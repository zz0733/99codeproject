-- region *.lua
-- Date 2017.04.10
-- 此文件由[BabeLua]插件自动生成
local module_pre = "game.yule.monkeyfish.src.views."
local FishEvent = require(module_pre.."scene.FishEvent")
local MathAide  = require(module_pre.."manager.MathAide")
local cmd = appdf.req("game.yule.monkeyfish.src" .. ".models.CMD_Game")

local FishDataMgr = class("FishDataMgr")

-- 创建实例接口
FishDataMgr.instance_ = nil
 function FishDataMgr.getInstance()
    if FishDataMgr.instance_ == nil then
        FishDataMgr.instance_ = FishDataMgr:new()
    end
    return FishDataMgr.instance_
end

function FishDataMgr.releaseInstance()
    FishDataMgr.getInstance():Clear()
    FishDataMgr.instance_ = nil
end

function FishDataMgr:ctor()
    self:Clear()
end

function FishDataMgr:Clear()
    self.m_tablePlayer = {}
    self.m_queueFire = {}
    self.m_queueFish = {}
    self.m_queueFishTeam = {}
    self.m_vecFish = {} 
    self.m_vecLastScene = {} 

    self.m_nUserEnterScore = 0
    --self.scene_bgindex_ = 0
    self.special_sceene_waited_time = 1
    self.isMaster = true
    self.exit_game_ = false
    self.game_ready_ = false
    self.game_active_ = false
    self.since_last_frame_ = 0
    self.current_shake_frame_ = 0
    self.shake_screen_ = false
    self.exchange_ratio_userscore_ = 0
    self.exchange_ratio_fishscore_ = 0
    self.exchange_count_ = 0
    self.min_bullet_multiple_ = 0
    self.max_bullet_multiple_ = 0
    self.bomb_range_width_ = 0
    self.bomb_range_height_ = 0
    self.lock_ = false
    self:setLastLockFish(0)
    --self:setSceneBGIndex(1)
    self.m_bAllStop = false
    self.m_nFoShouId = 0
    self.m_nLianDanLuId = 0
    self.m_nShanDianYuId = 0
    self.m_bIsNetworkFail = false
    self.switch_scene = nil 
    self.m_fUpdateFishTime = cc.exports.gettime()

    --鱼数据
    self.fish_multiple_ = {}
    self.fish_speed_ = {}
    self.fish_bounding_box_width_ = {}
    self.fish_bounding_box_height_ = {}
    self.fish_hit_radius_ = {}
    for i = 1, FishKind.FISH_KIND_COUNT do
        self.fish_multiple_[i] = 0
        self.fish_speed_[i] = 0
        self.fish_bounding_box_width_[i] = 0
        self.fish_bounding_box_height_[i] = 0
        self.fish_hit_radius_[i] = 0
    end

    --子弹数据
    self.bullet_speed_ = {}
    self.bullet_bounding_radius = {}
    for i = 1, #BulletKind do
        self.bullet_speed_[i] = 0
        self.bullet_bounding_radius[i] = 0
    end
    self.current_bullet_kind_ = BulletKind.BULLET_KIND_1_NORMAL
    self.current_bullet_mulriple_ = 0
    self.allow_fire_ = true
    self.lock_ = false
    self.m_nLastLockFish = -1
    self.m_bCreateDeskScene = false

    --玩家数据
    self._llUserScore = {}
    self._bkUserKind = {}
    self._current_mulriple_ = {}
    self._current_lock_fish = {}
    self._current_lock_fish_time = {}
    for i = 1, GAME_PLAYER_FISH do
        self._llUserScore[i] = 0
        self._bkUserKind[i] = BulletKind.BULLET_KIND_1_NORMAL
        self._current_mulriple_[i] = 0
        self._current_lock_fish[i] = -1
        self._current_lock_fish_time[i] = 0
    end
    self.m_fUpdateFishTime = cc.exports.gettime()
    self.m_fUpdateFPSTime = 0
    self.m_fFPSNumber = 0
    
    self.m_bCheckDistributeFish = false    --检测普通鱼的生成标记，鱼阵的鱼不检测， 如果10秒没有收到创建鱼的包，就判断为网络极差，断网退出
    self.m_fCheckDistributeTime = self.m_fUpdateFishTime --检测普通鱼的生成时间    
    self.m_bShowShadow = true   -- 设置影子是否显示
    if cc.UserDefault:getInstance():getIntegerForKey("fish_shadow", 0) == 1 then
        self.m_bShowShadow = false
    end
end 

function FishDataMgr:processGameScene(gamestatus)

    self:ClearAllData()
    self:setSpecialSceneWaitTime(gamestatus.special_sceene_waited_time)

    self.exchange_ratio_userscore_ = gamestatus.game_config.exchange_ratio_userscore
    self.exchange_ratio_fishscore_ = gamestatus.game_config.exchange_ratio_fishscore

    self.min_bullet_multiple_ = gamestatus.game_config.min_bullet_multiple
    self.max_bullet_multiple_ = gamestatus.game_config.max_bullet_multiple

    self.current_bullet_mulriple_ = self.min_bullet_multiple_

    local nBase = self:getBaseScore()

    if self.min_bullet_multiple_ < FISH_PAO_SCORE_1 * nBase then
        self.current_bullet_kind_ = BulletKind.BULLET_KIND_1_NORMAL
    else
        self.current_bullet_kind_ = BulletKind.BULLET_KIND_2_NORMAL
    end

    for i = 1, GAME_PLAYER_FISH do
        --print("reset ==================================")
        self._bkUserKind[i] = self.current_bullet_kind_
        self._current_mulriple_[i] = self.min_bullet_multiple_
    end

    for i = 1, FishKind.FISH_KIND_COUNT do     

        self.fish_speed_[i] = gamestatus.game_config.fish_speed[i]
        self.fish_bounding_box_width_[i] = gamestatus.game_config.fish_bounding_radius[i]
        self.fish_bounding_box_height_[i] = gamestatus.game_config.fish_bounding_count[i]
    end

    for i = 1, BulletKind.BULLET_KIND_COUNT do

        self.bullet_speed_[i] = gamestatus.game_config.bullet_speed[i]
        self.bullet_bounding_radius[i] = gamestatus.game_config.bullet_bounding_radius[i]
    end

    --SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_PAOREFRESH, nil)
end 

--玩家登录房间的时候 从userenter消息中取到用户的金币数量 包括体验房的虚拟金币数量，gameprocess命令中 只设置同一个桌子
--上的其他三名玩家的金币数量，用户自己进入捕鱼场景的时候，自己的金币数量从usreenter消息中获取
function FishDataMgr:userEnterSetPlayerScore(selfEnterRoomScore)
    self.m_nUserEnterScore    =   selfEnterRoomScore
    PlayerInfo:getInstance():setUserScore(self.m_nUserEnterScore)
end

function FishDataMgr:isSwitchGameScene()
    return false
end 

