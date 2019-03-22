--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local RedVsBlackDefine      = require("game.redvsblack.scene.RedVsBlackDefine")
local RedVsBlackEvent       = require("game.redvsblack.scene.RedVsBlackEvent")
local RedVsBlackDataManager = require("game.redvsblack.manager.RedVsBlackDataManager")
local FloatMessage          = require("common.layer.FloatMessage")

local MAX_BANKER_COUNT = 20
local DOWN_COUNT_HOX = 3
local TABLE_USER_COUNT = 8
local PLAYERS_COUNT_HOX = 5
local MAX_BANKER_COUNT = 20 --上庄列表玩家的椅子号， MAX_BANKER_COUNT值为20
local HAND_COUNT = 5

local CMsgRedVsBlack = class("CMsgRedVsBlack", require("common.app.CMsgGame"))

CMsgRedVsBlack.gclient = nil 
function CMsgRedVsBlack.getInstance()
    if not CMsgRedVsBlack.gclient then
        CMsgRedVsBlack.gclient = CMsgRedVsBlack:new()
    end
    return CMsgRedVsBlack.gclient
end

function CMsgRedVsBlack:ctor()

    self.func_game_ = {

        [G_C_CMD.MDM_GF_FRAME] = {
            [G_C_CMD.SUB_GF_GAME_SCENE]        = { func = self.process_100_101, debug = true, log = "游戏场景",},
        },

        [G_C_CMD.MDM_GF_GAME] = {
            [G_C_CMD.SUB_S_SysMessage]         = { func = self.process_200_302, debug = true, log = "系统消息"},
            [G_C_CMD.SUB_S_GameInfo]           = { func = self.process_200_301, debug = true, log = "游戏信息"},
            [G_C_CMD.SUB_S_SendTableUser]      = { func = self.process_200_303, debug = true, log = "上桌玩家信息"},
            [G_C_CMD.SUB_S_ChipSucc]           = { func = self.process_200_304, debug = true, log = "下注成功"},
            [G_C_CMD.SUB_S_GameResultInfo]     = { func = self.process_200_305, debug = true, log = "游戏结算信息"},
            [G_C_CMD.SUB_S_RequestBankerList]  = { func = self.process_200_306, debug = true, log = "申请上庄列表"},
            [G_C_CMD.SUB_S_RequestBanker]      = { func = self.process_200_307, debug = true, log = "申请庄家"}, --(单人申请庄家时发送)
            [G_C_CMD.SUB_S_UpdateBanker]       = { func = self.process_200_308, debug = true, log = "更新庄家信息"}, --(每回合结束都会更新)
            [G_C_CMD.SUB_S_ContiueChip]        = { func = self.process_200_310, debug = true, log = "玩家续投结果"},
            [G_C_CMD.SUB_S_UpdateChip]         = { func = self.process_200_311, debug = true, log = "上一秒的投注总和"},
            [G_C_CMD.SUB_S_CancelChip]         = { func = self.process_200_312, debug = true, log = "取消投注"},
            [G_C_CMD.SUB_S_GOLD_OVER]          = { func = self.process_200_313, debug = true, log = "库存被赢光"},
            [G_C_CMD.SUB_S_CurrentBanker]      = { func = self.process_200_314, debug = true, log = "当前庄家信息"},
        },
    }
    math.randomseed(os.time())
end

