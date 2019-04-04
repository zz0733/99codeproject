--
-- Author: zhong
-- Date: 2017-10-10 10:37:02
--
local TransitionLayer = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")
local BankInfoLayer = class("BankInfoLayer", TransitionLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local PlayerInfo = appdf.req(appdf.EXTERNAL_SRC .. "PlayerInfo")
local CommonGoldView      = appdf.req(appdf.PLAZA_VIEW_SRC.."CommonGoldView")   
-- net
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame")
-- net
local OPERATE_NUM = 
{
    BTN_OPERATE_0 = 0,        -- 金额按钮0
    BTN_OPERATE_1 = 1,        -- 金额按钮1
    BTN_OPERATE_2 = 2,        -- 金额按钮2
    BTN_OPERATE_3 = 3,        -- 金额按钮3
    BTN_OPERATE_4 = 4,        -- 金额按钮4
    BTN_OPERATE_5 = 5,        -- 金额按钮5
    BTN_OPERATE_6 = 6,        -- 金额按钮6
    BTN_OPERATE_7 = 7,        -- 金额按钮7
    BTN_OPERATE_8 = 8,        -- 金额按钮8
    BTN_OPERATE_9 = 9,        -- 金额按钮9
};
local TAG_START             = 100
local enumTable = 
{
    "CBT_SWITCH",           -- 切换按钮

    "BTN_ENABLEBANK",       -- 开通银行
    "EDIT_SETPASSWD",       -- 设置密码
    "EDIT_SUREPASSWD",      -- 确认密码

    "CBT_OPERATE_0",        -- 金额操作0
    "CBT_OPERATE_1",        -- 金额操作1
    "CBT_OPERATE_2",        -- 金额操作2
    "CBT_OPERATE_3",        -- 金额操作3
    "CBT_OPERATE_4",        -- 金额操作4
    "CBT_OPERATE_5",        -- 金额操作5
    

    "BTN_SAVE",             -- 存款
    "BTN_TAKE",             -- 取款
    "BTN_SHOWPASSWD",       -- 显示密码
    "BTN_HIDEPASSWD",       -- 隐藏密码
    "EDIT_SAVETAKE_SCORE",  -- 存取金额
    "EDIT_TAKE_PASSWD",     -- 取款密码 

    "BTN_TRANSFER",         -- 赠送
    "EDIT_TRANSFER_ID",     -- 赠送ID
    "EDIT_TRANSFER_SCORE",  -- 赠送金额
    "EDIT_TRANSFER_PASSWD", -- 银行密码
    "EDIT_TRANSFER_REMARK", -- 赠送备注
    "BTN_REMONE",           -- 清除
    "BTN_CLOSE",            -- 关闭


    "TAKE",                 --取款界面
    "SAVE",                 --存款界面
    "TRANSFER",             --转账界面
    "RECORD",               --银行记录界面

}
local TAG_ENUM = ExternalFun.declarEnumWithTable(TAG_START, enumTable)

function BankInfoLayer:ctor(scene, param, level)
    local this = self
    ExternalFun.registerNodeEvent(this)
    BankInfoLayer.super.ctor( self, scene, param, level )
    
     --是否开启银行服务
    local enableBank = GlobalUserItem.szBankPassWord ~= ""
    self.m_bEnableBank = enableBank

    --网络回调
    local  bankCallBack = function(result,message)
       this:onBankCallBack(result,message)
    end
    --网络处理
    self._bankFrame = LogonFrame:getInstance()
    self._bankFrame:setCallBackDelegate(self, bankCallBack)

    -- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("dt/SafeBoxView.csb", self)
    local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            this:onButtonClickedEvent(ref:getTag(), ref)            
        end
    end
    self.m_csbNode = csbNode
    -- 遮罩
    local mask = csbNode:getChildByName("mask")
    --面板
    local bankbg = csbNode:getChildByName("center"):getChildByName("image_Bg")

    local Nodecenter = csbNode:getChildByName("center")
    local diffX, diffY = display.size.width/2 , display.size.height/2
    Nodecenter:setPositionX(diffX)
    Nodecenter:setPositionY(diffY)

    bankbg:setVisible(enableBank)
    self.m_spBg = bankbg
     if LuaUtils.isIphoneXDesignResolution() then
        mask:setContentSize(1624,750)
        --bankbg:setPositionX(bankbg:getPositionX() + 145)
    end
--    --
    local btn = bankbg:getChildByName("button_closeBtn")
    btn:setTag(TAG_ENUM.BTN_CLOSE)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)

    local bankbg1 = bankbg:getChildByName("Image_1");
    local btn = bankbg1:getChildByName("btn_take")
    btn:setTag(TAG_ENUM.TAKE)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)
    btn:setTouchEnabled(false)
    btn:setBright(false)
    self.btntake = btn

    local btn = bankbg1:getChildByName("btn_save")
    btn:setTag(TAG_ENUM.SAVE)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)
    self.btnsave = btn

    local btn = bankbg1:getChildByName("btn_transfer")
    btn:setTag(TAG_ENUM.TRANSFER)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)
    self.btntransfer = btn

    local btn = bankbg1:getChildByName("btn_record")
    btn:setTag(TAG_ENUM.RECORD)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)
    self.btnrecord = btn

    -- 开通界面
    self.m_enableLayer = csbNode:getChildByName("panel_enable")
    self.m_enableLayer:setVisible(not enableBank)
    self:initEnableLayer()

    -- 取款
    self.m_lOperateScore = 0
    self.m_takeLayer = bankbg:getChildByName("panel_bankout")
    self.m_takeLayer:setVisible(true)
    self:initOutLayer()

    -- 存界面
    self.m_lOperateScore = 0
    self.m_saveLayer = bankbg:getChildByName("panel_banksave")
    self.m_saveLayer:setVisible(false)
    self:initSaveLayer()
    -- 赠送界面
    self.m_transferLayer = bankbg:getChildByName("panel_banktransfer")
    self.m_transferLayer:setPositionY(-10)
    self.m_transferLayer:setVisible(false)
    self:initTransferLayer()

    --记录
    self.m_recordLayer = bankbg:getChildByName("panel_bankrecord")
    self.m_recordLayer:setVisible(false)
    self:initRecordLayer()

    -- 是否编辑
    self.m_bBeginEdit = false
    self.m_bEditInput = false
    self.m_nEditCount = 0

     -- 加载动画
    self:scaleTransitionIn(self.m_spBg)
    self:scaleShakeTransitionIn(self.m_spBg)

    --self:addColdUI(bankbg)

    -- 大厅通用顶部金币和银行
    self.m_commonGoldUI = CommonGoldView:create("BankInfoLayer")
    self.m_commonGoldUI:setPosition(ccp(400,480))
    self.m_commonGoldUI:addTo(bankbg)
