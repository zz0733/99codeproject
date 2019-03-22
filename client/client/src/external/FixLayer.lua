--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local FixLayer = class("FixLayer", cc.Layer)

-- 界面淡入风格
FixLayer.SHOW_NO_STYLE = 0
FixLayer.SHOW_POPUP = 1                     -- 弹出
FixLayer.SHOW_MOVE_LEFT = 2                 -- 向左移入
FixLayer.SHOW_MOVE_RIGHT = 3                -- 向右移入
FixLayer.SHOW_MOVE_UP = 4                   -- 向上移入
FixLayer.SHOW_MOVE_DOWN = 5                 -- 向下移入

FixLayer.SHOW_DLG_NORMAL = 6               -- 对话框弹出
FixLayer.SHOW_DLG_BIG = 7                  -- 弹出

-- 界面淡出风格
FixLayer.HIDE_NO_STYLE = 0
FixLayer.HIDE_POPOUT = 1                    -- 弹出
FixLayer.HIDE_MOVE_RIGHT = 2                -- 向右移出
FixLayer.HIDE_MOVE_LEFT = 3                 -- 向左移出
FixLayer.HIDE_MOVE_DOWN = 4                 -- 向下移出
FixLayer.HIDE_MOVE_UP = 5                   -- 向上移出

FixLayer.HIDE_DLG_NORMAL = 6               -- 对话框弹出
FixLayer.HIDE_DLG_BIG = 7                  -- 弹出


-- 从零点开始，顺时针设置方向
FixLayer.DIRECTION_UP = 0
FixLayer.DIRECTION_RIGHT = 1
FixLayer.DIRECTION_DOWN = 2
FixLayer.DIRECTION_LEFT = 3
FixLayer.NUM_DIRECTIONS = 4


FixLayer.showStyle = 0
FixLayer.hideStyle = 0

FixLayer.m_bMoving = false
FixLayer.m_bHiding = false
FixLayer.m_fHideTime = 0.4

FixLayer.UI_ANIM_DURATION = 0.4     -- 界面动画时间
FixLayer.BG_VEIL_TAG = 2586         -- 背景遮罩tag
FixLayer.BG_ANIMATION_TAG = 2587    -- 动画节点

function FixLayer:ctor(child)
    
    self.child = child
    self.showStyle = self.SHOW_NO_STYLE
    self.hideStyle = self.HIDE_NO_STYLE
    self.m_bMoving = false
    self.m_bHiding = false
    
    self.m_fHideTime = self.UI_ANIM_DURATION
    self.m_fAlphaVal = 150
end

function FixLayer:init()
end

function FixLayer:onEnter()
    -- 初始化触摸事件
    self.m_pEventListener = cc.EventListenerTouchOneByOne:create()
    self.m_pEventListener:setSwallowTouches(true)
    self.m_pEventListener:registerScriptHandler(function(touch, event)
        return self:onTouchBegan(touch, event)
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    self.m_pEventListener:registerScriptHandler(function(touch, event)
        return self:onTouchMoved(touch, event)
    end, cc.Handler.EVENT_TOUCH_MOVED)

    self.m_pEventListener:registerScriptHandler(function(touch, event)
        return self:onTouchEnded(touch, event)
    end, cc.Handler.EVENT_TOUCH_ENDED)

    self.m_pEventListener:registerScriptHandler(function(touch, event)
        self:onTouchEnded(touch, event)
        return true
    end, cc.Handler.EVENT_TOUCH_CANCELLED)

    self.child:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_pEventListener, self.child)
end

function FixLayer:onTouchBegan(touch, event)
    if self.m_bMoving or self.m_bHiding then
        return false
    end
    return true
end

function FixLayer:onTouchMoved(touch, event)
    
end

function FixLayer:onTouchEnded(touch, event)
    
end

