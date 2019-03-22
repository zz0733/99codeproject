
local module_pre = "game.yule.monkeyfish.src"
local FishDefine  = require(module_pre..".views.scene.FishDefine")
local FishEvent   = require(module_pre..".views.scene.FishEvent")
local FishDataMgr = require(module_pre..".views.manager.FishDataMgr")
local cmd = appdf.req(module_pre .. ".models.CMD_Game")

local Public_Events = cc.exports.Public_Events
local SLFacade      = cc.exports.SLFacade
local PlayerInfo    = cc.exports.PlayerInfo

local CMsgFish = class("CMsgFish")

CMsgFish.instance_ = nil
function CMsgFish:getInstance()
    if CMsgFish.instance_ == nil then
        CMsgFish.instance_ = CMsgFish.new()
    end
    return CMsgFish.instance_
end
function CMsgFish:ctor()
end

--游戏消息
function CMsgFish:onGameMsg(sub,dataBuffer)
    if sub == "enter" then
        local deskinfo = dataBuffer["deskinfo"]
        self:loadGameSceneData(deskinfo)
        local memberinfos =  dataBuffer["memberinfos"]
        for k,v in pairs(memberinfos) do
            FishDataMgr:getInstance():onUserEnter(v.uid, v)
        end
    elseif sub == "newfish" then
       self:onDistributeFish(dataBuffer)
    elseif sub == "leave" then
         local chairid = FishDataMgr:getInstance():getChairIDByGuid(dataBuffer)
         FishDataMgr:getInstance():onUserLeave(dataBuffer)
         local _event = chairid
         SLFacade:dispatchCustomEvent(FishEvent.MSG_USER_LEAVE, _event)
    elseif sub == "come" then
        local memberinfo = dataBuffer.memberinfo
        FishDataMgr:getInstance():onUserEnter(memberinfo.uid, memberinfo)
        local _event = memberinfo.position
        SLFacade:dispatchCustomEvent(FishEvent.MSG_USER_FREE, _event)
    elseif sub == "buy" then
    elseif sub == "fish_group" then
    elseif sub == "npc_control" then
       FishDataMgr:getInstance().isMaster = dataBuffer == 1
    elseif sub == "fire_continuously" then
        FishDataMgr:getInstance():Protocal_fish_fire_continuously(dataBuffer)
    elseif sub == "explode" then
        self:onCatchFishChain(dataBuffer)
    elseif sub == "sync_group_fishes" then
    elseif sub == "lockon" then
    elseif sub == "switch_cannon" then
        FishDataMgr:getInstance():switch_cannon(dataBuffer)
    elseif sub == "catchsweepresult" then
        self:onCatchFishGroup(dataBuffer)
    elseif sub == "boss_lottery" then
    elseif sub == "clean" then
        local showtype = dataBuffer[2]
        if showtype == 1 then
            --self:getSwitchScene()
        end
    elseif sub == "dummy_shoot_start" then
        local guid = dataBuffer
        self:HandNpcMsg(202, guid, true)
    elseif sub == "dummy_shoot_stop" then
        local guid = dataBuffer
        self:HandNpcMsg(202, guid, false)
    elseif sub == "dummy_fast_shoot" then
        local guid = dataBuffer[1]
        local firingInterval = dataBuffer[2] == 1  and cmd.firingIntervalEnum.accelerate or cmd.firingIntervalEnum.norma
        --self:HandNpcMsg(203, guid, firingInterval)
    elseif sub == "dummy_lock_fish" then
        local guid = dataBuffer[1]
        local lockIn = dataBuffer[2]
        local angel = dataBuffer[3]
        self:HandNpcMsg(205, guid, lockIn, angel)
    elseif sub == "energy" then
    elseif sub == "levelbegin" then
    else
    end
end

