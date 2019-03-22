-- region PlayerInfo.lua
-- Date
--
-- endregion

--local CBankDetails = require("game.yule.bjl.src.common.manager.CBankDetails")

--local UsrMsgManager = require("game.yule.bjl.src.common.manager.UsrMsgManager")

local PlayerInfo = class("PlayerInfo")

local LuaUtils = appdf.req(appdf.EXTERNAL_SRC .. "LuaUtils")--require("client.LuaUtils")

PlayerInfo.g_instance = nil

PlayerInfo.m_sFaceID = 0 --头像标志
PlayerInfo.m_sTempFaceID = 0 --修改头像标志
PlayerInfo.m_nUserID = 0 --用户ID
PlayerInfo.m_nGameID = 0 --游戏ID
PlayerInfo.m_nGroupID = 0 --社团标志
PlayerInfo.m_nCustomID = 0 --自定义标志
PlayerInfo.m_nUserMedal = 0 --用户奖牌
PlayerInfo.m_llExperience = 0 --经验数值
PlayerInfo.m_llCurLevelExperience = 0 --当前等级经验数值
PlayerInfo.m_llNextLevelExperience = 0 --下一等级经验数值
PlayerInfo.m_iPriceScore = 0 --升级奖励
PlayerInfo.m_nLoveLiness = 0 --用户魅力
PlayerInfo.m_nLevel = 0 --用户等级
PlayerInfo.m_bReLogin = 0 --重连服务器标志
PlayerInfo.m_bIsInsurePass = 0 --是否设置银行密码
PlayerInfo.m_strInsurePass = 0 --银行密码
PlayerInfo.m_nGuestMoneyTimes = 0 --游客免费获取金币次数
PlayerInfo.m_lTempUserScore = 0 --玩家临时分数
PlayerInfo.m_wServerType = 0 --游戏房间类型（2体验房）

PlayerInfo.m_lCurAwardsGold = 0 --当前奖励金币数
PlayerInfo.m_lUserInsure = 0 --用户银行
PlayerInfo.m_lLastUserScore = 0 --用户上次金币
PlayerInfo.m_lLastUserInsure = 0 --用户银行上次金币（金币增加效果用）
PlayerInfo.m_sGender = 0 --用户性别
PlayerInfo.m_strNameNick = 0 --用户昵称
PlayerInfo.m_strGroupName = 0 --社团名称
PlayerInfo.m_strUnderWrite = 0 --个性签名
PlayerInfo.m_strTempNickName = 0 --用户修改昵称
PlayerInfo.m_strLoginPwd = 0 --用户登录密码
PlayerInfo.m_strRealName = 0 --用户真正名称
PlayerInfo.m_bIsGuest = 0 --是否游客
PlayerInfo.m_bIsRegister = 0 --是否注册
PlayerInfo.m_sMoorMachine = 0 --属性机器（暂无用）
PlayerInfo.m_strMobile = 0 --机器名
PlayerInfo.m_nVipLevel = 0 --Vip等级（暂无用）
PlayerInfo.m_nSpeakerTimes = 0 --小喇叭次数（暂无用）
PlayerInfo.m_nChairID = 0 --座位ID
PlayerInfo.m_nTableID = 0 --桌子ID
PlayerInfo.m_strEmail = 0 --邮箱
PlayerInfo.m_nLoginTime = 0 --登录时间？（暂无用）
PlayerInfo.m_nLoginType = 0 --登录类型？（1/2/3）
PlayerInfo.m_bIsSpread = 0 --是否是推广员

PlayerInfo.m_strPushToken = 0 --ios充值返回？
PlayerInfo.m_nKindID = 0 --游戏ID
PlayerInfo.m_bSitSuc = false --是否坐下成功
PlayerInfo.cbUserStatus = 0 --用户状态
PlayerInfo.m_strClientIP = 0 --客户端ip
PlayerInfo.m_nServerTime = 0 --服务器事件
PlayerInfo.m_lTimeOffset = 0 --客户端/服务器的时间差
PlayerInfo.m_nBankTransferRate = 0 --银行转账利率
PlayerInfo.m_nBankTransferPrerequisite = 0 --银行转账条件

PlayerInfo.m_lLastTransferMoney = 0 --剩余转账金额
PlayerInfo.m_llTransferLimit = 0 --转账税收限额
PlayerInfo.m_nSpreaderAwardGoldNum = 0 --推广获得金币数量
PlayerInfo.m_nStrUserAccount = 0 --帐号
PlayerInfo.m_bTransferUserIsProxy = 0 --转账到用户，是否代理
PlayerInfo.m_bTransferUserIsUnlimit = 0 --被转用户是否无限制
PlayerInfo.m_nTransferUserVipLevel = 0 --被转用户vip等级

PlayerInfo.m_bHaveRechargeOperate = 0 --是否有充值操作
PlayerInfo.m_usTargetServerID = 0 --推广获得总金币数量
PlayerInfo.m_bIsGetSharePresent = 0 --是否领取
PlayerInfo.m_nCurSharePresentIndex = 0 --当天分享序列号（0没领/1-7表示连续领取天数）

PlayerInfo.m_bIsNeedUpdateActivity = 0 --是否更新活动
PlayerInfo.m_strShareContent = 0 --活动内容描述
PlayerInfo.m_strShareUrl = 0 --活动网页地址
PlayerInfo.m_wInGameServerID = 0 --游戏房间ID

PlayerInfo.m_bIsBindWx = 0 --是否绑定微信

PlayerInfo.m_bIsQuickStart = 0 --是否快速开始
PlayerInfo.m_bIsReLoginInGame = 0 --在游戏中可以重新登录

PlayerInfo.m_strBindingCardNumber = 0 --绑定银行卡号
PlayerInfo.m_strBindingCardName = 0 --绑定银行名称
PlayerInfo.m_strBindingAliPayAccout = 0 --绑定支付宝帐号
PlayerInfo.m_strBindingAliPayName = 0 --绑定支付宝认证实名
PlayerInfo.m_strBindingBankMobile = 0 --绑定银行手机号码
PlayerInfo.m_strBindingBankName = 0 --绑定银行卡的开户行

PlayerInfo.m_strLogonSession = 0 --session

PlayerInfo.m_nRelieveScore = 0 --救济金
PlayerInfo.m_nRelieveCount = 0 --领取次数

