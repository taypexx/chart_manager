return {

    startbgcolor = 0x2f2f2f,
    bgcolor = 0x37262c,--0x76103b,
    font = "Calibri",
    github = "https://github.com/taypexx/chart_manager/",
    yt = "https://youtube.com/channel/UCrmB0yne92J9C042I8-Qy9g/",
    discord = "https://discord.gg/mdmc",
    bms_crop_value = "3I",

    discordapp = "1158821309556457536",
    discordRPC = {
        details = "Template",
        state = "Idle",
        startTimestamp = os.time(),
        largeImageKey = "icon",
        largeImageText = "",
        smallImageKey = "",
    },
    discordRPC_states = {
        ["create"] = {
            state = "Creating",
            smallImageKey = "",
        },
        ["offset"] = {
            state = "Offsetting %s",
            smallImageKey = "offset",
        },
        ["bms"] = {
            state = "Editing %s",
            smallImageKey = "bms",
        },
    },

}