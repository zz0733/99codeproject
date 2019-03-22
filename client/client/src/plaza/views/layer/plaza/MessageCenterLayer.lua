--region MessageCenterLayer.lua
--Date 2017.05.01.
--Auther JackyXu.
--Desc: 消息中心 layer.
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local FloatMessage      = cc.exports.FloatMessage
local NoticeDialog      = appdf.req(appdf.CLIENT_SRC.."external.NoticeDialog")
local UsrMsgManager     = appdf.req(appdf.CLIENT_SRC.."external.UsrMsgManager")
local MessageDialog     = appdf.req(appdf.CLIENT_SRC.."external.MessageDialog")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame") 
local MsgCenterKindType = {
        MSG_CENTER_MSG_LIST = 1,             -- 消息列表
        MSG_CENTER_RECOMMEND_LIST = 2,       -- 推荐列表
        MSG_CENTER_COUNT = 3,                -- 类型总数
}
local G_MessageCenterEventTag = "Tag_MessageCenterLayerEvent" -- 注册监听事件 tag

local MessageCenterLayer = class("MessageCenterLayer",FixLayer)

local G_MessageCenterLayer = nil
function MessageCenterLayer.create()
    G_MessageCenterLayer = MessageCenterLayer.new():init()
    return G_MessageCenterLayer
end

function MessageCenterLayer:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_pNodeTable = nil
    self.m_pBtnAllClean = nil
    self.m_pListView = nil
    self.m_nAllMsgNo = -1
    self.m_nKindIndex = MsgCenterKindType.MSG_CENTER_MSG_LIST
    self.m_bIsCanReq = true
    self.m_nLastCount = 0
    self.midNumList = {}     --邮件id列表
    self.Num = 0

    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    local  onUseMessageCallBack = function(result,message)
       self:onUserMessageCallBack(result,message)
    end

    self._plazaFrame = LogonFrame:getInstance()
    self._plazaFrame:setCallBackDelegate(self, onUseMessageCallBack)
end

function MessageCenterLayer:init()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)

    --init csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/MessageCenter.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("HallViewMessageCenter")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    self.m_pImageBg     = self.m_pNodeRoot:getChildByName("Image_bg")
    self.m_pNodeTable   = self.m_pImageBg:getChildByName("Panel_node_table")
    self.m_pBtnAllClean = self.m_pImageBg:getChildByName("Button_deleteAll")
    self.m_pBtnClose    = self.m_pImageBg:getChildByName("Button_close")
    self.m_pNodeNoDetail = self.m_pImageBg:getChildByName("node_noDetails")
    self.m_pLbNotice    = self.m_pNodeNoDetail:getChildByName("Label_noDetailsHint")

    self.m_pBtnAllClean:addClickEventListener(handler(self, self.onDelAllClicked))
    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseClicked))
    
    self.m_pLbNotice:setVisible(false)
    self.m_pBtnAllClean:setEnabled(false)

    
    return self
end

function MessageCenterLayer:onEnter()
    self.super:onEnter()
    self:showWithStyle()

    -- 注册网络监听
--    SLFacade:addCustomEventListener(Hall_Events.GET_LIST_MESSAGE_BACK,  handler(self, self.Handle_Socket_Ack), G_MessageCenterEventTag)
--    SLFacade:addCustomEventListener(Hall_Events.GET_RECOM_MESSAGE_BACK, handler(self, self.Handle_Socket_Ack), G_MessageCenterEventTag)
--    SLFacade:addCustomEventListener(Hall_Events.DEL_MSG_RESULT_BACK,    handler(self, self.Handle_Socket_Ack), G_MessageCenterEventTag)
    -- 注册自定义监听
    SLFacade:addCustomEventListener(Hall_Events.MSG_DEL_ALL_MSG,        handler(self, self.onSureDelAllMsg),   G_MessageCenterEventTag)

--    local curMsgNum = self.getCurContentListNumByType(MsgCenterKindType.MSG_CENTER_MSG_LIST)
--    if curMsgNum > 0 then
--        local nMaxIdx = self:getCurMsgIdByType(self.m_nKindIndex, 1)
--        local pKey = string.format("msgid-max-%d",PlayerInfo.getInstance():getUserID())
--        cc.UserDefault:getInstance():setIntegerForKey(pKey, nMaxIdx)
--        cc.UserDefault:getInstance():flush()
--    end

