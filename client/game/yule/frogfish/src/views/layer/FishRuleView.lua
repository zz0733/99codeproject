-- region *.lua
-- Date     2017.04.07
-- zhiyuan
-- 此文件由[BabeLua]插件自动生成
local module_pre = "game.yule.frogfish.src"
local FishRes = require(module_pre..".views.scene.FishSceneRes")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local FishRuleView = class("FishRuleView", cc.Layer)

local RULE_FISH = 1
local RULE_BOSS = 2
local RULE_BOMB = 3

FishRuleView.instance_ = nil
function FishRuleView.create()
    FishRuleView.instance_ = FishRuleView.new()
    return FishRuleView.instance_
end

function FishRuleView:ctor()
    self:enableNodeEvents()
    self:init()
end

function FishRuleView:onEnter()
    onOpenLayer(self.m_pNodeRule, self.m_pNodeShadow, self)
end

function FishRuleView:onExit()
end

function FishRuleView:init()

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)

    --csb
    self.m_pathUI = cc.CSLoader:createNode("game/frogfish/csb/gui-fish-rule.csb")
    self.m_pathUI:setPositionX((display.width - 1334) / 2)
    self.m_pathUI:setPositionY((display.height - 750) / 2)
    self.m_pathUI:addTo(self.m_rootUI)

    self.m_pNodeRule = self.m_pathUI:getChildByName("NodeRule")
    self.m_pNodeShadow = self.m_pathUI:getChildByName("NodeShadow")
    
    --关闭
    self.m_pBtnClose = self.m_pNodeRule:getChildByName("ButtonClose")

    --按钮
    local m_pNodeButton = self.m_pNodeRule:getChildByName("m_pNodeButton")
    self.m_pBtnFish = m_pNodeButton:getChildByName("m_pBtnFish")
    self.m_pBtnBoss = m_pNodeButton:getChildByName("m_pBtnBoss")
    self.m_pBtnBomb = m_pNodeButton:getChildByName("m_pBtnBomb")

    --规则
    local m_pNodeRule = self.m_pNodeRule:getChildByName("m_pNodeTable")
    self.m_pViewFish = m_pNodeRule:getChildByName("m_pViewFish")
    self.m_pViewBoss = m_pNodeRule:getChildByName("m_pViewBoss")
    self.m_pViewBomb = m_pNodeRule:getChildByName("m_pViewBomb")

    --绑定按钮
    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseClicked))
    self.m_pBtnFish:setTag(RULE_FISH)
    self.m_pBtnFish:addClickEventListener(handler(self, self.onTypeClicked))
    self.m_pBtnBoss:setTag(RULE_BOSS)
    self.m_pBtnBoss:addClickEventListener(handler(self, self.onTypeClicked))
    self.m_pBtnBomb:setTag(RULE_BOMB)
    self.m_pBtnBomb:addClickEventListener(handler(self, self.onTypeClicked))

    self.m_pBtnRule = { self.m_pBtnFish, self.m_pBtnBoss, self.m_pBtnBomb, }
    self.m_pViewRule = { self.m_pViewFish, self.m_pViewBoss, self.m_pViewBomb, }

    self:onUpdateType(RULE_FISH)
end

function FishRuleView:onCloseClicked()
    ExternalFun.playGameEffect(FishRes.SOUND_OF_CLOSE)

    onCloseLayer(self.m_pNodeRule, self.m_pNodeShadow, self)
end

function FishRuleView:onTypeClicked(pSender)
    ExternalFun.playGameEffect(FishRes.SOUND_OF_BUTTON)

    local tag = pSender:getTag()
    self:onUpdateType(tag)
end

function FishRuleView:onUpdateType(index)
    for i = RULE_FISH, RULE_BOMB do
        if index == i then
            self.m_pBtnRule[i]:setEnabled(false)
            self.m_pViewRule[i]:setVisible(true)
        else
            self.m_pBtnRule[i]:setEnabled(true)
            self.m_pViewRule[i]:setVisible(false)
        end
    end
end

return FishRuleView

-- endregion
