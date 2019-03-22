
local BaccaratDataMgr = class("BaccaratDataMgr")
--require("common.public.helper")             --辅助函数
appdf.req("game.yule.bjl.src.models.helper")
--游戏状态
BaccaratDataMgr.eType_Wait = 3
BaccaratDataMgr.eType_Bet = 1
BaccaratDataMgr.eType_Award = 2
--飞筹码类型
BaccaratDataMgr.eType_MyInit = 0
BaccaratDataMgr.eType_OtherInit = 1
BaccaratDataMgr.eType_OtherContinue = 2
--结算类型
BaccaratDataMgr.ePlace_Xian = 1
BaccaratDataMgr.ePlace_Zhuang = 2
BaccaratDataMgr.ePlace_Ping = 3
BaccaratDataMgr.ePlace_XianDui = 4
BaccaratDataMgr.ePlace_ZhuangDui = 5
--路子类型
BaccaratDataMgr.eType_ZhuLu = 0
BaccaratDataMgr.eType_DaLu = 1
BaccaratDataMgr.eType_DaYanZaiLu = 2
BaccaratDataMgr.eType_XianLu = 3
BaccaratDataMgr.eType_YueYouLu = 4
--大路小路
BaccaratDataMgr.DALU_ROW_MAX = 5
BaccaratDataMgr.XIAOLU_ROW_MAX = 3

local AreaCount = 8 --投注区域数量
local ChipCount = 6 --可选筹码数量

local _DEFAULT_RECORD = {
    cbRow = 0,
    cbCol = 0,
    wIndex = 0,
    bPlayerTwoPair = false,
    bBankerTwoPair = false,
    bExist = false,
}

--[[eMONEY_ONE      = 10
eMONEY_TWO      = 100
eMONEY_THREE    = 500
eMONEY_FOUR     = 1000
eMONEY_FIVE     = 5000
eMONEY_SIX      = 10000

BaccaratDataMgr.eMoneyType = {
    [0] = eMONEY_ONE,
    [1] = eMONEY_TWO,
    [2] = eMONEY_THREE,
    [3] = eMONEY_FOUR,
    [4] = eMONEY_FIVE,
    [5] = eMONEY_SIX,
}--]]

BaccaratDataMgr.instance_ = nil
function BaccaratDataMgr.getInstance()
    if BaccaratDataMgr.instance_ == nil then
        BaccaratDataMgr.instance_ = BaccaratDataMgr.new()
        BaccaratDataMgr.instance_:init()
    end
    return BaccaratDataMgr.instance_
end

function BaccaratDataMgr:ctor()
    self:init()
end

function BaccaratDataMgr:init()
    self:initData()
end

function BaccaratDataMgr:clean()
    self:initData()
end

function BaccaratDataMgr:initData()

    self.m_eGameState = self.eType_Wait
    self.m_nBankerId = INVALID_CHAIR
    self.m_nBankerTimes = 0
    self.m_nBankerCondition = 0
    self.m_llBankerScore = 0
    self.m_nStateTime = 0
    self.m_vecBankerList = {}

    self.m_llAllBetValue = {}
    self.m_llMyBetValue = {}
    self.m_llPlayScore = {}
    self.m_bIsRemaingBet = {}   --是否已投满
    for i = 1, AreaCount do
        self.m_llAllBetValue[i] = 0
        self.m_llMyBetValue[i] = 0
        self.m_llPlayScore[i] = 0
        self.m_bIsRemaingBet[i] = false
    end

    self.m_llBankerResult = 0
    self.m_llMyResult = 0       
    self.m_strBankerName = ""   --庄家名

    self.m_vecResultCard = {}
    for i = 1, 2 do
        self.m_vecResultCard[i] = {}
    end

    self.m_vecUserBet = {} --用户投注
    self.m_vecContinueBet = {} --续投
    self.m_bIsContinued = false --是否已续投

    self.m_queMyInitBetting = {}
    self.m_queOtherInitBetting = {}
    self.m_queOtherBetting = {}
    self.m_queChipCancel = {}

    self.m_vecGameRecord = {}   --开奖记录
    self.m_vecRankList = {}     --结算排行
    self.m_vecDaluRecord = {} 
    self.m_vecDaYanZaiLuRecord = {}
    self.m_vecXiaoLuRecord = {}
    self.m_vecYueYouLuRecord = {}
    self.m_vecJettonScore = {}
    self.m_members = {}
    self.m_lastRecord = nil

    self.m_cacheRecord = nil

    self.m_gameTax = 0

    self.m_bLoadGameSceneData = false
    print("BaccaratDataMgr:initData")
