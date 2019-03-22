-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成	

local WaterMarginLoadingLayer = class("WaterMarginLoadingLayer", require("common.layer.LoadingLayer"))

local SLFacade      = cc.exports.SLFacade
local Public_Events = cc.exports.Public_Events
local WaterRes      = require("game.watermargin.scene.WaterMarginSceneRes")

function WaterMarginLoadingLayer.loading()
    return WaterMarginLoadingLayer.new(true)
end

function WaterMarginLoadingLayer.reload()
    return WaterMarginLoadingLayer.new(false)
end

function WaterMarginLoadingLayer:ctor(bBool)
    self:enableNodeEvents()
    self.bLoad = bBool
    self:initLoading()
    self:initLoadingWord(self)
end

function WaterMarginLoadingLayer:initLoading()
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/watermargin/effect/tongyon_loding/tongyon_loding.ExportJson")
    self.m_rootWidget = cc.CSLoader:createNode("game/watermargin/WaterLoadingLayer.csb")
    local diffY = (display.size.height - 750) / 2
    self.m_rootWidget:setPosition(cc.p(0, diffY))
    self.m_rootWidget:addTo(self)

    self.m_rootNode = self.m_rootWidget:getChildByName("Panel_1")
    local diffX = (1624-display.size.width)/2
    self.m_rootNode:setPositionX(-diffX)
end

function WaterMarginLoadingLayer:startLoading()
    --碎图/大图/动画/音效/音乐
    self:initPlistArray(WaterRes.vecReleasePlist)
    self:initImageArray(WaterRes.vecReleaseImg)
    self:initEffectArray(WaterRes.vecReleaseAnim)
    self:initSoundArray(WaterRes.vecReleaseSound)
    self:initMusicArray(WaterRes.vecLoadingMusic)
    self:initOtherArray({})
    --self:initProgressBar(self)

    --进入加载
    self:executeLoading()
end

function WaterMarginLoadingLayer:stopLoading()
    --进入游戏
    SLFacade:dispatchCustomEvent(Public_Events.MSG_GAME_LOAD_SUCCESS)
end

return WaterMarginLoadingLayer
