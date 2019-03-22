--region MsgDetailsView.lua
--Date
--
--Desc: 举报页面
--modify by Goblin on 2017.08.01


local MsgDetailsView = class("MsgDetailsView", FixLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local UsrMsgManager     = appdf.req(appdf.CLIENT_SRC.."external.UsrMsgManager")

function MsgDetailsView:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()
    self:init()
end

function MsgDetailsView:onEnter()
    self.super:onEnter()
    self:showWithStyle()
end

function MsgDetailsView:onExit()
    self.super:onExit()
end

function MsgDetailsView:init()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    --csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/MsgDetailsView.csb")
    self.m_pathUI:addTo(self.m_rootUI)


    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("MsgDetailsView")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)
    
    self.m_pNodeTable = self.m_pNodeRoot:getChildByName("Image_bg"):getChildByName("Node_List")

    self.m_pBtnClose = self.m_pNodeRoot:getChildByName("Image_bg"):getChildByName("BTN_close")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseClicked))
end

function MsgDetailsView:setMsgTableContent(strFeedback, strRevert)

    self:initListView()

    --删除子项
    self.m_pListView:removeAllItems()

    local strContent = {
        "建议："..strFeedback,
        "回复："..strRevert,
    }
    --初始化内容项
    for i = 1, #strContent do
        local item = self:initListViewCell(i, strContent[i])
        self.m_pListView:pushBackCustomItem(item)
    end
--    local strContent = {
--        "建议："..strFeedback,
--        "回复："..strRevert,
--    }
--    local strColor = {
--        cc.c3b(160, 36, 36),
--        cc.c3b(120, 80, 10),
--    }
--    --初始化内容项
--    for i = 1, #strContent do
--        local item = self:initListViewCell(i, strContent[i], strColor[i] )
--        self.m_pListView:pushBackCustomItem(item)
--    end

--    --调试数据
--    strFeedback = " 冬天过去了,春天又迈着轻盈的脚步来到了人间,到处都好像约好似的,换上新装。我建议同学们不要错过了机会,到桃花坞去看看那里春天的风景。"
--    strRevert = "本站针对md5、sha1等全球通用公开的加密算法进行反向查询，通过穷举字符组合的方式，创建了明文密文对应查询数据库，创建的记录约90万亿条，占用硬盘超过500TB，查询成功率95%以上，很多复杂密文只有本站才可查询。已稳定运行十余年，国内外享有盛誉。 "
--    --建议    
--    local width = self.m_pNodeTable:getContentSize().width
--    local lbText = cc.Label:createWithSystemFont( "          " .. strFeedback, "Helvetica", 26)
--    lbText:setAnchorPoint(cc.p(0, 1))
--    lbText:setDimensions(width, 0)
--    local size = lbText:getContentSize()
--    local textPos = size.height + 15 
--    lbText:setPosition(0, textPos)
--    lbText:setColor( cc.c3b(108, 57, 29) )

--    local lbTextTitle = cc.Label:createWithSystemFont("建议:", "", 26 )
--    lbTextTitle:setPosition(0, textPos-1)
--    lbTextTitle:setAnchorPoint(cc.p(0, 1))
--    lbTextTitle:setColor(cc.c3b(255, 102, 0)) 

--    local cell = ccui.Layout:create()
--    local cellHeight = size.height + 20
--    cell:setContentSize(cc.size(width, cellHeight))
--    cell:addChild(lbText)
--    cell:addChild(lbTextTitle)
--    self.m_pListView:pushBackCustomItem(cell)

--    --回复
--    lbText = cc.Label:createWithSystemFont("          " .. strRevert, "Helvetica", 26)
--    lbText:setAnchorPoint(cc.p(0, 1))
--    lbText:setDimensions(width, 0)
--    size = lbText:getContentSize()
--    textPos = size.height
--    lbText:setPosition(0, textPos)
--    lbText:setColor( cc.c3b(108, 57, 29) )

--    lbTextTitle = cc.Label:createWithSystemFont("回复:", "", 26 )
--    lbTextTitle:setPosition(0, textPos-1)
--    lbTextTitle:setAnchorPoint(cc.p(0, 1))
--    lbTextTitle:setColor(cc.c3b(202, 23, 27)) 

--    cell = ccui.Layout:create()
--    cellHeight = size.height
--    cell:setContentSize(cc.size(width, cellHeight))
--    cell:addChild(lbText)
--    cell:addChild(lbTextTitle)
--    self.m_pListView:pushBackCustomItem(cell)
end

function MsgDetailsView:initListView()

    if not self.m_pListView then
        self.m_pListView = ccui.ListView:create()
        self.m_pListView:setGravity(0)
        self.m_pListView:setBounceEnabled(true)
        self.m_pListView:setDirection(ccui.ScrollViewDir.vertical)
        self.m_pListView:setContentSize(self.m_pNodeTable:getContentSize())
        self.m_pListView:setPosition(cc.p(0,0))
        self.m_pListView:addTo(self.m_pNodeTable, 1000)
    end
end

function MsgDetailsView:initListViewCell(nIdx, strContent)

    local width = self.m_pNodeTable:getContentSize().width
    local lbText = cc.Label:createWithSystemFont(strContent, "Helvetica", 26)
    lbText:setAnchorPoint(cc.p(0, 1))
    lbText:setDimensions(width, 0)
    local size = lbText:getContentSize()
    local textPos = nIdx == 1 and size.height + 15 or size.height
    lbText:setPosition(0, textPos)
    lbText:setColor(cc.c3b(120, 80, 30))

    local cell = ccui.Layout:create()
    local cellHeight = nIdx == 1 and size.height + 20 or size.height
    cell:setContentSize(cc.size(width, cellHeight))
    cell:addChild(lbText)

    return cell
end

---------------------- ccbi 按纽关闭
function MsgDetailsView:onCloseClicked(pSender)
    ExternalFun.playClickEffect()
    self:onMoveExitView()
end

return MsgDetailsView
