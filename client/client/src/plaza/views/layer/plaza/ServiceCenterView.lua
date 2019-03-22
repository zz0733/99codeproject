--region ServiceView.lua
--Desc: 客服中心页面

local ServiceCenterView = class("ServiceCenterView", FixLayer)
--local UsrMsgManager     = require("common.manager.UsrMsgManager")
--local MsgDetailsView    = require("hall.bean.MsgDetailsView")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")   
function ServiceCenterView:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()
    self:init()
end

function ServiceCenterView:onEnter()
    self.super:onEnter()
    self:showWithStyle()
 --   self:setCallBackInOpen(function()
 --      CMsgHall:sendGetFeedBackFinish()
 --   end)

  --   SLFacade:addCustomEventListener(Public_Events.MSG_ENTER_FOREGROUND, handler(self, self.onMsgForeGround), self.__cname)
  --  SLFacade:addCustomEventListener(Hall_Events.MSG_UPDATE_REVERT, handler(self, self.updateListView), self.__cname)
end

function ServiceCenterView:onExit()
    FloatMessage.getInstance():setPosition(0, -330)
    self.super:onExit()
 --   SLFacade:removeCustomEventListener(Public_Events.MSG_ENTER_FOREGROUND, self.__cname)
 --   SLFacade:removeCustomEventListener(Hall_Events.MSG_UPDATE_REVERT, self.__cname)
end

function ServiceCenterView:init()    
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)
    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)
    self.m_rootUIPosX = self.m_rootUI:getPositionX()
    self.m_rootUIPosY = self.m_rootUI:getPositionY()
    --init csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/ServiceCenterView.csb")
    local diffY = (display.height - 750) / 2
    self.m_pathUI:setPositionY(diffY)
    self.m_pathUI:addTo(self.m_rootUI)


    self.m_pNodeRoot    = self.m_pathUI:getChildByName("ServiceCenterView")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    --界面
    self.m_pImageBg     = self.m_pNodeRoot:getChildByName("Image_bg")
    self.m_pBtnClose    = self.m_pImageBg:getChildByName("Node_bg"):getChildByName("BTN_close") 
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))

    self.m_pButtonTable = {}
    for i = 1, 3 do
        self.m_pButtonTable[i] = {}
        self.m_pButtonTable[i].Button = self.m_pImageBg:getChildByName("Panel_button_info" .. i):getChildByName("BTN_info" .. i)
        self.m_pButtonTable[i].Tables = self.m_pImageBg:getChildByName("Panel_button_info" .. i):getChildByName("Image_0")
        if i == 1 then
           local image = "hall/image/file/gui-service-FAQ.png"
           self.m_pButtonTable[i].Tables:loadTexture(image)
        end
        self.m_pButtonTable[i].Normal = self.m_pImageBg:getChildByName("Panel_button_info" .. i):getChildByName("Image_1")
        self.m_pButtonTable[i].Select = self.m_pImageBg:getChildByName("Panel_button_info" .. i):getChildByName("Image_2")

        self.m_pButtonTable[i].Tables:setLocalZOrder(0)
        self.m_pButtonTable[i].Normal:setLocalZOrder(1)
        self.m_pButtonTable[i].Select:setLocalZOrder(2)
    end

    self.m_pNodeInput = self.m_pButtonTable[3].Tables:getChildByName("Node_Input")
    self.m_pNodeList  = self.m_pButtonTable[3].Tables:getChildByName("Node_back")

    self.m_BtnOnlineHelp = self.m_pImageBg:getChildByName("Panel_button_info1"):getChildByName("Btn_onlinehelp")
    self.m_BtnOnlineHelp:addClickEventListener(handler(self, self.onOnlineHelpClicked))

    self.m_pBtnContact = self.m_pButtonTable[3].Tables:getChildByName("Button_commit")
    self.m_pBtnContact:addClickEventListener(handler(self, self.onSubmitClicked))

    self.m_pButtonCopyID = self.m_pImageBg:getChildByName("Node_myinfo"):getChildByName("Button_copyID")
    self.m_pButtonCopyID:addClickEventListener(handler(self, self.onCopyClicked))

    self.Text_myID = self.m_pImageBg:getChildByName("Node_myinfo"):getChildByName("Text_myID")

    self.Text_myID:setString(GlobalUserItem.tabAccountInfo.userid)

    local size = self.m_pNodeList:getContentSize()
    self.size_of_list = cc.size(size.width + 10, size.height)

    self.m_pEditBoxFeedback = nil 
   -- self.m_pTextField = nil
    self.m_pListView = nil

    self:initTouchEvent()

    --self:initTextField()
    self:initEditBox()
    self:initListView()
    self:updateView(1)

    self.m_pWebView = nil
    -- 客服界面
    --self:addWebView()

    --设置位移
    local text1 = self.m_pButtonTable[3].Tables:getChildByName("Node_info"):getChildByName("Text_info_1")
    local text2 = self.m_pButtonTable[3].Tables:getChildByName("Node_info"):getChildByName("Text_info_2")
    local text3 = self.m_pButtonTable[3].Tables:getChildByName("Node_info"):getChildByName("Text_info_3")
    local width1, posX1 = text1:getContentSize().width, text1:getPositionX()
    local width2, posX2 = text2:getContentSize().width, text2:getPositionX()
    local width3, posX3 = text3:getContentSize().width, text3:getPositionX()
    text2:setPositionX(posX1 + width1 + 10)
    text3:setPositionX(posX1 + width1 + 10 + width2 + 10)
    self.m_bInput = false --是否正在输入
    --隐藏在线客服
    --self:hideOnlinekf()
