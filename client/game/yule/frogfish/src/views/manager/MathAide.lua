--region *.lua
--Date 2017-04-05
--Author zhiyuan
--此文件由[BabeLua]插件自动生成

--重新加载
local MathAide = class("MathAide")

function MathAide:Factorial(number)
    local factorial = 1
    local temp = number
    for i = 0, number - 1 do
        factorial = factorial * temp
        temp = temp - 1
    end

    return factorial
end

function MathAide:Combination(count, r)
    return MathAide:Factorial(count) /(MathAide:Factorial(r) * MathAide:Factorial(count - r))
end

function MathAide:CalcDistance(x1, y1, x2, y2)
    return math.sqrt((x1 - x2) *(x1 - x2) +(y1 - y2) *(y1 - y2))
end

function MathAide:CalcAngle(x1, y1, x2, y2)
    local distance = MathAide:CalcDistance(x1, y1, x2, y2)
    if distance == 0 then return 0 end
    local sin_value =(x1 - x2) / distance
    local angle = math.acos(sin_value)
    if y1 < y2 then angle = 2 * M_PI - angle end
    angle = angle + M_PI_2
    return angle
end

function MathAide:CalcAngle2(x1, y1, x2, y2)
    local distance = MathAide:CalcDistance(x1, y1, x2, y2);
    if distance == 0 then return 0 end
    local sin_value = math.abs(x1 - x2) / distance
    local angle = math.asin(sin_value)
    if x1 > x2 and y1 < y2 then
        angle = M_PI - angle
    elseif x1 < x2 and y1 < y2 then
        angle = M_PI + angle
    elseif x1 < x2 and y1 > y2 then
        angle = 2 * M_PI - angle
    end
    return angle
end 

