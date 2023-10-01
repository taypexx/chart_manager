local json = require("json")
local compression = require("compression")
local ui = require "ui"

local corepath = sys.currentdir
local targetdir = corepath

--// UI
local win = ui.Window("Chart Manager", "fixed", 1000, 600)
win:loadicon(corepath.."/icon.ico")

local pack_button = ui.Button(win, "Pack files to MDM", 250,550,175,35)
local load_button = ui.Button(win, "Generate chart files", 25,550,175,35)

local title_dir = ui.Label(win,"Browse directory",25,500,175,35)
title_dir.fontsize = 18
local choose_dir = ui.Button(win,"Click to browse directory",225,500,225,35)
choose_dir.fontsize = 10

function choose_dir:onClick()
    local dir = ui.dirdialog("Select chart folder")
    if dir then
        targetdir = dir.fullpath
        choose_dir.text = targetdir
    end
end

local title_chartname = ui.Label(win,"Name",25,25,175,35)
title_chartname.fontsize = 18
local box_chartname = ui.Entry(win,"",250,25,225,35)
box_chartname.tooltip = "Name of your chart"
box_chartname.fontsize = 12

local title_chartname_rom = ui.Label(win,"Name romanized",25,80,175,35)
title_chartname_rom.fontsize = 14
local box_chartname_rom = ui.Entry(win,"",250,75,225,35)
box_chartname_rom.tooltip = "Name of your chart(romanized)"
box_chartname_rom.fontsize = 12

local title_artist = ui.Label(win,"Artist",25,125,175,35)
title_artist.fontsize = 18
local box_artist = ui.Entry(win,"",250,125,225,35)
box_artist.tooltip = "Artist"
box_artist.fontsize = 12

local title_charter = ui.Label(win,"Charter",25,175,175,35)
title_charter.fontsize = 18
local box_charter = ui.Entry(win,"",250,175,225,35)
box_charter.tooltip = "Author of the chart"
box_charter.fontsize = 12

local title_scene = ui.Label(win,"Scene",25,225,175,35)
title_scene.fontsize = 18
local list_scene = ui.Combobox(win,{"scene_01 (Space Station)","scene_02 (Retrocity)","scene_03 (Castle)","scene_04 (Rainy Night)","scene_05 (Candyland)","scene_06 (Oriental)","scene_07 (Let's Groove)","scene_08 (Touhou)","scene_09 (DJMAX)"},
250,225,225,150)
list_scene.fontsize = 14

local title_bpm = ui.Label(win,"BPM",25,275,175,35)
title_bpm.fontsize = 18
local box_bpm = ui.Entry(win,"",250,275,225,35)
box_bpm.tooltip = "BPM of the song"
box_bpm.fontsize = 18

local title_diff = ui.Label(win,"Difficulty",25,325,175,35)
title_diff.fontsize = 18
local box_diff = ui.Entry(win,"",250,325,225,35)
box_diff.tooltip = "Difficulty of the chart"
box_diff.fontsize = 18

local title_notespeed = ui.Label(win,"Note Speed",25,375,175,35)
title_notespeed.fontsize = 18
local list_notespeed = ui.Combobox(win,{"Speed 1","Speed 2","Speed 3"},
250,375,225,150)
list_notespeed.fontsize = 14

local selectedFiles = {}

local title_demo = ui.Label(win,"Demo",525,25,175,35)
title_demo.fontsize = 18
local choose_demo = ui.Button(win,"Click to choose demo",750,25,225,35)
choose_demo.fontsize = 10

function choose_demo:onClick()
    selectedFiles.demo = ui.opendialog("Select a Demo music file", false, "OGG (*.ogg)|*.ogg|MP3 (*.mp3)|*.mp3")
    if selectedFiles.demo then
        choose_demo.text = selectedFiles.demo.name
    end
end

local title_music = ui.Label(win,"Music",525,75,175,35)
title_music.fontsize = 18
local choose_music = ui.Button(win,"Click to choose music",750,75,225,35)
choose_music.fontsize = 10