end

function ServiceCenterView:hideOnlinekf()
    local BTN2 = self.m_pImageBg:getChildByName("Panel_button_info2")
    BTN2:setVisible(false)
    self.m_pButtonTable[3].Normal:setPositionY(80)
    self.m_pButtonTable[3].Select:setPositionY(80)
    self.m_pButtonTable[3].Button:setPositionY(80)
end

function ServiceCenterView:initTouchEvent()
    for i= 1, 3 do
        self.m_pButtonTable[i].Button:setZoomScale(0) -- 禁用缩放
        self.m_pButtonTable[i].Button:addTouchEventListener(function(sender, eventType)

            if (i == self.select_type) then
                return
            end

            local txt_img = self.m_pButtonTable[i].Normal:getChildByName("Image_text")
            if eventType==ccui.TouchEventType.began then
                ExternalFun.playClickEffect()
                if txt_img then
                    txt_img:stopAllActions()
                    txt_img:runAction(cc.ScaleTo:create(0.05, 1.05))
                end
            elseif eventType==ccui.TouchEventType.canceled then
                if txt_img then
                    txt_img:stopAllActions()
                    txt_img:setScale(1.0)
                end
            elseif eventType==ccui.TouchEventType.ended then 
                if txt_img then
                    txt_img:stopAllActions()
                    txt_img:setScale(1.0)
                end

                -- 响应选中
                self:onTableClicked(i)
            end
        end)
    end
end

function ServiceCenterView:initEditBox()
    if self.m_pEditBoxFeedback  == nil then
        local editSize = self.m_pNodeInput:getContentSize()
        editSize.width = editSize.width - 10
        editSize.height = editSize.height - 15
        self.m_pEditBoxFeedback = self:createEditBox(150,
                                            cc.KEYBOARD_RETURNTYPE_DONE,
                                            cc.EDITBOX_INPUT_MODE_ANY,
                                            cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD,
                                            0,
                                            editSize,
                                            yl.getLocalString("SUGGEST_1"))
        self.m_pEditBoxFeedback:setAnchorPoint(cc.p(0, 1))
        self.m_pEditBoxFeedback:setPosition(cc.p(5, editSize.height+8))
        self.m_pEditBoxFeedback:registerScriptEditBoxHandler(handler(self, self.onEditBoxEventHandle))
        self.m_pNodeInput:addChild(self.m_pEditBoxFeedback)  
    end
end

