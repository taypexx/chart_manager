local crop_mode = {}

function crop_mode.run()
    --// Creating download window
    local win = ui.Window("Cropper - Chart Manager "..version, "single", 600, 500)
    win:loadicon(corepath.."/icon.ico")
    win.bgcolor = consts.bgcolor
    win.font = consts.font
    win.fontstyle = {["bold"] = true}
    win:center()
    win:status(lang.status_bar.idle)

    win.onClose = SaveAndExit

    --// Top menu setup

    win_menu = ui.Menu(lang.menu_bar.run_musedash,lang.menu_bar.exit)
    win.menu = win_menu 
    local mdmc_menu = ui.Menu()
    local mdmc_buttons = {
        mdmc_menu:insert(1,lang.menu_bar.mdmc.home),
        mdmc_menu:insert(2,lang.menu_bar.mdmc.upload),
        mdmc_menu:insert(3,lang.menu_bar.mdmc.charts),
        mdmc_menu:insert(4,lang.menu_bar.mdmc.discord)
    }

    function mdmc_menu_func(item)
        if item.text == lang.menu_bar.mdmc.home then
            sys.cmd([[explorer "https://mdmc.moe/"]])
        elseif item.text == lang.menu_bar.mdmc.upload then
            sys.cmd([[explorer "https://mdmc.moe/upload"]])
        elseif item.text == lang.menu_bar.mdmc.charts then
            sys.cmd([[explorer "https://mdmc.moe/charts"]])
        elseif item.text == lang.menu_bar.mdmc.discord then
            sys.cmd([[explorer "https://discord.gg/mdmc"]])
        end
    end

    for _,button in pairs(mdmc_buttons) do
        button.onClick = mdmc_menu_func
        if button.text == lang.menu_bar.mdmc.discord then
            button:loadicon(discord_icon)
        else
            button:loadicon(melon_icon)
        end
    end

    win.menu:insert(1,lang.menu_bar.mdmc.title, mdmc_menu)

    ---------------------------------------

    local program_select_menu = ui.Menu()
    local program_select_buttons = {
        program_select_menu:insert(1,lang.menu_bar.program_select.bms),
        program_select_menu:insert(2,lang.menu_bar.program_select.offset),
        program_select_menu:insert(3,lang.menu_bar.program_select.musedash)
    }

    for _,button in pairs(program_select_buttons) do
        if button.text == lang.menu_bar.program_select.bms then
            button.onClick = select_BMS_programm
            button:loadicon(bms_icon) 
        elseif button.text == lang.menu_bar.program_select.offset then
            button.onClick = select_offset_programm
            button:loadicon(offset_icon)
        elseif button.text == lang.menu_bar.program_select.musedash then
            button.onClick = prompt_musedash_program
            button:loadicon(md_icon)
        end
    end

    win.menu:insert(2,lang.menu_bar.program_select.title,program_select_menu)

    ---------------------------------------

    local help_docs = {
        [1] = {"Muse Dash Charting Tips",""},
        [2] = {"Understanding Muse Dash Chart Structure",""},
        [3] = {"Offsetting Charts With Adobe Audition (AU)",""}, 
        [4] = {"Quick MDBMSC Setup Guide","https://docs.google.com/document/d/1wYgaUv_sX6IxUv-KjiRRv68Jg82xH0GG21ySRs8zigk/preview"},
        [5] = {lang.main.github,consts.github}
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
        if button.text == lang.main.github then
            button:loadicon(github_icon) 
        else
            button:loadicon(help_icon) 
        end
    end

    win.menu:insert(3,lang.menu_bar.help, help_docs_menu)

    ---------------------------------------

    win.menu.items[4].onClick = function ()
        if not settings.muse_dash or settings.muse_dash == "" then
            local response = ui.confirm(lang.info_msgs.no_musedash_path.desc,lang.info_msgs.no_musedash_path.title)
            if response == "yes" then
                local selected = prompt_musedash_program()
                if selected == "" then return end
            else return end
        end
        sys.cmd(string.format([[""%s"]],settings.muse_dash))
    end

    win.menu.items[5].onClick = SaveAndExit

    ---------------------------------------

    local selected_chart,list_maps
    targetdir = corepath.."\\temp"
    local buttondb = false

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

    local title_select = ui.Label(win,lang.crop_mode.chart_to_crop,25,25,175,35)
    title_select.fontsize = 18
    title_select.fgcolor = 0xFFFFFF
    bg:toback(title_select)
    
    local button_select = ui.Button(win,lang.crop_mode.select_chart_file,225,25)
    button_select:loadicon(melon_icon)
    button_select.fontsize = 14
    button_select.width = 175
    button_select.height = 35
    bg:toback(button_select)
    button_select.onClick = function ()
        selected_chart = ui.opendialog(lang.crop_mode.select_chart_win.title, false, lang.crop_mode.select_chart_win.filetype)
        if selected_chart then
            button_select.text = selected_chart.name
            button_select.fontsize = 10
            list_maps.onChange()
        end
    end

    local progressbar = ui.Progressbar(win,27,9999,350,20)

    local title_maps = ui.Label(win,lang.crop_mode.target_map,25,75,175,35)
    title_maps.fontsize = 18
    title_maps.fgcolor = 0xFFFFFF
    bg:toback(title_maps)

    local button_save = ui.Button(win,lang.crop_mode.save_to_musedash,215,400)
    button_save.fontsize = 14
    button_save:loadicon(md_icon)
    button_save.width = 185
    button_save.height = 35
    bg:toback(button_save)
    button_save.enabled = false
    button_save.onClick = function ()
        if buttondb then return end
        buttondb = true

        --// Cropping BMS

        local bms_path = string.format("%s\\%s.bms",targetdir,list_maps.text)
        local bms_map = sys.File(bms_path)
        if not bms_map.exists then
            buttondb = false
            ui.error(string.format(lang.error_msgs.crop_mode.no_bms,list_maps.text),lang.error_msgs.error)
            return
        end

        bms_map:open("read")

        local bpm,cut_time,cut_beat = nil,nil,nil
        local write_lines = {}

        for line in bms_map.lines do
            local t = utils.split(line," ")
            if #t > 1 then
                if t[1] == "#BPM" then
                    bpm = tonumber(t[2])
                    break
                end
            end
        end
        bms_map:close()
        bms_map:open("read")

        local iter = 0
        for line in bms_map.lines do
            local t = utils.split(line,":")
            if #t > 1 then
                local beatvalues_str = t[2]
                local line_beat = tonumber(string.sub(line,2,4))
                local targ_ind
                for i = 1,string.len(beatvalues_str),2 do
                    local notepos = (i+1)/2
                    local value = string.sub(beatvalues_str,i,i+1)
                    if value == consts.bms_crop_value then
                        targ_ind = notepos
                    end
                end
                if targ_ind then
                    --// Mega smart calculations (i broke myself fr)
                    local beat_grid = string.len(beatvalues_str)/2
                    cut_beat = line_beat
                    cut_time = (1/bpm*60) * (beat_grid*cut_beat) / (beat_grid/4)
                end
                if cut_beat then
                    iter = iter + 1
                    local fmtnum = line_beat-cut_beat
                    if fmtnum < 10 then
                        fmtnum = "00"..fmtnum
                    elseif fmtnum < 100 then
                        fmtnum = "0"..fmtnum
                    else
                        fmtnum = tostring(fmtnum)
                    end
                    local line = string.format("#%s%s:%s",fmtnum,string.sub(t[1],5,6),beatvalues_str)
                    write_lines[iter] = line
                elseif string.sub(t[2],1,2) == "10" then
                    iter = iter + 1
                    write_lines[iter] = line
                end
            else
                iter = iter + 1
                write_lines[iter] = line
            end
        end
        bms_map:close()

        if not cut_time then
            buttondb = false
            ui.error(lang.error_msgs.crop_mode.no_crop_object,lang.error_msgs.error)
            return
        end

        bms_map:open("write")
        for _,line in pairs(write_lines) do
            bms_map:writeln(line)
        end
        bms_map:close()

        --// Music cropping

        local music_file = sys.File(targetdir.."\\music.ogg")
        if not music_file.exists then
            music_file = sys.File(targetdir.."\\music.mp3")
        end
        if not music_file.exists then
            buttondb = false
            ui.error(lang.error_msgs.crop_mode.no_music,lang.error_msgs.error)
            return
        end
        local music_extension = string.sub(music_file.name,-3,-1)
        local rename_success = music_file:move(targetdir.."\\cut."..music_extension)

        if not rename_success then
            buttondb = false
            ui.error(lang.error_msgs.crop_mode.music_rename_fail,lang.error_msgs.error)
            return
        end

        local cut_command = string.format(
            [[""%s/py/audio_cropper.exe" "%s" "%s" "%s" "%s"]],
            corepath,
            corepath.."\\temp",
            "cut."..music_extension,
            "music."..music_extension,
            utils.numtostr(cut_time)
        )
        local musiccrop_success = sys.cmd(cut_command)

        if not musiccrop_success then
            buttondb = false
            ui.error(lang.error_msgs.crop_mode.music_crop_fail,lang.error_msgs.error)
            return
        end

        --// info.json editing

        local info_path = targetdir.."\\info.json"
        local info_file = sys.File(info_path)
        if not info_file.exists then
            buttondb = false
            ui.error(lang.error_msgs.crop_mode.no_info,lang.error_msgs.error)
            return
        end
        info_file:open("read","utf8")

        local write_lines = {}
        local i = 0
        for line in info_file.lines do
            i = i + 1
            local t = utils.split(line,":")
            if string.find(t[1],[["name"]]) then
                local chart_name = ""
                local conc = false
                for _,char in pairs(utils.split(t[2],"")) do
                    if char == [["]] and not conc then
                        conc = true
                    elseif char == [["]] and conc then
                        break
                    end
                    if conc and char ~= [["]] then
                        chart_name = chart_name..char
                    end
                end
                write_lines[i] = string.format([[    "name": "%s (cut at %s)",]],chart_name,math.floor(utils.numtostr(cut_time)*100)/100)
            else
                write_lines[i] = line
            end
        end

        info_file:close()
        info_file = io.open(info_path,"w")
        if not info_file then print("No info file!") return end

        for _,line in pairs(write_lines) do
            info_file:write(line.."\n")
        end

        info_file:close()

        --// Talk files

        for m=1,4 do
            local talk = sys.File(targetdir..string.format("\\map%s.talk",tostring(m))) --// mr talk reference
            if talk.exists then
                local talk_json = utils.jsonR(talk.fullpath)
                if talk_json then
                    for _,lang in pairs(talk_json) do
                        for _,dialog in pairs(lang) do
                            local t = dialog.time - cut_time
                            if t <= 0 then
                                table.remove(lang,utils.tableFind(lang,dialog))
                            else
                                dialog.time = t
                            end
                        end
                    end
                end
                utils.jsonW(talk.fullpath,talk_json)
            end
        end

        --// Packing and saving

        chart_pack(win,progressbar)
        progressbar:hide()

        local mdm_chart = check_for_mdm()
        if not mdm_chart then
            buttondb = false
            ui.error(lang.error_msgs.crop_mode.chart_pack_fail,lang.error_msgs.error)
            return
        end

        local split_path = utils.split(settings.muse_dash,"\\")
        local charts_path = string.reverse(string.sub(string.reverse(settings.muse_dash),string.len(split_path[#split_path])+1)).."Custom_Albums"
    
        mdm_chart:move(charts_path.."/"..mdm_chart.name)

        ui.msg(lang.info_msgs.chart_crop_success,lang.info_msgs.success)
        win:status("> Idle")
        clearTemp()
        buttondb = false
    end

    local button_crop = ui.Button(win,lang.crop_mode.choose_map,25,400)
    button_crop:loadicon(bms_icon)
    button_crop.fontsize = 14
    button_crop.width = 175
    button_crop.height = 35
    bg:toback(button_crop)
    button_crop.enabled = false
    button_crop.onClick = function ()
        if buttondb then return end
        if settings.bms_editor == "" or not settings.bms_editor then
            local result = ui.confirm(lang.info_msgs.no_bms_editor.desc,lang.info_msgs.no_bms_editor.title)
            if result == "yes" then
                local selected = select_BMS_programm()
                if not selected then return end
            else return end
        end

        if not settings.muse_dash or settings.muse_dash == "" then
            local response = ui.confirm(lang.info_msgs.no_musedash_path.desc,lang.info_msgs.no_musedash_path.title)
            if response == "yes" then
                local selected = prompt_musedash_program()
                if selected == "" then return end
            else return end
        end

        buttondb = true
        clearTemp()

        local chart_copy = selected_chart:copy(targetdir.."\\TEMP.zip")
        if not chart_copy then
            buttondb = false
            ui.error(lang.error_msgs.crop_mode.chart_copy_fail,lang.error_msgs.error)
            return
        end

        local arch = compression.Zip(chart_copy)
        if not arch then
            buttondb = false
            ui.error(lang.error_msgs.crop_mode.chart_open_fail,lang.error_msgs.error)
            return
        end

        local extracted = arch:extractall(targetdir)
        if not extracted then
            arch:close()
            buttondb = false
            ui.error(lang.error_msgs.crop_mode.chart_extract_fail,lang.error_msgs.error)
            return
        end

        arch:close()
        chart_copy:remove()

        local bms_path = string.format("%s\\%s.bms",targetdir,list_maps.text)
        local bms_map = sys.File(bms_path)
        if not bms_map.exists then
            buttondb = false
            ui.error(string.format(lang.error_msgs.crop_mode.no_bms,list_maps.text),lang.error_msgs.error)
            return
        end

        bms_map:open("read")
        local i,lastline = 0,""
        local write_lines = {}
        for line in bms_map.lines do
            i = i+1
            if (string.sub(lastline,1,4) == "#WAV" or string.sub(lastline,1,7) == "#SCROLL") and line == "" then
                write_lines[i] = string.format("#WAV%s Crop object",consts.bms_crop_value)
            else
                write_lines[i] = line
            end
            lastline = line
        end
        bms_map:close()
        
        bms_map:open("write")
        for i,line in pairs(write_lines) do
            bms_map:writeln(line)
        end

        bms_map:close()

        ui.info(string.format(lang.crop_mode.cropping_info.desc,consts.bms_crop_value),lang.crop_mode.cropping_info.title)

        sys.cmd(string.format('""%s" "%s"',settings.bms_editor,bms_path))

        button_save.enabled = true
        buttondb = false
    end

    list_maps = ui.Combobox(win,{"map1","map2","map3","map4"},225,75,175,200)
    list_maps.fontsize = 16
    list_maps.fontstyle = {["bold"] = false}
    list_maps.text = ""
    list_maps.onChange = function()
        local active = list_maps.text ~= ""
        button_crop.enabled = active and selected_chart
        if active and selected_chart then
            button_crop.text = string.format(lang.crop_mode.crop_map,list_maps.text)
        elseif active then
            button_crop.text = lang.crop_mode.select_chart_file
        elseif selected_chart then
            button_crop.text = lang.crop_mode.choose_map
        end
    end
    bg:toback(list_maps)


    ui.run(win)
    waitall()
end

return crop_mode