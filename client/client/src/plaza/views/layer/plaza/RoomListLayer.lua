--
-- Author: zhong
-- Date: 2017-10-11 18:10:28
--
local TransitionLayer = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local RoomListLayer = class("RoomListLayer", TransitionLayer)
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local UserInfoLayer = appdf.req(appdf.PLAZA_VIEW_SRC .. "ucenter.UserInfoLayer")           -- 用户中心
local HeadSprite = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
local ShopLayer = appdf.req(appdf.PLAZA_VIEW_SRC .. "ShopLayer")                               -- 商城
local BankInfoLayer = appdf.req(appdf.PLAZA_VIEW_SRC .. "ucenter.BankInfoLayer")               -- 银行

local targetPlatform = cc.Application:getInstance():getTargetPlatform()
local TAG_START             = 100
local enumTable = 
{
    "BT_EXIT",              -- 退出
    "BT_SHOP",              -- 商店
    "BT_USERINFO",          -- 个人信息
    "BT_BANK",              -- 银行
    "BT_QUICK",             -- 快速开始
    "IMAGE_UID"
}
local TAG_ENUM = ExternalFun.declarEnumWithTable(TAG_START, enumTable)


function RoomListLayer:ctor(scene, param, level)
    RoomListLayer.super.ctor( self, scene, param, level )
    local this = self

    ExternalFun.registerNodeEvent(self)
    local logonCallBack = function (result,message)
        self:onLogonCallBack(result,message)
    end
    self._logonFrame = LogonFrame:getInstance()
    self._logonFrame:setCallBackDelegate(self, logonCallBack)

    -- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("plaza/RoomListLayer.csb", self)
    local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            this:onButtonClickedEvent(ref:getTag(), ref)            
        end
    end
    -- 底板
    local spbg = csbNode:getChildByName("sp_bg")
    spbg:addTouchEventListener( touchFunC )
    self.m_spBg = spbg

    local content = spbg:getChildByName("content")
    self.m_content = content

    self.m_szModuleStr = ""
    local enterGameInfo = self._scene:getEnterGameInfo()
    local modulestr = string.gsub(enterGameInfo._KindName, "%.", "/")
    self.m_szModuleStr = modulestr

    -- 退出
    local btn = spbg:getChildByName("btn_back")
    btn:setTag(TAG_ENUM.BT_EXIT)
    btn:addTouchEventListener(touchFunC)
    btn:setPressedActionEnabled(true)

    -- 昵称
    local nickname = csbNode:getChildByName("txt_nickname")
    nickname:setString(GlobalUserItem.tabAccountInfo.nickname)   

    -- gameid
    csbNode:getChildByName("txt_gameid"):setString("ID:" .. GlobalUserItem.tabAccountInfo.userid)

    -- 金币
    self.m_clipScore = csbNode:getChildByName("txt_score")
    self.m_clipScore:setString(GlobalUserItem.tabAccountInfo.bag_money)

    -- 头像
    self.m_spHeadBg = csbNode:getChildByName("plaza_sp_headbg")

    local btn = csbNode:getChildByName("btn_userinfo")
    btn:setTag(TAG_ENUM.BT_USERINFO)
    btn:addTouchEventListener(touchFunC)

    -- id复制
    local btn = csbNode:getChildByName("btn_copy")
    btn:setTag(TAG_ENUM.IMAGE_UID)
    btn:addTouchEventListener(touchFunC)

    -- 银行
    local btn = spbg:getChildByName("btn_bank")
    btn:setTag(TAG_ENUM.BT_BANK)
    btn:addTouchEventListener(touchFunC)
    btn:setPressedActionEnabled(true)

    -- 商城
    local btn = spbg:getChildByName("btn_charge")
    btn:setTag(TAG_ENUM.BT_SHOP)
    btn:addTouchEventListener(touchFunC)
    btn:setPressedActionEnabled(true)

    -- 快速开始
    local btn = spbg:getChildByName("btn_quick")
    btn:setTag(TAG_ENUM.BT_QUICK)
    btn:addTouchEventListener(touchFunC)
    btn:setPressedActionEnabled(true)

    -- 系统消息
    local btn = spbg:getChildByName("btn_notice")
    local noticeSize = btn:getContentSize()
    self.m_noticeArea = noticeSize

    -- 消息区域
    local stencil = display.newSprite()
        :setAnchorPoint(cc.p(0,0.5))
    stencil:setTextureRect(cc.rect(0, 0, noticeSize.width - 65, noticeSize.height))
    self._notifyClip = cc.ClippingNode:create(stencil)
        :setAnchorPoint(cc.p(0,0.5))
    self._notifyClip:setInverted(false)
    self._notifyClip:move(30,noticeSize.height * 0.5 + 2)
    self._notifyClip:addTo(btn)
    self._notifyText = cc.Label:createWithTTF("", "fonts/round_body.ttf", 24)
                                :addTo(self._notifyClip)
                                --:setTextColor(cc.c4b(255,191,123,255))
                                :setAnchorPoint(cc.p(0,0.5))
                                :enableOutline(cc.c4b(79,48,35,255), 1)
    self.bBound = false
    -- 消息内容
    self.m_tabSystemNotice = {}
    -- 播放索引
    self._sysIndex = 1
    -- 消息是否运行
    self.m_bNotifyRunning = false
    -- 跑马灯内容
    self.m_tabMarquee = {}
    -- 消息id
    self.m_nNotifyId = 0

    self.m_fThree = yl.WIDTH / 4
    -- 列表
    self._listView = nil
    self.m_tabList = {}
    self.m_nListCount = 0

    -- 按钮
    self.m_itemFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            local beginPos = ref:getTouchBeganPosition()
            local endPos = ref:getTouchEndPosition()
            if math.abs(endPos.x - beginPos.x) > 30 
                or math.abs(endPos.y - beginPos.y) > 30
                or nil == this._listView then
                return
            end

            -- widget add 到 tableview 会在非可见区域触发touch事件
            local toViewPoint = this._listView:convertToNodeSpace(endPos)
            local rec = cc.rect(0, 0, this._listView:getViewSize().width, this._listView:getViewSize().height)
            if true == cc.rectContainsPoint(rec, toViewPoint) then
                this:onItemButtonClickedEvent(ref:getTag(), ref)  
            end  
        end
    end

    -- 注册事件监听
    self:registerEventListenr()
    -- 加载动画
    self:scaleTransitionIn(spbg)
