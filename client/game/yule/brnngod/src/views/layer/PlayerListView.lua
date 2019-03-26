-- NiuniuPlayerListView.lua
-- 牛牛玩家列表
-- Create by tanglei@2017-9-20

--local BaseFullLayer = require("app.fw.common.BaseFullLayer")
--local CommonHelper = require('app.fw.common.CommHelper')

local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local module_pre = "game.yule.brnngod.src"
local Define = appdf.req(module_pre .. ".models.Define")
local HeadSprite = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
local HandredcattleRes = appdf.req(module_pre .. ".views.layer.handClasses.HandredcattleRes")
local PlayerListView = class("PlayerListView", cc.exports.FixLayer)
PlayerListView.RESOURCE_FILENAME = "Niuniu/NiuNiuPlayerList.csb"

local PlayerInfoItem = class('PlayerInfoItem')
local LineItem = class('LineItem', function() -- 闲家基本信息item
    return cc.TableViewCell:new()
end)

-- 初始化UI
function PlayerListView:ctor(playerInfoTable)
    -----PlayerListView.super.initUI(self, ...)
    print("NiuniuPlayerListView")
    ----require('app.fw.common.PopupEffect').init(
    ----    self,
    ----    self.bg,
    ----    self.resourceNode_:getChildByName('Panel_1') ,
    ----    true,
    ----    handler(self, self.popupAniEnd)
    ----)
    self.m_playerInfoTable = playerInfoTable
    local csbNode = ExternalFun.loadCSB(HandredcattleRes.CSB_GAME_PLAYER_LIST, self)
    self:setTargetShowHideStyle(self, self.SHOW_POPUP, self.HIDE_POPOUT)
    Define:getNodeList(self, csbNode)
    self:setVisible(false)

    -- 事件
    -- addNodeListener(self, "recvNnGetPlayerListRes", handler(self, self.recvDraonfightPlayersInfoRes))

    -- 按钮事件
    self.close:addClickEventListener(handler(self, self.onCloseView))

    -- table view
    self._playerTbView = self:createTableView(self.list, 'players', LineItem, self.itemModelLine)
    self.list:getParent():addChild(self._playerTbView)

    -- self:initListPlayer()
    self.num:setString(0)
    -- performWithDelay(self, function()
    --     cc.loaded_packages.NiuTigerLogic:requestNnGetPlayerListReq()
    -- end, 0.1)

    self:recvDraonfightPlayersInfoRes(playerInfoTable)
end

function PlayerListView:popupAniEnd()
    ------pcall(function () showLoadingView(LoadingViewType.LOAD_DATA) end)
    ------addNodeListener(self, "recvNnGetPlayerListRes", handler(self, self.recvDraonfightPlayersInfoRes))
    Define:performWithDelay(self, function()
        cc.loaded_packages.NiuTigerLogic:requestNnGetPlayerListReq()
    end, 0.1)
end

-- 返回按键响应
function PlayerListView:onBack( ... )
    ------pcall(function() hideLoadingView() end)
    self:onClose()
end
function PlayerListView:onCloseView()
    ------pcall(function() hideLoadingView() end)
    self:onClose()
end

function PlayerListView:onClose()
    self:hidePopout()
end

