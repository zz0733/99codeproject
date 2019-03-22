--region AnnouncementCenter.lua

local TAG_NOTICE = 1
local TAG_SYSTEM = 2

local ALL_MSG_DELETE = -1 --所有消息

local STATUS_UNREAD = 0 --未读状态
local STATUS_READ   = 1 --已读状态
local STATUS_DELETE = 2 --删除状态

local MSG_NODE_TAG = 199

local UsrMsgManager     = appdf.req(appdf.EXTERNAL_SRC .. "UsrMsgManager")
local CBroadcastManager = appdf.req(appdf.EXTERNAL_SRC .. "CBroadcastManager")
local AnnouncementMsg   = appdf.req(appdf.PLAZA_VIEW_SRC .. "bean.AnnouncementMsg")
local MessageDialog     = appdf.req(appdf.EXTERNAL_SRC .. "MessageDialog")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame") 

local AnnouncementCenter = class("AnnouncementCenter", FixLayer)

function AnnouncementCenter:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.event_ = {}
    self.m_pNodeButton = {}
    self.m_pButton = {}
    self.m_SelectIndex = TAG_NOTICE
    self.strContext = ""
    self.m_vecTableSelecet = {}
    self.m_bIsCanReq = true
    self.m_nLastMsgCount = 0
    self.m_nRequestDelCount = 0
    self.Num = 0
    self.m_pTableView = nil
    self.midNumList = {}
    local  onUseMessageCallBack = function(result,message)
       self:onUserMessageCallBack(result,message)
    end

    self._plazaFrame = LogonFrame:getInstance()
    self._plazaFrame:setCallBackDelegate(self, onUseMessageCallBack)

    self:init()
end

function AnnouncementCenter:onEnter()
    self.super:onEnter()

    --加载公告列表
    self:requestMessagemsg()
    --遮罩
     SLFacade:addCustomEventListener("SHANCHU", handler(self, self.sendDeleteNoticeByID ), self.__cname)
    --弹窗
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)
    
    self:showWithStyle()
end

function AnnouncementCenter:onExit()
    SLFacade:removeCustomEventListener("SHANCHU", self.__cname)
    --清理
    self:clean()

    self.super:onExit()
end

function AnnouncementCenter:init()
    self:initCSB()
    self:initTableView()  
end

function AnnouncementCenter:clean()
    self:updateHallMsg()
end

function AnnouncementCenter:initCSB()

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    --csb
    self.m_pathUI = cc.CSLoader:createNode("dt/MailView.csb")
    self.m_pathUI:setPositionY((display.height - 750) / 2)
    self.m_pathUI:addTo(self.m_rootUI)

    --offset
    self.m_pNodeRoot = self.m_pathUI:getChildByName("center")
    self.m_pNodeRoot:setPositionX((display.width ) / 2)
    --Bg
    self.m_pImageBg      = self.m_pNodeRoot:getChildByName("image_Bg") 
    self.m_pBgPanel       = self.m_pImageBg:getChildByName("panel_answerPanel") -- 基础容器
    self.m_pBtnReturn  = self.m_pImageBg:getChildByName("button_closeBtn") -- 关闭
    self.m_pBgtishi = self.m_pBgPanel:getChildByName("text_mailtishi")          -- 提示
    self.m_pNodetable = self.m_pBgPanel:getChildByName("Node_table")   -- listView容器

    self.m_pBtnReturn:addClickEventListener(handler(self, self.onReturnClicked))
end


