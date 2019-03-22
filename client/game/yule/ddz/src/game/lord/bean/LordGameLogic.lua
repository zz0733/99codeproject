--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local LordGameLogic = class("LordGameLogic")

LordGameLogic.m_pGameLogic = nil
function LordGameLogic:getInstance()
    if LordGameLogic.m_pGameLogic == nil then
        LordGameLogic.m_pGameLogic = LordGameLogic:new()
    end
    return LordGameLogic.m_pGameLogic
end

function LordGameLogic:init()
end

local function CopyMemory(data1, data2, i, j, count)
    for n = 0, count - 1 do
        data1[i + n] = data2[j + n]
    end
    return data1
end

local function ZeroMemory(data, count)
    data = {}
    for n = 0, count-1 do
        data[n] = 0
    end
    return data
end

--获取类型
function LordGameLogic:GetCardType(cbCardData, cbCardCount)
    self:SortCardList(cbCardData, cbCardCount, ST_ORDER)
    if cbCardCount == 0 then
        --空牌
        return CT_ERROR
    elseif cbCardCount == 1 then
        --单牌
        return CT_SINGLE
    elseif cbCardCount == 2 then
        --对牌火箭
        if cbCardData[0] == 0x4F and cbCardData[1] == 0x4E then
            return CT_MISSILE_CARD
        elseif self:GetCardLogicValue(cbCardData[0]) == self:GetCardLogicValue(cbCardData[1]) then
            return CT_DOUBLE
        end
        return CT_ERROR
    end

    local AnalyseResult = {}
    self:AnalysebCardData(cbCardData, cbCardCount, AnalyseResult)

    --四张相同牌型判断
    if AnalyseResult.cbBlockCount[3]>0 then
        if AnalyseResult.cbBlockCount[3]==1 and cbCardCount==4 then
            return CT_BOMB_CARD
        elseif AnalyseResult.cbBlockCount[3]==1 and cbCardCount==6 then
            return CT_FOUR_TAKE_ONE
        elseif AnalyseResult.cbBlockCount[3]==1 and cbCardCount==8 and AnalyseResult.cbBlockCount[1]==2 then
            return CT_FOUR_TAKE_TWO
        --修复：增加2飞机+1炸弹+2单牌（12张牌/三飞机），需服务器配合修改
        end
        return CT_ERROR
    end
    
    --三张相同牌型判断
    if AnalyseResult.cbBlockCount[2]>0 then
        --连牌判断
        if AnalyseResult.cbBlockCount[2]>1 then
            local cbCardData=AnalyseResult.cbCardData[2][0]
            local cbFirstLogicValue = self:GetCardLogicValue(cbCardData)
            --错误过虑
            if cbFirstLogicValue >= 15 then
                return CT_ERROR
            end
            --连牌判断
            for i=1, AnalyseResult.cbBlockCount[2] - 1 do
                local cbCardData=AnalyseResult.cbCardData[2][i*3]
                if cbFirstLogicValue ~= self:GetCardLogicValue(cbCardData) + i then
                    return CT_ERROR
                end
            end
        elseif cbCardCount == 3 then
            return CT_THREE
        end
        --三顺
        if AnalyseResult.cbBlockCount[2]*3 == cbCardCount then
            return CT_THREE_LINE
        end
        --三带一
        if AnalyseResult.cbBlockCount[2]*4 == cbCardCount then
            return CT_THREE_TAKE_ONE
        end
        --三带二
        if AnalyseResult.cbBlockCount[2]*5 == cbCardCount
        and AnalyseResult.cbBlockCount[1] == AnalyseResult.cbBlockCount[2]
        then
            return CT_THREE_TAKE_TWO
        end
        return CT_ERROR
    end
    
    --二张相同牌型判断
    if AnalyseResult.cbBlockCount[1]>=3 then
        --变量定义
        local cbCardData=AnalyseResult.cbCardData[1][0]
        local cbFirstLogicValue=self:GetCardLogicValue(cbCardData)

        --错误过虑
        if cbFirstLogicValue >= 15 then
            return CT_ERROR
        end

        --连牌判断
        for i = 1, AnalyseResult.cbBlockCount[1]-1 do
            local cbCardData=AnalyseResult.cbCardData[1][i*2]
            if cbFirstLogicValue ~= self:GetCardLogicValue(cbCardData)+i then
                return CT_ERROR
            end
        end
        --二连判断
        if AnalyseResult.cbBlockCount[1]*2 == cbCardCount then
            return CT_DOUBLE_LINE
        end
        return CT_ERROR
    end
    
    --单张判断
    if AnalyseResult.cbBlockCount[0]>=5 and AnalyseResult.cbBlockCount[0] == cbCardCount then
        --变量定义
        local cbCardData=AnalyseResult.cbCardData[0][0]
        local cbFirstLogicValue = self:GetCardLogicValue(cbCardData)
        --错误过虑
        if cbFirstLogicValue >= 15 then
            return CT_ERROR
        end 
        
        --连牌判断
        for i=1, AnalyseResult.cbBlockCount[0]-1 do
            local cbCardData=AnalyseResult.cbCardData[0][i]
            if cbFirstLogicValue ~= self:GetCardLogicValue(cbCardData)+i then
                return CT_ERROR
            end
        end
        
        return CT_SINGLE_LINE
    end
    return CT_ERROR
end

--排列扑克
function LordGameLogic:SortCardList(cbCardData, cbCardCount, cbSortType)
    --数目过虑
    if cbCardCount==0 then
        return
    end
    if cbSortType == ST_CUSTOM then
        return
    end
    --转换数值
    local cbSortValue = {}
    for i=0, cbCardCount-1 do
        cbSortValue[i]=self:GetCardLogicValue(cbCardData[i])
    end

    --排序操作
    local bSorted = false
    local cbSwitchData = 0
    local cbLast = cbCardCount - 1
    
    while bSorted==false do
        bSorted=true
        for i=0, cbLast-1 do
            if (cbSortValue[i] < cbSortValue[i+1])
            or (cbSortValue[i] == cbSortValue[i+1] and cbCardData[i] < cbCardData[i+1])
            then
                --设置标志
                bSorted=false
                --扑克数据
                cbSwitchData = cbCardData[i]
                cbCardData[i] = cbCardData[i+1]
                cbCardData[i+1] = cbSwitchData
                --排序权位
                cbSwitchData=cbSortValue[i]
                cbSortValue[i]=cbSortValue[i+1]
                cbSortValue[i+1]=cbSwitchData
            end
        end
        cbLast = cbLast - 1
    end
    --数目排序
    if cbSortType == ST_COUNT then
        --定义变量
        local cbCardIndex=0
        --分析扑克
        local AnalyseResult = {}
        self:AnalysebCardData(cbCardData, cbCardCount-cbCardIndex, AnalyseResult)
        --提取扑克
        for i=0, table.nums(AnalyseResult.cbBlockCount)-1 do
            --拷贝扑克
            local cbIndex = table.nums(AnalyseResult.cbBlockCount)-i-1
            if AnalyseResult.cbBlockCount[cbIndex] > 0 then
                
                cbCardData = CopyMemory(cbCardData, AnalyseResult.cbCardData[cbIndex], cbCardIndex, 0, AnalyseResult.cbBlockCount[cbIndex]*(cbIndex+1))
                cbCardIndex = cbCardIndex + AnalyseResult.cbBlockCount[cbIndex] * (cbIndex+1)
            end
        end
    end
    return
end

--混乱扑克（暂没使用）
function LordGameLogic:RandCardList(cbCardBuffer, cbBufferCount)
    local cbCardData = m_cbCardData

    local cbRandCount, cbPosition = 0, 0
    while (cbRandCount < cbBufferCount) do

        cbPosition=(math.random()*0xffffff)%(cbBufferCount-cbRandCount)
        cbCardBuffer[cbRandCount]=cbCardData[cbPosition]
        cbRandCount = cbRandCount+1
        cbCardData[cbPosition]=cbCardData[cbBufferCount-cbRandCount]
    end
    return