--    local curSpreadNum = self:getCurContentListNumByType(MsgCenterKindType.MSG_CENTER_RECOMMEND_LIST)
--    if curSpreadNum > 0 then
--        local pKey = string.format("spread-max-%d",PlayerInfo.getInstance():getUserID())
--        cc.UserDefault:getInstance():setIntegerForKey(pKey, curSpreadNum)
--        cc.UserDefault:getInstance():flush()
--    end

--    Veil:getInstance():ShowVeil(VEIL_WAIT)
    --延迟请求防止界面弹出卡顿
    local function funcFi()
        self:updateMinMsgIdx()
        self:initListView()
        self:requestMessagemsg()
    end
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(funcFi)))
end

function MessageCenterLayer:onExit()
    self.super:onExit()

    G_MessageCenterLayer = nil
end

function MessageCenterLayer:Handle_Socket_Ack(_event)
    local _userdata = unpack(_event._userdata)
    if not _userdata then
        return
    end

    Veil:getInstance():HideVeil()

    local eventID = _userdata.name
    local msg = _userdata.packet
    
    self.m_bIsCanReq = true
    if eventID == Hall_Events.GET_LIST_MESSAGE_BACK then
        self:updateListView()
        local count = self:getCurContentListNumByType(self.m_nKindIndex)
        local rate = self.m_nLastCount/count*100
        self.m_pListView:refreshView()
        self.m_pListView:jumpToPercentVertical(rate)
    elseif eventID == Hall_Events.GET_RECOM_MESSAGE_BACK then
        self:updateListView()
    elseif eventID == Hall_Events.DEL_MSG_RESULT_BACK then
        self:onDelMsgBack(msg)
    end
end

function MessageCenterLayer:openSelectSubViewByType(nType)
    if nType == MsgCenterKindType.MSG_CENTER_MSG_LIST then
        self.m_nKindIndex = MsgCenterKindType.MSG_CENTER_MSG_LIST
        self:updateContentByType(self.m_nKindIndex)
    elseif nType == MsgCenterKindType.MSG_CENTER_RECOMMEND_LIST then
        self.m_nKindIndex = MsgCenterKindType.MSG_CENTER_RECOMMEND_LIST
        self:updateContentByType(self.m_nKindIndex)
    end
end

function MessageCenterLayer:updateContentByType(nType)
    self:updateMinMsgIdx()
    
    local curTypeNum = self:getCurContentListNumByType(self.m_nKindIndex)
    -- print("curTypeNum:", curTypeNum)

    if nType == MsgCenterKindType.MSG_CENTER_RECOMMEND_LIST then
        self.m_pBtnAllClean:setVisible(false)
    else
        self.m_pBtnAllClean:setVisible(true)
    end
    
    self:updateListView()
end

function MessageCenterLayer:requestMsgInfo()
    -- body
    local curTypeNum = self:getCurContentListNumByType(self.m_nKindIndex)
    for i=1, curTypeNum do
        if not self:getCurMsgInfoByType(self.m_nKindIndex, i) then
            self.m_nRequestMsgId = self:getCurMsgIdByType(self.m_nKindIndex, i)
            self:getDataFromServerByType(self.m_nKindIndex, self.m_nRequestMsgId)
        end
    end
end

function MessageCenterLayer:updateMinMsgIdx()
    self.m_nAllMsgNo = self:getCurSumNumByType(self.m_nKindIndex)
    if self:getCurContentListNumByType(self.m_nKindIndex) > 0 then
        self.m_nMinMsgIdx = self:getCurMsgIdByType(self.m_nKindIndex,0) - self.m_nAllMsgNo + 1
    end
end

function MessageCenterLayer:initListView()
    -- body
    if not self.m_pListView then
        self.m_pListView = ccui.ListView:create()
        self.m_pListView:setGravity(0)
        self.m_pListView:setBounceEnabled(true)
        self.m_pListView:setDirection(ccui.ScrollViewDir.vertical)
        self.m_pListView:setContentSize(self.m_pNodeTable:getContentSize())
        self.m_pListView:addScrollViewEventListener(handler(self, self.touchListView))
        self.m_pListView:setPosition(cc.p(0,0))
        self.m_pNodeTable:addChild(self.m_pListView, 1000)
    end

    --self:updateListView()
end