--系统消息列表
function AnnouncementCenter:initTableView()

    self.m_pTableView = cc.TableView:create(cc.size(937,510))
    self.m_pTableView:setAnchorPoint(cc.p(0,0))
    self.m_pTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.m_pTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.m_pTableView:setDelegate()

    self.m_pTableView:registerScriptHandler(handler(self,self.cellSizeForTable), CCTableView.kTableCellSizeForIndex)
    self.m_pTableView:registerScriptHandler(handler(self,self.tableCellAtIndex), CCTableView.kTableCellSizeAtIndex)
    self.m_pTableView:registerScriptHandler(handler(self,self.numberOfCellsInTableView), CCTableView.kNumberOfCellsInTableView)
    self.m_pTableView:registerScriptHandler(handler(self,self.tableCellTouched), CCTableView.kTableCellTouched)
    self.m_pTableView:registerScriptHandler(handler(self,self.scrollViewDidScroll), CCTableView.kTableViewScroll)
    self.m_pNodetable:addChild(self.m_pTableView)
end

function AnnouncementCenter:cellSizeForTable(table, idx)
    
    return 920, 110
end

function AnnouncementCenter:tableCellAtIndex(table, idx)
    local cell = table:cellAtIndex(idx)
    if not cell then
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end

    self:initTableViewCell(cell, idx)
    return cell
end

function AnnouncementCenter:numberOfCellsInTableView(table)

    local nCount = self:getMsgCount()
    return nCount
end

function AnnouncementCenter:tableCellTouched(table, cell)

    local nIdx = cell:getTag()+1
    self.Num = nIdx
--    self:requestRead(self.midNumList[nIdx])
    self:showMsgView(1)
end

function AnnouncementCenter:initTableViewCell(cell, nIdx)

    cell:setTag(nIdx)
    local msgNode = self:getMessageNode(nIdx+1)
    msgNode:setTag(MSG_NODE_TAG)
    cell:addChild(msgNode)
    if self.m_SelectIndex == TAG_NOTICE then
        local msg = CBroadcastManager.getInstance():getBroadcastDetailsInfoAtIndex(nIdx+1)
        self:setNoticeNode(msgNode, msg, nIdx+1, self.m_vecTableSelecet[nIdx + 1])
    end
end

function AnnouncementCenter:scrollViewDidScroll(pView)

end

function AnnouncementCenter:getMsgCount()
    if self.m_SelectIndex == TAG_NOTICE then 
        return CBroadcastManager.getInstance():getBroadcastDetailsCount()
    end
end

function AnnouncementCenter:getMsgTotal()
    if self.m_SelectIndex == TAG_NOTICE then 
        return CBroadcastManager.getInstance():getBroadcastDetailsCount()
    end
end

function AnnouncementCenter:__click__() end

function AnnouncementCenter:onReturnClicked() -- 关闭
    ExternalFun.playClickEffect()
    
    self:onMoveExitView()
end

function AnnouncementCenter:onDeleteClicked() --删除消息
    ExternalFun.playClickEffect()

        self.m_nRequestDelCount = 0
        local nCount = self:getMsgTotal()
        for i=1, nCount do
            if self.m_vecTableSelecet[i] then
                self:sendDelMsgAtIndex(i)
                self.m_nRequestDelCount = self.m_nRequestDelCount+1
            end
        end
        if self.m_nRequestDelCount > 0 then 
--            Veil:getInstance():ShowVeil(VEIL_LOCK)
        end
end

function AnnouncementCenter:onTagClicked(sender) --打开消息
    ExternalFun.playClickEffect()

    local tag = sender:getTag()

    self.m_SelectIndex = tag

    self.m_nLastMsgCount = 0

    --更新默认图标
    self:onUpdateImageSelect(false)

    --更新按钮
    self:onUpdateButtonStatus(tag)

    --更新列表
    self:onUpdateListView(tag)

    --遮罩
end


function AnnouncementCenter:onUpdateImageSelect(bSelect) --更选中图片
    self.m_pImageSelect:setVisible(bSelect)
end

function AnnouncementCenter:onUpdateImageNone(bNone) --更新暂无图片
--    self.m_pImageNone:setVisible(bNone)
end

