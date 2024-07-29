local download_mode = {}
local entries = {}
local rows,columns = 3,2

local function createChartEntry(ind,info)
    local entry
end

local function clearChartEntries()
    
end

local ranked_url = "https://mdmc.moe/api/v1/charts"
local unranked_url = "https://mdmc.moe/api/v1/charts/unranked"
local cover_url = "https://mdmc.moe/charts/%s/cover.png"
local download_url = "https://mdmc.moe/download/%s"

function download_mode.run()
    --// Creating download window
    local win = ui.Window("Website charts - Chart Manager "..version, "single", 1000, 745)
    win:loadicon(corepath.."/icon.ico")
    win.bgcolor = consts.bgcolor
    win.font = consts.font
    win.fontstyle = {["bold"] = true}
    win:center()

    win.onClose = SaveAndExit

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

    ui.run(win)
    waitall()
end

return download_mode