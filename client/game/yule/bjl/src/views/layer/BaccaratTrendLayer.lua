-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成	

local BaccaratTrendLayer = class("BaccaratTrendLayer", cc.Layer)
local BaccaratDataMgr = appdf.req("game.yule.bjl.src.game.baccarat.manager.BaccaratDataMgr")
local BaccaratRes = appdf.req("game.yule.bjl.src.game.baccarat.scene.BaccaratRes")
local BaccaratEvent =  appdf.req("game.yule.bjl.src.game.baccarat.scene.BaccaratEvent")
 
BaccaratTrendLayer.TAG_OF_DALU = 1
BaccaratTrendLayer.TAG_OF_ZHULU = 2
BaccaratTrendLayer.TAG_OF_DAYANLU = 3
BaccaratTrendLayer.TAG_OF_XIAOLU = 4
BaccaratTrendLayer.TAG_OF_YUEYOULU = 5

BaccaratTrendLayer.instance_ = nil

function BaccaratTrendLayer.create()
	BaccaratTrendLayer.instance_ = BaccaratTrendLayer.new()
	return BaccaratTrendLayer.instance_
end  

function BaccaratTrendLayer:ctor()
    self:enableNodeEvents()
    self:init()
end

function BaccaratTrendLayer:onEnter()
--    local openlayer = function (layer, shadow, root)
        if self.m_trendLayer then
            local scale1 = 0.75
            local scale2 = 1.0
            local time = 0.3
            local scaleto = cc.EaseBackOut:create(cc.ScaleTo:create(time, scale2))
            self.m_trendLayer:setScale(scale1)
            self.m_trendLayer:runAction(scaleto)
        end

        if self.m_pShadow then
            local opacity1 = 100
            local opacity2 = 255
            local time = 0.3
            local fadeto = cc.FadeTo:create(time, opacity2)
            self.m_pShadow:setOpacity(opacity1)
            self.m_pShadow:runAction(fadeto)
        end
--    end
--    onOpenLayer(self.m_trendLayer, self.m_pShadow, self)
end

function BaccaratTrendLayer:onExit()
    self:unRegistEvent()
end

function BaccaratTrendLayer:init()
    self:initVar()
    self:initUI()
    self:refreshLabelView()
    self:refreshLuZiView()
    self:initEvent()
end

function BaccaratTrendLayer:initVar()
    self.m_daluMaxCol = 0
    self.m_dayanluMaxCol = 0
    self.m_xiaoluMaxCol = 0
    self.m_yueyouluMaxCol = 0
    self.m_zhuluMaxCol = 0
    self.m_isPlaySound = false
end

function BaccaratTrendLayer:initUI()
    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
    
    self.m_pathUI = cc.CSLoader:createNode(BaccaratRes.CSB_GAME_TREND)
    local diffY   = (display.size.height - 750) / 2
    self.m_pathUI:setPositionY(diffY)
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pathUI:setPositionX(diffX)
    self.m_pathUI:addTo(self.m_rootUI)

    self.m_pShadow = self.m_pathUI:getChildByName("Panel_1")

    self.m_trendLayer = self.m_pathUI:getChildByName("TrendLayer")
    
    local _Sp_bg = self.m_trendLayer:getChildByName("Sp_bg")

    --labels
    local _Image_top = _Sp_bg:getChildByName("Image_top")
    self.m_pLbNums = {}
    self.m_pLbNums[BaccaratDataMgr.ePlace_Xian]      = _Image_top:getChildByName("LbXianNum")
    self.m_pLbNums[BaccaratDataMgr.ePlace_Zhuang]    = _Image_top:getChildByName("LbZhuangNum")
    self.m_pLbNums[BaccaratDataMgr.ePlace_Ping]      = _Image_top:getChildByName("LbPingNum")
    self.m_pLbNums[BaccaratDataMgr.ePlace_XianDui]   = _Image_top:getChildByName("LbXianDuiNum")
    self.m_pLbNums[BaccaratDataMgr.ePlace_ZhuangDui] = _Image_top:getChildByName("LbZhuangDuiNum")

    --tablenods
    local _Image_dalu    = _Sp_bg:getChildByName("Image_dalu")
    self.m_pNodeDaLu     = _Image_dalu:getChildByName("Node_dalu")

    local _Image_otherlu = _Sp_bg:getChildByName("Image_otherlu")
    self.m_pNodeDaYanLu  = _Image_otherlu:getChildByName("Node_dayanlu")
    self.m_pNodeXiaoLu   = _Image_otherlu:getChildByName("Node_xiaolu")
    self.m_pNodeYueYouLu = _Image_otherlu:getChildByName("Node_yueyoulu")

    local _Image_zhulu   = _Sp_bg:getChildByName("Image_zhulu")
    self.m_pNodeZhuLu    =  _Image_zhulu:getChildByName("Node_zhulu")

    --btns
    self.m_pBtnClose  = _Sp_bg:getChildByName("Btn_close")
    self.m_pBtnClose2 = self.m_trendLayer:getChildByName("Button_0")

    self:initDaLuView()
    self:initDaYanLuView()
    self:initXiaoLuView()
    self:initYueYouLuView()
    self:initZhuLuView()
