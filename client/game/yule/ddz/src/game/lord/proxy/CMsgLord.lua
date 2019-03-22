--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local module_pre = "game.yule.ddz.src"
local LordScene_Define  = appdf.req(module_pre .. ".game.lord.scene.LordSceneDefine")
local LordScene_Events  = appdf.req(module_pre .. ".game.lord.scene.LordSceneEvent")

local LordDataMgr       = appdf.req(module_pre .. ".game.lord.bean.LordDataMgr")
local LordGameLogic     = appdf.req(module_pre .. ".game.lord.bean.LordGameLogic")

local FloatMessage      = appdf.req(module_pre .. ".common.layer.FloatMessage")

local CMsgLord = class("CMsgLord", appdf.req(module_pre .. ".common.app.CMsgGame"))
CMsgLord.gclient = nil 
function CMsgLord:getInstance()
    if not CMsgLord.gclient then
        CMsgLord.gclient = CMsgLord:new()
    end
    return CMsgLord.gclient
end

function CMsgLord:ctor()

--    self.func_game_ = {

--        [G_C_CMD.MDM_GF_FRAME] = {  --100
--            [G_C_CMD.SUB_GF_GAME_STATUS]    = { func = self.process_100_100, log = "游戏状态", debug = true, },
--            [G_C_CMD.SUB_GF_GAME_SCENE]     = { func = self.process_100_101, log = "游戏场景", debug = true, },
--        },

--        [G_C_CMD.MDM_GF_GAME] = {   --200
--            [G_C_CMD.SUB_S_GAME_START_LANDLORD] = { func = self.process_200_100, log = "游戏开始",  debug = true, },
--            [G_C_CMD.SUB_S_CALL_SCORE]          = { func = self.process_200_101, log = "玩家叫分",  debug = true, },
--            [G_C_CMD.SUB_S_BANKER_INFO]         = { func = self.process_200_102, log = "确定地主",  debug = true, },
--            [G_C_CMD.SUB_S_OUT_CARD]            = { func = self.process_200_103, log = "玩家出牌",  debug = true, },
--            [G_C_CMD.SUB_S_PASS_CARD]           = { func = self.process_200_104, log = "玩家过牌",  debug = true, },
--            [G_C_CMD.SUB_S_GAME_CONCLUDE]       = { func = self.process_200_105, log = "游戏结束",  debug = true, },
--            [G_C_CMD.SUB_S_TRUSTEESHIP_NOTICE]  = { func = self.process_200_107, log = "玩家托管",  debug = true, },
--            [G_C_CMD.SUB_S_USER_GENDER]         = { func = self.process_200_108, log = "玩家性别",  debug = true, },
--            [G_C_CMD.SUB_S_ADD_TIMES_NOTIFY]    = { func = self.process_200_112, log = "加倍通知",  debug = true, },
--            [G_C_CMD.SUB_S_USER_OUTCARD_FAIL]   = { func = self.process_200_113, log = "出牌错误",  debug = true, },
--        },
--    }
end

--游戏状态
function CMsgLord:process_100_100(__data) 
    
	local _buffer = __data:readData(__data:getReadableSize())

    local msg = {}
    msg.cbGameStatus     = _buffer:readChar()   --//游戏状态
    msg.cbAllowLookon     = _buffer:readChar()  --//旁观标志

    LordDataMgr:getInstance():setGameStatus(msg.cbGameStatus)

    return ""
end

-- 游戏场景
function CMsgLord:process_100_101(__data)
    
    --保存
    LordDataMgr.getInstance():initGameScene(__data)

    --通知
    SLFacade:dispatchCustomEvent(LordScene_Events.MSG_LANDLORD_INIT)

    FloatMessage.getInstance():pushMessageDebug("收到斗地主情景消息")

    return ""
end

