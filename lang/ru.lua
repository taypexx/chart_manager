--Author: @taypexx

return {

    main = {
        help = "Помощь",
        discord = "Дискорд",
        mdmc = "MDMC",
        github = "Гитхаб"
    },

    new_version = {
        title = "Доступна новая версия",
        desc = "Доступна новая версия программы (v%s). Хотите скачать новую версию?"
    },

    prompt_musedash = {
        win = {
            title = "Выберите MuseDash.exe",
            filetype = "Исполняемый файл (*.exe)|*.exe"
        },
        popup = {
            title = "Найден MuseDash.exe",
            desc = "Мы нашли Muse Dash на вашем пк:\n%s\nЭто правильный путь?"
        }
    },

    welcome_win = {
        create_chart = "Создать/изменить",
        crop_chart = "Обрезать",
        coming_soon = "В разработке",
        credits = "Кредиты"
    },

    error_msgs = {
        error = "Ошибка",
        unknown_error = "Произошла неизвестная ошибка!",
        no_chart_folder = "Необходимо выбрать папку чарта!",
        generate_mdm = {
            no_cover = "Вам нужна обложка чарта, чтобы сгенерировать MDM чарт.",
            no_info = "Вам нужен info.json, чтобы сгенерировать MDM чарт.",
            no_music = "Вам нужен файл музыки, чтобы сгенерировать MDM чарт.",
            no_demo = {
                title = "Внимание",
                desc = "Отсутсвует демо файл."
            },
            no_map = "Вам необходима хотя бы одна BMS карта, чтобы сгенерировать MDM чарт."
        },
        load_mdm = {
            no_musedash_path = "Вам нужно выбрать папку с Muse Dash, чтобы сохранять чарты!",
            cancel_packing = "Вам нужно сжать файлы, чтобы сохранить чарт."
        },
        crop_mode = {
            no_bms = "Не удалось открыть BMS карту! У чарта нет %s",
            no_crop_object = "Вы не добавили Crop object!",
            no_music = "У чарта нет файла музыки!",
            music_rename_fail = "Не удалось переименовать файл музыки!",
            music_crop_fail = "Не удалось обрезать файл музыки!",
            no_info = "info.json не найден!",
            chart_pack_fail = "Не удалось сжать MDM чарт!",
            chart_copy_fail = "Не удалось скопировать чарт!",
            chart_open_fail = "Не удалось открыть чарт!",
            chart_extract_fail = "Не удалось извлечь файлы из чарта!"
        },
        edit_mode = {
            offset_fail = "Не удалось оффсетнуть",
            open_fail = "Не удалось открыть",
            edit_fail = "Не удалось редактировать",
            packing_fail = "Не удалось сжать",
            generating_fail = "Не удалось сгенерировать",
            loading_fail = "Не удалось загрузить",
            cover_copy_fail = "Не удалось скопировать обложку!",
            demo_copy_fail = "Не удалось скопировать демо!",
            music_copy_fail = "Не удалось скопировать музыку!",
            video_copy_fail = "Не удалось скопировать видео!",
            info_find_fail = "Не удалось найти info.json!",
            info_read_fail = "Не удалось прочитать info.json!",
            file_find_fail = "Не удалось найти %s!",
            bms_read_fail = "Не удалось прочитать шаблон BMS файла!",
            no_file_found = "Не удалось найти %s в папке с чартом!",
            empty_chart_name = "Текущее название чарта пустое!",
            no_musedash_path = "Вам необходимо указать путь к папке Muse Dash!",
            no_cover = "Вам необходимо выбрать обложку!",
            no_demo = "Вам необходимо выбрать демо файл!",
            no_music = "Вам необходимо выбрать файл музыки!"
        }
    },

    info_msgs = {
        success = "Успешно",
        chart_pack_success = "Файлы чарта были успешно сжаты в MDM архив!",
        chart_load_success = "Чарт был успешно сохранен в папку Custom_Albums!",
        chart_crop_success = "Чарт был успешно обрезан. Теперь вы можете запустить MuseDash и попробовать.",
        chart_generate_success = "Файлы чарта были успешно сгенерированны!",
        no_musedash_path = {
            title = "Отсутсвует путь к Muse Dash",
            desc = "Путь к Muse Dash не выбран. Хотите выбрать сейчас?"
        },
        no_mdm = {
            title = "Отсутсвует MDM",
            desc = "В папке чарта нет MDM файла. Хотите сжать файлы?"
        },
        no_bms_editor = {
            title = "Отсутсвует BMS редактор",
            desc = "Путь к BMS редактору не выбран. Хотите выбрать сейчас?"
        },
        no_offset_editor = {
            title = "Отсутсвует программа для оффсета",
            desc = "Путь к редактору оффсета не выбран. Хотите выбрать сейчас?"
        },
        new_chart_folder = {
            title = "Внимание",
            desc = "Вы выбрали новую папку для чарта. Стереть все поля?"
        },
        cover_cropping = {
            title = "Обрезка обложки",
            desc = "Do you need to crop the Cover image in a circle?"
        },
        gif_cover_warning = {
            title = "Не удается обрезать GIF обложку",
            desc = "На данный момент отсутсвует поддержка обрезки анимированных обложек. Обложка не будет обрезана."
        }
    },

    file_select = {
        bms_editor = {
            title = "Выберите BMS редактор",
            filetype = "Исполняемый файл (*.exe)|*.exe"
        },
        offset_editor = {
            title = "Выберите программу для оффсета",
            filetype = "Исполняемый файл (*.exe)|*.exe"
        },
        demo = {
            title = "Выберите демо файл",
            filetype = "MP3 или OGG музыка|*.mp3;*.ogg"
        },
        music = {
            title = "Выберите файл с музыкой",
            filetype = "MP3 или OGG музыка|*.mp3;*.ogg"
        },
        cover = {
            title = "Выберите файл обложки",
            filetype = "PNG или GIF изображение|*.png;*.gif"
        },
        video = {
            title = "Выберите видео файл",
            filetype = "MP4 видео|*.mp4"
        }
    },

    status_bar = {
        idle = "> Готов",
        done = "> Готово!",
        packing_fail = "> Не удалось сжать!",
        generating_fail = "> Не удалось сгенерировать!",
        loading_fail = "> Не удалось загрузить!",
        checking_req_files = "> Проверяем необходимые файлы...",
        checking_dialog_files = "> Проверяет файлы диалогов...",
        checking_cinema_files = "> Проверяем файлы синемы...",
        checking_info_chars = "> Проверяем наличие недопустимых символов в info.json...",
        checking_mdm = "> Проверяем MDM...",
        loading_to_cam = "> Загружаем в Custom_Albums...",
        loading_files = "> Загружаем необходимые файлы...",
        loading_cinema_files = "> Загружаем файлы синемы...",
        loading_template_files = "> Загружаем шаблонные файлы...",
        loading_bms_files = "> Загружаем BMS файлы...",
        viewing_file = "> Просматриваем %s...",
        viewing_info = "> Просматриваем info.json...",
        compressing_mdm = "> Сжимаем в MDM...",
        offsetting = "> Оффсетим %s...",
        editing = "> Редактируем %s...",
        cropping_cover = "> Обрезаем обложку..."
    },

    menu_bar = {
        mdmc = {
            title = "MDMC",
            home = "Главная",
            upload = "Загрузить",
            charts = "Чарты",
            discord = "Дискорд",
            find_current_chart = "Найти текущий чарт"
        },
        program_select = {
            title = "Выбрать программы",
            bms = "BMS",
            offset = "Оффсет",
            musedash = "MuseDash"
        },
        help = "Помощь",
        exit = "Выход",
        run_musedash = "Запустить MuseDash",
        open = {
            title = "Открыть",
            chart_folder = "Папку с чартом",
            musedash_folder = "Папку MuseDash",
            info = "Инфо",
            cover = "Обложку"
        },
        offset = "Оффсет",
        edit_bms = "Редактировать BMS"
    },

    crop_mode = {
        chart_to_crop = "Чарт",
        select_chart_file = "Выбрать чарт",
        select_chart_win = {
            title = "Выберите чарт файл",
            filetype = "MDM чарт|*.mdm"
        },
        target_map = "Карта",
        save_to_musedash = "Сохранить",
        choose_map = "Выбрать карту",
        cropping_info = {
            title = "Обрезка",
            desc = [[Сейчас откроется редактор BMS. Найдите "%s: Crop object" и поставьте на любой лайн. Этот объект определяет откуда чарт будет начинаться.]]
        },
        crop_map = "Обрезать %s"
    },

    edit_mode = {
        generate_files = "Сгенерировать чарт",
        pack_files = "Сжать чарт в MDM",
        load_mdm = "Загрузить в Muse Dash",
        main_fields = "Основное",
        optional_fields = "Дополнительное",
        chart_folder = "Папка чарта",
        select_folder_info = "Выберите папку с чартом",
        select_folder = "Выбрать папку",
        name = {
            title = "Название",
            tooltip = "Название чарта"
        },
        artist = {
            title = "Автор",
            tooltip = "Исполнитель музыки"
        },
        charter = {
            title = "Чартер",
            tooltip = "Автор чарта"
        },
        scene = "Сцена",
        bpm = {
            title = "BPM",
            tooltip = "Кол-во ударов в минуту"
        },
        difficulty = {
            title = "Сложность",
            short = "Слож",
            tooltip = "Сложность чарта в звездах"
        },
        note_speed = "Скорость нот",
        demo = {
            title = "Демо",
            button = "Нажмите чтобы выбрать демо"
        },
        music = {
            title = "Музыка",
            button = "Нажмите чтобы выбрать музыку"
        },
        cover = {
            title = "Обложка",
            button = "Нажмите чтобы выбрать обложку"
        },
        name_romanized = {
            title = "Название латиницей",
            tooltip = "Название чарта (латиницей)",
        },
        video = {
            title = "Видео",
            button = "Нажмите чтобы выбрать видео"
        },
        video_opacity = {
            title = "Непрозрачность видео",
            tooltip = "Непрозрачность видео для синемы"
        },
        hide_bms_mode = "Режим скрытой BMS",
        hide_bms_msg = {
            title = "Текст скрытой BMS",
            tooltip = "Сообщение, которое выскакивает при разблокировке скрытой сложности"
        },
        other_maps = {
            add = "Да",
            skip = "Нет"
        },
        search_tags = {
            title = "Теги поиска",
            tooltip = "Теги разделяются запятой (тег1, тег2, ...)"
        },
        scene_egg = "Пасхалки"
    }

}