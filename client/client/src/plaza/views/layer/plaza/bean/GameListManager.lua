--region *.lua
--Date
--
--endregion

--GameServerManager<-->Controller+GameServerManager
local GameListManager = class("GameListManager")

GameListManager.g_release = nil

function GameListManager.getInstance()
    if not GameListManager.g_release then
        GameListManager.g_release = GameListManager:new()
    end
    return GameListManager.g_release
end

function GameListManager:ctor()
    ---------controll----------
    self.m_bGameSwitch = {}
    self.m_bHttpGameSwitch = {}
    self.m_bGameSwitch[0] = false
    self.m_bHttpGameSwitch[0] = false
    for i = 1,200 do
        self.m_bGameSwitch[i] = false
        self.m_bHttpGameSwitch[i] = false
    end
    self.m_dequeActivityID = {}
    self.m_sGameType = nil
    self.m_strIp = ""
    self.m_nPort = 0
    self.m_bLogined = false
    self.m_bConnect = false
    self.m_nLastLoginTime = 0
    self.m_nPlayerGuideFlag = 0
    self.m_bRechargeFlag = false
    self.m_bResume = false
    self.tm_subBetTime = 0
    self.m_bLotteryStart = false
    self.m_nBillBoardIndex = 0
    self.m_fQueryWinInfoTime = 0
    self.m_unSingleWinningNum = 0
    self.m_bIsRequestWinInfo = false
    self.m_strExchangeCode = ""
    self.m_bRotateStatus = false
    self.m_bIsEnterGame = false
    self.m_nGameFlag = 0
    self.m_nIsLoginGameSucFlag = false
    self.m_bIsEnterAddGoldFromHall = false
    self.m_bIsHadSendHallReqList = false
    self.m_bIsShowNotice = false
    self.m_bIsShowWallowVerify = false
    self.m_bIsWallowOut = false
    self.m_llLoginTime = 0
    self.m_nWallowState = 0
    self.m_bIsHaveLoadSwitch = false
    self.m_bIsHaveLoadGameKG = false
    self.m_bIsReLoginHall = false

    --隐藏游戏ID表
    self.m_vecHideGameID = {}
    self.m_mapAllGame = {}
    self.m_vecGameServer = {}
    self.m_vecGameKindId = {}

    self.m_vecGameListInfo = {}

    self.m_mapGameLocalSortID = {}  --本地排序IDmap
    self:ReadGameLocalSortID()
end

------------------------------------------------
--controll部分

function GameListManager:setIp(m_strIp)
    self.m_strIp = m_strIp
end

function GameListManager:getIp()
    return self.m_strIp
end

function GameListManager:setPort(m_nPort)
    self.m_nPort = m_nPort
end

function GameListManager:getPort()
    return self.m_nPort
end

-- 是否已经成功登录过游戏
function GameListManager:setIsConnect(m_bConnect)
    self.m_bConnect = m_bConnect
end

function GameListManager:getIsConnect()
    return self.m_bConnect
end

function GameListManager:setIsLogined(m_bLogined)
    self.m_bLogined = m_bLogined
end

function GameListManager:getIsLogined()
    return self.m_bLogined
end

function GameListManager:setLastLoginTime(m_nLastLoginTime)
    self.m_nLastLoginTime = m_nLastLoginTime
end

function GameListManager:getLastLoginTime()
    return self.m_nLastLoginTime
end

function GameListManager:setPlayerGuideFlag(m_nPlayerGuideFlag)
    self.m_nPlayerGuideFlag = m_nPlayerGuideFlag
end

function GameListManager:getPlayerGuideFlag()
    return self.m_nPlayerGuideFlag
end

function GameListManager:setRechargeFlag(m_bRechargeFlag)
    self.m_bRechargeFlag = m_bRechargeFlag
end

function GameListManager:getRechargeFlag()
    return self.m_bRechargeFlag
end

-- 中断回来
function GameListManager:setIsResume(m_bResume)
    self.m_bResume = m_bResume
end

function GameListManager:getIsResume()
    return self.m_bResume
end

-- 投注剩余时间
function GameListManager:setsubBetTime(tm_subBetTime)
    self.tm_subBetTime = tm_subBetTime
end

function GameListManager:getsubBetTime()
    return self.tm_subBetTime
end

--可购买状态
function GameListManager:setIsLotteryStart(m_bLotteryStart)
    self.m_bLotteryStart = m_bLotteryStart
