local json = require("libs.json")
local utils = require("libs.utils")
local consts = require("libs.consts")
local compression = require("compression")
local ui = require("ui")
local net = require("net")
--local discord = require("libs.discord")

local corepath = sys.currentdir
local targetdir = nil
local box_chartname

--// Updater

local version_file = io.open(corepath.."/version","r")
if version_file then
    version = version_file:read("a")
    version_file:close()

    pcall(coroutine.wrap(function()
        net.Http("https://raw.githubusercontent.com"):get("/taypexx/chart_manager/main/version").after = function (client, response)
            local available_version
            if response.status ~= 200 then
                available_version = "v1.0.1"
            else
                available_version = response.content
            end
            available_version = string.sub(available_version,2)
            local ver = string.sub(version,2)

            local avail_v,current_v = "",""
            for number in string.gmatch(available_version,"%d+") do
                avail_v = avail_v..number
            end
            for number in string.gmatch(ver,"%d+") do
                current_v = current_v..number
            end
            
            if tonumber(avail_v) > tonumber(current_v) then
                local result = ui.confirm(string.format("New version of the program is available (v%s). Would you like to download it?",available_version),"New version available")
                if result == "yes" then
                    sys.cmd([[explorer "%sreleases/"]],consts.github)
                end
            end
        end
    end))
end

--// Loading settings

local settings_file = io.open(corepath.."/settings.json","r")
local settings
if settings_file then
    settings = json.parse(settings_file:read("a"))
    if not settings or settings == {} then
        settings = {
            music_offset = "",
            bms_editor = "",
        }
    end
    settings_file:close()
end

local function saveSettings()
    settings_file = io.open(corepath.."/settings.json","w")
    if settings_file then
        settings_file:write(json.stringify(settings) or {})
        settings_file:close()
        print("Saved settings")
    else print("Couldn't save settings!") end
end

local function prompt_musedash_program()
    local selected_path = ui.opendialog("Select MuseDash.exe",false,"Executable file (*.exe)|*.exe").fullpath or ""
    settings.muse_dash = selected_path
    return selected_path
end

--// Muse Dash autodetect path
if not settings.muse_dash or settings.muse_dash == "" then
    local default_md_path = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Muse Dash\\MuseDash.exe"
    local md_exe = sys.File(default_md_path)
    if md_exe then
        local response = ui.confirm("We found a Muse Dash path on your computer at:\n"..default_md_path.."\nIs that a correct path?","MuseDash.exe found")
        if response == "yes" then
            settings.muse_dash = default_md_path
        elseif response == "no" then
            prompt_musedash_program()
        end
    end 
end

--// Window configuration

local win = ui.Window("Chart Manager "..version, "single", 1000, 745)
win:loadicon(corepath.."/icon.ico")
win.bgcolor = consts.bgcolor
win.font = consts.font
win.fontstyle = {["bold"] = true}
win:center()
win:status("> Idle")

function win:onClose()
    saveSettings()
    --discord.shutdownRPC()
end

--// Window menu

local win_menu = ui.Menu("Exit")
win.menu = win_menu

local function select_BMS_programm()
    local editor = ui.opendialog("Select BMS editor program",false,"Executable file (*.exe)|*.exe")
    if not editor then return end
    settings.bms_editor = editor.fullpath
    saveSettings()
    return true
end

local function select_offset_programm()
    local editor = ui.opendialog("Select offset editor program",false,"Executable files (*.exe)|*.exe")
    if not editor then return end
    settings.music_offset = editor.fullpath
    saveSettings()
    return true
end

local function offset_track(item)
    if not targetdir then
        ui.error("You need to select chart folder!","Failed to offset")
        return
    end

    if settings.music_offset == "" or not settings.music_offset then
        local result = ui.confirm("You didn't select a program for music offsetting. Would you like to do it?","No offset program found")
        if result == "yes" then
            local selected = select_offset_programm()
            if not selected then return end
        else return end
    end

    local track_name = item.text--string.sub(item.text,8)
    local track_path = string.format("%s/%s.ogg",targetdir,track_name)
    local track = io.open(track_path,"r")
    if not track then
        track_path = string.format("%s/%s.mp3",targetdir,track_name)
        track = io.open(track_path,"r")
    end
    if not track then
        ui.error(string.format("No %s file was found in chart folder!",track_name),"Failed to offset")
        return
    end
    track:close()

    local launch_cmd = string.format('""%s" "%s"',settings.music_offset,track_path)
    coroutine.wrap(function ()
        win:status("> Offsetting "..track_name.."...")
        --discord.setState("offset",track_name)
        sys.cmd(launch_cmd)
        win:status("> Idle")
        --discord.setState("create")
    end)()
end

--// Icons preload
local melon_icon = sys.File(corepath.."/assets/ico/melon.ico")
local offset_icon = sys.File(corepath.."/assets/ico/offset.ico")
local bms_icon = sys.File(corepath.."/assets/ico/bms.ico")
local discord_icon = sys.File(corepath.."/assets/ico/discord.ico")
local file_icon = sys.File(corepath.."/assets/ico/file.ico")
local help_icon = sys.File(corepath.."/assets/ico/help.ico")
local music_icon = sys.File(corepath.."/assets/ico/music.ico")
local photo_icon = sys.File(corepath.."/assets/ico/photo.ico")
local github_icon = sys.File(corepath.."/assets/ico/github.ico")
local md_icon = sys.File(corepath.."/assets/ico/md.ico")