PlayerInfo.m_nActivityShateValue = {} --分享获取money
PlayerInfo.m_lUserScore = 0 --用户分数
PlayerInfo.m_bVerifyCodeChoose = {} --校验码
PlayerInfo.m_vecActivityTypeId = {} --活动类型
PlayerInfo.m_bUserBind = {} --用户绑定信息
PlayerInfo.vec_GuestBindingInfo = {} --？暂无用

-- add by bkk ; move to controller.lua
PlayerInfo.m_bIsShowGuestRegister = false
PlayerInfo.m_bIsShowSpreadActivity = false
PlayerInfo.m_bIsHallBackToLogin = false 	-- 是否从大厅返回登录
PlayerInfo.m_bIsGameBackToHall = false 		-- 是否从游戏中返回大厅
PlayerInfo._bIsEnterGame = false
PlayerInfo.m_bIsHallBackToInGame = false    -- 是否从大厅拉回游戏
PlayerInfo.m_bIsGameNoNetWork = false       -- 是否游戏中网络断开返回大厅

PlayerInfo.m_bIsInGameRoom = false
PlayerInfo.m_bIsKickUserTo = 0

PlayerInfo.m_llRechargeTotal = 0
PlayerInfo.m_llRechargeScore = 0        --官方充值总额
PlayerInfo.m_llBuyScore = 0             --代理充值总额
PlayerInfo.m_nRechargeCount = 0         --官方充值次数
PlayerInfo.m_nBuyCount = 0              --代理充值次数

PlayerInfo.m_nDelayShowExTime = 0       --在线时长显示结算
PlayerInfo.m_bShowExchange = false      --是否显示兑换
PlayerInfo.m_nRechargeReduceRate = 0    --降低官方充值的概率
PlayerInfo.m_bShowRecharge = true       --是否显示官方充值
PlayerInfo.m_nExperienceTime = 0        --体验房时间
PlayerInfo.m_nRecommandGameKindID = 0   --推荐游戏KindID
PlayerInfo.m_strOfficialWebsite = ""    --官网地址
-- add by bkk -----------------------------------------------

function PlayerInfo.getInstance()
    if not PlayerInfo.g_instance then
        PlayerInfo.g_instance = PlayerInfo:new()
    end
    return PlayerInfo.g_instance
end

function PlayerInfo.releaseInstance()
    PlayerInfo.g_instance = nil
end

function PlayerInfo:ctor()
    print("PlayerInfo.ctor")
	--self.playerData = { }
	self.roomListData = { }
    self:setLastUserScore(0)
    self.currGamePort = 0
	self.m_activityTypeIdTab = { }
	self:Clear()
end

function PlayerInfo:Clear()

	self:setUserID(0)
	self:setGameID(0)
	self:setRealName("")
	self:setMobile("")

	self:setVipLevel(0)
	self:setSpeakerTimes(0)
	self:setEmail("")
	self:setLoginTime(0)
	self:setNameNick("")
	self:setTempNickName("")
	self:setFaceID(0)
	self:setTempFaceId(-1)
	self:setMoorMachine(0)
	self:setIsGuest(false)
    self:setIsSpread(false)
	self:setLastUserScore(0)
	self:setKindID(0)
	self:setLoginPwd("")
	self:setReLogin(false)
	self:setPriceScore(0)
	self:setChairID(INVALID_CHAIR)
	self:setLevel(1)
	self:setGuestMoneyTimes(-1)
	self.m_bSitSuc = false
    self:setIsInsurePass(0)
	for i = 1, 3 do
		self.m_bUserBind[i] = false
	end
	self:setExperience(0)
	self:setCurAwardsGold(0)
	self:setCurLevelExperience(0)
	self:setNextLevelExperience(0)
	self:setTimeOffset(0)
	self:setServerTime(0)
	self:setTempUserScore(0)
	self:setBankTransferRate(0)
	self:setBankTransferPrerequisite(0)
	self:setLastTransferMoney(0)
	self:setInsurePass("")
	self:setSpreaderAwardGoldNum(0)
	self:setStrUserAccount("")
	self:setLastUserInsure(0)
	self:setTransferUserIsProxy(false)
	self:setTransferUserIsUnlimit(0)
	self:setTransferUserVipLevel(0)
	self:setIsRegister(false)
	self:setUserInsure(0)
    self.m_lUserScore = 0
	self:setClientIP("")
	self:setTableID(INVALID_TABLE)
	self.m_usTargetServerID = 0
	self.m_bIsNeedUpdateActivity = true
	self.m_nCurSharePresentIndex = 0
	self.m_strShareContent = LuaUtils.getLocalString("WeChatShareContent")
	self.m_strShareUrl = LuaUtils.getLocalString("WeChatShareURL")

	self.m_vecActivityTypeId = {}
	for i = 1, 7 do
		self.m_nActivityShateValue[i] = 0
	end

	self:setInGameServerID(0)
	self:setServerType(0)

	for i = 1, 5 do
		self.m_bVerifyCodeChoose[i] = false
	end
	self:setLoginType(0)
	self:setTransferLimit(0)
	self:setIsBindWx(false)
	self:setIsQuickStart(false)
	self:setIsTableQuickStart(false)
	self:setIsReLoginInGame(false)

	self:setBindingCardName("")
	self:setBindingCardNumber("")
	self:setBindingAliPayName("")
	self:setBindingAliPayAccout("")

	self:setLogonSession("")

    self:setRelieveCount(0)
    self:setRelieveScore(0)

    self:setUserScore(0)
    self:setRechargeScore(0)
    self:setBuyScore(0)
    self:setRechargeCount(0)
    self:setBuyCount(0)

    -- add by bkk
	-- 是否已显示提示游客注册弹框
	self.m_bIsShowGuestRegister = false
    self.m_bIsShowSpreadActivity = false
    self.m_bIsShowTipsRelogin  = false
    self.m_nCurrentServerID = 0
    self.m_lastTablePosY = -1
    self.m_nRelieveCount = 0

    self.backgroundGame = 0
	--self.playerData.lUserScore = 0

    self.m_bIsInGameRoom = false
    self.m_bIsKickUserTo = KICK_NONE

    self:setRechargeTotal(0)

    self:setHeartTime(0)

    self:setEnterGame(false)

    self:setDelayShowExTime(0)
    self:setIsShowExchange(false)
    self:setRechargeReduceRate(0)
    self:setIsShowRecharge(true)

    self:setIsOpenAliPay(false)
    self:setIsOpenWechat(false)
    self:setIsOpenBank(false)
    
    self:setExperienceTime(0)
    self:setRecommandGameKindID(0)
    self:setOfficialWebsite("")
