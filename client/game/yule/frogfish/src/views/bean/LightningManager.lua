-- region LightningManager.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 创建闪电炮时，修改捕鱼中大闹天宫，一箭双雕，一石三鸟的表现错误
local module_pre = "game.yule.frogfish.src"
local Fish            = require(module_pre..".views.bean.Fish")     
local LightningItem   = require(module_pre..".views.bean.LightningItem")
local FishDataMgr     = require(module_pre..".views.manager.FishDataMgr")

local LightningManager = class("LightningManager")

LightningManager._Instance = nil 
function LightningManager.getInstance()
    if LightningManager._Instance == nil then
        LightningManager._Instance = LightningManager:new()
    end
    return LightningManager._Instance
end 

-- 修改捕鱼中大闹天宫，一箭双雕，一石三鸟的表现错误
function LightningManager:createLighting(_delegate, _pos, _fishKind, tag_)

    local vecDesPos = {}
    for k, pFish in pairs(FishDataMgr:getInstance().m_vecFish) do
        if pFish and pFish:getTraceFinish() and not pFish:getDie() and not pFish:isOutScreen() then
            if _fishKind == FishKind.FISH_DNTG then
                if tag_ >= 10 then
                    return
                end
                if tag_ == pFish:getFishKind() then        
                    pFish:setStopDie()
                    table.insert(vecDesPos, cc.p(pFish:getPosition()))
                end
            elseif _fishKind == FishKind.FISH_PIECE then
                if tag_ >= 10 then
                    return
                end
                local fishkind1 = Fish.m_cbMixFishDateType3[tag_][1]
                local fishkind2 = Fish.m_cbMixFishDateType3[tag_][2]
                local fishkind3 = Fish.m_cbMixFishDateType3[tag_][3]
                local fishkind4 = Fish.m_cbMixFishDateType3[tag_][4]
                local fishkind5 = Fish.m_cbMixFishDateType3[tag_][5]
                if fishkind1 == pFish:getFishKind()
                or fishkind2 == pFish:getFishKind()
                or fishkind3 == pFish:getFishKind()
                or fishkind4 == pFish:getFishKind()
                or fishkind5 == pFish:getFishKind()
                then
                    pFish:setStopDie()
                    table.insert(vecDesPos, cc.p(pFish:getPosition()))
                end
            end
        end
    end
    local item = LightningItem:create(_pos, vecDesPos)
    _delegate:addChild(item, 90)
end 

return LightningManager

-- endregion
