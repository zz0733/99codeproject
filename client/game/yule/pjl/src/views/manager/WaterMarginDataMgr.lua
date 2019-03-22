--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local WaterMarginDataMgr = class("WaterMarginDataMgr")  
local module_pre                = "game.yule.pjl.src"
local csv_shz850New             = appdf.req(module_pre .. ".views.csv_shz850New")

WaterMarginDataMgr.instance = nil

local WATER_MAX_LINE_NUM = 9
local WATER_LINE_CARD_COUNT = 5
local WATER_MARGIN_ICON_NUM = 9
local WATER_ICON_ROW = 3                    --行
local WATER_ICON_COL = 5                    --列

local BUY_FAIL = -1
local BUY_SMALL = 0
local BUY_TIE = 1
local BUY_BIG = 2

local WATER_MAX_LITTLE_MARY_ICON_NUM =24   --小玛丽中外围滚动最大牌子数


WaterMarginDataMgr.eGAME_HANDLE_IDLE = 0            --进入空闲状态
WaterMarginDataMgr.eGAME_HANDLE_OPEN = 1            --进入开奖状态
WaterMarginDataMgr.eGAME_HANDLE_RESULT = 2          --进入结算状态


WaterMarginDataMgr.Order_Result = 3           --结算界面
WaterMarginDataMgr.Order_Compare = 9          --比倍界面
WaterMarginDataMgr.Order_LittleMary = 10       --小玛丽界面
WaterMarginDataMgr.Order_LittleMaryWait = 12  --等待小玛丽开始界面

WaterMarginDataMgr.m_cbCardJoinLineDate =
{
    {cc.p(1,0),cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4)},			--0
    {cc.p(0,0),cc.p(0,1),cc.p(0,2),cc.p(0,3),cc.p(0,4)},			--1
    {cc.p(2,0),cc.p(2,1),cc.p(2,2),cc.p(2,3),cc.p(2,4)},          --2
    {cc.p(0,0),cc.p(1,1),cc.p(2,2),cc.p(1,3),cc.p(0,4)},			--3
    {cc.p(2,0),cc.p(1,1),cc.p(0,2),cc.p(1,3),cc.p(2,4)},          --4
    {cc.p(0,0),cc.p(0,1),cc.p(1,2),cc.p(0,3),cc.p(0,4)},			--5
    {cc.p(2,0),cc.p(2,1),cc.p(1,2),cc.p(2,3),cc.p(2,4)},          --6
    {cc.p(1,0),cc.p(2,1),cc.p(2,2),cc.p(2,3),cc.p(1,4)},          --7
    {cc.p(1,0),cc.p(0,1),cc.p(0,2),cc.p(0,3),cc.p(1,4)},			--8
};

WaterMarginDataMgr.m_cbCardBei =
{
    {2,  5,  20,  50},      -- 斧头
    {3,  10, 40,  100,},    -- 银枪
    {5,  15, 60,  150},     -- 大刀
    {7,  20, 100, 250},     -- 鲁智深
    {10, 30, 160, 400},     -- 林冲
    {15, 40, 200, 500},     -- 宋江
    {20, 80, 400, 1000},    -- 替天行道
    {50, 200,1000, 2500},   -- 忠义堂
    {1, 1, 2000, 5000 },    -- 水浒传
};

--小玛丽次数
WaterMarginDataMgr.m_cbWaterMarginNum = {1, 2, 3, 27 };

WaterMarginDataMgr.WaterMarginGameIcon =
{
	0,  -- 斧头
	1,  -- 银枪
	2,  -- 大刀
	3,  -- 鲁智深
	4,  -- 林冲
	5,  -- 宋江
	6,  -- 替天行道
	7,  -- 忠义堂
	8   -- 水浒传
}

