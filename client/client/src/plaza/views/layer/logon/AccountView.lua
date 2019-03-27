--region AccountView.lua
--Desc: 帐号 view

local LogonView = appdf.req(appdf.CLIENT_SRC .."plaza.views.layer.logon.LogonView")
local AccountViewItem = appdf.req(appdf.CLIENT_SRC .."plaza.views.layer.logon.AccountViewItem")
local AccountManager = appdf.req(appdf.CLIENT_SRC .."plaza.views.layer.logon.AccountManager")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .."ExternalFun")
local AccountView     = class("AccountView", FixLayer)

function AccountView:ctor(deletegate)
    self.super:ctor(self)
    self:enableNodeEvents()

    self.deletegate = deletegate

    self:init()
end

function AccountView:init()

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    self.m_pathUI = cc.CSLoader:createNode("hall/csb/LoginAccountView.csb")
    self.m_pathUI:addTo(self.m_rootUI)

    self.m_pNodeRoot = self.m_pathUI:getChildByName("node_rootUI")
    self.m_pNodeRoot:setPositionX((display.width - 1334) / 2)

    local pSpriteBg = self.m_pNodeRoot:getChildByName("Sprite_bg")

    self.m_pBtnClose = pSpriteBg:getChildByName("Button_close")
    self.m_pNodeTable = pSpriteBg:getChildByName("tableview_ac")

    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseClicked))
    self.m_tableAccount = AccountManager.getInstance():getLocalAccount()

    self:initTableView()
end

function AccountView:onEnter()
    self.super:onEnter()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)
    self:showWithStyle()

    SLFacade:addCustomEventListener(Hall_Events.MSG_SHOW_REGISTER, handler(self, self.onMsgShowRegister), self.__cname)
end

function AccountView:onExit()
    self.super:onExit()

    SLFacade:removeCustomEventListener(Hall_Events.MSG_SHOW_REGISTER, self.__cname)
end

function AccountView:getAccounts()
    return self.m_tableAccount
end

function AccountView:onCloseClicked()
    ExternalFun.playClickEffect()

    self:onMoveExitView()
end

function AccountView:initTableView()
    
    if not self.m_pTableView then
        self.m_sizeTable = self.m_pNodeTable:getContentSize()

        self.m_pTableView = cc.TableView:create(self.m_sizeTable)
--        self.m_pTableView:setIgnoreAnchorPointForPosition(false)
        self.m_pTableView:setAnchorPoint(cc.p(0,0))
        self.m_pTableView:setPosition(cc.p(0, 0))
        self.m_pTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.m_pTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        self.m_pTableView:setDelegate()

        self.m_pTableView:registerScriptHandler(handler(self,self.cellSizeForTable), CCTableView.kTableCellSizeForIndex)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellAtIndex), CCTableView.kTableCellSizeAtIndex)
        self.m_pTableView:registerScriptHandler(handler(self,self.numberOfCellsInTableView), CCTableView.kNumberOfCellsInTableView)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellTouched), CCTableView.kTableCellTouched)

        self.m_pTableView:addTo(self.m_pNodeTable)
    end
    self.m_pTableView:reloadData()
end


function AccountView:cellSizeForTable(table, idx)
    return self.m_sizeTable.width / 3 , self.m_sizeTable.height
end

function AccountView:tableCellAtIndex(table, idx)
    local cell = table:cellAtIndex(idx)
    if not cell then
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end
    self:initTableViewCell(cell, idx)
    return cell
end


function AccountView:initTableViewCell(cell, nIdx)
    local item = AccountViewItem.new()
    item:initAccount(self.m_tableAccount[nIdx + 1], self.deletegate)
    item:setPosition(cc.p(10, 15))
    item:addTo(cell)
end

function AccountView:numberOfCellsInTableView(table_)
    return #self.m_tableAccount + 1
end

function AccountView:tableCellTouched(table, cell)
end


function AccountView:onMsgShowRegister()
    
    --打开登陆界面
    local LogonView = LogonView.create(1)
    LogonView:setName("LogonView")
    LogonView:addTo(self.m_rootUI, 10)
end

return AccountView
