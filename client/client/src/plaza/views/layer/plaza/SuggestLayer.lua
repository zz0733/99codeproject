--region *.lua
--Date
--Desc 推广页面
--此文件由[BabeLua]插件自动生成

local SuggestLayer = class("SuggestLayer", FixLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local UsrMsgManager     = appdf.req(appdf.CLIENT_SRC.."external.UsrMsgManager")
local MsgDetailsView    = appdf.req(appdf.PLAZA_VIEW_SRC .. "MsgDetailsView")
appdf.req(appdf.CLIENT_SRC.."external.LuaUtils")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame") 
function SuggestLayer:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self:init()

    local  onUseSuggestCallBack = function(result,message)
       self:onUserSuggestCallBack(result,message)
    end
    --大厅网络处理
    self._plazaFrame = LogonFrame:getInstance()
    self._plazaFrame:setCallBackDelegate(self, onUseSuggestCallBack)
end

function SuggestLayer:onEnter()
    self.super:onEnter()
    self:showWithStyle()

    self.update_listener = SLFacade:addCustomEventListener(Hall_Events.MSG_UPDATE_REVERT, handler(self, self.updateListView), self.__cname)


--    Veil:getInstance():ShowVeil(VEIL_WAIT)

    --等动画弹出再请求
--    ActionDelay(self, function()
--       CMsgHall:sendGetFeedBackFinish()
--    end, 0.2) 
end

function SuggestLayer:onExit()
    self.super:onExit()

--    Veil:getInstance():HideVeil()

    SLFacade:removeEventListener(self.update_listener)
end

function SuggestLayer:init()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)

    --Root
    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    --csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/SuggestView.csb")
    self.m_pathUI:addTo(self.m_rootUI)

    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("SuggestView")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    --界面
    self.m_pImageBg     = self.m_pNodeRoot:getChildByName("Image_bg")
    self.m_pBtnClose    = self.m_pImageBg:getChildByName("Node_bg"):getChildByName("BTN_close") 
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))

    self.m_pButtonTable = {}
    for i = 1, 2 do
        self.m_pButtonTable[i] = {}
        self.m_pButtonTable[i].Button = self.m_pImageBg:getChildByName("Panel_button_info" .. i):getChildByName("BTN_info" .. i)
        self.m_pButtonTable[i].Tables = self.m_pImageBg:getChildByName("Panel_button_info" .. i):getChildByName("Image_0")
        self.m_pButtonTable[i].Normal = self.m_pImageBg:getChildByName("Panel_button_info" .. i):getChildByName("Image_1")
        self.m_pButtonTable[i].Select = self.m_pImageBg:getChildByName("Panel_button_info" .. i):getChildByName("Image_2")
    end

    self.m_pNodeInput = self.m_pButtonTable[1].Tables:getChildByName("Node_Input")
    self.m_pNodeList  = self.m_pButtonTable[2].Tables:getChildByName("Node_back")

    self.m_pImageBg:getChildByName("Panel_button_info2"):setVisible(false)

    self.m_pBtnContact = self.m_pButtonTable[1].Tables:getChildByName("BTN_contact")
    self.m_pBtnContact:addClickEventListener(handler(self, self.onSubmitClicked))

    local size = self.m_pNodeList:getContentSize()
    self.size_of_list = cc.size(size.width + 10, size.height)

    self.m_pTextField = nil
    self.m_pListView = nil

    self:initRichText()
    self:initTouchEvent()

    self:initTextField()
    self:initListView()

    self:updateView(1)
    self:updateListView()
    UsrMsgManager.getInstance():clearRevertData()
    --测试数据
--    local msg = {};
--    for i = 1, 3 do
--        msg[i] = {}
--        msg[i].dwFeedbackID = 1                 --已阅
--        msg[i].szRevertBack = "你就是个蛇精病"   --内容
--        msg[i].szFeedBack = "该吃点药"               --建议
--        msg[i].revertDate = {}
--        msg[i].revertDate.wMonth  = 01
--        msg[i].revertDate.wDay    = 09
--        msg[i].revertDate.wHour   = 16
--        msg[i].revertDate.wMinute = 26
--        msg[i].revertDate.wSecond = 22
--        UsrMsgManager.getInstance():addRevertData(msg[i])  --客服回复数据
--    end
end

