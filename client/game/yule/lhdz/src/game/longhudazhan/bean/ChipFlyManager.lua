--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--[[
    筹码显示业务
    1 上桌玩家筹码必须完整显示，不可隐藏，显示优先级值=CHIP_VIEWSORT_HIGH  = 1
    2 自己投注筹码必须完整显示，不可隐藏，显示优先级值=CHIP_VIEWSORT_HIGH = 1
    3 其他玩家筹码，若有坐标重叠，可隐藏，显示优先级值=CHIP_VIEWSORT_LOW  = 2
    4 被覆盖筹码显示优先级值高于覆盖筹码，则直接隐藏
    5 被覆盖筹码显示优先级值低于覆盖筹码，则两个都显示
]]--

local Lhdz_Res       = require("game.yule.lhdz.src.game.longhudazhan.scene.Lhdz_Res")
local CBetManager    = require("game.yule.lhdz.src.models.CBetManager")
local Lhdz_Const     = require("game.yule.lhdz.src.game.longhudazhan.scene.Lhdz_Const")
local LhdzDataMgr    = require("game.yule.lhdz.src.game.longhudazhan.manager.LhdzDataMgr")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local CHIP_FLY_STEPDELAY   = 0.02 --筹码连续飞行间隔
local CHIP_FLY_TIME        = 0.16 --飞筹码动画时间
local CHIP_JOBSPACETIME    = 0.16 --飞筹码任务队列间隔
local CHIP_FLY_SPLIT       = 20   --飞行筹码分组 分XX次飞完
local CHIP_VIEWSORT_HIGH   = 1    --筹码显示优先级高
local CHIP_VIEWSORT_LOW    = 2    --筹码显示优先级低
local CHIP_SCALE_TABLEVIEW = 0.50 --筹码在桌上显示比例
local CHIP_MAXROTATION     = 45 --筹码在桌上显示角度最大值

local ChipFlyManager = class("ChipFlyManager")

ChipFlyManager.instance = nil
function ChipFlyManager.getInstance()
    if ChipFlyManager.instance == nil then  
        ChipFlyManager.instance = ChipFlyManager.new()
    end  
    return ChipFlyManager.instance  
end

function ChipFlyManager.releaseInstance()
    ChipFlyManager.instance = nil
end

function ChipFlyManager:ctor()
    self:init()
end

function ChipFlyManager:init()
    self.m_chairId          = PlayerInfo.getInstance():getChairID()
    self.m_userId           = PlayerInfo.getInstance():getUserID()
    self.m_chipNode         = nil
    self.m_chipAreaVec      = {} --投注区域rect数组
    self.m_randmChipSelf    = {} --自己的随机筹码投注区
    self.m_randmChipOthers  = {} --其他玩家的随机筹码投注区
    self.m_bankerPos        = cc.p(0, 0)
    self.m_selfPos          = cc.p(0, 0)
    self.m_otherPos         = cc.p(0, 0)
    self.m_tableUserPosVec  = {}
    self.m_totalCount       = 0
    self.m_isPlayEffect     = {false, false, false, false, false, false} --上桌玩家是否正在播放获取筹码动画
end

--设置需要的参数
function ChipFlyManager:setData(data)
    self.m_chipNode = data.chipNode
    self.m_chipAreaVec = data.chipAreaVec
    self.m_bankerPos = data.bankerPos
    self.m_selfPos = data.selfPos
    self.m_otherPos = data.otherPos
    self.m_chipPosVec = data.chipPosVec
    self.m_tableUserPosVec = data.tableUserPos
    self.m_getChipEffect = data.getChipEffect
end

