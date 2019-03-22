-- region FishSceneMgr.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 鱼阵数据管理类

local MOVE_FORWARD_PATH = 999
local module_pre = "game.yule.lkby.src.views."
local FishRes  = require(module_pre.."scene.FishSceneRes")
local MathAide = require(module_pre.."manager.MathAide")

local FishSceneMgr = class("FishSceneMgr")

FishSceneMgr.instance_ = nil 
function FishSceneMgr.getInstance()
    if FishSceneMgr.instance_ == nil then
        FishSceneMgr.instance_ = FishSceneMgr:new()
    end
    return FishSceneMgr.instance_
end

function FishSceneMgr.releaseInstance()
    FishSceneMgr.getInstance():Clear()
    FishSceneMgr.instance_ = nil
end

function FishSceneMgr:ctor()
    
    self.m_bAllSceneFishEnd = false
    self.m_mapSceneData = {}
    self.map_Path = {}

    self:Clear()
end

function FishSceneMgr:Clear()
    self.m_bAllSceneFishEnd = false
    self.m_mapSceneData = {}
    self.map_Path = {}
end

function FishSceneMgr:startLoadSceneFish()
      if not self.m_bAllSceneFishEnd then
        self.m_mapSceneData = {}
        self.map_Path = {}
        self:prepare_path()
        self:loadAllFishScene()
    end 
end
                 
function FishSceneMgr:loadAllFishScene()

    for i = 0, 7 do
        self:loadOneSceneFileByIndex(i)
    end
end

function FishSceneMgr:getSceneFileCount()
      return 8
end

-- nIndex 传 0-7
function FishSceneMgr:loadOneSceneFileByIndex(nIndex)
    local strScene = string.format(FishRes.FILE_OF_SCENE, nIndex)
    local ret = self:loadFishScene(strScene, nIndex)

    if nIndex == 7 then
        self.m_bAllSceneFishEnd = true 
    end
end

function FishSceneMgr:getFishScene(index)

    return self.m_mapSceneData[index]
end 

function FishSceneMgr:loadFishScene(strSceneFile, sceneIndex)
    local  startTime = os.clock()
    local switchFish = {}
    switchFish.fish_count = 0
    switchFish.fishDataMap = {}
    -- 鱼的基本信息
    local fish_id = 0
    local fish_kind = 0
    local fish_tag = 0

    -- 第一段路径的信息
    local path_id1 = 0
    local begin_step1 = 0
    local end_step1 = 0
    local offset_x1 = 0
    local offset_y1 = 0

    -- 第二段路径的信息
    local path_id2 = 0
    local begin_step2 = 0
    local end_step2 = 0
    local offset_x2 = 0
    local offset_y2 = 0

    --记录vec数量
    local index = 0
    local fileData = yl.readJsonFileByFileName(strSceneFile)
    --for key, value in pairs(fileData) do 
    --第一行["id","kind","tag","path_id1","begin_step1","end_step1","offset_x1","offset_y1","path_id2","begin_step2","end_step2","offset_x2","offset_y2"],
    for i = 2, #fileData do
        local value = fileData[i]

        --读取每个点
        fish_id     = tonumber(value[1])
        fish_kind   = tonumber(value[2])
        fish_tag    = tonumber(value[3])
        path_id1    = tonumber(value[4])
        begin_step1 = tonumber(value[5])
        end_step1   = tonumber(value[6])
        offset_x1   = tonumber(value[7])
        offset_y1   = tonumber(value[8])
        path_id2    = tonumber(value[9])
        begin_step2 = tonumber(value[10])
        end_step2   = tonumber(value[11])
        offset_x2   = tonumber(value[12])
        offset_y2   = tonumber(value[13])

        --处理
