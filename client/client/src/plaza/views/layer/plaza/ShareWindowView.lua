local CommonNetImageView = require('app.fw.common.CommonNetImageView')
local CommonHelper = require('app.fw.common.CommHelper')
local DTCommonWords = require('app.games.dt.common.DTCommonWords')
local FloatBar = require('app.games.dt.hall.FloatBar')
local BaseFullLayer = require('app.fw.common.BaseFullLayer')
local ShareWindowView = class('ShareWindowView', BaseFullLayer)
ShareWindowView.RESOURCE_FILENAME = 'dt/ShareWindow.csb'
local cellSize = cc.size(889, 90)

local TAB_TYPE = {
    NONE = 0,
    SHARE = 1,
    REWARD = 2,
    RULE = 3,
    RANK = 4
}
local logic = cc.loaded_packages.DTHallLogic
local reqDetailItemIdx = -1
local function fmtDate(timestamp)
    local date = os.date('*t', timestamp or 0)
    return date.year .. '-' .. date.month .. '-' .. date.day
end

-- 创建tableView
uiTableView = {
    create = function(panelRef, cloneCell)
        local size = panelRef:getContentSize()
        local view = cc.TableView:create(size)
        view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        view:setDelegate()
        view:setVerticalFillOrder(0)

        --设置tablecell大小
        view:registerScriptHandler(function(table, idx) return cellSize.width, cellSize.height end, cc.TABLECELL_SIZE_FOR_INDEX)
        --设置tablecell数量
        view:registerScriptHandler(function(table, idx) return panelRef.max end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
        --点击tablecell
		-- view:registerScriptHandler(function(table, cell)
		-- 	print("??????????")
        --     if panelRef.holdCellOn and math.abs(panelRef.holdCellOn - os.clock()) < 1 then
        --         return
        --     end
        --     panelRef.holdCellOn = os.clock()

        --     cell:onCellClick()
        -- end, cc.TABLECELL_TOUCHED)
        --创建idx位置的tablecell
        view:registerScriptHandler(function(table, idx)
            local cell = table:dequeueCell()
            if not cell then
                cell = rankInfoItem.new(cloneCell)
            end
            cell:setIdx(idx)
            cell:setInfo(panelRef.list[idx + 1], panelRef.curTypeRank, idx)
            return cell
        end, cc.TABLECELL_SIZE_AT_INDEX)
        panelRef:addChild(view)

        return view
    end,
}

local function tips(msg)
    msg = msg or ''
    local bar = FloatBar.new(msg)
    bar:setPosition(display.center)
    cc.Director:getInstance():getRunningScene():addChild(bar)
end

function ShareWindowView:initUI(...)
    ShareWindowView.super.initUI(self, ...)
	require('app.fw.common.PopupEffect'):initBlur(
		self,
		self.resourceNode_:getChildByName('center'),
		self.resourceNode_:getChildByName('mask'),
		true
	)
	self.seletcBtns = {
		self.MyShare,
		self.ShareDetail,
		self.ShareClass,
		self.ShareRank,
	}
	self.datas = {}
	self.view = {}
	self.view.emptys = {}
	self.view.contents = {}
    self.curTab = TAB_TYPE.NONE
	for k, v in pairs(TAB_TYPE) do
        
        local emptyNode = self['empty_' .. v]
        if emptyNode then
            emptyNode:hide()
            emptyNode.type = v
            self.view.emptys[v] = emptyNode
        end
        local contentNode = self['panel' .. v]
        if contentNode then
            contentNode.type = v
            contentNode:hide()
            self.view.contents[v] = contentNode
        end
    end

	-- logic:reqShareSysData('getFenx_money', handler(self, self.updateShareNew))


	self.MyShare:setEnabled(false)
	for i,button in ipairs(self.seletcBtns) do
		local btn = self.seletcBtns[i]
		dump(i,"ashin index")
		btn.type = i
		btn:addClickEventListener(handler(self, self.onChangeTab))
	end


    local data = cc.loaded_packages.CommonModel:getCustomerInfo()

    if data then
        local dataTable = json.decode(data)
        local qqString = string.format("财富QQ:%s",dataTable.kf.cfqq or 0)
        self.qqCode:setString(qqString)
    end
    
	self:initTableView()
end

function ShareWindowView:onChangeTab( sender )
    for i,button in ipairs(self.seletcBtns) do
		local btn = self.seletcBtns[i]
		btn:setEnabled(sender.type ~= btn.type)
		self['panel' .. i]:setVisible(sender.type == btn.type)
		btn:getChildByName("btntext_unSelected"):setVisible(sender.type ~= btn.type)
		btn:getChildByName("btntext_Selected"):setVisible(sender.type == btn.type)
	end

    local curType = sender.type
    self.curTab = curType
    local data = self.datas[curType]
    if data and 0 < #data or (TAB_TYPE.RULE == curType or TAB_TYPE.SHARE == curType) then
        self:showContent(curType) 
    else
        self:showEmpty(curType)
    end
    if not data then
        if sender.type == 1 then
            logic:reqShareSysDataNew('getFenx_money', handler(self, self.updateShareNew))
        elseif sender.type == 2 then
            logic:reqShareSysDataNew('getDayFenx_money', handler(self, self.updateRewardNew))
        elseif sender.type == 4 then
            logic:reqShareSysDataNew('getQueryList', handler(self, self.updateRankWeekNew))
        end
    end
end

function ShareWindowView:showEmpty(type)
    if TAB_TYPE.NONE ~= type then
        self:showContent(TAB_TYPE.NONE)
    end
    print("typelc",type)
    for i, v in pairs(self.view.emptys) do
        if type == v.type then
            v:show()
        else
            v:hide()
        end
    end
end

function ShareWindowView:showContent(type)
    if TAB_TYPE.NONE ~= type then
        self:showEmpty(TAB_TYPE.NONE)
    end
    for i, v in pairs(self.view.contents) do
        if type == v.type then
            v:show()
        else
            v:hide()
        end
    end
end



function ShareWindowView:updateRewardNew(data)
    if not self or self.lvReward == nil then
        return
    end
    self.lvReward:removeAllItems()
    self.datas[TAB_TYPE.REWARD] = data
    for i, v in ipairs(data) do
        local itemNode = self.listItemReward:clone()
		UIHelper.parseCSDNode(itemNode, itemNode)
		
		if i%2 == 0 then
			itemNode.bG:loadTexture("dt/image/ShareWindow/qmdl_026.png")
		else
			itemNode.bG:loadTexture("dt/image/ShareWindow/qmdl_027.png")
		end
        itemNode.reward:setString(v.balance)
        itemNode.date:setString(fmtDate(v.create_time))
        self.lvReward:pushBackCustomItem(itemNode)
        itemNode:addClickEventListener(handler(self, self.onClickRewardDetail))
        itemNode.data = v
        itemNode.idx = i - 1
        if 1 == i then
            self:onClickRewardDetail(itemNode)
        end
    end
    if TAB_TYPE.REWARD == self.curTab then
        if 0 < #data then
            self:showContent(TAB_TYPE.REWARD)
        else
            self:showEmpty(TAB_TYPE.REWARD)
        end
    end
end

function ShareWindowView:onClickRewardDetail(sender)
    if 0 <= reqDetailItemIdx then
        return
    end
    if not sender.data or not sender.data.create_time then
        return
    end
    local rewardData = self.datas[TAB_TYPE.REWARD]
    if not rewardData then
        return
    end
    local items = self.lvReward:getItems()
    local exist = false
    for k, v in pairs(items) do
        if v.isDetail then
            self.lvReward:removeChild(v, true)
            exist = true
        end
    end
    if exist then
        if expandingRewardItem then
            local arrow = expandingRewardItem:getChildByName('Image_80')
            if arrow then
                arrow:setRotation(0)
            end
            expandingRewardItem = nil
        end
        return
    end
    reqDetailItemIdx = sender.idx
    local itemData = rewardData[reqDetailItemIdx + 1]
    if itemData and itemData.detail then
        self:onResRewardDetail(itemData.detail)
        return    
    end
    logic:reqShareSysDataNew('getDayFenx_balance', handler(self, self.onResRewardDetail),
    'create_time=' .. sender.data.create_time,sender.data.create_time)
    performWithDelay(self, function()
		reqDetailItemIdx = -1
	end, 5)
end

function ShareWindowView:onResRewardDetail(data)
    if not self or self.datas == nil then
        return
    end
    self:stopAllActions()
    local rewardData = self.datas[TAB_TYPE.REWARD]
    if not rewardData or 0 > reqDetailItemIdx then
        return
    end
    rewardData[reqDetailItemIdx + 1] = rewardData[reqDetailItemIdx + 1] or {}
    rewardData[reqDetailItemIdx + 1].detail = data

    local itemNode = self.lvReward:getItem(reqDetailItemIdx)
    if itemNode then
        expandingRewardItem = itemNode
        local arrow = itemNode:getChildByName('Image_80')
        if arrow then
            arrow:setRotation(180)
        end
    end

    local startIdx = reqDetailItemIdx + 1
    reqDetailItemIdx = -1
    local titleNode = self.detailTitle:clone()
    titleNode.isDetail = true
    self.lvReward:insertCustomItem(titleNode, startIdx)
    for i, v in ipairs(data) do
        local itemNode = self.listItemDetail:clone()
        itemNode.isDetail = true
        UIHelper.parseCSDNode(itemNode, itemNode)
        
        itemNode.nickname:setString(v.userName)
        itemNode.detailCanGet:setString(v.balance)
        itemNode.todayGongxian:setString(v.duty_number)
        startIdx = startIdx + 1
        self.lvReward:insertCustomItem(itemNode, startIdx)
    end
end

function ShareWindowView:updateShareNew(data)
    if (not self) or data == nil or self.datas == nil then
        return
	end
    dump(data,"updateShareNew")
    self.datas[TAB_TYPE.SHARE] = data
	self.mainData = data
	if data.ling_money then
        self.lingqu:setEnabled(0 < tonumber(data.ling_money))
	end
	
	local qrcodeApi = 'http://qr.liantu.com/api.php?text='
    if data and data.www then
        print(data.www,"data.www")
        local rid = cc.loaded_packages.CommonModel:getRoleID()
        local channel = getChannelID()
        -- local url = data.www .. '?type1=2%26' .. 'rid=' .. rid .. '%26channel=' .. channel
        local url = data.www
		self.mainData.shareUrl = url
		local Lang = require('app.games.dt.common.DTCommonWords')
		self._shareFn = wxShareImage
        print("rul =",url)
        self.qrImg = qrcodeApi .. url
        local img = CommonNetImageView:create(qrcodeApi .. url, self.qrcodeNode, cc.size(230, 230))
        self.qrcodeNode:removeAllChildren()
        self.qrcodeNode:addChild(img)
	end
	
	self.text1:setString(data.yday_all_balance and data.yday_all_balance or "--")
	self.text2:setString(data.under_rid and data.under_rid or "--")
	self.text3:setString(data.other_rid and data.other_rid or "--")
	self.text4:setString(data.yday_under_balance and data.yday_under_balance or "--")
    self.text5:setString(data.yday_other_balance and data.yday_other_balance or "--")
	self.text6:setString(data.history_all_balance and data.history_all_balance .. "元" or "--")
    self.text7:setString(data.ling_money and data.ling_money .. "元" or "--")
end
function ShareWindowView:onEnter( ... )
	-- body
	ShareWindowView.super.onEnter(self,...)
	--先停止正在播放的复制官网音效
	local dtCommonModel = cc.loaded_packages.DTCommonModel
	local copyAudioID = dtCommonModel:getCopyAudioID()
	if copyAudioID then
		-- body
		cc.loaded_packages.KKMusicPlayer:stopEffect(copyAudioID)
	end
	self.musicID = cc.loaded_packages.KKMusicPlayer:playEffect("res/dt/sound/share_audio.mp3")
end

function ShareWindowView:onExit( ... )
	
	ShareWindowView.super.onExit(self, ...)
	if self.musicID  then
		-- body
		cc.loaded_packages.KKMusicPlayer:stopEffect(self.musicID)
		self.musicID = nil
	end
	
end

function ShareWindowView:initListener()
	-- addNodeListener(self, "recvUpdateMoneyNotice", handler(self, self.updateMoney))
	self:onChangeTab(self.seletcBtns[1])
	self.closeBtn:addClickEventListener(handler(self, self.onClose))
	self.lingqu:addClickEventListener(handler(self, self.onClickGetReward))
	self.qrcodeImg:addClickEventListener(handler(self, self.onOpenDetail))
	self.yybz:addClickEventListener(handler(self, self.popHelpView))
    self.tqjl:addClickEventListener(handler(self, self.popRecordView))
    self.copyQQ:addClickEventListener(handler(self, self.copyTGQQ))
	self.wxhaoyou:addClickEventListener(function()
        self:onShare(0)
    end)
    self.pyquan:addClickEventListener(function()
        self:onShare(0)
    end)

    -- 监听分享结果
    addNodeListener(self, "event_wxshare", handler(self, self.onEventWxShare))
end


function ShareWindowView:copyTGQQ()

    local data = cc.loaded_packages.CommonModel:getCustomerInfo()
    if data then
        local dataTable = json.decode(data)
        if dataTable.kf.cfqq then
            if CCApplication.openURL then
                if device.platform ~= "ios" then
                    CCApplication:sharedApplication():openURL(string.format("http://wpa.qq.com/msgrd?v=3&uin=%s&site=qq&menu=yes",dataTable.kf.cfqq))
                else
                    local kl = "mqqwpa://im/chat?chat_type=wpa&uin=%s&version=1&src_type=web&web_src=oicqzone.com"
                    local content = string.format(kl,dataTable.kf.cfqq)
                    CCApplication:sharedApplication():openURL(content)
                end
            end
        end
    end


end


-- 分享SDK返回结果事件
function ShareWindowView:onEventWxShare(event)
    local eventData = event._userdata
    local wxErrCode = tonumber(eventData[2])
    if wxErrCode == 0 then
        -- 请求领奖
        TalkingDataGA:onEvent("share_success", {step="2"})
        cc.loaded_packages.DTHallLogic:requestGetShareRewardReq(1)
    elseif wxErrCode == -2 then
        HelpMode.showWoring("已经取消分享！")
    end
end

function ShareWindowView:popRecordView()
	local view = self:getApp():createLayer("app.games.dt.hall.ShareRecordView")
    self:addChild(view)
end

function ShareWindowView:popHelpView()
	local view = self:getApp():createLayer("app.games.dt.hall.ShareWindowHelp")
    self:addChild(view)
end

function ShareWindowView:onShare(type)
    if self._shareFn and self.qrImg  then
        pcall(function() showLoadingView(LoadingViewType.ENTER_GAME, nil, true) end)
        local fileName = urlDecodeMD5(self.qrImg)
        local old_Name =  cc.UserDefault:getInstance():getStringForKey(fileName,"empty")
        if old_Name ~= "empty" then  
            performWithDelay(self,function()  
                local qrCodePath = cc.FileUtils:getInstance():getWritablePath().."ns/"..old_Name
                local finalImagePath = createImageFileWithTwoImage("dt/image/share_sys/bg.jpg",qrCodePath,720,1280)
                self._shareParams = {finalImagePath}
                performWithDelay(self,function()  
                    pcall(function() hideLoadingView() end)
                    self._shareFn(type, unpack(self._shareParams))
                end,0.01)
            end,0.01)
        else
            pcall(function() hideLoadingView() end)
        end
    end
end



function ShareWindowView:onOpenDetail()
    local view = self:getApp():createLayer("app.games.dt.hall.ShareSysViewDetail")
    self:addChild(view)
end

function ShareWindowView:onClickGetReward()
    logic:reqShareSysDataNew('getDayFenx_enter', handler(self, self.onResGetReward))
    self.lingqu:setEnabled(false)
end

function ShareWindowView:onResGetReward(data)
    if not self then
        return
    end
    dump(data,"testLC")
    tips(data.msg)
    if  data.code then
        logic:reqShareSysDataNew('getFenx_money', handler(self, self.updateShareNew))
        logic:reqShareSysDataNew('getDayFenx_money', handler(self, self.updateRewardNew))
        -- if self.view.tabs[self.curTab] then
        --     self:onClickTab(self.view.tabs[self.curTab])
        -- end
    end
end

function ShareWindowView:onBack()
    self:onClose()
end


function ShareWindowView:updateRankWeekNew(data)
    if not self or self.datas == nil then
        return
    end
	self.datas[TAB_TYPE.RANK] = data
	if TAB_TYPE.RANK == self.curTab then
        if 0 < #data then
            self:showContent(TAB_TYPE.RANK)
        else
            self:showEmpty(TAB_TYPE.RANK)
        end
    end
	self.rankList.max = #data
    self.rankList.list = data
    self.myTableView:reloadData()
end

function ShareWindowView:initTableView()
    self.cellBtn:retain()
	-- self.cellBtn:removeFromParent()
    local view = uiTableView.create(self.rankList, self.cellBtn)
    self.myTableView = view
end

-- cell
rankInfoItem = class("rankWeekItem", function() return cc.TableViewCell:new() end)
local rank_format = "dt/image/rank/tjylc_phb_hg%01d.png"
itemFunc = {
    ctor = function(this, cloneCell)
        local node = cloneCell:clone()
        this.root = node
        this:addChild(node)
        node:setPosition(cc.p(cellSize.width * 0.5, cellSize.height * 0.5))
        UIHelper.parseCSDNode(this, this.root)
    end,
    --点击响应
    onCellClick = function(this)
        -- cc.loaded_packages.DTHallLogic:requestPlayerBaseInfo(this.myRid, 'DTRankPage')
    end,
    --设置信息
    setInfo = function(this, info, typeRank, idx)
        if this.itemBg then
            if idx%2 == 0 then
                this.itemBg:loadTexture("dt/image/ShareWindow/zcm_phb_item_bg.png")
            else
                this.itemBg:loadTexture("dt/image/ShareWindow/zcm_phb_item_bg2.png")
            end
        end

        -- this.myRid = info.rid
        local rank = idx +1
		if type(rank) == "number" and 0 < rank and 50 >= rank then
			print("yes=",idx)
            local bol = rank <= 3 and 1 <= rank
            this.rankSpr:setVisible(bol)
            this.rankLabel:setVisible(not bol)
            if this.noRank then this.noRank:hide() end
            if bol then
                this.rankSpr:loadTexture(string.format(rank_format, rank))
                this.numBgImg:hide()
            else
                this.numBgImg:show()
                this.rankLabel:setString(tostring(rank))
                this.rankLabel:setScale(0.8)
            end
		else
			print("no=",idx)
            this.rankSpr:hide()
            this.rankLabel:hide()
            if this.noRank then
                this.noRank:show()
                this.numBgImg:hide()
            end
        end

        -- local desc = info.desc
        -- if desc == nil or #desc == 0 or string.find(desc, "%S") == nil then
        --     desc = DTCommonWords.NO_PERSON_DESC
        -- end
        -- this.headImg:removeAllChildren()
        local nickname = info.userName
        CommonHelper:loadName(this.name, nickname, 6)
        -- CommonHelper:loadName(this.signDes, desc, 15)
        -- CommonHelper:loadNumber(self.userCoinsText, userInfo.gold or 0, false) -- 金币
        local rankValue = math.floor(info.balance)
        if 0 > rankValue then
            rankValue = 0
        end
        this.goldBmf:setString(rankValue .. '')
    end,
}
for k, v in pairs(itemFunc) do
    rankInfoItem[k]    = v
end


return ShareWindowView
