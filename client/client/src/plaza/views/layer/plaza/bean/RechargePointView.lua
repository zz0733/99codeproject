--region RechargePointView.lua
--Date 2017.04.25.
--Auther JackyXu.
--Desc: 通用充值 view

local FloatMessage = cc.exports.FloatMessage
local CRechargeManager  = cc.exports.CRechargeManager
local cjson = require("cjson")

local RechargePointView = class("RechargePointView", cc.Layer)

local G_TagRechargePointViewMsgEvent = "TagRechargePointViewMsgEvent" -- 事件监听 Tag

local CARD_TYPE = { "SZX", "UNICOM", "TELECOM"}

local MONEY_OPTION = 
{ 
    {10, 20, 30, 50, 100, 300, 500}, --移动
    {10, 20, 30, 50, 100, 300, 500}, --联通    
    {10, 20, 30, 50, 100, 300, 500} --电信                    
 }

local G_RechargePointView = nil
function RechargePointView.create()
    G_RechargePointView = RechargePointView.new():init()
    return G_RechargePointView
end

function RechargePointView:ctor()
    self:enableNodeEvents()

    self.m_pCheckType = {}
    self.m_pNodeEditBox = {}
    self.m_pCheckMoney = {}
    self.m_pLbRechargeMoney = {}
    self.m_pEditBox = {}
    self.m_nCurrentType = 1
    self.m_nCurrentMoney = MONEY_OPTION[1][1]
    
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
    
    self.m_nEditBoxTouchCount = 0 -- 输入框点击次数
end

function RechargePointView:init()
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/RechargePointCardView.csb")
    self.m_rootUI:addChild(self.m_pathUI)

    self.m_pNodeRoot =  self.m_pathUI:getChildByName("RechargePointCardView"):getChildByName("node_content")
    --node check
    self.m_pNodeCheck = self.m_pNodeRoot:getChildByName("Node_Check")
    self.m_pCheckType[1] = self.m_pNodeCheck:getChildByName("CheckBox_Mobile")
    self.m_pCheckType[1]:setSelected(true)
    self.m_pCheckType[1]:setEnabled(false)
    self.m_pCheckType[2] = self.m_pNodeCheck:getChildByName("CheckBox_Unicome")
    self.m_pCheckType[2]:setSelected(false)
    self.m_pCheckType[3] = self.m_pNodeCheck:getChildByName("CheckBox_Telecom")
    self.m_pCheckType[3]:setSelected(false)

    local isClose = {false, false, false}
    local index = 0
    for i= 1, 3 do
        if isClose[i] then
            self.m_pCheckType[i]:setVisible(false)
        else
            self.m_pCheckType[i]:setVisible(true)
            self.m_pCheckType[i]:setPosition(cc.p(55 + index*160, 480))
            index = index + 1
            if self.m_nCurrentType == 0 then 
                self.m_nCurrentType = i
            end 
        end
    end
    
    --node input
    self.m_pNodeInput = self.m_pNodeRoot:getChildByName("Node_Input")
    self.m_pNodeEditBox[1] = self.m_pNodeInput:getChildByName("Image_Input_Act")
    self.m_pNodeEditBox[2] = self.m_pNodeInput:getChildByName("Image_Input_Pwd")

    --node add
    self.m_pNodeAdd = self.m_pNodeRoot:getChildByName("Node_Add")
    for i= 1, 7 do
        local btnName = "CheckBox_" .. tostring(i)
        self.m_pCheckMoney[i] = self.m_pNodeAdd:getChildByName(btnName)
        if i == 1 then
            self.m_pCheckMoney[i]:setSelected(true)
            self.m_pCheckMoney[i]:setEnabled(false)
        else
            self.m_pCheckMoney[i]:setSelected(false)
        end
        self.m_pLbRechargeMoney[i] = self.m_pCheckMoney[i]:getChildByName("Text")
    end

    self.m_pBtnCommint  =  self.m_pNodeRoot:getChildByName("BTN_commit")

    self:updateMoneyByType(self.m_nCurrentType)

    return self
end

function RechargePointView:onEnter()
    self:initBtnEvent()
    SLFacade:addCustomEventListener(Hall_Events.MSG_BANK_INFO, handler(self, self.onMsgBankInfo),G_TagRechargePointViewMsgEvent)
    self:initEditBox()
    self:onMsgBankInfo(nil)

end

function RechargePointView:onExit()
    SLFacade:removeCustomEventListener(Hall_Events.MSG_BANK_INFO, G_TagRechargePointViewMsgEvent)
    Veil:getInstance():HideVeil(VEIL_WAIT)
    G_RechargePointView = nil
end