--        if begin_step1 == 0 then begin_step1 = 1 end
--        if end_step1 == 0 then end_step1 = 1 end 
--        if begin_step2 == 0 then begin_step2 = 1 end
--        if end_step2 == 0 then end_step2 = 1 end

        --这里要注意，路径数据是按照C++的习惯编辑的，下标从0开始，要修正为LUA的，下标从1开始
        -- 第一条路径
        local it = self.map_Path[path_id1]        
        if it ~= nil then
            -- 若路径的结束点为0，则默认到路径的最末尾
            local pathLen1 = #it[1]
            begin_step1 = begin_step1 + 1
            if  end_step1 == -1 then
                end_step1 = pathLen1 
            else
                end_step1 = end_step1 + 1
            end

            if  begin_step1 > pathLen1   then begin_step1 = pathLen1 end
            if  end_step1 > pathLen1    then end_step1   = pathLen1 end
        end

        -- 第二条路径
        local it2 = self.map_Path[path_id2]        
        if it2 ~= nil then
            -- 若路径的结束点为0，则默认到路径的最末尾
            local pathLen2 = #it2[1]
            begin_step2 = begin_step2 + 1
            if  end_step2 == -1 then 
                end_step2 = pathLen2 
            else
                end_step2 = end_step2 + 1
            end

            if  begin_step2 > pathLen2  then begin_step2 = pathLen2 end
            if  end_step2 > pathLen2   then end_step2   = pathLen2 end
        end
        
        
        -- 填写基本数据
        local fishData = {}
        fishData.fish_id = fish_id
        fishData.fish_kind = fish_kind
        fishData.fish_tag = fish_tag

        fishData.path_id1 = path_id1
        fishData.begin_step1 = math.floor(begin_step1)
        fishData.end_step1 = math.floor(end_step1)
        fishData.offset_x1 = offset_x1
        fishData.offset_y1 = offset_y1

        fishData.path_id2 = path_id2
        fishData.begin_step2 = math.floor(begin_step2)
        fishData.end_step2 = math.floor(end_step2)
        fishData.offset_x2 = offset_x2
        fishData.offset_y2 = offset_y2

        switchFish.fishDataMap[fish_id] = fishData
        --switchFish.fish_count         = key
    end
    switchFish.fish_count = table.nums(switchFish.fishDataMap)
    self.m_mapSceneData[sceneIndex] = switchFish
    return true
end

function FishSceneMgr:getAngle(pos_curr, pos2_next)
    --计算角度
    local vec = cc.pSub(pos2_next, pos_curr)
    local angle = math.radian2angle(cc.pGetAngle(vec, cc.p(0, 1))) + 270
    return angle
end

