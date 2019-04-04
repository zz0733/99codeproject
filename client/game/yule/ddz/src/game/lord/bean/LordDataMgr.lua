--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local module_pre = "game.yule.ddz.src"
local LordScene_Define  = appdf.req(module_pre .. ".game.lord.scene.LordSceneDefine")
local LordScene_Events  = appdf.req(module_pre .. ".game.lord.scene.LordSceneEvent")
local LordGameLogic = appdf.req(module_pre .. ".game.lord.bean.LordGameLogic")

local LordDataMgr = class("LordDataMgr")

LordDataMgr.m_pLordDataMgr = nil

LordDataMgr.m_cbHandCardData = {}
LordDataMgr.m_cbUserRobot = {}
LordDataMgr.m_pGameConclude = {}
LordDataMgr.m_cbUserOffLineTimes = {}
LordDataMgr.m_cbGender = {}
LordDataMgr.m_iAddTimes = {}

LordDataMgr.m_pLastDataMgr = {}

function LordDataMgr.getInstance()
    if LordDataMgr.m_pLordDataMgr == nil then
        LordDataMgr.m_pLordDataMgr = LordDataMgr:new()
    end
    return LordDataMgr.m_pLordDataMgr
end

function LordDataMgr:ctor()
    -- body
    self.m_nGameOverChairId = -1
    self:Clean()
end

function LordDataMgr:Clean()
    self.m_cbGameStatus = GS_T_FREE
    self.m_wCurrentUser = 0
    self.m_wCallScoreUser = 0
    self.m_cbBankerScore = 0
    self.m_wBankerUser = INVALID_CHAIR;
    self.m_wTurnWiner = 0
    self.m_cbSearchResultIndex = 0
    self.m_cbTurnCardCount = 0
    self.m_cbLastOutCardCount = 0
    self.m_cbTimeOutCard = 30
    self.m_cbTimeCallScore = 10
    self.m_cbTimeHeadOutCard = 30
    self.m_cbTimeAddTimes = 10
    self.m_wStartUser = 0
    self.m_iMuliple = 0
    self.m_iBombCount = 0 --记录炸弹数量
    self.m_iTimesLimit = 0
    self.m_bGameStart = false
    self.m_cbUserCallScore = 0
    self.m_wPassCardUser = 0
    self.m_cbTurnOver = 0
    self.m_wOutCardUser = 0
    self.m_cbOutCardCount = 0
    self.m_cbRecountOutCardCount = 0
    self.m_cbIsAddTimesStatus = 0;

    self.m_cbHandCardData = {}
    for i = 0, MAX_COUNT-1 do
        self.m_cbHandCardData[i] = 0
    end
    self.m_cbHandCardCount = {}
    for i = 0, GAME_PLAYER_LANDLORD-1 do
        --self.m_cbHandCardCount[i] = 0
        self.m_cbHandCardCount[i] = NORMAL_COUNT  -- 初始化默认牌张数
    end
    self.m_SearchCardResult = {}
    self.m_SearchCardResult.cbSearchCount = 0
    self.m_SearchCardResult.cbCardCount = {}
    for i = 0, MAX_COUNT-1 do
        self.m_SearchCardResult.cbCardCount[i] = 0
    end
    self.m_SearchCardResult.cbResultCard = {}
    for i = 0, MAX_COUNT-1 do
        self.m_SearchCardResult.cbResultCard[i] = {}
        for j = 0, MAX_COUNT-1 do
            self.m_SearchCardResult.cbResultCard[i][j] = 0
        end
    end
    self.m_cbTurnCardData = {}
    for i = 0, MAX_COUNT-1 do
        self.m_cbTurnCardData[i] = 0
    end
    self.m_cbScoreInfo = {}                 --索引是chairID
    for i = 0, GAME_PLAYER_LANDLORD-1 do
        self.m_cbScoreInfo[i] = 0
    end
    self.m_cbGender = {}
    for i = 0, GAME_PLAYER_LANDLORD-1 do
        self.m_cbGender[i] = 0
    end
    self.m_cbUserOffLineTimes = {}
    for i = 0, GAME_PLAYER_LANDLORD-1 do
        self.m_cbUserOffLineTimes[i] = 0
    end
    self.m_cbUserRobot = {}
    for i = 0, GAME_PLAYER_LANDLORD-1 do
        self.m_cbUserRobot[i] = 0
    end
    self.m_cbBankerCard = {}                --地主三张牌
    for i = 0, 2 do
        self.m_cbBankerCard[i] = 0
    end
    self.m_cbOutCardData = {}               --记录自己出的牌
    for i = 0, MAX_COUNT-1 do
        self.m_cbOutCardData[i] = 0
    end
    self.m_cbRecordOutCardData = {}
    for i = 0, MAX_COUNT-1 do
        self.m_cbRecordOutCardData[i] = 0
    end
    for i = 0, GAME_PLAYER_LANDLORD-1 do
        self.m_iAddTimes[i]= 0
    end
    self.m_bIsCall = {} --是否叫分
    for i = 0, 2 do
        self.m_bIsCall[i] = false
    end
    self.m_bLeftCard = false
    self.m_nLeftCard = {
        [1]  = 4, --"3",
        [2]  = 4, --"4",
        [3]  = 4, --"5", 
        [4]  = 4, --"6",
        [5]  = 4, --"7",
        [6]  = 4, --"8",
        [7]  = 4, --"9",
        [8]  = 4, --"10",
        [9]  = 4, --"J",
        [10] = 4, --"Q",
        [11] = 4, --"K",
        [12] = 4, --"A",
        [13] = 4, --"2",
        [14] = 1, --"小王",
        [15] = 1, --"大王",
    }
    --没初始化的变量
    self.m_llBaseScore = 0
    self.m_nOffLineChairID = INVALID_CHAIR
    self.m_pRobotChairID = INVALID_CHAIR
    self.m_pCoutrolIndex = 0

    --新增
    self.m_bCallScoreLocal = false  --是否本地叫分
    self.m_nCallTimeLocal = 0       --本地叫分
    self.m_bAddScoreLocal = false   --是否本地加倍
    self.m_nAddTimeLocal = 0        --本地倍数
    self.m_bPassCardLocal = false   --是否本地过牌
    self.m_bOutCardLocal = false    --是否本地出牌
    self.m_cbLastOutCardData = {}   --上次出牌数据
    self.m_nLastAction = -1         --最一次出牌行为
    self.iOverTimesLimt = 5         --强制托管次数
    self.m_pAddTimeData = ""        --开始出牌数据
    self.m_pLastDataMgr = {}        --最近所有数据

    self.m_wAddTimeChairID = INVALID_CHAIR
    self.m_iAddTimeCurrentTime = 0
    self.m_cbAddTimeCanOutCard = 0

    self.m_nMeChairID = -1
    self.m_nMeViewChairID = -1

    self.m_pGameConclude = {}