function MessageCenterLayer:touchListView(sender, eventType)
    -- 滚动到底部
    if eventType == ccui.ScrollviewEventType.scrollToBottom then
        self.m_nOldMsgNo = self:getCurContentListNumByType(self.m_nKindIndex)
        self.m_nRequestMsgId =  UsrMsgManager.getInstance():getLastReqestMsgID() --self:getCurMsgIdByType(self.m_nKindIndex,self.m_nOldMsgNo-1)

        local curNum = UsrMsgManager.getInstance():getInfoDataCount()
        local totalNum = UsrMsgManager.getInstance():getTotalMsgNo()
        if curNum < totalNum and self.m_bIsCanReq then
            self:getDataFromServerByType(self.m_nKindIndex, self.m_nRequestMsgId)
            self.m_nLastCount = curNum
            self.m_bIsCanReq = false
        end
    elseif eventType == ccui.ScrollviewEventType.scrollToTop then
        print("ccui.ScrollviewEventType.scrollToTop")
    end
end


function MessageCenterLayer:initListViewCell(nIdx)
    -- body
    local cell = ccui.Layout:create()
    cell:setContentSize(cc.size(690, 100))

    -- 画背景
--    if nIdx%2 == 1 then
        local spLine = cc.Sprite:createWithSpriteFrameName("gui-message-center-bg1.png") --"image-msg-bg.png")
        spLine:setPosition(cc.p(10, 0))
        spLine:setAnchorPoint(cc.p(0, 0))
        cell:addChild(spLine)
--    end
    
    local tmp = self:getCurMsgInfoByType(self.m_nKindIndex, nIdx)
    if not tmp then
        return cell
    end

    local stringDate = tmp.tmTime--string.format("%d月%d日 %02d:%02d:%02d", tmp.tmTime.wMonth, tmp.tmTime.wDay, tmp.tmTime.wHour, tmp.tmTime.wMinute,tmp.tmTime.wSecond)
    local lbTitle = cc.Label:createWithSystemFont(stringDate, "Microsoft Yahei", 20)
    lbTitle:setPosition(100, 41)
    lbTitle:setAnchorPoint(cc.p(0, 0))
    lbTitle:setColor(cc.c3b(125,110,79))
    cell:addChild(lbTitle)

    local strType = string.format("%s","[系统]")
    if tmp.dwType == 0 or tmp.dwType == 6 then
        strType = string.format("%s","[系统]")
    elseif tmp.dwType == 1  then
        strType = string.format("%s","[结算]")
    elseif tmp.dwType == 2 or tmp.dwType == 3 then
        strType = string.format("%s","[交互]")
    elseif tmp.dwType == 4 then
        strType = string.format("%s","[个人]")
    elseif tmp.dwType == 5 then
        strType = string.format("%s","[充值]")
    elseif tmp.dwType == 7 then
        strType = string.format("%s","[推广]")
    end
    local str = tmp.strContext
    if yl.getCharLength(tmp.strContext) > 12 then
        str = yl.getDisplayNickName(tmp.strContext, 24, true)
    end
    local strContext = strType .. str
    local lbText = cc.Label:createWithSystemFont(strContext, "Microsoft Yahei", 20)
    lbText:setPosition(100, 6)
    lbText:setAnchorPoint(cc.p(0, 0))
    lbText:setColor(cc.c3b(209,52,52))
    cell:addChild(lbText)
    
    --标识
--    local pKey =  self:getCurReadStateByType(self.m_nKindIndex)
--    local nLastIdx = tmp.msgID + cc.UserDefault:getInstance():getIntegerForKey(pKey, 0)
    local spNew = nil
    if self.m_nKindIndex == MsgCenterKindType.MSG_CENTER_MSG_LIST and tmp.read == 0 then
        --未读
        --spNew = Sprite:createWithSpriteFrameName("gui-news-icon-xin.png")
        spNew = cc.Sprite:createWithSpriteFrameName("gui-message-center-unread.png")--"icon-box-unopen.png")
    else
        --已读
        spNew = cc.Sprite:createWithSpriteFrameName("gui-message-center-read.png")--"icon-box-open.png")
--      spNew = Sprite:createWithSpriteFrameName("gui-news-icon-xin-open.png")
    end
    spNew:setPosition(cc.p(60, 42))
    cell:addChild(spNew)
    
    --delete button
    if self.m_nKindIndex == MsgCenterKindType.MSG_CENTER_RECOMMEND_LIST then
        return
    end

    local btn = ccui.Button:create()
    btn:loadTextureNormal("gui-message-center-delete.png", ccui.TextureResType.plistType) --"bt-text-delete.png"
    btn:addClickEventListener(function(sender)
        self:onDelCurMsgClicked(nIdx)
    end)
    btn:setPosition(cc.p(600,35))
    cell:addChild(btn,5)

    local bGButton = cc.Scale9Sprite:createWithSpriteFrameName("gui-message-null.png")
    local pBgBtn = cc.ControlButton:create(bGButton)
