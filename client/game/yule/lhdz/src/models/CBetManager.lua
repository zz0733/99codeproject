--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local CBetManager = class("CBetManager")  

-- 定义 ------------------------------
CBetManager.eGAMELOTTERY = 1 --下注
CBetManager.eGAMEOPEN   = 2 --开奖
CBetManager.eGAMEWAIT   = 3 --等待开奖
CBetManager.eGAMEEND    = 4 --结束

CBetManager.eMONEY_ONE   = 10    --1000
CBetManager.eMONEY_TWO   = 100   --10000
CBetManager.eMONEY_THREE = 500   --100000
CBetManager.eMONEY_FOUR  = 1000  --1000000
CBetManager.eMONEY_FIVE  = 5000  --5000000
CBetManager.eMONEY_SIX   = 10000 --10000000
-- 定义 ------------------------------

local JETTON_ITEM_COUNT = 6 -- 6个筹码
local CHIP_ITEM_COUNT = 11  --下注项数 （ 4飞禽项 4走兽项 鲨鱼项 2双倍项 ）

CBetManager.instance = nil
function CBetManager.getInstance()
    if CBetManager.instance == nil then  
        CBetManager.instance = CBetManager.new()
    end  
    return CBetManager.instance  
end

function CBetManager.releaseInstance()
    CBetManager.instance = nil
end

function CBetManager:ctor()
    
    self.m_eStatus = CBetManager.eGAMEOPEN
    self.m_eLotteryBaseScore = 10
    self.m_llWinScore = 0
    self.m_llChipScore = 0
    self.m_sGameResult = 0
    self.m_sHitDstType = 0
    self.m_sDstIndex = 0
    self.m_sDstPos = 0
    self.m_sLastPos = 0
    self.m_bContinue = true
    self.m_bIsBetting = false
    self.m_sTimeCount = 0

    self.arrAllServerStatic = {}
    self.arrAllServerAllStatic = {}
    self.arrAllServerEveryAmount = {}
    for i = 1, CHIP_ITEM_COUNT do
        self.arrAllServerStatic[i] = 0
        self.arrAllServerAllStatic[i] = 0
        self.arrAllServerEveryAmount[i] = 0
    end

    self._iBankerTimes = 0
    self._llBankerScore = 0
    self._llLastBankerScore = 0
    self._strBankerName = 0
    self._nBankerUserId = 0
    self._nLastBankerUserId = 0
    self._nSelfSlot = 0

    self.m_nDealerId = 0

    self.m_nPlayerResultGold = 0 --//玩家结果金币
    self.m_nBankerResultGold = 0 --//庄家结果金币
    self.m_nBankerScoreNeed = 0 --//庄家结果金币

    self.m_nBankerWin = 0
    self.m_vecPlayerWin = {}

    self.m_arrMatchRatioInfo = {6,8,8,12,6,8,8,12,24,2,2}

    self.m_arrRemaingBettingGold = {}
    for i = 1, CHIP_ITEM_COUNT do
        self.m_arrRemaingBettingGold[i] = 0
    end

    self:setWinResult("")
    self:setDealerId(INVALID_CHAIR)
    self:setIsBetting(false)
    self:setPlayerResultGold(0)
    self:setBankerResultGold(0)
    self.m_vecPlayerWin = {}
    self.m_nBankerScoreNeed = 0

    self.m_llJettonValue = {}
    for i = 1, JETTON_ITEM_COUNT do 
        self.m_llJettonValue[i] = 1
    end

    self.m_strWinResult = ""
    self.m_nBankerName =  "庄家逃跑"

    self.m_vecGameOpenLog = {}

    self.m_vecReqUserID = {}

    self.m_gameTax = 0 -- 游戏税率
    
    self:clear()
end