function ServiceCenterView:createEditBox(maxLength, keyboardReturnType, inputMode, inputFlag, tag, size, placestr)
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
    --if device.platform ~= "ios" and device.platform ~= "mac" then
    editBox:setPlaceholderFontName("Microsoft Yahei")
    editBox:setPlaceholderFontSize(28)
    editBox:setPlaceholderFontColor(cc.c3b(140,111,83))
    --end
    editBox:setFont("Microsoft Yahei", 28)
    editBox:setFontColor(cc.c3b(108, 57, 29))
        
    -- 模拟点击输入框解决 android 手机首次输入看不到输入内容BUG。
    --[[
    if device.platform == "android" then
      --  self.m_nEditBoxTouchCount = 0
       -- editBox:touchDownAction(editBox,ccui.TouchEventType.ended)
       -- editBox:touchDownAction(editBox,ccui.TouchEventType.canceled)
    else
        self.m_nEditBoxTouchCount = 2
    end
    ]]
    self.m_nEditBoxTouchCount = 0
    return editBox
end

function ServiceCenterView:onEditBoxEventHandle(event, pSender)
    if "began" == event then
        self.m_bInput = true
        if self.m_nEditBoxTouchCount > 1 then
            ExternalFun.playClickEffect()

        end
    elseif "ended" == event then
      --  ActionDelay(self, function()
             self.m_bInput = false
      --  end, 0.5)
        self.m_nEditBoxTouchCount = self.m_nEditBoxTouchCount + 1
    elseif "return" == event then
      --  ActionDelay(self, function()
            self.m_bInput = false
      --  end, 0.5)
    elseif "changed" == event then
    end
end

--function ServiceCenterView:initTextField()

--    local function textFieldEvent(sender, eventType)
--        if eventType == ccui.TextFiledEventType.attach_with_ime then
--            if CommonUtils.getInstance():getPlatformType() == G_CONSTANTS.CLIENT_KIND_IOS then --只有ios才上移界面
--                self.m_rootUI:runAction( cc.MoveTo:create(0.3, cc.p(self.m_rootUIPosX, self.m_rootUIPosY + 300) ) )
--            end
--        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
--            if CommonUtils.getInstance():getPlatformType() == G_CONSTANTS.CLIENT_KIND_IOS then --只有ios才上移界面
--                self.m_rootUI:runAction( cc.MoveTo:create(0.3, cc.p(self.m_rootUIPosX, self.m_rootUIPosY) ) )
--            end
--        elseif eventType == ccui.TextFiledEventType.insert_text then
--        elseif eventType == ccui.TextFiledEventType.delete_backward then
--        end
--    end

--    self.m_pTextField = ccui.TextField:create()
--    self.m_pTextField:setTouchEnabled(true)
--    self.m_pTextField:setFontName("Helvetica")
--    self.m_pTextField:setFontSize(22)
--    self.m_pTextField:setPlaceHolder(LuaUtils.getLocalString("SUGGEST_1"))
--    self.m_pTextField:setPlaceHolderColor(cc.c3b(205, 150, 110))
--    self.m_pTextField:setAnchorPoint(cc.p(0,1))
--    self.m_pTextField:setPosition(cc.p(0, self.m_pNodeInput:getContentSize().height-10))
--    self.m_pTextField:addEventListener(textFieldEvent)
--    self.m_pTextField:setTouchSize(self.m_pNodeInput:getContentSize())
--    self.m_pTextField:ignoreContentAdaptWithSize(false)
--    if CommonUtils.getInstance():getPlatformType() == G_CONSTANTS.CLIENT_KIND_IOS then
--        self.m_pTextField:setSize(self.m_pNodeInput:getContentSize().width, self.m_pNodeInput:getContentSize().height)
--    else
--        self.m_pTextField:setSize(self.m_pNodeInput:getContentSize().width, self.m_pNodeInput:getContentSize().height-20)
--    end
--    self.m_pTextField:setMaxLengthEnabled(true)
--    self.m_pTextField:setMaxLength(150) --设置输入最长限制
--    self.m_pTextField:setTextColor(cc.c3b(255, 140, 20))
--    self.m_pTextField:addTo(self.m_pNodeInput)
--end

function ServiceCenterView:initListView()

    if not self.m_pListView then
        self.m_pListView = ccui.ListView:create()
        self.m_pListView:setGravity(0)
        self.m_pListView:setBounceEnabled(true)
        self.m_pListView:setDirection(ccui.ScrollViewDir.vertical)
        self.m_pListView:setContentSize(self.m_pNodeList:getContentSize().width - 5, self.m_pNodeList:getContentSize().height - 8 )
        self.m_pListView:setPosition(cc.p(0,0))
        self.m_pListView:addTo(self.m_pNodeList)
    end