end

function BankInfoLayer:initEnableLayer()
    local this = self
    local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            this:onButtonClickedEvent(ref:getTag(), ref)            
        end
    end

    -- 开通银行
    local btn = self.m_enableLayer:getChildByName("Button_63")
    btn:setTag(TAG_ENUM.BTN_ENABLEBANK)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true) 

    local btn = self.m_enableLayer:getChildByName("btn_close")
    btn:setTag(TAG_ENUM.BTN_CLOSE)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)
end

function BankInfoLayer:initSaveLayer()
    local this = self
    -- 存取金额
    self.m_tabOperate = {}
    self.m_nOperateIdx = TAG_ENUM.CBT_OPERATE_0
    self.m_nSelectOpearte = 0

    local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            this:onButtonClickedEvent(ref:getTag(), ref)            
        end
    end

    -- 存款
    local btn = self.m_saveLayer:getChildByName("Image_92"):getChildByName("node_keyboard"):getChildByName("ok")
    btn:setTag(TAG_ENUM.BTN_SAVE)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)
--    btn:setPositionX(330)
--    btn:setPositionY(30)
    for i = 0 ,9 do
        local cbtbox = self.m_saveLayer:getChildByName("Image_92"):getChildByName("node_keyboard"):getChildByName("num"..i)
        cbtbox:setTag(i)
        cbtbox:addTouchEventListener( touchFunC )
        cbtbox:setPressedActionEnabled(true)
        cbtbox.nOperateScore = i
        cbtbox:setTitleText(cbtbox.nOperateScore)
    end

    --清除按钮
    local btnRemove = self.m_saveLayer:getChildByName("Image_92"):getChildByName("Image_3"):getChildByName("button_clearInputBtn")
    
    btnRemove:setTag(TAG_ENUM.BTN_REMONE)
    btnRemove:addTouchEventListener( touchFunC )
    btnRemove:setPressedActionEnabled(true)
    local btnBack = self.m_saveLayer:getChildByName("Image_92"):getChildByName("node_keyboard"):getChildByName("back")
    btnBack:setTag(TAG_ENUM.BTN_REMONE)
    btnBack:addTouchEventListener( touchFunC )
    btnBack:setPressedActionEnabled(true)
    self.m_txtSaveNumber = self.m_saveLayer:getChildByName("Image_92"):getChildByName("Image_3"):getChildByName("textField_shuru")
    self.m_txtSaveNumber:setString("请输入金额")
end

function BankInfoLayer:initOutLayer()
    local this = self
    -- 存取金额
    self.m_tabOperate = {}
    self.m_nOperateIdx = TAG_ENUM.CBT_OPERATE_0
    self.m_nSelectOpearte = 0

    local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            this:onButtonClickedEvent(ref:getTag(), ref)            
        end
    end

    -- 取款
    local btn = self.m_takeLayer:getChildByName("Image_92"):getChildByName("node_keyboard"):getChildByName("ok")
    btn:setTag(TAG_ENUM.BTN_TAKE)
