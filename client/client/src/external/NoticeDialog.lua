--region NoticeDialog.lua
--Date 2017.06.19.
--Auther JackyXu.
--Desc 游戏公用提示框. 相当于原工程中的 NoticeView.

local NoticeDialog = class("NoticeDialog", FixLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local G_NoticeDialog = nil
function NoticeDialog.create()
    G_NoticeDialog = NoticeDialog.new():init()
    return G_NoticeDialog
end

function NoticeDialog:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_pImgBg = nil --背景根节点
    self.m_pBtnOK = nil
    self.m_pInfoLabel = nil
    self.m_pInfoLabel2 = nil
    self.m_nNoticeType = 0
    self.m_nLastTouchTime = 0

    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)
end

function NoticeDialog:init()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)

    --init csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/NoticeDialog.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("NoticeDialog")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    self.m_pImageBg     = self.m_pNodeRoot:getChildByName("Image_bg")
    self.m_pBtnOK       = self.m_pImageBg:getChildByName("Button_confirm")
    self.m_pBtnCancel   = self.m_pImageBg:getChildByName("Button_cancel")
    self.m_pInfoLabel   = self.m_pImageBg:getChildByName("Label_text")
    self.m_pBtnClose    = self.m_pImageBg:getChildByName("Button_close")

    self.m_pBtnOK:addClickEventListener(handler(self, self.onBtnOkClick))
    self.m_pBtnCancel:addClickEventListener(handler(self, self.onBtnCloseClick))
    self.m_pBtnClose:addClickEventListener(handler(self, self.onBtnCloseClick))
    return self
end

function NoticeDialog:onEnter()
    self.super:onEnter()
    self:showWithStyle()
end

function NoticeDialog:onExit()
    self.super:onExit()
end

function NoticeDialog:setNoticeType(nIndex)
    self.m_nNoticeType = nIndex
    if(self.m_pInfoLabel == nil) then
        return
    end

    if(nIndex == 1) then
        self.m_pInfoLabel:setString(yl.getLocalString("MESSAGE_10"))
        --self.m_pInfoLabel:setTextColor(cc.c4b(255,231,149,255))
    elseif (nIndex == 2) then
        -- 帐号登出提示
        self.m_pInfoLabel:setString(yl.getLocalString("MESSAGE_11"))

    elseif(nIndex == 3) then
        self.m_pInfoLabel:setString(yl.getLocalString("MESSAGE_12"))

    elseif(nIndex == 4) then
        self.m_pInfoLabel:setString(yl.getLocalString("MESSAGE_14"))

    elseif(nIndex == 5) then
        self.m_pInfoLabel:setString(yl.getLocalString("MESSAGE_16"))

    elseif(nIndex == 6) then
        self.m_pInfoLabel:setString(yl.getLocalString("MESSAGE_17"))

    elseif(nIndex == 7) then
        -- 退出二人梭哈提示
        self.m_pInfoLabel:setString(yl.getLocalString("MESSAGE_18"))

    elseif(nIndex == 8) then
        -- 游客注册提示
        local strTips = yl.getLocalString("GUEST_REGIST_NOTICE")
        self.m_pInfoLabel:setString(strTips)
        self.m_pBtnCancel:setVisible(false)
        self.m_pBtnOK:setPosition(380, 120)
        local imageTexture = "gui-userinfo-update-account.png"
        self.m_pBtnOK:loadTextureNormal(imageTexture, ccui.TextureResType.plistType)
        self.m_pBtnOK:loadTextureDisabled(imageTexture, ccui.TextureResType.plistType)
    elseif(nIndex == 9) then
        self.m_pInfoLabel:setString(yl.getLocalString("EXCHANGE_4"))

    elseif(nIndex == 10) then
        -- 退出二人牛牛提示
        self.m_pInfoLabel:setString(yl.getLocalString("MESSAGE_27"))

    elseif (nIndex == 11) then
        -- 退出斗地主提示
        self.m_pInfoLabel:setString(yl.getLocalString("MESSAGE_20"))

    elseif (nIndex == 12) then
        -- 是否删除消息中心所有消息
        self.m_pInfoLabel:setString(yl.getLocalString("MESSAGE_21"))

    elseif (nIndex == 13) then
        -- 有新版本发布，是否立即更新？
        self.m_pInfoLabel:setString(yl.getLocalString("MESSAGE_23"))

    elseif (nIndex == 14) then
        -- 更新失败，是否重试？
        self.m_pInfoLabel:setString(yl.getLocalString("MESSAGE_24"))
    elseif (nIndex == 15) then
        -- 连接服务器失败，是否重试？
        self.m_pInfoLabel:setString(yl.getLocalString("MESSAGE_25"))
    elseif (nIndex == 16) then
        -- 是否更新到最新版本？
        self.m_pBtnCancel:setVisible(false)
        self.m_pBtnOK:setPosition(380, 120)
        self.m_pInfoLabel:setString(yl.getLocalString("MESSAGE_29"))
    elseif (nIndex == 17) then
        --炸金花提示
        self.m_pInfoLabel:setString(yl.getLocalString("ZJH_0"))
    end


    return self