end

--筹码
--获取筹码按钮状态
function BaccaratDataMgr:getJettonEnableState(index)
    --庄家
    if self:isBanker() then
        return false
    end

    --非投注状态
    if self:getGameState() ~= BaccaratDataMgr.eType_Bet then
        return false
    end

    --玩家钱币不足
    if PlayerInfo.getInstance():getUserScore() < self.m_vecJettonScore[index] then
        return false
    end

    return true
end

--获取筹码选择
function BaccaratDataMgr:getJettonSelAdjust()
    for i = ChipCount, 1, -1 do
        if PlayerInfo.getInstance():getUserScore() >= self.m_vecJettonScore[i] then
            return i
        end
    end
    return -1
end

--获取筹码index
function BaccaratDataMgr:setJettonScoreByIndex(index, value)
     self.m_vecJettonScore[index] = value
end

function BaccaratDataMgr:getJettonIndexByValue(value)
    
    --[[if     value >= 10000000    then    return  5
    elseif value >= 5000000     then    return  4
    elseif value >= 1000000     then    return  3
    elseif value >= 100000      then    return  2
    elseif value >= 10000       then    return  1
    elseif value >= 1000        then    return  0
    else                                return -1
    end--]]
    local index = -1
    for i = 5, 1, -1 do
        if value >= self.m_vecJettonScore[i] then
            index = i
            break
        end
    end
    return index
end

function BaccaratDataMgr:getScoreByJetton(index)
    
    --[[if      jetton == 0     then    return  1000
    elseif  jetton == 1     then    return  10000
    elseif  jetton == 2     then    return  100000
    elseif  jetton == 3     then    return  1000000
    elseif  jetton == 4     then    return  5000000
    elseif  jetton == 5     then    return  10000000
    else                            return  0
    end--]]
    return self.m_vecJettonScore[index]
end

function BaccaratDataMgr:parseJetton(eType, nChairId, index, value)
    
    local llDestValue = value
    local nJettonIndex = self:getJettonIndexByValue(llDestValue) 

    while nJettonIndex ~= -1 do
        local chip = {
            wChairId = nChairId,
            wChipIndex = index,
            wJettonIndex = nJettonIndex,
        }
        if eType == BaccaratDataMgr.eType_MyInit then
            table.insert(self.m_queMyInitBetting, chip)
        elseif eType == BaccaratDataMgr.eType_OtherInit then
            table.insert(self.m_queOtherInitBetting, chip)
        elseif eType == BaccaratDataMgr.eType_OtherContinue then
            table.insert(self.m_queOtherBetting, chip)
        end

        --自己的续投 加入投注记录
--        if nChairId == PlayerInfo.getInstance():getChairID() then
--            self:addUserBet({ cbBetArea = index,  lBetScore = self:getScoreByJetton(nJettonIndex)})
--        end

        llDestValue = llDestValue - self:getScoreByJetton(nJettonIndex)
        nJettonIndex = self:getJettonIndexByValue(llDestValue) 
    end
end

--庄家
function BaccaratDataMgr:isBanker()
    return self.m_nBankerId == PlayerInfo.getInstance():getChairID()
end

function BaccaratDataMgr:isSystemBanker() 
    return self.m_nBankerId == INVALID_CHAIR
end

function BaccaratDataMgr:isInBankerList()
    local bInList = false
    local nChairId = PlayerInfo.getInstance():getChairID()
    for k, v in ipairs(self.m_vecBankerList) do
        if v == nChairId then
            return k
        end
    end
    return -1
end

function BaccaratDataMgr:addBankerList(nChairId)
    if nChairId ~= INVALID_CHAIR then
        table.insert(self.m_vecBankerList, nChairId)
    end
end

function BaccaratDataMgr:getBankerListSize()
    return table.nums(self.m_vecBankerList)
end

function BaccaratDataMgr:delBankerList(nChairId)
    for k, v in pairs(self.m_vecBankerList) do
        if v == nChairId then
            table.remove(self.m_vecBankerList, k)
        end
    end
end

