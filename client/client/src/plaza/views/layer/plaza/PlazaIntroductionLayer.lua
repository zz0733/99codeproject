--
-- Author: David
-- Date: 2017-11-07 10:33:48
--
-- 大厅消息(二级弹窗)
local TransitionLayer = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")
local PlazaIntroductionLayer = class("PlazaIntroductionLayer", TransitionLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")


local BTN_CLOSE = 101   -- 关闭按钮
local TAG_MASK = 102    -- 遮罩

function PlazaIntroductionLayer:ctor( scene, param, level )
    PlazaIntroductionLayer.super.ctor( self, scene, param, level )
    -- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("introduction/IntroductionLayer.csb", self)
    local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(), ref)            
        end
    end

    -- 遮罩
    local mask = csbNode:getChildByName("mask")
    mask:setTag(TAG_MASK)
    mask:addTouchEventListener( touchFunC )

    -- 底板
    local spbg = csbNode:getChildByName("Image_bg")
    spbg:addTouchEventListener( touchFunC )
    self.m_spBg = spbg

    -- 关闭
    local btn = spbg:getChildByName("btn_close")
    btn:setTag(BTN_CLOSE)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)


    self.m_tabList = {} --param
    self.m_nListCount = 0 --#param
    self.m_tabBox = {}
    self.m_nSelectIdx = 0


    --请求玩法列表
    local action = "action=GetGameIntroList&".. GlobalUserItem:urlUserIdSignParam()
    appdf.onHttpJsionTable(yl.HTTP_URL .. "/WS/NewMoblieInterface.ashx","GET",action,function(jstable,jsdata)
        dump(jstable, "desciption", 7)
        local msg = ""
        if type(jstable) == "table" then
            msg = jstable["msg"]
            local data = jstable["data"]
            if type(data) == "table" then
                local valid = data["valid"]
                if valid then
                    local ruleList = data["ruleList"]
                    if type(ruleList) == "table" then
                        for k,v in pairs(ruleList) do
                            local gameinfo = {}
                            gameinfo.KindID = v["KindID"]
                            gameinfo.KindName = v["KindName"]
                            gameinfo.Content = v["Content"]
                            table.insert(self.m_tabList, gameinfo)
                        end
                    end
                end
            end
        end
        dump(self.m_tabList, "desciption", 7)
        --this:dismissPopWait()
    end)


    -- 注册事件监听
    self:registerEventListenr()
    -- 加载动画
    self:scaleShakeTransitionIn(spbg)
end

-- 按键监听
function PlazaIntroductionLayer:onButtonClickedEvent(tag,sender)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if self.m_bEditInput and cc.PLATFORM_OS_WINDOWS ~= targetPlatform then
        self.m_bEditInput = false
        -- editbox 隐藏键盘时屏蔽按钮
        return
    end
    if tag == BTN_CLOSE then --tag == TAG_MASK or tag == BTN_CLOSE then
        self:scaleTransitionOut(self.m_spBg)
    end
end

function PlazaIntroductionLayer:animationRemove()
    self:scaleTransitionOut(self.m_spBg)
end

function PlazaIntroductionLayer:onTransitionInFinish()
    self.m_nListCount = #self.m_tabList --#param

    -- 规则详细
    local tmp = self.m_spBg:getChildByName("content2")
    -- 读取文本
    self._scrollView = ccui.ScrollView:create()
                          :setContentSize(tmp:getContentSize())
                          :setPosition(tmp:getPosition())
                          :setAnchorPoint(tmp:getAnchorPoint())
                          :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
                          :setBounceEnabled(true)
                          :setScrollBarEnabled(false)
                          :addTo(self.m_spBg)
    tmp:removeFromParent()

    self._strLabel = cc.Label:createWithTTF("", "fonts/round_body.ttf", 25)
                         :setLineBreakWithoutSpace(true)
                         :setMaxLineWidth(self._scrollView:getContentSize().width- 10)
                         :setTextColor(cc.c4b(255,255,255,255))
                         :setAnchorPoint(cc.p(0.5, 1.0))
                         :addTo(self._scrollView)

    if nil ~= self.m_tabList[self.m_nListCount] then
        self.m_nSelectIdx = self.m_nListCount
        self:refreshIntroduce( self.m_tabList[self.m_nListCount].Content )
    end


    -- 规则列表
    local tmp = self.m_spBg:getChildByName("content1")
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

