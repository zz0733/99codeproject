--region LhdzRankLayer.lua
--Date
--Auther Ace
--Des [[龙虎斗玩家信息界面]]
--此文件由[BabeLua]插件自动生成

local LhdzRankLayer = class("LhdzRankLayer", cc.Layer)
--local AudioManager = cc.exports.AudioManager

--local CMsgLhdz = require("game.yule.lhdz.src.game.longhudazhan.proxy.CMsgLhdz")
local LhdzDataMgr = require("game.yule.lhdz.src.game.longhudazhan.manager.LhdzDataMgr")
local Lhdz_Res = require("game.yule.lhdz.src.game.longhudazhan.scene.Lhdz_Res")

LhdzRankLayer.instance_ = nil
function LhdzRankLayer.create()
    LhdzRankLayer.instance_ = LhdzRankLayer.new():init()
    return LhdzRankLayer.instance_
end

function LhdzRankLayer:ctor()
    self:enableNodeEvents()

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
end

function LhdzRankLayer:init()
    self:initVar()
    self:initCSB()
    return self
end

function LhdzRankLayer:onEnter()
end

function LhdzRankLayer:onExit()
end

function LhdzRankLayer:initVar()
    self.m_pLayerUserInfo = nil
    self.m_pBtnClose     = nil
    self.m_pNodeTable = nil
    self.m_pTableView = nil
    self.m_nContentHeight = 0
    self.m_nUserSize = 0
    self.m_bShowAllUser = false
end

function LhdzRankLayer:initCSB()
    local _pUiLayer = cc.CSLoader:createNode(Lhdz_Res.CSB_OF_RANK)
    _pUiLayer:setAnchorPoint(cc.p(0.5,0.5))
    _pUiLayer:setPosition(cc.p(667, 375 + (display.size.height - 750) / 2))
    self.m_rootUI:addChild(_pUiLayer, Z_ORDER_TOP)

    self.m_pLayerRoot = _pUiLayer:getChildByName("Panel_root")
    local diffX = 145 - (1624-display.size.width)/2 
    self.m_pLayerRoot:setPositionX(diffX)
    
    self.m_pLayerUserInfo = self.m_pLayerRoot:getChildByName("Panel_userInfo")
    self.m_pNodeTable = self.m_pLayerUserInfo:getChildByName("Panel_tableView")
    self.m_pBtnClose = self.m_pLayerUserInfo:getChildByName("Button_close")
    self.m_pBtnClose:addClickEventListener(function()
--        AudioManager.getInstance():playSound(Lhdz_Res.vecSound.SOUND_OF_CLOSE)
        self:removeFromParent()
    end)
    -- 设置弹窗动画节点
    --self:setTargetActNode(self.m_pLayerUserInfo)
    self:showPop()
end

function LhdzRankLayer:updateTableView()
    if not self.m_pTableView then
        local tableSize = self.m_pNodeTable:getContentSize()
        self.m_pTableView = cc.TableView:create(tableSize)
--        self.m_pTableView:setIgnoreAnchorPointForPosition(false)
        self.m_pTableView:setAnchorPoint(cc.p(0,0))
        self.m_pTableView:setPosition(cc.p(0,0))
        self.m_pTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        self.m_pTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.m_pTableView:setTouchEnabled(true)
        self.m_pTableView:setDelegate()
        self.m_pNodeTable:addChild(self.m_pTableView)

        self.m_pTableView:registerScriptHandler(handler(self,self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellSizeForIndex), cc.TABLECELL_SIZE_FOR_INDEX)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
        self.m_pTableView:registerScriptHandler(handler(self,self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellTouched), cc.TABLECELL_TOUCHED)
    end
    self.m_nUserSize = LhdzDataMgr.getInstance():getRankUserSize()
    self.m_pTableView:reloadData()
end