--    btn:setPositionX(330) 
--    btn:setPositionY(30)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)
    for i = 0 ,9 do
        local cbtbox = self.m_takeLayer:getChildByName("Image_92"):getChildByName("node_keyboard"):getChildByName("num"..i)
        cbtbox:setTag(i)
        cbtbox:addTouchEventListener( touchFunC )
        cbtbox:setPressedActionEnabled(true)
        cbtbox.nOperateScore = i
        cbtbox:setTitleText(cbtbox.nOperateScore)
    end

    --清除按钮
    local btnRemove = self.m_takeLayer:getChildByName("Image_92"):getChildByName("Image_3"):getChildByName("button_clearInputBtn") 
    btnRemove:setTag(TAG_ENUM.BTN_REMONE)
    btnRemove:addTouchEventListener( touchFunC )
    btnRemove:setPressedActionEnabled(true)
    local btnBack = self.m_takeLayer:getChildByName("Image_92"):getChildByName("node_keyboard"):getChildByName("back")
    btnBack:setTag(TAG_ENUM.BTN_REMONE)
    btnBack:addTouchEventListener( touchFunC )
    btnBack:setPressedActionEnabled(true)


    self.m_txtTakeNumber = self.m_takeLayer:getChildByName("Image_92"):getChildByName("Image_3"):getChildByName("textField_shuru")
    self.m_txtTakeNumber:setString("请输入金额")
end

function BankInfoLayer:initTransferLayer()
    local this = self
    local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            this:onButtonClickedEvent(ref:getTag(), ref)            
        end
    end

    -- 赠送
    local btn = self.m_transferLayer:getChildByName("Image_92"):getChildByName("node_keyboard"):getChildByName("ok")
    btn:setTag(TAG_ENUM.BTN_TRANSFER)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)
--    btn:setPositionX(330)

    self.m_textuser = self.m_transferLayer:getChildByName("Image_92"):getChildByName("Image_2"):getChildByName("txt_user")
    self.m_textuser:setVisible(false)

    for i = 0 ,9 do
        local cbtbox = self.m_transferLayer:getChildByName("Image_92"):getChildByName("node_keyboard"):getChildByName("num"..i)
        cbtbox:setTag(i)
        cbtbox:addTouchEventListener( touchFunC )
        cbtbox:setPressedActionEnabled(true)
        cbtbox.nOperateScore = i
        cbtbox:setTitleText(cbtbox.nOperateScore)
    end
    --清除按钮
    local btnRemove = self.m_transferLayer:getChildByName("Image_92"):getChildByName("Image_3"):getChildByName("button_clearInputBtn") 
    btnRemove:setTag(TAG_ENUM.BTN_REMONE)
    btnRemove:addTouchEventListener( touchFunC )
    btnRemove:setPressedActionEnabled(true)
    local btnBack = self.m_transferLayer:getChildByName("Image_92"):getChildByName("node_keyboard"):getChildByName("back")
    btnBack:setTag(TAG_ENUM.BTN_REMONE)
    btnBack:addTouchEventListener( touchFunC )
    btnBack:setPressedActionEnabled(true)
--    --清除按钮
--    local btnRemove = self.m_transferLayer:getChildByName("btn_remove")
--    btnRemove:setTag(TAG_ENUM.BTN_REMONE)
--    btnRemove:addTouchEventListener( touchFunC )
--    btnRemove:setPressedActionEnabled(true)

    self.m_txtTransferNumber = self.m_transferLayer:getChildByName("Image_92"):getChildByName("Image_3"):getChildByName("Text_5")
    self.m_txtTakeNumber:setString("请输入金额")
    self.m_txtSaveNumber:setString("请输入金额")
    self.m_txtTransferNumber:setString("请输入金额")
end

function BankInfoLayer:initRecordLayer()

    self.ScrollView = self.m_recordLayer:getChildByName("ScrollView_1")

end


function BankInfoLayer:onTouchImageBg()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if self.m_bEditInput and cc.PLATFORM_OS_WINDOWS ~= targetPlatform then
        self.m_bEditInput = false
        -- editbox 隐藏键盘时屏蔽按钮
        return
    end
end

function BankInfoLayer:onOperateSelectEvent( tag, sender )
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if self.m_bEditInput and cc.PLATFORM_OS_WINDOWS ~= targetPlatform then
        self.m_bEditInput = false
        sender:setSelected(self.m_nOperateIdx == tag)
        if nil ~= self.m_tabOpearteText[tag] then
            local fontsize = (self.m_nOperateIdx == tag) and 26 or 24
            self.m_tabOpearteText[tag]:setFontSize(fontsize)
        end
        
        -- editbox 隐藏键盘时屏蔽按钮
        return
    end
    if self.m_nOperateIdx == tag then
        sender:setSelected(true)
        if nil ~= self.m_tabOpearteText[tag] then
            local fontsize = (self.m_nOperateIdx == tag) and 26 or 24
            self.m_tabOpearteText[tag]:setFontSize(fontsize)
        end
        return
    end
    self.m_nOperateIdx = tag
    for k,v in pairs(self.m_tabOperate) do
        if k ~= tag then
            v:setSelected(false)
        end
    end
    if nil ~= self.m_tabOpearteText[tag] then
        self.m_tabOpearteText[tag]:setFontSize(26)
    end
    for k,v in pairs(self.m_tabOpearteText) do
        if k ~= tag then
            v:setFontSize(20)
        end
    end

    if nil ~= sender.nOperateScore then
        self.m_nSelectOpearte = sender.nOperateScore
    end
    self.m_editSave:setText(self.m_nSelectOpearte .. "")
