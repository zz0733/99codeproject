--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--messagebox业务预定义，包含业务字符串和回调方法
--endregion

--region 预定义回调业务
--注意 必须定义在PreStringBizEX上面，否则因为初始化顺序问题，PreStringBizEX中方法引用会报错
local PreDefineCallBackEX = {
    --充值
    CB_RECHARGE = function()
        if not GameListManager.getInstance():getGameSwitch(G_CONSTANTS.GAMESWITCH.RECHARGE) then
            SLFacade:dispatchCustomEvent(Public_Events.MSG_SHOW_SHOP)
        end
    end,

    -- 拉回房间
    CB_BACKROOM = function()
        local serverID = PlayerInfo.getInstance():getTargetServerID()
        local room = GameListManager.getInstance():getClientGameByServerId(serverID)
        if next(room) and room.wKindID > 0 then
            local _event = {
                name = Hall_Events.MSG_HALL_CLICKED_GAME,
                packet = room,
            }
            SLFacade:dispatchCustomEvent(Hall_Events.GAMELIST_CLICKED_GAME, _event)
        end
    end,

    -- 申请上庄
    CB_REQUESTBANKER = function()
        SLFacade:dispatchCustomEvent(Public_Events.MSG_COMFIRM_REQUEST_BANKER, nil)
    end,

    -- 捕鱼体验房提示
    CB_FISHEXPROOMTIP = function()
        SLFacade:dispatchCustomEvent(Public_Events.MSG_FISH_CLOSE, "fish-recharge")
    end,

    -- 退出游戏
    CB_EXITROOM = function()
        SLFacade:dispatchCustomEvent(Public_Events.MSG_GAME_EXIT)
    end,

    -- 退到选桌
    CB_EXITTOTABLE = function()
        SLFacade:dispatchCustomEvent(Public_Events.MSG_GAME_TO_TABLE)
    end,

    -- 体验房提示
    CB_EXPERIENCE_TIP_CLOSE = function()
        PlayerInfo.getInstance():setExperienceTime(G_CONSTANTS.EXPERIENCE_TIP_TIME+1)
    end,
    CB_EXPERIENCE_TIP = function()
        SLFacade:dispatchCustomEvent(Public_Events.MSG_GAME_EXIT)
        SLFacade:dispatchCustomEvent(Public_Events.MSG_GAME_TABLE_EXIT)
        SLFacade:dispatchCustomEvent(Public_Events.MSG_FISH_CLOSE)
        cc.UserDefault:getInstance():setBoolForKey("fish-recharge", true)
        PlayerInfo.getInstance():setExperienceTime(G_CONSTANTS.EXPERIENCE_TIP_TIME+1)
    end,

    -- 退出体验房
    CB_EXIT_EXPERIENCE_ROOM = function()
        SLFacade:dispatchCustomEvent(Public_Events.MSG_GAME_EXIT)
        SLFacade:dispatchCustomEvent(Public_Events.MSG_FISH_CLOSE)
    end,
}
--endregion

--region 预定义字符串业务
-- 此处配置自定义业务的字符串
-- ["xxxxxxxx"] 自定义业务字符串
-- ViewStr 返回实际显示的字符串
-- CB_Ok 点击确定回调
-- CB_Close 点击关闭回调
-- CB_Timeout 超时回调
-- NoAutoClose 是否自动关闭窗口，如果是父窗口先被销毁情况下，这里置true

--不使用预定义字符串业务，由各个游戏自己维护文本信息和业务调用
--[[
local PreStringBizEX = {
    ["message-box"] = --提示充值
    {
        ViewStr = function() return LuaUtils.getLocalString("STRING_050") end,
        CB_Ok = PreDefineCallBackEX.CB_RECHARGE,
    },

    ["message-box2"] = --提升vip
    {
        ViewStr = function() return LuaUtils.getLocalString("CHAT_7_1") end,
        CB_Ok = PreDefineCallBackEX.CB_RECHARGE,
    },

    ["message-box3"] = --提示充值
    {
        ViewStr = function() return LuaUtils.getLocalString("STRING_059") end,
        CB_Ok = PreDefineCallBackEX.CB_RECHARGE,
    },

    ["message-box7"] = --提示是否确认上庄
    {
        ViewStr = function() return LuaUtils.getLocalString("STRING_223") end,
        CB_Ok = PreDefineCallBackEX.CB_REQUESTBANKER,
    },

    ["message-box4"] = --提示转账额度不足
    {
        ViewStr = function() return LuaUtils.getLocalString("STRING_052") end,
        CB_Ok = PreDefineCallBackEX.CB_RECHARGE,
        NoClean = true,
    },

    ["message-box5"] = --提示充值（不清除）
    {
        ViewStr = function() return LuaUtils.getLocalString("STRING_051") end,
        CB_Ok = PreDefineCallBackEX.CB_RECHARGE,
        NoClean = true,
    },

    ["message-box-kick-user"] = 
    {
        ViewStr = function() return tostring("您还在其他游戏等级场中，是否立刻重回该游戏？") end,
        CB_Ok = PreDefineCallBackEX.CB_BACKROOM,
        NoClean = true,
    },

    ["game-exit-1"] = 
    {
        ViewStr = function() return LuaUtils.getLocalString("MESSAGE_10") end,
        CB_Ok = PreDefineCallBackEX.CB_EXITROOM,
    },
    ["game-exit-2"] = 
    {
        ViewStr = function() return LuaUtils.getLocalString("MESSAGE_22") end,
        CB_Ok = PreDefineCallBackEX.CB_EXITROOM,
    },
    ["game-exit-3"] = 
    {
        ViewStr = function() return LuaUtils.getLocalString("MESSAGE_18") end,
        CB_Ok = PreDefineCallBackEX.CB_EXITROOM,
    },
    ["game-exit-4"] = 
    {
        ViewStr = function() return LuaUtils.getLocalString("MESSAGE_22") end,
        CB_Ok = PreDefineCallBackEX.CB_EXITTOTABLE, --退选桌
    },
    ["experience-tips-1"] = 
    {
        ViewStr = function() return LuaUtils.getLocalString("EXPERIENCE_TIPS_1") end,
        CB_Ok = PreDefineCallBackEX.CB_EXPERIENCE_TIP,
        CB_Close =  PreDefineCallBackEX.CB_EXPERIENCE_TIP_CLOSE,
        NoAutoClose = true,
    },
    ["experience-tips-2"] = 
    {
        ViewStr = function() return LuaUtils.getLocalString("EXPERIENCE_TIPS_2") end,
        CB_Ok = PreDefineCallBackEX.CB_EXPERIENCE_TIP,
        CB_Close =  PreDefineCallBackEX.CB_EXPERIENCE_TIP_CLOSE,
        NoAutoClose = true,
    },
    ["experience-room-exit"] = 
    {
        ViewStr = function() return LuaUtils.getLocalString("EXPERIENCE_EXIT") end,
        CB_Ok = PreDefineCallBackEX.CB_EXIT_EXPERIENCE_ROOM,
        NoAutoClose = true,
        NoAutoClose = true,
    },
}
]]--
--endregion

local MsgBoxPreBiz = 
{
    --PreStringBiz = PreStringBizEX,
    PreDefineCallBack = PreDefineCallBackEX
}

return MsgBoxPreBiz