function FixLayer:onExit()
    if self.m_pBgLayer then
        self.m_pBgLayer:removeFromParent()
    end
    if not cc.Director:getInstance():getEventDispatcher():isEnabled() then
        cc.Director:getInstance():getEventDispatcher():setEnabled(true)
    end
end

function FixLayer:onMoveExitView(style)
    
    self:hideWithStyle(style)
end

-- 设置目标风格
function FixLayer:setTargetShowHideStyle(tgt, show, hide)
    self.showStyle = show
    self.hideStyle = hide
end

-- 设置遮罩透明度
function FixLayer:setVeilAlpha(val)
    if val then
        self.m_fAlphaVal = val
    end
end

function FixLayer:showWithStyle(style)

    local style = style or self.showStyle

    if (self.m_bMoving)then
        return
    end

    --背景遮罩
    self.m_pBgLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 0), 1624, 750)
    self:getParent():addChild(self.m_pBgLayer, self:getLocalZOrder()-1)
    
    self.m_bMoving = true
    self:setVisible(false)
    
    if (style == self.SHOW_NO_STYLE)then
        self:callbackMove()
        return
    end
    if style == self.SHOW_POPUP then
        self:showPopup()
    elseif style == self.SHOW_MOVE_LEFT then
        self:showMove(self.DIRECTION_LEFT)
    elseif style == self.SHOW_MOVE_UP then
        self:showMove(self.DIRECTION_UP)
    elseif style == self.SHOW_MOVE_RIGHT then
        self:showMove(self.DIRECTION_RIGHT)
    elseif style == self.SHOW_MOVE_DOWN then
        self:showMove(self.DIRECTION_DOWN)
    elseif style == self.SHOW_DLG_NORMAL then
        self:showDlgNormal()
    elseif style == self.SHOW_DLG_BIG then
        self:showDlgBig()
    end

    cc.Director:getInstance():getEventDispatcher():setEnabled(false)
end

function FixLayer:hideWithStyle(style)

    local style = style or self.hideStyle

    if (self.m_bHiding)then
        return
    end

    self.m_bHiding = true
    
    if (style == self.HIDE_NO_STYLE)then
    
        self:callbackRemoveLayer()
        return
    end
    
    if style == self.HIDE_POPOUT then
        self:hidePopout()
    elseif style == self.HIDE_MOVE_RIGHT then
        self:hideMove(self.DIRECTION_RIGHT)
    elseif style == self.HIDE_MOVE_UP then
        self:hideMove(self.DIRECTION_UP)
    elseif style == self.HIDE_MOVE_LEFT then
        self:hideMove(self.DIRECTION_LEFT)
    elseif style == self.HIDE_MOVE_DOWN then
        self:hideMove(self.DIRECTION_DOWN)
    elseif style == self.HIDE_DLG_NORMAL then
        self:hideDlgNormal()
    elseif style == self.HIDE_DLG_BIG then
        self:hideDlgBig()
    end
end

-- 弹出
function FixLayer:showPopup()

    local pNode = self:getChildByTag(self.BG_ANIMATION_TAG)
    if (pNode ~= nullptr)then
        pNode:stopAllActions()
        pNode:setScale(0.0)
        local show = cc.Show:create()
        local scaleTo = cc.ScaleTo:create(self.UI_ANIM_DURATION, 1.0)
        local ease = cc.EaseBackOut:create(scaleTo)
        local callback = cc.CallFunc:create(function ()
            self:callbackMove()
        end)
        local seq = cc.Sequence:create(show,ease,callback)
        self.pNode:runAction(seq);
    else
        self:stopAllActions()
        self:setScale(0.0)
        local show = cc.Show:create()
        local scaleTo = cc.ScaleTo:create(self.UI_ANIM_DURATION, 1.0)
        local ease = cc.EaseBackOut:create(scaleTo)
        local callback = cc.CallFunc:create(function ()
            self:callbackMove()
        end)
        local seq = cc.Sequence:create(show,ease,callback)
        self:runAction(seq)
    end