function CBetManager:clear()
    
    for i = 1, CHIP_ITEM_COUNT do
        self.arrAllServerStatic[i] = 0
        self.arrAllServerAllStatic[i] = 0
    end
    self:setShipScore(0)
    self:setWinScore(0)
    self.m_vecUserShip = {}
    self.m_vecUserShipLast = {}
    self.m_vecUserShipLastSecond = {}
    self.m_sDstIndex = -1

    self.m_strWinResult = ""
    self._iBankerTimes = 0
    self._llBankerScore = 0
    self._llLastBankerScore = 0
    self._llLastBankerScore = 0
    self._strBankerName = ""
    self._nBankerUserId = 0
    self._nLastBankerUserId = 0
    self._nSelfSlot = 0
    self.m_eStatus = CBetManager.eGAMEOPEN

    self.m_vecReqUserID = {}

end


function CBetManager:getScoreShip(index) --从1开始

    local value = 0
    for i, chip in ipairs(self.m_vecUserShip) do
        if (chip.wChipIndex == index-1)then
            value = value + chip.llChipValue
        end
    end
    return value
end

function CBetManager:setAllServerStatic(index, llValue)
    self.arrAllServerStatic[index] = llValue
end
function CBetManager:getAllServerStatic(index)
    return self.arrAllServerStatic[index]
end

function CBetManager:getAllServerAllStatic(index)
    return self.arrAllServerAllStatic[index]
end
function CBetManager:setAllServerAllStatic(index, llValue)
    self.arrAllServerAllStatic[index] = llValue;
end

function CBetManager:clearAllServerAllStatic()

    for i = 1, CHIP_ITEM_COUNT do
		self.arrAllServerStatic[i] = 0
		self.arrAllServerAllStatic[i] = 0
	end
end

function CBetManager:getGameOpenLog(index)
   return self.m_vecGameOpenLog[index]
end

--把当前投注备份一次
function CBetManager:refreshLast()
    if table.maxn(self.m_vecUserShip) > 0 then
        self.m_vecUserShipLast = self.m_vecUserShip --table.deepcopy(self.m_vecUserShip)
        self.m_vecUserShip = {}
    end
end

--wChipIndex = 0 llChipValue = 10
function CBetManager:addUserShip(ship)
    table.insert(self.m_vecUserShip, ship)
    table.insert(self.m_vecUserShipLastSecond, ship)
end

function CBetManager:getUserShip(index)
    
    if self.m_vecUserShip[index] then
        return self.m_vecUserShip[index]
    end

    local CMD_UserChip_C = {}
    CMD_UserChip_C.wChipIndex = 0
    CMD_UserChip_C.llChipValue = 0
    return CMD_UserChip_C
end

function CBetManager:clearUserChip()
    self.m_vecUserShip = {}
end

function CBetManager:clearUserChipLastSecond()
    self.m_vecUserShipLastSecond = {}
end

function CBetManager:getUserChipLastSecond(index)

    local ret = 0
    for i, chip in ipairs(self.m_vecUserShipLastSecond) do
        if (chip.wChipIndex == index-1)then
            ret = ret + chip.llChipValue
        end
    end
    return ret
end

function CBetManager:getUserShipLast(index)
    return self.m_vecUserShipLast[index]
end

--获取筹码按钮的响应状态
function CBetManager:getJettonEnableState(index)

    if (self:getStatus() ~= CBetManager.eGAMELOTTERY)then
        return false --非投注状态
    end
    if (PlayerInfo.getInstance():getTempUserScore() < self:getJettonScore(index)) then
        return false --玩家钱币不足
    end
    return true
end

--获取筹码选择标志的响应状态
function CBetManager:getJettonSelAdjust()

    local nMoney = PlayerInfo.getInstance():getTempUserScore()
    for i = 6, 1, -1 do    
        if nMoney >=self:getJettonScore(i) then
            return  i
        end
    end
    return 0
end

function CBetManager:setJettonScore(index,score)
    self.m_llJettonValue[index] = score
end

function CBetManager:getJettonScore(index)
    return self.m_llJettonValue[index] or 0
end

