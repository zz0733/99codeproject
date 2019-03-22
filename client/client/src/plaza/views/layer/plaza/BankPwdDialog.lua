--region *.lua
--Date
--Desc: 进入银行密码输入框
--endregion

local FloatMessage = cc.exports.FloatMessage

local BankPwdDialog = class("BankPwdDialog", cc.exports.FixLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
BankPwdDialog.instance_ = nil
function BankPwdDialog.create()
    BankPwdDialog.instance_ = BankPwdDialog.new():init()
    return BankPwdDialog.instance_
end

function BankPwdDialog:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    self.m_nLastTouchTime = 0;
    self.m_nEditBoxTouchCount = 0 -- 输入框点击次数
end

function BankPwdDialog:init()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)

    --init csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/BankPswDlg.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("BankPswDlg")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    self.m_pImgBg      = self.m_pNodeRoot:getChildByName("IMG_bg")
    self.m_pBtnClose   = self.m_pImgBg:getChildByName("BTN_close")
    self.m_pBtnFindPsw = self.m_pImgBg:getChildByName("BTN_findPsw")
    self.m_pBtnSure    = self.m_pImgBg:getChildByName("BTN_sure")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))
    self.m_pBtnFindPsw:addClickEventListener(handler(self, self.onGetBankPwdClicked))
    self.m_pBtnSure:addClickEventListener(handler(self, self.onConfirmClicked))

    self.m_pNodeEdit = self.m_pImgBg:getChildByName("node_input")

    self:initEditBox()
    return self
end

function BankPwdDialog:onEnter()
    self.super:onEnter()
    self:showWithStyle()

    self.m_verifyBankPwd = SLFacade:addCustomEventListener(Hall_Events.MSG_BANK_VERIFY_PWD, handler(self, self.onMsgVerifyBankPwd))
end

function BankPwdDialog:onExit()
    self.super:onExit()
    SLFacade:removeEventListener(self.m_verifyBankPwd)

    BankPwdDialog.instance_ = nil
end

function BankPwdDialog:initEditBox()
    if self.m_pEditBox == nil then
        self.m_pEditBox = self:createEditBox(20, cc.KEYBOARD_RETURNTYPE_DONE, "0", self.m_pNodeEdit:getContentSize(), LuaUtils.getLocalString("BANK_5"))
        self.m_pEditBox:setPosition(cc.p(0,10))
        self.m_pNodeEdit:addChild(self.m_pEditBox)
        self.m_pEditBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        self.m_pEditBox:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    end
end

function BankPwdDialog:createEditBox(maxLength, keyboardReturnType, tag, size, placestr)
    local sprite1 = ccui.Scale9Sprite:createWithSpriteFrameName("gui-texture-null.png")
    local sprite2 = ccui.Scale9Sprite:createWithSpriteFrameName("gui-texture-null.png")
    local sprite3 = ccui.Scale9Sprite:createWithSpriteFrameName("gui-texture-null.png")
    size = cc.size(size.width, 32)
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
    editBox:setFont("Microsoft Yahei", 25)
    editBox:setFontColor(cc.c3b(108,59,27))
    editBox:setAnchorPoint(cc.p(0, 0))
    editBox:registerScriptEditBoxHandler(handler(self, self.onEditBoxEventHandle))
    
    -- 模拟点击输入框解决 android 手机首次输入看不到输入内容BUG。
    if device.platform == "android" then
        self.m_nEditBoxTouchCount = 0
        editBox:touchDownAction(editBox,ccui.TouchEventType.ended);
        editBox:touchDownAction(editBox,ccui.TouchEventType.canceled);
    else
        self.m_nEditBoxTouchCount = 2
    end

    return editBox
end

function BankPwdDialog:onEditBoxEventHandle(event, pSender)
    if "began" == event then
        if self.m_nEditBoxTouchCount > 0 then
           ExternalFun.playClickEffect()
        end
    elseif "ended" == event then
        self.m_nEditBoxTouchCount = self.m_nEditBoxTouchCount + 1
    elseif "return" == event then
    elseif "changed" == event then
    end
end

-- 确认按钮
function BankPwdDialog:onConfirmClicked()
    ExternalFun.playClickEffect()
    local self = BankPwdDialog.instance_
    -- 防连点
    local nCurTime = os.time();
    if self.m_nLastTouchTime and nCurTime - self.m_nLastTouchTime <= 0 then
        return
    end
    self.m_nLastTouchTime = nCurTime

    local strPwd = self.m_pEditBox:getText()
    if not strPwd or strPwd == "" then
        FloatMessage.getInstance():pushMessageWarning("BANK_38")
        return
    end

    local strPwdMD5 = SLUtils:MD5(strPwd)

    CMsgHall:sendVerifyBankPwd(strPwdMD5)
--    Veil::getInstance()->setEnabled(true, VEIL_USR_SERVICE)
end

function BankPwdDialog:onReturnClicked()
    ExternalFun.playClickEffect()
    self:onMoveExitView()
end

function BankPwdDialog:onGetBankPwdClicked()
    ExternalFun.playClickEffect()
    if PlayerInfo.getInstance():getIsGuest() then
        cc.exports.FloatMessage.getInstance():pushMessage("请升级到正式账号")
    else
        self:getBackBankPassword()
    end
end

function BankPwdDialog:getBackBankPassword()
    self:getParent():getParent():showFindPwdDialog()
end

function BankPwdDialog:onMsgVerifyBankPwd()
    if self.m_pEditBox then
        PlayerInfo.getInstance():setInsurePass(self.m_pEditBox:getText())
    end
    self:getParent():getParent():showBankView()

    self:onMoveExitView(FixLayer.HIDE_NO_STYLE)
end

return BankPwdDialog