---------------------------------------

local mdmc_menu = ui.Menu()
local mdmc_buttons = {mdmc_menu:insert(1,"Home"),mdmc_menu:insert(2,"Upload"),mdmc_menu:insert(3,"Charts"),mdmc_menu:insert(4,"Find Current Chart"),mdmc_menu:insert(5,"Discord")}

local function mdmc_menu_func(item)
    if item.text == "Home" then
        sys.cmd([[explorer "https://mdmc.moe/"]])
    elseif item.text == "Upload" then
        sys.cmd([[explorer "https://mdmc.moe/upload"]])
    elseif item.text == "Charts" then
        sys.cmd([[explorer "https://mdmc.moe/charts"]])
    elseif item.text == "Find Current Chart" then
        if box_chartname.text ~= "" then
            sys.cmd(string.format([[explorer "https://mdmc.moe/charts?search=%s"]],box_chartname.text)) 
        else
            ui.error("Current chart name is empty","Failed to find")
        end
    elseif item.text == "Discord" then
        sys.cmd([[explorer "https://discord.gg/mdmc"]])
    end
end

for _,button in pairs(mdmc_buttons) do
    button.onClick = mdmc_menu_func
    if button.text == "Discord" then
        button:loadicon(discord_icon)
    else
        button:loadicon(melon_icon)
    end
end

win.menu:insert(1, "MDMC", mdmc_menu)

---------------------------------------

local file_open_menu = ui.Menu()
local file_open_buttons = {file_open_menu:insert(1,"info"),file_open_menu:insert(2,"cover")}

local function file_open_menu_func(item)
    if not targetdir then
        ui.error("You need to select chart folder!","Failed to open")
        return
    end
    if item.text == "info" then
        coroutine.wrap(function (...)
            win:status("> Viewing info.json...")
            sys.cmd(string.format([["%s"]],targetdir.."\\info.json"))
            win:status("> Idle")
        end)()
    elseif item.text == "cover" then
        local filename = "cover.png"
        local f = io.open(targetdir.."\\"..filename,"r")
        if not f then
            filename = "cover.gif"
        else
            f:close()
        end
        coroutine.wrap(function (...)
            win:status(string.format("> Viewing %s...",filename))
            sys.cmd(string.format([["%s"]],targetdir.."\\"..filename))
            win:status("> Idle")
        end)()
    end
end

for _,button in pairs(file_open_buttons) do
    if button.text == "info" then
        button.onClick = file_open_menu_func
        button:loadicon(file_icon)
    elseif button.text == "cover" then
        button.onClick = file_open_menu_func
        button:loadicon(photo_icon)
    end
end

win.menu:insert(2, "Open", file_open_menu)

---------------------------------------

local offset_edit_menu = ui.Menu()
local offset_edit_buttons = {offset_edit_menu:insert(1,"demo"),offset_edit_menu:insert(2,"music")}

for _,button in pairs(offset_edit_buttons) do
    button.onClick = offset_track
    button:loadicon(music_icon)
end

win.menu:insert(3, "Offset", offset_edit_menu)

---------------------------------------

local bms_edit_menu = ui.Menu()
local bms_edit_buttons = {bms_edit_menu:insert(1,"map1"),bms_edit_menu:insert(2,"map2"),bms_edit_menu:insert(3,"map3"),bms_edit_menu:insert(4,"map4")}

local function bms_edit_menu_func(item)
    if not targetdir then
        ui.error("You need to select chart folder!","Failed to edit")
        return
    end

    if settings.bms_editor == "" or not settings.bms_editor then
        local result = ui.confirm("You didn't select BMS editor program. Would you like to do it?","No BMS editor found")
        if result == "yes" then
            local selected = select_BMS_programm()
            if not selected then return end
        else return end
    end

    local map_name = item.text
    local map_path = targetdir.."\\"..map_name..".bms"
    local map_file = io.open(map_path,"r")
    if not map_file then
        ui.error(string.format("No %s file was found in chart folder!",map_name),"Failed to edit")
        return
    end
    map_file:close()

    local launch_cmd = string.format('""%s" "%s"',settings.bms_editor,map_path)
    coroutine.wrap(function ()
        win:status("> Editing "..map_name.."...")
        --discord.setState("bms",map_name)
        sys.cmd(launch_cmd)
        win:status("> Idle")
        --discord.setState("create")
    end)()
end

for _,button in pairs(bms_edit_buttons) do
    button.onClick = bms_edit_menu_func
    button:loadicon(bms_icon)
end

win.menu:insert(4, "Edit BMS", bms_edit_menu)

---------------------------------------

local program_select_menu = ui.Menu()
local program_select_buttons = {program_select_menu:insert(1,"BMS"),program_select_menu:insert(2,"Offset"),program_select_menu:insert(3,"Muse Dash")}