end

--删除扑克
function LordGameLogic:RemoveCardList(cbRemoveCard, cbRemoveCount, cbCardData, cbCardCount)
    --检验数据
    if cbRemoveCount > cbCardCount then
        print("LordGameLogic:RemoveCardList error 221")
        cc.exports.FloatMessage.getInstance():pushMessageDebug("LordGameLogic:RemoveCardList error 221")
        return false
    end
    local cbDeleteCount=0
    local cbTempCardData = {}
    for i = 0, MAX_COUNT-1 do
        cbTempCardData[i] = 0
    end
    if cbCardCount > MAX_COUNT then
        return false
    end
    CopyMemory(cbTempCardData, cbCardData, 0, 0, cbCardCount)
    --置零扑克
    for i = 0, cbRemoveCount-1 do
        for j = 0, cbCardCount-1 do
            if cbRemoveCard[i] == cbTempCardData[j] then
                cbDeleteCount = cbDeleteCount + 1
                cbTempCardData[j] = 0
                break
            end
        end
    end

    if cbDeleteCount ~= cbRemoveCount then
        return false, cbCardData
    end
       
    --清理扑克
    local cbCardPos = 0
    cbCardData = {}
    for i = 0, cbCardCount-1 do
        if cbTempCardData[i] ~= 0 then
            cbCardData[cbCardPos] = cbTempCardData[i]
            cbCardPos= cbCardPos+1
        end
    end
    return true, cbCardData
end

--删除扑克--与上面方法一样
function LordGameLogic:RemoveCard(cbRemoveCard, cbRemoveCount, cbCardData, cbCardCount)
    --检验数据
    if cbRemoveCount>cbCardCount then
        print("LordGameLogic:RemoveCard error 1")
        cc.exports.FloatMessage.getInstance():pushMessageDebug("LordGameLogic:RemoveCard error 1")
        return false
    end
    --定义变量
    local cbDeleteCount=0
    local cbTempCardData = {}
    for i = 0, MAX_COUNT-1 do
        cbTempCardData[i] = 0
    end
    --牌数大于最大手牌数则返回
    if cbCardCount > MAX_COUNT then
        return false
    end
    CopyMemory(cbTempCardData, cbCardData, 0, 0, cbCardCount)
    --置零扑克
    for i=0, cbRemoveCount - 1 do
        for j=0, cbCardCount - 1 do
            if cbRemoveCard[i]==cbTempCardData[j] then
                cbDeleteCount = cbDeleteCount+1
                cbTempCardData[j]=0
                break;
            end
        end
    end
    if cbDeleteCount ~= cbRemoveCount then
        return false
    end 
    
    --清理扑克
    local cbCardPos=0
    for i = 0, cbCardCount - 1 do
        if cbTempCardData[i] > 0 then
            cbCardData[cbCardPos] = cbTempCardData[i]
            cbCardPos = cbCardPos + 1
        end
    end
    --剩余未清零
    for i = 0, cbCardCount - 1 do
        if i >= cbCardCount - cbRemoveCount then
            cbCardData[i] = 0
        end
    end

    return true
end

--排列扑克
function LordGameLogic:SortOutCardList(cbCardData, cbCardCount)
    local cbCardType = self:GetCardType(cbCardData, cbCardCount)
    if cbCardType == CT_THREE_TAKE_ONE or cbCardType == CT_THREE_TAKE_TWO then
        --分析牌
        local AnalyseResult = {}
        self:AnalysebCardData(cbCardData, cbCardCount, AnalyseResult)
        cbCardCount = AnalyseResult.cbBlockCount[2]*3
        cbCardData = CopyMemory(cbCardData, AnalyseResult.cbCardData[2], 0, 0, cbCardCount)
        
        for i = table.nums(AnalyseResult.cbBlockCount)-1, 0, -1 do
            if i ~= 2 then
                if AnalyseResult.cbBlockCount[i] > 0 then
                    cbCardData = CopyMemory(cbCardData, AnalyseResult.cbCardData[i], cbCardCount, 0, (i+1)*AnalyseResult.cbBlockCount[i])
                    cbCardCount = cbCardCount + AnalyseResult.cbBlockCount[i]*(i+1)
                end
            end
        end
    elseif cbCardType == CT_FOUR_TAKE_ONE or cbCardType == CT_FOUR_TAKE_TWO then
        --分析牌
        local AnalyseResult = {}
        self:AnalysebCardData(cbCardData, cbCardCount, AnalyseResult)
        cbCardCount = AnalyseResult.cbBlockCount[3]*4
        cbCardData = CopyMemory(cbCardData, AnalyseResult.cbCardData[3], 0, 0, cbCardCount)
        for i = table.nums(AnalyseResult.cbBlockCount)-1, 0, -1 do
            if i ~= 3 then
                if AnalyseResult.cbBlockCount[i] > 0 then
                    cbCardData = CopyMemory(cbCardData, AnalyseResult.cbCardData[i], cbCardCount, 0, (i+1)*AnalyseResult.cbBlockCount[i])
                    cbCardCount = cbCardCount + AnalyseResult.cbBlockCount[i]*(i + 1)
                end
            end
        end
    end
    return
end

--获取逻辑数值
function LordGameLogic:GetCardLogicValue(cbCardData)
    if cbCardData == nil then
        print("LordGameLogic:GetCardLogicValue error 1")
        cc.exports.FloatMessage.getInstance():pushMessageDebug("LordGameLogic:GetCardLogicValue error 1")
        return
    end
    local cbCardColor = GetCardColor(cbCardData)
    local cbCardValue = GetCardValue(cbCardData)

    if cbCardColor == 0x40 then
        return cbCardValue + 2
    end

    if cbCardValue <= 2 then
        return cbCardValue + 13
    end
    return cbCardValue
end

--对比扑克
function LordGameLogic:CompareCard(cbFirstCard, cbNextCard, cbFirstCount, cbNextCount)
    --获取类型
    local cbNextType = self:GetCardType(cbNextCard,cbNextCount)
    local cbFirstType = self:GetCardType(cbFirstCard,cbFirstCount)
    --类型判断
    if cbNextType==CT_ERROR then
        return false
    end 
    if cbNextType == CT_MISSILE_CARD then
        return true
    end
    
    --炸弹判断
    if cbFirstType ~= CT_BOMB_CARD and cbNextType == CT_BOMB_CARD then
        return true
    end
    if cbFirstType == CT_BOMB_CARD and cbNextType ~= CT_BOMB_CARD then
        return false
    end
    
    --规则判断
    if cbFirstType ~= cbNextType or cbFirstCount ~= cbNextCount then
        return false
    end

    --开始对比
    if cbNextType == CT_SINGLE or cbNextType == CT_DOUBLE or cbNextType == CT_THREE 
    or cbNextType == CT_SINGLE_LINE or cbNextType == CT_DOUBLE_LINE 
    or cbNextType == CT_THREE_LINE or cbNextType == CT_BOMB_CARD
    then
        --获取第一张牌的数值
        local cbNextLogicValue = self:GetCardLogicValue(cbNextCard[0])
        local cbFirstLogicValue = self:GetCardLogicValue(cbFirstCard[0])
        --对比扑克
        return cbNextLogicValue > cbFirstLogicValue

    elseif cbNextType == CT_THREE_TAKE_ONE or cbNextType == CT_THREE_TAKE_TWO then
        --分析扑克
        local NextResult = {}
        local FirstResult = {}
        self:AnalysebCardData(cbNextCard,cbNextCount,NextResult)
        self:AnalysebCardData(cbFirstCard,cbFirstCount,FirstResult)

        --获取三张的牌值
        local cbFirstLogicValue = self:GetCardLogicValue(FirstResult.cbCardData[2][0])
        local cbNextLogicValue = self:GetCardLogicValue(NextResult.cbCardData[2][0])

        --对比扑克
        return cbNextLogicValue > cbFirstLogicValue

    elseif cbNextType == CT_FOUR_TAKE_ONE or cbNextType == CT_FOUR_TAKE_TWO then
        --分析扑克
        local NextResult = {}
        local FirstResult = {}
        self:AnalysebCardData(cbNextCard,cbNextCount,NextResult)
        self:AnalysebCardData(cbFirstCard,cbFirstCount,FirstResult)

        --获取四张的牌值
        local cbNextLogicValue = self:GetCardLogicValue(NextResult.cbCardData[3][0])
        local cbFirstLogicValue = self:GetCardLogicValue(FirstResult.cbCardData[3][0])
            
        --对比扑克
        return cbNextLogicValue > cbFirstLogicValue

    end
    return false