end



function BankInfoLayer:onEnter()
    self.m_listener = cc.EventListenerCustom:create(yl.RY_USERINFO_NOTIFY,handler(self, self.onUserInfoChange))
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_listener, self)
end

function BankInfoLayer:onExit()
    if nil ~= self.m_listener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.m_listener)
        self.m_listener = nil
    end 
end

function BankInfoLayer:onEnterTransitionFinish()
    
    if GlobalUserItem.szBankPassWord ~= "" then
        self:LogonBank(GlobalUserItem.szBankPassWord)
    end

    -- 编辑框
    local editHanlder = function(event,editbox)
        self:onEditEvent(event,editbox)
    end
    -- 设置密码
    local tmp = self.m_enableLayer:getChildByName("Image_47")
    local editbox = ccui.EditBox:create(cc.size(tmp:getContentSize().width - 10, tmp:getContentSize().height),"public/public_blank.png")
            :setPosition(tmp:getPositionX(),tmp:getPositionY())
            :setPlaceHolder("请输入您的密码")
            :setPlaceholderFont("fonts/round_body.ttf", 30)
            :setFont("fonts/round_body.ttf", 30) 
            :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
            :setTag(TAG_ENUM.EDIT_SETPASSWD)
            :setFontColor(cc.c4b(255,128,0,255))
            :setColor(cc.c3b(0,0,0))
    self.m_enableLayer:addChild(editbox)         
    self.m_editSetPasswd = editbox
    --editbox:registerScriptEditBoxHandler(editHanlder)

    -- 存取
    tmp = self.m_saveLayer:getChildByName("Image_92"):getChildByName("Image_3")
    editbox = ccui.EditBox:create(cc.size(tmp:getContentSize().width -70, tmp:getContentSize().height),"public/public_blank.png")
            :setPosition(tmp:getPositionX(),tmp:getPositionY() + 50)
            :setPlaceHolder("请输入存入金额")
            :setPlaceholderFont("fonts/round_body.ttf", 30)
            :setFont("fonts/round_body.ttf", 30)
            :setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
            :setMaxLength(10)
            :setTag(TAG_ENUM.EDIT_SAVETAKE_SCORE)
            :setPositionX(tmp:getPosition() -35)
            :setColor(cc.c3b(0,0,0))
            :setFontColor(cc.c4b(255,128,0,255))
    self.m_saveLayer:addChild(editbox)         
    self.m_editSave = editbox
    editbox:registerScriptEditBoxHandler(editHanlder)


    tmp = self.m_takeLayer:getChildByName("Image_92"):getChildByName("Image_3")
    editbox = ccui.EditBox:create(cc.size(tmp:getContentSize().width -70, tmp:getContentSize().height),"public/public_blank.png")
            :setPosition(tmp:getPositionX(),tmp:getPositionY() + 60)
            :setPlaceHolder("请输入取出金额")
            :setPlaceholderFont("fonts/round_body.ttf", 30)
            :setFont("fonts/round_body.ttf", 30)
            :setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
            :setMaxLength(10)
            :setTag(TAG_ENUM.EDIT_SAVETAKE_SCORE)
            :setPositionX(tmp:getPosition() -35)
            :setColor(cc.c3b(0,0,0))
            :setFontColor(cc.c4b(255,128,0,255,255))
    self.m_takeLayer:addChild(editbox)         
    self.m_editTake = editbox
    editbox:registerScriptEditBoxHandler(editHanlder)

    -- 赠送ID
    tmp = self.m_transferLayer:getChildByName("Image_92"):getChildByName("Image_2")
    editbox = ccui.EditBox:create(cc.size(tmp:getContentSize().width - 10, tmp:getContentSize().height),"public/public_blank.png")
            :setPosition(tmp:getPositionX(),tmp:getPositionY() + 50)
            :setPlaceHolder("请输入赠送ID")
            :setPlaceholderFont("fonts/round_body.ttf", 30)
            :setFont("fonts/round_body.ttf", 30)
            :setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
            :setTag(TAG_ENUM.EDIT_TRANSFER_ID)
            :setColor(cc.c3b(0,0,0))
            :setFontColor(cc.c4b(255,128,0,255))
    self.m_transferLayer:addChild(editbox)         
    self.m_editTransferID = editbox
    editbox:registerScriptEditBoxHandler(editHanlder)
    
    

    -- 赠送金额
    tmp = self.m_transferLayer:getChildByName("Image_92"):getChildByName("Image_3")
    editbox = ccui.EditBox:create(cc.size(tmp:getContentSize().width - 10, tmp:getContentSize().height),"public/public_blank.png")
            :setPosition(tmp:getPositionX(),tmp:getPositionY() + 50)
            :setPlaceHolder("请输入赠送金额")
            :setPlaceholderFont("fonts/round_body.ttf", 30)
            :setFont("fonts/round_body.ttf", 30)
            :setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
            :setMaxLength(10)
            :setTag(TAG_ENUM.EDIT_TRANSFER_SCORE)
            :setColor(cc.c3b(0,0,0))
            :setFontColor(cc.c4b(255,128,0,255))
    self.m_transferLayer:addChild(editbox)         
    self.m_editTransferScore = editbox
    editbox:registerScriptEditBoxHandler(editHanlder)
