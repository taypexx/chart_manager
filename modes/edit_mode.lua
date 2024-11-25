local edit_mode = {}
local box_chartname,progressbar

function select_BMS_programm()
    local editor = ui.opendialog(lang.file_select.bms_editor.title,false,lang.file_select.bms_editor.filetype)
    if not editor then return end
    settings.bms_editor = editor.fullpath
    SaveSettings()
    return true
end

function select_offset_programm()
    local editor = ui.opendialog(lang.file_select.offset_editor.title,false,lang.file_select.offset_editor.filetype)
    if not editor then return end
    settings.music_offset = editor.fullpath
    SaveSettings()
    return true
end

function offset_track(win,item)
    if not targetdir then
        ui.error(lang.error_msgs.no_chart_folder,lang.error_msgs.edit_mode.offset_fail)
        return
    end

    if settings.music_offset == "" or not settings.music_offset then
        local result = ui.confirm(lang.info_msgs.no_offset_editor.desc,lang.info_msgs.no_offset_editor.title)
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
        ui.error(string.format(lang.error_msgs.edit_mode.no_file_found,track_name),lang.error_msgs.edit_mode.offset_fail)
        return
    end
    track:close()

    local launch_cmd = string.format('""%s" "%s"',settings.music_offset,track_path)
    coroutine.wrap(function ()
        win:status(string.format(lang.status_bar.offsetting,track_name))
        sys.cmd(launch_cmd)
        win:status(lang.status_bar.idle)
    end)()
end

