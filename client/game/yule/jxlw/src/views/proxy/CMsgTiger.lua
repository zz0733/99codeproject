--region CMsgTiger.lua
--Date 2017.11.10
--Auther JackyXu.
--Desc 水果老虎机网络消息收发类.

local module_pre = "game.yule.jxlw.src.views"

local TigerDataMgr      = require(module_pre..".manager.TigerDataMgr")
local Tiger_Events      = require(module_pre..".manager.Tiger_Events")
local Tiger_Define      = require(module_pre..".scene.Tiger_Define")
local TigerConst        = require(module_pre..".scene.Tiger_Const")

local Public_Events = cc.exports.Public_Events
local SLFacade      = cc.exports.SLFacade
local Player        = cc.exports.PlayerInfo
local function LOG_PRINT(...) if true then printf(...) end end
local function MSG_PRINT(...) if true then printf(...) end end

local CMsgTiger = class("CMsgTiger")--, require("common.app.CMsgGame"))

CMsgTiger.instance_ = nil
function CMsgTiger:getInstance()
    if CMsgTiger.instance_ == nil then
        CMsgTiger.instance_ = CMsgTiger.new()
    end
    return CMsgTiger.instance_
end
function CMsgTiger:ctor()

    self.func_game_ =
        {
            [G_C_CMD.MDM_GF_FRAME] = {              --100-场景信息（覆盖）
                                        [G_C_CMD.SUB_GF_GAME_SCENE]         = { func = self.process_game_scene,       log = "场景信息", debug = true, },  --101
                                    },

            [G_C_CMD.TIGER_MDM_GF_GAME] = {     -- 游戏命令
                                                --服务器命令结构
                                                [G_C_CMD.SUB_S_GAME_START]         = { func = self.process_game_start,       log = "游戏开始", debug = true, },
                                                [G_C_CMD.SUP_S_GAME_END]           = { func = self.process_game_gameEnd,     log = "游戏结束", debug = true, },
                                                [G_C_CMD.SUP_S_FREE_TIMES]         = { func = self.process_game_freeTimes,   log = "免费次数", debug = true, },
                                                [G_C_CMD.SUP_S_EXTRA_TIMES]        = { func = self.process_game_extraTimes,  log = "额外倍数", debug = true, },
                                                [G_C_CMD.SUP_S_WIN_GOLD_SCORE]     = { func = self.process_game_winScore,    log = "赢取彩金", debug = true, },
                                                [G_C_CMD.SUP_S_LIB_GOLD_SCORE]     = { func = self.process_game_libScore,    log = "彩金库的", debug = true, },
                                                [G_C_CMD.SUP_S_ERROR]              = { func = self.process_game_error,       log = "错误信息", debug = true, },
                                                [G_C_CMD.SUP_S_SERVER_MESSAGE]     = { func = self.process_game_serverMsg,   log = "系统消息", debug = true, },
                                                [G_C_CMD.SUP_S_TP_MESSAGE_INFO]    = { func = self.process_game_topPrizeMsg,   log = "大奖消息", debug = true, },
                                            },
        }
end

----------------- 覆盖处理 start --------------------------------
function CMsgTiger:process_game_scene(__data) --100-101-场景消息
    
	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.llJetton = _buffer:readLongLong()
    msg.llGoldScore = _buffer:readLongLong()
    msg.cbLineIndex = _buffer:readUChar()
    msg.cbJettonIndex = _buffer:readUChar()
    msg.iFreeTimes = _buffer:readInt()

    --保存
    TigerDataMgr:getInstance():setMinBetNum(msg.llJetton)
    TigerDataMgr:getInstance():setPrizePool(msg.llGoldScore)
    TigerDataMgr:getInstance():setLineNum(msg.cbLineIndex)
    TigerDataMgr:getInstance():setBetNumIndex(msg.cbJettonIndex)
    TigerDataMgr:getInstance():setTigerState(TigerConst.GAME_TIGER_FREE)
    TigerDataMgr:getInstance():setIsAuto(false)
    TigerDataMgr:getInstance():setIsShowLine(true)
    TigerDataMgr:getInstance():setFreeTimes(msg.iFreeTimes)
    TigerDataMgr:getInstance():resetGameResult()
        
    --日志
    LOG_PRINT("场景消息：")
    LOG_PRINT("llJetton: %d", msg.llJetton)
    LOG_PRINT("llGoldScore: %d", msg.llGoldScore)
    LOG_PRINT("cbLineIndex: %d", msg.cbLineIndex)
    LOG_PRINT("cbJettonIndex: %d", msg.cbJettonIndex)
    LOG_PRINT("iFreeTimes: %d", msg.iFreeTimes)

    --通知
    self:enterGameScene()
