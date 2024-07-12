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
if settings_file then
    settings = json.parse(settings_file:read("a"))
    if not settings or settings == {} then
        settings = {
            music_offset = "",
            bms_editor = "",
            muse_dash = ""
        }
    end
    settings_file:close()
end

function SaveSettings()
    if settings.muse_dash == "" and settings.bms_editor == "" and settings.music_offset == "" then
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

function clearTemp()
    for entry in each(sys.Directory(corepath.."\\temp")) do
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

--// Muse Dash autodetect path

function prompt_musedash_program()
    local selected_path = ui.opendialog("Select MuseDash.exe",false,"Executable file (*.exe)|*.exe")
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
        local response = ui.confirm("We found a Muse Dash path on your computer at:\n"..default_md_path.."\nIs that a correct path?","MuseDash.exe found")
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

local credits = ui.Label(start_win,"Made by @taypexx",580,480,175,25)
credits.tooltip = "Feel free to contact me in discord! =3"
credits.fontsize = 10
credits.fgcolor = 0xffffff
credits.bgcolor = consts.startbgcolor
bg:toback(credits)

credits.onClick = function ()
    sys.cmd(string.format([[explorer "%s"]],consts.yt))
end

local help_button = ui.Button(start_win,"Help",10,465)
help_button.fontsize = 11
help_button:loadicon(github_icon)
help_button.width = 80
help_button.height = 30
bg:toback(help_button)

help_button.onClick = function ()
    sys.cmd(string.format([[explorer "%s#chart_manager"]],consts.github))
end

local discord_button = ui.Button(start_win,"Discord",100,465)
discord_button.fontsize = 11
discord_button:loadicon(discord_icon)
discord_button.width = 80
discord_button.height = 30
bg:toback(discord_button)

discord_button.onClick = function ()
    sys.cmd(string.format([[explorer "%s"]],consts.discord))
end

local mdmc_button = ui.Button(start_win,"MDMC",190,465)
mdmc_button.fontsize = 11
mdmc_button:loadicon(melon_icon)
mdmc_button.width = 80
mdmc_button.height = 30
bg:toback(mdmc_button)

mdmc_button.onClick = function ()
    sys.cmd([[explorer "https://mdmc.moe"]])
end

local edit_button = ui.Button(start_win,"Create/edit a chart",25,350)
edit_button:loadicon(bms_icon)
edit_button.fontsize = 18
edit_button.width = 220
edit_button.height = 40
bg:toback(edit_button)
edit_button.onClick = function ()
    start_win.visible = false
    start_win.enabled = false
    edit_mode.run()
end

local crop_button = ui.Button(start_win,"Crop a chart",250,350)
crop_button:loadicon(music_icon)
crop_button.fontsize = 18
crop_button.width = 200
crop_button.height = 40
bg:toback(crop_button)
crop_button.onClick = function ()
    start_win.visible = false
    start_win.enabled = false
    crop_mode.run()
end

local download_button = ui.Button(start_win,"Coming soon",455,350,200,50)
download_button:loadicon(md_icon)
download_button.fontsize = 18
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
        return false,"You need to select chart folder!"
    end

    progressbar.range = {0,4}
    progressbar.position = 0
    progressbar:show()

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

    progressbar:advance(1)
    win:status("> Checking for dialog files...")

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

    progressbar:advance(1)
    win:status("> Compressing into MDM...")
    
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
    
    return true,"Successfully packed chart into MDM!"
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

    progressbar.range = {0,3}
    progressbar.position = 0
    progressbar:show()

    win:status("> Checking for MDM...")

    local has_mdm = check_for_mdm()
    if not has_mdm then
        local result = ui.confirm("There is no MDM file in the chart folder. Do you want to pack files?","No MDM found")
        if result == "yes" then
            local success,msg = chart_pack(win,progressbar)
            progressbar:advance(1)
            if not success then return false,msg end
            ui.msg(msg,"Success")
            has_mdm = check_for_mdm()
            if not has_mdm then return false end
        else return false,"You have to pack files in order to save them" end
    end

    progressbar:advance(1)

    win:status("> Loading to Muse Dash charts path...")

    local split_path = utils.split(settings.muse_dash,"\\")
    local charts_path = string.reverse(string.sub(string.reverse(settings.muse_dash),string.len(split_path[#split_path])+1)).."Custom_Albums"
    
    has_mdm:move(charts_path.."/"..has_mdm.name)

    progressbar:advance(1)
    
    return true,"Successfully saved chart to Muse Dash!"
end

---------------------------------------

ui.run(start_win)
waitall()
SaveSettings()