end

-- 弹出
function FixLayer:showDlgNormal()

    local pNode = self:getChildByTag(self.BG_ANIMATION_TAG)
    if (pNode ~= nullptr)then
        pNode:stopAllActions()
        pNode:setScale(0.9)
        pNode:setCascadeOpacityEnabled(true)
        pNode:setOpacity(255 * 0.3)
        pNode:setVisible(true)
        local scaleTo = cc.Spawn:create(cc.ScaleTo:create(8/60, 1.05), cc.FadeTo:create(8/60, 255))
        local scaleTo2 = cc.ScaleTo:create(4/60, 1)
        local callback = cc.CallFunc:create(function ()
            self:callbackMove()
        end)
        local seq = cc.Sequence:create(scaleTo, scaleTo2, callback)
        self:runAction(seq)
    else
        self:stopAllActions()
        self:setVisible(true)
        self:setScale(0.9)
        self:setCascadeOpacityEnabled(true)
        self:setOpacity(255 * 0.3)
        local scaleTo = cc.Spawn:create(cc.ScaleTo:create(8/60, 1.03), cc.FadeTo:create(8/60, 255))
        local scaleTo2 = cc.ScaleTo:create(4/60, 1)
        local callback = cc.CallFunc:create(function ()
            self:callbackMove()
        end)
        local seq = cc.Sequence:create(scaleTo,scaleTo2,callback)
        self:runAction(seq)
    end

    self.m_pBgLayer:runAction(cc.FadeTo:create(12/60, self.m_fAlphaVal))
end

-- 隐藏
function FixLayer:hideDlgNormal()
    self:stopAllActions()
    self:setScale(1.0)
    local scaleTo = cc.Spawn:create(cc.ScaleTo:create(10/60, 0.3), cc.FadeTo:create(10/60, 255*0.3))
    local callback = cc.CallFunc:create(function ()
        self:callbackRemoveLayer()
    end)
    local seq = cc.Sequence:create(scaleTo, callback)
    self:runAction(seq)

    self.m_pBgLayer:runAction(cc.FadeTo:create(10/60, 0))
end

-- 弹出
function FixLayer:showDlgBig()

    local pNode = self:getChildByTag(self.BG_ANIMATION_TAG)
    if (pNode ~= nullptr)then
        pNode:stopAllActions()
        pNode:setScale(0.9)
        pNode:setCascadeOpacityEnabled(true)
        pNode:setOpacity(255 * 0.3)
        pNode:setVisible(true)
        local scaleTo = cc.Spawn:create(cc.ScaleTo:create(10/60, 1.05), cc.FadeTo:create(10/60, 255))
        local scaleTo2 = cc.ScaleTo:create(4/60, 1)
        local callback = cc.CallFunc:create(function ()
            self:callbackMove()
        end)
        local seq = cc.Sequence:create(scaleTo, scaleTo2, callback)
        self:runAction(seq)
    else
        self:stopAllActions()
        self:setVisible(true)
        self:setScale(0.9)
        self:setCascadeOpacityEnabled(true)
        self:setOpacity(255 * 0.3)
        local scaleTo = cc.Spawn:create(cc.ScaleTo:create(8/60, 1.03), cc.FadeTo:create(8/60, 255))
        local scaleTo2 = cc.ScaleTo:create(4/60, 1)
        local callback = cc.CallFunc:create(function ()
            self:callbackMove()
        end)
        local seq = cc.Sequence:create(scaleTo,scaleTo2,callback)
        self:runAction(seq)
    end
    self.m_pBgLayer:runAction(cc.FadeTo:create(12/60, self.m_fAlphaVal))
end