function FishDataMgr:sendExchangeFishScore( value)
    if value == -2 then 

        local wb = WWBuffer:create()
        wb:writeLongLong(value)
        cc.exports.CMsgGame:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_EXCHANGE_FISHSCORE, wb)
        --CMsgFish.getInstance():sendExchangeFishScore(value)

        local chairID = FishDataMgr:getInstance():getMeChairID()
        local score = FishDataMgr:getInstance():getUserScore()
        self:exchangeFishScore(chairID,  score)

        SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_ADD_PLAYER, chairID)

    else
        local wb = WWBuffer:create()
        wb:writeLongLong(value)
        cc.exports.CMsgGame:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_EXCHANGE_FISHSCORE, wb)
        --CMsgFish.getInstance():sendExchangeFishScore(value)

        local chairID = FishDataMgr:getInstance():getMeChairID()
        local score = FishDataMgr:getInstance():getUserScore()
        self:exchangeFishScore(chairID,  score)
    end  
end 

function FishDataMgr:getSizeOfQueueFish()
    local nFishNum = table.nums(self.m_queueFish)
    return nFishNum
end 

function FishDataMgr:popQueueFish()

    local ret = nil 

    if self.m_queueFish[1] ~= nil then

        ret = self.m_queueFish[1]
        table.remove(self.m_queueFish, 1)
    end
    return ret
end 

function FishDataMgr:getSizeofQueueFishTeam()

    return table.nums(self.m_queueFishTeam)
end 

function FishDataMgr:popQueueFishTeam()

    local ret = nil 
    if table.nums(self.m_queueFishTeam) > 0 then

        ret = self.m_queueFishTeam[1]
        table.remove(self.m_queueFishTeam, 1)
    end
    return ret
end 

function FishDataMgr:getSizeOfQueueFire()

    return table.nums(self.m_queueFire)
end

function FishDataMgr:popQueueFire()

    local ret = nil 
    if self.m_queueFire[1] ~= nil then

        ret = self.m_queueFire[1]
        table.remove(self.m_queueFire, 1)
    end
    return ret
end 

function FishDataMgr:getFishSpeed(monkeyfishKind)

    local ret = 3
    if monkeyfishKind <= FishKind.FISH_KIND_COUNT then

        ret = self.fish_speed_[monkeyfishKind+1]
    end
    return ret
end 

function FishDataMgr:getFishBoxWidth(monkeyfishKind)

    
    --local ret = 12

    if monkeyfishKind <= FishKind.FISH_KIND_COUNT then

        return self.fish_bounding_box_width_[monkeyfishKind+1]
    else 
        return 12
    end
--    if ret < 12 then
--        return 12
--    else
--        return ret
--    end
end 

function FishDataMgr:getFishBoxheight(monkeyfishKind)

--    local ret = 12
--    if monkeyfishKind == nil then 
--          return ret
--    end 
    if monkeyfishKind <= FishKind.FISH_KIND_COUNT then

        return self.fish_bounding_box_height_[monkeyfishKind+1]
    else
        return 12
    end
--    if ret < 12 then
--        return 12
--    else
--        return ret
--    end
end 

function FishDataMgr:getFishRadius(monkeyfishKind)

    local ret = 10
    if monkeyfishKind <= FishKind.FISH_KIND_COUNT then

        ret = self.fish_hit_radius_[monkeyfishKind+1]
    end
    return ret
end 

function FishDataMgr:getFishMultiple(monkeyfishKind)

    local ret = 10
    if monkeyfishKind <= FishKind.FISH_KIND_COUNT then

        ret = self.fish_multiple_[monkeyfishKind+1]
    end
    return ret
end

function FishDataMgr:addExchangeFishScore(usChairID, llFishScore)

    if usChairID < GAME_PLAYER_FISH then

        self._llUserScore[usChairID + 1] = self._llUserScore[usChairID + 1] + llFishScore

        local _event = {
            name = FishEvent.MSG_FISH_SCORE,
            chairId = usChairID,
        }
        SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_SCORE, _event)

        if usChairID == FishDataMgr:getInstance():getMeChairID() then
            PlayerInfo:getInstance():setUserScore(self._llUserScore[usChairID + 1])
        end
    end
end 

function FishDataMgr:exchangeFishScore(usChairID, llFishScore)

    --    CCLOG("==usChairID=%d   llFishScore=%lld=====",usChairID, llFishScore)
    if llFishScore < 0 or usChairID == INVALID_CHAIR then

        return
    end

    if usChairID < GAME_PLAYER_FISH then

        self._llUserScore[usChairID+1] = llFishScore
        local _event = {
            name = FishEvent.MSG_FISH_SCORE,
            chairId = usChairID,
        }
        SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_SCORE, _event)
    end
    if usChairID == FishDataMgr:getInstance():getMeChairID() then

        --PlayerInfo:getInstance():setUserScore(self._llUserScore[usChairID+1])
    end
end                  

function FishDataMgr:exchangeAddFishScore(usChairID,llFishScore)
    if llFishScore < 0 or usChairID == INVALID_CHAIR then
        return
    end

    if usChairID < GAME_PLAYER_FISH then

        self._llUserScore[usChairID+1] = self._llUserScore[usChairID+1] + llFishScore
        local _event = {
            name = FishEvent.MSG_FISH_SCORE,
            chairId = usChairID,
            nScore = llFishScore,
        }
        SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_SCORE_PLUS, _event)
    end
    if usChairID == FishDataMgr:getInstance():getMeChairID() then

        --PlayerInfo:getInstance():setUserScore(self._llUserScore[usChairID+1])
    end
end

function FishDataMgr:getUserFire(pUserFire)

    if pUserFire == nil then

        return
    end

    table.insert(self.m_queueFire, pUserFire)

    SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_FIRE, nil)
end 

