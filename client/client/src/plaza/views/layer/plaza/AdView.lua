 --[[   
    游戏列表左侧的广告
    实现细节:
    使用 scrollView 实现裁剪
	Create by ashin. 2018-10-02
--]]
--local CommonHelper = require('app.fw.common.CommHelper')
local AdView = class("AdView")
local scheduler = appdf.req(appdf.EXTERNAL_SRC .. "scheduler")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local ViewSize = cc.size(301, 480)
local PageSize = cc.size(301, 480)
local MarkSize = 16 
local ClickSize = 3
function AdView:create(...)
    local layer = cc.Layer:create()
    layer:setAnchorPoint(cc.p(0.5, 0.5))
    layer:setContentSize(PageSize)

    layer:onNodeEvent("exit", handler(self, self.close))

    local adView = cc.CSLoader:createNode("dt/AdView.csb")
    layer:addChild(adView)
    -- adView:setPositionX(142)
    -- adView:setPositionY(214)

    local adPanel = adView:getChildByName("adPanel")
    self.markContainer = adView:getChildByName("markContainer")
    local scrollNode = cc.ScrollView:create()
    scrollNode:setPosition(cc.p(0, 0))
    scrollNode:setContentSize(PageSize)
    scrollNode:setAnchorPoint(cc.p(0, 0))
    scrollNode:setContentOffset(cc.p(0, 0))
    scrollNode:setViewSize(PageSize)
    scrollNode:setTouchEnabled(false)
    scrollNode:setBounceable(false)
    adPanel:addChild(scrollNode, 1)
    self.adPanel = adPanel
    -- 容器节点
    local target = cc.Node:create()
    scrollNode:addChild(target)

    self._scrollContainer = target
    self._scrollNode = scrollNode
    self._scrollNode:getContainer():setLocalZOrder(-1)

	-- 页数
	self._pageCount = 2 
	-- 当前页数索引
	self._currentPageIndex = 1
	-- 广告图容器精灵
    self._adNodes = {} 
    -- 页码精灵
    self._markOnSprites = {}   
    -- 页码精灵
    self._markOffSprites = {}

    self:initTouchListener()
    self:reflashUI()
    self:restartReturnShow()

    return layer
end

function AdView:reflashUI( ... )
	self:cleanPages()
	self._pageCount = 2
	local lenth = 2

	for i = 1, lenth do
		-- 创建广告图
	    self._adNodes[i] = cc.Node:create()
	    self._scrollContainer:addChild(self._adNodes[i])

	    -- 创建标志
        self._markOnSprites[i] = cc.Sprite:create("dt/image/AdView/hall_ad_mark_selected.png")
        self._markOffSprites[i] = cc.Sprite:create("dt/image/AdView/hall_ad_mark_unselected.png")

        if self._markOnSprites[i] then
            self._markOnSprites[i]:setPosition(
                cc.p(
                    150 + (-self._pageCount / 2 + 0.5 + i - 1) * MarkSize,
                    0
                )
            )
            self.markContainer:addChild(self._markOnSprites[i])             
        end

        if self._markOffSprites[i] then
            self._markOffSprites[i]:setPosition(
                cc.p(
                    150 + (-self._pageCount / 2 + 0.5 + i - 1) * MarkSize,
                    0
                )
            )
            self.markContainer:addChild(self._markOffSprites[i])               
        end

	    self._adNodes[i]:setPosition(
	        cc.p(
	            PageSize.width * ((i-1) + 0.5) + 1,
	            PageSize.height / 2
	        )
	    )
	end

	self:onFinishDownloadAdImage()
	self:setCurrentPageIndex(1)
end

-- 下载回调完成
function AdView:onFinishDownloadAdImage(...)
	local lenth = 2
	for index=1, lenth do
        self._adNodes[index]:removeAllChildren(true);
        local sprite = nil
        sprite = cc.Sprite:create("dt/image/AdView/ad_banner" .. index .. ".png")
        if sprite then
           self._adNodes[index]:addChild(sprite);
       end
	end
end

-- 设置选中页
function AdView:setCurrentPageIndex( pageIndex )
	-- 页数小于2时,不支持翻页
    if self._pageCount <= 1 then
        return
    end

    local oldPageIndex = self._currentPageIndex;
    local newPageIndex = pageIndex
    local spriteIndex = self:toNormalIndex(newPageIndex)
    local newSprite = self._adNodes[spriteIndex]

	-- 将下一页的精灵移动到正确位置
	if newSprite ~= nil then
        if tolua.isnull(newSprite) then
            dump("ashin is so bad")
            self:stopByReturnShow()
            return
        else
           newSprite:setPosition(
                cc.p(
                    PageSize.width * (newPageIndex - 1 + 0.5) + 1,
                    PageSize.height / 2
                )
            )
        end
	end

	-- 滚动 scrollView
	if newPageIndex ~= oldPageIndex then
		self._scrollNode:setContentOffsetInDuration(cc.p(-(newPageIndex-1) * ViewSize.width, 0), 0.15);
	end

	-- 更新当前页数
    self._currentPageIndex = newPageIndex

 	-- 更新 mark
 	for i = 1, self._pageCount do
 		if self._markOnSprites[i] then
 			self._markOnSprites[i]:setVisible(i == self:toNormalIndex(self._currentPageIndex))
 		end

 		if self._markOffSprites[i] then
 			self._markOffSprites[i]:setVisible(i ~= self:toNormalIndex(self._currentPageIndex))
 		end
 	end