end

function BaccaratTrendLayer:initEvent()
    self.m_pBtnClose2:addClickEventListener(handler(self,self.onReturnClicked))
    self.m_pBtnClose:addClickEventListener(handler(self,self.onReturnClicked))

    SLFacade:addCustomEventListener(BaccaratEvent.MSG_GAME_BACCARAT_UPDATERECORD, handler(self, self.onMsgUpdateHistory), self.__cname)
end

function BaccaratTrendLayer:unRegistEvent()
    SLFacade:removeCustomEventListener(BaccaratEvent.MSG_GAME_BACCARAT_UPDATERECORD, self.__cname)
end

function BaccaratTrendLayer:removeEvent()
    SLFacade:removeCustomEventListener(BaccaratEvent.MSG_GAME_BACCARAT_UPDATERECORD, self.__cname)
end

--初始化大路显示 单个cel 背景尺寸32*32,边框各留1,行×列 = 5*26
function BaccaratTrendLayer:initDaLuView()
    local rows = 5
    local cols = 27
    local border = 1
    local bgwidth = 32
    local cellwidth = 2*border + bgwidth
    local cellheight = rows * cellwidth

    local cellSizeForTable = function (table, idx)
        return cellwidth, cellheight
    end

    local numberOfCellsInTableView = function (table)
        return self.m_daluMaxCol > cols and self.m_daluMaxCol or cols
    end

    local tableCellAtIndex = function (table, idx)
        local cell = table:dequeueCell()
        if not cell then
            cell = cc.TableViewCell:new()
        else
            cell:removeAllChildren()
        end

        for i = 0, rows - 1 do
            --背景方块
            local spBg = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_DALUCELL_BG)
                :setAnchorPoint(cc.p(0, 0))
                :setPosition(cc.p(border, cellheight - (i + 1)*cellwidth + border))
                :addTo(cell)

            local record = BaccaratDataMgr.getInstance():getDaLuRecordByPosition(i, idx)
            if record.bExist then
                local posx = bgwidth/2
                local posy = posx

                if record.cbWin == 4 then   --起始开平
                    cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_TABLE_PING)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(posx, posy)
                        :addTo(spBg)
                elseif record.cbWin >= 2 then--平
                    local spName1 = ((record.cbWin-2)==1)
                        and BaccaratRes.IMG_TABLE_ZHUANGWIN
                        or BaccaratRes.IMG_TABLE_XIANWIN

                    cc.Sprite:createWithSpriteFrameName(spName1)
                        --:setScale(0.8)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(posx, posy)
                        :addTo(spBg)

                    local spName2 = ((record.cbWin-2)==1)
                        and BaccaratRes.IMG_TABLE_ZHUANGPING
                        or BaccaratRes.IMG_TABLE_XIANPING

                    cc.Sprite:createWithSpriteFrameName(spName2)
                        :setScale(0.9)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(posx, posy)
                        :addTo(spBg)
                else
                    local spName = (record.cbWin == 1)
                        and BaccaratRes.IMG_TABLE_ZHUANGWIN
                        or BaccaratRes.IMG_TABLE_XIANWIN

                    cc.Sprite:createWithSpriteFrameName(spName)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(posx, posy)
                        --:setScale(0.8)
                        :addTo(spBg)
                end
                if record.bBankerTwoPair then
                    cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_TABLE_ZHUANGDUI)
                        :setScale(0.5)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(posx - 8, posy + 8)
                        :addTo(spBg)
                end
                if record.bPlayerTwoPair then
                    cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_TABLE_XIANDUI)
                        :setScale(0.5)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(posx + 8, posy - 8)
                        :addTo(spBg)
                end
            end
        end

        return cell
    end

    self.m_pDaluView = cc.TableView:create(cc.size(902, 170))