end

function BankInfoLayer:onSelectedEvent(tag, sender)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if self.m_bEditInput and cc.PLATFORM_OS_WINDOWS ~= targetPlatform then
        self.m_bEditInput = false
        -- editbox 隐藏键盘时屏蔽按钮
        sender:setSelected(not sender:isSelected())
        return
    end
    self:onRefreshInfo()
end
function BankInfoLayer:onTransitionOutFinish()
    self:removeFromParent()
end
function BankInfoLayer:onButtonClickedEvent(tag, sender)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if self.m_bEditInput and cc.PLATFORM_OS_WINDOWS ~= targetPlatform then
        self.m_bEditInput = false
        -- editbox 隐藏键盘时屏蔽按钮
        return
    end

    if TAG_ENUM.BTN_ENABLEBANK == tag then
        self:onEnableBank()
    elseif TAG_ENUM.BTN_SAVE == tag then
        self:onSaveScore()
    elseif TAG_ENUM.BTN_TAKE == tag then
        self:onTakeScore()
    elseif TAG_ENUM.BTN_CLOSE == tag then
        self:scaleTransitionOut(self.m_spBg)
--        self._scene:onChangeShowMode(yl.SCENE_PLAZA)
    elseif TAG_ENUM.TAKE == tag then
        self:ontakebtn()
        self:showGoldIcon(tag)
    elseif TAG_ENUM.SAVE == tag then
        self:onsavebtn()
        self:showGoldIcon(tag)
    elseif TAG_ENUM.TRANSFER == tag then
        self:ontransferbtn()
        self:showGoldIcon(tag)
    elseif TAG_ENUM.RECORD == tag then
        self:onrecordbtn()
        self:showGoldIcon(tag)

    elseif TAG_ENUM.BTN_TRANSFER == tag then
        self:onTransferScore()
    elseif OPERATE_NUM.BTN_OPERATE_0 == tag 
        or OPERATE_NUM.BTN_OPERATE_1 == tag 
        or OPERATE_NUM.BTN_OPERATE_2 == tag 
        or OPERATE_NUM.BTN_OPERATE_3 == tag 
        or OPERATE_NUM.BTN_OPERATE_4 == tag 
        or OPERATE_NUM.BTN_OPERATE_5 == tag 
        or OPERATE_NUM.BTN_OPERATE_6 == tag 
        or OPERATE_NUM.BTN_OPERATE_7 == tag 
        or OPERATE_NUM.BTN_OPERATE_8 == tag 
        or OPERATE_NUM.BTN_OPERATE_9 == tag 
        then
        local opeScore = sender.nOperateScore or 0
        self.m_lOperateScore = tonumber( self.m_lOperateScore..opeScore )
        if self.m_lOperateScore > (GlobalUserItem.tabAccountInfo.bag_money + GlobalUserItem.tabAccountInfo.bank_money) then
            showToast(self,"输入金币不能超过自身金币总和！",2)
            self.m_lOperateScore = 0
        end
        -- 更新金币
        self.m_editTransferScore:setText(self.m_lOperateScore .. "")
        self.m_editSave:setText(self.m_lOperateScore .."")
        self.m_editTake:setText(self.m_lOperateScore .."")
        self.m_txtTakeNumber:setString(ExternalFun.numberTransiform(self.m_lOperateScore ..""))
        self.m_txtSaveNumber:setString(ExternalFun.numberTransiform(self.m_lOperateScore ..""))
        self.m_txtTransferNumber:setString(ExternalFun.numberTransiform(self.m_lOperateScore ..""))
    elseif TAG_ENUM.BTN_REMONE == tag then --清除

        self.m_editSave:setText("")
        self.m_editTake:setText("")
        self.m_editTransferScore:setText("")
        self.m_lOperateScore = 0
        self.m_txtTakeNumber:setString("请输入金额")
        self.m_txtSaveNumber:setString("请输入金额")
        self.m_txtTransferNumber:setString("请输入金额")
    end
