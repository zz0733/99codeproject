--region ServiceView.lua
--Desc: 客服页面

local ServiceView = class("ServiceView", cc.Layer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
function ServiceView:ctor()
    self:enableNodeEvents()
    self:init()

    if ServiceView.instance_ then
        ServiceView.instance_:removeFromParent()
        ServiceView.instance_ = nil
    end
end

function ServiceView:onEnter()
  --  SLFacade:addCustomEventListener(Public_Events.MSG_ENTER_FOREGROUND, handler(self, self.onMsgForeGround), self.__cname)
    ServiceView.instance_ = self
end

function ServiceView:onExit()
--    SLFacade:removeCustomEventListener(Public_Events.MSG_ENTER_FOREGROUND, self.__cname)
    ServiceView.instance_ = nil
end

function ServiceView:init()
    
    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)

    --init csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/ServiceLayer.csb")
    local diffY = (display.height - 750) / 2
    self.m_pathUI:setPositionY(diffY)
    self.m_pathUI:addTo(self.m_rootUI)

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("node_rootUI")
    local diffX = (display.width - 1334) / 2
    self.m_pNodeRoot:setPositionX(diffX)

    -- 关闭按钮
    self.m_pBtnClose = self.m_pNodeRoot:getChildByName("BTN_close")
    self.m_pBtnClose:addClickEventListener(handler(self,self.onReturnClicked))
    self.m_pBtnClose:setPositionX(self.m_pBtnClose:getPositionX() + (display.width - 1334) / 2)

    -- 客服界面
    self:addWebView()
end

function ServiceView:addWebView()

    if device.platform == "windows" then
         return
    end

    if self.m_pWebView then
        self.m_pWebView:removeFromParent()
        self.m_pWebView = nil
    end

    --客服webView
    self.m_pWebView = ccexp.WebView:create()
    self.m_pWebView:setPosition(cc.p(667,0))
    self.m_pWebView:setAnchorPoint(cc.p(0.5,0))
    self.m_pWebView:setContentSize(cc.size(display.width, 668))
    self.m_pWebView:setScalesPageToFit(true)
    self.m_pWebView:setOnShouldStartLoading(function(sender, url)
        print("setOnShouldStartLoading, url is ", url)
        return self:onWebViewShouldStartLoading(sender, url)
    end)
    self.m_pWebView:setOnDidFinishLoading(function(sender, url)
        print("setOnDidFinishLoading, url is ", url)
        self:onWebViewDidFinishLoading(sender, url)
    end)
    self.m_pWebView:setOnDidFailLoading(function(sender, url)
        print("setOnDidFailLoading, url is ", url)
        self:onWebViewDidFailLoading(sender, url)
    end)
    self.m_pWebView:addTo(self.m_pNodeRoot)

    --open
    local strUrl = "https://chat7.livechatvalue.com/chat/chatClient/chatbox.jsp?companyID=919952&configID=62602&jid=2988069417&s=1"
    --ClientConfig:getInstance():getChatClientUrl()
    self.m_pWebView:loadURL(strUrl)
end

function ServiceView:onWebViewShouldStartLoading(sender, url)

    if device.platform == "android" then
        if (string.find(url, ".apk")) ~= nil then --跳转
            LuaNativeBridge:getInstance():openURL(url)
            return false  
        end
    end
    return true
end

function ServiceView:onWebViewDidFinishLoading(sender, url)

end

function ServiceView:onWebViewDidFailLoading(sender, url)

end

function ServiceView:onMsgForeGround()
    self:addWebView()
end

function ServiceView:onReturnClicked(pSender)
    ExternalFun.playClickEffect()
    self:removeFromParent()
end

return ServiceView
