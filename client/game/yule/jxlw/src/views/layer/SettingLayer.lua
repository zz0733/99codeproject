--
-- Author: zhong
-- Date: 2016-11-21 18:39:13
--
--设置界面
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")

local SettingLayer = class("SettingLayer",cc.Layer)

function SettingLayer:ctor()
   self:enableNodeEvents()
end

function SettingLayer:onEnter()
   self:init()
end

function SettingLayer:onExit()

end
--构造
function SettingLayer:init()
    --注册触摸事件
    ExternalFun.registerTouchEvent(this, true)
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
    --加载csb资源
    self.m_pathUI = cc.CSLoader:createNode("fruitSuper/Fruit_SetupNew.csb")
    self.m_pathUI:addTo(self.m_rootUI)

    self.center = self.m_pathUI:getChildByName("image_bg")
    self.center:setPositionX(display.width / 2)
    self.closebtn = self.center:getChildByName("button_close")
    self.music = self.center:getChildByName("slider_music")
	self.voice = self.center:getChildByName("slider_voice")
    self.closebtn:addClickEventListener(handler(self, self.onBack))
    self:initMyUI()

end

function SettingLayer:onBack()
    ExternalFun.playClickEffect()
    self:removeFromParent()
end

function SettingLayer:initMyUI()

	self.music:setPercent(GlobalUserItem.nMusic)
	self.voice:setPercent(GlobalUserItem.nSound)
	self.music:addEventListener(function(obj, eventType)
		if eventType == ccui.SliderEventType.percentChanged then
			self:onMusic(obj:getPercent())
		elseif eventType == ccui.SliderEventType.slideBallUp then
			self:onMusic(obj:getPercent())
		elseif eventType == ccui.SliderEventType.slideBallCancel then
			self:onMusic(obj:getPercent())
		end
	end)

	self.voice:addEventListener(function(obj, eventType)
		if eventType == ccui.SliderEventType.slideBallUp then
			self:onVoice(obj:getPercent())
		elseif eventType == ccui.SliderEventType.slideBallCancel then
			self:onVoice(obj:getPercent())
		end
	end)
end

--游戏音乐开关
function SettingLayer:onMusic(v)
	GlobalUserItem.setMusicVolume(v)
end
--游戏音效开关
function SettingLayer:onVoice(v)
	GlobalUserItem.setEffectsVolume(v) 
end

return SettingLayer