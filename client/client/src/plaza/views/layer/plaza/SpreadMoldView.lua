--region SpreadMoldView.lua
--Date
--
--endregion

-- modified by JackyXu
-- Desc: 游戏等级场选择列表 （三级页面）

local SpreadMoldView = class("SpreadMoldView", FixLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
--lzg
--[[
local UsrMsgManager = require("common.manager.UsrMsgManager")
]]--
local SPREAD_MOLD_NUM = 5
local MIDDLE_X = 667
local MIDDLE_Y = 375

SpreadMoldView.instance = nil
function SpreadMoldView.create()
    SpreadMoldView.instance = SpreadMoldView.new()
    return SpreadMoldView.instance
end

function SpreadMoldView:ctor()
    self:enableNodeEvents()


    self.m_pBtnLeftArrow = nil
    self.m_pBtnRightArrow = nil
    self.m_nLastTouchTime = nil
    self.m_bIsShowArrow = false

    self.m_listMaxWidth = 1334

    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)

    self:init()
end

function SpreadMoldView:onEnter()

    self.super:onEnter()
    self:showWithStyle()
end

function SpreadMoldView:onExit()

    self.super:onExit()
    SpreadMoldView.instance = nil
end

function SpreadMoldView:init()

    self:setTargetShowHideStyle(self, self.SHOW_POPUP, self.HIDE_POPOUT)
    
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/SpreadMoldView.csb")
    self.m_rootUI:addChild(self.m_pathUI)

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("SpreadMoldView")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    self.m_pNodeUI    = self.m_pNodeRoot:getChildByName("node_rootUI")
    self.m_pBtnClose    = self.m_pNodeUI:getChildByName("Button_close")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseClicked))
    self.m_pNodeTable       = self.m_pNodeUI:getChildByName("Node_table")
    self.m_pBtnLeftArrow    = self.m_pNodeUI:getChildByName("Button_left_arrow")
    self.m_pBtnRightArrow   = self.m_pNodeUI:getChildByName("Button_right_arrow")
    self.m_pBtnLeftArrow:setTag(1)
    self.m_pBtnRightArrow:setTag(2)
    self.m_pBtnLeftArrow:addClickEventListener(handler(self, self.onBtnArrorClicked))
    self.m_pBtnRightArrow:addClickEventListener(handler(self, self.onBtnArrorClicked))

    self:initTableView()
    self:createArrow()
end

function SpreadMoldView:createArrow()

    self.m_pBtnLeftArrow:setVisible(false);
    self.m_pBtnRightArrow:setVisible(false);
    local seq = cc.Sequence:create(cc.MoveBy:create(0.4, cc.p(-8,0)),cc.MoveBy:create(0.4, cc.p(8,0)));
    self.m_pBtnLeftArrow:runAction(cc.RepeatForever:create(seq));

    local seq2 = cc.Sequence:create(cc.MoveBy:create(0.4, cc.p(8,0)),cc.MoveBy:create(0.4, cc.p(-8,0)));
    self.m_pBtnRightArrow:runAction(cc.RepeatForever:create(seq2));

end

function SpreadMoldView:touchListView(sender, _type)
    if ccui.ListViewEventType.ONSELECTEDITEM_END == _type then
        local index = sender:getCurSelectedIndex() + 1
        print("touchListView index:" .. index)
        if index > 1 and self.TouchListItem then
            self:TouchListItem(index-1)
        end
    end
end

function SpreadMoldView:TouchListItem(index)
    print("TouchListItem index:" .. index)
    if index ~= GlobalUserItem.m_nSpreadMoldIndex then
        GlobalUserItem.m_nSpreadMoldIndex = index
        cc.UserDefault:getInstance():setIntegerForKey("SpreadMoldIndex",index)
        SLFacade:dispatchCustomEvent(Hall_Events.MSG_UPDATE_SPREAD_MOLD)
    end
    self:onMoveExitView()