for _,button in pairs(program_select_buttons) do
    if button.text == "BMS" then
        button.onClick = select_BMS_programm
        button:loadicon(bms_icon) 
    elseif button.text == "Offset" then
        button.onClick = select_offset_programm
        button:loadicon(offset_icon)
    elseif button.text == "Muse Dash" then
        button.onClick = prompt_musedash_program
        button:loadicon(md_icon)
    end
end

win.menu:insert(5, "Select Programs",program_select_menu)

---------------------------------------

local help_docs = {
    [1] = {"Muse Dash Charting Tips",""},
    [2] = {"Understanding Muse Dash Chart Structure",""},
    [3] = {"Offsetting Charts With Adobe Audition (AU)",""}, 
    [4] = {"Quick MDBMSC Setup Guide","https://docs.google.com/document/d/1wYgaUv_sX6IxUv-KjiRRv68Jg82xH0GG21ySRs8zigk/preview"},
    [5] = {"Github",consts.github}
}

local help_docs_menu = ui.Menu()
local help_docs_buttons = {}

for i,t in ipairs(help_docs) do
    table.insert(help_docs_buttons,help_docs_menu:insert(i,t[1]))
end

local function help_doc_open(item)
    local doc_dir
    for _,t in pairs(help_docs) do
        if t[1] == item.text then
            doc_dir = t[2]
        end
    end
    if not doc_dir then return end
    coroutine.wrap(function ()
        if doc_dir == "" then
            sys.cmd(string.format('""%s" "%s"',"explorer",corepath.."\\assets\\"..item.text..".pdf"))
        else
            sys.cmd(string.format([[explorer "%s"]],doc_dir))
        end
    end)()
end

for _,button in pairs(help_docs_buttons) do
    button.onClick = help_doc_open
    if button.text == "Github" then
        button:loadicon(github_icon) 
    else
        button:loadicon(help_icon) 
    end
end

win.menu:insert(6, "Help", help_docs_menu)

---------------------------------------

win.menu.items[7].onClick = function ()
    sys.exit()
end

--// UI

local selectedFiles = {}

local bg = ui.Picture(win,corepath.."/assets/bg.png",0,0)
local bg_ratio = (bg.width/bg.height)
local bg_width,bg_height
if win.width < win.height then
    bg_width = win.width
    bg_height = bg_width/bg_ratio
else
    bg_height = win.height
    bg_width = bg_height*bg_ratio
end
bg.width = bg_width
bg.height = bg_height
bg:center()

local load_button = ui.Button(win, "Generate chart files", 25,650,150,35)
local pack_button = ui.Button(win, "Pack files to MDM", 200,650,150,35)
local mdm_load_button = ui.Button(win, "Load MDM to Muse Dash", 375,650,150,35)
bg:toback(load_button)
bg:toback(pack_button)
bg:toback(mdm_load_button)

local title_chartname = ui.Label(win,"Name",25,25,175,35)
title_chartname.fontsize = 18
title_chartname.fgcolor = 0xFFFFFF
bg:toback(title_chartname)
box_chartname = ui.Entry(win,"",250,25,225,35)
box_chartname.tooltip = "Name of your chart"
box_chartname.fontsize = 12
box_chartname.fontstyle = {["bold"] = false}
bg:toback(box_chartname)

local title_chartname_rom = ui.Label(win,"Name romanized",25,80,175,35)
title_chartname_rom.fontsize = 14
title_chartname_rom.fgcolor = 0xFFFFFF
bg:toback(title_chartname_rom)
local box_chartname_rom = ui.Entry(win,"",250,75,225,35)
box_chartname_rom.tooltip = "Name of your chart(romanized)"
box_chartname_rom.fontsize = 12
box_chartname_rom.fontstyle = {["bold"] = false}
bg:toback(box_chartname_rom)

local title_artist = ui.Label(win,"Artist",25,125,175,35)
title_artist.fontsize = 18
title_artist.fgcolor = 0xFFFFFF
bg:toback(title_artist)
local box_artist = ui.Entry(win,"",250,125,225,35)
box_artist.tooltip = "Artist"
box_artist.fontsize = 12
box_artist.fontstyle = {["bold"] = false}
bg:toback(box_artist)

local title_charter = ui.Label(win,"Charter",25,175,175,35)
title_charter.fontsize = 18
title_charter.fgcolor = 0xFFFFFF
bg:toback(title_charter)
local box_charter = ui.Entry(win,"",250,175,225,35)
box_charter.tooltip = "Author of the chart"
box_charter.fontsize = 12
box_charter.fontstyle = {["bold"] = false}
bg:toback(box_charter)

local title_scene = ui.Label(win,"Scene",25,225,175,35)
title_scene.fontsize = 18
title_scene.fgcolor = 0xFFFFFF
bg:toback(title_scene)
local list_scene = ui.Combobox(win,{"scene_01 (Space Station)","scene_02 (Retrocity)","scene_03 (Castle)","scene_04 (Rainy Night)","scene_05 (Candyland)","scene_06 (Oriental)","scene_07 (Let's Groove)","scene_08 (Touhou)","scene_09 (DJMAX)"},
250,225,225,400)
list_scene.fontsize = 14
list_scene.fontstyle = {["bold"] = false}
list_scene.text = "scene_01 (Space Station)"
bg:toback(list_scene)

