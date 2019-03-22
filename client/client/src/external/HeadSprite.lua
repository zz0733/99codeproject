--
-- Author: zhong
-- Date: 2016-07-25 10:19:18
--
--游戏头像
local HeadSprite = class("HeadSprite", cc.Sprite)
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")

local SYS_HEADSIZE = 128

function HeadSprite:ctor( )
	self.m_spRender = nil

	local this = self
	--注册事件
	local function onEvent( event )
		if event == "exit" then
			this:onExit()
		elseif event == "enterTransitionFinish" then
			this:onEnterTransitionFinish()
        end
	end
	self:registerScriptHandler(onEvent)

	self.m_headSize = 128
	self.m_useritem = nil
	self.listener = nil
	self.m_bEnable = false
	--是否头像
	self.m_bFrameEnable = false
	--头像配置
	self.m_tabFrameParam = {}
	-- 是否请求
	self.m_bSendRequest = false
end

--创建普通玩家头像
function HeadSprite:createNormal( useritem ,headSize)
   
	if nil == useritem then
		--return
	end
	local sp = HeadSprite.new()
	sp.m_headSize = headSize
	local spRender = sp:initHeadSprite(useritem)
	if nil ~= spRender then
		sp:addChild(spRender)
		local selfSize = sp:getContentSize()
		spRender:setPosition(cc.p(selfSize.width * 0.5, selfSize.height * 0.5))
		return sp
	end
	
	return nil
end

--创建裁剪玩家头像
function HeadSprite:createClipHead( useritem, headSize, clippingfile )

	if nil == useritem then
		--return
	end
	local sp = HeadSprite.new()
	sp.m_headSize = headSize
	local spRender = sp:initHeadSprite(useritem)
	if nil == spRender then
		return nil
	end 

	--创建裁剪
	local strClip = "common/head/mask130.png"
	if nil ~= clippingfile then
		strClip = clippingfile
	end
	local clipSp = nil
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(strClip)
	if nil ~= frame then
		clipSp = cc.Sprite:createWithSpriteFrame(frame)
	else
		clipSp = cc.Sprite:create(strClip)
	end
	if nil ~= clipSp then
		--裁剪
		local clip = cc.ClippingNode:create()
		clip:setStencil(clipSp)
		clip:setAlphaThreshold(0.05)
		clip:addChild(spRender)
		local selfSize = sp:getContentSize()
		clip:setPosition(cc.p(selfSize.width * 0.5, selfSize.height * 0.5))
		sp:addChild(clip)
		return sp
	end

	return nil
end

function HeadSprite:updateHead( useritem )
	if nil == useritem then
		return nil
	end
	self.m_useritem = useritem

	--系统头像
	local faceid = useritem.avatar_no%11 == 0 and 1 or useritem.avatar_no%11
	local str = ""
    if GlobalUserItem.tabAccountInfo.sex == 1 then
        str = string.format("head_mman_%02d.png", faceid)
    else
        str = string.format("head_mwoman_%02d.png", faceid)
    end
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
	if nil ~= frame then
        
		self.m_spRender:setSpriteFrame(frame)
		self:setContentSize(self.m_spRender:getContentSize())
        	
	end
	self.m_fScale = self.m_headSize / SYS_HEADSIZE
	self:setScale(self.m_fScale)

	return self.m_spRender
end

local targetPlatform = cc.Application:getInstance():getTargetPlatform()

--允许个人信息弹窗/点击头像触摸事件
function HeadSprite:registerInfoPop( bEnable, fun )
	self.m_bEnable = bEnable
	self.m_fun = fun

	if bEnable then
		--触摸事件
		self:registerTouch()
	else
		if nil ~= self.listener then
			local eventDispatcher = self:getEventDispatcher()
			eventDispatcher:removeEventListener(self.listener)
			self.listener = nil
		end
	end
end

function HeadSprite:initHeadSprite( useritem )
    if useritem == nil  then return nil end
	self.m_useritem = useritem
	local isThirdParty = useritem.bThirdPartyLogin or false	

    local faceid = useritem.avatar_no%11 == 0 and 1 or useritem.avatar_no%11
	local str = ""
    if GlobalUserItem.tabAccountInfo.sex == 1 then
        str = string.format("head_mman_%02d.png", faceid)
    else
        str = string.format("head_mwoman_%02d.png", faceid)
    end
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
    if nil ~= frame then
	    self.m_spRender = cc.Sprite:createWithSpriteFrame(frame)
	    self:setContentSize(self.m_spRender:getContentSize())
	end	
	self.m_fScale = self.m_headSize / SYS_HEADSIZE
	self:setScale(self.m_fScale)
	
	return self.m_spRender
end

function HeadSprite:registerTouch( )
	local this = self
	local function onTouchBegan( touch, event )
		return this:isVisible() and this:isAncestorVisible(this) and this.m_bEnable
	end

	local function onTouchEnded( touch, event )
		local pos = touch:getLocation()
        pos = this:convertToNodeSpace(pos)
        local rec = cc.rect(0, 0, this:getContentSize().width, this:getContentSize().height)
        if true == cc.rectContainsPoint(rec, pos) then
            if type(this.m_fun) == "function" then
            	this.m_fun()
            end
        end        
	end

	local listener = cc.EventListenerTouchOneByOne:create()
	self.listener = listener
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function HeadSprite:isAncestorVisible( child )
	if nil == child then
		return true
	end
	local parent = child:getParent()
	if nil ~= parent and false == parent:isVisible() then
		return false
	end
	return self:isAncestorVisible(parent)
end

function HeadSprite:onExit( )
	if nil ~= self.listener then
		local eventDispatcher = self:getEventDispatcher()
		eventDispatcher:removeEventListener(self.listener)
		self.listener = nil
	end
end

function HeadSprite:onEnterTransitionFinish()
	if self.m_bEnable and nil == self.listener then
		self:registerTouch()
	end
end

--缓存头像
function HeadSprite.loadAllHeadFrame()
	if false == cc.SpriteFrameCache:getInstance():isSpriteFramesWithFileLoaded("common/head/head.plist") then
		--缓存头像
		cc.SpriteFrameCache:getInstance():addSpriteFrames("common/head/head.plist")
		--
		--手动retain所有的头像帧缓存、防止被释放
		local dict = cc.FileUtils:getInstance():getValueMapFromFile("common/head/head.plist")
		local framesDict = dict["frames"]
		if nil ~= framesDict and type(framesDict) == "table" then
			for k,v in pairs(framesDict) do
				local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(k)
				if nil ~= frame then
					frame:retain()
				end
			end
		end
	end
end

function HeadSprite.unloadAllHead()
	local dict = cc.FileUtils:getInstance():getValueMapFromFile("common/head/head.plist")
	local framesDict = dict["frames"]
	if nil ~= framesDict and type(framesDict) == "table" then
		for k,v in pairs(framesDict) do
			local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(k)
			if nil ~= frame then
				frame:release()
			end
		end
	end

	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
end

--获取系统头像数量
function HeadSprite.getSysHeadCount()
	return 10
end

--缓存头像
HeadSprite.loadAllHeadFrame()

return HeadSprite