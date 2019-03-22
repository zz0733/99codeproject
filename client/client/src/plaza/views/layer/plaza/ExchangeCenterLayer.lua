--region ExchangeCenterLayer.lua
--Date 2017.04.24.
--Auther JackyXu.
--Desc: 个人信息 view
local ExchangeCenterLayer   = class("ExchangeCenterLayer", FixLayer)
local ExternalFun    = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local G_VecBank      = yl.getLocalString("BankName")
local CommonGoldView = appdf.req(appdf.CLIENT_SRC .. "plaza.views.layer.plaza.CommonGoldView")     --通用金币框
local LogonFrame     = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame") 
local Lang           = appdf.req(appdf.EXTERNAL_SRC .. "DTCommonWords")
local BindAlipayView = appdf.req(appdf.PLAZA_VIEW_SRC.."BindAlipayView")   
local BindBankpayView = appdf.req(appdf.PLAZA_VIEW_SRC.."BindBankpayView")    
 
local TAG_BTN_SELECT = {
    ZhiFuBao    = 1,
    YingHangKa  = 2,
    Exchange    = 3,
}
local INTERVAL = 0.18
local IMAGE_LOGO = 200
local TEXT_LOGO = 201
local SHOW_LOGO = 100
local SHOW_TEXT = 101
local EXCHANGTYPE = {
    EXCHANGE_NONE = 0,
    EXCHANGE_ALIPAY = 1,
    EXCHANGE_WECHAT= 2,
    EXCHANGE_CARD = 3,
}
local G_EXCHANGE_ICON_PATH = {
    [EXCHANGTYPE.EXCHANGE_ALIPAY]   = "gui-hall-cash-icon-aliypay.png",
    [EXCHANGTYPE.EXCHANGE_CARD]     = "gui-hall-cash-icon-bank.png",
    [EXCHANGTYPE.EXCHANGE_WECHAT]   = "gui-hall-cash-icon-wechat.png",
}

function ExchangeCenterLayer.create()
    return ExchangeCenterLayer.new():init()
end

function ExchangeCenterLayer:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()
    self.m_nLastTouchTime       = 0
    self.m_nEditBoxTouchCount   = 0 -- 输入框点击次数
    self.m_nSelectBankTag       = 0
    self.m_iBindType            = -1
    self.m_bIsMenuOpen          = nil
    self.m_bIsMenuOpenbk          = nil
    self.m_pBtnBankerSelect     = {}
    self.m_pVecButtonImage      = {}
    self.m_AlipayAccount       = ""
    self.m_BankpayAccount       = ""
    self.selecteType = 1
    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    local  onUseMessageCallBack = function(result,message)
       self:onUserExchangeCenterCallBack(result,message)
    end

    self._plazaFrame = LogonFrame:getInstance()
    self._plazaFrame:setCallBackDelegate(self, onUseMessageCallBack)
    
end