function AnnouncementCenter:onUpdateListView(tag) --更新列表

    self.m_nRequestDelCount = 0
    --重置选中状态
    self.m_vecTableSelecet = {}
    local total = self:getMsgTotal()
    for i=1,total do 
        self.m_vecTableSelecet[i] = false
    end
    local nCount = self:getMsgCount()
    self.m_pTableView:reloadData()
    --更新暂无消息
    self:onUpdateImageNone(total == 0)
end

function AnnouncementCenter:onUpdateSelectAll() --根据列表选中情况，更新全选

    local count = 0
    local bVisible = false
    local total = self:getMsgTotal()
    for i=1, table.nums(self.m_vecTableSelecet) do
        if self.m_vecTableSelecet[i] then 
            count = count+1
        end
    end
    bVisible = (count == total)

    self:onUpdateImageSelect(bVisible)
end

function AnnouncementCenter:showMsgView(nIdx)

    print("showMsgView :", nIdx)

    if self.m_SelectIndex == TAG_NOTICE then 
        --打开公告
        local msg = CBroadcastManager.getInstance():getBroadcastDetailsInfoAtIndex(nIdx)
        self.msgID = msg.dwAnnounceID
        msg.content = self.strContext
        self:onShowNotice(msg)
    end
end

function AnnouncementCenter:updateHallMsg()
--    SLFacade:dispatchCustomEvent(Hall_Events.UPDATA_HALL_MSG_TAG)
end

function AnnouncementCenter:__item__() end

function AnnouncementCenter:getMessageNode(tag) --创建消息item

    local msgNode = ccui.Layout:create()
    msgNode:setContentSize(cc.size(920, 110))
    msgNode:setCascadeOpacityEnabled(true)

    --item
    local strPath = "dt/Mailitem.csb"
    local item = cc.CSLoader:createNode(strPath)
    item:setCascadeOpacityEnabled(true)
    item:addTo(msgNode)

    --node
    local node          = item:getChildByName("Panel_1")
--    local btn_select    = node:getChildByName("image_item")
    local image_select  = node:getChildByName("image_bgUnread")
    local image_open    = node:getChildByName("image_flagMail")
--    local text_msg      = node:getChildByName("Text_msg")
    local text_title    = node:getChildByName("text_yjbt")
    local text_time     = node:getChildByName("text_timeLabel")
    local text_view     = node:getChildByName("image_content")
    local image_read    = node:getChildByName("image_readFlag")

    --init
--    msgNode.btn_select      = btn_select    --选中按钮
    msgNode.image_select    = image_select  --选中图片
    msgNode.image_open      = image_open    --打开图片
    msgNode.image_read      = image_read    --已读图片
    msgNode.text_title      = text_title    --消息标题
--    msgNode.text_msg        = text_msg      --消息内容
    msgNode.text_time       = text_time     --消息时间
    msgNode.text_view       = text_view     --点击查看

    msgNode.image_select:setVisible(false)
    msgNode.image_read:setVisible(false)
    msgNode.text_title:setString("")
--    msgNode.text_msg:setString("")
    msgNode.text_time:setString("")

    return msgNode
end

function AnnouncementCenter:setNoticeNode(msgNode, data, nIdx) --设置公告item

    --打开
    local mail_path = {
        [0] = "dt/image/feedback/mail_weidu.png",
        [1] = "dt/image/feedback/mail_yidu.png",
    }
    local path = mail_path[data.wStatus]
    msgNode.image_open:loadTexture(path, ccui.TextureResType.localType)

    --标题
    msgNode.text_title:setString(data.title)

    --时间
    local stringDate = string.format("%s", data.tmTime)
    msgNode.text_time:setString(stringDate)

    --内容
--    msgNode.text_msg:setString(data.content)

    --已阅
    local bRead = data.wStatus == 1
    msgNode.image_read:setVisible(bRead)

    --已选
    local bSelect = self.m_vecTableSelecet[nIdx]
    msgNode.image_select:setVisible(bSelect)