end

-- 登录相关 -----------------------------------------------
--退出登录
function PlayerInfo:Logout(str)

    --ok-this->Clear();
    --CBankDetails::getInstance()->Clear();
    --GameServerManager::getInstance()->Clear();
    --CUsrMsg::getInstance()->Clear();
    --CUsrRun::getInstance()->Clear();
    --ChatManager::getInstance()->Clear();
    --ok-CUserManager::getInstance()->Clear();
    --ok-CGameClassifyDataMgr::getInstance()->Clear();
    --CLoginActivity::getInstance()->Clear();
    --ShopDataMgr::getInstance()->Clear();
    --GiftDataMgr::getInstance()->Clear();
    --ok-Controller::getInstance()->setIsHaveLoadSwitch(false);
    --ok-Controller::getInstance()->setIsHaveLoadGameKG(false);
    --OtherLoginMgr::getInstance()->Logout();
    --AppView::getInstance()->cleanAllSubView();
    --MsgCenter::getInstance()->postMsg(MSG_SHOW_VIEW, cocos2d::__String::create(str.c_str()));
    --ok-CTcpSocket::getInstance()->reConnectHall();
    --ok-CTcpSocket::getInstance()->sendData(MDM_GP_LOGON, SUB_GP_LOGOUT_ACCOUNTS);

--    self:Clear()
--    CUserManager:getInstance():clear()
--    CGameClassifyDataMgr:getInstance():Clear()
--    CBankDetails.getInstance():CleanTransferLog()
--    UsrMsgManager.getInstance():Clear()
--    --修复:清空游戏列表
--    GameListManager.getInstance():clearGameTable()
--    GameListManager:getInstance():setIsHaveLoadSwitch(false)
--    GameListManager:getInstance():setIsHaveLoadGameKG(false)
--    GameListManager:getInstance():setIsReLoginHall(false)

--    CMsgHall:sendLogout()

--    --统一在发送logout消息给服务器之后自己客户端断开Socket
--    CTcpSocket:getInstance():onDisconnect()

--    self:setIsHallBackToLogin(true)
--    cc.UserDefault:getInstance():setStringForKey("password", "");
end

--重连大厅
function PlayerInfo:reLoginHall()
    
    --未登录，不重连
    if self:getUserID() == 0 then
        return
    end
    
	--在重连界面，不显示遮罩
    CTcpSocket:getInstance():onDisconnect()
    GameListManager:getInstance():setIsReLoginHall(true)
    
    --CMsgHall:sendReLoginHall()
    CMsgHall:sendSessionLogin()
end

--登录游戏
function PlayerInfo:loginGame_()

--    --重设
--    CUserManager:getInstance():clear()
--    --CTcpSocket:getInstance():onDisconnect()
--    CTcpSocket:getInstance():onDisImmediately(true)
--    CTcpSocket:getInstance():reConnectGame()

--    local uid = self:getUserID()
--    local pwd = self:getLoginPwd()
--    local mid = LuaUtils.getDeviceOpenUDIDNew()
--    CMsgGame:sendLoginGame(uid, pwd, mid)
end

--登录游戏
function PlayerInfo:loginGame()
    
    --ChatManager::getInstance()->Clear();
    --ok-CUserManager::getInstance()->Clear();

    --ok-CTcpSocket::getInstance()->reConnectGame();

    --const int userID = this->getUserID();
    --const std::string password = this->getLoginPwd();
    --std::u16string stru16StrPassword;
    --StringUtils::UTF8ToUTF16(password, stru16StrPassword);
    --CMsgGRLogin msglogin;
    --msglogin.send(userID, stru16StrPassword.c_str(), getKindID());

    cc.exports.Veil.getInstance():ShowVeil(cc.exports.VEIL_START_GAME)

    self:loginGame_()

    return true
end


--重新登录游戏
function PlayerInfo:reLoginGame()
    
    --if(CTcpSocket::getInstance()->getConnectType() != CTcpSocket::TCP_CONNECT_GAME )
    --{
    --    return false;
    --}
    --Veil::getInstance()->setEnabled(true, VEIL_LOGIN);
    --return loginGame();

    if CTcpSocket:getInstance():getConnectType() ~= TAG_SOCKET_LOGON_GAME then
        return false
    end

    self:loginGame_()

    return true
end

----游戏中重新登录游戏
--function PlayerInfo:reLoginInGame(kindID, baseScore)

--    --auto tmp = GameServerManager::getInstance()->getSuitAbleServer(kindID, baseScore);
--    --GameServerManager::getInstance()->setGameType(tmp.wKindID);
--    --CTcpSocket::getInstance()->setCurrentServerID(tmp.wServerID);
--    --Player::getInstance()->setKindID(tmp.wKindID);
--    --return loginGame();

--    local tmp = GameListManager:getInstance():getSuitAbleServer(kindID, baseScore)
--    GameListManager:getInstance():setGameType(tmp.wKindID)
--    CTcpSocket:getInstance():setCurrentServerID(tmp.wServerID)
--    PlayerInfo:getInstance():setKindID(tmp.wKindID)
--    return self:loginGame()
--end

--登录后拉回游戏
function PlayerInfo:backToGame()

    --auto room = GameServerManager::getInstance()->getClientGameByServerId(Player::getInstance()->getInGameServerID());
    --GameServerManager::getInstance()->setGameType(room.wKindID);
    --CTcpSocket::getInstance()->setCurrentServerID(room.wServerID);
    --Player::getInstance()->setKindID(room.wKindID);
    --Veil::getInstance()->setEnabled(true, VEIL_LOGIN);
    --Player::getInstance()->loginGame();
    --CGameClassifyDataMgr::getInstance()->setSelectKindID(room.wKindID);

    local sID = PlayerInfo:getInstance():getInGameServerID()
    local room = GameListManager:getInstance():getClientGameByServerId(sID)
    CommonUtils.getInstance():setGameIPandPort(room.szServerAddr,room.wServerPort)
    CTcpSocket:getInstance():setCurrentServerID(room.wServerID)
    PlayerInfo:getInstance():setKindID(room.wKindID)
    CGameClassifyDataMgr:getInstance():setSelectKindID(room.wKindID)
    Veil:getInstance():ShowVeil(VEIL_LOGIN)

    self:loginGame()