end

function SpreadMoldView:onBtnArrorClicked(pSender, event)
    ExternalFun.playClickEffect()
    local nIndex = pSender:getTag()
    if nIndex == 1 then
        self.m_root_lv:scrollToPercentHorizontal(0, 0.5, true)
    else
        self.m_root_lv:scrollToPercentHorizontal(100, 0.5, true)
    end
end

function SpreadMoldView:onScrollEvent(sender, _event)
    -- print("_event:", _event)
    if not self.m_bIsShowArrow then
        return
    end
    if not self.m_pBtnLeftArrow or not self.m_pBtnRightArrow then
        return
    end

    -- 设置箭头显示
    local pos = sender:getInnerContainerPosition()
    local bShowLeft = pos.x < 0
    local bShowRight = display.width - pos.x < self.m_listMaxWidth
    self.m_pBtnLeftArrow:setVisible(bShowLeft)
    self.m_pBtnRightArrow:setVisible(bShowRight)
end

function SpreadMoldView:initTableView()
    self.m_root_lv = ccui.ListView:create()
    self.m_root_lv:addScrollViewEventListener(handler(self, self.onScrollEvent))
    self.m_root_lv:removeAllItems()

    local sumWidth = 0

    local nodeSize = cc.size(1164,535)--self.m_pNodeTable:getContentSize()
    local itemSize = cc.size(300,534)

    for i = 1, SPREAD_MOLD_NUM do

        local _btnNode = ccui.Layout:create()
        _btnNode:setContentSize(itemSize)
        _btnNode:setTouchEnabled(true)
        _btnNode:addClickEventListener(function()
            self:TouchListItem(i)
        end)

        --图
        local strFile = string.format("hall/image/file/image-spread-mold-%d.jpg",i)
        local spIcon = cc.Sprite:create(strFile)
        if spIcon then
            spIcon:setAnchorPoint(cc.p(0.5,0));
            spIcon:setPosition(cc.p(150, 0))
            spIcon:setScale(0.8)
            spIcon:addTo(_btnNode)
        end

--        local gameID = PlayerInfo.getInstance():getGameID()
--        local QRFilePath = cc.FileUtils:getInstance():getWritablePath() .. gameID .. "qr.jpg"
--        local texture2d = cc.Director:getInstance():getTextureCache():addImage(QRFilePath)
--        local sp = cc.Sprite:createWithTexture(texture2d)
--        sp:setAnchorPoint(cc.p(0.5,0));
--        sp:setScale(1.6)
--        sp:setPosition(cc.p(itemSize.width*0.5,10));
--        _btnNode:addChild(sp);

        self.m_root_lv:pushBackCustomItem(_btnNode)
        sumWidth = sumWidth + itemSize.width;
    end

    if sumWidth > 1334 then
        self.m_listMaxWidth = sumWidth
        sumWidth = self.m_root_lv:getContentSize().width
        self.m_bIsShowArrow = true;
    end

    self.m_root_lv:setContentSize(nodeSize)
    self.m_root_lv:setItemsMargin(40)
    self.m_root_lv:setInertiaScrollEnabled(true)
    self.m_root_lv:jumpToPercentHorizontal(0)
    self.m_root_lv:setAnchorPoint(cc.p(0,0))
    self.m_root_lv:setPosition(cc.p(0, 0))
    self.m_root_lv:setBounceEnabled(true)
    self.m_root_lv:setScrollBarEnabled(false) -- 隐藏滚动条
    self.m_root_lv:setDirection(ccui.ScrollViewDir.horizontal)
    self.m_root_lv:setGravity(0)
    self.m_root_lv:addTo(self.m_pNodeTable)
end


--关闭按钮
function SpreadMoldView:onCloseClicked()

    ExternalFun.playClickEffect()
    local self = SpreadMoldView.instance

    self:onMoveExitView()
end


return SpreadMoldView
