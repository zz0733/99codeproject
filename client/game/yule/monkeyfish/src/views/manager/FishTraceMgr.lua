-- region *.lua
-- Date 2017.04.06
-- 此文件由[BabeLua]插件自动生成 
local module_pre = "game.yule.monkeyfish.src.views."
local MathAide = require(module_pre.."manager.MathAide")
local FishRes  = require(module_pre.."scene.FishSceneRes")

local FISH_SPEED_ONE = 108 / 30
local FISH_SPEED_TWO = 90 / 30
local FISH_SPEED_THREE = 72 / 30
local FISH_SPEED_FOURE = 108 / 30

local FishTraceMgr = class("FishTraceMgr")

-- 创建实例接口
FishTraceMgr.instance_ = nil
function FishTraceMgr.getInstance()
    if FishTraceMgr.instance_ == nil then
        FishTraceMgr.instance_ = FishTraceMgr.new()
    end
    return FishTraceMgr.instance_
end

function FishTraceMgr.releaseInstance()
    FishTraceMgr.getInstance():Clear()
    FishTraceMgr.instance_ = nil
end

function FishTraceMgr:ctor()

    self.m_bAllFishTraceEnd = false
    self.m_bIsNewTrace = true
    self.m_vPathFileNameVec = {}
    self.m_vPathIdVec = {}
    self.m_mapAllFishTrace = {}  

    --for i = 1, 55 do --55个
    --    local strFileName = string.format(FishRes.FILE_OF_TRACE, i)
    --    table.insert(self.m_vPathFileNameVec, strFileName)
    --    table.insert(self.m_vPathIdVec, i)
    --end  
    --for i = 201, 250 do --50个
    --    local strFileName = string.format(FishRes.FILE_OF_TRACE, i)
    --    table.insert(self.m_vPathFileNameVec, strFileName)
    --    table.insert(self.m_vPathIdVec, i)
    --end 
    --for i = 301, 310 do --10个
    --    local strFileName = string.format(FishRes.FILE_OF_TRACE, i)
    --    table.insert(self.m_vPathFileNameVec, strFileName)
    --    table.insert(self.m_vPathIdVec, i)
    --end
end

function FishTraceMgr:Clear()

    self.m_bAllFishTraceEnd = false
    self.m_bIsNewTrace = true
    self.m_vPathFileNameVec = {}
    self.m_vPathIdVec = {}
    self.m_mapAllFishTrace = {}  
end

function FishTraceMgr:getPathFileCount()
    return #self.m_vPathFileNameVec
end

function FishTraceMgr:loadOnePathFileByIndex(nIndex)
    local strFileName =  self.m_vPathFileNameVec[nIndex] 
    local nPathId = self.m_vPathIdVec[nIndex]
    local ret = self:laodFishTrace(strFileName, nPathId)
    return ret
end

function FishTraceMgr:setIsNewTrace(IsNewTrace)
    self.m_bIsNewTrace = IsNewTrace
end

function FishTraceMgr:getIsNewTrace()
    return self.m_bIsNewTrace
end

-- nId pathID 路径的id
-- trace_vector 存放一条路径中 坐标 position的数组
function FishTraceMgr:findFishTraceById(nId, xOffset, yOffset)

    local pathData = self.m_mapAllFishTrace[nId] or self.m_mapAllFishTrace[2]
    local pointCount = #pathData[1]

    local trace_vector = { {}, {}, {}, }
    for i = 1, pointCount do
        trace_vector[1][i] = pathData[1][i] + xOffset
        trace_vector[2][i] = pathData[2][i] + yOffset
        trace_vector[3][i] = pathData[3][i]
    end 
    return trace_vector, pointCount
end

