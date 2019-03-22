--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local SpreadDetailsView = class("SpreadDetailsView", cc.Layer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
    --lzg
    --[[
    local UsrMsgManager = require("common.manager.UsrMsgManager")
    ]]--

local G_SpreadDetailsView = nil
function SpreadDetailsView.create()
    G_SpreadDetailsView = SpreadDetailsView.new():init()
    return G_SpreadDetailsView
end

function SpreadDetailsView:ctor()
    self:enableNodeEvents()
    self.m_rootUI = display.newNode():addTo(self)
end

function SpreadDetailsView:init()

    self.m_pathUI = cc.CSLoader:createNode("hall/csb/SpreadDetailsView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    self.m_pNodeRoot = self.m_pathUI:getChildByName("SpreadDetailsView")

    self.m_pNodeDetails = self.m_pNodeRoot:getChildByName("Panel_node_details")
    self.pNodeNoDetails = self.m_pNodeDetails:getChildByName("node_noDetails")

    self.m_pNodeTable = self.m_pNodeDetails:getChildByName("Panel_node_table")
    self.m_pLaberTable = {}
    for i = 1, 3 do
        local str = {"B","C","D"}
        self.m_pLaberTable[i] = self.m_pNodeDetails:getChildByName("Label_" .. str[i])
    end

    self.m_pLbCurrentDate = self.m_pNodeDetails:getChildByName("Label_data")
    self.m_pBtnDateDown = self.m_pNodeDetails:getChildByName("BTN_down")
    self.m_pBtnDateDown:addClickEventListener(handler(self, self.onDateDownClicked))

    self.m_pSpUp = self.m_pNodeDetails:getChildByName("Sprite_up")

    self.m_pNodeDateTable = self.m_pNodeDetails:getChildByName("Node_Date")
    self.m_pBtnDateUp = self.m_pNodeDateTable:getChildByName("Button_up")
    self.m_pBtnDateUp:addClickEventListener(handler(self, self.onDateUpClicked))
    self.m_pLaberDate = {}
    self.m_pBtnDate = {}
    for i = 1, 7 do
        self.m_pLaberDate[i] = self.m_pNodeDateTable:getChildByName("Label_data_" .. i)
        self.m_pBtnDate[i] = self.m_pNodeDateTable:getChildByName("Button_date_" .. i)
        self.m_pBtnDate[i]:setTag(i)
        self.m_pBtnDate[i]:addClickEventListener(handler(self, self.onDateClicked))
    end

    --update info
    self.m_pBtnDateDown:setVisible(true)
    self.m_pBtnDateUp:setVisible(false)
    self.m_pSpUp:setVisible(false)
    self.m_pNodeDateTable:setVisible(false)
    -- lzg
    --[[
    --当前前一天日期
    local serverTime = PlayerInfo.getInstance():getServerTime()
    local t = CommonUtils.getInstance():LocalTime(serverTime-86400)
    local strDate =  string.format(LuaUtils.getLocalString("STRING_201"),t.tm_mon,t.tm_mday);
    self.m_pLbCurrentDate:setString(strDate)
    
    --日期列表
    for i=1, 7 do
        local t = CommonUtils.getInstance():LocalTime(serverTime - i*86400)
        local strDate =  string.format(LuaUtils.getLocalString("STRING_201"),t.tm_mon,t.tm_mday);
        self.m_pLaberDate[i]:setString(strDate)
    end
    ]]--
    self.m_nCurrentDateIndex = -1
    self.m_nLastTouchTime = 0

    self:initTableView()
    self:onMsgSpreadInfo()

    return self
end

function SpreadDetailsView:onEnter()
    self.UpdataSpreadInfo = SLFacade:addCustomEventListener(Hall_Events.MSG_UPDATE_USR_SPREAD_DETAILS_INFO, handler(self, self.onMsgSpreadInfo))
    --lzg
    --[[
    if not PlayerInfo.getInstance():getIsGuest() then
        CMsgHall:sendGetSpreadInfoNew(-1)
    end
    ]]--
end

function SpreadDetailsView:onExit()
    SLFacade:removeEventListener(self.UpdataSpreadInfo)
        --lzg
  --[[
      Veil:getInstance():HideVeil(VEIL_WAIT)
  ]]--
    G_SpreadDetailsView = nil
end

function SpreadDetailsView:onMsgSpreadInfo(_event)
    --lzg
    --[[
    Veil:getInstance():HideVeil(VEIL_WAIT)
    local count = UsrMsgManager.getInstance():getSpreadDetaislLayerArraryCount(self.m_nCurrentDateIndex)
    self.m_pNodeTable:setVisible(count~=0);
    self.pNodeNoDetails:setVisible(count==0);
   
    local detailsInfo = UsrMsgManager.getInstance():getSpreadDetaislData(self.m_nCurrentDateIndex)
     ]]--
    if detailsInfo ~= nil then 

        local sData = {{detailsInfo.iLayer1Count,detailsInfo.llLayer1Revenue,detailsInfo.llLayer1Award},
                        {detailsInfo.iLayer2Count,detailsInfo.llLayer2Revenue,detailsInfo.llLayer2Award},
                        {detailsInfo.iLayer3Count,detailsInfo.llLayer3Revenue,detailsInfo.llLayer3Award}}
             
        local str = {"B","C","D"}                              
        for i=1,3 do
            local strCount = str[i]..LuaUtils.getLocalString("SPREAD_1")..tostring(sData[i][1])
            local strRevenue = LuaUtils.getLocalString("SPREAD_2")..LuaUtils.getFormatGoldAndNumber(sData[i][2])
            local strAward = LuaUtils.getLocalString("SPREAD_3")..LuaUtils.getFormatGoldAndNumber(sData[i][3])

            self.m_pLaberTable[i]:getChildByName("Label_1"):setString(strCount)
            self.m_pLaberTable[i]:getChildByName("Label_2"):setString(strRevenue)
            self.m_pLaberTable[i]:getChildByName("Label_3"):setString(strAward)
        end

        if self.m_pTableView then 
            self.m_pTableView:reloadData()
        end
    end
end

function SpreadDetailsView:initTableView()
    if not self.m_pTableView then
        self.m_pTableView = cc.TableView:create(self.m_pNodeTable:getContentSize());
        self.m_pTableView:setAnchorPoint(cc.p(0,0));
        --lzg
        --self.m_pTableView:setIgnoreAnchorPointForPosition(false);
        self.m_pTableView:setPosition(cc.p(0,0));
        self.m_pTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
        self.m_pTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
        self.m_pTableView:setTouchEnabled(true);
        self.m_pTableView:setDelegate();
        self.m_pNodeTable:addChild(self.m_pTableView);
        self.m_pTableView:registerScriptHandler(handler(self,self.scrollViewDidScroll), CCTableView.kTableViewScroll)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellSizeForIndex), CCTableView.kTableCellSizeForIndex)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellAtIndex), CCTableView.kTableCellSizeAtIndex)
        self.m_pTableView:registerScriptHandler(handler(self,self.numberOfCellsInTableView), CCTableView.kNumberOfCellsInTableView)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellTouched), CCTableView.kTableCellTouched)
    else
        self.m_pTableView:reloadData();
    end
