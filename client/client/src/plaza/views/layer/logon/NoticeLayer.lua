--
-- Author: zhong
-- Date: 2017-05-23 16:33:48
--
local TransitionLayer = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")
local NoticeLayer = class("NoticeLayer", TransitionLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")

-- net
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame")

local BTN_CLOSE = 101   -- 关闭按钮
local TAG_MASK = 102    -- 遮罩
function NoticeLayer:ctor( scene, param, level )
    NoticeLayer.super.ctor( self, scene, param, level )

     --网络回调
    local  noticeCallBack = function(result,message)
       self:onNoticeCallBack(result,message)
    end
    --网络处理
    self._noticeFrame = LogonFrame:getInstance()
    self._noticeFrame:setCallBackDelegate(self, noticeCallBack)

    -- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("service/NoticeLayer.csb", self)
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

    local tmp = self.m_spBg:getChildByName("txt_content")
    self.tmp = tmp

    -- 关闭
    local btn = spbg:getChildByName("btn_cancel")
    btn:setTag(BTN_CLOSE)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)

    self.m_tabCellHeightCache = {}
    self.m_tabList = param
    self.m_nListCount = #param
   
     --加载动画
    self:scaleTransitionIn(spbg)
    self:scaleShakeTransitionIn(spbg)
end

-- 按键监听
function NoticeLayer:onButtonClickedEvent(tag,sender)
    if tag == TAG_MASK or tag == BTN_CLOSE then
        self:scaleTransitionOut(self.m_spBg)
    end
end

function NoticeLayer:onTransitionInFinish()
    -- 公告列表
--    local tmp = self.m_spBg:getChildByName("txt_content")
--    self._listView = cc.TableView:create(tmp:getContentSize())
--    self._listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)    
--    self._listView:setPosition(tmp:getPosition())
--    self._listView:setDelegate()
--    self._listView:addTo(self.m_spBg)
--    self._listView:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED)
--    self._listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
--    self._listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
--    self._listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
--    self._listView:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL)
--    tmp:removeFromParent()
--    self._listView:reloadData()

    self:requestNotice()
end

function NoticeLayer:onNoticeCallBack(result,message)
    self:dismissPopWait()
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
    if message ~= nil and message ~= "" then
         if message.result == "ok" and message.tag == "get_question_recovery" then
             for i= 1,#message.body.recoveries do
             end
        end
    end
end

function  NoticeLayer:requestNotice()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "get_question_recovery"
    msgta["body"] = nil
    self._noticeFrame:sendGameData(msgta)
end
function NoticeLayer:onTransitionOutFinish()
    self:removeFromParent()
end

function NoticeLayer:tableCellTouched(view, cell)

end

-- 子视图大小
function NoticeLayer:cellSizeForTable(view, idx)
    local cacheHeight = self.m_tabCellHeightCache[idx + 1]
    if nil ~= cacheHeight then
        return view:getViewSize().width, cacheHeight + 10 -- +20为间隔
    end

    local notice = self.m_tabList[idx + 1]
    if nil ~= notice then
        -- 背景
        local imagesize = cc.size(994, 276) -- service/service_sp_cellbg.png 尺寸
        -- 内容
        local msg = notice.MoblieContent or ""
        local txtContent = cc.Label:createWithTTF(msg, "fonts/round_body.ttf", 30, cc.size(940,0), cc.TEXT_ALIGNMENT_LEFT)
        txtContent:setLineBreakWithoutSpace(true)
        -- +40 为空隙 + 30 为标题高度
        local adjHeight = txtContent:getContentSize().height + 70
        if adjHeight < imagesize.height then
            adjHeight = imagesize.height
        end
        self.m_tabCellHeightCache[idx + 1] = adjHeight
        return view:getViewSize().width, adjHeight + 10 -- +20为间隔
    else
        self.m_tabCellHeightCache[idx + 1] = 276
        return view:getViewSize().width, 276
    end
end

function NoticeLayer:tableCellAtIndex(view, idx)
    local cell = view:dequeueCell()
    if not cell then        
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end
    local notice1 = self.m_tabList[idx + 1]
    if nil == notice then
        return cell
    end

    -- 背景
    local imagecell = ccui.ImageView:create("service/service_sp_cellbg.png")
    imagecell:setScale9Enabled(true)
    cell:addChild(imagecell)
    local imagesize = imagecell:getContentSize()

    -- 时间
    local szdate = ""
    local date = tonumber(string.match(notice.PublisherTime,"(%d+)"))
    if nil ~= date then
        szdate = os.date("%Y-%m-%d", date / 1000)
    end
    local txtDate = cc.Label:createWithTTF(szdate, "fonts/round_body.ttf", 26)
    imagecell:addChild(txtDate)
    txtDate:setAnchorPoint(cc.p(1.0, 1.0))
    local dateSize = txtDate:getContentSize()

    -- 标题
    local txtTitle = ClipText:createClipText(cc.size(438, 30), notice.NoticeTitle, nil, 26) 
    imagecell:addChild(txtTitle)
    txtTitle:setAnchorPoint(cc.p(0.5, 1.0))

    -- 内容
    local msg = notice.MoblieContent or ""
    local txtContent = cc.Label:createWithTTF(msg, "fonts/round_body.ttf", 30, cc.size(940,0), cc.TEXT_ALIGNMENT_LEFT)
    txtContent:setLineBreakWithoutSpace(true)
    --txtContent:setColor(cc.c4b(100,54,27,255))
    imagecell:addChild(txtContent)
    txtContent:setAnchorPoint(cc.p(0, 1.0))
    local contentSize = txtContent:getContentSize()

    -- +40 为空隙
    local adjHeight = dateSize.height + contentSize.height + 40
    if adjHeight < imagesize.height then
        adjHeight = imagesize.height
    end
    local adjContentSize = cc.size(imagesize.width, adjHeight)
    imagecell:setContentSize(adjContentSize)

    -- 调整位置
    txtDate:setPosition(970, adjHeight - 6)
    txtTitle:setPosition(228, adjHeight - 3)
    txtContent:setPosition(27, adjHeight - 50)
    imagecell:setPosition(view:getViewSize().width * 0.5, imagecell:getContentSize().height * 0.5)
    return cell
end

-- 子视图数目
function NoticeLayer:numberOfCellsInTableView(view)
    return self.m_nListCount
end

function NoticeLayer:scrollViewDidScroll(view)
end

return NoticeLayer