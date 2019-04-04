-- region TigerRuleLayer.lua
-- Date 2017.11.15
-- Auther JackXu.
-- Desc 游戏规则弹框 Layer.
local module_pre = "game.yule.jxlw.src.views"
local ExternalFun       = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local Tiger_Res      = require(module_pre..".scene.Tiger_Res")
local AudioManager = cc.exports.AudioManager

local TigerRuleLayer = class("TigerRuleLayer", cc.exports.FixLayer)

TigerRuleLayer.instance_ = nil
function TigerRuleLayer.create()
    TigerRuleLayer.instance_ = TigerRuleLayer.new():init()
    return TigerRuleLayer.instance_
end
function TigerRuleLayer:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
end

function TigerRuleLayer:init()

    self:setTargetShowHideStyle(self, self.SHOW_POPUP, self.HIDE_POPOUT)

    self:initVar()
    self:initCSB()
    self:initList()
    
    return self
end

function TigerRuleLayer:onEnter()
    self.super:onEnter()

    self:showWithStyle()
end 
function TigerRuleLayer:onExit()
    self.super:onExit()
end

function TigerRuleLayer:initVar()
    self.m_pLayerMask    = nil
    self.m_pBtnIntroduce = nil  -- 游戏介绍按纽
    self.m_pBtnRule      = nil  -- 游戏规则按纽
    self.m_pLvIntroduce  = nil  -- 介绍列表
    self.m_pLvRule       = nil  -- 规则列表
    self.m_pBtnClose     = nil
end

function TigerRuleLayer:initCSB()

    --csb
    local _pUiLayer = cc.CSLoader:createNode("fruitSuper/Fruit_HelpNew.csb")
    _pUiLayer:setAnchorPoint(cc.p(0.5,0.5))
    _pUiLayer:setPosition(cc.p(display.cx, 375 + (display.size.height - 750) / 2))
    self.m_rootUI:addChild(_pUiLayer, 100)

    self.m_pBtnClose =self:getChildByUIName(_pUiLayer,"button_close")
    self.m_pLvRule = self:getChildByUIName(_pUiLayer,"scrollView_scroll")

    -- 关闭按纽
    self.m_pBtnClose:addClickEventListener(function()
        ExternalFun.playSoundEffect(Tiger_Res.SOUND_OF_CLOSE)
        self:onMoveExitView()
    end)
end

function TigerRuleLayer:initList()
--[[
    -- 游戏规则
    local _RuleNode = ccui.Layout:create()
    local pRuleImg = cc.Sprite:create(Tiger_Res.PNG_OF_TXT_RULE)
    local size = pRuleImg:getContentSize()
    pRuleImg:setPosition(cc.p(size.width/2, size.height/2))
    _RuleNode:setContentSize(size)
    _RuleNode:addChild(pRuleImg)
    self.m_pLvRule:pushBackCustomItem(_RuleNode)

    self.m_pLvRule:setInertiaScrollEnabled(true)
    self.m_pLvRule:setGravity(0)
    self.m_pLvRule:setBounceEnabled(true)--回弹
    self.m_pLvRule:setDirection(ccui.ScrollViewDir.vertical)--垂直方向
    self.m_pLvRule:setScrollBarEnabled(true) -- 显示滚动条
    --]]
end

function TigerRuleLayer:getChildByUIName(root,name)
    if nil == root then
        return nil
    end
    if root:getName() == name then
        return root
    end
    local arrayRootChildren = root:getChildren()
    for i,v in ipairs(arrayRootChildren) do
        if nil~=v then
            local res = self:getChildByUIName(v,name)
            if res ~= nil then
                return res
            end
        end
    end
end

return TigerRuleLayer