end

-- 登录相关 -----------------------------------------------



-- 用户数据 -----------------------------------------------


function PlayerInfo:addGuestBindingInfo(str)
	table.insert(self.vec_GuestBindingInfo, str)
end 

function PlayerInfo:getGuestBindingInfo(index)

    if self.vec_GuestBindingInfo[index] then
        return self.vec_GuestBindingInfo[index]
    end
	return ""
end 
function PlayerInfo:updateExperience()

end 

function PlayerInfo:getLevelUpProcess()

	local per = 100
	if (self.m_llNextLevelExperience - self.m_llCurLevelExperience) > 0 then

		per =(self.m_llExperience - self.m_llCurLevelExperience) * 100 /(self.m_llNextLevelExperience - self.m_llCurLevelExperience)
	end
	return per
end 

function PlayerInfo:getUserScore()
    return self.m_lUserScore
end

function PlayerInfo:setUserScore(userScore, bEffect)
    
    bEffect = bEffect or false

	self:setLastUserScore(self.m_lUserScore)
	if userScore >= 0 then
        self.m_lUserScore = userScore
--		if not bEffect then
--            local _event = {
--                name = Public_Events.MSG_UPDATE_USER_SCORE,
--                packet = nil,
--            }
--            SLFacade:dispatchCustomEvent(Public_Events.MSG_UPDATE_USER_SCORE, _event)
--		end
	end
end

function PlayerInfo:getUserLevel()

	return self.m_nLevel
end 

function PlayerInfo:setUserBindInfo(index, value)

	self.m_bUserBind[index] = value
end 

function PlayerInfo:getUserBindInfo(index)

	return self.m_bUserBind[index]
end 


-- ?? 活动类型ID
function PlayerInfo:addActivityTypeId(typeId)
	for k, v in pairs(self.m_activityTypeIdTab) do
        if v and v == typeId then
			return
        end
    end
	table.insert(self.m_vecActivityTypeId, typeId)
end

function PlayerInfo:getActivityTypeId(index)

	return self.m_vecActivityTypeId[index]
end 

function PlayerInfo:getActivityTypeSize()

	return #self.m_vecActivityTypeId
end 

function PlayerInfo:clearActivityType()

	self.m_vecActivityTypeId = { }
end 

function PlayerInfo:setActivityShateValue(index, value)

	if index < 0 and index >= G_CONSTANTS.MAX_SHARE_PRESENT_COUNT then

		return
	end
	self.m_nActivityShateValue[index] = value
end 

function PlayerInfo:getActivityShateValue(index)

	if index < 0 and index >= G_CONSTANTS.MAX_SHARE_PRESENT_COUNT then

		return 0
	end
	return self.m_nActivityShateValue[index]
end 

function PlayerInfo:cleanVerifyCodeChoose()

	for i = 1, MAX_VERIFY_CODE_COUNT do

		self.m_bVerifyCodeChoose[i] = false
	end
end 

function PlayerInfo:setVerifyCodeChoose(index, b)

	if index >= 0 and index < MAX_VERIFY_CODE_COUNT then

		self.m_bVerifyCodeChoose[index] = b
	end
end 

function PlayerInfo:getVerifyCodeChooseAtIndex(index)
	if index >= 0 and index < MAX_VERIFY_CODE_COUNT then

		return self.m_bVerifyCodeChoose[index]
	end
	return false
end 

-------------------------------------------------------------



function PlayerInfo:setGamePort(_port)
    self.currGamePort = _port
end

function PlayerInfo:getGamePort()
    return self.currGamePort
end

-- 初始化玩家数据
function PlayerInfo:initPlayerInfo(_data)
    if not _data then return end
    for _key, _value in pairs(_data) do
        self.playerData[_key] = _value
    end
end

function PlayerInfo:setLoginTime(nLoginTime)
	self.m_nLoginTime = nLoginTime
end

function PlayerInfo:getLoginTime()
	return self.m_nLoginTime
end

-- 设置玩家登录类型
function PlayerInfo:setLoginType(_index)
--    self.playerData.loginType = _index or 3

    self.m_nLoginType = _index or 3
end

function PlayerInfo:getLoginType()
	return self.m_nLoginType
end

function PlayerInfo:setRealName(strRealName)
	-- 用户真正的名称
	self.m_strRealName = strRealName
end

function PlayerInfo:getRealName()
	return self.m_strRealName
end

-- 设置玩家是否是游客
function PlayerInfo:setIsGuest(_bool)
--    self.playerData.isGuest = _bool

    self.m_bIsGuest = _bool
end

-- 设置玩家密码 md5
function PlayerInfo:setLoginPwd(_md5Pwd)
    --print("_md5Pwd .. " .. tostring(_md5Pwd) )
    --self.playerData.guestPwd = _md5Pwd

    self.m_strLoginPwd = _md5Pwd
end

function PlayerInfo:setPushToken(strPushToken)
	self.m_strPushToken = strPushToken
end

function PlayerInfo:getPushToken()
	return self.m_strPushToken
end

function PlayerInfo:setKindID(_index)
    print("PlayerInfo:setKindID .. " .. _index)
    self.m_nKindID = _index or 0
end

function PlayerInfo:getKindID()
	return self.m_nKindID
end

function PlayerInfo:setSitSuc(bSitSuc)
	-- 是否坐下成功
	self.m_bSitSuc = bSitSuc
end

function PlayerInfo:getSitSuc()
	return self.m_bSitSuc
end

function PlayerInfo:setUserStatus(cbUserStatus)
	-- 用户状态  zhajinhua
	self.cbUserStatus = cbUserStatus
end

function PlayerInfo:getUserStatus()
	return self.cbUserStatus
end

function PlayerInfo:setClientIP(strClientIP)
	-- 客户端 IP
	self.m_strClientIP = strClientIP
end

function PlayerInfo:getClientIP()
	return self.m_strClientIP
end

function PlayerInfo:setServerTime(nServerTime)
	-- 服务器时间
