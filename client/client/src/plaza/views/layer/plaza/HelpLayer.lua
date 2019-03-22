--
-- Author: zhong
-- Date: 2017-05-24 20:05:54
--
-- 帮助界面(三级弹窗)
local TransitionLayer = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")
local HelpLayer = class("HelpLayer", TransitionLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local BTN_CLOSE = 101   -- 关闭按钮
local TAG_MASK = 102    -- 遮罩
function HelpLayer:ctor( scene, param, level )
    HelpLayer.super.ctor( self, scene, param, level )
    -- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("service/HelpLayer.csb", self)
    local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(), ref)            
        end
    end

    -- 遮罩
    local mask = csbNode:getChildByName("panel_mask")
    mask:setTag(TAG_MASK)
    mask:addTouchEventListener( touchFunC )

    -- 底板
    local spbg = csbNode:getChildByName("sp_bg")
    self.m_spBg = spbg

    -- 关闭
    local btn = spbg:getChildByName("btn_close")
    btn:setTag(BTN_CLOSE)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)

    self.m_tabCellHeightCache = {}
    self.m_tabList = {}
    self.m_nListCount = 0

    -- 加载动画
    self:scaleShakeTransitionIn(spbg)
end

-- 按键监听
function HelpLayer:onButtonClickedEvent(tag,sender)
    if tag == TAG_MASK or tag == BTN_CLOSE then
        self:scaleTransitionOut(self.m_spBg)
    end
end

function HelpLayer:animationRemove()
    self:scaleTransitionOut(self.m_spBg)
end

function HelpLayer:onTransitionInFinish()
    self:getData()
    -- 公告列表
    local tmp = self.m_spBg:getChildByName("content")
    self._listView = cc.TableView:create(tmp:getContentSize())
    self._listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)    
    self._listView:setPosition(tmp:getPosition())
    self._listView:setDelegate()
    self._listView:addTo(self.m_spBg)
    self._listView:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED)
    self._listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self._listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self._listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self._listView:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL)
    tmp:removeFromParent()
    self._listView:reloadData()
end

function HelpLayer:onTransitionInBegin()
    self:sendShowEvent()
end

function HelpLayer:onTransitionOutBegin()
    self:sendHideEvent()
end

function HelpLayer:onTransitionOutFinish()
    self:removeFromParent()
end

function HelpLayer:tableCellTouched(view, cell)

end

-- 子视图大小
function HelpLayer:cellSizeForTable(view, idx)
    local cacheHeight = self.m_tabCellHeightCache[idx + 1]
    if nil ~= cacheHeight then
        return view:getViewSize().width, cacheHeight + 10 -- +10为间隔
    end

    local qa = self.m_tabList[idx + 1]
    if nil ~= qa then
        -- 背景
        local imagecell = ccui.ImageView:create("service/help_sp_cellbg.png")
        local imagesize = imagecell:getContentSize()
        -- 内容
        local txtContent = cc.Label:createWithTTF(qa.answer, "fonts/round_body.ttf", 24, cc.size(695,0), cc.TEXT_ALIGNMENT_LEFT)
        txtContent:setLineBreakWithoutSpace(true)
        -- +30 为空隙 +30 为标题高度
        local adjHeight = txtContent:getContentSize().height + 60
        if adjHeight < imagesize.height then
            adjHeight = imagesize.height
        end
        self.m_tabCellHeightCache[idx + 1] = adjHeight
        return view:getViewSize().width, adjHeight + 10 -- +10为间隔
    else
        self.m_tabCellHeightCache[idx + 1] = 160
        return view:getViewSize().width, 160
    end
end

