--region *.lua
--Date
--
--endregion

--local SettingLayer = class("SettingLayer", cc.Node)
local SettingLayer = class("SettingLayer", cc.Layer)

function SettingLayer.create()
    return SettingLayer:new()
end

function SettingLayer:ctor()
    self:enableNodeEvents()
    self:init()
end

function SettingLayer:init()

    self.m_pathUI = cc.CSLoader:createNode("zhajinhua/ZhajhSetting.csb")
    self.m_pathUI:addTo(self)
    self.btn_mask = self.m_pathUI:getChildByName("Panel_1")
    self.m_pBg = self.m_pathUI:getChildByName("image_bg")

    self.m_pBtnClose = self.m_pBg:getChildByName("button_close")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))

    self:initView()
end 

function SettingLayer:onEnter()
end

function SettingLayer:onExit()
end

function SettingLayer:onReturnClicked()
    self:removeFromParent()
end

function SettingLayer:initView()
    local music = self.m_pBg:getChildByName("slider_music")    --����
    local a = GlobalUserItem.nMusic
    music:setPercent(a)
    music:addEventListener(function(ref,eventType)
                print(ref:getPercent())
                self:Slider_Music(ref:getPercent())
            end)
    local voice = self.m_pBg:getChildByName("slider_voice")    --��Ч
    local b = GlobalUserItem.nSound;
    voice:setPercent(b)
    voice:addEventListener(function(ref,eventType)
                print(ref:getPercent())
                self:Slider_Voice(ref:getPercent())
            end)

end 

function SettingLayer:Slider_Music(music)
    GlobalUserItem.setMusicVolume(music) 
end

function SettingLayer:Slider_Voice(voice)
    GlobalUserItem.setEffectsVolume(voice) 
end

return SettingLayer