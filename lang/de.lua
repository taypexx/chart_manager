--Author: @buny154

return {

    main = {
        help = "Hilfe",
        discord = "Discord",
        mdmc = "MDMC",
        github = "Github"
    },

    new_version = {
        title = "Neue Version verfügbar",
        desc = "Ein neues Update ist verfügbar (v%s). Herunterladen?"
    },

    prompt_musedash = {
        win = {
            title = "MuseDash.exe auswählen",
            filetype = "Ausführbare Datei (*.exe)|*.exe"
        },
        popup = {
            title = "MuseDash.exe gefunden",
            desc = "Ein Pfad für Muse Dash wurde gefunden:\n%s\nDiesen Pfad verwenden?"
        }
    },

    welcome_win = {
        create_chart = "Chart erstellen/bearbeiten",
        crop_chart = "Chart zuschneiden",
        coming_soon = "Demnächst verfügbar!",
        credits = "Credits"
    },

    error_msgs = {
        error = "Fehler",
        unknown_error = "Ein unbekannter Fehler ist aufgetreten!",
        no_chart_folder = "Keinen Chart-Ordner ausgewählt!",
        generate_mdm = {
            no_cover = "MDM-Datei kann nicht erstellt werden: Titelbild fehlt!",
            no_info = "MDM-Datei kann nicht erstellt werden: info.json fehlt!",
            no_music = "MDM-Datei kann nicht erstellt werden: Musikdatei fehlt!",
            no_demo = {
                title = "Achtung",
                desc = "Demo-Datei fehlt. Chart wird keine Musik im Auswahlmenü abspielen."
            },
            no_map = "Mindestens eine BMS-Datei muss vorhanden sein um MDM-Datei zu erstellen!"
        },
        load_mdm = {
            no_musedash_path = "Muse Dash Pfad muss angegeben werden um MDM-Datei zu speichern.",
            cancel_packing = "Dateien müssen gepackt werden zum speichern."
        },
        crop_mode = {
            no_bms = "Fehler beim öffnen der BMS-Datei: %s fehlt.",
			no_crop_object = "Es wurde kein Zuschneide-Objekt platziert!",
            no_music = "Musikdatei fehlt.",
            music_rename_fail = "Umbenennen der Musikdatei fehlgeschlagen.",
            music_crop_fail = "Zuschneiden der Musikdatei fehlgeschlagen.",
            no_info = "info.json Datei fehlt.",
            chart_pack_fail = "Packen der MDM-Datei fehlgeschlagen.",
            chart_copy_fail = "Kopieren der Chart fehlgeschlagen.",
            chart_open_fail = "Öffnen der Chart fehlgeschlagen.",
            chart_extract_fail = "Entpacken der MDM-Datei fehlgeschlagen."
        },
        edit_mode = {
            offset_fail = "Offset Setzen fehlgeschlagen.",
            open_fail = "Öffnen fehlgeschlagen.",
            edit_fail = "Bearbeiten fehlgeschlagen.",
            packing_fail = "Packen fehlgeschlagen.",
            generating_fail = "Erstellen fehlgeschlagen.",
            loading_fail = "Laden fehlgeschlagen.",
            cover_copy_fail = "Kopieren des Titelbildes fehlgeschlagen.",
            demo_copy_fail = "Kopieren der Demo-Datei fehlgeschlagen.",
            music_copy_fail = "Kopieren der Musikdatei fehlgeschlagen.",
            video_copy_fail = "Kopieren der Videodatei fehlgeschlagen.",
            info_find_fail = "info.json Datei nicht gefunden.",
            info_read_fail = "Lesen der info.json Datei fehlgeschlagen.",
            file_find_fail = "%s Datei nicht gefunden.",
            bms_read_fail = "Lesen der BMS-Datei fehlgeschlagen.",
            no_file_found = "%s Datei nicht gefunden im Chart-Ordner.",
            empty_chart_name = "Keinen Chart-Namen festgesetzt.",
            no_musedash_path = "Muse Dash Pfad muss angegeben werden.",
            no_cover = "Ein Titelbild muss ausgewählt werden.",
            no_demo = "Eine Demo-Datei muss ausgewählt werden.",
            no_music = "Eine Musikdatei muss ausgewählt werden."
        }
    },

    info_msgs = {
        success = "Vorgang abgeschlossen",
        chart_pack_success = "Chart-Dateien wurden erfolgreich als MDM gepackt.",
        chart_load_success = "MDM-Datei erfolgreich im Custom_Albums Ordner gespeichert.",
        chart_crop_success = "Chart erfolgreich zugeschnitten. Die geschnittene Version kann nun in MuseDash gespielt werden.",
        chart_generate_success = "Chart-Dateien erfolgreich erstellt.",
        no_musedash_path = {
            title = "Muse Dash Pfad",
            desc = "Muse Dash Pfad nicht angegeben. Jetzt angeben?"
        },
        no_mdm = {
            title = "MDM nicht gefunden",
            desc = "Es wurden keine MDM-Datei im Chart Ordner gefunden. Dateien jetzt als MDM verpacken?"
        },
        no_bms_editor = {
            title = "BMS Editor nicht gefunden",
            desc = "BMS Editor Anwendung wurde noch nicht ausgewählt. Jetzt auswählen?"
        },
        no_offset_editor = {
            title = "Anwendung zum Offset Setzen nicht gefunden",
            desc = "Anwendung zum Offset Setzen wurde noch nicht ausgewählt. Jetzt auswählen?"
        },
        new_chart_folder = {
            title = "Achtung",
            desc = "Ein neuer Chart Ordner wurde ausgewählt. Alle vorherigen Felder zurücksetzen?"
        },
        cover_cropping = {
            title = "Titelbild zuschneiden",
            desc = "Titelbild kann jetzt automatisch zu einem Kreis zugeschnitten werden. Vorgang ausführen?"
        },
        gif_cover_warning = {
            title = "GIF-Datei",
            desc = "Das Zuschneiden von GIF-Dateien wird zurzeit nicht unterstützt. Titelbild kann nicht automatisch zugeschnitten werden."
        }
    },

    file_select = {
        bms_editor = {
            title = "BMS Editor Anwendung auswählen",
            filetype = "Ausführbare Datei (*.exe)|*.exe"
        },
        offset_editor = {
            title = "Anwendung zum Offset Setzen auswählen",
            filetype = "Ausführbare Datei (*.exe)|*.exe"
        },
        demo = {
            title = "Demo-Datei auswählen",
            filetype = "MP3 oder OGG music|*.mp3;*.ogg"
        },
        music = {
            title = "Musikdatei auswählen",
            filetype = "MP3 oder OGG music|*.mp3;*.ogg"
        },
        cover = {
            title = "Titelbild auswählen",
            filetype = "PNG oder GIF image|*.png;*.gif"
        },
        video = {
            title = "Videodatei auswählen",
            filetype = "MP4 video|*.mp4"
        }
    },

    status_bar = {
        idle = "> Leerlauf",
        done = "> Fertig!",
        packing_fail = "> Packen fehlgeschlagen!",
        generating_fail = "> erstellen fehlgeschlagen!",
        loading_fail = "> Laden fehlgeschlagen!",
        checking_req_files = "> Schaue nach erforderliche Dateien...",
        checking_dialog_files = "> Schaue nach Dialogdateien...",
        checking_cinema_files = "> Schaue nach Videodateien...",
        checking_info_chars = "> Prüfe auf unerlaubte Charaktere in info.json...",
        checking_mdm = "> Überprüfe nach MDM...",
        loading_to_cam = "> Lade Custom_Albums Pfad...",
        loading_files = "> Lade ausgewählte Dateien...",
        loading_cinema_files = "> Lade Videodateien...",
        loading_template_files = "> Lade Vorlagen...",
        loading_bms_files = "> Lade BMS-Dateien...",
        viewing_file = "> Besichtige %s...",
        viewing_info = "> Besichtige info.json...",
        compressing_mdm = "> Packe als MDM...",
        offsetting = "> Setze Offset für %s...",
        editing = "> Bearbeite %s...",
        cropping_cover = "> Schneide Titelbild zu..."
    },

    menu_bar = {
        mdmc = {
            title = "MDMC",
            home = "Startseite",
            upload = "Hochladen",
            charts = "Charts",
            discord = "Discord",
            find_current_chart = "Nach diesem Chart suchen"
        },
        program_select = {
            title = "Anwendungen auswählen",
            bms = "BMS",
            offset = "Offset",
            musedash = "MuseDash"
        },
        help = "Hilfe",
        exit = "Schließen",
        run_musedash = "MuseDash Starten",
        open = {
            title = "Öffnen",
            chart_folder = "Chart-Ordner",
            musedash_folder = "MuseDash Ordner",
            info = "info",
            cover = "Titelbild"
        },
        offset = "Offset",
        edit_bms = "BMS-Datei bearbeiten"
    },

    crop_mode = {
        chart_to_crop = "Chart zum zuschneiden",
        select_chart_file = "Chart auswählen",
        select_chart_win = {
            title = "Chart auswählen",
            filetype = "MDM chart|*.mdm"
        },
        target_map = "Ziel-Map",
        save_to_musedash = "Nach MuseDash speichern",
        choose_map = "Map auswählen",
        cropping_info = {
            title = "Zuschneiden",
            desc = "Öffnet den BMS Editor. Im Editor, platziere ein \"%s: Crop object\" an einer gewünschten Stelle. Die Map wird dann an dieser Stelle geschnitten."
        },
        crop_map = "%s zuschneiden"
    },

    edit_mode = {
        generate_files = "Chart-Dateien erstellen",
        pack_files = "Dateien als MDM packen",
        load_mdm = "MDM in Muse Dash laden",
        main_fields = "Erforderliche Felder",
        optional_fields = "Zusätzliche Felder",
        chart_folder = "Chart-Ordner",
        select_folder_info = "Chart-Ordner auswählen",
        select_folder = "Klicken zum auswählen",
        name = {
            title = "Name",
            tooltip = "Songtitel"
        },
        artist = {
            title = "Artist",
            tooltip = "Autor des Songs"
        },
        charter = {
            title = "Charter",
            tooltip = "Autor des Charts"
        },
        scene = "Szene",
        bpm = {
            title = "BPM",
            tooltip = "Songtempo in \"Beats pro Minute\""
        },
        difficulty = {
            title = "Schwierigkeit",
            short = "Diff",
            tooltip = "Schwierigkeitsgrad des Charts in Sternchen"
        },
        note_speed = "Notengeschwindigkeit",
        demo = {
            title = "Demo",
            button = "Klicken zum auswählen"
        },
        music = {
            title = "Musik",
            button = "Klicken zum auswählen"
        },
        cover = {
            title = "Titelbild",
            button = "Klicken zum auswählen"
        },
        name_romanized = {
            title = "Name romanisiert",
            tooltip = "Songtitel (romanisiert)",
        },
        video = {
            title = "Video",
            button = "Klicken zum auswählen"
        },
        video_opacity = {
            title = "Video Opazität",
            tooltip = "Opazität für Video festlegen"
        },
        hide_bms_mode = "Versteckte BMS",
        hide_bms_msg = {
            title = "Versteckte BMS Nachricht",
            tooltip = "Eine Nachricht die erscheint wenn eine versteckt Schwierigkeitsgrad freigeschaltet wird"
        },
        other_maps = {
            add = "Hinzufügen",
            skip = "Überspringen"
        },
        search_tags = {
            title = "Suchbegriffe",
            tooltip = "Begriffe mit einem Komma trennen (Begriff1, Begriff2, ...)"
        },
        scene_egg = "Alternative Szenentexturen"
    }

}