--region *.lua
--Date
--
--endregion

local RedVsBlackDataManager = class("RedVsBlackDataManager")

RedVsBlackDataManager.g_instance = nil

local CardTypeStr = { "单张","对子","顺子","金花","顺金","豹子", }

RedVsBlackDataManager.E_GAME_STATUE = 
{
    eGAME_STATUS_WAIT = 0,            --等待阶段
	eGAME_STATUS_IDLE = 3,            --进入空闲状态
	eGAME_STATUS_CHIP = 1,            --进入投注阶段
	eGAME_STATUS_END  = 2,            --进入开牌阶段
}

RedVsBlackDataManager.E_GAME_CHIPSTATUE = 
{
    CHIPSTATUE_OK          = 1, --可用
    CHIPSTATUE_WRONGSTATUS = 2, --余额足够但是游戏状态非投注
    CHIPSTATUE_NOTENOUGH   = 3, --余额不足
}

local DOWN_COUNT_HOX = 3
local JETTON_ITEM_COUNT = 6

function RedVsBlackDataManager.getInstance()
    if not RedVsBlackDataManager.g_instance then
        RedVsBlackDataManager.g_instance = RedVsBlackDataManager:new()
    end
    return RedVsBlackDataManager.g_instance
end

function RedVsBlackDataManager.releaseInstance()
    RedVsBlackDataManager.g_instance = nil
end


function RedVsBlackDataManager:ctor()
    self.m_llJettonValue = {1,5,10,50,100,500}
    self:clear()
end

function RedVsBlackDataManager:clear()
    self.m_eStatus = false
    self.m_gameTax = 0
    self.m_eLotteryBaseScore = 10
    self.m_bContinue = true
    self.m_sTimeCount = 0
    self._llBankerScore = 0
    self._llLastBankerScore = 0
    self._nBankerUserId = 0
    self.currbankerReuslt = 0
    self.currSelfReuslt = 0
    self._nLastBankerChairId = 0
	self._eGameStatus = RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_WAIT
	self._llBankerGold = 0
	self._llBankerLastGold = 0
	self._nCurBankerTimes = 0
	self._strBankerName = ""
	self._nBankerChairId = 65535
    self.m_lCurLastChipSumNum = 0
    self._nIsMyFly = true
    self._nIsAndroid = false
    self.m_llMinBankerScore = 0
    self.m_enterTs = 0 --接收到场景消息时的时间戳
    self.m_infoRankUser = {}                        --玩家列表
	self._vecUsrChip = {}                           --保存当局玩家投注
	self._vecUsrChipContinue = {}                   --保存续投的记录
	self._vecOpenData = {}                          --开奖数据
	self._vecHistoryList = {}                       --历史记录
    self._vecTmpHistoryList = {}                    --临时历史记录
	self._vecBankerList = {}                        --庄家列表
    self._queueOtherUserChip = {}                   --其他玩家下注队列(显示用)
    self._queueOtherUserContinueChip = {}           --其他玩家续投下注显示队列(显示用)
    self._queueOtherUserDelChip = {}                --其他玩家清空下注显示队列(显示用)
    self.m_arrTableChairID = {}                     --桌子的玩家
    self.m_arrOtherChip = {}                        --其他玩家的下注总额
    self.m_openData = {}
    self.m_pailuVec = {}                            --牌路二维数组 { {0,0,0,0,0,0},{1,1,1,1,1,1}}  赢家索引(0空 1红 2黑) 
    self.m_pailuLastPos = cc.p(-1, -1)                       --牌路最后一个元素位置
    self.m_lastHistory = nil

    self.MyAllMoney = {}
    self.AllMoney = {}
    for i = 1 , 3 do
        self.MyAllMoney[i] = 0
        self.AllMoney[i] = 0
    end
    
    self:clearOtherChip()
    self:clearTableChairID()
    return true
end

function RedVsBlackDataManager:setAllChip(index,allmoney)
    self.AllMoney[index] = allmoney
end
function RedVsBlackDataManager:getAllChip(index)
    return self.AllMoney[index]
end
function RedVsBlackDataManager:clearAllChip()
    for i = 1 , 3 do
        self.MyAllMoney[i] = 0
        self.AllMoney[i] = 0
    end
end
function RedVsBlackDataManager:setMyAllChip(index,myallmoney)
    self.MyAllMoney[index] = myallmoney
end
function RedVsBlackDataManager:getMyAllChip(index)
    return self.MyAllMoney[index]
