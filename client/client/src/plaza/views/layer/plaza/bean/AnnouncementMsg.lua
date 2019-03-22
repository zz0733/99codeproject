--region AnnouncementMsg.lua

local UsrMsgManager     = appdf.req(appdf.EXTERNAL_SRC .. "UsrMsgManager")
local CBroadcastManager = appdf.req(appdf.EXTERNAL_SRC .. "CBroadcastManager")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame") 
local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local AnnouncementMsg = class("AnnouncementMsg", FixLayer)

local TAG_IN_HALL = 0
local TAG_IN_NOTICE = 1

function AnnouncementMsg:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()
    self:init()
end

function AnnouncementMsg:onEnter()
    self.super:onEnter()

    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)
    self:showWithStyle()
end

function AnnouncementMsg:onExit()
    self.super:onExit()

end

function AnnouncementMsg:init()
    self:initCSB()
    self:initNode()
    self:initBtnEvent()
end

function AnnouncementMsg:initCSB()

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    --csb
    self.m_pathUI = cc.CSLoader:createNode("dt/MailDetailNew.csb")
    self.m_pathUI:setPositionY((display.height - 720) / 2)
    self.m_pathUI:addTo(self.m_rootUI)

    --node
    self.m_pImageBg = self.m_pathUI:getChildByName("Image_1")
    self.m_pMsgView = self.m_pImageBg:getChildByName("scrollView_contentScroll")

    self.m_pBtnReturn  = self.m_pImageBg:getChildByName("button_closeBtn")
    --size
    self.m_size_view = self.m_pMsgView:getContentSize()
    self.m_pFujian  = self.m_pImageBg:getChildByName("node_fujian"):setVisible(false)

    self.m_pBtnDetele  = self.m_pImageBg:getChildByName("button_deteleMailBtn")    -- 删除
end

function AnnouncementMsg:initNode()
    
    self.m_pMsgView:setScrollBarEnabled(false)

    self.m_pLayerView = cc.Layer:create()
--    self.m_pLayerView:setAnchorPoint(cc.p(0,1))
    self.m_pLayerView:addTo(self.m_pMsgView)
end

function AnnouncementMsg:initBtnEvent()
    self.m_pBtnDetele:addClickEventListener(handler(self, self.onDeteleClicked))
    self.m_pBtnReturn:addClickEventListener(handler(self, self.onReturnClicked))
end

-- 关闭
function AnnouncementMsg:onReturnClicked()
    ExternalFun.playClickEffect()

    --关闭界面
    self:onMoveExitView()
end
-- 关闭
function AnnouncementMsg:onDeteleClicked()
    ExternalFun.playClickEffect()   
    --关闭界面
    self:onMoveExitView()
       self._queryDialog = QueryDialog:create(("是否删除该条消息记录？"), function(ok)
        if ok == true then
        SLFacade:dispatchCustomEvent("SHANCHU")
        end
        self._queryDialog = nil
    end):setCanTouchOutside(false)
        :addTo(self)
    

end

-- 设置内容 type 0:大厅弹出  1：公告界面弹出
function AnnouncementMsg:setMessage(msg, nType)
    self.m_msg    = msg
    self.Id = msg.dwAnnounceID
    local content = self.m_msg.content
--    --content
    local lb3 = cc.Label:createWithSystemFont(content, "Helvetica", 26) 
    lb3:setAnchorPoint(0, 0)
    lb3:setDimensions(780, 0)
    lb3:setColor(cc.c3b(255, 255, 255))
    lb3:addTo(self.m_pLayerView)

end

return AnnouncementMsg
