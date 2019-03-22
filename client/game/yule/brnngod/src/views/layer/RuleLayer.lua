-- NiuHelpView.lua
-- 牛牛帮助
-- Create by tanglei@2017-7-11

local ExternalFun       = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local module_pre = "game.yule.brnngod.src"
--local BaseFullLayer = require("app.fw.common.BaseFullLayer")
--local CommonHelper = require('app.fw.common.CommHelper')
local Define = appdf.req(module_pre .. ".models.Define")

local HandredcattleRes = appdf.req(module_pre .. ".views.layer.handClasses.HandredcattleRes")
local NiuHelpView = class("NiuHelpView", cc.exports.FixLayer)


-- 初始化UI
function NiuHelpView:ctor( ... )
    ------NiuHelpView.super.initUI(self, ...)

    local csbNode = ExternalFun.loadCSB(HandredcattleRes.CSB_GAME_RULE, self)
    self:setTargetShowHideStyle(self, self.SHOW_POPUP, self.HIDE_POPOUT)
    Define:getNodeList(self, csbNode)
    self:setVisible(false)
    --[[require('app.fw.common.PopupEffect').init(
        self,
        self.bg,
        self.resourceNode_:getChildByName('Panel_1')
    )]]--

    self.close:addClickEventListener(handler(self, self.onClose))

    -- 文本内容
    self.content:removeFromParent(false)
    self.content:setPosition(cc.p(0, 0))
    self.scroll:getInnerContainer():addChild(self.content)
    self.scroll:setInnerContainerSize(self.content:getContentSize())

    self.showCardSpr:removeFromParent(false)
    self.showCardSpr:setPosition(cc.p(0, 0))
    self.scrollCard:getInnerContainer():addChild(self.showCardSpr)
    self.scrollCard:setInnerContainerSize(self.showCardSpr:getContentSize())

    self.cardTypeBtn:addClickEventListener(function ( ... )
        -- body
        self:selectBtn(1)
    end)
    self.desBtn:addClickEventListener(function ( ... )
        -- body
        self:selectBtn(2)
    end)


    self:selectBtn(1)

    ---local value = cc.loaded_packages.NiuTigerLogic:getModel():getTableRoomType()
    ---print(value,"房間類型------------------------")
    ---if value == 2 then
    ---    self.showCardSpr:loadTexture("Niuniu/image/brnn_bangzhu/brnn_help_dibei.png")
    ---    self.content:loadTexture("Niuniu/image/brnn_bangzhu/brnn_help2_dibei.png")
    ---end

    -- 新推广 帮助界面
    if KK_SECEOND_HELP_PLAN then
        if value == 2 then
            self.content:loadTexture("Niuniu/image/brnn_bangzhu/brnn_help2_dibei_second.png")
        else
            self.content:loadTexture("Niuniu/image/brnn_bangzhu/brnn_help2_second.png")
        end
    end
end

function NiuHelpView:selectBtn( index)
    -- body
    if index == 1 then
        self.desNode:hide()
        self.desSelect:hide()
        self.desNormal:show()
        self.sprNode:show()
        self.normal:hide()
        self.select:show()

    else
        self.sprNode:hide()
        self.normal:show()
        self.select:hide()
        self.desNormal:hide()
        self.desSelect:show()
        self.desNode:show()

    end

end
-- 返回按键响应
function NiuHelpView:onBack( ... )
    self:onClose()
end

function NiuHelpView:onClose()
    self:hidePopout()
end
return NiuHelpView