function CMsgRedVsBlack:process_100_101(__data) --游戏场景 有且仅一次 在进入游戏房间时发送
--[[
struct stgGameScene//场景消息
{
 TCHAR  szBankerName[LEN_NICKNAME];    //庄家名字
 WORD  wBankerChairID;       //当前庄家椅子号，如果是系统坐庄，就为 INVALID_CHAIR 0xFFFF
 DWORD  wBankerUserID;       //当前庄家的UserID
 int   iBankerTimes;       //庄家坐庄次数，之后客户端收到空闲消息的时候自加
 LONGLONG llBankerScore;       //如果是系统坐庄，这是系统的分数
 LONGLONG llMinBankerScore;      //上庄限制  WORD  wAppBankerCount;      //上庄列表玩家数
 WORD  wAppBankerChairID[MAX_BANKER_COUNT]; //上庄列表玩家的椅子号  BYTE  cbGameStatue;       //游戏状态  LONGLONG llMyDownJetton[DOWN_COUNT];    //当前自己押注情况
 LONGLONG llTotalJetton[DOWN_COUNT];    //当前所有人押注情况  BYTE  cbHisCount;        //历史记录数
 stgHistory  pHistory[20];       //历史记录
 int   iTiemrIndex;       //时钟剩余秒数
 stgHistory pNewHistory;       //最新历史记录(新加)
 LONGLONG llChipsValues[CHIPS_VALUES_COUNT];  //筹码数值
 DWORD  dwRevenueRatio;       //明税税率（按照万分之计算，如值为500，表示万分之五百）
};
阿牛 2018-07-20 20:29:20
ok
]]--        
    RedVsBlackDataManager.getInstance():releaseInstance()

    local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.szBankerName = _buffer:readString(64)           --庄家名字
    msg.wBankerChairID = _buffer:readUShort() or 65535  --当前庄家椅子号，如果是系统坐庄，就为 INVALID_CHAIR 0xFFFF
    msg.wBankerUserID = _buffer:readUInt()              --当前庄家的UserID
    msg.iBankerTimes = _buffer:readInt()                --庄家坐庄次数，之后客户端收到空闲消息的时候自加
    msg.llBankerScore = _buffer:readLongLong()          --如果是系统坐庄，这是系统的分数
    msg.llMinBankerScore = _buffer:readLongLong()       --上庄限制
    msg.wAppBankerCount = _buffer:readUShort()          --上庄列表玩家数
    if 65535 == msg.wBankerChairID then msg.szBankerName = "庄家逃跑" end -- 如果是系统坐庄 修改名称为庄家逃跑
    msg.wAppBankerChairID = {}
    for i = 1, MAX_BANKER_COUNT do--msg.wAppBankerCount do
        msg.wAppBankerChairID[i] = _buffer:readUShort() --上庄列表玩家的椅子号
    end
    msg.cbGameStatue = _buffer:readUChar()  --游戏状态
    msg.llMyDownJetton = {}
    msg.llTotalJetton = {}
    for i = 1,3 do
        msg.llMyDownJetton[i] = _buffer:readLongLong()  --当前自己押注情况
    end
    for i = 1,3 do
        msg.llTotalJetton[i] = _buffer:readLongLong()   --当前所有人押注情况
    end
    msg.cbHisCount = _buffer:readUChar() --历史记录数
    msg.pHistory = {}
    for i = 1, 20 do
        msg.pHistory[i] = {}
        msg.pHistory[i].bWin = _buffer:readUChar() --历史记录
        msg.pHistory[i].bCardType = _buffer:readUChar() --历史记录
    end
    msg.iTiemrIndex = _buffer:readInt()

    -- 最新的一条历史记录
    local lastHistory = {}
    lastHistory.bWin = _buffer:readUChar() --历史记录
    lastHistory.bCardType = _buffer:readUChar() --历史记录

    -- 服务器发送过来的是8个筹码数据
    msg.llChipsValues = {}
    for i = 1, 8 do
        msg.llChipsValues[i] = _buffer:readLongLong()
    end

    --明税
    msg.wGameTax = _buffer:readInt()

    --设置6个筹码数据
    for i = 1, 6 do
        RedVsBlackDataManager.getInstance():setJettonScore(i,msg.llChipsValues[i])
    end

    RedVsBlackDataManager.getInstance():setGameTax(msg.wGameTax/10000)

    local pGameScene = msg
    local strNick = nil
    RedVsBlackDataManager.getInstance():setBankerGold(pGameScene.llBankerScore)
    strNick = pGameScene.szBankerName
    RedVsBlackDataManager.getInstance():setBankerName(strNick)
    RedVsBlackDataManager.getInstance():setBankerChairId(pGameScene.wBankerChairID)
    if G_CONSTANTS.INVALID_CHAIR == msg.wBankerChairID then -- 系统坐庄设置0
        RedVsBlackDataManager.getInstance():setCurBankerTimes(0)
    else
        RedVsBlackDataManager.getInstance():setCurBankerTimes(pGameScene.iBankerTimes)
    end
    RedVsBlackDataManager.getInstance():setMinBankerScore(pGameScene.llMinBankerScore)
    if (pGameScene.cbGameStatue + 1) == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP then
        RedVsBlackDataManager.getInstance():setGameStatus(RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP)
        local time = pGameScene.iTiemrIndex
        if time <= 0 then
            time = 0
        end
        RedVsBlackDataManager.getInstance():setTimeCount(time)
    else
        RedVsBlackDataManager.getInstance():setGameStatus(RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_END)
        local time = pGameScene.iTiemrIndex
        time = pGameScene.cbGameStatue + 1 == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_END and time + 3 or time + 1
        if time <= 0 then
            time = 0
        end
        RedVsBlackDataManager.getInstance():setTimeCount(time)        
    end

    --标记进入场景时的时间戳
    RedVsBlackDataManager.getInstance():markEnterSceneTs()

    --庄家列表
    RedVsBlackDataManager.getInstance():clearBankerList()
    local tmp = math.min(pGameScene.wAppBankerCount, MAX_BANKER_COUNT)
    for i = 1, tmp do
        local strNick = CUserManager.getInstance():getUserNickByChairID(pGameScene.wAppBankerChairID[i])
        RedVsBlackDataManager.getInstance():addBankerListByChairId(pGameScene.wAppBankerChairID[i], 0, strNick)
    end
    --历史记录
    RedVsBlackDataManager.getInstance():clearHistory()
    local min = math.min(pGameScene.cbHisCount,20)
    for i = 1, min do
        RedVsBlackDataManager.getInstance():addHistoryToList(pGameScene.pHistory[i])
    end
    if 255 ~= lastHistory.bWin and 255 ~= lastHistory.bCardType then
        RedVsBlackDataManager.getInstance():setUnhandleHistory(lastHistory)
    end
    RedVsBlackDataManager.getInstance():synTmpHistory()



    --RedVsBlackDataManager.getInstance():setTotalBoard(pGameScene.iTotalBoard)