--投注(0-设置；1-增加；-1-减少)
function BaccaratDataMgr:setAllBetValue(index, value, mode)
    if mode == 0 then
        self.m_llAllBetValue[index] = value
    elseif mode == 1 then
        self.m_llAllBetValue[index] = self.m_llAllBetValue[index] + value
    elseif mode == -1 then
        self.m_llAllBetValue[index] = self.m_llAllBetValue[index] - value
    end
end

function BaccaratDataMgr:getAllBetValueAtIndex(index)
    return self.m_llAllBetValue[index]
end

function BaccaratDataMgr:getAllBetValue()
    local allBet = 0
    for k, v in pairs(self.m_llAllBetValue) do
        allBet = allBet + v
    end
    return allBet
end

--投注(0-设置；1-增加；-1-减少)
function BaccaratDataMgr:setMyBetValue(index, value, mode)
    if mode == nil then
        self.m_llMyBetValue[index] = value
    elseif mode == 1 then
        self.m_llMyBetValue[index] = self.m_llMyBetValue[index] + value
    elseif mode == -1 then
        self.m_llMyBetValue[index] = self.m_llMyBetValue[index] - value
    end
end

function BaccaratDataMgr:getMyBetValueAtIndex(index)
    return self.m_llMyBetValue[index]
end

function BaccaratDataMgr:getMyAllBetValue()
    local allMyBet = 0
    for k, v in pairs(self.m_llMyBetValue) do
        allMyBet = allMyBet + v
    end
    return allMyBet
end

function BaccaratDataMgr:cleanAllBetValue()
    for i = 1, AreaCount  do
        self.m_llAllBetValue[i] = 0
    end
    for i = 1, AreaCount do
        self.m_llMyBetValue[i] = 0
    end
end

function BaccaratDataMgr:cleanMyBetValue()
    for i = 1, AreaCount do
        self.m_llMyBetValue[i] = 0
    end
end

function BaccaratDataMgr:addUserBet(bet)
    table.insert(self.m_vecUserBet, table.deepcopy(bet))
end

function BaccaratDataMgr:getUserBetSize()
    return table.nums(self.m_vecUserBet)
end

function BaccaratDataMgr:getUserBetAtInex(index)
    return self.m_vecUserBet[index]
end

function BaccaratDataMgr:cleanUserBet()
    self.m_vecUserBet = {}
    for k, v in pairs(self.m_llPlayScore) do
        v = 0
    end
end

--续投
function BaccaratDataMgr:setContinueBet()
    for k, v in ipairs(self.m_vecUserBet) do
        table.insert(self.m_vecContinueBet, table.deepcopy(v))
    end
end

function BaccaratDataMgr:addContinueBet(bet)
    table.insert(self.m_vecContinueBet, table.deepcopy(bet))
end

function BaccaratDataMgr:getContinueBetSize()
    return table.nums(self.m_vecContinueBet)
end

function BaccaratDataMgr:getContinueBetAtIndex(index)
    return self.m_vecContinueBet[index]
end

function BaccaratDataMgr:cleanContinueBet()
    self.m_vecContinueBet = {}
end

--投满
function BaccaratDataMgr:resetRemaingBet()
    --庄家
    if self:isSystemBanker() or self:isBanker() then
        for i = 1, AreaCount do
            self.m_bIsRemaingBet[i] = false
        end
    --玩家
    else    
        local _nAllBettingGold = self:getAllBetValue()
        for i = 1, AreaCount do
            local _nAll = self.m_llBankerScore + _nAllBettingGold
            local _nLost = self:getAllBetValueAtIndex(i) * self:getChipBeishu(i)
            local _nRemaing = (_nAll - _nLost) / self:getChipBeishu(i)
            self.m_bIsRemaingBet[i] = (_nRemaing < 1000)
        end    
    end
end

function BaccaratDataMgr:getIsRemaingBet(index)
    return self.m_bIsRemaingBet[index]
end

function BaccaratDataMgr:setIsRemaingBet(index, bShow)
    
    self.m_bIsRemaingBet[index] = bShow
end

function BaccaratDataMgr:getChipBeishu(index)
    local CONST_BEISHU = {
        [AREA_XIAN + 1] = 2,
        [AREA_PING + 1] = 9,
        [AREA_ZHUANG + 1] = 2,
        [AREA_XIAN_TIAN + 1] = 3,
        [AREA_ZHUANG_TIAN + 1] = 3,
        [AREA_TONG_DUI + 1] = 33,
        [AREA_XIAN_DUI + 1] = 12,
        [AREA_ZHUANG_DUI + 1] = 12,
    }
    return CONST_BEISHU[index]
