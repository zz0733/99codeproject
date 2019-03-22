--
-- Author: zhong
-- Date: 2017-05-25 15:01:10
--
-- 机器锁定(三级弹窗)
local TransitionLayer = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")
local LockMachineLayer = class("LockMachineLayer", TransitionLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

-- net
local ModifyFrame = appdf.req(appdf.CLIENT_SRC .. "plaza.models.ModifyFrame")               -- 信息修改
-- net

local TAG_START             = 100
local enumTable = 
{
    "BTN_CLOSE",            -- 关闭按钮
    "TAG_MASK",             -- 遮罩
    "BTN_LOCK",             -- 锁定
    "BTN_UNLOCK",           -- 解锁
}
local TAG_ENUM = ExternalFun.declarEnumWithTable(TAG_START, enumTable)
function LockMachineLayer:ctor( scene, param, level )
    --网络回调
    local modifyCallBack = function(result,message)
        self:onModifyCallBack(result,message)
    end
    --网络处理
    self._modifyFrame = ModifyFrame:create(self,modifyCallBack)

    LockMachineLayer.super.ctor( self, scene, param, level )
    -- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("option/LockMachineLayer.csb", self )

    local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(), ref)
        end
    end

    -- 遮罩
    local mask = csbNode:getChildByName("panel_mask")
    mask:setTag(TAG_ENUM.TAG_MASK)
    mask:addTouchEventListener( touchFunC )

    -- 底板
    local spbg = csbNode:getChildByName("sp_bg")
    spbg:setScale(0.000001)
    self.m_spBg = spbg

    -- 关闭
    local btn = spbg:getChildByName("btn_close")
    btn:setTag(TAG_ENUM.BTN_CLOSE)
    btn:addTouchEventListener( touchFunC )

    local normal = "option/option_btn_lock_0.png"
    local disable = "option/option_btn_lock_0.png"
    local press = "option/option_btn_lock_1.png"
    self.m_btnLock = spbg:getChildByName("btn_lock")
    -- 锁定
    if 1 == GlobalUserItem.tabAccountInfo.cbMoorMachine then
        -- 已锁定, 解锁
        normal = "option/option_btn_unlock_0.png"
        disable = "option/option_btn_unlock_0.png"
        press = "option/option_btn_unlock_1.png"
        self.m_btnLock:setTag(TAG_ENUM.BTN_UNLOCK)
    else
        -- 已解锁, 锁定
        self.m_btnLock:setTag(TAG_ENUM.BTN_LOCK)
    end
    self.m_btnLock:loadTextureDisabled(disable)
    self.m_btnLock:loadTextureNormal(normal)
    self.m_btnLock:loadTexturePressed(press) 
    self.m_btnLock:addTouchEventListener( touchFunC )
    self.m_btnLock:setEnabled(false)

    -- 编辑区
    self.m_editBox = nil
    self.m_bEditInput = false

    self:scaleShakeTransitionIn(spbg)
end

function LockMachineLayer:onExit()
    if nil ~= self._modifyFrame then
        self._modifyFrame:onCloseSocket()
    end
    LockMachineLayer.super.onExit(self)
end

function LockMachineLayer:onButtonClickedEvent(tag, ref)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if self.m_bEditInput and cc.PLATFORM_OS_WINDOWS ~= targetPlatform then
        self.m_bEditInput = false
        -- editbox 隐藏键盘时屏蔽按钮
        return
    end
    if TAG_ENUM.TAG_MASK == tag or TAG_ENUM.BTN_CLOSE == tag then
        self:scaleTransitionOut(self.m_spBg)
    elseif TAG_ENUM.BTN_LOCK == tag then
        local txt = self.m_editBox:getText()
        if txt == "" then
            showToast(self, "密码不能为空!", 2)
            return 
        end
        self._modifyFrame:onBindingMachine(1, txt)
    elseif TAG_ENUM.BTN_UNLOCK == tag then
        local txt = self.m_editBox:getText()
        if txt == "" then
            showToast(self, "密码不能为空!", 2)
            return 
        end
        self._modifyFrame:onBindingMachine(0, txt)
    end
end

function LockMachineLayer:animationRemove()
    self:scaleTransitionOut(self.m_spBg)
end

function LockMachineLayer:onTransitionInFinish()
    -- 输入
    local tmp = self.m_spBg:getChildByName("option_sp_lockeditpw")
    local editbox = ccui.EditBox:create(cc.size(tmp:getContentSize().width - 10, tmp:getContentSize().height - 10),"public/public_blank.png")
        :setPosition(tmp:getPosition())
        :setFontName("fonts/round_body.ttf")
        :setPlaceholderFontName("fonts/round_body.ttf")
        :setFontSize(30)
        :setPlaceholderFontSize(30)
        :setMaxLength(32)
        :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
        :setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        :setPlaceHolder("请输入密码")
    self.m_spBg:addChild(editbox)
    local editHanlder = function(event,editbox)
        self:onEditEvent(event,editbox)
    end
    editbox:registerScriptEditBoxHandler(editHanlder)
    self.m_editBox = editbox

    self.m_btnLock:setEnabled(true)
end

function LockMachineLayer:onTransitionInBegin()
    self:sendShowEvent()
end

function LockMachineLayer:onTransitionOutBegin()
    self:sendHideEvent()
end

function LockMachineLayer:onTransitionOutFinish()
    self:removeFromParent()
end

function LockMachineLayer:onEditEvent(event,editbox)
    local src = editbox:getText()
    if event == "began" then
        self.m_bEditInput = string.len(src) ~= 0
    elseif event == "changed" then
        self.m_bEditInput = string.len(src) ~= 0
    end
end

function LockMachineLayer:onModifyCallBack(result, tips)
    if type(tips) == "string" and "" ~= tips then
        showToast(self, tips, 2)
    end 

    local normal = "option/option_btn_lock_0.png"
    local disable = "option/option_btn_lock_0.png"
    local press = "option/option_btn_lock_1.png"
    if self._modifyFrame.BIND_MACHINE == result then
        if 0 == GlobalUserItem.tabAccountInfo.cbMoorMachine then
            GlobalUserItem.tabAccountInfo.cbMoorMachine = 1
            self.m_btnLock:setTag(TAG_ENUM.BTN_UNLOCK)
            normal = "option/option_btn_unlock_0.png"
            disable = "option/option_btn_unlock_0.png"
            press = "option/option_btn_unlock_1.png"
        else
            GlobalUserItem.tabAccountInfo.cbMoorMachine = 0
            self.m_btnLock:setTag(TAG_ENUM.BTN_LOCK)
        end
    end   
    self.m_btnLock:loadTextureDisabled(disable)
    self.m_btnLock:loadTextureNormal(normal)
    self.m_btnLock:loadTexturePressed(press)  
end

return LockMachineLayer