end
------------------ 覆盖处理 end -----------------------------------

function CMsgTiger:process_game_start(__data) --200-200-游戏开始
    local _buffer = __data:readData(__data:getReadableSize())

    -- long long llResult;
    -- uint8 cbCardIndex[CARD_INDEX];

    -- 数据
    local msg = {}
    msg.llResult = _buffer:readLongLong()
    msg.cbCardIndex = {}
    for i=1, TigerConst.CARD_INDEX do
        msg.cbCardIndex[i] = _buffer:readUChar()
    end

    -- 保存游戏结果数据
    TigerDataMgr:getInstance():setGameResult(msg)
    TigerDataMgr:getInstance():setTigerState(TigerConst.GAME_TIGER_PLAY);
    --累计中奖
    TigerDataMgr:getInstance():setAllBetWinGold(TigerDataMgr:getInstance():getAllBetWinGold() + msg.llResult)
    -- 日志
    LOG_PRINT("游戏结果：[%d]", msg.llResult)
    for i=1, TigerConst.CARD_INDEX do
        LOG_PRINT("牌值: [%d][%d]", i, msg.cbCardIndex[i])
    end
    --FloatMessage.getInstance():pushMessageDebug("收到开始游戏")
    -- 通知UI.
    SLFacade:dispatchCustomEvent(Tiger_Events.MSG_TIGER_GAME_START)
end

function CMsgTiger:process_game_gameEnd(__data) --200-203- 游戏结束
    -- 设置游戏状态
    TigerDataMgr:getInstance():setTigerState(TigerConst.GAME_TIGER_FREE);

    --日志
    LOG_PRINT("游戏结束")
    --FloatMessage.getInstance():pushMessageDebug("收到游戏结束")
    -- 通知 
    SLFacade:dispatchCustomEvent(Tiger_Events.MSG_TIGER_GAME_END)
end

--function CMsgTiger:process_game_update(__data) --200-201-更新数据
--    local _buffer = __data:readData(__data:getReadableSize())

--    -- uint8 cbJettonIndex;
--    -- uint8 cbLineIndexLin;

--    -- 数据 
--    local msg = {}
--    msg.cbJettonIndex = _buffer:readUChar()
--    msg.cbLineIndexLin = _buffer:readUChar()

--    -- 保存
----    TigerDataMgr:getInstance():setBetNumIndex(msg.cbJettonIndex)
----    TigerDataMgr:getInstance():setLineNum(msg.cbLineIndexLin)

--    --日志
--    LOG_PRINT("更新数据 cbJettonIndex[%d], cbLineIndexLin[%d]", msg.cbJettonIndex, msg.cbLineIndexLin)

--    -- 通知
--    SLFacade:dispatchCustomEvent(Tiger_Events.MSG_TIGER_GAME_UPDATE)
--end

--function CMsgTiger:process_game_result(__data) --200-202-游戏结果
--    -- todo.
--end

function CMsgTiger:process_game_freeTimes(__data) --200-204- 免费次数
    local _buffer = __data:readData(__data:getReadableSize())

    -- uint8 cbFreeTimes;

    -- 数据
    local msg = {}
    msg.cbFreeTimes = _buffer:readUChar()

    -- 保存
    --TigerDataMgr:getInstance():setTempFreeTimes(msg.cbFreeTimes);
    TigerDataMgr:getInstance():setFreeTimes(msg.cbFreeTimes)
    --日志
    LOG_PRINT("免费次数[%d]", msg.cbFreeTimes)
    --FloatMessage.getInstance():pushMessageDebug("免费次数：".. msg.cbFreeTimes)
    -- 通知
--    SLFacade:dispatchCustomEvent(Tiger_Events.MSG_TIGER_GAME_FREE_TIMES)
end

function CMsgTiger:process_game_extraTimes(__data) --200-205-额外倍数
    local _buffer = __data:readData(__data:getReadableSize())

    -- int iExtraTimes;

    -- 数据
    local msg = {}
    msg.iExtraTimes = _buffer:readInt()

    -- 保存
    TigerDataMgr:getInstance():setExtraTimes(msg.iExtraTimes);

    --日志
    LOG_PRINT("额外倍数: [%d]", msg.iExtraTimes)

    -- 通知
    --[[SLFacade:dispatchCustomEvent(Tiger_Events.MSG_TIGER_GAME_EXTRA_TIMES)]]
