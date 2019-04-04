--BindBankpayView.lua
--creater by haike 2018-5-2
--[[
local BaseFullLayer = require("app.fw.common.BaseFullLayer")
local DTCommonWords = require "app.games.dt.common.DTCommonWords"
local CommonHelper = require('app.fw.common.CommHelper')
local Lang = require('app.games.dt.common.DTCommonWords')
local BindBankpayView = class("BindBankpayView", BaseFullLayer)
BindBankpayView.RESOURCE_FILENAME = "dt/BindBankpayView.csb"
--]]
local BindBankpayView   = class("BindBankpayView", FixLayer)
local ExternalFun    = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local LogonFrame     = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame") 
local Lang           = appdf.req(appdf.EXTERNAL_SRC .. "DTCommonWords")

function BindBankpayView.create()
    return BindBankpayView.new():init()
end

function BindBankpayView:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    local  onUseMessageCallBack = function(result,message)
      -- self:onUserExchangeCenterCallBack(result,message)
    end

    self._plazaFrame = LogonFrame:getInstance()
    self._plazaFrame:setCallBackDelegate(self, onUseMessageCallBack)
    
end

function BindBankpayView:init( ... )
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)

    self.m_pathUI = cc.CSLoader:createNode("dt/BindBankpayView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.bindali_root = self.m_pathUI:getChildByName("bindali_root")
    local diffX = 145 - (1624-display.size.width)/2
    self.bindali_root:setPositionX(diffX)
    self.rootNode_image_Bg = self.bindali_root:getChildByName("center"):getChildByName("image_Bg")
    self.bankListBg      = self.bindali_root:getChildByName("panel_bankListBg")
    self.Item = self.bindali_root:getChildByName("panel_Item")
    
    self.bankList = self.bankListBg:getChildByName("listView_bankList")
    
    self.nameInputBg     = self.rootNode_image_Bg:getChildByName("image_nameInputBg")
	self.bankcode        = self.rootNode_image_Bg:getChildByName("image_bankcode")
	self.openBankImg    = self.rootNode_image_Bg:getChildByName("image_openBankImg")
	self.provinceImg     = self.rootNode_image_Bg:getChildByName("image_provinceImg")
	self.cityImg         = self.rootNode_image_Bg:getChildByName("image_cityImg")
    
    self.openCardBankImg     = self.rootNode_image_Bg:getChildByName("image_openCardBankImg")
    self.openBankList    = self.openBankImg:getChildByName("button_openBankList")
    self.closeBtn = self.rootNode_image_Bg:getChildByName("button_closeBtn")
    self.bindBtn  = self.rootNode_image_Bg:getChildByName("button_bindBtn")
    
	self.closeBtn:addClickEventListener(handler(self, self.onClose))
	self.bindBtn:addClickEventListener(handler(self, self.onSureCall))
	self.openBankList:addClickEventListener(handler(self, self.openBankListCell))
    
    self.bankName = self.openBankImg:getChildByName("text_bankName")

    --[[
	self.nameInputBg:addClickEventListener(handler(self, self.onnameInputBg))
	self.bankcode:addClickEventListener(handler(self, self.onbankcode))
	self.openCardBankImg:addClickEventListener(handler(self, self.onopenCardBankImg))
	self.provinceImg:addClickEventListener(handler(self, self.onprovinceImg))
	self.cityImg:addClickEventListener(handler(self, self.oncityImg))
    --]]
	self:showBankList(false)
    
	-- 	--创建Editbox输入框     
	 self.nameInput = self:createEditBox("nameInput",cc.p(self.nameInputBg:getContentSize().width/2  + 10,self.nameInputBg:getContentSize().height / 2),  
	                 26,11,cc.c4b(255,255,255,255),"持卡人姓名",cc.EDITBOX_INPUT_MODE_ANY,handler(self,self.editboxHandle))  
	 self.nameInputBg:addChild(self.nameInput)

	 self.bankCodeInput = self:createEditBox("bankCodeInput",cc.p(self.bankcode:getContentSize().width / 2 + 10 ,self.bankcode:getContentSize().height / 2),  
	                 26,19,cc.c4b(255,255,255,255),"请输入银行卡账号",cc.EDITBOX_INPUT_MODE_NUMERIC,handler(self,self.editboxHandle),false,true) 
	 self.bankcode:addChild(self.bankCodeInput)

	-- self.idNumCodeInput = self:createEditBox("idNumCodeInput",cc.p(self.idnumberImg:getContentSize().width / 2 + 10,self.idnumberImg:getContentSize().height / 2 ),  
	--                 26,18,cc.c4b(148,151,160,255),"请输入身份证号码",cc.EDITBOX_INPUT_MODE_ANY,handler(self,self.editboxHandle)) 
	-- self.idnumberImg:addChild(self.idNumCodeInput)
	
	 self.provinceInput = self:createEditBox("provinceInput",cc.p(self.provinceImg:getContentSize().width / 2 ,self.provinceImg:getContentSize().height / 2 ),  
	                 26,20,cc.c4b(255,255,255,255),"省份",cc.EDITBOX_INPUT_MODE_ANY,handler(self,self.editboxHandle),cc.size(280,50)) 
	 self.provinceImg:addChild(self.provinceInput)

	 self.cityInput = self:createEditBox("cityInput",cc.p(self.cityImg:getContentSize().width / 2 ,self.cityImg:getContentSize().height / 2 ),  
	                 26,20,cc.c4b(255,255,255,255),"所属市",cc.EDITBOX_INPUT_MODE_ANY,handler(self,self.editboxHandle),cc.size(280,50)) 
	 self.cityImg:addChild(self.cityInput)

	 self.openCardBankInput = self:createEditBox("bankCodeInput",cc.p(self.openCardBankImg:getContentSize().width / 2 + 10,self.openCardBankImg:getContentSize().height / 2 ),  
	                 26,30,cc.c4b(255,255,255,255),"建议填写(可快速到账)",cc.EDITBOX_INPUT_MODE_ANY,handler(self,self.editboxHandle)) 
	 self.openCardBankImg:addChild(self.openCardBankInput)

    return self
end

function BindBankpayView:onEnter()
    self.super:onEnter()
    self:showWithStyle()
end

function BindBankpayView:onExit()
    self.super:onExit()
end

function BindBankpayView:createEditBox( name,pos,size,maxLength,fontColor,placeHolder,inputMode,funHandle, exSize,isNumber)
	-- body
	local deafoutSize = cc.size(365,50)
	if exSize then
		deafoutSize = exSize
	end
	local editTxt= ccui.EditBox:create(deafoutSize, "dt/image/zcm_chongzhi/zcm_zc1_2.png")  --输入框尺寸，背景图片  
    editTxt:setName(name)  
    editTxt:setAnchorPoint(0.5,0.5)  
    editTxt:setPosition(pos)                        --设置输入框的位置  
    editTxt:setFontSize(size)                            --设置输入设置字体的大小  
    editTxt:setMaxLength(maxLength)                             --设置输入最大长度为6  
    editTxt:setFontColor(fontColor)         --设置输入的字体颜色  
    editTxt:setFontName("sim2542hei")
    editTxt:setPlaceholderFontSize(24)
	editTxt:setPlaceholderFontColor(cc.c4b(184,187,182,255))
    if isNumber then
    	editTxt:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) 
    end                       --设置输入的字体为simhei.ttf  
    -- editTxt:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) --设置数字符号键盘  
	editTxt:setPlaceHolder(placeHolder)               --设置预制提示文本  
    editTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)  --输入键盘返回类型，done，send，go等KEYBOARD_RETURNTYPE_DONE  
    editTxt:setInputMode(inputMode) --输入模型，如整数类型，URL，电话号码等，会检测是否符合  
    editTxt:registerScriptEditBoxHandler(funHandle) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等  ,
    -- self.inputBg:addChild(editTxt,5)  
