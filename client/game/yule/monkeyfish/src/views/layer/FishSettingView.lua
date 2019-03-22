-- region *.lua
-- Date     2017.04.07
-- zhiyuan
-- 此文件由[BabeLua]插件自动生成

local module_pre = "game.yule.monkeyfish.src"
local FishRes = require(module_pre..".views.scene.FishSceneRes")
local FishDataMgr         =   require(module_pre..".views.manager.FishDataMgr")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local FishSettingView = class("FishSettingView", cc.Layer)

local OPEN_MUSIC = 1
local OPEN_SOUND = 2
local OPEN_SHADOW = 3
local OPEN_EFFECT = 4
local IS_OPEN = 0
local IS_CLOSE = 1

function FishSettingView:ctor()
    self:enableNodeEvents()
    self.m_iOpenValue = {}
    self:init()
end

function FishSettingView:onEnter()
    onOpenLayer(self.m_pNodeSetting, self.m_pNodeShadow, self)
end

function FishSettingView:onExit()
end

function FishSettingView:init()

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)

    --csb
    self.m_pathUI = cc.CSLoader:createNode("game/monkeyfish/csb/gui-fish-setting.csb")
    self.m_pathUI:setPositionX((display.width - 1334) / 2)
    self.m_pathUI:setPositionY((display.height - 750) / 2)
    self.m_pathUI:addTo(self.m_rootUI)

    --按钮
    self.m_pNodeShadow  = self.m_pathUI:getChildByName("NodeShadow")
    self.m_pNodeSetting = self.m_pathUI:getChildByName("NodeSetting")
    self.m_pBtnClose    = self.m_pNodeSetting:getChildByName("Button_Close")
    self.m_pBtnSwitch   = self.m_pNodeSetting:getChildByName("Button_Switch")
    self.m_pBtnSwitch2  = self.m_pNodeSetting:getChildByName("Button_Switch2")
    self.m_pBtnMusic    = self.m_pNodeSetting:getChildByName("Button_Music")
    self.m_pBtnMusic2   = self.m_pNodeSetting:getChildByName("Button_Music2")
    self.m_pBtnSound    = self.m_pNodeSetting:getChildByName("Button_Sound")
    self.m_pBtnSound2   = self.m_pNodeSetting:getChildByName("Button_Sound2")
    self.m_pBtnShadow   = self.m_pNodeSetting:getChildByName("Button_Shadow")
    self.m_pBtnShadow2  = self.m_pNodeSetting:getChildByName("Button_Shadow2")
    self.m_pBtnEffect   = self.m_pNodeSetting:getChildByName("Button_Effect")
    self.m_pBtnEffect2  = self.m_pNodeSetting:getChildByName("Button_Effect2")

    --绑定按钮
    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseClicked))
    self.m_pBtnSwitch:setTag(IS_OPEN)
    self.m_pBtnSwitch:addClickEventListener(handler(self, self.onSwitchClicked))
    self.m_pBtnSwitch2:setTag(IS_CLOSE)
    self.m_pBtnSwitch2:addClickEventListener(handler(self, self.onSwitchClicked))
    self.m_pBtnMusic:setTag(IS_CLOSE)
    self.m_pBtnMusic:addClickEventListener(handler(self, self.onMusicClicked))
    self.m_pBtnMusic2:setTag(IS_OPEN)
    self.m_pBtnMusic2:addClickEventListener(handler(self, self.onMusicClicked))
    self.m_pBtnSound:setTag(IS_CLOSE)
    self.m_pBtnSound:addClickEventListener(handler(self, self.onSoundClicked))
    self.m_pBtnSound2:setTag(IS_OPEN)
    self.m_pBtnSound2:addClickEventListener(handler(self, self.onSoundClicked))
    self.m_pBtnShadow:setTag(IS_CLOSE)
    self.m_pBtnShadow:addClickEventListener(handler(self, self.onShadowClicked))
    self.m_pBtnShadow2:setTag(IS_OPEN)
    self.m_pBtnShadow2:addClickEventListener(handler(self, self.onShadowClicked))
    self.m_pBtnEffect:setTag(IS_CLOSE)
    self.m_pBtnEffect:addClickEventListener(handler(self, self.onEffectClicked))
    self.m_pBtnEffect2:setTag(IS_OPEN)
    self.m_pBtnEffect2:addClickEventListener(handler(self, self.onEffectClicked))

    --加载
    for i = OPEN_MUSIC, OPEN_EFFECT do
        self.m_iOpenValue[i] = self:getIsOpenValue(i)
        self:onUpdateOpen(i, self.m_iOpenValue[i])
    end
end

function FishSettingView:onCloseClicked()
    ExternalFun.playGameEffect(FishRes.SOUND_OF_CLOSE)

    onCloseLayer(self.m_pNodeSetting, self.m_pNodeShadow, self)
end

function FishSettingView:onSwitchClicked(pSender)
    ExternalFun.playGameEffect(FishRes.SOUND_OF_BUTTON)

    local tag = pSender:getTag()
    for i = OPEN_MUSIC, OPEN_EFFECT do
        self:saveOpenValue(i, tag)
        self:onUpdateOpen(i, tag)
    end
