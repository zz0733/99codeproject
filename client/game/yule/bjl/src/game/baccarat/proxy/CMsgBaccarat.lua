--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--[[
//玩家索引
#define AREA_XIAN				0									//闲家索引
#define AREA_PING				1									//平家索引
#define AREA_ZHUANG				2									//庄家索引
#define AREA_XIAN_TIAN				3									//闲天王
#define AREA_ZHUANG_TIAN			4									//庄天王
#define AREA_TONG_DUI				5									//同点平
#define AREA_XIAN_DUI				6									//闲对子
#define AREA_ZHUANG_DUI				7									//庄对子
#define AREA_MAX				8									//最大区域

//区域倍数multiple
#define MULTIPLE_XIAN				2									//闲家倍数
#define MULTIPLE_PING				9									//平家倍数
#define MULTIPLE_ZHUANG				2									//庄家倍数
#define MULTIPLE_XIAN_TIAN			3									//闲天王倍数
#define MULTIPLE_ZHUANG_TIAN			3									//庄天王倍数
#define MULTIPLE_TONG_DIAN			33									//同点平倍数
#define MULTIPLE_XIAN_PING			12									//闲对子倍数
#define MULTIPLE_ZHUANG_PING			12									//庄对子倍数
]]--

local module_pre = "game.yule.bjl.src"
local BaccaratDefine    = require(module_pre..".game.baccarat.scene.BaccaratDefine")
local BaccaratEvent     = require(module_pre..".game.baccarat.scene.BaccaratEvent")
local BaccaratDataMgr   = require(module_pre..".game.baccarat.manager.BaccaratDataMgr")
local cmd = appdf.req(module_pre .. ".models.CMD_Game")

local PlayerInfo        = cc.exports.PlayerInfo
local SLFacade          = cc.exports.SLFacade
local PlayerInfo        = cc.exports.PlayerInfo

local BetArea = 8
local ChipNum = 6

local CMsgBaccarat = class("CMsgBaccarat")

CMsgBaccarat.instance_ = nil
function CMsgBaccarat.getInstance()
    if CMsgBaccarat.instance_ == nil then  
        CMsgBaccarat.instance_ = CMsgBaccarat.new()
    end
    return CMsgBaccarat.instance_  
end

function CMsgBaccarat:ctor()

    self.func_game_ =
    {   
        [G_C_CMD.MDM_GF_FRAME] = { --100-游戏框架信息
            [G_C_CMD.SUB_GF_GAME_SCENE]            = { func = self.process_game_scene,     log = "场景信息",  debug = true, },  --101
        },

        [G_C_CMD.MDM_GF_GAME] = { --200-游戏信息
            [G_C_CMD.SUB_S_SysMessage_BACCARAT]    = { func = self.process_system_msg,      log = "系统消息", debug = true, }, --302
            [G_C_CMD.SUB_S_GAME_FREE_BACCARAT]     = { func = self.process_game_free,       log = "游戏空闲", debug = true, }, --99
            [G_C_CMD.SUB_S_GAME_START_BACCARAT]    = { func = self.process_game_start,      log = "游戏开始", debug = true, }, --100
            [G_C_CMD.SUB_S_PLACE_JETTON]           = { func = self.process_chip_ok,         log = "用户下注", debug = true, }, --101
            [G_C_CMD.SUB_S_GAME_END_BACCARAT]      = { func = self.process_game_result,     log = "游戏结束", debug = true, }, --102
            [G_C_CMD.SUB_S_APPLY_BANKER]           = { func = self.process_banker_apply,    log = "申请庄家", debug = true, }, --103
            [G_C_CMD.SUB_S_CHANGE_BANKER]          = { func = self.process_banker_change,   log = "切换庄家", debug = true, }, --104
            [G_C_CMD.SUB_S_CHANGE_USER_SCORE]      = { func = self.process_game_score,      log = "更新分数", debug = true, }, --105
            [G_C_CMD.SUB_S_SEND_RECORD]            = { func = self.process_game_record,     log = "开奖记录", debug = true, }, --106
            [G_C_CMD.SUB_S_PLACE_JETTON_FAIL]      = { func = self.process_chip_failure,    log = "下注失败", debug = true, }, --107
            [G_C_CMD.SUB_S_CANCEL_BANKER]          = { func = self.process_banker_back,     log = "取消申请", debug = true, }, --108
            [G_C_CMD.SUB_S_CONTINUE_NOTIFY]        = { func = self.process_chip_continue,   log = "续投通知", debug = true, }, --110
            [G_C_CMD.SUB_S_CANCELDOWN_NOTIFY]      = { func = self.process_chip_cancel,     log = "清除投注", debug = true, }, --111
            [G_C_CMD.SUB_S_CANCEL_BANKER_SUCCESS]  = { func = self.process_banker_cancel,   log = "取消庄家", debug = true, }, --112
        },
    }