end

function LordGameLogic:MakeCardData(cbValueIndex, cbColorIndex)
    return bit.bor(bit.lshift(cbColorIndex, 4), cbValueIndex+1)
end

function LordGameLogic:ZeroAnalyseResultMemory(tagAnalyseResult)
    tagAnalyseResult.cbBlockCount = {}
    for i = 0, 3 do
        tagAnalyseResult.cbBlockCount[i] = 0
    end
    tagAnalyseResult.cbCardData = {}
    for i = 0, 3 do
        tagAnalyseResult.cbCardData[i] = {}
        for j = 0, MAX_COUNT-1 do
            tagAnalyseResult.cbCardData[i][j] = 0
        end
    end
end

--分析扑克
function LordGameLogic:AnalysebCardData(cbCardData, cbCardCount,  AnalyseResult)
    self:ZeroAnalyseResultMemory(AnalyseResult)
    --错误:i在这里是累计加1,与c++有所出入
    --for i = 0, cbCardCount-1 do
    --    --变量定义
    --    local cbSameCount = 1
    --    local cbLogicValue = self:GetCardLogicValue(cbCardData[i])
    --    --搜索相同的牌值
    --    for j = i + 1, cbCardCount-1 do
    --        if self:GetCardLogicValue(cbCardData[j]) ~= cbLogicValue then
    --            break
    --        end
    --        cbSameCount = cbSameCount + 1
    --    end
    --    local cbIndex = AnalyseResult.cbBlockCount[cbSameCount - 1]
    --    AnalyseResult.cbBlockCount[cbSameCount - 1] = AnalyseResult.cbBlockCount[cbSameCount - 1] + 1
    --    for j = 0, cbSameCount - 1 do
    --        AnalyseResult.cbCardData[cbSameCount - 1][cbIndex * cbSameCount + j] = cbCardData[i + j]
    --    end
    --    i = i + cbSameCount - 1
    --end
    --修复错误:
    --扑克分析
    local i = 0
    for i_count = 0, cbCardCount-1 do
        if i_count == i then
            --变量定义
            local cbSameCount = 1
            local cbLogicValue = self:GetCardLogicValue(cbCardData[i])
            --搜索相同的牌值
            for j = i + 1, cbCardCount-1 do
                if self:GetCardLogicValue(cbCardData[j]) ~= cbLogicValue then
                    break
                end
                cbSameCount = cbSameCount + 1
            end
            local cbIndex = AnalyseResult.cbBlockCount[cbSameCount - 1]
            AnalyseResult.cbBlockCount[cbSameCount - 1] = AnalyseResult.cbBlockCount[cbSameCount - 1] + 1
            for j = 0, cbSameCount - 1 do
                AnalyseResult.cbCardData[cbSameCount - 1][cbIndex * cbSameCount + j] = cbCardData[i + j]
            end
            i = i + cbSameCount
        end
    end
    return
end

function LordGameLogic:ZeroDistributingMemory(tagDistributing)
    tagDistributing.cbCardCount = 0
    tagDistributing.cbDistributing = {}
    for i=0, 14 do
        tagDistributing.cbDistributing[i] = {}
        for j = 0, 5 do
            tagDistributing.cbDistributing[i][j] = 0
        end
    end
end

--分析分布
function LordGameLogic:AnalysebDistributing(cbCardData, cbCardCount, Distributing)
    self:ZeroDistributingMemory(Distributing)
    for i = 0, cbCardCount-1 do
        if cbCardData[i] > 0 then
            --获取属性
            local cbCardColor = GetCardColor(cbCardData[i])
            local cbCardValue = GetCardValue(cbCardData[i])

            --分布信息
            Distributing.cbCardCount = Distributing.cbCardCount + 1
            Distributing.cbDistributing[cbCardValue-1][cbIndexCount] = Distributing.cbDistributing[cbCardValue-1][cbIndexCount] + 1

            local rShift = bit.rshift(cbCardColor,4)
            Distributing.cbDistributing[cbCardValue-1][rShift] = Distributing.cbDistributing[cbCardValue-1][rShift] + 1
        end
    end
end