end

--结算
--开牌
function BaccaratDataMgr:setCard(ePlace, index, sCard)
    self.m_vecResultCard[ePlace][index] = table.deepcopy(sCard)
end

--获取开牌张数
function BaccaratDataMgr:getCardCount(ePlace)
    return table.nums(self.m_vecResultCard[ePlace])
end

function BaccaratDataMgr:getCardAtIndex(ePlace, cardIndex)
    return self.m_vecResultCard[ePlace][cardIndex]
end

function BaccaratDataMgr:cleanCard()
    for i = 1, 2 do
        self.m_vecResultCard[i] = {}
    end
end

--获取开牌点数
function BaccaratDataMgr:getResultPoints(ePlace, count)
    local points = 0
--    local len = math.max(table.nums(self.m_vecResultCard[ePlace]), count)
--    for i = 1, len do
--        points = points + self:getRealPointsByCard(self.m_vecResultCard[ePlace][i])
--    end
    for i = 1, count do
        points = points + self:getRealPointsByCard(self.m_vecResultCard[ePlace][i])
    end
    --print("累计计算点数:" .. points)
    return points % 10
end

--获取牌面点数
function BaccaratDataMgr:getRealPointsByCard(sCard)
    local ret = sCard.iValue < 10 and sCard.iValue or 0
    return ret
end 
    
--是否有对子
function BaccaratDataMgr:getResultIsTwoPair(ePlace)
    local count = self:getCardCount(ePlace)
    if count < 2 then
        return false
    end
    local cards = {}
    for i = 1, count do
        cards[i] = self:getCardAtIndex(ePlace, i)
    end
    if not cards[1] or not cards[2] then
        return false
    end
    local ret = cards[1].iValue == cards[2].iValue
    return ret
end

--是否同点平
function BaccaratDataMgr:getResultIsTongDianPing()
    local ePlace = { 
        [1] = BaccaratDataMgr.ePlace_Xian, 
        [2] = BaccaratDataMgr.ePlace_Zhuang,
    }

    --牌数不同
    local cardCount = { 
        [1] = self:getCardCount(ePlace[1]),
        [2] = self:getCardCount(ePlace[2]),  
    }
    if cardCount[1] ~= cardCount[2] then
        return false
    end

    --点数不同
    local cardPoint = { 
        [1] = self:getResultPoints(ePlace[1], cardCount[1]), 
        [2] = self:getResultPoints(ePlace[2], cardCount[2]),
    }
    if cardPoint[1] ~= cardPoint[2] then
        return false
    end

    --庄闲牌，牌值不同
    local card = { [1] = {}, [2] = {}, }
    for i = 1, 2 do
        for j = 1, cardCount[1] do
            card[i][j] = self:getCardAtIndex(ePlace[i], j)
        end
    end
    for i = 1, cardCount[1] do
        if card[1][i].iValue ~= card[2][i].iValue then
            return false
        end
    end

    return true
end      

--排行
function BaccaratDataMgr:addRank(sRank)
    table.insert(self.m_vecRankList, table.deepcopy(sRank))
end

function BaccaratDataMgr:getRankSize()
    return table.nums(self.m_vecRankList)
end

function BaccaratDataMgr:getRankByIndex(index)
    return self.m_vecRankList[index]
end

function BaccaratDataMgr:cleanRank()
    self.m_vecRankList = {}
end

--游戏记录
function BaccaratDataMgr:addGameRecord(sRecord)
    table.insert(self.m_vecGameRecord, table.deepcopy(sRecord))
    self:addDaLuRecord(sRecord)
end

function BaccaratDataMgr:addGameRecordByOpen()
    local ePlace = { [1] = BaccaratDataMgr.ePlace_Xian, [2] = BaccaratDataMgr.ePlace_Zhuang, }
    local cardCount = {}
    local isTwoPair = {}
    local nPoints = {}
    for i = 1, 2 do
        cardCount[i] = self:getCardCount(ePlace[i])
        isTwoPair[i] = self:getResultIsTwoPair(ePlace[i])
        nPoints[i] = self:getResultPoints(ePlace[i], cardCount[i])
    end

    local nKingWinner = 0
    if nPoints[1] > 7 and nPoints[1] > nPoints[2] then
        nKingWinner = 3
    end
    if nPoints[2] > 7 and nPoints[2] > nPoints[1] then
        nKingWinner = 4
    end

    local record = {
        cbKingWinner = nKingWinner,
        bPlayerTwoPair = isTwoPair[1],
        bBankerTwoPair = isTwoPair[2],
        cbPlayerCount = nPoints[1],
        cbBankerCount = nPoints[2],
    }
    self:addGameRecord(record)
    self.m_lastRecord = record