function CMsgFish:HandNpcMsg(op,uid,...)
    local body = {}
    body[1] = 0
    body[2] = op
    body[3] = uid
    body[4] = {...}
    local _event = {
        name = FishEvent.MSG_FISH_TOUNCH_EVENT,
        msg = body,
    }
    SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_TOUNCH_EVENT, _event)
end

-- 游戏场景-100-101
function CMsgFish:loadGameSceneData(pData)
    
    --数据
    local pGameScene = {}
    pGameScene.is_special_scene = false
    pGameScene.special_sceene_waited_time = 0
    pGameScene.tick_count = os.time()
    pGameScene.game_config = {}
    pGameScene.game_config.exchange_ratio_userscore = pData.exchange_ratio_userscore
    pGameScene.game_config.exchange_ratio_fishscore = pData.exchange_ratio_fishscore
    pGameScene.game_config.exchange_count = pData.exchange_count
    pGameScene.game_config.min_bullet_multiple = pData.min_bullet_multiple
    pGameScene.game_config.max_bullet_multiple =  pData.max_bullet_multiple
    pGameScene.game_config.fish_speed = {}
    for i = 1, FishKind.FISH_KIND_COUNT do 
        pGameScene.game_config.fish_speed[i] = 40
    end
    pGameScene.game_config.fish_bounding_radius = {}
    for i = 1, FishKind.FISH_KIND_COUNT do 
        pGameScene.game_config.fish_bounding_radius[i] = 12
    end
    pGameScene.game_config.fish_bounding_count = {}
    for i = 1, FishKind.FISH_KIND_COUNT do 
        pGameScene.game_config.fish_bounding_count[i] = 12
    end
    pGameScene.game_config.bullet_speed = {}
    for i = 1,BulletKind.BULLET_KIND_COUNT do 
        pGameScene.game_config.bullet_speed[i] = 800
    end 
    pGameScene.game_config.bullet_bounding_radius = {}
    for i = 1,BulletKind.BULLET_KIND_COUNT do 
        pGameScene.game_config.bullet_bounding_radius[i] = 20
    end 
    pGameScene.fish_score = {}
    for i = 1,GAME_PLAYER_FISH do          
        pGameScene.fish_score[i] = 60
    end 
    pGameScene.exchange_fish_score = {}
    for i = 1,GAME_PLAYER_FISH do          
        pGameScene.exchange_fish_score[i] = 60
    end 

    --保存
    FishDataMgr:getInstance():processGameScene(pGameScene)
    --日志
    local ret = ""
    return ret
end

-- 大闹天宫捕鱼==========================
-- CMD_S_Scenemonkeyfish
function CMsgFish:onSceneFish(pData) --200-100
end 

-- CMD_S_Distributemonkeyfish   sizeof = 56
function CMsgFish:onDistributeFish(pData) --200-105
     
    --数据/保存
    local fishids = pData[1]
    local fishkind = pData[2]
    local pathid = pData[3]
    local mulriple = pData[4]
    local fishCount = #fishids
    local fishtag = 0
    if pathid >= 102 and pathid < 116 then  --场景鱼
        self:getSwitchScene(pData)
    else
        --print("onDistributeFis================h fish count:",tostring(fishCount))
        if fishkind == 20 then
            fishtag = 0
        end

        if fishkind == 18 then
            fishkind = 20
            fishtag = 1
        end

        local bKingFish = false
        if fishkind < 13 and fishkind % 2 == 0 then
            bKingFish = true
            fishtag = fishkind - 1
        end
        for i = 1, fishCount do
            local pDistributeFish = {}
            pDistributeFish.fish_kind = bKingFish == true and FishKind.FISH_DNTG or fishkind
            pDistributeFish.fish_id = fishids[i]
            pDistributeFish.tag = fishtag
            pDistributeFish.fish_mulriple = mulriple
            pDistributeFish.path_index = pathid
            pDistributeFish.fOffestX = math.random(100, 200)
            pDistributeFish.fOffestY = math.random(100, 200)
            pDistributeFish.fDir = 0
            pDistributeFish.fDelay = 0.1*(i-1)
            pDistributeFish.dwServerTick = os.time()
            pDistributeFish.FishSpeed = 60
            pDistributeFish.FisType = fishkind
            pDistributeFish.nTroop = 0
            pDistributeFish.nRefershID = 0

            FishDataMgr:getInstance():onDistributeFish(pDistributeFish, false)
        end
    end

    --日志
    local ret = "" --string.format("新鱼[%d]", fishCount)

    return ret