-- 隐藏
function FixLayer:hideDlgBig()
    self:stopAllActions()
    self:setScale(1.0)
    local scaleTo = cc.Spawn:create(cc.ScaleTo:create(10/60, 0.3), cc.FadeTo:create(10/60, 255*0.3))
    local callback = cc.CallFunc:create(function ()
        self:callbackRemoveLayer()
    end)
    local seq = cc.Sequence:create(scaleTo, callback)
    self:runAction(seq)

    self.m_pBgLayer:runAction(cc.FadeTo:create(10/60, 0))
end

-- 弹出
function FixLayer:hidePopout()
    self:stopAllActions()
    self:setScale(1.0)
    local scaleTo = cc.ScaleTo:create(self.UI_ANIM_DURATION, 0.0)
    local ease = cc.EaseBackIn:create(scaleTo);
    local callback = cc.CallFunc:create(function ()
        self:callbackRemoveLayer()
    end)
    local seq = cc.Sequence:create(ease, callback)
    self:runAction(seq)
end

-- 移动
function FixLayer:showMove(dir)

    self:stopAllActions()
    local offset =  self:GNOffsetByDirection(dir)
    offset = cc.pMul(offset, 200.0)

    if (dir == self.DIRECTION_LEFT or dir == self.DIRECTION_RIGHT)then
        offset = cc.pMul(offset, 1.5)
    end
    local move = cc.MoveBy:create(self.UI_ANIM_DURATION*2, offset)
    local ease = (dir == self.DIRECTION_UP or dir == self.DIRECTION_DOWN)
        and cc.EaseElasticOut:create(move)
        or  cc.EaseExponentialOut:create(move)
    local callback = cc.CallFunc:create(function()
        self:callbackMove()
    end)
    local show = cc.Show:create()
    local seq = cc.Sequence:create(show, ease, callback)
    
    offset = cc.pMul(offset, -1)
    local posNow = cc.p(self:getPosition())
    local posStart = cc.pAdd(posNow, offset)
    
    self:setPosition(posStart)
    self:runAction(seq)
end

-- 移动
function FixLayer:hideMove(dir)

    self:stopAllActions();
    local offset =  self:GNOffsetByDirection(dir)
    if (dir == self.DIRECTION_LEFT or dir == self.DIRECTION_RIGHT)then
        offset = cc.pMul(offset, display.width)
    else
        offset = cc.pMul(offset, display.height)
    end
    local move = cc.MoveBy:create(self.m_fHideTime , offset)
    local callback = cc.CallFunc:create(function ()
        self:callbackRemoveLayer()
    end)
    local seq = cc.Sequence:create(cc.EaseExponentialOut:create(move), callback)
    
    self:runAction(seq)
end

-- 方向 -> 偏移量
function FixLayer:GNOffsetByDirection(dir)

    if self.DIRECTION_DOWN == dir then return cc.p(0.0, -1.0)
    elseif self.DIRECTION_RIGHT == dir then return cc.p(1.0, 0.0)
    elseif self.DIRECTION_UP == dir then return cc.p(0.0, 1.0)
    elseif self.DIRECTION_LEFT == dir then return cc.p(-1.0, 0.0)
    end
    return cc.p(0.0, -1.0)
end

function FixLayer:callbackMove()

    if not cc.Director:getInstance():getEventDispatcher():isEnabled() then
        cc.Director:getInstance():getEventDispatcher():setEnabled(true)
    end
    self.m_bMoving = false
end

function FixLayer:callbackRemoveLayer()

    self.m_bMoving = false
    self.m_bHiding = false

    if self.m_pBgLayer then
        self.m_pBgLayer:removeFromParent()
    end

    if self.m_callback and type(self.m_callback) == "function" then
        self.m_callback()
    end
     
    if not cc.Director:getInstance():getEventDispatcher():isEnabled() then
        cc.Director:getInstance():getEventDispatcher():setEnabled(true)
    end
    self:removeFromParent()
end

function FixLayer:setCallBack(call)
    self.m_callback = call
end

cc.exports.FixLayer = FixLayer
return FixLayer