--  editTxt:setHACenter() --输入的内容锚点为中心，与anch不同，anch是用来确定控件位置的，而这里是确定输入内容向什么方向展开(。。。说不清了。。自己测试一下)  
 	return editTxt  
end
--输入框事件处理  
function BindBankpayView:editboxHandle(strEventName,sender)  
    if strEventName == "began" then  
    	sender:setPlaceHolder("")                                --光标进入，清空内容/选择全部  
    elseif strEventName == "ended" then  
                                                                --当编辑框失去焦点并且键盘消失的时候被调用  
    elseif strEventName == "return" then  
                                                                --当用户点击编辑框的键盘以外的区域，或者键盘的Return按钮被点击时所调用  
    elseif strEventName == "changed" then  
                                                                --输入内容改变时调用   
    end  
end

function BindBankpayView:onnameInputBg( ... )
	-- body
	self.nameInput:attachWithIME()
end
function BindBankpayView:onbankcode( ... )
	-- body
	self.bankCodeInput:attachWithIME()
end
function BindBankpayView:onopenCardBankImg( ... )
	-- body
	self.openCardBankInput:attachWithIME()
end
function BindBankpayView:onprovinceImg( ... )
	-- body
	self.provinceInput:attachWithIME()
end
function BindBankpayView:oncityImg( ... )
	-- body
	self.cityInput:attachWithIME()
end
function BindBankpayView:openBankListCell( ... )
	-- body
	self:showBankList(not self.bankListBg:isVisible())