end
function RoomListLayer:onEnterTransitionFinish()
    -- 创建头像
    local head = HeadSprite:createClipHead(GlobalUserItem.tabAccountInfo, 92, "plaza/plaza_sp_cliphead.png")
    if nil ~= head then
        head:setPosition(self.m_spHeadBg:getPosition())
--        head:setScale(1.5)
        self:addChild(head)
    end
end
function RoomListLayer:onAddNotice( msg )
    if type(msg) ~= "table" then
        dump(msg, "PlazaLayer:onAddNotice 参数非法", 6)
        return
    end
    table.insert( self.m_tabSystemNotice, msg )
    table.insert( self.m_tabMarquee, msg )
    if not self.m_bNotifyRunning then
        self:onChangeNotify(self.m_tabMarquee[self._sysIndex])
    end
end

function RoomListLayer:onChangeNotify( msg )
    self._notifyText:stopAllActions()
    if not msg or not msg.title or #msg.title == 0 then
        self._notifyText:setString("")
        self.m_bNotifyRunning = false
        self._tipIndex = 1
        return
    end
    local showMessage = msg.title
--    if not msg.showtitle then
--        showMessage = msg.marqueetitle
--    end
    if not showMessage or #showMessage == 0 then
        self._notifyText:setString("")
        self.m_bNotifyRunning = false
        self._tipIndex = 1
        return
    end
    self.m_bNotifyRunning = true
    local msgcolor = cc.c4b(229,222,203,255)
    self._notifyText:setVisible(false)
    self._notifyText:setString(showMessage)
    self._notifyText:setTextColor(msgcolor)

    if true == msg.autoremove then
        msg.showcount = msg.showcount or 0
        msg.showcount = msg.showcount - 1
        if msg.showcount <= 0 then
            self:removeNoticeById(msg.id)
        end
    end
    
    local tmpWidth = self._notifyText:getContentSize().width
    self._notifyText:runAction(
        cc.Sequence:create(
            cc.CallFunc:create( function()
                self._notifyText:move(self.m_noticeArea.width, 0)
                self._notifyText:setVisible(true)
            end),
            cc.MoveTo:create(6 + (tmpWidth / self.m_noticeArea.width) * 8,cc.p(0 - tmpWidth,0)),
            cc.CallFunc:create( function()
                local tipsSize = 0
                local tips = {}
                local index = 1
                -- 系统公告
                local tmp = self._sysIndex + 1
                if tmp > #self.m_tabMarquee then
                    tmp = 1
                end
                self._sysIndex = tmp
                self:onChangeNotify(self.m_tabMarquee[self._sysIndex])             
            end)
        )
    )
