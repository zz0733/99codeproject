--
-- Author: zhong
-- Date: 2016-07-22 13:27:18
--
--[[
* 通用显示玩家信息
]]

local PopupInfoLayer = class("PopupInfoLayer", cc.Layer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local HeadSprite = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")

local NotifyMgr = appdf.req(appdf.EXTERNAL_SRC .. "NotifyMgr")

function PopupInfoLayer:ctor(viewParent, isGame, csbFile)
	--注册事件
	ExternalFun.registerNodeEvent(self)

	self.m_parent = viewParent

	--加载csb资源
	isGame = isGame or false
	isGame = true
	local csbNode = nil
	if nil ~= csbFile and type(csbFile) == "string" and cc.FileUtils:getInstance():isFileExist(csbFile) then
		csbNode = ExternalFun.loadCSB(csbFile, self)
	else
		if true == isGame then
			if yl.SHOW_IP_ADDRESS then
				csbNode = ExternalFun.loadCSB("public/GamePopInfo.csb", self)
			else
				csbNode = ExternalFun.loadCSB("public/GamePopInfoNormal.csb", self)
			end
		else
			if yl.SHOW_IP_ADDRESS then
				csbNode = ExternalFun.loadCSB("public/PlazzPopInfo.csb", self)
			else
				csbNode = ExternalFun.loadCSB("public/PlazzPopInfoNormal.csb", self)
			end		
		end
	end
	self.m_bIsGame = isGame
	self.m_userInfo = {}

	--
	local bg_kuang = csbNode:getChildByName("bg_kuang")
	self.m_spBgKuang = bg_kuang

	--玩家头像
	local tmp = bg_kuang:getChildByName("_head_bg")
	self.m_headSize = tmp:getContentSize().width
	self.m_headPos = {x = tmp:getPositionX(), y = tmp:getPositionY()}
	tmp:removeFromParent()
	self.m_spHead = nil

	self.m_headNode = csbNode:getChildByName("Node_face")

	--签名
	self.m_textSign = bg_kuang:getChildByName("sign_text")

	--vip等级
	--self.m_textVip = bg_kuang:getChildByName("vip_text")

	--昵称
	tmp = bg_kuang:getChildByName("nick_text")
	self.m_clipNick = ClipText:createClipText(tmp:getContentSize(),"")
	self.m_clipNick:setPosition(tmp:getPosition())
	bg_kuang:addChild(self.m_clipNick)
	self.m_clipNick:setAnchorPoint(cc.p(0.0,0.5))
	self.m_clipNick:setTextColor(tmp:getTextColor())
	tmp:removeFromParent()

	--id
	self.m_textId = bg_kuang:getChildByName("id_text")

	--元宝
	--self.m_textIngot = bg_kuang:getChildByName("ingot_text")

	--游戏币
	--self.m_textScore = bg_kuang:getChildByName("score_text")

	--游戏豆
	--self.m_textBean = bg_kuang:getChildByName("bean_text")

	
	-- ip地址
	self.m_textIp = bg_kuang:getChildByName("ip_text")
	if nil ~= self.m_textIp then
		self.m_textIp:setVisible(yl.SHOW_IP_ADDRESS)
		if self.m_parent.m_bIsGamePop then
			self.m_textIp:setVisible(false)
		end
	end

	self.m_textDistance = bg_kuang:getChildByName("distance_text")
	if nil ~= self.m_textDistance then
		self.m_textDistance:setVisible(yl.SHOW_IP_ADDRESS)
		if self.m_parent.m_bIsGamePop then
			self.m_textDistance:setVisible(false)
		end
	end

	--性别
	self.m_male = bg_kuang:getChildByName("rank_userMale")
	self.m_female = bg_kuang:getChildByName("rank_userFemale")

	self.m_spTextBg = bg_kuang:getChildByName("sp_text_bg")

	--加载动画
	self.m_actShowAct = cc.ScaleTo:create(0.2, 1.0)
	ExternalFun.SAFE_RETAIN(self.m_actShowAct)

	local scale = cc.ScaleTo:create(0.2, 0.0001)
	local call = cc.CallFunc:create(function( )
		self:setVisible(false)
		self.m_spBgKuang:setAnchorPoint(cc.p(0.5,0.5))
	end)
	self.m_actHideAct = cc.Sequence:create(scale, call)
	ExternalFun.SAFE_RETAIN(self.m_actHideAct)
end

function PopupInfoLayer:onNearUserInfo( event )
	local nearuser = event.msg
	dump(nearuser, "nearuser", 6)
	if nil ~= nearuser then
		--位置
		if nil ~= self.m_textDistance and nil ~= nearuser.szPlaceName then
			local Adress = (nearuser.szPlaceName == "") and "暂未获取到地址" or nearuser.szPlaceName
			local strPlaceName = string.EllipsisByConfig(Adress, 250, 
                                		string.getConfig("fonts/round_body.ttf", 14))
			self.m_textDistance:setString(strPlaceName)
		end
	end
	--[[if nil ~= nearuser then
		-- ip地址
		local ipTable = ExternalFun.long2ip(nearuser.dwClientAddr)
		local r1 = ipTable.b
		local r2 = ipTable.s
		local r3 = ipTable.m
		local r4 = ipTable.p
		if nil == r1 or nil == r2 or nil == r3 or nil == r4 then
			self.m_userInfo.szIpAddress = ""
		else
			self.m_userInfo.szIpAddress = r1 .. "." .. r2 .. "." .. r3 .. "." .. r4
		end
		self.m_textIp:setString(self.m_userInfo.szIpAddress)

		-- 距离
		self.m_userInfo.dwDistance = nearuser.dwDistance
		if nil ~= self.m_userInfo.dwDistance and 0 ~= self.m_userInfo.dwDistance then
			if self.m_userInfo.dwDistance > 1000 then
				self.m_clipDistance:setString(string.format("%.2f", self.m_userInfo.dwDistance / 1000))
				self.m_textDistance:setString("千米")
			else
				self.m_clipDistance:setString("" .. self.m_userInfo.dwDistance)
				self.m_textDistance:setString("米")
			end
		else
			self.m_clipDistance:setString("")
			self.m_textDistance:setString("")
		end
	end]]	
end

--通知消息回调
function PopupInfoLayer:onNotify(msg)
	local bRes = false
	if nil == msg then
		return bRes
	end
	if msg.main == chat_cmd.MDM_GC_USER and msg.sub == chat_cmd.SUB_GC_RESPOND_NOTIFY then
		if msg.name == "faceinfo_friend_response" then
			bRes = true
		end
	end

	return bRes
end

function PopupInfoLayer:showLayer( var )
	self.m_spBgKuang:setScale(0.0001)
	self:setVisible(var)
end

function PopupInfoLayer:reSet(  )
	--头像
	if nil ~= self.m_spHead and nil ~= self.m_spHead:getParent() then
		self.m_spHead:removeFromParent()
	end

	self.m_textSign:setString("")
	--self.m_textVip:setString("")
	self.m_clipNick:setString("")
	self.m_textId:setString("")
	--[[self.m_textIngot:setString("")
	self.m_textScore:setString("")
	self.m_textBean:setString("")
	self.m_textIp:setString("")
	self.m_textDistance:setString("")]]
end

function PopupInfoLayer:refresh( useritem, popPos ,anr)
	self:reSet()
	if nil == useritem then
		return
	end
	self.m_userInfo = useritem
	--判断是否进入防作弊房间
	local bAntiCheat = GlobalUserItem.isAntiCheatValid(useritem.dwUserID)

	local nick = useritem.szNickName or ""
	local dwGameID = useritem.dwGameID or 0
	local ingot = useritem.lIngot or useritem.lUserIngot
	ingot = ingot or 0
	local vipIdx = useritem.cbMemberOrder or 0
	local sign = useritem.szSign or "此人很懒，没有签名"
	print("PopupInfoLayer:refresh---------------》", useritem.szSign, sign)

	local ipAdress = useritem.szIpAddress or ""
	if nil ~= useritem.dwIpAddress then
		if 0 == useritem.dwIpAddress then
			useritem.dwIpAddress = ExternalFun.random_longip()
		end
		local ipTable = ExternalFun.long2ip(useritem.dwIpAddress)
		local r1 = ipTable.b
		local r2 = ipTable.s
		local r3 = ipTable.m
		local r4 = ipTable.p
		if nil == r1 or nil == r2 or nil == r3 or nil == r4 then
			useritem.szIpAddress = ""
		else
			useritem.szIpAddress = r1 .. "." .. r2 .. "." .. r3 .. "." .. r4
		end
		ipAdress = useritem.szIpAddress
	end
	local dwDistance = useritem.dwDistance

	local Adress = (useritem.szLocation == nil) and "暂未获取到地址" or useritem.szLocation
	Adress = (Adress == "") and "暂未获取到地址" or Adress
	print("PopupInfoLayer:refresh---------------》", useritem.szLocation, Adress)
	
	sign = (sign == "") and "此人很懒，没有签名" or sign
	local bEnable = useritem.dwUserID ~= GlobalUserItem.dwUserID
	local visible = useritem.dwUserID ~= GlobalUserItem.dwUserID
	if bAntiCheat then
		nick = "游戏玩家"
		dwGameID = 0000
		ingot = 0
		vipIdx = 0
		sign = "此人很懒，没有签名"
		bEnable = false
	end

	--自己签名
	if useritem.dwGameID == GlobalUserItem.dwGameID then
		sign = GlobalUserItem.szSign
		ipAdress = GlobalUserItem.szIpAdress
		Adress = (GlobalUserItem.szLocation == nil) and "暂未获取到地址" or GlobalUserItem.szLocation
	else 
		if not bAntiCheat and nil == dwDistance then
		end
	end

	local size = cc.Director:getInstance():getWinSize()
	local pos = cc.p(size.width * 0.11, size.height * 0.26)
	if nil ~= popPos then
		pos = popPos --cc.p(size.width * 0.76, size.height * 0.44)
	end	
	if nil ~= anr then
		self.m_spBgKuang:setAnchorPoint(anr)
	end
	local bgAnchor = self.m_spBgKuang:getAnchorPoint()
	local bgSize = self.m_spBgKuang:getContentSize()
	pos = cc.p(pos.x + bgSize.width * bgAnchor.x, pos.y + bgSize.height * bgAnchor.y)
	self.m_spBgKuang:setPosition(pos)

	self.m_spBgKuang:stopAllActions()
	self.m_spBgKuang:runAction(self.m_actShowAct)
	
	if true == self.m_bIsGame then
		local head = HeadSprite:createNormal(useritem, self.m_headSize)
		if nil ~= head then
			print("create head")
			head:setPosition(self.m_headPos["x"], self.m_headPos["y"])
			self.m_spBgKuang:addChild(head, 1)
			self.m_spHead = head
		end
	else		
		local head = HeadSprite:createNormal(useritem, self.m_headSize --[[84]])
		if nil ~= head then
			head:setPosition(self.m_headPos["x"], self.m_headPos["y"])
			self.m_spBgKuang:addChild(head, 1)
			--self.m_spBgKuang:addChild(head, 1)
			self.m_spHead = head
		end
	end	
	
	--签名
	sign = sign or "此人很懒，没有签名"
	self.m_textSign:setString("个性签名: " .. sign)
	self.m_textSign:setVisible(not bAntiCheat)

	--vip
	--self.m_textVip:setString(string.format("%d", vipIdx))
	--[[local vipSp = self.m_spBgKuang:getChildByName("vip_sprite")
	if nil == vipSp then
		vipSp = cc.Sprite:create("usercenter/atlas_vipnumber.png")
		if nil ~= vipSp then
			vipSp:setName("vip_sprite")
			vipSp:setAnchorPoint(cc.p(0, 0.5))
			vipSp:setPosition(self.m_textVip:getPosition())
			self.m_spBgKuang:addChild(vipSp)			
		end
	end
	vipSp:setScale(0.9)
	vipSp:setTextureRect(cc.rect(28*vipIdx,0,28,26))]]

	--昵称	
	self.m_clipNick:setString(nick)

	--id
	local str = string.format("%d", dwGameID)
	self.m_textId:setString(str)

	--地址
	if nil ~= self.m_textDistance then
		local strPlaceName = string.EllipsisByConfig(Adress, 250, 
                                		string.getConfig("fonts/round_body.ttf", 14))
		print("PopupInfoLayer:refresh#####---------------》", strPlaceName, Adress)
		self.m_textDistance:setString(strPlaceName)
	end

	--ip
	if nil ~= self.m_textIp then
		self.m_textIp:setString(ipAdress)
	end

	--性别
	if nil ~= self.m_male then
		self.m_male:setVisible(useritem.cbGender == 1)
	end
	if nil ~= self.m_female then
		self.m_female:setVisible(useritem.cbGender == 0)
	end
end

function PopupInfoLayer:onExit( )
	if nil ~= self.listener then
		local eventDispatcher = self:getEventDispatcher()
		eventDispatcher:removeEventListener(self.listener)
		self.listener = nil
	end	

	ExternalFun.SAFE_RELEASE(self.m_actShowAct)
	self.m_actShowAct = nil
	ExternalFun.SAFE_RELEASE(self.m_actHideAct)
	self.m_actHideAct = nil

	if nil ~= self.m_listener then
		local eventDispatcher = self:getEventDispatcher()
		eventDispatcher:removeEventListener(self.m_listener)
		self.m_listener = nil
	end	
end

function PopupInfoLayer:onEnterTransitionFinish( )
	self:registerTouch()

	-- 信息通知
	self.m_listener = cc.EventListenerCustom:create(yl.RY_NEARUSER_NOTIFY,handler(self, self.onNearUserInfo))
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_listener, self)
end

function PopupInfoLayer:registerTouch(  )
	local function onTouchBegan( touch, event )
		return self:isVisible()
	end

	local function onTouchEnded( touch, event )
		local pos = touch:getLocation();
		local m_spBg = self.m_spBgKuang
        pos = m_spBg:convertToNodeSpace(pos)
        local rec = cc.rect(0, 0, m_spBg:getContentSize().width, m_spBg:getContentSize().height)
        if false == cc.rectContainsPoint(rec, pos) then
            self:hide()
        end        
	end

	local listener = cc.EventListenerTouchOneByOne:create();
	self.listener = listener;
	listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN );
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED );
    local eventDispatcher = self:getEventDispatcher();
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self);
end

function PopupInfoLayer:hide()
	self.m_spBgKuang:stopAllActions()
    self.m_spBgKuang:runAction(self.m_actHideAct)
end

return PopupInfoLayer