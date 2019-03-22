-- region LightningItem.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 闪电炮特效 node.


local LightningItem = class("LightningItem", cc.Node)

function LightningItem:ctor(startPos, vecDesPos)
    self.m_startPos = startPos
    self.m_vecDesPos = vecDesPos
end

function LightningItem:create(startPos, vecDesPos)

    local pLightning = LightningItem.new(startPos, vecDesPos)
    pLightning:init()
    return pLightning
end 

function LightningItem:init()

    -- 爆炸点动画
    local armature1 = ccs.Armature:create("shandianpao2_buyu")
    armature1:getAnimation():play("Animation2")
    armature1:setPosition(self.m_startPos)
    self:addChild(armature1, 40)

    print("闪电炮闪电个数:%d", #self.m_vecDesPos)
    local callback1 = cc.CallFunc:create(function()
        for i = 1, #self.m_vecDesPos do

            local desPos = self.m_vecDesPos[i]
            local distance = cc.pGetDistance(desPos, self.m_startPos)
            if distance < math.sqrt(1334 * 1334 + 750 * 750) then

                -- 设置方向
                local vec = cc.pSub(desPos, self.m_startPos)
                local angle = math.radian2angle(cc.pGetAngle(vec, cc.p(0, 1)))

                -- 连接线动画
                local armature2 = ccs.Armature:create("shandianpao1_buyu")
                armature2:getAnimation():play("Animation1")
                armature2:setAnchorPoint(cc.p(0, 0.5))
                armature2:setPosition(self.m_startPos)
                armature2:setRotation(angle + 270)
                armature2:setScaleX(0.1)
                self:addChild(armature2, 40 - 1)

                local scaleTo = cc.ScaleTo:create(0.3, distance / 500, 1)
                local fadeOut = cc.FadeOut:create(0.4)
                armature2:runAction(cc.Sequence:create(scaleTo, cc.DelayTime:create(0.3), fadeOut))
            end
        end
    end)

    local callback2 = cc.CallFunc:create(function()
        for i = 1, #self.m_vecDesPos do

            local desPos = self.m_vecDesPos[i]
            local distance = cc.pGetDistance(desPos, self.m_startPos)
            if distance < math.sqrt(1334 * 1334 + 750 * 750) then

                -- 爆炸点动画
                local armature3 = ccs.Armature:create("shandianpao3_buyu")
                armature3:getAnimation():play("Animation3")
                armature3:setPosition(desPos)
                self:addChild(armature3, 40)
            end
        end
    end)

    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), callback1, cc.DelayTime:create(0.3), callback2))

    local callFunc = cc.CallFunc:create( function()
        self:playEffectEnd(2)
    end)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(2.0), callFunc))

    return true
end

function LightningItem:playEffectEnd()

    self:stopAllActions()
    self:removeFromParent()
end 

return LightningItem

-- endregion
