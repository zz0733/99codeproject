--region RegisterView.lua
--Date 2017.04.26.
--Auther JackyXu.
--Desc: 注册正式帐号 view

local FloatMessage = cc.exports.FloatMessage
local TreatyView = require(appdf.PLAZA_VIEW_SRC.."TreatyView")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .."ExternalFun")
local RegisterView = class("RegisterView",FixLayer)
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame")
local ClientPopWait = appdf.req(appdf.EXTERNAL_SRC .. "ClientPopWait")

local G_RegisterView = nil
function RegisterView.create(nType, scene)
    G_RegisterView = RegisterView.new():init(nType, scene)
    return G_RegisterView
end

function RegisterView:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_pShengmFirstPic = nil
--    self.m_pNodeInput = {}
    self.m_pEditBox = {}

    self.m_pLbCountDown = nil
    self.m_pBtnGetNumber = nil
    self.m_nCountDown = -1
    self.m_bShengmFirst = false
    self.m_nLastTouchTime = 0
    self.m_bBangding = false
    if GlobalUserItem.tabAccountInfo.userid then
        self.m_bBangding = true
    end
    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)

    local onMsgCallBack = function (result,message)
		self:onMsgCallBack(result,message)
	end
	self._logonFrame = LogonFrame:getInstance()
    self._logonFrame:setCallBackDelegate(self, onMsgCallBack)

    self.m_rootUI:addTo(self)
end

function RegisterView:init(nType, scene)
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)

    self.m_nType = nType
    self._scene = scene

    --init csb  手机号
    self.m_pathUI = cc.CSLoader:createNode("login/RegisterView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pImageBg    = self.m_pathUI:getChildByName("image_bgImg")
    local diffX = display.size.width/2
    self.m_pImageBg:setPositionX(diffX)

    self.m_pNodeInput_0     = self.m_pImageBg:getChildByName("image_accountImg")
    self.m_pNodeInput_1     = self.m_pImageBg:getChildByName("image_passwordImg")

    self.m_pLbCountDown     = self.m_pImageBg:getChildByName("Text_count")   --倒计时
    self.m_pBtnGetNumber    = self.m_pImageBg:getChildByName("button_yanzhengmaBtn")  --获取验证码

    self.m_pBtnConfirm      = self.m_pImageBg:getChildByName("button_loginBtn")     --注册按钮
    self.m_pBtnClose        = self.m_pImageBg:getChildByName("button_closeBtn")       --关闭

    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseClicked))
    self.m_pBtnConfirm:addClickEventListener(handler(self, self.onRegisterClicked_yanzhengma))
    self.m_pBtnGetNumber:addClickEventListener(handler(self, self.onRegisterClicked))   --获取验证码，先发送手机号进行验证，通过后再获取验证码
--    self.m_pBtnGetNumber:addClickEventListener(handler(self, self.onClickedGetNumber))
    return self
end

function RegisterView:onEnter()
    self.super:onEnter()
    self:showWithStyle()

    self:initEditBox()

    self.m_pLbCountDown:setVisible(false)
    self.m_pBtnGetNumber:setVisible(true)

    cc.exports.TimerProxy:addTimer(1000, handler(self, self.updateCountDown), 1, -1, false)
    cc.exports.SLFacade:addCustomEventListener(Hall_Events.MSG_CLOSE_REGISTER, handler(self, self.onMsgCloseRegsiter), self.__cname)
end

function RegisterView:onExit()
    cc.exports.SLFacade:removeCustomEventListener(Hall_Events.MSG_CLOSE_REGISTER, self.__cname)
    cc.exports.TimerProxy:removeTimer(1000)
    self.super:onExit()

    G_RegisterView = nil
end


