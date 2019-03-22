-- region BombManager.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 炸弹特效管理单例

local module_pre = "game.yule.lkby.src"
local BombItem = appdf.req(module_pre..".views.bean.BombItem")
local FishRes  = appdf.req(module_pre..".views.scene.FishSceneRes")

local BombManager = class("BombManager", cc.Node)

BombManager.instance_ = nil
function BombManager.getInstance()
    if BombManager.instance_ == nil then
        BombManager.instance_ = BombManager:new()
    end
    return BombManager.instance_
end 

function BombManager:createBombWithType(_delegate, _pos, wBombType)

    if wBombType == BOMB_TYPE_FOZHANG then

        local startPos = cc.p(667 + math.random(-30, 30), 500 + math.random(0, 30))
        local endPos = { cc.p(1000, 200), cc.p(1080, 450), cc.p(300, 150), cc.p(300, 450), }
        local rang = { { 450, 300 }, { 400, 280 }, { 500, 280 }, { 300, 300 } }
        for i = 1, BOMB_ITEM_COUNT / 2 do
            local index = i % 4
            local off = {}
            off.x = math.random(- math.floor(rang[index][1] / 2), math.floor(rang[index][1] / 2))
            off.y = math.random(- math.floor(rang[index][2] / 2), math.floor(rang[index][2] / 2))
            local pos = cc.pAdd(endPos[index], off)
            local bombItem = BombItem:create(startPos, BOMB_TYPE_FOZHANG, pos)
            _delegate:addChild(bombItem, 100 - 1)
        end

    elseif wBombType == BOMB_TYPE_SPECIAL then

        --粒子
        local partical2 = cc.ParticleSystemQuad:create(FishRes.PARTICLE_OF_DAYUJISHA)
        partical2:setPosition(_pos)
        partical2:addTo(_delegate, 80)

        --炸弹
        for i = 1, BOMB_ITEM_COUNT / 2 do
            local bombItem = BombItem:create(_pos, BOMB_TYPE_SPECIAL)
            bombItem:setPosition(_pos)
            _delegate:addChild(bombItem, 80)
        end

        --延时炸弹
        local delay1 = cc.DelayTime:create(0.2)
        local callback1 = cc.CallFunc:create( function()
            for i = 1, BOMB_ITEM_COUNT / 2 do
                local bombItem = BombItem:create(_pos, BOMB_TYPE_SPECIAL)
                bombItem:setPosition(_pos)
                _delegate:addChild(bombItem, 80)
            end
        end)
        local delay2 = cc.DelayTime:create(3.0)
        local callback2 = cc.CallFunc:create(function()
            partical2:removeFromParent()
        end)
        _delegate:runAction(cc.Sequence:create(delay1, callback1, delay2, callback2))
        print("----------------------------炸弹，特殊鱼", os.time())
    end
end 

function BombManager:removeArmature(armature, type, name)

    if armature ~= nil then
        armature:removeFromParent()
        armature = nil
    end
end 

return BombManager

-- endregion