--开始游戏
function CMsgLord:process_200_100(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.wStartUser = _buffer:readShort()
    msg.wCurrentUser = _buffer:readShort()
    msg.cbValidCardData = _buffer:readChar()
    msg.cbValidCardIndex = _buffer:readChar()
    msg.cbCardData = {}
    for i = 0, MAX_COUNT-1 do
        msg.cbCardData[i] = _buffer:readChar()
    end

    --保存
    LordDataMgr.getInstance().m_pLastDataMgr = {}
    LordDataMgr.getInstance():OnSubGameStart(msg)
	LordDataMgr.getInstance():setGameOverChairID(-1)
    
    --通知
    SLFacade:dispatchCustomEvent(LordScene_Events.MSG_LANDLORD_START)

    return ""
end

-- 玩家叫分
function CMsgLord:process_200_101(__data)

	local _buffer = __data:readData(__data:getReadableSize())
    
    --数据
    local msg = {}
    msg.wCurrentUser = _buffer:readShort()  --当前用户id
    msg.wCallScoreUser = _buffer:readShort()--叫分用户id
    msg.cbCurrentScore = _buffer:readChar() --当前用户score
    msg.cbUserCallScore = _buffer:readChar()--叫分用户score

    --保存
    LordDataMgr.getInstance():OnSubCallScore(msg)

    --校验自己
    if PlayerInfo.getInstance():getChairID() == msg.wCallScoreUser then
        if LordDataMgr.getInstance():getCallScoreLocal() then
            if LordDataMgr.getInstance():getCallTimeLocal() ~= 255
            and LordDataMgr.getInstance():getCallTimeLocal() ~= msg.cbUserCallScore
            then
                --出错了，重置
                LordDataMgr.getInstance():setCallScoreLocal(false)
                LordDataMgr.getInstance():setCallTimeLocal(0)
                FloatMessage.getInstance():pushMessage("您的叫分操作超时了,默认不叫分。")
            end
        end
    end

    --通知
    SLFacade:dispatchCustomEvent(LordScene_Events.MSG_LANDLORD_CALL)

    return ""
end

-- 确定地主
function CMsgLord:process_200_102(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.wBankerUser = _buffer:readShort() --地主ID
    msg.wCurrentUser = _buffer:readShort() --当前用户ID
    msg.cbBankerScore = _buffer:readChar() --地主分数
    msg.cbBankerCard = {} --地主底牌
    for i = 0, GAME_PLAYER_LANDLORD-1 do
        msg.cbBankerCard[i] = _buffer:readChar()
    end
    msg.cbIsAddTimesModel = _buffer:readChar() --是否进入加倍阶段

    --保存
    LordDataMgr.getInstance():OnSubBankerInfo(msg)

    --通知
    SLFacade:dispatchCustomEvent(LordScene_Events.MSG_LANDLORD_BANKER)

    return ""
end

-- 加倍通知
function CMsgLord:process_200_112(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.wChairID = _buffer:readShort() --椅子ID
    msg.iCurrentTime = _buffer:readInt() --当前倍数
    msg.cbCanOutCard = _buffer:readChar() --当前玩家(地主)是否可以开始出牌/0还不能出牌/非0开始出牌

    --保存
    LordDataMgr.getInstance():onSubAddTimes(msg)

    --校验自己
    if PlayerInfo.getInstance():getChairID() == msg.wChairID then
        if LordDataMgr.getInstance():getAddScoreLocal() then
            if LordDataMgr.getInstance():getAddTimeLocal() == 2 --本地加倍
            and msg.iCurrentTime == 1 --收到未加倍
            then
                LordDataMgr.getInstance():setAddScoreLocal(false)
                LordDataMgr.getInstance():setAddTimeLocal(0)
                FloatMessage.getInstance():pushMessage("您的加倍操作超时了,默认不加倍。")
            end
        end
    end

    --保存所有数据
    if msg.cbCanOutCard > 0 then
        LordDataMgr.getInstance():setLastAction(0)
        local strData = string.format("%d,%d,%d",msg.wChairID,msg.iCurrentTime,msg.cbCanOutCard)
        LordDataMgr.getInstance():setAddTimeData(strData)
        LordDataMgr.getInstance():SaveLast()
    end

    --通知
--    local strData = string.format("%d,%d,%d",msg.wChairID,msg.iCurrentTime,msg.cbCanOutCard)
--	local _event = {
--        name = LordScene_Events.MSG_LANDLORD_ADDTIME_NOTIFY,
--		packet = strData,
--	}
    SLFacade:dispatchCustomEvent(LordScene_Events.MSG_LANDLORD_ADDTIME_NOTIFY)

    return ""
end

-- 玩家出牌
function CMsgLord:process_200_103(__data)
	
    local _buffer = __data:readData(__data:getReadableSize()) 

    --数据
    local msg = {}
    msg.cbCardCount = _buffer:readChar() --出牌数目
    msg.wCurrentUser = _buffer:readShort() --当前玩家
    msg.wOutCardUser = _buffer:readShort() --出牌玩家
    msg.cbCardData = {} --扑克列表
    for i = 0, msg.cbCardCount-1 do
        msg.cbCardData[i] = _buffer:readChar()
    end

    --测试代码---------------------------------------------------------

    --本地已过牌
    if LordDataMgr.getInstance():getPassCardLocal() then
        --数据还原/还原上一次场景
        LordDataMgr.getInstance():RecoverLast()
    end
    --本地已出牌
    if LordDataMgr.getInstance():getOutCardLocal() then
        --校验数据
        local bSameCard = true
        local cbCardData = LordDataMgr.getInstance():getLastOutCardData()
        if table.nums(cbCardData) ~= table.nums(msg.cbCardData) then
            FloatMessage.getInstance():pushMessage("您的出牌操作超时了。")
            bSameCard = false
        end
        if bSameCard then
            table.sort(cbCardData, function(a, b) return a > b end)
            table.sort(msg.cbCardData, function(a, b) return a > b end)
            for i, v in pairs(msg.cbCardData) do
                if cbCardData[i] ~= msg.cbCardData[i] then
                    FloatMessage.getInstance():pushMessage("您的出牌操作超时了。")
                    bSameCard = false
                    break
                end
            end
        end
        --如果出牌不过，数据还原，正常出牌
        if bSameCard == false then
            --数据还原/还原上一次场景
            LordDataMgr.getInstance():RecoverLast()
        end
        --如果相同，正常流程
    end

    --保存出牌
    LordDataMgr.getInstance():OnOutCard(msg)

    --保存最近一次出牌行为
    LordDataMgr.getInstance():setLastAction(1)

    --保存所有数据
    LordDataMgr.getInstance():SaveLast()

    --通知
    SLFacade:dispatchCustomEvent(LordScene_Events.MSG_LANDLORD_OUTCARD)

    return ""
end

-- 玩家过牌
function CMsgLord:process_200_104(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.cbTurnOver = _buffer:readChar()--一轮结束
    msg.wCurrentUser = _buffer:readShort()--当前玩家
    msg.wPassCardUser = _buffer:readShort()--放弃玩家
    
    --本地已出牌的话
    if LordDataMgr.getInstance():getOutCardLocal() then
        --数据还原
        LordDataMgr.getInstance():RecoverLast()
        --正常过牌
    end
    --本地已过牌的话
    if LordDataMgr.getInstance():getPassCardLocal() then
        --正常流程
    end

    --保存
    LordDataMgr.getInstance():OnPassCard(msg)

    --保存最近一次过牌行为
    LordDataMgr.getInstance():setLastAction(2)

    --保存所有数据
    LordDataMgr.getInstance():SaveLast()

    --通知
    SLFacade:dispatchCustomEvent(LordScene_Events.MSG_LANDLORD_PASS)

    return ""
end

-- 游戏结束
function CMsgLord:process_200_105(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.lCellScore = _buffer:readLongLong()--单元积分
    msg.lGameScore = {}--游戏积分
    for i = 0, 2 do
        msg.lGameScore[i] = _buffer:readLongLong()
    end
    msg.bChunTian = _buffer:readChar()--春天标志
    msg.bFanChunTian = _buffer:readChar()--反春天标志
    msg.cbBombCount = _buffer:readChar()--炸弹个数
    msg.cbEachBombCount = {}
    for i = 0, 2 do
        msg.cbEachBombCount[i] = _buffer:readChar()
    end
    msg.cbBankerScore = _buffer:readChar()--叫分数目
    msg.cbCardCount = {}--扑克数目
    for i = 0, 2 do
        msg.cbCardCount[i] = _buffer:readChar()
    end
    msg.cbHandCardData = {}--扑克列表
    for i = 0, 54-1 do
        msg.cbHandCardData[i] = _buffer:readChar()
    end

    --保存
    LordDataMgr.getInstance():OnConclude(msg)
    LordDataMgr.getInstance():setGameOverChairID(PlayerInfo.getInstance():getChairID())

    --通知
    SLFacade:dispatchCustomEvent(LordScene_Events.MSG_LANDLORD_CONCLUDE)

    return ""
end

-- 玩家托管
function CMsgLord:process_200_107(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.wChairID = _buffer:readShort()--椅子ID
    msg.cbCoutrolIndex = _buffer:readChar()--0取消托管/非0开始托管

    --保存
    LordDataMgr.getInstance():setUserRobotStatus(msg.wChairID, msg.cbCoutrolIndex)
    LordDataMgr.getInstance().m_cbUserRobot[msg.wChairID] = msg.cbCoutrolIndex

    --通知
    SLFacade:dispatchCustomEvent(LordScene_Events.MSG_USER_ROBOT)

    return ""
end

-- 获得玩家性别(不用)
function CMsgLord:process_200_108(__data)

	local _buffer = __data:readData(__data:getReadableSize())
    
    --数据
    local msg = {}
    msg.wChairID = _buffer:readShort()--椅子ID
    msg.cbUserGender = _buffer:readChar()--性别

    --日志
    return ""
end

function CMsgLord:process_200_113(__data)
    
	local _buffer = __data:readData(__data:getReadableSize())
    
    --struct CMD_S_UserOutCardFail {
    --	WORD	wCurrentUser;				//当前玩家
    --	BYTE	cbCardData[MAX_COUNT];		//扑克数据
    --	BYTE	cbCardCount;				//手牌数
    --	BYTE	cbTurnCardData[MAX_COUNT];	//上轮出牌
    --	BYTE	cbTurnCardCount;			//上轮出牌数
    --	TCHAR	szFailReason[64];			//失败原因
    --};

    --保存数据
    local msg = {}
    msg.wCurrentUser = _buffer:readShort() --当前玩家
    msg.cbCardData = {} --扑克数据
    for i = 0, MAX_COUNT-1 do
        msg.cbCardData[i] = _buffer:readChar()
    end
    msg.cbCardCount = _buffer:readChar() --手牌数
    msg.cbTurnCardData = {} --上轮出牌
    for i = 0, MAX_COUNT-1 do
        msg.cbTurnCardData[i] = _buffer:readChar()
    end
    msg.cbTurnCardCount = _buffer:readChar() --上轮出牌数
    msg.szFailReason = _buffer:readString(64) --失败原因


    --处理 -------------------------------------------------------

    --去掉无效数据
    for i = 0, MAX_COUNT-1 do
        if i >= msg.cbCardCount then
            msg.cbCardData[i] = 0
        end
        if i >= msg.cbTurnCardCount then
            msg.cbTurnCardData[i] = 0
        end
    end

    --排序
    LordGameLogic.getInstance():SortCardList(msg.cbCardData, msg.cbCardCount)
    LordGameLogic.getInstance():SortCardList(msg.cbTurnCardData, msg.cbTurnCardCount)

    --提示
    FloatMessage.getInstance():pushMessage(msg.szFailReason)

    --还原上一次出牌/过牌场景
    LordDataMgr.getInstance():RecoverLast()

    --用服务器覆盖本地
    if PlayerInfo.getInstance():getChairID() == msg.wCurrentUser then

        --旧数据
        local viewChair = LordDataMgr.getInstance():SwitchViewChairID(msg.wCurrentUser)
        local nCardCount = LordDataMgr.getInstance().m_cbHandCardCount[viewChair]

        --调试信息    
        local strServerCount = string.format("服务器牌数:[%d]", msg.cbCardCount)
        local strLocalCount = string.format("本地牌数:[%d]", nCardCount)
        local strServerCard = getCardStrings(msg.cbCardData)
        local strLocalCard = getCardStrings(LordDataMgr.getInstance().m_cbHandCardData)
        print("牌数:", strServerCount, strLocalCount)
        print("旧数据:", strLocalCard)
        print("服务器:", strServerCard)

        --覆盖本地数据
        LordDataMgr.getInstance().m_cbHandCardCount[viewChair] = msg.cbCardCount
        LordDataMgr.getInstance().m_cbHandCardData = table.deepcopy(msg.cbCardData)
    end

    --还原开始出牌
    if LordDataMgr.getInstance():getLastAction() == 0 then
	    local _event = {
            name = LordScene_Events.MSG_LANDLORD_ADDTIME_NOTIFY,
		    packet = LordDataMgr.getInstance():getAddTimeData(),
	    }
        SLFacade:dispatchCustomEvent(LordScene_Events.MSG_LANDLORD_ADDTIME_NOTIFY, _event)
    end
    --还原上一次出牌
    if LordDataMgr.getInstance():getLastAction() == 1 then
        SLFacade:dispatchCustomEvent(LordScene_Events.MSG_LANDLORD_OUTCARD)
    end
    --还原上一次过牌
    if LordDataMgr.getInstance():getLastAction() == 2 then
        SLFacade:dispatchCustomEvent(LordScene_Events.MSG_LANDLORD_PASS)
    end
    --处理 -------------------------------------------------------
end

--匹配
function CMsgLord:sendMatch()
    local wb = WWBuffer:create()

    self:sendData(G_C_CMD.MDM_GR_USER, G_C_CMD.SUB_GR_USER_MATCH, wb)
end

--托管
function CMsgLord:sendTrusteeship(state)
    local wb = WWBuffer:create()
    wb:writeChar(state)

    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_TRUSTEESHIP, wb)
end

--叫分
function CMsgLord:sendCallScore(score)
    local wb = WWBuffer:create()
    wb:writeChar(score)

    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_CALL_SCORE, wb)
end

--过牌
function CMsgLord:sendPassCard()
    local wb = WWBuffer:create()

    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_PASS_CARD, wb)
end

--出牌
function CMsgLord:sendOutCard(cbCardData, cbCardCount)
    local wb = WWBuffer:create()
    wb:writeChar(cbCardCount)
    for i = 0, cbCardCount-1 do
        wb:writeChar(cbCardData[i])
    end

    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_OUT_CARD, wb)
end
--加倍
function CMsgLord:sendAddTimes(times)
    local wb = WWBuffer:create()
    wb:writeChar(times)

    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_ADD_TIMES, wb)
end

return CMsgLord
--endregion