--	self.playerData.tServerTime = nServerTime

    self.m_nServerTime = nServerTime
end

function PlayerInfo:getServerTime()
--	return self.playerData.tServerTime or 0
    return self.m_nServerTime
end

function PlayerInfo:setTimeOffset()
	-- 客户端与服务器时间差
	self.m_lTimeOffset = self:getServerTime() - os.time()
end

function PlayerInfo:getTimeOffset()
	return self.m_lTimeOffset
end

function PlayerInfo:setBankTransferRate(nBankTransferRate)
	-- 银行转账利率
	self.m_nBankTransferRate = nBankTransferRate
end

function PlayerInfo:getBankTransferRate()
	return self.m_nBankTransferRate
end

function PlayerInfo:setBankTransferPrerequisite(lTimeOffset)
	-- 银行转账条件
	self.m_nBankTransferPrerequisite = lTimeOffset
end

function PlayerInfo:getBankTransferPrerequisite()
	return self.m_nBankTransferPrerequisite
end

function PlayerInfo:setLastTransferMoney(lLastTransferMoney)
	-- 剩余转账金额
	self.m_lLastTransferMoney = lLastTransferMoney
end

function PlayerInfo:getLastTransferMoney()
	return self.m_lLastTransferMoney
end

function PlayerInfo:setTransferLimit(llTransferLimit)
	-- 转账税收限额
	self.m_llTransferLimit = llTransferLimit
end

function PlayerInfo:getTransferLimit()
	return self.m_llTransferLimit
end

function PlayerInfo:setSpreaderAwardGoldNum(nSpreaderAwardGoldNum)
	-- 推广获得总金币数量
	self.m_nSpreaderAwardGoldNum = nSpreaderAwardGoldNum
end

function PlayerInfo:getSpreaderAwardGoldNum()
	return self.m_nSpreaderAwardGoldNum
end

function PlayerInfo:setStrUserAccount(nStrUserAccount)
	-- 帐号
	self.m_nStrUserAccount = nStrUserAccount
end

function PlayerInfo:getStrUserAccount()
	return self.m_nStrUserAccount
end

function PlayerInfo:setTransferUserIsProxy(bTransferUserIsProxy)
	-- 转账到用户是否是代理
	self.m_bTransferUserIsProxy = bTransferUserIsProxy
end

function PlayerInfo:getTransferUserIsProxy()
	return self.m_bTransferUserIsProxy
end

function PlayerInfo:setTransferUserIsUnlimit(bTransferUserIsUnlimit)
	-- 被转用户是否无限制
	self.m_bTransferUserIsUnlimit = bTransferUserIsUnlimit
end

function PlayerInfo:getTransferUserIsUnlimit()
	return self.m_bTransferUserIsUnlimit
end

function PlayerInfo:setTransferUserVipLevel(nTransferUserVipLevel)
	-- 被转用户vip等级
	self.m_nTransferUserVipLevel = nTransferUserVipLevel
end

function PlayerInfo:getTransferUserVipLevel()
	return self.m_nTransferUserVipLevel
end

function PlayerInfo:setHaveRechargeOperate(bHaveRechargeOperate)
	-- 是否有充值操作
	self.m_bHaveRechargeOperate = bHaveRechargeOperate
end

function PlayerInfo:getHaveRechargeOperate()
	return self.m_bHaveRechargeOperate
end

function PlayerInfo:setTargetServerID(usTargetServerID)
	self.m_usTargetServerID = usTargetServerID
end

function PlayerInfo:getTargetServerID()
	return self.m_usTargetServerID
end

-- 当前分享天数序列号 0表示没领取 1-7表示连续领取天数

function PlayerInfo:setIsGetSharePresent(bIsGetSharePresent)
	self.m_bIsGetSharePresent = bIsGetSharePresent
end

function PlayerInfo:getIsGetSharePresent()
	return self.m_bIsGetSharePresent
end

function PlayerInfo:setCurSharePresentIndex(nCurSharePresentIndex)
	self.m_nCurSharePresentIndex = nCurSharePresentIndex
end

function PlayerInfo:getCurSharePresentIndex()
	return self.m_nCurSharePresentIndex
end

function PlayerInfo:setIsNeedUpdateActivity(bIsNeedUpdateActivity)
	self.m_bIsNeedUpdateActivity = bIsNeedUpdateActivity
end

function PlayerInfo:getIsNeedUpdateActivity()
	return self.m_bIsNeedUpdateActivity
end

function PlayerInfo:setShareContent(strShareContent)
	self.m_strShareContent = strShareContent
end

function PlayerInfo:getShareContent()
	return self.m_strShareContent
end

function PlayerInfo:setShareUrl(strShareUrl)
	self.m_strShareUrl = strShareUrl
end

function PlayerInfo:getShareUrl()
	return self.m_strShareUrl
end

function PlayerInfo:setInGameServerID(wInGameServerID)
	self.m_wInGameServerID = wInGameServerID
end

function PlayerInfo:getInGameServerID()
	return self.m_wInGameServerID
end

function PlayerInfo:setIsBindWx(bIsBindWx)
	self.m_bIsBindWx = bIsBindWx
end

function PlayerInfo:getIsBindWx()
	return self.m_bIsBindWx
end

function PlayerInfo:setCurAwardsGold(lCurAwardsGold)
	-- 当前奖励金币数
	self.m_lCurAwardsGold = lCurAwardsGold
end

function PlayerInfo:getCurAwardsGold()
	return self.m_lCurAwardsGold
end

function PlayerInfo:setUserInsure(lUserInsure)
	-- 用户银行
	--self.playerData.lUserInsure = lUserInsure 

    self.m_lUserInsure = lUserInsure

--    local _event = {
--        name = Public_Events.MSG_UPDATE_USER_INSURE,
--        packet = nil,
--    }
--    SLFacade:dispatchCustomEvent(Public_Events.MSG_UPDATE_USER_INSURE, _event)
end

function PlayerInfo:getUserInsure()
--	return self.playerData.lUserInsure
    return self.m_lUserInsure
end

function PlayerInfo:setLastUserScore(_score)
    self.lastUserScore = _score
end

--游戏房间,保存快速开始
function PlayerInfo:setIsQuickStart(_bool)
    self.m_bIsQuickStart = _bool
end