end

function FishSettingView:onMusicClicked(pSender)
    ExternalFun.playGameEffect(FishRes.SOUND_OF_BUTTON)

    local tag = pSender:getTag()
    self:saveOpenValue(OPEN_MUSIC, tag)
    self:onUpdateOpen(OPEN_MUSIC, tag)
end

function FishSettingView:onSoundClicked(pSender)
    ExternalFun.playGameEffect(FishRes.SOUND_OF_BUTTON)

    local tag = pSender:getTag()
    self:saveOpenValue(OPEN_SOUND, tag)
    self:onUpdateOpen(OPEN_SOUND, tag)
end

function FishSettingView:onShadowClicked(pSender)
    ExternalFun.playGameEffect(FishRes.SOUND_OF_BUTTON)

    local tag = pSender:getTag()
    self:saveOpenValue(OPEN_SHADOW, tag)
    self:onUpdateOpen(OPEN_SHADOW, tag)
end

function FishSettingView:onEffectClicked(pSender)
    ExternalFun.playGameEffect(FishRes.SOUND_OF_BUTTON)

    local tag = pSender:getTag()
    self:saveOpenValue(OPEN_EFFECT, tag)
    self:onUpdateOpen(OPEN_EFFECT, tag)
end

function FishSettingView:onUpdateOpen(i, index)
        
    --检查按钮
    if i == OPEN_MUSIC then
        self.m_pBtnMusic:setVisible(index == IS_OPEN)
        self.m_pBtnMusic2:setVisible(index == IS_CLOSE)
    elseif i == OPEN_SOUND then
        self.m_pBtnSound:setVisible(index == IS_OPEN)
        self.m_pBtnSound2:setVisible(index == IS_CLOSE)
    elseif i == OPEN_SHADOW then
        self.m_pBtnShadow:setVisible(index == IS_OPEN)
        self.m_pBtnShadow2:setVisible(index == IS_CLOSE)
    elseif i == OPEN_EFFECT then
        self.m_pBtnEffect:setVisible(index == IS_OPEN)
        self.m_pBtnEffect2:setVisible(index == IS_CLOSE)
    end

    --检查模式
    self:onCheckSwitch()
end

function FishSettingView:onCheckSwitch()
    
    if  self.m_pBtnMusic2:isVisible() and self.m_pBtnSound2:isVisible()
    and self.m_pBtnShadow2:isVisible() and self.m_pBtnEffect2:isVisible()
    then
        self.m_pBtnSwitch:setEnabled(true)
        self.m_pBtnSwitch2:setEnabled(false)
    else
        self.m_pBtnSwitch:setEnabled(false)
        self.m_pBtnSwitch2:setEnabled(true)
    end
end

function FishSettingView:saveOpenValue(i, index) --保存值
    self:setIsOpenValue(i, index)
end

function FishSettingView:setIsOpenValue(i, index)

    self.m_iOpenValue[i] = index

    if i == OPEN_MUSIC then --音乐
        
        --保存/打开/关闭音乐
        local isMusicOn = GlobalUserItem.bVoiceAble
        if index == IS_OPEN and isMusicOn == false then
            GlobalUserItem.setVoiceAble(true)
            ExternalFun.playGameBackgroundAudio(FishRes.SOUND_OF_BG[1])
        elseif index == IS_CLOSE and isMusicOn == true then
            GlobalUserItem.setVoiceAble(false)
        end

    elseif i == OPEN_SOUND then --音效

        --保存/打开/关闭音效
        if index == IS_OPEN then
            GlobalUserItem.setSoundAble(true)
        elseif index == IS_CLOSE then
            GlobalUserItem.setSoundAble(false)
        end

    elseif i == OPEN_SHADOW then --影子

        --保存/打开/关闭影子
        FishDataMgr:getInstance():ShowFishShadow( index == IS_OPEN )  
        cc.UserDefault:getInstance():setIntegerForKey("fish_shadow", index)
        cc.UserDefault:getInstance():flush()

    elseif i == OPEN_EFFECT then --特效

        --保存/打开/关闭特效
        local msg = { showEffect = index == IS_OPEN, }
        SLFacade:dispatchCustomEvent(Hall_Events.MSG_SHOW_FISH_EFFECT, msg)
        cc.UserDefault:getInstance():setIntegerForKey("fish_effect", index)
        cc.UserDefault:getInstance():flush()

    end
end

function FishSettingView:getIsOpenValue(i)
    if i == OPEN_MUSIC then --音乐
        return GlobalUserItem.bVoiceAble and IS_OPEN or IS_CLOSE
    elseif i == OPEN_SOUND then --音效
        return GlobalUserItem.bSoundAble and IS_OPEN or IS_CLOSE
    elseif i == OPEN_SHADOW then --影子
        return cc.UserDefault:getInstance():getIntegerForKey("fish_shadow", IS_OPEN)
    elseif i == OPEN_EFFECT then --特效
        return cc.UserDefault:getInstance():getIntegerForKey("fish_effect", IS_OPEN)
    end
end

return FishSettingView

-- endregion
