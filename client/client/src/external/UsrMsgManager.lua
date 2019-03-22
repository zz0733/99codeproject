--region UsrMsgManager.lua
--Date 2017.05.06.
--Auther JackyXu.
--Desc 玩家消息数据管理单例

local UsrMsgManager = class("UsrMsgManager")
appdf.req(appdf.CLIENT_SRC.."external.helper")
UsrMsgManager.g_instance = nil
function UsrMsgManager.getInstance()
    if not UsrMsgManager.g_instance then
        UsrMsgManager.g_instance = UsrMsgManager:new()
    end
    return UsrMsgManager.g_instance
end

function UsrMsgManager.releaseInstance()
    UsrMsgManager.g_instance = nil
end

function UsrMsgManager:ctor()
    self:Clear()
end

function UsrMsgManager:Clear()
    self.m_vecInfoData = {};
    self:ClearRankingData();
    self:ClearWinRankingData();
    self.m_nTotalMsgNo = 0;
    self.m_vecSpreadInfoData = {};
    self.m_nNewMsgNum = -1;
    self.m_nSpreadTotalCount = 0
    self.m_llGainRevenue = 0;
    self.m_llAllRevenue = 0;
    self.m_bGotSpreadInfo = false;
    self.m_llGotSpeadInfoTime = "";
    self.m_llSpreadTotalAward = 0
    self.m_nSpreadCurrentLevel = 1
    self.m_bHaveSpreadQR = false
    self.m_nSpreadMoldIndex = 1
    self.m_vecSpreadGainRateData = {}
    self.m_vecSpreadAwardLevelData = {}
    self.m_vecSpreadDetailsData = {}
    self.m_vecRevertData = {} --客服回复数据
    self.m_nLastReqestMsgID = 0
    self.m_iTypeReportAward = "" --举报类型
    self.m_strAccountReportAward = "" --举报号码
end

function UsrMsgManager:setLastReqestMsgID(msgID)
    self.m_nLastReqestMsgID = msgID
end

function UsrMsgManager:getLastReqestMsgID()
    return self.m_nLastReqestMsgID
end

function UsrMsgManager:getInfoDataCount()
    return #self.m_vecInfoData;
end

