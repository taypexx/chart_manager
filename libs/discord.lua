local consts = require("libs.consts")
local rpc = require("libs.discordrpc")
local discord = {}

local presence

local function act(code)
    sys.cmd(string.format([[""%s\luvit" -e "%s"]],sys.currentdir,code))
end

function discord.updateRPC()
    rpc.updatePresence(presence)
    rpc.runCallbacks()
end

function discord.setState(state,fmt)
    local values = consts.discordRPC_states[state]
    if not values then return end

    for k,v in pairs(values) do
        if k == "state" and fmt then
            v = string.format(v,fmt)
        end
        presence[k] = v
    end

    discord.updateRPC()
end

function discord.setChartInfo(info)
    if info.chartname == "" then
        info.chartname = "Template"
    end
    if info.author == "" then
        info.author = "Unknown Artist"
    end
    if info.charter == "" then
        info.charter = "Unknown Charter"
    end
    presence.details = string.format("%s - %s",info.chartname,info.author)
    presence.largeImageText = string.format("Charter: %s | BPM: %s",info.charter,info.bpm)

    discord.updateRPC()
end

function discord.initRPC()
    --act("require([[ffi]])")
    presence = consts.discordRPC
    presence.startTimestamp = os.time()
    rpc.initialize(consts.discordapp, true)
    discord.updateRPC()
end

function discord.shutdownRPC()
    rpc.shutdown()
end

function rpc.ready(userId, username, discriminator, avatar)
    print(string.format("Discord: ready (%s, %s, %s, %s)", userId, username, discriminator, avatar))
end

function rpc.disconnected(errorCode, message)
    print(string.format("Discord: disconnected (%d: %s)", errorCode, message))
end

function rpc.errored(errorCode, message)
    print(string.format("Discord: error (%d: %s)", errorCode, message))
end

return discord