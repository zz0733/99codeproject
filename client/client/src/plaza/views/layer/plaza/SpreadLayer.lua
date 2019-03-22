--region *.lua
--Date
--Desc 推广页面
--此文件由[BabeLua]插件自动生成

local SpreadLayer       = class("SpreadLayer",FixLayer)
local SpreadInfoView    = require(appdf.PLAZA_VIEW_SRC.."SpreadMySpreadView")
local SpreadRewardIntroduceView = require(appdf.PLAZA_VIEW_SRC.."SpreadRewardIntroduceView")
local SpreadMyAchieveView = require(appdf.PLAZA_VIEW_SRC.."SpreadMyAchieveView")
local SpreadMyAgentView = require(appdf.PLAZA_VIEW_SRC.."SpreadMyAgentView")
local SpreadMyPlayerView = require(appdf.PLAZA_VIEW_SRC.."SpreadMyPlayerView")
local SpreadReceiveAwardsView = require(appdf.PLAZA_VIEW_SRC.."SpreadReceiveAwardsView")

local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
    --lzg
    --[[
    local UsrMsgManager = require("common.manager.UsrMsgManager")
    local CommonGoldView    = require("hall.bean.CommonGoldView")      --通用金币框
    ]]--

local TAG_BTN_SELECT = {
    Info        = 1,
    Tutorial    = 2,
    Detail      = 3,
    Detail      = 4,
    Detail      = 5,
    Detail      = 6,
}

local G_SpreadLayer = nil
function SpreadLayer.create()
    G_SpreadLayer = SpreadLayer.new():init()
    return G_SpreadLayer
end

function SpreadLayer:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()
    self.select_type = 1
    self.m_rootUI = display.newNode()
        :addTo(self)
    self.m_rootUI:setCascadeOpacityEnabled(true)
end

function SpreadLayer:init()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)

    self.m_pathUI = cc.CSLoader:createNode("dt/ShareWindow.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.center    = self.m_pathUI:getChildByName("center")
    local diffX = display.size.width/2
    self.center:setPositionX(diffX)
    self.m_pImageBg         = self.center:getChildByName("image_Bg")
    self.m_pNodeSub     = self.m_pImageBg:getChildByName("Panel_node")
    self.topTab     =  self.m_pImageBg:getChildByName("topTab")
    self.button_MyShare = self.topTab:getChildByName("button_MyShare")
    self.button_MyPlayer = self.topTab:getChildByName("button_MyPlayer")
    self.button_MyAchieve = self.topTab:getChildByName("button_MyAchieve")
    self.button_MyAgent = self.topTab:getChildByName("button_MyAgent")
    self.button_ReceiveAwards = self.topTab:getChildByName("button_ReceiveAwards")
    self.button_RewardIntroduce = self.topTab:getChildByName("button_RewardIntroduce")

    self.m_pBtnClose    = self.m_pImageBg:getChildByName("button_closeBtn") 

    self.m_pButtonTable ={self.button_MyShare,self.button_MyPlayer,self.button_MyAchieve,
                   self.button_MyAgent,self.button_ReceiveAwards,self.button_RewardIntroduce}
--[[
    self.m_pImageBg         = self.m_pNodeRoot:getChildByName("Image_bg")
    self.m_pNodeCommonGold  = self.m_pNodeRoot:getChildByName("Panel_node_common_gold") 
--    local commonGold = CommonGoldView:create("SpreadLayer")
--    commonGold:addTo(self.m_pNodeCommonGold)
--     --游戏才显示金币和银行金币
--    if not GameListManager.getInstance():getIsLoginGameSucFlag() then
--        commonGold:setVisible(false)
--    end

    self.m_pNodeSub     = self.m_pImageBg:getChildByName("Panel_node") 
    self.m_pBtnClose    = self.m_pImageBg:getChildByName("BTN_close") 
    self.m_pBtnTable = {}
    for i = 1,6 do
        self.m_pBtnTable[i] = self.m_pImageBg:getChildByName("Panel_button_info" .. i):getChildByName("BTN_info" .. i) 
    end
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))

    self.m_pButtonTable = {}
    for i = 1, 6 do
        self.m_pButtonTable[i] = {}
        local nodeName = "Panel_button_info"..i
        for j = 1, 2 do
            self.m_pButtonTable[i][j] = self.m_pImageBg:getChildByName(nodeName):getChildByName("Image_" .. j)
        end
    end

    self:initTouchEvent()
    self:refreshButtonStatus(1)
    --]]
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))
    self:initTouchEvent()
    self:refreshButtonStatus(1)
    return self
end

function SpreadLayer:onEnter()
    self.super:onEnter()
    self:showWithStyle()
    self.updateNickHead_listener    = SLFacade:addCustomEventListener(Hall_Events.MSG_OPEN_SPREADRX_LAYER, handler(self, self.jumpToxiangqing))
    GlobalUserItem.tabAccountInfo.savePageData = {}
end