end

function GameListManager:getIsLotteryStart()
    return self.m_bLotteryStart
end

--公告状态
function GameListManager:setBillBoardIndex(m_nBillBoardIndex)
    self.m_nBillBoardIndex = m_nBillBoardIndex
end

function GameListManager:getBillBoardIndex()
    return self.m_nBillBoardIndex
end

function GameListManager:setQueryWinInfoTime(m_fQueryWinInfoTime)
    self.m_fQueryWinInfoTime = m_fQueryWinInfoTime
end

function GameListManager:getQueryWinInfoTime()
    return self.m_fQueryWinInfoTime
end

function GameListManager:setSingleWinningNum(m_unSingleWinningNum)
    self.m_unSingleWinningNum = m_unSingleWinningNum
end

function GameListManager:getSingleWinningNum()
    return self.m_unSingleWinningNum
end

function GameListManager:setIsRequestWinInfo(m_bIsRequestWinInfo)
    self.m_bIsRequestWinInfo = m_bIsRequestWinInfo
end

function GameListManager:getIsRequestWinInfo()
    return self.m_bIsRequestWinInfo
end

function GameListManager:setExchangeCode(m_strExchangeCode)
    self.m_strExchangeCode = m_strExchangeCode
end

function GameListManager:getExchangeCode()
    return self.m_strExchangeCode
end

function GameListManager:setRotateStatus(m_bRotateStatus)
    self.m_bRotateStatus = m_bRotateStatus
end

function GameListManager:getRotateStatus()
    return self.m_bRotateStatus
end

function GameListManager:setIsEnterGame(m_bIsEnterGame)
    self.m_bIsEnterGame = m_bIsEnterGame
end

function GameListManager:getIsEnterGame()
    return self.m_bIsEnterGame
end

function GameListManager:setGameFlag(m_nGameFlag)
    self.m_nGameFlag = m_nGameFlag
end

function GameListManager:getGameFlag()
    return self.m_nGameFlag
end

--登录游戏房间成功失败标志
function GameListManager:setIsLoginGameSucFlag(m_nIsLoginGameSucFlag)
    self.m_nIsLoginGameSucFlag = m_nIsLoginGameSucFlag
end

function GameListManager:getIsLoginGameSucFlag()
    return self.m_nIsLoginGameSucFlag
end

function GameListManager:setIsEnterAddGoldFromHall(m_bIsEnterAddGoldFromHall)
    self.m_bIsEnterAddGoldFromHall = m_bIsEnterAddGoldFromHall
end

function GameListManager:getIsEnterAddGoldFromHall()
    return self.m_bIsEnterAddGoldFromHall
end

--是否已经发送大厅请求列表
function GameListManager:setIsHadSendHallReqList(m_bIsHadSendHallReqList)
    self.m_bIsHadSendHallReqList = m_bIsHadSendHallReqList
end

function GameListManager:getIsHadSendHallReqList()
    return self.m_bIsHadSendHallReqList
end

-----
--是否已经显示过游戏公告
function GameListManager:setIsShowNotice(m_bIsShowNotice)
    self.m_bIsShowNotice = m_bIsShowNotice
end

function GameListManager:getIsShowNotice()
    return self.m_bIsShowNotice
end

--是否已经认证过
function GameListManager:setIsShowWallowVerify(m_bIsShowWallowVerify)
    self.m_bIsShowWallowVerify = m_bIsShowWallowVerify
end

function GameListManager:getIsShowWallowVerify()
    return self.m_bIsShowWallowVerify
end

--是否需要防沉迷退出
function GameListManager:setIsWallowOut(m_bIsWallowOut)
    self.m_bIsWallowOut = m_bIsWallowOut
end

function GameListManager:getIsWallowOut()
    return self.m_bIsWallowOut
end

function GameListManager:setLoginTime(m_llLoginTime)
    self.m_llLoginTime = m_llLoginTime
end

function GameListManager:getLoginTime()
    return self.m_llLoginTime
end

--0,第一个小时，1，第二个小时，2，第三个小时
function GameListManager:setWallowState(m_nWallowState)
    self.m_nWallowState = m_nWallowState
end

function GameListManager:getWallowState()
    return self.m_nWallowState
end

--是否已已读取到开关信息
function GameListManager:setIsHaveLoadSwitch(m_bIsHaveLoadSwitch)
    self.m_bIsHaveLoadSwitch = m_bIsHaveLoadSwitch