function RegisterView:initEditBox()
    -----------------
    -- 1、手机号码
    -- 2、验证码
    -- 3、密码
    -- 4、确认密码
    -----------------
    local InputMode = {
        cc.EDITBOX_INPUT_MODE_NUMERIC,
        cc.EDITBOX_INPUT_MODE_NUMERIC,
        cc.EDITBOX_INPUT_MODE_SINGLELINE,
        cc.EDITBOX_INPUT_MODE_SINGLELINE,
        cc.EDITBOX_INPUT_MODE_SINGLELINE,
    }
    local InputFlag = {
        [1] = cc.EDITBOX_INPUT_FLAG_SENSITIVE,
        [2] = cc.EDITBOX_INPUT_FLAG_SENSITIVE,
        [3] = cc.EDITBOX_INPUT_FLAG_PASSWORD,
        [4] = cc.EDITBOX_INPUT_FLAG_PASSWORD,
        [5] = cc.EDITBOX_INPUT_FLAG_SENSITIVE,
    }
    local maxLen = {11,6,20,20,20}
    local strPlace = { 
        yl.getLocalString("REGISTER_17"), 
        yl.getLocalString("REGISTER_19"),
        yl.getLocalString("REGISTER_2"),
        yl.getLocalString("REGISTER_2"),
        yl.getLocalString("REGISTER_3"),
    };
    local fontColor = {
        cc.c3b(108, 59, 27),
        cc.c3b(108, 59, 27),
        cc.c3b(108, 59, 27),
        cc.c3b(108, 59, 27),
        cc.c3b(108, 59, 27),
    }

    self.m_pEditBox[1] = self:createEditBox(maxLen[1],
                                    cc.KEYBOARD_RETURNTYPE_DONE,
                                    InputMode[1],
                                    InputFlag[1],
                                    1,
                                    self.m_pNodeInput_0:getContentSize(),
                                    strPlace[1],
                                    fontColor[1])

    local pos = cc.p(self.m_pNodeInput_0:getPositionX() -90, self.m_pNodeInput_0:getPositionY() -18)
    self.m_pEditBox[1]:setPosition(pos)
    self.m_pImageBg:addChild(self.m_pEditBox[1], 50)

    self.m_pEditBox[2] = self:createEditBox(maxLen[2],
                                      cc.KEYBOARD_RETURNTYPE_DONE,
                                      InputMode[2],
                                      InputFlag[2],
                                      2,
                                      self.m_pNodeInput_1:getContentSize(),
                                      strPlace[2],
                                      fontColor[2])

        local pos = cc.p(self.m_pNodeInput_1:getPositionX() -60, self.m_pNodeInput_1:getPositionY()-18)
        self.m_pEditBox[2]:setPosition(pos)
        self.m_pImageBg:addChild(self.m_pEditBox[2], 50)
end

function RegisterView:createEditBox(maxLength, keyboardReturnType, inputMode, inputFlag, tag, size, placestr, color)
    local sprite1 = ccui.Scale9Sprite:create("kong.png")
    local sprite2 = ccui.Scale9Sprite:create("kong.png")
    local sprite3 = ccui.Scale9Sprite:create("kong.png")
    size = cc.size(size.width - 25, 33)
    local editBox = cc.EditBox:create(size, sprite1, sprite2, sprite3)
    editBox:setMaxLength(maxLength)
    editBox:setReturnType(keyboardReturnType)
    editBox:setInputMode(inputMode)
    editBox:setInputFlag(inputFlag)
    editBox:setTag(tag)
    editBox:setPlaceHolder(placestr)
    if device.platform ~= "ios" and device.platform ~= "mac" then
        editBox:setPlaceholderFontName("Microsoft Yahei")
        editBox:setPlaceholderFontSize(23)
        editBox:setPlaceholderFontColor(cc.c3b(171,120,70))
    end
    editBox:setFont("Microsoft Yahei", 23)
    editBox:setFontColor(color)
    editBox:setAnchorPoint(cc.p(0, 0))
    editBox:registerScriptEditBoxHandler(handler(self, self.onEditBoxEventHandle))

    -- 模拟点击输入框解决 android 手机首次输入看不到输入内容BUG。
    if device.platform == "android" then
        self.m_nEditBoxTouchCount = 0
        editBox:touchDownAction(editBox,ccui.TouchEventType.ended)
        editBox:touchDownAction(editBox,ccui.TouchEventType.canceled)
    else
        self.m_nEditBoxTouchCount = 6
    end

    return editBox
end

function RegisterView:onEditBoxEventHandle(event, pSender)
    if "began" == event then
        if self.m_nEditBoxTouchCount > 4 then
            local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .."ExternalFun")
        end
    elseif "ended" == event then
        self.m_nEditBoxTouchCount = self.m_nEditBoxTouchCount + 1
    elseif "return" == event then
    elseif "changed" == event then
    end
end

-- 请求手机验证码
function RegisterView:sendRequestPhoneCode(strCellPhone)
    
    if string.len(strCellPhone) == 0 then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_17")
        return
    end
    if not yl.CheckIsMobile(strCellPhone) then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_18")
        return 
    end

    self:send_send_phone_code1(strCellPhone)
end

function RegisterView:onMsgVerifyDone(pUserdata)
    -- 请求手机验证码消息返回处理
    -- print(" -- register -- todo: -- ")
    self.m_pBtnGetNumber:setVisible(false)
    self.m_pLbCountDown:setVisible(true)
    
    self.m_nCountDown = 60
end

function RegisterView:onMsgCloseRegsiter()
    --登录成功，取消遮罩
    cc.exports.Veil:getInstance():HideVeil(VEIL_CONNECT)

    local password = self.m_pEditBox[4]:getText()
    local pwdMD5 = SLUtils:MD5(password)
    PlayerInfo.getInstance():setLoginPwd(pwdMD5)

    --注册完成
    FloatMessage.getInstance():pushMessage("REGISTER_24")
    self:onMoveExitView()