end


function AnnouncementCenter:setItemSelect(node, bSelect, nIdx) --设置选中
    
    self.m_vecTableSelecet[nIdx] = bSelect
    node.image_select:setVisible(bSelect)
end


function AnnouncementCenter:setItemDelete(i) --删除单个
    
    local nCount = self:getMsgCount()
    if nCount > 0 then 
        local offsetY = self.m_pTableView:getContentOffset().y
        local rect = self.m_pTableView:getViewSize()
        local content = self.m_pTableView:getContentSize()
        self.m_pTableView:reloadData()
        if offsetY > rect.height-content.height then 
            self.m_pTableView:setContentOffset(cc.p(0,offsetY))
        end
    else
         self.m_pTableView:reloadData()  
    end

    self:onUpdateImageNone(nCount == 0)
    self:onUpdateSelectAll()
end

function AnnouncementCenter:setItemDeleteAll() --删除所有
    
    self.m_pTableView:reloadData()
    self:onUpdateImageNone(true)
    self:onUpdateSelectAll()
end

function AnnouncementCenter:__recieve__() end

function AnnouncementCenter:onMsgGetNotice() --1.收到消息（公告）
    if self.m_SelectIndex == TAG_NOTICE then
        self:onUpdateListView(TAG_NOTICE)
    end
end

function AnnouncementCenter:onMsgdelNotice(event) --3.关闭消息界面（公告）

end

function AnnouncementCenter:onMsgGetMessage() --1.收到消息（消息）

end

function AnnouncementCenter:onMsgSetMessage(event) --2.收到状态（消息）

end

function AnnouncementCenter:onMsgDelMessage(event) --2.删除消息（消息）

end

function AnnouncementCenter:onMsgCloseMessage(event) --3.关闭消息界面（消息）

end

function AnnouncementCenter:__send__() end
function AnnouncementCenter:sendDefaultRequest() --请求

end

function AnnouncementCenter:sendGetNotice() --发送获取公告(登录已获取)
end

function AnnouncementCenter:sendDelAllMsg() --删除所有

end

function AnnouncementCenter:sendDelMsgAtIndex(nIdx) --根据索引删除
    if self.m_SelectIndex == TAG_NOTICE then 
        local data = CBroadcastManager.getInstance():getBroadcastDetailsInfoAtIndex(nIdx)
        print("发送删除公告 ID："..data.dwAnnounceID)
        
        self:sendDeleteNoticeByID(data.dwAnnounceID)
        
    end
end

function AnnouncementCenter:sendReadNotice(msgID) --发送已读（公告）
    self:requestRead(msgID)
end

function AnnouncementCenter:sendDeleteNoticeByID() --发送删除（公告）
--    local mid = 
    self.Num = self.msgID
    self:requestDelete(self.msgID)
end

function AnnouncementCenter:sendGetMessage(msgID) --发送获取消息（每次上限5条）
    self:requestMessagemsg()
    self.m_bIsCanReq = false
end


function AnnouncementCenter:onShowNotice(msg) --打开公告
    local pAnnouncementMsg = AnnouncementMsg.new()
    pAnnouncementMsg:setMessage(msg,1)
    pAnnouncementMsg:addTo(self.m_rootUI, 10)
end

function AnnouncementCenter:onShowMessage(msg) --打开消息
    local pMessageDialog = MessageDialog.create()
    pMessageDialog:setMsgText(msg)
    pMessageDialog:addTo(self.m_rootUI, 10)
end

--请求消息数据
function AnnouncementCenter:requestMessagemsg()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "mail_list"
    msgta["body"] = {}
    msgta["body"]["box"] = "in"
    msgta["body"]["pageindex"] = 1
    msgta["body"]["pagesize"] = 2
    msgta["body"]["type"] = -1
    msgta["body"]["status"] = -1

    LogonFrame:sendGameData(msgta)
    dump(msgta)