--    self.m_pDaluView:setIgnoreAnchorPointForPosition(false)
    self.m_pDaluView:setAnchorPoint(cc.p(0,0))
    self.m_pDaluView:setPosition(cc.p(0,0))
    self.m_pDaluView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.m_pDaluView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.m_pDaluView:setTouchEnabled(true)
    self.m_pDaluView:setDelegate()
    self.m_pNodeDaLu:addChild(self.m_pDaluView)
    --self.m_daluMaxCol = BaccaratDataMgr.getInstance():getDaluRecordSize()
    self.m_daluMaxCol = BaccaratDataMgr.getInstance():getDaLuColCount()
    self.m_daluMaxCol = self.m_daluMaxCol > cols and self.m_daluMaxCol or cols
    self.m_pDaluView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.m_pDaluView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.m_pDaluView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    self.m_pDaluView:reloadData()

    if self.m_daluMaxCol > cols then
        self.m_pDaluView:setContentOffset(
            cc.p(self.m_pDaluView:getViewSize().width - self.m_pDaluView:getContentSize().width, 0))
    end
end

--初始化大眼仔路显示 单个cel 背景尺寸20*20,边框各留1,行×列 = 3*20
function BaccaratTrendLayer:initDaYanLuView()
    local rows = 3
    local cols = 20
    local border = 1
    local bgwidth = 20
    local cellwidth = 2*border + bgwidth
    local cellheight = rows * cellwidth
    local scale = 20/30

    local cellSizeForTable = function (table, idx)
        return cellwidth, cellheight
    end

    local numberOfCellsInTableView = function (table)
        return self.m_dayanluMaxCol > cols and self.m_dayanluMaxCol or cols
    end

    local tableCellAtIndex = function (table, idx)
        local cell = table:dequeueCell()
        if not cell then
            cell = cc.TableViewCell:new()
        else
            cell:removeAllChildren()
        end

        for i = 0, rows - 1 do
            --背景方块
            local spBg = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_XIAOLUCELL_BG)
                :setAnchorPoint(cc.p(0, 0))
                :setPosition(cc.p(border, cellheight - (i + 1)*cellwidth + border))
                :addTo(cell)

            local record = BaccaratDataMgr.getInstance():getDaYanZaiRecordByPosition(i, idx)
            if record.bExist then
                local strSpName = (record.cbWin == 1)
                    and BaccaratRes.IMG_TABLE_ZHUANGWIN
                    or  BaccaratRes.IMG_TABLE_XIANWIN

                local spIcon = cc.Sprite:createWithSpriteFrameName(strSpName)
                spIcon:setScale(scale)
                spIcon:setPosition(cc.p(bgwidth/2, bgwidth/2))
                spIcon:addTo(spBg)
            end
        end

        return cell
    end

    self.m_pDayanluView = cc.TableView:create(cc.size(440, 66))
--    self.m_pDayanluView:setIgnoreAnchorPointForPosition(false)
    self.m_pDayanluView:setAnchorPoint(cc.p(0,0))
    self.m_pDayanluView:setPosition(cc.p(0,0))
    self.m_pDayanluView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.m_pDayanluView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.m_pDayanluView:setTouchEnabled(true)
    self.m_pDayanluView:setDelegate()
    self.m_pNodeDaYanLu:addChild(self.m_pDayanluView)
    --self.m_dayanluMaxCol = BaccaratDataMgr.getInstance():getDaluRecordSize()
    self.m_dayanluMaxCol = BaccaratDataMgr.getInstance():getDaYanZaiColCount()
    self.m_dayanluMaxCol = self.m_dayanluMaxCol > cols and self.m_dayanluMaxCol or cols
    self.m_pDayanluView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.m_pDayanluView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.m_pDayanluView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    self.m_pDayanluView:reloadData()

    if self.m_dayanluMaxCol > cols then
        self.m_pDayanluView:setContentOffset(
            cc.p(self.m_pDayanluView:getViewSize().width - self.m_pDayanluView:getContentSize().width, 0))
    end
end

