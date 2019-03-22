--region AccountViewItem.lua
--Desc: 帐号 view


local AccountViewItem = class("AccountViewItem", cc.Node)
local RegisterView = appdf.req(appdf.CLIENT_SRC .."plaza.views.layer.logon.RegisterView")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .."ExternalFun")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame")
function AccountViewItem:ctor()
    self:enableNodeEvents()

    self:init()
end

function AccountViewItem:init()

    --root
    self.m_rootUI = cc.CSLoader:createNode("hall/csb/LoginAccountItem.csb")
    self.m_rootUI:addTo(self)

    self.m_pNodeRoot = self.m_rootUI:getChildByName("Node_root")
    
    --账号
    self.m_pNodeAccount  = self.m_pNodeRoot:getChildByName("Node_acount")
    self.m_pImgFrame     = self.m_pNodeAccount:getChildByName("Image_frame")
    self.m_pImgHead      = self.m_pNodeAccount:getChildByName("Image_head")
    self.m_pBtnLogin     = self.m_pNodeAccount:getChildByName("Button_login")
    self.m_pTextNickName = self.m_pNodeAccount:getChildByName("Text_Nick")
    self.m_pTextGameID   = self.m_pNodeAccount:getChildByName("Text_ID")
    self.m_pTextAccount  = self.m_pNodeAccount:getChildByName("Text_Phone")
    self.m_pSpVip        = self.m_pNodeAccount:getChildByName("Sprite_Vip")

    --注册
    self.m_pNodeRegister = self.m_pNodeRoot:getChildByName("Node_register")
    self.m_pBtnAdd       = self.m_pNodeRegister:getChildByName("Button_Add")
    self.m_pBtnRegister  = self.m_pNodeRegister:getChildByName("Button_regstier")

    --绑定
    self.m_pBtnLogin:addClickEventListener(handler(self, self.onLoginClicked))
    self.m_pBtnRegister:addClickEventListener(handler(self, self.onRegisterClicked))
    self.m_pBtnAdd:addClickEventListener(handler(self, self.onRegisterClicked))
end

function AccountViewItem:initAccount(account, delegate)
--    if account == nil then
--        return
--    end
--    if account[1] == nil then
--        return
--    end
    self.m_account = account
    self.m_delegate = delegate
    
    if account then
        self.m_pNodeAccount:setVisible(true)
        self.m_pNodeRegister:setVisible(false)
        self:setTextID(account[1])
        self:setImageHead(account[2])
        self:setTextName(account[3])
        self:setPhoneNumber(account[4])
        self:setVipInfo(account[7], account[8])
    else
        self.m_pNodeAccount:setVisible(false)
        self.m_pNodeRegister:setVisible(true)
    end
end

function AccountViewItem:onEnter()

end

function AccountViewItem:onExit()

end

function AccountViewItem:setTextID(userID)
    self.m_pTextGameID:setString(tostring(userID))
end

function AccountViewItem:setTextName(name)
    self.m_pTextNickName:setString(tostring(name))
end 

function AccountViewItem:setImageHead(faceID)
    local strHeadIcon = string.format("hall/image/file/gui-icon-head-%02d.png", faceID + 1)
    self.m_pImgHead:loadTexture(strHeadIcon, ccui.TextureResType.localType)
end

function AccountViewItem:setPhoneNumber(number)
    if type(tonumber(number)) == "number" and string.len(number) == 11 then
        self.m_pTextAccount:setString(tostring(number))
    else
        self.m_pTextAccount:setString( cc.exports.Localization_cn["USR_DIALOG_33"] )
    end
end

function AccountViewItem:setVipInfo(vipLevel, frameIndex)
    vipLevel = vipLevel or 0
    frameIndex = frameIndex or 0
    --vip图标
    self.m_pSpVip:setSpriteFrame(string.format("hall/plist/vip/icon_VIP%d.png", vipLevel))
    --vip头像框
    local framePath = string.format("hall/plist/userinfo/gui-frame-v%d.png", frameIndex)
    self.m_pImgFrame:loadTexture(framePath, ccui.TextureResType.plistType)
end

function AccountViewItem:onLoginClicked()
    ExternalFun.playClickEffect()    

    if self.m_account[8] == yl.LOGON_TYPE.VISTOR then
        self.m_delegate:sendGuestLogin()
    elseif self.m_account[8] == yl.LOGON_TYPE.PHONE then
        self.m_delegate:phoneNumAccount(self.m_account[4])
    elseif self.m_account[8] == yl.LOGON_TYPE.WECHAT then
        self.m_delegate:logonByWeChat(self.m_account[10], self.m_account[4], self.m_account[3], self.m_account[11])
    else
        self.m_delegate:sendAccountLogin(self.m_account[4], self.m_account[5])
    end
       
end

function AccountViewItem:onRegisterClicked()
    ExternalFun.playClickEffect()
    --打开注册界面
    SLFacade:dispatchCustomEvent(Hall_Events.MSG_SHOW_REGISTER)
end

return AccountViewItem