function PlayerInfo:getIsQuickStart()
	return self.m_bIsQuickStart
end

--游戏选桌,保存快速开始
function PlayerInfo:setIsTableQuickStart(bool)
    self.m_bIsTableQuickStart = bool
end

function PlayerInfo:getIsTableQuickStart()
    return self.m_bIsTableQuickStart
end

function PlayerInfo:setIsReLoginInGame(bIsReLoginInGame)
	-- 在游戏中可重新登陆	
	self.m_bIsReLoginInGame = bIsReLoginInGame
end

function PlayerInfo:getIsReLoginInGame()
	return self.m_bIsReLoginInGame
end

function PlayerInfo:setBindingCardNumber(strBindingCardNumber)
	self.m_strBindingCardNumber = strBindingCardNumber
end

function PlayerInfo:getBindingCardNumber()
	return self.m_strBindingCardNumber
end

function PlayerInfo:setBindingCardName(strBindingCardName)
	self.m_strBindingCardName = strBindingCardName
end

function PlayerInfo:getBindingCardName()
	return self.m_strBindingCardName
end

function PlayerInfo:setBindingAliPayAccout(strBindingAliPayAccout)
	self.m_strBindingAliPayAccout = strBindingAliPayAccout
end

function PlayerInfo:getBindingAliPayAccout()
	return self.m_strBindingAliPayAccout
end

function PlayerInfo:setBindingAliPayName(strBindingAliPayName)
	self.m_strBindingAliPayName = strBindingAliPayName
end

function PlayerInfo:getBindingAliPayName()
	return self.m_strBindingAliPayName
end

function PlayerInfo:setBindingBankMobile(strBindingBankMobile)
	self.m_strBindingBankMobile = strBindingBankMobile
end

function PlayerInfo:getBindingBankMobile()
	return self.m_strBindingBankMobile
end

function PlayerInfo:setBindingBankName(strBindingBankName)
	self.m_strBindingBankName = strBindingBankName
end

function PlayerInfo:getBindingBankName()
	return self.m_strBindingBankName
end

function PlayerInfo:setLogonSession(strLogonSession)
	self.m_strLogonSession = strLogonSession
end

function PlayerInfo:getLogonSession()
	return self.m_strLogonSession
	--return self.playerData.szSession
end

function PlayerInfo:setFaceID(nFaceId)
	-- 头像标志
	self.m_sFaceID = nFaceId
--	self.playerData.wFaceID = nFaceId
end

function PlayerInfo:getFaceID()
    --return self.playerData.wFaceID or 1
    return self.m_sFaceID
end

function PlayerInfo:setTempFaceId(sTempFaceID)
	-- 修改头像标志
	self.m_sTempFaceID = sTempFaceID
end

function PlayerInfo:getTempFaceId()
	return self.m_sTempFaceID
end

function PlayerInfo:setUserID(nUserID)
	-- 用户ID
	--self.playerData.dwUserID = nUserID
    self.m_nUserID = nUserID
end

function PlayerInfo:getUserID()
--	return self.playerData.dwUserID or 0
    return self.m_nUserID
end

function PlayerInfo:setGameID(nGameID)
	-- 游戏ID
	self.m_nGameID = nGameID
end

function PlayerInfo:getGameID()
	return self.m_nGameID
end

function PlayerInfo:setGroupID(nGroupID)
	-- 社团标志
	self.m_nGroupID = nGroupID
end

function PlayerInfo:getGroupID()
	return self.m_nGroupID
end

function PlayerInfo:setCustomID(nCustomID)
	-- 自定标志
	self.m_nCustomID = nCustomID
end

function PlayerInfo:getCustomID()
	return self.m_nCustomID
end

function PlayerInfo:setUserMdedal(nUserMedal)
	-- 用户奖牌
	self.m_nUserMedal = nUserMedal
end

function PlayerInfo:getUserMdedal()
	return self.m_nUserMedal
end

function PlayerInfo:setExperience(llExperience)
	-- 经验数值
	self.m_llExperience = llExperience
end

function PlayerInfo:getExperience()
	return self.m_llExperience
end

function PlayerInfo:setCurLevelExperience(llCurLevelExperience)
	-- 当前等级经验数值
	self.m_llCurLevelExperience = llCurLevelExperience
end

function PlayerInfo:getCurLevelExperience()
	return self.m_llCurLevelExperience
end

function PlayerInfo:setNextLevelExperience(llNextLevelExperience)
	-- 下一等级经验数值
	self.m_llNextLevelExperience = llNextLevelExperience
end

function PlayerInfo:getNextLevelExperience()
	return self.m_llNextLevelExperience
end

function PlayerInfo:setPriceScore(iPriceScore)
	-- 升级奖励
	self.m_iPriceScore = iPriceScore
end

function PlayerInfo:getPriceScore()
	return self.m_iPriceScore
end

function PlayerInfo:setLoveLiness(nLoveLiness)
	-- 用户魅力
	self.m_nLoveLiness = nLoveLiness
end

function PlayerInfo:getLoveLiness()
	return self.m_nLoveLiness
end

function PlayerInfo:setLevel(nLevel)
	-- 游戏等级
	self.m_nLevel = nLevel
end

function PlayerInfo:getLevel()
	return self.m_nLevel
end

function PlayerInfo:setReLogin(bReLogin)
	-- 重连服务器标志
	self.m_bReLogin = bReLogin
end

function PlayerInfo:getReLogin()
	return self.m_bReLogin
end

function PlayerInfo:setIsInsurePass(bIsInsurePass)
	-- 是否设置银行密码
	--self.playerData.bySetInsurePass = bIsInsurePass

    self.m_bIsInsurePass = bIsInsurePass
end

function PlayerInfo:getIsInsurePass()
--	return self.playerData.bySetInsurePass or 0
    return self.m_bIsInsurePass
end

function PlayerInfo:setInsurePass(strInsurePass)
	-- 银行密码
	self.m_strInsurePass = strInsurePass
end

function PlayerInfo:getInsurePass()
	return self.m_strInsurePass or ""
end

function PlayerInfo:setGuestMoneyTimes(nGuestMoneyTimes)
	-- 游客免费获取金币次数
	self.m_nGuestMoneyTimes = strInsurePass
end

function PlayerInfo:getGuestMoneyTimes()
	return self.m_nGuestMoneyTimes