function HelpLayer:tableCellAtIndex(view, idx)
    local cell = view:dequeueCell()
    if not cell then        
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end
    local qa = self.m_tabList[idx + 1]
    -- 背景
    local imagecell = ccui.ImageView:create("service/help_sp_cellbg.png")
    cell:addChild(imagecell)
    imagecell:setScale9Enabled(true)
    local imagesize = imagecell:getContentSize()

    -- 标号
    local spnum = cc.Sprite:create("service/help_sp_numbg.png")
    imagecell:addChild(spnum)
    local num = self.m_nListCount - idx
    local txtnum = cc.Label:createWithTTF(num .. "", "fonts/round_body.ttf", 30)
    spnum:addChild(txtnum)
    txtnum:setPosition(spnum:getContentSize().width * 0.5, spnum:getContentSize().height * 0.5)

    -- 问
    local txtQue = cc.Label:createWithTTF("问:", "fonts/round_body.ttf", 24)
    txtQue:setColor(cc.c4b(255,237,31,255))
    txtQue:setAnchorPoint(cc.p(0, 1.0))
    imagecell:addChild(txtQue)
    local txtTitle = cc.Label:createWithTTF(qa.question, "fonts/round_body.ttf", 24)
    txtTitle:setColor(cc.c4b(255,237,31,255))
    imagecell:addChild(txtTitle)
    txtTitle:setAnchorPoint(cc.p(0, 1.0))
    local titleSize = txtTitle:getContentSize()

    -- 答
    local txtAns = cc.Label:createWithTTF("答:", "fonts/round_body.ttf", 24)
    imagecell:addChild(txtAns)
    txtAns:setAnchorPoint(cc.p(0, 1.0))
    local txtContent = cc.Label:createWithTTF(qa.answer, "fonts/round_body.ttf", 24, cc.size(695,0), cc.TEXT_ALIGNMENT_LEFT)
    txtContent:setLineBreakWithoutSpace(true)
    imagecell:addChild(txtContent)
    txtContent:setAnchorPoint(cc.p(0, 1.0))
    local contentSize = txtContent:getContentSize()

    -- +30 为空隙
    local adjHeight = titleSize.height + contentSize.height + 30
    if adjHeight < imagesize.height then
        adjHeight = imagesize.height
    end
    local adjContentSize = cc.size(imagesize.width, adjHeight)
    imagecell:setContentSize(adjContentSize)

    -- 调整位置
    spnum:setPosition(80, adjHeight * 0.5)
    txtQue:setPosition(140, adjHeight - 10)
    txtTitle:setPosition(190, adjHeight - 10)
    txtAns:setPosition(140, adjHeight - 50)
    txtContent:setPosition(190, adjHeight - 50)
    imagecell:setPosition(view:getViewSize().width * 0.5, imagecell:getContentSize().height * 0.5)
    return cell
end

-- 子视图数目
function HelpLayer:numberOfCellsInTableView(view)
    return self.m_nListCount
end

function HelpLayer:scrollViewDidScroll(view)

end

function HelpLayer:getData()
    self.m_tabList = {}
    table.insert(self.m_tabList, {
        time = "2017.02.05", 
        question = "如何获取元宝?", 
        answer = "如何获取元宝如何获取元宝如何获取元宝",
        })
    table.insert(self.m_tabList, {
        time = "2017.02.07", 
        question = "如何获取钻石?", 
        answer = "如何获取钻石如何获取钻石如何获取钻石",
        })
    table.insert(self.m_tabList, {
        time = "2017.02.07", 
        question = "如何获取房卡?", 
        answer = "如何获取钻石如何获取钻石如何获取钻石",
        })
    table.insert(self.m_tabList, {
        time = "2017.02.05", 
        question = "如何获取元宝1?", 
        answer = "如何获取元宝如何获取元宝如何获取元宝",
        })
    table.insert(self.m_tabList, {
        time = "2017.02.07", 
        question = "如何获取钻石1?", 
        answer = "如何获取钻石如何获取钻石如何获取钻石如何获取钻石如何获取钻石如何获取钻石如何获取钻石如何获取钻石如何获取钻石如何获取钻石如何获取钻石如何获取钻石",
        })
    table.insert(self.m_tabList, {
        time = "2017.02.07", 
        question = "如何获取房卡1?", 
        answer = "如何获取钻石如何获取钻石如何获取钻石",
        })
    table.insert(self.m_tabList, {
        time = "2017.02.05", 
        question = "如何获取元宝2222?", 
        answer = "如何获取元宝如何获取元宝如何获取元宝",
        })
    table.insert(self.m_tabList, {
        time = "2017.02.07", 
        question = "如何获取钻石22222?", 
        answer = "如何获取钻石如何获取钻石如何获取钻石",
        })
    table.insert(self.m_tabList, {
        time = "2017.02.07", 
        question = "如何获取房卡22222?", 
        answer = "如何获取钻石如何获取钻石如何获取钻石",
        })
    self.m_nListCount = #self.m_tabList
end

return HelpLayer