end

function BaccaratDataMgr:getGameRecordSize()
    return table.nums(self.m_vecGameRecord)
end

function BaccaratDataMgr:getGameRecordAtIndex(index) --1~n
    return self.m_vecGameRecord[index]
end

function BaccaratDataMgr:getLastGameRecord(index)
    return self.m_lastRecord
end

function BaccaratDataMgr:getGameRecordCountByType(ePlace)
    local count = 0
    for k, v in ipairs(self.m_vecGameRecord) do
        if ePlace == BaccaratDataMgr.ePlace_Xian then
            if v.cbPlayerCount > v.cbBankerCount then
                count = count + 1
            end
        elseif ePlace == BaccaratDataMgr.ePlace_Zhuang then
            if v.cbPlayerCount < v.cbBankerCount then
                count = count + 1
            end
        elseif ePlace == BaccaratDataMgr.ePlace_Ping then
            if v.cbPlayerCount == v.cbBankerCount then
                count = count + 1
            end
        elseif ePlace == BaccaratDataMgr.ePlace_XianDui then
            if v.bPlayerTwoPair then
                count = count + 1
            end
        elseif ePlace == BaccaratDataMgr.ePlace_ZhuangDui then
            if v.bBankerTwoPair then
                count = count + 1
            end
        end
    end
    return count
end

--大路
function BaccaratDataMgr:addDaLuRecord(r)
    local record = table.deepcopy(_DEFAULT_RECORD)
    record.wIndex = table.nums(self.m_vecDaluRecord)+1
    record.bPlayerTwoPair = r.bPlayerTwoPair
    record.bBankerTwoPair = r.bBankerTwoPair

    if r.cbPlayerCount > r.cbBankerCount then
        record.cbWin = 0
    elseif r.cbPlayerCount < r.cbBankerCount then
        record.cbWin = 1
    else
        --查询开和前最近1次非和结果
        local index = record.wIndex - 1
        local fWin = 2
        while index > 0 do
            local fRecord = self:getDaLuRecordAtIndex(index)
            if fRecord.cbWin < 2 then
                fWin = fRecord.cbWin
                break
            else
                index = index - 1    
            end
        end
        record.cbWin = 2+fWin
    end
    local tempRecord = self:calRecordPositionByType(BaccaratDataMgr.eType_DaLu, record.cbWin)
    record.cbRow = tempRecord.cbRow
    record.cbCol = tempRecord.cbCol
    record.bExist = true
    table.insert(self.m_vecDaluRecord, record)

    local position = record.cbCol*5 + record.cbRow
    if position >=6 then
        self:addDaYanLuRecord(record)
    end
    if position >= 11 then
        self:addXiaoLuRecord(record)
    end
    if position >= 16 then
        self:addYueYouLuRecord(record)
    end
end

function BaccaratDataMgr:getDaluRecordSize()
    return table.nums(self.m_vecDaluRecord)
end

function BaccaratDataMgr:getDaLuRecordAtIndex(index)
    return self.m_vecDaluRecord[index]
end

function BaccaratDataMgr:getDaLuRecordByPosition(row, col)
    for k, v in pairs(self.m_vecDaluRecord) do
        if v.cbRow == row and v.cbCol == col then
            return v
        end
    end
    return _DEFAULT_RECORD
end

function BaccaratDataMgr:getDaLuCountByCol(col)
    if col < 0 then return 0 end
    local count = 0
    for k, v in pairs(self.m_vecDaluRecord) do
        if v.cbCol == col then
            count = count + 1
        end
    end
    local ret = count > 5 and 5 or count
    return ret
end

function BaccaratDataMgr:getDaLuColCount()
    local maxCol = 0
    for k, v in pairs(self.m_vecDaluRecord) do
        maxCol = v.cbCol > maxCol and v.cbCol or maxCol
    end
    return maxCol + 1
end