function CBetManager:setBankerUserIdByID(nUserID)

    if self._nLastBankerUserId == 0 then
        self._nLastBankerUserId = nUserID
    else
        self._nLastBankerUserId = self._nBankerUserId
    end
    self._nBankerUserId = nUserID
end

function CBetManager:getBankerNickName() 
    return self._strBankerName
end

function CBetManager:getBankerDisplayName()
    local len = string.utf8len(self._strBankerName)
    if len > 6 then
        return LuaUtils.getDisplayNickName(self._strBankerName, 8, true)
    else
        return self._strBankerName
    end
end

function CBetManager:getBankerGold()
    return self._llBankerScore
end

function CBetManager:setBankerGold(llBankerScore)
    self._llLastBankerScore = self._llBankerScore
    self._llBankerScore = llBankerScore
end

function CBetManager:getBankerListSize()

    return table.nums(self.m_vecReqUserID)
end

function CBetManager:addBankerListByUserId(nUserID)
    table.insert(self.m_vecReqUserID, nUserID)
end

function CBetManager:getBankerListByIndex(nIdx)

    return self.m_vecReqUserID[nIdx]
end

function CBetManager:cleanBankerList()

    self.m_vecReqUserID= {}
end


function CBetManager:resetRemaingBettingValue()

    local m_nAllBettingGold = 0
    if self._nBankerUserId == -1 then --系统庄家
        for i = 1, CHIP_ITEM_COUNT do
            self.m_arrRemaingBettingGold[i] = -1
        end
    else --玩家庄家
        for i = 1, CHIP_ITEM_COUNT do
            m_nAllBettingGold = m_nAllBettingGold + self.arrAllServerAllStatic[i]
        end
        for j = 1, CHIP_ITEM_COUNT do
            local Remaing = (self._llBankerScore + m_nAllBettingGold - self.arrAllServerAllStatic[j] * self.m_arrMatchRatioInfo[j]) / self.m_arrMatchRatioInfo[j]
            if( Remaing < 1000)then
                self.m_arrRemaingBettingGold[j] = 0
            else
                self.m_arrRemaingBettingGold[j] = (Remaing / 1000 * 1000)
            end
        end
    end
end

function CBetManager:getRemaingBettingGold(nIndex)
    return self.m_arrRemaingBettingGold[nIndex]
end

--飞禽和赛马
function CBetManager:IsBanker()

    if PlayerInfo.getInstance():getChairID() == self.m_nDealerId 
    or PlayerInfo.getInstance():getUserID() == self.m_nDealerId
    then
        return true
    end
    return false
end

function CBetManager:clearPlayerWin()

    self.m_vecPlayerWin = {}
end

function CBetManager:addPlayerWin(nRankIndex, strName, nWinGold)

    for i, child in ipairs(self.m_vecPlayerWin) do
        if child.nRankIndex == nRankIndex then
            return
        end
    end

    local playerTmp = {}
    playerTmp.nRankIndex = nRankIndex
    playerTmp.strName = strName
    playerTmp.nWinGold = nWinGold
    table.insert(self.m_vecPlayerWin, playerTmp)
end

function CBetManager:getPlayerWinInfo(nIndex)

    if self.m_vecPlayerWin[nIndex] then
        return self.m_vecPlayerWin[nIndex]
    else
        local PlayerListInfo = {}
        PlayerListInfo.nRankIndex = 0
        PlayerListInfo.strUserNickName = 0
        PlayerListInfo.nWinGold = 0
        return PlayerListInfo
    end
end

function CBetManager:getLotteryBaseScoreIndex()

    for i = 1, JETTON_ITEM_COUNT do
        if self.m_llJettonValue[i] == self.m_eLotteryBaseScore then
            return i-1
        end
    end
    return 1
end

function CBetManager:getLotteryBaseScoreByIndex(index)
    return self.m_llJettonValue[index]
end


function CBetManager:setAllServerEveryAmount(index, llValue)
    self.arrAllServerEveryAmount[index] = llValue
end
function CBetManager:getAllServerEveryAmount(index)
    return self.arrAllServerEveryAmount[index]