--    for i = 1, DOWN_COUNT_HOX do
--        RedVsBlackDataManager.getInstance():setWinBoardCount(i,pGameScene.iBoardCount[i])
--    end
    --桌子上的玩家/先初始化上次的
--    RedVsBlackDataManager.getInstance():clearTableChairID()
--    RedVsBlackDataManager.getInstance():setCurTableRealUserNum(4)
--    for i = 1, TABLE_USER_COUNT do
--        local chairID = pGameScene.wTableChairID[i] or 65535
--        if chairID >=0 and chairID < 100 then
--            RedVsBlackDataManager.getInstance():setTableChairIDByIndex(i, chairID)
--        end
--    end
    --当前局已下注金币
    for i = 1, DOWN_COUNT_HOX do
        local totalJetton = pGameScene.llTotalJetton[i]
        local selfJetton = pGameScene.llMyDownJetton[i]
        local otherJetton = ((totalJetton - selfJetton) > 0) and (totalJetton - selfJetton) or 0
            
        while selfJetton > 0 do
            local selfChip = {}
            selfChip.wChipIndex = i
            local index = RedVsBlackDataManager.getInstance():GetJettonMaxIdx(selfJetton)
            if index >= 1 then
                selfChip.wJettonIndex = index
                selfJetton = selfJetton - RedVsBlackDataManager.getInstance():getJettonScore(index)
            end
            RedVsBlackDataManager.getInstance():addUsrChip(selfChip)
        end
            
        while otherJetton > 0 do              
            local index = RedVsBlackDataManager.getInstance():GetJettonMaxIdx(otherJetton)
            if index >= 1 then
                local jettonVal = RedVsBlackDataManager.getInstance():getJettonScore(index)
                otherJetton = otherJetton - jettonVal
                RedVsBlackDataManager.getInstance():addOtherChip(i,jettonVal)
            end
        end
    end

    --通知/进入场景时当场景消息阻塞时,通知更新庄家数据
