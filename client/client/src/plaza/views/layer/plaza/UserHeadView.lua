--region UserHeadView.lua
--Date 2017.04.25.
--Auther JackyXu.
--Desc: 设置头像 view
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame")  
local UserHeadView = class("UserHeadView", FixLayer)
local HeadSprite = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
local TOATAL_FACE_NUM = 10
local ROW_FACE_NUM     = 3

local VIP_MAX = 6

local TAG_HEAD = 1
local TAG_FRAME = 2

local FEMALE = 1
local MALE = 2
local HEAD_2_SEX = {FEMALE,MALE}

function UserHeadView:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_iHeadIndex = GlobalUserItem.tabAccountInfo.avatar_no 

    self:init()
    --游戏网络回调
    local  onUserHeadCallBack = function(result,message)
       self:onUserHeadCallBack(result,message)
    end

    --大厅网络处理
    self._plazaFrame = LogonFrame:getInstance()
    self._plazaFrame:setCallBackDelegate(self, onUserHeadCallBack)
end

function UserHeadView:init()
        --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    --csb
    self.m_pathUI = cc.CSLoader:createNode("dt/ModifyIcon.csb")
    self.m_pathUI:setPositionY((display.height - 750) / 2)
    self.m_pathUI:addTo(self.m_rootUI)
    self.m_pNode    = self.m_pathUI:getChildByName("center")
    self.m_pNode:setPositionX((display.width) / 2)
    --弹窗
    self.m_pImgBg          = self.m_pNode:getChildByName("bg1")
    --关闭按钮
    self.m_pBtnClose       = self.m_pNode:getChildByName("button_close")
    self.m_pBtnOk = self.m_pImgBg:getChildByName("button_btnOk") 
    self.headIcon = {}
    self.headselect = {}
    for i = 1 ,10 do
        local icon = string.format("image_newIcon_%d", i)
        local sele = string.format("image_select_%d", i)
        self.headIcon[i] = self.m_pImgBg:getChildByName("Image_7"):getChildByName(icon)
        self.headselect[i] = self.m_pImgBg:getChildByName("Image_7"):getChildByName(icon):getChildByName(sele)
        self.headselect[i]:setLocalZOrder(100)
--        self.headselect[i]:setVisible(false)        
    end
    self:createHeadIcon()
--    self.headselect[self.m_iHeadIndex]:setVisible(true)

    self.m_pBtnnvBtn = self.m_pImgBg:getChildByName("checkBox_nvBtn") 
    -- 女
    local BtnnvBtnEvent = function (sender,eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            GlobalUserItem.tabAccountInfo.sex = 2
            self:changeSex(2)
            self.m_pBtnnanBtn:setSelected(false)
            self:createHeadIcon()
        elseif eventType == ccui.CheckBoxEventType.unselected then
        end
    end
    self.m_pBtnnanBtn = self.m_pImgBg:getChildByName("checkBox_nanBtn") 
    --响应事件函数 男
    local BtnnanBtnEvent = function (sender,eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            GlobalUserItem.tabAccountInfo.sex = 1
            self:changeSex(1)
            self.m_pBtnnvBtn:setSelected(false)
            self:createHeadIcon()

        elseif eventType == ccui.CheckBoxEventType.unselected then

        end
    end
    if GlobalUserItem.tabAccountInfo.sex == 1 then self.m_pBtnnanBtn:setSelected(true) self.m_pBtnnvBtn:setSelected(false)
    else self.m_pBtnnvBtn:setSelected(true) self.m_pBtnnanBtn:setSelected(false)
    end
--    ------------------------------------------------------
    self.m_pBtnnvBtn:addEventListenerCheckBox(BtnnvBtnEvent)  --注册事件
    self.m_pBtnnanBtn:addEventListenerCheckBox(BtnnanBtnEvent)  --注册事件
    --按钮绑定
    self.m_pBtnClose:addClickEventListener(handler(self,self.onClickedClose))
    self.m_pBtnOk:addClickEventListener(handler(self,self.onClickedOk))

    for i = 1, 10 do
        self.headIcon[i]:setTag(i)
        self.headIcon[i]:addClickEventListener(handler(self, self.onHeadImageClicked))
    end
end
function UserHeadView:createHeadIcon()
    for i = 1,10 do
        local head = HeadSprite:createClipHead({userid = GlobalUserItem.tabAccountInfo.userid, nickname = GlobalUserItem.tabAccountInfo.nickname, avatar_no = i},129)
        head:setAnchorPoint(cc.p(0,0))
        self.headIcon[i]:addChild(head)
    end

end
function UserHeadView:changeSex(sexId)
--    "AccountService/change_sex", {sex="1"} 换性别
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "change_sex"
    msgta["body"] = {}
    msgta["body"]["sex"] = sexId
    self._plazaFrame:sendGameData(msgta)
end
function UserHeadView:onEnter()
    self.super:onEnter()

--    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)
--    self:showWithStyle()
    self:updateHeadSelect(self.m_iHeadIndex)

end

function UserHeadView:onExit()
    self.super:onExit()
end
function UserHeadView:Hide(args)
    args:setVisible(false)
end
function UserHeadView:Show(args)
    args:setVisible(true)
end

function UserHeadView:updateHeadSelect(headIndex)
    --右边头像选中
    for i = 1,10 do
        self.headselect[i]:setVisible(false)
    end
    self.headselect[headIndex]:setVisible(true)
--    self.m_pHeadSelect:setPosition(self.m_pImageHead[headIndex]:getPosition())
end



function UserHeadView:onTagClicked(sender)
    ExternalFun.playClickEffect()
    
--    local tag = sender:getTag()
--    self:refreshButtonStatus(tag)
end

function UserHeadView:onHeadImageClicked(sender)
    ExternalFun.playClickEffect()
    
    self.m_iHeadIndex = sender:getTag()
    self:updateHeadSelect(self.m_iHeadIndex)
    self:sendModifyHeadImage()
end


function UserHeadView:onClickedOk()
    ExternalFun.playClickEffect()
    local _event = {
        name = Hall_Events.MSG_NICK_HEAD_MODIFIED,
        packet = {},
    }
    SLFacade:dispatchCustomEvent(Hall_Events.MSG_NICK_HEAD_MODIFIED,_event)

    self:onMoveExitView()
end
function UserHeadView:onClickedClose()
    ExternalFun.playClickEffect()

    SLFacade:dispatchCustomEvent(Hall_Events.MSG_NICK_HEAD_MODIFIED)

    self:onMoveExitView()
end

function UserHeadView:sendModifyHeadImage()
    if self.m_iHeadIndex ~= GlobalUserItem.tabAccountInfo.avatar_no then
        self:sureModifyHeadImage(self.m_iHeadIndex)
    end
end


function UserHeadView:sureModifyHeadImage(nIdx)
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "avatar_modify"
    msgta["body"] = {}
    msgta["body"]["aid"] = nIdx
    self._plazaFrame:sendGameData(msgta)
end
--self:createHeadIcon()
--大厅网络回调
function UserHeadView:onUserHeadCallBack(result,message)
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
    if type(message) == "table" then
        if message.tag == "avatar_modify" then
            if message.result == "ok" then
               GlobalUserItem.tabAccountInfo.avatar_no = message.body

            end 
        elseif message.tag == "change_sex" then
            if message.result == "ok" then
--                self:createHeadIcon()
            end 
        end
   end
end

return UserHeadView
