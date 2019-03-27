--region *.lua
--Date
--
--endregion
local module_pre = "game.yule.lhdz.src."
local Lhdz_Res              = appdf.req(module_pre.."game.longhudazhan.scene.Lhdz_Res")
--local SettingLayer = class("SettingLayer", cc.Node)
local SettingLayer = class("SettingLayer", cc.Layer)

function SettingLayer.create()
    return SettingLayer:new()
end

function SettingLayer:ctor()
    self:enableNodeEvents()
    self:init()
    self:show()
end

function SettingLayer:init()

    self.m_pathUI = cc.CSLoader:createNode(Lhdz_Res.CSB_OF_SETTING)
    self.m_pathUI:setAnchorPoint(cc.p(0.5,0.5))
    self.m_pathUI:setPosition(cc.p(display.width/2,display.height/2))
    self.m_pathUI:addTo(self)
    self.m_pBg = self.m_pathUI:getChildByName("image_bg")

    self.m_pBtnClose = self.m_pBg:getChildByName("button_close")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))

    self:initView()
end

-- µØ≥ˆ
function SettingLayer:show()

    local pNode = self.m_pathUI
    if (pNode ~= nil)then
        pNode:stopAllActions()
        pNode:setScale(0.0)
        local show = cc.Show:create()
        local scaleTo = cc.ScaleTo:create(0.4, 1.0)
        local ease = cc.EaseBackOut:create(scaleTo)
        local callback = cc.CallFunc:create(function ()
            --self:callbackMove()
        end)
        local seq = cc.Sequence:create(show,ease,callback)
        pNode:runAction(seq)
    end
end

function SettingLayer:onEnter()
end

function SettingLayer:onExit()
end

function SettingLayer:onReturnClicked()
    self:removeFromParent()
end

function SettingLayer:initView()
    local music = self.m_pBg:getChildByName("slider_music")    --“Ù¿÷
    local a = GlobalUserItem.nMusic
    music:setPercent(a)
    music:addEventListener(function(ref,eventType)
                print(ref:getPercent())
                self:Slider_Music(ref:getPercent())
            end)
    local voice = self.m_pBg:getChildByName("slider_voice")    --“Ù–ß
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