end

-- 移除公告
function RoomListLayer:removeNoticeById(id)
    if nil == id then
        return
    end
    local idx = nil
    for k,v in pairs(self.m_tabMarquee) do
        if nil ~= v.id and v.id == id then
            idx = k
            break
        end
    end
    if nil ~= idx then
        table.remove(self.m_tabMarquee, idx)
    end
end

function RoomListLayer:onButtonClickedEvent( tag, ref )
    if TAG_ENUM.BT_EXIT == tag then
         -- 大厅界面
        self._scene:onChangeShowMode(yl.SCENE_PLAZA) 
    elseif TAG_ENUM.BT_SHOP == tag then
        self:popShopLayer(ShopLayer.DIAMOND_CHARGE)
    elseif TAG_ENUM.BT_BANK == tag then                             -- 银行
        self:popMark()
    elseif TAG_ENUM.BT_USERINFO == tag then
        local ul = UserInfoLayer:create(self._scene, {}, UserInfoLayer.SECOND_LEVEL)
        self._scene:addPopLayer(ul)
    elseif TAG_ENUM.BT_QUICK == tag then
        self:popGame()
    elseif TAG_ENUM.IMAGE_UID == tag  then                           -- 复制ID
        MultiPlatform:getInstance():copyToClipboard(GlobalUserItem.tabAccountInfo.userid .. "")
        local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
         local querydialog = QueryDialog:create("您的ID已拷贝到剪贴板！", function ()
				
				end,nil,1):setCanTouchOutside(false)
                :addTo(self._scene)
    end
end

function RoomListLayer:popGame()
    if #self.m_tabList > 0 then
        GlobalUserItem.tabRoomInfo = self.m_tabList[1]
        self._scene:onStartGame()
    else
        showToast(self, "未找到游戏房间！", 2)
    end
end

function RoomListLayer:popMark()
    local ul = BankInfoLayer:create(self._scene, {}, BankInfoLayer.SECOND_LEVEL)
    self._scene:addPopLayer(ul) 
end

-- 弹出商店
function RoomListLayer:popShopLayer( shopType )
    local hl = HelpLayer:create(self._scene, shopType, HelpLayer.SECOND_LEVEL)
     self._scene:addPopLayer(hl)
end

function RoomListLayer:onItemButtonClickedEvent( tag, ref )
    local roominfo = ref.roominfo
    if nil == roominfo then
        showToast(self, "未找到游戏房间！", 2)
        return
    end
    GlobalUserItem.tabRoomInfo = roominfo
    self._scene:onStartGame()