end

local function CopyMemory(data1, data2, i, j, count)
    for n = 0, count-1 do
        data1[i + n] = data2[j + n]
    end
    return data1
end

local function ZeroMemory(data, count)
    data = {}
    for n = 0, count-1 do
        data[n] = 0
    end
    return data
end
--=> 重进后刷新牌桌
--{
--'type': 'ddz', 'tag': 'update',
--'body': {
--	'deskid': 455001, #牌桌号
--	'step': self.step, #0叫, 1加, 2出
--	'call_times': self.call_times, #叫牌次数
--	'double': 32, #当前倍数
--	'mycards': [1,4,5,3,10,33], #我的牌
--	'current_state': *current_state, #所有人的状态
--	'thisone': self.this.uid if self.this else 0,
--	'lastone': self.last.uid if self.last else 0,
--	'showed_cards': [1,2,3,4,5,...], #已出过的牌,用于计牌器
--	'hide_cards': [11,22,33], #补牌
--	'banker': 100244, #地主
--	'banker_cards': [] #地主的明牌
--	'task': newplayer.task_value, #本局任务(同发牌消息)
--	'timeout': 5, #倒计时剩余秒数
--	}
--}

--*current_state = []
--{
--'uid': player.uid,
--'managed': player.managed, #是否托管
--'hold_num': len(player.cards), #剩余牌数
--'lastput': [c.val for c in player.lastput], #上一手出的牌
--'lastput_type': player.lastput_type, #上一手出的牌的牌型
--'callpt': player.callpt, #-1:还未叫;0:不叫; 1:叫
--'raised': player.raised, #-1:还未加倍, 0:不加倍, 1:加倍
--}
function LordDataMgr:initGameScene(__data)
    if not __data then
        return false
    end
	local msg = __data
--    --时间信息
--    msg.cbTimeOutCard = _buffer:readChar()		--出牌时间
--    msg.cbTimeCallScore = _buffer:readChar()	--叫分时间
--    msg.cbTimeStartGame = _buffer:readChar()	--开始时间
--    msg.cbTimeHeadOutCard = _buffer:readChar()	--首出时间
--    --游戏变量
--    msg.lCellScore = _buffer:readLongLong()		--单元积分
--    msg.cbBombCount = _buffer:readChar()		--炸弹次数
--    msg.wBankerUser = _buffer:readShort()		--庄家用户
--    msg.wCurrentUser = _buffer:readShort()		--当前玩家
--    msg.cbBankerScore = _buffer:readChar()		--庄家叫分
--    --出牌信息
--    msg.wTurnWiner = _buffer:readShort()		--胜利玩家
--    msg.cbTurnCardCount = _buffer:readChar()	--出牌数目
--    msg.cbTurnCardData = {}                     --出牌数据
--    for i = 0, MAX_COUNT-1 do
--        msg.cbTurnCardData[i] = _buffer:readChar()              
--    end
--    --扑克信息
--    --游戏底牌
--    msg.cbBankerCard = {}
--    for i = 0, GAME_PLAYER_LANDLORD-1 do
--        msg.cbBankerCard[i] = _buffer:readChar()
--    end
--    --手上扑克
--    msg.cbHandCardData = {}
--    for i = 0, MAX_COUNT-1 do
--        msg.cbHandCardData[i] = _buffer:readChar()
--    end
--    --扑克数目
--    msg.cbHandCardCount = {}
--    for i = 0, GAME_PLAYER_LANDLORD-1 do
--        msg.cbHandCardCount[i] = _buffer:readChar()
--    end
--    --历史积分
----        msg.lTurnScore = {}
----        for i = 0, GAME_PLAYER_LANDLORD-1 do
----            msg.lTurnScore[i] = _buffer:readLongLong()
----        end
--    --积分信息
--    msg.lCollectScore = {}
--    for i = 0, GAME_PLAYER_LANDLORD-1 do
--        msg.lCollectScore[i] = _buffer:readLongLong()
--    end
--    --玩家断线次数
    msg.cbUserOffLineTimes = {}
    for i = 0, GAME_PLAYER_LANDLORD-1 do
        msg.cbUserOffLineTimes[i] = 0
    end
--    --倍数封顶
--    msg.iTimesLimit = _buffer:readInt()
--    --玩家托管
    msg.cbUserTrusteeShip = {}
    for i = 0, GAME_PLAYER_LANDLORD-1 do
        msg.cbUserTrusteeShip[i] = 0
    end
