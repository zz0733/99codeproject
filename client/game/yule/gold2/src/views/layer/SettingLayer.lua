--
-- Author: zhong
-- Date: 2016-11-21 18:39:13
--
--设置界面
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")

local SettingLayer = class("SettingLayer", cc.Layer)

SettingLayer.BT_EFFECT = 1
SettingLayer.BT_MUSIC = 2
SettingLayer.BT_CLOSE = 3
SettingLayer.BT_HELP = 4
--构造
function SettingLayer:ctor( parent )
    local this = self
    self.m_parent = parent
    --注册触摸事件
    ExternalFun.registerTouchEvent(this, true)

    --加载csb资源
    self.root = ccs.GUIReader:getInstance():widgetFromJsonFile("goold2zjh/seting.json")    
    if not self.root then
        return false
    end
    self:addChild(self.root)


    local cbtlistener = function (sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            this:onSelectedEvent(sender:getTag(),sender,eventType)
        end
    end


    --关闭按钮
    local btn = self.root:getChildByName("Button_gb")
    btn:setTag(SettingLayer.BT_CLOSE)
    btn:addTouchEventListener(function (ref, eventType)
        if eventType == ccui.TouchEventType.ended then
            ExternalFun.playClickEffect()
            this:removeFromParent()
        end
    end)

    self.openEffect = true
    self.openMusic = true
    self.root:getChildByName("Panel_5"):getChildByName("Button_yy"):setPosition(cc.p(385,208))
    self.root:getChildByName("Panel_5"):getChildByName("Image_yygb"):setVisible(false)
    self.root:getChildByName("Panel_5"):getChildByName("Image_yykq"):setVisible(true)
    self.root:getChildByName("Panel_5"):getChildByName("Button_yx"):setPosition(cc.p(385,106))
    self.root:getChildByName("Panel_5"):getChildByName("Image_yxgb"):setVisible(false)
    self.root:getChildByName("Panel_5"):getChildByName("Image_yxkq"):setVisible(true)
    --音效
    self.m_btnEffect = self.root:getChildByName("Panel_5"):getChildByName("Button_yx")
    self.m_btnEffect:setTag(SettingLayer.BT_EFFECT)
    self.m_btnEffect:addTouchEventListener(cbtlistener)

    --音乐
    self.m_btnMusic = self.root:getChildByName("Panel_5"):getChildByName("Button_yy")
    self.m_btnMusic:setTag(SettingLayer.BT_MUSIC)
    self.m_btnMusic:addTouchEventListener(cbtlistener)

    if (GlobalUserItem.bVoiceAble)then -- 音乐开着
        self.m_btnMusic:setPosition(cc.p(385,208))
        GlobalUserItem.setVoiceAble(true)
        self.root:getChildByName("Panel_5"):getChildByName("Image_yygb"):setVisible(false)
        self.root:getChildByName("Panel_5"):getChildByName("Image_yykq"):setVisible(true)
    else
        self.m_btnMusic:setPosition(cc.p(219,208))
        GlobalUserItem.setVoiceAble(false)
        self.root:getChildByName("Panel_5"):getChildByName("Image_yygb"):setVisible(true)
        self.root:getChildByName("Panel_5"):getChildByName("Image_yykq"):setVisible(false)
    end
    if (GlobalUserItem.bSoundAble)then -- 音效开着
        self.m_btnEffect:setPosition(cc.p(385,106))
        GlobalUserItem.setSoundAble(true)
        self.root:getChildByName("Panel_5"):getChildByName("Image_yxgb"):setVisible(false)
        self.root:getChildByName("Panel_5"):getChildByName("Image_yxkq"):setVisible(true)
    else
        self.m_btnEffect:setPosition(cc.p(219,106))
        GlobalUserItem.setSoundAble(false)
        self.root:getChildByName("Panel_5"):getChildByName("Image_yxgb"):setVisible(true)
        self.root:getChildByName("Panel_5"):getChildByName("Image_yxkq"):setVisible(false)    
    end
end


function SettingLayer:onSelectedEvent( tag, sender )
    if SettingLayer.BT_MUSIC == tag then
        if self.openMusic == true then
            self.openMusic = false
            GlobalUserItem.setVoiceAble(false)
            sender:setPosition(cc.p(219,208))
            self.root:getChildByName("Panel_5"):getChildByName("Image_yygb"):setVisible(true)
            self.root:getChildByName("Panel_5"):getChildByName("Image_yykq"):setVisible(false)
        else
            self.openMusic = true
            GlobalUserItem.setVoiceAble(true)
            sender:setPosition(cc.p(385,208))
            self.root:getChildByName("Panel_5"):getChildByName("Image_yygb"):setVisible(false)
            self.root:getChildByName("Panel_5"):getChildByName("Image_yykq"):setVisible(true)
        end
    elseif SettingLayer.BT_EFFECT == tag then
        if self.openEffect == true then
            self.openEffect = false
            GlobalUserItem.setSoundAble(false)
            sender:setPosition(cc.p(219,106))
            self.root:getChildByName("Panel_5"):getChildByName("Image_yxgb"):setVisible(true)
            self.root:getChildByName("Panel_5"):getChildByName("Image_yxkq"):setVisible(false)
        else
            self.openEffect = true
            GlobalUserItem.setSoundAble(true)
            sender:setPosition(cc.p(385,106))
            self.root:getChildByName("Panel_5"):getChildByName("Image_yxgb"):setVisible(false)
            self.root:getChildByName("Panel_5"):getChildByName("Image_yxkq"):setVisible(true)
        end
    end
end



return SettingLayer