function FishSceneMgr:prepare_path()

    local kFishSpeed = 90 / 30

    -- format:[x][y][angle]
    local vecLine1 = { {}, {}, {}, }
    local vecLine2 = { {}, {}, {}, }
    local vecLine3 = { {}, {}, {}, }
    local vecLine4 = { {}, {}, {}, }
    local vecLine5 = { {}, {}, {}, }
    local vecLine6 = { {}, {}, {}, }
    local vecLine7 = { {}, {}, {}, }
    local vecLine8 = { {}, {}, {}, }
    local vecLine9 = { {}, {}, {}, }
    local vecLine10 = { {}, {}, {}, }
    local vecLine11 = { {}, {}, {}, }
    local vecLine12 = { {}, {}, {}, }
    local vecLine13 = { {}, {}, {}, }
    local vecLine14 = { {}, {}, {}, }
    local vecLine15 = { {}, {}, {}, }
    local vecLine16 = { {}, {}, {}, }
    local vecLine17 = { {}, {}, {}, }
    local vecLine18 = { {}, {}, {}, }

    -- 第一条 直线 从左到右
    local init_x = { -1334, 1334 + 200 }
    local init_y = { 0, 0 }
    vecLine1 = MathAide:BuildLinearPointAngle(init_x, init_y, 2, kFishSpeed)

    -- 第二条 直线 从右到左
    local init_x = { 1334 * 2, -200, }
    local init_y = { 0, 0, }
    vecLine2 = MathAide:BuildLinearPointAngle(init_x, init_y, 2, kFishSpeed)

    -- 第三条 原地不动
    for i = 1, 2000 do
        vecLine3[1][i] = 0
        vecLine3[2][i] = 0
        vecLine3[3][i] = 0
    end

    -- 第四至七条 圆形路径 逆时针 半径150/220/290/360像素
    vecLine4 = MathAide:BuildCirclePath(cc.p(0, 0), 150, 56, M_PI, 8 * M_PI)
    vecLine5 = MathAide:BuildCirclePath(cc.p(0, 0), 220, 56, M_PI, 8 * M_PI)
    vecLine6 = MathAide:BuildCirclePath(cc.p(0, 0), 290, 56, M_PI, 8 * M_PI)
    vecLine7 = MathAide:BuildCirclePath(cc.p(0, 0), 360, 56, M_PI, 8 * M_PI)

    -- 第八至十一条 圆形路径 顺时针 半径150/220/290/360像素
    vecLine8 = MathAide:BuildCirclePathOther(cc.p(0, 0), 150, 56, M_PI, 8 * M_PI)
    vecLine9 = MathAide:BuildCirclePathOther(cc.p(0, 0), 220, 56, M_PI, 8 * M_PI)
    vecLine10 = MathAide:BuildCirclePathOther(cc.p(0, 0), 290, 56, M_PI, 8 * M_PI)
    vecLine11 = MathAide:BuildCirclePathOther(cc.p(0, 0), 360, 56, M_PI, 8 * M_PI)

    -- 第十二条 直线 从右到左
    local init_x = { 0, 0, }
    local init_y = { 0, 750 * 2, }
    vecLine12 = MathAide:BuildLinearPointAngle(init_x, init_y, 2, kFishSpeed)

    -- 第十三条 直线 从右到左
    local init_x = { 0, 0, }
    local init_y = { 0, - 750 * 2, }
    vecLine13 = MathAide:BuildLinearPointAngle(init_x, init_y, 2, kFishSpeed)

    -- 第十四条 圆形路径 逆时针 半径300
    vecLine14 = MathAide:BuildCirclePathOther(cc.p(0, 0), 300, 56, M_PI, 8 * M_PI)

    -- 第十五条 圆形路径
    local center = cc.p(1334 - 100, 750 / 2)
    local size = 0
    while (center.x > -200) do 
        
        local vecTemp = MathAide:ActionScene8FishMoveLine(center, 100, 0)
        
        --第一个圆(上半圈逆时针)
        for i = 1, #vecTemp[1] do
            size = size + 1
            vecLine15[1][size] = vecTemp[1][i]
            vecLine15[2][size] = vecTemp[2][i]
            vecLine15[3][size] = vecTemp[3][i]
        end 
        center.x =  center.x - 200
        
        --第二个圆(下半圈顺时针)
        for i = 1, #vecTemp[1] do 
            size = size + 1
            vecLine15[1][size] = vecTemp[1][i] - 200
            vecLine15[2][size] = 750 - vecTemp[2][i]
            vecLine15[3][size] = 360 - vecTemp[3][i]
        end 
        center.x = center.x - 200

        vecTemp = {}
    end 
    
    --第十六条 正方形（与十五关于x轴对称）
    for i = 1, #vecLine15[1] do
        vecLine16[1][i] = vecLine15[1][i]
        vecLine16[2][i] = 750 - vecLine15[2][i]
        vecLine16[3][i] = 360 - vecLine15[3][i]
    end

    --第十七条 圆形
    local center = cc.p(1334 - 200, 750 / 2)
    local size = 0
    while (center.x > -200) do
        
        --圆形点集合
        local vecTemp = MathAide:ActionScene7FishMoveLine(center, 200, 0)

        --第一个圆(上半圈逆时针)
        for i = 1, #vecTemp[1] do
            size = size + 1
            vecLine17[1][size] = vecTemp[1][i]
            vecLine17[2][size] = vecTemp[2][i]
            vecLine17[3][size] = vecTemp[3][i]
        end
        center.x = center.x - 400

        --第二个圆(下半圈顺时针)
        for i = 1, #vecTemp[1] do
            size = size + 1
            vecLine17[1][size] = vecTemp[1][i] - 400
            vecLine17[2][size] = 750 - vecTemp[2][i]
            vecLine17[3][size] = 360 - vecTemp[3][i]
        end
        center.x = center.x - 400
    end

    --第十八条 圆形
    for i = 1, #vecLine17[1] do
        vecLine18[1][i] = vecLine17[1][i]
        vecLine18[2][i] = 750 - vecLine17[2][i]
        vecLine18[3][i] = 360 - vecLine17[3][i]
    end

    self.map_Path = {}
    self.map_Path[1] = vecLine1
    self.map_Path[2] = vecLine2
    self.map_Path[3] = vecLine3
    self.map_Path[4] = vecLine4
    self.map_Path[5] = vecLine5
    self.map_Path[6] = vecLine6
    self.map_Path[7] = vecLine7
    self.map_Path[8] = vecLine8
    self.map_Path[9] = vecLine9
    self.map_Path[10] = vecLine10
    self.map_Path[11] = vecLine11
    self.map_Path[12] = vecLine12
    self.map_Path[13] = vecLine13
    self.map_Path[14] = vecLine14
    self.map_Path[15] = vecLine15
    self.map_Path[16] = vecLine16
    self.map_Path[17] = vecLine17
    self.map_Path[18] = vecLine18
