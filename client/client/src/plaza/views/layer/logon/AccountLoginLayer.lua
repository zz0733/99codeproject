--region AccountLoginLayer.lua
--Date 
--
--endregion

-- Desc: 帐号登录 view
-- modified by JackyXu on 2017.05.16.


local FindPwdDialog = require(appdf.CLIENT_SRC .."plaza.views.layer.logon.ForgetDialog")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .."ExternalFun")

local AccountLoginLayer = class("AccountLoginLayer", FixLayer)

AccountLoginLayer.instance_ = nil
function AccountLoginLayer.create()
    AccountLoginLayer.instance_ = AccountLoginLayer.new()
    return AccountLoginLayer.instance_
end
function AccountLoginLayer:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_nEditBoxTouchCount = 0 -- 输入框点击次数

    self:init()
end

function AccountLoginLayer:init()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    self.m_pathUI = cc.CSLoader:createNode("hall/csb/AccountLoginDialog.csb")
    self.m_pathUI:addTo(self.m_rootUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("AccountLogin")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    self.m_pImgBg       = self.m_pNodeRoot:getChildByName("Image_bg")
    self.m_pBtnClose    = self.m_pImgBg:getChildByName("BTN_close")
    self.m_pBtnGetPwd   = self.m_pImgBg:getChildByName("Button_find_password")
    self.m_pBtnSignin   = self.m_pImgBg:getChildByName("Button_signin")
    local nodeName      =  self.m_pImgBg:getChildByName("Image_input1")
    local nodePassWord  =  self.m_pImgBg:getChildByName("Image_input2")

    --init editbox
    self.m_accountEditBox = self:createEditBox(20,
                                        cc.KEYBOARD_RETURNTYPE_DONE,
                                        cc.EDITBOX_INPUT_MODE_SINGLELINE,
                                        cc.EDITBOX_INPUT_FLAG_SENSITIVE,
                                        1,
                                        nodeName:getContentSize(),
                                        yl.getLocalString("LOGIN_1"),
                                        cc.c3b(108,59,27)) --cc.WHITE
    self.m_accountEditBox:setPosition(cc.p(10,14))
    self.m_accountEditBox:addTo(nodeName, 1)

    self.m_passwordEditBox = self:createEditBox(20,
                                        cc.KEYBOARD_RETURNTYPE_DONE,
                                        cc.EDITBOX_INPUT_MODE_SINGLELINE,
                                        cc.EDITBOX_INPUT_FLAG_PASSWORD,
                                        2,
                                        nodePassWord:getContentSize(),
                                        yl.getLocalString("LOGIN_2"),
                                        cc.c3b(108,59,27)) --cc.WHITE
    self.m_passwordEditBox:setPosition(cc.p(10,14))
    self.m_passwordEditBox:addTo(nodePassWord, 1)

    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseClicked))
    self.m_pBtnSignin:addClickEventListener(handler(self, self.onLoginClicked))
    self.m_pBtnGetPwd:addClickEventListener(handler(self, self.onForgetPwdClicked))

    -- 设置之前登录过的帐号
    local account = ""
    local password  = ""
    local accpuntinfor =  AccountManager.getInstance():getCurrentAccountInfor()
    if accpuntinfor then
        account = accpuntinfor[4]
        password = accpuntinfor[5]
    end
    if string.len(account) > 0 then
        self.m_accountEditBox:setText(account);
    end
    if string.len(password) > 0 then
        self.m_passwordEditBox:setText(password);
    end

    return self
end

function AccountLoginLayer:onEnter()
    self.super:onEnter()
    self:showWithStyle()
end

function AccountLoginLayer:onExit()
    
    self:stopAllActions()
    self.super:onExit()
    AccountLoginLayer.instance_ = nil
end

function AccountLoginLayer:createEditBox(maxLength, keyboardReturnType, inputMode, inputFlag, tag, size, placestr, color)
    local sprite1 = ccui.Scale9Sprite:createWithSpriteFrameName("gui-dialog-null.png")
    local sprite2 = ccui.Scale9Sprite:createWithSpriteFrameName("gui-dialog-null.png")
    local sprite3 = ccui.Scale9Sprite:createWithSpriteFrameName("gui-dialog-null.png")
    size = cc.size(size.width - 20, 35)
    local editBox = cc.EditBox:create(size, sprite1, sprite2, sprite3)
    editBox:setMaxLength(maxLength)
    editBox:setReturnType(keyboardReturnType)
    editBox:setInputMode(inputMode)
    editBox:setInputFlag(inputFlag)
    editBox:setTag(tag)
    editBox:setPlaceHolder(placestr)
    if device.platform == "windows" then
        editBox:setPlaceholderFontName("Microsoft Yahei")
        editBox:setPlaceholderFontSize(25)
        editBox:setPlaceholderFontColor(cc.c3b(171,120,70))
    end
    editBox:setFontSize(25)
    editBox:setFontColor(color)
    editBox:setAnchorPoint(cc.p(0,0))
    editBox:registerScriptEditBoxHandler(handler(self, self.onEditBoxEventHandle))

    -- 模拟点击输入框解决 android 手机首次输入看不到输入内容BUG。
    if device.platform == "android" then
        self.m_nEditBoxTouchCount = 0
        editBox:touchDownAction(editBox,ccui.TouchEventType.ended)
        editBox:touchDownAction(editBox,ccui.TouchEventType.canceled)
    else
        self.m_nEditBoxTouchCount = 3
    end

    return editBox
end

function AccountLoginLayer:onEditBoxEventHandle(event, pSender)
    if "began" == event then
        if self.m_nEditBoxTouchCount > 1 then
           ExternalFun.playClickEffect()
        end
    elseif "ended" == event then
        self.m_nEditBoxTouchCount = self.m_nEditBoxTouchCount + 1
    elseif "return" == event then
    elseif "changed" == event then
    end
end


function AccountLoginLayer:onCloseClicked()
    ExternalFun.playClickEffect()
    print("AccountLoginLayer:close")

    self:onMoveExitView()
end

function AccountLoginLayer:onForgetPwdClicked()
     ExternalFun.playClickEffect()
	print("AccountLoginLayer:onForgetPwdClicked")

    local findPwdDialog = FindPwdDialog.create(1) --找回账号
    findPwdDialog:setName("FindPwdDialog")
    findPwdDialog.typeDialog = 1
    findPwdDialog:addTo(self:getParent(), 50)
end

function AccountLoginLayer:onLoginClicked()
    ExternalFun.playClickEffect()
	print("AccountLoginLayer:onLoginClicked")

    -- 防连点
    local nCurTime = os.time()
    if self.m_nLastTouchTime and nCurTime - self.m_nLastTouchTime <= 0 then
        return
    end
    self.m_nLastTouchTime = nCurTime

	self:accountLogin()
end

function AccountLoginLayer:accountLogin()
    local account = self.m_accountEditBox:getText()
    local password = self.m_passwordEditBox:getText()
    account = string.trim(account)
    password = string.trim(password)
    print("account:", account, "password", password)
    if not account or string.len(account) == 0 then --账户空
        FloatMessage.getInstance():pushMessageWarning("LOGIN_4")
        return
    end
    if not password or string.len(password) == 0 then --密码空
        FloatMessage.getInstance():pushMessageWarning("LOGIN_8")
        return
    end
    if string.len(password) < 4 or string.len(password) > 20 then --密码长度
        FloatMessage.getInstance():pushMessageWarning("LOGIN_3")
        return
    end

    AccountLoginLayer.instance_.delegate:sendAccountLogin(account, password)
end

return AccountLoginLayer