end 
function CMsgFish:onReturnFishSync(pData)
    local datalen = pData:getReadableSize()
    if datalen % 56 > 0 then
        return "error 200-105"
    end
    local _buffer = pData:readData(datalen)

    --数据/保存
    local fishCount = datalen / 56
    FishDataMgr:getInstance().m_nSyncFishNum = fishCount
    FishDataMgr:getInstance().m_nSyncFishNum = 0
    --print("onReturnFishSync================h fish count:",tostring(fishCount))
    for i = 1, fishCount do
        local pDistributeFish = {}
        pDistributeFish.fish_kind = _buffer:readInt()
        pDistributeFish.fish_id = _buffer:readInt()
        pDistributeFish.tag = _buffer:readInt()
        pDistributeFish.fish_mulriple = _buffer:readUInt()
        pDistributeFish.path_index = _buffer:readInt()
        pDistributeFish.fOffestX = _buffer:readFloat()
        pDistributeFish.fOffestY = _buffer:readFloat()
        pDistributeFish.fDir = _buffer:readFloat()
        pDistributeFish.fDelay = _buffer:readFloat()
        pDistributeFish.dwServerTick = _buffer:readInt()
        pDistributeFish.FishSpeed = _buffer:readFloat()
        pDistributeFish.FisType = _buffer:readInt()
        pDistributeFish.nTroop = _buffer:readInt()
        pDistributeFish.nRefershID = _buffer:readInt()

        FishDataMgr:getInstance():onDistributeFish(pDistributeFish, true)
    end

    --日志
    local ret = string.format("同步鱼[%d]", fishCount)

    return ret
end

function CMsgFish:onUserScoreSync( pData )
    local datalen = pData:getReadableSize()
    if 20 ~= datalen then
        return "error 200-117"
    end
    local _buffer = pData:readData(datalen)

    local	wChairid    = _buffer:readUShort()
	local	wType       = _buffer:readUShort()
	local	dwData1     = _buffer:readUInt()
	local   dwData2     = _buffer:readUInt()
	local	llCurScore  = _buffer:readLongLong()

    --通知
    local _event = {
        name = FishEvent.MSG_FISH_SCORE_SYNC,
        chairId = wChairid,
        syncType = wType,
        Data1 = dwData1,
        Data2 = dwData2,
        CurScore = llCurScore,
    }
    SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_SCORE_SYNC, _event)

    local ret = "UserScoreSync:" .. llCurScore
    return ret
end


function CMsgFish:onUserFireError( pData )
    local datalen = pData:getReadableSize()
    if 14 ~= datalen then
        return "error 200-118"
    end
    local _buffer = pData:readData(datalen)
    local	wErrorType    = _buffer:readUShort()
    local   dwBulletMul   = _buffer:readUInt()
	local	llCurScore    = _buffer:readLongLong()

    local nChairId = FishDataMgr:getInstance():getMeChairID()
    FishDataMgr:getInstance():exchangeFishScore(nChairId, llCurScore)

    local ret = "onUserFireError:" .. llCurScore
    return ret
end

