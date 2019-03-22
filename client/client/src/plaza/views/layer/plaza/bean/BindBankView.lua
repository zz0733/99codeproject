--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local FloatMessage = cc.exports.FloatMessage

local BindBankView = class("BindBankView", FixLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local G_VecBank    = LuaUtils.getLocalString("BankName")

BindBankView.instance_ = nil
function BindBankView.create()
    BindBankView.instance_ = BindBankView.new():init()
    return BindBankView.instance_
end

function BindBankView:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)
    
    self.m_nSelectBankTag       = 1
    self.m_nEditBoxTouchCount   = 0 -- 输入框点击次数
end

function BindBankView:init()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)

    --init csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/BindBankView.csb")
    self.m_rootUI:addChild(self.m_pathUI)

    self.m_pNodeRoot          = self.m_pathUI:getChildByName("BindBank")
    self.m_pNodeRoot:setPositionX(145 - (1624-display.size.width)/2)

    self.m_pNodeContent       = self.m_pNodeRoot:getChildByName("Image_bg")

    -- Button return
    self.m_pBtnClose          = self.m_pNodeContent:getChildByName("Button_return")

    -- EditBox Bg
    self.m_pImgEditAccount    = self.m_pNodeContent:getChildByName("Image_EditAccount")
    self.m_pImgEditName       = self.m_pNodeContent:getChildByName("Image_EditName")

    --Node bank
    local nodeBank            = self.m_pNodeContent:getChildByName("Node_Bank")
    self.m_pBtnBanks          = {}
    for i = 1, 15 do
        self.m_pBtnBanks[i]   = nodeBank:getChildByName("Image_"..i)
    end
    self.m_pImgSelect         = nodeBank:getChildByName("Image_Select")

    -- Button Bind
    self.m_pBtnBind           = self.m_pNodeContent:getChildByName("Button_Bind")

    return self
end

function BindBankView:onEnter()
    self.super:onEnter()
    self:showWithStyle()

    -- Click Event
    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseClicked))
    self.m_pBtnBind:addClickEventListener(handler(self, self.onBindClicked))
    for i = 1, 15 do
        self.m_pBtnBanks[i]:setTouchEnabled(true)
        self.m_pBtnBanks[i]:addClickEventListener(handler(self, self.onBankClicked))
    end

    self:initEditBox()
    self:initSelectBanker()

   SLFacade:addCustomEventListener(Hall_Events.MSG_QUERY_BINDING,          handler(self, self.onMsgQueryBinding),   self.__cname)
    SLFacade:addCustomEventListener(Hall_Events.MSG_BINDING_SUCCESS,       handler(self, self.onMsgBindingSuccess), self.__cname)
end

function BindBankView:onExit()
    self.super:onExit()

    SLFacade:removeCustomEventListener(Hall_Events.MSG_QUERY_BINDING,           self.__cname)
    SLFacade:removeCustomEventListener(Hall_Events.MSG_BINDING_SUCCESS,         self.__cname)
    BindBankView.instance_ = nil
end

function BindBankView:initSelectBanker()
    local _bankname = "中国工商银行"--PlayerInfo.getInstance():getBindingBankName()
    if string.len(_bankname) > 0 then
        for i=1,15 do
            local strName = string.format("bank_%d", i)
            if _bankname == G_VecBank[strName] then
                local _pos = cc.p(self.m_pBtnBanks[i]:getPosition())
                self.m_pImgSelect:setPosition(_pos)
                self.m_pImgSelect:setVisible(true)
                self.m_nSelectBankTag = i
                break
            end
        end
    end
end


