--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local ExternalFun       = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local AgentContactDlg = class("AgentContactDlg",FixLayer)
local FloatMessage = cc.exports.FloatMessage

AgentContactDlg.instance_ = nil

function AgentContactDlg:create(_agentNum,_agentName, _agentType)
    self.agentNum = _agentNum
    self.agentName = _agentName
    self.agentType = _agentType
    AgentContactDlg.instance_ = AgentContactDlg.new():init()
    return AgentContactDlg.instance_
end

function AgentContactDlg:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)
end

function AgentContactDlg:init()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)

     --init csb
    self.m_pathUI = cc.CSLoader:createNode("dt/ZCShopTpsView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("center")
    local diffX = display.size.width/2
    self.m_pNodeRoot:setPositionX(diffX)

    local imageBg = self.m_pNodeRoot:getChildByName("image_Bg")
    self.m_pAgentText = imageBg:getChildByName("Image_20"):getChildByName("text_numberLabel")
    self.m_pAgentName = imageBg:getChildByName("Image_20"):getChildByName("Image_5"):getChildByName("text_nameDes")
    self.m_pButtonOpen = imageBg:getChildByName("Image_20"):getChildByName("button_copyBtn")
    self.m_pButtonOpen:addClickEventListener(handler(self, self.onOpenClicked))
    self.m_pBtnClose = imageBg:getChildByName("button_closeBtn")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseClicked))

    local account = LuaUtils.getDisplayNickName2(self.agentNum, 190, "Helvetica", 34, "...")
    self.m_pAgentText:setString(account)
    local accountName = LuaUtils.getDisplayNickName2(self.agentName, 190, "Helvetica", 34, "...")
    self.m_pAgentName:setString(accountName)

--    local strImgName = "hall/plist/shop/gui-shop-agent-icon-wx.png"
--    local strBtnImage = "hall/plist/shop/gui-shop-btn-copy-wx.png"
--    --1微信2qq
--    if self.agentType == 2 then
--        strImgName = "hall/plist/shop/gui-shop-agent-icon-koukou.png"
--        strBtnImage = "hall/plist/shop/gui-shop-btn-copy-koukou.png"
--    end
--    self.m_pAgentSp:loadTexture(strImgName, ccui.TextureResType.plistType)
    --self.m_pButtonSp:loadTexture(strBtnImage, ccui.TextureResType.plistType)
--    self.m_pButtonOpen:loadTextureNormal(strBtnImage, ccui.TextureResType.plistType)
    
    return self
end

function AgentContactDlg:onEnter()
    self.super:onEnter()
    self:showWithStyle()
end

function AgentContactDlg:onExit()
    self:stopAllActions()
    self.super:onExit()
    AgentContactDlg.instance_ = nil
end

function AgentContactDlg:onCloseClicked()
    ExternalFun.playSoundEffect("public/sound/sound-close.mp3")

    self:onMoveExitView()
end

function AgentContactDlg:onOpenClicked()
    ExternalFun.playSoundEffect("public/sound/sound-button.mp3")
    local self = AgentContactDlg.instance_
    
    FloatMessage.getInstance():pushMessage("STRING_204")
    cc.Application:getInstance():openURL("weixin://")
--    --根据是qq还是微信跳转app    --1微信2qq
--    if self.agentType == 2 then
--        local canOpen = LuaNativeBridge:getInstance():isQQInstall()
--        if canOpen then
--            LuaNativeBridge:getInstance():openURL("mqqwpa://im/chat?chat_type=wpa&uin="..self.agentNum.."&version=1")
--        else
--            FloatMessage.getInstance():pushMessage("STRING_046_6")
--        end
--    else
--        local canOpen = LuaNativeBridge:getInstance():isWeChatInstall()
--        if canOpen then
--            LuaNativeBridge:getInstance():openURL("weixin://")
--        else
--            FloatMessage.getInstance():pushMessage("STRING_046_1")
--        end
--    end
end

return AgentContactDlg

--endregion