end

function CBetManager:clearAllServerEveryAmount()
    for i = 1, CHIP_ITEM_COUNT do
        self.arrAllServerEveryAmount[i] = 0
    end
end

function CBetManager:GetJettonIdxByValue(llValue)

    for i = JETTON_ITEM_COUNT, 1, -1 do
        if llValue >= self:getJettonScore(i) then
            return i
        end
    end
    return -1
end

function CBetManager:getSplitGold(llValue)

    --解析要添加的筹码
    local vecRet = {}
    local llDestValue = llValue
    local nJettonIndex = self:GetJettonIdxByValue(llDestValue)
    while nJettonIndex ~= -1 do
        local score = self:getJettonScore(nJettonIndex)
        table.insert(vecRet, score)
        llDestValue =  llDestValue - score
        nJettonIndex = self:GetJettonIdxByValue(llDestValue);
    end
    return vecRet;
end



-- setter & getter ---------------------------------

function CBetManager:setStatus(nStatus) --当前游戏状态
    self.m_nStatus = nStatus
end
function CBetManager:getStatus()
    return self.m_nStatus
end
function CBetManager:setLotteryBaseScore(m_eLotteryBaseScore)
    self.m_eLotteryBaseScore = m_eLotteryBaseScore
end
function CBetManager:getLotteryBaseScore()
    return self.m_eLotteryBaseScore
end



-- 玩家结算数据 --------------------------------
function CBetManager:setWinScore(_llWinScore)
    self.m_llWinScore = _llWinScore
end
function CBetManager:getWinScore()
    return self.m_llWinScore
end
function CBetManager:setShipScore(_llChipScore)
    self.m_llChipScore = _llChipScore
end
function CBetManager:getShipScore()
    return self.m_llChipScore
end
function CBetManager:setGameResult(_sGameResult)
    self.m_sGameResult = _sGameResult
end
function CBetManager:getGameResult()
    return self.m_sGameResult
end
-- 玩家结算数据 --------------------------------




-- 本轮开奖数据 --------------------------------
function CBetManager:setHitDstType(m_sHitDstType)
    self.m_sHitDstType = m_sHitDstType
end
function CBetManager:getHitDstType()
    return self.m_sHitDstType
end
function CBetManager:setDstIndex(m_sDstIndex)
    self.m_sDstIndex = m_sDstIndex
end
function CBetManager:getDstIndex()
    return self.m_sDstIndex
end
function CBetManager:setLastPos(m_sDstPos)
    self.m_sDstPos = m_sDstPos
end
function CBetManager:getLastPos()
    return self.m_sDstPos
end
function CBetManager:setDstPos(m_sLastPos)
    self.m_sLastPos = m_sLastPos
end
function CBetManager:getDstPos()
    return self.m_sLastPos
end
-- 本轮开奖数据 --------------------------------


function CBetManager:setContinue(_bContinue) -- 是否已经续投
    self.m_bContinue = _bContinue
end
function CBetManager:getContinue() -- 是否已经续投
    return self.m_bContinue
end

function CBetManager:setTimeCount(_sTimeCount)
    self.m_sTimeCount = _sTimeCount
end
function CBetManager:getTimeCount()
    return self.m_sTimeCount
end


-- 庄家数据 ------------------------------------------
function CBetManager:setBankerUserId(_nBankerUserId)
    self._nBankerUserId = _nBankerUserId
end
function CBetManager:getBankerUserId() --取得庄家UserID
    return self._nBankerUserId
end
function CBetManager:setLastBankerUserId(_nLastBankerUserId)
    self._nLastBankerUserId = _nLastBankerUserId
end
function CBetManager:getLastBankerUserId()
    return self._nLastBankerUserId
end
function CBetManager:setSelfSlot(_nSelfSlot)
    self._nSelfSlot = _nSelfSlot
end
function CBetManager:getSelfSlot()
    return self._nSelfSlot
end
function CBetManager:setBankerName(_strBankerName)
    self._strBankerName = _strBankerName;