end

function CMsgBaccarat:process_game_scene(__data)--游戏场景
    
    local _buffer = __data:readData(__data:getReadableSize())

    -- 数据
    local msg = {}
    msg.cbTimeLeave = _buffer:readUChar()
    msg.cbGameStatus = _buffer:readUChar()
    msg.lAllBet = {}
    for i = 1, BetArea do
        msg.lAllBet[i] = _buffer:readLongLong()
    end
    msg.lPlayBet = {}
    for i = 1, BetArea do
        msg.lPlayBet[i] = _buffer:readLongLong()
    end
    msg.lPlayBetScore = _buffer:readLongLong()
    msg.lPlayFreeScore = _buffer:readLongLong()
    msg.lPlayScore = {}
    for i = 1, BetArea do
        msg.lPlayScore[i] = _buffer:readLongLong()
    end
    msg.lPlayAllScore = _buffer:readLongLong()
    msg.wBankerUser = _buffer:readUShort()
    msg.lBankerScore = _buffer:readLongLong()
    msg.lBankerWinScore = _buffer:readLongLong()
    msg.wBankerTime = _buffer:readUShort()
    msg.bEnableSystemBanker = _buffer:readUChar()
    msg.lApplyBankerCondition = _buffer:readLongLong()
    msg.lAreaLimitScore = _buffer:readLongLong()

    --扑克信息
    msg.cbCardCount = {}
    for i = 1, 2 do
        msg.cbCardCount[i] = _buffer:readUChar()
    end
    msg.cbTableCardArray = {}
    for i = 1, 2 do
        msg.cbTableCardArray[i] = {}
        for j = 1, 3 do
            msg.cbTableCardArray[i][j] = _buffer:readUChar()
        end
    end

    msg.szGameRoomName = _buffer:readString(64)
    msg.szBankerName = _buffer:readString(64)

    -- 服务器发送过来的是8个筹码数据
    msg.llChipsValues = {}
    for i = 1, 8 do
        msg.llChipsValues[i] = _buffer:readLongLong()
    end

    msg.wGameTax = _buffer:readInt()

    --清理数据
    BaccaratDataMgr.getInstance():clean()

    --保存
    PlayerInfo:getInstance():setUserScore(msg.lPlayFreeScore)
    BaccaratDataMgr.getInstance():setBankerId(msg.wBankerUser)
    BaccaratDataMgr.getInstance():setBankerScore(msg.wBankerUser == INVALID_CHAIR and 999999999 or msg.lBankerScore)
    BaccaratDataMgr.getInstance():setBankerName(msg.wBankerUser == INVALID_CHAIR and "庄家逃跑" or msg.szBankerName)
    BaccaratDataMgr.getInstance():setGameState(msg.cbGameStatus)
    BaccaratDataMgr.getInstance():setBankerTimes(msg.wBankerTime)
    BaccaratDataMgr.getInstance():setBankerCondition(msg.lApplyBankerCondition)
    if BaccaratDataMgr.eType_Bet == msg.cbGameStatus then
        BaccaratDataMgr.getInstance():setStateTime(msg.cbTimeLeave + 1) -- +1是为了衔接的更紧
    elseif BaccaratDataMgr.eType_Award == msg.cbGameStatus then
        BaccaratDataMgr.getInstance():setStateTime(msg.cbTimeLeave + 2) -- +2是为了包含空闲时间
    else
        BaccaratDataMgr.getInstance():setStateTime(msg.cbTimeLeave)
    end
    BaccaratDataMgr.getInstance():setGameTax(msg.wGameTax/10000)
    print("场景消息通知时间:" .. msg.cbTimeLeave)

    --设置6个筹码数据
    for i = 1, ChipNum do
        BaccaratDataMgr.getInstance():setJettonScoreByIndex(i,msg.llChipsValues[i])
    end

    --设置押注数据
    for i = 1, BetArea do
        BaccaratDataMgr.getInstance():setAllBetValue(i, msg.lAllBet[i], 1)
        BaccaratDataMgr.getInstance():setMyBetValue(i, msg.lPlayBet[i], 1)
    end
    --fly jetton
    for i = 1, BetArea do
        --modify
        if msg.cbGameStatus == BaccaratDataMgr.eType_Bet then
            if msg.lPlayBet[i] > 0 then
                BaccaratDataMgr.getInstance():parseJetton(BaccaratDataMgr.eType_MyInit, PlayerInfo:getInstance():getChairID(), i, msg.lPlayBet[i])
            end
            if msg.lAllBet[i] > msg.lPlayBet[i] then
                local _nOther = PlayerInfo:getInstance():getChairID() - 1
                local _nChair = _nOther > 0 and _nOther or _nOther + 2
                local _nBet = msg.lAllBet[i] - msg.lPlayBet[i]
                --ERROR
                BaccaratDataMgr.getInstance():parseJetton(BaccaratDataMgr.eType_OtherInit, _nChair, i, _nBet)
            end
        end
    end
    BaccaratDataMgr.getInstance():resetRemaingBet()
    BaccaratDataMgr.getInstance():setIsLoadGameSceneData(true)
    --通知
    --SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_BACCARAT_INIT, "0")
    self:enterGameScene()

    local ret = string.format("%s", "初始化场景消息")
    return ret