function FishDataMgr:getCatchFishGroup(pCatchFish)

    local i = 1

    while (i <= pCatchFish.fish_count) do
        if pCatchFish.catch_fish[i] then
            for k,v in pairs(self.m_queueFish) do
                if self.m_queueFish[k].fish_id == pCatchFish.catch_fish[i].fish_id then
                    print("=========杀死一个未创建的鱼==========")
                    self.m_queueFish[k].isAlive = false
                end
            end

            if pCatchFish.catch_fish[i].bullet_double then

                local bulletKind = self:getbulletKindByIndex(pCatchFish.chair_id)
                if bulletKind < BulletKind.BULLET_KIND_1_ION then
                    --local kind = BulletKind[bulletKind + 3]
                    --local kind = getBulletKindByIndex(bulletKind + 3+1)
                    -- add by nick
                    local kind = BulletKind[bulletKind+3+1]
                    self:setBulletKindByIndex(pCatchFish.chair_id, kind)
                end
                -- 触发了buff
                local _event = {
                    name = FishEvent.MSG_FISH_ADD_BUFF,
                    chairId = pCatchFish.chair_id,
                }
                SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_ADD_BUFF, _event)
            end

            --local allFishScore = self:getFishScoreByIndex(pCatchFish.chair_id) 
    --        local chairID = pCatchFish.chair_id
    --        local score = pCatchFish.catch_fish[i].fish_score
    --        FishDataMgr:getInstance():exchangeAddFishScore(chairID, score)

            -- 找到杀死的鱼
            local fish = FishDataMgr:getInstance():getFishByID(pCatchFish.catch_fish[i].fish_id)

            if fish == nil then 
            
            else

                if pCatchFish.catch_fish[i].fish_kind == FishKind.FISH_FOSHOU then

                    self.m_nFoShouId = pCatchFish.catch_fish[i].fish_id

                elseif pCatchFish.catch_fish[i].fish_kind == FishKind.FISH_BGLU then

                    self.m_nLianDanLuId = pCatchFish.catch_fish[i].fish_id

                elseif pCatchFish.catch_fish[i].fish_kind == FishKind.FISH_DNTG
                or pCatchFish.catch_fish[i].fish_kind == FishKind.FISH_PIECE then
                    self.m_nShanDianYuId = pCatchFish.catch_fish[i].fish_id
                else

                    if (pCatchFish.catch_fish[i].link_fish_id == self.m_nFoShouId and self.m_nFoShouId ~= 0)
                    or (pCatchFish.catch_fish[i].link_fish_id == self.m_nLianDanLuId and self.m_nLianDanLuId ~= 0)
                    or (pCatchFish.catch_fish[i].link_fish_id == self.m_nShanDianYuId and self.m_nShanDianYuId ~= 0)
                    then
                        fish:setPlayEffect(false)
                    end
                end

                local _event = {
                    name = FishEvent.MSG_FISH_CATCH_SUC,
                    fishId = pCatchFish.catch_fish[i].fish_id,
                    chairId = pCatchFish.chair_id,
                    score = pCatchFish.catch_fish[i].fish_score,
                    deadIndex = pCatchFish.catch_fish[i].dead_index,  --鱼的死亡索引
                }
                SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_CATCH_SUC, _event)
            end
        end
        i = i + 1
    end
end 

function FishDataMgr:onCatchFishChain(pCatchChain)

    local pFish = nil

    -- 更新玩家的分数
    --local allFishScore = self:getFishScoreByIndex(pCatchChain.chair_id)
    local llScore = 0
    for i = 1, pCatchChain.fish_count do

        llScore = llScore + pCatchChain.catch_fish[i].fish_score
    end
    --打死鱼直接加分
    FishDataMgr:getInstance():exchangeAddFishScore(pCatchChain.chair_id, llScore)

    local i = 1
    while (i <= pCatchChain.fish_count and i <= kMaxChainFishCount) do
        for k,v in pairs(self.m_queueFish) do
            if self.m_queueFish[k].fish_id == pCatchChain.catch_fish[i].fish_id then
                print("=========杀死一个未创建的鱼 泡泡鱼==========")
                self.m_queueFish[k].isAlive = false
            end
        end


        if i == 1 then
            pFish = self:getFishByID(pCatchChain.catch_fish[1].fish_id)
            if pFish == nil then return end
        else
            pFish.m_arrShanDianFish[i - 1] = pCatchChain.catch_fish[i].fish_kind
            self:delFish(pCatchChain.catch_fish[i].fish_id)
        end
        i = i + 1
    end

    local _event = {
        name = FishEvent.MSG_FISH_CATCH_SUC,
        fishId = pCatchChain.catch_fish[1].fish_id,
        chairId = pCatchChain.chair_id,
        score = llScore,
        deadIndex = 1, --鱼的死亡索引
    }
    SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_CATCH_SUC, _event)
end 

function FishDataMgr:onDistributeFishTeam(pCMD_DistributeFishTeam)

    local curTime = cc.exports.gettime()
    for i = 1, pCMD_DistributeFishTeam.fish_count do

        local info = {}
        info.fish_team_type = pCMD_DistributeFishTeam.fish_team_type
        info.fish_id = pCMD_DistributeFishTeam.fish_id[i]
        info.fish_kind = pCMD_DistributeFishTeam.fish_kind[i]
        info.path_index = pCMD_DistributeFishTeam.path_index
        info.yOffset = pCMD_DistributeFishTeam.yOffset[i]
        info.xOffset = pCMD_DistributeFishTeam.xOffset[i]
        info.tag = pCMD_DistributeFishTeam.tag[i]
        info.createTime = curTime -- 创建鱼的时间是服务器下发包的时间
        table.insert(self.m_queueFishTeam, info)
    end
    self.m_bCheckDistributeFish = true
    self.m_fCheckDistributeTime = curTime
    SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_DISTRIBUTE_FISH_TEAM, nil)
end 


function FishDataMgr:loadHitFishLK(pData)

    for k,v in pairs(self.m_vecFish) do

        local fish = v
        if fish ~= nil and fish:getID() == pData.fish_id then

            if fish:getFishKind() ~= FishKind.FISH_MEIRENYU then

                fish:setMultiple(pData.fish_mulriple)
            end
            return
        end
    end
end 

function FishDataMgr:loadSwitchScene(switchScene)
    self.m_bCheckDistributeFish = false
    self.switch_scene = switchScene                                                    
    self:setCreateDeskScene(self.switch_scene.tick_count == 0)
    print("------------------------------切换场景----------------------------(%d)", self.switch_scene.next_scene)
    local _event = {
        name = FishEvent.MSG_FISH_SWITCH_SCENE,
        packet = nil,
    }
    SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_SWITCH_SCENE, _event)
end 

function FishDataMgr:getbulletKindByIndex(index)
    local ret = BulletKind.BULLET_KIND_1_NORMAL
    if index < GAME_PLAYER_FISH then
        ret = self._bkUserKind[index+1]
    end
    return ret
end 

function FishDataMgr:getFishScoreByIndex(index)

    if index < GAME_PLAYER_FISH then

        return self._llUserScore[index+1]
    end
    return 0
end 

function FishDataMgr:getMulripleByIndex(index)

    if index < GAME_PLAYER_FISH then

        return self._current_mulriple_[index+1]
    end

    return 0
end 

function FishDataMgr:getMinBulletMultiple()

    return self.min_bullet_multiple_
end 

function FishDataMgr:getMaxBulletMultiple()

    return self.max_bullet_multiple_
end 

function FishDataMgr:setMulripleByIndex(index, mulriple)

    if index < GAME_PLAYER_FISH then

        self._current_mulriple_[index+1] = mulriple
    end
end 

function FishDataMgr:setBulletKindByIndex(index, bullKind)

    if index < GAME_PLAYER_FISH then

        self._bkUserKind[index+1] = bullKind
    end
end 


function FishDataMgr:getBulletTypeByMulriple(nMulriple, bullet_double)

    local eType = BulletKind.BULLET_KIND_1_NORMAL
    local nBase = self:getBaseScore()

    if nMulriple < FISH_PAO_SCORE_1 * nBase then
        eType = BulletKind.BULLET_KIND_1_NORMAL
        if bullet_double then
            eType = BulletKind.BULLET_KIND_1_ION
        end
    else
        eType = BulletKind.BULLET_KIND_2_NORMAL
        if bullet_double then
            eType = BulletKind.BULLET_KIND_2_ION
        end
    end

    return eType
