--region SettingLayer.lua
--Date
--
--Desc: 大厅设置页面
--modify by JackyXu on 2017.06.19.

local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local SettingLayer = class("SettingLayer", FixLayer)
local HeadSprite = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")

local G_SettingLayer
function SettingLayer.create(scene)
    G_SettingLayer = SettingLayer.new():init(scene)
    return G_SettingLayer
end

function SettingLayer:ctor()
	self.super:ctor(self)
    self:enableNodeEvents()

    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)
end

function SettingLayer:init(scene)
    self._scene = scene
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)

    self.m_pathUI = cc.CSLoader:createNode("hall/csb/HallViewSetting.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("HallViewSetting")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    self.m_pImageBg         = self.m_pNodeRoot:getChildByName("Image_bg")
    self.m_pBtnClose        = self.m_pImageBg:getChildByName("Button_close")
    self.m_pNodeMusic       = self.m_pImageBg:getChildByName("Panel_music_node")
    self.m_pNodeSound       = self.m_pImageBg:getChildByName("Panel_sound_node")
  

    local pNormalSprite = cc.Scale9Sprite:createWithSpriteFrameName("hall/plist/userinfo/gui-setting-close.png")
    local pClickSprite  = cc.Scale9Sprite:createWithSpriteFrameName("hall/plist/userinfo/gui-setting-open.png")
    self.m_pBtMusic     = cc.ControlButton:create(pNormalSprite)
    local pBtnSize      = self.m_pNodeMusic:getContentSize()
    self.m_pBtMusic:setZoomOnTouchDown(true)
    self.m_pBtMusic:setBackgroundSpriteForState(pClickSprite,cc.CONTROL_STATE_HIGH_LIGHTED)
--    self.m_pBtMusic:setScrollSwallowsTouches(false)
--    self.m_pBtMusic:setCheckScissor(false)
    self.m_pBtMusic:setPosition(cc.p(pBtnSize.width/2, pBtnSize.height/2))
    self.m_pNodeMusic:addChild(self.m_pBtMusic)
    local function onButtonClicked()
        self:onMusicClicked()
    end
    self.m_pBtMusic:registerControlEventHandler(onButtonClicked, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)

    --
    local pNormalSprite1 = cc.Scale9Sprite:createWithSpriteFrameName("hall/plist/userinfo/gui-setting-close.png")
    local pClickSprite1  = cc.Scale9Sprite:createWithSpriteFrameName("hall/plist/userinfo/gui-setting-open.png")
    self.m_pBtSound      = cc.ControlButton:create(pNormalSprite1)
    local pBtnSize1      = self.m_pNodeSound:getContentSize()
    self.m_pBtSound:setZoomOnTouchDown(true)
    self.m_pBtSound:setBackgroundSpriteForState(pClickSprite1,cc.CONTROL_STATE_HIGH_LIGHTED)
--    self.m_pBtSound:setScrollSwallowsTouches(false)
--    self.m_pBtSound:setCheckScissor(false)
    self.m_pBtSound:setPosition(cc.p(pBtnSize1.width/2, pBtnSize1.height/2))
    self.m_pNodeSound:addChild(self.m_pBtSound)
    local function onButtonClicked1()
        self:onSoundClicked()
    end
    self.m_pBtSound:registerControlEventHandler(onButtonClicked1, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)

    self.m_pBtnClose:addClickEventListener(handler(self,self.onCloseClicked))
    ----------updateview------
    self:initViewData()
    self:UpdateViewInfo()

    return self
end

function SettingLayer:onEnter()
    self.super:onEnter()
    self:showWithStyle()
end

function SettingLayer:onExit()
    self.super:onExit()
    G_SettingLayer = nil
end

--------------------------
function SettingLayer:initViewData()
    self.music = GlobalUserItem.bVoiceAble
    self.sound = GlobalUserItem.bSoundAble

--    local strNickName = GlobalUserItem.tabAccountInfo.nickname
--    self.m_pLbName:setString(strNickName)

--    local strUserID = GlobalUserItem.tabAccountInfo.userid
--    self.m_pLbGameId:setString("ID: " .. strUserID)

--    --if PlayerInfo.getInstance():getIsGuest() then
--    if false then
--        self.m_pLbNotice:setString(yl.getLocalString("STRING_012"))
--    else
--        self.m_pLbNotice:setString(yl.getLocalString("STRING_013"))
--    end
end

-- 退出帐号提示
function SettingLayer:showLogoutNotice()
    if self._queryDialog then
        return
    end
   self._queryDialog = QueryDialog:create(yl.getLocalString("MESSAGE_11"), function(ok)
        if ok == true then
            self._scene:exitPlaza()
        end
        self._queryDialog = nil
    end):setCanTouchOutside(false)
        :addTo(self)
end

function SettingLayer:onCloseClicked()
    ExternalFun.playClickEffect()
    self:onMoveExitView()
end

function SettingLayer:onLogoutClicked()
   ExternalFun.playClickEffect()
    self:showLogoutNotice()
end

function SettingLayer:onMusicClicked()
   ExternalFun.playClickEffect()
    if not GlobalUserItem.bVoiceAble then
        GlobalUserItem.setVoiceAble(true)
        ExternalFun.playPlazzBackgroudAudio()
    else
        GlobalUserItem.setVoiceAble(false)
    end
    self.music = GlobalUserItem.bVoiceAble
    self:UpdateViewInfo()
end

function SettingLayer:onSoundClicked()
    if not GlobalUserItem.bSoundAble then
        GlobalUserItem.setSoundAble(true)
    else
        GlobalUserItem.setSoundAble(false)
    end
    ExternalFun.playClickEffect()
    
    self.sound = GlobalUserItem.bSoundAble
    self:UpdateViewInfo()
end

function SettingLayer:UpdateViewInfo()
    local musicTexture = self.music and "gui-setting-open.png" or "gui-setting-close.png"
    local soundTexture = self.sound and "gui-setting-open.png" or "gui-setting-close.png"

    local btnNormal = cc.Scale9Sprite:createWithSpriteFrameName(musicTexture)
    local btnSelected = cc.Scale9Sprite:createWithSpriteFrameName(musicTexture)
    self.m_pBtMusic:setBackgroundSpriteForState(btnNormal,cc.CONTROL_STATE_NORMAL)
    self.m_pBtMusic:setBackgroundSpriteForState(btnSelected,cc.CONTROL_STATE_HIGH_LIGHTED)

    local btnNormal2 = cc.Scale9Sprite:createWithSpriteFrameName(soundTexture)
    local btnSelected2 = cc.Scale9Sprite:createWithSpriteFrameName(soundTexture)
    self.m_pBtSound:setBackgroundSpriteForState(btnNormal2,cc.CONTROL_STATE_NORMAL)
    self.m_pBtSound:setBackgroundSpriteForState(btnSelected2,cc.CONTROL_STATE_HIGH_LIGHTED)
end


return SettingLayer