end

function GameListManager:getIsHaveLoadSwitch()
    return self.m_bIsHaveLoadSwitch
end

--是否已已读取到开关信息
function GameListManager:setIsHaveLoadGameKG(m_bIsHaveLoadGameKG)
    self.m_bIsHaveLoadGameKG = m_bIsHaveLoadGameKG
end

function GameListManager:getIsHaveLoadGameKG()
    return self.m_bIsHaveLoadGameKG
end

--是否正在重连登陆服务器
function GameListManager:setIsReLoginHall(m_bIsReLoginHall)
    self.m_bIsReLoginHall = m_bIsReLoginHall
end

function GameListManager:getIsReLoginHall()
    return self.m_bIsReLoginHall
end

--[[
struct CMD_ClientActivityConfig
{
    int arrActivityConfig[MAX_CLIENT_ACTIVITY];
    int arrActivityID[MAX_CLIENT_ACTIVITY];
    int arrActivityKind[MAX_CLIENT_ACTIVITY];
};
--]]
function GameListManager:setClientActivityConfig(pClientActivityConfig)
    if not pClientActivityConfig then return end
    for i = 1, G_CONSTANTS.MAX_CLIENT_ACTIVITY do
        --需要判断该活动是否已经显示过,今天还没有显示过就需要将他放入队列进行播放
        local curActivityID = pClientActivityConfig.arrActivityConfig[i]
        if curActivityID ~= 0 then
            local strKey = string.format("client_activity_%d_%d", PlayerInfo.getInstance():getUserID(), curActivityID)
            local strTime = cc.UserDefault:getInstance():getStringForKey(strKey, "0")
            if strTime == "0" then
                table.insert(self.m_dequeActivityID, curActivityID)
            else
                local lastShowTime = strTime
                --判断是否是同一天
                if not self:IsSameDay(lastShowTime, os.time()) then
                    table.insert(self.m_dequeActivityID, curActivityID)
                end
            end
        end
    end
end

--判断是否是同一天
function GameListManager:IsSameDay(lastTime,nowTime)
    return true
end

function GameListManager:setGameSwitch(index,status)
    if not index or index < 0 or index > G_CONSTANTS.MAX_CHANNEL_STATUS_COUNT then return end
    self.m_bGameSwitch[index] = status

    print("-------gameswitch  index:"..index.."    bool:"..tostring(status))

    if index == G_CONSTANTS.GAMESWITCH.CLOSE_ACTIVITY_RECHARGE and not status then
        PlayerInfo.getInstance():addActivityTypeId(1)
    elseif (CommonUtils.getInstance():getPlatformType() == G_CONSTANTS.CLIENT_KIND_IOS and 
           index == G_CONSTANTS.GAMESWITCH.CLOSE_ACTIVITY_COMMENT and not status) then
        PlayerInfo.getInstance():addActivityTypeId(3)
    elseif index == G_CONSTANTS.GAMESWITCH.CLOSE_ACTIVITY_DEFAULT_4 and not status then
        PlayerInfo.getInstance():addActivityTypeId(4)
    elseif index == G_CONSTANTS.GAMESWITCH.CLOSE_ACTIVITY_DEFAULT_5 and not status then
        PlayerInfo.getInstance():addActivityTypeId(5)
    elseif index == G_CONSTANTS.GAMESWITCH.CLOSE_ACTIVITY_DEFAULT_6 and not status then
        PlayerInfo.getInstance():addActivityTypeId(6)
    elseif index == G_CONSTANTS.GAMESWITCH.CLOSE_ACTIVITY_DEFAULT_7 and not status then
        PlayerInfo.getInstance():addActivityTypeId(7)
    elseif index == G_CONSTANTS.GAMESWITCH.CLOSE_ACTIVITY_DEFAULT_8 and not status then
        PlayerInfo.getInstance():addActivityTypeId(8)
    elseif index == G_CONSTANTS.GAMESWITCH.CLOSE_ACTIVITY_DEFAULT_9 and not status then
        PlayerInfo.getInstance():addActivityTypeId(9)
    elseif index == G_CONSTANTS.GAMESWITCH.CLOSE_ACTIVITY_DEFAULT_10 and not status then
        PlayerInfo.getInstance():addActivityTypeId(10)      
    end
    --fix 不应该在这里设置读取了开关
    --self.m_bIsHaveLoadSwitch = true