--出牌搜索
function LordGameLogic:SearchOutCard(cbHandCardData, cbHandCardCount, cbTurnCardData, cbTurnCardCount, pSearchCardResult)
    --设置结果
    if pSearchCardResult == nil then
        print("LordGameLogic:SearchOutCard error 1")
        cc.exports.FloatMessage.getInstance():pushMessageDebug("LordGameLogic:SearchOutCard error 1")
        return 0
    end
    self:ZeroSearchCardResultMemory(pSearchCardResult)
    --变量定义
    local cbResultCount = 0
    local tmpSearchCardResult = {}
    --构造扑克
    local cbCardData = {}
    local cbCardCount = cbHandCardCount
    CopyMemory(cbCardData, cbHandCardData, 0, 0, cbHandCardCount)
    --排列扑克
    self:SortCardList(cbCardData, cbCardCount, ST_ORDER)
    --获取类型
    local cbTurnOutType = self:GetCardType(cbTurnCardData, cbTurnCardCount)
    --出牌分析
    if cbTurnOutType == CT_ERROR then                       --错误类型
        --提取各种牌型一组
        if pSearchCardResult == nil then
            print("LordGameLogic:pSearchCardResult error 2")
            cc.exports.FloatMessage.getInstance():pushMessageDebug("LordGameLogic:pSearchCardResult error 2")
            return 0
        end
        --是否一手出完
        if self:GetCardType(cbCardData, cbCardCount) ~= CT_ERROR then
            pSearchCardResult.cbCardCount[cbResultCount] = cbCardCount
            pSearchCardResult.cbResultCard[cbResultCount] = CopyMemory(pSearchCardResult.cbResultCard[cbResultCount], cbCardData, 0, 0, cbCardCount)
            cbResultCount = cbResultCount + 1
        end
        --如果最小牌不是单牌，则提取
        local cbSameCount = 0
        if cbCardCount > 1 and (GetCardValue(cbCardData[cbCardCount-1]) == GetCardValue(cbCardData[cbCardCount-2])) then
            cbSameCount = 1
            pSearchCardResult.cbResultCard[cbResultCount][0] = cbCardData[cbCardCount-1]
            local cbCardValue = GetCardValue(cbCardData[cbCardCount-1])
            for i = cbCardCount - 2, 0, -1 do
                if GetCardValue(cbCardData[i]) == cbCardValue then
                    pSearchCardResult.cbResultCard[cbResultCount][cbSameCount] = cbCardData[i]
                    cbSameCount = cbSameCount + 1
                else
                    break
                end
            end
            pSearchCardResult.cbCardCount[cbResultCount] = cbSameCount
            cbResultCount = cbResultCount + 1
        end

        --单牌
        local cbTmpCount = 0
        if cbSameCount ~= 1 then
            cbTmpCount = self:SearchSameCard(cbCardData, cbCardCount, 0, 1, tmpSearchCardResult)
            if cbTmpCount > 0 then
                pSearchCardResult.cbCardCount[cbResultCount] = tmpSearchCardResult.cbCardCount[0]
                pSearchCardResult.cbResultCard[cbResultCount] = 
                    CopyMemory( pSearchCardResult.cbResultCard[cbResultCount], tmpSearchCardResult.cbResultCard[0], 0, 0, tmpSearchCardResult.cbCardCount[0])
                cbResultCount = cbResultCount + 1
            end
        end

        --对牌
        if cbSameCount ~= 2 then
            cbTmpCount = self:SearchSameCard(cbCardData, cbCardCount, 0, 2, tmpSearchCardResult)
            if cbTmpCount > 0 then
                pSearchCardResult.cbCardCount[cbResultCount] = tmpSearchCardResult.cbCardCount[0]
                pSearchCardResult.cbResultCard[cbResultCount] = 
                    CopyMemory( pSearchCardResult.cbResultCard[cbResultCount], tmpSearchCardResult.cbResultCard[0], 0, 0, tmpSearchCardResult.cbCardCount[0])
                cbResultCount = cbResultCount + 1
            end
        end
        --三条
        if cbSameCount ~= 3 then
            cbTmpCount = self:SearchSameCard(cbCardData, cbCardCount, 0, 3, tmpSearchCardResult)
            if cbTmpCount > 0 then
                pSearchCardResult.cbCardCount[cbResultCount] = tmpSearchCardResult.cbCardCount[0]
                pSearchCardResult.cbResultCard[cbResultCount] = 
                    CopyMemory( pSearchCardResult.cbResultCard[cbResultCount], tmpSearchCardResult.cbResultCard[0], 0, 0, tmpSearchCardResult.cbCardCount[0])
                cbResultCount = cbResultCount + 1
            end
        end
        --三带一单
        cbTmpCount = self:SearchTakeCardType(cbCardData, cbCardCount, 0, 3, 1, tmpSearchCardResult)
        if cbTmpCount > 0 then
            pSearchCardResult.cbCardCount[cbResultCount] = tmpSearchCardResult.cbCardCount[0]
            pSearchCardResult.cbResultCard[cbResultCount] = 
                CopyMemory( pSearchCardResult.cbResultCard[cbResultCount], tmpSearchCardResult.cbResultCard[0], 0, 0, tmpSearchCardResult.cbCardCount[0])
            cbResultCount = cbResultCount + 1
        end
        --三带一对
        cbTmpCount = self:SearchTakeCardType(cbCardData, cbCardCount, 0, 3, 2, tmpSearchCardResult)
        if cbTmpCount > 0 then
            pSearchCardResult.cbCardCount[cbResultCount] = tmpSearchCardResult.cbCardCount[0]
            pSearchCardResult.cbResultCard[cbResultCount] = 
                CopyMemory( pSearchCardResult.cbResultCard[cbResultCount], tmpSearchCardResult.cbResultCard[0], 0, 0, tmpSearchCardResult.cbCardCount[0])
            cbResultCount = cbResultCount + 1
        end
        --单连
        cbTmpCount = self:SearchLineCardType(cbCardData, cbCardCount, 0, 1, 0, tmpSearchCardResult)
        if cbTmpCount > 0 then
            pSearchCardResult.cbCardCount[cbResultCount] = tmpSearchCardResult.cbCardCount[0]
            pSearchCardResult.cbResultCard[cbResultCount] = 
                CopyMemory( pSearchCardResult.cbResultCard[cbResultCount], tmpSearchCardResult.cbResultCard[0], 0, 0, tmpSearchCardResult.cbCardCount[0])
            cbResultCount = cbResultCount + 1
        end
        --连对
        cbTmpCount = self:SearchLineCardType(cbCardData, cbCardCount, 0, 2, 0, tmpSearchCardResult)
        if cbTmpCount > 0 then
            pSearchCardResult.cbCardCount[cbResultCount] = tmpSearchCardResult.cbCardCount[0]
            pSearchCardResult.cbResultCard[cbResultCount] = 
                CopyMemory( pSearchCardResult.cbResultCard[cbResultCount], tmpSearchCardResult.cbResultCard[0], 0, 0, tmpSearchCardResult.cbCardCount[0])
            cbResultCount = cbResultCount + 1
        end
        --三连
        cbTmpCount = self:SearchLineCardType(cbCardData, cbCardCount, 0, 3, 0, tmpSearchCardResult)
        if cbTmpCount > 0 then
            pSearchCardResult.cbCardCount[cbResultCount] = tmpSearchCardResult.cbCardCount[0]
            pSearchCardResult.cbResultCard[cbResultCount] = 
                CopyMemory( pSearchCardResult.cbResultCard[cbResultCount], tmpSearchCardResult.cbResultCard[0], 0, 0, tmpSearchCardResult.cbCardCount[0])
            cbResultCount = cbResultCount + 1
        end
        --飞机
        cbTmpCount = self:SearchThreeTwoLine(cbCardData, cbCardCount, tmpSearchCardResult)
        if cbTmpCount > 0 then
            pSearchCardResult.cbCardCount[cbResultCount] = tmpSearchCardResult.cbCardCount[0]
            pSearchCardResult.cbResultCard[cbResultCount] = 
                CopyMemory( pSearchCardResult.cbResultCard[cbResultCount], tmpSearchCardResult.cbResultCard[0], 0, 0, tmpSearchCardResult.cbCardCount[0])
            cbResultCount = cbResultCount + 1
        end
        --炸弹
        if cbSameCount ~= 4 then
            cbTmpCount = self:SearchSameCard(cbCardData, cbCardCount, 0, 4, tmpSearchCardResult)
            if cbTmpCount > 0 then
                pSearchCardResult.cbCardCount[cbResultCount] = tmpSearchCardResult.cbCardCount[0]
                pSearchCardResult.cbResultCard[cbResultCount] = 
                    CopyMemory( pSearchCardResult.cbResultCard[cbResultCount], tmpSearchCardResult.cbResultCard[0], 0, 0, tmpSearchCardResult.cbCardCount[0])
                cbResultCount = cbResultCount + 1
            end
        end
        --搜索火箭
        if (cbCardCount >= 2) and (cbCardData[0] == 0x4F) and (cbCardData[1] == 0x4E) then
            --设置结果
            pSearchCardResult.cbCardCount[cbResultCount] = 2
            pSearchCardResult.cbResultCard[cbResultCount][0] = cbCardData[0]
            pSearchCardResult.cbResultCard[cbResultCount][1] = cbCardData[1]
            cbResultCount = cbResultCount + 1
        end
        pSearchCardResult.cbSearchCount = cbResultCount
        return cbResultCount
    elseif cbTurnOutType == CT_SINGLE or cbTurnOutType == CT_DOUBLE or cbTurnOutType == CT_THREE then
        --变量定义
        local cbReferCard = cbTurnCardData[0]
        local cbSameCount = 1
        if cbTurnOutType == CT_DOUBLE then
            cbSameCount = 2
        elseif cbTurnOutType == CT_THREE then
            cbSameCount = 3
        end
        --搜索相同牌
        cbResultCount = self:SearchSameCard(cbCardData, cbCardCount, cbReferCard, cbSameCount, pSearchCardResult)
    elseif cbTurnOutType == CT_SINGLE_LINE or cbTurnOutType == CT_DOUBLE_LINE or cbTurnOutType == CT_THREE_LINE then
        --变量定义
        local cbBlockCount = 1
        if cbTurnOutType == CT_DOUBLE_LINE then
            cbBlockCount = 2
        elseif cbTurnOutType == CT_THREE_LINE then
            cbBlockCount = 3
        end
        local cbLineCount = cbTurnCardCount/cbBlockCount
        --搜索单牌
        cbResultCount = self:SearchLineCardType(cbCardData, cbCardCount, cbTurnCardData[0], cbBlockCount, cbLineCount, pSearchCardResult)
    elseif cbTurnOutType == CT_THREE_TAKE_ONE or cbTurnOutType == CT_THREE_TAKE_TWO then
        --效验牌数
        if cbCardCount >= cbTurnCardCount then
            --如果是三带一或三带二
            if cbTurnCardCount == 4 or cbTurnCardCount == 5 then
                local cbTakeCardCount = 2
                if cbTurnOutType == CT_THREE_TAKE_ONE then
                    cbTakeCardCount = 1
                end
                cbResultCount = self:SearchTakeCardType(cbCardData, cbCardCount, cbTurnCardData[2], 3, cbTakeCardCount, pSearchCardResult )
            else
                --定义变量
                local cbBlockCount = 3
                local cbLineCount = 0
                if cbTurnOutType == CT_THREE_TAKE_ONE then
                    cbLineCount = cbTurnCardCount/4
                else
                    cbLineCount = cbTurnCardCount/5
                end
                local cbTakeCardCount = 0
                if cbTurnOutType == CT_THREE_TAKE_ONE then
                    cbTakeCardCount = 1
                else
                    cbTakeCardCount = 2
                end
                --搜索连牌
                local cbTmpTurnCard = {}
                CopyMemory(cbTmpTurnCard, cbTurnCardData, 0, 0, cbTurnCardCount)
                self:SortOutCardList(cbTmpTurnCard, cbTurnCardCount)
                cbResultCount = self:SearchLineCardType(cbCardData, cbCardCount, cbTmpTurnCard[0], cbBlockCount, cbLineCount, pSearchCardResult)
                local bAllDistill = true
                for i = 0, cbResultCount-1 do
                    local cbResultIndex = cbResultCount-i-1
                    --定义变量
                    local cbTmpCardData = {}
                    local cbTmpCardCount = cbCardCount
                    --删除连牌
                    CopyMemory(cbTmpCardData, cbCardData, 0, 0, cbCardCount)
                    local bRemoveSuccess = self:RemoveCard(pSearchCardResult.cbResultCard[cbResultIndex], pSearchCardResult.cbCardCount[cbResultIndex], cbTmpCardData, cbTmpCardCount)
                    if bRemoveSuccess == false then
                        print("LordGameLogic:SearchOutCard error 3")
                        cc.exports.FloatMessage.getInstance():pushMessageDebug("LordGameLogic:SearchOutCard error 3")
                    end
                    cbTmpCardCount = cbTmpCardCount - pSearchCardResult.cbCardCount[cbResultIndex]
                    --分析牌
                    local TmpResult = {}
                    self:AnalysebCardData(cbTmpCardData, cbTmpCardCount, TmpResult)
                    --提取牌
                    local cbDistillCard = {}
                    local cbDistillCount = 0
                    for j = cbTakeCardCount - 1, table.nums(TmpResult.cbBlockCount) - 1 do
                        if TmpResult.cbBlockCount[j] > 0 then
                            if j+1 == cbTakeCardCount and TmpResult.cbBlockCount[j] >= cbLineCount then
                                local cbTmpBlockCount = TmpResult.cbBlockCount[j]

                                cbDistillCard = CopyMemory(cbDistillCard, TmpResult.cbCardData[j], 0, (cbTmpBlockCount-cbLineCount)*(j+1), (j+1)*cbLineCount)
                                for k = 1, (j+1)*cbLineCount do
                                end
                                cbDistillCount = (j+1)*cbLineCount
                                break
                            else
                                for k = 0, TmpResult.cbBlockCount[j]-1 do
                                    local cbTmpBlockCount = TmpResult.cbBlockCount[j]

                                    cbDistillCard = CopyMemory(cbDistillCard,  TmpResult.cbCardData[j], cbDistillCount, (cbTmpBlockCount-k-1)*(j+1), cbTakeCardCount)
                                    cbDistillCount = cbDistillCount + cbTakeCardCount
                                    --提取完成
                                    if cbDistillCount == cbTakeCardCount*cbLineCount then
                                        break
                                    end
                                end
                            end
                        end
                        --提取完成
                        if cbDistillCount == cbTakeCardCount*cbLineCount then
                            break
                        end
                    end
                    --提取完成
                    if cbDistillCount == cbTakeCardCount*cbLineCount then
                        --复制带牌
                        local cbCount = pSearchCardResult.cbCardCount[cbResultIndex]
                        pSearchCardResult.cbResultCard[cbResultIndex] = 
                            CopyMemory(pSearchCardResult.cbResultCard[cbResultIndex], cbDistillCard, cbCount, 0, cbDistillCount)
                        pSearchCardResult.cbCardCount[cbResultIndex] = pSearchCardResult.cbCardCount[cbResultIndex] + cbDistillCount
                    else
                        --否则删除连牌
                        bAllDistill = false
                        pSearchCardResult.cbCardCount[cbResultIndex] = 0
                    end
                end
                --整理组合
                if not bAllDistill then
                    pSearchCardResult.cbSearchCount = cbResultCount
                    cbResultCount = 0
                    for i = 0, pSearchCardResult.cbSearchCount-1 do
                        if pSearchCardResult.cbCardCount[i] ~= 0 then
                            tmpSearchCardResult.cbCardCount[cbResultCount] = pSearchCardResult.cbCardCount[i]
                            tmpSearchCardResult.cbResultCard[cbResultCount] = 
                                CopyMemory(tmpSearchCardResult.cbResultCard[cbResultCount], pSearchCardResult.cbResultCard[i], 0, 0, pSearchCardResult.cbCardCount[i])
                            cbResultCount = cbResultCount + 1
                        end
                    end
                    tmpSearchCardResult.cbSearchCount = cbResultCount