--    local _event1 = {
--        name = RedVsBlackEvent.MSG_REDVSBLACK_UPDATE_BANKER_INFO,
--        packet = msg,
--    }
--    SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_REDVSBLACK_UPDATE_BANKER_INFO, _event1)
--    local _event2 = {
--        name = RedVsBlackEvent.MSG_HOX_SCENE_UPDATE,
--        packet = msg,
--    }
--    SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_HOX_SCENE_UPDATE, _event2)
    self:enterGameScene()

    return ""
end

function CMsgRedVsBlack:process_200_302(__data)

    local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.wSysType = _buffer:readShort()          --消息类型/0-普通消息
    msg.szSysMessage = _buffer:readString(512)  --消息内容

    --通知
    local _event = {
        name = RedVsBlackEvent.MSG_UPDATE_ROLL_MSG,
        packet = msg,
    }
    SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_UPDATE_ROLL_MSG, _event)  

    return ""
end

function CMsgRedVsBlack:process_200_301(__data)

    local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.wGmaeStatus = _buffer:readUShort()  --游戏状态
    msg.wTimerValue = _buffer:readUShort()  --timer的值

    --保存
    local pGameInfo = msg
    if pGameInfo.wGmaeStatus == 1 then
        RedVsBlackDataManager.getInstance():setGameStatus(RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_IDLE)
    elseif pGameInfo.wGmaeStatus == 2 then
        if G_CONSTANTS.INVALID_CHAIR ~= RedVsBlackDataManager.getInstance():getBankerChairId() then -- 非系统坐庄才累加次数
            RedVsBlackDataManager.getInstance():setCurBankerTimes(RedVsBlackDataManager.getInstance():getCurBankerTimes() + 1)
        end
        RedVsBlackDataManager.getInstance():setGameStatus(RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP)
        --local time = pGameInfo.wTimerValue - 1
        local time = pGameInfo.wTimerValue + 1
        time = (time > 0) and time or 0 
        RedVsBlackDataManager.getInstance():setTimeCount(time)
        RedVsBlackDataManager.getInstance():setContinue(false)
        RedVsBlackDataManager.getInstance():updateBetContinueRec()
    elseif pGameInfo.wGmaeStatus == 3 then
        RedVsBlackDataManager.getInstance():setGameStatus(RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_END)
        RedVsBlackDataManager.getInstance():setTimeCount(msg.wTimerValue + 2)
    end

    --通知
    local _event = {
        name = RedVsBlackEvent.MSG_REDVSBLACK_UDT_GAME_STATUE,
        packet = msg,
    }
    SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_REDVSBLACK_UDT_GAME_STATUE, _event)

    --日志
    local state = 
    {
        "空闲时间 ",
        "开始下注 ",
        "游戏结束 ",
    }
    local ret = state[pGameInfo.wGmaeStatus]

    return ret
end

function CMsgRedVsBlack:process_200_303(__data)

    local _buffer = __data:readData(__data:getReadableSize())
    
    --数据
    local msg = {}
    msg.wChairID = {}
    for i = 1,8 do --TABLE_USER_COUNT
        msg.wChairID[i] = _buffer:readUShort()
    end

    --保存
    RedVsBlackDataManager.getInstance():clearTableChairID()
    RedVsBlackDataManager.getInstance():setCurTableRealUserNum(4)
    for i = 1, 8 do
        local chairID = msg.wChairID[i]
        if chairID >=0 and chairID < 100 then
            RedVsBlackDataManager.getInstance():setTableChairIDByIndex( i, chairID)
        end
    end

    --通知/更新桌子
    local _event = {
        name = RedVsBlackEvent.MSG_REDVSBLACK_UPDATE_TABLE_INFO,
        packet = "flyEffect",
    }
    SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_REDVSBLACK_UPDATE_TABLE_INFO, _event)

    return ""