end

function GameListManager:getGameSwitch(index)
    if not index or index < 0 or index >= 200 then return true end
    return self.m_bGameSwitch[index]
end

function GameListManager:setHttpGameSwitch(index, ret)
    if not index or index < 0 or index > 200 then return end
    self.m_bHttpGameSwitch[index] = ret
end

function GameListManager:getHttpGameSwitch(index)
    if not index or index < 0 or index > 200 then return true end
    return self.m_bHttpGameSwitch[index]
end

function GameListManager:clearHideGameID()
    self.m_vecHideGameID = {}
end

function GameListManager:addHideGameID(gameID)
    if not gameID then return end
    table.insert(self.m_vecHideGameID, gameID)
end

--获得隐藏游戏ID
function GameListManager:getHideGameID(index)
    if not index or index < 0 or index > #self.m_vecHideGameID then 
        return 0 
    end
    return self.m_vecHideGameID[index]
end

function GameListManager:checkHideGame(gameID)
    if not gameID then return end
    for _index, _value in pairs(self.m_vecHideGameID) do
        if gameID == _value then
            return true
        end
    end
    return false;
end

function GameListManager:getHideGameSize()
    return table.nums(self.m_vecHideGameID)
end

function GameListManager:popOutAcitivity()
    local ret = 0
    if table.maxn(self.m_dequeActivityID) > 0 then
        ret = self.m_dequeActivityID[1]
        table.remove(self.m_dequeActivityID,1)
    end
    return ret
end


function GameListManager:isCloseExchange()
    
    local isClosedExchange = self:getGameSwitch(G_CONSTANTS.GAMESWITCH.CLOSE_EXCHANGE)
    --兑换开启 判断充值
    if not isClosedExchange and self:getGameSwitch(G_CONSTANTS.GAMESWITCH.CLOSE_EXCHANGE_BY_RECHARGE) 
       and PlayerInfo.getInstance():getRechargeTotal() == 0 then
        isClosedExchange = true
    end
    return isClosedExchange
end

--是否屏蔽客服
function GameListManager:isCloseService()
    local isCloseService = self:getGameSwitch(G_CONSTANTS.GAMESWITCH.CLOSE_SERVICE)
    return isCloseService
end

--是否屏蔽Vip(TODO:暂时没有VIP)
function GameListManager:isCloseVip()
    return false
end
--------------------------------------------

--------------------------------------------
--GameServerManager类方法
function GameListManager:setGameType(m_sGameType)
    self.m_sGameType = m_sGameType
end

function GameListManager:getGameType()
    return self.m_sGameType
end

function GameListManager:clearGameTable()
    self.m_mapAllGame = {}
    self.m_vecGameServer = {}
    self.m_vecGameKindId = {}
end
   
function GameListManager:addGameServer(gameserver)
    local isAdd = false
    print("server open game:", gameserver.wServerID, gameserver.szServerName, gameserver.dwBaseScore)
    for i = 1, CGameClassifyDataMgr.getInstance():getLocalOpenGameNum() do
        --根据渠道屏蔽游戏
        if self:checkHideGame(i) then
            break
        end
        if gameserver.wKindID == CGameClassifyDataMgr.getInstance():getLocalOpenGameKind(i) then
            isAdd = true
            break
        end
    end

    --tagClientGameServer结构体
    for k,v in pairs(self.m_vecGameServer) do
        if v then
            --如果已存在房间 更新信息
            if v.wKindID == gameserver.wKindID and v.wServerID == gameserver.wServerID then
                self.m_vecGameServer[k] = gameserver
                isAdd = false
                break
            end
        end
    end
    if not isAdd then return end

    table.insert(self.m_vecGameServer,gameserver)
    self:setGameSortIdMap(gameserver)
end

function GameListManager:getGameListNumber()
    return table.maxn(self.m_vecGameKindId)
end

function GameListManager:getClientGameByServerId(sServerId)
    local temptab = {}
    if not sServerId then return temptab end
    for k,v in pairs(self.m_vecGameServer) do
        if v and v.wServerID == sServerId then
            return v
        end
    end
    return temptab
end

-- 服务器下发的所有游戏(没有排序的)
function GameListManager:getLocalGameKindId()
    return self.m_mapAllGame
end

-- 服务器下发的所有游戏(排序后的)
function GameListManager:getAllGameKindId()
    return self.m_vecGameKindId