end 

function FishDataMgr:getBulletSpeed(index)

    if index < BulletKind.BULLET_KIND_COUNT then
        return self.bullet_speed_[index+1]
    end
    return 3
end 

function FishDataMgr:getBulletBoundingRadius(index)

    if index < BulletKind.BULLET_KIND_COUNT then
        return self.bullet_bounding_radius[index+1]
    end
    return 10
end 

function FishDataMgr:getFishNameByIndex(index)

    local userinfor = self:getUserInforByChairID(index)
    local ret = ""
    if userinfor then
        ret = userinfor.nickname
    end
    return ret
end 

function FishDataMgr:getIsExistByIndex(index)
    local ret = self:getUserInforByChairID(index) ~= nil
    return ret
end 

-- del by nick ----------------------
function FishDataMgr:sendUserFire(bulletTempId, bullet_kind, angle, bullet_mulriple, lock_fishid)

    local a = 0
    --CMsgFish.getInstance():sendUserFire(angle,bullet_mulriple,lock_fishid,0,bulletTempId)
end 

function FishDataMgr:sendCatchFish(pFish, bulletId, bulletTempId)
    if pFish == nil then
        return
    end
    --CMsgFish.getInstance():sendCatchFish(0,pFish:getID(),bulletId,bulletTempId)
    --FishDataMgr:getInstance():sendCatchFish(pFish, bulletid, bulletTempId)
end 
-- del by nick ----------------------

function FishDataMgr:getFishByID(fishID)

    return self.m_vecFish[fishID]
end 

-- 设置鱼的影子是否可见
function FishDataMgr:ShowFishShadow( bShadow )
    self.m_bShowShadow = bShadow
    for k,v in pairs(self.m_vecFish) do
        if v ~= nil then 
            v:ShowShadow( bShadow )
        end 
    end
end 

function FishDataMgr:addFish(pFish)
    local nFishId = pFish:getID()
    if self.m_vecFish[nFishId] ~= nil then
        print("error fishid: " .. nFishId )
        return 
    end
    
    self.m_vecFish[nFishId] = pFish
end 

function FishDataMgr:delAllFish()

    for k,v in pairs(self.m_vecFish) do
        if v ~= nil then 
            --local nFishId = v:getID()
            --v:removeFromParent()
            v:SetFishUnuse()
            self.m_vecFish[k] = nil 
        end 
    end
    self.m_vecFish = {}
end 

function FishDataMgr:getAllFishLastScene()
    for k,v in pairs(self.m_vecFish) do
        table.insert(self.m_vecLastScene, k)
    end
end

function FishDataMgr:delAllFishLastScene()
    for k,v in pairs(self.m_vecLastScene) do
        self:delFish(self.m_vecLastScene[k], true)
        self.m_vecLastScene[k] = nil
    end

    self.m_vecLastScene = {}
end 

function FishDataMgr:delFish(fishID, bImmediatelyDie)

    if self.m_vecFish[fishID] ~= nil then
        local pFish = self.m_vecFish[fishID]
        pFish:setDie(true)

        if self:isNeedDieAction(self.m_vecFish[fishID]:getFishKind()) and bImmediatelyDie == false then
            local action1 = cc.RotateBy:create(5/60,  45)
            local action2 = cc.RotateBy:create(10/60, -90)
            local action3 = cc.RotateBy:create(9/60,  90)
            local action4 = cc.RotateBy:create(8/60,  -90)
            local action5 = cc.RotateBy:create(8/60,  90)
            local action6 = cc.RotateBy:create(4/60,  -90)
            local action7 = cc.Spawn:create(cc.RotateBy:create(8/60, 45),cc.FadeOut:create(8/60))
            local func = cc.CallFunc:create(function()
                --self.m_vecFish[fishID]:removeAllChildren()
                --self.m_vecFish[fishID]:removeFromParent()
                pFish:setOpacity(255)
                pFish:SetFishUnuse()
                self.m_vecFish[fishID] = nil
            end)
            local action = cc.Sequence:create(action1,action2,action3,action4,action5,action6,action7,func)
            pFish:setDie(true)
            pFish:runAction(action)
        else
            --self.m_vecFish[fishID]:removeAllChildren()
            --self.m_vecFish[fishID]:removeFromParent()
            pFish:setDie(true)
            pFish:setOpacity(255)
            pFish:SetFishUnuse()
            self.m_vecFish[fishID] = nil
        end
        --print("$$$$$$$$$$$$$$$$vecFishNUM: " .. table.nums(self.m_vecFish) )
    end
end

FishDataMgr.Fish_Of_Need_die = {
    [FishKind.FISH_JINCHAN]      = false, --18-李逵
    [FishKind.FISH_HAIDAN]       = false, --21-海胆
    [FishKind.FISH_SHUANGTOUQIE] = false, --24-双头企鹅
    [FishKind.FISH_FOSHOU]       = false, --26-佛手
    [FishKind.FISH_BGLU]         = false, --27-炼丹炉
    [FishKind.FISH_DNTG]         = false, --28-大闹天宫
    [FishKind.FISH_PIECE]        = false, --31-金玉满堂
    [FishKind.FISH_CHAIN]        = false, --33-闪电鱼
}
yl.setDefault(FishDataMgr.Fish_Of_Need_die, true)

function FishDataMgr:isNeedDieAction(fishKind_)
    return FishDataMgr.Fish_Of_Need_die[fishKind_]
end

function FishDataMgr:getUpdateFishTime()
    return self.m_fUpdateFishTime
end

function FishDataMgr:updateFish(dt)
    local updateTime = cc.exports.gettime()
    if updateTime > self.m_fUpdateFishTime then
        self.m_fUpdateFishTime = updateTime --避免时间回退
    end

    for k, v in pairs(self.m_vecFish) do
        if v ~= nil and v.fish_id_~= nil then
            if v.m_bRedStatus then
               v:refreshStatus(dt)
            end
            local bRemove = false
            if self.m_fFPSNumber < 16 then
                bRemove = v:SimpleRefresh(self.m_fUpdateFishTime)
            else
                bRemove = v:refresh(self.m_fUpdateFishTime)
            end

            if not bRemove then
                --local nFishId = v:getID()
                --v:removeFromParent()
                v:setDie(true)
                v:SetFishUnuse()            
                self.m_vecFish[k] = nil
                --print("$$$$$$$$$$$$$$$$vecFishNUM: " .. table.nums(self.m_vecFish) )
            end
        else 
            self.m_vecFish[k] = nil
        end
    end
end 