--    --房间类型
----        msg.wServerType = _buffer:readShort()
--    --农民加倍
--    msg.iAddTimes = {};
--    for i = 0, GAME_PLAYER_LANDLORD-1 do
--        msg.iAddTimes[i] = _buffer:readInt()
--    end
--    --加倍时间
--    msg.cbTimeAddTimes = _buffer:readChar();
--    --强制托管次数
--    msg.iOverTimesLimt = _buffer:readUInt();

    --for k,v in pairs(msg) do
    --    print(k .. " : " .. tostring(v))
    --end

    self.m_llBaseScore = msg.lCellScore
    PlayerInfo.getInstance():setBaseScore(msg.lCellScore)
    self.m_cbTimeOutCard = msg.cbTimeOutCard
--    self.m_cbTimeCallScore = msg.cbTimeCallScore
--    self.m_cbTimeHeadOutCard = msg.cbTimeHeadOutCard
--    self.m_cbTimeAddTimes = msg.cbTimeAddTimes
    self.m_wCurrentUser = msg.wCurrentUser
--    self.m_cbBankerScore = msg.cbBankerScore
    self.m_wBankerUser = msg.wBankerUser
    self.m_wTurnWiner = msg.wTurnWiner
--    self.iOverTimesLimt = msg.iOverTimesLimt

    self.m_cbBankerCard = {}
    self.m_cbBankerCard = CopyMemory(self.m_cbBankerCard, msg.cbBankerCard, 0, 0, GAME_PLAYER_LANDLORD)

    --出牌数据
    self.m_cbOutCardCount = msg.cbTurnCardCount
    self.m_cbOutCardData = {}
    self.m_cbOutCardData = CopyMemory(self.m_cbOutCardData, msg.cbTurnCardData, 0, 0, msg.cbTurnCardCount)
    self.m_cbTurnCardCount = msg.cbTurnCardCount
    self.m_cbTurnCardData = {}
    self.m_cbTurnCardData = CopyMemory(self.m_cbTurnCardData, msg.cbTurnCardData, 0, 0, msg.cbTurnCardCount)
    for i = 0, GAME_PLAYER_LANDLORD-1 do
--        print("托管状态:"..msg.cbUserTrusteeShip[i])
--        print("断线次数:"..msg.cbUserOffLineTimes[i])
        local viewChair = self:SwitchViewChairID(i)
        local count = msg.cbHandCardCount[i]
        --self.m_cbHandCardCount[viewChair] = count
        self.m_cbHandCardCount[i] = count
--        self.m_iAddTimes[i] = msg.iAddTimes[i];
    end
    local handCardCount = getCardCount(msg.cbHandCardData)
    self.m_cbHandCardData = {}
    self.m_cbHandCardData = CopyMemory(self.m_cbHandCardData, msg.cbHandCardData, 0, 0, handCardCount)
    --修复:有时候未排序
    LordGameLogic.getInstance():SortCardList(self.m_cbHandCardData, handCardCount, ST_ORDER)
    self.m_cbUserOffLineTimes = {}  
    
    self.m_cbUserOffLineTimes = CopyMemory(self.m_cbUserOffLineTimes, msg.cbUserOffLineTimes, 0, 0, GAME_PLAYER_LANDLORD)
    self.m_cbUserOffLineTimes[PlayerInfo.getInstance():getChairID()] = 0
    self.m_cbUserRobot = {}
    
    self.m_cbUserRobot = CopyMemory(self.m_cbUserRobot, msg.cbUserTrusteeShip, 0, 0, GAME_PLAYER_LANDLORD)
    self.m_cbUserRobot[PlayerInfo.getInstance():getChairID()] = 0
    self.m_iTimesLimit = msg.iTimesLimit
    self.m_iMuliple = self.m_cbBankerScore
    self.m_iBombCount = msg.cbBombCount
    if msg.cbBombCount > 0 then
        local muliple = self.m_cbBankerScore * math.pow(2, msg.cbBombCount)
        self.m_iMuliple = muliple
        if muliple > self.m_iTimesLimit then
            self.m_iMuliple = self.m_iTimesLimit
        end
    end

    if self:CurrentUserIsMe() then
        self:searchOutCard()
    end

    return true
end

function LordDataMgr:OnSubGameStart(pGameStart)

    self.m_wCurrentUser = pGameStart.wCurrentUser
    self.m_wStartUser = pGameStart.wStartUser
    for i = 0, GAME_PLAYER_LANDLORD-1 do
        self.m_cbHandCardCount[i] = NORMAL_COUNT
    end
    self.m_cbHandCardData = {}
    self.m_cbHandCardData = CopyMemory(self.m_cbHandCardData, pGameStart.cbCardData, 0, 0, NORMAL_COUNT)
    
    --暂不排序
    --LordGameLogic:getInstance():SortCardList(self.m_cbHandCardData, self.m_cbHandCardCount[wMeChairID],ST_ORDER)

    self.m_bGameStart = true
    self.m_cbGameStatus = GS_T_CALL    
    --重置记录自己出牌数据
    self.m_cbRecountOutCardCount = 0
    self.m_cbRecordOutCardData = {}
    for i = 0, MAX_COUNT-1 do
        self.m_cbRecordOutCardData[i] = 0
        self.m_bIsCall[i] = false --重新叫分
    end
    return true
end

