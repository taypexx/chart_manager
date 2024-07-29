--// Libs
json = require("libs.json")
utils = require("libs.utils")
consts = require("libs.consts")
compression = require("compression")
ui = require("ui")
net = require("net")
--discord = require("libs.discord")

--// Modes
edit_mode = require("modes.edit_mode")
download_mode = require("modes.download_mode")
crop_mode = require("modes.crop_mode")

corepath = sys.currentdir
targetdir = nil
settings = nil
lang = nil

--// Loading settings

local settings_file = io.open(corepath.."/settings.json","r")
if settings_file then
    settings = json.parse(settings_file:read("a"))
    if not settings or settings == {} then
        settings = {
            music_offset = "",
            bms_editor = "",
            muse_dash = "",
            lang = ""
        }
    end
    settings_file:close()
end

function SaveSettings()
    if settings.muse_dash == "" and settings.bms_editor == "" and settings.music_offset == "" and settings.lang == "" then
        print("Skipped settings saving, fields are empty")
        return
    end
    settings_file = io.open(corepath.."/settings.json","w")
    if settings_file then
        settings_file:write(json.stringify(settings) or {})
        settings_file:close()
        print("Saved settings")
    else print("Couldn't save settings!") end
end

function SaveAndExit()
    clearTemp()
    SaveSettings()
    sys.exit()
end

--// Temporary files management

local tempdir = sys.Directory(corepath.."\\temp")
if not tempdir.exists then
    tempdir:make()
end

function clearTemp()
    for entry in each(tempdir) do
        local name = tostring(entry)
        if name then
            if string.sub(name,1,4) == "File" then
                entry:remove()
            elseif string.sub(name,1,9) == "Directory" then
                entry:removeall()
            end
        end
    end
end

--// Language selection
local languageCodes = {
    [1] = {English = "en"},
    [2] = {Spanish = "es"},
    [3] = {German = "de"},
    [4] = {Russian = "ru"},
    [5] = {Vientamese = "vi"},
}

function lang_prompt()
    local langwin = ui.Window("Language selection","fixed",300,500)
    langwin:loadicon(corepath.."/icon.ico")
    langwin:center()

    local langtitle = ui.Label(langwin,"Please select your language:",50,25,250,25)
    langtitle.fontsize = 12

    local langlist = ui.List(langwin,{},25,75,250,300)
    langlist.fontsize = 12

    for _,langTable in ipairs(languageCodes) do
        local k,_ = utils.firstElement(langTable)
        langlist:add(k)
    end

    local confirm = ui.Button(langwin,"Confirm",25,425,250,50)
    confirm.fontsize = 12

    local lang_changed = false
    confirm.onClick = function()
        if langlist.selected then
            settings.lang = utils.tableFindRecursive(languageCodes,langlist.selected.text)
            lang_changed = true
        elseif settings.lang == "" or not settings.lang then
            settings.lang = "en"
        end
        ui.remove(langwin)
    end

    ui.run(langwin):wait()

    return lang_changed
end

if settings.lang == "" or not settings.lang then
    lang_prompt()
end

if settings.lang == "" or not settings.lang then settings.lang = "en" end
lang = require("lang."..settings.lang)

--// Updater

local version_file = io.open(corepath.."/version","r")
if version_file then
    version = version_file:read("a")
    version_file:close()

    pcall(coroutine.wrap(function()
        net.Http("https://raw.githubusercontent.com"):get("/taypexx/chart_manager/main/version").after = function (client, response)
            if not response then return end
            
            local available_version
            if response.status ~= 200 then
                available_version = "v2.2.0"
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
                local result = ui.confirm(string.format(lang.new_version.desc,available_version),lang.new_version.title)
                if result == "yes" then
                    sys.cmd([[explorer "%sreleases/"]],consts.github)
                end
            end
        end
    end))
end

--// Muse Dash autodetect path

function prompt_musedash_program()
    local selected_path = ui.opendialog(lang.prompt_musedash.win.title,false,lang.prompt_musedash.win.filetype)
    if selected_path then
        selected_path = selected_path.fullpath
    else selected_path = "" end
    settings.muse_dash = selected_path
    return selected_path
end

if not settings.muse_dash or settings.muse_dash == "" then
    local default_md_path = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Muse Dash\\MuseDash.exe"
    local md_exe = sys.File(default_md_path)
    if md_exe then
        local response = ui.confirm(string.format(lang.prompt_musedash.popup.desc,default_md_path),lang.prompt_musedash.popup.title)
        if response == "yes" then
            settings.muse_dash = default_md_path
        elseif response == "no" then
            prompt_musedash_program()
        end
    end 
end

---------------------------------------