end

function CMsgTiger:process_game_winScore(__data) --200-206- 赢取彩金
    local _buffer = __data:readData(__data:getReadableSize())

    -- long long llGold;

    -- 数据 
    local msg = {}
    msg.llGold = _buffer:readLongLong()

    -- 保存
    TigerDataMgr:getInstance():setWinPrizeGold(msg.llGold)

    --日志
    LOG_PRINT("赢取彩金: [%d]", msg.llGold)

    -- 通知 
    --[[SLFacade:dispatchCustomEvent(Tiger_Events.MSG_TIGER_GAME_WIN_SCORE)]]
end

function CMsgTiger:process_game_libScore(__data) --200-207- 彩金库
    local _buffer = __data:readData(__data:getReadableSize())

    -- long long llGoldLibScore;

    -- 数据
    local msg = {}
    msg.llGoldLibScore = _buffer:readLongLong()

    -- 保存
    local nScore = TigerDataMgr:getInstance():getPrizePool();
    TigerDataMgr:getInstance():setLastPrizePool(nScore);
    TigerDataMgr:getInstance():setPrizePool(msg.llGoldLibScore);

    --日志
    LOG_PRINT("彩金库：[%d]", msg.llGoldLibScore)
    LOG_PRINT("上一轮彩金库：[%d]", nScore)

    -- 通知 
    SLFacade:dispatchCustomEvent(Tiger_Events.MSG_TIGER_GAME_LIB_SCORE)
end

--function CMsgTiger:process_game_showPlayer(__data) --200-209- 展示其他玩家
--    local _buffer = __data:readData(__data:getReadableSize())

--    -- uint16 wChairID[4];

--    -- 数据
--    local msg = {}
--    msg.wChairID = {}
--    for i=1,4 do
--        msg.wChairID[i] = _buffer:readUShort()
--    end

--    -- 保存
--    TigerDataMgr:getInstance():setGameOtherPlayers(msg)

--    --日志
--    LOG_PRINT("展示其他玩家：")
--    for i=1,4 do
--        LOG_PRINT("index: [%d], charId: [%d]", i, msg.wChairID[i])
--    end

--    -- 通知 
--    SLFacade:dispatchCustomEvent(Tiger_Events.MSG_TIGER_GAME_SHOW_PLAYER)
--end

--function CMsgTiger:process_game_updateOther(__data) --200-211- 更新其他玩家
--    local _buffer = __data:readData(__data:getReadableSize())

--    -- uint16   wChairID;
--    -- long long  llScore;

--    -- 数据 
--    local msg = {}
--    msg.wChairID = _buffer:readUShort()
--    msg.llScore = _buffer:readLongLong()

--    -- 保存 
--    local pUserScore = {}
--    pUserScore.dwUserID = CUserManager:getInstance():getUserIdByChairID(msg.wChairID)
--    pUserScore.llScore = msg.llScore
--    CUserManager:getInstance():updateOtherScore(pUserScore)

--    --日志
--    LOG_PRINT("其他玩家 chairId：[%d]， llScore: [%d]", msg.wChairID, msg.llScore)

--    -- 通知 
--    SLFacade:dispatchCustomEvent(Tiger_Events.MSG_TIGER_GAME_UPDATE_OTHER)
--end

function CMsgTiger:process_game_error(__data) --200-210- 错误消息
    local _buffer = __data:readData(__data:getReadableSize())

    -- uint8 cbIndex;

    -- 数据
    local msg = {}
    msg.cbIndex = _buffer:readUChar()
    
    -- 判断错误类型  0：不在游戏状态  1：数据包错误  2：当前金币不足
    if     msg.cbIndex == 0 then --cc.exports.FloatMessage:getInstance():pushMessage("TIGER_8") --不提示
    elseif msg.cbIndex == 1 then --cc.exports.FloatMessage:getInstance():pushMessage("TIGER_7") --不提示
    elseif msg.cbIndex == 2 then cc.exports.FloatMessage:getInstance():pushMessage("TIGER_4")
    end

    --日志
    LOG_PRINT("错误消息 cbIndex: [%d]", msg.cbIndex)

    -- 通知 
    SLFacade:dispatchCustomEvent(Tiger_Events.MSG_TIGER_GAME_ERROR)
end