function FishDataMgr:GetTargetPoint(src_x_pos, src_y_pos, angle, target_x_pos, target_y_pos)
    local screen_width = 1334
    local screen_height = 750
    local screen_left = 0
    if LuaUtils.IphoneXDesignResolution then
        screen_width = display.width - LuaUtils.screenDiffX
        screen_left = - LuaUtils.screenDiffX
    end

    local bIsUpToDown = true
    local degrees = math.radian2angle(angle)
    if degrees >= 360 then
        degrees = degrees - 360
    end
    if (degrees > 270 and degrees <= 360) or(degrees >= 0 and degrees < 90) then
        bIsUpToDown = false
    end
    if bIsUpToDown then
        if angle < M_PI then
            local temp_angle = MathAide:CalcAngle(screen_width, screen_height, src_x_pos, src_y_pos)
            if temp_angle > angle then
                target_x_pos = screen_width                                                          
                target_y_pos = src_y_pos + math.tan(angle - M_PI_2) *(screen_width - src_x_pos)
            else
                target_x_pos = src_x_pos +(screen_height - src_y_pos) * math.tan(M_PI - angle)
                target_y_pos = screen_height
            end
        else
            local temp_angle = MathAide:CalcAngle(screen_left, screen_height, src_x_pos, src_y_pos)
            if temp_angle > angle then
                target_x_pos = src_x_pos -(screen_height - src_y_pos) * math.tan(angle - M_PI)
                target_y_pos = screen_height
            else
                target_x_pos = screen_left
                target_y_pos = src_y_pos + math.tan(M_PI + M_PI_2 - angle) * (src_x_pos + math.abs(screen_left) )
            end
        end
    else

        if angle == M_PI / 2 then
            target_x_pos = screen_width
            target_y_pos = src_y_pos
        elseif angle > M_PI * 2 then
            local temp_angle = MathAide:CalcAngle(screen_width, 0, src_x_pos, src_y_pos)
            if temp_angle > angle then
                target_x_pos = src_x_pos + src_y_pos * math.tan(angle - M_PI * 2)
                target_y_pos = 0
            else
                target_x_pos = screen_width
                target_y_pos = src_y_pos -(screen_width - src_x_pos) * math.tan(M_PI_2 + M_PI * 2 - angle)
            end
        else
            local temp_angle = MathAide:CalcAngle(screen_left, 0, src_x_pos, src_y_pos)
            if temp_angle > angle then
                target_x_pos = screen_left
                target_y_pos = src_y_pos - math.tan(angle - M_PI - M_PI_2) * (src_x_pos + math.abs(screen_left) )
            else
                target_x_pos = src_x_pos - src_y_pos * math.tan(2 * M_PI - angle)
                target_y_pos = 0
            end
        end
    end
    return target_x_pos,target_y_pos
end 


function FishDataMgr:GetTargetPoint2(src_x_pos, src_y_pos, angle, target_x_pos, target_y_pos)
    local screen_width = 1334
    local screen_height = 750
    local screen_left = 0
    if LuaUtils.IphoneXDesignResolution then
        screen_width = display.width - LuaUtils.screenDiffX
        screen_left = - LuaUtils.screenDiffX
    end

    local bIsUpToDown = true
    local degrees = math.radian2angle(angle)  
    if degrees >= 360 then
        degrees = degrees - 360
    end
    if (degrees > 270 and degrees <= 360) or (degrees >= 0 and degrees < 90) then
        bIsUpToDown = false
    end

    if bIsUpToDown then
        if angle == M_PI then
            target_x_pos = src_x_pos
            src_y_pos = 0
        elseif angle < M_PI then
            local temp_angle = MathAide:CalcAngle2(screen_width, 0, src_x_pos, src_y_pos)
            if temp_angle > angle then
                target_x_pos = screen_width
                target_y_pos = src_y_pos - math.tan(angle - M_PI_2) *(screen_width - src_x_pos)
            else
                target_x_pos = src_x_pos + src_y_pos * math.tan(M_PI - angle)
                target_y_pos = 0
            end
        else

            local temp_angle = MathAide:CalcAngle2(screen_left, 0, src_x_pos, src_y_pos)
            if temp_angle > angle then

                target_x_pos = src_x_pos - src_y_pos * math.tan(angle - M_PI)
                target_y_pos = 0

            else

                target_x_pos = screen_left
                target_y_pos = src_y_pos - math.tan(M_PI + M_PI_2 - angle) * (src_x_pos + math.abs(screen_left) )
            end
        end
    else

        if angle == M_PI_2 then

            target_x_pos = screen_width
            target_y_pos = 0
        elseif angle < M_PI_2 then

            local temp_angle = MathAide:CalcAngle2(screen_width, screen_height, src_x_pos, src_y_pos)
            if temp_angle > angle then

                target_x_pos = src_x_pos +(screen_height - src_y_pos) * math.tan(angle)
                target_y_pos = screen_height

            else

                target_x_pos = screen_width
                target_y_pos = src_y_pos +(screen_width - src_x_pos) * math.tan(M_PI_2 - angle)
            end

        else

            local temp_angle = MathAide:CalcAngle2(screen_left, screen_height, src_x_pos, src_y_pos)
            if temp_angle > angle then

                target_x_pos = screen_left
                target_y_pos = src_y_pos + math.tan(angle - M_PI - M_PI_2) * (src_x_pos + math.abs(screen_left) )
            else

                target_x_pos = src_x_pos -(screen_height - src_y_pos) * math.tan(2 * M_PI - angle)
                target_y_pos = screen_height
            end
        end
    end
    return target_x_pos,target_y_pos
end 

--子弹的弹射路径
function FishDataMgr:getTanSheAngle(pofunction, angle)

    local visbleSize = {}
    visbleSize.width = 1334
    visbleSize.height = 750    
--    if LuaUtils.IphoneXDesignResolution then
--        visbleSize.width = display.width - LuaUtils.screenDiffX
--    end
    if angle > 2 * M_PI then
        angle = angle - 2 * M_PI
    end
    if pofunction.y <= 0 then
        if angle < M_PI then
            angle = M_PI - angle
        else
            angle =(3 * M_PI - angle)
        end
    elseif pofunction.y >= visbleSize.height then

        if angle < M_PI_2 then
            angle = M_PI - angle
        else
            angle =(3 * M_PI - angle)
        end
    elseif pofunction.x <= 0 then
        angle =(2 * M_PI - angle)
    elseif pofunction.x >= visbleSize.width then
        angle =(2 * M_PI - angle)
    end
    return angle
end 


function FishDataMgr:setAllSleepStatus(_bSleep)

    local  curTime = cc.exports.gettime()
    self.m_bAllStop = _bSleep
    for k,v in pairs(self.m_vecFish) do
        local pFish = v
        if pFish ~= nil then
            pFish:setSleepStaus(_bSleep, curTime )
        end
    end
end 

function FishDataMgr:getSwtichSceneData()
     return self.switch_scene
end

function FishDataMgr:ClearAllData()

    self:delAllFish()
    self:Clear()
    self:ClearFishBullet()
end

function FishDataMgr:ClearBullet()
--    local nMyChirId = FishDataMgr:getInstance():getMeChairID()
--    for k,v in pairs(self.m_queueFire) do
--        local nChairId = v.chair_id
--        local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(nChairId)
--        if nChairId < GAME_PLAYER_FISH then
--            if nMyChirId ~= nChairId then
--                local fishScore = self:getFishScoreByIndex(nChairId)
--                self._llUserScore[nChairId + 1] = fishScore - v.bullet_mulriple
--            end
--        end
--    end
    self.m_queueFire = {}