local GI_FUTOU = 0         -- 斧头
local GI_YINGQIANG = 1     -- 银枪
local GI_DADAO = 2         -- 大刀
local GI_LU = 3            -- 鲁智深
local GI_LIN = 4           -- 林冲
local GI_SONG = 5          -- 宋江
local GI_TITIANXINGDAO = 6 -- 替天行道
local GI_ZHONGYITANG = 7   -- 忠义堂
local GI_SHUIHUZHUAN = 8   -- 水浒传
local GI_COUNT = 9

WaterMarginDataMgr.m_cbLittleMaryIcon =
{
    GI_SHUIHUZHUAN,GI_LIN,GI_YINGQIANG,GI_FUTOU,GI_DADAO,GI_TITIANXINGDAO,GI_SHUIHUZHUAN,
    GI_LU,GI_YINGQIANG,GI_ZHONGYITANG,GI_FUTOU,GI_DADAO,
    GI_SHUIHUZHUAN,GI_SONG,GI_LU,GI_YINGQIANG,GI_FUTOU,GI_TITIANXINGDAO,GI_SHUIHUZHUAN,
    GI_LIN,GI_DADAO,GI_FUTOU,GI_LU,GI_SONG
}

WaterMarginDataMgr.m_cbMixCardBei =
{
    50, --三人物混合全盘
    15, --三武器混合全盘
}

local WIN_ALL_NOT = -1       --没有全屏
local WIN_ALL_MIX_ROLE = 9   --所有人物混合
local WIN_ALL_MIX_WEAPON  = 10    --所有武器混合

function WaterMarginDataMgr:ctor()
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    self:clear()
end

function WaterMarginDataMgr:getMixIconBei(nIndex)

    if(nIndex < 0 or nIndex >= 2)then
        return 0;
    end
    
    return self.m_cbMixCardBei[nIndex+1];
end

function WaterMarginDataMgr:clear()
    self.m_nLineNum = WATER_MAX_LINE_NUM
    self.m_nBaseBetNum = 1
    self.m_nBaseBetChangeMul = 1
    self.m_nBaseBetChangeNum = 1

    self.m_stuGameReusltLast = {}
    self.m_stuGameResult = {}
    self.vecWinResult = {}

    self.m_nLittleMaryCount = 0;

    self.m_Scene2CompareResult = {}

    self._eGameHandleStatus = self.eGAME_HANDLE_IDLE

    self.m_bIsAuto = false;
    
    self.m_stuGameResult.result_icons = {};
    self.m_stuGameReusltLast.result_icons = {};      
    for i=1,tonumber(WATER_ICON_ROW),1 do 
        self.m_stuGameResult.result_icons[i] = {};
        self.m_stuGameReusltLast.result_icons[i] = {};

        for j=1,tonumber(WATER_ICON_COL),1 do 
            local index = self:getRandomIconIndex();
            self.m_stuGameResult.result_icons[i][j] = index;
            self.m_stuGameReusltLast.result_icons[i][j] = index;            
        end
    end

    self.m_stuGameResult.llResultScore = 0;
    self.m_stuGameReusltLast.llResultScore = 0;
    self.m_stuGameResult.llResultMoney = 0
    self.m_stuGameReusltLast.llResultMoney = 0

    self.m_Scene2CompareResult.dice_points = 0;
    
    self:clearLittleMaryData();

    self.m_testEnableLittleMary = false

    self.vecCompareResult = {}
    for i = 1, 10 do
        table.insert(self.vecCompareResult, math.random(1, 2) == 2 and 2 or 0)
    end

    self.m_nWinMulti = 0
    self.m_nWinAllType = WIN_ALL_NOT
    self.m_mUserIntoMoney = 0
    self.m_mGameCompareBet = 0
end

function WaterMarginDataMgr:setUserIntoMoney( money_)  --设置玩家身上剩余的实际金额
    if money_ < 0 then
        return
    end
    self.m_mUserIntoMoney = money_
end
function WaterMarginDataMgr:getUserIntoMoney( )
    return self.m_mUserIntoMoney
end
function WaterMarginDataMgr:setGameCompareBet( money_)  --设置玩家比倍押注金额
    if money_ <= 0 then
        return
    end
    self.m_mGameCompareBet = money_