function ExchangeCenterLayer:init()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)

    self.m_pathUI = cc.CSLoader:createNode("dt/ChangeView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))
    
    self.center = self.m_pathUI:getChildByName("center")
    self.center:setPositionX((display.width ) / 2)
    self.rootNode = self.center:getChildByName("image_Bg")
    self.rootNode:setPositionY(self.rootNode:getPositionY()+30)
    self.color = self.m_pathUI:getChildByName("mask"):setContentSize(cc.size(1334,750))
    self.bmfont_myMoneyLabel = self.rootNode:getChildByName("bmfont_myMoneyLabel")
    self.button_closeBtn = self.rootNode:getChildByName("button_closeBtn")
    self.button_recordBtn = self.rootNode:getChildByName("button_recordBtn")
    self.button_recordBtn:setVisible(false)
    self.panel_contentPanel = self.rootNode:getChildByName("panel_contentPanel")
    self.openInput = self.panel_contentPanel:getChildByName("image_openInput")
    self.button_clearInput = self.openInput:getChildByName("button_clearInput")
    self.perentLabel = self.panel_contentPanel:getChildByName("text_perentLabel")
    self.moneySlider = self.panel_contentPanel:getChildByName("slider_moneySlider")
    self.button_maxBtn = self.panel_contentPanel:getChildByName("button_maxBtn")
    self.changeBtn = self.rootNode:getChildByName("button_changeBtn")
    self.clearInput = self.openInput:getChildByName("button_clearInput")

    self.acNum = self.panel_contentPanel:getChildByName("Image_15")
    self.bindAlipayBtn = self.acNum:getChildByName("button_bindAlipayBtn")
    self.ownAccountImg = self.acNum:getChildByName("image_ownAccountImg")
    self.alipayAccount = self.acNum:getChildByName("Image_16"):getChildByName("text_alipayAccount")
    
    self.tab2 = self.rootNode:getChildByName("Image_left"):getChildByName("listView_listTabs"):getChildByName("panel_tab2")
    self.tab1 = self.rootNode:getChildByName("Image_left"):getChildByName("listView_listTabs"):getChildByName("panel_tab1")

    self.myMoneyLabel = self.rootNode:getChildByName("bmfont_myMoneyLabel")
    self.myMoneyLabel:setString(GlobalUserItem.tabAccountInfo.bank_money)

    self.clearInput:addClickEventListener(handler(self, self.onClearInput))
    self.button_closeBtn:addClickEventListener(handler(self,self.onMsgCloseSelf))
    self.button_maxBtn:addClickEventListener(handler(self, self.maxMoney))
    self.bindAlipayBtn:addClickEventListener(handler(self, self.openBindAlipay))
    self.changeBtn:addClickEventListener(handler(self, self.onChangeCash))

    self.moneySlider:addEventListener(function (obj ,eventType )
    		-- body
		if eventType == ccui.SliderEventType.percentChanged then
			self:updateInputMoney(obj:getPercent())
		elseif eventType == ccui.SliderEventType.slideBallUp then
			-- self:onMusic(obj:getPercent())
			self:updateInputMoney(obj:getPercent())
		elseif eventType == ccui.SliderEventType.slideBallCancel then
			-- self:onMusic(obj:getPercent())
			self:updateInputMoney(obj:getPercent())
		end
	end)
    self:initTabSelect()
    self.perentLabel:setString("0%")
    return self
end

function ExchangeCenterLayer:onEnter()
    self.super:onEnter()
    self:showWithStyle()
    self:openInputEditBox()


    self:GetbindMsg()

end

function ExchangeCenterLayer:openInputEditBox( ... )


	editTxt = ccui.EditBox:create(cc.size(340,50), "dt/image/zcm_chongzhi/zcm_zc1_2.png")  --输入框尺寸，背景图片  
    editTxt:setName("inputTxt")  
    editTxt:setAnchorPoint(0.5,0.5)  
    editTxt:setPosition(cc.p(self.openInput:getPositionX() / 2 - 40 ,self.openInput:getPositionY() / 2 - 82))                        --设置输入框的位置  
    editTxt:setFontSize(26)                            --设置输入设置字体的大小  
    editTxt:setMaxLength(10)                             --设置输入最大长度
    editTxt:setFontColor(cc.c4b(255,255,255,255))         --设置输入的字体颜色  
    editTxt:setFontName("sim2542hei")                       --设置输入的字体为simhei.ttf
    editTxt:setPlaceholderFontSize(24)
	editTxt:setPlaceholderFontColor(cc.c4b(184,187,182,255))  
    -- editTxt:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) --设置数字符号键盘  
	editTxt:setPlaceHolder("输入兑换金额")               --设置预制提示文本  
    editTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)  --输入键盘返回类型，done，send，go等KEYBOARD_RETURNTYPE_DONE  
    -- editTxt:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) --输入模型，如整数类型，URL，电话号码等，会检测是否符合  
    editTxt:registerScriptEditBoxHandler(function(eventname,sender) self:editboxHandle(eventname,sender) end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等  
    self.openInput:addChild(editTxt,5)  
--  editTxt:setHACenter() --输入的内容锚点为中心，与anch不同，anch是用来确定控件位置的，而这里是确定输入内容向什么方向展开(。。。说不清了。。自己测试一下)  
end

--输入框事件处理  
function ExchangeCenterLayer:editboxHandle(strEventName,sender)  
    if strEventName == "began" then  
    	sender:setPlaceHolder("")                                    --光标进入，清空内容/选择全部  
    elseif strEventName == "ended" then  
        if sender:getText() then
        	sender:setPlaceHolder("输入兑换金额") 
        end                                                        --当编辑框失去焦点并且键盘消失的时候被调用  
    elseif strEventName == "return" then  
         self:updataPercent()                                                       --当用户点击编辑框的键盘以外的区域，或者键盘的Return按钮被点击时所调用  
    elseif strEventName == "changed" then
    	 print(sender:getText(), "sender")
    	if  #sender:getText() > 0 then
          	self:updataPercent() 
  		end                                                     --输入内容改变时调用   
    end  
end 

function ExchangeCenterLayer:initTabSelect()
	local allTab = {}
	local function itemSelected(item, bol)
		item:getChildByName("image"):setVisible(bol)
		item:getChildByName("light"):setVisible(bol)
		item:getChildByName("unlight"):setVisible(not bol)
		item:getChildByName("sp"):setVisible(not bol)
		if bol then
			-- self:showPayPanel(item.myTp)
			self:changePanel(item.myTp)
		end
	end
	local function Btn_SelectTab(obj)
		if obj == self.tab2 then
--			local canUseAilpay = cc.loaded_packages.DTCommonModel:getCanUseAlipay()
	--		if not canUseAilpay  then
		--		self:showBar("使用支付宝充值成功一次即可开通！")
	--			return
--			end
		end
		if obj == self.tab2 then
			-- self.payWaringTps:loadTexture("dt/image/zcm_duihuan/zcm_dh48.png")
		else
			-- self.payWaringTps:loadTexture("dt/image/zcm_duihuan/zcm_dh46.png")
		end
		uiCheck:updateGroup(allTab, obj)
	end

	for i = 1, 10 do
		local panel = self["tab"..i]
		if panel ~= nil then
			local type_rank = i
			panel.myTp = type_rank
			panel.setSelected = itemSelected
			panel:addClickEventListener(Btn_SelectTab)
			table.insert(allTab, panel)
		end
	end
	uiCheck:updateGroup(allTab, allTab[self.selecteType])
end

function ExchangeCenterLayer:changePanel( panelType )
	-- body
	-- local data = cc.loaded_packages.DTCommonModel:getBindExchangeInfos()
	if panelType == 1 then
		self.ownAccountImg:loadTexture("dt/image/zcm_duihuan/zcm_dh23.png")
		
		local info = self:getChangeInfoByType(2)
		if info then
			self.alipayAccount:setString(info.bankcardnumber)
		--	self.changeImg:loadTexture("dt/image/zcm_duihuan/zcm_dh38.png")
		else
			self.alipayAccount:setString(Lang.EXCHANGE_TYPE_BankPay)
		--	self.changeImg:loadTexture("dt/image/zcm_duihuan/zcm_dh21.png")
		end

	elseif panelType == 2 then
		self.ownAccountImg:loadTexture("dt/image/zcm_duihuan/zcm_dh3.png")
		local info = self:getChangeInfoByType(1)
		if info then
			self.alipayAccount:setString(info.alipayaccout)
			--self.changeImg:loadTexture("dt/image/zcm_duihuan/zcm_dh37.png")
		else
			self.alipayAccount:setString(Lang.EXCHANGE_TYPE_AliPay)
			--self.changeImg:loadTexture("dt/image/zcm_duihuan/zcm_dh29.png")
		end
	end
	self.selecteType = panelType == 1 and 2 or 1
    self:setUserBinding()
end

function ExchangeCenterLayer:getChangeInfoByType( types )

	return nil
end


uiCheck = {
	updateGroup = function(this, checkArray, checkCur)
		for i,v in pairs(checkArray) do
			if v~=checkCur then
				v:setSelected(false)
				v:setTouchEnabled(true)
			end
		end
		checkCur:setTouchEnabled(false)
		checkCur:setSelected(true)
	end
}

function ExchangeCenterLayer:updatePanelShow( ... )
	-- body
	local data = cc.loaded_packages.DTCommonModel:getBindExchangeInfos()
	dump(data, "绑定的信息")
	local info = self:getChangeInfoByType(self.selecteType)
	print("self.selecteType",self.selecteType)
	dump(info,"info")
	if info then
		if self.selecteType == 2 then
			self.alipayAccount:setString(info.bankcardnumber)
			--self.changeImg:loadTexture("dt/image/zcm_duihuan/zcm_dh38.png")
		elseif self.selecteType == 1 then
			self.alipayAccount:setString(info.alipayaccout)
			--self.changeImg:loadTexture("dt/image/zcm_duihuan/zcm_dh37.png")
		else
			print("errorupdatePanelShow")
		end
	end
end

function ExchangeCenterLayer:updataPercent( value)
	-- body
	local function reset( ... )
		-- body
		self.perentLabel:setString("0%")
		self.moneySlider:setPercent(0)
		editTxt:setText("")
	end

	local inputString = editTxt:getText()
	print("inputString",inputString)
	local percent = 0
	if #inputString == 0 then
		reset()
		return
	end

	if not tonumber(inputString) then
		self:showBar("输入了非法字符,请正确输入")
		reset()
		return
	end
--[[
	if string.match(inputString, "%.") then
		reset()
		self:showBar("不可输入小数")
		return
	end
    --]]
	local insertNum = tonumber(inputString) 
	if math.floor(insertNum) < insertNum then
		--self:showBar("不可输入小数")
		--reset()
		--return
	end
	local maxLimit = GlobalUserItem.tabAccountInfo.bank_money-- cc.loaded_packages.DTCommonModel:getCoinCnt() - OutLimit
	--[[
    maxLimit = math.floor(maxLimit)
	if maxLimit < 0 then
		self:showBar("剩余余额不足5元不可兑换")
		reset()
		return
	end
    --]]
	if insertNum > maxLimit then
		insertNum = maxLimit
		editTxt:setText(insertNum)
	end
	local percent = math.ceil(insertNum *100/ maxLimit )
	self.perentLabel:setString(percent.."%")
	self.moneySlider:setPercent(percent)
end

function ExchangeCenterLayer:showBar( content )
	-- body
	local FloatBar = appdf.req(appdf.PLAZA_VIEW_SRC .. "FloatBar")
	local bar = FloatBar.new(content)
	self:addChild(bar)
	bar:setPosition(display.center)
end

function ExchangeCenterLayer:maxMoney( ... )
	-- body
	-- self.moneySlider:setPercent(100)
	-- self:updateInputMoney(100)
	local maxLimit = GlobalUserItem.tabAccountInfo.bank_money
	if maxLimit then
		--self:showBar("剩余余额不足5元不可兑换")
		--editTxt:setText(tostring(maxLimit))
		self.moneySlider:setPercent(100)
		self:updateInputMoney(100)
	end
end

function ExchangeCenterLayer:updateInputMoney( value )
	-- body
	self.perentLabel:setString(value.."%")
	print("滑动值:",value)
	local money = GlobalUserItem.tabAccountInfo.bank_money
	if money < 0 then
		self:onClearInput()
	else
		local realMoney = money * value / 100
		if realMoney == 0 then
			realMoney = ""
		end
		editTxt:setText(realMoney)
	end
	
end

function ExchangeCenterLayer:onClearInput( ... )
	-- body
	self.moneySlider:setPercent(0)
	-- self:updateInputMoney(0)
	editTxt:setText("")
end

function ExchangeCenterLayer:openBindAlipay( ... )
	-- body
	if self.selecteType == 2 then
        local m_BindBankpayView = BindBankpayView.create(self._scene)
        m_BindBankpayView:setName("m_BindAlipayView")
    	self:addChild(m_BindBankpayView)
	elseif self.selecteType == 1 then
        local m_BindAlipayView = BindAlipayView.create(self._scene)
        m_BindAlipayView:setName("m_BindAlipayView")
    	self:addChild(m_BindAlipayView)
	end
end

function ExchangeCenterLayer:onExit()
    self.super:onExit()
end

function ExchangeCenterLayer:setUserBinding()

    local account = self.selecteType == 1 and self.m_AlipayAccount or self.m_BankpayAccount

    self.alipayAccount:setString(account)
end

function ExchangeCenterLayer:onMsgCloseSelf()
    self:onMoveExitView(FixLayer.HIDE_NO_STYLE)
end


function ExchangeCenterLayer:checkIsGuestUser()
    local isGuest = false
    if PlayerInfo.getInstance():getIsGuest() then
        isGuest = true
    end

    if GameListManager.getInstance():isYsdkChannel() then
        self.m_pBtnUpdateAcount:setVisible(false)
    end

    return isGuest
end

function ExchangeCenterLayer:createEditBox(maxLength, keyboardReturnType, inputMode, inputFlag, tag, size, placestr)
    local sprite1 = ccui.Scale9Sprite:createWithSpriteFrameName("gui-texture-null.png")
    local sprite2 = ccui.Scale9Sprite:createWithSpriteFrameName("gui-texture-null.png")
    local sprite3 = ccui.Scale9Sprite:createWithSpriteFrameName("gui-texture-null.png")
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
    --[[
    if device.platform == "android" then
        self.m_nEditBoxTouchCount = 0
        editBox:touchDownAction(editBox,ccui.TouchEventType.ended)
        editBox:touchDownAction(editBox,ccui.TouchEventType.canceled)
    else
        self.m_nEditBoxTouchCount = 2
    end
    ]]
    return editBox
end
-------------------------init----------------------------
function ExchangeCenterLayer:initExchangeInfo()
    self.m_pNodePop:setVisible(false)
    self.m_pBtnPush:setVisible(true)
    self.m_pBtnPull:setVisible(false)
    self.m_pBtnCancel:setVisible(false)
    self:setExchangeType(EXCHANGTYPE.EXCHANGE_ALIPAY)
    self:initEditBox()

    --初始化是否暂不支持
    for i = 1, 3 do
        local isSupport = self:checkSupport(i , false)
        self.m_pNodePop:getChildByTag(i):getChildByName("LB_tips"):setVisible(not isSupport)
    end

    -- 微信暂不支持 禁用
    self.m_pNodePop:getChildByTag(2):getChildByName("LB_tips"):setVisible(true)
    self.m_pNodePop:getChildByTag(2):getChildByName("BTN_select"):setTouchEnabled(false)
    -- 银行卡绑定界面隐藏暂不可用字样
    for i=1,6 do
        local pSelectBtnbk = self.m_pNodePopbk:getChildByName("node_"..i):getChildByName("LB_tips")
        if pSelectBtnbk then
           pSelectBtnbk:setVisible(false)
        end
    end
end

function ExchangeCenterLayer:initSelectBanker()
    local _bankname =  "123456"--PlayerInfo.getInstance():getBindingBankName()
    if string.len(_bankname) > 0 then
        for i=1,15 do
            local strName = string.format("bank_%d", i)
            if _bankname == G_VecBank[strName] then
                local _pos = cc.p(self.m_pBtnBankerSelect[i]:getPosition())
                self.m_pImgBankSelected:setPosition(_pos)
                self.m_pImgBankSelected:setVisible(true)
                break
            end
        end
    end
end




--------------------------click-----------------------------

-- 关闭
function ExchangeCenterLayer:onCloseClicked()
    ExternalFun.playClickEffect()
    self:onMoveExitView()
end

function ExchangeCenterLayer:onMenuStutasChange()
    ExternalFun.playClickEffect()
    self.m_bIsMenuOpen = not self.m_bIsMenuOpen
    self:onClickedWay()
end

function ExchangeCenterLayer:onMenuOpen()
    ExternalFun.playClickEffect()
    self.m_bIsMenuOpen = true
    self:onClickedWay()
end
function ExchangeCenterLayer:onMenuStutasChangebk()
    ExternalFun.playClickEffect()
    self.m_bIsMenuOpenbk = not self.m_bIsMenuOpenbk
    self:onClickedWaybk()
end
--绑定银行界面
function ExchangeCenterLayer:onMenuOpenbk()
    ExternalFun.playClickEffect()
    self.m_bIsMenuOpenbk = true
    self:onClickedWaybk()
end

--绑定银行界面
function ExchangeCenterLayer:onMenuClosebk()
    ExternalFun.playClickEffect()
    self.m_bIsMenuOpenbk = false
    self:onClickedWaybk()
end

function ExchangeCenterLayer:onMenuClose()
    ExternalFun.playClickEffect()
    self.m_bIsMenuOpen = false
    self.m_bIsMenuOpenbk = false
    self:onClickedWay()
    self:onClickedWaybk()
end

function ExchangeCenterLayer:onClickedWay()
    if self.m_bIsMenuOpen then --up to down
        self.m_pNodePop:stopAllActions()
        self.m_pBtnPull:setVisible(true)
        self.m_pBtnCancel:setVisible(true)
        self.m_pBtnPush:setVisible(false)
        self.m_pBtnSelect:setVisible(false)
        self.m_pDialogAction:play("PopSelect",false)
    else 
        --down to up
        self.m_pNodePop:stopAllActions()
        self.m_pBtnPull:setVisible(false)
        self.m_pBtnCancel:setVisible(false)
        self.m_pBtnPush:setVisible(true)
        self.m_pBtnSelect:setVisible(true)
        self.m_pDialogAction:play("HideSelect",false)
    end
end

function ExchangeCenterLayer:onClickedWaybk()
    if self.m_bIsMenuOpenbk then --up to down
        self.m_pNodePopbk:stopAllActions()
        self.m_pBtnPullbk:setVisible(true)
        self.m_pBtnCancel:setVisible(true)
        self.m_pBtnPushbk:setVisible(false)
        --self.m_pBtnSelect:setVisible(false)
        self.m_pDialogAction:play("PopSelect",false)
    else 
        --down to up
        self.m_pNodePopbk:stopAllActions()
        self.m_pBtnPullbk:setVisible(false)
        self.m_pBtnCancel:setVisible(false)
        self.m_pBtnPushbk:setVisible(true)
        --self.m_pBtnSelect:setVisible(true)
        self.m_pDialogAction:play("HideSelect",false)
    end
end

function ExchangeCenterLayer:onTypeClickedItem(nIndex,noneedaction)

    --set type
    --self:setExchangeType(nIndex)
    --[[
    self:setUserBinding()
    
    --set logo and text
    if G_EXCHANGE_ICON_PATH[nIndex] then
        local _sprite2 = self.m_pImgTypeBg:getChildByTag(SHOW_LOGO)
        _sprite2:loadTexture(G_EXCHANGE_ICON_PATH[nIndex], ccui.TextureResType.plistType)
    end
        
    local _label1 = self.m_pNodePop:getChildByTag(nIndex):getChildByTag(TEXT_LOGO)
    local _label2 = self.m_pImgTypeBg:getChildByTag(SHOW_TEXT)
    _label2:setString(_label1:getText())
    
    -- 初始化的时候用了这不需要下面的显示
    if noneedaction ~= nil and noneedaction then
        return
    else
        ExternalFun.playClickEffect()
    end

    --close menu
    self.m_bIsMenuOpen = false
    self:onClickedWay()
    --]]
end

function ExchangeCenterLayer:onTypeClickedItembk(nIndex)
--[[
    ExternalFun.playClickEffect()

    --set type
    self:setExchangeType(nIndex)
    self:setUserBinding()

    local _label1 = self.m_pNodePopbk:getChildByName("node_"..nIndex):getChildByName("LB_type")
    local _label2 = self.m_pImgTypeBgbk:getChildByName("LB_selectType")
    _label2:setString(_label1:getText())
    
    --close menu
    self.m_bIsMenuOpenbk = false
    self:onClickedWaybk()
    --]]
end

function ExchangeCenterLayer:onClickedItem(index)
    if index == TAG_BTN_SELECT.YingHangKa then
        self.m_iBindType = EXCHANGTYPE.EXCHANGE_CARD
    elseif index == TAG_BTN_SELECT.ZhiFuBao then
        self.m_iBindType = EXCHANGTYPE.EXCHANGE_ALIPAY
    end
    if index == TAG_BTN_SELECT.YingHangKa then
        self:initSelectBanker()
    end
    self:updateTableButtonState(index)
end

-- 选择银行
function ExchangeCenterLayer:onClickedBank(tag, pos)
    ExternalFun.playClickEffect()
    -- 未绑定
 --   if string.len(PlayerInfo.getInstance():getBindingBankName()) == 0 then
        self.m_nSelectBankTag = tag
        self.m_pImgBankSelected:setPosition(pos)
        self.m_pImgBankSelected:setVisible(true)
--    end

    local strName = string.format("bank_%d", tag)
    printf("--- userBinding:onBankClicked [%d] [%s] ----", tag, G_VecBank[strName])
end

function ExchangeCenterLayer:initBindData(BDdata)
    if BDdata == nil then
        return
    end
    --支付宝账号
    self.m_AlipayAccount       = BDdata[1] 
    --银行卡号
    self.m_BankpayAccount       = BDdata[3] 
    -- 获取数据后初始化提现界面
    self:initExLayer(BDdata)
end

function ExchangeCenterLayer:initExLayer(BDdata)
   local  hasbdAlipay  = string.len(BDdata[1]) > 0
   local  hasbdBankpay = string.len(BDdata[3]) > 0
   self:setUserBinding()
end

-- help func
function ExchangeCenterLayer:setExchangeType(nExchangeType)
    self.m_iExchangeType = nExchangeType
end

function ExchangeCenterLayer:getExchangeType()
    return self.m_iExchangeType
end

function ExchangeCenterLayer:onChangeCash( ... )
	-- body
	local inputString = editTxt:getText()
	if #inputString == 0 then
		inputString = "0"
	end
	local moneyNum = tonumber(inputString)
	print(moneyNum,"moneyNum")

	if moneyNum  <=  0 then
		self:showBar("输入的数字不是有效的数字")
		return
	end

    local CashType =  self.selecteType == 1 and 2 or 1
    
    --local dataType = self:transformType(CashType)
    -- 2.支付宝 1.银行卡
    self:sendExchange(CashType,moneyNum)
end

function ExchangeCenterLayer:transformType(CashType)
   local dataType = CashType == 1 and 2 or 1
   return dataType
end

--请求绑定支付宝
function ExchangeCenterLayer:sendAlipayBindMsg(account, realname)
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "bind_pay_account"
    msgta["body"] = {}
    msgta["body"]["bind_type"] = 1
    msgta["body"]["bind_account"] = account
    msgta["body"]["owner_name"] = realname
    msgta["body"]["bank_name"] = ""
    msgta["body"]["bank_province"] = ""
    msgta["body"]["bank_subbranch"] = ""
    msgta["body"]["bind_status"] = 1
    self._plazaFrame:sendGameData(msgta)
end

--请求绑定银行卡
function ExchangeCenterLayer:sendBindingCard(bankAccount,bankName,SubbranchName,provinceName,cityName)
    local address = ""
    if provinceName and cityName then
       address = provinceName.."省"..cityName
    end
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "bind_pay_account"
    msgta["body"] = {}
    msgta["body"]["bind_type"] = 2
    msgta["body"]["bind_account"] = bankAccount
    msgta["body"]["owner_name"] = bankAccount
    msgta["body"]["bank_name"] = bankName
    msgta["body"]["bank_province"] = address
    msgta["body"]["bank_subbranch"] = SubbranchName
    msgta["body"]["bind_status"] = 1
    self._plazaFrame:sendGameData(msgta)
end

--请求提现
function ExchangeCenterLayer:sendExchange(exType,money)
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "treasure_to_zfb_fare"
    msgta["body"] = {}
    msgta["body"]["zfb_money"] = money
    msgta["body"]["exchange_type"] = exType
    self._plazaFrame:sendGameData(msgta)
end

--请求绑定的信息
function ExchangeCenterLayer:GetbindMsg()
   local payBindMsg = GlobalUserItem.tabAccountInfo.payBindMsg
   if payBindMsg ~= nil then
      self:initBindData(payBindMsg)
   else
      self:sendGetbindMsg()
   end

end


--请求绑定的信息
function ExchangeCenterLayer:sendGetbindMsg()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "get_zfb_account"
    msgta["body"] = {}
    self._plazaFrame:sendGameData(msgta)
end

--消息请求回调
function ExchangeCenterLayer:onUserExchangeCenterCallBack(result,message)
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
    if type(message) == "table" then
        if message.tag == "bind_pay_account" then
            if message.result == "ok" then
                FloatMessage.getInstance():pushMessage("绑定成功")
                --绑定成功重新获取绑定信息
                self:sendGetbindMsg()
            else
                FloatMessage.getInstance():pushMessage(message.result)
            end 
        elseif message.tag == "treasure_to_zfb_fare" then
            if message.result == "ok" then
                FloatMessage.getInstance():pushMessage("提现成功")
                --绑定成功重新获取绑定信息
                self:sendGetbindMsg()
            else
                FloatMessage.getInstance():pushMessage(message.result)
            end 
        elseif message.tag == "get_zfb_account" then
            if message.result == "ok" then
                print("获取绑定信息成功")
                self:initBindData(message.body)
            else
                FloatMessage.getInstance():pushMessage(message.result)
            end
        end
    end
end



return ExchangeCenterLayer
