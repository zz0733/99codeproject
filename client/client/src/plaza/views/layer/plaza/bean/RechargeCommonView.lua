--region RechargeCommonView.lua
--Date 2017.04.25.
--Auther JackyXu.
--Desc: 通用充值 view
local ExternalFun       = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local FloatMessage = cc.exports.FloatMessage
local CRechargeManager  = cc.exports.CRechargeManager
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local money_niu = {50,100,500,1000,5000,10000,20000,50000}
local G_RECHARGE_TYPE_ICON = {
    [2] = "hall/plist/shop/gui-recharge-icon-wx.png",       --[G_CONSTANTS.Recharge_Type.Type_WeChat]
    [1] = "hall/plist/shop/gui-recharge-icon-zfb.png",      --[G_CONSTANTS.Recharge_Type.Type_Alipay]
    [3] = "hall/plist/shop/gui-recharge-icon-koukou.png",   --[G_CONSTANTS.Recharge_Type.Type_QQ]
    [4] = "hall/plist/shop/gui-recharge-icon-bank.png",     --[G_CONSTANTS.Recharge_Type.Type_Bank]
    [5] = "hall/plist/shop/gui-recharge-icon-jindon.png",   --[G_CONSTANTS.Recharge_Type.Type_JingDong]
}
local payparam = {
    ["Type_Alipay"] = "http://pay456game.tianshen898.com/client_unity/pay/?username=%s&money_amount=%d&bank_type_code=ALIPAY&package_id=comazgodqp456",
    ["Type_WeChat"] = "http://pay456game.tianshen898.com/account/payh5/?username=%s&money_amount=%d&bank_type_code=WECHATPAY",
    ["Type_Bank"] = "http://pay456game.tianshen898.com/account/payh5/?username=%s&money_amount=%d&bank_type_code=BANKWAP"
}
local RechargeCommonView = class("RechargeCommonView", cc.Layer)
    
local G_TagRechargeCommonViewMsgEvent = "TagRechargeCommonViewMsgEvent" -- 事件监听 Tag

local G_RechargeCommonView = nil
function RechargeCommonView.create()
    G_RechargeCommonView = RechargeCommonView.new():init()
    return G_RechargeCommonView
end

function RechargeCommonView:ctor()
    self:enableNodeEvents()

    self.m_pNodeInput = nil;
    self.m_pLbUserId = nil;
    self.m_pLbBankMoney = nil;
    self.m_pEditBox = nil;
    self.m_vecBtnScore = {}
	self.m_pLbRechargeMoney = {}
    
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
    
    self.m_nEditBoxTouchCount = 0 -- 输入框点击次数
end

function RechargeCommonView:init()
    
    --init csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/RechargeCommonView.csb")
    self.m_rootUI:addChild(self.m_pathUI)

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("CommonRechargeView")
    self.m_pNodeContent = self.m_pNodeRoot:getChildByName("node_content")
    self.m_pImgIcon     = self.m_pNodeContent:getChildByName("Image_myinfo"):getChildByName("IMG_typeIcon")
    self.m_pLbUserId    = self.m_pNodeContent:getChildByName("Image_myinfo"):getChildByName("LB_ID")
    self.m_pNodeInput   = self.m_pNodeContent:getChildByName("Node_input_gold"):getChildByName("IMG_inputBg")
    self.m_pBtnClean    = self.m_pNodeContent:getChildByName("Node_input_gold"):getChildByName("BTN_clean")
    self.m_pBtnCommit   = self.m_pNodeContent:getChildByName("BTN_commit")

    -- 按纽响应
    self.m_pBtnClean:addClickEventListener(handler(self, self.onClickedClear))
    self.m_pBtnCommit:addClickEventListener(handler(self, self.onClickedCommit))
    for i=1,#money_niu do
        local strNodeName = "BTN_score" .. i
        self.m_vecBtnScore[i]       = self.m_pNodeContent:getChildByName("Node_gold"):getChildByName(strNodeName)
        self.m_pLbRechargeMoney[i]  = ccui.Helper:seekWidgetByName(self.m_vecBtnScore[i], "FNT_btnTx")
        self.m_vecBtnScore[i]:addTouchEventListener(function(sender,eventType)
                if not self.m_vecBtnScore[i]:isVisible() then return end
                if eventType==ccui.TouchEventType.began then
                    ExternalFun.playSoundEffect("public/sound/sound-button.mp3")
                    if self.m_pLbRechargeMoney[i] then
                        self.m_pLbRechargeMoney[i]:stopAllActions()
                        local pZoomTitleAction = cc.ScaleTo:create(0.05, 1.05, 1.05)
                        self.m_pLbRechargeMoney[i]:runAction(pZoomTitleAction)
                    end
                elseif eventType==ccui.TouchEventType.canceled then
                    if self.m_pLbRechargeMoney[i] then
                        self.m_pLbRechargeMoney[i]:stopAllActions()
                        self.m_pLbRechargeMoney[i]:setScale(1.0)
                    end
                elseif eventType==ccui.TouchEventType.ended then 
                    if self.m_pLbRechargeMoney[i] then
                        self.m_pLbRechargeMoney[i]:stopAllActions()
                        self.m_pLbRechargeMoney[i]:setScale(1.0)
                    end
                    -- 响应选中
                    self:onClickedAdd(i)
                end
            end)
    end

    return self