-- CMD_S_CatchmonkeyfishGroup  77
function CMsgFish:onCatchFishGroup(pData)--200-108

    --数据/保存
    local count = 1
    local total = 0
    local totalScore = 0
    local chairID = FishDataMgr:getInstance():getChairIDByGuid(pData[1])
    local bombKindID = 0
    local bombFishID = 0
    local fish_kind  = nil
    local fish_id = pData[2]
    local pfish = FishDataMgr:getInstance():getFishByID(pData[2])
    if pfish then
        fish_kind = pfish:getFishKind()
        if fish_kind == 18 then
            fish_kind = 20
        end
    end

    if fish_kind then
        if fish_kind == FishKind.FISH_FOSHOU 
        or fish_kind == FishKind.FISH_BGLU 
        or fish_kind == FishKind.FISH_DNTG 
        or fish_kind == FishKind.FISH_YJSD 
        or fish_kind == FishKind.FISH_YSSN 
        or fish_kind == FishKind.FISH_PIECE then
            bombKindID = fish_kind -- 炸弹ID
            bombFishID = fish_id
            if bombKindID == FishKind.FISH_BGLU then
                local fish = FishDataMgr:getInstance():getFishByID(bombFishID)
                if fish ~= nil and fish:getFishTag() == 0 then -- 0表示忠义堂，不显示炸弹结算动画
                    bombKindID = 0
                    bombFishID = 0
                end
            end
        end
    end 

    for j = 1, count do
        local pCatchFishGroup = {}
        pCatchFishGroup.tick_count = os.time()
        pCatchFishGroup.chair_id = FishDataMgr:getInstance():getChairIDByGuid(pData[1])
        pCatchFishGroup.fish_count = #pData[3]
        total = total + pCatchFishGroup.fish_count
        pCatchFishGroup.catch_fish = {}
        for i = 1, total do
            local pfish = FishDataMgr:getInstance():getFishByID(pData[3][i][1])
            if pfish then
                pCatchFishGroup.catch_fish[i] = {}
                pCatchFishGroup.catch_fish[i].fish_id = pData[3][i][1]
                pCatchFishGroup.catch_fish[i].fish_kind = pfish:getFishKind()
                pCatchFishGroup.catch_fish[i].fish_score = pData[3][i][2]
                pCatchFishGroup.catch_fish[i].bullet_double = false
                pCatchFishGroup.catch_fish[i].link_fish_id = 0
                pCatchFishGroup.catch_fish[i].dead_index = (j - 1) * 3 + i  --鱼的死亡索引
            end
            totalScore = totalScore + pData[3][i][2]
        end
        pCatchFishGroup.bullet_id = 0
        FishDataMgr:getInstance():getCatchFishGroup(pCatchFishGroup)
    end

    if totalScore > 0 then
        FishDataMgr:getInstance():exchangeAddFishScore(chairID, totalScore)
    end
    
    if bombKindID > 0 and totalScore > 0 then
       local _event = {
            name = FishEvent.MSG_FISH_BOMB_EFFECT,
            ChairId = chairID,
            BombFishID = bombFishID,
            BombKindID = bombKindID,
            TotalScore = totalScore,
        }
        SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_BOMB_EFFECT, _event)
    end

    --日志
    local ret = "" --string.format("新鱼群[%d]", datalen / 77)
    if total > 1 then
        print(">>>>>>>>>>>>>>>>>>> fishgroup: " .. total )
    end

    return ret
end

-- CMD_S_BulletDoubleTimeout 2
function CMsgFish:onBulletDoubleTimeOut(pData)--200-104
    local datalen = pData:getReadableSize()
    if 2 ~= datalen then
        return "error 200-104"
    end
    local _buffer = pData:readData(datalen)

    --数据
    local nChairId = _buffer:readUShort()

    --日志
    local ret = string.format("%d", nChairId)

    --保存
    local bulletKind = FishDataMgr:getInstance():getbulletKindByIndex(nChairId)
    if bulletKind >= BulletKind.BULLET_KIND_1_ION then
        local kind = BulletKind[bulletKind-3+1]
        FishDataMgr:getInstance():setBulletKindByIndex(nChairId, kind)
    end

    --通知
    local _event = {
        name = FishEvent.MSG_FISH_DEL_BUFF,
        chairId = nChairId,
    }
    SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_DEL_BUFF, _event)

    return ret