-- init_xtable x 坐标数组
-- init_ytable y 坐标数组
-- init_count 坐标个数
-- std::vector<FPoint>& trace_vector
-- 暂时没用到
function MathAide:BuildLinearPoint(init_xtable, init_ytable, init_count, distance)
    local trace_vector = { }

    if init_count < 2 then return end
    if distance <= 0 then return end

    local distance_total = MathAide:CalcDistance(init_xtable[init_count], init_ytable[init_count], init_xtable[1], init_ytable[1])
    if distance_total <= 0 then return end

    local cos_value = math.abs(init_ytable[init_count] - init_ytable[1]) / distance_total
    local angle = math.acos(cos_value)

    local point = { }
    point.x = init_xtable[1]
    point.y = init_ytable[1]
    table.insert(trace_vector, point)
    local temp_distance = 0

    local size = 0
    while (temp_distance < distance_total) do
        local point1 = { }
        size = #trace_vector

        if init_xtable[init_count] < init_xtable[1] then
            point1.x = init_xtable[1] - math.sin(angle) *(distance * size)

        else
            point1.x = init_xtable[1] + math.sin(angle) *(distance * size)
        end

        if init_ytable[init_count] < init_ytable[1] then
            point1.y = init_ytable[1] - math.cos(angle) *(distance * size)
        else
            point1.y = init_ytable[1] + math.cos(angle) *(distance * size)
        end

        table.insert(trace_vector, point1)
        temp_distance = MathAide:CalcDistance(point1.x, point1.y, init_xtable[1], init_ytable[1])
    end

    --local lastPoint =  trace_vector[#trace_vector]
     trace_vector[#trace_vector].x = init_xtable[init_count]
     trace_vector[#trace_vector].y = init_ytable[init_count]

    return trace_vector
end 

-- 角度直线(0号/1号/2号/12号/13号鱼阵)
function MathAide:BuildLinearPointAngle(init_xtable, init_ytable, init_count, distance)

    if init_count < 2 then return end
    if distance <= 0 then return end
    if init_xtable[init_count] - init_xtable[1] == 0 and init_ytable[init_count] - init_ytable[1] == 0 then return end

    --距离,起点,终点
    local distance_total = MathAide:CalcDistance(init_xtable[init_count], init_ytable[init_count], init_xtable[1], init_ytable[1])
    local pos_start = cc.p(init_xtable[1], init_ytable[1])
    local pos_stop = cc.p(init_xtable[init_count], init_ytable[init_count])

    --弧度(绝对值)
    local cos_value = math.abs(pos_stop.y - pos_start.y) / distance_total
    local temp_angle = math.acos(cos_value)

    --角度
    local vec = cc.pGetAngle(cc.pSub(pos_stop, pos_start), cc.p(0, 1))
    local real_angle = math.radian2angle(vec) + 270

    --点数
    local size = 1

    --起点
    local trace_vector = { {}, {}, {}, }
    trace_vector[1][size] = pos_start.x
    trace_vector[2][size] = pos_start.y
    trace_vector[3][size] = real_angle

    --起点到终点
    local temp_distance = 0
    local temp_pos = { x = 0, y = 0, angle = real_angle }
    local point = { x = 0, y = 0, angle = real_angle }
    local sinAngle = math.sin(temp_angle)
    local cosAngle = math.cos(temp_angle)
    local distanceMax = (init_xtable[init_count] - init_xtable[1])*(init_xtable[init_count] - init_xtable[1]) +  (init_ytable[init_count] - init_ytable[1])*(init_ytable[init_count] - init_ytable[1])

    while (temp_distance < distanceMax) do
        size = size + 1
        point.x = 0
        point.y = 0

        --计算x
        if init_xtable[init_count] == init_xtable[1] then
            point.x = init_xtable[1]
        elseif init_xtable[init_count] < init_xtable[1] then
            point.x = init_xtable[1] - sinAngle *(distance * size)
        else
            point.x = init_xtable[1] + sinAngle *(distance * size)
        end

        --计算y
        if init_ytable[init_count] == init_ytable[1] then
            point.y = init_ytable[1]
        elseif init_ytable[init_count] < init_ytable[1] then
            point.y = init_ytable[1] - cosAngle *(distance * size)
        else
            point.y = init_ytable[1] + cosAngle *(distance * size)
        end

        --记录angle
        --point.angle = real_angle

        -------------------------------------------------------------
        --测试计算角度
        --local vec = cc.pSub(point, temp_pos)
        --local angle = math.radian2angle(cc.pGetAngle(vec, cc.p(0, 1))) + 270
        --temp_pos.x = point.x
        --temp_pos.y = point.y
        --trace_vector[4][size] = angle
        -------------------------------------------------------------

        --记录到vector
        trace_vector[1][size] = point.x
        trace_vector[2][size] = point.y
        trace_vector[3][size] = real_angle

        --计算距离
        --temp_distance = MathAide:CalcDistance(point.x, point.y, init_xtable[1], init_ytable[1])
        temp_distance = (point.x-init_xtable[1])*(point.x-init_xtable[1]) + (point.y-init_ytable[1])*(point.y-init_ytable[1])
    end

    --终点
    trace_vector[1][size] = init_xtable[init_count]
    trace_vector[2][size] = init_ytable[init_count]
    trace_vector[3][size] = real_angle

    return trace_vector
end 

-- init_xtable x 坐标数组
-- init_ytable y 坐标数组
-- init_count 坐标个数
-- std::vector<FPoint>& trace_vector
-- 暂时没用到
function MathAide:BuildBezier(init_xtable, init_ytable, init_count, trace_vector, distance)
    trace_vector = { }

    local index = 0;
    
    local t = 0
    local count = init_count
    local temp_distance = distance
    local temp_value = 0

    while (t <= 1) do
        local temp_pos = { 0, 0 }
        temp_pos.x = 0
        temp_pos.y = 0
        index = 1
        while (index <= count) do
            temp_value = math.pow(t, index) * math.pow(1 - t, count - index) * MathAide:Combination(count, index)
            temp_pos.x = temp_pos.x + init_xtable[index] * temp_value
            temp_pos.y = temp_pos.y + init_ytable[index] * temp_value
            index = index + 1
        end

        local pos_space = 0
        if trace_vector.size() > 0 then
            local back_pos = trace_vector[#trace_vector]
            pos_space = MathAide:CalcDistance(back_pos.x, back_pos.y, temp_pos.x, temp_pos.y);
        end

        if (pos_space >= temp_distance or trace_vector.size() == 0) then
            trace_vector.push_back(temp_pos);
        end

        t = t + 0.00001
    end
end 

-- init_xtable x 坐标数组
-- init_ytable y 坐标数组
-- init_count 坐标个数
--  std::vector<FPoint>& trace_vector
-- 暂时没用到
function MathAide:BuildBezierFast(init_xtable, init_ytable, init_count, trace_vector, distance)
    trace_vector = { }

    local index = 1
    
    local t = 0
    local count = init_count
    local temp_distance = distance
    local temp_value = 0

    while (t <= 1) do
        local temp_pos = { 0, 0 }
        temp_pos.x = 0
        temp_pos.y = 0
        index = 1
        while (index <= count) do
            temp_value = math.pow(t, index) * math.pow(1 - t, count - index) * MathAide:Combination(count, index)
            temp_pos.x = temp_pos.x + init_xtable[index] * temp_value
            temp_pos.y = temp_pos.y + init_ytable[index] * temp_value
            index = index + 1
        end

        local pos_space = 0
        if table.nums(trace_vector) > 0 then
            local back_pos = trace_vector[#trace_vector]
            pos_space = MathAide:CalcDistance(back_pos.x, back_pos.y, temp_pos.x, temp_pos.y)
        end

        if pos_space >= temp_distance or table.nums(trace_vector) == 0 then
            table.insert(trace_vector, temp_pos)
        end

        t = t + 0.01
    end
end 

-- init_xtable x 坐标数组
-- init_ytable y 坐标数组
-- init_count 坐标个数
-- std::vector<FPointAngle>& trace_vector
-- 暂时没用到
function MathAide:BuildBezier(init_xtable, init_ytable, init_count, trace_vector, distance, cirIndex)

    trace_vector = { }
    local pos1 = { init_xtable[1], init_ytable[1], 1 }
    table.insert(trace_vector, pos1)

    local index = 1
    local temp_pos0 = { 0, 0 }
    local t = 0
    local count = init_count
    local temp_distance = distance
    local temp_pos = { 0, 0 }
    local temp_value = 0

    local circle = false
    while (t < 1) do
        temp_pos.x = 0
        temp_pos.y = 0
        index = 1
        while (index <= count) do
            temp_value = math.pow(t, index) * math.pow(1 - t, count - index) * MathAide:Combination(count, index)
            temp_pos.x = temp_pos.x + init_xtable[index] * temp_value
            temp_pos.y = temp_pos.y + init_ytable[index] * temp_value
            index = index + 1
        end

        local pos_space = 0
        if #trace_vector > 0 then
            local back_pos = trace_vector[#trace_vector]
            pos_space = MathAide:CalcDistance(back_pos.x, back_pos.y, temp_pos.x, temp_pos.y)
        end

        if pos_space >= temp_distance or #trace_vector == 0 then
            if #trace_vector > 0 then
                local temp_dis = MathAide:CalcDistance(temp_pos.x, temp_pos.y, temp_pos0.x, temp_pos0.y)
                if temp_dis ~= 0 then
                    local temp_value =(temp_pos.x - temp_pos0.x) / temp_dis
                    if (temp_pos.y - temp_pos0.y) >= 0 then
                        temp_pos.angle = math.acos(temp_value)
                    else
                        temp_pos.angle = - math.acos(temp_value)
                    end
                else
                    temp_pos.angle = 1
                end
            else
                temp_pos.angle = 1
            end
            table.insert(trace_vector, temp_pos)
            temp_pos0.x = temp_pos.x;
            temp_pos0.y = temp_pos.y;

            -- zhuanquan
            if cirIndex > 0 and not circle then

                -- std::vector<FPointAngle> temp_trace_vector;
                local temp_trace_vector = { }
                local radius = math.random(0, 80) + 120
                local centerx = temp_pos.x
                local centery = 0
                local start_angle = 0
                local rotate_angle = 2 * M_PI
                if init_xtable[1] < init_xtable[init_count - 1] and temp_pos.x >= init_xtable[cirIndex] then

                    circle = true;
                    centery = temp_pos.y + radius
                    start_angle = M_PI * 3 + M_PI_2

                elseif init_xtable[1] > init_xtable[init_count] and temp_pos.x <= init_xtable[cirIndex] then

                    circle = true
                    centery = temp_pos.y - radius
                    start_angle = M_PI_2
                end
                if circle then

                    local rotate_duration = 5.5 + radius / 100
                    MathAide:BuildCircle(temp_trace_vector, centerx, centery, radius, start_angle, rotate_angle, rotate_duration)
                    for i = 1, #temp_trace_vector do
                        table.insert(trace_vector, temp_trace_vector[i])
                    end
                end
            end

        end

        t = t + 0.00001
    end
end 

-- center_x 中心点 x坐标
-- center_y 中心点 y坐标
-- radius 半径
-- FPoint* fish_pos  每个鱼的坐标数组
-- fish_count 鱼的个数
-- 暂时没用到
function MathAide:BuildCircle1(center_x, center_y, radius, fish_pos, fish_count)
    if fish_count <= 0 then return end
    local cell_radian = 2 * M_PI / fish_count

    for i = 1, fish_count do
        fish_pos[i].x = center_x + radius * math.cos(i * cell_radian)
        fish_pos[i].y = center_y + radius * math.sin(i * cell_radian)
    end
end 

-- center_x 中心点 x坐标
-- center_y 中心点 y坐标
-- radius 半径
-- FPoint* fish_pos  每个鱼的坐标数组
-- fish_count 鱼的个数
-- rotate 旋转角度
-- rotate_speed 旋转速度
-- 暂时没用到
function MathAide:BuildCircle2(center_x, center_y, radius, fish_pos, fish_count, rotate, rotate_speed)

    if fish_count <= 0 then return end
    local cell_radian = 2 * M_PI / fish_count

    local last_pos = { }
    -- 这里计算好像有问题
    for i = 1, fish_count do
        last_pos.x = center_x + radius * math.cos(i * cell_radian + rotate - rotate_speed)
        last_pos.y = center_y + radius * math.sin(i * cell_radian + rotate - rotate_speed)

        fish_pos[i].x = center_x + radius * math.cos(i * cell_radian + rotate)
        fish_pos[i].y = center_y + radius * math.sin(i * cell_radian + rotate)
        local temp_dis = MathAide:CalcDistance(fish_pos[i].x, fish_pos[i].y, last_pos.x, last_pos.y)
        if temp_dis ~= 0 then
            local temp_value =(fish_pos[i].x - last_pos.x) / temp_dis
            if (fish_pos[i].y - last_pos.y) >= 0 then
                fish_pos[i].angle = math.acos(temp_value)
            else
                fish_pos[i].angle = - math.acos(temp_value)
            end
        else
            fish_pos[i].angle = M_PI / 2
        end
    end
end 

-- std::vector<FPointAngle> &trace_vector
-- center_x 中心点 x坐标
-- center_y 中心点 y坐标
-- radius 半径
-- start_angle 初始角度
-- rotate_angle 旋转角度
-- rotate_duration 旋转时间
-- 暂时没用到
function MathAide:BuildCircle3(trace_vector, center_x, center_y, radius, start_angle, rotate_angle, rotate_duration)

    local dur = 0
    local pointAngle = { }
    while (dur < rotate_duration) do

        local angle = start_angle + rotate_angle * dur / rotate_duration
        pointAngle.x = center_x + radius * math.cos(angle)
        pointAngle.y = center_y + radius * math.sin(angle)
        pointAngle.angle = M_PI / 2 + angle
        table.insert(trace_vector, pointAngle)
        dur = dur + 0.033;
    end
end 

-- init_xtable x 坐标数组
-- init_ytable y 坐标数组
-- init_count 坐标个数
-- std::vector<FPoint>& trace_vector
-- 暂时没用到
function MathAide:BuildLinearAdd(init_xtable, init_ytable, init_count, trace_vector, distance)

    trace_vector = { }

    if init_count < 2 then return end
    if distance <= 0 then return end

    local distance_total = MathAide:CalcDistance(init_xtable[init_count], init_ytable[init_count], init_xtable[1], init_ytable[1]);
    if distance_total <= 0 then return end

    local cos_value = math.abs(init_ytable[init_count] - init_ytable[1]) / distance_total
    local angle = math.acos(cos_value)

    local point = { }
    point.x = init_xtable[1]
    point.y = init_ytable[1]
    table.insert(trace_vector, point)

    local temp_distance = 0

    local size = 0
    local fAddDis = 1
    while (temp_distance < distance_total) do

        local point1 = { }
        size = #trace_vector

        if (init_xtable[init_count] < init_xtable[1]) then

            point1.x = init_xtable[1] - math.sin(angle) *(distance * size * fAddDis)

        else

            point1.x = init_xtable[1] + math.sin(angle) *(distance * size * fAddDis)
        end

        if (init_y[init_count] < init_y[1]) then

            point1.y = init_ytable[1] - math.cos(angle) *(distance * size * fAddDis)

        else

            point1.y = init_ytable[1] + math.cos(angle) *(distance * size * fAddDis)
        end

        table.insert(trace_vector, point1)
        temp_distance = MathAide:CalcDistance(point1.x, point1.y, init_xtable[1], init_ytable[1])

        fAddDis = fAddDis + 0.2
    end

    local lastPoint = trace_vector[#trace_vector]
    lastPoint.x = init_x[init_count]
    lastPoint.y = init_y[init_count]
end

-- init_xtable x 坐标数组
-- init_ytable y 坐标数组
-- init_count 坐标个数
-- std::vector<FPoint>& trace_vector
-- 暂时没用到
function MathAide:BuildGoldRunAdd(init_xtable, init_ytable, init_count, trace_vector, distance)

    -- 清理位置
    trace_vector = { }

    -- 效验参数
    if init_count < 2 then return end
    if distance <= 0 then return end

    -- 判断总距离
    local distance_total = MathAide:CalcDistance(init_xtable[init_count], init_ytable[init_count], init_xtable[1], init_ytable[1])
    if distance_total <= 0 then return end

    -- 初始点
    local startPoint = { }
    startPoint.x = init_xtable[1]
    startPoint.y = init_ytable[1]
    table.insert(trace_vector, startPoint)

    -- 终点
    local end_point = { }
    end_point.x = init_xtable[init_count]
    end_point.y = init_ytable[init_count]

    -- 计划飞行帧数
    local iFrame = 0
    local iFrameX = 0
    local iFrameY = 0

    -- 向上弯的距离
    local fUpMoveDis = 180

    -- 速度
    local fxSpeed = 15
    -- 水平速度
    local fySpeed = -15
    -- 垂直速度

    -- 修正水平速度
    if end_point.x < newPoint.x then fxSpeed = - fxSpeed end

    -- 计算水平到达帧数
    iFrameX = math.abs(int((end_point.x - point.x) / fxSpeed))

    -- 计算垂直到达帧数
    iFrameY = math.abs(int((math.abs(end_point.y - point.y) + fUpMoveDis * 2) / fySpeed))

    -- 合并计算
    if iFrameX > iFrameY then

        fySpeed =(math.abs(end_point.y - point.y) + 2 * fUpMoveDis) / iFrameX
        iFrame = iFrameX

    else

        fxSpeed =(end_point.x - newPoint.x) / iFrameY
        iFrame = iFrameY
    end

    -- 帧数
    local iUpMoveNum = math.abs(math.floor(fUpMoveDis / fySpeed))
    if fySpeed > 0 then fySpeed = - fySpeed end
    for i = 1, iFrame do

        local newPoint = startPoint
        -- 向上飞完了
        local fNewYSpeed = fySpeed
        if i >= iUpMoveNum then

            if newPoint.y < end_point.y then fNewYSpeed = - fySpeed end
        end

        -- 新点
        newPoint.x = newPoint.x + fxSpeed
        newPoint.y = newPoint.y + fNewYSpeed;

        -- 增加位置点
        table.insert(trace_vector, newPoint)
    end

    local lastPoint = trace_vector[#trace_vector]
    lastPoint.x = init_xtable[init_count]
    lastPoint.y = init_ytable[init_count]
end

-- init_x 起始点 x坐标
-- init_y 起始点 y坐标
-- angle 角度
-- std::vector<FPoint>& trace_vector
-- 大闹天宫用到
function MathAide:BuildLinearHoShou(init_x, init_y, angle, distance)

    local visbleSize = display.size
    if LuaUtils.IphoneXDesignResolution then
        visbleSize.width = 1334   
        visbleSize.height = 750
    end
    if init_x < 0 then
        init_x = 0
    end
    if init_x > visbleSize.width then
        init_x = visbleSize.width
    end
    if init_y < 0 then
        init_y = 0
    end
    if init_y > visbleSize.height then
        init_y = visbleSize.height
    end
    while (angle > M_PI * 2) do
        angle = angle - M_PI * 2
    end

    local isEnd = false
    local trace_vector = { {}, {}, {}, }
    local size = 0
    while (true) do
        local pointAngle = { }
        size = size + 1
        if angle >= 0 and angle <= M_PI / 2 then

            pointAngle.x = init_x + math.sin(angle) * distance *(size)
            pointAngle.y = init_y + math.cos(angle) * distance *(size)

        elseif angle > M_PI_2 and angle <= M_PI then

            local anglel = angle - M_PI_2
            pointAngle.x = init_x + math.cos(anglel) * distance *(size)
            pointAngle.y = init_y - math.sin(anglel) * distance *(size)

        elseif angle > M_PI and angle <= (M_PI_2 * 3) then

            local anglel = angle - M_PI
            pointAngle.x = init_x - math.sin(anglel) * distance *(size)
            pointAngle.y = init_y - math.cos(anglel) * distance *(size)

        elseif angle >(M_PI_2 * 3) and angle <=(M_PI * 2) then

            local anglel =(M_PI * 2) - angle
            pointAngle.x = init_x - math.sin(anglel) * distance *(size)
            pointAngle.y = init_y + math.cos(anglel) * distance *(size)
        end
        pointAngle.angle = angle
        if pointAngle.x <= 0 or pointAngle.x >= visbleSize.width or pointAngle.y <= 0 or pointAngle.y >= visbleSize.height then

            if isEnd then
                break
            end

            if pointAngle.x < 0 then
                pointAngle.x = 0
            end
            if pointAngle.x > visbleSize.width then
                pointAngle.x = visbleSize.width
            end
            if pointAngle.y < 0 then
                pointAngle.y = 0
            end
            if pointAngle.y > visbleSize.height then
                pointAngle.y = visbleSize.height
            end
            isEnd = true
        end

        trace_vector[1][size] = pointAngle.x
        trace_vector[2][size] = pointAngle.y
        trace_vector[3][size] = pointAngle.angle
    end
    return trace_vector
end

--逆时针旋转(4号/5号/6号/7号鱼阵)
function MathAide:BuildCirclePath(center, radius, rotate_duration, start_angle, rotate_angle)

    local vecLine = { {}, {}, {}, }

    --第一个点
    vecLine[1][1] = center.x + radius * math.cos(start_angle)
    vecLine[2][1] = center.y + radius * math.sin(start_angle)
    vecLine[3][1] = math.radian2angle(M_PI_2 - start_angle) + 180

    --剩余点
    local dur, angle, size = 0.033, 0, 1
    local test_angle = 0
    while (dur < rotate_duration) do
        size = size + 1
        angle = start_angle + rotate_angle * dur / rotate_duration
        vecLine[1][size] = center.x + radius * math.cos(angle)
        vecLine[2][size] = center.y + radius * math.sin(angle)
        vecLine[3][size] = math.radian2angle(M_PI_2 - angle) + 180
        dur = dur + 0.033
    end

    ---------------------------------------------------------------------
    --测试用点计算角度
    --local function getAngle(pos_curr, pos2_next)
    --    local vec = cc.pSub(pos2_next, pos_curr)
    --    local angle = math.radian2angle(cc.pGetAngle(vec, cc.p(0, 1))) 
    --    return (angle + 270) % 360
    --end
    --local angle = 0
    --local pos_curr = 0
    --local pos_next = 0
    --for i, v in ipairs(vecline[1]) do
    --    pos_curr = cc.p(vecline[1][i], vecline[2][i])
    --    pos_next = cc.p(vecline[1][i + 1], vecline[2][i + 1])
    --    if pos_next_x and pos_next_y then
    --        angle = getangle(pos_curr, pos_next)
    --    end
    --    vecline[4][i] = angle
    --end
    ---------------------------------------------------------------------

    return vecLine
end

--顺时针旋转(8号/9号/10号/11号/14号鱼阵)
function MathAide:BuildCirclePathOther(center, radius, rotate_duration, start_angle, rotate_angle)
    local vecLine = { {}, {}, {}, }
    
    --第一个点
    vecLine[1][1] = center.x + radius * math.cos(start_angle)
    vecLine[2][1] = center.y + radius * math.sin(start_angle)
    vecLine[3][1] = math.radian2angle(M_PI_2 - start_angle)

    --剩余点
    local dur, angle, size = 0.033, 0, 1
    while (dur < rotate_duration) do
        size = size + 1
        angle = start_angle - rotate_angle * dur / rotate_duration
        vecLine[1][size] = center.x + radius * math.cos(angle)
        vecLine[2][size] = center.y + radius * math.sin(angle)
        vecLine[3][size] = math.radian2angle(M_PI_2 - angle)
        dur = dur + 0.033
    end
    return vecLine
end 

--逆时针(小圆)(17号/18号鱼阵)
function MathAide:ActionScene7FishMoveLine(center, radius, start_angle)
    local vecTrack = { {}, {}, {}, }
    local curAngle, dur, angle, size = 0, 0, 0, 0
    while (curAngle  < M_PI) do
        size = size + 1
        angle = start_angle + 4 * M_PI * dur / 14.3
        vecTrack[1][size] = center.x + radius * math.cos(angle)
        vecTrack[2][size] = center.y + radius * math.sin(angle)
        vecTrack[3][size] = math.radian2angle(M_PI_2 - angle) + 180
        curAngle = angle
        dur = dur + 0.033
    end
    if vecTrack[2][size] < center.y then
        vecTrack[2][size] = center.y
        vecTrack[1][size] = center.x - radius
    end
    return vecTrack
end 

--逆时针(大圆)(15号/16号鱼阵)
function MathAide:ActionScene8FishMoveLine(center, radius, start_angle)

    local vecTrack = { {}, {}, {}, }
    local curAngle, dur, angle, size = 0, 0, 0, 0
    while (curAngle < M_PI) do
        size = size + 1
        angle = start_angle + 6 * M_PI * dur / 14.3
        vecTrack[1][size] = center.x + radius * math.cos(angle)
        vecTrack[2][size] = center.y + radius * math.sin(angle)
        vecTrack[3][size] = math.radian2angle(M_PI_2 - angle) + 180
        curAngle = angle
        dur = dur + 0.033
    end
    
    if vecTrack[2][size] < center.y then
        vecTrack[1][size] = center.x - radius
        vecTrack[2][size] = center.y
    end
    return vecTrack
end 

return MathAide
--endregion
