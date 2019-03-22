--region RechargeAgentView.lua
--Date 2017.04.25.
--Auther JackyXu.
--Desc: 代理充值 view
local ExternalFun       = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ReportAwardDlg     = appdf.req(appdf.PLAZA_VIEW_SRC.."bean.ReportAwardDlg")
local AgentContactDlg    = appdf.req(appdf.PLAZA_VIEW_SRC.."bean.AgentContactDlg")
local ClientPopWait = appdf.req(appdf.EXTERNAL_SRC .. "ClientPopWait")
local FloatMessage       = cc.exports.FloatMessage
local CRechargeManager   = cc.exports.CRechargeManager

local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local BaseFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.BaseFrame")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame") 

local RechargeAgentView        = class("RechargeAgentView", FixLayer)--, cc.Layer)
local G_RechargeAgentEventTag  = "RechargeAgentEventTag" -- 事件监听TAG

RechargeAgentView._instance = nil
function RechargeAgentView.create()
    RechargeAgentView._instance = RechargeAgentView.new():init()
    return RechargeAgentView._instance
end

function RechargeAgentView:ctor()
    self:enableNodeEvents()

    self.m_pNodeTable  = nil
    self.m_pBtnFresh   = nil
    self.m_pBtnReport  = nil
    self.m_pBtnCopy    = nil
    self.m_pTextID     = nil
    self.m_pTableView  = nil
    self.m_bIsDrug     = false

    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    local  onUseRankCallBack = function(result,message)
       self:onAgentViewCallBack(result,message)
    end

    --大厅网络处理
    self._plazaFrame = LogonFrame:getInstance()
    self._plazaFrame:setCallBackDelegate(self, onUseRankCallBack)
end

 --排行榜请求回调
function RechargeAgentView:onAgentViewCallBack(result,message)
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
    if type(message) == "table" then
        if message.tag == "get_agency_ranking" then
        dump(message)
            if message.result == "ok" then
                GlobalUserItem.tabAccountInfo.agentList = {}
                GlobalUserItem.tabAccountInfo.agentList = message.body
                
                SLFacade:dispatchCustomEvent(Hall_Events.MSG_GET_AGENT)
            end 
        end
    end
end

function RechargeAgentView:init()

    --init csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/RechargeAgentView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    self.m_pNodeRoot    = self.m_pathUI:getChildByName("RechargeAgentView")

    self.m_pNodeContent = self.m_pNodeRoot:getChildByName("node_content")
    self.m_pNodeTable   = self.m_pNodeContent:getChildByName("node_list")
    self.m_pBtnFresh    = self.m_pNodeContent:getChildByName("BTN_refresh")
    self.m_pBtnFresh:addClickEventListener(handler(self, self.onFreshBtnClick))
    self.m_pBtnReport   = self.m_pNodeContent:getChildByName("BTN_report")
    self.m_pBtnReport:addClickEventListener(handler(self, self.onReportBtnClick))
    self.m_pBtnCopy     = self.m_pNodeContent:getChildByName("Button_Copy")
    self.m_pBtnCopy:addClickEventListener(handler(self, self.onCopyBtnClick))
    self.m_pTextID      = self.m_pNodeContent:getChildByName("Button_Copy"):getChildByName("Text_ID")
    self.m_pTextID:setString(GlobalUserItem.tabAccountInfo.userid)

    return self
end

function RechargeAgentView:onEnter()

    self:initTableView()

    SLFacade:addCustomEventListener(Hall_Events.MSG_GET_AGENT, handler(self, self.onMsgAgentInfo), G_RechargeAgentEventTag)
    
    --请求人工充值信息
--    self:showPopWait()--self:showWithStyle()
    self:onRequestAgentInfo()
end

function RechargeAgentView:onExit()
    SLFacade:removeCustomEventListener(Hall_Events.MSG_GET_AGENT, G_RechargeAgentEventTag)

    RechargeAgentView._instance = nil
end

function RechargeAgentView:cellSizeForTable(table, idx)
    return 1020, 106;
end

function RechargeAgentView:tableCellAtIndex(table, idx)
    local cell = table:cellAtIndex(idx)
    if not cell then
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end

    self:initTableViewCell(cell, idx);

    return cell
end

function RechargeAgentView:numberOfCellsInTableView(table)
    local count = #GlobalUserItem.tabAccountInfo.agentList
    return math.ceil(count / 2);
end

function RechargeAgentView:tableCellTouched(table, cell)
end