end 

-- CMD_S_CatchFrogChain -- size 136
function CMsgFish:onCatchFishChain(pData) --200-107

    local body = pData

    --数据
    local pCatchChain = {}
    pCatchChain.chair_id = FishDataMgr:getInstance():getChairIDByGuid(body.uid)
    pCatchChain.fish_count = #body.fish
    pCatchChain.catch_fish = {}
    for i = 1, pCatchChain.fish_count do
        local fc = body.fish[i]
        pCatchChain.catch_fish[i] = {}
        pCatchChain.catch_fish[i].fish_id = fc[1]
        pCatchChain.catch_fish[i].fish_kind = 0
        pCatchChain.catch_fish[i].fish_score = fc[2]
        pCatchChain.catch_fish[i].bullet_double = false
        pCatchChain.catch_fish[i].link_fish_id = 0
    end
    pCatchChain.bullet_id = 0

    --日志
    local ret = string.format("id[%d]fish[%d]", pCatchChain.chair_id, pCatchChain.fish_count)

    --保存
    FishDataMgr:getInstance():onCatchFishChain(pCatchChain)

    return ret
end 

-- CMD_S_ExchangeFishScore size 18
function CMsgFish:getExchangeFishScore(pData) --200-102

    local datalen = pData:getReadableSize()
    if datalen ~= 18 then
        return "error 200-102"
    end
    local _buffer = pData:readData(datalen)

    --数据
    local pExchangeFishScore = {}
    pExchangeFishScore.chair_id = _buffer:readUShort()
    pExchangeFishScore.swap_fish_score = _buffer:readLongLong()
    pExchangeFishScore.exchange_fish_score = _buffer:readLongLong()

    --日志
    local nChairId = FishDataMgr:getInstance():getMeChairID()
    local ret = string.format("id[%d] score[%d]", nChairId, pExchangeFishScore.swap_fish_score)

    --保存
    FishDataMgr:getInstance():exchangeFishScore(pExchangeFishScore.chair_id, pExchangeFishScore.swap_fish_score)

    --通知
    local nChairId =FishDataMgr:getInstance():getMeChairID()
    if pExchangeFishScore.chair_id ~= nChairId and pExchangeFishScore.swap_fish_score ~= 0 then
        -- 上分，表示有玩家进入
        SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_ADD_PLAYER,  pExchangeFishScore.chair_id)
    end

    return ret
end 

-- struct CMD_S_UserFire size 27
function CMsgFish:getUserFire(pData) --200-103

    local datalen = pData:getReadableSize()
    if datalen ~= 27 then
        return "error 200-103"
    end
    local _buffer = pData:readData(datalen)

    --数据
    local pUserFire = {}
    pUserFire.tick_count = _buffer:readUInt()
    pUserFire.chair_id = _buffer:readUShort()
    pUserFire.bullet_id = _buffer:readInt()
    pUserFire.angle = _buffer:readFloat()
    pUserFire.bullet_double = _buffer:readBoolean()
    pUserFire.bullet_mulriple = _buffer:readInt()
    pUserFire.lock_fishid = _buffer:readInt()
    pUserFire.bullet_temp_id = _buffer:readInt()

    --日志
    local ret = 1 -- string.format("chair[%d]", pUserFire.chair_id)

    --保存
    FishDataMgr:getInstance():getUserFire(pUserFire)

    return ret
end 
  
-- struct CMD_S_SwitchScene size 8
function CMsgFish:getSwitchScene(pData) --200-106
    --数据
    local fishids = pData[1]
    local pathid = pData[3]
    local pswitchscene = {}
    pswitchscene.next_scene = pathid % 8
    pswitchscene.tick_count = os.time()
    pswitchscene.create_time = cc.exports.gettime()  --创建鱼阵的时间
    pswitchscene.fishids = fishids
    --保存
    FishDataMgr.getInstance():loadSwitchScene(pswitchscene)

    --日志
    local ret = ""
    return ret