--                    for k = 0, 3 do --c++p846/有问题的代码
--                        pSearchCardResult[k] = CopyMemory(pSearchCardResult[k], tmpSearchCardResult[k], 0, 0, 20)
--                    end
                    pSearchCardResult = table.deepcopy(tmpSearchCardResult) 
                end
            end
        end
    elseif cbTurnOutType == CT_FOUR_TAKE_ONE or cbTurnOutType == CT_FOUR_TAKE_TWO then
        local cbTakeCount = 0
        if cbTurnOutType==CT_FOUR_TAKE_ONE then
            cbTakeCount = 1
        else
            cbTakeCount = 2
        end
        local cbTmpTurnCard = {}
        CopyMemory(cbTmpTurnCard, cbTurnCardData, 0, 0, cbTurnCardCount)
        self:SortOutCardList(cbTmpTurnCard,cbTurnCardCount)

        --搜索带牌
        cbResultCount = self:SearchTakeCardType(cbCardData, cbCardCount, cbTmpTurnCard[0], 4, cbTakeCount, pSearchCardResult)
    end

    --搜索炸弹
    if (cbCardCount>=4) and (cbTurnOutType ~= CT_MISSILE_CARD) then
        --变量定义
        local cbReferCard = 0
        if cbTurnOutType == CT_BOMB_CARD then
            cbReferCard = cbTurnCardData[0]
        end
        --搜索炸弹
        local cbTmpResultCount = self:SearchSameCard(cbCardData, cbCardCount, cbReferCard, 4, tmpSearchCardResult)
        for i = 0, cbTmpResultCount-1 do
            pSearchCardResult.cbCardCount[cbResultCount] = tmpSearchCardResult.cbCardCount[i]
            pSearchCardResult.cbResultCard[cbResultCount] = 
                CopyMemory(pSearchCardResult.cbResultCard[cbResultCount], tmpSearchCardResult.cbResultCard[i], 0, 0, tmpSearchCardResult.cbCardCount[i])
            cbResultCount = cbResultCount + 1
        end
    end

    --搜索火箭
    if (cbTurnOutType ~= CT_MISSILE_CARD) and (cbCardCount >= 2) and (cbCardData[0] == 0x4F) and (cbCardData[1] == 0x4E) then
        --设置结果
        pSearchCardResult.cbCardCount[cbResultCount] = 2
        pSearchCardResult.cbResultCard[cbResultCount][0] = cbCardData[0]
        pSearchCardResult.cbResultCard[cbResultCount][1] = cbCardData[1]
        
        cbResultCount = cbResultCount + 1
    end
    pSearchCardResult.cbSearchCount = cbResultCount
    return cbResultCount
end

function LordGameLogic:ZeroSearchCardResultMemory(tagSearchCardResult)
    tagSearchCardResult.cbSearchCount = 0
    tagSearchCardResult.cbCardCount = {}
    for i = 0, 19 do
        tagSearchCardResult.cbCardCount[i] = 0
    end
    tagSearchCardResult.cbResultCard = {}
    for i = 0, 19 do
        tagSearchCardResult.cbResultCard[i] = {}
        for j = 0, 19 do
            tagSearchCardResult.cbResultCard[i][j] = 0
        end
    end
