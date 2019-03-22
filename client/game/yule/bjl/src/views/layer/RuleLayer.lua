--
-- Author: zhong
-- Date: 2016-11-21 18:39:13
--
--设置界面
--local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")

local RuleLayer = class("RuleLayer", cc.Layer)

function RuleLayer.create()
	return RuleLayer.new()
end
--构造
function RuleLayer:ctor( scene )

    --加载csb资源
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
    
    self.m_pathUI = cc.CSLoader:createNode("game/baccarat/RuleLayer.csb")
    local diffY   = (display.size.height - 750) / 2
    self.m_pathUI:setPositionY(diffY)
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pathUI:setPositionX(diffX)
    self.m_pathUI:addTo(self.m_rootUI)

--    local csbNode = cc.CSLoader:createNode("game/baccarat/RuleLayer.csb")
--    self:addChild(scene)
    local touch_back = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.m_pathUI:setVisible(false)           
        end
    end
    local btn = self.m_pathUI:getChildByName("btn_mask")
    btn:addTouchEventListener(touch_back)

    local btn = self.m_pathUI:getChildByName("Sprite_1"):getChildByName("btn_close")
    btn:addTouchEventListener(touch_back)
end


return RuleLayer