--// Icons preload
melon_icon = sys.File(corepath.."/assets/ico/melon.ico")
offset_icon = sys.File(corepath.."/assets/ico/offset.ico")
bms_icon = sys.File(corepath.."/assets/ico/bms.ico")
discord_icon = sys.File(corepath.."/assets/ico/discord.ico")
file_icon = sys.File(corepath.."/assets/ico/file.ico")
help_icon = sys.File(corepath.."/assets/ico/help.ico")
music_icon = sys.File(corepath.."/assets/ico/music.ico")
photo_icon = sys.File(corepath.."/assets/ico/photo.ico")
github_icon = sys.File(corepath.."/assets/ico/github.ico")
md_icon = sys.File(corepath.."/assets/ico/md.ico")
archive_icon = sys.File(corepath.."/assets/ico/archive.ico")
heart_icon = sys.File(corepath.."/assets/ico/heart.ico")
lang_icon = sys.File(corepath.."/assets/ico/lang.ico")

---------------------------------------

--// Start menu
start_win = ui.Window("Chart Manager "..version,"single",700,500)
start_win:loadicon(corepath.."/icon.ico")
start_win.bgcolor = consts.startbgcolor
start_win.font = consts.font
start_win.fontstyle = {["bold"] = true}
start_win:center()

local bg = ui.Picture(start_win,corepath.."/assets/welcome.png",0,0)
bg:center()

local help_button = ui.Button(start_win,lang.main.help,10,465)
help_button.fontsize = 11
help_button:loadicon(github_icon)
help_button.width = 90
help_button.height = 30
bg:toback(help_button)

help_button.onClick = function ()
    sys.cmd(string.format([[explorer "%s#chart_manager"]],consts.github))
end

local discord_button = ui.Button(start_win,lang.main.discord,110,465)
discord_button.fontsize = 11
discord_button:loadicon(discord_icon)
discord_button.width = 90
discord_button.height = 30
bg:toback(discord_button)

discord_button.onClick = function ()
    sys.cmd(string.format([[explorer "%s"]],consts.discord))
end

local mdmc_button = ui.Button(start_win,lang.main.mdmc,210,465)
mdmc_button.fontsize = 11
mdmc_button:loadicon(melon_icon)
mdmc_button.width = 90
mdmc_button.height = 30
bg:toback(mdmc_button)

mdmc_button.onClick = function ()
    sys.cmd([[explorer "https://mdmc.moe"]])
end

local credits_button = ui.Button(start_win,lang.welcome_win.credits,310,465)
credits_button.fontsize = 11
credits_button:loadicon(heart_icon)
credits_button.width = 90
credits_button.height = 30
bg:toback(credits_button)

credits_button.onClick = function ()
    local credits_win = ui.Window(lang.welcome_win.credits,"fixed",400,550)
    credits_win:loadicon(heart_icon)
    credits_win:center()

    local credits_bg = ui.Picture(credits_win,"assets/credits.png",0,0,credits_win.width,credits_win.height)
    ui.run(credits_win)
end

local lang_button = ui.Button(start_win,"Language",410,465)
lang_button.fontsize = 11
lang_button:loadicon(lang_icon)
lang_button.width = 90
lang_button.height = 30
bg:toback(lang_button)

lang_button.onClick = function ()
    if lang_prompt() then
        ui.msg("Please restart the program for the language to apply.","Restart")
        ui.remove(start_win) 
    end
end

local edit_button = ui.Button(start_win,lang.welcome_win.create_chart,25,350)
edit_button:loadicon(bms_icon)
edit_button.fontsize = 14
edit_button.width = 220
edit_button.height = 40
bg:toback(edit_button)
edit_button.onClick = function ()
    start_win.visible = false
    start_win.enabled = false
    edit_mode.run()
end

local crop_button = ui.Button(start_win,lang.welcome_win.crop_chart,250,350)
crop_button:loadicon(music_icon)
crop_button.fontsize = 14
crop_button.width = 200
crop_button.height = 40
bg:toback(crop_button)
crop_button.onClick = function ()
    start_win.visible = false
    start_win.enabled = false
    crop_mode.run()
end

local download_button = ui.Button(start_win,lang.welcome_win.coming_soon,455,350,200,50)
download_button:loadicon(md_icon)
download_button.fontsize = 14
download_button.width = 220
download_button.height = 40
download_button.enabled = false
bg:toback(download_button)
download_button.onClick = function ()
    start_win.visible = false
    start_win.enabled = false
    download_mode.run()
end

---------------------------------------