function FishTraceMgr:loadAllPathFile(index)
    local path = string.format(FishRes.FISH_PATH, index)
    local fullPath = self:getDatFilePath(path, index)
    if fullPath == "" then 
        --print("－－－－－－－－－－－－－－找不到路径文件：%s", strName)
        return false 
    end 
    local pFile = io.open(fullPath, "rb")
    if pFile == nil then
        --print("－－－－－－－－－－－－－－找不到路径文件：%s", strName)
        return false
    end
    
    pFile:seek('set')
    --读取路径文件数量
    local byteFileNumber = pFile:read(4)
    local FileNumber = self:bytes_to_int(byteFileNumber)

    local trace_vector = {}
    local PathID = 0
    local PointNum = 0
    local posx = 0
    local posy = 0
    local angle = 0

    local b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12 = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    local c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12 = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    local fReadCount = 0
    local iReadCount = 0
    local pointIdx = 0
    local lessCount = 0
    for fileIndex = 1, FileNumber do
        trace_vector = { {}, {}, {}, }

        b1, b2, b3, b4, b5, b6, b7, b8 = pFile:read(8):byte(1, 8)
        PathID   = b1 + b2  * 256 + b3  * 65536 + b4  * 16777216
        PointNum = b5 + b6  * 256 + b7  * 65536 + b8  * 16777216
        fReadCount = PointNum / 2
        iReadCount = math.floor(fReadCount)
        lessCount = (fReadCount - iReadCount) * 2
        pointIdx = 1
        for i = 1, iReadCount do --1次读取两个点数据
            b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12,
            c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12  = pFile:read(24):byte(1, 24)

            --------------解析第1个点数据
            posx  = b1 + b2  * 256 + b3  * 65536 + b4  * 16777216
            posy  = b5 + b6  * 256 + b7  * 65536 + b8  * 16777216
            angle = b9 + b10 * 256 + b11 * 65536 + b12 * 16777216

            if posx > 1000000 then
                posx = -(posx-1000000)
            end
            if posy > 1000000 then
                posy = -(posy-1000000)
            end
            trace_vector[1][pointIdx] = posx / 100
            trace_vector[2][pointIdx] = posy / 100
            trace_vector[3][pointIdx] = angle / 100
            pointIdx = pointIdx + 1

            --------------解析第2个点数据
            posx  = c1 + c2  * 256 + c3  * 65536 + c4  * 16777216
            posy  = c5 + c6  * 256 + c7  * 65536 + c8  * 16777216
            angle = c9 + c10 * 256 + c11 * 65536 + c12 * 16777216

            if posx > 1000000 then
                posx = -(posx-1000000)
            end
            if posy > 1000000 then
                posy = -(posy-1000000)
            end
            trace_vector[1][pointIdx] = posx / 100
            trace_vector[2][pointIdx] = posy / 100
            trace_vector[3][pointIdx] = angle / 100
            pointIdx = pointIdx + 1
            -----------------
        end
        if lessCount > 0 then
            ------------------ 如果有剩余1个点，继续读取数据
            b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12 = pFile:read(12):byte(1, 12)            
            posx  = b1 + b2  * 256 + b3  * 65536 + b4  * 16777216
            posy  = b5 + b6  * 256 + b7  * 65536 + b8  * 16777216
            angle = b9 + b10 * 256 + b11 * 65536 + b12 * 16777216

            if posx > 1000000 then
                posx = -(posx-1000000)
            end
            if posy > 1000000 then
                posy = -(posy-1000000)
            end
            trace_vector[1][pointIdx] = posx / 100
            trace_vector[2][pointIdx] = posy / 100
            trace_vector[3][pointIdx] = angle / 100
            pointIdx = pointIdx + 1
            --------------------------
        end

        self.m_mapAllFishTrace[PathID] = trace_vector
    end
    pFile:close()
    return true
end