end

function PlayerInfo:setTempUserScore(lTempUserScore)
	-- 玩家零时分数
	self.m_lTempUserScore = lTempUserScore
end

function PlayerInfo:getTempUserScore()
	return self.m_lTempUserScore
end

function PlayerInfo:setServerType(wServerType)
	-- 游戏房间类型 //2 体验房
	self.m_wServerType = wServerType
end

function PlayerInfo:getServerType()
	return self.m_wServerType
end

function PlayerInfo:getLoginPwd()
--    return self.playerData.guestPwd
    return self.m_strLoginPwd
end

function PlayerInfo:getRoomList()
	return self.roomListData or { }
end

function PlayerInfo:getLastUserScore()
    return self.lastUserScore or 0
end

function PlayerInfo:setLastUserInsure(lLastUserInsure)
	-- 用户银行上次金币（金币增加效果用）
	self.m_lLastUserInsure = lLastUserInsure
end

function PlayerInfo:getLastUserInsure()
	return self.m_lLastUserInsure
end

function PlayerInfo:setGender(sGender)
	-- 用户性别
	--self.playerData.cbGender = sGender

    self.m_sGender = sGender
end

function PlayerInfo:getGender()
--	return self.playerData.cbGender or 0
    return self.m_sGender
end

function PlayerInfo:setNameNick(strNameNick)-- 用户昵称
	self.m_strNameNick = strNameNick
end

function PlayerInfo:getNameNick()
	return self.m_strNameNick
end

function PlayerInfo:setGroupName(strGroupName)
	-- 社团名称
	self.m_strGroupName = strGroupName
end

function PlayerInfo:getGroupName()
	return self.m_strGroupName
end

function PlayerInfo:setUnderWrite(strUnderWrite)
	-- 个性签名
	self.m_strUnderWrite = strUnderWrite
end

function PlayerInfo:getUnderWrite()
	return self.m_strUnderWrite
end

function PlayerInfo:setTempNickName(strTempNickName)
	-- 用户修改昵称
	self.m_strTempNickName = strTempNickName
end

function PlayerInfo:getTempNickName()
	return self.m_strTempNickName
end

function PlayerInfo:getIsGuest()
    --return self.playerData.isGuest
    return self.m_bIsGuest
end

function PlayerInfo:setIsRegister(bIsRegister)
	self.m_bIsRegister = bIsRegister
end

function PlayerInfo:getIsRegister()
	return self.m_bIsRegister
end

function PlayerInfo:setMoorMachine(sMoorMachine)
	-- 输定机器
	self.m_sMoorMachine = sMoorMachine
end

function PlayerInfo:getMoorMachine()
	return self.m_sMoorMachine
end

function PlayerInfo:setMachine(m_machine)
	self.m_machine = m_machine
end

function PlayerInfo:getMachine()
	return self.m_machine
end

function PlayerInfo:setMobile(strMobile)
	self.m_strMobile = strMobile
end

function PlayerInfo:getMobile()
	return self.m_strMobile
end

function PlayerInfo:setVipLevel(nVipLevel)
	self.m_nVipLevel = nVipLevel
end

function PlayerInfo:getVipLevel()
	return self.m_nVipLevel
end

function PlayerInfo:setSpeakerTimes(nSpeakerTimes)
	self.m_nSpeakerTimes = nSpeakerTimes
end

function PlayerInfo:getSpeakerTimes()
	return self.m_nSpeakerTimes
end

function PlayerInfo:setChairID(nChairID)
	self.m_nChairID = nChairID
end

function PlayerInfo:getChairID()
	return self.m_nChairID
end

function PlayerInfo:setTableID(nTableID)
	self.m_nTableID = nTableID
end

function PlayerInfo:getTableID()
	return self.m_nTableID
end

function PlayerInfo:setIsSpread(spread)
	self.m_bIsSpread = spread
end

function PlayerInfo:getIsSpread()
	return self.m_bIsSpread
end

function PlayerInfo:setEmail(strEmail)
	self.m_strEmail = strEmail
end

function PlayerInfo:getEmail()
	return self.m_strEmail
end

function PlayerInfo:getRoomList()
    return self.roomListData
end

function PlayerInfo:setBaseScore(BaseScore)
    self.m_BaseScore = BaseScore
end

function PlayerInfo:getBaseScore()
    return self.m_BaseScore
end

function PlayerInfo:setUserBackgroundGame(_gameId)
    self.backgroundGame = _gameId or 0
end

function PlayerInfo:getUserBackgroundGame()
    return self.backgroundGame or 0
end

function PlayerInfo:setShowGuestRegister(bIsShow)
	self.m_bIsShowGuestRegister = bIsShow
end

function PlayerInfo:getShowGuestRegister()
	return self.m_bIsShowGuestRegister
end

function PlayerInfo:setShowSpreadActivity(bIsShow)
	self.m_bIsShowSpreadActivity = bIsShow
end

function PlayerInfo:getShowSpreadActivity()
	return self.m_bIsShowSpreadActivity
end

function PlayerInfo:setShowTipsRelogin(ret)
	self.m_bIsShowTipsRelogin = ret
end

function PlayerInfo:getShowTipsRelogin()
	return self.m_bIsShowTipsRelogin
end

function PlayerInfo:setIsHallBackToLogin(bRet)
	self.m_bIsHallBackToLogin = bRet
end

function PlayerInfo:getIsHallBackToLogin()
	return self.m_bIsHallBackToLogin
end

function PlayerInfo:setIsGameBackToHall(bRet)
	self.m_bIsGameBackToHall = bRet
end

function PlayerInfo:getIsGameBackToHall()
	return self.m_bIsGameBackToHall
end

function PlayerInfo:setIsGameBackToHallSuc(bRet)
    self.m_bIsGameBackToHallSuccess = bRet
end

function PlayerInfo:getIsGameBackToHallSuc()
    return self.m_bIsGameBackToHallSuccess
end

function PlayerInfo:setCurrentServerID(m_nCurrentServerID)
    self.m_nCurrentServerID = m_nCurrentServerID
end

function PlayerInfo:getCurrentServerID()
    return self.m_nCurrentServerID
end

function PlayerInfo:setRelieveScore(bRelieveScore)
    self.m_nRelieveScore = bRelieveScore
end

