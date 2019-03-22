-- region BombManager.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 炸弹特效管理单例

local module_pre = "game.yule.monkeyfish.src"
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

    if wBombType == BOMB_TYPE_JINGB then --金箍棒
        local armature = ccs.Armature:create("ruyijingubangwenzidonghua_buyu")
        armature:getAnimation():play("Animation1")
        local animationEvent = function (armatureBack,movementType,movementID)
            if moveMentType == ccs.MovementEventType.complete
            or moveMentType == ccs.MovementEventType.loopComplete
            then
                --self:removeArmature(armatureBack)
                armatureBack:removeFromParent()
            end
        end
        armature:getAnimation():setMovementEventCallFunc(animationEvent)
        armature:setPosition(_pos)
        armature:addTo(_delegate, 90)

        local function createBomb()
            for i = 0, math.floor(BOMB_ITEM_COUNT/2) do
                local bombItem = BombItem:create(_pos, BOMB_TYPE_JINGB)
                bombItem:setPosition(_pos)
                bombItem:addTo(_delegate,90)
            end
        end
        local call1 = cc.CallFunc:create(function()
            createBomb()
        end)
        local delay = cc.DelayTime:create(0.15)
        local call2 = cc.CallFunc:create(function()
            createBomb()
        end)
        local actionAll = cc.Sequence:create(call1, delay, call2)
        _delegate:runAction(actionAll)
        print("----------------------------金箍棒 (%ld)", os.time())

    elseif wBombType == BOMB_TYPE_FOZHANG then --万佛朝中

        --动画
        local armature = ccs.Armature:create("wanfochaozhongwenzidonghua_buyu")
        armature:getAnimation():play("Animation1")
        armature:setPosition(_pos)
        local animationEvent = function (armatureBack,movementType,movementID)
            if movementType == ccs.MovementEventType.complete then
                self:removeArmature(armatureBack)
            end
        end
        armature:getAnimation():setMovementEventCallFunc(animationEvent)
        armature:addTo(_delegate, 90+1) 

        --延时炸弹
        local function createBomb()
            for i = 0, math.floor(BOMB_ITEM_COUNT / 2) do
                local bombItem = BombItem:create(_pos, BOMB_TYPE_FOZHANG)
                bombItem:setPosition(_pos)
                bombItem:addTo(_delegate, 90)
            end
        end
        local delay1 = cc.DelayTime:create(0.15)
        local callb1 = cc.CallFunc:create(function() createBomb() end)
        local delay2 = cc.DelayTime:create(0.15)
        local callb2 = cc.CallFunc:create(function() createBomb() end)
        local delay3 = cc.DelayTime:create(0.15)
        local callb3 = cc.CallFunc:create(function() createBomb() end)
        local action = cc.Sequence:create(delay1, callb1, delay2, callb2, delay3, callb3)
        _delegate:runAction(action)
        --print("----------------------------万佛朝中 (%ld)", os.time())

    elseif wBombType == BOMB_TYPE_SPECIAL then

        --粒子
        local partical2 = cc.ParticleSystemQuad:create(FishRes.PARTICLE_OF_DAYUJISHA)
        if partical2 ~= nil then
            partical2:setPosition(_pos)
            partical2:addTo(_delegate,80)

            --延时炸弹
            local function createBomb()
                for i = 1, BOMB_ITEM_COUNT / 2 do
                    local bombItem = BombItem:create(_pos, BOMB_TYPE_SPECIAL)
                    bombItem:setPosition(_pos)
                    _delegate:addChild(bombItem, 80)
                end
            end
            local callb1 = cc.CallFunc:create(function()
                createBomb()
            end)
            local delay1 = cc.DelayTime:create(0.2)
            local callb2 = cc.CallFunc:create(function()
                createBomb()
            end)
            local delay2 = cc.DelayTime:create(3.0)
            local callb3 = cc.CallFunc:create(function()
                partical2:removeFromParent()
            end)
            _delegate:runAction(cc.Sequence:create(callb1, delay1, callb2, delay2, callb3))
            --print("----------------------------炸弹，特殊鱼", os.time())
        end
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