function FishTraceMgr:loadAllPathFile1(index)
    local path = string.format(FishRes.FISH_PATH, index)
    local fullPath = self:getDatFilePath(path, index)
    if fullPath == "" then 
        --print("－－－－－－－－－－－－－－找不到路径文件：%s", strName)
        return false 
    end 
    local pFile = io.open(fullPath, "rb")
    if pFile == nil then
        --print("－－－－－－－－－－－－－－找不到路径文件：%s", strName)
        return false
    end
    
    pFile:seek('set')
    --读取路径文件数量
    local byteFileNumber = pFile:read(4)
    local FileNumber = self:bytes_to_int(byteFileNumber)

    local trace_vector = {}
    local PathID = 0
    local PointNum = 0
    local posx = 0
    local posy = 0
    local angle = 0

    local b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12 = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

    for fileIndex = 1, FileNumber do
        trace_vector = { {}, {}, {}, }

        b1, b2, b3, b4, b5, b6, b7, b8 = pFile:read(8):byte(1, 8)
        PathID   = b1 + b2  * 256 + b3  * 65536 + b4  * 16777216
        PointNum = b5 + b6  * 256 + b7  * 65536 + b8  * 16777216
        for i = 1, PointNum do

            b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12 = pFile:read(12):byte(1, 12)

            posx  = b1 + b2  * 256 + b3  * 65536 + b4  * 16777216
            posy  = b5 + b6  * 256 + b7  * 65536 + b8  * 16777216
            angle = b9 + b10 * 256 + b11 * 65536 + b12 * 16777216

            if posx > 1000000 then
                posx = -(posx-1000000)
            end
            if posy > 1000000 then
                posy = -(posy-1000000)
            end
            trace_vector[1][i] = posx / 100
            trace_vector[2][i] = posy / 100
            trace_vector[3][i] = angle / 100
        end
        self.m_mapAllFishTrace[PathID] = trace_vector
    end
    pFile:close()
    return true
end

function FishTraceMgr:loadAllPathFile_old(index)
    local path = string.format(FishRes.FISH_PATH, index)
    local fullPath = self:getDatFilePath(path, index)
    if fullPath == "" then 
        --print("－－－－－－－－－－－－－－找不到路径文件：%s", strName)
        return false 
    end 
    local pFile = io.open(fullPath, "rb")
    if pFile == nil then
        --print("－－－－－－－－－－－－－－找不到路径文件：%s", strName)
        return false
    end
    
    pFile:seek('set')
    --读取路径文件数量
    local byteFileNumber = pFile:read(4)
    local FileNumber = self:bytes_to_int(byteFileNumber)

    for i=1, FileNumber do
        local trace_vector = { {}, {}, {}, }
        local bytePathID = pFile:read(4)
        local PathID = self:bytes_to_int(bytePathID)
        local bytePointNum = pFile:read(4)
        local PointNum = self:bytes_to_int(bytePointNum)
        for i = 1, PointNum do
            local byteX = pFile:read(4)
            local posx = self:bytes_to_int(byteX)
            local byteY = pFile:read(4)
            local posy = self:bytes_to_int(byteY)
            local byteangle = pFile:read(4)
            local angle = self:bytes_to_int(byteangle)

            if posx > 100000000 then
                posx = -(posx-100000000)
            end
            if posy > 100000000 then
                posy = -(posy-100000000)
            end
            trace_vector[1][i] = posx / 10000
            trace_vector[2][i] = posy / 10000
            trace_vector[3][i] = angle / 10000
        end
        self.m_mapAllFishTrace[PathID] = trace_vector
    end
    --print("－－－pathName:" .. pathName .."   num:" .. FileNumber)
    pFile:close()
    return true
end

function FishTraceMgr:laodFishTrace(strName, pathIndex)

    return self:laodFishTrace2(strName, pathIndex)

--  C++部分通过读取本地配置文件 获得 x y坐标的字符串
--    local strPathData = Utils:laodFishTrace(strName, pathIndex)

--    local i = 1
--    local len = #strPathData
--    local pathPositionTable = { }