function RechargePointView:initBtnEvent()
    for i = 1, 3 do 
        local function selectedEvent(sender,eventType)
            if eventType == ccui.CheckBoxEventType.selected then
                self:onTypeClicked(i)
            elseif eventType == ccui.CheckBoxEventType.unselected then

            end
        end  
        self.m_pCheckType[i]:addEventListenerCheckBox(selectedEvent)
    end

    for i = 1, 7 do 
        local function selectedEvent(sender,eventType)
            if eventType == ccui.CheckBoxEventType.selected then
                self:onClickedAdd(i)
            elseif eventType == ccui.CheckBoxEventType.unselected then

            end
        end  
        self.m_pCheckMoney[i]:addEventListenerCheckBox(selectedEvent)
    end

    self.m_pBtnCommint:addClickEventListener(handler(self, self.onClickedCommit))
end

function RechargePointView:initEditBox()
    local str = { LuaUtils.getLocalString("STRING_229"),LuaUtils.getLocalString("STRING_230") }
    for i=1, 2 do 
        if not self.m_pEditBox[i] then
            self.m_pEditBox[i] = self:createEditBox(21,
                                              cc.KEYBOARD_RETURNTYPE_DONE,
                                              cc.EDITBOX_INPUT_MODE_SINGLELINE,
                                              cc.EDITBOX_INPUT_FLAG_SENSITIVE,
                                              0,
                                              self.m_pNodeEditBox[i]:getContentSize(),
                                              str[i]);
            self.m_pEditBox[i]:setPosition(cc.p(15, 10))
            self.m_pNodeEditBox[i]:addChild(self.m_pEditBox[i])
        end
    end
end

function RechargePointView:createEditBox(maxLength, keyboardReturnType, inputMode, inputFlag, tag, size, placestr)
    size.height = 40
    local sprite1 = ccui.Scale9Sprite:createWithSpriteFrameName("hall/plist/hall/gui-texture-null.png")
    local sprite2 = ccui.Scale9Sprite:createWithSpriteFrameName("hall/plist/hall/gui-texture-null.png")
    local sprite3 = ccui.Scale9Sprite:createWithSpriteFrameName("hall/plist/hall/gui-texture-null.png")
    local editBox = cc.EditBox:create(size, sprite1, sprite2, sprite3)
    editBox:setMaxLength(maxLength)
    editBox:setReturnType(keyboardReturnType)
    editBox:setInputMode(inputMode)
    editBox:setInputFlag(inputFlag)
    editBox:setTag(tag);
    editBox:setPlaceHolder(placestr)
    if device.platform ~= "ios" and device.platform ~= "mac" then
        editBox:setPlaceholderFontName("Microsoft Yahei")
        editBox:setPlaceholderFontSize(30)
        editBox:setPlaceholderFontColor(cc.c3b(140,111,83))
    end
    editBox:setFont("Microsoft Yahei", 30)
    editBox:setFontColor(cc.c3b(108,59,27))
    editBox:setAnchorPoint(cc.p(0, 0))
    editBox:registerScriptEditBoxHandler(handler(self, self.onEditBoxEventHandle))
    
    -- 模拟点击输入框解决 android 手机首次输入看不到输入内容BUG。
    if device.platform == "android" then
        self.m_nEditBoxTouchCount = 0
        editBox:touchDownAction(editBox,ccui.TouchEventType.ended)
        editBox:touchDownAction(editBox,ccui.TouchEventType.canceled)
    else
        self.m_nEditBoxTouchCount = 2
    end

    return editBox;
end

function RechargePointView:onEditBoxEventHandle(event, pSender)
    
    if self.m_nEditBoxTouchCount == nil then
        return
    end

    if "began" == event then
        if self.m_nEditBoxTouchCount > 0 then
            AudioManager.getInstance():playSound("public/sound/sound-button.mp3")
        end
    elseif "ended" == event then
        self.m_nEditBoxTouchCount = self.m_nEditBoxTouchCount + 1
    elseif "return" == event then
    elseif "changed" == event then
    end
end

function RechargePointView:onMsgBankInfo(pMsgData)
    
end

function RechargePointView:updateMoneyByType(nType)
    
    for i= 1, 7 do
        self.m_pLbRechargeMoney[i]:setString(tostring(MONEY_OPTION[nType][i]))
    end
end

function RechargePointView:cleanEditBox()
    
    for i= 1, 2 do
        self.m_pEditBox[i]:setText("")
    end
end

function RechargePointView:createOrder(cardNo, cardPwd)

    --cardType=xxx&cardNo=xxx&cardPwd=xxx
    local str = "cardType="..CARD_TYPE[self.m_nCurrentType].."&cardNo="..cardNo.."&cardPwd="..cardPwd
    local orderExtra = string.urlencode(str)
    local strPostDataEncrypt = CRechargeManager:getInstance():CreatedOrder(G_CONSTANTS.Recharge_Type.Type_PointCard, self.m_nCurrentMoney, 0 , orderExtra)
    self:goPay(strPostDataEncrypt)
