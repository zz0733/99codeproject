--region TigerDataMgr.lua
--Date 2017.11.10
--Auther JackyXu.
--Desc 水果老虎机数据管理类.
local module_pre = "game.yule.jxlw.src.views"

local Player = cc.exports.PlayerInfo
local TigerConst        = require(module_pre..".scene.Tiger_Const")
local vecCardLineDate   = TigerConst.vecCardLineDate -- 线数数据)
local JXLW_FreeMultiple       = appdf.req(module_pre .. ".rewardTable.JXLW_FreeMultiple")
local Tiger_Events          = require(module_pre..".manager.Tiger_Events")

local TigerDataMgr = class("TigerDataMgr")

TigerDataMgr.instance_ = nil
function TigerDataMgr:getInstance()
    if TigerDataMgr.instance_ == nil then
        TigerDataMgr.instance_ = TigerDataMgr.new()
    end
    return TigerDataMgr.instance_
end
function TigerDataMgr:releaseInstance()
    TigerDataMgr.instance_ = nil
end
function TigerDataMgr:ctor()
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    self:Clear()
end

function TigerDataMgr:Clear()
    self.m_nMinBetNum = 1              -- 底注值
    self.m_nBetNumIndex = 1            -- 底注倍数
    self.m_nLineNum = 1                -- 压线数
    self.m_nLastBetNumIndex = 0        -- 中断断线重连用
    self.m_nLastLineNum = 0            -- 中断断线重连用
    self.m_bIsAuto = false             -- 是否自动
    self.m_bIsShowLine = false         -- 是否显示线
    self.m_nTigerState = TigerConst.GAME_TIGER_FREE    -- 游戏状态
    self.m_lLastPrizePool = 0          -- 上一轮奖池
    self.m_lPrizePool = 0              -- 奖池
    self.m_lAllBetWinGold = 0          -- 累计押中
    self.m_nFreeTimes = 0              -- 免费次数
    self.m_nTempFreeTimes = 0          -- 免费次数
    self.m_nExtraTimes = 0             -- 额外倍数
    self.m_lWinPrizeGold = 0           -- 中奖彩金数量

    self.m_stuGameResult = {            -- 开奖结果
        llResult = 0,
        llResultMoney = 0,              --结算后余额
        cbCardIndex = {},
    }
    self.m_stuGameReusltLast = {        -- 上期开奖结果
        llResult = 0,
        llResultMoney = 0,
        cbCardIndex = {},
    }
    self:resetGameResult()
    self.m_stuGameOtherPlayers = {      -- 其他玩家列表(chairId)
        chairId = {0,0,0,0}
    }
    self.freeResultTable = {}
    self.freeTimesMoney = 0
end

function TigerDataMgr:resetData()
    self.m_nMinBetNum = 1
    self.m_nBetNumIndex = 1
    self.m_nLineNum = 1
    self.m_bIsAuto = false
    self.m_nTigerState = TigerConst.GAME_TIGER_FREE
    self.m_lPrizePool = 0
    self.m_lAllBetWinGold = 0
    self.m_nFreeTimes = 0
    self.m_nTempFreeTimes = 0
    self.m_nExtraTimes = 0
    self.m_lWinPrizeGold = 0
    
    self.m_stuGameResult = {
        llResultMoney = 0,
        llResult = 0,
        cbCardIndex = {},
    }
    self.m_stuGameReusltLast = {
        llResultMoney = 0,
        llResult = 0,
        cbCardIndex = {},
    }
    self:resetGameResult()
end

-- 底注值
function TigerDataMgr:setMinBetNum(nNum)
    self.m_nMinBetNum = nNum
end
function TigerDataMgr:getMinBetNum()
    return self.m_nMinBetNum
end

-- 底注倍数
function TigerDataMgr:setBetNumIndex(nIndex)
    self.m_nBetNumIndex = nIndex
end
function TigerDataMgr:getBetNumIndex()
    return self.m_nBetNumIndex
end

function TigerDataMgr:setLastBetNumIndex(nIndex)
    self.m_nLastBetNumIndex = nIndex