function LhdzRankLayer:initTableViewCell(cell, index)
    local tableItem = cell:getChildByName("lhdzUserInfoItem")
    if not tableItem then
        tableItem = cc.CSLoader:createNode(Lhdz_Res.CSB_OF_RANK_ITEM)
        tableItem:setName("lhdzUserInfoItem")
        tableItem:setPosition(cc.p(self.m_pNodeTable:getContentSize().width/2, 55))
        cell:addChild(tableItem)
    end
    local pSpItemBg = tableItem:getChildByName("Sprite_userItem_bg")
    local pSpbanker = pSpItemBg:getChildByName("Sprite_banker")
    -- 神算子
    local pSpOperator = pSpItemBg:getChildByName("Sprite_operator")
    -- 富豪1-6
    local pNodeRegal = pSpItemBg:getChildByName("Node_regal")
    local pLbRegalNumber = pNodeRegal:getChildByName("BitmapFontLabel_regal_number")
    local pLbRegalSp = pNodeRegal:getChildByName("Sprite_regal")
    -- 头像
    local pNodeHead = pSpItemBg:getChildByName("Node_head")
    local pSpHead = pNodeHead:getChildByName("Sprite_head")
    -- 昵称
    local pLbName = pSpItemBg:getChildByName("Text_name")
    -- 金币
    local pLbGold = pSpItemBg:getChildByName("BitmapFontLabel_gold")
    -- 信息
    local pNodeInfo = pSpItemBg:getChildByName("Node_info")
    local pLbBetCount = pNodeInfo:getChildByName("BitmapFontLabel_betCount")
    local pLbWinCount = pNodeInfo:getChildByName("BitmapFontLabel_winCount")
    local pLbBetInvalid = pNodeInfo:getChildByName("Text_bet_invalid")
    local pLbWinInvalid = pNodeInfo:getChildByName("Text_win_invalid")
    local selfbg = pSpItemBg:getChildByName("userinfobg_self")
    local fuhaobg = pNodeRegal:getChildByName("Sprite_regal_bg")

    -- 是否是系统坐庄
    -- local bSystemBanker = LhdzDataMgr.getInstance():getBankerId() == G_CONSTANTS.INVALID_CHAIR
    -- if (not bSystemBanker) and index == 0 then
    --     pSpbanker:setVisible(true)
    --     pLbBetInvalid:setVisible(true)
    --     pLbWinInvalid:setVisible(true)
    --     pLbBetCount:setVisible(false)
    --     pLbWinCount:setVisible(false)
    --     pSpOperator:setVisible(false)
    --     pNodeRegal:setVisible(false)
    --     local wFaceID = LhdzDataMgr.getInstance():getBankerFaceId()
    --     pSpHead:setTexture(string.format(Lhdz_Res.PNG_OF_HEAD, wFaceID % G_CONSTANTS.FACE_NUM + 1))
    --     pLbName:setString(LhdzDataMgr.getInstance():getBankerName())
    --     pLbGold:setString(LuaUtils.getFormatGoldAndNumber(LhdzDataMgr.getInstance():getBankerScore()))
    --     selfbg:setVisible(LhdzDataMgr.getInstance():getBankerId() == PlayerInfo.getInstance():getUserID())
    -- else
        local rankIndex = index+1--bSystemBanker and index+1 or index
        local rankUser = LhdzDataMgr.getInstance():getRankUserByIndex()
        dump(rankUser)
        pSpbanker:setVisible(false)
        pLbBetInvalid:setVisible(false)
        pLbWinInvalid:setVisible(false)
        pLbBetCount:setVisible(true)
        pLbWinCount:setVisible(true)

        pSpOperator:setVisible((rankIndex-1)==0)
        pNodeRegal:setVisible((rankIndex-1) > 0)
        pLbRegalNumber:setString(string.format("N%d", rankIndex-1))
        pSpHead:setSpriteFrame(string.format(Lhdz_Res.PNG_OF_HEAD, rankUser[rankIndex][1] % G_CONSTANTS.FACE_NUM + 1))
        pLbName:setString(rankUser[rankIndex][2])
        pLbGold:setString(LuaUtils.getFormatGoldAndNumber(rankUser[rankIndex][6]))
        pLbBetCount:setString(LuaUtils.getFormatGoldAndNumber(0))
        pLbWinCount:setString(0)

        if rankIndex == 2 then
            pLbRegalNumber:setVisible(false)
            pLbRegalSp:setVisible(true)
            pLbRegalSp:setSpriteFrame("game/longhudazhan/gui-longhudazhan-main/gui-lhdz-icon-regal-1.png")
            fuhaobg:setVisible(false)
            --pLbRegalSp:setPosition(cc.p(10, 0))
        elseif rankIndex>2 and rankIndex<7 then
            pLbRegalNumber:setVisible(false)
            pLbRegalSp:setVisible(true)
            pLbRegalSp:setSpriteFrame("game/longhudazhan/gui-longhudazhan-main/fuhaotag.png")
            fuhaobg:setVisible(true)
            --pLbRegalSp:setPosition(cc.p(-35, -4))
        elseif rankIndex>6 then
            pLbRegalNumber:setVisible(true)
            pLbRegalSp:setVisible(false)
            fuhaobg:setVisible(true)
        end
        
        selfbg:setVisible(rankUser.dwUserID == PlayerInfo.getInstance():getUserID())
    --end
end

function LhdzRankLayer:scrollViewDidScroll(table,cell)
    if table:getContentOffset().y > 10 then
        if not self.m_bShowAllUser and self.m_nUserSize ~= 0 then
            self.m_bShowAllUser = true
            FloatMessage.getInstance():pushMessage("LHDZ_5");
        end
    end
end

function LhdzRankLayer:tableCellTouched(table, cell)

end

function LhdzRankLayer:tableCellSizeForIndex(table, index)
    return self.m_pNodeTable:getContentSize().width, 110
end

function LhdzRankLayer:numberOfCellsInTableView(table)
    local bSystemBanker = LhdzDataMgr.getInstance():getBankerId() == G_CONSTANTS.INVALID_CHAIR
    --return bSystemBanker and self.m_nUserSize or self.m_nUserSize + 1
    return self.m_nUserSize
end

function LhdzRankLayer:tableCellAtIndex(table, index)
    local cell = table:dequeueCell()
    if not cell then
        cell = cc.TableViewCell:new()
    end
    self:initTableViewCell(cell, index);
    return cell
end

function LhdzRankLayer:showPop()
    self.m_pLayerUserInfo:setScale(0.0)
    local show = cc.Show:create()
    local scaleTo = cc.ScaleTo:create(0.4, 1.0)
    local ease = cc.EaseBackOut:create(scaleTo)
    local seq = cc.Sequence:create(show,ease)
    self.m_pLayerUserInfo:runAction(seq)
end


return LhdzRankLayer

--endregion