function LordDataMgr:OnSubCallScore(pCallScore)

    self.m_wCurrentUser = pCallScore.wCurrentUser
    self.m_wCallScoreUser = pCallScore.wCallScoreUser
    self.m_cbUserCallScore = pCallScore.cbUserCallScore
    if pCallScore.cbUserCallScore ~= 255 then
        self.m_cbBankerScore = math.max(self.m_cbBankerScore, pCallScore.cbUserCallScore)
    end
    
    self.m_cbGameStatus = GS_T_CALL

    self.m_bIsCall[pCallScore.wCallScoreUser] = true

    return true
end

function LordDataMgr:onSubAddTimes(pAddTimes)
    
    self.m_wAddTimeChairID = pAddTimes.wChairID
    self.m_iAddTimeCurrentTime = pAddTimes.iCurrentTime
    self.m_cbAddTimeCanOutCard = pAddTimes.cbCanOutCard

    --保存加倍
    self.m_iAddTimes[pAddTimes.wChairID] = pAddTimes.iCurrentTime
end

function LordDataMgr:OnSubBankerInfo(pBankerInfo)

    self.m_wBankerUser = pBankerInfo.wBankerUser
    self.m_wCurrentUser = pBankerInfo.wCurrentUser
    self.m_wTurnWiner = pBankerInfo.wBankerUser
    self.m_cbBankerScore = pBankerInfo.cbBankerScore
    self.m_cbBankerCard = {}
    self.m_cbBankerCard = CopyMemory(self.m_cbBankerCard, pBankerInfo.cbBankerCard, 0, 0, LANDLORD_COUNT)
    self.m_cbIsAddTimesStatus = pBankerInfo.cbIsAddTimesModel

    if self:bankIsMe() then
        self.m_cbHandCardCount[self:GetMeChairID()] = self.m_cbHandCardCount[self:GetMeChairID()] + LANDLORD_COUNT
        self.m_cbHandCardData = CopyMemory(self.m_cbHandCardData, pBankerInfo.cbBankerCard, NORMAL_COUNT, 0, LANDLORD_COUNT)
        LordGameLogic:getInstance():SortCardList(self.m_cbHandCardData, self.m_cbHandCardCount[self:GetMeChairID()], ST_ORDER)
    else
        --local chairid = self:SwitchViewChairID(pBankerInfo.wBankerUser)
        --self.m_cbHandCardCount[chairid] = self.m_cbHandCardCount[chairid] + 3
        self.m_cbHandCardCount[pBankerInfo.wBankerUser] = self.m_cbHandCardCount[pBankerInfo.wBankerUser] + LANDLORD_COUNT
    end
    self:searchOutCard()
    self.m_cbLastOutCardCount = 0
    self.m_iMuliple = self.m_cbBankerScore

    return true
end

function LordDataMgr:OnOutCard(pOutCard)

    self.m_wCurrentUser = pOutCard.wCurrentUser
    self.m_wOutCardUser = pOutCard.wOutCardUser
    self.m_wTurnWiner = pOutCard.wOutCardUser
    self.m_cbOutCardData = {}
    self.m_cbOutCardData = CopyMemory(self.m_cbOutCardData, pOutCard.cbCardData,0, 0, pOutCard.cbCardCount)
    self.m_cbOutCardCount = pOutCard.cbCardCount
    
    if (pOutCard.wOutCardUser ==PlayerInfo.getInstance():getChairID()) then
        for i = 0, pOutCard.cbCardCount-1 do
            --CCLOG("out card :%d",pOutCard->cbCardData[i]);
            local index = self.m_cbRecountOutCardCount + i
            self.m_cbRecordOutCardData[index] = pOutCard.cbCardData[i]
        end
        self.m_cbRecountOutCardCount = self.m_cbRecountOutCardCount + pOutCard.cbCardCount
        local isRemoveSuc = true
        isRemoveSuc, self.m_cbHandCardData = LordGameLogic:getInstance():RemoveCardList(pOutCard.cbCardData, pOutCard.cbCardCount, self.m_cbHandCardData, self:getMeCardCount())
    end
    --local chairID = self:SwitchViewChairID(pOutCard.wOutCardUser)
    --self.m_cbHandCardCount[chairID] = self.m_cbHandCardCount[chairID] - pOutCard.cbCardCount
    self.m_cbHandCardCount[pOutCard.wOutCardUser] = self.m_cbHandCardCount[pOutCard.wOutCardUser] - pOutCard.cbCardCount

    if (self:canPass()) then
        self.m_cbTurnCardData = {}
        self.m_cbTurnCardData = CopyMemory(self.m_cbTurnCardData, pOutCard.cbCardData, 0, 0, pOutCard.cbCardCount)
        self.m_cbTurnCardCount = pOutCard.cbCardCount
    else
        self.m_cbTurnCardCount = 0
        self.m_cbTurnCardData = {}
        for i = 0, MAX_COUNT-1 do
            self.m_cbTurnCardData[i] = 0
        end
        self.m_cbLastOutCardCount = 0
    end
    if (self:CurrentUserIsMe()) then
        self:searchOutCard()
    end
    
    local cardtype = LordGameLogic:getInstance():GetCardType(pOutCard.cbCardData, pOutCard.cbCardCount)
    if (cardtype == CT_MISSILE_CARD or cardtype == CT_BOMB_CARD) then
        self.m_iMuliple = self.m_iMuliple * 2
        self.m_iBombCount = self.m_iBombCount + 1 --炸弹数+1
    end

    self.m_cbGameStatus = GS_T_PLAY

    return true
end

