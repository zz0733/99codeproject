--region UserCenterLayer.lua
--Date 2017.04.24.
--Auther JackyXu.
--Desc: 大厅个人中心

local UserHeadView      = appdf.req(appdf.PLAZA_VIEW_SRC.."UserHeadView")
local RegisterView      = appdf.req(appdf.CLIENT_SRC .."plaza.views.layer.logon.RegisterView")
local FloatMessage      = cc.exports.FloatMessage
local CommonGoldView    = appdf.req(appdf.CLIENT_SRC .. "plaza.views.layer.plaza.CommonGoldView")     --通用金币框
local HeadSprite = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame") 
local SettingView         = appdf.req(appdf.PLAZA_VIEW_SRC .. "SettingLayer")                       --设置界面
local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
local UserCenterLayer   = class("UserCenterLayer", FixLayer)

local FEMALE = 1
local MALE = 2
local HEAD_2_SEX = {FEMALE,MALE}
local TAG_BTN_SELECT = {
    ZhiFuBao    = 1,
    YingHangKa  = 2,
    UserInfo    = 3,
}
local VIP_MAX = 6

local VIP_VALUE = {
    [0] = 0,
    [1] = 30,
    [2] = 500,
    [3] = 3000,
    [4] = 10000,
    [5] = 30000,
    [6] = 70000,

    [7] = 70000,
}
local G_UserCenterLayer = nil
function UserCenterLayer.create(scene)
    G_UserCenterLayer = UserCenterLayer.new():init(scene)
    return G_UserCenterLayer
end

function UserCenterLayer:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()
    self.m_nLastTouchTime       = 0
    self.m_nEditBoxTouchCount   = 0 -- 输入框点击次数
    self.m_nSelectBankTag       = 1
    self.m_iBindType            = 3
    self.m_bIsModifying         = false
    self.m_pBtnBankerSelect     = {}
    self.m_pVecButtonImage      = {}
    self.m_pEditBox             = { {}, {},}
    self.m_iSelectSex = 1
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    math.random()
    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    local  onUserCenterCallBack = function(result,message)
       self:onUserCenterCallBack(result,message)
    end

    --大厅网络处理
    self._plazaFrame = LogonFrame:getInstance()
    self._plazaFrame:setCallBackDelegate(self, onUserCenterCallBack)
end

