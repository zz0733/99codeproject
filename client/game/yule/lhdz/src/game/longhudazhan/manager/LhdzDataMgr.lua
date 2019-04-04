--region LhdzDataMgr.lua
--Date
--Auther Ace
--Desc [[龙虎斗数据管理类]]
--此文件由[BabeLua]插件自动生成

local CBetManager = require("game.yule.lhdz.src.models.CBetManager")
local Lhdz_Const = require("game.yule.lhdz.src.game.longhudazhan.scene.Lhdz_Const")
local LhdzDataMgr = class("LhdzDataMgr")

LhdzDataMgr.instance = nil
function LhdzDataMgr.getInstance()
    if LhdzDataMgr.instance == nil then  
        LhdzDataMgr.instance = LhdzDataMgr.new()
    end  
    return LhdzDataMgr.instance  
end

function LhdzDataMgr.releaseInstance()
    LhdzDataMgr.instance = nil
end

function LhdzDataMgr:ctor()
    self:clear()
end

function LhdzDataMgr:clear()
    --庄家Id
    self.m_nBankerId = 65535
    --庄家昵称
    self.m_strBankerName = "庄家逃跑"
    --庄家分数
    self.m_llBankerScore = 0
    --庄家头像
    self.m_wFaceID = 0
    --庄家成绩
    self.m_llBankerResult = 0
    --上庄最低分数
    self.m_llMinBankerScore = 0
    --庄家上庄次数
    self.m_nBankerTimes = 0
    --自己结算
    self.m_llMyResult = 0
    --历史开奖数
    self.m_nHistoryCount = 0
    -- 获胜区域
    self.m_nAreaType = 0
    -- 龙胜利数
    self.m_nDragonWinCount = 0
    -- 虎胜利数
    self.m_nTigerWinCount = 0
    -- 平胜利数
    self.m_nDrawWinCount = 0
    --上庄列表
    self.m_vecBankerList = {}

    --我的下注
    self.m_vecUserChip = {}
    --续局下注
    self.m_vecContinueChip = {}
    --其他玩家续局下注
    self.m_vecOtherContinueChip = {}
    --所有玩家的下注
    self.m_vecAllUserChip = {}
    -- 是否是神算子下注
    self.m_bIsNo1Bet = {}
    --排行榜玩家
    self.m_vecRankUser = {}
    --历史开奖记录
    self.m_vecHistoryList = {}
    --临时开奖记录
    self.m_vecTempHistoryList = {}

    self.m_vecTrendList = {}

    self.m_vecTrendListTmp = {}
    --游戏状态
    self.m_nGameStatus = 1
    --自己各区域下注的值
    self.m_vecMyBetValues = {0,0,0}
    --各区域下注的值
    self.m_vecOtherBetValues = {0,0,0}
    --上桌玩家列表
    self.m_vecTableUserInfo = {}
    --上一桌玩家列表
    self.m_vecTableUserIdLast = {}
    -- 上桌玩家下注的值
    self.m_vecTableBetValues = {}
    -- 上桌玩家结算
    self.m_vecTableResult = {}
    for i=1, Lhdz_Const.TABEL_USER_COUNT do
        self.m_vecTableBetValues[i] = {0, 0, 0}
        self.m_vecTableResult[i] = 0
    end
    --结算的牌
    self.m_nCards = {}

    --自己是否下注
    self.m_bIsMyBetted = false
    --能否续投
    self.m_bIsContinued = false
    --是否还有更多玩家
    self.m_bIsMoreUser = false
    --结果
    self.m_result = {}
end

--自己是否是庄家
function LhdzDataMgr:isBanker()
    return self.m_nBankerId == PlayerInfo.getInstance():getChairID();
end

--清空庄家列表
function LhdzDataMgr:clearBankerList()
    self.m_vecBankerList = {}
end

--庄家列表
function LhdzDataMgr:addBankerList(nChairId)
    if(nChairId == G_CONSTANTS.INVALID_CHAIR)then
        return;
    end
    table.insert(self.m_vecBankerList,nChairId)
end

--玩家是否在庄家列表中
function LhdzDataMgr:isInBankerList()
    local nIndex = 0
    for key, value in pairs(self.m_vecBankerList) do
        if value == PlayerInfo.getInstance():getChairID() then
            return nIndex
        else
            nIndex = nIndex + 1
        end
    end
    return -1
