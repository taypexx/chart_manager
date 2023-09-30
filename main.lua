local json = require("json")
local compression = require("compression")
local ui = require "ui"

--// UI
local win = ui.Window("Chart Manager", "fixed", 250, 300)
local button = ui.Button(win, "Create MDM template", 80)

function chart_pack()
    local filestotal = {}
    local cover1 = io.open("./cover.png","r")
    local cover2 = io.open("./cover.gif","r")
    if not (cover1 or cover2) then print("You need a cover image to generate MDM chart.") return end
    if cover1 then
        filestotal.cover = ".png"
        cover1:close()
    end
    if cover2 then
        filestotal.cover = ".gif"
        cover2:close()
    end

    local infoFile = io.open("./info.json","r")
    if not infoFile then print("You need an info.json file to generate MDM chart.") return end

    local music1 = io.open("./music.mp3","r")
    local music2 = io.open("./music.ogg","r")
    if not (music1 or music2) then
        print("You need a music file to generate MDM chart.")
        if music1 then
            music1:close()
        end
        if music2 then
            music2:close()
        end
        return
    end
    if music1 then
        music1:close()
        filestotal.music = ".mp3"
    end
    if music2 then
        music2:close()
        filestotal.music = ".ogg"
    end

    local demo1 = io.open("./demo.mp3","r")
    local demo2 = io.open("./demo.ogg","r")
    if not (demo1 or demo2) then
        print("Missing demo file for chart.")
    end
    if demo1 then
        demo1:close()
        filestotal.demo = ".mp3"
    end
    if demo2 then
        demo2:close()
        filestotal.demo = ".ogg"
    end

    local map1 = io.open("./map1.bms","r")
    local map2 = io.open("./map2.bms","r")
    local map3 = io.open("./map3.bms","r")
    local map4 = io.open("./map4.bms","r")

    if not (map1 or map2 or map3 or map4) then
        print("You need at least 1 bms map to generate MDM chart.")
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
        return
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

    --[[
    if not (fs.existsSync("./cover.png") or fs.existsSync("./cover.gif")) then print("You need a cover image to generate MDM chart.") return end
    if not fs.existsSync("./info.json") then print("You need an info.json file to generate MDM chart.") return end
    if not (fs.existsSync("./music.mp3") or fs.existsSync("./music.ogg")) then print("You need a music file to generate MDM chart.") return end
    if not (fs.existsSync("./map1.bms") or fs.existsSync("./map2.bms") or fs.existsSync("./map3.bms") or fs.existsSync("./map4.bms")) then print("You need at least 1 bms map to generate MDM chart.") return end
    if not (fs.existsSync("./demo.mp3") or fs.existsSync("./demo.ogg")) then print("Missing demo file for chart.") end
    ]]
    
    local contents = infoFile:read("a")
    local info = json.decode(contents)
    if not info then return end
    infoFile:close()
    
    local chartname = info.name
    print(chartname) 

    --[[local mdm = compression.Zip(chartname..".zip")
    mdm:open("write")
    mdm:write("./cover.png")]]
end

chart_pack()

ui.run(win)