function CMsgTiger:process_game_serverMsg(__data) --200-220- 服务器消息
    local _buffer = __data:readData(__data:getReadableSize())

    -- 数据
    local msg = {}
    msg.wSysType = _buffer:readShort() --消息类型 （ 0-普通消息 ）
    msg.szSysMessage = _buffer:readString(256*2) --消息内容

    --日志
    --print("系统消息："..msg.szSysMessage)

    if msg.wSysType == G_CONSTANTS.UPRUN_MSG then
        cc.exports.FloatMessage:getInstance():pushMessage(tostring(msg.szSysMessage))
    end
end

function CMsgTiger:process_game_topPrizeMsg (__data) --200-212- 服务器消息
--    //大奖消息
--    struct CMD_S_TopPrizeMessageInfo
--    {
--     TCHAR szNickName[32];//中奖玩家昵称
--     BYTE cbType;//0普通，1超级，2钻石，3七七七，4宝箱
--     int  iTimes;//倍数或免费次数，宝箱类型此字段为0
--     long long llScore;//获得金币
--    };

    local _buffer = __data:readData(__data:getReadableSize())

    -- 数据
    local msg = {}
    msg.szNickName = _buffer:readString(32*2)
    msg.cbType = _buffer:readChar()
    msg.iTimes = _buffer:readInt()
    msg.llScore = _buffer:readLongLong()

    local strMsg = ""
    local strLocal = cc.exports.Localization_cn[string.format("TIGER_TOP_PRIZE_%d",msg.cbType)]
    if msg.cbType == 0 or msg.cbType == 1 or msg.cbType == 3 then
        local strGold = LuaUtils.getFormatGoldAndNumber(msg.llScore)
        strMsg = string.format(strLocal,msg.szNickName,msg.iTimes,strGold)
    elseif msg.cbType == 2 then 
        strMsg = string.format(strLocal,msg.szNickName,msg.iTimes)
    elseif msg.cbType == 4 then 
        local strGold = LuaUtils.getFormatGoldAndNumber(msg.llScore)
        strMsg = string.format(strLocal,msg.szNickName,strGold)
    end
    --GameRollMsg.getInstance():addMessage(strMsg)
end
-------------------- 发送 ----------------------------------

function CMsgTiger:sendStandUp()  -- 站起
    local wTableID = Player:getInstance():getTableID()
    local wChairID = Player:getInstance():getChairID()

    local wb = WWBuffer:create()
    wb:writeShort(wTableID) --桌子位置
    wb:writeShort(wChairID) --椅子位置
    wb:writeChar(1) --强制离开

    self:sendData(G_C_CMD.MDM_GR_USER,G_C_CMD.SUB_GR_USER_STANDUP,wb)

    --日志
    LOG_PRINT("发送站起")
end

--function CMsgTiger:sendDownLine(nLineIdx, bIsMobile) -- 更改下注线数
--    local wb = WWBuffer:create()
--    wb:writeUChar(nLineIdx)
--    wb:writeBoolean(bIsMobile)
--    self:sendData(TigerCMD.MDM_GF_GAME, TigerCMD.SUB_C_DownLine, wb)

--    --日志
--    LOG_PRINT("发送更改下注线数")
--end

--function CMsgTiger:sendAddJetton(bAdd, bIsMobile) -- 更改单线下注数额
--    local wb = WWBuffer:create()
--    wb:writeBoolean(bAdd)
--    wb:writeBoolean(bIsMobile)
--    self:sendData(TigerCMD.MDM_GF_GAME, TigerCMD.SUB_C_AddJetton, wb)

--    --日志
--    LOG_PRINT("发送更改单线下注数额")
--end

function CMsgTiger:sendGameStart(line, jetton) -- 开始游戏
--struct CMD_C_GameStartEx
--{
--	BYTE cbLineCount;     //总共押注多少线
--	BYTE cbJettonCount;	  //每条线押注的筹码数
--	bool bIsMobilePlayer; //是否是移动用户
--};
    local wb = WWBuffer:create()
    wb:writeChar(line)
    wb:writeChar(jetton)
    wb:writeBoolean(true)
    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUP_C_GameStartEx, wb)

    --FloatMessage.getInstance():pushMessageDebug("发送开始游戏")
    --日志
    LOG_PRINT("开始游戏")
end

function CMsgTiger:sendGameStop() -- 停止游戏
    local wb = WWBuffer:create()
    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_GameEnd, wb)

    --日志
    LOG_PRINT("停止游戏")
end

return CMsgTiger   