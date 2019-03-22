-- NiuDealerQView.lua
-- 上庄列表
-- Create by tanglei@2017-9-20
local ExternalFun       = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local module_pre = "game.yule.brnngod.src"

------local BaseFullLayer = app.req("app.fw.common.BaseFullLayer")
------local CommonHelper = app.req('app.fw.common.CommHelper')
------local Const = app.req('app.games.Niuniu.NiuConst')
local Define = appdf.req(module_pre..'.models.Define')
local Lang = appdf.req(module_pre..'.views.layer.NiuLang')
local HandredcattleRes = appdf.req(module_pre .. ".views.layer.handClasses.HandredcattleRes")

local DealerQueueView = class("NiuDealerQView", cc.exports.FixLayer)
DealerQueueView.RESOURCE_FILENAME = "Niuniu/NiuDealerQueue.csb"

local WaitQueueItem = class('WaitQueueItem') -- 上庄队列
local _ = {}


-- 初始化UI
function DealerQueueView:ctor( pNodeGameView)
    ------NiuDealerQView.super.initUI(self, ...)

    ------require('app.fw.common.PopupEffect').init(
    ------    self,
    ------    self.bg,
    ------    self.resourceNode_:getChildByName('Panel_1')
    ------)
    local csbNode = ExternalFun.loadCSB(HandredcattleRes.CSB_GAME_DEALER_QUEUE, self)
    self:setTargetShowHideStyle(self, self.SHOW_POPUP, self.HIDE_POPOUT)
    Define:getNodeList(self, csbNode)
    self:setVisible(false)

    self.m_pNodeGameView = pNodeGameView
    self.close:addClickEventListener(handler(self, self.onBack))
    self.cancelZhuangBtn:addClickEventListener(handler(self, self.onClickCancelZhuang))    
    self.beZhuangBtn:addClickEventListener(handler(self, self.onClickQPanelBeZhuang))    

    ---addNodeListener(self, "recvNnGetApplyUpBankerRes", handler(self, self.recvNnGetApplyUpBankerRes))
    ---addNodeListener(self, "event_closeDealerQ", handler(self, self.onEventCloseDealerQ))
    ---addNodeListener(self, "event_DealerInfoRefresh", handler(self, self.onEventDealerInfoRefresh))


    --设置最小庄携带
    ------local carry = cc.loaded_packages.NiuTigerLogic:getModel():getMinZhuangCarry()
    ------CommonHelper:loadNumber(self.minZhuangCarry, carry, false)

    self:recvNnGetApplyUpBankerRes()
    --self:updateBtns()
end

-- 返回按键响应
function DealerQueueView:onBack( ... )
    self:onClose()
end

function DealerQueueView:onClose()
    self:hidePopout()
end

-- 取消上庄点击时调用
function DealerQueueView:onClickCancelZhuang()

    -- 老板，你确定要取消上庄申请吗？
    require('app.fw.common.DialogBox').show("", Lang.DEALER_CANCEL_QUES, Lang.CONFIRM, Lang.CANCEL, function()
        cc.loaded_packages.NiuTigerLogic:requestNnApplyUpDownBankerReq(false) -- 下庄
        cc.loaded_packages.NiuTigerLogic:requestNnGetApplyUpBankerReq() -- 拉列表
    end)

end


-- 上庄面板，上庄按钮点击时调用
function DealerQueueView:onClickQPanelBeZhuang()
    -- 金币不足
    --self.m_pNodeGameView
    local model = self.m_pNodeGameView
    if not model:canBeDealer() then
        -- dispatchEvent('event_NiuMessage', Lang.DEALER_MONEY_NOT_ENOUGH)
        local showDialog = require('app.fw.common.DialogBox').show
        showDialog(Lang.DEF_MSG_TITLE, Lang.ZHUANG_BUY, Lang.OK, Lang.CANCEL, function()
            local view = cc.loaded_packages.App:createLayer('app.games.Niuniu.ui.NiuRechargeView')
            cc.Director:getInstance():getRunningScene():addChild(view)            
        end)        
        return
    end

    cc.loaded_packages.NiuTigerLogic:requestNnApplyUpDownBankerReq(true) -- 上庄
    cc.loaded_packages.NiuTigerLogic:requestNnGetApplyUpBankerReq() -- 上庄队列
end

-- 事件：关闭UI
function DealerQueueView:onEventCloseDealerQ(event)
    print('NiuDealerQView:onEventCloseDealerQ')

    self:onBack()
end

-- 事件：响应申请上庄列表
function DealerQueueView:recvNnGetApplyUpBankerRes()
    print('NiuDealerQView:recvNnGetApplyUpBankerRes')

    self:updateBtns()
    self:reloadDealerList()
