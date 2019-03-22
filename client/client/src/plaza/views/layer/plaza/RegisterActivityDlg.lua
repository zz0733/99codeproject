--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local ExternalFun       = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local RegisterActivityDlg = class("RegisterActivityDlg", FixLayer)

--local SpineManager        = appdf.req(appdf.PLAZA_VIEW_SRC.."bean.SpineManager")

RegisterActivityDlg.instance_ = nil
function RegisterActivityDlg.create()
    RegisterActivityDlg.instance_ = RegisterActivityDlg.new():init()
    return RegisterActivityDlg.instance_
end

function RegisterActivityDlg:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)
end

function RegisterActivityDlg:init()
    
    --init csb
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)

    self.m_pathUI = cc.CSLoader:createNode("login/WelcomeRegisterView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot         = self.m_pathUI:getChildByName("RegisterActivity")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    self.m_pImgBg            = self.m_pNodeRoot:getChildByName("panel_bgImg")
    self.m_pBtnClose         = self.m_pImgBg:getChildByName("button_closeBtn")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseClicked))
    self.m_pBtnRegister      = self.m_pImgBg:getChildByName("button_registerBtn")
    self.m_pBtnRegister:addClickEventListener(handler(self, self.onRegisterClicked))

    --self.skeletonNode = sp.SkeletonAnimation:create("hall/effect/xiaochounv/xiaochounv.json","hall/effect/xiaochounv/xiaochounv.atlas",1)
--    self.skeletonNode = SpineManager.getInstance():getSpine("hall/effect/xiaochounv/xiaochounv")
    if self.skeletonNode ~= nil then
        self.skeletonNode:setPosition(cc.p(667 ,50))
        self.skeletonNode:setScale(0.82)
        self.skeletonNode:setAnimation(0, "animation2", true)
        self.m_pNodeRoot:addChild(self.skeletonNode)
    end

    return self
end

function RegisterActivityDlg:onEnter()
    self.super:onEnter()
    self:showWithStyle()
end

function RegisterActivityDlg:onExit()
    self.super:onExit()
    RegisterActivityDlg.instance_ = nil

    if not GlobalUserItem.tabAccountInfo.isNeedPopNotice then
        SLFacade:dispatchCustomEvent(Hall_Events.MSG_POP_NOTICE)
    end
end

function RegisterActivityDlg:onCloseClicked()
    ExternalFun.playClickEffect()
    self:onMoveExitView()
end

function RegisterActivityDlg:onRegisterClicked()
    ExternalFun.playClickEffect()
    
    SLFacade:dispatchCustomEvent(Hall_Events.MSG_SHOW_REGISTER)
    GlobalUserItem.tabAccountInfo.isNeedPopNotice = true

    self:onMoveExitView(FixLayer.HIDE_NO_STYLE)
end


return RegisterActivityDlg

--endregion
