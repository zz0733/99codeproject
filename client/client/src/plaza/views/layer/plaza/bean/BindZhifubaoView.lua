--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local FloatMessage = cc.exports.FloatMessage
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local BindZhifubaoView = class("BindZhifubaoView", FixLayer)

BindZhifubaoView.instance_ = nil
function BindZhifubaoView.create()
    BindZhifubaoView.instance_ = BindZhifubaoView.new():init()
    return BindZhifubaoView.instance_
end

function BindZhifubaoView:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)
    
    self.m_nEditBoxTouchCount = 0 -- 输入框点击次数
end

function BindZhifubaoView:init()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)

    --init csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/BindZhifubaoView.csb")
    self.m_rootUI:addChild(self.m_pathUI)

    self.m_pNodeRoot          = self.m_pathUI:getChildByName("BindZhifubao")
    self.m_pNodeRoot:setPositionX(145 - (1624-display.size.width)/2)

    self.m_pNodeContent       = self.m_pNodeRoot:getChildByName("Image_bg")

    -- Button return
    self.m_pBtnClose          = self.m_pNodeContent:getChildByName("Button_return")

    -- EditBox Bg
    self.m_pImgEditAccount    = self.m_pNodeContent:getChildByName("Image_EditAccount")
    self.m_pImgEditName       = self.m_pNodeContent:getChildByName("Image_EditName")

    -- Button Bind
    self.m_pBtnBind           = self.m_pNodeContent:getChildByName("Button_Bind")

    return self
end

function BindZhifubaoView:onEnter()
    self.super:onEnter()
    self:showWithStyle()

    -- Click Event
    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseClicked))
    self.m_pBtnBind:addClickEventListener(handler(self, self.onBindClicked))

    self:initEditBox()

    SLFacade:addCustomEventListener(Hall_Events.MSG_QUERY_BINDING,              handler(self, self.onMsgQueryBinding),   self.__cname)
    SLFacade:addCustomEventListener(Hall_Events.MSG_BINDING_SUCCESS,            handler(self, self.onMsgBindingSuccess), self.__cname)
end

function BindZhifubaoView:onExit()
    self.super:onExit()

    SLFacade:removeCustomEventListener(Hall_Events.MSG_QUERY_BINDING,           self.__cname)
    SLFacade:removeCustomEventListener(Hall_Events.MSG_BINDING_SUCCESS,         self.__cname)
    BindZhifubaoView.instance_ = nil
end

function BindZhifubaoView:initEditBox()
    -- body
   if self.m_pEditAccount == nil then
        self.m_pEditAccount = self:createEditBox(128, cc.KEYBOARD_RETURNTYPE_DONE, cc.EDITBOX_INPUT_MODE_SINGLELINE, cc.EDITBOX_INPUT_FLAG_SENSITIVE, 1, cc.size(340, 40), LuaUtils.getLocalString("USR_DIALOG_21"))
        self.m_pEditAccount:setPosition(cc.p(15, 10))
        self.m_pImgEditAccount:addChild(self.m_pEditAccount)
    end

    if self.m_pEditName == nil then
        self.m_pEditName = self:createEditBox(64, cc.KEYBOARD_RETURNTYPE_DONE, cc.EDITBOX_INPUT_MODE_SINGLELINE, cc.EDITBOX_INPUT_FLAG_SENSITIVE, 2, cc.size(340, 40), LuaUtils.getLocalString("USR_DIALOG_24"))
        self.m_pEditName:setPosition(cc.p(15, 10))
        self.m_pImgEditName:addChild(self.m_pEditName)
    end
end

function BindZhifubaoView:createEditBox(maxLength, keyboardReturnType, inputMode, inputFlag, tag, size, placestr)
    local sprite1 = ccui.Scale9Sprite:createWithSpriteFrameName("hall/plist/hall/gui-texture-null.png")
    local sprite2 = ccui.Scale9Sprite:createWithSpriteFrameName("hall/plist/hall/gui-texture-null.png")
    local sprite3 = ccui.Scale9Sprite:createWithSpriteFrameName("hall/plist/hall/gui-texture-null.png")
    --size = cc.size(size.width, 35)
    local editBox = cc.EditBox:create(size, sprite1, sprite2, sprite3)
    editBox:setMaxLength(maxLength)
    editBox:setReturnType(keyboardReturnType)
    editBox:setInputMode(inputMode)
    editBox:setInputFlag(inputFlag)
    editBox:setTag(tag)
    editBox:setPlaceHolder(placestr)
    if device.platform ~= "ios" and device.platform ~= "mac" then
        editBox:setPlaceholderFontName("Helvetica")
        editBox:setPlaceholderFontSize(28)
        editBox:setPlaceholderFontColor(cc.c3b(140,111,83))
    end
    editBox:setFont("Helvetica", 28)
    editBox:setFontColor(cc.c3b(108,59,27))
    editBox:setAnchorPoint(cc.p(0, 0))
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

function BindZhifubaoView:onEditBoxEventHandle(event, pSender)
    -- body
    if "began" == event then
        if self.m_nEditBoxTouchCount > 1 then
            ExternalFun.playClickEffect()
        end
    elseif "ended" == event then
    elseif "return" == event then
    elseif "changed" == event then
    end
end

----------------------------
-- Click Handle
-- Close
function BindZhifubaoView:onCloseClicked()
    ExternalFun.playClickEffect()
    
    self:onMoveExitView()
end

-- Bind
function BindZhifubaoView:onBindClicked()
    ExternalFun.playClickEffect()

    -- check editbox
    local strText1 = self.m_pEditAccount:getText()
    local strText2 = self.m_pEditName:getText()

    --检查支付宝账号
    if string.len(strText1) <= 0 then
        FloatMessage.getInstance():pushMessage("USR_DIALOG_21")
        return
    end

    --检查支付宝实名
    if string.len(strText2) <= 0 then
        FloatMessage.getInstance():pushMessage("USR_DIALOG_10")
        return
    end
    
    --如果是纯数字,就判断是不是电话号码
    if LuaUtils.string_number2(strText1) then
        if string.len(strText1) ~= 11 then
            FloatMessage.getInstance():pushMessage("USR_DIALOG_27")
            return
        end
    else
        if not LuaUtils.check_email(strText1) then
            FloatMessage.getInstance():pushMessage("USR_DIALOG_27")
            return
        end
    end
   
    --检查名字是中文
    if not LuaUtils.check_string_chinese(strText2) then
        FloatMessage.getInstance():pushMessage("USR_DIALOG_28")
        return
    end

    local strPswd = PlayerInfo.getInstance():getLoginPwd()
    CMsgHall:sendBindingAli(strText1, strText2, strPswd)
    cc.exports.Veil.getInstance():ShowLockAndUnlock(1.0)
end

----------------------------
-- update Handle
-- Bind Success
function BindZhifubaoView:onMsgBindingSuccess()
    --sucess tip
    FloatMessage.getInstance():pushMessage("USR_DIALOG_25")

    --query msg
    CMsgHall:sendQueryBank()

    -- close self
    self:onMoveExitView(FixLayer.HIDE_NO_STYLE)
end

-- Query Success
function BindZhifubaoView:onMsgQueryBinding()
    self.m_pEditAccount:setText(PlayerInfo.getInstance():getBindingAliPayAccout())
    self.m_pEditAccount:setTouchEnabled(false)
    self.m_pEditName:setText(PlayerInfo.getInstance():getBindingAliPayName())
    self.m_pEditName:setTouchEnabled(false)

    self.m_pBtnBind:setVisible(false)
end

return BindZhifubaoView

--endregion