end

--当前游戏是否可用
function GameListManager:isGameKindExist(kindID)
    for k, v in pairs(self.m_vecGameServer) do
        if v.wKindID == kindID then
            return not self:gameKindHide(kindID)
        end
    end
    return false
end

function GameListManager:getStructRoomByKindID(sKindID,baseScore)
    local vecTmp = {}
    for k,v in pairs(self.m_vecGameServer) do
        if v then
            if v.wKindID == sKindID then
                if v.dwBaseScore == baseScore or baseScore == -1 then
                    table.insert(vecTmp,v)
                end
            end
        end
    end
    --根据serverID排序
    table.sort(vecTmp, function(r1, r2)
        return r1.wServerID < r2.wServerID
    end)
    return vecTmp
end

function GameListManager:getStructRoomByKindIDWithOnlyBaseScore(sKindID)
    local vecTmp = {}
    for k,v in pairs(self.m_vecGameServer) do
        if v and v.wKindID == sKindID then
            local bExist = false
            for index, room in pairs(vecTmp) do
                if room and  room.dwBaseScore == v.dwBaseScore then
                    bExist = true
                end
            end
            if not bExist then
                table.insert(vecTmp,v)
            end
        end
    end
    return vecTmp
end

function GameListManager:getGameNameByKindID(sKingID)
    local name = ""
    for k,v in pairs(self.m_vecGameServer) do
        if v and v.wKindID == sKingID then
            name = v.szServerName
            break
        end
    end
    return name
end

function GameListManager:getSuitAbleServer(sKindID, baseScore)
    local ret = {}
    local vecGameServer = {}
    if sKindID == G_CONSTANTS.EGAME_TYPE_CODE.EGAME_TYPE_NIUNIU then
        local HoxDataMgr = require("game.handredcattle.manager.HoxDataMgr")
        local bModeFour = HoxDataMgr.getInstance():getModeType() == 4
        vecGameServer = self:getStructRoomByKindIDAndMode(sKindID, baseScore, bModeFour)
    else
        vecGameServer = self:getStructRoomByKindID(sKindID, baseScore)
    end

--    local vecGameServer = self:getStructRoomByKindID(sKindID, baseScore)
    if next(vecGameServer) == nil then
        print("can't find server. ")
        return ret
    end
    
    local ret = vecGameServer[1]
    for k,v in pairs(vecGameServer) do
        if ret.dwOnLineCount > v.dwOnLineCount then
            ret = v
        end
    end
    return ret
end

function GameListManager:setGameSortIdMap(gameServer) 
    for k,v in pairs(self.m_mapAllGame) do
        if v and v.wKindId == gameServer.wKindID then
            return
        end
    end
    --PerGameInfo
    --筛选类型游戏
    local perGameInfo = {}
    perGameInfo.wKindId = gameServer.wKindID
    perGameInfo.wSortId = gameServer.wSortID
    perGameInfo.wLocalSortID = self:GetGameLocalSortID(gameServer.wKindID)
    if perGameInfo.wLocalSortID < cc.exports.g_iCalcCount then
        perGameInfo.wLocalSortID = 0 --大于等于3次才参与本地排序
    end
    table.insert(self.m_mapAllGame,perGameInfo)
end

function GameListManager:getGameKindIDBySortID(sSortID)
    local kindID = 0
    for k,v in pairs(self.m_vecGameServer) do
        if v and v.wSortID == sSortID then
            kindID = v.wSortID
            break
        end
    end
    return kindID
end