end

function BankInfoLayer:openPanel(onlyme)
    self.m_saveLayer:setVisible(false)
    self.m_takeLayer:setVisible(false)
    self.m_transferLayer:setVisible(false)
    self.m_recordLayer:setVisible(false)
    onlyme:setVisible(true)
end

function BankInfoLayer:ontakebtn()
    self:setopen(self.btnrecord)
    self:setopen(self.btnsave)
    self:setopen(self.btntransfer)
    self:setclose(self.btntake)

    self:openPanel(self.m_takeLayer)
end

function BankInfoLayer:onrecordbtn()
    self:setopen(self.btntake)
    self:setopen(self.btnsave)
    self:setopen(self.btntransfer)
    self:setclose(self.btnrecord)

    self:openPanel(self.m_recordLayer)

    self:showPopWait()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "bank_record_json"
    msgta["body"] = {}
    msgta["body"]["pageindex"] = 1
    msgta["body"]["end_date"] = 2018-01-01
    msgta["body"]["start_date"] = 2020-01-01
    msgta["body"]["pagesize"] = 100
    self._bankFrame:sendGameData(msgta)
end

function BankInfoLayer:onsavebtn()
    self:setopen(self.btnrecord)
    self:setopen(self.btntake)
    self:setopen(self.btntransfer)
    self:setclose(self.btnsave)

    self:openPanel(self.m_saveLayer)
end

function BankInfoLayer:ontransferbtn()
    self:setopen(self.btnrecord)
    self:setopen(self.btnsave)
    self:setopen(self.btntake)
    self:setclose(self.btntransfer)

    self:openPanel(self.m_transferLayer)
end

function BankInfoLayer:setopen(sender)
    sender:setBright(true)
    sender:setTouchEnabled(true)
end

function BankInfoLayer:setclose(sender)
    sender:setBright(false)
    sender:setTouchEnabled(false)
end

function BankInfoLayer:onEditEvent(event, editbox)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    local src = editbox:getText()
    local tag = editbox:getTag()
    if event == "began" then
        self.m_bBeginEdit = true
        self.m_nEditCount = 0
        if targetPlatform ~= cc.PLATFORM_OS_ANDROID then
            self.m_bEditInput = true
            editbox:setText(src)
        end
    elseif event == "changed" then
        self.m_nEditCount = self.m_nEditCount + 1

        if targetPlatform ~= cc.PLATFORM_OS_ANDROID then
            editbox:setText(src)
        end

        if TAG_ENUM.EDIT_TRANSFER_ID == tag then
                self.m_textuser:setVisible(false)
        end

        if self.m_bBeginEdit then
            if targetPlatform == cc.PLATFORM_OS_ANDROID then
                self.m_bEditInput = (self.m_nEditCount > 1)
            end
            
            if TAG_ENUM.EDIT_SAVETAKE_SCORE == tag then
                 -- 赠送大写
                local ndst = tonumber(src)
                if type(ndst) == "number" and ndst < 9999999999999 then
                    self.m_txtTakeNumber:setString(ExternalFun.numberTransiform(src))
                    self.m_txtSaveNumber:setString(ExternalFun.numberTransiform(src))
                else
                    self.m_txtTakeNumber:setString("请输入金额")
                    self.m_txtSaveNumber:setString("请输入金额")
                end
           elseif TAG_ENUM.EDIT_TRANSFER_SCORE == tag then
                -- 赠送大写
                local ndst = tonumber(src)
                if type(ndst) == "number" and ndst < 9999999999999 then
                    self.m_txtTransferNumber:setString(ExternalFun.numberTransiform(src))
                else
                   self.m_txtTransferNumber:setString("请输入金额")
                end
            end
        end
    elseif event == "return" then
        self.m_bBeginEdit = false
        self.m_nEditCount = 0
        if TAG_ENUM.EDIT_SAVETAKE_SCORE == tag then
            local ndst = tonumber(src)
            if nil ~= ndst then
                self.m_lOperateScore = ndst
            end
        end
        if TAG_ENUM.EDIT_TRANSFER_ID == tag then
            if #self.m_editTransferID:getText() > 0 then
                local msgta = {}
                msgta["type"] = "AccountService"
                msgta["tag"] = "nickname_by_uid"
                msgta["body"] = {}
                msgta["body"]["uid"] = self.m_editTransferID:getText()
                self._bankFrame:sendGameData(msgta)
            end
        end
    end
end