end

-- 事件：庄家刷新(game start时)
function DealerQueueView:onEventDealerInfoRefresh()
    print('NiuDealerQView:onEventDealerInfoRefresh()')
    self:updateBtns()
    dispatchEvent('event_closeDealerQ')
end

-- 刷新按钮状态
function DealerQueueView:updateBtns()
    local model = self.m_pNodeGameView
    local isSelfDealer = model:isBanker()
    local isSelfInDealerQueue = model:isSelfInDealerQueue()
    print('@@#', isSelfDealer, isSelfInDealerQueue)

    self.cancelZhuangBtn:setVisible(not isSelfDealer and isSelfInDealerQueue) -- 取消申请
    self.beZhuangBtn:setVisible(not isSelfDealer and not isSelfInDealerQueue) -- 申请上庄
end


-- 事件：收到列表数据
function DealerQueueView:reloadDealerList()
    local model = self.m_pNodeGameView
    local list = model:getDealerQueue()

    self.zhuangQList:removeAllItems()  
    self.selfPosTip:setVisible(false)
    for i, player in pairs(list) do
        local itemObj = WaitQueueItem:new()
        itemObj:init(i, player, self.itemModelZhuangQItem,self.m_pNodeGameView)
        self.zhuangQList:pushBackCustomItem(itemObj.node)
    
        -- 自己在多少位
        local isSelf = player.rid == GlobalUserItem.tabAccountInfo.userid
        if not self.selfPosTip:isVisible() and isSelf then
            self.selfPosTip:setVisible(true)
            self.selfPosNum:setString(i)
        end
    end
end


------------------------------------------------------------------------------------------------------------

function WaitQueueItem:ctor()

end

function WaitQueueItem:init(index, player, itemModel,pNodeGameView)

    self.m_pNodeGameView = pNodeGameView
    player.rolename = player[2]
    player.sex = player[4] or 0         --暂时没有性别
    player.coin = player[5] or 0        --玩家金币

    --剩余局数
    if player.left_banker_num == nil then
        player.left_banker_num = 0
    end

    self.node = itemModel:clone()
    --UIHelper.parseCSDNode(self, self.node)
    Define:getNodeList(self, self.node)

    --CommonHelper:loadHeadMiddleImg(self.avatar, player.sex or 0, player.logo or 1) -- 头像

    -- 头像
    self.avatar:setScale(0.6)
    self.avatar = createStencilAvatar(self.avatar, 'common/tx/tx_mask.png', 'common/tx/tx_2.png', cc.size(2, 2))
    loadHeadMiddleImg(self.avatar, player.sex or 0, player.logo or 1) -- 头像
    setVIPIcon(self.node, player.vip or 0)
    -- self.avatar:getParent():setAlphaThreshold((player.vip or 0) > 0 and 0 or 0.6) -- 切换剪裁区域

    --CommonHelper:setVIPIcon(self.avatar, player.vip or 0)
    Define:loadName(self.name, player.rolename, 6) -- 名字
    if index == 1 then
        dump(player,"WaitQueueItem:init")
        if player.left_banker_num > 0 then
            self.zhuang:setVisible(true)
            self.zhuangjushu:setString(player.left_banker_num)
        elseif player.left_banker_num == 0 then
            self.jijiang:setVisible(true)
        end

        if self.m_pNodeGameView:isCurDealer(player.rid) == true then
            -- 庄图标
            self.dealerSign:setVisible(true)
        else
            self.dealerSign:setVisible(false)
            self.dengdai:setVisible(true)
            self.zhuang:setVisible(false)
        end
    else
        self.dengdai:setVisible(true)
        self.dealerSign:setVisible(false)
    end
    -- 点头像弹信息面板
    local rid = player.rid
    local infoTable = {}
    infoTable.rid = rid
    infoTable.x = self.avatar:getPositionX()
    infoTable.y = self.avatar:getPositionY()
    self.avatar:addClickEventListener(handler(self, function(self)
        dispatchEvent('event_openPlayerInfo', infoTable)
    end))    

    -- 自己在多少位
    -- local isSelf = player.rid == cc.loaded_packages.CommonModel:getRoleID()
    -- self.selfPosTip:setVisible(isSelf)
    -- self.selfPosNum:setString(index)
    -- self.highlightBg:setVisible(isSelf)

    -- 钱钱
    self.coinIcon:setVisible(not isSelf)
    -----self.coin:setString(CommonHelper.getDealNumStr(player.coin or 0, false))
    self.coin:setString(player.coin or 0)
end

return DealerQueueView
