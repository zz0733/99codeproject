--
-- Author: zhong
-- Date: 2016-11-21 18:39:13
--
--设置界面
--local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")

local SettingLayer = class("SettingLayer", cc.Layer)

--function SettingLayer.create()
--	return SettingLayer.new()
--end
--构造
function SettingLayer:ctor( scene )
    self:enableNodeEvents()
    --加载csb资源
--    self.m_rootUI = display.newNode()
--    self.m_rootUI:addTo(self)
    
    self.m_pathUI = cc.CSLoader:createNode("game/lord/rulelayer.csb")
    local diffY   = (display.size.height - 750) / 2
    self.m_pathUI:setPositionY(diffY)
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pathUI:setPositionX(diffX)
    self.m_pathUI:addTo(self)

--    local csbNode = cc.CSLoader:createNode("game/baccarat/SettingLayer.csb")
--    self:addChild(scene)
    local touch_back = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.m_pathUI:setVisible(false)           
        end
    end
    local btn = self.m_pathUI:getChildByName("btn_mask")
    btn:addTouchEventListener(touch_back)

    local btn = self.m_pathUI:getChildByName("Sprite_1"):getChildByName("btn_colse")
    btn:addTouchEventListener(touch_back)
end


return SettingLayer