--    while (i < len) do
--        local position = { }
--        -- 获取x坐标
--        local strTemp = string.sub(strPathData, i, len)
--        local xPosition = string.find(strTemp, "x", 1, #strTemp)
--        local xData = ""
--        local j = xPosition + 1
--        local m = string.sub(strTemp,j,j)
--        local n = string.sub(strTemp,1,1)

--        while (string.sub(strTemp,j,j) ~= ";") do
--            xData = xData ..     string.sub(strTemp,j,j)         
--            j = j + 1                        
--        end

--        position.x = tonumber( xData)/1000
--        -- 获取y坐标
--        local yPosition = j + 1
--        if string.sub(strTemp,yPosition,yPosition) ~= "y" then
--            break
--        end
--        local yData = ""
--        local k = yPosition + 1
--        while ( string.sub(strTemp,k,k) ~= ";") do
--            yData = yData .. string.sub(strTemp,k,k)
--            k = k + 1
--        end

--        position.y = tonumber (yData)/1000

--        table.insert(pathPositionTable, position)

--        i = i + k 

--    end

--    self.m_mapAllFishTrace[pathIndex] = pathPositionTable
---------------------------------- 方法 2--------------------------------------
    --return self:laodFishTrace2(strName, pathIndex)
---------------------------------------方法 3----------------------------------
    --Utils:laodFishTraceByWWBuffer(strName, pathIndex)
    --return true 
-------------------------------------------------------------------------------
end

-- strName  完整路径
function FishTraceMgr:laodFishTrace2(strName, i)

    local fullPath = self:getDatFilePath(strName, i)
    if fullPath == "" then 
        --print("－－－－－－－－－－－－－－找不到路径文件：%s", strName)
        return false 
    end 
    local pFile = io.open(fullPath, "rb")
    if pFile == nil then
        --print("－－－－－－－－－－－－－－找不到路径文件：%s", strName)
        return false
    end

    local trace_vector = { {}, {}, {}, }

    pFile:seek('set')

    -- 读取贝塞尔曲线的控制点，程序目前没有用
    local bytekeyLen1 = pFile:read(4)
    local keyLen1 = self:bytes_to_int(bytekeyLen1)
    --local inTangent = 0.0
    --local outTangent = 0.0
    --local fTime = 0.0
    --local fValue = 0.0
    for i = 1, keyLen1 do
        local byteinTangent = pFile:read(4)
        --inTangent = self:bytes_to_float(byteinTangent)
        local byteoutTangent = pFile:read(4)
        --outTangent = self:bytes_to_float(byteoutTangent)
        local bytefTime = pFile:read(4)
        --fTime = self:bytes_to_float(bytefTime)
        local bytefValue = pFile:read(4)
        --fValue = self:bytes_to_float(bytefValue)
    end

    -- 读取坐标点的位置
    local bytebReverse1 = pFile:read(1)
    local bytePointNum = pFile:read(4)
    local PointNum = self:bytes_to_int(bytePointNum)
    for i = 1, PointNum do
        local byteX = pFile:read(4)
        local posx = self:bytes_to_float(byteX)
        local byteY = pFile:read(4)
        local posy = self:bytes_to_float(byteY)

        trace_vector[1][i] = posx * 1334 / 1.8
        trace_vector[2][i] = posy * 750
        trace_vector[3][i] = 0.0
        --print("第一路径:%.6f, %.6f", fPos.x, fPos.y)
    end

    local byteSelectSecond = pFile:read(1)
    local SelectSecond = self:bytes_to_bool(byteSelectSecond) 
    local bytebReverse2 = pFile:read(1)
    --local bReverse2 = self:bytes_to_bool(bytebReverse2) 
    if SelectSecond then

        -- 读取路径的控制点，程序目前没有使用
        local bytekeyLen2 = pFile:read(4)
        local keyLen2 = self:bytes_to_int(bytekeyLen2)
        for i = 1, keyLen2 do
            local byteinTangent = pFile:read(4)
            --local inTangent = self:bytes_to_float(byteinTangent)
            local byteoutTangent = pFile:read(4)
            --local outTangent = self:bytes_to_float(byteoutTangent)
            local bytefTime = pFile:read(4)
            --local fTime = self:bytes_to_float(bytefTime)
            local bytefValue = pFile:read(4)
            --local fValue = self:bytes_to_float(bytefValue)
        end

        -- 读取路径的坐标点
        local bytePointNum2 = pFile:read(4)
        local PointNum2 = self:bytes_to_int(bytePointNum2)
        for i = 1, PointNum2 do
            local byteX = pFile:read(4)
            local posx = self:bytes_to_float(byteX)
            local byteY = pFile:read(4)
            local posy = self:bytes_to_float(byteY)

            trace_vector[1][i + PointNum] = posx * 1334 / 1.8
            trace_vector[2][i + PointNum] = posy * 750
            trace_vector[3][i + PointNum] = 0.0
            --print("第二路径:%.6f, %.6f", fPos.x, fPos.y)
        end
    end
    pFile:close()
    -- CCLOG("总的路径步数:%lu", trace_vector.size())
    self.m_bAllFishTraceEnd = true
    self.m_mapAllFishTrace[i] = trace_vector
    return true
end

function FishTraceMgr:getDatFilePath(strName, index)
    local fullPath = ""
    if false then
        local path = cc.FileUtils:getInstance():getWritablePath()
        local name = string.format(FishRes.FISH_COPY_PATH, index)
        fullPath = path .. name
        if not cc.FileUtils:getInstance():isFileExist (fullPath) then
            print("开始加载路径 fullPath:%s", fullPath)
            local sourcePath = cc.FileUtils:getInstance():fullPathForFilename(strName)
            if cc.FileUtils:getInstance():isFileExist(sourcePath) then
                Utils:copyFile(name, sourcePath)
            end
        end
    else
        fullPath = cc.FileUtils:getInstance():fullPathForFilename(strName)
    end
    return fullPath
end

function FishTraceMgr:copyFile(file, sourcePath)
    --lua 没有导出 getDataFromFile
    --getDataFromFile读出来的结果是字符串,遇到0\0就没了
    local data = cc.FileUtils:getInstance():getDataFromFile(sourcePath)
    local destPath = cc.FileUtils:getInstance():getWritablePath()..file
    local ret = cc.FileUtils:getInstance():writeStringToFile(str,destPath)
    print("copy file ", destPath)
    return ret 
end

--加载0号路径
function FishTraceMgr:loadNumZeroTrace()

    local arrX = { -300, 460 }
    local arrY = { 270, 770 }

    local trace_vector = MathAide:BuildLinearPointAngle(arrX, arrY, 2, FISH_SPEED_FOURE)
    
    -- 试玩场的路径 ID 为 0
    self.m_mapAllFishTrace[0] = trace_vector
end

--创建新的路径，用于在中间产生不同的鱼群，向四周扩散
function FishTraceMgr:createSpecailTrace()

    local circle_count = 18
    local step_length = 1.6
    local center = 
    {
        x = 1334 / 2,
        y = 750 / 2,
        angle = 0,
    }

    for i = 0, circle_count - 1 do

        local trace_vector_for_circle = { {}, {}, {}, }

        local angle = 2 * math.pi * 1.0 / circle_count * i
        local singleStep = 
        {
            x = step_length * math.cos(angle),
            y = step_length * math.sin(angle),
        }
        local currentStep = 
        {
            x = center.x,
            y = center.y,
        }
        local real_angle = math.radian2angle(0 - angle)

        for n = 1, 600 do
            currentStep.x = currentStep.x + singleStep.x
            currentStep.y = currentStep.y + singleStep.y
            
            trace_vector_for_circle[1][n] = currentStep.x
            trace_vector_for_circle[2][n] = currentStep.y
            trace_vector_for_circle[3][n] = real_angle
        end

        self.m_mapAllFishTrace[i + 401] = trace_vector_for_circle
    end
end

function FishTraceMgr:bytes_to_bool(x)
    local char = string.byte(x)
    if char == 0 or char == '0' or char == '\0' then 
        return false 
    end 
    return true
end

function FishTraceMgr:bytes_to_int(x)

    --取byte
    local b1, b2, b3, b4 = x:byte(1, 4)

    --整数
    local i = b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
    return i
end

function FishTraceMgr:bytes_to_float(x)
    
    --取byte
    local b1, b2, b3, b4 = x:byte(1, 4)
    
    --正负
    local sign = b4 <= 127 and 1 or -1
    
    --尾数
    local mantissa = b3 % 128 
    mantissa = mantissa * 256 + b2
    mantissa = mantissa * 256 + b1
    mantissa = math.ldexp(mantissa, -23) + 1

    --指数
    local exponent = b4 % 128 * 2 + math.floor(b3 / 128)
    if exponent == 0 then
        return 0 
    end

    --浮点数
    local f = math.ldexp(mantissa * sign, exponent - 127)
    return f
end

--[[ 旧代码

function FishTraceMgr:bytes_to_int2(b1,b2,b3,b4)

    local n = b1 + b2*256 + b3*65536 + b4*16777216 
    n = (n > 2147483647) or n 
    return n
end

function FishTraceMgr:bytes_to_float2(x)
    local byte =  string.byte
    local ldexp = math.ldexp
    local sign = 1 
    local mantissa = byte(x,3)%128 
    for i = 2,1,-1 do 
        mantissa = mantissa *256 + byte(x,i)
    end 
    if byte(x,4) > 127 then 
        sign = -1
    end 
    local exponent = ( byte(x,4) % 128) * 2 + math.floor( byte(x,3) /128)
    if exponent == 0 then 
        return 0 
    end 
    mantissa = ( ldexp(mantissa,-23)+1)*sign 
    return ldexp(mantissa, exponent - 127)
end

  -- 收到 读取文件字节流回调 
  -- lenth 字节流长度
function cc.exports.onReceiveTraceWWBuffer(__wwBuffer, lenth, fileIndex)
    if fileIndex == 47 then
        local a = 0
    end 

    local len = __wwBuffer:getReadableSize()
    local _buffer = __wwBuffer:readData(len)

    local trace_vector = { }

    -- 读取贝塞尔曲线的控制点，程序目前没有用
    local keyLen1 = 0
    keyLen1 = _buffer:readInt()
    local inTangent = 0.0
    local outTangent = 0.0
    local fTime = 0.0
    local fValue = 0.0
    for i = 1, keyLen1 do

        inTangent = _buffer:readFloat()
        outTangent = _buffer:readFloat()
        fTime = _buffer:readFloat()
        fValue = _buffer:readFloat()
    end

    -- 读取坐标点的位置
    local bReverse1 = false
    bReverse1 = _buffer:readBoolean()
    local PointNum = 0
    PointNum = _buffer:readInt()
    for i = 1, PointNum do

        local fPos = { }
        fPos.x = _buffer:readFloat()
        fPos.y = _buffer:readFloat()
        fPos.y = fPos.y * 750;
        fPos.x = fPos.x * 1334 / 1.8;
        fPos.angle = 0.0
        trace_vector[#trace_vector + 1] = fPos
        --print("第一路径:%.6f, %.6f", fPos.x, fPos.y);
    end

    local SelectSecond = false
    SelectSecond = _buffer:readBoolean()
    local bReverse2 = false
    bReverse2 = _buffer:readBoolean()

    if SelectSecond then

        -- 读取路径的控制点，程序目前没有使用
        local keyLen2 = 0
        keyLen2 = _buffer:readInt()
        for i = 1, keyLen2 do

            inTangent = _buffer:readFloat()
            outTangent = _buffer:readFloat()
            fTime = _buffer:readFloat()
            fValue = _buffer:readFloat()
        end

        -- 读取路径的坐标点
        local PointNum2 = 0
        PointNum2 = _buffer:readInt()
        for i = 1, PointNum2 do

            local fPos = { }
            fPos.x = _buffer:readFloat()
            fPos.y = _buffer:readFloat()
            fPos.y = fPos.y * 750;
            fPos.x = fPos.x * 1334 / 1.8;
            fPos.angle = 0.0
            trace_vector[#trace_vector + 1] = fPos
            --print("第二路径:%.6f, %.6f", fPos.x, fPos.y);
        end
    end

    FishTraceMgr:getInstance().m_mapAllFishTrace[fileIndex] = trace_vector

    FishTraceMgr:getInstance().m_bAllFishTraceEnd = true
    return true
end 
--]]

function FishTraceMgr:setMapReadOnly()
    
    setReadOnly(self.m_mapAllFishTrace)
end

return FishTraceMgr

--endregion