end
------------------------------------------------------------------------------------------------
function CMsgBaccarat:process_system_msg(__data)   -- 302 系统消息
    
    local _buffer = __data:readData(__data:getReadableSize())

    -- 数据
    local msg = {}
    msg.wSysType = _buffer:readShort()            --消息类型 （ 0-普通消息 ）
    msg.szSysMessage = _buffer:readString(512)    --消息内容

    -- 通知
    SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_UPDATE_ROLL_MSG, msg.szSysMessage)  

    local ret = string.format("%s", msg.szSysMessage)
    return ret
end

function CMsgBaccarat:process_game_free(__data)   -- 99 收到空闲

    local _buffer = __data:readData(__data:getReadableSize())

    -- 数据 
    local time = _buffer:readUInt() --剩余时间
    print("游戏空闲时间:" .. time)

    -- 保存
    BaccaratDataMgr.getInstance():setGameState(BaccaratDataMgr.eType_Wait)

    -- 通知
    SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_BACCARAT_STATE, "0")

    local ret = string.format("%s", "游戏空闲")
    return ret
end

function CMsgBaccarat:process_game_start(__data)   -- 100 收到游戏

    local _buffer = __data:readData(__data:getReadableSize())
    
    -- 数据
    local msg = {}
    msg.cbTimeLeave = _buffer:readUChar()         --剩余时间
    msg.wBankerUser = _buffer:readUShort()        --庄家位置
    msg.lBankerScore = _buffer:readLongLong()     --庄家金币
    msg.lPlayBetScore = _buffer:readLongLong()    --玩家最大下注
    msg.lPlayFreeSocre = _buffer:readLongLong()   --玩家自由金币
    msg.nChipRobotCount = _buffer:readInt()       --人数上限 (下注机器人)
    msg.nListUserCount = _buffer:readLongLong()   --列表人数
    msg.nAndriodCount = _buffer:readInt()         --机器人列表人数

    -- 保存
    BaccaratDataMgr.getInstance():setGameState(BaccaratDataMgr.eType_Bet)
    BaccaratDataMgr.getInstance():setStateTime(msg.cbTimeLeave + 1)
    BaccaratDataMgr.getInstance():setBankerId(msg.wBankerUser)
    BaccaratDataMgr.getInstance():setBankerScore(msg.lBankerScore)
    BaccaratDataMgr.getInstance():setBankerTimes(BaccaratDataMgr.getInstance():getBankerTimes() + 1)
    BaccaratDataMgr.getInstance():cleanAllBetValue()
    BaccaratDataMgr.getInstance():cleanUserBet()
    BaccaratDataMgr.getInstance():setIsContinued(false)
    BaccaratDataMgr.getInstance():resetRemaingBet()
    PlayerInfo.getInstance():setUserScore(msg.lPlayBetScore)

    -- 通知
    SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_BACCARAT_STATE, "1")

    local ret = string.format("%s", "游戏开始")
    return ret
