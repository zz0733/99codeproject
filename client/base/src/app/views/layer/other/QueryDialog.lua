--[[
	询问对话框
		2016_04_27 C.P
	功能：确定/取消 对话框 与用户交互
]]
local PlayerInfo = appdf.req(appdf.EXTERNAL_SRC .. "PlayerInfo")
local QueryDialog = class("QueryDialog", function(msg,callback)
		local queryDialog = display.newLayer()
    return queryDialog
end)

--默认字体大小
QueryDialog.DEF_TEXT_SIZE 	= 32

--UI标识
QueryDialog.DG_QUERY_EXIT 	=  2 
QueryDialog.BT_CANCEL		=  0   
QueryDialog.BT_CONFIRM		=  1
QueryDialog.TAG_MASK 		= 3

-- 对话框类型
QueryDialog.QUERY_SURE 			= 1
QueryDialog.QUERY_SURE_CANCEL 	= 2

--窗外触碰
function QueryDialog:setCanTouchOutside(canTouchOutside)
	self._canTouchOutside = canTouchOutside
	return self
end

--msg 显示信息
--callback 交互回调
--txtsize 字体大小
function QueryDialog:ctor(msg, callback, txtsize, queryType)
	queryType = queryType or QueryDialog.QUERY_SURE_CANCEL
    txtsize = txtsize or 25
	self._callback = callback
	self._canTouchOutside = true

	-- 加载csb
	local csbNode = cc.CSLoader:createNode("dt/DialogNew.csb")
	self:addChild(csbNode)
	--按键监听
	local btcallback = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
         	self:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

    -- 遮罩
    local mask = csbNode:getChildByName("Panel_1")
    mask:setTag(QueryDialog.TAG_MASK)
    mask:addTouchEventListener( btcallback )

    
    -- 底板
    local spbg = csbNode:getChildByName("Node_1"):getChildByName("image_bottomBg")
    self.m_spBg = spbg
    
    if LuaUtils.isIphoneXDesignResolution() then
        mask:setContentSize(1624,750)
        spbg:setPositionX(spbg:getPositionX() + 145)
    end
    -- 确定
    local btn = spbg:getChildByName("Node_b1"):getChildByName("button_btn1")
    btn:setTag(QueryDialog.BT_CONFIRM)
    btn:addTouchEventListener(btcallback)
    btn:setPressedActionEnabled(true)
    self.m_btnSure = btn
    spbg:getChildByName("Node_b1"):getChildByName("button_btn1"):getChildByName("image_wzxx"):setVisible(false)
    -- 取消
    btn = spbg:getChildByName("Node_b2"):getChildByName("button_btn2")
    btn:setTag(QueryDialog.BT_CANCEL)
    btn:addTouchEventListener(btcallback)
    btn:setPressedActionEnabled(true)
    self.m_btnCancel = btn
    spbg:getChildByName("Node_b2"):getChildByName("button_btn2"):getChildByName("image_exit"):setVisible(false)
    -- 关闭
--    btn = spbg:getChildByName("Button_close")
--    btn:setTag(QueryDialog.BT_CANCEL)
--    btn:addTouchEventListener(btcallback)
--    btn:setPressedActionEnabled(true)

    if QueryDialog.QUERY_SURE == queryType then
    	self.m_btnSure:setPositionX(spbg:getContentSize().width * 0.5)
    	self.m_btnCancel:setEnabled(false)
    	self.m_btnCancel:setVisible(false)
    end

 	-- 内容
    local txtcontent = spbg:getChildByName("Image_2"):getChildByName("text_content")
 	txtcontent:setString(msg)
    txtcontent:setFontSize(txtsize)

	self._dismiss  = false
	spbg:stopAllActions()
	spbg:runAction(cc.ScaleTo:create(0.2, 1.0))
end

--按键点击
function QueryDialog:onButtonClickedEvent(tag,ref)
	if tag == QueryDialog.TAG_MASK then
		if not self._canTouchOutside then
			return
		end
	end
	if self._dismiss == true then
		return
	end
	--取消显示
	self:dismiss()
	--通知回调
	if self._callback then
		self._callback(tag == QueryDialog.BT_CONFIRM)
	end
end

--取消消失
function QueryDialog:dismiss()
	self._dismiss = true
	self.m_spBg:stopAllActions()
	self.m_spBg:runAction(
		cc.Sequence:create(
			cc.ScaleTo:create(0.1, 0.5),
			cc.CallFunc:create(function()
					self:removeSelf()
				end)
			))	
end

return QueryDialog
