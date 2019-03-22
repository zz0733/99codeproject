--
-- Author: zhong
-- Date: 2017-06-29 17:20:09
--
-- 包含两个界面(大厅等待、断网重连)
local ClientPopWait = {}
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")
local scheduler = cc.Director:getInstance():getScheduler()

local ANI_PLIST = "hall/effect/jiazai_1/jiazai_10.plist"
local ANI_PNG = "hall/effect/jiazai_1/jiazai_10.png"
local ANI_JSON = "hall/effect/jiazai_1/jiazai_1.ExportJson"
local PNG_BOX = "hall/image/file/gui-bar-help-text-biaoti-box.png"

-- 加载等待
local PopWait = class("PopWait", ccui.Layout)
ClientPopWait.PopWait = PopWait
function PopWait:ctor()
    
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

end

function PopWait:onEnterTransitionFinish()
    --动画资源
	cc.SpriteFrameCache:getInstance():addSpriteFrames(ANI_PLIST, ANI_PNG)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(ANI_JSON)

    self.m_pArmature = ccs.Armature:create("jiazai_1")
	self.m_pArmature:setPosition(display.cx, display.cy)
    self.m_pArmature:setVisible(true)
    self.m_pArmature:addTo(self)
    self.m_pArmature:getAnimation():play("Animation1")

    --阴影条
    self.m_sp_box = cc.Sprite:create(PNG_BOX)
    self.m_sp_box:setPosition(display.cx, display.cy - 70.0)
    self.m_sp_box:setScale(0.3, 0.8)
    self.m_sp_box:setVisible(true)
    self.m_sp_box:addTo(self)

     --提示字符串
    self.m_lb_connect = cc.Label:createWithSystemFont("", "Helvetice", 24)
    self.m_lb_connect:setPosition(display.cx, display.cy - 70)
    self.m_lb_connect:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_lb_connect:setString("加载中...")
    self.m_lb_connect:setVisible(true)
    self.m_lb_connect:addTo(self)

    self.m_lb_count = cc.Label:createWithSystemFont("", "Helvetice", 24)
    self.m_lb_count:setPosition(display.cx, display.cy)
    self.m_lb_count:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_lb_count:setVisible(true)
    self.m_lb_count:addTo(self)

end
function PopWait:onExitTransitionStart()
    --释放动画
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(name)
    --释放图片
    display.removeImage(ANI_JSON)
    --删除定时器
    cc.exports.TimerProxy:removeTimer(999)
end

--显示
function PopWait:show(parent,message)
    self:addTo(parent)
    self.m_lb_connect:setString(message or "加载中...")
    local counttick = 15
    local function countDown()
        if not yl.isObject(self) then
             cc.exports.TimerProxy:removeTimer(999)
             return
        end
        counttick = counttick - 1
        self.m_lb_count:setString(counttick)
        if counttick < 0 then
            if  yl.isObject(self) then
                self:removeFromParent()
            else
                 --删除定时器
                cc.exports.TimerProxy:removeTimer(999)
            end
        end
    end

    cc.exports.TimerProxy:removeTimer(999)
    cc.exports.TimerProxy:addTimer(999, countDown, 1, -1, false)
    self.m_lb_count:setString(counttick)
    return self
end

--显示状态
function PopWait:isShow()
    return not self._dismiss 
end

--取消显示
function PopWait:dismiss()
    if self._dismiss or not yl.isObject(self) then
        return
    end
    self._dismiss  = true
    self:stopAllActions()
    self:runAction(cc.RemoveSelf:create())
end

-- 断网重连
local ReConnectPopWait = class("ReConnectPopWait", cc.Layer)
ClientPopWait.ReConnectPopWait = ReConnectPopWait
-- @param[waittime] 重连时间
-- @param[callback] 回调
function ReConnectPopWait:ctor( waittime, callback )
    self._callback = callback
    -- 注册触摸事件
    ExternalFun.registerTouchEvent(self, true)

    -- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("public/ReConnectPopWait.csb", self)

    -- 
    local spbg = csbNode:getChildByName("sp_bg")
    self.m_spBg = spbg

    -- 旋转
    local spRound = spbg:getChildByName("sp_waitround")
    local param = AnimationMgr.getAnimationParam()
    param.m_fDelay = 0.03
    -- 动画
    param.m_strName = yl.COMMON_LOADING_ANI
    param.m_bRestore = true
    local animate = AnimationMgr.getAnimate(param)
    if nil ~= animate then
        local rep = cc.RepeatForever:create(animate)
        spRound:runAction(rep)
    end

    -- 文本
    local txttip = spbg:getChildByName("txt_waittip")
    txttip:setString("您的网络出现异常,  正在重连 20")
    self.m_txtWatiTip = txttip

    self.m_nPopCount = 20
    -- 定时器
    local function countDown(dt)
        self:reConnectUpdate()
    end
    self.m_scheduler = scheduler:scheduleScriptFunc(countDown, 1.0, false)
end

function ReConnectPopWait:onExit()
    if nil ~= self.m_scheduler then
        scheduler:unscheduleScriptEntry(self.m_scheduler)
        self.m_scheduler = nil
    end
end

function ReConnectPopWait:reConnectUpdate()
    self.m_nPopCount = self.m_nPopCount - 1
    if self.m_nPopCount >= 0 then
        self.m_txtWatiTip:setString(string.format("您的网络出现异常,  正在重连 %02d", self.m_nPopCount))
    end
    if type(self._callback) == "function" then
        self._callback(self.m_nPopCount)
    end
end

return ClientPopWait