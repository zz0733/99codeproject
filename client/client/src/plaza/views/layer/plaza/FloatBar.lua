--FloatBar.lua
--浮动条
--Create by . 2017-06-30

local FloatBar = class("FloatBar", function ( ... )
	return cc.Node:create()
end)

function FloatBar:ctor(content, size)

    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    self.m_pathUI = cc.CSLoader:createNode("dt/FloatBar.csb")
    self.m_rootUI:addChild(self.m_pathUI)

    self.rootNode = self.m_pathUI:getChildByName("image_bar")
    self.content = self.rootNode:getChildByName("text_content")
    self.bar = self.rootNode
	if size then
		self.bar:setContentSize(size)
		self.content:setPosition(cc.p(size.width / 2, size.height / 2))
	end
	self.content:setString(content or "")
	if self.content:getContentSize().width >= 150 then
		self.bar:setContentSize(cc.size(self.content:getContentSize().width + 300, self.bar:getContentSize().height))
	end
	ccui.Helper:doLayout(self.bar)
	
	self.bar:getChildByName('Image_1_0'):setPositionY(self.bar:getContentSize().height - 2)

	local action = {
		cc.DelayTime:create(1),
		cc.Spawn:create(cc.MoveBy:create(0.5, cc.p(0, 100)), cc.FadeOut:create(0.5)),
		cc.RemoveSelf:create()
	}
	self:runAction(cc.Sequence:create(action))
end

return FloatBar