--清理所有筹码
function ChipFlyManager:clearAllChip()
    self.m_chipNode:stopAllActions()
    print("投注累计飞行筹码:" .. self.m_totalCount)
    print("节点显示筹码:" .. #self.m_chipNode:getChildren())
    self.m_totalCount = 0
    for _, v in pairs(self.m_chipNode:getChildren()) do
        self:removeJettonSprite(v)
    end
    for i = 1, 3 do
        self.m_randmChipSelf[i] = {}
        self.m_randmChipOthers[i] = {}
    end
end

--重置筹码投注区
function ChipFlyManager:resetChipPosArea()
    local offset = 8
    local cfg = {
        {row = 5, col = 7}, --龙
        {row = 5, col = 7}, --虎
        {row = 4, col = 6}, --和
    }
    for i = 1, 3 do
        self.m_randmChipSelf[i] = {
            idx = 1, -- pos点的索引，原则上按递增方式取点，保证首次最大化铺满区域，然后随机取点
            vec = self:getRandomChipPosVec(self.m_chipAreaVec[i], cfg[i].row, cfg[i].col, offset)
        }
        self.m_randmChipOthers[i] = {
            idx = 1,
            vec = self:getRandomChipPosVec(self.m_chipAreaVec[i], cfg[i].row, cfg[i].col, offset)
        }
    end
end

--创建静态放置筹码
function ChipFlyManager:createStaticChip(wJettonIndex, wAreaIndex, dwUserID)
    local chipVec = {}
    local posIdx = -1
    local userIndex = LhdzDataMgr.getInstance():getUserByUserId(dwUserID)
    local viewSort = userIndex > -1 and CHIP_VIEWSORT_HIGH or CHIP_VIEWSORT_LOW

    if dwUserID == self.m_userId then
        chipVec = self.m_randmChipSelf[wAreaIndex]
        posIdx = self:getChipEndPositionIdx(wAreaIndex, true)
    else
        chipVec = self.m_randmChipOthers[wAreaIndex]
        posIdx = self:getChipEndPositionIdx(wAreaIndex, false)
    end

    --按显示优先级处理已显示筹码
    if CHIP_VIEWSORT_HIGH == viewSort then
        for i = #chipVec.vec[posIdx].chips, 1, -1 do
            --低优先级的直接删除
            if CHIP_VIEWSORT_LOW == chipVec.vec[posIdx].chips[i].viewSort then
                self:removeJettonSprite(chipVec.vec[posIdx].chips[i].pChipSpr)
                table.remove(chipVec.vec[posIdx].chips, i)
            end
        end
    else
        --在低优先级显示的情况下，如果坐标位已经有筹码了，则不再显示
        if #chipVec.vec[posIdx].chips > 0 then
            return
        end
    end

    local pSpJetton = self:createJettonSprite(wJettonIndex)
    if not pSpJetton then return end
    pSpJetton:setPosition(chipVec.vec[posIdx].pos)

    --保存显示筹码信息
    local chipInfo = {}
    chipInfo.wAreaIndex = wAreaIndex
    chipInfo.wJettonIndex = wJettonIndex
    chipInfo.pChipSpr = pSpJetton
    chipInfo.userIndex = userIndex
    chipInfo.viewSort = viewSort

    chipVec.vec[posIdx].chips[#chipVec.vec[posIdx].chips + 1] = chipInfo
end

--创建下注筹码飞向投注区
function ChipFlyManager:playFlyJettonToBetArea(wJettonIndex, wAreaIndex, wChairID)
    local pSpJetton = self:createJettonSprite(wJettonIndex)
    if not pSpJetton then
        print("筹码创建失败")
        return
    end

    pSpJetton:setScale(CHIP_SCALE_TABLEVIEW - 0.15)

    self.m_totalCount = self.m_totalCount + 1

    local chipVec = {}
    local posIdx = -1
--    local tableID = PlayerInfo:getInstance():getTableID()
--    local userid = CUserManager:getInstance():getUserIDByChairID2(tableID, wChairID)
    local userIndex = LhdzDataMgr.getInstance():getUserByUserId(wChairID)
    local viewSort = userIndex > -1 and CHIP_VIEWSORT_HIGH or CHIP_VIEWSORT_LOW

    if wChairID == self.m_chairId then
        chipVec = self.m_randmChipSelf[wAreaIndex]
        posIdx = self:getChipEndPositionIdx(wAreaIndex, true)
    else
        chipVec = self.m_randmChipOthers[wAreaIndex]
        posIdx = self:getChipEndPositionIdx(wAreaIndex, false)
    end

    --低优先级的准备删除
    local delVec = {}
    for i = #chipVec.vec[posIdx].chips, 1, -1 do
        if CHIP_VIEWSORT_LOW == chipVec.vec[posIdx].chips[i].viewSort then
            delVec[#delVec + 1] = chipVec.vec[posIdx].chips[i]
            table.remove(chipVec.vec[posIdx].chips, i)
        end
    end

    --保存筹码信息
    local chipInfo = {}
    chipInfo.wAreaIndex = wAreaIndex
    chipInfo.wJettonIndex = wJettonIndex
    chipInfo.pChipSpr = pSpJetton
    chipInfo.userIndex = userIndex
    chipInfo.viewSort = viewSort

    chipVec.vec[posIdx].chips[#chipVec.vec[posIdx].chips + 1] = chipInfo

    --飞行
    local endPos = chipVec.vec[posIdx].pos
    local beginPos = nil
    if wChairID == PlayerInfo.getInstance():getChairID() then
        beginPos = self.m_chipPosVec[wJettonIndex]
    elseif -1 == userIndex then
        beginPos = self.m_otherPos
    else
        beginPos = self.m_tableUserPosVec[userIndex]
    end

    pSpJetton:setPosition(beginPos)

    local moveTo = cc.MoveTo:create(0.2 , endPos)
    local callBack = cc.CallFunc:create(function()
            for i = 1, #delVec do
                self:removeJettonSprite(delVec[i].pChipSpr)
            end
        end)
    local scaleAnim1 = cc.ScaleTo:create(0.2, CHIP_SCALE_TABLEVIEW + 0.05)
    local spawn = cc.Spawn:create(moveTo, scaleAnim1)
    local scaleAnim2 = cc.ScaleTo:create(0.15, CHIP_SCALE_TABLEVIEW)
    local seq = cc.Sequence:create(spawn, scaleAnim2, callBack)
    pSpJetton:runAction(seq)

end

-- 创建筹码
function ChipFlyManager:createJettonSprite(wJettonIndex)
    local score = CBetManager.getInstance():getJettonScore(wJettonIndex)
--    if score == 1 then score = 1
--    elseif score == 50 then score = 10
--    elseif score == 100 then score = 50
--    elseif score == 500 then score = 100
----    elseif score == 100 then score = 50000
----    elseif score == 500 then score = 100000
--    end
    local pSpJetton = cc.Sprite:createWithSpriteFrameName(string.format(Lhdz_Res.PNG_OF_JETTON, score))
    if not pSpJetton then return end
    pSpJetton:setScale(CHIP_SCALE_TABLEVIEW)
    self.m_chipNode:addChild(pSpJetton,1)

    local randomRotation = math.random(0, CHIP_MAXROTATION * 2) - CHIP_MAXROTATION
    pSpJetton:setRotation(randomRotation)

    return pSpJetton
end

--删除筹码
function ChipFlyManager:removeJettonSprite(sp)
    sp:removeFromParent()
end

-- 获取区域范围内指定数量的随机下注点
-- rect cc.rect矩形范围
-- rowNum 显示多少行筹码 以能相互覆盖到为标准
-- colNum 显示多少列筹码 以能相互覆盖到为标准
-- offset 允许的随机偏移量
-- 返回值为筹码放置对象集合
function ChipFlyManager:getRandomChipPosVec(rect, rowNum, colNum, offset)
    local rowStep = (math.floor(rect.height*100 / (rowNum + 1))) / 100
    local colStep = (math.floor(rect.width*100 / (colNum + 1))) / 100

    -- 计算逻辑矩形中总的筹码放置位置
    local chipPosVec = {}
    for m = 1, rowNum do
        for n = 1, colNum do
            local randx = (math.random(-offset*100, offset*100)) / 100
            local randy = (math.random(-offset*100, offset*100)) / 100
            local posx = rect.x + n*colStep + randx
            local posy = rect.y + m*rowStep + randy
            --[[
                {
                    pos = cc.p(), 筹码坐标
                    chips = {}, 此坐标上的筹码列表
                }
            ]]--
            table.insert(chipPosVec, {pos = cc.p(posx, posy), chips = {}})
        end
    end

    -- 乱序排列
    local count = #chipPosVec

    for i = 1, count do
        local tmp = math.random(i, count)
        chipPosVec[i], chipPosVec[tmp] = chipPosVec[tmp], chipPosVec[i]
    end

    return chipPosVec
end

--获取投注筹码动画落点坐标索引
function ChipFlyManager:getChipEndPositionIdx(areaIndex, isSelf)
    --[[
        坐标位索引选择依次加一
        所有坐标位都已经有了筹码显示，则随机选择一个坐标位
    ]]--
    local idx = 0
    if isSelf then
        if self.m_randmChipSelf[areaIndex].idx > #self.m_randmChipSelf[areaIndex].vec then
            idx = math.random(1, #self.m_randmChipSelf[areaIndex].vec)
        else
            idx = self.m_randmChipSelf[areaIndex].idx
            self.m_randmChipSelf[areaIndex].idx = idx + 1
        end
    else
        if self.m_randmChipOthers[areaIndex].idx > #self.m_randmChipOthers[areaIndex].vec then
            idx = math.random(1, #self.m_randmChipOthers[areaIndex].vec)
        else
            idx = self.m_randmChipOthers[areaIndex].idx
            self.m_randmChipOthers[areaIndex].idx = idx + 1
        end
    end
    return idx
end

--获取一个随机落点
function ChipFlyManager:getRandomChipEndPosition(areaIndex, isSelf)
    if isSelf then
        local idx = math.random(1, #self.m_randmChipSelf[areaIndex].vec)
        return self.m_randmChipSelf[areaIndex].vec[idx].pos
    else
        local idx = math.random(1, #self.m_randmChipOthers[areaIndex].vec)
        return self.m_randmChipOthers[areaIndex].vec[idx].pos
    end    
end

function ChipFlyManager:doSomethingLater(call, delay, ...)
    self.m_chipNode:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(call, {...})))
end

--以队列方式进行飞筹码
function ChipFlyManager:flychipex(cbFun)
    self.m_isPlayEffect = {false, false, false, false, false, false}
    local bankerwinvec = {}                       --庄家赢取的筹码
    local bankerlostvec = {}                      --庄家赔付筹码
    local selfwinvec = {}                         --自己赢取的筹码
    local tablewinvec = {}                        --上桌玩家赢取的筹码
    local otherwinvec = {}                        --其他人赢取的筹码
    local bankerwin = false
    local bankerlose = false
    local otherwin = false
    local selfwin = false

    --初始化
    for i =1, 6 do
        tablewinvec[i] = {}
        for j = 1, 3 do
            tablewinvec[i][j] = {}
        end
    end

    for i = 1, 3 do
        bankerwinvec[i] = {}
        bankerlostvec[i] = {}
        selfwinvec[i] = {}
        otherwinvec[i] = {}
    end


    --[[
    local chipInfo = {}
    chipInfo.wAreaIndex = wAreaIndex
    chipInfo.wJettonIndex = wJettonIndex
    chipInfo.pChipSpr = pSpJetton
    chipInfo.userIndex = userIndex
    chipInfo.viewSort = viewSort
    ]]--
    local _idx = 0
    local _endpos = cc.p(0, 0)
    local nAreaType = LhdzDataMgr.getInstance():getAreaType() --获胜区域

    for i = 1, 3 do
        --自己的押注
        for _, v in pairs(self.m_randmChipSelf[i].vec) do
            for _, info in pairs(v.chips) do
                if info.wAreaIndex == nAreaType then --押中了
                    local count = 1
                    if nAreaType == Lhdz_Const.AREA.DRAW then
                        count = 8 -- 平局返还8倍
                    end
                    for i=1, count do
                        local bankerJetton = self:createJettonSprite(info.wJettonIndex)
                        bankerJetton:setPosition(self.m_bankerPos)
                        bankerJetton:setVisible(false)
                        _endpos = self:getRandomChipEndPosition(info.wAreaIndex, true)
                        table.insert( bankerlostvec[info.wAreaIndex], { sp = bankerJetton, endpos = _endpos}) --庄家赔付
                        table.insert( selfwinvec[info.wAreaIndex], { sp = bankerJetton, endpos = self.m_selfPos}) --自己赢取
                    end
                    table.insert( selfwinvec[info.wAreaIndex], { sp = info.pChipSpr, endpos = self.m_selfPos}) --自己本身的拿回
                    bankerlose = true
                    selfwin = true
                else --没押中
                    if nAreaType == Lhdz_Const.AREA.DRAW then --开了平，拿回押注
                        table.insert( selfwinvec[info.wAreaIndex], { sp = info.pChipSpr, endpos = self.m_selfPos}) --拿回自己的押注
                        selfwin = true
                    else --完全没中，筹码庄家收走
                        table.insert( bankerwinvec[info.wAreaIndex], { sp = info.pChipSpr, endpos = self.m_bankerPos}) --庄家赢取
                        bankerwin = true
                    end
                end
            end
        end

        --其他人的押注
        for _, v in pairs(self.m_randmChipOthers[i].vec) do
            for _, info in pairs(v.chips) do
                local endPos = info.userIndex > 0 and self.m_tableUserPosVec[info.userIndex] or self.m_otherPos
                if info.wAreaIndex == nAreaType then
                    local count = 1
                    if nAreaType == Lhdz_Const.AREA.DRAW then
                        count = 8 -- 平局返还8倍
                    end
                    for i=1, count do
                        local bankerJetton = self:createJettonSprite(info.wJettonIndex)
                        bankerJetton:setPosition(self.m_bankerPos)
                        bankerJetton:setVisible(false)
                        _endpos = self:getRandomChipEndPosition(info.wAreaIndex, false)
                        table.insert( bankerlostvec[info.wAreaIndex], { sp = bankerJetton, endpos = _endpos}) --庄家赔付
                        table.insert( otherwinvec[info.wAreaIndex], { sp = bankerJetton, endpos = endPos, playeffect = true, userindex = info.userIndex})
                    end
                    table.insert( otherwinvec[info.wAreaIndex], { sp = info.pChipSpr, endpos = endPos, playeffect = true, userindex = info.userIndex})
                    bankerlose = true
                    otherwin = true
                else
                    if nAreaType == Lhdz_Const.AREA.DRAW then
                        table.insert( otherwinvec[info.wAreaIndex], { sp = info.pChipSpr, endpos = endPos, playeffect = true, userindex = info.userIndex})
                        otherwin = true
                    else
                        table.insert( bankerwinvec[info.wAreaIndex], { sp = info.pChipSpr, endpos = self.m_bankerPos}) --庄家赢取
                        bankerwin = true
                    end
                end
            end
        end
    end

    -- 庄家获取筹码
    local jobitem1 = {
        flytime       = CHIP_FLY_TIME,                                -- 飞行时间
        flytimedelay  = false,                                        -- 飞行时间延长随机时间(0.05~0.15)
        flysteptime   = CHIP_FLY_STEPDELAY,                           -- 筹码队列飞行间隔
        nextjobtime   = CHIP_JOBSPACETIME,                            -- 下个任务执行间隔时间
        chips         = bankerwinvec,                                 -- 筹码队列集合 二维数组[下注区域索引][筹码对象引用]
        scaleinfo     = { beginVal = -1, endVal = 0.35 },             -- 筹码飞行中缩放变化
        preCB         = function()                                    -- 任务开始时执行的回调，此回调根据preCBExec控制只执行一次
                            if bankerwin then
                                ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_RESULT_JETTON)
                            end
                        end,
        preCBExec     = false,
        --overCB        = function() print("庄家获胜筹码飞行完毕") end, -- 动画任务完成后回调
        hideAfterOver = true                                          -- 动画完成后隐藏
    }

    -- 庄家赔付筹码
    local jobitem2 = {
        flytime       = CHIP_FLY_TIME,
        flysteptime   = CHIP_FLY_STEPDELAY,
        nextjobtime   = CHIP_JOBSPACETIME,
        chips         = bankerlostvec,
        scaleinfo     = { beginVal = 0.35, endVal = CHIP_SCALE_TABLEVIEW },
        preCB         = function()
                            if bankerlose then
                                ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_RESULT_JETTON)
                            end
                        end,
        --overCB        = function() print("庄家赔付筹码飞行完毕") end,
        hideAfterOver = false
    }

    -- 其他人赢得的筹码
    local jobitem3 = {
        flytime       = CHIP_FLY_TIME + 0.1,
        flysteptime   = CHIP_FLY_STEPDELAY,
        nextjobtime   = CHIP_JOBSPACETIME,
        chips         = otherwinvec,
        scaleinfo     = { beginVal = -1, endVal = 0.35 },
        preCB         = function()
                            if otherwin then
                                ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_RESULT_JETTON)
                            end
                        end,
        preCBExec     = false,
        --overCB        = function() print("其他人获胜筹码飞行完毕") end,
        hideAfterOver = true
    }

    -- 自己赢得的筹码
    local jobitem4 = {
        flytime       = CHIP_FLY_TIME + 0.1,
        flytimedelay  = true,                                        -- 飞行时间延长随机时间(0.05~0.15)
        flysteptime   = 0.01,
        nextjobtime   = CHIP_JOBSPACETIME,
        chips         = selfwinvec,
        scaleinfo     = { beginVal = -1, endVal = 0.35 },
        preCB         = function()
                            if selfwin then
                                ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_RESULT_JETTON)
                            end
                        end,
        preCBExec     = false,
        --overCB        = function() print("自己获胜筹码飞行完毕") end,
        hideAfterOver = true
    }

    self.m_flyJobVec = {}
    self.m_flyJobVec.nIdx = 1 -- 任务处理索引
    self.m_flyJobVec.flyIdx = 1 -- 飞行队列索引
    self.m_flyJobVec.jobVec = {} -- 任务对象
    self.m_flyJobVec.overCB = function()
        print("所有飞行任务执行完毕")
        self.m_flyJobVec = {}
        if cbFun then 
            cbFun() 
        end
        print("飞行筹码数量:" .. self.flycount)
        print("==================================节点筹码总量:==================================" .. #self.m_chipNode:getChildren())
    end

    table.insert(self.m_flyJobVec.jobVec, { jobitem1 }) -- 1 飞行庄家获取筹码
    table.insert(self.m_flyJobVec.jobVec, { jobitem2 }) -- 2 飞行庄家赔付筹码
    table.insert(self.m_flyJobVec.jobVec, { jobitem3, jobitem4 }) -- 3 其他人筹码和自己筹码一起飞行

    self.flycount = 0
    self:doFlyJob()
end

--执行单个的飞行任务
function ChipFlyManager:doFlyJob()
    -- 全部任务执行完成之前，被清理重置
    if nil == self.m_flyJobVec.nIdx or nil == self.m_flyJobVec.jobVec then return end

    -- 任务处理完了
    if self.m_flyJobVec.nIdx > #self.m_flyJobVec.jobVec then
        if self.m_flyJobVec.overCB then
            self.m_flyJobVec.overCB()
        end
        return
    end

    -- 取出一个当前需要处理的飞行任务
    local job = self.m_flyJobVec.jobVec[self.m_flyJobVec.nIdx]
    if not job then return end
    if 0 == #job then return end

    -- 按队列取出需要飞行的对象进行动画处理
    local flyvec = {}
    local mf = math.floor
    if self.m_flyJobVec.flyIdx <= CHIP_FLY_SPLIT then
        for i = 1, #job do
            if job[i] then
                if job[i].preCB and (not job[i].preCBExec) then
                    job[i].preCB()
                    job[i].preCBExec = true
                end
                for j = 1, #job[i].chips do
                    local segnum = mf(#job[i].chips[j] / CHIP_FLY_SPLIT) -- 计算需要分成几段
                    for m = 0, segnum do
                        local tgg = job[i].chips[j][m*CHIP_FLY_SPLIT + self.m_flyJobVec.flyIdx]
                        if tgg then
                            table.insert(flyvec, { sptg = tgg, idx = i })
                        end                    
                    end
                end
            end
        end
    end

    -- 当前队列都飞完了
    if 0 == #flyvec then
        -- 下个任务的执行
        self.m_flyJobVec.nIdx = self.m_flyJobVec.nIdx + 1
        self.m_flyJobVec.flyIdx = 1
        self:doSomethingLater(function ()
            for i = 1, #job do
                if job[i].overCB then job[i].overCB() end
            end
            self:doFlyJob()
        end , job[1].nextjobtime) -- 多个任务时 取第一个任务的时间
        return
    end

    -- 开始飞筹码
    for i = 1, #flyvec do
        local tg = flyvec[i]
        if tg and tg.sptg then
            local ts = job[tg.idx].flytimedelay and job[tg.idx].flytime + math.random(5,15) / 100 or job[tg.idx].flytime
            local mt = cc.MoveTo:create(ts, tg.sptg.endpos)
            if i == #flyvec then -- 最后一个筹码飞行完成后执行下一次的飞行回调
                self.m_flyJobVec.flyIdx = self.m_flyJobVec.flyIdx + 1
                self:doSomethingLater(function ()
                    self:doFlyJob()
                end , job[tg.idx].flysteptime)
            end

            if tolua.isnull(tg.sptg.sp) then
                return
            end

            local seqActions = {}
            seqActions[1] = cc.Show:create()
            if job[tg.idx].scaleinfo then
                if job[tg.idx].scaleinfo.beginVal > 0 then
                    tg.sptg.sp:setScale(job[tg.idx].scaleinfo.beginVal)
                end
                if job[tg.idx].scaleinfo.endVal > 0 then
                    seqActions[#seqActions + 1] = cc.Spawn:create( mt, cc.ScaleTo:create(ts, job[tg.idx].scaleinfo.endVal))
                end
            else
                seqActions[#seqActions + 1] = mt
            end

            if job[tg.idx].hideAfterOver then
                seqActions[#seqActions + 1] = cc.Hide:create()
                self.flycount = self.flycount + 1
            end

            --playeffect = true, userindex = info.userIndex
--            if tg.sptg.playeffect and tg.sptg.userindex > 0 then
--                seqActions[#seqActions + 1] = cc.CallFunc:create(
--                    function()
--                        if not self.m_isPlayEffect[tg.sptg.userindex] then
--                            self.m_isPlayEffect[tg.sptg.userindex] = true
--                            if not self.m_getChipEffect[tg.sptg.userindex]:isVisible() then
--                                self.m_getChipEffect[tg.sptg.userindex]:setVisible(true)
--                                self.m_getChipEffect[tg.sptg.userindex]:setAnimation(0, "animation", true)
--                                self.m_getChipEffect[tg.sptg.userindex]:registerSpineEventHandler(function(event)
--                                    self.m_getChipEffect[tg.sptg.userindex]:setVisible(false)
--                                end, sp.EventType.ANIMATION_COMPLETE)
--                            end
--                        end
--                    end
--                )
--            end

            tg.sptg.sp:runAction(cc.Sequence:create(seqActions))
        end
    end
end

return ChipFlyManager

--endregion