end 

-- struct CMD_DistributemonkeyfishTeam size 300
function CMsgFish:onDistributeFishTeam(pData) --200-113
 
    local datalen = pData:getReadableSize()
    if 300 ~= datalen then
        return "error 200-113"
    end
    local _buffer = pData:readData(datalen)

    --数据
    local pDistributeFishTeam = {}
    pDistributeFishTeam.fish_team_type = _buffer:readInt()
    pDistributeFishTeam.fish_count = _buffer:readInt()
    pDistributeFishTeam.path_index = _buffer:readInt()
    pDistributeFishTeam.fish_kind = {}
    for i = 1, MAX_FISH_TEAM do
        pDistributeFishTeam.fish_kind[i] = _buffer:readInt()
    end
    pDistributeFishTeam.fish_id = {}
    for i = 1, MAX_FISH_TEAM do
        pDistributeFishTeam.fish_id[i] = _buffer:readInt()
    end
    pDistributeFishTeam.tag = {}
    for i = 1, MAX_FISH_TEAM do
        pDistributeFishTeam.tag[i] = _buffer:readInt()
    end
    pDistributeFishTeam.xOffset = {}
    for i = 1, MAX_FISH_TEAM do
        pDistributeFishTeam.xOffset[i] = _buffer:readInt()
    end
    --union 联合体，共用内存
    --pDistributeFishTeam.delayStep = {}
    --for i = 1, MAX_FISH_TEAM do
    --    pDistributeFishTeam.delayStep[i] = _buffer:readInt()
    --end
    pDistributeFishTeam.yOffset = {}
    for i = 1, MAX_FISH_TEAM do
        pDistributeFishTeam.yOffset[i] = _buffer:readInt()
    end

    --保存
    FishDataMgr:getInstance():onDistributeFishTeam(pDistributeFishTeam)

    --日志
    local ret = string.format("fihs[%d]", pDistributeFishTeam.fish_count)

    return ret
end 

-- struct CMD_DistributemonkeyfishCircle size 492
function CMsgFish:onDistributeFishCircle(pData) --200-114
    local datalen = pData:getReadableSize()
    if 492 ~= datalen then
        return "error 200-114"
    end
    local _buffer = pData:readData(datalen)

    --数据
    local pDistributeFishCircle = {}
    pDistributeFishCircle.fish_count = _buffer:readInt()-- 鱼的类型
    pDistributeFishCircle.xOffset = _buffer:readInt()-- 出生点的偏移
    pDistributeFishCircle.yOffset = _buffer:readInt()-- 出生点的偏移
    pDistributeFishCircle.fish_kind = {} -- 鱼群的类型
    for i = 1, MAX_FISH_CIRCLE do
        pDistributeFishCircle.fish_kind[i] = _buffer:readInt()
    end
    pDistributeFishCircle.fish_id = {} -- 鱼的ID
    for i = 1, MAX_FISH_CIRCLE do
        pDistributeFishCircle.fish_id[i] = _buffer:readInt()
    end
    pDistributeFishCircle.tag = {}
    for i = 1, MAX_FISH_CIRCLE do
        pDistributeFishCircle.tag[i] = _buffer:readInt()
    end
    pDistributeFishCircle.path_index = {} -- 鱼的路径ID
    for i = 1, MAX_FISH_CIRCLE do
        pDistributeFishCircle.path_index[i] = _buffer:readInt()
    end
    pDistributeFishCircle.fish_mulriple = {} -- 鱼的倍数 
    for i = 1, MAX_FISH_CIRCLE do
        pDistributeFishCircle.fish_mulriple[i] = _buffer:readInt()
    end

    --保存
    FishDataMgr:getInstance():onDistributeFishCircle(pDistributeFishCircle)

    --日志
    local ret = string.format("fish[%d]", pDistributeFishCircle.fish_count)
    return ret
end 