end

function FishSceneMgr:checkLine1(xPos)

    local ret = 0
    local it = self.map_Path[1]
    for i = 1, #it do
        if it[i].x > xPos then
            return i
        end
    end
    return ret
end 

function FishSceneMgr:checkLine2(xPos)

    local ret = 0
    local it = self.map_Path[2]
    for i = 1, #it do
        if it[i].x < xPos then
            return i
        end
    end
    return ret
end 

function FishSceneMgr:prepare_path2(index) --1-16

    if self.map_Path == nil then
        self.map_Path = {}
    end
    if self.map_Path[index] == nil then
        self.map_Path[index] = {}
    end

    local kFishSpeed = 90 / 30

    if index == 1 then

        -- 第一条 直线 从左到右
        local init_x = { -1334, 1334 + 200 }
        local init_y = { 0, 0 }
        local vecLine = MathAide:BuildLinearPointAngle(init_x, init_y, 2, kFishSpeed)
        self.map_Path[1] = vecLine

    elseif index == 2 then

        -- 第二条 直线 从右到左
        local init_x = { 1334 * 2, -200, }
        local init_y = { 0, 0, }
        local vecLine = MathAide:BuildLinearPointAngle(init_x, init_y, 2, kFishSpeed)
        self.map_Path[2] = vecLine

    elseif index == 3 then

        -- 第三条 原地不动
        local vecLine = { {}, {}, {}, }
        for i = 1, 2000 do
            vecLine[1][i] = 0
            vecLine[2][i] = 0
            vecLine[3][i] = 0
        end
        self.map_Path[3] = vecLine

    elseif index == 4 then

        -- 第四至七条 圆形路径 逆时针 半径150/220/290/360像素
        local vecLine = MathAide:BuildCirclePath(cc.p(0, 0), 150, 56, M_PI, 8 * M_PI)
        self.map_Path[4] = vecLine

    elseif index == 5 then

        -- 第四至七条 圆形路径 逆时针 半径150/220/290/360像素
        local vecLine = MathAide:BuildCirclePath(cc.p(0, 0), 220, 56, M_PI, 8 * M_PI)
        self.map_Path[5] = vecLine

    elseif index == 6 then

        -- 第四至七条 圆形路径 逆时针 半径150/220/290/360像素
        local vecLine = MathAide:BuildCirclePath(cc.p(0, 0), 290, 56, M_PI, 8 * M_PI)
        self.map_Path[6] = vecLine

    elseif index == 7 then

        -- 第四至七条 圆形路径 逆时针 半径150/220/290/360像素
        local vecLine = MathAide:BuildCirclePath(cc.p(0, 0), 360, 56, M_PI, 8 * M_PI)
        self.map_Path[7] = vecLine

    elseif index == 8 then

        -- 第八至十一条 圆形路径 顺时针 半径150/220/290/360像素
        local vecLine = MathAide:BuildCirclePathOther(cc.p(0, 0), 150, 56, M_PI, 8 * M_PI)
        self.map_Path[8] = vecLine

    elseif index == 9 then

        -- 第八至十一条 圆形路径 顺时针 半径150/220/290/360像素
        local vecLine = MathAide:BuildCirclePathOther(cc.p(0, 0), 220, 56, M_PI, 8 * M_PI)
        self.map_Path[9] = vecLine

    elseif index == 10 then

        -- 第八至十一条 圆形路径 顺时针 半径150/220/290/360像素
        local vecLine = MathAide:BuildCirclePathOther(cc.p(0, 0), 290, 56, M_PI, 8 * M_PI)
        self.map_Path[10] = vecLine

    elseif index == 11 then

        -- 第八至十一条 圆形路径 顺时针 半径150/220/290/360像素
        local vecLine = MathAide:BuildCirclePathOther(cc.p(0, 0), 360, 56, M_PI, 8 * M_PI)
        self.map_Path[11] = vecLine

    elseif index == 12 then

        -- 第十二条 直线 从右到左
        local init_x = { 0, 0, }
        local init_y = { 0, 750 * 2, }
        local vecLine = MathAide:BuildLinearPointAngle(init_x, init_y, 2, kFishSpeed)
        self.map_Path[12] = vecLine

    elseif index == 13 then

        -- 第十三条 直线 从右到左
        local init_x = { 0, 0, }
        local init_y = { 0, - 750 * 2, }
        local vecLine = MathAide:BuildLinearPointAngle(init_x, init_y, 2, kFishSpeed)
        self.map_Path[13] = vecLine

    elseif index == 14 then

        -- 第十四条 圆形路径 逆时针 半径300
        local vecLine = MathAide:BuildCirclePathOther(cc.p(0, 0), 300, 56, M_PI, 8 * M_PI)
        self.map_Path[14] = vecLine

    elseif index == 15 then
        -- 第十五条 圆形路径
        local vecLine = { {}, {}, {}, }
        local center = cc.p(1334 - 100, 750 / 2)
        local size = 0
        while (center.x > -200) do 
        
            local vecTemp = MathAide:ActionScene8FishMoveLine(center, 100, 0)
        
            --第一个圆(上半圈逆时针)
            for i = 1, #vecTemp[1] do
                size = size + 1
                vecLine[1][size] = vecTemp[1][i]
                vecLine[2][size] = vecTemp[2][i]
                vecLine[3][size] = vecTemp[3][i]
            end 
            center.x =  center.x - 200
        
            --第二个圆(下半圈顺时针)
            for i = 1, #vecTemp[1] do 
                size = size + 1
                vecLine[1][size] = vecTemp[1][i] - 200
                vecLine[2][size] = 750 - vecTemp[2][i]
                vecLine[3][size] = 360 - vecTemp[3][i]
            end 
            center.x = center.x - 200

            vecTemp = {}
        end 
        self.map_Path[15] = vecLine
    
        --第十六条 正方形（与十五关于x轴对称）
        local vecLine2 = { {}, {}, {}, }
        for i = 1, #vecLine[1] do
            vecLine2[1][i] = vecLine[1][i]
            vecLine2[2][i] = 750 - vecLine[2][i]
            vecLine2[3][i] = 360 - vecLine[3][i]
        end
        self.map_Path[16] = vecLine2

    elseif index == 16 then

        --第十七条 圆形
        local vecLine = { {}, {}, {}, }
        local center = cc.p(1334 - 200, 750 / 2)
        local size = 0
        while (center.x > -200) do
        
            --圆形点集合
            local vecTemp = MathAide:ActionScene7FishMoveLine(center, 200, 0)

            --第一个圆(上半圈逆时针)
            for i = 1, #vecTemp[1] do
                size = size + 1
                vecLine[1][size] = vecTemp[1][i]
                vecLine[2][size] = vecTemp[2][i]
                vecLine[3][size] = vecTemp[3][i]
            end
            center.x = center.x - 400

            --第二个圆(下半圈顺时针)
            for i = 1, #vecTemp[1] do
                size = size + 1
                vecLine[1][size] = vecTemp[1][i] - 400
                vecLine[2][size] = 750 - vecTemp[2][i]
                vecLine[3][size] = 360 - vecTemp[3][i]
            end
            center.x = center.x - 400
        end
        self.map_Path[17] = vecLine

        --第十八条 圆形
        local vecLine2 = { {}, {}, {}, }
        for i = 1, #vecLine[1] do
            vecLine2[1][i] = vecLine[1][i]
            vecLine2[2][i] = 750 - vecLine[2][i]
            vecLine2[3][i] = 360 - vecLine[3][i]
        end
        self.map_Path[18] = vecLine2
    end
end

function FishSceneMgr:setMapReadOnly()
    
    setReadOnly(self.map_Path)
end

return FishSceneMgr

-- endregion