function SuggestLayer:initRichText()

    local Node_Tips = self.m_pImageBg:getChildByName("Node_bg"):getChildByName("Node_Tips")

    local nGold = 2000.0 --奖励金币

    local Text_tips1 = Node_Tips:getChildByName("Text_tips1") --我们
    local Text_tips2 = Node_Tips:getChildByName("Text_tips2") --将会
    local Text_tips3 = Node_Tips:getChildByName("Text_tips3") --2000
    local Text_tips4 = Node_Tips:getChildByName("Text_tips4") --游戏

    local string1 = yl.getLocalString("SUGGEST_2") --我们
    local string2 = yl.getLocalString("SUGGEST_3") --将会
    local string3 = string.format(" %0.2f ", nGold)      --2000
    local string4 = yl.getLocalString("SUGGEST_4") --游戏

    local name_text = Text_tips1:getFontName()      --字体名字
    local size_text = Text_tips1:getFontSize()      --字体大小
    local posX, posY = Text_tips2:getPosition()     --字体坐标
    local color_text = Text_tips1:getTextColor()    --字体颜色
    local color_gold = Text_tips3:getTextColor()    --金币颜色

    --保留第一行，删掉第二行
    Text_tips1:setString(string1)
    Text_tips2:removeFromParent()
    Text_tips3:removeFromParent()
    Text_tips4:removeFromParent()

    --富文本文字
    local pRichText = ccui.RichText:create()
    pRichText:setPosition(posX, posY)
    pRichText:setAnchorPoint(0, 0)
    pRichText:addTo(Node_Tips)

    --第二行文字
    local richStr1 = ccui.RichElementText:create(0, color_text, 255, string2, name_text, size_text)
    local richStr2 = ccui.RichElementText:create(1, color_gold, 255, string3, name_text, size_text)
    local richStr3 = ccui.RichElementText:create(2, color_text, 255, string4, name_text, size_text)
    pRichText:pushBackElement(richStr1)
    pRichText:pushBackElement(richStr2)
    pRichText:pushBackElement(richStr3)
end

function SuggestLayer:initTouchEvent()
    for i= 1, 2 do
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

