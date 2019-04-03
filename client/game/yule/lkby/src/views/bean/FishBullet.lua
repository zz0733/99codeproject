-- region FishBullet.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 子弹类 node.
local module_pre = "game.yule.lkby.src"
local FishDataMgr  = require(module_pre..".views.manager.FishDataMgr")
local DataCacheMgr = require(module_pre..".views.manager.DataCacheMgr")

local LOCK_FISH_DISTANCE = 60

local FishBullet = class("FishBullet", cc.Node)


function FishBullet:ctor()
    self:enableNodeEvents()

    self.m_nBulletType = BulletKind.BULLET_KIND_1_NORMAL
    self.m_nBulletId = -1
    self.m_nBulletChaiId = INVALID_CHAIR
    self.m_nBulletTempId = 0

    self.m_nBulletScore = 0
    self.m_nFishID = -1

    self.m_pLockFish = nil 
    self.m_pBulletSprite = nil 
    self.m_nBeginPoint = cc.p(0, 0)
    self.m_fAngle = 0
    self.m_fSpeed = 0
    self.m_posLastPos = cc.p(0, 0)

    self.m_bMove = false
    self.m_fMoveStartTime = 0
    self.m_nEndPoint = cc.p(0, 0)
    self.m_fMoveTime = 0
    self.m_curposition = cc.p(0, 0)
    self.m_bulletTypeIndex = BulletKind.BULLET_KIND_1_NORMAL
end

function FishBullet:create(bulletId, bulletTempId, bulletKind, chairID, bulletScore, fish_id, pPaoView)
    local bulletTypeIndex = FishDataMgr:getInstance():getbulletKindByIndex(chairID)

    local pFishBullet = DataCacheMgr:getInstance():GetBulletFromFreePool(bulletTypeIndex)
    if pFishBullet == nil then
        pFishBullet = FishBullet.new()

        local spriteName = string.format("#game/lkfish/gui-fish-pao/fish-bullet_%d.png", bulletTypeIndex)
        pFishBullet.m_pBulletSprite = display.newSprite(spriteName)
        pFishBullet.m_pBulletSprite:setAnchorPoint(cc.p(0.5, 0.5))
        pFishBullet.m_pBulletSprite:setScale(0.9) --缩小到0.9倍
        pFishBullet:addChild(pFishBullet.m_pBulletSprite, 20)
        pPaoView.m_pathUI:addChild(pFishBullet, 20 + 5)
    end
    
    pFishBullet:setVisible(true)
	pFishBullet:init(bulletId, bulletTempId, bulletKind, chairID, bulletScore, fish_id, pPaoView)
	return pFishBullet
end
function FishBullet:SetUnuse()
   self:setVisible(false)
   DataCacheMgr:getInstance():AddBulletToFreePool( self, self.m_bulletTypeIndex )
   
   --self:setPosition(cc.p(-100, -100))
end
function FishBullet:init(bulletId, bulletTempId, bulletType, chairID, bulletScore, fish_id, pPaoView)
    self.m_pPaoView = pPaoView
    self.m_nBulletId = bulletId
    self.m_nBulletTempId = bulletTempId
    self.m_nBulletType = bulletType
    self.m_nBulletChaiId = chairID
    self.m_nFishID = fish_id
    self.m_pLockFish = FishDataMgr:getInstance():getFishByID(fish_id)

    local bulletTypeIndex = self:getBulletTypeIndex() - 1
    self.m_bulletTypeIndex = bulletTypeIndex
--    local spriteName = string.format("#gui-fish-bullet%d.png", bulletTypeIndex)
--    self.m_pBulletSprite = display.newSprite(spriteName)
--    self.m_pBulletSprite:setAnchorPoint(cc.p(0.5, 0.5))    
--    self.m_pBulletSprite:setScale(0.9) --缩小到0.9倍

    self.m_pBulletSprite:setPosition(cc.p(0, 0))
    self:setBulletScore(bulletScore)
--    self:addChild(self.m_pBulletSprite, 20)

    -- 上排的炮发的子弹要旋转180度
    local viewChiarID = FishDataMgr:getInstance():SwitchViewChairID(self.m_nBulletChaiId)
    if viewChiarID >= GAME_PLAYER_FISH / 2 then
        self:setRotation(180)
    end
    --self.updateFishAndCollision = scheduler.scheduleGlobal( handler(self, self.checkBulletPos),0.1)
    --scheduler.scheduleGlobal(handler(self, self.checkBulletPos), 0.1)
end 

function FishBullet:onExit()
    self:stopAllActions()     
end

function FishBullet:refresh( curTime )
    if self.m_bMove then
        if curTime > self.m_fMoveStartTime + self.m_fMoveTime then
        --这一次位移到达终点
            self:setPosition( self.m_nEndPoint )
            self.m_curposition.x = self.m_nEndPoint.x
            self.m_curposition.y = self.m_nEndPoint.y
              if self.m_nFishID >= 0 and self.m_pLockFish~=nil then
                self:callback2()
            else
                self:callback()
            end            
            return true
        end
        local timePer = (curTime - self.m_fMoveStartTime) / self.m_fMoveTime 
        local x = self.m_nBeginPoint.x * (1.0-timePer) + self.m_nEndPoint.x * timePer
        local y = self.m_nBeginPoint.y * (1.0-timePer) + self.m_nEndPoint.y * timePer 

        self:setPosition( x, y )
        self.m_curposition.x = x
        self.m_curposition.y = y
    end

    return true
end

function FishBullet:flyTo(beginpos, endpos, angle, speed)