end


function ServiceCenterView:updateListView()

    Veil:getInstance():HideVeil()

    --删除子项
    self.m_pListView:removeAllItems()

    --初始化内容项
    local count = UsrMsgManager:getInstance():getRevertDataNum()
    for index = 1,count do
        local item = self:initListViewCell(index)
        self.m_pListView:pushBackCustomItem(item)
    end

    --本地保存最后的回复ID
    if count > 0 then 
        local newFeedBack = UsrMsgManager:getInstance():getRevertDataAtIndex(1)
        cc.UserDefault:getInstance():setIntegerForKey("LastFeedBackID", newFeedBack.dwFeedbackID)
    end
end

function ServiceCenterView:initListViewCell(nIdx)

    local tmp = UsrMsgManager.getInstance():getRevertDataAtIndex(nIdx)

    --size
    local cellSize = cc.size(self.m_pNodeList:getContentSize().width, 134.0)
    local bgSize = cc.size(cellSize.width - 10, cellSize.height - 5)

    --cell
    local cell = ccui.Layout:create()
    cell:setContentSize(cellSize)
    cell:setTouchEnabled(true)
    cell:addClickEventListener(function()
        self:TouchListItem(nIdx)
    end)

    --日期文字
    local stringDate = string.format("%d月%d日", tmp.revertDate.wMonth, tmp.revertDate.wDay)
    local stringTime = string.format("%02d:%02d:%02d", tmp.revertDate.wHour, tmp.revertDate.wMinute, tmp.revertDate.wSecond)
    local stringTitle = string.format("%s %s", stringDate, stringTime)
    local lbTitle = cc.Label:createWithSystemFont(stringTitle, "", 24)
    lbTitle:setPosition(5, 85)
    lbTitle:setAnchorPoint(cc.p(0, 0))
    lbTitle:setColor(cc.c3b(108, 57, 29))
    lbTitle:addTo(cell)

    --提示文字
    local lbTip = cc.Label:createWithSystemFont("点击查看详情>>", "", 24)
    lbTip:setPosition(bgSize.width-40, 85)
    lbTip:setAnchorPoint(cc.p(1, 0))
    lbTip:setColor(cc.c3b(255, 102, 0))
    lbTip:addTo(cell)

    --建议内容文字
    local lbText = cc.Label:createWithSystemFont("建议:", "", 26, cc.size(90, 35) )
    lbText:setPosition(5, 35)
    lbText:setAnchorPoint(cc.p(0, 0))
    lbText:setColor(cc.c3b(255, 102, 0))    
    lbText:addTo(cell)

    local strContext = tmp.szFeedBack
    local stringWidth = cellSize.width - 60
    strContext = LuaUtils.getDisplayString(strContext, 26, stringWidth, "...")
    local lbTextFeed = cc.Label:createWithSystemFont(strContext, "", 26, cc.size(800, 35) )
    lbTextFeed:setPosition(70, 35)
    lbTextFeed:setAnchorPoint(cc.p(0, 0))
    lbTextFeed:setColor(cc.c3b(108, 57, 29))    
    lbTextFeed:addTo(cell)

    --回复内容文字
    lbText = cc.Label:createWithSystemFont("回复:", "", 26, cc.size(90, 35) )
    lbText:setPosition(5, 0)
    lbText:setAnchorPoint(cc.p(0, 0))
    lbText:setColor(cc.c3b(202, 23, 27))    
    lbText:addTo(cell)

    strContext = tmp.szRevertBack
    stringWidth = cellSize.width - 60
    strContext = LuaUtils.getDisplayString(strContext, 26, stringWidth, "...")
    local lbTextRevert = cc.Label:createWithSystemFont(strContext, "", 26, cc.size(800, 35) )
    lbTextRevert:setPosition(70, 0)
    lbTextRevert:setAnchorPoint(cc.p(0, 0))
    lbTextRevert:setColor(cc.c3b(108, 57, 29))
    lbTextRevert:addTo(cell)

    --已阅图片
    local pKey = "ReadFeedBack_"..tmp.dwFeedbackID
    local isRead = cc.UserDefault:getInstance():getBoolForKey(pKey, false)
    local spRead = cc.Sprite:createWithSpriteFrameName("hall/plist/help/image-read.png")
    spRead:setPosition(cellSize.width-3, cellSize.height-6)
    spRead:setAnchorPoint(1, 1)
    spRead:setVisible(isRead)
    spRead:setName("Readed")
    spRead:addTo(cell)

    --分隔线
    local spLine = cc.Sprite:createWithSpriteFrameName("hall/plist/help/bgline.png")
    spLine:setPosition(cc.p(0, -10))
    spLine:setAnchorPoint(cc.p(0, 0))
    spLine:addTo(cell)

    return cell