end
function TigerDataMgr:getLastBetNumIndex()
    return self.m_nLastBetNumIndex
end

-- 压线数
function TigerDataMgr:setLineNum(nNum)
    self.m_nLineNum = nNum
end
function TigerDataMgr:getLineNum()
    return self.m_nLineNum
end

function TigerDataMgr:setLastLineNum(nNum)
    self.m_nLastLineNum = nNum
end
function TigerDataMgr:getLastLineNum()
    return self.m_nLastLineNum
end

-- 是否自动
function TigerDataMgr:setIsAuto(bIsAuto)
    self.m_bIsAuto = bIsAuto
end
function TigerDataMgr:getIsAuto()
    return self.m_bIsAuto
end

-- 是否显示线
function TigerDataMgr:setIsShowLine(bIsShow)
    self.m_bIsShowLine = bIsShow
end
function TigerDataMgr:getIsShowLine()
    return self.m_bIsShowLine
end

-- 游戏状态
function TigerDataMgr:setTigerState(nState)
    self.m_nTigerState = nState
end
function TigerDataMgr:getTigerState()
    return self.m_nTigerState
end

-- 上一轮奖池
function TigerDataMgr:setLastPrizePool(nPrizePool)
    self.m_lLastPrizePool = nPrizePool
end
function TigerDataMgr:getLastPrizePool()
    return self.m_lLastPrizePool
end

-- 奖池
function TigerDataMgr:setPrizePool(nPrizePool)
    self.m_lPrizePool = nPrizePool
end
function TigerDataMgr:getPrizePool()
    return self.m_lPrizePool
end

-- 累计押中
function TigerDataMgr:setAllBetWinGold(nWinGold)
    self.m_lAllBetWinGold = nWinGold
end
function TigerDataMgr:getAllBetWinGold()
    return self.m_lAllBetWinGold
end

-- 免费次数
function TigerDataMgr:setFreeTimes(nTimes)
    self.m_nFreeTimes = nTimes
end
function TigerDataMgr:getFreeTimes()
    return self.m_nFreeTimes
end
function TigerDataMgr:setTempFreeTimes(nTimes)
    self.m_nTempFreeTimes = nTimes
end
function TigerDataMgr:getTempFreeTimes()
    return self.m_nTempFreeTimes
end

-- 额外倍数
function TigerDataMgr:setExtraTimes(nTimes)
    self.m_nExtraTimes = nTimes
end
function TigerDataMgr:getExtraTimes()
    return self.m_nExtraTimes
end

-- 中奖彩金数量
function TigerDataMgr:setWinPrizeGold(nWinGold)
    self.m_lWinPrizeGold = nWinGold
end
function TigerDataMgr:getWinPrizeGold()
    return self.m_lWinPrizeGold
end

-- 其他玩家列表
function TigerDataMgr:setGameOtherPlayers(vecOtherPlayers)
    self.m_stuGameOtherPlayers = table.copy(vecOtherPlayers)
end
function TigerDataMgr:getGameOtherPlayers()
    return self.m_stuGameOtherPlayers
end

-- 游戏结果
function TigerDataMgr:setGameResult(vecGameRes)
    self.m_stuGameReusltLast = self.m_stuGameResult
    self.m_stuGameResult = vecGameRes
end

--随机重置开奖结果
function TigerDataMgr:resetGameResult()
    for i=1, TigerConst.CARD_INDEX do
        self.m_stuGameResult.cbCardIndex[i] = math.random(1, 15)%14+1
        self.m_stuGameReusltLast.cbCardIndex[i] = math.random(1, 15)%14+1
    end

    --控制前两列不出现重复的图案且第二列不出现bar(11)
    local indexVec = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14}
    for i = 1, 13 do
        local tmp = math.random(i, 13)
        indexVec[i], indexVec[tmp] = indexVec[tmp], indexVec[i]
    end

    --[[
        1  2  3  4  5
        6  7  8  9  10
        11 12 13 14 15
    ]]--
    local count = 0 --钻石出现的数量
    local colIdx = {1, 6, 11,
                    2, 7, 12,
                    3, 8, 13,
                    4, 9, 14,
                    5, 10, 15}
    for i = 1, 6 do
        self.m_stuGameResult.cbCardIndex[colIdx[i]] = indexVec[i]
        if 12 == indexVec[i] then
            count = count + 1
        end
        self.m_stuGameReusltLast.cbCardIndex[colIdx[i]] = indexVec[i + 6]
    end

    --最多只能出现2个钻石(12)
    for i = 7, 15 do
        if 12 == self.m_stuGameResult.cbCardIndex[colIdx[i]] then
            if 2 == count then
                self.m_stuGameResult.cbCardIndex[colIdx[i]] = indexVec[math.random(1, 10)]
            else
                count = count + 1
            end
        end
    end