end
function CBetManager:getBankerName()
    return self._strBankerName
end
function CBetManager:setBankerTimes(_iBankerTimes)
    self._iBankerTimes = _iBankerTimes
end
function CBetManager:getBankerTimes()
    return self._iBankerTimes
end
function CBetManager:setBankerScore(_llBankerScore)
    self._llBankerScore = _llBankerScore
end
function CBetManager:getBankerScore()
    return self._llBankerScore
end
function CBetManager:setLastBankerScore(_llLastBankerScore)
    self._llLastBankerScore = _llLastBankerScore
end
function CBetManager:getLastBankerScore()
    return self._llLastBankerScore
end
-- 庄家数据 ------------------------------------------------




-- 飞禽和赛马的结算数据 ------------------------------------
function CBetManager:setBankerUserName(_nBankerName)
    self.m_nBankerName = _nBankerName
end
function CBetManager:getBankerUserName()
    return self.m_nBankerName
end
function CBetManager:setWinResult(m_strWinResult)
    self.m_strWinResult = m_strWinResult
end
function CBetManager:getWinResult()
    return self.m_strWinResult 
end
function CBetManager:setDealerId(DealerId)
    self.m_nDealerId = DealerId
end
function CBetManager:getDealerId()
    return self.m_nDealerId
end
function CBetManager:setIsBetting(m_bIsBetting)
    self.m_bIsBetting = m_bIsBetting
end
function CBetManager:getIsBetting()
    return self.m_bIsBetting
end
function CBetManager:setPlayerResultGold(m_nPlayerResultGold)
    self.m_nPlayerResultGold = m_nPlayerResultGold
end
function CBetManager:getPlayerResultGold()
    return self.m_nPlayerResultGold
end
function CBetManager:setBankerResultGold(m_nBankerResultGold)
    self.m_nBankerResultGold = m_nBankerResultGold
end
function CBetManager:getBankerResultGold()
    return self.m_nBankerResultGold
end
function CBetManager:setBankerScoreNeed(m_nBankerScoreNeed)
    self.m_nBankerScoreNeed = m_nBankerScoreNeed
end
function CBetManager:getBankerScoreNeed()
    return self.m_nBankerScoreNeed
end
-- 飞禽和赛马的结算数据 -------------------------------------






-- add by bkk ---------------------------------------------------------

function CBetManager:getUserShipLastCount() -- 用户上次投入的总额
    return table.nums(self.m_vecUserShipLast);
end
function CBetManager:getUserShipCount() -- 用户投入的总额
    return table.nums(self.m_vecUserShip)
end
function CBetManager:clearGameOpenLog()
    self.m_vecGameOpenLog = {}
end
function CBetManager:addGameOpenLog(value)
    table.insert(self.m_vecGameOpenLog,value)
end
function CBetManager:getGameOpenLogCount() 
    return table.nums(self.m_vecGameOpenLog)
end
function CBetManager:getPlayerWinInfoCount()
    return table.nums(self.m_vecPlayerWin);
end
function CBetManager:clearVar()
    self.m_vecUserShip = {}
    self.m_vecUserShipLast = {}
    self.m_vecUserShipLastSecond = {}

    --self.m_llJettonValue = {10,10,10,10,10,10}

end

function CBetManager:getUserAllChips()
    
    local nUserChip = 0 
    for i = 1, CHIP_ITEM_COUNT do
        nUserChip = nUserChip + self:getScoreShip(i)
    end
    return nUserChip
end

function CBetManager:getUserAllChipsOnLOTTERY()
    
    if CBetManager.getInstance():getStatus() == CBetManager.eGAMELOTTERY then
        return CBetManager.getInstance():getUserAllChips()
    else
        return 0
    end
end

function CBetManager:setGameTax(tax)
    self.m_gameTax = tax > 0 and tax or 0
end

function CBetManager:getGameTax()
    return self.m_gameTax
end

-- add by bkk ---------------------------------------------------------


return CBetManager
--endregion
