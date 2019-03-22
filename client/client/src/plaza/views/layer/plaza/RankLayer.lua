--region RankLayer.lua
--Date 2017.04.26.
--Auther JackyXu.
--Desc: 银行主页面

local RANK_COST = 1
local RANK_TIME = 2
local QUERY_INTERVAL = 15*60
local HeadSprite = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
--local UsrMsgManager     = require("common.manager.UsrMsgManager")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local RankLayer = class("RankLayer", FixLayer)
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame") 
function RankLayer:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_pTableView = nil
    self.m_pNodeButton = {}
    self.m_pButton     = {}
    self.m_vecRankData = {}
    self.m_rankPlayerMessageData = {}
    self.m_nRankIndex  = RANK_COST      --区分金币排行和时间排行

    self:init()

    local  onUseRankCallBack = function(result,message)
       self:onUserRankCallBack(result,message)
    end

    --大厅网络处理
    self._plazaFrame = LogonFrame:getInstance()
    self._plazaFrame:setCallBackDelegate(self, onUseRankCallBack)
end

function RankLayer:onEnter()
    self.super:onEnter()

    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)
    --self:setCallBackInOpen(handler(self, self.sendDefaultRequest))
    self:sendDefaultRequest()
    self:showWithStyle()
end

function RankLayer:onExit()
    self:clean()

--    Veil:getInstance():HideVeil(VEIL_WAIT)
    self.super:onExit()
end

function RankLayer:init()
    self:initCSB()
    --self:initNode()---------------
    self:initBtnEvent()
    self:initEvent()
end

function RankLayer:clean()
    self:cleanEvent()
end

function RankLayer:initCSB()
    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    --csb
    self.m_pathUI = cc.CSLoader:createNode("dt/RankPage.csb")
--    self.m_pathUI:setPositionY((display.height) / 2)
    self.m_pathUI:addTo(self.m_rootUI)
    self.m_pNodeMask = self.m_pathUI:getChildByName("mask")
    self.m_pNodeMask:setPosition(self.m_pNodeMask:getPositionX()+20,self.m_pNodeMask:getPositionY()+20)
    --offset
    self.m_pNodeRoot = self.m_pathUI:getChildByName("center")
    self.m_pNodeRoot:setPositionX((display.width) / 2)
    self.m_pNodeRoot:setPositionY((display.height) / 2)
--    local viewColor = cc.LayerColor:create(cc.c4b(0,0,0,175))
--    viewColor:setPosition(cc.p(0,0))
--    self:addChild(viewColor,-1)
--    --node
    self.m_pImageBg = self.m_pNodeRoot:getChildByName("image_Bg")    
    self.m_pPanel = self.m_pImageBg:getChildByName("Panel_1")
    self.m_pPanelList = self.m_pPanel:getChildByName("panel_panelList")

    self.m_pNodeRoot:getChildByName("Panel_2"):setVisible(false)
--    --btn
    self.m_pBtnClose = self.m_pImageBg:getChildByName("button_close")
    self.m_pTxtTips = self.m_pImageBg:getChildByName("text_rankTips")
    self.m_pTxtTips:setString("*玩家纯盈利排行榜，每日0点重置")
    self.m_pTxtTips:setVisible(true)
end

function RankLayer:initNode()
    --set var
    self.m_pNodeButton[RANK_COST] = {}
    self.m_pNodeButton[RANK_COST].pressed = self.m_pSelectCost
    self.m_pNodeButton[RANK_COST].normal = self.m_pNormalCost
    self.m_pNodeButton[RANK_COST].button = self.m_pBtnCost
    self.m_pNodeButton[RANK_TIME] = {}
    self.m_pNodeButton[RANK_TIME].pressed = self.m_pSelectTime
    self.m_pNodeButton[RANK_TIME].normal = self.m_pNormalTime
    self.m_pNodeButton[RANK_TIME].button = self.m_pBtnTime

    --set button
    self.m_pNodeButton[RANK_COST].pressed:setVisible(true)
    self.m_pNodeButton[RANK_COST].normal:setVisible(false)
    self.m_pNodeButton[RANK_COST].button:setEnabled(false)
    self.m_pNodeButton[RANK_TIME].pressed:setVisible(false)
    self.m_pNodeButton[RANK_TIME].normal:setVisible(true)
    self.m_pNodeButton[RANK_TIME].button:setEnabled(true)

    --set data
