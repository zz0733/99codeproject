-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成	

local Tiger_Res      = require("game.tiger.scene.Tiger_Res")
local SLFacade         = cc.exports.SLFacade
local Public_Events    = cc.exports.Public_Events

local TigerLoadingLayer = class("TigerLoadingLayer", require("common.layer.LoadingLayer"))

function TigerLoadingLayer.loading()
    return TigerLoadingLayer.new(true)
end

function TigerLoadingLayer.reload()
    return TigerLoadingLayer.new(false)
end

function TigerLoadingLayer:ctor(bBool)
    self:enableNodeEvents()
    self.bLoad = bBool
    self:initLoading()
    self:initLoadingWord(self)
end

function TigerLoadingLayer:initLoading()
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/tiger/effect/tongyon_loding/tongyon_loding.ExportJson")
    self.m_rootWidget = cc.CSLoader:createNode(Tiger_Res.CSB_OF_LOADING)
    local diffY = (display.size.height - 750) / 2
    self.m_rootWidget:setPosition(cc.p(0, diffY))
    self.m_rootWidget:addTo(self)

    self.m_rootNode = self.m_rootWidget:getChildByName("Panel_1")
    local diffX = (1624-display.size.width)/2
    self.m_rootNode:setPositionX(-diffX)
end 

function TigerLoadingLayer:startLoading()

    local pAniTable = {}
    for _,strArmName in pairs(Tiger_Res.vecAnim) do
        local strPath = string.format("%s%s/%s.ExportJson", Tiger_Res.strAnimPath, strArmName, strArmName)
        table.insert(pAniTable, strPath)
    end

    --碎图/大图/动画/音效/音乐
    self:initPlistArray(Tiger_Res.vecPlist)
    self:initImageArray(Tiger_Res.vecReleaseImg)
    self:initEffectArray(pAniTable)
    self:initSoundArray(Tiger_Res.vecSound)
    self:initMusicArray(Tiger_Res.vecMusic)

    --进入加载
    self:executeLoading()
end

function TigerLoadingLayer:stopLoading()
    --进入游戏
    SLFacade:dispatchCustomEvent(Public_Events.MSG_GAME_LOAD_SUCCESS)
end

return TigerLoadingLayer