function LordDataMgr:OnPassCard(pPassCard)

    self.m_wCurrentUser = pPassCard.wCurrentUser
    self.m_wPassCardUser = pPassCard.wPassCardUser
    self.m_cbTurnOver = pPassCard.cbTurnOver

    if (pPassCard.cbTurnOver == 1) then
         self.m_cbTurnCardCount = 0
         self.m_cbTurnCardData = {}
         for i = 0, MAX_COUNT-1 do
            self.m_cbTurnCardData[i] = 0
         end
        self.m_cbLastOutCardCount = 0
    end
    if (self:CurrentUserIsMe()) then
        self:searchOutCard()
    end
    
    self.m_cbGameStatus = GS_T_PLAY
    return true
end

function LordDataMgr:OnConclude(pGameConclude)
--{bomb_times=0 user_win_money={} double=1 rocket_times=0 is_spring=false system_win=0 winner=68918296 }{winmoney=-20 tax=0 cards={} uid=77164409 }
    --保存数值
--    self.m_pGameConclude.lCellScore = pGameConclude.lCellScore
    self.m_pGameConclude.lGameScore = {}
    for i = 0, 2 do
        self.m_pGameConclude.lGameScore[i] = pGameConclude.user_win_money[i+1].winmoney
    end
    self.m_pGameConclude.bChunTian = pGameConclude.is_spring
    self.m_pGameConclude.bFanChunTian = pGameConclude.is_spring
    
    self.m_pGameConclude.cbBombCount = pGameConclude.bomb_times
--    self.m_pGameConclude.cbEachBombCount = {}
--    for i = 0, 2 do
--        self.m_pGameConclude.cbEachBombCount[i] = pGameConclude.cbEachBombCount[i]
--    end
--    self.m_pGameConclude.cbBankerScore = pGameConclude.cbBankerScore
    self.m_pGameConclude.cbCardCount = {}
    for i = 0, 2 do
        self.m_pGameConclude.cbCardCount[i] = #pGameConclude.user_win_money[i+1].cards
    end
    self.m_pGameConclude.cbHandCardData = {}
    for i = 0, 2 do
        self.m_pGameConclude.cbHandCardData[i] = pGameConclude.user_win_money[i+1].cards
    end

    --返回
--    if (self.m_pGameConclude.bChunTian > 0 or self.m_pGameConclude.bFanChunTian > 0) then
        self.m_iMuliple = pGameConclude.double
--    end
    
    self.m_cbGameStatus = GS_T_CONCLUDE
    return true
end

function LordDataMgr:GetMeChairID()
    if self.m_nMeChairID == -1 then
        self.m_nMeChairID = PlayerInfo.getInstance():getChairID()
    end
    return self.m_nMeChairID
end

function LordDataMgr:GetMeViewChairID()
    
    if self.m_nMeViewChairID == -1 then
        self.m_nMeViewChairID = self:SwitchViewChairID(self:GetMeChairID())
    end
    return self.m_nMeViewChairID
end

function LordDataMgr:SwitchViewChairID(wChairID)
    if wChairID == INVALID_CHAIR or wChairID >= 3 then
        return 0
    end
    local wChairCount= 3
    local meChairID = PlayerInfo.getInstance():getChairID()

    -- add by Jacky
    if meChairID == INVALID_CHAIR then
        meChairID = LordDataMgr.getInstance():getGameOverChairID()
    end

    local wViewChairID = ( wChairID + math.floor(wChairCount * 3 / 2) - meChairID ) % wChairCount
    if wViewChairID > 2 then
        wViewChairID = 2
    end
    return wViewChairID
end

function LordDataMgr:curentUserChairId()
    return self:SwitchViewChairID(self.m_wCurrentUser)
end

function LordDataMgr:CurrentUserIsMe()
    return self.m_wCurrentUser == PlayerInfo.getInstance():getChairID()
end

function LordDataMgr:canCallScore()
    return (self.m_cbBankerScore < 3 and self:CurrentUserIsMe())
end

function LordDataMgr:bankIsMe()
    return self.m_wBankerUser == PlayerInfo.getInstance():getChairID()
end

function LordDataMgr:isMeBanker()
    return self.m_wBankerUser == PlayerInfo.getInstance():getChairID()
end

function LordDataMgr:getMeCardCount()
    return self.m_cbHandCardCount[self:GetMeChairID()]
end

function LordDataMgr:hasOutCard()
    return self.m_SearchCardResult.cbSearchCount ~= 0
end

function LordDataMgr:canNotCall()
    return self.m_wStartUser ~= PlayerInfo.getInstance():getChairID()
end

function LordDataMgr:canPass()
    return self.m_wTurnWiner ~= PlayerInfo.getInstance():getChairID()
end

function LordDataMgr:setMeRobot(b)

    self.m_cbUserRobot[PlayerInfo.getInstance():getChairID()] = b
end

function LordDataMgr:getMeRobot()

    local chair = PlayerInfo.getInstance():getChairID()
    return self:getUserRobot(chair)
end

function LordDataMgr:getUserRobot(chair)
    
    return self.m_cbUserRobot[chair]
end

function LordDataMgr:getCurrentMuliple()
    --[[
    local muliple = self.m_iMuliple
    if (self.m_iMuliple > self.m_iTimesLimit) then
        muliple = self.m_iTimesLimit
    end
    ]]
    return self.m_iMuliple
end

function LordDataMgr:searchOutCard()
    if (self:canPass()) then
        local cbHandCardCount = getCardCount(self.m_cbHandCardData) --计算数量
        LordGameLogic:getInstance():SearchOutCard(self.m_cbHandCardData,cbHandCardCount,self.m_cbTurnCardData,self.m_cbTurnCardCount,self.m_SearchCardResult)
        self.m_cbSearchResultIndex = 0
    else
        local cbHandCardCount = getCardCount(self.m_cbHandCardData) --计算数量
        LordGameLogic:getInstance():SearchOutCard(self.m_cbHandCardData,cbHandCardCount,{},0,self.m_SearchCardResult)
        self.m_cbSearchResultIndex = 0
    end