end

function TigerDataMgr:getGameResult()
    return self.m_stuGameResult
end
function TigerDataMgr:getGameResultLast()
    return self.m_stuGameReusltLast
end

--获取线上牌子数
function TigerDataMgr:GetLineTypeCount(nLineIndex)
    local nCardCount = TigerConst.LINE_CARD_COUNT
    local vecResultCardIndex = self.m_stuGameResult.cbCardIndex
    for i=2, nCardCount do
        local fistType = vecResultCardIndex[vecCardLineDate[nLineIndex * nCardCount + 1]]
        local currentType = vecResultCardIndex[vecCardLineDate[nLineIndex * nCardCount + i]]
        --print("线："..nLineIndex.." 起始图标："..fistType.." 当前图标："..currentType)
        if fistType == TigerConst.eResultType.Type_Diamond then
            return 0

        elseif currentType == TigerConst.eResultType.Type_BAR and fistType ~= TigerConst.eResultType.Type_777 and fistType ~= TigerConst.eResultType.Type_Diamond and fistType ~= TigerConst.eResultType.Type_Gold then 

            if(i == 5) then return 5 end

        elseif fistType ~= currentType then
            return i-1
        end

        if(i == 5) then return 5 end
    end

    return 1
end

--获取线上牌子类型
function TigerDataMgr:GetLineType(nLineIndex)
    if (self:GetDiamondCount(nLineIndex) >= 3) then
        return TigerConst.eResultType.Type_Diamond
    else
        return self.m_stuGameResult.cbCardIndex[vecCardLineDate[nLineIndex * TigerConst.LINE_CARD_COUNT + 1]]
    end
end

--判断钻石中奖-----------------------------------------------------------------
function TigerDataMgr:GetDiamondCount(nLineIndex)
    local nCount = 0
    local nCardCount = TigerConst.LINE_CARD_COUNT
    for i=1, nCardCount do
        if(TigerConst.eResultType.Type_Diamond == self.m_stuGameResult.cbCardIndex[vecCardLineDate[nLineIndex * nCardCount + i]]) then
            nCount = nCount + 1
        else
            break
        end
    end
    return nCount
end

function TigerDataMgr:GetCardFlash(cbVecCardIndex)
    if type(cbVecCardIndex) ~= "table" then return end

    local nCardCount = TigerConst.LINE_CARD_COUNT
    for nLineIndex=0,self.m_nLineNum-1 do
        local nCount = self:GetLineTypeCount(nLineIndex)
        local tType = self:GetLineType(nLineIndex)
        if (nCount >= 3 or (tType == TigerConst.eResultType.Type_BAR and nCount >= 3)) then
            for i=1,nCount do
                cbVecCardIndex[vecCardLineDate[nLineIndex * nCardCount + i]] = 1
            end
        end
        
        nCount = self:GetDiamondCount(nLineIndex)
        if (nCount >= 3) then
            for i=1,nCardCount do
                if(TigerConst.eResultType.Type_Diamond == self.m_stuGameResult.cbCardIndex[vecCardLineDate[nLineIndex * nCardCount + i]]) then
                    cbVecCardIndex[vecCardLineDate[nLineIndex * nCardCount + i]] = 1
                end
            end
        end
    end

    return cbVecCardIndex