--    pBgBtn:setScrollSwallowsTouches(false)
    pBgBtn:setAnchorPoint(cc.p(0, 0))
    pBgBtn:setPosition(0,0)
    pBgBtn:setPreferredSize(cc.size(671,83))
    local function onButtonClicked(sender)
        
        self:requestRead(tmp.msgID)
    end
    pBgBtn:registerControlEventHandler(onButtonClicked, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
    cell:addChild(pBgBtn)

    return cell
end

function MessageCenterLayer:updateListView()
    --删除子项
    self.m_pListView:removeAllItems()

    --初始化内容项
    local count = self:getCurContentListNumByType(self.m_nKindIndex)
    --UsrMsgManager.getInstance():setTotalMsgNo(count)
    for index =1,count do
        local item = self:initListViewCell(index)
        self.m_pListView:pushBackCustomItem(item)
    end
    -- 设置子项间距
    -- self.m_pListView:setItemsMargin(10.0)

    self.m_pBtnAllClean:setEnabled(count ~= 0)
    
    local str = (nType == MsgCenterKindType.MSG_CENTER_RECOMMEND_LIST and yl.getLocalString("MESSAGE_13") or yl.getLocalString("MESSAGE_3"))
    self.m_pLbNotice:setString(str)
    self.m_pLbNotice:setVisible(count <= 0)
end

function MessageCenterLayer:onDelMsgBack(msg)
    if not msg or not self.m_pListView then 
        return
    end
    
    local nResultNum = tonumber(msg)
    -- print("MessageCenterLayer:onDelMsgBack nResultNum:", nResultNum)
    if 0 == nResultNum then
        self:delMsgInfoByType(self.m_nKindIndex,0,true)
    else
        self:delMsgInfoByType(self.m_nKindIndex,nResultNum,false)
        self:updateMinMsgIdx()
    end

    self:updateListView()
    --[[if (this->isScheduled("reloadtable4") == false ){
        this->scheduleOnce(CC_CALLBACK_1(MsgCenterView::reloadTable2,this), 1.f,"reloadtable4")
    }]]

    -- 刷新大厅小红点
--    local _event = {
--        name = Hall_Events.UPDATA_HALL_MSG_TAG,
--    }
--    SLFacade:dispatchCustomEvent(Hall_Events.UPDATA_HALL_MSG_TAG,_event)
end

function MessageCenterLayer:getCurContentListNumByType(nType)
    local curNum = 0
    if nType == MsgCenterKindType.MSG_CENTER_MSG_LIST then
        curNum = UsrMsgManager.getInstance():getInfoDataCount()
    elseif nType == MsgCenterKindType.MSG_CENTER_RECOMMEND_LIST then
        curNum = UsrMsgManager.getInstance():getSpreadCount()
    end
    return curNum
end

function MessageCenterLayer:getCurMsgIdByType(nType,nIndex)
    local curMsgId = 0
    if nType == MsgCenterKindType.MSG_CENTER_MSG_LIST then
        local msgInfo = UsrMsgManager.getInstance():getInfoAtIndex(nIndex)
        curMsgId = (msgInfo and msgInfo.msgID or 0)
    elseif nType == MsgCenterKindType.MSG_CENTER_RECOMMEND_LIST then
        local msgInfo = UsrMsgManager.getInstance():GetSpreadData(nIndex)
        curMsgId = (msgInfo and msgInfo.msgID or 0)
    end
    return curMsgId
end

function MessageCenterLayer:getCurMsgInfoByType(nType,nIndex)
    local curMsgInfo = nil
    if nType == MsgCenterKindType.MSG_CENTER_MSG_LIST then
        curMsgInfo = UsrMsgManager.getInstance():getInfoAtIndex(nIndex)
    elseif nType == MsgCenterKindType.MSG_CENTER_RECOMMEND_LIST then
        curMsgInfo = UsrMsgManager.getInstance():GetSpreadData(nIndex)
    end
    return curMsgInfo
end

function MessageCenterLayer:getCurSumNumByType(nType)
    local sumNum = 0
    if nType == MsgCenterKindType.MSG_CENTER_MSG_LIST then
        sumNum = UsrMsgManager.getInstance():getTotalMsgNo()
    elseif MsgCenterKindType.MSG_CENTER_RECOMMEND_LIST then
        sumNum = UsrMsgManager.getInstance():getTotalSpreadNo()
    end
    return sumNum
end

function MessageCenterLayer:getDataFromServerByType(nType,nRequestMsgId)
    if nType == MsgCenterKindType.MSG_CENTER_MSG_LIST then
        CMsgHall:sendMsgListGetMessage(nRequestMsgId)

    elseif nType == MsgCenterKindType.MSG_CENTER_RECOMMEND_LIST then
        CMsgHall:sendRecommendGetMessage(nRequestMsgId)
    end
end

function MessageCenterLayer:delMsgInfoByType(nType, nIndex, bIsDelAll)
    if nType == MsgCenterKindType.MSG_CENTER_MSG_LIST then
        if bIsDelAll then
            UsrMsgManager.getInstance():delAllInfoOfVec()
        else
            UsrMsgManager.getInstance():delCurInfoByIndex(nIndex)
        end
    end
end

function MessageCenterLayer:getCurReadStateByType(nType)
    local pStr = ""
    if nType == MsgCenterKindType.MSG_CENTER_MSG_LIST then
        pStr = string.format("msgid-max-%d",123456)--PlayerInfo.getInstance():getUserID())
    elseif nType == MsgCenterKindType.MSG_CENTER_RECOMMEND_LIST then
        pStr = string.format("spread-max-%d",123456)--PlayerInfo.getInstance():getUserID())
    end

    return pStr