function choose_music:onClick()
    selectedFiles.music = ui.opendialog("Select the main music file", false, "OGG (*.ogg)|*.ogg|MP3 (*.mp3)|*.mp3")
    if selectedFiles.music then
        choose_music.text = selectedFiles.music.name
    end
end

local title_cover = ui.Label(win,"Cover Image",525,125,175,35)
title_cover.fontsize = 18
local choose_cover = ui.Button(win,"Click to choose an image",750,125,225,35)
choose_cover.fontsize = 10

function choose_cover:onClick()
    selectedFiles.cover = ui.opendialog("Select a Cover image file", false, "PNG (*.png)|*.png|GIF (*.gif)|*.gif")
    if selectedFiles.cover then
        choose_cover.text = selectedFiles.cover.name
    end
end

local title_video = ui.Label(win,"Video (optional)",525,175,175,35)
title_video.fontsize = 18
local choose_video = ui.Button(win,"Click to choose video",750,175,225,35)
choose_video.fontsize = 10

function choose_video:onClick()
    selectedFiles.video = ui.opendialog("Select the cinema video file", false, "MP4 (*.mp4)|*.mp4")
    if selectedFiles.video then
        choose_video.text = selectedFiles.video.name
    end
end

function generate_chart()
    --// Generate chart files

    if not selectedFiles.cover then
        return false,"You need to pick a cover image!"
    end
    if not selectedFiles.demo then
        return false,"You need to pick the demo audio!"
    end
    if not selectedFiles.music then
        return false,"You need to pick the music audio!"
    end

    local cover = selectedFiles.cover:copy("TEMPCOVER"..selectedFiles.cover.extension)
    cover:move(targetdir.."/cover"..selectedFiles.cover.extension)

    local demo = selectedFiles.demo:copy("TEMPDEMO"..selectedFiles.demo.extension)
    demo:move(targetdir.."/demo"..selectedFiles.demo.extension)

    local music = selectedFiles.music:copy("TEMPMUSIC"..selectedFiles.music.extension)
    music:move(targetdir.."/music"..selectedFiles.music.extension)
    
    local video
    if selectedFiles.video then
        video = selectedFiles.video:copy("TEMPVIDEO"..selectedFiles.video.extension)
        video:move(targetdir.."/video"..selectedFiles.video.extension)

        local cinemaTemplate = sys.File(targetdir.."/cinema.json")
        cinemaTemplate:open("write")
        cinemaTemplate:write([[{"file_name": "video.mp4","opacity": 0.5}]])
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

    info = string.format(info,
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
        "0",
        box_diff.text,
        "0",
        "0"
    )

    infoFile = io.open(targetdir.."/info.json","w")
    if not infoFile then
        return false,"Couldn't find info.json!"
    end
    infoFile:write(info)
    infoFile:close()

    local bmsFile = io.open(targetdir.."/map2.bms","r")
    if not bmsFile then
        return false,"Couldn't find map2.bms!"
    end
    local bms = bmsFile:read("a")
    bmsFile:close()
    if not bms then
        return false,"Couldn't read map2.bms file!"
    end
    
    bms = string.format(bms,
        string.sub(list_notespeed.text,6),
        string.sub(list_scene.text,1,8),
        box_chartname.text,
        box_artist.text,
        box_charter.text,
        box_bpm.text,
        box_diff.text,
        "2"
    )

    bmsFile = io.open(targetdir.."/map2.bms","w")
    if not bmsFile then
        return false,"Couldn't find map2.bms!"
    end
    bmsFile:write(bms)
    bmsFile:close()

    return true,"Successfully generated chart files!"
end

---------------------------------------

function chart_pack()
    --// Packing

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

function pack_button:onClick()
    local success,msg = chart_pack()
    msg = msg or "Unknown error occured"
    if success then
        ui.msg(msg,"Success")
    else 
        ui.error(msg,"Failed to pack")
    end
end

function load_button:onClick()
    local success,msg = generate_chart()
    msg = msg or "Unknown error occured"
    if success then
        ui.msg(msg,"Success")
    else 
        ui.error(msg,"Failed to generate")
    end
end

ui.run(win)