function GameListManager:sortGameKindId_AS()
    local m_vecHadResGameKindId = {}
    local m_vecNotResGameKindId = {}
    local m_vecPerInfo = {}
    
    --[[
    for k,v in pairs(self.m_mapAllGame) do
        if v then
            table.insert(m_vecPerInfo,v)
        end
    end

    --冒泡排序 ??排序
    local len = #m_vecPerInfo
    local function bubble_sort()
        local temp = {}
        for i = 1, (len-1) do
             for j = 1,(len - i) do
                if m_vecPerInfo[j].wSortId > m_vecPerInfo[j +1].wSortId then
                    temp = m_vecPerInfo[j]
                    m_vecPerInfo[j] = m_vecPerInfo[j +1]
                    m_vecPerInfo[j +1] = temp
                end
             end
        end 
    end
    bubble_sort()
    ]]

    m_vecPerInfo = table.copy(self.m_mapAllGame)

    table.sort(m_vecPerInfo, function(a,b)
          if a.wSortId + a.wLocalSortID * 10000 > b.wSortId + b.wLocalSortID * 10000 then
            return true
        end
    end)

    for k,v in pairs(m_vecPerInfo) do
        --修改为需要下载的排后面
        if not DownloadResMgr.getInstance():getIsShowDownloadDone(v.wKindId) then
            -- 需要下载资源
            table.insert(m_vecNotResGameKindId, v.wKindId)
        else
            table.insert(m_vecHadResGameKindId, v.wKindId)
        end
    end

    self.m_vecGameKindId = {}
    for _,nKindId in ipairs(m_vecHadResGameKindId) do
        table.insert(self.m_vecGameKindId,nKindId)
    end
    for _,nKindId in ipairs(m_vecNotResGameKindId) do
        table.insert(self.m_vecGameKindId,nKindId)
    end

    --游戏列表去掉要隐藏的游戏
    for index,gameID in pairs(self.m_vecHideGameID) do
        self:removeHideGameByID(gameID)
    end

    --去掉寻龙夺宝(1.9)
    for index,gameID in pairs(self.m_vecGameKindId) do
        if gameID == G_CONSTANTS.EGAME_TYPE_CODE.EGAME_TYPE_LONG_FISH then
            if GameListManager.getInstance():canOpenDeepfish(gameID) == false then --版本2.0.0
                self:removeHideGameByID(gameID)
                break
            end
        end
    end
end

function GameListManager:removeHideGameByID(KindID)
    for k,v in pairs(self.m_vecGameKindId) do
        if v and v == KindID then
            table.remove(self.m_vecGameKindId,k)
            return
        end
    end
end

function GameListManager:gameKindHide(KindID)
    for k,v in pairs(self.m_vecGameKindId) do
        if v and v == KindID then
            return false
        end
    end
    return true
end

function GameListManager:updateOnlineNumByServerIdAndScore(_roomData)
    local vecTmp = {}
    for k,v in pairs(_roomData) do
        for i,j in pairs(self.m_vecGameServer) do
            if j then
                if j.wServerID == v.wServerID then
                    self.m_vecGameServer[i].dwOnLineCount = v.dwOnLineCount
                    break
                end
            end
        end
    end
end

function GameListManager:getStructRoomByKindIDAndMode( sKindID, baseScore, isFourTimes)
    local vecTmp = {}
    for k,v in pairs(self.m_vecGameServer) do
        --有4倍两个字说明是4倍场，否则是10倍场
        if v and v.wKindID == sKindID then
            local name = v.szServerName or ""
            local isFourTimesRoom = string.find(name, LuaUtils.getLocalString("NIUNIU_15")) and true or false
            if isFourTimesRoom == isFourTimes then
                if (v.dwBaseScore == baseScore or baseScore == -1) then
                    table.insert(vecTmp,v)
                end
            end
        end
    end
    return vecTmp
end

function GameListManager:getStructRoomByKindIDAndMode2(sKindID, nMode)
    local vecTmp = {}
    for k,v in pairs(self.m_vecGameServer) do
        --有4倍两个字说明是4倍场，否则是10倍场
        if v and v.wKindID == sKindID then
            local name = v.szServerName or ""
            local isFourTimesRoom = string.find(name, "4倍")
            if isFourTimesRoom and nMode == 4 then --4倍
                table.insert(vecTmp,v)
            elseif not isFourTimesRoom and nMode == 10 then --10倍
                table.insert(vecTmp,v)
            end
        end
    end
    return vecTmp
end

function GameListManager:getStructRoomByKindIDWithBaseScoreAndMode( sKindID, isFourTimes)
    local vecTmp = {}
    for k,v in pairs(self.m_vecGameServer) do
        --有4倍两个字说明是4倍场，否则是10倍场
        local name = v.szServerName or ""
        local isFourTimesRoom = string.find(name, LuaUtils.getLocalString("NIUNIU_15")) and true or false
        if isFourTimesRoom == isFourTimes then
            if v and v.wKindID == sKindID then
                local bExist = false
                 for index, room in pairs(vecTmp) do
                    if room and room.dwBaseScore == v.dwBaseScore then
                        bExist = true
                    end
                end
                if not bExist then
                    table.insert(vecTmp,v)
                end
            end
        end
    end
    return vecTmp