end
--读邮件
function AnnouncementCenter:requestRead(mid)
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "mail_read"
    msgta["body"] = {}
    msgta["body"]["mid"] = mid

    LogonFrame:sendGameData(msgta)
    dump(msgta)
end
--删除邮件
function AnnouncementCenter:requestDelete(mid)
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "mail_delete"
    msgta["body"] = {}
    msgta["body"]["mid"] = mid
    
    LogonFrame:sendGameData(msgta)
    dump(msgta)
end
 --消息请求回调
function AnnouncementCenter:onUserMessageCallBack(result,message)
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
    if type(message) == "table" then
        if message.tag == "mail_list" then                --加载
            if message.result == "ok" then    
                self:receiveNotice(message.body)
            end 
            --{mail_type=1 title="mTitle" nickname="18518125984" read=0 send_time="2019-01-17 17:01:23" id=390 }
        elseif message.tag == "mail_delete" then          --删除
            if message.result == "ok" then    
                self:deleteNotice(message.body)
            else
                    
            end 
        elseif message.tag == "mail_read" then            --读取
            if message.result == "ok" then    
                self.strContext = message.body
                self:showMsgView(self.Num)
            end 
        elseif message.tag == "mail_write" then           --编写
            if message.result == "ok" then    

            end 
        end
    end
end
--公告
function AnnouncementCenter:receiveNotice(_data)
    if _data.page.total == 0 and _data.page.pagecount == 0 then
        self.m_pBgtishi:setVisible(true)
        return
    end
    self.m_pBgtishi:setVisible(false)
    CBroadcastManager.getInstance():Clear()
--    for i = 1 , 7 do
--        local msgInfo = {}
--        msgInfo.dwAnnounceID = 123456
--        table.insert(self.midNumList,123456)
--        msgInfo.dwType = 0  -- {0~7}
--        msgInfo.title = 666
--        msgInfo.wStatus = 0
--        msgInfo.tmTime = 20190308
--        msgInfo.content = ""
--        CBroadcastManager.getInstance():addBroadcastDetailsInfo(msgInfo)
--    end
    for i = 1,#_data.data do
        local msgInfo = {}
        msgInfo.dwAnnounceID = _data.data[i].id
        table.insert(self.midNumList,_data.data[i].id)
        msgInfo.dwType = _data.data[i].mail_type  -- {0~7}
        msgInfo.title = _data.data[i].title
        msgInfo.wStatus = _data.data[i].read
        msgInfo.tmTime = _data.data[i].send_time
        msgInfo.content = ""
        CBroadcastManager.getInstance():addBroadcastDetailsInfo(msgInfo)
    end
    self:onMsgGetNotice()
end

--消息
function AnnouncementCenter:receiveMessages(_data)
    if _data.page.total == 0 and _data.page.pagecount == 0 then
        FloatMessage:getInstance():pushMessage("暂无消息")
        return
    end
    UsrMsgManager.getInstance():setLastReqestMsgID(_data.data[#_data.data].id)

    for i = 1,#_data.data do
        local msgInfo = {}
        msgInfo.msgID = _data.data[i].id
        table.insert(self.midNumList,_data.data[i].id)
        msgInfo.dwType = _data.data[i].mail_type  -- {0~7}
        msgInfo.title = _data.data[i].title
        msgInfo.wStatus = _data.data[i].read
        msgInfo.tmTime = _data.data[i].send_time
        msgInfo.content = ""
        UsrMsgManager.getInstance():addInfo(msgInfo)
    end

end
function AnnouncementCenter:deleteNotice(_data)
    if _data ~= "成功" then
        return
    end

    CBroadcastManager.getInstance():delBroadcastDetailsInfoByID(self.Num)

    table.remove(self.midNumList,self.Num)       
    FloatMessage:getInstance():pushMessage("删除".._data)
    self:onMsgGetNotice()
end
return AnnouncementCenter