end

function CMsgRedVsBlack:process_200_304(__data)

    local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.wChairID = _buffer:readUShort()     --椅子ID
    msg.wChipIndex = _buffer:readUShort()   --下注索引
    msg.wJettonIndex = _buffer:readUShort() --筹码索引
    msg.bIsAndroid = _buffer:readBoolean()  --是否AI
    local userChipTem = {}
    userChipTem.wChipIndex = msg.wChipIndex + 1
    userChipTem.wJettonIndex = msg.wJettonIndex + 1
        
    --保存
    if msg.wChairID == PlayerInfo.getInstance():getChairID() then --自己投注
        RedVsBlackDataManager.getInstance():addUsrChip(userChipTem)
        local curGold = PlayerInfo.getInstance():getUserScore()
        local subGold = RedVsBlackDataManager.getInstance():getJettonScore(msg.wJettonIndex + 1)
        PlayerInfo.getInstance():setUserScore(curGold - subGold)
        --print("下注成功，用户余额:" .. PlayerInfo.getInstance():getUserScore())
        --print("用户下注:" .. subGold)
    else
        local chip = msg.wChipIndex + 1
        local score = RedVsBlackDataManager.getInstance():getJettonScore(msg.wJettonIndex + 1)
        RedVsBlackDataManager.getInstance():addOtherChip(chip, score)
        --print("其他玩家下注:" .. score)
    end
    local userDownChip = {}
    userDownChip.wChairID = msg.wChairID
    userDownChip.wChipIndex = msg.wChipIndex + 1
    userDownChip.wJettonIndex = msg.wJettonIndex + 1
    userDownChip.bIsSelf = (msg.wChairID == PlayerInfo.getInstance():getChairID())
    userDownChip.bIsAndroid = msg.bIsAndroid
    RedVsBlackDataManager.getInstance():pushOtherUserChip(userDownChip)

    --通知
    local _event = {
        name = RedVsBlackEvent.MSG_GAME_SHIP,
        packet = nil,
    }

    if msg.wChairID == PlayerInfo.getInstance():getChairID() then -- 自己投注 立即分发消息
        SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_GAME_SHIP, _event)
    else -- 他人投注 随机延迟
        local randomts = math.random(0,8)/10
        cc.exports.scheduler.performWithDelayGlobal(function()
            SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_GAME_SHIP, _event)
        end, randomts)
    end

    --return ""
end

function CMsgRedVsBlack:process_200_306(__data)
    local _buffer = __data:readData(__data:getReadableSize())

    local iRequestCount = _buffer:readInt()

    SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_REDVSBLACK_GAME_END, _event)
end

function CMsgRedVsBlack:process_200_305(__data)

    local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}

    -- 6张开牌 顺序 先红后黑
    msg.wOpenCards = {}
    for i = 6,1,-1 do -- 为保持和内部发牌动画顺序一致 保存数据时倒序保存
        msg.wOpenCards[i] = _buffer:readUChar()
    end

    local function GetCardStr(num)
        local color = CommonUtils.getInstance():getCardColor(num)
        local value = CommonUtils.getInstance():getCardValue(num)+1
        return value
    end

    -- 0是红 1是黑
    msg.wWinIndex = _buffer:readUChar() -- 赢家索引
    --[[
    #define CARD_TYPE_SINGLE						1									//单牌
    #define CARD_TYPE_DOUBLE						2									//对子
    #define CARD_TYPE_SHUNZI						3									//顺子
    #define CARD_TYPE_JINHUA						4									//金花
    #define CARD_TYPE_SHUNJIN						5									//顺金
    #define CARD_TYPE_LEOPARD						6									//豹子
    ]]--