end

function RechargePointView:goPay(strPostDataEncrypt)

    cc.exports.Veil:getInstance():ShowVeil(VEIL_WAIT)
    self.m_pBtnCommint:setEnabled(false)
    local strUrl = ClientConfig:getInstance():getCreateOrderUrl()
    local strPostUrl = string.format("%s?%s", strUrl, strPostDataEncrypt)
    print("\n\n(1)CreatedOrder(1):"..strPostUrl.."\n")
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON 
    xhr:open("POST", strPostUrl)
    local function onReadyStateChange()
        print("Http Status Code:"..xhr.status)
        if(xhr.status == 200) then
            local response = xhr.response
            print("Http Response:"..response)
            if(response ~= nil) then 
                -- 解析json数据
                local ret = SLUtils:aes256Uncrypt(response)
                print("ret:"..ret)
                if G_RechargePointView == nil then
                    return
                end
                local self = G_RechargePointView
                local strRet = self:subResutleString(ret,"}")
                if strRet ~= nil then
                    local httpStartPos,httpEndPos = string.find(response, "{\"")
                    if httpStartPos == 1 then  --兼容老版本,需要简单判断一下是不是json格式
                        print("strRet:"..strRet)
                        local jsonConf = cjson.decode(strRet)
                        local status = tonumber(jsonConf.status)
                        if status == 1 then
                            --交易成功
                            self:cleanEditBox()
                            SLFacade:dispatchCustomEvent(Hall_Events.MSG_QUERY_RECHARGE)
                        end
                        local msg = tostring(jsonConf.msg)
                        FloatMessage.getInstance():pushMessage(msg)
                    end
                end
                self.m_pBtnCommint:setEnabled(true)
                Veil:getInstance():HideVeil(VEIL_WAIT)
            end
        end
        xhr:unregisterScriptHandler()
    end
    xhr:registerScriptHandler(onReadyStateChange) -- 注册脚本方法回调
    xhr:send()-- 发送
end

--function RechargePointView:getBankInfo()
--    if GameListManager.getInstance():getIsLoginGameSucFlag() then
--        CMsgGame:sendBankQueryInsureInfo()
--    else
--        CMsgHall:sendUserQueryInsureInfo()
--    end
--end

--截取开始到最后符合规则的字符串
function RechargePointView:subResutleString(str, strTag)
    
    local ts = string.reverse(str)
    local i, j = string.find(ts, strTag)
    if i == nil then 
        return nil
    end
    local m = string.len(ts) - i + 1
    local str2 = string.sub(str, 1, m)
    return str2
end
----------------------------------
-- ccbi 按纽响应
function RechargePointView:onTypeClicked(index)
    AudioManager:getInstance():playSound("public/sound/sound-button.mp3")
 
    self.m_nCurrentType = index
    for i= 1, 3 do
        if i == index then 
            self.m_pCheckType[i]:setEnabled(false)
        else
            self.m_pCheckType[i]:setEnabled(true)
            self.m_pCheckType[i]:setSelected(false)
        end
    end
    self:updateMoneyByType(self.m_nCurrentType)
end

function RechargePointView:onClickedAdd(index)
    AudioManager:getInstance():playSound("public/sound/sound-button.mp3")
 
    for i= 1, 7 do
        if i == index then 
            self.m_pCheckMoney[i]:setEnabled(false)
        else
            self.m_pCheckMoney[i]:setEnabled(true)
            self.m_pCheckMoney[i]:setSelected(false)
        end
    end
    self.m_nCurrentMoney = MONEY_OPTION[self.m_nCurrentType][index]
end


function RechargePointView:onClickedCommit(pSender)
    AudioManager:getInstance():playSound("public/sound/sound-button.mp3")

    local str = self.m_pEditBox[1]:getText();
    local str2 = self.m_pEditBox[2]:getText();
    if string.len(str) <= 0 then
        FloatMessage.getInstance():pushMessage("STRING_229")
        return;
    end
    if string.len(str2) <= 0 then
        FloatMessage.getInstance():pushMessage("STRING_230")
        return;
    end
    if not self:isMatchCard(str) then 
        FloatMessage.getInstance():pushMessage("STRING_231")
        return;
    end
    if not self:isMatchCard(str2) then 
        FloatMessage.getInstance():pushMessage("STRING_232")
        return;
    end
    
    self:createOrder(str,str2)
end

--是否只包含 数字 字母 下划线 减号
function RechargePointView:isMatchCard(str)

    local strTemp = ""
    for w in string.gmatch(str, "([%w-_])") do
        strTemp = strTemp..w
    end
    local b = string.match(strTemp, str)
    if b == nil then
        return false
    end
    return true
end

return RechargePointView