--初始化小路显示 单个cel 背景尺寸20*20,边框各留1,行×列 = 3*20
function BaccaratTrendLayer:initXiaoLuView()
    local rows = 3
    local cols = 20
    local border = 1
    local bgwidth = 20
    local cellwidth = 2*border + bgwidth
    local cellheight = rows * cellwidth
    local scale = 20/30

    local cellSizeForTable = function (table, idx)
        return cellwidth, cellheight
    end

    local numberOfCellsInTableView = function (table)
        return self.m_xiaoluMaxCol > cols and self.m_xiaoluMaxCol or cols
    end

    local tableCellAtIndex = function (table, idx)
        local cell = table:dequeueCell()
        if not cell then
            cell = cc.TableViewCell:new()
        else
            cell:removeAllChildren()
        end

        for i = 0, rows - 1 do
            --背景方块
            local spBg = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_XIAOLUCELL_BG)
                :setAnchorPoint(cc.p(0, 0))
                :setPosition(cc.p(border, cellheight - (i + 1)*cellwidth + border))
                :addTo(cell)

            local record = BaccaratDataMgr.getInstance():getXiaoLuRecordByPosition(i, idx)
            if record.bExist then
                local strSpName = (record.cbWin == 1)
                    and BaccaratRes.IMG_TABLE_ZHUANGDUI
                    or  BaccaratRes.IMG_TABLE_XIANDUI

                local spIcon = cc.Sprite:createWithSpriteFrameName(strSpName)
                spIcon:setScale(scale)
                spIcon:setPosition(cc.p(bgwidth/2, bgwidth/2))
                spIcon:addTo(spBg)
            end
        end

        return cell
    end

    self.m_pXiaoLuView = cc.TableView:create(cc.size(440, 66))
--    self.m_pXiaoLuView:setIgnoreAnchorPointForPosition(false)
    self.m_pXiaoLuView:setAnchorPoint(cc.p(0,0))
    self.m_pXiaoLuView:setPosition(cc.p(0,0))
    self.m_pXiaoLuView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.m_pXiaoLuView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.m_pXiaoLuView:setTouchEnabled(true)
    self.m_pXiaoLuView:setDelegate()
    self.m_pNodeXiaoLu:addChild(self.m_pXiaoLuView)
    --self.m_xiaoluMaxCol = BaccaratDataMgr.getInstance():getXiaoLuRecordSize()
    self.m_xiaoluMaxCol = BaccaratDataMgr.getInstance():getXiaoLuColCount()
    self.m_xiaoluMaxCol = self.m_xiaoluMaxCol > cols and self.m_xiaoluMaxCol or cols
    self.m_pXiaoLuView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.m_pXiaoLuView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.m_pXiaoLuView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    self.m_pXiaoLuView:reloadData()

    if self.m_xiaoluMaxCol > cols then
        self.m_pXiaoLuView:setContentOffset(
            cc.p(self.m_pXiaoLuView:getViewSize().width - self.m_pXiaoLuView:getContentSize().width, 0))
    end
end

--初始化曱由路显示 单个cel 背景尺寸20*20,边框各留1,行×列 = 3*20
function BaccaratTrendLayer:initYueYouLuView()
    local rows = 3
    local cols = 20
    local border = 1
    local bgwidth = 20
    local cellwidth = 2*border + bgwidth
    local cellheight = rows * cellwidth
    local scale = 20/30

    local cellSizeForTable = function (table, idx)
        return cellwidth, cellheight
    end

    local numberOfCellsInTableView = function (table)
        return self.m_yueyouluMaxCol > cols and self.m_yueyouluMaxCol or cols
    end

    local tableCellAtIndex = function (table, idx)
        local cell = table:dequeueCell()
        if not cell then
            cell = cc.TableViewCell:new()
        else
            cell:removeAllChildren()
        end

        for i = 0, rows - 1 do
            --背景方块
            local spBg = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_XIAOLUCELL_BG)
                :setAnchorPoint(cc.p(0, 0))
                :setPosition(cc.p(border, cellheight - (i + 1)*cellwidth + border))
                :addTo(cell)

            local record = BaccaratDataMgr.getInstance():getYueYouLuRecordByPosition(i, idx)
            if record.bExist then
                local strSpName = (record.cbWin == 1)
                    and BaccaratRes.IMG_TABLE_ZHUANGPING
                    or  BaccaratRes.IMG_TABLE_XIANPING

                local spIcon = cc.Sprite:createWithSpriteFrameName(strSpName)
                spIcon:setScale(scale)
                spIcon:setPosition(cc.p(bgwidth/2, bgwidth/2))
                spIcon:addTo(spBg)
            end
        end

        return cell
    end

    self.m_pYueYouLuView = cc.TableView:create(cc.size(440, 66))
