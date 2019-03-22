--
-- Author: zhong
-- Date: 2017-05-27 10:01:40
--
-- 大厅广告(二级弹窗)
local TransitionLayer = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")
local PlazaAdLayer = class("PlazaAdLayer", TransitionLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local UIPageView = appdf.req(appdf.EXTERNAL_SRC .. "UIPageView")

local TAG_START             = 100
local enumTable = 
{
    "BTN_CLOSE",            -- 关闭按钮
    "TAG_MASK",             -- 遮罩
}
local TAG_ENUM = ExternalFun.declarEnumWithTable(TAG_START, enumTable)
function PlazaAdLayer:ctor( scene, param, level )
    PlazaAdLayer.super.ctor( self, scene, param, level )
    -- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("plaza/PlazaAdLayer.csb", self)
    self.m_rootLayer = rootLayer

    -- 按钮事件
    local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(), ref)            
        end
    end

    -- 遮罩
    local mask = csbNode:getChildByName("panel_mask")
    mask:setTag(TAG_ENUM.TAG_MASK)
    mask:addTouchEventListener( touchFunC )

    -- 底板
    local spbg = csbNode:getChildByName("sp_bg")
    self.m_spBg = spbg

    -- 关闭
    local btn = spbg:getChildByName("btn_close")
    btn:setTag(TAG_ENUM.BTN_CLOSE)
    btn:addTouchEventListener( touchFunC )
    btn:setLocalZOrder(1)
    btn:setPressedActionEnabled(true)

    -- pageview
    local tmp = spbg:getChildByName("text"):setString("网址已复制到粘贴板")
    
    -- 移除监听
    self.m_removeCallBack = nil
    -- 加载动画
    self:scaleTransitionIn(spbg)
end

function PlazaAdLayer:animationRemove()
    self:scaleTransitionOut(self.m_spBg)
end

function PlazaAdLayer:onTransitionInFinish()
end

function PlazaAdLayer:onButtonClickedEvent(tag, ref)
    if tag == TAG_ENUM.TAG_MASK or tag == TAG_ENUM.BTN_CLOSE then
        self:scaleTransitionOut(self.m_spBg)
    end
end

function PlazaAdLayer:onTransitionOutFinish()
    if type(self.m_removeCallBack) == "function" then
        self.m_removeCallBack()
    end
    self:removeFromParent()
end

return PlazaAdLayer