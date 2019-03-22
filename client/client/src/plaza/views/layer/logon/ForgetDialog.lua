--region *.lua
--Date
--
--endregion
-- Desc: 忘记密码
-- modified by JackyXu on 2017.05.16.

local ForgetDialog = class("ForgetDialog",FixLayer)
local FloatMessage = cc.exports.FloatMessage
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .."ExternalFun")

ForgetDialog.instance_ = nil
function ForgetDialog.create(nType)
    ForgetDialog.instance_ = ForgetDialog.new():init(nType)
    return ForgetDialog.instance_
end

function ForgetDialog:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    self.m_nCountDown = -1
    self.typeDialog = 2 --默认银行功能

    self.m_nEditBoxTouchCount = 0 -- 输入框点击次数
end

function ForgetDialog:init(nType)
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)
    self:setVeilAlpha(0)

    self.m_nVerifyType = nType --1登录/2银行
    --init csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/FindPasswordDialog.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("FindPassWordDialog")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    self.m_pImgBg        = self.m_pNodeRoot:getChildByName("Image_bg")
    self.m_pBtnGetNumber = self.m_pImgBg:getChildByName("BTN_get_number")
    self.m_pLbCountDown  = self.m_pImgBg:getChildByName("TXT_countDown")
    self.m_pBtnClose     = self.m_pImgBg:getChildByName("Button_close")
    self.m_pBtnConfirm   = self.m_pImgBg:getChildByName("Button_confirm")

    self.m_pBtnGetNumber:addClickEventListener(handler(self,self.onClickedGetNumber))
    self.m_pBtnClose:addClickEventListener(handler(self,self.onCloseClicked))
    self.m_pBtnConfirm:addClickEventListener(handler(self,self.onConfirmClicked))

    self.m_pLbCountDown:setVisible(false)

    self.m_pImgInput = {}
    for i = 1,4 do
        local nodeName = string.format("image_input%d",i)
        self.m_pImgInput[i] = self.m_pImgBg:getChildByName(nodeName) --tolua.cast(self[nodeName], "cc.Node")
    end

    return self
end

function ForgetDialog:onEnter()
    self.super:onEnter()
    self:showWithStyle()

    self.m_verifyBankPwd = SLFacade:addCustomEventListener(Hall_Events.MSG_BANK_VERIFY_PWD, handler(self, self.onMsgVerifyBankPwd))

    self:initEditBox()
    --找回银行密码 手机号不可输入
    if self.typeDialog == 2 then 
        self.m_pEditBox1:setEnabled(false)
        local strAccounts = PlayerInfo.getInstance():getStrUserAccount()
        self.m_pEditBox1:setText(strAccounts)
    end
    cc.exports.TimerProxy:addTimer(1000, handler(self, self.updateCountDown), 1, -1, false)
end

function ForgetDialog:onExit()
    self.super:onExit()

    cc.exports.TimerProxy:removeTimer(1000)
    SLFacade:removeEventListener(self.m_verifyBankPwd)

    ForgetDialog.instance_ = nil
end

function ForgetDialog:initEditBox()
     self.m_pEditBox1 = self:createEditBox(11, cc.KEYBOARD_RETURNTYPE_DONE, 0, self.m_pImgInput[1]:getContentSize(),yl.getLocalString("REGISTER_17"), true)
--    self.m_pEditBox1:setFontColor(cc.c3b(238, 228, 152))
    self.m_pEditBox1:setPosition(self.m_pImgInput[1]:getPositionX() + 10, self.m_pImgInput[1]:getPositionY() + 10)
    self.m_pEditBox1:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)

    self.m_pEditBox2 = self:createEditBox(6, cc.KEYBOARD_RETURNTYPE_DONE, 1, self.m_pImgInput[2]:getContentSize(), yl.getLocalString("REGISTER_19"))