end
function TigerDataMgr:getRandomResult(multiple_bet_)
    local line = self:getLineNum()
    if multiple_bet_ >100 and multiple_bet_ ~= 999 and self:getFreeTimes() <= 0 then
        local ran = math.random(1,100);
        if ran <= 40 then
            self:setFreeResult(multiple_bet_)
            return
        end
    end
    local rewardTable = appdf.req(module_pre .. ".rewardTable.JXLW_Line"..line)
    if multiple_bet_ == 99 or multiple_bet_ == 999 then
        rewardTable = appdf.req(module_pre .. ".rewardTable.JXLW_JackPot")
    end
    local tab_multiple = {}     --存放和服务器通知结果相同倍数结果的表
    for key, var in ipairs(rewardTable) do
        if var.multiples_bet == multiple_bet_ then
            table.insert(tab_multiple,var)
        end
    end
    local num_ = #tab_multiple
    local index_ = math.random(1,num_)
    local tab_ = tab_multiple[index_]
    print("中奖的ID是________________________________"..tab_.id)
    return tab_
end
--当倍数大于100，40%概率进入免费次数 JXLW_FreeMultiple
function TigerDataMgr:setFreeResult(multiple_bet_)
    local tab_multiple = {}     --存放和服务器通知结果相同倍数结果的表
    for key, var in pairs(JXLW_FreeMultiple) do
        if multiple_bet_ == var.multiple then
            table.insert(tab_multiple,var)
        end
    end
    local num_ = #tab_multiple
    local index_ = math.random(1,num_)
    self.freeResultTable = tab_multiple[index_]
    self:setFreeTimes(self.freeResultTable.free_count)

    self.freeTimesMoney = self:getGameResultLast().llResultMoney
    self:onGameGoon(1)    
end
function TigerDataMgr:itIsFree()
    if self:getFreeTimes()<=0 then
        return
    end
    local freeTimes = self:getFreeTimes()
    freeTimes = freeTimes -1
    local caseIndex = #self.freeResultTable.case - freeTimes
    self:setFreeTimes(freeTimes)

    self:onGameGoon(caseIndex)

    
end
function TigerDataMgr:onGameGoon(caseIndex)
    local _buffer = self:getRandomResult(self.freeResultTable.case[caseIndex]) --通过 中奖倍数 在表中查找
    --数据
    local msg = {}
    msg.llResult = self.freeResultTable.case[caseIndex] * self:getMinBetNum() * self:getBetNumIndex()--__data[5]        --中奖金额
    self.freeTimesMoney = self.freeTimesMoney + msg.llResult
    msg.llResultMoney = self.freeTimesMoney--__data[2]   --背包余额(本轮结算后)
    
    msg.cbCardIndex = {}   --3*5
    for i=1,3,1 do           --3
        for j=1,5,1 do       --5
            local iconIndex = self:numChange1_10(_buffer.symbol_tables[j][i])
            msg.cbCardIndex[(i-1)*5+j] = iconIndex
        end        
    end

    --保存游戏结果数据
    self:setGameResult(msg)
    self:setTigerState(TigerConst.GAME_TIGER_PLAY);
    --累计中奖
    self:setAllBetWinGold(TigerDataMgr:getInstance():getAllBetWinGold() + msg.llResult)
    -- 通知UI.
    SLFacade:dispatchCustomEvent(Tiger_Events.MSG_TIGER_GAME_START)
end
function TigerDataMgr:numChange1_10(num_)
    local _num = num_
    if _num == 1 then
        _num = 10
    elseif _num == 2 then
        _num = 9
    elseif _num == 3 then
        _num = 8
    elseif _num == 4 then
        _num = 7
    elseif _num == 5 then
        _num = 6
    elseif _num == 6 then
        _num = 5
    elseif _num == 7 then
        _num = 4
    elseif _num == 8 then
        _num = 3
    elseif _num == 9 then
        _num = 2
    elseif _num == 10 then
        _num = 1
    elseif _num == 11 then
        _num = 13
    elseif _num == 14 then
        _num = 11
    elseif _num == 13 then
        _num = 14
    end
    return _num
end
return TigerDataMgr