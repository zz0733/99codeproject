-- region *.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 打中鱼后掉落的金币数 node
local module_pre = "game.yule.lkby.src"
local FishRes      = require(module_pre..".views.scene.FishSceneRes")
local DataCacheMgr = require(module_pre..".views.manager.DataCacheMgr")
local FishDataMgr  =   appdf.req(module_pre ..".views.manager.FishDataMgr")

local FishNumber = class("FishNumber", cc.Node)

function FishNumber:ctor()
    self.m_pLbNum = nil
    self.m_numberType = 1
    self.m_ContentSize = {}
end 

function FishNumber.create(paoView, iScore, nChairID)
    local numbertype = 1
    if nChairID ~=  FishDataMgr:getInstance():getMeChairID()then
        numbertype = 2
    end
    local pFishNumber = DataCacheMgr:getInstance():GetNumberFromFreePool(numbertype)
    if pFishNumber == nil then
        pFishNumber = FishNumber.new()
        pFishNumber.m_numberType = numbertype
        pFishNumber:addTo(paoView.m_pathUI, 100 + 11) --层级要比金币高
    end
    pFishNumber:init(iScore, nChairID) 
    pFishNumber:setVisible(true)
    return pFishNumber
end 

function FishNumber:getLabelContentSize()
     return self.m_ContentSize
end

function FishNumber:init(iScore, nChairID)
    local striScore = (iScore)

    if self.m_pLbNum == nil then
        local strPath = (nChairID == FishDataMgr:getInstance():getMeChairID()) and FishRes.FONT_OF_SUZI_NUMBER or  FishRes.FONT_OF_SUZI_NUMBER_SILVER
        self.m_pLbNum = cc.Label:createWithBMFont(strPath, "")
        self:addChild(self.m_pLbNum)
    end
    self.m_pLbNum:setString(striScore)
    self.m_ContentSize = 
    {
        width = self.m_pLbNum:getContentSize().width,
        height = self.m_pLbNum:getContentSize().height,
    }

    self.m_pLbNum:setScale(0.1)
    local hide = cc.Hide:create()
    local show = cc.Show:create()
    local scale = cc.EaseBackOut:create(cc.ScaleTo:create(0.3, 0.8))
    local fadeOut = cc.Spawn:create(cc.ScaleTo:create(0.2, 0.1),  cc.FadeOut:create(0.2))
    local callFunc = cc.CallFunc:create(function()
        self:removeSchedule(2.3)
    end)
    self.m_pLbNum:runAction(cc.Sequence:create(hide, cc.DelayTime:create(0.1), show, scale, cc.DelayTime:create(0.8), fadeOut, callFunc))
    return true
end 

function FishNumber:removeSchedule(dt)
    --self:removeFromParent()
   self.m_pLbNum:stopAllActions()
   DataCacheMgr:getInstance():AddNumberToFreePool( self, self.m_numberType )
   self.m_pLbNum:setOpacity(255)
   self:setVisible(false)
end 

return FishNumber

-- endregion