--    self.m_pEditBox2:setFontColor(cc.c3b(238, 228, 152))
    self.m_pEditBox2:setPosition(self.m_pImgInput[2]:getPositionX() + 10, self.m_pImgInput[2]:getPositionY() + 7)
    self.m_pEditBox2:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)

    self.m_pEditBox3 = self:createEditBox(20, cc.KEYBOARD_RETURNTYPE_DONE, 2, self.m_pImgInput[3]:getContentSize(), yl.getLocalString("REGISTER_2"))
    self.m_pEditBox3:setPosition(self.m_pImgInput[3]:getPositionX() + 10, self.m_pImgInput[3]:getPositionY() + 10)
    self.m_pEditBox3:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    self.m_pEditBox3:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)

    self.m_pEditBox4 = self:createEditBox(20, cc.KEYBOARD_RETURNTYPE_DONE, 3, self.m_pImgInput[4]:getContentSize(), yl.getLocalString("REGISTER_2"))
    self.m_pEditBox4:setPosition(self.m_pImgInput[4]:getPositionX() + 10, self.m_pImgInput[4]:getPositionY() + 10)
    self.m_pEditBox4:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    self.m_pEditBox4:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)

    self.m_pImgBg:addChild(self.m_pEditBox1)
    self.m_pImgBg:addChild(self.m_pEditBox2)
    self.m_pImgBg:addChild(self.m_pEditBox3)
    self.m_pImgBg:addChild(self.m_pEditBox4)
end

function ForgetDialog:createEditBox(maxLength, keyboardReturnType, tag, size, placestr, noNeedTouch)
    local sprite1 = ccui.Scale9Sprite:createWithSpriteFrameName("gui-dialog-null.png")
    local sprite2 = ccui.Scale9Sprite:createWithSpriteFrameName("gui-dialog-null.png")
    local sprite3 = ccui.Scale9Sprite:createWithSpriteFrameName("gui-dialog-null.png")
    size = cc.size(size.width - 25, 35)
    local editBox = cc.EditBox:create(size, sprite1, sprite2, sprite3)
    editBox:setMaxLength(maxLength)
    editBox:setReturnType(keyboardReturnType)
    editBox:setTag(tag)
    editBox:setPlaceHolder(placestr)
    if device.platform ~= "ios" and device.platform ~= "mac" then
        editBox:setPlaceholderFontName("Microsoft Yahei");
        editBox:setPlaceholderFontSize(25)
        editBox:setPlaceholderFontColor(cc.c3b(171,120,70))
    end
    editBox:setFont("Microsoft Yahei", 25);
    editBox:setFontColor(cc.c3b(108,59,27))
    editBox:setAnchorPoint(cc.p(0, 0))
    editBox:registerScriptEditBoxHandler(handler(self, self.onEditBoxEventHandle))
    
    -- 模拟点击输入框解决 android 手机首次输入看不到输入内容BUG。
    if device.platform == "android" and not noNeedTouch then
        self.m_nEditBoxTouchCount = 0
        editBox:touchDownAction(editBox,ccui.TouchEventType.ended)
        editBox:touchDownAction(editBox,ccui.TouchEventType.canceled)
    else
        self.m_nEditBoxTouchCount = 5
    end

    return editBox
end

function ForgetDialog:onEditBoxEventHandle(event, pSender)
    print("onEditBoxEventHandle")
    if "began" == event then
        if self.m_nEditBoxTouchCount > 3 then
            ExternalFun.playClickEffect()
        end
    elseif "ended" == event then
        self.m_nEditBoxTouchCount = self.m_nEditBoxTouchCount + 1
    elseif "return" == event then
    elseif "changed" == event then
    end
end

function ForgetDialog:onCloseClicked()
   ExternalFun.playClickEffect()

    self:onMoveExitView()
end

function ForgetDialog:onConfirmClicked()
   ExternalFun.playClickEffect()
    self:verify()
end

function ForgetDialog:onClickedGetNumber()
    ExternalFun.playClickEffect()
    -------------------------
    -- modifie by JackyXu
    local curTime = os.time()
    if self.tlast and curTime - self.tlast < 1 then
        return
    end
    self.tlast = curTime
    -------------------------
    
    self:sendRequestPhoneCode()