--    self.m_pYueYouLuView:setIgnoreAnchorPointForPosition(false)
    self.m_pYueYouLuView:setAnchorPoint(cc.p(0,0))
    self.m_pYueYouLuView:setPosition(cc.p(0,0))
    self.m_pYueYouLuView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.m_pYueYouLuView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.m_pYueYouLuView:setTouchEnabled(true)
    self.m_pYueYouLuView:setDelegate()
    self.m_pNodeYueYouLu:addChild(self.m_pYueYouLuView)
    --self.m_yueyouluMaxCol = BaccaratDataMgr.getInstance():getYueYouLuRecordSize()
    self.m_yueyouluMaxCol = BaccaratDataMgr.getInstance():getYueYouLuColCount()
    self.m_yueyouluMaxCol = self.m_yueyouluMaxCol > cols and self.m_yueyouluMaxCol or cols
    self.m_pYueYouLuView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.m_pYueYouLuView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.m_pYueYouLuView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    self.m_pYueYouLuView:reloadData()

    if self.m_yueyouluMaxCol > cols then
        self.m_pYueYouLuView:setContentOffset(
            cc.p(self.m_pYueYouLuView:getViewSize().width - self.m_pYueYouLuView:getContentSize().width, 0))
    end
end

--初始化珠路显示 单个cel 背景尺寸32*32,边框各留1,行×列 = 6*13
function BaccaratTrendLayer:initZhuLuView()
    local rows = 6
    local cols = 13
    local border = 1
    local bgwidth = 32
    local cellwidth = 2*border + bgwidth
    local cellheight = rows * cellwidth
    local scale = 1

    local cellSizeForTable = function (table, idx)
        return cellwidth, cellheight
    end

    local numberOfCellsInTableView = function (table)
        return self.m_zhuluMaxCol > cols and self.m_zhuluMaxCol or cols
    end

    local tableCellAtIndex = function (table, idx)
        local cell = table:dequeueCell()
        if not cell then
            cell = cc.TableViewCell:new()
        else
            cell:removeAllChildren()
        end

        for i = 0, rows - 1 do
            --背景方块
            local spBg = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_DALUCELL_BG)
                :setAnchorPoint(cc.p(0, 0))
                :setPosition(cc.p(border, cellheight - (i + 1)*cellwidth + border))
                :addTo(cell)

            local rIndex = idx*6+i
            if rIndex <  BaccaratDataMgr.getInstance():getGameRecordSize() then
                local record = BaccaratDataMgr.getInstance():getGameRecordAtIndex(rIndex+1)
                local strSpName
                if record.cbPlayerCount < record.cbBankerCount then
                    --庄赢
                    strSpName = BaccaratRes.IMG_SMALL_ZHUANG
                elseif record.cbPlayerCount > record.cbBankerCount then
                    --闲赢
                    strSpName = BaccaratRes.IMG_SMALL_XIAN
                else
                    --平
                    strSpName = BaccaratRes.IMG_SMALL_PING
                end
                local spIcon = cc.Sprite:createWithSpriteFrameName(strSpName)
                                :setPosition(cc.p(bgwidth/2, bgwidth/2))
                                :setScale(scale)
                                :addTo(spBg)

                if record.bBankerTwoPair then
                    cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_TABLE_ZHUANGDUI)
                        :setScale(0.5)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(bgwidth/2 - 8, bgwidth/2 + 8)
                        :addTo(spBg)
                end
                if record.bPlayerTwoPair then
                    cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_TABLE_XIANDUI)
                        :setScale(0.5)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(bgwidth/2 + 8, bgwidth/2 - 8)
                        :addTo(spBg)
                end
            end
        end

        return cell
    end

    self.m_pZhuluView = cc.TableView:create(cc.size(444, 206))
--    self.m_pZhuluView:setIgnoreAnchorPointForPosition(false)
    self.m_pZhuluView:setAnchorPoint(cc.p(0,0))
    self.m_pZhuluView:setPosition(cc.p(0,0))
    self.m_pZhuluView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.m_pZhuluView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.m_pZhuluView:setTouchEnabled(true)
    self.m_pZhuluView:setDelegate()
    self.m_pNodeZhuLu:addChild(self.m_pZhuluView)
    self.m_zhuluMaxCol = math.floor( BaccaratDataMgr.getInstance():getGameRecordSize() / rows) + 1
    self.m_zhuluMaxCol = self.m_zhuluMaxCol > cols and self.m_zhuluMaxCol or cols
    self.m_pZhuluView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.m_pZhuluView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.m_pZhuluView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    self.m_pZhuluView:reloadData()

    if self.m_zhuluMaxCol > cols then
        self.m_pZhuluView:setContentOffset(
            cc.p(self.m_pZhuluView:getViewSize().width - self.m_pZhuluView:getContentSize().width, 0))
    end
end

--刷新历史记录
function BaccaratTrendLayer:onMsgUpdateHistory()
    self:refreshLabelView()
    self:refreshLuZiView()
end

--刷新局数显示
function BaccaratTrendLayer:refreshLabelView()
    for k, v in pairs(self.m_pLbNums) do
        v:setString(BaccaratDataMgr.getInstance():getGameRecordCountByType(k))
    end