local title_bpm = ui.Label(win,"BPM",25,275,175,35)
title_bpm.fontsize = 18
title_bpm.fgcolor = 0xFFFFFF
bg:toback(title_bpm)
local box_bpm = ui.Entry(win,"100",250,275,225,35)
box_bpm.tooltip = "BPM of the song"
box_bpm.fontsize = 18
box_bpm.fontstyle = {["bold"] = false}
bg:toback(box_bpm)

local title_diff = ui.Label(win,"Difficulty",25,325,175,35)
title_diff.fontsize = 18
title_diff.fgcolor = 0xFFFFFF
bg:toback(title_diff)
local box_diff = ui.Entry(win,"?",250,325,225,35)
box_diff.tooltip = "Difficulty of the chart"
box_diff.fontsize = 18
box_diff.fontstyle = {["bold"] = false}
bg:toback(box_diff)

local title_notespeed = ui.Label(win,"Note Speed",25,375,175,35)
title_notespeed.fontsize = 18
title_notespeed.fgcolor = 0xFFFFFF
bg:toback(title_notespeed)
local list_notespeed = ui.Combobox(win,{"Speed 1","Speed 2","Speed 3"},
250,375,225,150)
list_notespeed.fontsize = 16
list_notespeed.fontstyle = {["bold"] = false}
list_notespeed.text = "Speed 3"
bg:toback(list_notespeed)

local title_demo = ui.Label(win,"Demo",525,25,175,35)
title_demo.fontsize = 18
title_demo.fgcolor = 0xFFFFFF
bg:toback(title_demo)
local choose_demo = ui.Button(win,"Click to choose demo",750,25,225,35)
choose_demo.fontsize = 10
bg:toback(choose_demo)

function choose_demo:onClick()
    selectedFiles.demo = ui.opendialog("Select a Demo music file", false, "MP3 or OGG music|*.mp3;*.ogg")
    if selectedFiles.demo then
        choose_demo.text = selectedFiles.demo.name
        choose_demo.fontsize = 7
    end
end

local title_music = ui.Label(win,"Music",525,75,175,35)
title_music.fontsize = 18
title_music.fgcolor = 0xFFFFFF
bg:toback(title_music)
local choose_music = ui.Button(win,"Click to choose music",750,75,225,35)
choose_music.fontsize = 10
bg:toback(choose_music)

function choose_music:onClick()
    selectedFiles.music = ui.opendialog("Select the main music file", false, "MP3 or OGG music|*.mp3;*.ogg")
    if selectedFiles.music then
        choose_music.text = selectedFiles.music.name
        choose_music.fontsize = 7
    end
end

local title_cover = ui.Label(win,"Cover Image",525,125,175,35)
title_cover.fontsize = 18
title_cover.fgcolor = 0xFFFFFF
bg:toback(title_cover)
local choose_cover = ui.Button(win,"Click to choose an image",750,125,225,35)
choose_cover.fontsize = 10
bg:toback(choose_cover)

function choose_cover:onClick()
    selectedFiles.cover = ui.opendialog("Select a Cover image file", false, "PNG or GIF image|*.png;*.gif")
    if selectedFiles.cover then
        choose_cover.text = selectedFiles.cover.name
        choose_cover.fontsize = 7
    end
end

local title_video = ui.Label(win,"Video (optional)",525,175,175,35)
title_video.fontsize = 18
title_video.fgcolor = 0xFFFFFF
bg:toback(title_video)
local choose_video = ui.Button(win,"Click to choose video",750,175,225,35)
choose_video.fontsize = 10
bg:toback(choose_video)

function choose_video:onClick()
    selectedFiles.video = ui.opendialog("Select the cinema video file", false, "MP4 video|*.mp4")
    if selectedFiles.video then
        choose_video.text = selectedFiles.video.name
        choose_video.fontsize = 7
    end
end

local title_video_opacity = ui.Label(win,"Video Opacity",525,225,175,35)
title_video_opacity.fontsize = 18
title_video_opacity.fgcolor = 0xFFFFFF
bg:toback(title_video_opacity)
local box_video_opacity = ui.Entry(win,"0.5",750,225,225,35)
box_video_opacity.fontsize = 18
box_video_opacity.fontstyle = {["bold"] = false}
bg:toback(box_video_opacity)

local title_gen_bms1 = ui.Label(win,"map1.bms",525,425,175,35)
title_gen_bms1.fontsize = 18
title_gen_bms1.fgcolor = 0xFFFFFF
bg:toback(title_gen_bms1)

local check_map1 = ui.Combobox(win,{"Yes","No"},750,425,75,100)
check_map1.text = "No"
check_map1.fontsize = 14
check_map1.fontstyle = {["bold"] = false}
check_map1.fgcolor = 0xFFFFFF
bg:toback(check_map1)

local title_gen_bms3 = ui.Label(win,"map3.bms",525,475,175,35)
title_gen_bms3.fontsize = 18
title_gen_bms3.fgcolor = 0xFFFFFF
bg:toback(title_gen_bms3)

local check_map3 = ui.Combobox(win,{"Yes","No"},750,475,75,100)
check_map3.text = "No"
check_map3.fontsize = 14
check_map3.fontstyle = {["bold"] = false}
check_map3.fgcolor = 0xFFFFFF
bg:toback(check_map3)