end

function FishDataMgr:ClearFishBullet()

    self.m_queueFire = {}
    self:ClearFishQuene()
end 

function FishDataMgr:ClearFishQuene()

    self.m_queueFish = {}
end 

function FishDataMgr:ClearFishTeamQuene()

    self.m_queueFishTeam = {}
end 

function FishDataMgr:setFishAllAccelerate()
    for k,pFish in pairs(self.m_vecFish) do
        if pFish ~= nil then
            pFish:setAccelerate()
        end
    end
end

-- 处理大闹天宫2的服务器消息
function FishDataMgr:onSceneFish(pSceneFish)
    local newFish = {}
    newFish.isAlive = true 
    newFish.path_index = pSceneFish.path_index
    newFish.fish_kind = pSceneFish.fish_kind
    newFish.fish_id = pSceneFish.fish_id
    newFish.elapsed = pSceneFish.elapsed
    newFish.tag = pSceneFish.tag
    newFish.bSyncFish = false
    newFish.createTime = cc.exports.gettime() -- 创建鱼的时间是服务器下发包的时间
    table.insert(self.m_queueFish, newFish)
    self.m_bCheckDistributeFish = true
    self.m_fCheckDistributeTime = newFish.createTime
end 

function FishDataMgr:onDistributeFish(pDistributeFish, bSyncFish)

    local newFish = {}
    newFish.isAlive = true 
    newFish.path_index = pDistributeFish.path_index
    newFish.fish_kind = pDistributeFish.fish_kind
    newFish.fish_id = pDistributeFish.fish_id
    newFish.tag = pDistributeFish.tag
    newFish.delay = pDistributeFish.fDelay
    newFish.xOffset = pDistributeFish.fOffestX
    newFish.yOffset = pDistributeFish.fOffestY
    newFish.passTime = pDistributeFish.dwServerTick
    newFish.bSyncFish = bSyncFish
    newFish.createTime = cc.exports.gettime() -- 创建鱼的时间是服务器下发包的时间
    newFish.fish_mulriple = pDistributeFish.fish_mulriple    
    table.insert(self.m_queueFish, newFish)

    if newFish.path_index < 10000 then  -- 普通的鱼才检测
        self.m_bCheckDistributeFish = true
        self.m_fCheckDistributeTime = newFish.createTime
    else
        self.m_bCheckDistributeFish = false
    end
end 

function FishDataMgr:onDistributeFishCircle(pDistributeCircle)
    local curTime = cc.exports.gettime()
    local i = 1
    while (i <= pDistributeCircle.fish_count and i <= MAX_FISH_CIRCLE) do
        local newFish = {}
        newFish.isAlive = true 
        newFish.path_index = pDistributeCircle.path_index[i]
        newFish.fish_kind = pDistributeCircle.fish_kind[i]
        newFish.fish_id = pDistributeCircle.fish_id[i]
        newFish.tag = pDistributeCircle.tag[i]
        newFish.elapsed = 0
        newFish.delay = 0
        newFish.fish_mulriple = pDistributeCircle.fish_mulriple[i]
        newFish.xOffset = pDistributeCircle.xOffset
        newFish.yOffset = pDistributeCircle.yOffset
        newFish.bSyncFish = false
        newFish.createTime = curTime -- 创建鱼的时间是服务器下发包的时间
        table.insert(self.m_queueFish, newFish)
        i = i + 1
    end

    self.m_bCheckDistributeFish = true
    self.m_fCheckDistributeTime = curTime
end

FishDataMgr.Scale_Of_Fish = {
    [FishKind.FISH_LANYU]        = 0.8, --07-蓝鱼
    [FishKind.FISH_JINCHAN]      = 1.2, --18-李逵
    [FishKind.FISH_MEIRENYU]     = 0.8, --20-美人鱼
    [FishKind.FISH_XIAOYINLONG]  = 1.25, --22-小银龙
    [FishKind.FISH_XIAOJINLONG]  = 1.25, --23-小金龙
    [FishKind.FISH_SHUANGTOUQIE] = 1.3, --24-双头企鹅
    [FishKind.FISH_DNTG]         = 0.8, --28-大闹天宫
    [FishKind.FISH_PIECE]        = 0.8, --31-金玉满堂
}
yl.setDefault(FishDataMgr.Scale_Of_Fish, 1.0)

-- 修正动画大小
function FishDataMgr:getFishScale(_fishKind)
    return FishDataMgr.Scale_Of_Fish[_fishKind]
end

FishDataMgr.Offset_Of_Fish = {
    [FishKind.FISH_LANYU] = cc.p(-5, 0),
    [FishKind.FISH_DENGLONGYU] = cc.p(9, 14),
}
yl.setDefault(FishDataMgr.Offset_Of_Fish, cc.p(0, 0))

-- 修正动画位置
function FishDataMgr:getFishOffset(_fishKind)
    return FishDataMgr.Offset_Of_Fish[_fishKind]
end

FishDataMgr.Scale_Of_QUAN = {
    [FishKind.FISH_WONIUYU]     = 0.45,    
    [FishKind.FISH_LVCAOYU]     = 0.37,    
    [FishKind.FISH_HUANGCAOYU]  = 0.55, 
    [FishKind.FISH_DAYANYU]     = 0.65,    
    [FishKind.FISH_HUANGBIANYU] = 0.65,
    [FishKind.FISH_XIAOCHOUYU]  = 0.50, 
    [FishKind.FISH_XIAOCIYU]    = 0.60,   
    [FishKind.FISH_LANYU]       = 0.70,      
    [FishKind.FISH_DENGLONGYU]  = 0.80, 
}
yl.setDefault(FishDataMgr.Scale_Of_QUAN, 1)

function FishDataMgr:getQuanQuanScale(_fishKind)
    return FishDataMgr.Scale_Of_QUAN[_fishKind]
end 

function FishDataMgr:getQuanQuanDistance(_fishKind1, _fishKind2)

    local dis1 = self:getQuanQuanScale(_fishKind1) * 100
    local dis2 = self:getQuanQuanScale(_fishKind2) * 100
    return dis1 + dis2
end 

function FishDataMgr:checkIsShowFishByKind(_fishKind)

    if _fishKind < FishKind.FISH_WONIUYU --<0
    or _fishKind > FishKind.FISH_CHAIN   -->33
    then
        return false
    end
    return true
end

FishDataMgr.FISH_OF_ArmatureLiveName = {
    [FishKind.FISH_FOSHOU] = "move",
    [FishKind.FISH_DNTG]   = "onepanmove",
    [FishKind.FISH_PIECE]  = "fivepanmove",
    [FishKind.FISH_CHAIN]  = "",
}
yl.setDefault(FishDataMgr.FISH_OF_ArmatureLiveName, "Animation1")

function FishDataMgr:getAnimationLiveNameByFishKind(_fishKind)
    return FishDataMgr.FISH_OF_ArmatureLiveName[_fishKind]