end
function RedVsBlackDataManager:setRankUser(UserInfo)
    table.insert( self.m_infoRankUser,UserInfo)
end
function RedVsBlackDataManager:getRankUser()
    return self.m_infoRankUser
end
function RedVsBlackDataManager:getRankUserSize()
    return table.nums(self.m_infoRankUser)
end
function RedVsBlackDataManager:setStatus(m_eStatus)
    self.m_eStatus = m_eStatus
end

function RedVsBlackDataManager:getStatus()
    return self.m_eStatus
end

function RedVsBlackDataManager:setLotteryBaseScore(m_eLotteryBaseScore)
    self.m_eLotteryBaseScore = m_eLotteryBaseScore
end

function RedVsBlackDataManager:getLotteryBaseScore()
    return self.m_eLotteryBaseScore
end

function RedVsBlackDataManager:setContinue(m_bContinue)
    self.m_bContinue = m_bContinue
end

function RedVsBlackDataManager:getContinue()
    return self.m_bContinue
end

function RedVsBlackDataManager:setTimeCount(m_sTimeCount)
    self.m_sTimeCount = m_sTimeCount
end

function RedVsBlackDataManager:getTimeCount()
    return self.m_sTimeCount
end
--
--庄家的ID
function RedVsBlackDataManager:setBankerUserId(_nBankerUserId)
    self._nBankerUserId = _nBankerUserId
end

function RedVsBlackDataManager:getBankerUserId()
    return self._nBankerUserId
end

--庄家的名字
function RedVsBlackDataManager:setBankerName(_strBankerName)
    self._strBankerName = _strBankerName
end

function RedVsBlackDataManager:getBankerName()
    return self._strBankerName
end

function RedVsBlackDataManager:clearUserChip() 
    self.m_vecUserShip = {}
end

--获取筹码按钮的响应状态
function RedVsBlackDataManager:getJettonEnableState( index)
    if PlayerInfo.getInstance():getUserScore() < self.m_llJettonValue[index] then
        --玩家钱币不足
        return self.E_GAME_CHIPSTATUE.CHIPSTATUE_NOTENOUGH
    end

    if self:getGameStatus() ~= self.E_GAME_STATUE.eGAME_STATUS_CHIP then
        --非投注状态
        return self.E_GAME_CHIPSTATUE.CHIPSTATUE_WRONGSTATUS
    end

    return self.E_GAME_CHIPSTATUE.CHIPSTATUE_OK
end

--获取筹码选择标志的响应状态
function RedVsBlackDataManager:getJettonSelAdjust()
    if PlayerInfo.getInstance():getUserScore() > RedVsBlackDataManager.getInstance():getLotteryBaseScore() then
        return -1
    end
    for i = JETTON_ITEM_COUNT , 1, -1 do
        if RedVsBlackDataManager.getInstance():getJettonScore(i) <= PlayerInfo.getInstance():getUserScore() then
            return  i
        end
    end
    return 0
end

function RedVsBlackDataManager:setLastBankerChairId(_nLastBankerChairId)
    self._nLastBankerChairId = _nLastBankerChairId
end

function RedVsBlackDataManager:getLastBankerChairId()
    return self._nLastBankerChairId
end

function RedVsBlackDataManager:getBankerGold()
    return self._llBankerScore
end

function RedVsBlackDataManager:setBankerGold( llBankerScore)
    self._llLastBankerScore = self._llBankerScore
    self._llBankerScore = llBankerScore
end

function RedVsBlackDataManager:getLotteryBaseScoreIndex()
    local i = 1
    for i = 1, JETTON_ITEM_COUNT do
        if (self.m_llJettonValue[i] == self.m_eLotteryBaseScore) then
            return (i-1)
        end
    end
    return (i - 1)

end

function RedVsBlackDataManager:getJettonScore( index)
    if not index or index < 1 or index > JETTON_ITEM_COUNT then
        return self.m_llJettonValue[1]
    end
    return self.m_llJettonValue[index]
end

function RedVsBlackDataManager:setJettonScore(index, value)
    self.m_llJettonValue[index] = value
end

function RedVsBlackDataManager:setGameStatus(_eGameStatus)
    self._eGameStatus = _eGameStatus
end

function RedVsBlackDataManager:getGameStatus()
    return self._eGameStatus
end

function RedVsBlackDataManager:setCurBankerTimes(_nCurBankerTimes)
    self._nCurBankerTimes = _nCurBankerTimes
end