local title_gen_bms4 = ui.Label(win,"map4.bms",525,525,175,35)
title_gen_bms4.fontsize = 18
title_gen_bms4.fgcolor = 0xFFFFFF
bg:toback(title_gen_bms4)

local check_map4 = ui.Combobox(win,{"Yes","No"},750,525,75,100)
check_map4.text = "No"
check_map4.fontsize = 14
check_map4.fontstyle = {["bold"] = false}
check_map4.fgcolor = 0xFFFFFF
bg:toback(check_map4)

local title_map1_diff = ui.Label(win,"Diff:",835,425,50,35)
title_map1_diff.fontsize = 18
title_map1_diff.fgcolor = 0xFFFFFF
bg:toback(title_map1_diff)

local box_map1_diff = ui.Entry(win,"0",915,425,50,35)
box_map1_diff.fontsize = 18
box_map1_diff.fgcolor = 0xFFFFFF
box_map1_diff.fontstyle = {["bold"] = false}
bg:toback(box_map1_diff)

local title_map3_diff = ui.Label(win,"Diff:",835,475,50,35)
title_map3_diff.fontsize = 18
title_map3_diff.fgcolor = 0xFFFFFF
bg:toback(title_map3_diff)

local box_map3_diff = ui.Entry(win,"0",915,475,50,35)
box_map3_diff.fontsize = 18
box_map3_diff.fgcolor = 0xFFFFFF
box_map3_diff.fontstyle = {["bold"] = false}
bg:toback(box_map3_diff)

local title_map4_diff = ui.Label(win,"Diff:",835,525,50,35)
title_map4_diff.fontsize = 18
title_map4_diff.fgcolor = 0xFFFFFF
bg:toback(title_map4_diff)

local box_map4_diff = ui.Entry(win,"0",915,525,50,35)
box_map4_diff.fontsize = 18
box_map4_diff.fgcolor = 0xFFFFFF
box_map4_diff.fontstyle = {["bold"] = false}
bg:toback(box_map4_diff)

local title_secret_msg = ui.Label(win,"hideBmsMessage",525,325,175,35)
title_secret_msg.fontsize = 18
title_secret_msg.fgcolor = 0xFFFFFF
bg:toback(title_secret_msg)

local box_secret_msg = ui.Entry(win,"",750,325,225,35)
box_secret_msg.tooltip = "Hidden message for map4"
box_secret_msg.fontsize = 18
box_secret_msg.fontstyle = {["bold"] = false}
bg:toback(box_secret_msg)

local title_hide_mode = ui.Label(win,"hideBmsMode",525,275,175,35)
title_hide_mode.fontsize = 18
title_hide_mode.fgcolor = 0xFFFFFF
bg:toback(title_hide_mode)

local list_hide_mode = ui.Combobox(win,{"CLICK","PRESS","TOGGLE"},750,275,225,200)
list_hide_mode.tooltip = "Type for accessing map4"
list_hide_mode.fontsize = 18
list_hide_mode.fontstyle = {["bold"] = false}
list_hide_mode.text = "CLICK"
bg:toback(list_hide_mode)

local credits = ui.Label(win,"Program made by @taypexx",800,685,175,25)
credits.tooltip = "Feel free to contact me in discord! =3"
credits.fontsize = 8
credits.fgcolor = 0x6e6e6e
credits.bgcolor = 0x292929
bg:toback(credits)

local title_dir = ui.Label(win,"Chart folder",25,600,175,35)
title_dir.fontsize = 18
title_dir.fgcolor = 0xFFFFFF

bg:toback(title_dir)
local choose_dir = ui.Button(win,"Click to browse directory",250,600,225,35)
choose_dir.fontsize = 10
bg:toback(choose_dir)

--// Fields managing

local default_button_size = {x=225,y=35}
local function clearFields()
    selectedFiles = {}
    box_chartname.text = ""
    box_chartname_rom.text = ""
    box_artist.text = ""
    box_bpm.text = "100"
    box_charter.text = ""
    list_scene.selected = list_scene.items[1]
    box_diff.text = "?"
    box_map1_diff.text = "0"
    box_map3_diff.text = "0"
    box_map4_diff.text = "0"
    box_video_opacity.text = "0.5"
    list_hide_mode.text = "CLICK"
    box_secret_msg.text = ""
    list_notespeed.selected = list_notespeed.items[3]
    check_map1.text = "No"
    check_map3.text = "No"
    check_map4.text = "No"
    load_button.enabled = true
    choose_demo.text = "Click to choose demo"
    choose_music.text = "Click to choose music"
    choose_cover.text = "Click to choose an image"
    choose_video.text = "Click to choose video"
    choose_demo.enabled = true
    choose_music.enabled = true
    choose_cover.enabled = true
    choose_video.enabled = true
    choose_demo.width = default_button_size.x
    choose_demo.height = default_button_size.y
    choose_music.width = default_button_size.x
    choose_music.height = default_button_size.y
    choose_cover.width = default_button_size.x
    choose_cover.height = default_button_size.y
    choose_video.width = default_button_size.x
    choose_video.height = default_button_size.y
    choose_demo.fontsize = 10
    choose_music.fontsize = 10
    choose_cover.fontsize = 10
    choose_video.fontsize = 10