end
function WaterMarginDataMgr:getGameCompareBet( )
    return self.m_mGameCompareBet
end

function WaterMarginDataMgr:setTestEnableLittleMary(m_testEnableLittleMary)
    self.m_testEnableLittleMary = m_testEnableLittleMary
end
function WaterMarginDataMgr:getTestEnableLittleMary()
    return self.m_testEnableLittleMary
end


function WaterMarginDataMgr:clearLittleMaryData()

    self.m_Scene3LittleMaryResult = {}
    self.m_Scene3LittleMaryResult.rolling_result_icons = {}

    self.m_LastScene3LittleMaryResult = {}
    self.m_LastScene3LittleMaryResult.rolling_result_icons = {}
    
    self.m_Scene3LittleMaryResult.rotate_result = 0;
    self.m_Scene3LittleMaryResult.llResultScore = 0;
    self.m_LastScene3LittleMaryResult.rotate_result = 0;
    self.m_LastScene3LittleMaryResult.llResultScore = 0;
    for i=1,tonumber(4),1 do 
        self.m_Scene3LittleMaryResult.rolling_result_icons[i] = 0;
        self.m_LastScene3LittleMaryResult.rolling_result_icons[i] = 0;
    end
    self.m_nLastIndex = 0;
    self.m_nDstIndex = 0;

end


function WaterMarginDataMgr:getRandomIconIndex()
    local num = 0;
    num = math.random(1,9)-1
    return num;
end

function WaterMarginDataMgr:getParserCompareResult()
    local dice_points = self.m_Scene2CompareResult.dice_points;
    
    local m_DicePoints={}; 
--    m_DicePoints.low = bit.band(dice_points , 0x00ff)
--    --m_DicePoints.low = dice_points & 0x00ff
--    m_DicePoints.height = bit.rshift(dice_points , 8)
    m_DicePoints.low    = dice_points[1]
    m_DicePoints.height = dice_points[2]
    
    return m_DicePoints;
end


function WaterMarginDataMgr:getParserCompareResultInfo()

    local resultInfo = {};
    
    local parserCompareResult = self:getParserCompareResult();
    local sumVal = parserCompareResult.height + parserCompareResult.low;
    
    resultInfo.isDouble = (parserCompareResult.height == parserCompareResult.low)
    
    if((sumVal < 2) or (sumVal > 12))then
        --fail
        resultInfo.iType = BUY_FAIL;
    elseif(sumVal <= 6)then
        --SMALL
        resultInfo.iType = BUY_SMALL;
    elseif(sumVal < 8)then
        --TIE
        resultInfo.iType = BUY_TIE;
    elseif(sumVal <= 12)then
        --BIG
        resultInfo.iType = BUY_BIG;
    end
    
    return resultInfo;
end


function WaterMarginDataMgr:checkWinAll()

    local isAllRole = true;
    local isAllWeapon = true;
    local icon_count = {0,0,0,0,0,0,0,0,0,0};
    for i=1,tonumber(WATER_ICON_ROW),1 do 
        for j=1,tonumber(WATER_ICON_COL),1 do 
            icon_count[self.m_stuGameResult.result_icons[i][j]+1] = icon_count[self.m_stuGameResult.result_icons[i][j]+1] + 1
        end
    end

    for icon=1,tonumber(10),1 do 
        if (icon_count[icon] == WATER_ICON_ROW*WATER_ICON_COL)then
            return icon-1;
        end

        if(((icon < 4) or (icon > 6)) and (icon_count[icon] > 0))then
            isAllRole = false;
        end

        if((icon > 3) and (icon_count[icon] > 0))then
            isAllWeapon = false;
        end
    end

    local resultType = WIN_ALL_NOT;--没有全屏奖励
    if(isAllRole) then
        resultType = WIN_ALL_MIX_ROLE;
    end
    if(isAllWeapon) then 
        resultType = WIN_ALL_MIX_WEAPON;
    end
    
    return resultType;