function PlayerInfo:getRelieveScore()
    return self.m_nRelieveScore
end

function PlayerInfo:setRelieveCount(bRelieveCount)
    self.m_nRelieveCount = bRelieveCount
end

function PlayerInfo:getRelieveCount()
    return self.m_nRelieveCount
end

function PlayerInfo:setMinEnterScore(minEnterScore)
    self.m_minEnterScore = minEnterScore
end

function PlayerInfo:getMinEnterScore()
    return self.m_minEnterScore
end

function PlayerInfo:setChooseTableOffset(posY)
	self.m_lastTablePosY = posY
end

function PlayerInfo:getChooseTableOffset()
	return self.m_lastTablePosY
end

-- add by bkk
--初始化玩家数据
function PlayerInfo:initPlayerGameInfo(_data)
    if not _data then return end
    for _key, _value in pairs(_data) do
        self.playerData[_key] = _value
    end
end

function PlayerInfo:setPlayerInfoByKey(_key,_value)
    self.playerData[_key] = _value
end

--add by nick

function PlayerInfo:getUserName()
    return self.m_strNameNick
end

function PlayerInfo:setUserName(name)
    self.m_strNameNick = name
end

function PlayerInfo:saveUserScore()
    self:setTempUserScore(self:getUserScore())
end

function PlayerInfo:setIsHallBackToInGame(isTrue)
    self.m_bIsHallBackToInGame = isTrue
end

function PlayerInfo:getIsHallBackToInGame()
    return self.m_bIsHallBackToInGame
end

function PlayerInfo:setIsInGameRoom(bTrue)
    self.m_bIsInGameRoom = bTrue
end
function PlayerInfo:getIsInGameRoom()
    return self.m_bIsInGameRoom
end

--0.没踢；1.踢到大厅；2.踢到登录
KICK_NONE = 0
KICK_HALL = 1
KICK_LOGIN = 2
function PlayerInfo:setIsKickUserTo(kickTo)
    self.m_bIsKickUserTo = kickTo
end
function PlayerInfo:getIsKickUserTo()
    return self.m_bIsKickUserTo
end

function PlayerInfo:setRechargeTotal(gold)
    self.m_llRechargeTotal = gold
end

function PlayerInfo:getRechargeTotal()
    return self.m_llRechargeTotal
end

function PlayerInfo:setHeartTime(time)
    self.m_nHeartTime = time
end

function PlayerInfo:getHeartTime()
    return self.m_nHeartTime
end

function PlayerInfo:setEnterGame(bTrue)
    self.m_bEnterGame = bTrue
end

function PlayerInfo:getEnterGame()
    return self.m_bEnterGame
end

function PlayerInfo:setRechargeScore(score)
    self.m_llRechargeScore = score
end

function PlayerInfo:getRechargeScore()
    return self.m_llRechargeScore
end

function PlayerInfo:setBuyScore(score)
    self.m_llBuyScore = score
end

function PlayerInfo:getBuyScore()
    return self.m_llBuyScore
end

function PlayerInfo:setRechargeCount(count)
    self.m_nRechargeCount = count
end

function PlayerInfo:getRechargeCount()
    return self.m_nRechargeCount
end

function PlayerInfo:setBuyCount(count)
    self.m_nBuyCount = count
end

function PlayerInfo:getBuyCount()
    return self.m_nBuyCount
end

function PlayerInfo:getCurrentRoomNo()

    return GameListManager.getInstance():getRoomNumber(self:getKindID(),self:getBaseScore(),self:getCurrentServerID())
end

function PlayerInfo:getIsShowRoomNo() --超过一个房间才显示房号
    
    local kindID = self:getKindID()
    if CGameClassifyDataMgr.getInstance():isArcadeGameKind(kindID) then
        local rooms = GameListManager.getInstance():getStructRoomByKindID(kindID, -1)
        if table.nums(rooms) > 1 then
            return true
        end
    end
    return false
end

--延迟显示兑换时间
function PlayerInfo:setDelayShowExTime(fTime)
    self.m_nDelayShowExTime = fTime
end
function PlayerInfo:getDelayShowExTime()
    return self.m_nDelayShowExTime
end

--是否显示兑换
function PlayerInfo:isShowExchange()
    return self.m_bShowExchange
end
function PlayerInfo:setIsShowExchange(isShow)
    self.m_bShowExchange = isShow
end

--降低官方充值的概率
function PlayerInfo:getRechargeReduceRate()
    return self.m_nRechargeReduceRate
end
function PlayerInfo:setRechargeReduceRate(rate)
    self.m_nRechargeReduceRate = rate
end

--是否显示官方充值
function PlayerInfo:isShowRecharge()
    return self.m_bShowRecharge
end
function PlayerInfo:setIsShowRecharge(isShow)
    self.m_bShowRecharge = isShow
end

--是否支持支付宝提现
function PlayerInfo:setIsOpenAliPay(bBool)
    self.m_bIsOpen_Alipay = tonumber(bBool) == 1
end
function PlayerInfo:getIsOpenAliPay()
    return self.m_bIsOpen_Alipay
end

--是否支持微信提现
function PlayerInfo:setIsOpenWechat(bBool)
    self.m_bIsOpen_Wechat = tonumber(bBool) == 1
end
function PlayerInfo:getIsOpenWechat()
    return self.m_bIsOpen_Wechat
end

--是否支持银行卡提现
function PlayerInfo:setIsOpenBank(bBool)
    self.m_bIsOpen_Bank = tonumber(bBool) == 1
end
function PlayerInfo:getIsOpenBank()
    return self.m_bIsOpen_Bank
end

function PlayerInfo:setExperienceTime(nMin)
    self.m_nExperienceTime = nMin
end

function PlayerInfo:getExperienceTime()
    return self.m_nExperienceTime
end

function PlayerInfo:setRecommandGameKindID(kindID)
    self.m_nRecommandGameKindID = kindID
end

function PlayerInfo:getRecommandGameKindID()
    return self.m_nRecommandGameKindID
end

function PlayerInfo:setOfficialWebsite(strWeb)
    self.m_strOfficialWebsite = strWeb
end

function PlayerInfo:getOfficialWebsite()
    return self.m_strOfficialWebsite
end

cc.exports.PlayerInfo = PlayerInfo
return cc.exports.PlayerInfo