function SuggestLayer:initTextField()

    local function textFieldEvent(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then

        elseif eventType == ccui.TextFiledEventType.detach_with_ime then

        elseif eventType == ccui.TextFiledEventType.insert_text then

        elseif eventType == ccui.TextFiledEventType.delete_backward then

        end
    end

    self.m_pTextField = ccui.TextField:create()
    self.m_pTextField:setTouchEnabled(true)
    self.m_pTextField:setFontName("Helvetica")
    self.m_pTextField:setFontSize(22)
    self.m_pTextField:setPlaceHolder(yl.getLocalString("SUGGEST_1"))
    self.m_pTextField:setPlaceHolderColor(cc.c3b(205, 150, 110))
    self.m_pTextField:setAnchorPoint(cc.p(0,1))
    self.m_pTextField:setPosition(cc.p(0, self.m_pNodeInput:getContentSize().height))
    self.m_pTextField:addEventListener(textFieldEvent)
    self.m_pTextField:setTouchSize(self.m_pNodeInput:getContentSize())
    self.m_pTextField:ignoreContentAdaptWithSize(false)
    self.m_pTextField:setSize(self.m_pNodeInput:getContentSize())
    self.m_pTextField:setMaxLengthEnabled(true)
    self.m_pTextField:setMaxLength(250) --设置输入最长限制
    self.m_pTextField:setTextColor(cc.c3b(255, 140, 20))
    self.m_pTextField:addTo(self.m_pNodeInput)
end

function SuggestLayer:initListView()

    if not self.m_pListView then
        self.m_pListView = ccui.ListView:create()
        self.m_pListView:setGravity(0)
        self.m_pListView:setBounceEnabled(true)
        self.m_pListView:setDirection(ccui.ScrollViewDir.vertical)
        self.m_pListView:setContentSize(self.m_pNodeList:getContentSize())
        self.m_pListView:setPosition(cc.p(0,0))
        self.m_pListView:addTo(self.m_pNodeList)
    end
end


function SuggestLayer:updateListView()

--    Veil:getInstance():HideVeil()

    --删除子项
    self.m_pListView:removeAllItems()

    --初始化内容项
    local count = UsrMsgManager:getInstance():getRevertDataNum()
    for index = 1,count do
        local item = self:initListViewCell(index)
        self.m_pListView:pushBackCustomItem(item)
    end

    --本地保存最后的回复ID
--    if count > 0 then 
--        local newFeedBack = UsrMsgManager:getInstance():getRevertDataAtIndex(1)
--        cc.UserDefault:getInstance():setIntegerForKey("LastFeedBackID", newFeedBack.dwFeedbackID)
--    end
end


function SuggestLayer:initListViewCell(nIdx)
    local tmp = UsrMsgManager.getInstance():getRevertDataAtIndex(nIdx)

    --size
    local cellSize = cc.size(self.m_pNodeList:getContentSize().width, 120.0)
    local bgSize = cc.size(cellSize.width - 20, cellSize.height - 5)

    --cell
    local cell = ccui.Layout:create()
    cell:setContentSize(cellSize)
    cell:setTouchEnabled(true)
    cell:addClickEventListener(function()
        self:TouchListItem(nIdx)
    end)

    --框
    local spBg = cc.Scale9Sprite:createWithSpriteFrameName("image-gai-message.png")
    spBg:setPosition(cc.p(10, 0))
    spBg:setAnchorPoint(cc.p(0, 0))
    spBg:setPreferredSize(bgSize)
    spBg:setInsetTop(20)
    spBg:setInsetBottom(20)
    spBg:setInsetLeft(30)
    spBg:setInsetRight(30)
    spBg:addTo(cell)

    --日期文字
    local stringDate = string.format("%d月%d日", tmp.revertDate.wMonth, tmp.revertDate.wDay)
    local stringTime = string.format("%02d:%02d:%02d", tmp.revertDate.wHour, tmp.revertDate.wMinute, tmp.revertDate.wSecond)
    local stringTitle = string.format("%s %s", stringDate, stringTime)
    local lbTitle = cc.Label:createWithSystemFont(stringTitle, "", 22)
    lbTitle:setPosition(30, 65)
    lbTitle:setAnchorPoint(cc.p(0, 0))
    lbTitle:setColor(cc.c3b(255, 140, 15))
    lbTitle:addTo(cell)

    --提示文字
    local lbTip = cc.Label:createWithSystemFont("点击查看详情", "", 22)
    lbTip:setPosition(bgSize.width - 100, 65)
    lbTip:setAnchorPoint(cc.p(1, 0))
    lbTip:setColor(cc.c3b(255, 140, 20))
    lbTip:addTo(cell)

    --内容文字
    local strContext = tmp.szRevertBack
    local stringWidth = cellSize.width - 150
    strContext = LuaUtils.getDisplayString(strContext, 24, stringWidth, "...")
    local lbText = cc.Label:createWithSystemFont(strContext, "", 24)
    lbText:setPosition(30, 20)
    lbText:setAnchorPoint(cc.p(0, 0))
    lbText:setColor(cc.c3b(120, 80, 30))
    lbText:addTo(cell)

    --已阅图片
    local pKey = "ReadFeedBack_"..tmp.dwFeedbackID
    local isRead = cc.UserDefault:getInstance():getBoolForKey(pKey, false)
    local spRead = cc.Sprite:createWithSpriteFrameName("icon-gai-yue.png")
    spRead:setPosition(cellSize.width - 60, cellSize.height / 2)
    spRead:setAnchorPoint(0.5, 0.5)
    spRead:setVisible(isRead)
    spRead:setName("Readed")
    spRead:addTo(cell)

    return cell
end


function SuggestLayer:TouchListItem(index)
 --print("TouchListItem index:" .. index)
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

function SuggestLayer:updateItemRead(index)

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
--        self.m_pListView:refreshView()
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

function SuggestLayer:onReturnClicked()
  ExternalFun.playClickEffect()

    self:onMoveExitView()
end

function SuggestLayer:onTableClicked(index)

    self.select_type = index
    self:updateView(index)
end

function SuggestLayer:updateView(nType)

    self.select_type = nType

    local bShow1 = (self.select_type == 1)
    local bShow2 = (self.select_type == 2)

    self.m_pButtonTable[1].Normal:setVisible(bShow2)
    self.m_pButtonTable[1].Select:setVisible(bShow1)
    self.m_pButtonTable[1].Tables:setVisible(bShow1)

    self.m_pButtonTable[2].Normal:setVisible(bShow1)
    self.m_pButtonTable[2].Select:setVisible(bShow2)
    self.m_pButtonTable[2].Tables:setVisible(bShow2)
end

function SuggestLayer:onSubmitClicked(pSender, nType)
   ExternalFun.playClickEffect()

    if self.m_pTextField ~= nil then
        local strText = self.m_pTextField:getString()
        --去掉空格
        strText = string.gsub(strText, "^%s*(.-)%s*$", "%1")
        if string.len(strText) <= 0 then
            FloatMessage:getInstance():pushMessage("请输入内容")
            self.m_pTextField:setText("")
            return
        end
        if string.len(strText) > 255 then
            FloatMessage:getInstance():pushMessage("输入内容太长了，请重新输入")
            return
        end
        print(strText)
        self:sendFeedBack(strText)
        self.m_pTextField:setText("")
    end
end

--建议请求
function SuggestLayer:sendFeedBack(str)
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "mail_write"
    msgta["body"] = {}
    msgta["body"]["to_nickname"] = ""
    msgta["body"]["mail_title"] = "mTitle"
    msgta["body"]["mail_content"] = str
    msgta["body"]["mail_type"] = 2
    dump(msgta)
    self._plazaFrame:sendGameData(msgta)
end


--建议请求下发回调
function SuggestLayer:onUserSuggestCallBack(result,message)
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
    if type(message) == "table" then
        if message.tag == "mail_list" then
            if message.result == "ok" then
                local msg = {};
                msg.dwFeedbackID = 1                 --已阅
                msg.szRevertBack = "你就是个蛇精病"   --内容
                msg.szFeedBack = "该吃点药"               --建议
--                msg.tmTime =                        --时间
                msg.revertDate = {}
                msg.revertDate.wMonth  = 01
                msg.revertDate.wDay    = 09
                msg.revertDate.wHour   = 16
                msg.revertDate.wMinute = 26
                msg.revertDate.wSecond = 22
                UsrMsgManager.getInstance():addRevertData(msg)  --客服回复数据
            end
        elseif  message.tag == "mail_write" then    
            
            if message.result == "ok" then
                 FloatMessage:getInstance():pushMessage("建议提交"..message.body)     
            else
                 FloatMessage:getInstance():pushMessage(message.result)
            end
        end
    end
end


return SuggestLayer
--endregion