function BaccaratDataMgr:calRecordPositionByType(eType, win)
    local vecRecord = {} 
    local record = table.deepcopy(_DEFAULT_RECORD)
    local bottom = 0

    if eType == BaccaratDataMgr.eType_DaLu then
        vecRecord = self.m_vecDaluRecord
        bottom = BaccaratDataMgr.DALU_ROW_MAX-1
    elseif eType == BaccaratDataMgr.eType_DaYanZaiLu then
        vecRecord = self.m_vecDaYanZaiLuRecord
        bottom = BaccaratDataMgr.XIAOLU_ROW_MAX-1
    elseif eType == BaccaratDataMgr.eType_XianLu then
        vecRecord = self.m_vecXiaoLuRecord
        bottom = BaccaratDataMgr.XIAOLU_ROW_MAX-1
    elseif eType == BaccaratDataMgr.eType_YueYouLu then
        vecRecord = self.m_vecYueYouLuRecord
        bottom = BaccaratDataMgr.XIAOLU_ROW_MAX-1
    end

    if table.nums(vecRecord) < 1 then
        return record
    end

    local fRecord = vecRecord[table.nums(vecRecord)]
    if win == fRecord.cbWin or win >= 2 or fRecord.cbWin-2 == win then
        local nRecord = {}
        for k, v in pairs(vecRecord) do
            if v.cbRow == fRecord.cbRow + 1 and v.cbCol == fRecord.cbCol then
                nRecord = table.deepcopy(v)
            end
        end
        if fRecord.cbRow == bottom or nRecord.bExist then
            record.cbCol = fRecord.cbCol + 1
            record.cbRow = fRecord.cbRow
        else
            record.cbCol = fRecord.cbCol
            record.cbRow = fRecord.cbRow + 1
        end
    else--换列
        record.cbRow = 0
        local iCol = fRecord.cbCol + 1
        while iCol > 0 do
            local bExist = false
            for k, v in pairs(vecRecord) do
                if v.cbRow == 0 and v.cbCol == iCol then
                    bExist = v.bExist
                    break
                end
            end
            if bExist then
                break
            end
            iCol = iCol-1
        end
        record.cbCol = iCol + 1
    end
    return record
end

--珠路
--大眼仔路
function BaccaratDataMgr:addDaYanLuRecord(r)
    local record = table.deepcopy(_DEFAULT_RECORD)
    record.wIndex = table.nums(self.m_vecDaYanZaiLuRecord) + 1
    record.bPlayerTwoPair = r.bPlayerTwoPair
    record.bBankerTwoPair = r.bBankerTwoPair
    
    if r.cbRow == 0 and r.cbCol >= 2 then
        local count1 = self:getDaLuCountByCol(r.cbCol-1)
        local count2 = self:getDaLuCountByCol(r.cbCol-2)
        record.cbWin = count1 == count2 and 1 or 0
    else
        local fRecord = self:getDaLuRecordByPosition(r.cbRow, r.cbCol-1)
        if not fRecord.bExist then
            local fRecord2 = self:getDaLuRecordByPosition(r.cbRow-1, r.cbCol-1)
            if not fRecord2.bExist then
                record.cbWin = 1
            else
                record.cbWin = 0
            end
        else
            record.cbWin = 1
        end
    end

    local tempReocrd = self:calRecordPositionByType(BaccaratDataMgr.eType_DaYanZaiLu, record.cbWin)
    record.cbRow = tempReocrd.cbRow
    record.cbCol = tempReocrd.cbCol
    record.bExist = true
    table.insert(self.m_vecDaYanZaiLuRecord, record)
end

function BaccaratDataMgr:getDaYanZaiRecordSize()
    return table.nums(self.m_vecDaYanZaiLuRecord)
end

function BaccaratDataMgr:getDaYanZaiRecordAtIndex(index)
    return self.m_vecDaYanZaiLuRecord[index]
end

function BaccaratDataMgr:getDaYanZaiColCount()
    local maxCol = 0
    for k, v in pairs(self.m_vecDaYanZaiLuRecord) do
        maxCol = v.cbCol > maxCol and v.cbCol or maxCol
    end
    return maxCol + 1
end

function BaccaratDataMgr:getDaYanZaiRecordByPosition(row, col)
    for k, v in pairs(self.m_vecDaYanZaiLuRecord) do
        if v.cbRow == row and v.cbCol == col then
            return v
        end
    end
    return _DEFAULT_RECORD
end

