-- region FishGoldManager.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 打中鱼后掉落金币UI管理类
local module_pre = "game.yule.lkby.src"
local FishDataMgr = require(module_pre..".views.manager.FishDataMgr")
local FishGold    = require(module_pre..".views.bean.FishGold")

local FishGoldManager = class("FishGoldManager", cc.Node)


FishGoldManager.POS = { 
    cc.p(0,    0),
    cc.p(80,   0),
    cc.p(160,  0),
    cc.p(240,  0),
    cc.p(320,  0),
    cc.p(400,  0),
    cc.p(0,   - 80),
    cc.p(80,  - 80),
    cc.p(160, - 80),
    cc.p(240, - 80),
    cc.p(320, - 80),
    cc.p(400, - 80),
}

function FishGoldManager:ctor()
    self.m_vecFishGold = {}
end  

function FishGoldManager:initFishGolds()

    --print("begin:%ld", os.time())
    for i = 1, MAX_FISH_GOLD_NUM do

        local item = FishGold.create()
        self:addChild(item)
        table.insert(self.m_vecFishGold, item)
    end
    --print("end:%ld", os.time())

    self.m_nMeChairID = FishDataMgr:getInstance():getMeChairID()
end 

function FishGoldManager:releaseFishGolds()
    for i = 1, MAX_FISH_GOLD_NUM do
        if self.m_vecFishGold[i] then 
            self.m_vecFishGold[i]:removeFromParent()
            self.m_vecFishGold[i] = nil
        end 
    end
    self.m_vecFishGold = {}
end

--function FishGoldManager:updateFishGold(dt)

--    for i = 1, MAX_FISH_GOLD_NUM do
--        if self.m_vecFishGold[i]:getStatus() ~= STATUS_UNUSE then
--            self.m_vecFishGold[i]:updateFishGold(dt)
--        end
--    end
--end 

--chairId 是 viewChairId
function FishGoldManager:setFishGoldEndByChairId(nChairId)

    for i = 1, MAX_FISH_GOLD_NUM do
        if self.m_vecFishGold[i]:getChairId() == nChairId then
            self.m_vecFishGold[i]:setChairId(nil)
            self.m_vecFishGold[i]:setAnimationEnd()
        end
    end
end

function FishGoldManager:getUnuseFishGold(count)

    local vecGold = {}

    --计算闲置的金币动画
    --local nAllCount = 0
    --for i = 1, MAX_FISH_GOLD_NUM do
    --    if self.m_vecFishGold[i]:getStatus() == STATUS_UNUSE then
    --        nAllCount = nAllCount + 1
    --    end
    --end
    --FloatMessage.getInstance():pushMessageDebug("gold unused :"..nAllCount)

    for i = 1, MAX_FISH_GOLD_NUM do
        if self.m_vecFishGold[i]:getStatus() == STATUS_UNUSE then
            self.m_vecFishGold[i]:initUsed()
            table.insert(vecGold, self.m_vecFishGold[i])
            if #vecGold == count then
                break
            end
        end
    end

   if #vecGold == 0 then 
        local item = FishGold.create()
        self:addChild(item)
        table.insert(self.m_vecFishGold, item)
        table.insert(vecGold, item)
    end
    return vecGold
end 

function FishGoldManager:createFishGold(node)

    local flyInfo = self:getGoldNumByKind(node)
    if node.deadIdx~=nil then
        --print("mmmmmmmmmmmmmmm: deadIdx: " .. node.deadIdx )
        if node.deadIdx > 15 and node.kind < FishKind.FISH_HUABANYU then   --优化效率，同时打死鱼超过15个，小鱼的金币只冒一个
           flyInfo.goldNum = 1
        end
    end

    local vecFishGold = self:getUnuseFishGold(flyInfo.goldNum)

    local startPos1 = node.startPos
    local goldNum = 6
    if flyInfo.goldNum < 6 then
        goldNum = flyInfo.goldNum
    end

    if (node.startPos.x + goldNum * 80) > display.width then
        startPos1.x = node.startPos.x -(node.startPos.x + goldNum * 80 - display.width)
    end
    if node.startPos.y + 100 > display.height then
        startPos1.y = display.height - 100
    end

    local len = table.nums(vecFishGold)
    for i = 1, len do
        local sound = 0
        if i == 1 then -- 金币入袋声音类型
            if flyInfo.goldType == FROGGOLD_TYPE_GOLD then
                sound = 2
            else
                sound = 1
            end
        end
        local startPos = cc.pAdd(cc.pAdd(startPos1 , cc.p(0, 40)) , self.POS[i])
        local item = vecFishGold[i]
        item:setGoldType(flyInfo.goldType)
        --item:showFishGold(startPos, node.desPos, i, sound, cc.p(0,0))
        item:showFishGold2(startPos, node.desPos, i, sound, cc.p(0,0), flyInfo.goldType)
        if i == 1 then 
             item:setGoldScore(node.score)
             item:setChairId(node.chairID)
        else --清空
            item:setGoldScore(0)
            item:setChairId(-1)
        end 
    end
end 

function FishGoldManager:pushDeadNode(node)

    self:createFishGold(node)
end 

function FishGoldManager:getGoldNumByKind(deadNode)

    local nBaseRandom = math.random(1, 2) - 1
    local mulriple = math.max(FishDataMgr:getInstance():getMulripleByIndex(deadNode.chairID), 1)
    local fishMulprile = deadNode.score / mulriple

    local _type = FROGGOLD_TYPE_GOLD
    if deadNode.chairID == self.m_nMeChairID then
        _type = FROGGOLD_TYPE_GOLD
    else
       
        _type = FROGGOLD_TYPE_SILVER
    end
    local ret = {
        goldType = _type,
        goldNum = 0,
    }

    if     fishMulprile <= 5    then ret.goldNum = nBaseRandom + 1
    elseif fishMulprile <= 10   then ret.goldNum = nBaseRandom + 2
    elseif fishMulprile <= 20   then ret.goldNum = nBaseRandom + 3
    elseif fishMulprile <= 50   then ret.goldNum = nBaseRandom + 4
    elseif fishMulprile <= 100  then ret.goldNum = nBaseRandom + 5
    else                             ret.goldNum = nBaseRandom + 6
    end
    return ret
end 


return FishGoldManager

-- endregion