function BindBankView:initEditBox()
    -- body
   if self.m_pEditAccount == nil then
        self.m_pEditAccount = self:createEditBox(128, cc.KEYBOARD_RETURNTYPE_DONE, cc.EDITBOX_INPUT_MODE_NUMERIC, cc.EDITBOX_INPUT_FLAG_SENSITIVE, 1, cc.size(340, 40), LuaUtils.getLocalString("USR_DIALOG_22"))
        self.m_pEditAccount:setPosition(15, 10)
        self.m_pImgEditAccount:addChild(self.m_pEditAccount)
    end

    if self.m_pEditName == nil then
        self.m_pEditName = self:createEditBox(64, cc.KEYBOARD_RETURNTYPE_DONE, cc.EDITBOX_INPUT_MODE_SINGLELINE, cc.EDITBOX_INPUT_FLAG_SENSITIVE, 2, cc.size(340, 40), LuaUtils.getLocalString("USR_DIALOG_24"))
        self.m_pEditName:setPosition(15, 10)
        self.m_pImgEditName:addChild(self.m_pEditName)
    end
end

function BindBankView:createEditBox(maxLength, keyboardReturnType, inputMode, inputFlag, tag, size, placestr)
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

function BindBankView:onEditBoxEventHandle(event, pSender)
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
function BindBankView:onCloseClicked()
    ExternalFun.playClickEffect()
    
    self:onMoveExitView()
end

-- Bank 
function BindBankView:onBankClicked(sender)
    ExternalFun.playClickEffect()
    local tag = sender:getTag()
    
    self.m_nSelectBankTag = tag
    local x, y =self.m_pBtnBanks[tag]:getPosition()
    self.m_pImgSelect:setPosition(cc.p(x, y))
end

-- Bind
function BindBankView:onBindClicked()
    ExternalFun.playClickEffect()

    -- check editbox
    local strText1 = self.m_pEditAccount:getText()
    local strText2 = self.m_pEditName:getText()

    --银行卡号
    if string.len(strText1) <= 0 then
        FloatMessage.getInstance():pushMessage("USR_DIALOG_22")
        return
    end

    --检查银行卡实名
    if string.len(strText2) <= 0 then
        FloatMessage.getInstance():pushMessage("USR_DIALOG_10")
        return
    end

    --检查是否选中银行
    if self.m_nSelectBankTag == 0 then
        FloatMessage.getInstance():pushMessage("USR_DIALOG_26")
        return
    end

    --检查银行卡号
    if not LuaUtils.string_number2(strText1) then
        FloatMessage.getInstance():pushMessage("STRING_212")
        return
    end

    --检查名字是中文
    if not LuaUtils.check_string_chinese(strText2) then
        FloatMessage.getInstance():pushMessage("USR_DIALOG_28")
        return
    end

    local strName = string.format("bank_%d", self.m_nSelectBankTag)
    local strMobile = PlayerInfo.getInstance():getMobile()
    local strPswd = PlayerInfo.getInstance():getLoginPwd()
    local strBank = G_VecBank[strName]
    CMsgHall:sendBindingCard(strText1, strText2, strMobile, strPswd, strBank)
    cc.exports.Veil.getInstance():ShowLockAndUnlock(1.0)
end

----------------------------
-- update Handle
-- Bind Success
function BindBankView:onMsgBindingSuccess()
    --sucess tip
    FloatMessage.getInstance():pushMessage("USR_DIALOG_25")

    --query msg
    CMsgHall:sendQueryBank()

    -- close self
    self:onMoveExitView(FixLayer.HIDE_NO_STYLE)
end

-- Query Success
function BindBankView:onMsgQueryBinding()
    self.m_pEditAccount:setText(PlayerInfo.getInstance():getBindingCardNumber())
    self.m_pEditAccount:setTouchEnabled(false)
    self.m_pEditName:setText(PlayerInfo.getInstance():getBindingCardName())
    self.m_pEditName:setTouchEnabled(false)

    --银行卡按钮不再可点
    for i = 1, 15 do
        self.m_pBtnBanks[i]:setTouchEnabled(false)
    end

    self.m_pBtnBind:setVisible(false)
end

return BindBankView

--endregion