--    local strcard = "发牌:"
--    for m = 1, 6 do
--        strcard = strcard .. GetCardStr(msg.wOpenCards[m]) .. "_"
--    end
--    local cardstr = { "单牌","对子","顺子","金花","顺金","豹子", }
    msg.wWinCardType = {}
    msg.wWinCardType[1] = _buffer:readUChar() -- 红方牌型
    msg.wWinCardType[2] = _buffer:readUChar() -- 黑方牌型
--    local winnerstr = 0 == msg.wWinIndex and "红" or "黑"
--    print("发牌为：" .. strcard)
--    print("赢家:" .. winnerstr .. "  牌型:" .. cardstr[msg.wWinCardType[1]] .. cardstr[msg.wWinCardType[2]])

    msg.cbLuckyBeat = _buffer:readUChar() -- 中了幸运牌型 0:每中 1:中了
    --print("幸运一击:" .. msg.cbLuckyBeat)
    msg.llBankerResult = _buffer:readLongLong() -- 庄家成绩
    msg.llBankerScore = _buffer:readLongLong() -- 庄家分数
    msg.llFinaResult = _buffer:readLongLong() -- 自己分数 此分数没有扣除本金
    --print("庄家成绩:" .. msg.llBankerResult)
    --print("自己成绩:" .. msg.llFinaResult)

    --保存/更新庄家分数
    RedVsBlackDataManager.getInstance():setBankerGold(msg.llBankerScore)
    RedVsBlackDataManager.getInstance():setBankerCurrResult(msg.llBankerResult)
    local data = msg
    RedVsBlackDataManager.getInstance():addOpenData(data)

    if RedVsBlackDataManager.getInstance():isBanker() then
        RedVsBlackDataManager.getInstance():setSelfCurrResult(msg.llBankerResult)
        PlayerInfo.getInstance():setUserScore(msg.llBankerScore)
    else
        local betVal = RedVsBlackDataManager.getInstance():getUserTotalChip()
        local curVal = msg.llFinaResult - betVal
        RedVsBlackDataManager.getInstance():setSelfCurrResult(curVal)

        --local offval = curVal > 0 and curVal or 0
        PlayerInfo.getInstance():setUserScore(PlayerInfo.getInstance():getUserScore() + msg.llFinaResult)
    end

    --通知
    local _event = {
        name = RedVsBlackEvent.MSG_REDVSBLACK_GAME_END,
        packet = msg,
    }
    SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_REDVSBLACK_GAME_END, _event)

    return "开始比牌 "
end

function CMsgRedVsBlack:process_200_307(__data)

    local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.bAppBanker = _buffer:readBoolean()  --是否申请上庄
    msg.wChairID = _buffer:readUShort()     --玩家ID

    --保存
    if msg.bAppBanker then --申请上庄
        local strNick = CUserManager.getInstance():getUserNickByChairID(msg.wChairID)
        RedVsBlackDataManager.getInstance():addBankerListByChairId(msg.wChairID, 0, strNick)
    else --申请下庄
        RedVsBlackDataManager.getInstance():delBankerByChairId(msg.wChairID)
    end

    --通知
    local _event = {
        name = RedVsBlackEvent.MSG_REDVSBLACK_REQUEST_BANKER_INFO,
        packet = string.format("%d",msg.wChairID),
    }
    SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_REDVSBLACK_REQUEST_BANKER_INFO, _event)  

    return ""
end