end

function CMsgBaccarat:process_chip_ok(__data)   -- 101 下注返回
    
    local _buffer = __data:readData(__data:getReadableSize())

    -- 数据
    local msg = {}
    msg.wChairID = _buffer:readUShort()       --用户位置
    msg.cbBetArea = _buffer:readChar()        --筹码区域
    msg.lBetScore = _buffer:readLongLong()    --加注数目
    msg.cbAndroidUser = _buffer:readUChar()   --机器人标识

    msg.cbBetArea = msg.cbBetArea + 1

    -- 保存下注筹码
    BaccaratDataMgr.getInstance():setAllBetValue(msg.cbBetArea, msg.lBetScore, 1)
    if msg.wChairID == PlayerInfo.getInstance():getChairID() then
        BaccaratDataMgr.getInstance():setMyBetValue(msg.cbBetArea, msg.lBetScore, 1)
        if not BaccaratDataMgr.getInstance():getIsContinued() then
            BaccaratDataMgr.getInstance():cleanContinueBet()
            BaccaratDataMgr.getInstance():setIsContinued(true)
        end
        local bet = {}
        bet.cbBetArea = msg.cbBetArea
        bet.lBetScore = msg.lBetScore
        BaccaratDataMgr.getInstance():addUserBet(bet)
        local llscore = PlayerInfo.getInstance():getUserScore() - msg.lBetScore
        PlayerInfo.getInstance():setUserScore(llscore)
    end

    BaccaratDataMgr.getInstance():resetRemaingBet()

    -- 通知

    if msg.wChairID == PlayerInfo.getInstance():getChairID() then --自己投注直接发送
        SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_BACCARAT_CHIP_SUCCESS, msg)
    else
        --1秒内随机投递事件 最后1秒直接投递
        if BaccaratDataMgr.getInstance():getStateTime() > 1 then
            local randomts = math.random(0,8)/10
            cc.exports.scheduler.performWithDelayGlobal(function()
                SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_BACCARAT_CHIP_SUCCESS, msg)
            end, randomts)
        else
            SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_BACCARAT_CHIP_SUCCESS, msg)
        end
    end

    --local ret = string.format("id[%d]bet[%d]score[%d]", msg.wChairID, msg.cbBetArea, msg.lBetScore)
    --return ret
    --return ""
end