end

-- 根据页数转为合法索引值
function AdView:toNormalIndex( index )
    index = index % self._pageCount
    if index <= 0 then
    	index = self._pageCount + index
    end

    return index
end

-- 清除所有内容页
function AdView:cleanPages( ... )
	local len = table.getn(self._adNodes)
	for i=1, len do
        if self._adNodes and self._adNodes[i] then
        	self._adNodes[i]:removeFromParent()
        end

        if self._markOnSprites[i] then
        	self._markOnSprites[i]:removeFromParent()
        end

        if self._markOffSprites[i] then
        	self._markOffSprites[i]:removeFromParent()
        end
	end

    
    self._adNodes = {}
    self._markOnSprites = {}
    self._markOffSprites = {}

    self._pageCount = 2;
    self._currentPageIndex = 1;
end

-- 初始化点击监听
function AdView:initTouchListener( )
	local that = self.adPanel
	self.adPanel:setTouchEnabled(true)
    self.adPanel:onTouch(function(event)
        function onTouchBegan(touch, event) 
        	self:stopByReturnShow()
        	local pos = touch:getTouchBeganPosition()  
        	local touchLocation = that:convertToNodeSpace(pos)
            if touchLocation.x > 0 and touchLocation.x < that:getContentSize().width 
            	and touchLocation.y > 0 and touchLocation.y < that:getContentSize().height then 
                self.touchDown = touchLocation
                return true
            end
            return false
        end  
        function onTouchMoved(touch, event)   
            return false
        end  
        function onTouchEnded(touch, event)   
        	local pos = touch:getTouchEndPosition() 
            local touchLocation = that:convertToNodeSpace(pos)
            if touchLocation.x > self.touchDown.x + ClickSize then
                self:prePage()
            elseif touchLocation.x < self.touchDown.x - ClickSize then
                self:nextPage()
            else
                local adIndex = self:toNormalIndex(self._currentPageIndex)
              	dump("ashin say adIndex:"..adIndex)
              	self:onBtnBgClicked(adIndex)
            end
            self:startByReturnShow()
            return false
        end

      function onTouchCancel(touch, event)   
            local pos = touch:getTouchEndPosition() 
            local touchLocation = that:convertToNodeSpace(pos)
            if touchLocation.x > self.touchDown.x + ClickSize then
                self:prePage()
            elseif touchLocation.x < self.touchDown.x - ClickSize then
                self:nextPage()
            else
                local adIndex = self:toNormalIndex(self._currentPageIndex)
                dump("ashin say adIndex:"..adIndex)
                self:onBtnBgClicked(adIndex)
            end
            self:startByReturnShow()
            return false
        end
        print(event.name,"initTouchListener")
        if event.name == "began" then
            onTouchBegan(event.target, event)
        elseif event.name == "moved" then
            onTouchMoved(event.target, event)
        elseif event.name == "ended" then
            onTouchEnded(event.target, event)
        elseif event.name == "cancelled" then
            onTouchCancel(event.target, event)
        end
    end)
end

-- 翻到下一页
function AdView:nextPage( ... )
	 self:setCurrentPageIndex(self:getCurrentPageIndex() + 1)
end

-- 翻到上一页
function AdView:prePage( ... )
	 self:setCurrentPageIndex(self:getCurrentPageIndex() - 1)
end

-- 获取页总数
function AdView:getPageCount( ... )
	return self._pageCount
end

-- 获取当前所在页
function AdView:getCurrentPageIndex( ... )
	return self._currentPageIndex
end

-- 背景按钮回调
function AdView:onBtnBgClicked( index )
    if index%2 ~= 0 then
        ExternalFun.playClickEffect()
        MultiPlatform.getInstance():copyToClipboard(strWebsite)
        FloatMessage.getInstance():pushMessage("STRING_204")
        --[[
        --先停止正在播放的复制官网音效
        local dtCommonModel = cc.loaded_packages.DTCommonModel
        local copyAudioID = dtCommonModel:getCopyAudioID()
        if copyAudioID then
            -- body
            cc.loaded_packages.KKMusicPlayer:stopEffect(copyAudioID)
        end
        local musicID = cc.loaded_packages.KKMusicPlayer:playEffect("res/dt/sound/copyWebSit.mp3")
        local dtCommonModel = cc.loaded_packages.DTCommonModel
        dtCommonModel:setCopyAudioID(musicID)


        local FloatBar = require("app.games.dt.hall.FloatBar")
        local bar = FloatBar.new("官方网址已复制，请转发好友哦~")
        bar:setPosition(display.center)
        display.getRunningScene():addChild(bar)
        local gwUrl = "http://95077.com"
        copyToClipboard(gwUrl)
        --]]
    end
end

function AdView:restartReturnShow( ... )
    self:stopByReturnShow()
    self:startByReturnShow()
end

-- 开始自动翻页
function AdView:startByReturnShow( ... )
	local interVal = 5
	if self.schedulerHandle == nil then
		self.schedulerHandle = scheduler.scheduleGlobal(handler(self, self.nextPage), interVal)
	end
end

-- 停止自动翻页
function AdView:stopByReturnShow( ... )
	if self.schedulerHandle ~= nil then
		scheduler.unscheduleGlobal(self.schedulerHandle)
		self.schedulerHandle = nil
	end
end

function AdView:close()
    self:stopByReturnShow()
end
return AdView