end

--刷新各种路子显示
function BaccaratTrendLayer:refreshLuZiView()
    --大路
    self.m_daluMaxCol = BaccaratDataMgr.getInstance():getDaLuColCount()
    self.m_pDaluView:reloadData()

    --大眼仔路
    self.m_dayanluMaxCol = BaccaratDataMgr.getInstance():getDaYanZaiColCount()
    self.m_pDayanluView:reloadData()
    
    --小路
    self.m_xiaoluMaxCol = BaccaratDataMgr.getInstance():getXiaoLuColCount()
    self.m_pXiaoLuView:reloadData()

    --曱由路
    self.m_yueyouluMaxCol = BaccaratDataMgr.getInstance():getYueYouLuColCount()
    self.m_pYueYouLuView:reloadData()

    --珠路
    self.m_zhuluMaxCol = math.floor(BaccaratDataMgr.getInstance():getGameRecordSize() / 6) + 1
    self.m_pZhuluView:reloadData()
end

function BaccaratTrendLayer:initZhuLu() --珠路

    local node = self.m_pNodeTableNode[BaccaratTrendLayer.TAG_OF_ZHULU]
    local size = node:getContentSize()

    local function initTableViewCell(cell, idx)
        if idx == 0 then
            local spXian2 = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMAGE_OF_ZHULU_CELL)
            spXian2:setAnchorPoint(cc.p(0, 0))
            spXian2:setPosition(cc.p(52, 209))
            spXian2:setRotation(180)
            spXian2:addTo(cell)
        end
        local spXian = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMAGE_OF_ZHULU_CELL)
        spXian:setAnchorPoint(cc.p(0, 0))
        spXian:setPosition(cc.p(0, 0))
        spXian:addTo(cell)

        for i = 0, 5 do

            local rIndex = idx*6+i
            if rIndex >=  BaccaratDataMgr.getInstance():getGameRecordSize() then
                break
            end
            local record = BaccaratDataMgr.getInstance():getGameRecordAtIndex(rIndex+1)
            local strSpName
            if record.cbPlayerCount < record.cbBankerCount then
                --庄赢
                strSpName = BaccaratRes.IMAGE_OF_TABLE_ZHUANG
            elseif record.cbPlayerCount > record.cbBankerCount then
                --闲赢
                strSpName = BaccaratRes.IMAGE_OF_TABLE_XIAN
            else
                --平
                strSpName = BaccaratRes.IMAGE_OF_TABLE_PING
            end
            local spIcon = cc.Sprite:createWithSpriteFrameName(strSpName)
            spIcon:setPosition(cc.p(26,188.5-i*34.5))
            spIcon:addTo(cell)

            if record.bBankerTwoPair then
                --庄对
                local sp = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMAGE_OF_TABLE_ZHUANG_DUI)
                sp:setPosition(cc.p(8, 26))
                sp:addTo(spIcon)
            end
            if record.bPlayerTwoPair then
                --闲对
                local sp = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMAGE_OF_TABLE_XIAN_DUI)
                sp:setPosition(cc.p(28, 9))
                sp:addTo(spIcon)
            end
        end
    end
    local function tableCellTouched(table, cell)
        print("touch:"..cell:getIdx())
    end
    local function tableCellAtIndex(table, idx)
        local cell = table:cellAtIndex(idx)
        if not cell then
            cell = cc.TableViewCell:new()
        else
            cell:removeAllChildren()
        end
        initTableViewCell(cell, idx)
        return cell
    end
    local function cellSizeForTable(table, idx)
        return 51, size.height
    end
    local function numberOfCellsInTableView(table)
        return self.m_iMaxZhulu
    end
    if not self.m_pTableZhulu then
        self.m_pTableZhulu = cc.TableView:create(size)
--        self.m_pTableZhulu:setIgnoreAnchorPointForPosition(false)
        self.m_pTableZhulu:setAnchorPoint(cc.p(0,0))
        self.m_pTableZhulu:setPosition(cc.p(0, 0))
        self.m_pTableZhulu:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        self.m_pTableZhulu:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.m_pTableZhulu:setTouchEnabled(true)
        self.m_pTableZhulu:setDelegate()
        self.m_pTableZhulu:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
        self.m_pTableZhulu:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
        self.m_pTableZhulu:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
        self.m_pTableZhulu:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
        self.m_pTableZhulu:addTo(node)
    end
    self.m_pTableZhulu:reloadData()
