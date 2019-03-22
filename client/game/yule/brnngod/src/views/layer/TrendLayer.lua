-- NiuTrendView.lua
-- 牛牛走势
-- Create by tanglei@2017-7-11

local BET_TYPE_CNT = 4

local ExternalFun       = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local module_pre = "game.yule.brnngod.src"
local Define = appdf.req(module_pre .. ".models.Define")
local TrendLayer = class("TrendLayer", cc.exports.FixLayer)
local HandredcattleRes              = appdf.req(module_pre .. ".views.layer.handClasses.HandredcattleRes")
-- 初始化UI
function TrendLayer:ctor( ... )
    --NiuTrendView.super.initUI(self, ...)

    --[[require('app.fw.common.PopupEffect').init(
        self,
        self.bg, 
        self.resourceNode_:getChildByName('Panel_1') 
    )]]--

    local csbNode = ExternalFun.loadCSB(HandredcattleRes.CSB_GAME_TREND_VIEW, self)
    self:setTargetShowHideStyle(self, self.SHOW_POPUP, self.HIDE_POPOUT)
    Define:getNodeList(self, csbNode)
    self:setVisible(false)

    self.close:addClickEventListener(handler(self, self.onClose))
    --addNodeListener(self, "recvNnGetTrendRes", handler(self, self.recvNnGetTrendRes))


    --cc.loaded_packages.NiuTigerLogic:requestNnGetTrendReq()
end

-- 返回按键响应
function TrendLayer:onBack( ... )
    self:onClose()
end

function TrendLayer:onClose()
    self:hidePopout()
end

-- 事件
function TrendLayer:recvNnGetTrendRes(event)
    print('NiuTrendView:recvNnGetTrendRes')

    local function len(tab)
        local n = 0
        for _1, _2 in ipairs(tab) do
            n = n + 1
        end
        return n
    end

    ------local newlyTrendInfo = (event._userdata or {}).newlyTrendInfo or {}
    local newlyTrendInfo = event or {}
    local n = #newlyTrendInfo
    local list = {}
    for i = 1, n do
        local info = {}
        table.insert(info, ((newlyTrendInfo or {})[i] or {})[1] or 0)
        table.insert(info, ((newlyTrendInfo or {})[i] or {})[2] or 0)
        table.insert(info, ((newlyTrendInfo or {})[i] or {})[3] or 0)
        table.insert(info, ((newlyTrendInfo or {})[i] or {})[4] or 0)
        table.insert(list, info)
    end

    self:reloadData(list)
end


-- 加载数据
function TrendLayer:reloadData(list)
    print('NiuTrendView:reloadData')

    -- 创建
    self.shengchang1=0
    self.shengchang2=0
    self.shengchang3=0
    self.shengchang4=0
    local function createItem(data,index)
        local WIN_IMG = 'game/handredcattle/image/brnn_sfzs/brnn_sfzs_sheng.png'
        local LOSE_IMG = 'game/handredcattle/image/brnn_sfzs/brnn_sfzs_fu.png'
        local node = self.itemModel:clone()
        local obj = {}
        ------UIHelper.parseCSDNode(obj, node)
        Define:getNodeList(obj, node)
        --if index == 20 then
        local maxIndex = 15
        if index == maxIndex then
            obj['newbg']:setVisible(true)
            obj['new']:setVisible(true)
        end
        for i = 1, BET_TYPE_CNT do
            local op = obj['op'..i]
            op:loadTexture(data[i] > 1 and WIN_IMG or LOSE_IMG)
            if data[i] > 1 then
                self["shengchang"..i] = self["shengchang"..i]+1
            end
        end
        return node
    end

    self.list:removeAllItems()

    for i, data in ipairs(list) do
        print('@', i) for k, v in pairs(data) do print(v) end -- debug
        local item = createItem(data,i)

        self.list:pushBackCustomItem(item)
    end
    for i = 1, BET_TYPE_CNT do
        local shenglv = (self["shengchang"..i] / 20) * 100 --20局胜率
        self["shenglv"..i]:setString(shenglv.."%")
    end
    self.list:jumpToRight()
end

function TrendLayer:setTrendData(histroyTable)
    self:recvNnGetTrendRes(histroyTable)
end

return TrendLayer