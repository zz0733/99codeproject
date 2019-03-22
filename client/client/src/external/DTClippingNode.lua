--DTClippingLight --流光效果

local DTClippingLight = class("DTClippingLight", function()
	local cn = cc.ClippingNode:create()
	cn:setAlphaThreshold(0.9)
	return cn
end)

local  function playAction( node , speet)
	-- body
	node:show()
	local actionPath = "dt/lightAction.csb"
	local act = cc.CSLoader:createTimeline(actionPath)
	act:play("ac_light",false)
	if speet then
		act:setTimeSpeed(speet)
	end
	node:runAction(act)
end 

function DTClippingLight:ctor(parent,newstencil)
	local widgetPath = "dt/lightAction.csb"
	self.widget = cc.CSLoader:createNode(widgetPath)
	self.widget:hide()
	self:addChild(self.widget)
	local path = newstencil or "dt/image/Dating/button_1.png"
	local btnSpr = display.newSprite(newstencil)
	self:setStencil(btnSpr)   
end

function DTClippingLight:stop( ... )
	-- body
	self.widget:hide()
	self.widget:stopAllActions()
end

function DTClippingLight:showAction( speet )
	-- body
	playAction(self.widget,speet)
end

return DTClippingLight

	


    -- 