end
function BaccaratTrendLayer:initDaYanZaiLu()

    local node = self.m_pNodeTableNode[BaccaratTrendLayer.TAG_OF_DAYANLU]
    local size = node:getContentSize()

    local function initTableViewCell(cell, idx)
        if idx == 0 then
            local spXian2 = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMAGE_OF_XIAOLU_CELL)
            spXian2:setAnchorPoint(cc.p(0, 0))
            spXian2:setPosition(cc.p(25, size.height + 1))
            spXian2:setRotation(180)
            spXian2:addTo(cell)
        end
        local spXian = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMAGE_OF_XIAOLU_CELL)
        spXian:setAnchorPoint(cc.p(0, 0))
        spXian:setPosition(cc.p(0, 0))
        spXian:addTo(cell)
    
        for i = 0, 2 do
            local record = BaccaratDataMgr.getInstance():getDaYanZaiRecordByPosition(i, idx)
            if record.bExist then
                local strSpName = (record.cbWin == 1)
                    and BaccaratRes.IMAGE_OF_TABLE_ZHUANG2
                    or  BaccaratRes.IMAGE_OF_TABLE_XIAN2
                local spIcon = cc.Sprite:createWithSpriteFrameName(strSpName)
                spIcon:setScale(0.4)
                spIcon:setPosition(cc.p(12.5, 56-23*i))
                spIcon:addTo(cell)
            end
        end
    end
    local function tableCellTouched(table, cell)
        print("%d \n", cell:getIdx())
    end
    local function tableCellAtIndex(table, idx)
        local cell = table:cellAtIndex(idx)
        if not cell then
            cell = cc.TableViewCell:new()
        else
            cell:removeAllChildren()
        end
        initTableViewCell(cell, idx)
        return cell
    end
    local function cellSizeForTable(table, idx)
        return 25, size.height
    end
    local function numberOfCellsInTableView(table)
        return self.m_iMaxDaYanlu
    end
    if not self.m_pTableDayanlu then
        self.m_pTableDayanlu = cc.TableView:create(size)
--        self.m_pTableDayanlu:setIgnoreAnchorPointForPosition(false)
        self.m_pTableDayanlu:setAnchorPoint(cc.p(0,0))
        self.m_pTableDayanlu:setPosition(cc.p(0, 0))
        self.m_pTableDayanlu:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        self.m_pTableDayanlu:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.m_pTableDayanlu:setTouchEnabled(true)
        self.m_pTableDayanlu:setDelegate()
        self.m_pTableDayanlu:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
        self.m_pTableDayanlu:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
        self.m_pTableDayanlu:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
        self.m_pTableDayanlu:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
        self.m_pTableDayanlu:addTo(node)
    end
    self.m_pTableDayanlu:reloadData()
end
function BaccaratTrendLayer:initXiaoLu()

    local node = self.m_pNodeTableNode[BaccaratTrendLayer.TAG_OF_XIAOLU]
    local size = node:getContentSize()

    local function initTableViewCell(cell, idx)
        if idx == 0 then
            local spXian2 = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMAGE_OF_XIAOLU_CELL)
            spXian2:setAnchorPoint(cc.p(0, 0))
            spXian2:setPosition(cc.p(25, size.height))
            spXian2:setRotation(180)
            spXian2:addTo(cell)
        end
        local spXian = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMAGE_OF_XIAOLU_CELL)
        spXian:setAnchorPoint(cc.p(0, 0))
        spXian:setPosition(cc.p(0, 0))
        spXian:addTo(cell)
    
        for i = 0, 2 do
            local record = BaccaratDataMgr.getInstance():getXiaoLuRecordByPosition(i,idx)
            if record.bExist then
                local strSpName = (record.cbWin == 1)
                    and BaccaratRes.IMAGE_OF_TABLE_ZHUANG_DUI
                    or  BaccaratRes.IMAGE_OF_TABLE_XIAN_DUI
                local spIcon = cc.Sprite:createWithSpriteFrameName(strSpName)
                spIcon:setPosition(cc.p(12.5, 56-23*i))
                spIcon:addTo(cell)
            end
        end
    end
    local function tableCellTouched(table, cell)
        print("%d \n", cell:getIdx())
    end
    local function tableCellAtIndex(table, idx)
        local cell = table:cellAtIndex(idx)
        if not cell then
            cell = cc.TableViewCell:new()
        else
            cell:removeAllChildren()
        end
        initTableViewCell(cell, idx)
        return cell
    end
    local function cellSizeForTable(table, idx)
        return 25, size.height
    end
    local function numberOfCellsInTableView(table)
        return self.m_iMaxXiaolu
    end
    if not self.m_pTableXiaolu then
        self.m_pTableXiaolu = cc.TableView:create(size)
