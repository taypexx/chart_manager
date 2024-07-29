--Author: @darnocz

return {

    main = {
        help = "Ayuda",
        discord = "Discord",
        mdmc = "MDMC",
        github = "Github"
    },

    new_version = {
        title = "Nueva versión disponible",
        desc = "Una nueva versión de la aplicación está disponible (v%s). ¿Deseas descargarla?",
    },

    prompt_musedash = {
        win = {
            title = "Seleccionar MuseDash.exe",
            filetype = "Archivo ejecutable (*.exe)|*.exe"
        },
        popup = {
            title = "MuseDash.exe encontrado",
            desc = "Se ha encontrado una ruta de instalación de Muse Dash en:\n%s\n¿Deseas usarla?"
        }
    },

    welcome_win = {
        create_chart = "Crear/editar chart",
        crop_chart = "Acortar chart",
        coming_soon = "Próximamente",
        credits = "Créditos"
    },

    error_msgs = {
        error = "Error",
        unknown_error = "¡Ha ocurrido un error desconocido!",
        no_chart_folder = "¡Necesitas seleccionar la carpeta del chart!",
        generate_mdm = {
            no_cover = "Necesitas una miniatura para generar el archivo MDM.",
            no_info = "Necesitas el archivo info.json para generar el archivo MDM.",
            no_music = "Necesitas una canción para generar el archivo MDM.",
            no_demo = {
                title = "Advertencia",
                desc = "El audio de demonstración del chart no existe."
            },
            no_map = "Necesitas al menos un mapa .bms para generar el archivo MDM"
        },
        load_mdm = {
            no_musedash_path = "¡Necesitas especificar la ruta de instalación de Muse Dash para guardar archivos MDM!",
            cancel_packing = "Debes comprimir los archivos para guardarlos"
        },
        crop_mode = {
            no_bms = "Error al abrir el mapa bms! Este chart no posee %s",
            no_crop_object = "¡No has añadido un objeto de Recorte!",
            no_music = "¡El chart no posee un archivo de música!",
            music_rename_fail = "¡Error al renombrar el archivo de música!",
            music_crop_fail = "¡No se ha podido acortar la canción!",
            no_info = "¡No se ha encontrado el archivo info.json!",
            chart_pack_fail = "¡No se ha podido comprimir el archivo MDM!",
            chart_copy_fail = "¡No se ha podido copiar el chart!",
            chart_open_fail = "¡No se ha podido abrir el chart!",
            chart_extract_fail = "¡No se han podido extraer los contenidos del chart!"
        },
        edit_mode = {
            offset_fail = "No se ha podido aplicar el offset",
            open_fail = "No se ha podido abrir",
            edit_fail = "No se ha podido editar",
            packing_fail = "No se ha podido comprimir",
            generating_fail = "No se ha podido generar",
            loading_fail = "No se ha podido cargar",
            cover_copy_fail = "¡No se ha podido copiar la miniatura!",
            demo_copy_fail = "¡No se ha podido copiar el audio de demostración!",
            music_copy_fail = "¡No se ha podido copiar el audio de la música!",
            video_copy_fail = "¡No se ha podido copiar el video de fondo (cinema)!",
            info_find_fail = "¡No se ha podido encontrar el archivo info.json!",
            info_read_fail = "¡No se ha podido leer el archivo info.json!",
            file_find_fail = "¡No se ha podido encontrar %s!",
            bms_read_fail = "¡No se ha podido leer la plantilla para el archivo BMS!",
            no_file_found = "¡No se ha encontrado el archivo %s en la carpeta del chart!",
            empty_chart_name = "¡El nombre del chart está vacío!",
            no_musedash_path = "¡Debes seleccionar la ruta de instalación de Muse Dash!",
            no_cover = "¡Debes seleccionar una miniatura!",
            no_demo = "¡Debes seleccionar un audio de demostración!",
            no_music = "¡Debes seleccionar el audio de la canción!"
        }
    },

    info_msgs = {
        success = "Éxito",
        chart_pack_success = "¡Se han comprimido el archivo MDM con éxito!",
        chart_load_success = "¡Se ha guardado el chart en la carpeta Custom_Albums con éxito!",
        chart_crop_success = "Se ha acortado el chart con éxito. Ahora puedes jugar la versión más corta.",
        chart_generate_success = "¡Se han generado los archivos del chart con éxito!",
        no_musedash_path = {
            title = "Ruta de instalación no especificada",
            desc = "No se ha seleccionado la ruta de instalación de Muse Dash. ¿Deseas seleccionarla?"
        },
        no_mdm = {
            title = "MDM no encontrado",
            desc = "No se ha encontrado el archivo MDM en la carpeta de charts. ¿Deseas comprimir los archivos?"
        },
        no_bms_editor = {
            title = "Editor de BMS no encontrado",
            desc = "No has seleccionado un editor de archivos BMS. ¿Deseas hacerlo?"
        },
        no_offset_editor = {
            title = "Aplición para offset no encontrado",
            desc = "No has seleccionado una aplicación para ajustar el offset de la música. ¿Deseas hacerlo?"
        },
        new_chart_folder = {
            title = "Advertencia",
            desc = "Has seleccionado la carpeta de un nuevo chart. ¿Eliminar todos los campos anteriores?"
        },
        cover_cropping = {
            title = "Recorte de miniatura",
            desc = "¿Necesitas recortar la imagen de miniatura en un círculo?",
        },
        gif_cover_warning = {
            title = "No se puede recortar GIF",
            desc = "Por el momento, no es posible recortar miniaturas en formato GIF. No se realizaron cambios."
        }
    },

    file_select = {
        bms_editor = {
            title = "Seleccionar editor de BMS",
            filetype = "Archivo ejecutable (*.exe)|*.exe"
        },
        offset_editor = {
            title = "Seleccionar editor de offset",
            filetype = "Archivo ejecutable (*.exe)|*.exe"
        },
        demo = {
            title = "Seleccionar audio de demostración",
            filetype = "Música MP3 u OGG|*.mp3;*.ogg"
        },
        music = {
            title = "Seleccionar audio de música",
            filetype = "Música MP3 u OGG|*.mp3;*.ogg"
        },
        cover = {
            title = "Seleccionar imagen de miniatura",
            filetype = "Imagen PNG o GIF|*.png;*.gif"
        },
        video = {
            title = "Seleccionar video de fondo (cinema)",
            filetype = "Video MP4|*.mp4"
        }
    },

    status_bar = {
        idle = "> En reposo",
        done = "> ¡Listo!",
        packing_fail = "> ¡No se pudo comprimir!",
        generating_fail = "> ¡No se pudo generar!",
        loading_fail = "> ¡No se pudo cargar!",
        checking_req_files = "> Verificando archivos necesarios...",
        checking_dialog_files = "> Verificando archivos de diálogo...",
        checking_cinema_files = "> Verificando archivos de cinema",
        checking_info_chars = "> Buscando caracteres prohibidos en info.json...",
        checking_mdm = "> Verificando archivo MDM...",
        loading_to_cam = "> Cargando ruta de Custom_Albums...",
        loading_files = "> Cargando archivos seleccionados...",
        loading_cinema_files = "> Cargando archivos de cinema...",
        loading_template_files = "> Cargando archivos de plantilla...",
        loading_bms_files = "> Cargando archivos BMS...",
        viewing_file = "> Revisando %s...",
        viewing_info = "> Revisando info.json...",
        compressing_mdm = "> Comprimiendo en archivo MDM...",
        offsetting = "> Aplicando offset a %s...",
        editing = "> Editando %s...",
        cropping_cover = "> Recortando miniatura..."
    },

    menu_bar = {
        mdmc = {
            title = "MDMC",
            home = "Menú",
            upload = "Publicar",
            charts = "Charts",
            discord = "Discord",
            find_current_chart = "Buscar chart actual"
        },
        program_select = {
            title = "Aplicaciones",
            bms = "BMS",
            offset = "Offset",
            musedash = "MuseDash"
        },
        help = "Ayuda",
        exit = "Salir",
        run_musedash = "Ejecutar MuseDash",
        open = {
            title = "Abrir",
            chart_folder = "Carpeta de Charts",
            musedash_folder = "Carpeta de MuseDash",
            info = "info",
            cover = "Miniatura"
        },
        offset = "Offset",
        edit_bms = "Editar BMS"
    },

    crop_mode = {
        chart_to_crop = "Chart a acortar",
        select_chart_file = "Selecciona un chart",
        select_chart_win = {
            title = "Selecciona el archivo del chart",
            filetype = "Chart MDM|*.mdm"
        },
        target_map = "Mapa deseado",
        save_to_musedash = "Guardar a MuseDash",
        choose_map = "Selecciona el mapa",
        cropping_info = {
            title = "Acortar",
            desc = [[El editor de BMS se abrirá. Busca el objeto "%s: Crop object" y colócalo en cualquier línea. Esto determina dónde se acortará el chart.]]
        },
        crop_map = "Acortar %s"
    },

    edit_mode = {
        generate_files = "Generar chart",
        pack_files = "Comprimir a MDM",
        load_mdm = "Cargar en Muse Dash",
        main_fields = "Campos requeridos",
        optional_fields = "Campos opcionales",
        chart_folder = "Carpeta del chart",
        select_folder_info = "Seleccionar carpeta del chart",
        select_folder = "Seleccionar carpeta",
        name = {
            title = "Nombre",
            tooltip = "Nombre del chart"
        },
        artist = {
            title = "Artista",
            tooltip = "Autor de la canción"
        },
        charter = {
            title = "Charter",
            tooltip = "Autor del chart"
        },
        scene = "Escena",
        bpm = {
            title = "BPM",
            tooltip = "Pulsos por minuto de la canción"
        },
        difficulty = {
            title = "Dificultad",
            short = "Dif.",
            tooltip = "Dificultad del chart, en estrellas"
        },
        note_speed = "Velocidad",
        demo = {
            title = "Demo",
            button = "Seleccionar un audio de demostración"
        },
        music = {
            title = "Música",
            button = "Seleccionar la música"
        },
        cover = {
            title = "Miniatura",
            button = "Escoger una imagen de miniatura"
        },
        name_romanized = {
            title = "Nombre romanizado",
            tooltip = "Nombre de chart, pero romanizado",
        },
        video = {
            title = "Video",
            button = "Escoger un video de fondo"
        },
        video_opacity = {
            title = "Opacidad de Video",
            tooltip = "Opacidad del video de fondo (cinema)"
        },
        hide_bms_mode = "Modo Oculto",
        hide_bms_msg = {
            title = "Mensaje Oculto",
            tooltip = "Mensaje que aparece al desbloquear la dificultad oculta"
        },
        other_maps = {
            add = "Añadir",
            skip = "Saltar"
        },
        search_tags = {
            title = "Tags de búsqueda",
            tooltip = "Las tags (etiquetas) van separadas por comas (etiqueta1, etiqueta2, ...)"
        },
        scene_egg = "Variante de Escena"
    }

}