end

function LordDataMgr:resetSearchIndexToStart()
    self.m_cbSearchResultIndex = 0
end

function LordDataMgr:getNextSearchCard(cbCardData, cbCardCount)
    for i = self.m_cbSearchResultIndex, self.m_SearchCardResult.cbSearchCount-1 do
        if (self.m_SearchCardResult.cbCardCount[i] == self.m_cbHandCardCount[self:GetMeChairID()]) then
            self.m_cbSearchResultIndex = i
        end
    end
    cbCardData = CopyMemory(cbCardData, self.m_SearchCardResult.cbResultCard[self.m_cbSearchResultIndex], 0, 0, self.m_SearchCardResult.cbCardCount[self.m_cbSearchResultIndex])
    cbCardCount = self.m_SearchCardResult.cbCardCount[self.m_cbSearchResultIndex]
    
    if (self.m_SearchCardResult.cbSearchCount == 0) then
        self.m_cbSearchResultIndex = 0
        return
    end
    self.m_cbSearchResultIndex = self.m_cbSearchResultIndex + 1
    self.m_cbSearchResultIndex = self.m_cbSearchResultIndex % self.m_SearchCardResult.cbSearchCount
    return cbCardData, cbCardCount
end

function LordDataMgr:VerdictOutCard(cbCardData, cbShootCount)
    if (not self:CurrentUserIsMe()) then
        return false
    end
    
    if (cbShootCount > 0) then
        LordGameLogic:getInstance():SortCardList(cbCardData, cbShootCount, ST_ORDER)
        if (LordGameLogic:getInstance():GetCardType(cbCardData, cbShootCount) == CT_ERROR) then
            return false
        end
        if (self.m_cbTurnCardCount==0) then
            return true
        end
        return LordGameLogic:getInstance():CompareCard(self.m_cbTurnCardData, cbCardData, self.m_cbTurnCardCount, cbShootCount)
    end
    
    return false
end

function LordDataMgr:setUserRobotStatus(chairID, coutrolIndex)
    self.m_pRobotChairID = chairID
    self.m_pCoutrolIndex = coutrolIndex
end

function LordDataMgr:getUserRobotStatus()
    return self.m_pRobotChairID, self.m_pCoutrolIndex
end

--设置游戏状态
function LordDataMgr:setGameStatus(Status)
    self.m_cbGameStatus = Status
end

--获取游戏状态
function LordDataMgr:getGameStatus()
    return self.m_cbGameStatus
end

--设置开始玩家
function LordDataMgr:setStartUser(StartUser)
    self.m_wStartUser = StartUser
end

--获取开始玩家
function LordDataMgr:getStartUser()
    return self.m_wStartUser
end

--设置当前玩家
function LordDataMgr:setCurrentUser(CurrentUser)
    self.m_wCurrentUser = CurrentUser
end

--获取当前玩家
function LordDataMgr:getCurrentUser()
    return self.m_wCurrentUser
end

--设置当前叫分
function LordDataMgr:setBankerScore(BankerScore)
    self.m_cbBankerScore = BankerScore
end

--获取当前叫分
function LordDataMgr:getBankerScore()
    return self.m_cbBankerScore
end

--设置叫分玩家
function LordDataMgr:setCallScoreUser(CallScoreUser)
    self.m_wCallScoreUser = CallScoreUser
end

--获取叫分玩家
function LordDataMgr:getCallScoreUser()
    return self.m_wCallScoreUser
end

--设置上次叫分
function LordDataMgr:setUserCallScore(UserCallScore)
    self.m_cbUserCallScore = UserCallScore
end

--获取上次叫分
function LordDataMgr:getUserCallScore()
    return self.m_cbUserCallScore
end

--已经叫过分
function LordDataMgr:setUserIsCall(chair, bCall)
    self.m_bIsCall[chair] = bCall 
end

--获取是否叫分
function LordDataMgr:getUserIsCall(chair)
    return self.m_bIsCall[chair]
end

--设置地主ID
function LordDataMgr:setBankerUser(BankerUser)
    self.m_wBankerUser = BankerUser
end

--获取地主ID
function LordDataMgr:getBankerUser()
    return self.m_wBankerUser
end

--设置Pass玩家
function LordDataMgr:setPassCardUser(PassCardUser)
    self.m_wPassCardUser = PassCardUser
end

--获取Pass玩家
function LordDataMgr:getPassCardUser()
    return self.m_wPassCardUser
end

--设置一局是否结束
function LordDataMgr:setTurnOver(TurnOver)
    self.m_cbTurnOver = TurnOver
end

--获取一局是否结束
function LordDataMgr:getTurnOver()
    return self.m_cbTurnOver
end

--设置玩家输赢
function LordDataMgr:setTurnWiner(TurnWiner)
    self.m_wTurnWiner = TurnWiner
end

--获取玩家输赢
function LordDataMgr:getTurnWiner()
    return self.m_wTurnWiner
end

--设置出牌玩家
function LordDataMgr:setOutCardUser(OutCardUser)
    self.m_wOutCardUser = OutCardUser
end

--获取出牌玩家
function LordDataMgr:getOutCardUser()
    return self.m_wOutCardUser
end

--设置上一轮出牌张数
function LordDataMgr:setLastOutCardCount(LastOutCardCount)
    self.m_cbLastOutCardCount = LastOutCardCount
