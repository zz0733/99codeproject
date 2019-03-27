local TrendDefine = import('.TrendDefine')
local Lu = TrendDefine.Lu
local LU_TYPE = TrendDefine.LU_TYPE
local M = class('DragonTigerTrendHelper')

local zplData = {} -- 珠盘路数据
local dlData = {} -- 大路数据
local dyzlData = {} -- 大眼仔路数据
local xlData = {} -- 小路数据
local yylData = {} -- 曱甴路数据

function M.analyze(data)
    M.reset()
    data = M.convertData(data)
    M._analyzeZPL(data)
    M._analyzeDL()
    M._analyzeDYZL()
    M._analyzeXL()
    M._analyzeYYL()
end

function M.analyzeT1WenLu(data)
    data = data or {}
    data = clone(data)
    table.insert(data, {record = 2})
    M.analyze(data)
end

function M.analyzeT2WenLu(data)
    data = data or {}
    data = clone(data)
    table.insert(data, {record = 0})
    M.analyze(data)
end

function M.getZPL()
    return zplData
end

function M.getDL()
    return M._arrange(dlData)
end

function M.getDYZL()
    return M._arrange(dyzlData)
end

function M.getXL()
    return M._arrange(xlData)
end

function M.getYYL()
    return M._arrange(yylData)
end

function M.getLastDYZL()
    local lastColumn = dyzlData[#dyzlData]
    if lastColumn then
        return lastColumn[#lastColumn]
    end
end

function M.getLastXL()
    local lastColumn = xlData[#xlData]
    if lastColumn then
        return lastColumn[#lastColumn]
    end
end

function M.getLastYYL()
    local lastColumn = yylData[#yylData]
    if lastColumn then
        return lastColumn[#lastColumn]
    end
end

function M.convertData(data)
    local trendData = {}
    for i, v in ipairs(data) do
        local type
        local result = v.record
        if 0 == result then
            type = LU_TYPE.T1
        elseif 1 == result then
            type = LU_TYPE.T3
        elseif 2 == result then
            type = LU_TYPE.T2
        end
        if type then
            table.insert(trendData, type)
        end
    end
    return trendData
end

function M._arrange(data)
    local ret = {}
    for i, v in ipairs(data) do
        local changeRow
        for i2, v2 in ipairs(v) do
            ret[i] = ret[i] or {}
            if not changeRow and 6 >= i2 and nil == ret[i][i2] then
                ret[i][i2] = v2
            else
                changeRow = changeRow or i2 - 1
                local idxOther = i + i2 - changeRow
                ret[idxOther] = ret[idxOther] or {}
                ret[idxOther][changeRow] = v2
            end
        end
    end
    return ret
end

function M._analyzeZPL(data)
    for i, v in ipairs(data) do
        table.insert(zplData, Lu:create(v))
    end
end

function M._analyzeDL()
    local srcData = zplData
    local dstData = dlData
    local len = #srcData
    for i = 1, len do
        local dataItem = srcData[i]
        local type = dataItem.type
        if LU_TYPE.T3 ~= type then
            local draw = 0 -- 和局数
            for j = i + 1, len do
                if LU_TYPE.T3 ~= srcData[j].type then
                    break
                end
                draw = draw + 1
            end
            i = i + draw
            local lu
            if 0 < draw then
                lu = Lu:create(type, draw)
            else
                lu = Lu:create(type)
            end

            local dstLen = #dstData
            local lastColumn = dstData[dstLen]
            if 0 < dstLen and lastColumn[1].type == lu.type then
                table.insert(lastColumn, lu)
            else
                table.insert(dstData, {lu})
            end
        end
    end
end

function M._analyzeDYZL()
    M._analyzeLuFromDL(dyzlData, 2)
end

function M._analyzeXL()
    M._analyzeLuFromDL(xlData, 3)
end

function M._analyzeYYL()
    M._analyzeLuFromDL(yylData, 4)
end

function M._analyzeLuFromDL(dstData, startColumn)
    local srcData = dlData
    local dstData = dstData
    for column = startColumn, #srcData do
        for row = 1, #srcData[column] do
            if not (startColumn == column and 1 == row) then
                local type
                if 1 == row then
                    if #srcData[column - 1] == #srcData[column - startColumn] then
                        type = LU_TYPE.T1
                    else
                        type = LU_TYPE.T2
                    end
                else
                    local anaColumn = srcData[column - startColumn + 1]
                    local daLuItem = anaColumn[row]
                    local daLuItemUp = anaColumn[row - 1]
                    if not anaColumn[row] and anaColumn[row - 1] then
                        type = LU_TYPE.T2
                    else
                        type = LU_TYPE.T1
                    end
                end
                local lu = Lu:create(type)
                local lastColumn = dstData[#dstData]
                if lastColumn and 0 < #lastColumn and lu.type == lastColumn[1].type then
                    table.insert(lastColumn, lu)
                else
                    table.insert(dstData, {lu})
                end
            end
        end
    end
end

function M.reset()
    zplData = {}
    dlData = {}
    dyzlData = {}
    xlData = {}
    yylData = {}
end

return M