function edit_mode.run()
    --// Creating edit window
    local win = ui.Window("Editor - Chart Manager "..version, "single", 1000, 745)
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
        mdmc_menu:insert(4,lang.menu_bar.mdmc.find_current_chart),
        mdmc_menu:insert(5,lang.menu_bar.mdmc.discord)
    }

    function mdmc_menu_func(item)
        if item.text == lang.menu_bar.mdmc.home then
            sys.cmd([[explorer "https://mdmc.moe/"]])
        elseif item.text == lang.menu_bar.mdmc.upload then
            sys.cmd([[explorer "https://mdmc.moe/upload"]])
        elseif item.text == lang.menu_bar.mdmc.charts then
            sys.cmd([[explorer "https://mdmc.moe/charts"]])
        elseif item.text == lang.menu_bar.mdmc.find_current_chart then
            if box_chartname.text ~= "" then
                sys.cmd(string.format([[explorer "https://mdmc.moe/charts?search=%s"]],box_chartname.text)) 
            else
                ui.error(lang.error_msgs.edit_mode.empty_chart_name,lang.error_msgs.error)
            end
        elseif item.text == lang.menu_bar.mdmc.discord then
            sys.cmd(string.format([[explorer "%s"]],consts.discord))
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

    win.menu:insert(1,lang.menu_bar.mdmc.title,mdmc_menu)

    ---------------------------------------

    local file_open_menu = ui.Menu()
    local file_open_buttons = {
        file_open_menu:insert(1,lang.menu_bar.open.chart_folder),
        file_open_menu:insert(2,lang.menu_bar.open.musedash_folder),
        file_open_menu:insert(3,lang.menu_bar.open.info),
        file_open_menu:insert(4,lang.menu_bar.open.cover)
    }

    function file_open_menu_func(item)
        if item.text == lang.menu_bar.open.musedash_folder then
            if not settings.muse_dash or settings.muse_dash == "" then
                ui.error(lang.error_msgs.edit_mode.no_musedash_path,lang.error_msgs.edit_mode.open_fail)
                return
            end
            sys.cmd(string.format([[explorer "%s"]],string.sub(settings.muse_dash,1,-13)))
            return
        end
        if not targetdir then
            ui.error(lang.error_msgs.no_chart_folder,lang.error_msgs.edit_mode.open_fail)
            return
        end
        if item.text == lang.menu_bar.open.chart_folder then
            sys.cmd(string.format([[explorer "%s"]],targetdir))
        elseif item.text == lang.menu_bar.open.info then
            coroutine.wrap(function (...)
                win:status(lang.status_bar.viewing_info)
                sys.cmd(string.format([["%s"]],targetdir.."\\info.json"))
                win:status(lang.status_bar.idle)
            end)()
        elseif item.text == lang.menu_bar.open.cover then
            local filename = "cover.png"
            local f = io.open(targetdir.."\\"..filename,"r")
            if not f then
                filename = "cover.gif"
            else
                f:close()
            end
            coroutine.wrap(function (...)
                win:status(string.format(lang.status_bar.viewing_file,filename))
                sys.cmd(string.format([["%s"]],targetdir.."\\"..filename))
                win:status(lang.status_bar.idle)
            end)()
        end
    end

    for _,button in pairs(file_open_buttons) do
        button.onClick = file_open_menu_func
        if button.text == lang.menu_bar.open.chart_folder then
            button:loadicon(melon_icon)
        elseif button.text == lang.menu_bar.open.info then
            button:loadicon(file_icon)
        elseif button.text == lang.menu_bar.open.cover then
            button:loadicon(photo_icon)
        elseif button.text == lang.menu_bar.open.musedash_folder then
            button:loadicon(md_icon)
        end
    end

    win.menu:insert(2,lang.menu_bar.open.title,file_open_menu)

    ---------------------------------------

    local offset_edit_menu = ui.Menu()
    local offset_edit_buttons = {offset_edit_menu:insert(1,"demo"),offset_edit_menu:insert(2,"music")}

    for _,button in pairs(offset_edit_buttons) do
        button.onClick = function ()
            offset_track(win,button)
        end
        button:loadicon(music_icon)
    end

    win.menu:insert(3, lang.menu_bar.offset, offset_edit_menu)

    ---------------------------------------

    local bms_edit_menu = ui.Menu()
    local bms_edit_buttons = {bms_edit_menu:insert(1,"map1"),bms_edit_menu:insert(2,"map2"),bms_edit_menu:insert(3,"map3"),bms_edit_menu:insert(4,"map4")}

    function bms_edit_menu_func(item)
        if not targetdir then
            ui.error(lang.error_msgs.no_chart_folder,lang.error_msgs.edit_mode.edit_fail)
            return
        end

        if settings.bms_editor == "" or not settings.bms_editor then
            local result = ui.confirm(lang.info_msgs.no_bms_editor.desc,lang.info_msgs.no_bms_editor.title)
            if result == "yes" then
                local selected = select_BMS_programm()
                if not selected then return end
            else return end
        end

        local map_name = item.text
        local map_path = targetdir.."\\"..map_name..".bms"
        local map_file = io.open(map_path,"r")
        if not map_file then
            ui.error(string.format(lang.error_msgs.edit_mode.no_file_found,map_name),lang.error_msgs.edit_mode.edit_fail)
            return
        end
        map_file:close()

        local launch_cmd = string.format('""%s" "%s"',settings.bms_editor,map_path)
        coroutine.wrap(function ()
            win:status(string.format(lang.status_bar.editing,map_name))
            sys.cmd(launch_cmd)
            win:status(lang.status_bar.idle)
        end)()
    end

    for _,button in pairs(bms_edit_buttons) do
        button.onClick = bms_edit_menu_func
        button:loadicon(bms_icon)
    end

    win.menu:insert(4, lang.menu_bar.edit_bms, bms_edit_menu)

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

    win.menu:insert(5,lang.menu_bar.program_select.title,program_select_menu)

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

    win.menu:insert(6,lang.menu_bar.help,help_docs_menu)

    ---------------------------------------

    win.menu.items[7].onClick = function ()
        if not settings.muse_dash or settings.muse_dash == "" then
            local response = ui.confirm(lang.info_msgs.no_musedash_path.desc,lang.info_msgs.no_musedash_path.title)
            if response == "yes" then
                local selected = prompt_musedash_program()
                if selected == "" then return end
            else return end
        end
        sys.cmd(string.format([[""%s"]],settings.muse_dash))
    end

    win.menu.items[8].onClick = SaveAndExit

    --// Edit mode UI

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

    local load_button = ui.Button(win,lang.edit_mode.generate_files, 25,650)
    load_button:loadicon(bms_icon)
    load_button.fontsize = 14
    load_button:autosize()

    local pack_button = ui.Button(win,lang.edit_mode.pack_files,load_button.x+load_button.width+15,650)
    pack_button:loadicon(archive_icon)
    pack_button.fontsize = 14
    load_button:autosize()

    local mdm_load_button = ui.Button(win,lang.edit_mode.load_mdm,pack_button.x+pack_button.width+15,650)
    mdm_load_button:loadicon(md_icon)
    mdm_load_button.fontsize = 14
    load_button:autosize()

    bg:toback(load_button)
    bg:toback(pack_button)
    bg:toback(mdm_load_button)
-----------------------------------------------------------------------------
    local title_main_fields = ui.Label(win,lang.edit_mode.main_fields,25,25,450,25)
    title_main_fields.fontsize = 14
    title_main_fields.fgcolor = 0xFFFFFF
    bg:toback(title_main_fields)
-----------------------------------------------------------------------------
    local title_dir = ui.Label(win,lang.edit_mode.chart_folder,25,75,175,35)
    title_dir.fontsize = 18
    title_dir.fgcolor = 0xFFFFFF
    bg:toback(title_dir)

    local choose_dir = ui.Button(win,lang.edit_mode.select_folder,250,75)
    choose_dir:loadicon(melon_icon)
    choose_dir.fontsize = 14
    choose_dir.width = 225
    choose_dir.height = 35
    bg:toback(choose_dir)
-----------------------------------------------------------------------------
    local title_chartname = ui.Label(win,lang.edit_mode.name.title,25,125,175,35)
    title_chartname.fontsize = 18
    title_chartname.fgcolor = 0xFFFFFF
    bg:toback(title_chartname)

    box_chartname = ui.Entry(win,"",250,125,225,35)
    box_chartname.tooltip = lang.edit_mode.name.tooltip
    box_chartname.fontsize = 12
    box_chartname.fontstyle = {["bold"] = false}
    bg:toback(box_chartname)
-----------------------------------------------------------------------------
    local title_artist = ui.Label(win,lang.edit_mode.artist.title,25,175,175,35)
    title_artist.fontsize = 18
    title_artist.fgcolor = 0xFFFFFF
    bg:toback(title_artist)

    local box_artist = ui.Entry(win,"",250,175,225,35)
    box_artist.tooltip = lang.edit_mode.artist.tooltip
    box_artist.fontsize = 12
    box_artist.fontstyle = {["bold"] = false}
    bg:toback(box_artist)
-----------------------------------------------------------------------------
    local title_charter = ui.Label(win,lang.edit_mode.charter.title,25,225,175,35)
    title_charter.fontsize = 18
    title_charter.fgcolor = 0xFFFFFF
    bg:toback(title_charter)

    local box_charter = ui.Entry(win,"",250,225,225,35)
    box_charter.tooltip = lang.edit_mode.charter.tooltip
    box_charter.fontsize = 12
    box_charter.fontstyle = {["bold"] = false}
    bg:toback(box_charter)
-----------------------------------------------------------------------------
    local title_scene = ui.Label(win,lang.edit_mode.scene,25,275,175,35)
    title_scene.fontsize = 18
    title_scene.fgcolor = 0xFFFFFF
    bg:toback(title_scene)

    local list_scene = ui.Combobox(win,{
        "scene_01 (Space Station)",
        "scene_02 (Retrocity)",
        "scene_03 (Castle)",
        "scene_04 (Rainy Night)",
        "scene_05 (Candyland)",
        "scene_06 (Oriental)",
        "scene_07 (Let's Groove)",
        "scene_08 (Touhou)",
        "scene_09 (DJMAX)"
    },
    250,275,225,400)
    list_scene.fontsize = 14
    list_scene.fontstyle = {["bold"] = false}
    list_scene.text = "scene_01 (Space Station)"
    bg:toback(list_scene)
-----------------------------------------------------------------------------
    local title_bpm = ui.Label(win,lang.edit_mode.bpm.title,25,325,175,35)
    title_bpm.fontsize = 18
    title_bpm.fgcolor = 0xFFFFFF
    bg:toback(title_bpm)

    local box_bpm = ui.Entry(win,"100",250,325,225,35)
    box_bpm.tooltip = lang.edit_mode.bpm.tooltip
    box_bpm.fontsize = 18
    box_bpm.fontstyle = {["bold"] = false}
    bg:toback(box_bpm)
-----------------------------------------------------------------------------
    local title_diff = ui.Label(win,lang.edit_mode.difficulty.title,25,375,175,35)
    title_diff.fontsize = 18
    title_diff.fgcolor = 0xFFFFFF
    bg:toback(title_diff)

    local box_diff = ui.Entry(win,"?",250,375,225,35)
    box_diff.tooltip = lang.edit_mode.difficulty.tooltip
    box_diff.fontsize = 18
    box_diff.fontstyle = {["bold"] = false}
    bg:toback(box_diff)
-----------------------------------------------------------------------------
    local title_notespeed = ui.Label(win,lang.edit_mode.note_speed,25,425,175,35)
    title_notespeed.fontsize = 18
    title_notespeed.fgcolor = 0xFFFFFF
    bg:toback(title_notespeed)

    local list_notespeed = ui.Combobox(win,{"Speed 1","Speed 2","Speed 3"},
    250,425,225,150)
    list_notespeed.fontsize = 16
    list_notespeed.fontstyle = {["bold"] = false}
    list_notespeed.text = "Speed 3"
    bg:toback(list_notespeed)
-----------------------------------------------------------------------------
    local title_demo = ui.Label(win,lang.edit_mode.demo.title,25,475,175,35)
    title_demo.fontsize = 18
    title_demo.fgcolor = 0xFFFFFF
    bg:toback(title_demo)
    local choose_demo = ui.Button(win,lang.edit_mode.demo.button,250,475,225,35)
    choose_demo.fontsize = 10
    choose_demo:loadicon(music_icon)
    bg:toback(choose_demo)

    function choose_demo:onClick()
        selectedFiles.demo = ui.opendialog(lang.file_select.demo.title, false, lang.file_select.demo.filetype)
        if selectedFiles.demo then
            choose_demo.text = selectedFiles.demo.name
            choose_demo.fontsize = 7
        end
    end
-----------------------------------------------------------------------------
    local title_music = ui.Label(win,lang.edit_mode.music.title,25,525,175,35)
    title_music.fontsize = 18
    title_music.fgcolor = 0xFFFFFF
    bg:toback(title_music)
    local choose_music = ui.Button(win,lang.edit_mode.music.button,250,525,225,35)
    choose_music.fontsize = 14
    choose_music:loadicon(music_icon)
    bg:toback(choose_music)

    function choose_music:onClick()
        selectedFiles.music = ui.opendialog(lang.file_select.music.title,false, lang.file_select.music.filetype)
        if selectedFiles.music then
            choose_music.text = selectedFiles.music.name
            choose_music.fontsize = 7
        end
    end
-----------------------------------------------------------------------------
    local title_cover = ui.Label(win,lang.edit_mode.cover.title,25,575,175,35)
    title_cover.fontsize = 18
    title_cover.fgcolor = 0xFFFFFF
    bg:toback(title_cover)
    local choose_cover = ui.Button(win,lang.edit_mode.cover.button,250,575,225,35)
    choose_cover.fontsize = 14
    choose_cover:loadicon(photo_icon)
    bg:toback(choose_cover)

    function choose_cover:onClick()
        selectedFiles.cover = ui.opendialog(lang.file_select.cover.title,false,lang.file_select.cover.filetype)
        if selectedFiles.cover then
            choose_cover.text = selectedFiles.cover.name
            choose_cover.fontsize = 7
        end
    end
-----------------------------------------------------------------------------
    local title_optional_fields = ui.Label(win,lang.edit_mode.optional_fields,525,25,450,25)
    title_optional_fields.fontsize = 14
    title_optional_fields.fgcolor = 0xFFFFFF
    bg:toback(title_optional_fields)
 -----------------------------------------------------------------------------
    local title_chartname_rom = ui.Label(win,lang.edit_mode.name_romanized.title,525,75,175,35)
    title_chartname_rom.fontsize = 14
    title_chartname_rom.fgcolor = 0xFFFFFF
    bg:toback(title_chartname_rom)

    local box_chartname_rom = ui.Entry(win,"",750,75,225,35)
    box_chartname_rom.tooltip = lang.edit_mode.name_romanized.tooltip
    box_chartname_rom.fontsize = 12
    box_chartname_rom.fontstyle = {["bold"] = false}
    bg:toback(box_chartname_rom)
-----------------------------------------------------------------------------
    local title_video = ui.Label(win,lang.edit_mode.video.title,525,125,175,35)
    title_video.fontsize = 18
    title_video.fgcolor = 0xFFFFFF
    bg:toback(title_video)

    local choose_video = ui.Button(win,lang.edit_mode.video.button,750,125,225,35)
    choose_video.fontsize = 14
    choose_video:loadicon(music_icon)
    bg:toback(choose_video)

    function choose_video:onClick()
        selectedFiles.video = ui.opendialog(lang.file_select.video.title,false,lang.file_select.video.filetype)
        if selectedFiles.video then
            choose_video.text = selectedFiles.video.name
            choose_video.fontsize = 7
        end
    end
-----------------------------------------------------------------------------
    local title_video_opacity = ui.Label(win,lang.edit_mode.video_opacity.title,525,175,175,35)
    title_video_opacity.fontsize = 13
    title_video_opacity.fgcolor = 0xFFFFFF
    bg:toback(title_video_opacity)

    local box_video_opacity = ui.Entry(win,"0.5",750,175,225,35)
    box_video_opacity.tooltip = lang.edit_mode.video_opacity.tooltip
    box_video_opacity.fontsize = 14
    box_video_opacity.fontstyle = {["bold"] = false}
    bg:toback(box_video_opacity)
-----------------------------------------------------------------------------
    local title_hide_mode = ui.Label(win,lang.edit_mode.hide_bms_mode,525,225,175,35)
    title_hide_mode.fontsize = 12
    title_hide_mode.fgcolor = 0xFFFFFF
    bg:toback(title_hide_mode)

    local list_hide_mode = ui.Combobox(win,{"CLICK","PRESS","TOGGLE"},750,225,225,200)
    list_hide_mode.fontsize = 14
    list_hide_mode.fontstyle = {["bold"] = false}
    list_hide_mode.text = "CLICK"
    bg:toback(list_hide_mode)
-----------------------------------------------------------------------------
    local title_secret_msg = ui.Label(win,lang.edit_mode.hide_bms_msg.title,525,275,175,35)
    title_secret_msg.fontsize = 12
    title_secret_msg.fgcolor = 0xFFFFFF
    bg:toback(title_secret_msg)

    local box_secret_msg = ui.Entry(win,"",750,275,225,35)
    box_secret_msg.tooltip = lang.edit_mode.hide_bms_msg.tooltip
    box_secret_msg.fontsize = 12
    box_secret_msg.fontstyle = {["bold"] = false}
    bg:toback(box_secret_msg)
    -----------------------------------------------------------------------------
    local title_gen_bms1 = ui.Label(win,"map1.bms",525,325,175,35)
    title_gen_bms1.fontsize = 18
    title_gen_bms1.fgcolor = 0xFFFFFF
    bg:toback(title_gen_bms1)

    local check_map1 = ui.Combobox(win,{lang.edit_mode.other_maps.add,lang.edit_mode.other_maps.skip},750,325,75,100)
    check_map1.text = lang.edit_mode.other_maps.skip
    check_map1.fontsize = 14
    check_map1.fontstyle = {["bold"] = false}
    check_map1.fgcolor = 0xFFFFFF
    bg:toback(check_map1)
-----------------------------------------------------------------------------
    local title_gen_bms3 = ui.Label(win,"map3.bms",525,375,175,35)
    title_gen_bms3.fontsize = 18
    title_gen_bms3.fgcolor = 0xFFFFFF
    bg:toback(title_gen_bms3)

    local check_map3 = ui.Combobox(win,{lang.edit_mode.other_maps.add,lang.edit_mode.other_maps.skip},750,375,75,100)
    check_map3.text = lang.edit_mode.other_maps.skip
    check_map3.fontsize = 14
    check_map3.fontstyle = {["bold"] = false}
    check_map3.fgcolor = 0xFFFFFF
    bg:toback(check_map3)
-----------------------------------------------------------------------------
    local title_gen_bms4 = ui.Label(win,"map4.bms",525,425,175,35)
    title_gen_bms4.fontsize = 18
    title_gen_bms4.fgcolor = 0xFFFFFF
    bg:toback(title_gen_bms4)

    local check_map4 = ui.Combobox(win,{lang.edit_mode.other_maps.add,lang.edit_mode.other_maps.skip},750,425,75,100)
    check_map4.text = lang.edit_mode.other_maps.skip
    check_map4.fontsize = 14
    check_map4.fontstyle = {["bold"] = false}
    check_map4.fgcolor = 0xFFFFFF
    bg:toback(check_map4)
-----------------------------------------------------------------------------
    local title_map1_diff = ui.Label(win,lang.edit_mode.difficulty.short..":",835,325,50,35)
    title_map1_diff.fontsize = 14
    title_map1_diff.fgcolor = 0xFFFFFF
    bg:toback(title_map1_diff)

    local box_map1_diff = ui.Entry(win,"0",915,325,50,35)
    box_map1_diff.fontsize = 14
    box_map1_diff.fgcolor = 0xFFFFFF
    box_map1_diff.fontstyle = {["bold"] = false}
    bg:toback(box_map1_diff)
-----------------------------------------------------------------------------
    local title_map3_diff = ui.Label(win,lang.edit_mode.difficulty.short..":",835,375,50,35)
    title_map3_diff.fontsize = 14
    title_map3_diff.fgcolor = 0xFFFFFF
    bg:toback(title_map3_diff)

    local box_map3_diff = ui.Entry(win,"0",915,375,50,35)
    box_map3_diff.fontsize = 14
    box_map3_diff.fgcolor = 0xFFFFFF
    box_map3_diff.fontstyle = {["bold"] = false}
    bg:toback(box_map3_diff)
-----------------------------------------------------------------------------
    local title_map4_diff = ui.Label(win,lang.edit_mode.difficulty.short..":",835,425,50,35)
    title_map4_diff.fontsize = 14
    title_map4_diff.fgcolor = 0xFFFFFF
    bg:toback(title_map4_diff)

    local box_map4_diff = ui.Entry(win,"0",915,425,50,35)
    box_map4_diff.fontsize = 14
    box_map4_diff.fgcolor = 0xFFFFFF
    box_map4_diff.fontstyle = {["bold"] = false}
    bg:toback(box_map4_diff)
-----------------------------------------------------------------------------
    local title_search_tags = ui.Label(win,lang.edit_mode.search_tags.title,525,475,175,35)
    title_search_tags.fontsize = 14
    title_search_tags.fgcolor = 0xFFFFFF
    bg:toback(title_search_tags)

    local box_search_tags = ui.Entry(win,"",750,475,225,35)
    box_search_tags.tooltip = lang.edit_mode.search_tags.tooltip
    box_search_tags.fontsize = 12
    box_search_tags.fontstyle = {["bold"] = false}
    bg:toback(box_search_tags)
-----------------------------------------------------------------------------
    local title_scene_egg = ui.Label(win,lang.edit_mode.scene_egg,525,525,175,35)
    title_scene_egg.fontsize = 14
    title_scene_egg.fgcolor = 0xFFFFFF
    bg:toback(title_scene_egg)

    local list_scene_egg = ui.Combobox(win,{"None","RinLen","Miku","Christmas","BadApple","Queen","Arknights","Cytus","Touhou","Wacca"},750,526,225,150)
    list_scene_egg.text = "None"
    list_scene_egg.fontsize = 14
    list_scene_egg.fontstyle = {["bold"] = false}
    bg:toback(list_scene_egg)
-----------------------------------------------------------------------------
    progressbar = ui.Progressbar(win,25,575,450,25)
    progressbar.range = {0,10}

    --// Fields managing

    local default_button_size = {x=225,y=35}
    function clearFields()
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
        check_map1.text = lang.edit_mode.other_maps.skip
        check_map3.text = lang.edit_mode.other_maps.skip
        check_map4.text = lang.edit_mode.other_maps.skip
        load_button.enabled = true
        choose_demo.text = lang.edit_mode.demo.button
        choose_music.text = lang.edit_mode.music.button
        choose_cover.text = lang.edit_mode.cover.button
        choose_video.text = lang.edit_mode.video.button
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
        box_search_tags.text = ""
        list_scene_egg.text = "None"
    end

    clearFields()

    function autofill_fields()

        if box_chartname.text ~= "" then
            if ui.confirm(lang.info_msgs.new_chart_folder.desc,lang.info_msgs.new_chart_folder.title) == "yes" then
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
            check_map1.text = lang.edit_mode.other_maps.add
        else
            check_map1.text = lang.edit_mode.other_maps.skip
        end
        if box_map3_diff.text ~= "0" then
            check_map3.text = lang.edit_mode.other_maps.add
        else
            check_map3.text = lang.edit_mode.other_maps.skip
        end
        if box_map4_diff.text ~= "0" then
            check_map4.text = lang.edit_mode.other_maps.add
        else
            check_map4.text = lang.edit_mode.other_maps.skip
        end

        local chart_searchTags = ""
        for i,searchTag in pairs(chart_info.searchTags) do
            chart_searchTags = chart_searchTags..searchTag
            if i < #chart_info.searchTags then
                chart_searchTags = chart_searchTags..", "
            end
        end
        box_search_tags.text = chart_searchTags

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
        local dir = ui.dirdialog(lang.edit_mode.select_folder_info)
        if dir then
            targetdir = dir.fullpath
            choose_dir.fontsize = 6
            choose_dir.text = targetdir
            autofill_fields()
        end
    end

    function generate_chart()
        --// Generate chart files
    
        if not targetdir then
            return false,lang.error_msgs.no_chart_folder
        end
        if not selectedFiles.cover then
            return false,lang.error_msgs.edit_mode.no_cover
        end
        if not selectedFiles.demo then
            return false,lang.error_msgs.edit_mode.no_demo
        end
        if not selectedFiles.music then
            return false,lang.error_msgs.edit_mode.no_music
        end

        progressbar.range = {0,5}
        progressbar.position = 0
        progressbar:show()
    
        win:status(lang.status_bar.checking_info_chars)

        local searchTags = ""
        local searchTagsSplit = utils.split(box_search_tags.text,",")
        for index,searchTag in pairs(searchTagsSplit) do
            if searchTag ~= "" then
                searchTag = utils.removeSpaces(searchTag)
                searchTags = searchTags..string.format([["%s"]],searchTag)
                if index < #searchTagsSplit then
                    searchTags = searchTags..","
                end 
            end
        end

        local sceneEggFormat = ""
        if list_scene_egg.text ~= "None" then
            sceneEggFormat = string.format([[,
    "sceneEgg": "%s"]],list_scene_egg.text)
        end
    
        local info_format = {
            box_chartname.text,
            box_chartname_rom.text,
            box_artist.text,
            box_bpm.text,
            string.sub(list_scene.text,1,8),
            searchTags,
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
            box_secret_msg.text,
            sceneEggFormat,
        }
    
        for i,formatstr in pairs(info_format) do
            if i ~= 6 and i ~= 18 then --// Skip search tags and scene egg (they have quotes)
                local allowed,errmsg = utils.checkForValidJsonField(formatstr)
                if not allowed then
                    return false,errmsg
                end 
            end
        end

        progressbar:advance(1)
    
        --// Cover cropping (disabled at the moment)
    
        local need_cropping = "no"--ui.confirm(lang.info_msgs.cover_cropping.desc,lang.info_msgs.cover_cropping.title)
        if need_cropping == "yes" and selectedFiles.cover.extension ~= ".gif" then
            win:status(lang.status_bar.cropping_cover)
            sys.cmd(string.format([[""%s\py\cover_cropper.exe" "%s" "%s"]],corepath,selectedFiles.cover.fullpath,targetdir))
        else
            if selectedFiles.cover.extension == ".gif" and need_cropping == "yes" then
                ui.warn(lang.info_msgs.gif_cover_warning.desc,lang.info_msgs.gif_cover_warning.title)
            end
            local cover = selectedFiles.cover:copy(targetdir.."/cover"..selectedFiles.cover.extension)
            if not cover then
                return false,lang.error_msgs.edit_mode.cover_copy_fail
            end
        end

        progressbar:advance(1)
        win:status(lang.status_bar.loading_files)
    
        local demo = selectedFiles.demo:copy(targetdir.."/demo"..selectedFiles.demo.extension)
        if not demo then
            return false,lang.error_msgs.edit_mode.demo_copy_fail
        end
    
        local music = selectedFiles.music:copy(targetdir.."/music"..selectedFiles.music.extension)
        if not music then
            return false,lang.error_msgs.edit_mode.music_copy_fail
        end

        local video
        if selectedFiles.video then
    
            win:status(lang.status_bar.loading_cinema_files)
    
            video = selectedFiles.video:copy(targetdir.."/video"..selectedFiles.video.extension)
            if not video then
                return false,lang.error_msgs.edit_mode.video_copy_fail
            end
    
            local video_opacity = tonumber(box_video_opacity.text)
            if not video_opacity then
                box_video_opacity.text = "0.5"
            end

            os.execute(string.format([[copy "%s/template/other" "%s"]],corepath,targetdir))
    
            local cinemaTemplate = io.open(targetdir.."/cinema.json","r")
            if not cinemaTemplate then
                return false,lang.error_msgs.unknown_error
            end
            local cinema = cinemaTemplate:read("a")
            cinemaTemplate:close()
            cinemaTemplate = io.open(targetdir.."/cinema.json","w")
            if not cinemaTemplate then
                return false,lang.error_msgs.unknown_error
            end
            cinemaTemplate:write(string.format(cinema,box_video_opacity.text))
            cinemaTemplate:close()
        end
    
        os.execute(string.format([[copy "%s/template/main" "%s"]],corepath,targetdir))
    
        local infoFile = io.open(targetdir.."/info.json","r")
        if not infoFile then
            return false,lang.error_msgs.edit_mode.info_find_fail
        end
        local info = infoFile:read("a")
        infoFile:close()
        if not info then
            return false,lang.error_msgs.edit_mode.info_read_fail
        end

        progressbar:advance(1)
        win:status(lang.status_bar.loading_template_files)
    
        info = string.format(info,table.unpack(info_format))
    
        infoFile = io.open(targetdir.."/info.json","w")
        if not infoFile then
            return false,lang.error_msgs.edit_mode.info_find_fail
        end
        infoFile:write(info)
        infoFile:close()

        progressbar:advance(1)
        win:status(lang.status_bar.loading_bms_files)
    
        local bms2File = io.open(targetdir.."/map2.bms","r")
        if not bms2File then
            return false,string.format(lang.error_msgs.edit_mode.file_find_fail,"map2.bms")
        end
        local bmsTemplate = bms2File:read("a")
        bms2File:close()
        if not bmsTemplate then
            return false,lang.error_msgs.edit_mode.bms_read_fail
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
            return false,string.format(lang.error_msgs.edit_mode.file_find_fail,"map2.bms")
        end
        bms2File:write(bms2)
        bms2File:close()
    
        --// Bonus BMS maps
    
        if check_map1.text == lang.edit_mode.other_maps.add then
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
    
        if check_map3.text == lang.edit_mode.other_maps.add then
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
    
        if check_map4.text == lang.edit_mode.other_maps.add then
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

        progressbar:advance(1)
    
        return true,lang.info_msgs.chart_generate_success
    end

    local button_debounce = false

    --// Bindings

    function pack_button:onClick()
        if button_debounce then return end
        button_debounce = true

        local success,msg = chart_pack(win,progressbar)
        msg = msg or lang.error_msgs.unknown_error
        if success then
            win:status(lang.status_bar.done)
            ui.msg(msg,lang.info_msgs.success)
        else 
            win:status(lang.status_bar.packing_fail)
            ui.error(msg,lang.error_msgs.edit_mode.packing_fail)
        end

        progressbar:hide()
        button_debounce = false
        win:status(lang.status_bar.idle)
    end

    function load_button:onClick()
        if button_debounce then return end
        button_debounce = true

        local success,msg = generate_chart()
        msg = msg or lang.error_msgs.unknown_error
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
            win:status(lang.status_bar.done)
            ui.msg(msg,lang.info_msgs.success)
        else 
            win:status(lang.status_bar.generating_fail)
            ui.error(msg,lang.error_msgs.edit_mode.generating_fail)
        end

        progressbar:hide()
        button_debounce = false
        win:status(lang.status_bar.idle)
    end

    function mdm_load_button:onClick()
        if button_debounce then return end
        button_debounce = true

        local success,msg = mdm_load(win,progressbar)
        msg = msg or lang.error_msgs.unknown_error
        if success then
            win:status(lang.status_bar.done)
            ui.msg(msg,lang.info_msgs.success)
        else 
            win:status(lang.status_bar.loading_fail)
            ui.error(msg,lang.error_msgs.edit_mode.loading_fail)
        end

        progressbar:hide()
        win:status(lang.status_bar.idle)
        button_debounce = false
    end
    
    ui.run(win)
    waitall()
end

return edit_mode