function CMsgBaccarat:process_game_result(__data)   -- 102 收到结算

    local _buffer = __data:readData(__data:getReadableSize())

    -- 数据
    local msg = {}
    ---- 下局信息
    msg.cbTimeLeave = _buffer:readUChar() -- 剩余时间
    ---- 扑克信息
    msg.cbCardCount = {}                  -- 扑克数目
    for i = 1, 2 do
        msg.cbCardCount[i] = _buffer:readUChar()
    end
    msg.cbTableCardArray = {}             -- 桌面扑克
    for i = 1, 2 do
        msg.cbTableCardArray[i] = {}
        for j = 1, 3 do
            msg.cbTableCardArray[i][j] = _buffer:readUChar()
        end
    end
     ---- 庄家信息
     msg.lBankerScore = _buffer:readLongLong()        -- 庄家成绩
     msg.lBankerTotallScore = _buffer:readLongLong()  -- 庄家成绩
     msg.nBankerTime = _buffer:readInt()              -- 做庄次数
     ---- 玩家成绩
     msg.lPlayScore = {}                          --玩家成绩
     for i = 1, BetArea do
        msg.lPlayScore[i] = _buffer:readLongLong()
     end
     msg.lPlayAllScore = 0                        --玩家成绩
     msg.lPlayAllScore = _buffer:readLongLong()
     ---- 全局信息
     msg.lRevenue = _buffer:readLongLong() --游戏税收
     msg.cbRankCount = _buffer:readUChar() --排行数量
     msg.wRankChairID = {}                 --排行id   
     for i = 1, 5 do
        msg.wRankChairID[i] = _buffer:readUShort()
     end
     msg.llRankResult = {}                 --排行分数
     for i = 1, 5 do
        msg.llRankResult[i] = _buffer:readLongLong()
     end

     print("庄家得分:" .. msg.lBankerScore)
     print("玩家得分:" .. msg.lPlayAllScore)

    -- 保存
    BaccaratDataMgr.getInstance():setGameState(BaccaratDataMgr.eType_Award)
    BaccaratDataMgr.getInstance():setStateTime(msg.cbTimeLeave + 2) -- 加上空闲时间2秒
    BaccaratDataMgr.getInstance():setBankerTimes(msg.nBankerTime)
    BaccaratDataMgr.getInstance():setBankerResult(msg.lBankerScore)
    BaccaratDataMgr.getInstance():cleanCard()   --牌面
    for i = 1, 2 do
        for n = 1, 3 do
            if n <= msg.cbCardCount[i] then
                local card = {}
                card.iValue = BaccaratDataMgr.getInstance():GetCardValue(msg.cbTableCardArray[i][n])
                card.iColor = BaccaratDataMgr.getInstance():GetCardColor(msg.cbTableCardArray[i][n])
                BaccaratDataMgr.getInstance():setCard(i, n, card)
            end
        end
    end
    --BaccaratDataMgr.getInstance():addGameRecordByOpen() --加入开奖记录
    BaccaratDataMgr.getInstance():cleanRank()   --结算排行版
    for i = 1, msg.cbRankCount do
        local rank = {}
        rank.wChirId = msg.wRankChairID[i]
        rank.llScore = msg.llRankResult[i]
        BaccaratDataMgr.getInstance():addRank(rank)
    end
    BaccaratDataMgr.getInstance():setContinueBet()  --设置续投
    BaccaratDataMgr.getInstance():setPlayScore(msg.lPlayScore)  --设置

    if BaccaratDataMgr.getInstance():isBanker() then    --庄家
        BaccaratDataMgr.getInstance():setMyResult(msg.lBankerScore)
    else
        BaccaratDataMgr.getInstance():setMyResult(msg.lPlayAllScore)
    end
    

    -- 通知界面 --------------------------------------------------
    SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_BACCARAT_STATE, "2")
    
    local ret = string.format("%s", "游戏结算")
    return ret
end

function CMsgBaccarat:process_banker_apply(__data)   -- 103 申请上庄
    
    local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local wApplyUser = _buffer:readUShort() -- 申请玩家

    --保存
    BaccaratDataMgr.getInstance():addBankerList(wApplyUser);

    local msg = {}
    msg.wCancelUser = wApplyUser
    --通知
    SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_BACCARAT_APPLYBANKER, msg)
    --SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_BACCARAT_APPLYBANKER, wApplyUser)

    --local ret = string.format("id[%d]", wApplyUser)
    --return ret
end

function CMsgBaccarat:process_banker_change(__data)   -- 104 切换庄家

    local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.wBankerUser = _buffer:readUShort() -- 当前庄家
    msg.lBankerScore = _buffer:readLongLong() -- 庄家分数

    --保存
    BaccaratDataMgr.getInstance():setBankerId(msg.wBankerUser)
    local strBankerName = (msg.wBankerUser == INVALID_CHAIR)
        and "庄家逃跑"
        or CUserManager:getInstance():getUserNickByChairID(msg.wBankerUser)
    local llBankerScore = (msg.wBankerUser == INVALID_CHAIR)
        and 9999999999
        or msg.lBankerScore
    BaccaratDataMgr.getInstance():setBankerScore(llBankerScore)
    BaccaratDataMgr.getInstance():setBankerName(strBankerName)
    BaccaratDataMgr.getInstance():setBankerTimes(0)
    BaccaratDataMgr.getInstance():delBankerList(msg.wBankerUser)

    --通知界面
    SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_BACCARAT_BANKER, "changebanker")

    --local ret = string.format("id[%d]name[%s]score[%d]", msg.wBankerUser, strBankerName, msg.lBankerScore)
    --return ret