end

function SpreadDetailsView:scrollViewDidScroll(view)

end

function SpreadDetailsView:tableCellTouched(table, cell)

end

function SpreadDetailsView:tableCellSizeForIndex(table, idx)
    return self.m_pNodeTable:getContentSize().width, 62
end

function SpreadDetailsView:tableCellAtIndex(table, idx)
    local cell = table:cellAtIndex(idx)
    if not cell then
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end

    self:initTableViewCell(cell, idx);

    return cell
end

function SpreadDetailsView:numberOfCellsInTableView(table, idx)
    --lzg先注释掉
    --[[
    local nSize = UsrMsgManager.getInstance():getSpreadDetaislLayerArraryCount(self.m_nCurrentDateIndex)
    return nSize;
    ]]--
end

function SpreadDetailsView:initTableViewCell(cell, nIdx)

    --bg line
    local pBg = cc.Sprite:createWithSpriteFrameName("gui-spread-cutline.png");
    pBg:setAnchorPoint(cc.p(0, 0));
    cell:addChild(pBg);

    local detailsInfo = UsrMsgManager.getInstance():getSpreadDetaislData(self.m_nCurrentDateIndex);
    local ts = detailsInfo.arrMessage[nIdx+1]

    local pos = { cc.p(90,29), cc.p(270,29), cc.p(438,29), cc.p(615,29)};
    local strData = {}
    strData[1] = tostring(ts.szNickName);
    strData[2] = string.format("%d",ts.dwSubGameID);
    strData[3] = LuaUtils.getFormatGoldAndNumber(ts.llBrightRevenue);
    strData[4] = LuaUtils.getFormatGoldAndNumber(ts.llSpreaderAward);

    for i = 1, 4 do
        local lb = cc.Label:createWithSystemFont(strData[i], "Helvetica", 22);
        lb:setAnchorPoint(cc.p(0.5,0.5));
        lb:setPosition(pos[i]);
        lb:setColor(cc.c3b(108,59,27))
        cell:addChild(lb);
    end