function RechargeAgentView:initTableViewCell(cell, nIdx)

    local count = #GlobalUserItem.tabAccountInfo.agentList
    local startX = 18
    for i=1,2 do
        local tag = nIdx * 2 + i
        if tag > count then
            return
        end

        local info = GlobalUserItem.tabAccountInfo.agentList[tag]
--        if info.type == 0 then
--            return
--        end

        -- 背景也是按纽
        local celNodeBg = cc.Sprite:createWithSpriteFrameName("hall/plist/shop/gui-shop-agent-item-bg.png")
        local pNormalSprite = cc.Scale9Sprite:createWithSpriteFrame(celNodeBg:getSpriteFrame())
        local pClickSprite = cc.Scale9Sprite:createWithSpriteFrame(celNodeBg:getSpriteFrame())
        local pBgBtn = ccui.Button:create("hall/plist/shop/gui-shop-agent-item-bg.png", "hall/plist/shop/gui-shop-agent-item-bg.png", "hall/plist/shop/gui-shop-agent-item-bg.png",ccui.TextureResType.plistType)--cc.ControlButton:create(pNormalSprite)
        pBgBtn:setScale9Enabled(true)
        local pBtnSize = pBgBtn:getContentSize()
        pBgBtn:setSwallowTouches(false)


        pBgBtn:setPosition(cc.p(startX + pBtnSize.width / 2 + (i-1)*410, 50))
        pBgBtn:setTag(tag);
        cell:addChild(pBgBtn);
        -- 添加响应
         pBgBtn:addClickEventListener(handler(self,self.onCopyClicked))
        -- name
        local name = info[2]
        local lb_name = cc.Label:createWithSystemFont(name, "Helvetica", 24);
        lb_name:setColor(cc.c3b(202,23,27));
        lb_name:setPosition(cc.p(pBtnSize.width / 2 - 26, pBtnSize.height / 2 + 20));
        pBgBtn:addChild(lb_name);

        -- account
        local account = info[3]--LuaUtils.getDisplayNickName2(info.account, 120, "Helvetica", 24, "...")
        local lb_name = cc.Label:createWithSystemFont(account, "Helvetica", 24)
        lb_name:setColor(cc.c3b(108,57,29));
        lb_name:setPosition(cc.p(pBtnSize.width / 2 - 26, pBtnSize.height / 2 - 16))
        pBgBtn:addChild(lb_name);

        -- flag img
        local strImgName = "hall/plist/shop/gui-shop-agent-icon-wx.png"
        local pFlagImg = cc.Sprite:createWithSpriteFrameName(strImgName)
        pFlagImg:setPosition(cc.p(10 + pFlagImg:getContentSize().width/2, pBtnSize.height / 2 + 5))
        pBgBtn:addChild(pFlagImg);

        -- copy Sp
        local pCopySp = cc.Sprite:createWithSpriteFrameName("hall/plist/shop/gui-shop-agent-btn-recharge.png")
        pCopySp:setPosition(cc.p(pBtnSize.width-pCopySp:getContentSize().width/2-10, pBtnSize.height / 2));
        pCopySp:setTag(tag)
        pBgBtn:addChild(pCopySp)
    end
end

function RechargeAgentView:scrollViewDidScroll(pView)
    local slider = tolua.cast(self.m_pNodeTable:getChildByTag(100), "cc.ControlSlider")
    if not slider then
        return;
    end
    
    local max = self.m_nTableHeight - 390;
    slider:setValue((pView:getContentOffset().y + max));
end

function RechargeAgentView:initTableView()
    if not self.m_pTableView then
        self.m_nTableHeight = self.m_pNodeTable:getContentSize().height
        self.m_pTableView = cc.TableView:create(self.m_pNodeTable:getContentSize());
--        self.m_pTableView:setIgnoreAnchorPointForPosition(false);
        self.m_pTableView:setAnchorPoint(cc.p(0,0));
        self.m_pTableView:setPosition(cc.p(0, 0));
        self.m_pTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
        self.m_pTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
        self.m_pTableView:setDelegate()
        self.m_pTableView:registerScriptHandler(handler(self,self.scrollViewDidScroll), CCTableView.kTableViewScroll)
        self.m_pTableView:registerScriptHandler(handler(self,self.cellSizeForTable), CCTableView.kTableCellSizeForIndex)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellAtIndex), CCTableView.kTableCellSizeAtIndex)
        self.m_pTableView:registerScriptHandler(handler(self,self.numberOfCellsInTableView), CCTableView.kNumberOfCellsInTableView)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellTouched), CCTableView.kTableCellTouched)
        self.m_pNodeTable:addChild(self.m_pTableView);
    end
