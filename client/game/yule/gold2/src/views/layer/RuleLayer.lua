--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--
-- Author: zhong
-- Date: 2016-11-21 18:39:13
--
--设置界面
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")

local RuleLayer = class("RuleLayer", cc.Layer)

RuleLayer.BT_EFFECT = 1
RuleLayer.BT_MUSIC = 2
RuleLayer.BT_CLOSE = 3
RuleLayer.BT_HELP = 4
--构造
function RuleLayer:ctor( parent )
    local this = self
    self.m_parent = parent
    --注册触摸事件
    ExternalFun.registerTouchEvent(this, true)

    --加载csb资源
    self.root = ccs.GUIReader:getInstance():widgetFromJsonFile("goold2zjh/rule.json")    
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
    btn:setTag(RuleLayer.BT_CLOSE)
    btn:addTouchEventListener(function (ref, eventType)
        if eventType == ccui.TouchEventType.ended then
            ExternalFun.playClickEffect()
            this:removeFromParent()
        end
    end)


    self.root:getChildByName("Panel_3"):getChildByName("ScrollView_bx"):setVisible(false)
    self.root:getChildByName("Panel_3"):getChildByName("Panel_jj"):setVisible(true)

    --游戏简介
    self.m_btnEffect = self.root:getChildByName("Panel_3"):getChildByName("Button_jj")
    self.m_btnEffect:setTag(RuleLayer.BT_EFFECT)
    self.m_btnEffect:addTouchEventListener(cbtlistener)

    --牌型说明
    self.m_btnMusic = self.root:getChildByName("Panel_3"):getChildByName("Button_bx")
    self.m_btnMusic:setTag(RuleLayer.BT_MUSIC)
    self.m_btnMusic:addTouchEventListener(cbtlistener)
    
end


function RuleLayer:onSelectedEvent( tag, sender )
    if RuleLayer.BT_MUSIC == tag then
        self.root:getChildByName("Panel_3"):getChildByName("ScrollView_bx"):setVisible(true)
        self.root:getChildByName("Panel_3"):getChildByName("Panel_jj"):setVisible(false)
    elseif RuleLayer.BT_EFFECT == tag then
        self.root:getChildByName("Panel_3"):getChildByName("ScrollView_bx"):setVisible(false)
        self.root:getChildByName("Panel_3"):getChildByName("Panel_jj"):setVisible(true)
    end
end



return RuleLayer

--endregion