end

function SpreadDetailsView:onDateDownClicked()
    ExternalFun.playClickEffect()

    self.m_pBtnDateDown:setVisible(false)
    self.m_pBtnDateUp:setVisible(true)
    self.m_pSpUp:setVisible(true)
    self.m_pNodeDateTable:setVisible(true)

    local action = cc.CSLoader:createTimeline("hall/csb/SpreadDetailsView.csb")
    action:play("animation0", false)
    self.m_pathUI:runAction(action)
end

function SpreadDetailsView:onDateUpClicked()
    ExternalFun.playClickEffect()

    self.m_pBtnDateDown:setVisible(true)
    self.m_pBtnDateUp:setVisible(false)
    self.m_pSpUp:setVisible(false)
    self.m_pNodeDateTable:setVisible(false)
end

function SpreadDetailsView:onDateClicked(sender)
    ExternalFun.playClickEffect()

    local index = sender:getTag()
    --lzg
    --先注释掉
    --[[
    if not PlayerInfo.getInstance():getIsGuest() and index ~= self.m_nCurrentDateIndex then
        self.m_nCurrentDateIndex = -index
        local detailsInfo = UsrMsgManager.getInstance():getSpreadDetaislData(self.m_nCurrentDateIndex)
        if detailsInfo ~= nil and detailsInfo.bHaveData  then
            self:onMsgSpreadInfo()
        else
            -- 防连点
            local nCurTime = os.time();
            if self.m_nLastTouchTime and nCurTime - self.m_nLastTouchTime < 1 then
                return
            end
            self.m_nLastTouchTime = nCurTime
            Veil:getInstance():ShowVeil(VEIL_WAIT)
            CMsgHall:sendGetSpreadInfoNew(self.m_nCurrentDateIndex)
        end
    end

    local serverTime = PlayerInfo.getInstance():getServerTime() - index*86400
    local t = CommonUtils.getInstance():LocalTime(serverTime)
    local strDate =  string.format(LuaUtils.getLocalString("STRING_201"),t.tm_mon,t.tm_mday);
    --]]
    self.m_pLbCurrentDate:setString(strDate)
    self.m_pBtnDateDown:setVisible(true)
    self.m_pBtnDateUp:setVisible(false)
    self.m_pNodeDateTable:setVisible(false)
end


return SpreadDetailsView

--endregion