end

-- 确认删除所有消息
function MessageCenterLayer:onSureDelAllMsg(_event)
    self.m_bIsCanReq = false
    for i = 1, #self.midNumList do
        local midNum = self.midNumList[i]
        self.Num = 0
        self:requestDelete(midNum)
    end
    
    
--    CMsgHall:sendDelMessage(-1)
end

---------------------------------------------
-- 按纽响应
-- 返回
function MessageCenterLayer:onCloseClicked()
   ExternalFun.playClickEffect()
    -- body
--    if self:getCurContentListNumByType(MsgCenterKindType.MSG_CENTER_MSG_LIST) then
--        local nMaxIdx = self:getCurMsgIdByType(MsgCenterKindType.MSG_CENTER_MSG_LIST,1)

--        local pKey = string.format("msgid-max-%d",PlayerInfo.getInstance():getUserID())
--        cc.UserDefault:getInstance():setIntegerForKey(pKey, nMaxIdx)
--        cc.UserDefault:getInstance():flush()

--        -- 刷新大厅小红点
--        local _event = {
--            name = Hall_Events.UPDATA_HALL_MSG_TAG,
--        }
--        SLFacade:dispatchCustomEvent(Hall_Events.UPDATA_HALL_MSG_TAG,_event)
--    end

--    local curSpreadNum = self:getCurContentListNumByType(MsgCenterKindType.MSG_CENTER_RECOMMEND_LIST)
--    if curSpreadNum then
--        local pKey = string.format("spread-max-%d",PlayerInfo.getInstance():getUserID())
--        cc.UserDefault:getInstance():setIntegerForKey(pKey, curSpreadNum)
--        cc.UserDefault:getInstance():flush()

--        -- MsgCenter:getInstance():postMsg(MSG_UPDATE_USR_SPREAD_INFO, nullptr)
--    end
    
    self:onMoveExitView()
end

-- 删除
function MessageCenterLayer:onDelCurMsgClicked(nIndex)
   ExternalFun.playClickEffect()
    -- body
    -- print("MessageCenterLayer:onDelCurMsgClicked", nIndex)
    if nIndex <= self:getCurContentListNumByType(self.m_nKindIndex) then
        -- if not self.m_bIsCanReq then
        --     return
        -- end
        local iMsgID = self:getCurMsgIdByType(self.m_nKindIndex,nIndex)
        -- self.m_bIsCanReq = false
        local midNum = self.midNumList[nIndex]
        self.Num = nIndex
        self:requestDelete(midNum)
--        CMsgHall:sendDelMessage(iMsgID)
    end
end