end

------------------
-- 按纽响应
function NoticeDialog:onBtnCloseClick()
   ExternalFun.playClickEffect()
    local self = G_NoticeDialog

    if(self.m_nNoticeType == 13 or self.m_nNoticeType == 15) then
        --取消热更
        local scheduler = cc.Director:getInstance():getScheduler()
	    self.handle = scheduler:scheduleScriptFunc(function()
	        scheduler:unscheduleScriptEntry(self.handle)
	        self.handle = nil;
	        cc.Director:getInstance():endToLua()
	    end, 0.1, false)
    --elseif self.m_nNoticeType == 14 then
    --    SLFacade:dispatchCustomEvent(Public_Events.MSG_UPDATE_CANCEL)
    else
       self:onMoveExitView()
    end
end

function NoticeDialog:onBtnOkClick()
    ExternalFun.playClickEffect()
    local self = G_NoticeDialog
    -- 防连点
    local nCurTime = os.time();
    if self.m_nLastTouchTime and nCurTime - self.m_nLastTouchTime <= 0 then
        return
    end
    self.m_nLastTouchTime = nCurTime

    if(self.m_nNoticeType == 2) then -- 切换账号
        
        self.m_pBtnOK:setEnabled(false)

        --[[PlayerInfo.getInstance():Clear()
        PlayerInfo.getInstance():setIsHallBackToLogin(true)
        CBankDetails.getInstance():CleanTransferLog()
        CUserManager.getInstance():clearUserInfo()
        UsrMsgManager.getInstance():Clear()

        cc.UserDefault:getInstance():setStringForKey("password", "");--]]

        self:onMoveExitView(FixLayer.HIDE_NO_STYLE)

        --切换帐号，收到0-3后，再返回登录界面
        PlayerInfo.getInstance():Logout()
        
        --如果断开，则不能返回登录
        SLFacade:dispatchCustomEvent(Hall_Events.Login_Entry)

    elseif(self.m_nNoticeType == 4) then
        self:onMoveExitView(FixLayer.HIDE_NO_STYLE)

    elseif(self.m_nNoticeType == 8) then
        SLFacade:dispatchCustomEvent(Public_Events.MSG_SHOW_REGISTER)
        self:onMoveExitView(FixLayer.HIDE_NO_STYLE)

    elseif(self.m_nNoticeType == 9) then
        self:onMoveExitView(FixLayer.HIDE_NO_STYLE)

    elseif self.m_nNoticeType == 12 then
        -- 删除消息中心所有消息
        SLFacade:dispatchCustomEvent(Hall_Events.MSG_DEL_ALL_MSG)
        self:onMoveExitView(FixLayer.HIDE_NO_STYLE)
    --elseif self.m_nNoticeType == 13 then
    --    -- 开始热更
    --    SLFacade:dispatchCustomEvent(Public_Events.MSG_START_UPDATE)
    --    self:onMoveExitView(FixLayer.HIDE_NO_STYLE)
    --elseif self.m_nNoticeType == 14 then
    --    -- 重试热更
    --    SLFacade:dispatchCustomEvent(Public_Events.MSG_RETRY_UPDATE)
    --    self:onMoveExitView(FixLayer.HIDE_NO_STYLE)
    elseif self.m_nNoticeType == 15 then
        -- 重试连接服务器
        SLFacade:dispatchCustomEvent(Public_Events.MSG_RETRY_CHECK_ADDRESS)
        self:onMoveExitView(FixLayer.HIDE_NO_STYLE)
    elseif self.m_nNoticeType == 16 then
        -- 更新版本
        cc.exports.closeConnectSocket()
        cc.Director:getInstance():getEventDispatcher():dispatchEvent(cc.EventCustom:new("NEED_RESTART_APP"))
    else
        self.m_pBtnOK:setEnabled(false)

        self:onMoveExitView(FixLayer.HIDE_NO_STYLE)
        local _event = {
            name = Public_Events.MSG_GAME_EXIT,
            packet = 0,
        }
        SLFacade:dispatchCustomEvent(Public_Events.MSG_GAME_EXIT, _event)
    end
end

function NoticeDialog:setNoticeString( strNotice )
    
    self.m_pInfoLabel:setString(strNotice)
end

return NoticeDialog