function PlazaIntroductionLayer:refreshIntroduce( szTips )
    local viewSize = self._scrollView:getContentSize()
    self._strLabel:setString(szTips)
    local labelSize =   self._strLabel:getContentSize()
    local fHeight = labelSize.height > viewSize.height and labelSize.height or viewSize.height
    self._strLabel:setPosition(cc.p(viewSize.width * 0.5, fHeight))
    self._scrollView:setInnerContainerSize(cc.size(viewSize.width, labelSize.height))
end


function PlazaIntroductionLayer:onTransitionOutFinish()
    self:removeFromParent()
end

function PlazaIntroductionLayer:onOtherShowEvent()
    if self:isVisible() then
        self:setVisible(false)
    end
end

function PlazaIntroductionLayer:onOtherHideEvent()
    if not self:isVisible() then
        self:setVisible(true)
    end
end

function PlazaIntroductionLayer:tableCellTouched(view, cell)
    local index = cell:getIdx()
    local info = self.m_tabList[index +1]
    if nil == info then
        return 
    end

    --设置为选择
    local image = cell:getChildByTag(1)
    local imagePress = string.format("introduction/introduction_btn1_%d.png", info.KindID)
    if nil ~= image then
        image:loadTexture(imagePress)
    end
    self:refreshIntroduce(self.m_tabList[index +1].Content)

    print("aaaaaaaaaaaaaaaaaaaaaaaaaa", self.m_nSelectIdx)
    if self.m_nSelectIdx > 0 then 
        local imageOld = self.m_tabBox[self.m_nSelectIdx]
        local infoOld = self.m_tabList[self.m_nSelectIdx]
        -- if nil ~= infoOld  and nil ~= imageOld and not view:cellAtIndex(self.m_nSelectIdx -1) then
        --     local image = string.format("introduction/introduction_btn2_%d.png", infoOld.KindID)
        --     imageOld:loadTexture(image)
        -- end
        local cell = view:cellAtIndex(self.m_nSelectIdx -1)
        if cell then
            local imageOld = cell:getChildByTag(1)
            if nil ~= imageOld then 
                local image = string.format("introduction/introduction_btn2_%d.png", infoOld.KindID)
                imageOld:loadTexture(image)
            end
        end
    end
    self.m_nSelectIdx = index +1

end

-- 子视图大小
function PlazaIntroductionLayer:cellSizeForTable(view, idx)
        return view:getViewSize().width, 90
end

function PlazaIntroductionLayer:tableCellAtIndex(view, idx)
    local cell = view:dequeueCell()
    if not cell then        
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end
    
    --获取游戏ID
    local info = self.m_tabList[idx +1]
    if nil == info then
        return cell
    end
    dump(info, "aaaaa", 10)

    -- local selectedEvent = function (sender,eventType)
    --     self:onCheckBoxSelectedEvent(sender:getTag(),sender)
    -- end
    local imageNormal = string.format("introduction/introduction_btn2_%d.png", info.KindID)
    local imagePress = string.format("introduction/introduction_btn1_%d.png", info.KindID)
    local imagePath = imageNormal
    if idx +1 == self.m_nSelectIdx then
        imagePath = imagePress
    end

    if cc.FileUtils:getInstance():isFileExist(imagePath) then
        local image = ccui.ImageView:create(imagePath)
        cell:addChild(image)  --添加到图层
        image:setSwallowTouches(false)
        image:setPosition(cc.p(view:getViewSize().width/2, 45))   --坐标
        image:setTag(1)
        self.m_tabBox[idx +1] = image
        -- local checkBox = ccui.CheckBox:create()
        -- checkBox:loadTextures(imageNormal,
        --             imagePress,
        --             imagePress,
        --             imageNormal,
        --             imageNormal)
        -- checkBox:setPosition(cc.p(view:getViewSize().width/2, 45))   --坐标
        -- checkBox:setTag(idx +1)
        -- checkBox:addEventListenerCheckBox(selectedEvent)  --注册事件
        -- cell:addChild(checkBox)  --添加到图层
        -- if self.m_nSelectIdx == idx +1 then
        --     checkBox:setSelected(true)
        -- end
        -- checkBox:setSwallowTouches(false)

        -- self.m_tabBox[idx +1] = checkBox
    end

    return cell
end

-- 子视图数目
function PlazaIntroductionLayer:numberOfCellsInTableView(view)
    return self.m_nListCount
end

function PlazaIntroductionLayer:scrollViewDidScroll(view)

end

function PlazaIntroductionLayer:getEmptySpace( sz )

end

return PlazaIntroductionLayer