end

function RechargeCommonView:onEnter()

--    local gameID = PlayerInfo.getInstance():getGameID();
--    self.m_pLbUserId:setString( tostring(gameID) ) 

    self:initEditBox()

    --[[SLFacade:addCustomEventListener(Public_Events.MSG_BANK_INFO, handler(self, self.onMsgBankInfo),G_TagRechargeCommonViewMsgEvent)
    self:onMsgBankInfo(nil)]]
end

function RechargeCommonView:setRechargeType(rechargeType)
    self.m_RechargeType =  rechargeType

    if G_RECHARGE_TYPE_ICON[rechargeType] then
        self.m_pImgIcon:loadTexture(G_RECHARGE_TYPE_ICON[rechargeType], ccui.TextureResType.plistType)
    end
    
    for i = 1, #money_niu do
        --fixbug:bad argument #2 to 'format' (number expected, got nil)
        local money = money_niu[i]--CRechargeManager.getInstance():getRechargeMoneyByIndex(i)
        if money then
            local str = string.format("%.2f", money)
            self.m_pLbRechargeMoney[i]:setString(str)
        end
	end
end

function RechargeCommonView:onExit()
    --[[SLFacade:removeCustomEventListener(Public_Events.MSG_BANK_INFO, G_TagRechargeCommonViewMsgEvent)]]
    G_RechargeCommonView = nil
end

function RechargeCommonView:initEditBox()
    if not self.m_pEditBox then
        local editsize = self.m_pNodeInput:getContentSize()
        self.m_pEditBox = self:createEditBox(20,
                                          cc.KEYBOARD_RETURNTYPE_DONE,
                                          cc.EDITBOX_INPUT_MODE_NUMERIC,
                                          cc.EDITBOX_INPUT_FLAG_SENSITIVE,
                                          0,
                                          editsize,
                                          "充值金额最低10元")--LuaUtils.getLocalString("BANK_17"))
        self.m_pEditBox:setPosition(cc.p(15, 10))
        self.m_pNodeInput:addChild(self.m_pEditBox)
    end
end

function RechargeCommonView:createEditBox(maxLength, keyboardReturnType, inputMode, inputFlag, tag, size, placestr)
    local sprite1 = ccui.Scale9Sprite:createWithSpriteFrameName("hall/plist/hall/gui-texture-null.png")
    local sprite2 = ccui.Scale9Sprite:createWithSpriteFrameName("hall/plist/hall/gui-texture-null.png")
    local sprite3 = ccui.Scale9Sprite:createWithSpriteFrameName("hall/plist/hall/gui-texture-null.png")
    size = cc.size(size.width, 40)
    local editBox = cc.EditBox:create(size, sprite1, sprite2, sprite3)    
    editBox:setMaxLength(maxLength);
    editBox:setReturnType(keyboardReturnType);
    editBox:setInputMode(inputMode);
    editBox:setInputFlag(inputFlag);
    editBox:setTag(tag);
    editBox:setPlaceHolder(placestr);
    if device.platform ~= "ios" and device.platform ~= "mac" then
        editBox:setPlaceholderFontName("Microsoft Yahei");
        editBox:setPlaceholderFontSize(28)
        editBox:setPlaceholderFontColor(cc.c3b(140,111,83))
    end
    editBox:setFont("Microsoft Yahei", 28)
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

    return editBox;