-- 一键删除
function MessageCenterLayer:onDelAllClicked()
   ExternalFun.playClickEffect()
    if self:getCurContentListNumByType(self.m_nKindIndex) == 0 then
        FloatMessage.getInstance():pushMessage("STRING_044")
        return
    end
    
    -- notice delete all.
    if self.m_rootUI:getChildByName("NoticeDialog") then
        self.m_rootUI:getChildByName("NoticeDialog"):setVisible(true)
        return
    end
    local pNoticeDlg = NoticeDialog.create()
    pNoticeDlg:setName("NoticeDialog")
    pNoticeDlg:setNoticeType(12)
    self.m_rootUI:addChild(pNoticeDlg, 20)
end

function MessageCenterLayer:onMsgClicked(msg)
    ExternalFun.playClickEffect()
    local pNoticeDlg = MessageDialog.create()
    pNoticeDlg:setName("MessageDialog")
    pNoticeDlg:setMsgText(msg)
    self.m_rootUI:addChild(pNoticeDlg, 20)
end

 --请求消息数据
function MessageCenterLayer:requestMessagemsg()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "mail_list"
    msgta["body"] = {}
    msgta["body"]["box"] = "in"
    msgta["body"]["pageindex"] = 1
    msgta["body"]["pagesize"] = 7
    msgta["body"]["type"] = -1
    msgta["body"]["status"] = -1

    LogonFrame:sendGameData(msgta)
    dump(msgta)
end
--读邮件
function MessageCenterLayer:requestRead(mid)
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "mail_read"
    msgta["body"] = {}
    msgta["body"]["mid"] = mid

    LogonFrame:sendGameData(msgta)
    dump(msgta)
end
--删除邮件
function MessageCenterLayer:requestDelete(mid)
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "mail_delete"
    msgta["body"] = {}
    msgta["body"]["mid"] = mid
    
    LogonFrame:sendGameData(msgta)
    dump(msgta)
end
--发邮件
function MessageCenterLayer:requestWrite(nickname,title,content)
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "mail_write"
    msgta["body"] = {}
    msgta["body"]["to_nickname"]  = nickname         --收件人昵称
    msgta["body"]["mail_title"]   = title            --邮件标题
    msgta["body"]["mail_content"] = content          --邮件内容

    LogonFrame:sendGameData(msgta)
    dump(msgta)
end
 --消息请求回调
function MessageCenterLayer:onUserMessageCallBack(result,message)
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
    if type(message) == "table" then
        if message.tag == "mail_list" then                --加载
            if message.result == "ok" then    
                self:receiveMessages(message.body)
            end 
        elseif message.tag == "mail_delete" then          --删除
            if message.result == "ok" then    
                self:deleteMessages(message.body)
            else
                    
            end 
        elseif message.tag == "mail_read" then            --读取
            if message.result == "ok" then    
                local strContext = message.body
                self:onMsgClicked(strContext)
            end 
        elseif message.tag == "mail_write" then           --编写
            if message.result == "ok" then    

            end 
        end
    end
end
--消息处理
function MessageCenterLayer:receiveMessages(_data)
    if _data.page.total == 0 and _data.page.pagecount == 0 then
        FloatMessage:getInstance():pushMessage("暂无消息")
        return
    end
    UsrMsgManager.getInstance():setLastReqestMsgID(_data.data[#_data.data].id)
--    UsrMsgManager.getInstance():setTotalMsgNo(msg.total)

    for i = 1,#_data.data do
        local msgInfo = {}
        msgInfo.msgID = _data.data[i].id
        table.insert(self.midNumList,_data.data[i].id)
        msgInfo.dwType = _data.data[i].mail_type  -- {0~7}
        msgInfo.strContext = _data.data[i].title
        msgInfo.read = _data.data[i].read
        msgInfo.tmTime = _data.data[i].send_time
--        msgInfo.tmTime = {}
--        msgInfo.tmTime.wMonth = 01
--        msgInfo.tmTime.wDay = 08
--        msgInfo.tmTime.wHour = 15
--        msgInfo.tmTime.wMinute = 03
--        msgInfo.tmTime.wSecond = 32
        UsrMsgManager.getInstance():addInfo(msgInfo)
    end

--    UsrMsgManager.getInstance():addSpreadData({123456,"666",20181213})

    self:updateListView()
end

function MessageCenterLayer:deleteMessages(_data)
    if _data ~= "成功" then
        return
    end

    self:onDelMsgBack(self.Num)
    table.remove(self.midNumList,self.Num)       
    FloatMessage:getInstance():pushMessage("删除".._data)
end
return MessageCenterLayer
