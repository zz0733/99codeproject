-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
-- endregion

local LhdzMessageBox = class("LhdzMessageBox", FixLayer)

local MsgBoxPreBiz = require("game.yule.lhdz.src.models.MsgBoxPreBiz")
local scheduler    = require("game.yule.lhdz.src.models.scheduler")
local Lhdz_Res = require("game.yule.lhdz.src.game.longhudazhan.scene.Lhdz_Res")

--[Comment]
-- msg: 消息正文
-- cbFun: 点击确定后的回调
-- useTimer: 是否使用倒计时,默认true
-- time: 倒计时时间，默认10
function LhdzMessageBox.create(msg, cbFun, useTimer, time)
    return LhdzMessageBox:new():init(msg, cbFun, useTimer, time)
end

function LhdzMessageBox:ctor()
    self:enableNodeEvents()
end

function LhdzMessageBox:init(msg, okFun, useTimer, time)
   
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)

    self.m_pathUI = cc.CSLoader:createNode(Lhdz_Res.CSB_OF_MESSAGEBOX)
    self.m_pathUI:addTo(self.m_rootUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("MessageBoxDialog")
    local diffX = 145 - (1624-display.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    self.m_pImgBg           = self.m_pNodeRoot:getChildByName("Image_bg")
    self.m_pCountDown       = self.m_pImgBg:getChildByName("Sprite_count")
    self.m_pBoxCountDown    = self.m_pCountDown:getChildByName("LB_count_down")

    self.m_pBtnOk = self.m_pImgBg:getChildByName("BTN_sure")
    self.m_pBtnOk:addClickEventListener(handler(self,self.onSureClicked))

    self.m_pBtnClose = self.m_pImgBg:getChildByName("BTN_close")
    self.m_pBtnClose:addClickEventListener(handler(self,self.onCloseClicked))

    self.m_okFun = nil      -- 点击确定回调
    self.m_closeFun = nil   -- 点击关闭回调
    self.m_timeoutFun = nil -- 倒计时结束回调
    self.m_autoClose = useTimer and true or false -- 自动关闭

    self.m_time = time and time or 10
    if "function" == type(okFun) then self.m_okFun = okFun end
    if "table" == type(msg) then msg = msg.packet end

    self:initView(msg)

    self:showPop()

    return self
end 

function LhdzMessageBox:initView(msg)
    if self.m_autoClose then -- 需要倒计时
        self.m_pCountDown:setVisible(true)
        self.handle = scheduler.scheduleGlobal(handler(self, self.update), 1)
    else
        self.m_pCountDown:setVisible(false)
    end

    local pos = cc.p(505, 356)
    local sp = cc.Sprite:createWithSpriteFrameName(msg)
    sp:setPosition(pos)
    sp:addTo(self.m_pImgBg)
end

function LhdzMessageBox:onEnter()
end

function LhdzMessageBox:onExit()
    if self.handle then
        scheduler.unscheduleGlobal(self.handle)
        self.handle = nil
    end
end

function LhdzMessageBox:onSureClicked()
--    AudioManager.getInstance():playSound(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
    self:onMoveExitView()
    if self.m_okFun then
        self.m_okFun()
    end
end

function LhdzMessageBox:onCloseClicked()
--    AudioManager.getInstance():playSound(Lhdz_Res.vecSound.SOUND_OF_CLOSE)
    self:onMoveExitView()
    if self.m_closeFun then
        self.m_closeFun()
    end
end

function LhdzMessageBox:update(value)
    if not self.m_pCountDown or not self.m_pCountDown:isVisible() then return end

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
        if self.m_pCountDown and  self.m_pBoxCountDown then
            self.m_pBoxCountDown:setString(string.format(LuaUtils.getLocalString("STRING_029"), self.m_time))
        end
    end
end

--设置确定按钮点击回调
function LhdzMessageBox:setOkCallBack(cbFun)
    if "function" == type(cbFun) then
        self.m_okFun = cbFun
    else
        print("LhdzMessageBox:setOkCallBack need function parm...")
    end
end

--设置关闭按钮点击回调
function LhdzMessageBox:setCloseCallBack(cbFun)
    if "function" == type(cbFun) then
        self.m_closeFun = cbFun
    else
        print("LhdzMessageBox:setCloseCallBack need function parm...")
    end
end

--设置倒计时结束回调，若不设置，则默认使用关闭按钮回调
function LhdzMessageBox:setTimeOutCallBack(cbFun)
    if "function" == type(cbFun) then
        self.m_timeoutFun = cbFun
    else
        print("LhdzMessageBox:setTimeOutCallBack need function parm...")
    end
end

function LhdzMessageBox:onMoveExitView()
    self.m_pImgBg:setScale(1.0)
    local scaleTo = cc.ScaleTo:create(0.2, 0)
    local callBack = cc.CallFunc:create(function()
            if not cc.Director:getInstance():getEventDispatcher():isEnabled() then
                cc.Director:getInstance():getEventDispatcher():setEnabled(true)
            end
            self:setVisible(false)
        end)

    local seq = cc.Sequence:create(scaleTo, callBack)
    self.m_pImgBg:runAction(seq)
end

function LhdzMessageBox:showPop()
    self.m_pImgBg:setScale(0.0)
    local show = cc.Show:create()
    local scaleTo = cc.ScaleTo:create(0.4, 1.0)
    local ease = cc.EaseBackOut:create(scaleTo)
    local seq = cc.Sequence:create(show,ease)
    self.m_pImgBg:runAction(seq)
end

return LhdzMessageBox