end
function CMsgBaccarat:process_game_score(__data)   -- 105 更新分数
    print("105 更新分数(没处理)")
end
function CMsgBaccarat:process_game_record(__data)   -- 106 开奖记录

    local len = __data:getReadableSize()
    local _buffer = __data:readData(len)

    --数据
    local _SIZE_OF_A_RECORD = 5 -- size of tagServerGameRecord
    local records = {}
    for i = 1, len / _SIZE_OF_A_RECORD do
        local record = 
        {
            cbKingWinner    = _buffer:readUChar()   ,-- 天王赢家
            bPlayerTwoPair  = _buffer:readBoolean() ,-- 对子标识
            bBankerTwoPair  = _buffer:readBoolean() ,-- 对子标识
            cbPlayerCount   = _buffer:readUChar()   ,--闲家点数
            cbBankerCount   = _buffer:readUChar()   ,--庄家点数
        }
        table.insert(records, record)
    end

    --保存
    for k, v in pairs(records) do
        if BaccaratDataMgr.eType_Bet ~= BaccaratDataMgr.getInstance():getGameState() and k == table.nums(records) then
            BaccaratDataMgr.getInstance():setCacheRecord(records[k])
        else
            BaccaratDataMgr.getInstance():addGameRecord(records[k])
        end
    end

    --通知界面
    SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_BACCARAT_RECORD, "")

    return ""
end

function CMsgBaccarat:process_chip_failure(__data)   -- 107 下注失败

    local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local wPlaceUser = _buffer:readUShort()     -- 下注玩家
    local lBetArea = _buffer:readUChar()        -- 下注区域
    local lPlaceScore = _buffer:readLongLong()  -- 当前下注

    --通知界面
    if PlayerInfo.getInstance():getChairID() == wPlaceUser then
        SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_BACCARAT_CHIP_FAIL)
    end

    --local ret = string.format("id[%d]bet[%d]score[%d]", wPlaceUser, lBetArea, lPlaceScore)
    --return ret
end

function CMsgBaccarat:process_banker_back(__data)   -- 108 申请下庄（已上庄）
    
    local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.wCancelUser = _buffer:readUShort() -- 取消玩家

    --保存
    BaccaratDataMgr.getInstance():delBankerList(msg.wCancelUser);

    --通知
    SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_CANCEL_BANKER, msg)

    local ret = string.format("%s", msg.wCancelUser)
    return ret
end

function CMsgBaccarat:process_chip_continue(__data)   -- 110 续投成功
    
    local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.wChairID = _buffer:readUShort()   -- chardId
    msg.llDownJetton = {}                 -- jetton
    for i = 1 , BetArea do
        msg.llDownJetton[i] = _buffer:readLongLong()
    end

    --保存
    if msg.wChairID == PlayerInfo.getInstance():getChairID() then
        local llScore = 0
        for i = 1, BetArea do
            llScore = llScore + msg.llDownJetton[i]
            BaccaratDataMgr.getInstance():setAllBetValue(i, msg.llDownJetton[i], 1)
            BaccaratDataMgr.getInstance():setMyBetValue(i, msg.llDownJetton[i], 1)
            BaccaratDataMgr.getInstance():parseJetton(BaccaratDataMgr.eType_OtherContinue, msg.wChairID, i, msg.llDownJetton[i])
        end
        PlayerInfo.getInstance():setUserScore(PlayerInfo:getInstance():getUserScore() - llScore)
        BaccaratDataMgr.getInstance():cleanContinueBet()
        BaccaratDataMgr.getInstance():setIsContinued(true)
    else
        if BaccaratDataMgr.getInstance():getGameState() == BaccaratDataMgr.eType_Bet then
            for i = 1, BetArea do
                BaccaratDataMgr.getInstance():setAllBetValue(i, msg.llDownJetton[i], 1)
                BaccaratDataMgr.getInstance():parseJetton(BaccaratDataMgr.eType_OtherContinue, msg.wChairID, i, msg.llDownJetton[i])
            end
        end
    end
    local str = string.format("%d", msg.wChairID)
            
    --通知
    SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_BACCARAT_CHIP_CONTINUE, str)
    BaccaratDataMgr.getInstance():resetRemaingBet()

    --local ret = string.format("id[%d]", msg.wChairID)
    --return ret
