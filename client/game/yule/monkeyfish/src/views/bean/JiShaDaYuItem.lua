-- region JiShaDaYuItem.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 击杀大鱼特效动画 node.

local module_pre = "game.yule.monkeyfish.src"
local FishRes     = require(module_pre..".views.scene.FishSceneRes")
local FishDataMgr = require(module_pre..".views.manager.FishDataMgr")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local JiShaDaYuItem = class("JiShaDaYuItem", cc.Node)

JiShaDaYuItem.m_nChairId = 0           --这个chairId  是 viewChairId

function JiShaDaYuItem:ctor()
    self.m_fishSoundID = 0
    self.m_nChairId = 0
end

function JiShaDaYuItem.create(_fishKind, _llScore, _nSeatIndex)

    local pJiShaDaYuItem = JiShaDaYuItem.new()
    pJiShaDaYuItem:init(_fishKind, _llScore, _nSeatIndex)
    return pJiShaDaYuItem
end 

function JiShaDaYuItem:getChairId()
    return self.m_nChairId
end

function JiShaDaYuItem:init(_fishKind, _llScore, _nSeatIndex)
    self.m_nChairId = _nSeatIndex

    --节点
    local node = display.newNode()
    node:setScale(0.5)
    node:addTo(self, 90 + 1)

    --文字
    local bBoss = (_fishKind == FishKind.FISH_SWK or _fishKind == FishKind.FISH_YUWANGDADI)
    local frame = bBoss and "#gui-fish-jsbs-bg.png" or "#gui-fish-jsdy-bg.png"
    local sp = display.newSprite(frame)
    sp:addTo(node)

    --得分
     local nMeChairID =FishDataMgr:getInstance():getMeChairID()
    local nViewChairID = FishDataMgr:getInstance():SwitchViewChairID(nMeChairID)
    local isMeSelf = nViewChairID == _nSeatIndex
    local strPath = isMeSelf and FishRes.FONT_OF_SUZI_NUMBER or FishRes.FONT_OF_SUZI_NUMBER_SILVER
    local strllScore = (_llScore) --string.format("%d.%02d", (_llScore/100), math.abs((_llScore)%100))
    local lb = cc.Label:createWithBMFont(strPath, strllScore)
    lb:setAnchorPoint(cc.p(0.5,0.5))
    lb:setPosition(cc.p(0, -10))
    lb:setScale(bBoss and 0.8 or 0.65)
    lb:addTo(node)

    --放大效果
    local actionNode = cc.EaseBackIn:create(cc.ScaleTo:create(0.3, 1.0))
    node:runAction(actionNode)

    --1.5秒后删除自己
    local delay = cc.DelayTime:create(1.5)
    local call = cc.CallFunc:create(function()
        self:removeSchedule()
    end)
    local actionSelf = cc.Sequence:create(delay, call)
    self:runAction(actionSelf)
    
    return true
end 

function JiShaDaYuItem:removeSchedule(dt)

    self:removeFromParent()
end 

function JiShaDaYuItem:removeArmature(armature)

    ExternalFun.stopGameEffect(self.m_fishSoundID)
    self.m_fishSoundID = 0
    if armature ~= nil then

        armature:removeFromParent()
        armature = nil
    end
    self:removeFromParent()
end 

return JiShaDaYuItem

-- endregion