-- struct CMD_S_ReturnBulletScore size 12
function CMsgFish:onReturnBulletGold(pData) --200-115
    local datalen = pData:getReadableSize()
    if 12 ~= datalen then
        return "error 200-115"
    end
    local _buffer = pData:readData(datalen)

    --数据
    local pReturnBulletScore = {}
    pReturnBulletScore.chairid = _buffer:readUShort()
    pReturnBulletScore.wReason = _buffer:readUShort()
    pReturnBulletScore.llReturn = _buffer:readLongLong()

    --保存
    local chairID = pReturnBulletScore.chairid
    local score = pReturnBulletScore.llReturn
    if chairID ~= INVALID_CHAIR and score > 0 then
        -- 给玩家返回金币
        local curFishScore = FishDataMgr:getInstance():getFishScoreByIndex(chairID)
        FishDataMgr:getInstance():exchangeFishScore(chairID, curFishScore + score)
    end

    return ""
end

-- 发送 捕到鱼 消息 给服务器
function CMsgFish:sendCatchFish(tick_count,fish_id,bullet_id,bullet_temp_id)

--    local wb = WWBuffer:create()
--    wb:writeUInt(tick_count)
--    wb:writeInt(fish_id)
--    wb:writeInt(bullet_id)
--    wb:writeInt(bullet_temp_id)

--    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_CATCH_FISH, wb)
end

--玩家发炮请求
function CMsgFish:sendUserFire(angle,bullet_mulriple,lock_fishid,tick_count,bulletTempId)
--    local wb = WWBuffer:create()
--    wb:writeUInt(tick_count)
--    wb:writeFloat(angle)
--    wb:writeInt(lock_fishid)
--    wb:writeInt(bullet_mulriple)
--    wb:writeInt(bulletTempId)

--    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_USER_FIRE, wb)
end
--玩家发炮的信息数据，用来检测客户端数据是否正常
function CMsgFish:sendCheckUserInfo( chairID, curSocre )
--    local wb = WWBuffer:create()
--    wb:writeUShort(chairID)
--    wb:writeLongLong(curSocre)

--    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_USER_CUR_SCORE, wb)
end
-- 发送初始化金币 请求
function CMsgFish:sendExchangeFishScore(value)
    local msg = {}
    msg["type"] = "fish"
    msg["tag"] = "buy"
    msg["body"] = value
    local strvalue = cjson.encode(msg)
    self._gameFrame:sendSocketData(strvalue)
end

-- 发送同步场景鱼 请求
function CMsgFish:sendFishSync()
    --local wb = WWBuffer:create()
    --self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_USER_FISH_SYNC, wb)
end

function CMsgFish:sendUserReady()
    print("发送准备", os.date("%c"))
    local msg = {}
    msg["type"] = "game"
    msg["tag"] = "ready"
    local strvalue = cjson.encode(msg)
    self._gameFrame:sendSocketData(strvalue)
end

function CMsgFish:FireContinuously(op,uid,...)
    local msg = {}
    msg["type"] = "fish"
    msg["tag"] = "fire_continuously"
    local body = {0,op,uid,{...}}
    msg["body"] = body
    local strvalue = cjson.encode(msg)
    self._gameFrame:sendSocketData(strvalue)
end

function CMsgFish:HitContinuously(...)
    local msg = {}
    msg["type"] = "fish"
    msg["tag"] = "hit_continuously"
	local body = {...}
    msg["body"] = body
    local strvalue = cjson.encode(msg)
    self._gameFrame:sendSocketData(strvalue)
end

function CMsgFish:SwitchCannon(...)
    local msg = {}
    msg["type"] = "fish"
    msg["tag"] = "switch_cannon"
	local body = {...}
    msg["body"] = body
    local strvalue = cjson.encode(msg)
    self._gameFrame:sendSocketData(strvalue)
end

function CMsgFish:setGameFrame(frameEngine)
   self._gameFrame = frameEngine
end

return CMsgFish
-- endregion