end

function RegisterView:updateCountDown(dt)
    if self.m_nCountDown == 0 then
        self.m_pLbCountDown:setVisible(false)
        self.m_pBtnGetNumber:setVisible(true)
    elseif self.m_nCountDown > 0 then
        self.m_nCountDown = self.m_nCountDown - 1
        local strTip = string.format(yl.getLocalString("REGISTER_22"), self.m_nCountDown)
        self.m_pLbCountDown:setString(strTip)
    end
end

-- 校验   --无验证码
function RegisterView:_verify()
    local strCellPhone = self.m_pEditBox[1]:getText()
    self.strCellPhone = strCellPhone
    if string.len(strCellPhone) == 0 then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_17")
        return
    end
    
    if string.len(strCellPhone) ~= 11 or not yl.string_number2(strCellPhone) then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_18")
        return 
    end


    self:send_send_phone_code1(strCellPhone)
end

-- 校验   有验证码
function RegisterView:_verify_yanzhengma()
    local strCellPhone = self.strCellPhone
    local strVerifyCode = self.m_pEditBox[2]:getText()

    
    if string.len(strCellPhone) == 0 then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_17")
        return
    end
    
    if string.len(strCellPhone) ~= 11 or not yl.string_number2(strCellPhone) then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_18")
        return 
    end
    
    if string.len(strVerifyCode) == 0 then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_19")
        return
    end


    self:send_bind_phone(strCellPhone,strVerifyCode)
end
------------------------------------
-- 按纽响应
-- 返回
function RegisterView:onCloseClicked(pSender)
   ExternalFun.playClickEffect()

    self:onMoveExitView()
end

-- 获取验证码
function RegisterView:onClickedGetNumber(pSender)
----    ExternalFun.playClickEffect()

--    -- body
--    print("RegisterView.onClickedGetNumber")
--    -- 防连点
--    local nCurTime = os.time()
--    if self.m_nLastTouchTime and nCurTime - self.m_nLastTouchTime <= 0 then
--        return
--    end
--    self.m_nLastTouchTime = nCurTime

    if string.len(self.strCellPhone) == 0 then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_17")
        return
    end
    if string.len(self.strCellPhone) ~= 11 then
        FloatMessage.getInstance():pushMessageWarning("REGISTER_18")
        return
    end
    
    self:sendRequestPhoneCode(self.strCellPhone)
--    -- 发送就开始倒计时
--    self:onMsgVerifyDone(nil)
end

-- 游戏协议复选框
function RegisterView:onShengmFirstBtnClicked(pSender)
    ExternalFun.playClickEffect()

    self.m_bShengmFirst = not self.m_bShengmFirst
end

-- 游戏协议
function RegisterView:onTreatyClicked(pSender)
   ExternalFun.playClickEffect()

    local pTreatyView = self.m_rootUI:getChildByName("TreatyView")
    if pTreatyView then
        pTreatyView:setVisible(true)
        return
    end
    pTreatyView = TreatyView:create()
    pTreatyView:setName("TreatyView")
    self.m_rootUI:addChild(pTreatyView)
end

-- 注册
function RegisterView:onRegisterClicked(pSender)
    ExternalFun.playClickEffect()

    -- body
    self:_verify()
end
function RegisterView:onRegisterClicked_yanzhengma(pSender)
    ExternalFun.playClickEffect()

    -- body
    self:_verify_yanzhengma()
end
--先发无验证码手机号/再发有验证码手机号
function RegisterView:send_mobile_oauth(str_phoneNum_ , str_phoneCode)
    local phoneCode = str_phoneCode or ""
    local tabmsg = {}
    tabmsg["type"] = "AccountService"
    tabmsg["tag"] = "mobile_oauth"
    tabmsg["body"] = {}
    tabmsg["body"]["agent_id"] = ""
    tabmsg["body"]["reg_client_type"] = 1
    tabmsg["body"]["phone"] = str_phoneNum_
    tabmsg["body"]["device_id"] = MultiPlatform:getInstance():getMachineId()
    tabmsg["body"]["phonecode"] = phoneCode
      
    self._logonFrame:sendGameData(tabmsg)

    --记录登陆信息
    GlobalUserItem.tabUserLogonInfor.logontype = yl.LOGON_TYPE.PHONE
    GlobalUserItem.tabUserLogonInfor.account = str_phoneNum_
end
--获得手机验证码
function RegisterView:getYanzhengmaForAccount(str_phoneNum_)
    local tabmsg = {}
    tabmsg["type"] = "AccountService"
    tabmsg["tag"] = "send_mobile_sms"
    tabmsg["body"] = {}
    tabmsg["body"]["phone"] = str_phoneNum_
      
    self._logonFrame:sendGameData(tabmsg)
end

