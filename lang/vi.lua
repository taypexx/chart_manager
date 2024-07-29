--Author: @madguiy

return {

    main = {
        help = "Hỗ Trợ",
        discord = "Discord",
        mdmc = "MDMC",
        github = "Github"
    },

    new_version = {
        title = "Đã có phiên bản mới",
        desc = "Phiên bản mới nhất (v%s) đã ra. Bạn có muốn tải về?"
    },

    prompt_musedash = {
        win = {
            title = "Chọn MuseDash.exe",
            filetype = "Executable file (*.exe)|*.exe"
        },
        popup = {
            title = "Đã tìm thấy MuseDash.exe",
            desc = "Chúng tôi tìm thấy đường dẫn tệp Muse Dash trong máy của bạn ở:\n%s\nCó phải là đường dẫn đúng?"
        }
    },

    welcome_win = {
        create_chart = "Tạo/chỉnh sửa chart",
        crop_chart = "Cắt chart",
        coming_soon = "Sắp ra",
        credits = "Credits"
    },

    error_msgs = {
        error = "Lỗi",
        unknown_error = "Đã xảy ra lỗi không xác định!",
        no_chart_folder = "Bạn phải chọn thư mục chart!",
        generate_mdm = {
            no_cover = "Bạn cần ảnh bìa (cover.png) để tạo MDM chart.",
            no_info = "Bạn cần info.json để tạo MDM chart.",
            no_music = "Bạn cần nhạc (music.ogg/mp3) để tạo MDM chart.",
            no_demo = {
                title = "Cảnh báo",
                desc = "Đang thiếu demo (demo.ogg/mp3) cho chart."
            },
            no_map = "Bạn cần ít nhất 1 file .bms để tạo MDM chart."
        },
        load_mdm = {
            no_musedash_path = "Bạn cần đường dẫn Mush Dash để lưu tập tin MDMs!",
            cancel_packing = "Bạn cần đóng gói các tập tin để lưu chúng"
        },
        crop_mode = {
            no_bms = "Xảy ra lỗi mở file .bms! chart này không có %s",
            no_crop_object = "Chưa chọn Crop Object!",
            no_music = "Chart không có nhạc (music.ogg)!",
            music_rename_fail = "Đặt lại tên nhạc không thành công!",
            music_crop_fail = "Cắt nhạc không thành công!",
            no_info = "Không tìm thấy info.json!",
            chart_pack_fail = "Dống gói MDM không thành công!",
            chart_copy_fail = "Sao chép chart không thành công!",
            chart_open_fail = "Mở chart không thành công!",
            chart_extract_fail = "Xảy ra lỗi trích xuất nội dung của chart!"
        },
        edit_mode = {
            offset_fail = "Không offset được",
            open_fail = "Không mở được",
            edit_fail = "Không chỉnh sửa được",
            packing_fail = "Không đóng gói được",
            generating_fail = "Không tạo được",
            loading_fail = "Tải file không thành công",
            cover_copy_fail = "Sao chép ảnh bìa không thành công!",
            demo_copy_fail = "Sao chép nhạc demo không thành công!",
            music_copy_fail = "Sao chép nhạc không thành công!",
            video_copy_fail = "Sao chép cinema video không thành công!",
            info_find_fail = "Không tìm được info.json!",
            info_read_fail = "Không đọc được info.json!",
            file_find_fail = "Không tìm được %s!",
            bms_read_fail = "Không đọc được file .bms mẫu (template)",
            no_file_found = "Không tìm thấy file %s trong thư mục chart",
            empty_chart_name = "Chart hiện tại không có tên!",
            no_musedash_path = "Bạn cần chọn đường dẫn Muse Dash!",
            no_cover = "Bạn cần chọn ảnh bìa!",
            no_demo = "Bạn cần chọn nhạc demo!",
            no_music = "Bạn cần chọn nhạc!"
        }
    },

    info_msgs = {
        success = "Thành công",
        chart_pack_success = "Đóng gói tệp tin chart vào MDM thành công!",
        chart_load_success = "Lưu chart vào thư mục Custom_Albums thành công!",
        chart_crop_success = "Cắt chart thành công. Giờ bạn có thể mở Muse Dash và chơi bản đã cắt.",
        chart_generate_success = "Tạo files cho chart thành công!",
        no_musedash_path = {
            title = "Không có đường dẫn Muse Dash",
            desc = "Đường dẫn cho Muse Dash chưa được lựa chọn. Bạn có muốn chọn?"
        },
        no_mdm = {
            title = "Không tìm được MDM",
            desc = "Không có tệp tin MDM trong thưu mục chart. Bạn có muốn đóng gói tệp tin?",
        },
        no_bms_editor = {
            title = "Không tìm được phần mềm chỉnh sửa BMS",
            desc = "Bạn chưa chọn phần mềm chỉnh sửa BMS. Bạn có muốn chọn không?"
        },
        no_offset_editor = {
            title = "Không tìm được phần mềm để offset",
            desc = "Bạn chưa chọn phần mềm để offset nhạc. Bạn có muốn chọn không?"
        },
        new_chart_folder = {
            title = "Cảnh báo",
            desc = "Bạn chọn một thư mục chart mới. Xóa bỏ các files trước đó?"
        },
        cover_cropping = {
            title = "Cắt ảnh bìa",
            desc = "Bạn có cần cắt ảnh bìa thành một hình tròn?"
        },
        gif_cover_warning = {
            title = "Không thể cắt GIF",
            desc = "Hiện tại chương trình không hỗ trợ cắt ảnh bìa gif. Ảnh bìa sẽ không được cắt."
        }
    },

    file_select = {
        bms_editor = {
            title = "Chọn phần mềm chỉnh sửa BMS",
            filetype = "Executable file (*.exe)|*.exe"
        },
        offset_editor = {
            title = "Chọn phần mềm chỉnh sửa offset",
            filetype = "Executable file (*.exe)|*.exe"
        },
        demo = {
            title = "Chọn demo (demo.ogg/mp3)",
            filetype = "MP3 or OGG music|*.mp3;*.ogg"
        },
        music = {
            title = "Chọn nhạc (music.ogg/mp3)",
            filetype = "MP3 or OGG music|*.mp3;*.ogg"
        },
        cover = {
            title = "Chọn ảnh bìa",
            filetype = "PNG or GIF image|*.png;*.gif"
        },
        video = {
            title = "Chọn cinema video",
            filetype = "MP4 video|*.mp4"
        }
    },

    status_bar = {
        idle = "> idle",
        done = "> Hoàn thành!",
        packing_fail = "> Đóng gói không thành công!",
        generating_fail = "> Tạo không thành công!",
        loading_fail = "> Lỗi tải file!",
        checking_req_files = "> Kiểm tra files...",
        checking_dialog_files = "> Kiểm tra hôp thoại...",
        checking_cinema_files = "> Kiểm tra cinema...",
        checking_info_chars = "> Kiểm tra các kí tự không hợp lệ trong info.json...",
        checking_mdm = "> Kiểm tra MDM...",
        loading_to_cam = "> Tải đến đường dẫn Custom_Albums...",
        loading_files = "> Tải files được chọn...",
        loading_cinema_files = "> Tải cinema files...",
        loading_template_files = "> Tải template files...",
        loading_bms_files = "> Tải BMS files...",
        viewing_file = "> Đang xem %s...",
        viewing_info = "> Đang xem info.json...",
        compressing_mdm = "> Nén thành MDM...",
        offsetting = "> Offsetting %s...",
        editing = "> Chỉnh sửa %s...",
        cropping_cover = "> Cắt ảnh bìa..."
    },

    menu_bar = {
        mdmc = {
            title = "MDMC",
            home = "Trang chủ",
            upload = "Đăng tải",
            charts = "Charts",
            discord = "Discord",
            find_current_chart = "Tìm chart hiện tại"
        },
        program_select = {
            title = "Chọn chương trình",
            bms = "BMS",
            offset = "Offset",
            musedash = "MuseDash"
        },
        help = "Trợ giúp",
        exit = "Thoát",
        run_musedash = "Chạy MuseDash",
        open = {
            title = "Mở",
            chart_folder = "Thư mục chart",
            musedash_folder = "Thư mục MuseDash",
            info = "Thông tin",
            cover = "Ảnh bìa"
        },
        offset = "Offset",
        edit_bms = "Chỉnh sửa BMS"
    },

    crop_mode = {
        chart_to_crop = "Chart cần cắt",
        select_chart_file = "Chọn chart",
        select_chart_win = {
            title = "Chọn chart",
            filetype = "MDM chart|*.mdm"
        },
        target_map = "Map cần cắt",
        save_to_musedash = "Lưu về MuseDash",
        choose_map = "Chọn map",
        cropping_info = {
            title = "Đang cắt",
            desc = [[Phần mềm chỉnh sửa BMS sẽ mở. Tìm "%s: Crop object" và đặt nó ở bất cứ vạch nào. Cái này sẽ đánh dấu điểm mà chart sẽ được cắt.]]
        },
        crop_map = "Chọn map %s"
    },

    edit_mode = {
        generate_files = "Tạo chart files",
        pack_files = "Đóng gói files thành MDM",
        load_mdm = "Tải MDM vào  Muse Dash",
        main_fields = "Fields chính (bắt buộc)",
        optional_fields = "Fields phụ (tùy thuộc)",
        chart_folder = "Thư mục chart",
        select_folder_info = "Chọn thư mục chart",
        select_folder = "Nhấp để chọn thư mục",
        name = {
            title = "Tên",
            tooltip = "Tên chart của bạn"
        },
        artist = {
            title = "Tác giả",
            tooltip = "Tác giả của bài hát"
        },
        charter = {
            title = "Charter",
            tooltip = "Tên người làm chart"
        },
        scene = "Sân khấu",
        bpm = {
            title = "BPM",
            tooltip = "Nhịp mỗi phút của nhạc"
        },
        difficulty = {
            title = "Độ khó",
            short = "Diff",
            tooltip = "Độ khó của chart trong số sao ★"
        },
        note_speed = "Tốc độ của note",
        demo = {
            title = "Demo",
            button = "Chọn nhạc demo"
        },
        music = {
            title = "Nhạc",
            button = "Chọn nhạc"
        },
        cover = {
            title = "Ảnh bìa",
            button = "Chọn ảnh bìa"
        },
        name_romanized = {
            title = "La-tinh hóa",
            tooltip = "Tên của chart (tiếng La-tinh)",
        },
        video = {
            title = "Video",
            button = "Chọn video"
        },
        video_opacity = {
            title = "Độ mờ đục",
            tooltip = "Độ sáng/tối của video"
        },
        hide_bms_mode = "Chế độ mở màn ẩn BMS",
        hide_bms_msg = {
            title = "Tin nhắn khi mở màn ẩn",
            tooltip = "Tin nhắn hiện lên khi mở khóa một độ khó ẩn"
        },
        other_maps = {
            add = "Cho thêm",
            skip = "Bỏ qua"
        },
        search_tags = {
            title = "Tags (từ khóa) tìm chart",
            tooltip = "Tags được phân chia bởi dấu phẩy (tag1, tag2, ...)"
        },
        scene_egg = "Easter egg"
    }

}