end

clearFields()

local function autofill_fields()

    if box_chartname.text ~= "" then
        if ui.confirm("Erase all fields?","Erase") == "yes" then
            clearFields()
        end
    else clearFields() end

    local info_file = io.open(targetdir.."/info.json","r")
    if not info_file then return end
    local chart_info = info_file:read("a")
    info_file:close()
    if not chart_info then return end
    success,chart_info = pcall(json.parse,chart_info)
    if not success then print(chart_info) return end
    if not chart_info then return end

    local bms_main = io.open(targetdir.."/map2.bms","r")
    if not bms_main then return end
    local bms_info = bms_main:read("a")
    bms_main:close()
    if not bms_info then return end
    
    box_chartname.text = chart_info.name or ""
    box_chartname_rom.text = chart_info.name_romanized or ""
    box_artist.text = chart_info.author or ""
    box_bpm.text = chart_info.bpm or "100"
    box_charter.text = chart_info.levelDesigner or ""
    list_scene.selected = list_scene.items[tonumber(string.sub(chart_info.scene,7)) or 1]
    box_diff.text = chart_info.difficulty2 or "?"
    box_map1_diff.text = chart_info.difficulty1 or "0"
    box_map3_diff.text = chart_info.difficulty3 or "0"
    box_map4_diff.text = chart_info.difficulty4 or "0"
    list_hide_mode.text = chart_info.hideBmsMode or "CLICK"
    box_secret_msg.text = chart_info.hideBmsMessage or ""

    local chart_notespeed = string.sub(utils.split(bms_info,"#")[2],8)
    list_notespeed.selected = list_notespeed.items[tonumber(chart_notespeed) or 3]

    choose_demo.text = "-"
    choose_music.text = "-"
    choose_cover.text = "-"
    choose_video.text = "-"
    choose_demo.enabled = false
    choose_music.enabled = false
    choose_cover.enabled = false
    choose_video.enabled = false

    if box_map1_diff.text ~= "0" then
        check_map1.text = "Yes"
    else
        check_map1.text = "No"
    end
    if box_map3_diff.text ~= "0" then
        check_map3.text = "Yes"
    else
        check_map3.text = "No"
    end
    if box_map4_diff.text ~= "0" then
        check_map4.text = "Yes"
    else
        check_map4.text = "No"
    end

    local cinema_file = io.open(targetdir.."/cinema.json","r")
    if cinema_file then
        local cinema_info = cinema_file:read("a")
        cinema_file:close()
        if cinema_info then
            success,cinema_info = pcall(json.parse,cinema_info)
            if success and cinema_info then
                local opacity = utils.split(tostring(cinema_info.opacity),",")
                box_video_opacity.text = opacity[1].."."..opacity[2]
            end
        end
    end

    load_button.enabled = false
end

function choose_dir:onClick()
    local dir = ui.dirdialog("Select chart folder")
    if dir then
        targetdir = dir.fullpath
        choose_dir.fontsize = 6
        choose_dir.text = targetdir
        autofill_fields()
    end
end

---------------------------------------

--// Main functions

local forbidden_chars = {"{","}",'"'}

local function check_for_chars(str)
    for _,char in pairs(forbidden_chars) do
        if string.find(str,char) then
            return false,char
        end
    end
    return true
end