end
function StringToTable(s)  
    local tb = {}  
      
    --[[  
    UTF8的编码规则：  
    1. 字符的第一个字节范围： 0x00—0x7F(0-127),或者 0xC2—0xF4(194-244); UTF8 是兼容 ascii 的，所以 0~127 就和 ascii 完全一致  
    2. 0xC0, 0xC1,0xF5—0xFF(192, 193 和 245-255)不会出现在UTF8编码中   
    3. 0x80—0xBF(128-191)只会出现在第二个及随后的编码中(针对多字节编码，如汉字)   
    ]]  
    for utfChar in string.gmatch(s, "[%z\1-\127\194-\244][\128-\191]*") do  
        table.insert(tb, utfChar)  
    end  
      
    return tb  
end 
function BindBankpayView:showBankList( isVisible )
	-- body
	self.bankListBg:setVisible(isVisible)
	if isVisible then
		if not self.bankList.isShow then
			for i = 1, 13 do
				local item = self:createOneItem(i, Lang["BANKNAME_TYPE_"..i])
				self.bankList:pushBackCustomItem(item)
				self.bankList.isShow = true
			end
		end
		self.bankList:jumpToTop()
	end
end

function BindBankpayView:createOneItem( index, txt )
	-- body
	local item = self.Item:clone()
	item:getChildByName("bankName"):setString(txt)
	-- item:getChildByName("bankName"):setColor(cc.c3b(145,178,228))
	item.index = index
	item:addClickEventListener(handler(self, self.updataBankName))
	return item
end

function BindBankpayView:updataBankName( sender )
	-- body
	local name = Lang["BANKNAME_TYPE_"..sender.index]
	self.bankName:setString(name)
	self:openBankListCell()
end

function BindBankpayView:onAccountImgInput( ... )
	-- body
	-- self.accountField:attachWithIME()
end

function BindBankpayView:onSureCall( ... )
	-- body
	--检查输入信息完整
	--#idNumCodeInput:getText()  >0 and 
	local function checkInfoAll( ... )
		-- body --and #openCardBankInput:getText()  > 0 
		if #self.nameInput:getText() > 0 and #self.bankCodeInput:getText()  > 0 and 
			#self.provinceInput:getText()  > 0 
			and #self.cityInput:getText()  > 0 and #self.bankName:getString() > 0 then
			return true
		end
		return false
	end

	local function checkBankNum( ... )
		-- body
		if #self.bankCodeInput:getText()  > 12 then
			return true
		end
		return false
	end

	if not checkInfoAll() then
		self:showBar("账号信息未全部填写")
		return
	end
	if  not checkBankNum() then
		self:showBar("银行卡位数不正确")
		return
	end
    local sTable = StringToTable(self.bankCodeInput:getText())  
    for i=1,#sTable do  
        local utfCharLen = string.len(sTable[i])  
        if utfCharLen > 1 then -- 长度大于1的就认为是中文  
 			self:showBar("银行卡号不能为中文")
 			return
        end  
    end 
	-- if not checkID() then
	-- 	self:showBar("身份证号码位数不正确")
	-- 	return
	-- end
 

	local   realname = self.nameInput:getText()
	local	bankcardnumber = self.bankCodeInput:getText()
	local	province = self.provinceInput:getText()
	local	city = self.cityInput:getText()
	local	bankname = self.openCardBankInput:getText()
	local	banktypename= self.bankName:getString()  or ""

    self:sendBindingCard(realname,bankcardnumber,banktypename,bankname,province,city)
end

function BindBankpayView:showBar( content )
	-- body
	local FloatBar = require("app.games.dt.hall.FloatBar")
	local bar = FloatBar.new(content)
	self:addChild(bar)
	bar:setPosition(display.center)
end

function BindBankpayView:showWaringDialogBox( content )
	-- body
	local showDialog = require('app.fw.common.DialogBox').show
   	showDialog('', content, Lang.OK)
end

function BindBankpayView:setData( data )
	-- body
	self.nameDes:setString(data.name..data.des)
	self.numberLabel:setString(data.account)
end

function BindBankpayView:initListener( ... )
	-- body
	BindBankpayView.super.initListener(self, ...)
	addNodeListener(self,"EXC_BINDRESULT", handler(self, self.onClose))
end

function BindBankpayView:onCopyCell( ... )
	-- body
	local FloatBar = require("app.games.dt.hall.FloatBar")
	local bar = FloatBar.new("复制成功,功能在快速开发中。。。")
	self:addChild(bar)
	bar:setPosition(display.center)
end

function BindBankpayView:onBack( ... )
	-- body
	print("BindBankpayView:onBack")
	self:onClose()
end

--请求绑定银行卡
function BindBankpayView:sendBindingCard(realname,bankAccount,bankName,SubbranchName,provinceName,cityName)
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
    msgta["body"]["owner_name"] = realname 
    msgta["body"]["bank_name"] = bankName
    msgta["body"]["bank_province"] = address
    msgta["body"]["bank_subbranch"] = SubbranchName
    msgta["body"]["bind_status"] = 1
    self._plazaFrame:sendGameData(msgta)
end

function BindBankpayView:onClose( ... )
    self:onMoveExitView(FixLayer.HIDE_NO_STYLE)
end
return BindBankpayView