end

function FishDataMgr:getAnimationDieNameByFishKind(_fishKind)
    return ""
end

FishDataMgr.FISH_OF_Armature = {
    [FishKind.FISH_WONIUYU]        = "yu0_buyu",                  --0-蜗牛鱼
    [FishKind.FISH_LVCAOYU]        = "yu1_buyu",                  --1-绿草鱼
    [FishKind.FISH_HUANGCAOYU]     = "yu2_buyu",                  --2-黄草鱼
    [FishKind.FISH_DAYANYU]        = "yu3_buyu",                  --3-黄草鱼
    [FishKind.FISH_HUANGBIANYU]    = "yu4_buyu",                  --4-黄边鱼
    [FishKind.FISH_XIAOCHOUYU]     = "yu5_buyu",                  --5-小丑鱼
    [FishKind.FISH_XIAOCIYU]       = "yu6_buyu",                  --6-小刺鱼
    [FishKind.FISH_LANYU]          = "yu7_buyu",                  --7-蓝鱼
    [FishKind.FISH_DENGLONGYU]     = "yu8_buyu",                  --8-灯笼鱼
    [FishKind.FISH_HAIGUI]         = "yu9_buyu",                  --9-海龟
    [FishKind.FISH_HUDIEYU]        = "yu14_buyu",                 --11-蝴蝶鱼
    [FishKind.FISH_KONGQUEYU]      = "yu12_buyu",                 --12-孔雀鱼(??)
    [FishKind.FISH_JIANYU]         = "yu13_buyu",                 --13-剑鱼
    [FishKind.FISH_BIANFUYU]       = "yu14_buyu",                 --14-蝙蝠鱼
    [FishKind.FISH_YINSHA]         = "yu16_buyu",                 --15-银鲨
    [FishKind.FISH_JINSHA]         = "yu17_buyu",                 --16-金鲨
    [FishKind.FISH_XIAOYINLONG]    = "yu22_buyu",                 --22-小银龙
    [FishKind.FISH_XIAOJINLONG]    = "yu23_buyu",                 --23-小金龙
    [FishKind.FISH_FOSHOU]         = "yu26_buyu",                 --26-佛手
    [FishKind.FISH_BAWANGJING]     = "dashengzhanjian_buyu",      --17-霸王鲸-神仙船
    [FishKind.FISH_JINCHAN]        = "sunwukong_buyu",            --18-金蝉-孙悟空
    [FishKind.FISH_SHENXIANCHUAN]  = "dashengzhanjian_buyu",      --19-神仙船
    [FishKind.FISH_MEIRENYU]       = "meirenyu_buyu",             --20-美人鱼
    [FishKind.FISH_XIAOQINGLONG]   = "ruyijingubang_buyu",        --21-小青龙-如意棒
    [FishKind.FISH_SWK]            = "sunwukong_buyu",            --24-孙悟空
    [FishKind.FISH_YUWANGDADI]     = "yuhuangdadi_buyu",          --25-玉皇大帝
    [FishKind.FISH_BGLU]           = "liandanlu_buyu",            --27-炼丹炉
    [FishKind.FISH_DNTG]           = "danaotiankongyuanpan_buyu", --28-大闹天宫
    [FishKind.FISH_YJSD]           = "yijianshuangdiao_buyu",     --29-一箭双雕
    [FishKind.FISH_YSSN]           = "yishisanniao_buyu",         --30-一石三鸟
}
yl.setDefault(FishDataMgr.FISH_OF_Armature, "")

function FishDataMgr:getArmatureNameByFishKind(_fishKind)
    return FishDataMgr.FISH_OF_Armature[_fishKind]
end

function FishDataMgr:checkFishLock(fish_id)

    local fish = self:getFishByID(fish_id)
    if fish == nil then
        return nil,false
    end

    if fish:isOutScreen() then
        return nil,false
    end

    if fish:getDie() then
        return nil,false
    end

    if fish:getChainStatus() then
        return nil,false
    end

    return fish, true
end 

function FishDataMgr:cancelLock(chair_id)

    if chair_id < 0 or chair_id >= GAME_PLAYER_FISH then

        return false
    end
    self._current_lock_fish[chair_id+1] = -1
    return true
end 

function FishDataMgr:getLockFish(chair_id)

    local ret = -1
    if chair_id >= 0 or chair_id < GAME_PLAYER_FISH then

        ret = self._current_lock_fish[chair_id+1]
    end
    return ret

end 

function FishDataMgr:setLockFish(chair_id, fish_id)

    if chair_id >= 0 or chair_id < GAME_PLAYER_FISH then

        self._current_lock_fish[chair_id+1] = fish_id

        if fish_id >= 0 then

            self._current_lock_fish_time[chair_id+1] = os.time()
        end
    end
end 

function FishDataMgr:getLockFishTime(chair_id)

    if chair_id >= 0 or chair_id < GAME_PLAYER_FISH then

        return self._current_lock_fish_time[chair_id+1]
    end
    return 0
end 

function FishDataMgr:getLockFish2()

    -- 首先查找上一次锁定的鱼
    local fish = self:getFishByID(self.m_nLastLockFish)
    if fish ~= nil then
        return fish:getID()
    end
    for k, fish in pairs(self.m_vecFish) do
        if  fish:getFishKind() >= FishKind.FISH_YINSHA
        and fish:getFishKind() ~= FishKind.FISH_HAIDAN
        and fish:getFishKind() <= FishKind.FISH_KIND_COUNT
        and not fish:isOutScreen()
        and not fish:getChainStatus()
        then
            return fish:getID()
        end
    end
    return -1
end 

function FishDataMgr:getTargetPositionByAngle(begin, angle, distance)

    local x = 0
    local y = 0
    -- 计算弧度
    angle = math.angle2radian(angle)
    if angle >= 0 and angle <= M_PI_2 then

        x = begin.x + math.sin(angle) * distance
        y = begin.y + math.cos(angle) * distance

    elseif angle > M_PI_2 and angle <= M_PI then

        angle = angle - M_PI_2
        x = begin.x + math.cos(angle) * distance
        y = begin.y - math.sin(angle) * distance

    elseif angle > M_PI and angle <= (M_PI_2 * 3) then

        angle = angle - M_PI
        x = begin.x - math.sin(angle) * distance
        y = begin.y - math.cos(angle) * distance

    elseif angle > (M_PI_2 * 3) and angle <= (M_PI * 2) then

        angle =(M_PI * 2) - angle
        x = begin.x - math.sin(angle) * distance
        y = begin.y + math.cos(angle) * distance

    end

    return cc.p(x, y)
end 

function FishDataMgr:SwitchViewChairID(chairID)

    local meChairID = FishDataMgr:getInstance():getMeChairID()
    if meChairID == nil then 
         meChairID = 0
    end
    if meChairID < 2 then
        return chairID
    end

    return (chairID + 2) % GAME_PLAYER_FISH
end 