function RedVsBlackDataManager:getCurBankerTimes()
    return self._nCurBankerTimes
end

function RedVsBlackDataManager:getViewBankerTimes()
    if self._nCurBankerTimes > 0 then
        return self._nCurBankerTimes
    else
        return 1
    end
end

function RedVsBlackDataManager:getJettonEnableState(nIdx)
    if self:getJettonScore(nIdx) > PlayerInfo.getInstance():getUserScore() then -- 余额不足下注
        return false
    end

    if self:isBanker() then -- 庄家不可下注
        return false
    end

    if self:getGameStatus() ~= RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP then -- 非下注时间
        return false
    end

    return true
end

--是否是自己下注的
function RedVsBlackDataManager:setIsMyFly(_nIsMyFly)
    self._nIsMyFly = _nIsMyFly
end

function RedVsBlackDataManager:getIsMyFly()
    return self._nIsMyFly
end

--上庄限制
function RedVsBlackDataManager:setMinBankerScore(m_llMinBankerScore)
    self.m_llMinBankerScore = m_llMinBankerScore
end

function RedVsBlackDataManager:getMinBankerScore()
    return self.m_llMinBankerScore
end

function RedVsBlackDataManager:clearOtherChip()
    for i = 1, DOWN_COUNT_HOX do
        self.m_arrOtherChip[i] = 0
    end
end

function RedVsBlackDataManager:setBankerGold(llBankerGold)
	self._llBankerLastGold = self._llBankerGold
	self._llBankerGold = llBankerGold
end

function RedVsBlackDataManager:getBankerGold()
	return self._llBankerGold
end

--将投注加入当前记录
function RedVsBlackDataManager:addUsrChip(chip)
	table.insert(self._vecUsrChip, chip)
end

--通过索引获取投注信息
function RedVsBlackDataManager:getUsrChipByIdx(index)
    if not index or index > #self._vecUsrChip then return end