--    self.m_vecRankData = --初始数据
--    {
--        [RANK_COST] = 
--        {
--            dwID         = -1,
--            dwUserID     = PlayerInfo.getInstance():getUserID(),
--            szNickName   = PlayerInfo.getInstance():getNameNick(),
--            dwFaceID     = PlayerInfo.getInstance():getFaceID(),
--            dwGameID     = PlayerInfo.getInstance():getGameID(),
--            dwVipLev     = -1,
--            dwRankValue  = UsrMsgManager.getInstance():getRankingUser(RANK_COST),
--            dwPlatformID = -1,
--        },
--        [RANK_TIME] = 
--        {
--            dwID         = -1,
--            dwUserID     = PlayerInfo.getInstance():getUserID(),
--            szNickName   = PlayerInfo.getInstance():getNameNick(),
--            dwFaceID     = PlayerInfo.getInstance():getFaceID(),
--            dwGameID     = PlayerInfo.getInstance():getGameID(),
--            dwVipLev     = -1,
--            dwRankValue  = UsrMsgManager.getInstance():getRankingUser(RANK_TIME),
--            dwPlatformID = -1,
--        },
--    }


        self.m_vecRankData = --初始数据
    {
        [RANK_COST] = 
        {
            dwID         = -1,
            dwUserID     = GlobalUserItem.tabAccountInfo.username,
            szNickName   = GlobalUserItem.tabAccountInfo.nickname,
            dwFaceID     = GlobalUserItem.tabAccountInfo.avatar_no%11 == 0 and 1 or GlobalUserItem.tabAccountInfo.avatar_no%11,
            dwGameID     = 1011,
            dwVipLev     = -1,
            dwRankValue  = 1,
            dwPlatformID = -1,
        },
        [RANK_TIME] = 
        {
             dwID         = -1,
            dwUserID     = GlobalUserItem.tabAccountInfo.username,
            szNickName   = GlobalUserItem.tabAccountInfo.nickname,
            dwFaceID     = GlobalUserItem.tabAccountInfo.avatar_no%11 == 0 and 1 or GlobalUserItem.tabAccountInfo.avatar_no%11,
            dwGameID     = 1011,
            dwVipLev     = -1,
            dwRankValue  = 1,
            dwPlatformID = -1,
        },
    }

    self:setRankNode(self.m_pRankSelf, self.m_vecRankData[RANK_COST], RANK_COST, true)
    self.m_pRankSelf.image_top:setVisible(false)
--    self.m_pRankSelf.image_icon:setVisible(false)
    self.m_pRankSelf.label_value:setString("")

    --set tips
    self:onUpdateRankText(RANK_COST)
end

function RankLayer:initBtnEvent()
    --set tag
--    self.m_pBtnCost:setTag(RANK_COST)
--    self.m_pBtnTime:setTag(RANK_TIME)

    --set call
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))
--    self.m_pBtnCost:addClickEventListener(handler(self, self.onRankTagClicked))
--    self.m_pBtnTime:addClickEventListener(handler(self, self.onRankTagClicked))
end

function RankLayer:initEvent()
    SLFacade:addCustomEventListener(Hall_Events.MSG_UPDATE_RANKING, handler(self, self.onUpdateMsgRank), self.__cname)
end

function RankLayer:cleanEvent()
    SLFacade:removeCustomEventListener(Hall_Events.MSG_UPDATE_RANKING, self.__cname)
end

function RankLayer:cellSizeForTable(table, idx)
    return 889, 65
end

function RankLayer:tableCellAtIndex(table, idx)
    local cell = table:cellAtIndex(idx)
    if not cell then
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end

    self:initTableViewCell(cell, idx)   ------------------------init排行榜的cell

    return cell
end

