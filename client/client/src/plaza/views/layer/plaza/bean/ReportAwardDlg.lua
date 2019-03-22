--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local ExternalFun       = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ReportAwardDlg  = class("ReportAwardDlg",FixLayer)
--local UsrMsgManager   = require("common.manager.UsrMsgManager")
local FloatMessage    = cc.exports.FloatMessage

ReportAwardDlg.instance_ = nil
function ReportAwardDlg.create()
    ReportAwardDlg.instance_ = ReportAwardDlg.new():init()
    return ReportAwardDlg.instance_
end

function ReportAwardDlg:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)
end

function ReportAwardDlg:init()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)

    --init csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/RechargeAwardView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("RechargeAwardView")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)


    self.m_pTextAward = self.m_pNodeRoot:getChildByName("Image_bg"):getChildByName("Text_Tips4")
    local imageBottom = self.m_pNodeRoot:getChildByName("Image_bg"):getChildByName("Image_Bottom")
    self.m_pBtnOpen = imageBottom:getChildByName("Button_Report")
    self.m_pBtnOpen:addClickEventListener(handler(self, self.onOpenClicked))
    self.m_pBtnClose = self.m_pNodeRoot:getChildByName("Image_bg"):getChildByName("Button_close")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseClicked))
    self.m_pTextAward:setString("3000元")--LuaUtils.getLocalString("RECHARGE_3"))

    --logo/号码/按钮字
    self.m_pImageLogo = imageBottom:getChildByName("Image_Icon")
    self.m_pTextOfficial = imageBottom:getChildByName("Text_Account")
    --self.m_pTextCopy = self.m_pBtnOpen:getChildByName("Image_1")

--    self:updateWeChat()

    return self
end

function ReportAwardDlg:onEnter()
    self.super:onEnter()
    self:showWithStyle()
end

function ReportAwardDlg:onExit()
    self:stopAllActions()
    self.super:onExit()
    ReportAwardDlg.instance_ = nil
end

function ReportAwardDlg:onCloseClicked()
    ExternalFun.playSoundEffect("public/sound/sound-close.mp3")

    self:onMoveExitView()
end

function ReportAwardDlg:onOpenClicked()
    ExternalFun.playSoundEffect("public/sound/sound-button.mp3")
    FloatMessage:getInstance():pushMessage("复制成功")
    cc.Application:getInstance():openURL("weixin://")
--    local self = ReportAwardDlg.instance_

--    local iType = UsrMsgManager.getInstance():getReportAwardType()--0微信/1QQ
--    local strAccount = UsrMsgManager.getInstance():getReportawardAccount()

--    --复制成功
--    LuaNativeBridge.getInstance():setCopyContent(strAccount)
--    FloatMessage.getInstance():pushMessage("STRING_204")

--    if iType == 0 then
--        local canOpen = LuaNativeBridge:getInstance():isWeChatInstall()
--        if canOpen then
--            LuaNativeBridge:getInstance():openURL("weixin://")
--        else
--            FloatMessage.getInstance():pushMessage("STRING_046_1")
--        end
--    else
--        local canOpen = LuaNativeBridge:getInstance():isQQInstall()
--        if canOpen then
--            LuaNativeBridge:getInstance():openURL("mqqwpa://im/chat?chat_type=wpa&uin="..strAccount.."&version=1")
--        else
--            FloatMessage.getInstance():pushMessage("STRING_046_6")
--        end
--    end
end

function ReportAwardDlg:updateWeChat()
    local iType = UsrMsgManager.getInstance():getReportAwardType()
    local strAccount = UsrMsgManager.getInstance():getReportawardAccount()
    
    local path = iType == 0 and "hall/plist/shop/gui-shop-agent-icon-wx.png" or "hall/plist/shop/gui-shop-agent-icon-koukou.png"
    self.m_pImageLogo:loadTexture(path, ccui.TextureResType.plistType)

    local account = LuaUtils.getDisplayNickName2(strAccount, 250, "Helvetica", 32, "...")
    self.m_pTextOfficial:setString(account)

    local path2 = (iType == 0) and "hall/plist/shop/gui-shop-btn-copy-wx.png" or "hall/plist/shop/gui-shop-btn-copy-koukou.png"
    --self.m_pTextCopy:loadTexture(path2, ccui.TextureResType.plistType)
    self.m_pBtnOpen:loadTextureNormal(path2, ccui.TextureResType.plistType)
end

return ReportAwardDlg


--endregion
