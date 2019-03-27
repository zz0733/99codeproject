local module_pre = "game.yule.lhdz.src."
local TrendDefine           = appdf.req(module_pre.."game.longhudazhan.trend.TrendDefine")
local LU_TYPE               = TrendDefine.LU_TYPE
local TrendHelper           = appdf.req(module_pre.."game.longhudazhan.trend.TrendHelper")
local Lhdz_Res              = appdf.req(module_pre.."game.longhudazhan.scene.Lhdz_Res")
local LhdzDataMgr = require("game.yule.lhdz.src.game.longhudazhan.manager.LhdzDataMgr")
local M = class('DragonTigerTrend', function()
    return cc.CSLoader:createNode(Lhdz_Res.CSB_OF_DRAGONTREND)
end)

local function overflowIndex(total, max, m)
    local startIdx = 1
	if max < total then
		local mod = total % m
		local left = (0 == mod) and 0 or (m - mod)
        startIdx = total - max + 1 + left
    end
    return startIdx
end

function M:ctor( )
    --cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(1280, 720, cc.ResolutionPolicy.EXACT_FIT)
    bindCCBNode(self, self)
end

function M:updateTrend()
    local data = LhdzDataMgr:getInstance():getTrendListRecord()
    TrendHelper.analyze(data)
    self:updateZPL()
    self:updateDL()
    self:updateDYZL()
    self:updateXL()
    self:updateYYL()
    self:updateRoundNum()
    TrendHelper.analyzeT1WenLu(data)
    self:updateT1WenLu()
    TrendHelper.analyzeT2WenLu(data)
    self:updateT2WenLu()
end

function M:updateZPL()
    self.zplContainer:removeAllChildren()
    local data = TrendHelper.getZPL()
    local itemWH = 38.5

    local len = #data
    local startIdx = overflowIndex(len, 48, 6)
    local lastNode
    for i = startIdx, len do
        local idx = i - startIdx
        local cloneNode = self['zplItem_' .. data[i].type]
        if cloneNode then
            local nodeItem = cloneNode:clone()
            local row = idx % 6
            local column = math.modf(idx / 6)
            nodeItem:setPosition(column * itemWH, -row * itemWH)
            self.zplContainer:addChild(nodeItem)
            lastNode = nodeItem
        end
    end
    if lastNode then
        lastNode:runAction(cc.Blink:create(3, 5))
    end
end

function M:updateDL()
    self.dlContainer:removeAllChildren()
    local data = TrendHelper.getDL()
    local len = #data
    local startIdx = 1
    if 24 < len then
        startIdx = startIdx + len - 24
    end
    local lastNode
    for i = startIdx, len do
        local columnData = data[i]
        for j = 1, table.maxn(columnData) do
            local dataItem = columnData[j]
            if dataItem then
                local nodeItem = self['dlItem_' .. dataItem.type]:clone()
                nodeItem:setPosition((i - startIdx) * 18.4, -(j - 1) * 19.5)
                self.dlContainer:addChild(nodeItem)
                if dataItem.extra then
                    local text = cc.Label:create()
                    text:setString(dataItem.extra)
                    text:setSystemFontSize(10)
                    text:setTextColor(cc.c4b(28, 181, 6, 255))
                    text:setPosition(8.5, 8.5)
                    nodeItem:addChild(text)
                end
                lastNode = nodeItem
            end
        end
    end
    if lastNode then
        lastNode:runAction(cc.Blink:create(3, 5))
    end
end

function M:updateDYZL()
    self.dyzlContainer:removeAllChildren()
    local data = TrendHelper.getDYZL()
    local len = #data
    local startIdx = 1
    if 24 < len then
        startIdx = startIdx + len - 24
    end
    local lastNode
    for i = startIdx, len do
        local columnData = data[i]
        for j = 1, table.maxn(columnData) do
            local dataItem = columnData[j]
            if dataItem then
                local nodeItem = self['dyzlItem_' .. dataItem.type]:clone()
                nodeItem:setPosition((i - startIdx) * 9.2, -(j - 1) * 9.75)
                self.dyzlContainer:addChild(nodeItem)
                lastNode = nodeItem
            end
        end
    end
    if lastNode then
        lastNode:runAction(cc.Blink:create(3, 5))
    end
end