end

--是否有全屏
function WaterMarginDataMgr:getWinAllType()
    return self.m_nWinAllType
end

--赢的总倍数
function WaterMarginDataMgr:getWinMulti()
    return self.m_nWinMulti
end

function WaterMarginDataMgr:getGameResult()
    return self.m_stuGameResult;
end


function WaterMarginDataMgr:getGameResultLast()
    return self.m_stuGameReusltLast;
end


function WaterMarginDataMgr:getCurTotalBetNum()
    local nCurrentBetMoney = 0;
    nCurrentBetMoney = self.m_nLineNum * (self.m_nBaseBetNum * self.m_nBaseBetChangeMul);
    return nCurrentBetMoney;
end
function WaterMarginDataMgr:updataLast_llResultMoney()  --从比倍出来同步比倍结束的钱为上局钱数
    print("比倍之后余额__________________"..self:getUserIntoMoney())
    self.m_stuGameReusltLast.llResultMoney = self:getUserIntoMoney()
end

function WaterMarginDataMgr:setGameCompareResult(compareRes)
    self.m_Scene2CompareResult = compareRes;
    if compareRes.llResultScore>0 then
        
        self:setUserIntoMoney(compareRes.llResultScore)
    end
    
end

function WaterMarginDataMgr:addGameCompareResult()
    local result = self:getParserCompareResultInfo()
    table.insert(self.vecCompareResult, result.iType)
end

function WaterMarginDataMgr:getLineTypeAtIndex(cbLineIndex, nIconIndex)

    local lineData = self.m_cbCardJoinLineDate[cbLineIndex][nIconIndex];
    local iLineType = self.m_stuGameResult.result_icons[lineData.x+1][lineData.y+1]
    --WaterMarginGameIcon iLineType = (WaterMarginGameIcon)(m_stuGameResult.result_icons[(int)lineData.x][(int)lineData.y]);
    return iLineType;
end

function WaterMarginDataMgr:getLineTypeCountByLeft(cbLineIndex)

    local iLineType = self:getLineTypeAtIndex(cbLineIndex, 1);--返回0 - 8
    local pay_line_count = 0;
    
    for i=1,tonumber(GI_COUNT-1),1 do 
        if iLineType ~= self.WaterMarginGameIcon[i] and iLineType ~= self.WaterMarginGameIcon[GI_SHUIHUZHUAN+1] then
        else
            local temp_count = 0;
            for k=1,tonumber(WATER_ICON_COL),1 do 
                local iLineTypeTemp = self:getLineTypeAtIndex(cbLineIndex, k);
                if iLineTypeTemp ~= self.WaterMarginGameIcon[i] and iLineTypeTemp ~= self.WaterMarginGameIcon[GI_SHUIHUZHUAN+1] then
                    break
                end
                temp_count = temp_count + 1
            end

            if(temp_count > pay_line_count) then
                pay_line_count = temp_count;       
            end     
        end
    end
    return pay_line_count;
end

function WaterMarginDataMgr:getLineTypeCountByRight(cbLineIndex)
    local iLineType = self:getLineTypeAtIndex(cbLineIndex, WATER_ICON_COL);
    local pay_line_count = 0;
    for i=1,tonumber(GI_COUNT-1),1 do 
        if iLineType ~= self.WaterMarginGameIcon[i] and iLineType ~= self.WaterMarginGameIcon[GI_SHUIHUZHUAN+1] then
        else
            local temp_count = 0;
            for k=WATER_ICON_COL,tonumber(1),-1 do    
                local iLineTypeTemp = self:getLineTypeAtIndex(cbLineIndex, k);
                if iLineTypeTemp ~= self.WaterMarginGameIcon[i] and iLineTypeTemp ~= self.WaterMarginGameIcon[GI_SHUIHUZHUAN+1] then
                    break
                end
                temp_count = temp_count + 1
            end

            if(temp_count > pay_line_count) then
                pay_line_count = temp_count   
            end  
        end
    end
    return pay_line_count;