function RankLayer:numberOfCellsInTableView(table_)
    --return G_CONSTANTS.MAX_RANKINGLIST
--    local data = UsrMsgManager.getInstance():getRankingData(self.m_nRankIndex)
    return table.nums(GlobalUserItem.tabAccountInfo.rankData)--self.m_rankPlayerMessageData)--table.nums(data)
end

function RankLayer:tableCellTouched(table, cell)
end

function RankLayer:initTableViewCell(cell, nIdx)
--    local data = UsrMsgManager.getInstance():getRankingData(self.m_nRankIndex)      --通过cell的ID获取数据
    local data = self:getRankingData(self.m_nRankIndex)
    local node = self:getRankNode()
    self:setRankNode(node, data[nIdx + 1], self.m_nRankIndex, false,nIdx+1)
    cell:addChild(node)
end

function RankLayer:getRankingData(args)
    return GlobalUserItem.tabAccountInfo.rankData--self.m_rankPlayerMessageData
end
function RankLayer:showRankTableView()-------------------更新排行榜的tableview
    if not self.m_pTableView then
        self.m_nTableHeight = self.m_pPanelList:getContentSize().height
        self.m_pTableView = cc.TableView:create(cc.size(self.m_pPanelList:getContentSize().width,self.m_pPanelList:getContentSize().height+70))
--        self.m_pTableView:setIgnoreAnchorPointForPosition(false)
        self.m_pTableView:setAnchorPoint(cc.p(0,0))
        self.m_pTableView:setPosition(cc.p(0, -70))
        self.m_pTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.m_pTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        self.m_pTableView:setDelegate()
        --self.m_pTableView:registerScriptHandler(handler(self,self.scrollViewDidScroll), CCTableView.kTableViewScroll)
        self.m_pTableView:registerScriptHandler(handler(self,self.cellSizeForTable), CCTableView.kTableCellSizeForIndex)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellAtIndex), CCTableView.kTableCellSizeAtIndex) ------------刷新创建cell
        self.m_pTableView:registerScriptHandler(handler(self,self.numberOfCellsInTableView), CCTableView.kNumberOfCellsInTableView)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellTouched), CCTableView.kTableCellTouched)
        self.m_pPanelList:addChild(self.m_pTableView)
    end
    self.m_pTableView:reloadData()
end


-- 关闭
function RankLayer:onReturnClicked()
    ExternalFun.playClickEffect()
    self:onMoveExitView()
end

function RankLayer:onRankTagClicked(sender)
    ExternalFun.playClickEffect()
    local tag = sender:getTag()
    self.m_nRankIndex = tag

    self:sendRankingRequest(tag)   -- 请求排行数据
    self:onUpdateButtonStatus(tag) -- 更新按钮显示
    self:onUpdateRankText(tag)     -- 更新提示文字
end

function RankLayer:onUpdateMsgRank()-----------------------------收到MSG_UPDATE_RANKING事件 刷新排行榜
--    Veil:getInstance():HideVeil(VEIL_WAIT)

    local tag = self.m_nRankIndex
    self.m_pPanelList:setVisible(true)
--    self.m_pNodeSelf:setVisible(true)
--    self:onUpdateMyRank(tag)       --更新我的排行
    self:showRankTableView()       --更新排行显示
end

function RankLayer:onUpdateButtonStatus(tag)
    for i = RANK_COST, RANK_TIME do
        if i == tag then
            self.m_pNodeButton[i].normal:setVisible(false)
            self.m_pNodeButton[i].pressed:setVisible(true)
            self.m_pNodeButton[i].button:setEnabled(false)
        else
            self.m_pNodeButton[i].normal:setVisible(true)
            self.m_pNodeButton[i].pressed:setVisible(false)
            self.m_pNodeButton[i].button:setEnabled(true)
        end
    end
end

function RankLayer:onUpdateMyRank(tag)
    self.m_vecRankData[tag].dwRankValue = UsrMsgManager.getInstance():getRankingUser(tag)
    self.m_vecRankData[tag].dwID = UsrMsgManager.getInstance():getRankingByUserId(tag)

    --fix 确保今日赢分小于0时为0显示
    if tag == RANK_COST and self.m_vecRankData[tag].dwRankValue < 0 then
        self.m_vecRankData[tag].dwRankValue  = 0
    end
    self:setRankNode(self.m_pRankSelf, self.m_vecRankData[tag], tag, true)