function BankInfoLayer:onBankCallBack(result, message)
    self:dismissPopWait()
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
    if message ~= nil and type(message) == "table" then
        -- 银行登陆
        if message.tag == "bank_login" then
            if message.result == "ok"  then
                --隐藏登陆
                self.m_enableLayer:setVisible(false) 
                self.m_spBg:setVisible(true)

                --保存登陆密码
                GlobalUserItem.onSaveBankPassword()

                --更新用户信息
                self._scene:sendGetAccount()
            else
                GlobalUserItem.szBankPassWord = ""
                showToast(self,message.body,2)

                 --显示登陆
                self.m_enableLayer:setVisible(true) 
                self.m_spBg:setVisible(false)
            end      
        elseif message.tag == "nickname_by_uid" then
            if message.result == "ok" then
               self.m_textuser:setVisible(true)
               self.m_textuser:setString(message.body)
            else
               showToast(self,message.body,2)
            end
        elseif message.tag == "bank_record_json" then
            if message.result == "ok" then
               local nHight = 470
               if #message.body.data * 50 > nHight then
                    nHight = #message.body.data * 50
               end
               self.ScrollView:setInnerContainerSize(cc.size(700, nHight))
               self.ScrollView:removeAllChildren()
               for i= 1,#message.body.data do
                    txttime = cc.Label:createWithTTF(string.sub(message.body.data[i].action_time, 6, #message.body.data[i].action_time), "fonts/round_body.ttf", 18):setPosition(cc.p(74,nHight-50*(i-1))):setColor(cc.c3b(255, 165, 0))
                    txttime:setAnchorPoint(ccp(0.5,1))
                    self.ScrollView:addChild(txttime)

                    txttype = cc.Label:createWithTTF(message.body.data[i].action_type, "fonts/round_body.ttf", 18):setPosition(cc.p(250,nHight-50*(i-1))):setColor(cc.c3b(255, 165, 0))
                    txttype:setAnchorPoint(ccp(0.5,1))
                    self.ScrollView:addChild(txttype)

                    txtact = cc.Label:createWithTTF(message.body.data[i].action_money, "fonts/round_body.ttf", 18):setPosition(cc.p(450,nHight-50*(i-1))):setColor(cc.c3b(255, 165, 0))
                    txtact:setAnchorPoint(ccp(0.5,1))
                    self.ScrollView:addChild(txtact)

                    txtend = cc.Label:createWithTTF("", "fonts/round_body.ttf", 18):setString(message.body.data[i].end_money):setPosition(cc.p(620,nHight-50*(i-1))):setColor(cc.c3b(255, 165, 0))
                    txtend:setAnchorPoint(ccp(0.5,1))
                    self.ScrollView:addChild(txtend)
               end
            else
                showToast(self,message.body,2)
            end   
         elseif message.tag == "bag2bank" or  message.tag == "bank2bag" then
           if message.result == "ok" then  
                self._scene:sendGetAccount()
                self:clean()
           elseif message.result == "error" then
                showToast(self,message.body,2)
           else
                showToast(self,"未知错误！",2)
           end  
         elseif message.tag == "deliver_money" then
           if message.result == "ok" then  
                self._scene:sendGetAccount()
                self:clean()
           elseif message.result == "error" then
                showToast(self,message.body,2)
           else
                showToast(self,"未知错误！",2)
           end  
        end
    end
end

-- 开通
function BankInfoLayer:onEnableBank()
    --参数判断
    local szPass = self.m_editSetPasswd:getText()

    if #szPass < 1 then 
        showToast(self,"请输入银行密码！",2)
        return
    end
    if #szPass < 6 then
        showToast(self,"密码必须大于6个字符，请重新输入！",2)
        return
    end
   
   self:LogonBank(szPass)
end


--登陆银行
function BankInfoLayer:LogonBank(password)

    GlobalUserItem.szBankPassWord = password

    self:showPopWait()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "bank_login"
    msgta["body"] = {}
    msgta["body"]["password"] = password
    msgta["body"]["pwdcard_r2"] = ""
    msgta["body"]["login_type"] = 0
    msgta["body"]["device_id"] = MultiPlatform:getInstance():getMachineId()
    msgta["body"]["pwdcard_r1"] = ""
    self._bankFrame:sendGameData(msgta)
end

function BankInfoLayer:sendTakeMoney(lOperateScore)
    self:showPopWait()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "bank2bag"
    msgta["body"] = {}
    msgta["body"]["amount"] = lOperateScore
    self._bankFrame:sendGameData(msgta)
end

function BankInfoLayer:sendSaveMoney(lOperateScore)
    self:showPopWait()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "bag2bank"
    msgta["body"] = {}
    msgta["body"]["amount"] = lOperateScore
    self._bankFrame:sendGameData(msgta)
end

function BankInfoLayer:sendTranseferMoney(szTarget, lOperateScore) 
    self:showPopWait()  
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "deliver_money"
    msgta["body"] = {}
    msgta["body"]["uid"] = szTarget
    msgta["body"]["money"] = lOperateScore
    self._bankFrame:sendGameData(msgta)
end

-- 存款
function BankInfoLayer:onSaveScore()
    --参数判断
    --local szScore = string.gsub(self.m_editSave:getText(),"([^0-9])","")   
    --szScore = string.gsub(szScore, "[.]", "")
    local szScore = self.m_editSave:getText() or 0 
    if #szScore < 1 then 
        showToast(self,"请输入操作金额！",2)
        return
    end
    local lOperateScore = tonumber(szScore)
    if nil == lOperateScore or lOperateScore < 1 then
        showToast(self,"请输入正确金额！",2)
        return
    end
    if lOperateScore > GlobalUserItem.tabAccountInfo.bag_money then
        showToast(self,"您所携带游戏币的数目余额不足,请重新输入游戏币数量!",2)
        return
    end
  
  self:sendSaveMoney(lOperateScore)
end

-- 取款
function BankInfoLayer:onTakeScore()
    --参数判断
    --local szScore =  string.gsub(self.m_editTake:getText(),"([^0-9])","")
    --szScore = string.gsub(szScore, "[.]", "")
    local szScore =  self.m_editTake:getText() or 0
    if #szScore < 1 then 
        showToast(self,"请输入操作金额！",2)
        return
    end
    local lOperateScore = tonumber(szScore)
    if nil == lOperateScore or lOperateScore < 1 then
        showToast(self,"请输入正确金额！",2)
        return
    end
    if lOperateScore > GlobalUserItem.tabAccountInfo.bank_money then
        showToast(self,"您银行游戏币的数目余额不足,请重新输入游戏币数量！",2)
        return
    end
    
    self:sendTakeMoney(lOperateScore)
end

-- 转账
function BankInfoLayer:onTransferScore()
    --参数判断
    local szScore =  self.m_editTransferScore:getText() or 0
    local szTarget = self.m_editTransferID:getText()
    local byID = 1

    if #szScore < 1 then 
        showToast(self,"请输入操作金额！",2)
        return
    end
    local lOperateScore = tonumber(szScore)
    if nil == lOperateScore or lOperateScore < 1 then
        showToast(self,"请输入正确金额！",2)
        return
    end

    if #szTarget < 1 then 
        showToast(self,"请输入赠送用户ID！",2)
        return
    end

    self:sendTranseferMoney(szTarget, lOperateScore)
end

function BankInfoLayer:clean()
    -- 重置编辑区域
    self.m_editSave:setText("")
    self.m_editTake:setText("")
    self.m_editTransferID:setText("")
    self.m_editTransferScore:setText("")
    self.m_lOperateScore = 0

    -- 转账金额大写
    self.m_txtTransferNumber:setString("请输入金额")
end

function BankInfoLayer:addColdUI( node  )

    local imageGold = ccui.ImageView:create("hall/plist/hall/gui-gm-icon-gold.png", ccui.TextureResType.plistType)
    imageGold:setAnchorPoint(cc.p(0.5,0.5))
    imageGold:setPosition(cc.p(450, 550))
    node:addChild(imageGold)

    local imageBank = ccui.ImageView:create("hall/plist/hall/gui-hall-top-btn-bank.png", ccui.TextureResType.plistType)
    imageBank:setAnchorPoint(cc.p(0.5,0.5))
    imageBank:setPosition(cc.p(500+200, 550))
    node:addChild(imageBank)

    -- 金币
    local textGold = cc.Label:createWithBMFont("hall/font/sz_jbdtzt3.fnt","")
    textGold:setPosition(ccp(95,20))
    textGold:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
    textGold:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    textGold:setString(GlobalUserItem.tabAccountInfo.bag_money)
    imageGold:addChild(textGold)

    -- 存款
    local textBank = cc.Label:createWithBMFont("hall/font/sz_jbdtzt3.fnt","")
    textBank:setPosition(ccp(100,22))
    textBank:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
    textBank:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    textBank:setString(GlobalUserItem.tabAccountInfo.bank_money)
    imageBank:addChild(textBank)

    self.TextGold = textGold
    self.TextBank = textBank
    self.ImageGold = imageGold
    self.ImageBank = imageBank
end

function BankInfoLayer:onUserInfoChange( event  )
    print("----------userinfo change notify------------")
    local msgWhat = event.obj
    if nil ~= msgWhat then
       if msgWhat == yl.RY_MSG_USERWEALTH then
         --  self:onMsgUpdateSocre()
       end
    end
end

function BankInfoLayer:onMsgUpdateSocre()
    --用户金币
    self.TextGold:setString(GlobalUserItem.tabAccountInfo.bag_money)

    -- 保险箱金币
    self.TextBank:setString(GlobalUserItem.tabAccountInfo.bank_money)
end

function BankInfoLayer:showGoldIcon(tag)

    if tag == TAG_ENUM.RECORD then
       self.m_commonGoldUI:setVisible(false)
    else
       self.m_commonGoldUI:setVisible(true)
    end
    if tag == TAG_ENUM.TRANSFER then
       self.m_commonGoldUI:setPositionY(509)
    else
       self.m_commonGoldUI:setPositionY(480)
    end
end

return BankInfoLayer