--绑定手机号获取验证码:sendRequestPhoneCode(strCellPhone)
function RegisterView:send_send_phone_code1(str_phoneNum_)
    local tabmsg = {}
    tabmsg["type"] = "AccountService"
    tabmsg["tag"] = "send_phone_code1"
    tabmsg["body"] = {}
    tabmsg["body"]["type"]      = 1                     --账号
    tabmsg["body"]["mobile"]    = str_phoneNum_         --密码

    self._logonFrame:sendGameData(tabmsg)
end

--输入验证码绑定手机号
function RegisterView:send_bind_phone(str_phoneNum_, str_phoneCode)
    local tabmsg = {}
    tabmsg["type"] = "AccountService"
    tabmsg["tag"] = "bind_phone"
    tabmsg["body"] = {}
    tabmsg["body"]["type"]          = 1                 --#0-解绑,1-绑定
    tabmsg["body"]["valid_type"]    = 2                 --2,验证类型 玩家选择1:手机 2:微信，3:邮件
    tabmsg["body"]["code"]          = 123123            
    tabmsg["body"]["charcode"]      = str_phoneCode     --验证码
    tabmsg["body"]["new"]           = 1                 --‘1’新版本
    tabmsg["body"]["phone"]         = str_phoneNum_     --手机号

    self._logonFrame:sendGameData(tabmsg)
end
--账号注册
function RegisterView:registerAccount(account,password,nickname,spreadid)--账号，密码，昵称，推荐人id
    --注册信息
    local tabmsg = {}
    tabmsg["type"] = "AccountService"
    tabmsg["tag"] = "account_register"
    tabmsg["body"] = {}
    tabmsg["body"]["username"] = account           --账号
    tabmsg["body"]["password"] = password           --密码
    tabmsg["body"]["nickname"] = nickname           --昵称
    tabmsg["body"]["agent_id"] = spreadid or ""     --推荐人ID
    tabmsg["body"]["name"] = ""
    tabmsg["body"]["idcard"] = ""
    tabmsg["body"]["new"] = "1"
    tabmsg["body"]["did"] = MultiPlatform:getInstance():getMachineId()    --机器码
    tabmsg["body"]["reg_client_type"] = yl.getDeviceType()

    self:showPopWait()
    self._logonFrame:sendGameData(tabmsg)

    --记录登陆信息
    GlobalUserItem.tabUserLogonInfor.logontype  = yl.LOGON_TYPE.REGISTER
    GlobalUserItem.tabUserLogonInfor.account = account
    GlobalUserItem.tabUserLogonInfor.password = password
    GlobalUserItem.tabUserLogonInfor.nickname = nickname
    GlobalUserItem.tabUserLogonInfor.spreadid = spreadid
end

function RegisterView:onMsgCallBack(result,value)
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
    if value.tag == "account_register" then 
         self:dismissPopWait() 
        if value.result == "ok"  then --注册成功
            SLFacade:dispatchCustomEvent(Hall_Events.MSG_REGISTER_OK)
        else
            showToast(self,value.result,2,cc.c4b(250,0,0,255));
        end
--    elseif value.tag == "mobile_oauth" then 
--        if value.result == "phonecode"  then --获取验证码成功
--            FloatMessage.getInstance():pushMessageWarning("请获取验证码！")
--            self.m_pathUI:removeFromParent()
--            self.m_pathUI_yanzhengma:setVisible(true)
--        end
    elseif value.tag == "send_mobile_sms" then 
        if value.result == "ok"  then --获取验证码成功
            FloatMessage.getInstance():pushMessageWarning("验证码发送成功！")
            self:onMsgVerifyDone(nil)
        else
            FloatMessage.getInstance():pushMessageWarning(value.result)
        end
    elseif value.tag == "send_phone_code1" then     --绑定手机号获取验证码
        if value.result == "ok"  then 
            self:onMsgVerifyDone(nil)
            FloatMessage.getInstance():pushMessageWarning("验证码发送成功！")
        else
            FloatMessage.getInstance():pushMessageWarning(value.result)
        end
    elseif value.tag == "guest_reg_mobile" then 
        if value.result == "ok"  then 
            SLFacade:dispatchCustomEvent(Hall_Events.MSG_DINGPHONE_OK)
        else
            FloatMessage.getInstance():pushMessageWarning(value.result)
        end
    elseif value.tag == "bind_phone" then 
        if value.result == "ok"  then 
            self:onMoveExitView()
        else
            self:onMoveExitView()
            FloatMessage.getInstance():pushMessageWarning(value.result)
        end
    end
end

--显示等待
function RegisterView:showPopWait()
    FloatPopWait.getInstance():show("请稍后")
end

--关闭等待
function RegisterView:dismissPopWait()
    FloatPopWait.getInstance():dismiss()
end

return RegisterView