end

function RoomListLayer:animationRemove()
    self:scaleTransitionOut(self.m_spBg)
end

function RoomListLayer:onTransitionInFinish()
    -- 列表
    local tmp = self.m_spBg:getChildByName("content")
    self._listView = cc.TableView:create(tmp:getContentSize())
    self._listView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)    
    self._listView:setPosition(tmp:getPosition())
    self._listView:setDelegate()
    self._listView:addTo(self.m_spBg)
    self._listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self._listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self._listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tmp:removeFromParent()


    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "get_rooms"
    msgta["body"] = {}
    msgta["body"]["minv"] = 20000
    msgta["body"]["agentid"] = -1
    msgta["body"]["maxv"] = 39999
    msgta["body"]["gt"] = tostring(GlobalUserItem.nCurGameKind)
    msgta["body"]["rt"] = "1"

    self._logonFrame:sendGameData(msgta)
end

function RoomListLayer:onTransitionOutFinish()
    self:removeFromParent()
end

function RoomListLayer:onOtherShowEvent()
    if self:isVisible() then
        self:setVisible(false)
    end
end

function RoomListLayer:onOtherHideEvent()
    if not self:isVisible() then
        self:setVisible(true) 
    end
end

-- 子视图大小
function RoomListLayer:cellSizeForTable(view, idx)
    return self.m_fThree , 319
end

function RoomListLayer:tableCellAtIndex(view, idx)
    local cell = view:dequeueCell()

    if not cell then        
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end
    local roominfo = self.m_tabList[idx + 1]
    if nil == roominfo then
        return cell
    end
    
    -- 房间图片
     local iconfile = "plaza/roomicon.png"
     local btn = ccui.Button:create(iconfile, iconfile, iconfile)
     btn:setPosition(self.m_fThree * 0.5, view:getViewSize().height * 0.5)
     btn:setPressedActionEnabled(true)
     btn:setSwallowTouches(false)
     btn:addTouchEventListener(self.m_itemFunC)
     btn.roominfo = roominfo

     --类型
     local wLv = roominfo.room_type
     local img_title = display.newSprite(string.format("#hall_roomname%d.png", wLv))
     img_title:setPosition(btn:getContentSize().width/2, 250)
     img_title:addTo(btn)

     --状态
     local statuse = self:getServerStatuse(roominfo.online_num, roominfo.max_online)
     local img_statuse = display.newSprite(string.format("#imgRFText%d.png", statuse))
     img_statuse:setPosition(btn:getContentSize().width/2, 150)
     img_statuse:addTo(btn)

     cell:addChild(btn)

     local txtScore = ccui.Text:create():setString("入场:"..roominfo.min_money):addTo(btn):setPosition(btn:getContentSize().width/2,80):setColor(cc.c3b(236,255,255)):setFontSize(30)

    return cell
end

-- 子视图数目
function RoomListLayer:numberOfCellsInTableView(view)
    return self.m_nListCount
end

--处理房间列表
function RoomListLayer:handRoomList(data)
    -- 获取房间列表
    self.m_tabList = {}
    self.m_tabList = data
    self.m_nListCount = #self.m_tabList
    self._listView:reloadData()
end

function RoomListLayer:onLogonCallBack(result,message)
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
    if message.tag == "get_rooms" then 
        if message.result == "ok" then
            self:handRoomList(message.body)
        else
            if type(message.result) == "string" then
               showToast(self,message.result,2,cc.c4b(250,0,0,255));
            end
        end  
    end
end

function RoomListLayer:getServerStatuse(dwOnLineCount, dwMaxCount)
    local  dwPer = (dwOnLineCount*100)/dwMaxCount
     if dwPer > 80 then
		return 3
	elseif dwPer > 60 then
        return 2
	elseif dwPer > 20 then
        return 1
	else
        return 0
    end
end


return RoomListLayer