function UsrMsgManager:addInfo(info)
    -- just for test.
    --[[if not GiftDataMgr::getInstance()->checkGiftOpen(info.strContext) then
    {
        return;
    }]]

    -- avoid to repet message.
    for _,msgInfo in ipairs(self.m_vecInfoData) do
        if msgInfo.msgID == info.msgID then
            return;
        end
    end
    
    self.m_vecInfoData[#self.m_vecInfoData + 1] = info;
    
    table.sort(self.m_vecInfoData, function(a,b)
            return a.msgID > b.msgID;
        end)
end

function UsrMsgManager:getInfoAtIndex(index)
    local msgInfo = nil;
    if index >= 1 and index <= #self.m_vecInfoData then
        msgInfo = self.m_vecInfoData[index];
    end
    return msgInfo;
end

function UsrMsgManager:delInfoByIndex(nIdex)
    if nIdex >= 1 and nIdex <= #self.m_vecInfoData then
        table.remove(self.m_vecInfoData, index);
    end
end

function UsrMsgManager:delCurInfoByIndex(nMsgId)
    for index,msgInfo in pairs(self.m_vecInfoData) do
        if msgInfo.msgID == nMsgId then
            table.remove(self.m_vecInfoData, index);
            break;
        end
    end
end

function UsrMsgManager:delAllInfoOfVec()
    self.m_vecInfoData = {};
end

function UsrMsgManager:setNewMsgNum(nNum)
    self.m_nNewMsgNum = nNum;
end

function UsrMsgManager:getNewMsgNum(nNum)
    return self.m_nNewMsgNum;
end

function UsrMsgManager:setTotalMsgNo(nNum)
    self.m_nTotalMsgNo = nNum;
end

function UsrMsgManager:getTotalMsgNo()
    return self.m_nTotalMsgNo;
end

-------------------------
-- RankingData
function UsrMsgManager:ClearRankingData()
    self.m_vecRankData = {};
end

function UsrMsgManager:addRankingData(pRankData)
    self.m_vecRankData[#self.m_vecRankData + 1] = pRankData;
end

function UsrMsgManager:GetRankingData()
    return self.m_vecRankData;
end

function UsrMsgManager:ClearWinRankingData()
    self.m_vecWinRankData = {};
end

function UsrMsgManager:addWinRankingData(pRankData)
    self.m_vecWinRankData[#self.m_vecWinRankData + 1] = pRankData;
end

function UsrMsgManager:GetWinRankingData()
    return self.m_vecWinRankData;
end

-- Spread data
function UsrMsgManager:setTotalSpreadNo(nNum)
    self.m_nTotalSpreadNo = nNum;
end

function UsrMsgManager:getTotalSpreadNo()
    return self.m_nTotalSpreadNo;
end

function UsrMsgManager:ClearSpreadData()
    self.m_vecSpreadInfoData = {};
end

function UsrMsgManager:addSpreadData(info)
    self.m_vecSpreadInfoData[#self.m_vecSpreadInfoData + 1] = info;
end

function UsrMsgManager:getSpreadCount()
    return #self.m_vecSpreadInfoData;
end

function UsrMsgManager:GetSpreadData(nIndex)
    local msgInfo = nil;
    if nIndex >= 1 and nIndex <= #self.m_vecSpreadInfoData then
        msgInfo = self.m_vecSpreadInfoData[nIndex];
    end
    return msgInfo;
end

function UsrMsgManager:delAllInfoOfSpreadVec()
    self.m_vecSpreadInfoData = {};
end

function UsrMsgManager:delCurSpreadInfoByIndex(nMsgId)
    for index,msgInfo in ipairs(self.m_vecSpreadInfoData) do
        if msgInfo.msgID == nMsgId then
            table.remove(self.m_vecSpreadInfoData, index)
            break;
        end
    end
end

--Spread info
function UsrMsgManager:clearSpreadInfo(args)
    self.m_nSpreadTotalCount = 0
    self.m_llGainRevenue = 0
    self.m_llAllRevenue = 0
    self.m_bGotSpreadInfo = false
    self.m_llGotSpeadInfoTime = ""
    self.m_llSpreadTotalAward = 0
    self.m_nSpreadCurrentLevel = 1
    self.m_vecSpreadGainRateData = {}
    self.m_vecSpreadAwardLevelData = {}
end

--返点系数
function UsrMsgManager:clearSpreadGainRateData()
    self.m_vecSpreadGainRateData = {}
end

function UsrMsgManager:getSpreadGainRateCount()
    return #self.m_vecSpreadGainRateData
end

function UsrMsgManager:addSpreadGainRateData(info)
    self.m_vecSpreadGainRateData[#self.m_vecSpreadGainRateData + 1] = info
end

function UsrMsgManager:getSpreadGainRateData(nIndex)
    local msgInfo = nil;
    if nIndex >= 1 and nIndex <= #self.m_vecSpreadGainRateData then
        msgInfo = self.m_vecSpreadGainRateData[nIndex];
    end
    return msgInfo;
end

--推广员等级
function UsrMsgManager:clearSpreadAwardLevelData()
    self.m_vecSpreadAwardLevelData = {}
end

function UsrMsgManager:getSpreadAwardLevelCount()
    return #self.m_vecSpreadAwardLevelData
end

function UsrMsgManager:addSpreadAwardLevelData(info)
    self.m_vecSpreadAwardLevelData[#self.m_vecSpreadAwardLevelData + 1] = info
end

function UsrMsgManager:getSpreadAwardLevelData(nIndex)
    local msgInfo = nil;
    if nIndex >= 1 and nIndex <= #self.m_vecSpreadAwardLevelData then
        msgInfo = self.m_vecSpreadAwardLevelData[nIndex];
    end
    return msgInfo;
end

--推广明细
function UsrMsgManager:clearSpreadDetailsData()
    self.m_vecSpreadDetailsData = {}
end

function UsrMsgManager:getSpreadDetaislLayerArraryCount(dayNum)
    local count = 0
    local detailsInfo = self:getSpreadDetaislData(dayNum)
    if detailsInfo ~= nil  then 
        count = #detailsInfo.arrMessage
    end
    return count
end

--function UsrMsgManager:addSpreadDetaislData(info)
--    self.m_vecSpreadDetailsData[#self.m_vecSpreadDetailsData + 1] = info
--end

function UsrMsgManager:addSpreadDetaislLayerData(dayNum, layer1Count, layer2Count, layer3Count, layer1Revenue, layer2Revenue, layer3Revenue, layer1Award, layer2Award, layer3Award)

    for k,v in ipairs(self.m_vecSpreadDetailsData) do
        if v.iDayNum == dayNum and v.bHaveData then 
            return
        end
    end
    local info = {}
    info.iDayNum = dayNum
    info.iLayer1Count = layer1Count
    info.iLayer2Count = layer2Count
    info.iLayer3Count = layer3Count
    info.llLayer1Revenue = layer1Revenue
    info.llLayer2Revenue = layer2Revenue
    info.llLayer3Revenue = layer3Revenue
    info.llLayer1Award = layer1Award
    info.llLayer2Award = layer2Award
    info.llLayer3Award = layer3Award
    info.arrMessage = {}
    info.bHaveData = false

    self.m_vecSpreadDetailsData[#self.m_vecSpreadDetailsData + 1] = info
end

function UsrMsgManager:addSpreadDetaislLayerArraryData(dayNum, arrData)

    for k,v in ipairs(self.m_vecSpreadDetailsData) do
        if v.iDayNum == dayNum and v.bHaveData == false then 
            v.arrMessage = arrData
            v.bHaveData = true
        end
    end
end

function UsrMsgManager:getSpreadDetaislData(dayNum)
    local msgInfo = nil;
    for k,v in ipairs(self.m_vecSpreadDetailsData) do
        if v.iDayNum == dayNum then 
            msgInfo = v
        end
    end
    return msgInfo;
end

function UsrMsgManager:setSpreadTotalCount(pSpreadCount)
    self.m_nSpreadTotalCount = pSpreadCount
end

function UsrMsgManager:getSpreadTotalCount()
    return self.m_nSpreadTotalCount
end

function UsrMsgManager:setGainRevenue(pGainRevenue)
    self.m_llGainRevenue = pGainRevenue
end

function UsrMsgManager:getGainRevenue()
    return self.m_llGainRevenue
end

function UsrMsgManager:setAllRevenue(pAllRevenue)
    self.m_llAllRevenue = pAllRevenue
end

function UsrMsgManager:getAllRevenue()
    return self.m_llAllRevenue
end

function UsrMsgManager:setGotSpreadInfo(pGotSpreadInfo)
    self.m_bGotSpreadInfo = pGotSpreadInfo
end

function UsrMsgManager:getGotSpreadInfo()
    return self.m_bGotSpreadInfo
end

function UsrMsgManager:setGotSpeadInfoTime(pGotSpeadInfoTime)
    self.m_llGotSpeadInfoTime = pGotSpeadInfoTime
end

function UsrMsgManager:getGotSpeadInfoTime()
    return self.m_llGotSpeadInfoTime
end

function UsrMsgManager:setSpreadTotalAward(llAward)
    self.m_llSpreadTotalAward = llAward
    --fixbug
    if #self.m_vecSpreadAwardLevelData == 0 then
        return
    end
    --设置等级
    if self.m_llSpreadTotalAward >= self.m_vecSpreadAwardLevelData[#self.m_vecSpreadAwardLevelData].llMinAward then 
         self.m_nSpreadCurrentLevel = #self.m_vecSpreadAwardLevelData
         return
    end 
    for i=1, #self.m_vecSpreadAwardLevelData-1 do
        if self.m_llSpreadTotalAward < self.m_vecSpreadAwardLevelData[i+1].llMinAward then
            self.m_nSpreadCurrentLevel = i
            break
        end
    end
end

function UsrMsgManager:getSpreadTotalAward()
    return self.m_llSpreadTotalAward
end

function UsrMsgManager:getSpreadCurrentLevel()
    return self.m_nSpreadCurrentLevel
end

function UsrMsgManager:setHaveSpreadQR(bHave)
    self.m_bHaveSpreadQR = bHave
end

function UsrMsgManager:getHaveSpreadQR()
    return self.m_bHaveSpreadQR
end

function UsrMsgManager:setSpreadMoldIndex(nIndex)
    self.m_nSpreadMoldIndex = nIndex
end

function UsrMsgManager:getSpreadMoldIndex()
    return self.m_nSpreadMoldIndex
end

--revert
function UsrMsgManager:clearRevertData()
    self.m_vecRevertData = {}
end

function UsrMsgManager:getRevertDataNum()
    return table.nums(self.m_vecRevertData)
end

function UsrMsgManager:addRevertData(info)
    table.insert(self.m_vecRevertData, table.deepcopy(info))
end

function UsrMsgManager:getRevertDataAtIndex(nIndex)
    return self.m_vecRevertData[nIndex]
end

function UsrMsgManager:sortRevertData()
    table.sort(self.m_vecRevertData, function(a, b)
        return a.dwFeedbackID > b.dwFeedbackID
    end)
end

function UsrMsgManager:isHaveNewFeedBack()
    if self:getRevertDataNum() > 0 then
        local lastID = cc.UserDefault:getInstance():getIntegerForKey("LastFeedBackID", 0)
        local newFeedBack = self.m_vecRevertData[1]
        if newFeedBack.dwFeedbackID > lastID then 
            return true
        end
    end
    return false
end

function UsrMsgManager:getNewFeedBackNumber()
    local nUnRead = 0
    for i, v in pairs(self.m_vecRevertData) do
        local pKey = "ReadFeedBack_"..v.dwFeedbackID
        local isRead = cc.UserDefault:getInstance():getBoolForKey(pKey, false)
        if isRead == false then
            nUnRead = nUnRead + 1
        end
    end
    return nUnRead
end

function UsrMsgManager:setReportAwardType(iType) --0微信/1QQ
    self.m_iTypeReportAward = iType
end
function UsrMsgManager:getReportAwardType()
    return self.m_iTypeReportAward
end
function UsrMsgManager:setReportAwardAccount(strAccount) --账号
    self.m_strAccountReportAward = strAccount
end
function UsrMsgManager:getReportawardAccount()
    return self.m_strAccountReportAward
end

--revert

return UsrMsgManager