function chart_pack(win,progressbar)
    --// Packing

    if not targetdir then
        return false,lang.error_msgs.no_chart_folder
    end

    progressbar.range = {0,4}
    progressbar.position = 0
    progressbar:show()

    win:status(lang.status_bar.checking_req_files)

    local filestotal = {}
    local cover1 = io.open(targetdir.."/cover.png","r")
    local cover2 = io.open(targetdir.."/cover.gif","r")
    if not (cover1 or cover2) then return false,lang.error_msgs.generate_mdm.no_cover end
    if cover1 then
        filestotal.cover = "png"
        cover1:close()
    end
    if cover2 then
        filestotal.cover = "gif"
        cover2:close()
    end

    local infoFile = io.open(targetdir.."/info.json","r")
    if not infoFile then return false,lang.error_msgs.generate_mdm.no_info end

    local music1 = io.open(targetdir.."/music.mp3","r")
    local music2 = io.open(targetdir.."/music.ogg","r")
    if not (music1 or music2) then
        if music1 then
            music1:close()
        end
        if music2 then
            music2:close()
        end
        return false,lang.error_msgs.generate_mdm.no_music
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
        ui.warn(lang.error_msgs.generate_mdm.no_demo.desc,lang.error_msgs.generate_mdm.no_demo.title)
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
        return false,lang.error_msgs.generate_mdm.no_map
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

    progressbar:advance(1)
    win:status(lang.status_bar.checking_dialog_files)

    local map1_talk = io.open(targetdir.."/map1.talk","r")
    local map2_talk = io.open(targetdir.."/map2.talk","r")
    local map3_talk = io.open(targetdir.."/map3.talk","r")
    local map4_talk = io.open(targetdir.."/map4.talk","r")

    filestotal.map_talks = {}
    if map1_talk then
        map1_talk:close()
        table.insert(filestotal.map_talks,1)
    end
    if map2_talk then
        map2_talk:close()
        table.insert(filestotal.map_talks,2)
    end
    if map3_talk then
        map3_talk:close()
        table.insert(filestotal.map_talks,3)
    end
    if map4_talk then
        map4_talk:close()
        table.insert(filestotal.map_talks,4)
    end

    progressbar:advance(1)
    win:status(lang.status_bar.checking_cinema_files)

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

    progressbar:advance(1)
    win:status(lang.status_bar.compressing_mdm)
    
    local contents = infoFile:read("a")
    local info = json.decode(contents)
    if not info then return end
    infoFile:close()
    
    local chartname = utils.removeForbiddenWindowsCharacters(info.name)
    if not utils.checkForValidWindowsName(chartname) then
        chartname = chartname.."0"
    end
    local mdmname = chartname..".zip"
    sys.currentdir = targetdir
    local mdm
    local success,errmsg = pcall(function (...)
        mdm = compression.Zip(mdmname,"write")
    end)
    if not success then
        print(string.format("Incorrect name: %s: selecting other one",errmsg))
        chartname = chartname:gsub('%W','')
        mdmname = chartname..".zip"
        mdm = compression.Zip(mdmname,"write")
    end
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

    for _,v in pairs(filestotal.map) do
        mdm:write(targetdir.."/map"..v..".bms")
    end

    for _,v in pairs(filestotal.map_talks) do
        mdm:write(targetdir.."/map"..v..".talk")
    end

    mdm:close()
    sys.cmd(string.format([[ren "%s" "%s.mdm"]],mdmname,chartname))

    progressbar:advance(1)
    
    return true,lang.info_msgs.chart_pack_success
end

function check_for_mdm()
    local found_mdm
    for entry in each(sys.Directory(targetdir):list("*.*")) do
        local expected_chars = string.sub(entry.name,string.len(entry.name)-3)
        if string.lower(expected_chars) == ".mdm" then
            found_mdm = entry
            break
        end
    end
    return found_mdm
end

function mdm_load(win,progressbar)
    --// Loading to Muse Dash

    if not targetdir then
        return false,lang.error_msgs.no_chart_folder
    end

    if not settings.muse_dash or settings.muse_dash == "" then
        local response = ui.confirm(lang.info_msgs.no_musedash_path.desc,lang.info_msgs.no_musedash_path.title)
        if response == "yes" then
            prompt_musedash_program()
        elseif response == "no" then
            return false,lang.error_msgs.load_mdm.no_musedash_path
        end
    end

    progressbar.range = {0,3}
    progressbar.position = 0
    progressbar:show()

    win:status(lang.status_bar.checking_mdm)

    local has_mdm = check_for_mdm()
    if not has_mdm then
        local result = ui.confirm(lang.info_msgs.no_mdm.desc,lang.info_msgs.no_mdm.title)
        if result == "yes" then
            local success,msg = chart_pack(win,progressbar)
            progressbar:advance(1)
            if not success then return false,msg end
            ui.msg(msg,lang.info_msgs.success)
            has_mdm = check_for_mdm()
            if not has_mdm then return false end
        else return false,lang.error_msgs.load_mdm.cancel_packing end
    end

    progressbar:advance(1)

    win:status(lang.status_bar.loading_to_cam)

    local split_path = utils.split(settings.muse_dash,"\\")
    local charts_path = string.reverse(string.sub(string.reverse(settings.muse_dash),string.len(split_path[#split_path])+1)).."Custom_Albums"
    
    has_mdm:move(charts_path.."/"..has_mdm.name)

    progressbar:advance(1)
    
    return true,lang.info_msgs.chart_load_success
end

---------------------------------------

ui.run(start_win)
waitall()
SaveAndExit()