function M:updateXL()
    self.xlContainer:removeAllChildren()
    local data = TrendHelper.getXL()
    local len = #data
    local startIdx = 1
    if 24 < len then
        startIdx = startIdx + len - 24
    end
    local lastNode
    for i = startIdx, len do
        local columnData = data[i]
        for j = 1, table.maxn(columnData) do
            local dataItem = columnData[j]
            if dataItem then
                local nodeItem = self['xlItem_' .. dataItem.type]:clone()
                nodeItem:setPosition((i - startIdx) * 9.2, -(j - 1) * 9.75)
                self.xlContainer:addChild(nodeItem)
                lastNode = nodeItem
            end
        end
    end
    if lastNode then
        lastNode:runAction(cc.Blink:create(3, 5))
    end
end

function M:updateYYL()
    self.yylContainer:removeAllChildren()
    local data = TrendHelper.getYYL()
    local len = #data
    local startIdx = 1
    if 24 < len then
        startIdx = startIdx + len - 24
    end
    local lastNode
    for i = startIdx, len do
        local columnData = data[i]
        for j = 1, table.maxn(columnData) do
            local dataItem = columnData[j]
            if dataItem then
                local nodeItem = self['yylItem_' .. dataItem.type]:clone()
                nodeItem:setPosition((i - startIdx) * 9.2, -(j - 1) * 9.75)
                self.yylContainer:addChild(nodeItem)
                lastNode = nodeItem
            end
        end
    end
    if lastNode then
        lastNode:runAction(cc.Blink:create(3, 5))
    end
end

function M:updateRoundNum()
    local longRound = LhdzDataMgr:getInstance():getDragonWinCount() or 0
    local heRound = LhdzDataMgr:getInstance():getDrawWinCount() or 0
    local huRound = LhdzDataMgr:getInstance():getTigerWinCount() or 0
    self.round_long:setString(longRound)
    self.round_hu:setString(huRound)
    self.round_he:setString(heRound)
    self.round_total:setString(longRound + huRound + heRound)
end

function M:updateT1WenLu()
    local data = TrendHelper.getLastDYZL()
    self.wenlu_1_1:setVisible(nil ~= data)
    if data then
        if LU_TYPE.T1 == data.type then
            self.wenlu_1_1:loadTexture('game/longhudazhan/image/trend/lhzst_008.png')
        elseif LU_TYPE.T2 == data.type then
            self.wenlu_1_1:loadTexture('game/longhudazhan/image/trend/lhzst_007.png')
        end
    end
    data = TrendHelper.getLastXL()
    self.wenlu_1_2:setVisible(nil ~= data)
    if data then
        if LU_TYPE.T1 == data.type then
            self.wenlu_1_2:loadTexture('game/longhudazhan/image/trend/lhzst_011.png')
        elseif LU_TYPE.T2 == data.type then
            self.wenlu_1_2:loadTexture('game/longhudazhan/image/trend/lhzst_010.png')
        end
    end
    data = TrendHelper.getLastYYL()
    self.wenlu_1_3:setVisible(nil ~= data)
    if data then
        if LU_TYPE.T1 == data.type then
            self.wenlu_1_3:loadTexture('game/longhudazhan/image/trend/lhzst_013.png')
        elseif LU_TYPE.T2 == data.type then
            self.wenlu_1_3:loadTexture('game/longhudazhan/image/trend/lhzst_012.png')
        end
    end
end

function M:updateT2WenLu()
    local data = TrendHelper.getLastDYZL()
    self.wenlu_2_1:setVisible(nil ~= data)
    if data then
        if LU_TYPE.T1 == data.type then
            self.wenlu_2_1:loadTexture('game/longhudazhan/image/trend/lhzst_008.png')
        elseif LU_TYPE.T2 == data.type then
            self.wenlu_2_1:loadTexture('game/longhudazhan/image/trend/lhzst_007.png')
        end
    end
    data = TrendHelper.getLastXL()
    self.wenlu_2_2:setVisible(nil ~= data)
    if data then
        if LU_TYPE.T1 == data.type then
            self.wenlu_2_2:loadTexture('game/longhudazhan/image/trend/lhzst_011.png')
        elseif LU_TYPE.T2 == data.type then
            self.wenlu_2_2:loadTexture('game/longhudazhan/image/trend/lhzst_010.png')
        end
    end
    data = TrendHelper.getLastYYL()
    self.wenlu_2_3:setVisible(nil ~= data)
    if data then
        if LU_TYPE.T1 == data.type then
            self.wenlu_2_3:loadTexture('game/longhudazhan/image/trend/lhzst_013.png')
        elseif LU_TYPE.T2 == data.type then
            self.wenlu_2_3:loadTexture('game/longhudazhan/image/trend/lhzst_012.png')
        end
    end
end

return M