end

function RankLayer:onUpdateRankText(tag)
    local string_rank = {
        [RANK_COST] = "提示：巅峰对决，实力PK！今日你上榜了吗？",
        [RANK_TIME] = "提示：笑到最后才是笑，没到最后谁能肯定自己是真正的赢家！",
    }
    local string_use = string_rank[tag]
    self.m_pTextTips:setString(string_use)
end

function RankLayer:getRankNode(tag)

    local rankNode = ccui.Layout:create()
    rankNode:setContentSize(cc.size(889, 65))

    --item
    local item = cc.CSLoader:createNode("dt/RankViewItem.csb")
    item:addTo(rankNode)

    --node
    local node = item:getChildByName("Panel_1")
    local image_bg = node:getChildByName("image_darkImg")
--    local image_head = node:getChildByName("image_head")
--    local image_no_rank = node:getChildByName("rank_no_rank")
    local image_num = node:getChildByName("image_numBgImg")
    local label_rank = node:getChildByName("image_numBgImg"):getChildByName("bmfont_rankLabel")
    local image_top = node:getChildByName("image_rankSpr")
    local label_name = node:getChildByName("text_name")
--    local image_icon = node:getChildByName("image_icon")
    local label_value = node:getChildByName("image_imgGold"):getChildByName("text_goldBmf")
    label_value:setScale(0.8)
    --init
    image_num:setVisible(false)
    image_top:setVisible(false)

    image_top:ignoreContentAdaptWithSize(true)
--    image_head:ignoreContentAdaptWithSize(true)
--    image_icon:ignoreContentAdaptWithSize(true)

    label_rank:setString("")
    label_name:setString("")
    label_value:setString("")

    rankNode.item_node = item
    rankNode.item_bg = image_bg        --背景图片
    rankNode.image_top = image_top     --皇冠图片
--    rankNode.image_out = image_no_rank --没上榜图片
    rankNode.image_num = image_num     --排名背景图片
    rankNode.label_rank = label_rank   --排名号字体
--    rankNode.image_head = image_head   --头像
    rankNode.label_name = label_name   --名字 
--    rankNode.image_icon = image_icon   --类型:时长/赢分
    rankNode.label_value = label_value --数值

    return rankNode
end

function RankLayer:setRankNode(rankNode, data, tag, bSelf,nIdx)  --cell的csb上各node，该行显示的玩家数据，区分金币排行和时间排行，是否是自己
    
    if nIdx ~= nil then
        data.dwID = nIdx
    end
    --排名(标志图/数值背景图/数值)
    if data.dwID == 1 then
        rankNode.image_top:loadTexture("dt/image/rank/tjylc_phb_hg1.png", ccui.TextureResType.localType)
        rankNode.image_top:setVisible(true)
        rankNode.label_rank:setString("")
        rankNode.image_num:setVisible(false)
--        rankNode.image_out:setVisible(false)
    elseif data.dwID == 2 then
        rankNode.image_top:loadTexture("dt/image/rank/tjylc_phb_hg2.png", ccui.TextureResType.localType)
        rankNode.image_top:setVisible(true)
        rankNode.label_rank:setString("")
        rankNode.image_num:setVisible(false)
--        rankNode.image_out:setVisible(false)
    elseif data.dwID == 3 then
        rankNode.image_top:loadTexture("dt/image/rank/tjylc_phb_hg3.png", ccui.TextureResType.localType)
        rankNode.image_top:setVisible(true)
        rankNode.label_rank:setString("")
        rankNode.image_num:setVisible(false)
--        rankNode.image_out:setVisible(false)
    elseif 3 < data.dwID and data.dwID <= 50 then
        rankNode.image_top:setVisible(false)
        rankNode.label_rank:setString(data.dwID)
        rankNode.image_num:setVisible(true)