--    self.m_nBeginPoint = beginpos
--    self.m_fAngle = angle
    self.m_fSpeed = speed

    local distance = math.abs(cc.pGetDistance(beginpos, endpos))
    if self.m_nFishID >= 0 and self.m_pLockFish then

        if distance > LOCK_FISH_DISTANCE then

            angle = math.radian2angle(angle)
            -- 修正角度
            if angle < 0 then

                angle = angle + 360
            elseif angle > 360 then

                angle = angle - 360
            end            
            endpos = FishDataMgr:getInstance():getTargetPositionByAngle(beginpos, angle, LOCK_FISH_DISTANCE)
            distance = LOCK_FISH_DISTANCE
            angle = math.angle2radian(angle)
        end
        self:NewMoveTo(beginpos, endpos, angle, distance, true)
    else                                                                 

        self:NewMoveTo(beginpos, endpos, angle, distance, false)
    end
  --  print("---------moveto: x: " .. endpos.x .. "  y: " .. endpos.y )
end 

function FishBullet:NewMoveTo(beginpos, endpos, angle, distance, isLock)
    if distance <= 0 then 
        --self:callback2()
--        if self.m_pPaoView ~= nil then 
--              self.m_pPaoView:deleteNotMoveBullet(self)
--        end 
          return 
    end 

    --if angle > self.m_fAngle + 0.2 or angle < self.m_fAngle - 0.2  then
    -- 旋转
        self:setRotation(math.radian2angle(angle))
   -- end
--   if isLock then
--      print("---------setRotation: angle: " .. angle )
--   end
    -- 移动
    local ftime = 0
    if self.m_fSpeed > 1 then
        ftime = distance / self.m_fSpeed
    else
        ftime = distance / 1
    end

    self.m_bMove = true
    self.m_nBeginPoint = beginpos
    self.m_nEndPoint = endpos
    self.m_fAngle = angle
    self.m_fMoveStartTime = cc.exports.gettime() 
    self.m_fMoveTime = ftime
end 

function FishBullet:callback()

    local angle = FishDataMgr:getInstance():getTanSheAngle(self.m_nEndPoint, self.m_fAngle)
    -- 获得目标点
    local x = 0
    local y = 0
    x,y = FishDataMgr:getInstance():GetTargetPoint2(self.m_nEndPoint.x, self.m_nEndPoint.y, angle, x, y)
    local distance = math.abs(cc.pGetDistance(self.m_nEndPoint, cc.p(x, y)))
    self:NewMoveTo(self.m_nEndPoint, cc.p(x, y), angle, distance, false)
end 

function FishBullet:callback2()

    self.m_pLockFish = FishDataMgr:getInstance():getFishByID(self.m_nFishID)
    if self.m_nFishID >= 0 and self.m_pLockFish ~= nil then

        --local targetX, targetY = self.m_pLockFish:getPosition()
        local target = cc.p(self.m_pLockFish.lastposX,self.m_pLockFish.lastposY )
        local vec = cc.pSub(target, self.m_nEndPoint)
        local angle = math.radian2angle(cc.pGetAngle(vec, cc.p(0, 1)))
        -- 修正角度
        if angle < 0 then

            angle = angle + 360

        elseif angle > 360 then

            angle = angle - 360
        end        
        local distance = math.abs(cc.pGetDistance(self.m_nEndPoint, target))
        if distance > LOCK_FISH_DISTANCE then

            target = FishDataMgr:getInstance():getTargetPositionByAngle(self.m_nEndPoint, angle, LOCK_FISH_DISTANCE)
            distance = LOCK_FISH_DISTANCE
        end
        angle = math.angle2radian(angle)
        self:NewMoveTo(self.m_nEndPoint, target, angle, distance, true)
    else

        -- 获得目标点
        local x = 0
        local y = 0
        x,y = FishDataMgr:getInstance():GetTargetPoint2(self.m_nEndPoint.x, self.m_nEndPoint.y, self.m_fAngle, x, y)
        local distance = math.abs(cc.pGetDistance(self.m_nEndPoint, cc.p(x, y)))
        self:NewMoveTo(self.m_nEndPoint, cc.p(x, y), self.m_fAngle, distance, false)
    end
end 

function FishBullet:getBulletSprite()
    return self.m_pBulletSprite
end 

function FishBullet:getBulletTypeIndex()
    --print("FishBullet:getBulletTypeIndex")
    --print("self.m_nBulletChaiId:",self.m_nBulletChaiId)
    return FishDataMgr:getInstance():getbulletKindByIndex(self.m_nBulletChaiId) + 1
end 

function FishBullet:setBulletId(nBulletId)
    self.m_nBulletId = nBulletId
end

function FishBullet:getBulletId()
      return self.m_nBulletId
end

function FishBullet:setBulletTempId(nBulletTempId)
    self.m_nBulletTempId = nBulletTempId
end

function FishBullet:getBulletTempId()
      return self.m_nBulletTempId
end

function FishBullet:setBulletType(nBulletType)
    self.m_nBulletType = nBulletType
end

function FishBullet:getBulletType()
      return self.m_nBulletType
end

function FishBullet:setBulletScore(nBulletScore)
    self.m_nBulletScore = nBulletScore
end

function FishBullet:getBulletScore()
      return self.m_nBulletScore
end

function FishBullet:setBulletChaiId(nBulletChaiId)
    self.m_nBulletChaiId = nBulletChaiId
end

function FishBullet:getBulletChaiId()
      return self.m_nBulletChaiId
end

function FishBullet:setFishID(nFishID)
    self.m_nFishID = nFishID
end

function FishBullet:getFishID()
      return self.m_nFishID
end


return FishBullet

-- endregion