end

function GameListManager:getRoomNumber( sKindID,baseScore,serverID)

    local roomList = self:getStructRoomByKindID(sKindID,baseScore)
    --百人牛牛先根据模式
    if sKindID == G_CONSTANTS.EGAME_TYPE_CODE.EGAME_TYPE_NIUNIU then
        roomList = {}
        local HoxDataMgr = require("game.handredcattle.manager.HoxDataMgr")
        local bModeFour = HoxDataMgr.getInstance():getModeType() == 4
        local rooms = self:getStructRoomByKindIDWithBaseScoreAndMode(sKindID, bModeFour)
        for k, v in pairs(rooms) do
            if v.dwBaseScore == baseScore then
                table.insert(roomList, v)
            end
        end
        table.sort(roomList, function(a, b)
            return a.wServerID < b.wServerID
        end)
    end
    for i=1, #roomList do
        if roomList[i].wServerID == serverID then 
            return i
        end
    end
    return 1
end

function GameListManager:getMatchRoom(rooms)

    --移除满员房间
    for i = table.nums(rooms), 1, -1 do
        if rooms[i].dwFullCount == rooms[i].dwOnLineCount then
            table.remove(rooms, i)
        end
    end
    --按在线人数排序房间
    table.sort(rooms, function(a, b)
        return a.dwOnLineCount < b.dwOnLineCount
    end)
    --随机登录未满员前1/2的房间
    local nRoomCount = table.nums(rooms) 
    local nRandomCount = (nRoomCount >= 4) and math.floor(nRoomCount / 2) or nRoomCount
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    local nRandom = math.random(1, nRandomCount)
    return rooms[nRandom]
end

--根据客户端版本判断是否可以开启寻龙夺宝
function GameListManager:canOpenDeepfish(_nGameKindID)

    if _nGameKindID ~= G_CONSTANTS.EGAME_TYPE_CODE.EGAME_TYPE_LONG_FISH then
        return true
    end

    local nNowVersion = CommonUtils:getInstance():formatAppVersion()
    local nSupportVersion = CommonUtils:getInstance():getFormatVersion("2.0.0")
    if nSupportVersion <= nNowVersion then
        return  true
    else
        return  false
    end
end

function GameListManager:setGameListInfo(list)
    for i, v in pairs(self.m_vecGameListInfo) do
        self.m_vecGameListInfo[i] = nil
    end
    self.m_vecGameListInfo = {}
    self.m_vecGameListInfo = list
end

function GameListManager:getGameListInfo(kind)
    return self.m_vecGameListInfo[kind]
end


--读取本地排序ID
function GameListManager:ReadGameLocalSortID()
    local strLocalSortID = cc.UserDefault:getInstance():getStringForKey("local_sort_id");
    if strLocalSortID == nil or strLocalSortID == "" then 
        return
    end

    for k, v in string.gmatch( strLocalSortID, "(%d+)=(%d+)") do       
        self.m_mapGameLocalSortID[tonumber(k)] = tonumber(v)
    end
end

--保存本地排序ID
function GameListManager:SaveGameLocalSortID()
    if table.maxn( self.m_mapGameLocalSortID ) == 0 then
        return
    end
    local strLocalSortID = ""
    for k, v in pairs( self.m_mapGameLocalSortID ) do
        local tempID = k .. "=" .. v
        if strLocalSortID == "" then
           strLocalSortID = strLocalSortID .. tempID
        else
            strLocalSortID = strLocalSortID .. "," .. tempID
        end
    end

    cc.UserDefault:getInstance():setStringForKey("local_sort_id", strLocalSortID )
    cc.UserDefault:getInstance():flush()
end
--添加本地排序值
function GameListManager:AddGameLocalSortID( gameKind, sortID )
   if self.m_mapGameLocalSortID[gameKind] ~= nil then
        self.m_mapGameLocalSortID[gameKind] = self.m_mapGameLocalSortID[gameKind] + sortID
   else 
        self.m_mapGameLocalSortID[gameKind] = sortID
   end
end
--获取指定游戏的本地排序值
function GameListManager:GetGameLocalSortID(gameKind)
    if self.m_mapGameLocalSortID[gameKind] ~= nil then
        return self.m_mapGameLocalSortID[gameKind]
    end
    return 0
end
----------------------------------
cc.exports.GameListManager = GameListManager
return GameListManager