end

function ServiceCenterView:TouchListItem(index)
    --print("TouchListItem index:" .. index)
    if self.m_bInput then return  end   -- 如果正在输入，就不响应

    local tmp = UsrMsgManager.getInstance():getRevertDataAtIndex(index)
    if not tmp then 
        return
    end
    local pMsgDetailsView = self.m_rootUI:getChildByName("MsgDetailsView")
    if pMsgDetailsView then
        pMsgDetailsView:setVisible(true)
        return
    end
    pMsgDetailsView = MsgDetailsView:create()
    pMsgDetailsView:setName("MsgDetailsView")
    pMsgDetailsView:setMsgTableContent(tmp.szFeedBack, tmp.szRevertBack)
    pMsgDetailsView:addTo(self.m_rootUI, Z_ORDER_COMMON)

    --更新为已读
    self:updateItemRead(index)
end

function ServiceCenterView:updateItemRead(index)

    local tmp = UsrMsgManager.getInstance():getRevertDataAtIndex(index)
    if not tmp then 
        return
    end
    local count = UsrMsgManager:getInstance():getRevertDataNum()
    local pKey = "ReadFeedBack_"..tmp.dwFeedbackID
    local isRead = cc.UserDefault:getInstance():getBoolForKey(pKey, false)

    if not isRead then 

        cc.UserDefault:getInstance():setBoolForKey(pKey, true)

        local item = self.m_pListView:getItem(index-1)
        local read = item:getChildByName("Readed")
        read:setVisible(true)

        local pos = self.m_pListView:getInnerContainerPosition()
        local maxY = item:getContentSize().height * count - self.m_pListView:getContentSize().height
        local rate = 100 + (pos.y/maxY)*100
        self.m_pListView:refreshView()
        self.m_pListView:jumpToPercentVertical(rate)
    end

    if UsrMsgManager.getInstance():isHaveNewFeedBack() == false then
        local _event = {
            name = Hall_Events.MSG_UPDATE_REVERT,
            packet = "",
        }
        SLFacade:dispatchCustomEvent(Hall_Events.MSG_UPDATE_REVERT, _event)
    end
end


function ServiceCenterView:onTableClicked(index)

    self.select_type = index
    self:updateView(index)

    FloatMessage.getInstance():clearMessageQueue() --清理一遍浮动提示，避免从中间切换到左边看起奇怪
    if self.select_type == 2 then
        FloatMessage.getInstance():setPosition(-435, -620)
    else
        FloatMessage.getInstance():setPosition(0, -330)
    end
end

function ServiceCenterView:updateView(nType)

    self.select_type = nType

    for i=1, 3 do 
        local bShow = true
        if i == nType then
            bShow = true
        else
            bShow = false 
        end
        if self.m_pButtonTable[i].Normal then
            self.m_pButtonTable[i].Normal:setVisible(true)
        end
        if self.m_pButtonTable[i].Select then
            self.m_pButtonTable[i].Select:setVisible(bShow)
            self.m_pButtonTable[i].Normal:setVisible(not bShow)
        end
        if self.m_pButtonTable[i].Tables then
            self.m_pButtonTable[i].Tables:setVisible(bShow)
        end
    end
    if nType == 1 then
        self.m_BtnOnlineHelp:setVisible( true )
    else
        self.m_BtnOnlineHelp:setVisible( false )
    end

    if nType == 2 then
        self:addWebView()
    else 
        if self.m_pWebView then
            self.m_pWebView:removeFromParent()
            self.m_pWebView = nil
        end
    end
end