--小路
function BaccaratDataMgr:addXiaoLuRecord(r)
    local record = table.deepcopy(_DEFAULT_RECORD)
    record.wIndex = table.nums(self.m_vecXiaoLuRecord) + 1
    record.bPlayerTwoPair = r.bPlayerTwoPair
    record.bBankerTwoPair = r.bBankerTwoPair

    if r.cbRow == 0 and r.cbCol >= 3 then
        local count1 = self:getDaLuCountByCol(r.cbCol-1)
        local count2 = self:getDaLuCountByCol(r.cbCol-3)
        record.cbWin = count1 == count2 and 1 or 0
    else
        local fRecord = self:getDaLuRecordByPosition(r.cbRow, r.cbCol-2)
        if not fRecord.bExist then
            local fRecord2 = self:getDaLuRecordByPosition(r.cbRow-1, r.cbCol-2)
            record.cbWin = (not fRecord2.bExist) and 1 or 0
        else
            record.cbWin = 1
        end
    end
    local tempRecord = self:calRecordPositionByType(BaccaratDataMgr.eType_XianLu, record.cbWin)
    record.cbRow = tempRecord.cbRow
    record.cbCol = tempRecord.cbCol
    record.bExist = true
    table.insert(self.m_vecXiaoLuRecord, record)
end

function BaccaratDataMgr:getXiaoLuRecordSize()
    return table.nums(self.m_vecXiaoLuRecord)
end

function BaccaratDataMgr:getXiaoLuRecordAtIndex(index)
    return self.m_vecXiaoLuRecord[index]
end

function BaccaratDataMgr:getXiaoLuColCount()
    local maxCol = 0
    for k, v in pairs(self.m_vecXiaoLuRecord) do
        maxCol = v.cbCol > maxCol and v.cbCol or maxCol
    end
    return maxCol + 1
end

function BaccaratDataMgr:getXiaoLuRecordByPosition(row, col)
    for k, v in pairs(self.m_vecXiaoLuRecord) do
        if v.cbRow == row and v.cbCol == col then
            return v
        end
    end
    return _DEFAULT_RECORD
end

--甲由路
function BaccaratDataMgr:addYueYouLuRecord(r)
    local record = table.deepcopy(_DEFAULT_RECORD)
    record.wIndex = table.nums(self.m_vecYueYouLuRecord)+1
    record.bPlayerTwoPair = r.bPlayerTwoPair
    record.bBankerTwoPair = r.bBankerTwoPair

    if r.cbRow == 0 and r.cbCol >= 4 then
        local count1 = self:getDaLuCountByCol(r.cbCol-1)
        local count2 = self:getDaLuCountByCol(r.cbCol-4)
        record.cbWin = count1 == count2 and 1 or 0
    else
        local fRecord = self:getDaLuRecordByPosition(r.cbRow, r.cbCol-3)
        if not fRecord.bExist then
            local fRecord2 = self:getDaLuRecordByPosition(r.cbRow-1, r.cbCol-3)
            record.cbWin = (not fRecord2.bExist) and 1 or 0
        else
            record.cbWin = 1
        end
    end
    local tempRecord = self:calRecordPositionByType(BaccaratDataMgr.eType_YueYouLu, record.cbWin)
    record.cbRow = tempRecord.cbRow
    record.cbCol = tempRecord.cbCol
    record.bExist = true
    table.insert(self.m_vecYueYouLuRecord, record)
end

function BaccaratDataMgr:getYueYouLuRecordSize()
    return table.nums(self.m_vecYueYouLuRecord)
end

function BaccaratDataMgr:getYueYouKuRecordAtIndex(index)
    return self.m_vecYueYouLuRecord[index]
end

function BaccaratDataMgr:getYueYouLuColCount()
    local maxCol = 0
    for k, v in pairs(self.m_vecYueYouLuRecord) do
        maxCol = v.cbCol > maxCol and v.cbCol or maxCol
    end
    return maxCol + 1
end

function BaccaratDataMgr:getYueYouLuRecordByPosition(row, col)
    for k, v in pairs(self.m_vecYueYouLuRecord) do
        if v.cbRow == row and v.cbCol == col then
            return v
        end
    end
    return _DEFAULT_RECORD
end

--获取数值
function BaccaratDataMgr:GetCardValue(value)
    return bit.band(value, 0x0F)
end

