--BindAlipayView.lua
--[[
local BaseFullLayer = require("app.fw.common.BaseFullLayer")
local DTCommonWords = require "app.games.dt.common.DTCommonWords"
local CommonHelper = require('app.fw.common.CommHelper')
local Lang = require('app.games.dt.common.DTCommonWords')
local BindAlipayView = class("BindAlipayView", BaseFullLayer)
BindAlipayView.RESOURCE_FILENAME = "dt/BindAlipayView.csb"
--]]
local BindAlipayView   = class("BindAlipayView", FixLayer)
local ExternalFun    = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local LogonFrame     = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame") 
local Lang           = appdf.req(appdf.EXTERNAL_SRC .. "DTCommonWords")

local accountStr = nil
local bindNameStr = nil

function BindAlipayView.create()
    return BindAlipayView.new():init()
end

function BindAlipayView:ctor()
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

function BindAlipayView:init( ... )
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)
	-- body

    self.m_pathUI = cc.CSLoader:createNode("dt/BindAlipayView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.rootNode = self.m_pathUI:getChildByName("center"):getChildByName("image_Bg")
    self.closeBtn = self.rootNode:getChildByName("button_closeBtn")
    self.sureBtn  = self.rootNode:getChildByName("button_sureBtn")
    self.accountImg  = self.rootNode:getChildByName("image_accountImg")
    self.nameImg  = self.rootNode:getChildByName("image_nameImg")
    self.accountStr=self.accountImg:getChildByName("textField_accountStr")
    self.bindNameStr=self.nameImg:getChildByName("textField_bindNameStr")
	self.closeBtn:addClickEventListener(handler(self, self.onClose))
	self.sureBtn:addClickEventListener(handler(self, self.onSureCall))
	self.accountStr:setVisible(false)
	self.bindNameStr:setVisible(false)

    self.accountStr = self:createEditBox("accountStr",cc.p(self.accountImg:getPositionX() / 2 - 60,self.accountImg:getPositionY() / 2 - 170),  
	                26,70,cc.c4b(148,151,160,255),"邮箱/手机号",cc.EDITBOX_INPUT_MODE_ANY,handler(self,self.editboxHandle))  
	self.bindNameStr = self:createEditBox("accountStr",cc.p(self.nameImg:getPositionX() / 2 - 60,self.nameImg:getPositionY() / 2 - 115),  
	                26,70,cc.c4b(148,151,160,255),"支付宝实名制姓名",cc.EDITBOX_INPUT_MODE_ANY,handler(self,self.editboxHandle)) 
	self.accountImg:addChild(self.accountStr,1)  
	self.nameImg:addChild(self.bindNameStr,1) 


    return self
end
function BindAlipayView:onEnter()
    self.super:onEnter()
    self:showWithStyle()
end

function BindAlipayView:onExit()
    self.super:onExit()
end

function BindAlipayView:createEditBox( name,pos,size,maxLength,fontColor,placeHolder,inputMode,funHandle)
	-- body
	local editTxt= ccui.EditBox:create(cc.size(365,50), "dt/image/zcm_chongzhi/zcm_zc1_2.png")  --输入框尺寸，背景图片  
	editTxt:setPlaceholderFontSize(24)
	editTxt:setPlaceholderFontColor(cc.c4b(95,95,95,255))
    editTxt:setName(name)  
    editTxt:setAnchorPoint(0.5,0.5)  
    editTxt:setPosition(pos)                        --设置输入框的位置  
    editTxt:setFontSize(size)                            --设置输入设置字体的大小  
    editTxt:setMaxLength(maxLength)                             --设置输入最大长度为6  
    editTxt:setFontColor(fontColor)         --设置输入的字体颜色  
    editTxt:setFontName("sim2542hei")                       --设置输入的字体为simhei.ttf  
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
function BindAlipayView:editboxHandle(strEventName,sender)  
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

function BindAlipayView:onNameImgInput( ... )
	-- body
	self.bindNameStr:attachWithIME()
end

function BindAlipayView:onAccountImgInput( ... )
	-- body
	self.accountStr:attachWithIME()
end

function BindAlipayView:onSureCall( ... )
	-- body
	local account = self.accountStr:getText()
	local name = self.bindNameStr:getText()
	if #account == "" or #name == "" then
		return
	end

        --如果是纯数字,就判断是不是电话号码
    if yl.string_number(account) then
        if string.len(account) ~= 11 then
            FloatMessage.getInstance():pushMessage("USR_DIALOG_27")
            return
        end
    else
        if not yl.check_email(account) then
            FloatMessage.getInstance():pushMessage("USR_DIALOG_27")
            return
        end
    end

        --检查名字是中文
    if not yl.check_string_chinese(name) then
        FloatMessage.getInstance():pushMessage("USR_DIALOG_28")
        return
    end
	print("绑定的account:",account,"name", name)

    self:sendAlipayBindMsg(account, name)
end

--请求绑定支付宝
function BindAlipayView:sendAlipayBindMsg(account, realname)
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

function BindAlipayView:showWaringDialogBox( content )
	-- body
	local showDialog = require('app.fw.common.DialogBox').show
   	showDialog('', content, Lang.OK)
end

function BindAlipayView:setData( data )
	-- body
	self.nameDes:setString(data.name..data.des)
	self.numberLabel:setString(data.account)
end

function BindAlipayView:initListener( ... )
	-- body
	BindAlipayView.super.initListener(self, ...)
	addNodeListener(self,"EXC_BINDRESULT", handler(self, self.onClose))
end

function BindAlipayView:onCopyCell( ... )
	-- body
	local FloatBar = require("app.games.dt.hall.FloatBar")
	local bar = FloatBar.new("复制成功,功能在快速开发中。。。")
	self:addChild(bar)
	bar:setPosition(display.center)
end

function BindAlipayView:onBack( ... )
	-- body
	print("BindAlipayView:onBack")
	self:onClose()
    self:onMoveExitView(FixLayer.HIDE_NO_STYLE)
end

function BindAlipayView:onClose( ... )
    self:onMoveExitView(FixLayer.HIDE_NO_STYLE)
end
--]]
return  BindAlipayView