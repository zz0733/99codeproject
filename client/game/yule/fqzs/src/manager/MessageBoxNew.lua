-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
-- endregion

local MessageBoxNew = class("MessageBoxNew", FixLayer)

local MsgBoxPreBiz = require("game.yule.fqzs.src.public.MsgBoxPreBiz")
local scheduler    = require("game.yule.fqzs.src.models.scheduler")

--[Comment]
-- msg: 消息正文
-- cbFun: 点击确定后的回调
-- useTimer: 是否使用倒计时,默认true
-- time: 倒计时时间，默认10
function MessageBoxNew.create(msg, cbFun, useTimer, time)
    return MessageBoxNew:new():init(msg, cbFun, useTimer, time)
end

function MessageBoxNew:ctor()
    self:enableNodeEvents()
    self.super:ctor(self)
end

function MessageBoxNew:init(msg, okFun, useTimer, time)
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)
    
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)

    self.m_pathUI = cc.CSLoader:createNode("hall/csb/message-box.csb")
    self.m_pathUI:addTo(self.m_rootUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

--    self.m_pDialogAction = cc.CSLoader:createTimeline("hall/csb/message-box.csb")
--    self.m_pathUI:runAction(self.m_pDialogAction)
--    self.m_pDialogAction:play("DialogPop",false)

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("MessageBoxDialog")
    local diffX = 145 - (1624-display.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    self.m_pImgBg           = self.m_pNodeRoot:getChildByName("Image_bg")
    self.m_pBoxNoticeText   = self.m_pImgBg:getChildByName("LB_notice_text")
    self.m_pBoxCountDown    = self.m_pImgBg:getChildByName("LB_count_down")

    self.m_pBtnOk = self.m_pImgBg:getChildByName("BTN_sure")
    self.m_pBtnOk:addClickEventListener(handler(self,self.onSureClicked))

    self.m_pBtnNo = self.m_pImgBg:getChildByName("BTN_cancel")
    self.m_pBtnNo:addClickEventListener(handler(self,self.onCloseClicked))

    self.m_pBtnClose = self.m_pImgBg:getChildByName("BTN_close")
    self.m_pBtnClose:addClickEventListener(handler(self,self.onCloseClicked))

    self.m_okFun = nil      -- 点击确定回调
    --self.m_cancelFun = nil  -- 点击取消回调 暂不使用
    self.m_closeFun = nil   -- 点击关闭回调
    self.m_timeoutFun = nil -- 倒计时结束回调
    self.m_autoClose = not useTimer -- 自动关闭

    self.m_time = time and time or 10
    if "function" == type(okFun) then self.m_okFun = okFun end
    if "table" == type(msg) then msg = msg.packet end

    self:initView(msg)

    return self
end 

function MessageBoxNew:initView(msg)
--资源分离，不再使用公共定义
--    local str = nil
--    local bizhandle = MsgBoxPreBiz.PreStringBiz[msg]
--    if bizhandle then -- 首先查询有无预定义处理业务
--        if bizhandle.ViewStr then
--            str = bizhandle.ViewStr()
--        end
--        if bizhandle.CB_Ok then
--            self.m_okFun = bizhandle.CB_Ok
--        end
--        if bizhandle.CB_Close then
--            self.m_closeFun = bizhandle.CB_Close
--        end
--        if bizhandle.CB_Timeout then
--            self.m_timeoutFun = bizhandle.CB_Timeout
--        end
--        if bizhandle.NoAutoClose then
--            self.m_autoClose = false
--        end
--        if bizhandle.NoClean then
--            self.m_bClean = false
--        end
--    else
--        str = LuaUtils.getLocalString(msg) -- 获取本地化配置
--    end

--    if nil == str then str = msg end

    if self.m_autoClose then -- 需要倒计时
        self.m_pBoxCountDown:setVisible(true)
        self.handle = scheduler.scheduleGlobal(handler(self, self.update), 1)
    else
        self.m_pBoxCountDown:setVisible(false)
    end

    self.m_pBoxNoticeText:setString(msg)
end

function MessageBoxNew:onEnter()
    self.super:onEnter()
    self:showWithStyle()
end

function MessageBoxNew:onExit()
    self.super:onExit()
    if self.handle then
        scheduler.unscheduleGlobal(self.handle)
        self.handle = nil
    end
end

function MessageBoxNew:onSureClicked()
--    AudioManager.getInstance():playSound("public/sound/sound-button.mp3")
    self:onMoveExitView()
    if self.m_okFun then self.m_okFun() end
end

function MessageBoxNew:onCloseClicked()
--    AudioManager.getInstance():playSound("public/sound/sound-close.mp3")
    self:onMoveExitView()
    if self.m_closeFun then self.m_closeFun() end
end

function MessageBoxNew:update(value)
    if not self.m_pBoxCountDown or not self.m_pBoxCountDown:isVisible() then return end

    if self.m_time <= 0 then
        self:onMoveExitView()
        if self.m_timeoutFun then
            self.m_timeoutFun()
        elseif self.m_closeFun then
            self.m_closeFun()
        end
        return
    else
        -- 使用自减倒计时方式，可能因为外界干扰不准确？
        -- 使用os.time()时间差方式，可能因为用户修改系统时间导致未知业务问题？
        self.m_time = self.m_time - 1
        if self.m_pBoxCountDown then
            self.m_pBoxCountDown:setString(string.format(LuaUtils.getLocalString("STRING_029"), self.m_time))
        end
    end
end

--设置确定按钮点击回调
function MessageBoxNew:setOkCallBack(cbFun)
    if "function" == type(cbFun) then
        self.m_okFun = cbFun
    else
        print("MessageBoxNew:setOkCallBack need function parm...")
    end
end

-- 暂时不使用cancel
--function MessageBoxNew:setCancelCallBack(cbFun)
--    if "function" == type(okFun) then self.m_cancelFun = cbFun end
--end

--设置关闭按钮点击回调
function MessageBoxNew:setCloseCallBack(cbFun)
    if "function" == type(cbFun) then
        self.m_closeFun = cbFun
    else
        print("MessageBoxNew:setCloseCallBack need function parm...")
    end
end

--设置倒计时结束回调，若不设置，则默认使用关闭按钮回调
function MessageBoxNew:setTimeOutCallBack(cbFun)
    if "function" == type(cbFun) then
        self.m_timeoutFun = cbFun
    else
        print("MessageBoxNew:setTimeOutCallBack need function parm...")
    end
end

--重载fixlayer的onMoveExitView
--function MessageBoxNew:onMoveExitView()
--    self.m_pDialogAction:play("DialogHide",false)
--    cc.Director:getInstance():getEventDispatcher():setEnabled(false)
--    local eventFrameCall = function(frame)  
--        self.m_pDialogAction:clearFrameEventCallFunc()
--        self.m_pDialogAction = nil
--        self:removeFromParent()
--    end
--    self.m_pDialogAction:setLastFrameCallFunc(eventFrameCall)
--end

return MessageBoxNew