end
--收到请求列表的返回消息
function RechargeAgentView:onMsgAgentInfo(pUserdata)

    --cc.exports.scheduler.performWithDelayGlobal(function()
    ActionDelay(self, function()
--        Veil:getInstance():HideVeil(VEIL_REQUEST_DATA)
        self:dismissPopWait()
        self.m_pBtnFresh:setVisible(true)
        
        self.m_pTableView:reloadData()

        local slider = tolua.cast(self.m_pNodeTable:getChildByTag(100), "cc.ControlSlider")
        local count = #GlobalUserItem.tabAccountInfo.agentList
        if slider then
            local maxHeight = 120 * math.ceil(count / 3)
            self.m_nTableHeight = maxHeight
            local max = maxHeight - 390
            local maxVaule = (max > 0 and max or 0);
            slider:setMaximumValue(maxVaule)
        end

        -- 只有一屏则隐藏滚动条
        if count < 10 then
            local slider = tolua.cast(self.m_pNodeTable:getChildByTag(100), "cc.ControlSlider")
            if slider then
                slider:setVisible(false)
            end
        end
    end, 0.4)
end

-- 网络请求
function RechargeAgentView:onRequestAgentInfo()
    self:sendReguestAgentList()
--    if BaseFrame:isSocketServer() then
----        if cc.exports.isConnectGame() then
----            CMsgGame:sendQueryAgentInfoInGame()
----        elseif cc.exports.isConnectHall() then
----            CMsgHall:sendQueryAgentInfoAtHall()
----        end

--    else
--        FloatMessage:getInstance():pushMessage("网络连接已断开")
--    end
end

function RechargeAgentView:sendReguestAgentList()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "get_agency_ranking"
    msgta["body"] = {123456789}
--    msgta["body"]["openid"] = 1
    LogonFrame:sendGameData(msgta)
end
------------------------
-- 按纽响应
-- 列表子项复制按纽响应
function RechargeAgentView:onCopyClicked(pSender)
--    ExternalFun.playClickEffect()
    ExternalFun.playSoundEffect("public/sound/sound-button.mp3")
    local nIndex = pSender:getTag()
    print("RechargeAgentView:onCopyClicked:", nIndex)

    local agentInfo = GlobalUserItem.tabAccountInfo.agentList[nIndex]


    local agentNum = agentInfo[3]
    MultiPlatform:getInstance():copyToClipboard(agentNum)
    local agentType = 1
    local RechargeViewNode = self:getParent():getParent():getParent():getParent():getParent()
    AgentContactDlg:create(agentNum, agentType):addTo(RechargeViewNode, Z_ORDER_COMMON)
end

-- 刷新
function RechargeAgentView:onFreshBtnClick(pSender)
    ExternalFun.playSoundEffect("public/sound/sound-button.mp3")

    self.m_pBtnFresh:setVisible(false)

    --手动刷新延时1秒发送请求，防连点
     self:showPopWait()
--    cc.exports.Veil.getInstance():ShowVeil(cc.exports.VEIL_REQUEST_DATA
--    cc.exports.scheduler.performWithDelayGlobal(function()
    ActionDelay(self, function()
        --请求人工充值信息
        self:onRequestAgentInfo()
    end, 1.5)
end

-- 举报
function RechargeAgentView:onReportBtnClick(pSender)
    ExternalFun.playSoundEffect("public/sound/sound-button.mp3")

    local RechargeViewNode = self:getParent():getParent():getParent():getParent():getParent()
    ReportAwardDlg:create():addTo(RechargeViewNode, Z_ORDER_COMMON)
end

function RechargeAgentView:onCopyBtnClick(pSender)
    ExternalFun.playSoundEffect("public/sound/sound-button.mp3")

    local nGameId = GlobalUserItem.tabAccountInfo.userid
    MultiPlatform:getInstance():copyToClipboard(gameId)

    FloatMessage.getInstance():pushMessage("STRING_036")
end


--显示等待
function RechargeAgentView:showPopWait(isTransparent)
   FloatPopWait.getInstance():show("请稍后")
end

--关闭等待
function RechargeAgentView:dismissPopWait()
   FloatPopWait.getInstance():dismiss()
end


return RechargeAgentView