--	assert(index < #self._vecUsrChip)
	return self._vecUsrChip[index]
end

--获取投注数量
function RedVsBlackDataManager:getUsrChipCount()
	return #self._vecUsrChip
end

--清除投注内容--清空按钮
function RedVsBlackDataManager:clearUsrChip()
	self._vecUsrChip = {}
end

--将续投加入当前记录
function RedVsBlackDataManager:recordBetContinue()
    for k,v in pairs(self._vecUsrChipContinue) do
		self:addUsrChip(v) 
    end
end

--更新续投内容
function RedVsBlackDataManager:updateBetContinueRec()
	if #self._vecUsrChip > 0 then
		self._vecUsrChipContinue = self._vecUsrChip
		self._vecUsrChip = {}
	end
    self:clearOtherChip()
end

function RedVsBlackDataManager:getUsrContinueChipByIdx(index)
    if not index or index > #self._vecUsrChipContinue then return end
	return self._vecUsrChipContinue[index]
end

function RedVsBlackDataManager:getUsrContinueChipCount()
	return #self._vecUsrChipContinue
end

--[[
 *  获取自己在某一个区域下注的总额
 *  @param index 区域index
 *  @return 返回的钱
 --]]
function RedVsBlackDataManager:getUserAllChip(index)
    local nAllChip = 0
    for k,v in pairs(self._vecUsrChip) do
        if v.wChipIndex == index then
            local value = RedVsBlackDataManager.getInstance():getJettonScore(v.wJettonIndex)
            nAllChip = nAllChip + value
        end
    end
    return nAllChip
end

--获取下注的总额
function RedVsBlackDataManager:getUserTotalChip()
    local nAllChip = 0
    for k,v in pairs(self._vecUsrChip) do
        local value = RedVsBlackDataManager.getInstance():getJettonScore(v.wJettonIndex)
        nAllChip = nAllChip + value
    end
    return nAllChip
end

--其他玩家的数据
function RedVsBlackDataManager:addOtherChip( index, llValue)
    if index <= DOWN_COUNT_HOX then
        self.m_arrOtherChip[index] = self.m_arrOtherChip[index] or 0
        self.m_arrOtherChip[index] = self.m_arrOtherChip[index] + llValue
    end
end

function RedVsBlackDataManager:delOtherChip( index, llValue)
    if index <= DOWN_COUNT_HOX then
        self.m_arrOtherChip[index] = self.m_arrOtherChip[index] - llValue
        self.m_arrOtherChip[index] = (self.m_arrOtherChip[index] < 0) and 0 or self.m_arrOtherChip[index]
    end
end

function RedVsBlackDataManager:getOtherChip( index)
    if index > DOWN_COUNT_HOX then
        return 0
    end
    return self.m_arrOtherChip[index]
end

function RedVsBlackDataManager:getOtherAllChip()
    local llValue = 0
    for i = 1, DOWN_COUNT_HOX do
        llValue = llValue + self:getOtherChip(i)
    end
    return llValue
end

function RedVsBlackDataManager:clearOtherChip()
    for i = 1, DOWN_COUNT_HOX do
        self.m_arrOtherChip[i] = 0
    end
end

--开奖数据
function RedVsBlackDataManager:addOpenData(tmp)
    self.m_openData = tmp
    local msg = {}
    msg.bWin = tmp.wWinIndex
    msg.bCardType = tmp.wWinCardType[tmp.wWinIndex + 1]
    self:addHistoryToList(msg)
end

function RedVsBlackDataManager:getOpenData() 
	return self.m_openData
end

function RedVsBlackDataManager:getCardTypeDesc(nIndex)
    return CardTypeStr[nIndex]
end

function RedVsBlackDataManager:getCardData(nIndex)
    return self.m_openData.wOpenCards[nIndex]
end

--历史记录 倒序 索引1的为最新的
function RedVsBlackDataManager:addHistoryToList( stgHis)
    table.insert(self._vecHistoryList, 1, stgHis)
end

function RedVsBlackDataManager:getHistoryByIdx( nIdx)
	return self._vecHistoryList[#self._vecHistoryList + 1 - nIdx]
end

function RedVsBlackDataManager:getHistoryByAscIdx( nIdx)
	return self._vecHistoryList[nIdx]
end

function RedVsBlackDataManager:getLastHistory()
	return self._vecHistoryList[1]
end

function RedVsBlackDataManager:getHistoryListSize()
	return #self._vecHistoryList
end

function RedVsBlackDataManager:clearHistory()
    self._vecHistoryList = {}
	return self._vecHistoryList
end

function RedVsBlackDataManager:setUnhandleHistory(stgHis)
    self.m_lastHistory = stgHis
end

function RedVsBlackDataManager:getUnhandleHistory()
    return self.m_lastHistory
end

function RedVsBlackDataManager:synLastHistory()
    if self.m_lastHistory then
        self:addHistoryToList(self.m_lastHistory)
        self.m_lastHistory = nil
        self:synTmpHistory()
    end
end

--同步临时历史记录，处理玩家通过历史记录界面提前看到结果问题
function RedVsBlackDataManager:synTmpHistory()
    self._vecTmpHistoryList = clone(self._vecHistoryList)
end

function RedVsBlackDataManager:getTmpHistoryListSize()
    return #self._vecTmpHistoryList
end

function RedVsBlackDataManager:getTmpHistoryByIdx( nIdx)
	return self._vecTmpHistoryList[#self._vecTmpHistoryList + 1 - nIdx]
end

function RedVsBlackDataManager:getTmpHistoryByAscIdx( nIdx)
	return self._vecTmpHistoryList[nIdx]
end

--region 牌路数据处理
function RedVsBlackDataManager:getPaiLuVal(col, row)
    if nil == self.m_pailuVec[col] then return 0 end
    if nil == self.m_pailuVec[col][row] then return 0 end
    return self.m_pailuVec[col][row]
end

function RedVsBlackDataManager:isLastItem(col, row)
    return col == self.m_pailuLastPos.x and row == self.m_pailuLastPos.y
end

function RedVsBlackDataManager:getPaiLuVecSize()
    return #self.m_pailuVec
end

-- 重置待放置路数数组 排序顺序 同路放置扩展顺序 1向下 2向右 异路新列
function RedVsBlackDataManager:resetPaiLuVec()
    self.m_pailuVec = {}
    -- 顺序从最老的记录到最新的连胜记录
    local _defaultEmptyItem = { 0, 0, 0, 0, 0, 0} -- 赢家索引(1红 2黑) 
    local placeOk = false
    local newRoad = false
    local lastIdx = 0 -- 胜负切换最后索引列
    local lastCol = 0 -- 连胜最后放置列索引
    local lastRow = 0 -- 连胜最后放置行索引
    local lastWin = 0
    local val = self:getTmpHistoryListSize()
    local changval = 0
    for i = 1, self:getTmpHistoryListSize() do
        repeat
            placeOk = false
            local tmp = self:getTmpHistoryByIdx(i)
            newRoad = lastWin ~= (tmp.bWin + 1)
            lastWin = tmp.bWin + 1

            -- 首列
            if 0 == #self.m_pailuVec then 
                local newitem = table.deepcopy(_defaultEmptyItem)
                newitem[1] = lastWin
                self.m_pailuVec[1] = newitem
                lastIdx = 1
                lastCol = 1
                lastRow = 1
                placeOk = true
                break
            end

            -- 不同路放置
            if newRoad then
                if #self.m_pailuVec > lastIdx then -- 新列有数据
                    self.m_pailuVec[lastIdx + 1][1] = lastWin
                else -- 新加一列
                    local newitem = table.deepcopy(_defaultEmptyItem)
                    newitem[1] = lastWin
                    self.m_pailuVec[#self.m_pailuVec + 1] = newitem
                end
                placeOk = true
                lastIdx = lastIdx + 1
                lastCol = lastIdx
                lastRow = 1
                break
            end

            -- 同路放置 向下原则
            for m = lastRow + 1, 6 do -- 现有列找位置放置
                if 0 == self.m_pailuVec[lastCol][m] then
                    self.m_pailuVec[lastCol][m] = lastWin
                    lastRow = m
                    placeOk = true
                    break
                end
                if lastWin ~= self.m_pailuVec[lastCol][m] then
                    break
                end
            end                    
            if placeOk then break end

            -- 同路放置 向右原则
            if #self.m_pailuVec > lastCol then -- 新列有数据
                self.m_pailuVec[lastCol + 1][lastRow] = lastWin
            else -- 新加一列
                local newitem = table.deepcopy(_defaultEmptyItem)
                newitem[lastRow] = lastWin
                self.m_pailuVec[#self.m_pailuVec + 1] = newitem
            end
            lastCol = lastCol + 1

            -- 右扩展时 如果是第一列扩展 则最后切换索引+1
            if 1 == lastRow then lastIdx = lastIdx + 1 end

            break
        until true
    end

    self.m_pailuLastPos.x = lastCol
    self.m_pailuLastPos.y = lastRow
end
--endregion

--庄家列表
function RedVsBlackDataManager:addBankerListByChairId( wChairId, wUsrId, strNickName)
	for k,v in pairs(self._vecBankerList) do
		if v.wChairID == wChairId then
			return
        end
    end
	local tmp = {}
	tmp.dwUserID = wUsrId
	tmp.wChairID = wChairId
	tmp.strUserNickName = strNickName
    table.insert(self._vecBankerList, tmp)
end

function RedVsBlackDataManager:delBankerByChairId( wChairId)
	for i = 1, #self._vecBankerList do
		if self._vecBankerList[i] and self._vecBankerList[i].wChairID == wChairId then
            table.remove(self._vecBankerList, i)
		end
	end
end

function RedVsBlackDataManager:getBankerListSize()
	return #self._vecBankerList
end

function RedVsBlackDataManager:clearBankerList()
	self._vecBankerList = {}
end

--在返回index，不在返回－1
function RedVsBlackDataManager:isInBnakerList()
    local nIndex = 0
    local cid = PlayerInfo.getInstance():getChairID()
    for k,v in pairs(self._vecBankerList) do
        if v.wChairID == PlayerInfo.getInstance():getChairID() then
            return nIndex
        else
            nIndex = nIndex + 1
        end
    end
    return -1
end

function RedVsBlackDataManager:isBanker()
    return self._nBankerChairId == PlayerInfo.getInstance():getChairID()
end

--获取牌点数
function RedVsBlackDataManager:GetCardValue( cbCardData)
	return ((cbCardData % 13) >= 9) and 10 or (cbCardData % 13 + 1)
end

function RedVsBlackDataManager:GetCardType( cbCount)
	if 0 == cbCount then
        return G_CONSTANTS.CardValue_Ten
    end
	return cbCount % 10
end

function RedVsBlackDataManager:GetJettonMaxIdx( llValue)
    if 0 == llValue then
        llValue = PlayerInfo.getInstance():getUserScore()
    end    
    for i = JETTON_ITEM_COUNT, 1, -1 do
        if llValue >= RedVsBlackDataManager.getInstance():getJettonScore(i) then
            return i
        end
    end
    return 1
end

--获取当前局投注总数
function RedVsBlackDataManager:GetCurUserChipSumNum()
    local sumNum = 0
    for k,v in pairs(self._vecUsrChip) do
        if v then
            sumNum = sumNum + RedVsBlackDataManager.getInstance():getJettonScore(v.wJettonIndex)
        end
    end
    self.m_lCurLastChipSumNum = sumNum
end

--获取数组对应的其他玩家索引
function RedVsBlackDataManager:GetArrTableIndexByChairId( iChairId)
    local index = 1
    for i = 1, 8 do--TABLE_USER_COUNT do
        if self.m_arrTableChairID[i] == iChairId then
            index = i
            break
        end
    end
    return index
end

function RedVsBlackDataManager:setTableChairIDByIndex(_index,_chairid)
    if not _index or not _chairid then return end
    self.m_arrTableChairID[_index] = _chairid
end

function RedVsBlackDataManager:clearTableChairID()
    for i = 1, 8 do--TABLE_USER_COUNT
        self.m_arrTableChairID[i] = G_CONSTANTS.INVALID_CHAIR
    end
end

function RedVsBlackDataManager:pushOtherUserChip(_data)
    if not _data then return end
    table.insert(self._queueOtherUserChip,_data) 
end

function RedVsBlackDataManager:getOtherUserChip(_index)
    if not _index then return end
    return self._queueOtherUserChip[_index]
end

function RedVsBlackDataManager:clearOtherUserChip()
    self._queueOtherUserChip = {}
end


function RedVsBlackDataManager:setBankerCurrResult(bankerReuslt)
    self.currbankerReuslt = bankerReuslt or 0
end

function RedVsBlackDataManager:getBankerCurrResult()
    return self.currbankerReuslt
end

function RedVsBlackDataManager:setSelfCurrResult(reusltVal)
    self.currSelfReuslt = reusltVal or 0
end

function RedVsBlackDataManager:getSelfCurrResult()
    return self.currSelfReuslt
end

function RedVsBlackDataManager:setBankerChairId(_nBankerChairId)
    self._nBankerChairId = _nBankerChairId
end

function RedVsBlackDataManager:getBankerChairId()
    return self._nBankerChairId or 65535
end

function RedVsBlackDataManager:setIsAndroid(_nIsAndroid)
    self._nIsAndroid = _nIsAndroid
end

function RedVsBlackDataManager:getIsAndroid()
    return self._nIsAndroid
end

-- 检测庄家金额够不够赔付最大赔率
function RedVsBlackDataManager:checkCanBet(nIndex, betVal)
    --print("检测可否投注")
    local rewardGold = {} -- 筹码区域累计赔付押注
    for i = 1, 2 do
        rewardGold[i] = self:getUserAllChip(i) + self:getOtherChip(i)
    end
    -- 幸运区最大赔付金额 *10是按照最大赔率来计算
    rewardGold[3] = 10 * (self:getUserAllChip(3) + self:getOtherChip(3))

    local maxRewardGold = 0 -- 最大赔付金额
    local bankerGetGold = 0 -- 庄家可收取筹码

    if 1 == nIndex then -- 押注黑色筹码区域 最大赔付黑色和幸运区
        maxRewardGold = rewardGold[3] + rewardGold[1] + betVal
        bankerGetGold = rewardGold[2]
    elseif 2 == nIndex then -- 押注红色筹码区域
        maxRewardGold = rewardGold[3] + rewardGold[2] + betVal
        bankerGetGold = rewardGold[1]
    elseif 3 == nIndex then -- 押注幸运筹码区域
        maxRewardGold = rewardGold[3] + betVal * 10
    end

    return maxRewardGold <= (self:getBankerGold() + bankerGetGold)
end

-- 通过总量拆分筹码
function RedVsBlackDataManager:splitChip(val)
    local betVec = {0, 0, 0, 0, 0, 0}
    local tmpval = val
    for i = 6, 1, -1 do
        betVec[i] = math.floor(tmpval / self.m_llJettonValue[i])
        tmpval = tmpval - betVec[i]*self.m_llJettonValue[i]
    end
    return betVec
end

function RedVsBlackDataManager:setGameTax(tax)
    self.m_gameTax = tax > 0 and tax or 0
end

function RedVsBlackDataManager:getGameTax()
    return self.m_gameTax
end

function RedVsBlackDataManager:markEnterSceneTs()
    self.m_enterTs = os.time()
end

function RedVsBlackDataManager:synEnterSceneTs()
    local tsOffset = os.time() - self.m_enterTs
    self.m_sTimeCount = self.m_sTimeCount - tsOffset
    if self.m_sTimeCount <= 0 then
        self.m_sTimeCount = 0
    end
end

return RedVsBlackDataManager