--        self.m_pTableXiaolu:setIgnoreAnchorPointForPosition(false)
        self.m_pTableXiaolu:setAnchorPoint(cc.p(0,0))
        self.m_pTableXiaolu:setPosition(cc.p(0, 0))
        self.m_pTableXiaolu:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        self.m_pTableXiaolu:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.m_pTableXiaolu:setTouchEnabled(true)
        self.m_pTableXiaolu:setDelegate()
        self.m_pTableXiaolu:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
        self.m_pTableXiaolu:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
        self.m_pTableXiaolu:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
        self.m_pTableXiaolu:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
        self.m_pTableXiaolu:addTo(node)
    end
    self.m_pTableXiaolu:reloadData()
end
function BaccaratTrendLayer:initYueYouLu()
    
    local node = self.m_pNodeTableNode[BaccaratTrendLayer.TAG_OF_YUEYOULU]
    local size = node:getContentSize()

    local function initTableViewCell(cell, idx)
        
        if idx == 0 then
            local spXian2 = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMAGE_OF_XIAOLU_CELL)
            spXian2:setAnchorPoint(cc.p(0, 0))
            spXian2:setPosition(cc.p(25, size.height))
            spXian2:setRotation(180)
            spXian2:addTo(cell)
        end
        local spXian = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMAGE_OF_XIAOLU_CELL)
        spXian:setAnchorPoint(cc.p(0, 0))
        spXian:setPosition(cc.p(0, 0))
        spXian:addTo(cell)
    
        for i = 0, 2 do
            local record = BaccaratDataMgr.getInstance():getYueYouLuRecordByPosition(i, idx)
            if record.bExist then
                local strSpName = (record.cbWin == 1)
                    and BaccaratRes.IMAGE_OF_TABLE_PING2
                    or  BaccaratRes.IMAGE_OF_TABLE_PING3
                local spIcon = cc.Sprite:createWithSpriteFrameName(strSpName)
                spIcon:setScale(0.6)
                spIcon:setPosition(cc.p(12.5, 56-23*i))
                spIcon:addTo(cell)
            end
        end
    end
    local function tableCellTouched(table, cell)
        print("%d \n", cell:getIdx())
    end
    local function tableCellAtIndex(table, idx)
        local cell = table:cellAtIndex(idx)
        if not cell then
            cell = cc.TableViewCell:new()
        else
            cell:removeAllChildren()
        end
        initTableViewCell(cell, idx)
        return cell
    end
    local function cellSizeForTable(table, idx)
        return 25, size.height
    end
    local function numberOfCellsInTableView(table)
        return self.m_iMaxYueYoulu
    end
    if not self.m_pTableYueyoulu then
        self.m_pTableYueyoulu = cc.TableView:create(size)
--        self.m_pTableYueyoulu:setIgnoreAnchorPointForPosition(false)
        self.m_pTableYueyoulu:setAnchorPoint(cc.p(0,0))
        self.m_pTableYueyoulu:setPosition(cc.p(0, 0))
        self.m_pTableYueyoulu:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        self.m_pTableYueyoulu:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.m_pTableYueyoulu:setTouchEnabled(true)
        self.m_pTableYueyoulu:setDelegate()
        self.m_pTableYueyoulu:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
        self.m_pTableYueyoulu:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
        self.m_pTableYueyoulu:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
        self.m_pTableYueyoulu:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
        self.m_pTableYueyoulu:addTo(node)
    end
    self.m_pTableYueyoulu:reloadData()
end

function BaccaratTrendLayer:onReturnClicked()
    if not self.m_isPlaySound then
--        ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_CLOSE)
        self.m_isPlaySound = true
    end
--    onCloseLayer(self.m_trendLayer, self.m_pShadow, self)
    if self.m_trendLayer and self then
        local scale1 = 1.0
        local scale2 = 0.5
        local time = 0.3
        local scaleto = cc.EaseBackIn:create(cc.ScaleTo:create(time, scale2))
        local close = cc.CallFunc:create(function() self:removeFromParent() end)
        local seq = cc.Sequence:create(scaleto, close)
        self.m_trendLayer:setScale(1.0)
        self.m_trendLayer:runAction(seq)
    end

    if self.m_pShadow then
        local opacity1 = 255
        local opacity2 = 50
        local time = 0.3
        local fadeto = cc.FadeTo:create(time, opacity2)
        self.m_pShadow:setOpacity(opacity1)
        self.m_pShadow:runAction(fadeto)
    end
end

return BaccaratTrendLayer