end

function RechargeCommonView:onEditBoxEventHandle(event, pSender)
    if "began" == event then
        if self.m_nEditBoxTouchCount > 0 then
            ExternalFun.playSoundEffect("public/sound/sound-button.mp3")
        end
    elseif "ended" == event then
        self.m_nEditBoxTouchCount = self.m_nEditBoxTouchCount + 1
    elseif "return" == event then
    elseif "changed" == event then
    end
end

function RechargeCommonView:onMsgBankInfo(pMsgData)
    --[[local goldNum = PlayerInfo.getInstance():getUserInsure()
    self.m_pLbBankMoney:setString(LuaUtils.getFormatGoldAndNumber(goldNum))]]
end

function RechargeCommonView:goPay(money, userGiftID)
    CRechargeManager:getInstance():CreatedOrder(self.m_RechargeType, money, userGiftID, "")
end

----------------------------------
-- 按纽响应
-- 50/100/500/1000/5000
function RechargeCommonView:onClickedAdd(nIndex)
    local moneyAdd = money_niu[nIndex]--CRechargeManager.getInstance():getRechargeMoneyByIndex(nIndex)

    --fixbug:attempt to perform arithmetic on local 'moneyAdd' (a nil value)
    if moneyAdd == nil then
        moneyAdd = tonumber(self.m_pLbRechargeMoney[nIndex]:getString())
    end

    local curMoney = 0
    local strMoney = self.m_pEditBox:getText()
    if string.len(strMoney) > 0 then
        curMoney = tonumber(strMoney)
        if curMoney == nil then 
            FloatMessage.getInstance():pushMessage("STRING_057")
            return
        end
    end
    curMoney = curMoney + moneyAdd
   
    strMoney = string.format("%.2f", curMoney)
    self.m_pEditBox:setText(strMoney)
end

function RechargeCommonView:onClickedClear(pSender)
    ExternalFun.playSoundEffect("public/sound/sound-button.mp3")
    self.m_pEditBox:setText("")
end

function RechargeCommonView:onClickedCommit(pSender)
    ExternalFun.playSoundEffect("public/sound/sound-button.mp3")
    if not self.m_pEditBox then
        return
    end

    local str = self.m_pEditBox:getText()
    if string.len(str) <= 0 then
        FloatMessage.getInstance():pushMessage("STRING_056")
        return
    end
    if not LuaUtils.string_number(str) then
        FloatMessage.getInstance():pushMessage("STRING_057")
        return
    end

    local money = tonumber(str)

    if type(money) ~= "number" then
        FloatMessage.getInstance():pushMessage("STRING_057")
        return
    end


    local nickName = GlobalUserItem.tabAccountInfo.nickname
    if self.m_RechargeType == Hall_Events.Recharge_Type.Type_Alipay then
--        if LuaNativeBridge:getInstance():isAlipayInstall() then
--            self:goPay(money, 0)
--        else
--            FloatMessage.getInstance():pushMessage("未安装支付宝客户端")
--        end
        local url = string.format(payparam.Type_Alipay,nickName,money)
        MultiPlatform:getInstance():openBrowser( url )
    elseif self.m_RechargeType == Hall_Events.Recharge_Type.Type_WeChat then
        local url = string.format(payparam.Type_WeChat,nickName,money)
        MultiPlatform:getInstance():openBrowser( url )
    elseif self.m_RechargeType == Hall_Events.Recharge_Type.Type_QQ then
        FloatMessage:getInstance():pushMessage("QQ充值暂未开放，请用其他渠道")
    elseif self.m_RechargeType == Hall_Events.Recharge_Type.Type_Bank then
--        self:goPay(money, 0)
        local url = string.format(payparam.Type_Bank,nickName,money)
        MultiPlatform:getInstance():openBrowser( url )
    elseif self.m_RechargeType == G_CONSTANTS.Recharge_Type.Type_JingDong then
--        if device.platform == "windows" then
--        else
--            self:goPay(money, 0)
--        end
    else
        print("不支持的支付类型!")
    end
end

return RechargeCommonView
