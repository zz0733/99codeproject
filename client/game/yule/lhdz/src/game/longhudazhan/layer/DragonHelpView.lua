-- DragonHelpView.lua
-- 龙虎斗帮助
-- Create by tanglei@2017-7-11
local module_pre = "game.yule.lhdz.src."
local Lhdz_Res              = appdf.req(module_pre.."game.longhudazhan.scene.Lhdz_Res")
local DragonHelpView = class("DragonHelpView", function()
    return cc.CSLoader:createNode(Lhdz_Res.CSB_OF_RULE)
end)

-- 初始化UI
function DragonHelpView:ctor(  )
    bindCCBNode(self,self)
    self:initUI()
    self:show()
end

function DragonHelpView:initUI()
    self:setAnchorPoint(cc.p(0.5,0.5))
    self:setPosition(cc.p(display.width/2,display.height/2))
    self.close:addClickEventListener(handler(self, self.onClose))

    -- 文本内容
    self.content:removeFromParent(false)
    self.content:setPosition(cc.p(50, 0))
    self.scroll:getInnerContainer():addChild(self.content)
    self.scroll:setInnerContainerSize(self.content:getContentSize())
    self.help:setVisible(false)
    self.helpSecond:setVisible(true)
end

-- 弹出
function DragonHelpView:show()

    local pNode = self
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

-- 返回按键响应
function DragonHelpView:onClose( )
    self:removeFromParent()
end


return DragonHelpView