end

--获取上一轮出牌张数
function LordDataMgr:getLastOutCardCount()
    return self.m_cbLastOutCardCount
end

--设置出牌时间
function LordDataMgr:setTimeOutCard(TimeOutCard)
    self.m_cbTimeOutCard = TimeOutCard
end

--获取出牌时间
function LordDataMgr:getTimeOutCard()
    return self.m_cbTimeOutCard
end

--设置叫分时间
function LordDataMgr:setTimeCallScore(TimeCallScore)
    self.m_cbTimeCallScore = TimeCallScore
end

--获取叫分时间
function LordDataMgr:getTimeCallScore()
    return self.m_cbTimeCallScore
end

--设置首出时间
function LordDataMgr:setTimeHeadOutCard(TimeHeadOutCard)
    self.m_cbTimeHeadOutCard = TimeHeadOutCard
end

--获取首出时间
function LordDataMgr:getTimeHeadOutCard()
    return self.m_cbTimeHeadOutCard
end

--设置加倍时间
function LordDataMgr:setTimeAddTimes(TimeAddTimes)
    self.m_cbTimeAddTimes = TimeAddTimes
end

--获取加倍时间
function LordDataMgr:getTimeAddTimes()
    return self.m_cbTimeAddTimes
end

--设置倍数
function LordDataMgr:setMuliple(Muliple)
    self.m_iMuliple = Muliple
end

--获取倍数
function LordDataMgr:getMuliple()
    return self.m_iMuliple
end

--获取炸弹
function LordDataMgr:getBombCount()
    return self.m_iBombCount
end

--设置倍数封顶
function LordDataMgr:setTimesLimit(TimesLimit)
    self.m_iTimesLimit = TimesLimit
end

--获取倍数封顶
function LordDataMgr:getTimesLimit()
    return self.m_iTimesLimit
end

--设置游戏是否已经开始
function LordDataMgr:setGameStart(GameStart)
    self.m_bGameStart = GameStart
end

--获取游戏是否已经开始
function LordDataMgr:getGameStart()
    return self.m_bGameStart
end

--设置游戏底分
function LordDataMgr:setBaseScore(BaseScore)
    self.m_llBaseScore = BaseScore
end

--获取游戏底分
function LordDataMgr:getBaseScore()
    return self.m_llBaseScore
end

--设置是否正在加倍状态(等于=0是叫分阶段,>1是加倍阶段)
function LordDataMgr:setIsAddTimesStatus(IsAddTimesStatus)
    self.m_cbIsAddTimesStatus = IsAddTimesStatus
end

--获取是否正在加倍状态
function LordDataMgr:getIsAddTimesStatus()
    return self.m_cbIsAddTimesStatus
end

--设置掉线用户位置ID
function LordDataMgr:setOffLineChairID(nChairID)
    self.m_nOffLineChairID = nChairID
end

--获取掉线用户ID
function LordDataMgr:getOffLineChairID()
    return self.m_nOffLineChairID
end

--设置结算用户位置ID (结算时断线重连用到)
function LordDataMgr:setGameOverChairID(nChairID)
    self.m_nGameOverChairId = nChairID
end

--获取结算用户位置ID
function LordDataMgr:getGameOverChairID()
    return self.m_nGameOverChairId
end

--获取强制托管次数
function LordDataMgr:getOverTimeLimt()
    return self.iOverTimesLimt
end

--本次是否本地叫分
function LordDataMgr:setCallScoreLocal(bTrue)
    self.m_bCallScoreLocal = bTrue
end

function LordDataMgr:getCallScoreLocal()
    return self.m_bCallScoreLocal
end

--本次叫分
function LordDataMgr:setCallTimeLocal(nTime)
    self.m_nCallTimeLocal = nTime
end

function LordDataMgr:getCallTimeLocal()
    return self.m_nCallTimeLocal
end

--本次是否本地加倍
function LordDataMgr:setAddScoreLocal(bTrue)
    self.m_bAddScoreLocal = bTrue
end

function LordDataMgr:getAddScoreLocal()
    return self.m_bAddScoreLocal
end

--本次加倍
function LordDataMgr:setAddTimeLocal(nTime)
    self.m_nAddTimeLocal = nTime
end

function LordDataMgr:getAddTimeLocal()
    return self.m_nAddTimeLocal
end

--本次是否本地出牌
function LordDataMgr:setOutCardLocal(bTrue)
    self.m_bOutCardLocal = bTrue
end

function LordDataMgr:getOutCardLocal()
    return self.m_bOutCardLocal
end

--本次是否本地过牌
function LordDataMgr:setPassCardLocal(bTrue)
    self.m_bPassCardLocal = bTrue
end

function LordDataMgr:getPassCardLocal()
    return self.m_bPassCardLocal
end

--设置本次出牌数据
function LordDataMgr:setLastOutCardData(msg, count)
    if count == 0 then
        self.m_cbLastOutCardData = {}
    else
        self.m_cbLastOutCardData = table.deepcopy(msg)
    end
end

--获取上次出牌数据
function LordDataMgr:getLastOutCardData()
    return self.m_cbLastOutCardData
end

--最近一次是[-1]未开始/[0]开始/[1]过牌/[2]出牌
function LordDataMgr:setLastAction(nAction)
    
    self.m_nLastAction = nAction --(-1)未开始/0开始/1出牌/2过牌
end

function LordDataMgr:getLastAction()
    return self.m_nLastAction
end