-- 事件：闲家列表
function PlayerListView:recvDraonfightPlayersInfoRes(event)
    print('NiuniuPlayerListView:recvDraonfightPlayersInfoRes')
    ------pcall(function () hideLoadingView() end )
    -- 变成二维数组（一行三个）
    local list = event or {}
    local tmp = {{}}
    local counter = 0
    for i, playerInfo in ipairs(list) do
        local group = tmp[#tmp] 
        if #group == 3 then
            group = {}
            table.insert(tmp, group)
        end

        table.insert(group, playerInfo)
    end

    self.dataList_players = tmp
    self._playerTbView:reloadData()


    -- 在线人数
    -- local model = cc.loaded_packages.DragonTigerLogic:getModel()
    -- self.num:setString(model:getPlayerNum())
    self.num:setString(#list)
end

function PlayerListView:initListPlayer( ... )
    -- body
    -- local info = cc.loaded_packages.NiuTigerLogic:getModel():getAllOtherListTmp() 
    -- self:recvDraonfightPlayersInfoRes({_userdata = info})
end


-- 使用table view 优化列表效率
function PlayerListView:createTableView(sizeNode, name, cellClass, itemModel)
    local cellSize = itemModel:getContentSize()

    local function tableCellSizeForIndex(self, table, idx)
        return cellSize.width, cellSize.height
    end
    
    local function tableCellAtIndex(self, table, idx)
        local cell = table:dequeueCell()
        if not cell then
            cell = cellClass.new()
        end

        local list = self['dataList_'..name] or {}
        local data = list[idx + 1]
        cell:setIdx(idx)
        cell:init(idx, data, itemModel)
        return cell
    end
    
    local function numberOfCellsInTableView(self)
        local list = self['dataList_'..name] or {}
        return #list
    end
    
    local function tableCellTouched(self, table, cell)
        -- cell:onClick()
    end
    
    local function tableCellHighlight(self, table, cell)
        -- cell:tableCellHighlight()
    end
    
    local function tableCellUnhighlight(self, table, cell)
        -- cell:tableCellUnhighlight()
    end
    

    local size = sizeNode:getContentSize()
    local pos = cc.p(sizeNode:getPosition())

    local tableView = cc.TableView:create(size)
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setDelegate()
    tableView:setVerticalFillOrder(0)
    
    tableView:registerScriptHandler(handler(self, tableCellSizeForIndex), cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(handler(self, tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(handler(self, numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(handler(self, tableCellTouched), cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(handler(self, tableCellHighlight), cc.TABLECELL_HIGH_LIGHT)
    tableView:registerScriptHandler(handler(self, tableCellUnhighlight), cc.TABLECELL_UNHIGH_LIGHT)

    -- self:addChild(tableView)
    tableView:setPosition(pos)
    tableView:setName(name)
    return tableView
end
-----------------------------------------------------------------------------

function LineItem:init(index, data, itemModel)
    local TAG_ITEM = 100

    local old = self:getChildByTag(TAG_ITEM)
    if old ~= nil then
        self.node = old
    else
        self.node = itemModel:clone()
        self.node:setTag(TAG_ITEM)
        self:addChild(self.node)
    end

    ------UIHelper.parseCSDNode(self, self.node)
    Define:getNodeList(self, self.node)
    self.node:setPosition(cc.p(10, 0))

    for i = 1, 3 do
        local playerNode = self['player_'..i]
        playerNode:setVisible(data[i] ~= nil)
        if data[i] ~= nil then
            PlayerInfoItem.new(data[i], playerNode)
        end
    end
end

function PlayerInfoItem:ctor(base, node)
    local player = base
    player.rid = player[1]
    player.rolename = player[2]
    player.coin = player[6]
    player.logo = player[3]
    player.sex = player[5]
    player.avatar_no = player[3]
    player.vip = 0
    dump(player, "player-------------------")
    self.node = node
    Define:getNodeList(self, self.node)

    -- CommonHelper:loadHeadMiddleImg(self.avatar, player.sex or 0, player.logo or 1) -- 头像
    -- CommonHelper:setVIPIcon(self.avatar, player.vip or 0)
    -- self.name:setString(player.rolename)
    self.name:setString(LuaUtils.getDisplayNickName(player.rolename, 8, true))
    -- 钱钱
    self.coin:setString(player.coin or 0)
    -- 点头像弹信息面板
    local rid = player.rid
    -- 头像
    self.avatar:setScale(0.6)
    local avatar = createStencilAvatar(self.avatar, cc.size(2, 2))
    loadHeadMiddleImg(avatar, player.sex or 0, player.logo or 1) -- 头像
    setVIPIcon(self.node, player.vip or 0)

    -- avatar:getParent():setAlphaThreshold((player.vip or 0) > 0 and 0 or 0.6) -- 切换剪裁区域

    local infoTable = {}
    infoTable.rid = rid
    infoTable.x = self.avatar:getPositionX()
    infoTable.y = self.avatar:getPositionY()

    -- 点头像弹信息面板
    -- local rid = player.rid
    -- self.avBtn:addClickEventListener(handler(self, function(self)
    --     dispatchEvent('event_openPlayerInfo', rid)
    -- end))    
end

--------------------------------------------------------------------------


return PlayerListView