end

function WaterMarginDataMgr:getLineShuiHuZhuanCount(cbLineIndex)

    local icon_count = {0,0,0,0,0,0,0,0,0,0};
    for i=1,tonumber(WATER_ICON_ROW),1 do 
        for j=1,tonumber(WATER_ICON_COL),1 do 
            icon_count[self.m_stuGameResult.result_icons[i][j]+1] = icon_count[self.m_stuGameResult.result_icons[i][j]+1] + 1
        end
    end

    local pay_line_count = 0;
    if (icon_count[GI_SHUIHUZHUAN+1] >= 3)then
        for j=1,tonumber(WATER_ICON_COL),1 do 
            local iLineType = self:getLineTypeAtIndex(cbLineIndex, j);
            if (iLineType ~= self.WaterMarginGameIcon[GI_SHUIHUZHUAN+1])then
                break;
            end
            pay_line_count = pay_line_count + 1;
        end

        if(pay_line_count < 3)then
            pay_line_count = 0;
            for j=WATER_ICON_COL,tonumber(1),-1 do    
                local iLineType = self:getLineTypeAtIndex(cbLineIndex, j);
                if (iLineType ~= self.WaterMarginGameIcon[GI_SHUIHUZHUAN+1])then
                    break;
                end
                pay_line_count = pay_line_count + 1;
            end
        end
    end
    return pay_line_count;
end

function WaterMarginDataMgr:setGameResult(gameRes)--------------------------------------
    self.m_stuGameReusltLast = self.m_stuGameResult;
    self:updataLast_llResultMoney()
    self.m_stuGameResult = gameRes;
    self:setUserIntoMoney(gameRes.llResultMoney)

    self.vecWinResult = {}
    self.m_nLittleMaryCount = 0
    self.m_nWinMulti = 0
    self.m_nWinAllType = WIN_ALL_NOT 
               
    --存放中间信息
    for i=1,tonumber(WATER_MAX_LINE_NUM),1 do   --WATER_MAX_LINE_NUM = 9
        local iconCount = {0,0,0}
        iconCount[1] = self:getLineTypeCountByLeft(i);
        iconCount[2] = self:getLineTypeCountByRight(i);
        iconCount[3] = self:getLineShuiHuZhuanCount(i);
        --print("---- "..iconCount[1].." "..iconCount[2].." "..iconCount[3])
        if(iconCount[1] < 3 and iconCount[2] < 3 and iconCount[3] < 3)then
        else
            local temp = {};
            temp.nLineIndex = i;
            temp.vecIconsIndexData = {}
            temp.vecIconsIndexData[1] = {}
            temp.vecIconsIndexData[2] = {}
            temp.vecIconsIndexData[3] = {}

            if (iconCount[1] >= 3)then
                for k=1,iconCount[1],1 do 
                    local info = {};
                    info.giType = self:getLineTypeAtIndex(i, k);
                    info.pos = self.m_cbCardJoinLineDate[i][k];
                    table.insert(temp.vecIconsIndexData[1],info)
                end
            end

            if ((iconCount[2] >= 3) and (iconCount[1] < 5))then
                for k=WATER_ICON_COL -1 ,WATER_ICON_COL-iconCount[2],-1 do    
                    local info = {};
                    info.giType = self:getLineTypeAtIndex(i, k+1);
                    info.pos = self.m_cbCardJoinLineDate[i][k+1];
                    table.insert(temp.vecIconsIndexData[2],info)
                end
            end

            if (iconCount[3] >= 3)then
                for k=1,WATER_ICON_COL,1 do 
                    local iconType = WaterMarginDataMgr.getInstance():getLineTypeAtIndex(i, k);
                    if (iconType ~= self.WaterMarginGameIcon[GI_SHUIHUZHUAN+1])then
                    else
                        local info = {};
                        info.giType = self.WaterMarginGameIcon[GI_SHUIHUZHUAN+1];
                        info.pos = self.m_cbCardJoinLineDate[i][k];
                        table.insert(temp.vecIconsIndexData[3],info)
                    end
                end
                self.m_nLittleMaryCount = self.m_nLittleMaryCount + self:getAwardMaryNum(iconCount[3]-3);
            end

            table.insert(self.vecWinResult,temp)
        end
        
    end

    self.m_nWinAllType = self:checkWinAll()
    self.m_nWinMulti = self:calculateWinMulti()
    return self.m_nLittleMaryCount