function CMsgRedVsBlack:process_200_308(__data)

    print("get baker info")
    local _buffer = __data:readData(__data:getReadableSize())
    
    --数据
    local msg = {}
    msg.wChairID = _buffer:readUShort()                  --当前庄家，如果是系统坐庄，这个值为 INVALID_CHAIR 0xFFFF
    msg.wLastBankerChairID = _buffer:readUShort()    --被换掉的庄家
    msg.llBankerScore = _buffer:readLongLong()         --庄家分数
    --更新庄家信息-当收到这个消息，客户端将庄家坐庄次数设为0，之后自加

    --保存/删掉老庄家
    RedVsBlackDataManager.getInstance():delBankerByChairId(msg.wLastBankerChairID)
    RedVsBlackDataManager.getInstance():setLastBankerChairId(msg.wLastBankerChairID)
    local strNick = "" --更新新的
    if msg.wChairID == G_CONSTANTS.INVALID_CHAIR then
        strNick = LuaUtils.getLocalString("STRING_240")
        RedVsBlackDataManager.getInstance():setBankerGold(msg.llBankerScore)
    else
        strNick = CUserManager.getInstance():getUserNickByChairID(msg.wChairID)
        RedVsBlackDataManager.getInstance():setBankerGold(msg.llBankerScore)
    end
    RedVsBlackDataManager.getInstance():setBankerChairId(msg.wChairID)
    RedVsBlackDataManager.getInstance():setBankerName(strNick)
    RedVsBlackDataManager.getInstance():setCurBankerTimes(0)
    
    --通知
    local label = (msg.wChairID == G_CONSTANTS.INVALID_CHAIR) and "SystemBanker" or "UserBanker"
    local _event = {
        name = RedVsBlackEvent.MSG_REDVSBLACK_UPDATE_BANKER_INFO,
        packet = label,
    }
    SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_REDVSBLACK_UPDATE_BANKER_INFO, _event)    

    return ""
end

function CMsgRedVsBlack:process_200_310(__data)

    local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.bSucssce = _buffer:readBoolean() 
    msg.wChairID = _buffer:readUShort()  
    msg.llDownTotal = {}
    for i = 1, 3 do--DOWN_COUNT_HOX do
        msg.llDownTotal[i] = _buffer:readLongLong()  
    end
    if msg.bSucssce then
        if msg.wChairID == PlayerInfo.getInstance():getChairID() then
            RedVsBlackDataManager.getInstance():setIsAndroid(false)
            RedVsBlackDataManager.getInstance():setIsMyFly(true)
            RedVsBlackDataManager.getInstance():setContinue(true)
            RedVsBlackDataManager.getInstance():recordBetContinue()

            local _event = {
                name = RedVsBlackEvent.MSG_GAME_CONTINUE_SUCCESS,
                packet = "MyContinueSuc",
            }
            SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_GAME_CONTINUE_SUCCESS, _event)         
            --chang gold
            local curGold = PlayerInfo.getInstance():getUserScore()
            local totalCost = 0
            for i = 1, 3 do --DOWN_COUNT_HOX do
                totalCost = totalCost + msg.llDownTotal[i]
            end
            PlayerInfo.getInstance():setUserScore((curGold - totalCost) < 0 and 0 or (curGold - totalCost))
        else
            RedVsBlackDataManager.getInstance():setIsAndroid(false)
            RedVsBlackDataManager.getInstance():setIsMyFly(false)
            for i = 1,3 do -- DOWN_COUNT_HOX do
                RedVsBlackDataManager.getInstance():addOtherChip(i, msg.llDownTotal[i])
                --显示用
                local userDownContinueChip = {}
                userDownContinueChip.wChipIndex = i
                userDownContinueChip.llTotalChipVale = msg.llDownTotal[i]
                userDownContinueChip.bIsSelf = RedVsBlackDataManager.getInstance():getIsMyFly()
                RedVsBlackDataManager.getInstance()._queueOtherUserContinueChip[i] = userDownContinueChip
            end
            local _event = {
                name = RedVsBlackEvent.MSG_GAME_CONTINUE_SUCCESS,
                packet = nil,
            }
            SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_GAME_CONTINUE_SUCCESS, _event)  
        end
    end

    return ""
end

function CMsgRedVsBlack:process_200_311(__data)
    return ""
end