--        rankNode.image_out:setVisible(false)
    elseif bSelf then
        rankNode.image_top:setVisible(false)
        rankNode.label_rank:setString("")
--        rankNode.image_num:loadTexture("dt/image/rank/tjylc_phb_hg3.png", ccui.TextureResType.localType)
--        rankNode.image_out:setVisible(true)
    end

    --背景
--    if bSelf then
--        rankNode.item_bg:loadTexture("hall/plist/rank/bg-line2.png", ccui.TextureResType.plistType)
--    end




    --头像
    --   local path = string.format("public/im_face/gui-icon-head-%d.png",10)
    --   rankNode.image_head:loadTexture("hall/plist/rank/bg-line2.png", ccui.TextureResType.plistType)
--    local headtable = {}
--    headtable["avatar_no"] = data.avatar_no

--    local head = HeadSprite:createNormal(headtable, 124) --124 是大小
--    if nil ~= head then
--         head:setPosition(ccp(rankNode.image_head:getPositionX()-75,rankNode.image_head:getPositionY()+15))
--         rankNode.image_head:addChild(head)
--    end

    --名字
    rankNode.label_name:setString(data.nickname)

    --图标
--    if tag == RANK_COST then
--        rankNode.image_icon:loadTexture("hall/plist/rank/icon-gold.png", ccui.TextureResType.plistType)
--    elseif tag == RANK_TIME then
--        rankNode.image_icon:loadTexture("hall/plist/rank/icon-time.png", ccui.TextureResType.plistType)
--    end
--    rankNode.image_icon:setVisible(true)

    --数值
    if data.dwRankValue == "" then
        rankNode.label_value:setString("")
    elseif tag == RANK_COST then
        local strData = data.bag_money--string.format("%0.2f", data.bag_money / 100)
        rankNode.label_value:setString(strData)
    elseif tag == RANK_TIME then
        local clock  = data.dwRankValue / 3600
        local minute = data.dwRankValue % 3600 / 60
        local second = data.dwRankValue % 60
        local strData = string.format("%02d:%02d:%02d", clock, minute, second)
        rankNode.label_value:setString(strData)
    end
end

--获取排行数据
function RankLayer:sendDefaultRequest()
    self:sendRankingRequest()
end

--获取排行数据
function RankLayer:sendRankingRequest(_tag)
    local tag = _tag or RANK_COST

    --fix,十五分钟请求一次
    if self:needNewRequest(tag) then
        --self.m_pNodeRank:setVisible(false)
        --self.m_pNodeSelf:setVisible(false)
        --Veil:getInstance():ShowVeil(VEIL_WAIT)

--        if tag == RANK_COST then 
--            CMsgHall:proccessGetRankWinScore()
--        elseif tag == RANK_TIME then 
--            CMsgHall:proccessGetRankOnline()
--        end
        self:requestRankmsg()
    else

    --    self:onUpdateMyRank(tag) -- 更新我的排行
        self:showRankTableView() -- 更新排行显示
    end

    
end

--超过十五分钟需要请求排行版
function RankLayer:needNewRequest(_tag)
    local curTime = os.time()  
    local lastQueryTime = GlobalUserItem.tabAccountInfo.lastGetRankMessage or 0
    if curTime - lastQueryTime > QUERY_INTERVAL then
        return true
    else
        return false
    end
end
 --请求排行榜数据
function RankLayer:requestRankmsg(_tag)
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "get_userranks"
    msgta["body"] = {}
    LogonFrame:sendGameData(msgta)
    dump(msgta)
end
 --排行榜请求回调
function RankLayer:onUserRankCallBack(result,message)
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
    if type(message) == "table" then
        if message.tag == "get_userranks" then
            if message.result == "ok" then
                self:saveLastGetRankMessageTime()
--                self.m_rankPlayerMessageData
                GlobalUserItem.tabAccountInfo.rankData = message.body
                
                self:onUpdateMsgRank()
            end 
        end
    end
end

function RankLayer:saveLastGetRankMessageTime( )
     GlobalUserItem.tabAccountInfo.lastGetRankMessage = os.time()

end


return RankLayer