----------------------------------------------------------------------------------
function FishDataMgr:setAllStop(m_bAllStop)
     self.m_bAllStop   = m_bAllStop
end

function FishDataMgr:getAllStop()
    return self.m_bAllStop
end

function FishDataMgr:setLock(lock_)
     self.lock_   = lock_
end

function FishDataMgr:getLock()
    return self.lock_
end

function FishDataMgr:setLastLockFish(nLastLockFish)
     self.m_nLastLockFish   = nLastLockFish
end

function FishDataMgr:getLastLockFish()
    return self.m_nLastLockFish
end

function FishDataMgr:setAllowFire(allow_fire_)
     self.allow_fire_   = allow_fire_
end

function FishDataMgr:getAllowFire()
    return self.allow_fire_
end

--function FishDataMgr:setSceneBGIndex(scene_bgindex_)
--     self.scene_bgindex_   = scene_bgindex_
--end

--function FishDataMgr:getSceneBGIndex()
--    return self.scene_bgindex_
--end

function FishDataMgr:setSpecialSceneWaitTime(special_sceene_waited_time)
     self.special_sceene_waited_time   = special_sceene_waited_time
end

function FishDataMgr:getSpecialSceneWaitTime()
    return self.special_sceene_waited_time
end

function FishDataMgr:setFoShouId(nFoShouId)
     self.m_nFoShouId   = nFoShouId
end

function FishDataMgr:getFoShouId()
    return self.m_nFoShouId
end

function FishDataMgr:setLianDanLuId(nLianDanLuId)
     self.m_nLianDanLuId   = nLianDanLuId
end

function FishDataMgr:getLianDanLuId()
    return self.m_nLianDanLuId
end

function FishDataMgr:setShanDianYuId(nShanDianYuId)
     self.m_nShanDianYuId   = nShanDianYuId
end

function FishDataMgr:getShanDianYuId()
    return self.m_nShanDianYuId
end

function FishDataMgr:setCreateDeskScene(bCreateDeskScene)
     self.m_bCreateDeskScene   = bCreateDeskScene
end

function FishDataMgr:getCreateDeskScene()
    return self.m_bCreateDeskScene
end

function FishDataMgr:setIsNetworkFail(IsNetworkFail)
     self.m_bIsNetworkFail   = IsNetworkFail
end

function FishDataMgr:getIsNetworkFail()
    return self.m_bIsNetworkFail
end

function FishDataMgr:getBaseScore()
    return self:getMinBulletMultiple()
end

function FishDataMgr:onUserEnter(userid, userinfor)
    if userinfor then
         userinfor.AutomaticFiring =  userinfor.is_shoot_stop == false 
         userinfor.is_shoot_stop = false
         userinfor.firingInterval = cmd.firingIntervalEnum.normal
         userinfor.TouchPhase = false
         userinfor.lastAttackTime = 0
         userinfor.lastFirePos = cc.p(0,0)
         userinfor.isLockfish = false
         self.m_tablePlayer[userid] = userinfor
         self._llUserScore[userinfor.position+1] = userinfor.score
     end
end

function FishDataMgr:onUserLeave(userid)
   self.m_tablePlayer[userid] = nil
end

function FishDataMgr:getUserList()
    return self.m_tablePlayer
end

function FishDataMgr:getUserInforByChairID(chairid)
    for k,v in pairs(self.m_tablePlayer) do
         local viewchairid = v.position
        if viewchairid == chairid then
             return v
        end
    end
   return nil
end

function FishDataMgr:getChairIDByGuid(guid)
    if self.m_tablePlayer[guid] then
        return self.m_tablePlayer[guid].position
    end
    return INVALID_CHAIR
end

function FishDataMgr:getMeChairID()
    local meInfor = self:getMeUserInfor()
    if meInfor then
        return meInfor.position
    end
    return INVALID_CHAIR
end

function FishDataMgr:getMeUserInfor()
    return self.m_tablePlayer[GlobalUserItem.tabAccountInfo.userid]
end

function FishDataMgr:setAutomaticFiring(guid, AutomaticFiring)
    if self.m_tablePlayer[guid] then
         self.m_tablePlayer[guid].AutomaticFiring = AutomaticFiring
    end
end

function FishDataMgr:getAutomaticFiring(guid)
    return self.m_tablePlayer[guid].AutomaticFiring
end

function FishDataMgr:setfiringInterval(guid, firingInterval)
    if self.m_tablePlayer[guid] then
         self.m_tablePlayer[guid].firingInterval = firingInterval
    end
end

function FishDataMgr:getfiringInterval(guid)
    return self.m_tablePlayer[guid].firingInterval
end

function FishDataMgr:setstopAttack(guid, stopAttack)
    if self.m_tablePlayer[guid] then
         self.m_tablePlayer[guid].is_shoot_stop = stopAttack
    end
end

function FishDataMgr:getstopAttack(guid)
    return self.m_tablePlayer[guid].is_shoot_stop
end

function FishDataMgr:setfireAngel(guid, angel)
    if self.m_tablePlayer[guid] then
         self.m_tablePlayer[guid].lock_angle = angel
    end
end

function FishDataMgr:getfireAngel(guid)
    return self.m_tablePlayer[guid].lock_angle
end

function FishDataMgr:setTouchPhase(guid, TouchPhase)
    if self.m_tablePlayer[guid] then
         self.m_tablePlayer[guid].TouchPhase = TouchPhase
    end
end

function FishDataMgr:getTouchPhase(guid)
    return self.m_tablePlayer[guid].getTouchPhase
end

function FishDataMgr:setlastAttackTime(guid, lastAttackTime)
    if self.m_tablePlayer[guid] then
         self.m_tablePlayer[guid].lastAttackTime = lastAttackTime
    end
end

function FishDataMgr:getlastAttackTime(guid)
    return self.m_tablePlayer[guid].lastAttackTime
end

function FishDataMgr:setlastFirePos(guid, lastFirePos)
    if self.m_tablePlayer[guid] then
         self.m_tablePlayer[guid].lastFirePos = lastFirePos
    end
end

function FishDataMgr:getlastFirePos(guid)
    return self.m_tablePlayer[guid].lastFirePos
end

function FishDataMgr:getUserScore()
    local meInfor = self:getMeUserInfor()
    if meInfor then
        return meInfor.score
    end
    return 0
end

function FishDataMgr:setUserLockFish(guid, islockfish)
    if self.m_tablePlayer[guid] then
         self.m_tablePlayer[guid].isLockfish = islockfish
    end
end

function FishDataMgr:getUserLockFish(guid)
    return self.m_tablePlayer[guid].isLockfish
end

function FishDataMgr:Protocal_fish_fire_continuously(body) 
   -- {game.setting.msgId,op,uid,{...}}
    local _event = {
        name = FishEvent.MSG_FISH_TOUNCH_EVENT,
        msg = body,
    }
    SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_TOUNCH_EVENT, _event)
end

function FishDataMgr:switch_cannon(body)
    local _event = {
        body = body,
    }
    SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_SWITCH_CANNON, _event)
end

return FishDataMgr

--endregion
