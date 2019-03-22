--region LhdzRuleLayer.lua
--Date
--Auther Ace
--Des [[龙虎斗规则界面]]
--此文件由[BabeLua]插件自动生成
local module_pre = "game.yule.lhdz.src."
local LhdzRuleLayer = class("LhdzRuleLayer", cc.Layer)
--local AudioManager = cc.exports.AudioManager
--local AudioManager      = appdf.req(module_pre .. "models.AudioManager")
local Lhdz_Res = require("game.yule.lhdz.src.game.longhudazhan.scene.Lhdz_Res")

LhdzRuleLayer.instance_ = nil
function LhdzRuleLayer.create()
    LhdzRuleLayer.instance_ = LhdzRuleLayer.new():init()
    return LhdzRuleLayer.instance_
end

function LhdzRuleLayer:ctor()
    self:enableNodeEvents()

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
end

function LhdzRuleLayer:init()
    self:initVar()
    self:initCSB()
    return self
end

function LhdzRuleLayer:onEnter()
    self:show()
end

function LhdzRuleLayer:onExit()

end

function LhdzRuleLayer:initVar()
    self.m_pLayerRule = nil
    self.m_pBtnClose     = nil
end

function LhdzRuleLayer:initCSB()
    local _pUiLayer = cc.CSLoader:createNode(Lhdz_Res.CSB_OF_RULE)
    _pUiLayer:setAnchorPoint(cc.p(0.5,0.5))
    _pUiLayer:setPosition(cc.p(667, 375 + (display.size.height - 750) / 2))
    self.m_rootUI:addChild(_pUiLayer, Z_ORDER_TOP)

    self.m_pLayerRoot = _pUiLayer:getChildByName("Panel_root")
    local diffX = 145 - (1624-display.size.width)/2 
    self.m_pLayerRoot:setPositionX(diffX)
    
    self.m_pLayerRule = self.m_pLayerRoot:getChildByName("Panel_rule")

    self.m_pBtnClose = self.m_pLayerRule:getChildByName("Button_close")
    self.m_pBtnClose:addClickEventListener(function()
--        AudioManager.getInstance():playSound(Lhdz_Res.vecSound.SOUND_OF_CLOSE)
        if self.isHide then
            return
        end
        self:hide()
    end)
    -- 设置弹窗动画节点
    --self:setTargetActNode(self.m_pLayerRule)
end

-- 弹出
function LhdzRuleLayer:show()
    local pNode = self.m_pLayerRule
    if (pNode ~= nil)then
        pNode:stopAllActions()
        pNode:setScale(0.0)
        local show = cc.Show:create()
        local scaleTo = cc.ScaleTo:create(0.4, 1.0)
        local ease = cc.EaseBackOut:create(scaleTo)
        local callback = cc.CallFunc:create(function ()
            --self:callbackMove()
        end)
        local seq = cc.Sequence:create(show,ease,callback)
        pNode:runAction(seq)
    end
end

-- 弹出
function LhdzRuleLayer:hide()
    self.isHide = true

    local pNode = self.m_pLayerRule
    pNode:stopAllActions()
    pNode:setScale(1.0)
    local scaleTo = cc.ScaleTo:create(0.4, 0.0)
    local ease = cc.EaseBackIn:create(scaleTo)
    local callback = cc.CallFunc:create(function ()
        self:removeFromParent()
    end)
    local seq = cc.Sequence:create(ease, callback)
    pNode:runAction(seq)
end

return LhdzRuleLayer
--endregion