end

function ForgetDialog:sendRequestPhoneCode()
    --请求手机验证码
    local strCellPhone = self.m_pEditBox1:getText()
    print("ForgetDialog:sendRequestPhoneCode strCellPhone:", strCellPhone)
    print("ForgetDialog:sendRequestPhoneCode #strCellPhone:", string.len(strCellPhone))
    if string.len(strCellPhone) == 0 then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_17")
        return
    end
    if not yl.CheckIsMobile(strCellPhone) then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_18")
        return 
    end

    --5 => '重置登录密码',(在用)
    --6 => '重置银行密码',(在用)
    if self.m_nVerifyType == 1 then
        --CMsgHall:sendRequestPhoneVerifyCode(0, strCellPhone, 5) --登录密码找回
    elseif self.m_nVerifyType == 2 then
       -- CMsgHall:sendRequestPhoneVerifyCode(0, strCellPhone, 6) --银行密码找回
    end

    --发送就开始倒计时
    self:onMsgVerifyDone()
end
    
function ForgetDialog:onMsgVerifyDone()
    self.m_pBtnGetNumber:setVisible(false)
    self.m_pLbCountDown:setVisible(true)
    self.m_nCountDown = 60

end

--重新获取倒计时
function ForgetDialog:updateCountDown()
    if (self.m_nCountDown == 0) then
        self.m_pLbCountDown:setVisible(false)
        self.m_pBtnGetNumber:setVisible(true)
    elseif(self.m_nCountDown > 0) then
        self.m_nCountDown = self.m_nCountDown - 1
        self.m_pLbCountDown:setString( string.format(yl.getLocalString("REGISTER_22"),self.m_nCountDown))
    end
end

--校验
function ForgetDialog:verify()
    local strCellPhone = self.m_pEditBox1:getText()
    local strVerifyCode = self.m_pEditBox2:getText()
    local strPassword1 = self.m_pEditBox3:getText()
    local strPassword2 = self.m_pEditBox4:getText()
    
    if string.len(strCellPhone) == 0 then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_17")
        return
    end
    
    if string.len(strCellPhone) ~= 11 then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_18")
        return 
    end
    
    if string.len(strVerifyCode) == 0 then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_19")
        return
    end
    
    if not strPassword1 or strPassword1 == "" then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_14")
        return
    end
    
    if not strPassword2 or strPassword2 == "" then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_20")
        return
    end
    
    if strPassword1 ~= strPassword2 then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_7")
        return
    end

    if yl.check_include_chinese(strPassword1) then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_26")
        return
    end

    if not yl.check_paypassword(strPassword1) then
       FloatMessage.getInstance():pushMessageWarning("REGISTER_16")
       return
   end
    
    self:sendFindPwd()
end

function ForgetDialog:sendFindPwd()
    local strPhone = self.m_pEditBox1:getText()
    local strVerifyCode = self.m_pEditBox2:getText()
    local strPwd = self.m_pEditBox3:getText()
    local strPwdMD5 = SLUtils:MD5(strPwd)
    
    if (self:getType() == 1) then
        --CMsgHall:sendResetLogonPwd(strPhone, strPwdMD5, strVerifyCode)
    elseif (self:getType() == 2) then
        --CMsgHall:sendResetBankPwd(strPhone, strPwdMD5, strVerifyCode)
    end
end

function ForgetDialog:getType()
    return self.typeDialog or 1
end

function ForgetDialog:onMsgVerifyBankPwd()
    
    if self.typeDialog == 1 then --打开登录界面
        self:getParent():getParent():onLoginClicked()
    elseif self.typeDialog == 2 then --打开银行提示界面
        PlayerInfo.getInstance():setInsurePass(self.m_pEditBox3:getText())
        PlayerInfo.getInstance():setIsInsurePass(1)
        
        self:getParent():getParent():showBankView()
    end

    self:removeFromParent()
end

return ForgetDialog