end

--计算赢的总倍数
function WaterMarginDataMgr:calculateWinMulti()

    local winMulti = 0
    local winLineIndexIcon = {} --单线中奖图标索引
    local nWinLineNum = self:getWinResultNum()
    for i = 1, nWinLineNum do 
        local resultInfo = self:getWinResultAtIndex(i)
        for j=1, 2 do --//计算左右
            if(#resultInfo.vecIconsIndexData[j] >= 3)then
                if j == 1 then
                    table.insert(winLineIndexIcon, resultInfo.vecIconsIndexData[1])
                else 
                    table.insert(winLineIndexIcon,resultInfo.vecIconsIndexData[2])
                end
            end
        end
    end
    local nWinCount = table.nums(winLineIndexIcon)
    if nWinCount == 0 then
        return
    end
    for i=1, nWinCount do
        local nType = winLineIndexIcon[i][1].giType
        local nCount = table.nums(winLineIndexIcon[i])
        for j =1, table.nums(winLineIndexIcon[i]) do 
            if winLineIndexIcon[i][j].giType ~= 8 then
                nType = winLineIndexIcon[i][j].giType
                break
            end
        end
        winMulti = winMulti + self.m_cbCardBei[nType+1][nCount-2]
    end
    return winMulti
end


--获取倍率
function WaterMarginDataMgr:getIconBei(nType,nIndex)

    if(nType < 0 or nType >= WATER_MARGIN_ICON_NUM or nIndex < 0 or nIndex >= 4)then
        return 0;
    end
    return self.m_cbCardBei[nType+1][nIndex+1];
end

function WaterMarginDataMgr:getAwardMaryNum(nIndex)
    if(nIndex < 0 or nIndex >= 4)then
        return 0;
    end
    return self.m_cbWaterMarginNum[nIndex+1];
end

function WaterMarginDataMgr:getWinResultNum()
    local num = #self.vecWinResult
    return num;
end

function WaterMarginDataMgr:getGameCompareAwardGold()
    return self.m_Scene2CompareResult.llResultScore;
end

function WaterMarginDataMgr:getWinResultAtIndex(index)

    local temp = {};
    if(index <= #self.vecWinResult)then
        temp = self.vecWinResult[index];
    end
    
    return temp;
end

function WaterMarginDataMgr:setLittleMaryResult(res)

    self.m_LastScene3LittleMaryResult = self.m_Scene3LittleMaryResult;
    self.m_Scene3LittleMaryResult = res;
    
    self.m_nTotalAwardGold = self.m_nTotalAwardGold + self.m_Scene3LittleMaryResult.llResultScore;
    
    self:setRollPointIndexInfo(self.m_Scene3LittleMaryResult);
end


function WaterMarginDataMgr:setRollPointIndexInfo(resultInfo)

    self.m_nLastIndex = self.m_nDstIndex;
    
    local vecIndex = {};
    for i=1,tonumber(WATER_MAX_LITTLE_MARY_ICON_NUM),1 do    
        if(self.m_cbLittleMaryIcon[i] == self.m_Scene3LittleMaryResult.rotate_result)then
            table.insert(vecIndex,i-1)
        end
    end

    
    if(#vecIndex > 0)then
        local randIndex = math.random(1,#vecIndex);
        self.m_nDstIndex = vecIndex[randIndex];
    end
end


function WaterMarginDataMgr:getPerLineTotalBetNum()

    local nCurrentBetMoney = 0;
    nCurrentBetMoney = self.m_nBaseBetNum * self.m_nBaseBetChangeMul;
    return nCurrentBetMoney;
end


function WaterMarginDataMgr:getLastLittleMaryResult()
    return self.m_LastScene3LittleMaryResult;
end


function WaterMarginDataMgr:setLastIndex(m_nLastIndex)
    self.m_nLastIndex = m_nLastIndex
end
function WaterMarginDataMgr:getLastIndex()
    return self.m_nLastIndex
end

function WaterMarginDataMgr:getLittleMaryResult()

    return self.m_Scene3LittleMaryResult;
end

function WaterMarginDataMgr:setDstIndex(m_nDstIndex)
    self.m_nDstIndex = m_nDstIndex
end
function WaterMarginDataMgr:getDstIndex()
    return self.m_nDstIndex
end

function WaterMarginDataMgr:setTotalAwardGold(m_nTotalAwardGold)
    self.m_nTotalAwardGold = m_nTotalAwardGold
end
function WaterMarginDataMgr:getTotalAwardGold()
    return self.m_nTotalAwardGold
end

function WaterMarginDataMgr:setIsAuto(m_bIsAuto)
    self.m_bIsAuto = m_bIsAuto
end
function WaterMarginDataMgr:getIsAuto()
    return self.m_bIsAuto
end

function WaterMarginDataMgr:getLittleMaryAwardGold()
    return self.m_Scene3LittleMaryResult.llResultScore;
end

function WaterMarginDataMgr:setLittleMaryCount(m_nLittleMaryCount)
    self.m_nLittleMaryCount = m_nLittleMaryCount
end
function WaterMarginDataMgr:getLittleMaryCount()
    return self.m_nLittleMaryCount
end

function WaterMarginDataMgr:setGameHandleStatus(_eGameHandleStatus)
    self._eGameHandleStatus = _eGameHandleStatus
end
function WaterMarginDataMgr:getGameHandleStatus()
    return self._eGameHandleStatus
end

function WaterMarginDataMgr:setBaseBetChangeNum(m_nBaseBetChangeNum)
    self.m_nBaseBetChangeNum = m_nBaseBetChangeNum
end
function WaterMarginDataMgr:getBaseBetChangeNum()
    return self.m_nBaseBetChangeNum
end


function WaterMarginDataMgr:setBaseBetChangeMul(m_nBaseBetChangeMul)
    self.m_nBaseBetChangeMul = m_nBaseBetChangeMul
end
function WaterMarginDataMgr:getBaseBetChangeMul()
    return self.m_nBaseBetChangeMul
end


function WaterMarginDataMgr:setBaseBetNum(m_nBaseBetNum)
    self.m_nBaseBetNum = m_nBaseBetNum
end
function WaterMarginDataMgr:getBaseBetNum()
    return self.m_nBaseBetNum
end


function WaterMarginDataMgr:setLineNum(m_nLineNum)
    self.m_nLineNum = m_nLineNum
end
function WaterMarginDataMgr:getLineNum()
    return self.m_nLineNum
end


function WaterMarginDataMgr.getInstance()
    if WaterMarginDataMgr.instance == nil then  
        WaterMarginDataMgr.instance = WaterMarginDataMgr.new()
    end  
    return WaterMarginDataMgr.instance  
end

function WaterMarginDataMgr.releaseInstance()
    WaterMarginDataMgr.instance = nil
end

function WaterMarginDataMgr:getRandomResult(multiple_bet_)
    local tab_multiple = {}     --存放和服务器通知结果相同倍数结果的表
    for key, var in ipairs(csv_shz850New) do
        if var.multiple_bet == multiple_bet_ then
            table.insert(tab_multiple,var)
        end
    end
    local num_ = #tab_multiple
    local index_ = math.random(1,num_)
    local tab_ = tab_multiple[index_]
    return tab_
end


return WaterMarginDataMgr

--endregion