function generate_chart()
    --// Generate chart files

    if not targetdir then
        return false,"You need to select chart folder!"
    end
    if not selectedFiles.cover then
        return false,"You need to pick a cover image!"
    end
    if not selectedFiles.demo then
        return false,"You need to pick the demo audio!"
    end
    if not selectedFiles.music then
        return false,"You need to pick the music audio!"
    end

    win:status("> Checking for foridden characters in info.json...")

    local info_format = {
        box_chartname.text,
        box_chartname_rom.text,
        box_artist.text,
        box_bpm.text,
        string.sub(list_scene.text,1,8),
        box_charter.text,
        box_charter.text,
        box_charter.text,
        box_charter.text,
        box_charter.text,
        box_map1_diff.text,
        box_diff.text,
        box_map3_diff.text,
        box_map4_diff.text,
        list_hide_mode.text,
        box_secret_msg.text
    }

    for _,formatstr in pairs(info_format) do
        local allowed,char = check_for_chars(formatstr)
        if not allowed then
            return false,'Character '..char..' is not allowed.'
        end
    end

    win:status("> Loading selected files...")

    local cover = selectedFiles.cover:copy("TEMPCOVER"..selectedFiles.cover.extension)
    cover:move(targetdir.."/cover"..selectedFiles.cover.extension)

    local demo = selectedFiles.demo:copy("TEMPDEMO"..selectedFiles.demo.extension)
    demo:move(targetdir.."/demo"..selectedFiles.demo.extension)

    local music = selectedFiles.music:copy("TEMPMUSIC"..selectedFiles.music.extension)
    music:move(targetdir.."/music"..selectedFiles.music.extension)
    
    local video
    if selectedFiles.video then

        win:status("> Loading cinema files...")

        video = selectedFiles.video:copy("TEMPVIDEO"..selectedFiles.video.extension)
        video:move(targetdir.."/video"..selectedFiles.video.extension)

        local video_opacity = tonumber(box_video_opacity.text)
        if not video_opacity then
            box_video_opacity.text = "0.5"
        end

        local cinemaTemplate = sys.File(targetdir.."/cinema.json")
        cinemaTemplate:open("write")
        cinemaTemplate:write(string.format([[{"file_name": "video.mp4","opacity": %s}]],box_video_opacity.text))
        cinemaTemplate:close()
    end

    os.execute('copy "'..corepath..'/template" "'..targetdir..'"')

    local infoFile = io.open(targetdir.."/info.json","r")
    if not infoFile then
        return false,"Couldn't find info.json!"
    end
    local info = infoFile:read("a")
    infoFile:close()
    if not info then
        return false,"Couldn't read info.json!"
    end

    win:status("> Loading template files...")

    info = string.format(info,table.unpack(info_format))

    infoFile = io.open(targetdir.."/info.json","w")
    if not infoFile then
        return false,"Couldn't find info.json!"
    end
    infoFile:write(info)
    infoFile:close()

    win:status("> Loading BMS files...")

    local bms2File = io.open(targetdir.."/map2.bms","r")
    if not bms2File then
        return false,"Couldn't find map2.bms!"
    end
    local bmsTemplate = bms2File:read("a")
    bms2File:close()
    if not bmsTemplate then
        return false,"Couldn't read bms template file!"
    end
    
    local bms2 = string.format(bmsTemplate,
        string.sub(list_notespeed.text,7),
        string.sub(list_scene.text,1,8),
        box_chartname.text,
        box_artist.text,
        box_charter.text,
        box_bpm.text,
        box_diff.text,
        "2"
    )

    bms2File = io.open(targetdir.."/map2.bms","w")
    if not bms2File then
        return false,"Couldn't find map2.bms!"
    end
    bms2File:write(bms2)
    bms2File:close()

    --// Bonus bms maps

    if check_map1.text == "Yes" then
        local bms1 = string.format(bmsTemplate,
            string.sub(list_notespeed.text,7),
            string.sub(list_scene.text,1,8),
            box_chartname.text,
            box_artist.text,
            box_charter.text,
            box_bpm.text,
            box_map1_diff.text,
            "1"
        )

        local bms1File = sys.File(targetdir.."/map1.bms")
        bms1File:open("write")
        bms1File:write(bms1)
        bms1File:close()
    end

    if check_map3.text == "Yes" then
        local bms3 = string.format(bmsTemplate,
            string.sub(list_notespeed.text,7),
            string.sub(list_scene.text,1,8),
            box_chartname.text,
            box_artist.text,
            box_charter.text,
            box_bpm.text,
            box_map3_diff.text,
            "3"
        )

        local bms3File = sys.File(targetdir.."/map3.bms")
        bms3File:open("write")
        bms3File:write(bms3)
        bms3File:close()
    end

    if check_map4.text == "Yes" then
        local bms4 = string.format(bmsTemplate,
            string.sub(list_notespeed.text,7),
            string.sub(list_scene.text,1,8),
            box_chartname.text,
            box_artist.text,
            box_charter.text,
            box_bpm.text,
            box_map4_diff.text,
            "3" -- not a typo!!!
        )

        local bms4File = sys.File(targetdir.."/map4.bms")
        bms4File:open("write")
        bms4File:write(bms4)
        bms4File:close()
    end

    return true,"Successfully generated chart files!"
end

---------------------------------------

