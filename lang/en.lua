--Author: @taypexx

return {

    main = {
        help = "Help",
        discord = "Discord",
        mdmc = "MDMC",
        github = "Github"
    },

    new_version = {
        title = "New version available",
        desc = "New version of the program is available (v%s). Would you like to download it?"
    },

    prompt_musedash = {
        win = {
            title = "Select MuseDash.exe",
            filetype = "Executable file (*.exe)|*.exe"
        },
        popup = {
            title = "MuseDash.exe found",
            desc = "We found a Muse Dash path on your computer at:\n%s\nIs that a correct path?"
        }
    },

    welcome_win = {
        create_chart = "Create/edit a chart",
        crop_chart = "Crop a chart",
        coming_soon = "Coming soon",
        credits = "Credits"
    },

    error_msgs = {
        error = "Error",
        unknown_error = "Unknown error occured!",
        no_chart_folder = "You need to select chart folder!",
        generate_mdm = {
            no_cover = "You need a cover image to generate MDM chart.",
            no_info = "You need an info.json file to generate MDM chart.",
            no_music = "You need a music file to generate MDM chart.",
            no_demo = {
                title = "Warning",
                desc = "Missing demo file for chart."
            },
            no_map = "You need at least 1 bms map to generate MDM chart."
        },
        load_mdm = {
            no_musedash_path = "You need Muse Dash path to save MDMs!",
            cancel_packing = "You have to pack files in order to save them"
        },
        crop_mode = {
            no_bms = "Error opening bms map! This chart doesn't have %s",
            no_crop_object = "You didn't add Crop object!",
            no_music = "Chart doesn't have a music file!",
            music_rename_fail = "Failed to rename music file!",
            music_crop_fail = "Failed to crop music file!",
            no_info = "info.json not found!",
            chart_pack_fail = "Failed to pack MDM chart!",
            chart_copy_fail = "Failed to copy the chart!",
            chart_open_fail = "Failed to open the chart!",
            chart_extract_fail = "Failed to extract chart contents!"
        },
        edit_mode = {
            offset_fail = "Failed to offset",
            open_fail = "Failed to open",
            edit_fail = "Failed to edit",
            packing_fail = "Failed to pack",
            generating_fail = "Failed to generate",
            loading_fail = "Failed to load",
            cover_copy_fail = "Failed to copy cover image!",
            demo_copy_fail = "Failed to copy demo audio!",
            music_copy_fail = "Failed to copy music audio!",
            video_copy_fail = "Failed to copy cinema video!",
            info_find_fail = "Failed to find info.json!",
            info_read_fail = "Failed to read info.json!",
            file_find_fail = "Failed to find %s!",
            bms_read_fail = "Failed to read template BMS file!",
            no_file_found = "No %s file was found in chart folder!",
            empty_chart_name = "Current chart name is empty!",
            no_musedash_path = "You need to select Muse Dash path!",
            no_cover = "You need to select a cover image!",
            no_demo = "You need to select the demo audio!",
            no_music = "You need to select the music audio!"
        }
    },

    info_msgs = {
        success = "Success",
        chart_pack_success = "Successfully packed chart files into MDM!",
        chart_load_success = "Successfully saved chart to Custom_Albums folder!",
        chart_crop_success = "Successfully cropped your chart. You can now run MuseDash and play your cropped version.",
        chart_generate_success = "Successfully generated chart files!",
        no_musedash_path = {
            title = "No Muse Dash path",
            desc = "Muse Dash path wasn't selected. Do you want to select it?"
        },
        no_mdm = {
            title = "No MDM found",
            desc = "There is no MDM file in the chart folder. Do you want to pack files?"
        },
        no_bms_editor = {
            title = "No BMS editor found",
            desc = "You didn't select BMS editor program. Would you like to do it?"
        },
        no_offset_editor = {
            title = "No offset program found",
            desc = "You didn't select a program for music offsetting. Would you like to do it?"
        },
        new_chart_folder = {
            title = "Warning",
            desc = "You selected a new chart folder. Erase all previous fields?"
        },
        cover_cropping = {
            title = "Cover cropping",
            desc = "Do you need to crop the Cover image in a circle?"
        },
        gif_cover_warning = {
            title = "Cannot crop GIF",
            desc = "There is no support for cropping gif covers at the moment. Cover won't be cropped."
        }
    },

    file_select = {
        bms_editor = {
            title = "Select BMS editor program",
            filetype = "Executable file (*.exe)|*.exe"
        },
        offset_editor = {
            title = "Select offset editor program",
            filetype = "Executable file (*.exe)|*.exe"
        },
        demo = {
            title = "Select a demo file",
            filetype = "MP3 or OGG music|*.mp3;*.ogg"
        },
        music = {
            title = "Select a music file",
            filetype = "MP3 or OGG music|*.mp3;*.ogg"
        },
        cover = {
            title = "Select a cover image file",
            filetype = "PNG or GIF image|*.png;*.gif"
        },
        video = {
            title = "Select cinema video file",
            filetype = "MP4 video|*.mp4"
        }
    },

    status_bar = {
        idle = "> Idle",
        done = "> Done!",
        packing_fail = "> Failed to pack!",
        generating_fail = "> Failed to generate!",
        loading_fail = "> Failed to load!",
        checking_req_files = "> Checking required files...",
        checking_dialog_files = "> Checking for dialog files...",
        checking_cinema_files = "> Checking for cinema files...",
        checking_info_chars = "> Checking for foridden characters in info.json...",
        checking_mdm = "> Checking for MDM...",
        loading_to_cam = "> Loading to Custom_Albums path...",
        loading_files = "> Loading selected files...",
        loading_cinema_files = "> Loading cinema files...",
        loading_template_files = "> Loading template files...",
        loading_bms_files = "> Loading BMS files...",
        viewing_file = "> Viewing %s...",
        viewing_info = "> Viewing info.json...",
        compressing_mdm = "> Compressing into MDM...",
        offsetting = "> Offsetting %s...",
        editing = "> Editing %s...",
        cropping_cover = "> Cropping cover..."
    },

    menu_bar = {
        mdmc = {
            title = "MDMC",
            home = "Home",
            upload = "Upload",
            charts = "Charts",
            discord = "Discord",
            find_current_chart = "Find current chart"
        },
        program_select = {
            title = "Select Programs",
            bms = "BMS",
            offset = "Offset",
            musedash = "MuseDash"
        },
        help = "Help",
        exit = "Exit",
        run_musedash = "Run MuseDash",
        open = {
            title = "Open",
            chart_folder = "Chart Folder",
            musedash_folder = "MuseDash Folder",
            info = "info",
            cover = "cover"
        },
        offset = "Offset",
        edit_bms = "Edit BMS"
    },

    crop_mode = {
        chart_to_crop = "Chart to crop",
        select_chart_file = "Select a chart file",
        select_chart_win = {
            title = "Select the chart file",
            filetype = "MDM chart|*.mdm"
        },
        target_map = "Target map",
        save_to_musedash = "Save to MuseDash",
        choose_map = "Choose the map",
        cropping_info = {
            title = "Cropping",
            desc = [[BMS editor will open. Find "%s: Crop object" and place it on any line. This object defines where the chart will be cropped at.]]
        },
        crop_map = "Crop the %s"
    },

    edit_mode = {
        generate_files = "Generate chart files",
        pack_files = "Pack files to MDM",
        load_mdm = "Load MDM to Muse Dash",
        main_fields = "Main fields",
        optional_fields = "Optional fields",
        chart_folder = "Chart folder",
        select_folder_info = "Select chart folder",
        select_folder = "Click to select folder",
        name = {
            title = "Name",
            tooltip = "Name of your chart"
        },
        artist = {
            title = "Artist",
            tooltip = "Author of the music"
        },
        charter = {
            title = "Charter",
            tooltip = "Author of the chart"
        },
        scene = "Scene",
        bpm = {
            title = "BPM",
            tooltip = "Beats per minute of the music"
        },
        difficulty = {
            title = "Difficulty",
            short = "Diff",
            tooltip = "Difficulty of the chart in stars"
        },
        note_speed = "Note Speed",
        demo = {
            title = "Demo",
            button = "Click to select demo"
        },
        music = {
            title = "Music",
            button = "Click to select music"
        },
        cover = {
            title = "Cover Image",
            button = "Click to choose image"
        },
        name_romanized = {
            title = "Name romanized",
            tooltip = "Name of your chart (romanized)",
        },
        video = {
            title = "Video",
            button = "Click to choose video"
        },
        video_opacity = {
            title = "Video Opacity",
            tooltip = "Opacity of the cinema video"
        },
        hide_bms_mode = "Hide BMS Mode",
        hide_bms_msg = {
            title = "Hide BMS Message",
            tooltip = "Message that pops up when you unlock hidden difficulty"
        },
        other_maps = {
            add = "Add",
            skip = "Skip"
        },
        search_tags = {
            title = "Search Tags",
            tooltip = "Tags are separated by comma (tag1, tag2, ...)"
        },
        scene_egg = "Scene Egg"
    }

}