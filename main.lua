local json = require("json")
local compression = require("compression")
local ui = require "ui"

local corepath = sys.currentdir
local targetdir = nil

--// UI
local win = ui.Window("Chart Manager", "single", 1000, 730)
win:loadicon(corepath.."/icon.ico")
win.bgcolor = 0x0d1f30
win.font = "Tahoma"
win.fontstyle = {["bold"] = true}
win:center()
win:status("> Idle")

--[[
win:loadtrayicon("./icon.ico")
win.traytooltip = "Chart Manager"
]]

local bg = ui.Picture(win,"./assets/bg.png",0,0)
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

local pack_button = ui.Button(win, "Pack files to MDM", 250,650,175,35)
local load_button = ui.Button(win, "Generate chart files", 25,650,175,35)
bg:toback(pack_button)
bg:toback(load_button)

local title_dir = ui.Label(win,"Chart folder",25,600,175,35)
title_dir.fontsize = 18
title_dir.fgcolor = 0xFFFFFF

bg:toback(title_dir)
local choose_dir = ui.Button(win,"Click to browse directory",250,600,225,35)
choose_dir.fontsize = 10
bg:toback(choose_dir)

function choose_dir:onClick()
    local dir = ui.dirdialog("Select chart folder")
    if dir then
        targetdir = dir.fullpath
        choose_dir.text = targetdir
    end
end

local title_chartname = ui.Label(win,"Name",25,25,175,35)
title_chartname.fontsize = 18
title_chartname.fgcolor = 0xFFFFFF
bg:toback(title_chartname)
local box_chartname = ui.Entry(win,"",250,25,225,35)
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

local selectedFiles = {}

local title_demo = ui.Label(win,"Demo",525,25,175,35)
title_demo.fontsize = 18
title_demo.fgcolor = 0xFFFFFF
bg:toback(title_demo)
local choose_demo = ui.Button(win,"Click to choose demo",750,25,225,35)
choose_demo.fontsize = 10
bg:toback(choose_demo)

function choose_demo:onClick()
    selectedFiles.demo = ui.opendialog("Select a Demo music file", false, "OGG (*.ogg)|*.ogg|MP3 (*.mp3)|*.mp3")
    if selectedFiles.demo then
        choose_demo.text = selectedFiles.demo.name
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
    selectedFiles.music = ui.opendialog("Select the main music file", false, "OGG (*.ogg)|*.ogg|MP3 (*.mp3)|*.mp3")
    if selectedFiles.music then
        choose_music.text = selectedFiles.music.name
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
    selectedFiles.cover = ui.opendialog("Select a Cover image file", false, "PNG (*.png)|*.png|GIF (*.gif)|*.gif")
    if selectedFiles.cover then
        choose_cover.text = selectedFiles.cover.name
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
    selectedFiles.video = ui.opendialog("Select the cinema video file", false, "MP4 (*.mp4)|*.mp4")
    if selectedFiles.video then
        choose_video.text = selectedFiles.video.name
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

local title_gen_bms1 = ui.Label(win,"Add map1.bms?",525,425,175,35)
title_gen_bms1.fontsize = 18
title_gen_bms1.fgcolor = 0xFFFFFF
bg:toback(title_gen_bms1)

local check_map1 = ui.Combobox(win,{"Yes","No"},750,425,75,100)
check_map1.text = "No"
check_map1.fontsize = 14
check_map1.fontstyle = {["bold"] = false}
check_map1.fgcolor = 0xFFFFFF
bg:toback(check_map1)

local title_gen_bms3 = ui.Label(win,"Add map3.bms?",525,475,175,35)
title_gen_bms3.fontsize = 18
title_gen_bms3.fgcolor = 0xFFFFFF
bg:toback(title_gen_bms3)

local check_map3 = ui.Combobox(win,{"Yes","No"},750,475,75,100)
check_map3.text = "No"
check_map3.fontsize = 14
check_map3.fontstyle = {["bold"] = false}
check_map3.fgcolor = 0xFFFFFF
bg:toback(check_map3)

local title_gen_bms4 = ui.Label(win,"Add map4.bms?",525,525,175,35)
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

local title_secret_msg = ui.Label(win,"hideBmsMessage",525,600,175,35)
title_secret_msg.fontsize = 18
title_secret_msg.fgcolor = 0xFFFFFF
bg:toback(title_secret_msg)

local box_secret_msg = ui.Entry(win,"",750,600,225,35)
box_secret_msg.tooltip = "Hidden message for map4.bms"
box_secret_msg.fontsize = 18
box_secret_msg.fontstyle = {["bold"] = false}
bg:toback(box_secret_msg)

local credits = ui.Label(win,"Program made by @taypexx",800,685,175,25)
credits.tooltip = "Feel free to contact me in discord! =3"
credits.fontsize = 8
credits.fgcolor = 0x6e6e6e
credits.bgcolor = 0x292929
bg:toback(credits)

---------------------------------------

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
    chartname = chartname:gsub('%W','') -- removing all non alphanumeric characters
    print(chartname) 

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
    os.execute("ren "..mdmname.." "..chartname..".mdm")
    return true,"Successfully packed chart into MDM!"
end

---------------------------------------

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
        win:status("> Done!")
        ui.msg(msg,"Success")
    else 
        win:status("> Failed to generate")
        ui.error(msg,"Failed to generate")
    end
    win:status("> Idle")
end

ui.run(win)