end

--从庄家列表移除
function LhdzDataMgr:delBankerList(nChirId)

    for i=1,tonumber(table.maxn(self.m_vecBankerList)),1 do    
        if self.m_vecBankerList[i] == nChirId then
            table.remove(self.m_vecBankerList,i)
            return
        end
    end
end

-- 申请庄家人数
function LhdzDataMgr:getBankerListSize()
    return table.maxn(self.m_vecBankerList)
end

function LhdzDataMgr:getBankerList()
    return self.m_vecBankerList
end

--清空历史记录
function LhdzDataMgr:clearHistory()
    self.m_vecHistoryList = {}
    self.m_vecTempHistoryList = {}
    self.m_nDragonWinCount = 0
    self.m_nTigerWinCount = 0
    self.m_nDrawWinCount = 0
end

--设置临时开奖记录
function LhdzDataMgr:addTempHistory(cbHistorys)
    self.m_vecTempHistoryList[#self.m_vecTempHistoryList + 1] = cbHistorys
end

--同步临时开奖记录至历史记录
function LhdzDataMgr:synTempHistory()
    local count = #self.m_vecTempHistoryList

    if 0 == count then
        return 0
    end

    for i = 1, #self.m_vecTempHistoryList do
        self:addHistoryToList(self.m_vecTempHistoryList[i])
    end
    
    self.m_vecTempHistoryList = {}

    return count
end

--历史记录
function LhdzDataMgr:addHistoryToList(cbHistorys)
    self:addTrendToList(cbHistorys)
    self:setWinCount(cbHistorys)
    table.insert(self.m_vecHistoryList, 1, cbHistorys)
end

function LhdzDataMgr:getHistoryListSize()
    return table.maxn(self.m_vecHistoryList)
end

function LhdzDataMgr:getHistoryByIndex(index)
    return self.m_vecHistoryList[index]
end

-- 走势
function LhdzDataMgr:addTrendToList(cbHistorys)
    table.insert( self.m_vecTrendListTmp,cbHistorys )
    local trendListSize = self:getTrendListSize()--==0 and 1 or self:getTrendListSize()
    if trendListSize == 0 then
        self:initTrendListByIndex(1)
        self.m_vecTrendList[1][1].cbAreaType = cbHistorys.cbAreaType
        self.m_vecTrendList[1][1].bNewest = true
        return 
    end
    for i=trendListSize, 1, -1 do
        for k=1, 5 do
            if self.m_vecTrendList[i][k].cbAreaType ~= -1 and self.m_vecTrendList[i][k].bNewest then
                self.m_vecTrendList[i][k].bNewest = false
                if self.m_vecTrendList[i][k].cbAreaType ~= cbHistorys.cbAreaType then
                    for n=trendListSize, 1, -1 do
                        if self.m_vecTrendList[n][1].cbAreaType ~= -1 then
                            if not self.m_vecTrendList[n+1] then
                                self:initTrendListByIndex(n+1)
                            end
                            self.m_vecTrendList[n+1][1].cbAreaType = cbHistorys.cbAreaType
                            self.m_vecTrendList[n+1][1].bNewest = true
                            return
                        end
                    end
                else
                    if k<5 and self.m_vecTrendList[i][k+1].cbAreaType == -1 and self.m_vecTrendList[i][1].cbAreaType ~= -1 then
                        self.m_vecTrendList[i][k+1].cbAreaType = cbHistorys.cbAreaType
                        self.m_vecTrendList[i][k+1].bNewest = true
                    else
                        if not self.m_vecTrendList[i+1] then
                            self:initTrendListByIndex(i+1)
                        end
                        self.m_vecTrendList[i+1][k].cbAreaType = cbHistorys.cbAreaType
                        self.m_vecTrendList[i+1][k].bNewest = true
                    end
                end
                return
            end
        end
    end
end

--初始化走势
function LhdzDataMgr:initTrendListByIndex(index)
    self.m_vecTrendList[index] = {}
    for i=1, 5 do
        self.m_vecTrendList[index][i] = {}
        self.m_vecTrendList[index][i].cbAreaType = -1
        self.m_vecTrendList[index][i].bNewest = false
    end
end

--清除本地缓存的路子记录
function LhdzDataMgr:clearTrendList()
    self.m_vecTrendList = {}
    self.m_vecTrendListTmp = {}
end

function LhdzDataMgr:getTrendListSize()
    return table.maxn(self.m_vecTrendList)
end

function LhdzDataMgr:getTrendListByIndex(index)
    return self.m_vecTrendList[index]
end

function LhdzDataMgr:getTrendListRecord()
    local tb = {}
    for _, v in pairs(self.m_vecTrendListTmp) do
        local cbAreaType = v.cbAreaType
        local record = nil
        if cbAreaType == Lhdz_Const.AREA.DRAGON then
            record = 0
        elseif cbAreaType == Lhdz_Const.AREA.TIGER then
            record = 2
        else
            record = 1
        end
        table.insert(tb,{record = record})
    end
    return tb
end

-- 龙虎胜利场数
function LhdzDataMgr:setWinCount(cbHistorys)
    if cbHistorys.cbAreaType == Lhdz_Const.AREA.DRAGON then
        self.m_nDragonWinCount = self.m_nDragonWinCount + 1
    elseif cbHistorys.cbAreaType == Lhdz_Const.AREA.TIGER then
        self.m_nTigerWinCount = self.m_nTigerWinCount + 1
    else
        self.m_nDrawWinCount = self.m_nDrawWinCount + 1
    end
end

function LhdzDataMgr:getTwentyWinPercent()
    local historySize = self:getHistoryListSize() > 20 and 20 or self:getHistoryListSize()
    local dragonCount = 0
    local tigerCount = 0
    for i=1, historySize do
        if self.m_vecHistoryList[i].cbAreaType == Lhdz_Const.AREA.DRAGON then
            dragonCount = dragonCount + 1
        elseif self.m_vecHistoryList[i].cbAreaType == Lhdz_Const.AREA.TIGER then
            tigerCount = tigerCount + 1
        end
    end
    local count = (dragonCount + tigerCount) > 0 and (dragonCount + tigerCount) or 1
    return math.floor(dragonCount*100/count), math.ceil(tigerCount*100/count)
end

--获取上桌玩家信息
function LhdzDataMgr:getTableUserInfo(index)
    return self.m_vecTableUserInfo[index]
end

---- 更新上桌玩家的金币
--function LhdzDataMgr:setTableUserScore(wChairID, llValue)
--    local tableID = PlayerInfo:getInstance():getTableID()
--    local userid = CUserManager:getInstance():getUserIDByChairID2(tableID, wChairID)
--    for i = 1, Lhdz_Const.TABEL_USER_COUNT do
--        local tableUser = self:getTableUserInfo(i)
--        if tableUser and tableUser.dwUserID == userid then
--            tableUser.llUserScore = tableUser.llUserScore + llValue
--            return
--        end
--    end
--end

---- 更新上桌玩家的金币
--function LhdzDataMgr:setTableUserScoreByIndex(index, llValue)
--    local tableUser = self:getTableUserInfo(index)
--    tableUser.llUserScore = tableUser.llUserScore + llValue
--end

-- 是否是神算子在改区域下注
function LhdzDataMgr:setIsNo1BetByIndex(index, dwUserID)
    if self.m_vecTableUserInfo[1] and self.m_vecTableUserInfo[1][1] == dwUserID then
        self.m_bIsNo1Bet[index] = true
    end
end

-- 是否是神算子在改区域下注
function LhdzDataMgr:setIsNo1BetByIndexAndChairId(index, wChairID)
--    local tableID = PlayerInfo:getInstance():getTableID()
    local userid = wChairID--CUserManager:getInstance():getUserIDByChairID2(tableID, wChairID)
    self:setIsNo1BetByIndex(index, userid)
end

function LhdzDataMgr:getIsNo1BetByChairID( wChairID )
    local tableID = PlayerInfo:getInstance():getTableID()
    local userid = wChairID--CUserManager:getInstance():getUserIDByChairID2(tableID, wChairID)
    return self.m_vecTableUserInfo[1] and self.m_vecTableUserInfo[1].dwUserID == userid
end

-- 排行榜玩家
function LhdzDataMgr:addRankUserToList(stUserShowEx)
    if stUserShowEx.dwUserID ~= G_CONSTANTS.INVALID_CHAIR then
        local rankSize = self:getRankUserSize()
        table.insert(self.m_vecRankUser, rankSize+1, stUserShowEx)
        self.m_vecRankUser["id" .. stUserShowEx[1]] = stUserShowEx
        table.sort(self.m_vecRankUser,function (a,b)
            return a[6]>b[6]
        end)
    end
end

-- 神算子排到第一个
function LhdzDataMgr:sortRankUserList()
    local rankUser = self.m_vecRankUser[1]
    local index = 1
    local rankSize = table.nums(self.m_vecRankUser)
    for i=1, rankSize do
        if i < rankSize then
            if rankUser.wWinCount < self.m_vecRankUser[i+1].wWinCount then
                rankUser = self.m_vecRankUser[i+1]
                index = i+1
            elseif rankUser.wWinCount == self.m_vecRankUser[i+1].wWinCount then
                if rankUser.llDownTotal < self.m_vecRankUser[i+1].llDownTotal then
                    rankUser = self.m_vecRankUser[i+1]
                    index = i+1
                elseif rankUser.llDownTotal == self.m_vecRankUser[i+1].llDownTotal then
                    if rankUser.llUserScore < self.m_vecRankUser[i+1].llUserScore then
                        rankUser = self.m_vecRankUser[i+1]
                        index = i+1
                    end
                end
            end
        end
    end
    table.remove(self.m_vecRankUser, index)
    table.insert(self.m_vecRankUser, 1, rankUser)
end

-- 获取排行榜人数
function LhdzDataMgr:getRankUserSize()
    return table.maxn(self.m_vecRankUser)
end

-- 获取排行榜玩家信息
function LhdzDataMgr:getRankUserByIndex()
    return self.m_vecRankUser
end

-- 清空排行榜玩家
function LhdzDataMgr:clearRankUser()
    self.m_vecRankUser = {}
end

-- 根据金币获取筹码最大面值
function LhdzDataMgr:GetJettonMaxIndexByValue(llValue)
    for i = Lhdz_Const.JETTON_ITEM_COUNT, 1, -1 do
        if llValue >= CBetManager.getInstance():getJettonScore(i) then
            return i
        end
    end
    return 1
end

-- 自己的投注
function LhdzDataMgr:addMyUserChip(chip)
    table.insert(self.m_vecUserChip, chip)
end

-- 清空自己的投注
function LhdzDataMgr:clearMyUserChip()
    self.m_vecUserChip = {}
end

-- 所有玩家的投注
function LhdzDataMgr:addAllUserChip(chip)
    table.insert(self.m_vecAllUserChip, chip)
end

-- 玩家下注总值
function LhdzDataMgr:addMyBetValue(index, llValue)
    self.m_vecMyBetValues[index] = self.m_vecMyBetValues[index] + llValue
end

-- 其他玩家下注总值
function LhdzDataMgr:addOtherBetValue(index, llValue)
    self.m_vecOtherBetValues[index] = self.m_vecOtherBetValues[index] + llValue
end

-- 上桌玩家下注
function LhdzDataMgr:addTableBetValue(wChairID, index, llValue)
--    local tableID = PlayerInfo:getInstance():getTableID()
    local userid = wChairID--CUserManager:getInstance():getUserIDByChairID2(tableID, wChairID)
    for i = 1, Lhdz_Const.TABEL_USER_COUNT do
        local tableUser = self:getTableUserInfo(i)
        if tableUser and tableUser[1] == userid then
            self.m_vecTableBetValues[i][index] = self.m_vecTableBetValues[i][index] + llValue
        end
    end
end

---- 上桌玩家下注
--function LhdzDataMgr:addTableBetValueByUserId(dwUserID, index, llValue)
--    for i = 1, Lhdz_Const.TABEL_USER_COUNT do
--        local tableUser = self:getTableUserInfo(i)
--        if tableUser and tableUser[1] == dwUserID then
--            self.m_vecTableBetValues[i][index] = self.m_vecTableBetValues[i][index] + llValue
--        end
--    end
--end

function LhdzDataMgr:clearTableBetValues()
    self.m_vecTableBetValues = {}
    for i=1, Lhdz_Const.TABEL_USER_COUNT do
        self.m_vecTableBetValues[i] = {0, 0, 0}
    end
end

-- 筹码状态
function LhdzDataMgr:getJettonEnableStatus(index)
    if self.m_nGameStatus ~= Lhdz_Const.STATUS.GAME_SCENE_BET then
        --非投注状态
        return false
    end
    if PlayerInfo.getInstance():getUserScore() < CBetManager.getInstance():getJettonScore(index) then
        return false
    end

    if self:isBanker() then
        return false
    end

    return true
end

-- 选中筹码状态
function LhdzDataMgr:getJettonSelAdjust()
    if(PlayerInfo.getInstance():getUserScore() >= CBetManager.getInstance():getLotteryBaseScore())then
        return -1;
    end
    
    for i=6,tonumber(1),-1 do    
        if (CBetManager.getInstance():getJettonScore(i) <= PlayerInfo.getInstance():getUserScore())then
            return  i;
        end
    end
    
    return 1;
end

-- 续投
function LhdzDataMgr:updateContinueInfo()
    if(table.maxn(self.m_vecUserChip) > 0)then
        self.m_vecContinueChip = {}
        for i=1,tonumber(table.maxn(self.m_vecUserChip)),1 do    
            table.insert(self.m_vecContinueChip,self.m_vecUserChip[i])
        end
        self.m_vecUserChip = {}
    end
end

function LhdzDataMgr:getContinueChipByIndex(index)
    return self.m_vecContinueChip[index];
end

function LhdzDataMgr:getContinueChipSize()
    return table.maxn(self.m_vecContinueChip);
end

-- 续投下注
function LhdzDataMgr:setMyContinue()
    for i=1,tonumber(table.maxn(self.m_vecContinueChip)),1 do    
        table.insert(self.m_vecUserChip,self.m_vecContinueChip[i])
        table.insert(self.m_vecAllUserChip, self.m_vecContinueChip[i])
    end
end

-- 其他玩家续投
function LhdzDataMgr:addOtherContinueChip(userChip)
    table.insert(self.m_vecOtherContinueChip, userChip)
end

function LhdzDataMgr:getOtherContinueChipSize()
    return table.maxn(self.m_vecOtherContinueChip);
end

function LhdzDataMgr:getOtherContinueChipByIndex(index)
    return self.m_vecOtherContinueChip[index]
end

function LhdzDataMgr:clearOtherContinueChip()
    self.m_vecOtherContinueChip = {}
end

function LhdzDataMgr:getIsNo1BetByIndex(index)
    return self.m_bIsNo1Bet[index]
end

function LhdzDataMgr:clearNo1Bet()
    for i=1, tonumber(Lhdz_Const.GAME_DOWN_COUNT) do
        self.m_bIsNo1Bet[i] = false
    end
end

--根据ChirdId获取是否是自己或者上桌玩家
function LhdzDataMgr:getUserByChirId(chairId)
    if chairId == PlayerInfo.getInstance():getChairID() then
        return 0
    else
        local tableID = PlayerInfo:getInstance():getTableID()
        local userid = chairId--CUserManager:getInstance():getUserIDByChairID2(tableID, chairId)
        for i = 1, Lhdz_Const.TABEL_USER_COUNT do
            local tableUser = self:getTableUserInfo(i)
            if tableUser and tableUser[1] == userid then
                return i
            end
        end
    end
    return -1
end

--根据dwUserID获取是否是自己或者上桌玩家
function LhdzDataMgr:getUserByUserId(dwUserID)
    if dwUserID == PlayerInfo.getInstance():getUserID() then
        return 0
    else
        for i = 1, Lhdz_Const.TABEL_USER_COUNT do
            local tableUser = self:getTableUserInfo(i)
            if tableUser and tableUser[1] == dwUserID then
                return i
            end
        end
    end
    return -1
end

function LhdzDataMgr:clearAllUserChip()
    self.m_vecAllUserChip = {}
end

---------------set and get------------------------------
--庄家Id
function LhdzDataMgr:setBankerId(nBankerId)
    self.m_nBankerId = nBankerId
end

function LhdzDataMgr:getBankerId()
    return self.m_nBankerId
end

--庄家昵称
function LhdzDataMgr:setBankerName(strBankerName)
    self.m_strBankerName = strBankerName
end

function LhdzDataMgr:getBankerName()
    return self.m_strBankerName
end

--庄家分数
function LhdzDataMgr:setBankerScore(llBankerScore)
    self.m_llBankerScore = llBankerScore
end

function LhdzDataMgr:getBankerScore()
    return self.m_llBankerScore
end

-- 庄家头像
function LhdzDataMgr:setBankerFaceId(wFaceID)
    self.m_wFaceID = wFaceID
end

function LhdzDataMgr:getBankerFaceId()
    return self.m_wFaceID
end

--庄家结算成绩
function LhdzDataMgr:setBankerResult(llBankerResult)
    self.m_llBankerResult = llBankerResult
end

function LhdzDataMgr:getBankerResult()
    return self.m_llBankerResult
end

--最低上庄分数
function LhdzDataMgr:setMinBankerScore(llMinBankerScore)
    self.m_llMinBankerScore = llMinBankerScore
end

function LhdzDataMgr:getMinBankerScore()
    return self.m_llMinBankerScore
end

--庄家上庄次数
function LhdzDataMgr:setBankerTimes(nBankerTimes)
    self.m_nBankerTimes = nBankerTimes
end

function LhdzDataMgr:getBankerTimes()
    return self.m_nBankerTimes
end

--游戏状态
function LhdzDataMgr:setGameStatus(nGameStatus)
    self.m_nGameStatus = nGameStatus
end

function LhdzDataMgr:getGameStatus()
    return self.m_nGameStatus
end

--能否续投
function LhdzDataMgr:setIsContinued(bIsContinued)
    self.m_bIsContinued = bIsContinued
end

function LhdzDataMgr:getIsContinued()
    return self.m_bIsContinued
end

--自己是否下注
function LhdzDataMgr:setIsMyBetted(bIsMyBetted)
    self.m_bIsMyBetted = bIsMyBetted
end

function LhdzDataMgr:getIsMyBetted()
    return self.m_bIsMyBetted
end

--自己结算
function LhdzDataMgr:setMyResult(llMyResult)
    self.m_llMyResult = llMyResult
end

function LhdzDataMgr:getMyResult()
    return self.m_llMyResult --- self:getAllMyBetValue()
end

-- 上桌玩家结算
function LhdzDataMgr:setTableResult(index , cbAreaType)
--    for i = 1, Lhdz_Const.TABEL_USER_COUNT do
--        self.m_vecTableResult[i] = 0
--        if cbAreaType == Lhdz_Const.AREA.DRAGON then
--            self.m_vecTableResult[i] = self.m_vecTableBetValues[i][1]*Lhdz_Const.MULTIPLE.DRAGON
--        elseif cbAreaType == Lhdz_Const.AREA.TIGER then
--            self.m_vecTableResult[i] = self.m_vecTableBetValues[i][2]*Lhdz_Const.MULTIPLE.TIGER
--        elseif cbAreaType == Lhdz_Const.AREA.DRAW then
--            self.m_vecTableResult[i] = self.m_vecTableBetValues[i][1]+self.m_vecTableBetValues[i][2]+self.m_vecTableBetValues[i][3]*Lhdz_Const.MULTIPLE.DRAW
--        end
--    end
    self.m_vecTableResult[index] = cbAreaType
--    self.m_vecTableResult[index] = 0
end

function LhdzDataMgr:getTableResult(index)
    -- 抽水
--    local llRevenue = 0
--    local llBetValue = self:getTableBetValue(index)
--    if self.m_vecTableResult[index] - llBetValue > 0 then
--        llRevenue = (self.m_vecTableResult[index] - llBetValue)*Lhdz_Const.RESULT_PUMP + llBetValue
--    else
--        llRevenue = llBetValue
--    end

    return self.m_vecTableResult[index]
end

-- 获胜区域
function LhdzDataMgr:setAreaType(nAreaType)
    self.m_nAreaType = nAreaType
end

function LhdzDataMgr:getAreaType()
    return self.m_nAreaType
end

-- 牌值
function LhdzDataMgr:setCards(cbCards)
    self.m_nCards = cbCards
end

function LhdzDataMgr:getCards()
    return self.m_nCards
end

function LhdzDataMgr:getCardValueAndColor(nCard)
    local value =  bit.band(nCard, 0x0F)
	local nColor = bit.band(nCard, 0xF0)
    local color = bit.rshift(nColor, 4)
    return value , color
end

--
function LhdzDataMgr:setMyBetValue(index, llValue)
    self.m_vecMyBetValues[index] = llValue;
end

-- 获取玩家下注总值
function LhdzDataMgr:getMyBetValue(index)
    return self.m_vecMyBetValues[index]
end

function LhdzDataMgr:getAllMyBetValue()
    local llValue = 0
    for i=1, Lhdz_Const.GAME_DOWN_COUNT do
        llValue = llValue + self.m_vecMyBetValues[i]
    end
    return llValue
end

-- 
function LhdzDataMgr:setOtherBetValue(index, llValue)
    self.m_vecOtherBetValues[index] = llValue;
end

-- 获取其他玩家下注总值
function LhdzDataMgr:getOtherBetValue(index)
    return self.m_vecOtherBetValues[index]
end

function LhdzDataMgr:getAllOtherBetValue()
    local llValue = 0
    for i=1, Lhdz_Const.GAME_DOWN_COUNT do
        llValue = llValue + self.m_vecOtherBetValues[i]
    end
    return llValue
end

-- 获取单个玩家的下注数
function LhdzDataMgr:getTableBetValue(index)
    local llValue = 0
    for i=1, Lhdz_Const.GAME_DOWN_COUNT do
        llValue = self.m_vecTableBetValues[index][i] + llValue
    end
    return llValue
end

-- 获取单个玩家的区域下注数
function LhdzDataMgr:getTableAreaBetValue(index, areaIndex)
    return self.m_vecTableBetValues[index][areaIndex]
end

-- 玩家下注筹码数
function LhdzDataMgr:getUserChipCount()
    return #self.m_vecUserChip
end

-- 所有玩家下注筹码数
function LhdzDataMgr:getAllUserChipCount(index)
    return #self.m_vecAllUserChip
end

function LhdzDataMgr:getUserChipByIndex(index)
    if not index or index > #self.m_vecUserChip then return end
    return self.m_vecUserChip[index]
end

function LhdzDataMgr:getAllUserChipByIndex(index)
    if not index or index > #self.m_vecAllUserChip then return end
    return self.m_vecAllUserChip[index]
end

-- 龙胜利场数
function LhdzDataMgr:getDragonWinCount()
    return self.m_nDragonWinCount
end

-- 虎胜利场数
function LhdzDataMgr:getTigerWinCount()
    return self.m_nTigerWinCount
end

-- 和胜利场数
function LhdzDataMgr:getDrawWinCount()
    return self.m_nDrawWinCount
end

--清除上桌玩家信息
function LhdzDataMgr:clearTableUserInfo()
    self.m_vecTableUserInfo = {}
end

--清除上一桌玩家信息
function LhdzDataMgr:clearTableUserIdLast()
    self.m_vecTableUserIdLast = {}
end

--添加上桌玩家信息
function LhdzDataMgr:addTableUserInfo(info)
    self.m_vecTableUserInfo[#self.m_vecTableUserInfo + 1] = info
end

--添加上一桌玩家信息
function LhdzDataMgr:addTableUserIdLast(userid)
    self.m_vecTableUserIdLast[#self.m_vecTableUserIdLast + 1] = userid
end

function LhdzDataMgr:getTableUserIdLast(idx)
    if self.m_vecTableUserIdLast[idx] then
        return self.m_vecTableUserIdLast[idx]
    else
        return G_CONSTANTS.INVALID_CHAIR
    end
end

function LhdzDataMgr:setTableUserIdLast(idx, userid)
    self.m_vecTableUserIdLast[idx] = userid
end

function LhdzDataMgr:setResult(result)
    self.m_result = result
end

function LhdzDataMgr:getResult()
    return self.m_result
end

function LhdzDataMgr:clearResult()
    self.m_result = {}
end

return LhdzDataMgr
--endregion
