-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成	

local RedVsBlackRes          = require("game.redvsblack.scene.RedVsBlackRes")
local SLFacade               = cc.exports.SLFacade
local Public_Events          = cc.exports.Public_Events

local RedVsBlackLoadingLayer = class("RedVsBlackLoadingLayer", require("common.layer.LoadingLayer"))

function RedVsBlackLoadingLayer.loading()
    return RedVsBlackLoadingLayer.new(true)
end

function RedVsBlackLoadingLayer.reload()
    return RedVsBlackLoadingLayer.new(false)
end

function RedVsBlackLoadingLayer:ctor(bBool)
    self:enableNodeEvents()
    self.bLoad = bBool
    self:initLoading()
    self:initLoadingWord(self)
end

function RedVsBlackLoadingLayer:initLoading()
    self.m_rootWidget = cc.CSLoader:createNode(RedVsBlackRes.CSB_GAME_LOADING)
    local diffY = (display.size.height - 750) / 2
    self.m_rootWidget:setPosition(cc.p(0, diffY))
    self.m_rootWidget:addTo(self)

    self.m_rootNode = self.m_rootWidget:getChildByName("Panel_1")
    local diffX = (1624-display.size.width)/2
    self.m_rootNode:setPositionX(-diffX)
end 

function RedVsBlackLoadingLayer:startLoading()

    --碎图/大图/动画/音效/音乐
    self:initPlistArray(RedVsBlackRes.vecLoadingPlist)
    self:initImageArray(RedVsBlackRes.vecLoadingImg)
    self:initEffectArray(RedVsBlackRes.vecLoadingAnim)
    self:initSoundArray(RedVsBlackRes.vecLoadingSound)
    self:initMusicArray(RedVsBlackRes.vecLoadingMusic)
    self:initOtherArray({})

    --进入加载
    self:executeLoading()
end

function RedVsBlackLoadingLayer:stopLoading()
    --进入游戏
    SLFacade:dispatchCustomEvent(Public_Events.MSG_GAME_LOAD_SUCCESS)
end

return RedVsBlackLoadingLayer
