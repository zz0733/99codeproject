--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


local FloatPopWait = class("FloatPopWait",  ccui.Layout)  
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local ANI_JSON = "hall/effect/jazai/jazai.ExportJson"
local PNG_BOX = "hall/image/file/gui-bar-help-text-biaoti-box.png"


FloatPopWait.inst_ = nil
function FloatPopWait.getInstance()
    if FloatPopWait.inst_ == nil then
        FloatPopWait.inst_ = FloatPopWait.new()
    end
    return FloatPopWait.inst_
end

function FloatPopWait.releaseInstance()
    if FloatPopWait.inst_ then
        FloatPopWait.inst_:removeFromParent()
        FloatPopWait.inst_ = nil
    end
end

function FloatPopWait:ctor()
    self:setContentSize(display.width,display.height)
    self:setBackGroundColorType(LAYOUT_COLOR_SOLID)
    self:setBackGroundColorOpacity(128)
    self:setBackGroundColor(cc.c3b(0, 0, 0))
    self:setTouchEnabled(true)
    self:setSwallowTouches(true)


        --回调函数
    self:registerScriptHandler(function(eventType)
        if eventType == "enterTransitionFinish" then    -- 进入场景而且过渡动画结束时候触发。
            self:onEnterTransitionFinish()
        elseif eventType == "exitTransitionStart" then  -- 退出场景而且开始过渡动画时候触发。
            self:onExitTransitionStart()
        end
    end)
    

    --动画资源
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(ANI_JSON)

    self.m_pArmature = ccs.Armature:create("jazai")
	self.m_pArmature:setPosition(display.cx, display.cy)
    self.m_pArmature:setVisible(true)
    self.m_pArmature:addTo(self)
    self.m_pArmature:getAnimation():play("jz")

    --阴影条
    self.m_sp_box = cc.Sprite:create(PNG_BOX)
    self.m_sp_box:setPosition(display.cx, display.cy - 80.0)
    self.m_sp_box:setScale(0.3, 0.8)
    self.m_sp_box:setVisible(true)
    self.m_sp_box:addTo(self)

     --提示字符串
    self.m_lb_connect = cc.Label:createWithSystemFont("", "Helvetice", 24)
    self.m_lb_connect:setPosition(display.cx, display.cy - 80)
    self.m_lb_connect:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_lb_connect:setString("加载中...")
    self.m_lb_connect:setVisible(true)
    self.m_lb_connect:addTo(self)

    self.m_lb_count = cc.Label:createWithSystemFont("", "Helvetice", 24)
    self.m_lb_count:setPosition(display.cx, display.cy)
    self.m_lb_count:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_lb_count:setVisible(false)
    self.m_lb_count:addTo(self)

    self:setVisible(false)

end

function FloatPopWait:onEnterTransitionFinish()

end
function FloatPopWait:onExitTransitionStart()
    --释放动画
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(ANI_JSON)
    --删除定时器
    cc.exports.TimerProxy:removeTimer(999)
end

--显示
function FloatPopWait:show(message)
    self.m_lb_connect:setString(message or "加载中...")
    local counttick = 15
    local function countDown()
        counttick = counttick - 1
        self.m_lb_count:setString(counttick)
        if counttick < 0 then
            self:setVisible(false)
            --删除定时器
            cc.exports.TimerProxy:removeTimer(999)
        end
    end

    cc.exports.TimerProxy:removeTimer(999)
    cc.exports.TimerProxy:addTimer(999, countDown, 1, -1, false)
    self.m_lb_count:setString(counttick)
    self:setVisible(true)
    return self
end

--显示状态
function FloatPopWait:isShow()
    return self:isVisible()
end

--取消显示
function FloatPopWait:dismiss()
    self:stopAllActions()
    self:setVisible(false)
    cc.exports.TimerProxy:removeTimer(999)
end

return FloatPopWait

--endregion