end

--同牌搜索
function LordGameLogic:SearchSameCard(cbHandCardData, cbHandCardCount, cbReferCard, cbSameCardCount, pSearchCardResult)
    --设置结果
    if pSearchCardResult then
        self:ZeroSearchCardResultMemory(pSearchCardResult)
    end
    local cbResultCount = 0

    --构造扑克
    local cbCardData = {}
    local cbCardCount = cbHandCardCount
    CopyMemory(cbCardData, cbHandCardData, 0, 0, cbHandCardCount)
    
    --排列扑克
    self:SortCardList(cbCardData, cbCardCount, ST_ORDER)

    --分析扑克
    local AnalyseResult = {}
    self:AnalysebCardData(cbCardData, cbCardCount, AnalyseResult)
    local cbReferLogicValue = self:GetCardLogicValue(cbReferCard)
    if cbReferCard == 0 then
        cbReferLogicValue = 0
    end
    local cbBlockIndex = cbSameCardCount - 1
    while cbBlockIndex < table.nums(AnalyseResult.cbBlockCount) do
        for i = 0, AnalyseResult.cbBlockCount[cbBlockIndex]-1 do
            local cbIndex = (AnalyseResult.cbBlockCount[cbBlockIndex]-i-1)*(cbBlockIndex+1)
            if self:GetCardLogicValue(AnalyseResult.cbCardData[cbBlockIndex][cbIndex]) > cbReferLogicValue then
                if not pSearchCardResult then
                    return 1
                end
                if cbResultCount >= table.nums(pSearchCardResult.cbCardCount) then
                    print("LordGameLogic:SearchSameCard error 1")
                    cc.exports.FloatMessage.getInstance():pushMessageDebug("LordGameLogic:SearchSameCard error 1")
                    return 0
                end
                --复制扑克
                CopyMemory(pSearchCardResult.cbResultCard[cbResultCount], AnalyseResult.cbCardData[cbBlockIndex], 0, cbIndex, cbSameCardCount)
                pSearchCardResult.cbCardCount[cbResultCount] = cbSameCardCount
                cbResultCount = cbResultCount + 1
            end
        end
        cbBlockIndex = cbBlockIndex + 1
    end

    if pSearchCardResult then
        pSearchCardResult.cbSearchCount = cbResultCount
    end
    return cbResultCount
end

--带牌类型搜索(三带一，四带一等)
function LordGameLogic:SearchTakeCardType(cbHandCardData, cbHandCardCount, cbReferCard, cbSameCount, cbTakeCardCount, pSearchCardResult)
    --设置结果
    if pSearchCardResult then
        self:ZeroSearchCardResultMemory(pSearchCardResult)
    end
    local cbResultCount = 0
    --效验
    if cbSameCount ~= 3 and cbSameCount ~= 4 then
        print("LordGameLogic:SearchTakeCardType error 1")
        cc.exports.FloatMessage.getInstance():pushMessageDebug("LordGameLogic:SearchTakeCardType error 1")
        return 0
    end
    if cbTakeCardCount ~= 1 and cbTakeCardCount ~= 2 then
        print("LordGameLogic:SearchTakeCardType error 2")
        cc.exports.FloatMessage.getInstance():pushMessageDebug("LordGameLogic:SearchTakeCardType error 2")
        return 0
    end
    if cbSameCount ~= 3 and cbSameCount ~= 4 then
        return cbResultCount
    end
    if cbTakeCardCount ~= 1 and cbTakeCardCount ~= 2 then
        return cbResultCount
    end
    --长度判断
    if (cbSameCount == 4 and cbHandCardCount < cbSameCount+cbTakeCardCount*2)
    or (cbHandCardCount < cbSameCount+cbTakeCardCount)
    then
        return cbResultCount
    end
    --构造扑克
    local cbCardData = {}
    local cbCardCount = cbHandCardCount
    CopyMemory(cbCardData, cbHandCardData, 0, 0, cbHandCardCount)
    --排列扑克
    self:SortCardList(cbCardData, cbCardCount, ST_ORDER)
    --搜索同张
    local SameCardResult = {}
    local cbSameCardResultCount = self:SearchSameCard(cbCardData, cbCardCount, cbReferCard, cbSameCount, SameCardResult)

    if cbSameCardResultCount > 0 then
        --分析扑克
        local AnalyseResult = {}
        self:AnalysebCardData(cbCardData, cbCardCount, AnalyseResult)
        --需要牌数
        local cbNeedCount = cbSameCount + cbTakeCardCount
        if cbSameCount == 4 then
            cbNeedCount = cbNeedCount + cbTakeCardCount
        end
        --提取带牌
        for i = 0, cbSameCardResultCount-1 do
            local bMerge = false
            for j = cbTakeCardCount-1, table.nums(AnalyseResult.cbBlockCount) - 1 do
                for k = 0, AnalyseResult.cbBlockCount[j]-1 do
                    --从小到大
                    local cbIndex = (AnalyseResult.cbBlockCount[j]-k-1)*(j+1)
                    --过滤相同牌
                    if GetCardValue(SameCardResult.cbResultCard[i][0]) == GetCardValue(AnalyseResult.cbCardData[j][cbIndex]) then
                    else
                        local cbCount = SameCardResult.cbCardCount[i]
                        CopyMemory(SameCardResult.cbResultCard[i], AnalyseResult.cbCardData[j], cbCount, cbIndex, cbTakeCardCount)
                        
                        SameCardResult.cbCardCount[i] = SameCardResult.cbCardCount[i] + cbTakeCardCount
                        if SameCardResult.cbCardCount[i] < cbNeedCount then
                        else
                            if pSearchCardResult == nil then
                                return 1
                            end
                            --复制结果
                            CopyMemory(pSearchCardResult.cbResultCard[cbResultCount], SameCardResult.cbResultCard[i], 0, 0, SameCardResult.cbCardCount[i])
                            pSearchCardResult.cbCardCount[cbResultCount] = SameCardResult.cbCardCount[i]
                            cbResultCount = cbResultCount + 1
                            bMerge = true
                            --下一组合
                            break
                        end
                    end
                end
                if bMerge then
                    break
                end
            end
        end
    end
    
    if pSearchCardResult then
        pSearchCardResult.cbSearchCount = cbResultCount
    end
    return cbResultCount
end