--获取花色 0方块；1梅花；2红桃；3黑桃
function BaccaratDataMgr:GetCardColor(color)
    
    return bit.rshift(bit.band(color, 0xF0), 4)
end

--------------------------------------
function BaccaratDataMgr:getOtherBetting()
    return self.m_queOtherBetting
end

function BaccaratDataMgr:getOtherInitBetting()
    return self.m_queOtherInitBetting
end

function BaccaratDataMgr:getMyInitBetting()
    return self.m_queMyInitBetting
end

function BaccaratDataMgr:cleanOtherInitBetting()
    self.m_queOtherInitBetting = {}
end

function BaccaratDataMgr:cleanOtherBetting()
    self.m_queOtherBetting = {}
end

function BaccaratDataMgr:CleanMyInitBetting()
    self.m_queMyInitBetting = {}
end

function BaccaratDataMgr:getChipCancel()
  return self.m_queChipCancel
end

function BaccaratDataMgr:addChipCancel(chipIndex, betScore)
    local chip = {
            wChipIndex = chipIndex,
            llBetScore = betScore,          
        }
    table.insert(self.m_queChipCancel, chip)
end

function BaccaratDataMgr:cleanChipCancel()
    self.m_queChipCancel = {}
end
-------------------------------------
--get and set
function BaccaratDataMgr:setMembers(member)
--    self.m_members = name
    table.insert(self.m_members,member)
end

function BaccaratDataMgr:getMembers()
    return self.m_members
end

function BaccaratDataMgr:setBankerId(id)
    self.m_nBankerId = id
end

function BaccaratDataMgr:getBankerId()
    return self.m_nBankerId
end

function BaccaratDataMgr:setGameState(eState)
    self.m_eGameState = eState
end

function BaccaratDataMgr:getGameState()
    return self.m_eGameState
end

function BaccaratDataMgr:setBankerTimes(times)
    self.m_nBankerTimes = times
end

function BaccaratDataMgr:getBankerTimes()
    return self.m_nBankerTimes
end

function BaccaratDataMgr:setBankerCondition(cond)
    self.m_nBankerCondition = cond
end

function BaccaratDataMgr:getBankerCondition()
    return self.m_nBankerCondition
end

function BaccaratDataMgr:setBankerScore(score)
    self.m_llBankerScore = score
end

function BaccaratDataMgr:getBankerScore()
    return self.m_llBankerScore
end

function BaccaratDataMgr:setStateTime(time)
    self.m_nStateTime = time
end

function BaccaratDataMgr:getStateTime()
    return self.m_nStateTime
end

function BaccaratDataMgr:setBankerName(name)
    self.m_strBankerName = name
end

function BaccaratDataMgr:getBankerName()
    return self.m_strBankerName
end

function BaccaratDataMgr:setIsContinued(bContinued)
    self.m_bIsContinued = bContinued
end

function BaccaratDataMgr:getIsContinued()
    return self.m_bIsContinued
end

function BaccaratDataMgr:setBankerResult(score)
    self.m_llBankerResult = score
end

function BaccaratDataMgr:getBankerResult()
    return self.m_llBankerResult
end

function BaccaratDataMgr:setPlayScore(scores)
    for k, v in pairs(self.m_llPlayScore) do
        self.m_llPlayScore[k] = scores[k]
    end
end

function BaccaratDataMgr:getPlayScore()
    return self.m_llPlayScore
end

function BaccaratDataMgr:setMyResult(score)
    self.m_llMyResult = score
end

function BaccaratDataMgr:getMyResult()
    return self.m_llMyResult
end

function BaccaratDataMgr:setIsLoadGameSceneData(bLoad)
    self.m_bLoadGameSceneData = bLoad
end

function BaccaratDataMgr:getIsLoadGameSceneData()
    return self.m_bLoadGameSceneData
end

function BaccaratDataMgr:setGameTax(tax)
    self.m_gameTax = tax > 0 and tax or 0
end

function BaccaratDataMgr:getGameTax()
    return self.m_gameTax
end

function BaccaratDataMgr:setCacheRecord(record)
    self.m_cacheRecord = record
end

function BaccaratDataMgr:hasCacheRecord()
    return nil ~= self.m_cacheRecord
end

function BaccaratDataMgr:synCacheRecord()
    if self.m_cacheRecord then
        self:addGameRecord(self.m_cacheRecord)
    end
    self.m_cacheRecord = nil
end

return BaccaratDataMgr