function UserCenterLayer:init(scene)
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)
    self._scene = scene
    self.m_pathUI = cc.CSLoader:createNode("dt/DTNewPersonlView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("center")
    local diffX = (display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    self.m_pBtnReturn           = self.m_pNodeRoot:getChildByName("button_closeBtn")
    self.m_userInfo             = self.m_pNodeRoot:getChildByName("node_userInfo")      --用户界面
    self.m_pPanelSetting        = self.m_pNodeRoot:getChildByName("node_setting")       --设置界面 
    self.m_pPanelUser           =  self.m_userInfo:getChildByName("node_infoNode"):getChildByName("Panel_7")
    self.m_pPanelInfo           =  self.m_userInfo:getChildByName("image_info")
    --修改头像
    local nodeHead              = self.m_pPanelUser:getChildByName("image_headBg")
    self.m_pImgHead             = nodeHead:getChildByName("image_icon")
    self.m_pBtnModifyHead       = self.m_pPanelUser:getChildByName("button_headBtn")
    self.m_pVIP                 = nodeHead:getChildByName("sprite_vipSpr"):setVisible(false)
    --ID
    self.m_pLbGameID            = self.m_pPanelUser:getChildByName("text_roleIDtxt")
    self.m_pBtnCopyID           = self.m_pPanelUser:getChildByName("button_copy")
    
    --系统设置按钮
    self.m_pBtnSysUserinfo      = self.m_pNodeRoot:getChildByName("button_cardTypeBtn")
    self.m_pBtnSysSetting       = self.m_pNodeRoot:getChildByName("button_desBtn")

    self.Userinfobtn_select = self.m_pBtnSysUserinfo:getChildByName("image_select")
    self.Userinfobtn_normal = self.m_pBtnSysUserinfo:getChildByName("image_normal")

    self.Settingbtn_select = self.m_pBtnSysSetting:getChildByName("image_desSelect")
    self.Settingbtn_normal = self.m_pBtnSysSetting:getChildByName("image_desNormal")
    --切换账号按钮
    self.m_pBtnLogout           = self.m_pPanelSetting:getChildByName("button_exit")
    --用户昵称
    self.m_pImgNameEdit        = self.m_pPanelUser:getChildByName("text_roleNametxt")
    self.m_pImgNameEdit:setPositionX(self.m_pImgNameEdit:getPositionX()-50)
    self.m_pBtnNameEdit        = self.m_pPanelUser:getChildByName("button_changeName")
    self.m_pBtnNameEdit:setVisible(false)
    --用户金币  
    local nodeGold             = self.m_pPanelUser:getChildByName("Image_3")
    self.m_pLbGold             = nodeGold:getChildByName("bmfont_goldTxt")
    self.m_pLbGoldBtn          = nodeGold:getChildByName("button_addGoldBtn")

    --支付宝绑定
--    self.m_pNodeAlipay         = self.m_pPanelInfo:getChildByName("Node_BindAlipay")
    self.m_pLbAlipay           = self.m_pPanelInfo:getChildByName("text_zhifubao")
    self.m_pBtnBindAlipay      = self.m_pPanelInfo:getChildByName("button_bindIApayBtn")
    --银行卡绑定
--    self.m_pNodeBank           = self.m_pPanelInfo:getChildByName("Node_BindBank")
    self.m_pLbBank             = self.m_pPanelInfo:getChildByName("text_yinhangka")
    self.m_pBtnBindBank        = self.m_pPanelInfo:getChildByName("button_bindBankBtn")
    --手机号绑定(升级正式账号)
--    self.m_pNodeMobile         = self.m_pPanelInfo:getChildByName("Node_BindMobile")
    self.m_pLbMobile           = self.m_pPanelInfo:getChildByName("text_zhanghao")
    self.m_pBtnBindMobile      = self.m_pPanelInfo:getChildByName("button_bindAccountBtn")

    self:initBtnEvent()
    self:SettingInfo()

    return self
end

function UserCenterLayer:onEnter()
    self.super:onEnter()
    self:showWithStyle()

    self.m_pPanelSetting:setVisible(false)
--    self.m_pNodeBank:setVisible(false)
--    self.m_pNodeMobile:setVisible(false)
--    self.m_pLbTips:setVisible(false)
    self:onUpdateBindInfo()
    self:initUsrInfoView()

    self.updateNickHead_listener    = SLFacade:addCustomEventListener(Hall_Events.MSG_NICK_HEAD_MODIFIED, handler(self, self.onMsgUpdateUserInfo))
    self.queryBinding_listener      = SLFacade:addCustomEventListener(Hall_Events.MSG_QUERY_BINDING, handler(self, self.onUpdateBindInfo))
    self.m_pCloseSelf               = SLFacade:addCustomEventListener(Hall_Events.MSG_CLOSE_CURRENT_DIALOG, handler(self, self.onMsgCloseSelf))
    self.m_CloseRegister            = SLFacade:addCustomEventListener(Hall_Events.MSG_CLOSE_REGISTER, handler(self, self.onMsgCloseRegsiter))
    
end

function UserCenterLayer:onExit()
    self.super:onExit()

    SLFacade:removeEventListener(self.updateNickHead_listener)
    SLFacade:removeEventListener(self.m_pCloseSelf)
    G_UserCenterLayer = nil
end


-------------------------msg-------------------------
function UserCenterLayer:onMsgUpdateUserInfo(_event)
    -- 刷新玩家信息
    self:initUsrInfoView()
    self.m_bIsModifying = false

end

--提现绑定信息
function UserCenterLayer:onUpdateBindInfo()

    --支付宝账号
    if GlobalUserItem.tabAccountInfo.payBindMsg == nil or string.len(GlobalUserItem.tabAccountInfo.payBindMsg[1]) == 0 then
        self.m_pBtnBindAlipay:setVisible(true)
        self.m_pLbAlipay:setString( LuaUtils.getLocalString("USR_DIALOG_33") )
        self.m_pLbAlipay:setTextColor(cc.c3b(0xca, 0x17, 0x1b))
    else
        self.m_pBtnBindAlipay:setVisible(false)
        local str_format = LuaUtils.getLocalString("USR_DIALOG_30")
        local str_account = GlobalUserItem.tabAccountInfo.payBindMsg[1]
        local str_account_encode = self:getAccountStringEncode(str_account)
        local str_label = string.format(str_format, str_account_encode)
        self.m_pLbAlipay:setString(str_label)
        self.m_pLbAlipay:setTextColor(cc.c3b(0x14, 0x81, 0x09))
    end

    --银行卡账号
    if GlobalUserItem.tabAccountInfo.payBindMsg == nil or string.len(GlobalUserItem.tabAccountInfo.payBindMsg[4]) == 0 then
        self.m_pBtnBindBank:setVisible(true)
        self.m_pLbBank:setString( LuaUtils.getLocalString("USR_DIALOG_33") )
        self.m_pLbBank:setTextColor(cc.c3b(0xca, 0x17, 0x1b))
    else
        self.m_pBtnBindBank:setVisible(false)
        local str_format = LuaUtils.getLocalString("USR_DIALOG_30")
        local str_account = GlobalUserItem.tabAccountInfo.payBindMsg[4]
        local str_account_encode = self:getAccountStringEncode(str_account)
        local str_label = string.format(str_format, str_account_encode)
        self.m_pLbBank:setString(str_label)
        self.m_pLbBank:setTextColor(cc.c3b(0x14, 0x81, 0x09))
    end

    --手机号码
    if self:checkIsGuestUser() then
       --游客不能修改名字,显示升级按钮
       self.m_pBtnNameEdit:setVisible(false)
       self.m_pBtnBindMobile:setVisible(true)
       self.m_pLbMobile:setString(LuaUtils.getLocalString("EXCHANGE_3"))
       self.m_pLbMobile:setTextColor(cc.c3b(0xca, 0x17, 0x1b))
    else
        --正式账号,可以修改名字
        self.m_pBtnNameEdit:setVisible(false)
        self.m_pBtnBindMobile:setVisible(false)
        local str_format = LuaUtils.getLocalString("USR_DIALOG_30")
        local str_account = GlobalUserItem.tabAccountInfo.telephone
        local str_account_encode = self:getAccountStringEncode(str_account, 3, 4)
        local str_label = string.format(str_format, str_account_encode)
        self.m_pLbMobile:setString(str_label)
        self.m_pLbMobile:setTextColor(cc.c3b(0x14, 0x81, 0x09))
    end
end
function UserCenterLayer:onMsgCloseSelf()
    self:onMoveExitView(FixLayer.HIDE_NO_STYLE)
end
function UserCenterLayer:onMsgCloseRegsiter()

    --手机号码
    if self:checkIsGuestUser() then
       --游客不能修改名字,显示升级按钮
       self.m_pBtnNameEdit:setVisible(false)
       self.m_pBtnBindMobile:setVisible(true)
       self.m_pLbMobile:setString(LuaUtils.getLocalString("EXCHANGE_3"))
       self.m_pLbMobile:setTextColor(cc.c3b(0xca, 0x17, 0x1b))
    else
        --正式账号,可以修改名字
        self.m_pBtnNameEdit:setVisible(false)
        self.m_pBtnBindMobile:setVisible(false)
        local str_format = LuaUtils.getLocalString("USR_DIALOG_32")
        local str_account = GlobalUserItem.tabAccountInfo.telephone
        local str_account_encode = self:getAccountStringEncode(str_account, 3, 4)
        local str_label = string.format(str_format, str_account_encode)
        self.m_pLbMobile:setString(str_label)
        self.m_pLbMobile:setTextColor(cc.c3b(0x14, 0x81, 0x09))
    end
end
function UserCenterLayer:getAccountStringEncode(str, len1, len2)
    
    if type(str) ~= "string" then
        return ""
    end

    len1 = len1 or 4
    len2 = len2 or 4

    if string.len(str) < len1 then
        return str
    end

    if string.len(str) < 8 then
        len1 = 1
        len2 = 1
    end

    local string_len = string.len(str)
    local string_1 = string.sub(str, 1, len1)
    local string_2 = ""
    for i = 1, string_len - len1 - len2 do
        string_2 = string_2 .. "*"
    end
    local string_3 = string.sub(str, string_len - len2 + 1, string_len)
    local string_all = string_1 .. string_2 .. string_3
    return string_all
end
------------------------function---------------------
function UserCenterLayer:initBtnEvent()
    self.m_pBtnReturn:addClickEventListener(handler(self,self.onCloseClicked))
    self.m_pBtnModifyHead:addClickEventListener(handler(self,self.onClickedHead))
    self.m_pBtnSysSetting:addClickEventListener(handler(self,self.onClickedSetting)) 
    self.m_pBtnSysUserinfo:addClickEventListener(handler(self,self.onClickedUserinfo)) 
    self.m_pBtnLogout:addClickEventListener(handler(self,self.onClickedLogout))       
    self.m_pBtnCopyID:addClickEventListener(handler(self,self.onCopyGameID))
    self.m_pLbGoldBtn:addClickEventListener(handler(self,self.onGoldBank))
    self.m_pBtnBindAlipay:addClickEventListener(handler(self,self.onBindZhifubaoClicked))
    self.m_pBtnBindBank:addClickEventListener(handler(self,self.onBindBankClicked)) 
    self.m_pBtnBindMobile:addClickEventListener(handler(self,self.onInstantRegisterClicked))
end
function UserCenterLayer:SettingInfo()
    local music = self.m_pPanelSetting:getChildByName("slider_music")    --音乐
    local a = GlobalUserItem.nMusic
    music:setPercent(a)
    music:addEventListener(function(ref,eventType)
                print(ref:getPercent())
                self:Slider_Music(ref:getPercent())
            end)
    local voice = self.m_pPanelSetting:getChildByName("slider_voice")    --音效
    local b = GlobalUserItem.nSound;
    voice:setPercent(b)
    voice:addEventListener(function(ref,eventType)
                print(ref:getPercent())
                self:Slider_Voice(ref:getPercent())
            end)
end
function UserCenterLayer:Slider_Music(music)
    GlobalUserItem.setMusicVolume(music) 
end
function UserCenterLayer:Slider_Voice(voice)
    GlobalUserItem.setEffectsVolume(voice) 
end
function UserCenterLayer:checkIsGuestUser()
    local isGuest = false
    if GlobalUserItem.tabAccountInfo.telephone == "" then
        isGuest = true
    end
    return isGuest
end

function UserCenterLayer:createEditBox(maxLength, keyboardReturnType, inputMode, inputFlag, tag, size, placestr)
    local sprite1 = ccui.Scale9Sprite:createWithSpriteFrameName("hall/plist/userinfo/gui-userinfo-null.png")
    local sprite2 = ccui.Scale9Sprite:createWithSpriteFrameName("hall/plist/userinfo/gui-userinfo-null.png")
    local sprite3 = ccui.Scale9Sprite:createWithSpriteFrameName("hall/plist/userinfo/gui-userinfo-null.png")
    size = cc.size(size.width, 35)
    local editBox = cc.EditBox:create(size, sprite1, sprite2, sprite3)
    editBox:setMaxLength(maxLength)
    editBox:setReturnType(keyboardReturnType)
    editBox:setInputMode(inputMode)
    editBox:setInputFlag(inputFlag)
    editBox:setTag(tag)
    editBox:setPlaceHolder(placestr)
    if device.platform ~= "ios" and device.platform ~= "mac" then
        editBox:setPlaceholderFontName("Microsoft Yahei")
        editBox:setPlaceholderFontSize(25)
        editBox:setPlaceholderFontColor(cc.c3b(171,120,70))
    end
    editBox:setFont("Microsoft Yahei", 25)
    editBox:setFontColor(cc.c3b(108,59,27))
    editBox:setAnchorPoint(cc.p(0, 0))
    
    -- 模拟点击输入框解决 android 手机首次输入看不到输入内容BUG。
--    if device.platform == "android" then
--        self.m_nEditBoxTouchCount = 0
--        editBox:touchDownAction(editBox,ccui.TouchEventType.ended)
--        editBox:touchDownAction(editBox,ccui.TouchEventType.canceled)
--    else
--        self.m_nEditBoxTouchCount = 2
--    end

    return editBox
end

function UserCenterLayer:onEditBoxEventHandle(event, pSender)
    if "began" == event then
        if self.m_nEditBoxTouchCount > 0 then
        end
    elseif "ended" == event then
        self.m_nEditBoxTouchCount = self.m_nEditBoxTouchCount + 1
        if self.m_nEditBoxTouchCount > 1 then
            self:modifyNickName()
        else
            local strNickName =GlobalUserItem.tabAccountInfo.nickname
            self.m_pEditBoxNickName:setText(strNickName)
        end
    elseif "return" == event then
    elseif "changed" == event then
    end
end

function UserCenterLayer:modifyNickName()
    local strNickName = self.m_pEditBoxNickName:getText()
    if yl.getCharLength(strNickName) <= 0 then
        FloatMessage.getInstance():pushMessage("STRING_106")
        return
    end
    
    if not yl.isNickVaild(strNickName) then
        FloatMessage.getInstance():pushMessage("STRING_103")
        return
    end
    
    if strNickName == GlobalUserItem.tabAccountInfo.nickname then
        FloatMessage.getInstance():pushMessage("STRING_107")
        return
    end
    
    local length =  yl.getCharLength(strNickName)
    if length < 6 or length > 16 then
        FloatMessage.getInstance():pushMessage("STRING_006")
        return
    end
    if length > 16 then
        local strName = string.sub(strNickName,1,16)
        self.m_pEditBoxNickName:setText(strName)
    end

    --CMsgHall:sendModifyNickName(strNickName)
end

-------------------------init----------------------------
function UserCenterLayer:initUsrInfoView()
--    if self:checkIsGuestUser() then
--        if not self.m_pImgNameEdit then
            local strNickName = GlobalUserItem.tabAccountInfo.nickname--PlayerInfo.getInstance():getUserName()
--            local pLable = cc.Label:createWithSystemFont(strNickName, "Helvetica", 28)
--            pLable:setAnchorPoint(cc.p(0, 0))
--            pLable:setPosition(cc.p(20, 15))
--            pLable:setName("lbNickName")
--            pLable:setTextColor(cc.c3b(0x62,0x39,0x1D))
            self.m_pImgNameEdit:setString(strNickName)
--        end
--    else
--        if not self.m_pEditBoxNickName then
--            self.m_pEditBoxNickName = self:createEditBox(16,
--                                              cc.KEYBOARD_RETURNTYPE_DONE,
--                                              cc.EDITBOX_INPUT_MODE_SINGLELINE,
--                                              cc.EDITBOX_INPUT_FLAG_SENSITIVE,
--                                              0,
--                                              cc.size(300, 40),
--                                              LuaUtils.getLocalString("USR_CENTER_1"))
--            self.m_pEditBoxNickName:setPosition(cc.p(15, 10))
--            self.m_pEditBoxNickName:registerScriptEditBoxHandler(handler(self, self.onEditBoxEventHandle))
--            self.m_pImgNameEdit:addChild(self.m_pEditBoxNickName)

--            --fix bug ，游客注册完成界面没刷新bug
--            local lb = self.m_pImgNameEdit
--            if lb ~= nil then
--                lb:removeFromParent()
--            end
--            self.m_pBtnBindMobile:setVisible(false)
--        end
--        local strNickName = GlobalUserItem.tabAccountInfo.nickname--PlayerInfo.getInstance():getUserName()
--        self.m_pEditBoxNickName:setText(strNickName)
--        --self.m_pEditBoxNickName:setEnabled(false)
--    end
    
    self.m_pLbGameID:setString(GlobalUserItem.tabAccountInfo.userid)
    local goldNum = GlobalUserItem.tabAccountInfo.bag_money--PlayerInfo.getInstance():getUserScore()
    self.m_pLbGold:setString( LuaUtils.getFormatGoldAndNumber(goldNum) )
--    local bankNum = GlobalUserItem.tabAccountInfo.bank_money--PlayerInfo.getInstance():getUserInsure()
--    self.m_pLbBankGold:setString( LuaUtils.getFormatGoldAndNumber(bankNum) )


    local head = HeadSprite:createClipHead(GlobalUserItem.tabAccountInfo,129)
    head:setAnchorPoint(cc.p(0,0))
    self.m_pImgHead:addChild(head)

--    local frameIndex = GlobalUserItem.tabAccountInfo.vip_level--PlayerInfo.getInstance():getFrameID()
--    local framePath = string.format("hall/plist/userinfo/gui-frame-v%d.png", frameIndex)
--    self.m_pImgFrame:loadTexture(framePath, ccui.TextureResType.plistType)

    --vip
--    local vipLev = GlobalUserItem.tabAccountInfo.vip_level--PlayerInfo.getInstance():getVipLevel()
--    local vipPath = string.format("hall/plist/vip/icon_big_VIP%d.png", vipLev)
--    self.m_pImgVip:loadTexture(vipPath, ccui.TextureResType.plistType)

--    local vipPath1 = string.format("hall/plist/vip/img-vip%d.png", vipLev)
--    self.m_pImgVipLeft:loadTexture(vipPath1, ccui.TextureResType.plistType)
    
--    if vipLev < 6 then
--        local vipPath2 = string.format("hall/plist/vip/img-vip%d.png", vipLev + 1)
--        self.m_pImgVipRight:loadTexture(vipPath2, ccui.TextureResType.plistType)
--    else
--        self.m_pImgVipRight:setVisible(false)
--    end

--    local value = GlobalUserItem.tabAccountInfo.vip_level/100
--    local percent = self:getVipPercentByValue(value)
--    self.m_pBarVip:setPercent(percent * 100)

--    value = value > VIP_VALUE[6] and VIP_VALUE[6] or value
--    local strValue = string.format("%.0f/%.0f", value, VIP_VALUE[vipLev+1])
--    self.m_pLabelValue:setString(strValue)
end
----------------------------------------
function UserCenterLayer:getVipPercentByValue(value)
    
    for i = 1, VIP_MAX do
        if value < VIP_VALUE[i] then
            return value / VIP_VALUE[i]
        end
    end
    return 100
end

function UserCenterLayer:getVipLevelByValue(value)
    
    for i = 1, VIP_MAX do
        if value < VIP_VALUE[i] then
            return i - 1
        end
    end
    return VIP_MAX
end
    
function UserCenterLayer:getVipRechargeByValue(value)
    
    for i = 1, VIP_MAX do
        if value < VIP_VALUE[i] then
            return VIP_VALUE[i] - value
        end
    end
    return 0
end

----------------------------------------
--------------------------click-----------------------------
-- 头像
function UserCenterLayer:onClickedHead()
    ExternalFun.playClickEffect()
    local pUserHead = self.m_rootUI:getChildByName("UserHeadView")
    if pUserHead then
        pUserHead:setVisible(true)
        return
    end
    pUserHead = UserHeadView:create()
    pUserHead:setName("UserHeadView")
    self.m_rootUI:addChild(pUserHead)
end
--系统设置
function UserCenterLayer:onClickedSetting()
    ExternalFun.playClickEffect()
    self.m_pPanelSetting:setVisible(true)
    self.m_userInfo:setVisible(false)
    self:changebtnView(2)
--    if self:getChildByName("SettingView") then
--        self:getChildByName("SettingView"):setVisible(true)
--        return
--    end

--    local pSettingView = SettingView.create(self._scene)
--    pSettingView:setName("SettingView")
--    self:addChild(pSettingView, 10)
end

function UserCenterLayer:changebtnView(tag)
    if tag == 1 then
       self.Userinfobtn_select:setVisible(true)
       self.Userinfobtn_normal:setVisible(false)
       self.Settingbtn_select:setVisible(false) 
       self.Settingbtn_normal:setVisible(true)
    else
       self.Userinfobtn_select:setVisible(false)
       self.Userinfobtn_normal:setVisible(true)
       self.Settingbtn_select:setVisible(true) 
       self.Settingbtn_normal:setVisible(false)
    end
end

--系统设置
function UserCenterLayer:onClickedUserinfo()
    ExternalFun.playClickEffect()
    self.m_pPanelSetting:setVisible(false)
    self.m_userInfo:setVisible(true)
    self:changebtnView(1)
end

--切换账号
function UserCenterLayer:onClickedLogout()
    ExternalFun.playClickEffect()
    if self._queryDialog then
        return
    end
   self._queryDialog = QueryDialog:create(yl.getLocalString("MESSAGE_11"), function(ok)
        if ok == true then
        cc.UserDefault:getInstance():setBoolForKey("noNeedAutoLogin",true)
        SLFacade:dispatchCustomEvent(Hall_Events.SHOW_EXIT_VIEW,"exit")
        end
        self._queryDialog = nil
    end):setCanTouchOutside(false)
        :addTo(self)
end
-- 充值
function UserCenterLayer:onGoldBank()
    ExternalFun.playClickEffect()
    local _event = {
        name = Hall_Events.MSG_SHOW_SHOP,
        packet = nil,
    }
    SLFacade:dispatchCustomEvent(Hall_Events.MSG_SHOW_SHOP, _event)
end

-- 修改昵称
function UserCenterLayer:onChangeNickClicked()
    ExternalFun.playClickEffect()
    if self.m_pEditBoxNickName then
        self.m_pEditBoxNickName:touchDownAction(self.m_pEditBoxNickName, ccui.TouchEventType.ended)
    end
end


-- 复制 gameID
function UserCenterLayer:onCopyGameID()
    ExternalFun.playClickEffect()
    local gameId = GlobalUserItem.tabAccountInfo.userid
    MultiPlatform:getInstance():copyToClipboard(gameId)
    FloatMessage.getInstance():pushMessage("STRING_036")
end

-- 绑定支付宝
function UserCenterLayer:onBindZhifubaoClicked()
    ExternalFun.playClickEffect()
    self:setCallBack(function()
        local _event = 
        {
            name = Hall_Events.SHOW_BIND_VIEW,
            packet = {
                bindtype = "zhifubao"
            },
        }
    SLFacade:dispatchCustomEvent(Hall_Events.SHOW_BIND_VIEW,_event)
    end)
    self:onMoveExitView()
end

-- 绑定银行卡
function UserCenterLayer:onBindBankClicked()
    ExternalFun.playClickEffect()

    self:setCallBack(function()
        local _event = 
        {
            name = Hall_Events.SHOW_BIND_VIEW,
            packet = {
                bindtype = "bank"
            },
        }
    SLFacade:dispatchCustomEvent(Hall_Events.SHOW_BIND_VIEW,_event)
    end)
    self:onMoveExitView()
    
end

-- 升级成正式帐号
function UserCenterLayer:onInstantRegisterClicked()
    ExternalFun.playClickEffect()
    local pRegisterView = self.m_rootUI:getChildByName("RegisterView")
    if pRegisterView then
        pRegisterView:setVisible(true)
        return
    end
    pRegisterView = RegisterView.create(2)
    pRegisterView:setName("RegisterView")
    self.m_rootUI:addChild(pRegisterView, 100)
end

-- 打开vip界面
function UserCenterLayer:onVipClicked()
    ExternalFun.playClickEffect()
    
    self:setCallBack(function()
        SLFacade:dispatchCustomEvent(Hall_Events.MSG_OPEN_HALL_LAYER, "vip")
    end)
    self:onMoveExitView()
end

-- 关闭
function UserCenterLayer:onCloseClicked()
    ExternalFun.playClickEffect()
    self:onMoveExitView()
    --self:onMsgCloseSelf()
end



--------------------------update-----------------------
function UserCenterLayer:updateInfoView()
    local sex = tonumber(GlobalUserItem.tabAccountInfo.sex)
    local nSex = HEAD_2_SEX[sex]
--    self.m_pSpriteMale:setVisible(nSex == MALE)
--    self.m_pSpriteFemale:setVisible(nSex == FEMALE)
end

--大厅网络回调
function UserCenterLayer:onUserCenterCallBack(result,message)
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
--    if type(message) == "table" then
--        if message.tag == "change_sex" then
--            if message.result == "ok" then
--                GlobalUserItem.tabAccountInfo.sex = self.m_iSelectSex
--                self:updateInfoView()
--            end 
--        end
--    end
end

return UserCenterLayer