--连牌搜索
function LordGameLogic:SearchLineCardType(cbHandCardData, cbHandCardCount, cbReferCard, cbBlockCount, cbLineCount, pSearchCardResult)
    --设置结果
    if pSearchCardResult then
        self:ZeroSearchCardResultMemory(pSearchCardResult)
    end
    local cbResultCount = 0
    --定义变量
    local cbLessLineCount = 0
    if cbLineCount == 0  then
        if cbBlockCount == 1 then
            cbLessLineCount = 5
        elseif cbBlockCount == 2 then
            cbLessLineCount = 3
        else 
            cbLessLineCount = 2
        end
    else
        cbLessLineCount = cbLineCount
    end
    local cbReferIndex = 2
    if cbReferCard ~= 0 then
        if (self:GetCardLogicValue(cbReferCard)-cbLessLineCount < 2) then
            print("LordGameLogic:SearchLineCardType error 1")
            cc.exports.FloatMessage.getInstance():pushMessageDebug("LordGameLogic:SearchLineCardType error 1")
            return 0
        end
        cbReferIndex = self:GetCardLogicValue(cbReferCard)-cbLessLineCount+1
    end
    --超过A
    if cbReferIndex+cbLessLineCount > 14 then
        return cbResultCount
    end
    --长度判断
    if cbHandCardCount < cbLessLineCount*cbBlockCount then
        return cbResultCount
    end
    --构造扑克
    local cbCardData = {}
    local cbCardCount = cbHandCardCount
    CopyMemory(cbCardData, cbHandCardData, 0, 0, cbHandCardCount)
    --排列扑克
    self:SortCardList(cbCardData, cbCardCount, ST_ORDER)
    --分析扑克
    local Distributing = {}
    self:AnalysebDistributing(cbCardData, cbCardCount, Distributing)
    --搜索顺子
    local cbTmpLinkCount = 0
    local cbValueIndex = 0
    for i = cbReferIndex, 13-1, 1 do
        cbValueIndex = i
        local countinue = false
        if Distributing.cbDistributing[cbValueIndex][cbIndexCount] < cbBlockCount then
            if cbTmpLinkCount < cbLessLineCount then
                cbTmpLinkCount = 0
                countinue = true
            else
                cbValueIndex = cbValueIndex - 1
            end
        else
            cbTmpLinkCount = cbTmpLinkCount + 1
            --寻找最长连
            if cbLineCount == 0 then
                countinue = true
            end
        end
        if not countinue then
            if cbTmpLinkCount >= cbLessLineCount then
                if not pSearchCardResult then
                    return 1
                end
                if (cbResultCount >= table.nums(pSearchCardResult.cbCardCount)) then
                    print("LordGameLogic:SearchLineCardType error 2")
                    cc.exports.FloatMessage.getInstance():pushMessageDebug("LordGameLogic:SearchLineCardType error 2")
                    return 0
                end
                --复制扑克
                local cbCount = 0
                for cbIndex = cbValueIndex + 1 - cbTmpLinkCount, cbValueIndex, 1 do
                    local cbTmpCount = 0
                    for cbColorIndex = 0, 3, 1 do
                        for cbColorCount = 0, Distributing.cbDistributing[cbIndex][3-cbColorIndex] - 1, 1 do
                            pSearchCardResult.cbResultCard[cbResultCount][cbCount] = self:MakeCardData(cbIndex, 3-cbColorIndex)
                            cbCount = cbCount + 1
                            cbTmpCount = cbTmpCount + 1
                            if cbTmpCount == cbBlockCount then
                                break
                            end
                        end
                        if cbTmpCount == cbBlockCount then
                            break
                        end
                    end
                end
                --设置变量
                pSearchCardResult.cbCardCount[cbResultCount] = cbCount
                cbResultCount = cbResultCount + 1
                
                if cbLineCount ~= 0 then
                    cbTmpLinkCount = cbTmpLinkCount - 1
                else
                    cbTmpLinkCount = 0
                end
            end
        end
        cbValueIndex = cbValueIndex + 1
    end
    --特殊顺子
    if (cbTmpLinkCount >= cbLessLineCount-1 and cbValueIndex == 13) then
        if Distributing.cbDistributing[0][cbIndexCount] >= cbBlockCount or cbTmpLinkCount >= cbLessLineCount then
            if not pSearchCardResult then
                return 1
            end
            if (cbResultCount >= table.nums(pSearchCardResult.cbCardCount)) then
                print("LordGameLogic:SearchLineCardType error 3")
                cc.exports.FloatMessage.getInstance():pushMessageDebug("LordGameLogic:SearchLineCardType error 3")
                return 0
            end
            --复制扑克
            local cbCount = 0
            local cbTmpCount = 0
            for cbIndex = cbValueIndex-cbTmpLinkCount, 13-1, 1 do
                cbTmpCount = 0
                for cbColorIndex = 0, 3 do
                    for cbColorCount = 0, Distributing.cbDistributing[cbIndex][3-cbColorIndex] - 1, 1 do
                        pSearchCardResult.cbResultCard[cbResultCount][cbCount] = self:MakeCardData(cbIndex, 3-cbColorIndex)
                        cbCount = cbCount + 1
                        cbTmpCount = cbTmpCount + 1
                        if cbTmpCount == cbBlockCount then
                            break
                        end
                    end
                    if cbTmpCount == cbBlockCount then
                        break
                    end
                end
            end

            --复制A
            if Distributing.cbDistributing[0][cbIndexCount] >= cbBlockCount then
                cbTmpCount = 0
                for cbColorIndex = 0, 3, 1 do
                    for cbColorCount = 0, Distributing.cbDistributing[0][3-cbColorIndex]-1, 1 do
                        pSearchCardResult.cbResultCard[cbResultCount][cbCount] = self:MakeCardData(0, 3-cbColorIndex)
                        cbCount = cbCount + 1
                        cbTmpCount = cbTmpCount + 1
                        if cbTmpCount == cbBlockCount then
                            break
                        end
                    end
                    if cbTmpCount == cbBlockCount then
                        break
                    end
                end
            end
            --设置变量
            pSearchCardResult.cbCardCount[cbResultCount] = cbCount
            cbResultCount = cbResultCount + 1
        end
    end

    if pSearchCardResult then
        pSearchCardResult.cbSearchCount = cbResultCount
    end
    return cbResultCount
end