end

function CMsgBaccarat:process_chip_cancel(__data)   -- 111 清空投注
    
    local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.wChairID = _buffer:readUShort()   -- chardId
    msg.llDownJetton = {}                 -- jetton
    for i = 1 , BetArea do
        msg.llDownJetton[i] = _buffer:readLongLong()
    end

    --保存
    if msg.wChairID == PlayerInfo.getInstance():getChairID() then
        local llScore= BaccaratDataMgr.getInstance():getMyAllBetValue()
        for i = 1, BetArea do
            BaccaratDataMgr.getInstance():setMyBetValue(i, 0)
            BaccaratDataMgr.getInstance():setAllBetValue(i, msg.llDownJetton[i], -1)
        end
        PlayerInfo.getInstance():setUserScore(PlayerInfo:getInstance():getUserScore() + llScore)
        if BaccaratDataMgr.getInstance():getIsContinued() then
            BaccaratDataMgr.getInstance():setContinueBet()
        end
        BaccaratDataMgr.getInstance():cleanUserBet()
        BaccaratDataMgr.getInstance():setIsContinued(false)
    else
        if BaccaratDataMgr.getInstance():getGameState() == BaccaratDataMgr.eType_Bet then
            for i = 1, BetArea do
                BaccaratDataMgr.getInstance():setAllBetValue(i, msg.llDownJetton[i], -1)
                if msg.llDownJetton[i] > 0 then
                    BaccaratDataMgr.getInstance():addChipCancel(i,msg.llDownJetton[i])
                end
            end
        end
    end
    BaccaratDataMgr.getInstance():resetRemaingBet()

    --通知
    local str = string.format("%d", msg.wChairID)
    SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_BACCARAT_CHIP_CANCEL, str)

    local ret = string.format("%s", msg.wChairID)
    return ret
end

function CMsgBaccarat:process_banker_cancel(__data)   -- 112 取消上庄（未上庄）
    SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_CANCEL_BANKER, "")

    return ""
end


--玩家下注
function CMsgBaccarat:sendMsgChip(iChipIndex, lBetScore)

    local _nMainId = G_C_CMD.MDM_GF_GAME
    local _nSubId = G_C_CMD.SUB_C_PLACE_JETTON
    local wb = WWBuffer:create()
    wb:writeChar(iChipIndex)    --//下注索引
    wb:writeLongLong(lBetScore) --//下注值
    self:sendData(_nMainId, _nSubId, wb)
end
--玩家续投
function CMsgBaccarat:sendMsgChipContinue(listChip)
    
    local _nMainId = G_C_CMD.MDM_GF_GAME
    local _nSubId = G_C_CMD.SUB_C_CONTINUES
    local wb = WWBuffer:create()
    for i = 1, BetArea do
        wb:writeLongLong(listChip[i])
    end
    self:sendData(_nMainId, _nSubId, wb)
end
--清除投注
function CMsgBaccarat:sendMsgChipCancel()

    local _nMainId = G_C_CMD.MDM_GF_GAME
    local _nSubId = G_C_CMD.SUB_C_CANCEL_DOWN
    self:sendNullData(_nMainId, _nSubId)
end
--申请庄家
function CMsgBaccarat:sendMsgBanker(bBanker)

    local _nMainId = G_C_CMD.MDM_GF_GAME
    local _nSubId = bBanker and G_C_CMD.SUB_C_APPLY_BANKER or G_C_CMD.SUB_C_CANCEL_BANKER
    self:sendNullData(_nMainId, _nSubId)
end

return CMsgBaccarat
--endregion

