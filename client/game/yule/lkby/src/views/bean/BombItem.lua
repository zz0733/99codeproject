-- region BombItem.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 炸弹特效 node.

local BombItem = class("BombItem", cc.Node)

function BombItem:ctor(fStartPos, wBombType, endPos)
    self.m_fStartPos = fStartPos
    self.m_fEndPos = endPos
    self.m_wItemType = wBombType

    self:init()
end

function BombItem:init()
    self.m_fSpeed = math.random(0, 1) + math.random(0, 2) + 1 + 0.5
    local amount = BOMB_ITEM_COUNT
    local m_fFuDu = M_PI * 2 / amount * (math.random(0, 50) + 1)
    local fRaiLong = 1600
    if self.m_wItemType == BOMB_TYPE_SPECIAL then
        self.m_fSpeed = 0.5 + math.random(0, 1)
        fRaiLong = 800.0
    end

    self.m_fEndPos = cc.p(math.cos(m_fFuDu) * fRaiLong, math.sin(m_fFuDu) * fRaiLong)
    -- 设置方向
    local vec = cc.pSub(self.m_fEndPos, self.m_fStartPos)
    local angle = math.radian2angle(cc.pGetAngle(vec, cc.p(0, 1)))

    if self.m_wItemType == BOMB_TYPE_JINGB then

        local sprite = display.newSprite("#bglu_gunturning_006.png")
        sprite:setRotation(angle + 5)
        sprite:addTo(self)

        local move = cc.MoveTo:create(self.m_fSpeed, self.m_fEndPos)
        sprite:runAction(move)

    elseif self.m_wItemType == BOMB_TYPE_FOZHANG then

        local a = ccs.Armature:create("yu26_buyu")
        a:getAnimation():play("Animation3")
        a:setPosition(self.m_fStartPos)
        a:addTo(self, 100)

        local sx = self.m_fStartPos.x
        local sy = self.m_fStartPos.y
        local ex = self.m_fEndPos.x
        local ey = self.m_fEndPos.y
        local h = math.random(400, 550)
        local bezier
        bezier.controlPoint_1 = cc.p(sx, sy)
        bezier.controlPoint_2 = (sx < ex)
            and cc.p(sx + (ex - sx) * 0.5, sy + (ey - sy) * 0.5 + h)
            or  cc.p(sx - (ex - sx) * 0.5, sy + (ey - sy) * 0.5 + h)
        bezier.endPosition = self.m_fEndPos

        local flyTime = math.random(4, 12) / 10.0
        local delayTime = math.random(1, 10) / 10.0
        local actionMove = cc.BezierTo:create(flyTime, bezier)
        local actionScale = cc.ScaleTo:create(flyTime, 2.0)
        local actionSpawn = cc.Spawn:create(actionMove, actionScale)
        local actionDelay = cc.DelayTime:create(delayTime)
        local actionAll = cc.Sequence:create(actionDelay, actionSpawn)
        a:runAction(actionAll)

        self.m_fSpeed = delayTime + flyTime

    elseif self.m_wItemType == BOMB_TYPE_SPECIAL then

        local sprite = display.newSprite("#gui-fish-lizi.png")
        sprite:addTo(self)

        local move = cc.MoveTo:create(self.m_fSpeed, self.m_fEndPos)
        local scale = cc.ScaleTo:create(self.m_fSpeed, 3)
        local spawn = cc.Spawn:create(move, scale)
        local fade = cc.FadeOut:create(0.2)
        local action = cc.Sequence:create(spawn, fade)
        sprite:runAction(action)

        self.m_fSpeed = self.m_fSpeed + 0.2
    end

    local delay = cc.DelayTime:create(self.m_fSpeed)
    local callFunc = cc.CallFunc:create(function()
        self:moveEnd(self.m_fSpeed)
    end)
    self:runAction(cc.Sequence:create(delay, callFunc))
end 

function BombItem:moveEnd(time)

    if self.m_wItemType == BOMB_TYPE_FOZHANG then

        local b = ccs.Armature:create("yu26_buyu")
        b:getAnimation():play("Animation4")
        self:addChild(b, 100)
        local function animationEvent(armature,moveMentType,moveMentId)
            if moveMentType == ccs.MovementEventType.complete  then 
                if moveMentId == "Animation4" then 
                    self:removeFromParent()
                end 
            end 
        end
        b:getAnimation():setMovementEventCallFunc(animationEvent)
        b:setPosition(self.m_fEndPos)
    else
        self:removeFromParent()
    end
end 

function BombItem:removeArmature(armature)

    self:removeFromParent()
end 

return BombItem

-- endregion