--搜索飞机
function LordGameLogic:SearchThreeTwoLine(cbHandCardData, cbHandCardCount, pSearchCardResult)
    --设置结果
    if pSearchCardResult then
        self:ZeroSearchCardResultMemory(pSearchCardResult)
    end

    local tmpSearchResult = {}
    self:ZeroSearchCardResultMemory(tmpSearchResult)
    local tmpSingleWing = {}
    self:ZeroSearchCardResultMemory(tmpSingleWing)
    local tmpDoubleWing = {}
    self:ZeroSearchCardResultMemory(tmpDoubleWing)
    local cbTmpResultCount = 0

    --搜索连牌
    cbTmpResultCount = self:SearchLineCardType(cbHandCardData, cbHandCardCount, 0, 3, 0, tmpSearchResult)
    if cbTmpResultCount > 0 then
        --提取带牌
        for i = 0, cbTmpResultCount-1, 1 do
            local continue = false
            --变量定义
            local cbTmpCardData = {}
            local cbTmpCardCount = cbHandCardCount
            --不够牌
            if (cbHandCardCount-tmpSearchResult.cbCardCount[i]) < math.floor(tmpSearchResult.cbCardCount[i]/3) then
                local cbNeedDelCount = 3
                while ( (cbHandCardCount + cbNeedDelCount - tmpSearchResult.cbCardCount[i]) < (math.floor(tmpSearchResult.cbCardCount[i]-cbNeedDelCount)/3)) do
                    cbNeedDelCount = cbNeedDelCount + 3
                end
                --不够连牌
                if math.floor(tmpSearchResult.cbCardCount[i]-cbNeedDelCount)/3 < 2 then
                    --废除连牌
                    continue = true
                else
                    --拆分连牌
                    self:RemoveCard(tmpSearchResult.cbResultCard[i], cbNeedDelCount, tmpSearchResult.cbResultCard[i], tmpSearchResult.cbCardCount[i])
                    tmpSearchResult.cbCardCount[i] = tmpSearchResult.cbCardCount[i] - cbNeedDelCount
                end
            end

            if not pSearchCardResult then
                return 1
            end
  
            do --修复：飞机里检测炸弹
                local TmpResult = {}
                self:AnalysebCardData(cbHandCardData, cbHandCardCount, TmpResult)
                if TmpResult.cbBlockCount[3] > 0 then --有炸弹
                    continue = true
                end
            end

            if not continue then
                --删除连牌
                CopyMemory(cbTmpCardData, cbHandCardData, 0, 0, cbHandCardCount)
                --断言
                local bRemoveSuccess = self:RemoveCard(tmpSearchResult.cbResultCard[i], tmpSearchResult.cbCardCount[i], cbTmpCardData, cbTmpCardCount)
                if bRemoveSuccess == false then
                    print("LordGameLogic:SearchThreeTwoLine error 1")
                    cc.exports.FloatMessage.getInstance():pushMessageDebug("LordGameLogic:SearchThreeTwoLine error 1")
                    return 0
                end
                cbTmpCardCount = cbTmpCardCount - tmpSearchResult.cbCardCount[i]
                --组合飞机
                local cbNeedCount = math.floor(tmpSearchResult.cbCardCount[i]/3)
                if (cbNeedCount > cbTmpCardCount) then
                    print("LordGameLogic:SearchThreeTwoLine error 2")
                    cc.exports.FloatMessage.getInstance():pushMessageDebug("LordGameLogic:SearchThreeTwoLine error 2")
                    return 0
                end
                --修复:如果剩牌3张是同牌
                local cbTmpSameCount = self:SearchSameCard(cbTmpCardData, cbTmpCardCount, 0, 3, {})
                if cbTmpSameCount > 0 then
                    return 0
                end
                --修复:如果剩牌4张是同牌
                local cbTmpSameCount = self:SearchSameCard(cbTmpCardData, cbTmpCardCount, 0, 4, {})
                if cbTmpSameCount > 0 then
                    return 0
                end
                --拷贝飞机
                local cbResultCount =  tmpSingleWing.cbSearchCount
                tmpSingleWing.cbSearchCount = tmpSingleWing.cbSearchCount + 1
                tmpSingleWing.cbResultCard[cbResultCount] = CopyMemory(tmpSingleWing.cbResultCard[cbResultCount], tmpSearchResult.cbResultCard[i], 0, 0, tmpSearchResult.cbCardCount[i])
                tmpSingleWing.cbResultCard[cbResultCount] = CopyMemory(tmpSingleWing.cbResultCard[cbResultCount], cbTmpCardData, tmpSearchResult.cbCardCount[i], cbTmpCardCount - cbNeedCount, cbNeedCount)
                tmpSingleWing.cbCardCount[i] = tmpSearchResult.cbCardCount[i]+cbNeedCount

                --不够带翅膀
                if cbTmpCardCount < math.floor(tmpSearchResult.cbCardCount[i]/3)*2 then
                    local cbNeedDelCount = 3
                    while cbTmpCardCount + cbNeedDelCount - tmpSearchResult.cbCardCount[i] < math.floor((tmpSearchResult.cbCardCount[i]-cbNeedDelCount)/3)*2 do
                        cbNeedDelCount = cbNeedDelCount + 3
                    end
                    --不够连牌
                    if math.floor((tmpSearchResult.cbCardCount[i]-cbNeedDelCount)/3) < 2 then
                        --废除连牌
                        continue = true
                    else
                        --拆分连牌
                        self:RemoveCard( tmpSearchResult.cbResultCard[i], cbNeedDelCount, tmpSearchResult.cbResultCard[i], tmpSearchResult.cbCardCount[i])
                        tmpSearchResult.cbCardCount[i] = tmpSearchResult.cbCardCount[i] - cbNeedDelCount
                        --重新删除连牌
                        CopyMemory(cbTmpCardData, cbHandCardData, 0, 0, cbHandCardCount)
                        local bRemoveSuccess = self:RemoveCard(tmpSearchResult.cbResultCard[i], tmpSearchResult.cbCardCount[i], cbTmpCardData, cbTmpCardCount)
                        if bRemoveSuccess == false then
                            print("LordGameLogic:SearchThreeTwoLine error 3")
                            cc.exports.FloatMessage.getInstance():pushMessageDebug("LordGameLogic:SearchThreeTwoLine error 3")
                            return 0
                        end
                        cbTmpCardCount = cbHandCardCount-tmpSearchResult.cbCardCount[i]
                    end
                end

                if not continue then
                    --分析牌
                    local TmpResult = {}
                    self:AnalysebCardData(cbTmpCardData, cbTmpCardCount, TmpResult)

                    --提取翅膀
                    local cbDistillCard = {}
                    local cbDistillCount = 0
                    local cbLineCount = math.floor(tmpSearchResult.cbCardCount[i]/3)

                    for j = 1, table.nums(TmpResult.cbBlockCount)-1 do
                        if TmpResult.cbBlockCount[j] > 0 then
                            if j + 1 == 2 and TmpResult.cbBlockCount[j] >= cbLineCount then
                                local cbTmpBlockCount = TmpResult.cbBlockCount[j]
                                cbDistillCard = CopyMemory(cbDistillCard, TmpResult.cbCardData[j], 0, (cbTmpBlockCount-cbLineCount)*(j+1) ,(j+1)*cbLineCount)
                                cbDistillCount = (j+1)*cbLineCount
                                break
                            else
                                for k = 0, TmpResult.cbBlockCount[j]-1 do
                                    local cbTmpBlockCount = TmpResult.cbBlockCount[j]
                                    cbDistillCard = CopyMemory(cbDistillCard, TmpResult.cbCardData[j], cbDistillCount, (cbTmpBlockCount-k-1)*(j+1), 2)
                                    cbDistillCount = cbDistillCount + 2
                                    --提取完成
                                    if cbDistillCount == 2*cbLineCount then
                                        break
                                    end
                                end
                            end
                        end
                        --提取完成
                        if cbDistillCount == 2*cbLineCount then
                            break
                        end
                    end
                    --提取完成
                    if cbDistillCount == 2*cbLineCount then
                        --复制翅膀
                        cbResultCount = tmpDoubleWing.cbSearchCount
                        tmpDoubleWing.cbSearchCount = tmpDoubleWing.cbSearchCount + 1
                        tmpDoubleWing.cbResultCard[cbResultCount] = 
                            CopyMemory(tmpDoubleWing.cbResultCard[cbResultCount], tmpSearchResult.cbResultCard[i], 0, 0, tmpSearchResult.cbCardCount[i])
                        tmpDoubleWing.cbResultCard[cbResultCount] = 
                            CopyMemory(tmpDoubleWing.cbResultCard[cbResultCount], cbDistillCard, tmpSearchResult.cbCardCount[i], 0, cbDistillCount)
                        
                        tmpDoubleWing.cbCardCount[i] = tmpSearchResult.cbCardCount[i] + cbDistillCount
                    end
                end
            end
        end

        --复制结果
        for i = 0, tmpDoubleWing.cbSearchCount-1 do
            local cbResultCount = pSearchCardResult.cbSearchCount
            pSearchCardResult.cbSearchCount = pSearchCardResult.cbSearchCount + 1
            pSearchCardResult.cbResultCard[cbResultCount] = 
                CopyMemory(pSearchCardResult.cbResultCard[cbResultCount], tmpDoubleWing.cbResultCard[i], 0, 0, tmpDoubleWing.cbCardCount[i])
            pSearchCardResult.cbCardCount[cbResultCount] = tmpDoubleWing.cbCardCount[i]
        end

        for i = 0, tmpSingleWing.cbSearchCount-1 do
            local cbResultCount = pSearchCardResult.cbSearchCount
            pSearchCardResult.cbSearchCount = pSearchCardResult.cbSearchCount + 1
            pSearchCardResult.cbResultCard[cbResultCount] = 
                CopyMemory(pSearchCardResult.cbResultCard[cbResultCount], tmpSingleWing.cbResultCard[i], 0, 0, tmpSingleWing.cbCardCount[i])    
            pSearchCardResult.cbCardCount[cbResultCount] = tmpSingleWing.cbCardCount[i]
        end
    end
    local SearchCount = 0
    if pSearchCardResult then
        SearchCount = pSearchCardResult.cbSearchCount
    end
    return SearchCount
end

--效验扑克数据
function LordGameLogic:CheckCardData(cbCardData, cbCardCount)
    --判断是否是存在于牌库里的牌
    for i = 0, cbCardCount-1 do
        local bValid = false
        for j = 1, FULL_COUNT do --m_cbCardData从1开始
            if cbCardData[i] == m_cbCardData[j] then
                bValid = true
                break
            end
        end
        if not bValid then
            print("错误牌数据:%d",cbCardData[i])
            cc.exports.FloatMessage.getInstance():pushMessageDebug("错误牌数据")
            return false;
        end
    end
    --判断是否有两张相同的牌
    for i = 0, cbCardCount-1 do
        for  j = i + 1, cbCardCount-1 do
            if cbCardData[i] == cbCardData[j] then
                print("重复牌数据:%d",cbCardData[i])
                cc.exports.FloatMessage.getInstance():pushMessageDebug("重复牌数据")
                return false
            end
        end
    end
    return true
end

return LordGameLogic
--endregion