function chart_pack()
    --// Packing

    if not targetdir then
        return false,"You need to select chart folder!"
    end

    win:status("> Checking required files...")

    local filestotal = {}
    local cover1 = io.open(targetdir.."/cover.png","r")
    local cover2 = io.open(targetdir.."/cover.gif","r")
    if not (cover1 or cover2) then return false,"You need a cover image to generate MDM chart." end
    if cover1 then
        filestotal.cover = "png"
        cover1:close()
    end
    if cover2 then
        filestotal.cover = "gif"
        cover2:close()
    end

    local infoFile = io.open(targetdir.."/info.json","r")
    if not infoFile then return false,"You need an info.json file to generate MDM chart." end

    local music1 = io.open(targetdir.."/music.mp3","r")
    local music2 = io.open(targetdir.."/music.ogg","r")
    if not (music1 or music2) then
        if music1 then
            music1:close()
        end
        if music2 then
            music2:close()
        end
        return false,"You need a music file to generate MDM chart."
    end
    if music1 then
        music1:close()
        filestotal.music = "mp3"
    end
    if music2 then
        music2:close()
        filestotal.music = "ogg"
    end

    local demo1 = io.open(targetdir.."/demo.mp3","r")
    local demo2 = io.open(targetdir.."/demo.ogg","r")
    if not (demo1 or demo2) then
        ui.warn("Missing demo file for chart.","Warning")
    end
    if demo1 then
        demo1:close()
        filestotal.demo = "mp3"
    end
    if demo2 then
        demo2:close()
        filestotal.demo = "ogg"
    end

    local map1 = io.open(targetdir.."/map1.bms","r")
    local map2 = io.open(targetdir.."/map2.bms","r")
    local map3 = io.open(targetdir.."/map3.bms","r")
    local map4 = io.open(targetdir.."/map4.bms","r")

    if not (map1 or map2 or map3 or map4) then
        if map1 then
            map1:close()
        end
        if map2 then
            map2:close()
        end
        if map3 then
            map3:close()
        end
        if map4 then
            map4:close()
        end
        return false,"You need at least 1 bms map to generate MDM chart."
    end
    filestotal.map = {}
    if map1 then
        map1:close()
        table.insert(filestotal.map,1)
    end
    if map2 then
        map2:close()
        table.insert(filestotal.map,2)
    end
    if map3 then
        map3:close()
        table.insert(filestotal.map,3)
    end
    if map4 then
        map4:close()
        table.insert(filestotal.map,4)
    end

    win:status("> Checking for cinema files...")

    --// Cinema files

    local cinema_main = io.open(targetdir.."/cinema.json")
    local cinema_video = io.open(targetdir.."/video.mp4")
    filestotal.cinema = (cinema_main~=nil)
    filestotal.video = (cinema_video~=nil)
    if cinema_main then
        cinema_main:close()
    end
    if cinema_video then
        cinema_video:close()
    end

    win:status("> Compressing into MDM...")
    
    local contents = infoFile:read("a")
    local info = json.decode(contents)
    if not info then return end
    infoFile:close()
    
    local chartname = info.name
    --chartname = chartname:gsub('%W','') -- removing all non alphanumeric characters

    local mdmname = chartname..".zip"
    sys.currentdir = targetdir
    local mdm = compression.Zip(mdmname,"write")
    mdm:write(targetdir.."/cover."..filestotal.cover)
    mdm:write(targetdir.."/info.json")
    mdm:write(targetdir.."/music."..filestotal.music)

    if filestotal.demo then
        mdm:write(targetdir.."/demo."..filestotal.demo)
    end
    if filestotal.cinema then
        mdm:write(targetdir.."/cinema.json")
    end
    if filestotal.video then
        mdm:write(targetdir.."/video.mp4")
    end

    for i,v in pairs(filestotal.map) do
        mdm:write(targetdir.."/map"..v..".bms")
    end

    mdm:close()
    sys.cmd(string.format([[ren "%s" "%s.mdm"]],mdmname,chartname))
    return true,"Successfully packed chart into MDM!"
end

local function check_for_mdm()
    local found_mdm
    for entry in each(sys.Directory(targetdir):list("*.*")) do
        local expected_chars = string.sub(entry.name,string.len(entry.name)-3)
        print(expected_chars)
        if string.lower(expected_chars) == ".mdm" then
            found_mdm = entry
            break
        end
    end
    return found_mdm
end

function mdm_load()
    --// Loading to Muse Dash

    if not targetdir then
        return false,"You need to select chart folder!"
    end

    if not settings.muse_dash or settings.muse_dash == "" then
        local response = ui.confirm("Muse Dash path wasn't selected. Do you want to do it right now?","No Muse Dash path")
        if response == "yes" then
            prompt_musedash_program()
        elseif response == "no" then
            return false,"You need Muse Dash path to save MDMs!"
        end
    end

    win:status("> Checking for MDM...")

    local has_mdm = check_for_mdm()
    if not has_mdm then
        local result = ui.confirm("There is no MDM file in the chart folder. Do you want to pack files?","No MDM found")
        if result == "yes" then
            local success,msg = chart_pack()
            if not success then return false,msg end
            ui.msg(msg,"Success")
            has_mdm = check_for_mdm()
            if not has_mdm then return false end
        else return false,"You have to pack files in order to save them" end
    end

    win:status("> Loading to Muse Dash charts path...")

    local split_path = utils.split(settings.muse_dash,"\\")
    local charts_path = string.reverse(string.sub(string.reverse(settings.muse_dash),string.len(split_path[#split_path])+1)).."Custom_Albums"
    
    has_mdm:move(charts_path.."/"..has_mdm.name)

    return true,"Successfully saved chart to Muse Dash!"
end

---------------------------------------

--// Bindings

function pack_button:onClick()
    local success,msg = chart_pack()
    msg = msg or "Unknown error occured"
    if success then
        win:status("> Done!")
        ui.msg(msg,"Success")
    else 
        win:status("> Failed to pack")
        ui.error(msg,"Failed to pack")
    end
    win:status("> Idle")
end

function load_button:onClick()
    local success,msg = generate_chart()
    msg = msg or "Unknown error occured"
    if success then
        load_button.enabled = false
        choose_demo.text = "-"
        choose_music.text = "-"
        choose_cover.text = "-"
        choose_video.text = "-"
        choose_demo.enabled = false
        choose_music.enabled = false
        choose_cover.enabled = false
        choose_video.enabled = false
        win:status("> Done!")
        ui.msg(msg,"Success")
    else 
        win:status("> Failed to generate")
        ui.error(msg,"Failed to generate")
    end
    win:status("> Idle")
end

function mdm_load_button:onClick()
    local success,msg = mdm_load()
    msg = msg or "Unknown error occured"
    if success then
        win:status("> Done!")
        ui.msg(msg,"Success")
    else 
        win:status("> Failed to load")
        ui.error(msg,"Failed to load")
    end
    win:status("> Idle")
end

ui.run(win)