function ServiceCenterView:onSubmitClicked(pSender, nType)
    ExternalFun.playClickEffect()
    local curTime = cc.exports.gettime()
    if GlobalUserItem.tabAccountInfo.m_submitSugestTime ~= nil and curTime - GlobalUserItem.tabAccountInfo.m_submitSugestTime < 10 * 60 then
        FloatMessage:getInstance():pushMessage("亲，每十分钟只能提交一次建议，请您稍后再试")
        return --10分钟提交一次
    end

    if self.m_pEditBoxFeedback ~= nil then
        local strText = self.m_pEditBoxFeedback:getText()
        --去掉空格
        strText = string.gsub(strText, "^%s*(.-)%s*$", "%1")
        if string.len(strText) <= 0 then
            FloatMessage:getInstance():pushMessage("请输入内容")
            self.m_pEditBoxFeedback:setText("")
            return
        end
        if string.len(strText) > 255 then
            FloatMessage:getInstance():pushMessage("输入内容太长了，请重新输入")
            return
        end
        print(strText)
        self:sendFeedBack(strText)
        self.m_pEditBoxFeedback:setText("")
       GlobalUserItem.tabAccountInfo.m_submitSugestTime = curTime
    end
end

function ServiceCenterView:sendFeedBack(strText) -- 暂时没有此功能 只做提交成功提示

    FloatMessage.getInstance():pushMessage("您的反馈已经提交成功")

end

function ServiceCenterView:onCopyClicked()
    ExternalFun.playClickEffect()
    local gameId = tostring(GlobalUserItem.tabAccountInfo.userid)
    MultiPlatform.getInstance():copyToClipboard(gameId)
    FloatMessage.getInstance():pushMessage("STRING_204")
end

function ServiceCenterView:onOnlineHelpClicked()
    self:updateView( 2 )
end

function ServiceCenterView:addWebView()

    if device.platform == "windows" then
        return
    end

    if self.m_pWebView then
        self.m_pWebView:removeFromParent()
        self.m_pWebView = nil
    end

    --客服webView
    self.m_pWebView = ccexp.WebView:create()
    self.m_pWebView:setPosition(cc.p(0,0))
    self.m_pWebView:setAnchorPoint(cc.p(0,0))
    self.m_pWebView:setContentSize(cc.size(872, 620))
    self.m_pWebView:setScalesPageToFit(true)
    self.m_pWebView:setOnShouldStartLoading(function(sender, url)
        print("setOnShouldStartLoading, url is ", url)
        return self:onWebViewShouldStartLoading(sender, url)
    end)
    self.m_pWebView:setOnDidFinishLoading(function(sender, url)
        print("setOnDidFinishLoading, url is ", url)
        self:onWebViewDidFinishLoading(sender, url)
    end)
    self.m_pWebView:setOnDidFailLoading(function(sender, url)
        print("setOnDidFailLoading, url is ", url)
        self:onWebViewDidFailLoading(sender, url)
    end)
    self.m_pWebView:setOnJSCallback(function(sender, url)
        print("setOnJSCallback, url is ", url)
        FloatMessage.getInstance():pushMessage("setOnJSCallback, url is:" .. url)
    end)
    self.m_pWebView:addTo(self.m_pButtonTable[2].Tables)

    --open
    local strUrl = "https://chat7.livechatvalue.com/chat/chatClient/chatbox.jsp?companyID=919952&configID=62602&jid=2988069417&s=1"--ClientConfig:getInstance():getChatClientUrl()
    self.m_pWebView:loadURL(strUrl)
end

function ServiceCenterView:onWebViewShouldStartLoading(sender, url)

    if device.platform == "android" then
        if (string.find(url, ".apk")) ~= nil then --跳转
            LuaNativeBridge:getInstance():openURL(url)
            return false  
        end
    end
    return true
end

function ServiceCenterView:onWebViewDidFinishLoading(sender, url)

end

function ServiceCenterView:onWebViewDidFailLoading(sender, url)

end

function ServiceCenterView:onMsgForeGround()
    if self.select_type == 2 then
        self:addWebView()
    end
end

function ServiceCenterView:onReturnClicked(pSender)
   ExternalFun.playClickEffect()
    if self.m_pWebView then
        self.m_pWebView:removeFromParent()
        self.m_pWebView = nil
    end
    self:onMoveExitView()
end

return ServiceCenterView