function SpreadLayer:initTouchEvent()
    for nIndex=1,6 do
        --self.m_pBtnTable[nIndex]:setZoomScale(0) -- 禁用缩放
        self.m_pButtonTable[nIndex]:addTouchEventListener(function(sender,eventType)
            if (nIndex == self.select_type) then return end

            if eventType==ccui.TouchEventType.began then
                ExternalFun.playClickEffect()

            elseif eventType==ccui.TouchEventType.canceled then

            elseif eventType==ccui.TouchEventType.ended then 
                self:onTableClicked(nIndex)
            end
        end)
    end
end

function SpreadLayer:isSameDay(date1, date2)
    return date1 == date2
end

function SpreadLayer:onExit()
    self.super:onExit()
    self:cleanTemporaryStorage() 
    SLFacade:removeEventListener(self.UpdataSpreadInfo)
    SLFacade:removeEventListener(self.m_pCloseSelf)
    SLFacade:removeEventListener(self.updateNickHead_listener)
    G_SpreadLayer = nil
end

function SpreadLayer:cleanTemporaryStorage()
    GlobalUserItem.tabAccountInfo.webLink = nil
    GlobalUserItem.tabAccountInfo.extension = nil
    GlobalUserItem.tabAccountInfo.agent_userlist = nil
    GlobalUserItem.tabAccountInfo.AchieveData = nil
    GlobalUserItem.tabAccountInfo.receveAchieveData = nil
    GlobalUserItem.tabAccountInfo.myAgentData = nil
    GlobalUserItem.tabAccountInfo.savePageData = nil
end

function SpreadLayer:onReturnClicked()
    ExternalFun.playClickEffect()
    
    self:onMoveExitView()
end

function SpreadLayer:jumpToxiangqing()
    self:onTableClicked(5)
end

function SpreadLayer:onTableClicked(index)

    self.select_type = index
    self:refreshButtonStatus(index)
end

function SpreadLayer:refreshButtonStatus(index)

    for i = 1, 6 do
        if i == index  then
            self.m_pButtonTable[i]:setBright(false)
        else
            self.m_pButtonTable[i]:setBright(true)
        end       
    end

    self:cleanSubView()
    self:showSubView(index)
end

function SpreadLayer:showSubView(index)
    local diffX,commenY = -250,-140

    if index == 1 then
      self.m_pSpreadInfoView = SpreadInfoView:create()
      self.m_pSpreadInfoView:setPosition(-130,-120)
      self.m_pNodeSub:addChild(self.m_pSpreadInfoView)
    elseif index == 2 then
      self.m_pSpreadMyPlayerView = SpreadMyPlayerView:create()
      self.m_pSpreadMyPlayerView:setPosition(diffX,commenY)
      self.m_pNodeSub:addChild(self.m_pSpreadMyPlayerView)
    elseif index == 3 then
      self.m_pSpreadMyAchieveView = SpreadMyAchieveView:create()
      self.m_pSpreadMyAchieveView:setPosition(diffX,commenY)
      self.m_pNodeSub:addChild(self.m_pSpreadMyAchieveView)
    elseif index == 4 then
      self.m_pSpreadMyAgentView = SpreadMyAgentView:create()
      self.m_pSpreadMyAgentView:setPosition(diffX,commenY)
      self.m_pNodeSub:addChild(self.m_pSpreadMyAgentView)
    elseif index == 5 then
      self.m_pSpreadReceiveAwardsView = SpreadReceiveAwardsView:create()
      self.m_pSpreadReceiveAwardsView:setPosition(diffX,commenY+50)
      self.m_pNodeSub:addChild(self.m_pSpreadReceiveAwardsView)
    elseif index == 6 then
      self.m_pSpreadRewardIntroduceView = SpreadRewardIntroduceView:create()
      self.m_pSpreadRewardIntroduceView:setPosition(diffX,commenY)
      self.m_pNodeSub:addChild(self.m_pSpreadRewardIntroduceView)
    end
end

function SpreadLayer:cleanSubView()
    if (self.m_pSpreadInfoView) then
        self.m_pSpreadInfoView:removeFromParent()
        self.m_pSpreadInfoView = nil
    end
    if (self.m_pSpreadMyPlayerView) then
        self.m_pSpreadMyPlayerView:removeFromParent()
        self.m_pSpreadMyPlayerView = nil
    end
    if (self.m_pSpreadMyAchieveView) then
        self.m_pSpreadMyAchieveView:removeFromParent()
        self.m_pSpreadMyAchieveView = nil
    end
    if (self.m_pSpreadMyAgentView) then
        self.m_pSpreadMyAgentView:removeFromParent()
        self.m_pSpreadMyAgentView = nil
    end
    if (self.m_pSpreadReceiveAwardsView) then
        self.m_pSpreadReceiveAwardsView:removeFromParent()
        self.m_pSpreadReceiveAwardsView = nil
    end
    if (self.m_pSpreadRewardIntroduceView) then
        self.m_pSpreadRewardIntroduceView:removeFromParent()
        self.m_pSpreadRewardIntroduceView = nil
    end
end

return SpreadLayer
--endregion