--保存本次的数据
function LordDataMgr:SaveLast()

    --保存所有数据
    LordDataMgr.m_pLastDataMgr = {}
    for k, v in pairs(LordDataMgr.m_pLordDataMgr) do
        if type(v) == "function" then
            print("function")
        elseif type(v) == "table" then
            LordDataMgr.m_pLastDataMgr[k] = table.deepcopy(v)
        else
            LordDataMgr.m_pLastDataMgr[k] = v
        end
    end
    return
end
--还原上次的数据
function LordDataMgr:RecoverLast()
    
    for k, v in pairs(LordDataMgr.m_pLastDataMgr) do
        if type(v) == "function" then
            print("function")
        elseif type(v) == "table" then
            LordDataMgr.m_pLordDataMgr[k] = table.deepcopy(v)
        else
            LordDataMgr.m_pLordDataMgr[k] = v
        end
    end
    return
end

--加倍完数据
function LordDataMgr:setAddTimeData( data )
    
    self.m_pAddTimeData = data
end

function LordDataMgr:getAddTimeData()

    return self.m_pAddTimeData
end

--是否首出
function LordDataMgr:getIsHeadOutCard()
    local count = 0
    for i, v in pairs(self.m_cbHandCardCount) do
        count = count + v
    end
    return count == FULL_COUNT
end

--是否含双王
function LordDataMgr:getIsHaveTwoKing(cbCardData)
    
    if table.nums(cbCardData) > 2 and table.keyof(cbCardData, 0x4f) and table.keyof(cbCardData, 0x4e) then
        return true
    else
        return false
    end
end

--更新性别信息
function LordDataMgr:updateUserGender()
    
--    local nTableID = PlayerInfo.getInstance():getTableID()
--    local nChairID = PlayerInfo.getInstance():getChairID()
--    for i = 0, 2 do
--        local user = CUserManager.getInstance():getUserInfoByChairID(nTableID, i)
--        if user.dwUserID > 0 then
--            self.m_cbGender[i] = user.cbGender
--            print("ID:", user.dwUserID, "椅子：", i, "性别", user.cbGender, "自己", nChairID)
--        end
--    end
end

--排序
function LordDataMgr:SortCardListOfSelf()
    LordGameLogic:getInstance():SortCardList(self.m_cbHandCardData, self.m_cbHandCardCount[PlayerInfo.getInstance():getChairID()])
end

--获取春天
function LordDataMgr:getChuntianCount()
    if self.m_pGameConclude.bChunTian  then
        return 1
    elseif self.m_pGameConclude.bFanChunTian  then
        return 1
    end
    return 0
end

--获取加倍
function LordDataMgr:getJiaBeiCount()

    if self.m_cbGameStatus == GS_T_FREE then --空闲
        return 0
    end
    if self.m_cbGameStatus == GS_T_CALL then
        if self.m_cbIsAddTimesStatus == 0 then --叫地主
            return 0
        end
    end
    
    local iCount = 0
    local chair = PlayerInfo.getInstance():getChairID()
    local banker = self:getBankerUser()
    if banker == chair then
        for i = 0, 2 do
            if i ~= banker then
                iCount = iCount + self.m_iAddTimes[i]
            end
        end
    else
        iCount = self.m_iAddTimes[chair]
    end
    return iCount
end

--获取托管状态
function LordDataMgr:getIsRobot()
    
    local chair = PlayerInfo.getInstance():getChairID()
    if chair == INVALID_CHAIR then
        return false
    end

    if self.m_cbUserRobot[chair] > 0 then
        return true
    end

    if self.m_cbUserOffLineTimes[chair] >= self.iOverTimesLimt then
        return true
    end

    return false
end

--是否获取过记牌器数据
function LordDataMgr:IsGetLeftCard()
    return self.m_bLeftCard
end

--设置牌数
function LordDataMgr:setLeftCard(cards)
    
    for i = 1, 15 do
        self.m_nLeftCard[i] = cards[i]
    end
    self.m_bLeftCard = true
end
--获取牌数
function LordDataMgr:getLeftCard()
    
    return self.m_nLeftCard
end
--记牌
function LordDataMgr:markLeftCard(user, cards)

    if user == PlayerInfo.getInstance():getChairID() then --自己出牌不计数
        return
    end

    if self.m_bLeftCard == false then --未获取记牌数据
        return
    end
    
    --牌对应数组
    local VALUE_TO_ARRAY = 
    {
        [1]  = 12,
        [2]  = 13,
        [3]  = 1, 
        [4]  = 2,
        [5]  = 3,
        [6]  = 4,
        [7]  = 5,
        [8]  = 6,
        [9]  = 7,
        [10] = 8,
        [11] = 9,  --J
        [12] = 10, --Q
        [13] = 11, --K
        [14] = 14, --小王
        [15] = 15, --大王
    }

    for k, v in pairs(cards) do
        local cbCardData = v % 0x10
        local index = VALUE_TO_ARRAY[cbCardData]
        if self.m_nLeftCard[index] > 0 then
            self.m_nLeftCard[index] = self.m_nLeftCard[index] - 1
        else
            print("")
        end
    end

    --数组对应牌
    local ARRAY_TO_VALUE = 
    {
        [1]  = "3",
        [2]  = "4",
        [3]  = "5", 
        [4]  = "6",
        [5]  = "7",
        [6]  = "8",
        [7]  = "9",
        [8]  = "10",
        [9]  = "J",
        [10] = "Q",
        [11] = "K",
        [12] = "A",
        [13] = "2",
        [14] = "小王",
        [15] = "大王",
    }
    for k, v in pairs(self.m_nLeftCard) do
        print(ARRAY_TO_VALUE[k], v)
    end
end
return LordDataMgr
--endregion
