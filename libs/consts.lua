return {

    bgcolor = 0x0d1f30,
    font = "Calibri",
    github = "https://github.com/taypexx/chart_manager/",

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