function CMsgRedVsBlack:process_200_312(__data)
    
    local len = __data:getReadableSize()
    local _buffer = __data:readData(len)

    --数据
    local msg = {}
    msg.bSuccsce = _buffer:readBoolean()  
    msg.wChairID = _buffer:readUShort()  
    msg.llDownTotal = {}
    for i = 1, 3 do--DOWN_COUNT_HOX do
        msg.llDownTotal[i] = _buffer:readLongLong()  
    end
    if msg.bSuccsce then
        if msg.wChairID == PlayerInfo.getInstance():getChairID() then
            --清空成功
            RedVsBlackDataManager.getInstance():GetCurUserChipSumNum()
            RedVsBlackDataManager.getInstance():clearUsrChip()
            RedVsBlackDataManager.getInstance():clearUserChip()
            RedVsBlackDataManager.getInstance():setContinue(false)
            local _event = {
                name = RedVsBlackEvent.MSG_GAME_SHIP,
                packet = "ChipCanle",
            }
            SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_GAME_SHIP, _event)

            --return gold
            local curGold = PlayerInfo.getInstance():getUserScore()
            local totalCost = 0
            for i = 1, 3 do -- DOWN_COUNT_HOX do
                totalCost = totalCost + msg.llDownTotal[i]
            end
            PlayerInfo.getInstance():setUserScore(curGold + totalCost)
        else
            for i = 1, 3 do-- DOWN_COUNT_HOX do
                RedVsBlackDataManager.getInstance():delOtherChip(i, msg.llDownTotal[i])
                if msg.llDownTotal[i] > 0 then
                    --显示用
                    local userDownDelChip = {}
                    userDownDelChip.wChipIndex = i
                    userDownDelChip.llTotalChipVale = msg.llDownTotal[i]
                    userDownDelChip.bIsSelf = false
                    table.insert(RedVsBlackDataManager.getInstance()._queueOtherUserDelChip, userDownDelChip)
                end
            end         
            local _event = {
                name = RedVsBlackEvent.MSG_GAME_SHIP,
                packet = "OtherChipCanle",
            }
            SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_GAME_SHIP, _event)
        end
    end

    return ""
end

function CMsgRedVsBlack:process_200_313(__data)
   
   return ""
end

function CMsgRedVsBlack:process_200_314(__data)
    
    local len = __data:getReadableSize()
    local _buffer = __data:readData(len)

    --数据
    local msg = {}
    msg.wChairID = _buffer:readUShort()
    msg.strUserNickName = _buffer:readString(64)
    msg.llBankerScore = _buffer:readLongLong()

    --保存
    RedVsBlackDataManager.getInstance():setBankerName(msg.strUserNickName)
    RedVsBlackDataManager.getInstance():setBankerGold(msg.llBankerScore)
    RedVsBlackDataManager.getInstance():setBankerChairId(msg.wChairID)

    --通知
    local _event = {
        name = RedVsBlackEvent.MSG_REDVSBLACK_UPDATE_BANKER_INFO,
        packet = "flyEffect",
    }
    SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_REDVSBLACK_UPDATE_BANKER_INFO, _event)

    return ""
end

--申请上庄
function CMsgRedVsBlack:sendMsgOfReqHost(iStateType)
    local wb = WWBuffer:create()
    wb:writeBoolean(iStateType)

    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_RequestBanker, wb)
end

--投注
function CMsgRedVsBlack:sendMsgOfChipStart(_data)
    local wb = WWBuffer:create()
    wb:writeUShort(_data.wChipIndex)
    wb:writeUShort(_data.wJettonIndex)

    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_UserChip, wb)
end

--续投
function CMsgRedVsBlack:sendMsgOfContinueChip(continueChip)
    local wb = WWBuffer:create()
    for i = 1,3 do --DOWN_COUNT_HOX
        wb:writeLongLong(continueChip.llDownTotal[i])
    end

    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_ContinueChip, wb)
end

--清空投注
function CMsgRedVsBlack:sendMsgShipCancel()
    local wb = WWBuffer:create()

    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_CancelChip, wb)
end

return CMsgRedVsBlack

--endregion
