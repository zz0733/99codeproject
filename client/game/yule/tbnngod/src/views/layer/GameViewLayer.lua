--
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")
local FloatMessage              = cc.exports.FloatMessage

local module_pre = "game.yule.tbnngod.src"
local cmd = appdf.req(module_pre .. ".models.CMD_Game")
local Define = appdf.req(module_pre .. ".models.Define")
local GameRoleItem = appdf.req(module_pre .. ".views.layer.GameRoleItem")
local HeadSprite = require(appdf.EXTERNAL_SRC .. "HeadSprite")
local CardSprite = appdf.req(module_pre .. ".views.layer.gamecard.CardSprite")
local CardsNode = appdf.req(module_pre .. ".views.layer.gamecard.CardsNode")
local GameLogic = appdf.req(module_pre .. ".models.GameLogic")
local GameResultLayer = appdf.req(module_pre .. ".views.layer.GameResultLayer")
local SettingLayer = appdf.req(module_pre .. ".views.layer.SettingLayer")
local GameRuleLayer = appdf.req(module_pre .. ".views.layer.GameRuleLayer")

local Poker = appdf.req(module_pre .. ".views.layer.gamecard.Poker")

local TAG_ENUM = Define.TAG_ENUM
local TAG_ZORDER = Define.TAG_ZORDER

local GAME_STATE = {
	BullWait = 0 , -- 客户端自己
	BullReadyStart = 1, --准备阶段
	BullDealCards = 2, --发牌
	BullShowCards = 3, --展示牌
	BullSettle = 4, --结算
}

local _ = {}
local GameViewLayer = class("GameViewLayer",function(scene)
        local gameViewLayer = display.newLayer()
    return gameViewLayer
end)

function GameViewLayer:ctor(scene)
print("on enter -----------===========----------    GameViewLayer")
    --注册node事件
    ExternalFun.registerNodeEvent(self)
    self._scene = scene

    self:initAllVar()
    self:initCCB()
end

--初始化所有变量
function GameViewLayer:initAllVar()
    --初始化节点
    self.m_rootBg       = nil   
    self.m_roomLogo     = nil
    self.m_roomDifen    = nil
    self.m_tableName    = nil
    self.m_easyPeilv    = nil
    self.m_panelPlayer  = nil
    self.m_btnShowCard  = nil
    self.m_btnStart     = nil
    self.m_panelAnimation   = nil
    self.m_panelCoin        = nil
    self.m_imageWaitnext    = nil
    self.m_tabPlayerNode = {}   --玩家头像等节点
    self.m_tabCardNode = {}     --玩家牌节点
    self.m_btnRobot     = nil
    self.m_btnShop      = nil
    self.m_btnMenu      = nil
    self.m_panelCaijin  = nil
    self.m_panelMenu    = nil
    self.m_btnExit      = nil
    self.m_btnSetting   = nil
    self.m_btnChangeRoom= nil
    self.m_btnHelp      = nil
    --标志位
    self.gameState = GAME_STATE.BullWait  --游戏状态  
    self.m_pAutoState = false   --机器人
    self.m_pMenuState = false   --菜单界面展示与否标志
    self.m_unitMoney = 0
    self.m_initMoney = 0
    self.m_niuBeilv = {}
    self.m_playerTable = {}
end
--初始化CSB及所有节点
function GameViewLayer:initCCB()
    print("EnterGame:通比牛牛       GameViewLayer:initCSB")

    local rootLayer, csbNode = ExternalFun.loadRootCSB("tongbiniuniu/TongBiNiuNiuScene.csb", self)
    self.m_rootWidget = csbNode
    --iphoneX适配
    if LuaUtils.isIphoneXDesignResolution() then
        local width_ = yl.WIDTH - display.size.width
        self.m_rootWidget:setPositionX(self.m_rootWidget:getPositionX() - width_/2)
    end
    self.m_rootBg       = self.m_rootWidget:getChildByName("Image_bg")    
    self.m_roomLogo     = self.m_rootBg:getChildByName("Image_208")
    self.m_roomDifen    = self.m_roomLogo:getChildByName("text_betCoinLabel")  --房间底分
    self.m_tableName    = self.m_roomLogo:getChildByName("text_tableName")     --房间名字桌号
    self.m_easyPeilv    = self.m_roomLogo:getChildByName("Text_73")            --房间赔率显示
    self.m_panelPlayer  = self.m_rootBg:getChildByName("panel_playerPanel")
    self.m_btnShowCard  = self.m_panelPlayer:getChildByName("button_showCardBtn")       --摊牌按钮
    self.m_btnStart     = self.m_panelPlayer:getChildByName("button_startBtn")          --开始按钮
    self.m_panelAnimation   = self.m_panelPlayer:getChildByName("panel_animationPanel") --动画层
    self.m_panelCoin        = self.m_panelPlayer:getChildByName("panel_coinPanel")      --金币动画层
    self.m_imageWaitnext    = self.m_panelPlayer:getChildByName("image_showNextRound")  --等待下一局
    for i = 1,6 do
        local playerNode = self.m_panelPlayer:getChildByName("fileNode_player_"..i)
        table.insert(self.m_tabPlayerNode,playerNode)

        local cardNode = self.m_panelPlayer:getChildByName("fileNode_playerCard_"..i)
        table.insert(self.m_tabCardNode,cardNode)
    end
    self.m_btnRobot     = self.m_rootBg:getChildByName("button_autoBtn")                --机器人按钮
    self.m_btnShop      = self.m_rootBg:getChildByName("button_buy"):setVisible(false)  --商城按钮（隐藏）
    self.m_btnMenu      = self.m_rootBg:getChildByName("button_back")                   --菜单按钮
    self.m_panelCaijin  = self.m_rootBg:getChildByName("Image_64"):setVisible(false)    --彩金池（暂时没有需要隐藏）
    self.m_panelMenuBack= self.m_rootBg:getChildByName("panel_backMenu")                --菜单返回监听层
    self.m_panelMenu    = self.m_panelMenuBack:getChildByName("image_settingPanel")     --菜单panel
    self.m_btnExit      = self.m_panelMenu:getChildByName("button_exit")            --退出按钮
    self.m_btnSetting   = self.m_panelMenu:getChildByName("button_setting")         --设置按钮
    self.m_btnChangeRoom= self.m_panelMenu:getChildByName("button_BtnChangeRoom")   --换桌按钮
    self.m_btnHelp      = self.m_panelMenu:getChildByName("button_helpX")           --帮助按钮
    --添加按钮监听
    self.m_btnShowCard:addClickEventListener(handler(self, self.onShowCardClicked))
    self.m_btnStart:addClickEventListener(handler(self, self.onStartClicked))
    self.m_btnRobot:addClickEventListener(handler(self, self.onRobotClicked))
    self.m_btnMenu:addClickEventListener(handler(self, self.onMenuClicked))
    self.m_panelMenuBack:addClickEventListener(handler(self, self.onMenuClicked))
    self.m_btnExit:addClickEventListener(handler(self, self.onExitClicked))
    self.m_btnSetting:addClickEventListener(handler(self, self.onSettingClicked))
    self.m_btnChangeRoom:addClickEventListener(handler(self, self.onChangeRoomClicked))
    self.m_btnHelp:addClickEventListener(handler(self, self.onHelpClicked))
    --需要初始化时隐藏
    self.m_panelMenuBack:setVisible(false)
    self.m_panelCoin:setVisible(false)
--    self.m_panelAnimation:setVisible(false)
    self.m_imageWaitnext:setVisible(false)
    self.m_btnShowCard:setVisible(false)
    for i = 1,6 do
        self.m_panelPlayer:getChildByName("fileNode_player_"..i):setVisible(false)
        self.m_panelPlayer:getChildByName("fileNode_playerCard_"..i):setVisible(false)
    end
    
end
--初始化游戏
function GameViewLayer:initGame( data )
    self.m_unitMoney = data.deskinfo.unit_money
    self.m_initMoney = data.deskinfo.init_money
    self.m_niuBeilv = data.deskinfo.multiple
    for key, player_ in ipairs(data.memberinfos) do --确定自己的位置
        if player_.uid == GlobalUserItem.tabAccountInfo.userid then
            self.myPos_ = player_.position
        end
    end
    --加载玩家信息
    for key, player_ in ipairs(data.memberinfos) do
        self:loadPlayerInfo(player_)
    end
    self.m_roomDifen:setString("通比牛牛")            --房间底分
    self.m_tableName:setString("底分："..self.m_unitMoney)            --房间名字桌号
    self.m_easyPeilv:setString("牛牛3倍,牛七~牛九2倍")            --房间赔率显示
    ExternalFun.playBackgroudAudio("game_bg.mp3")
end
----------------------------------------------------------------------------
                                --服务器消息--
----------------------------------------------------------------------------

function GameViewLayer:onEventEnter(bufferData)
    self:initGame(bufferData)

    self:showAllCD(bufferData.deskinfo.continue_timeout)	--倒计时
end
--进入房间
function GameViewLayer:onEventCome(bufferData)
    dump(bufferData)
    self:loadPlayerInfo(bufferData.memberinfo)
end
--离开房间
function GameViewLayer:onEventLeave(bufferData)
    for key, player_ in ipairs(self.m_playerTable) do
        if bufferData == player_.uid then
            player_.node:setVisible(false)
            player_.cardNode:setVisible(false)
        end
    end    
end
--准备
function GameViewLayer:onEventReady(bufferData)
    for key, player_ in ipairs(self.m_playerTable) do
        if bufferData == player_.uid then
            player_.cardNode:getChildByName("Panel_2"):getChildByName("ok"):setVisible(true)
            if bufferData == GlobalUserItem.tabAccountInfo.userid then
                self.m_btnStart:setVisible(false)
                self.gameState = GAME_STATE.BullReadyStart
            end
            player_.isStart = true
            self:stopCD(player_)
        end
    end
end
--摊牌
function GameViewLayer:onEventOK(bufferData)    
    for key, player_ in ipairs(self.m_playerTable) do
        if bufferData.uid == player_.uid then
            player_.cardNode:getChildByName("Panel_2"):getChildByName("ok"):setVisible(true)
            if bufferData.uid == GlobalUserItem.tabAccountInfo.userid then
                self.m_btnShowCard:setVisible(false)
            end
            self:stopCD(player_)
        end
    end
end
--发牌
function GameViewLayer:onEventDeal(bufferData)
    print("发牌..................")
    dump(bufferData)
    local playerNum = 0
    for key, player_ in ipairs(self.m_playerTable) do
        player_.cardNode:getChildByName("Panel_2"):getChildByName("ok"):setVisible(false)
        if player_.isStart == true then
            playerNum = playerNum + 1
        end
        if player_.uid == GlobalUserItem.tabAccountInfo.userid then
            player_.cardValue = bufferData.cards
            player_.cardType = bufferData.type
        end
    end
    self.m_btnShowCard:setVisible(true)
    self.m_panelAnimation:setVisible(true)
    ---------------------------
	self:clearCardsImg()
	local endTime = bufferData.t        --该阶段倒计时
	local dealInfo = bufferData.cards   --自己牌数据
	if dealInfo then
		self.gameState = GAME_STATE.BullDealCards
		dump(dealInfo, "发牌数据")
		local cards = self:createAllCards( playerNum )
		self:flyCardToSeatPlayer(cards, dealInfo )
--		self:startShowAnimation()	
        --开始动画--------------------------------------------
        local anmifilePath = "tongbiniuniu/image/animation/start.csb"
   	    local markerAni = cc.CSLoader:createNode(anmifilePath)
   	    markerAni:setPosition(cc.p(display.width/2, display.height/2))
        if LuaUtils.isIphoneXDesignResolution() then
            markerAni:setPosition(cc.p(display.width/2-145, display.height/2))
        end
   	    self.m_panelAnimation:addChild(markerAni)
--	    cc.loaded_packages.KKMusicPlayer:playEffect("tongbiniuniu/sound/tbnn_fire.mp3",false)
        ExternalFun.playSoundEffect("tbnn_fire.mp3")
        local action = cc.CSLoader:createTimeline(anmifilePath)
        markerAni:runAction(action)
        action:gotoFrameAndPlay(0,28, false)  --true循环播放，false 播放一次
        markerAni:runAction(cc.Sequence:create(cc.DelayTime:create(0.9),cc.FadeOut:create(0.1),cc.CallFunc:create(function()
            markerAni:removeFromParent()
        end)))

		local localTime = 1 --发牌用的时间
		local canUseTime = endTime 
		self:showAllCD(canUseTime)	--倒计时

	end
end
--结算
function GameViewLayer:onEventEnd(bufferData)
    print("结算..................")
	self.gameState = GAME_STATE.BullShowCards   --展示牌
	local allCardsInfo = bufferData.infos--cc.loaded_packages.TongBiNiuniuModel:getShowCardsInfo()
    local winChair = 0      --赢家椅子号
    local winPos = cc.p(0,0)
    local winUid = 0
    for key_, player_ in ipairs(self.m_playerTable) do
        for key, info in ipairs(allCardsInfo) do
            if player_.uid == info[1] then
                self:setCardsValueCards(player_,true)
                self:setResult( info )
                --隐藏摊牌的ok
                player_.cardNode:getChildByName("Panel_2"):getChildByName("ok"):setVisible(false)
                if info[4] > 0 then
                    winChair = player_.chairID
                    winPos = player_.worldPos
                    winUid = player_.uid
                end
            end
        end
    end
    
--	for i = 1, #allCardsInfo do
--		local clientIndex = cc.loaded_packages.TongBiNiuniuModel:changeSeat(allCardsInfo[i].seatindex)
--		if clientIndex ~= 1 then
--			if self.autoOpration then
--				self.allPlayers[clientIndex]:setCardsValueCards(clientIndex,true)
--			end
--		end
--		self.allPlayers[clientIndex]:setResult(allCardsInfo[i].cardstype, allCardsInfo[i].cardsinfo )
--		self.allPlayers[clientIndex]:showOrHideOK(false)
--	end
--	self.showCardBtn:hide()

--	self.autoOpration = false

    --飞金币
		local function showCoinFly()
			self.m_panelCoin:removeAllChildren()
            self.m_panelCoin:setVisible(true)
			for key_, player_ in ipairs(self.m_playerTable) do
                for key_, info_ in ipairs(allCardsInfo) do
                    if player_.uid == info_[1] then
                        if info_[4] > 0 then
		                    player_.cardNode:getChildByName("Panel_2"):getChildByName("win"):setVisible(true)
		                    player_.cardNode:getChildByName("Panel_2"):getChildByName("win"):setString("+"..info_[4].."$")
	                    elseif info_[4] < 0 then
		                    player_.cardNode:getChildByName("Panel_2"):getChildByName("lose"):setVisible(true)
		                    player_.cardNode:getChildByName("Panel_2"):getChildByName("lose"):setString(info_[4].."$")
                            self:flyToWinChip(1, winPos , player_)
	                    end
                        player_.node:getChildByName("namebg"):getChildByName("money"):setString(info_[5])
                    end
                end
			end
		end
        showCoinFly()

		

    local function cleanTable()
        self.m_panelCoin:removeAllChildren()
        self.m_panelCoin:setVisible(false)
        self.m_panelAnimation:removeAllChildren()
        self.m_panelAnimation:setVisible(true)
        self:showAllCD(bufferData.t)	--倒计时
        for key_, player_ in ipairs(self.m_playerTable) do
            local cardPanel = player_["cardNode"]:getChildByName("Panel_2")
            cardPanel:getChildByName("resultType"):setVisible(false)
            cardPanel:getChildByName("ok"):setVisible(false)
            cardPanel:getChildByName("win"):setVisible(false)
            cardPanel:getChildByName("lose"):setVisible(false)
        end
        self.m_btnStart:setVisible(true)
        if self.m_pAutoState == true then
            self._scene:sendReady()
        end
        self.gameState = GAME_STATE.BullSettle  --结算
    end
    self:runAction(cc.Sequence:create( cc.DelayTime:create(3),cc.CallFunc:create(cleanTable)))
end
--结束
function GameViewLayer:onEventDeskover(bufferData)
    print("结束..................")
    dump(bufferData)
    
end
--中途进入
function GameViewLayer:onEventLate(bufferData)
    local a = 1
    local b = 2
end

----------------------------------------------------------------------------
                                --按钮点击事件--
----------------------------------------------------------------------------
function GameViewLayer:onShowCardClicked( sender )
--摊牌按钮
    ExternalFun.playClickEffect()    
    self._scene:sendTanPai()
end

function GameViewLayer:onStartClicked( sender )
--开始按钮
    ExternalFun.playClickEffect()    
    self._scene:sendReady()
end

function GameViewLayer:onRobotClicked( sender )
--托管按钮
    ExternalFun.playClickEffect()
    _:disableQuickClick(self.m_btnRobot)
    if self.m_pAutoState == true then
        self.m_pAutoState = false
        self.m_btnRobot:loadTextureNormal("common/zcmdwc_common/btn_tg.png")
    else
        self.m_pAutoState = true
        self.m_btnRobot:loadTextureNormal("common/zcmdwc_common/btn_tgqx.png")
    end
    self:autoGameStep()
end

function GameViewLayer:onMenuClicked( sender )
--菜单按钮
    ExternalFun.playClickEffect()
    _:disableQuickClick(self.m_btnMenu)
    local jiantou = self.m_btnMenu:getChildByName("Image_5")
    if self.m_pMenuState == false then
        self.m_panelMenuBack:setVisible(true)
        self.m_panelMenu:runAction(cc.MoveBy:create(0.3,cc.p(190,0)))
        jiantou:runAction(cc.RotateTo:create(0.2,180))
        self.m_pMenuState = true
    else        
        self.m_panelMenu:runAction(cc.Sequence:create(cc.MoveBy:create(0.3,cc.p(-190,0)),cc.CallFunc:create(function()
                self.m_panelMenuBack:setVisible(false)
            end)))
        jiantou:runAction(cc.RotateTo:create(0.2,90))
        self.m_pMenuState = false
    end

end

function GameViewLayer:onExitClicked( sender )
--退出按钮
    ExternalFun.playClickEffect()
    self._scene:onQueryExitGame()

end

function GameViewLayer:onSettingClicked( sender )
--设置按钮
    ExternalFun.playClickEffect()
    local settingLayer = SettingLayer.create()--SettingLayer.create()
    settingLayer:addTo(self.m_rootBg)
end

function GameViewLayer:onChangeRoomClicked( sender )
--换桌按钮
    ExternalFun.playClickEffect()
    _:disableQuickClick(self.m_btnChangeRoom)
    --换桌消息
    local function chengeTableFun()
        self._scene:sendChangedesk()        
        self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
            self._scene:sendContinue()
        end)))
    end
    if self.m_pAutoState == true then
        --游戏托管中
        FloatMessage:getInstance():pushMessage("游戏托管中，无法换桌")
    else    
        if self.gameState == GAME_STATE.BullWait then
            FloatMessage:getInstance():pushMessage("正在换桌，请稍后")
            chengeTableFun()
        elseif self.gameState == GAME_STATE.BullReadyStart then
            --游戏中，不能换桌
            FloatMessage:getInstance():pushMessage("游戏中，无法换桌")
        elseif self.gameState == GAME_STATE.BullDealCards then
            --游戏中，不能换桌
            FloatMessage:getInstance():pushMessage("游戏中，无法换桌")
        elseif self.gameState == GAME_STATE.BullShowCards then
            --游戏中，不能换桌
            FloatMessage:getInstance():pushMessage("游戏中，无法换桌")
        elseif self.gameState == GAME_STATE.BullSettle then
            FloatMessage:getInstance():pushMessage("正在换桌，请稍后")
            chengeTableFun()
        end
    end
    
    
end

function GameViewLayer:onHelpClicked( sender )
--帮助按钮
    ExternalFun.playClickEffect()
    local gameRuleLayer = GameRuleLayer.create()
    gameRuleLayer:addTo(self.m_rootBg)
end
----------------------------------------------------------------------------
                                --工具--
----------------------------------------------------------------------------
function GameViewLayer:loadPlayerInfo( playerInfo )
    --判断玩家信息表中是否已存在该玩家信息
    for key, player_ in ipairs(self.m_playerTable) do
        if playerInfo.uid == player_.uid then
            return
        end
    end
    table.insert(self.m_playerTable,playerInfo)
    if playerInfo.uid ~= GlobalUserItem.tabAccountInfo.userid then
        if playerInfo.position < self.myPos_ then
            playerInfo["chairID"] = playerInfo.position + 2 
        else
            playerInfo["chairID"] = playerInfo.position + 1
        end
    else
        playerInfo["chairID"] = 1
    end
    playerInfo["isStart"] = false   --根据该状态判断是否参与本局游戏，收到该玩家的准备消息后发牌
    --初始化头像数据
    playerInfo["node"] = self.m_panelPlayer:getChildByName("fileNode_player_"..playerInfo["chairID"])
    playerInfo["node"]:setVisible(true)
    local playerNode = playerInfo["node"]    
    local norFrame = playerNode:getChildByName("icon"):getChildByName("norFrame")
    local head = HeadSprite:createNormal(playerInfo, 124)
    head:setPosition(cc.p(0,0))
    head:setAnchorPoint(cc.p(0,0))
    norFrame:addChild(head)
    playerNode:getChildByName("namebg"):getChildByName("name"):setString(playerInfo.nickname)
    playerNode:getChildByName("namebg"):getChildByName("money"):setString(playerInfo.into_money)
    --初始化牌的状态数据
    playerInfo["cardNode"] = self.m_panelPlayer:getChildByName("fileNode_playerCard_"..playerInfo["chairID"])
    playerInfo["cardNode"]:setVisible(true)    
    local cardPanel = playerInfo["cardNode"]:getChildByName("Panel_2")
    for i = 1,5 do
        cardPanel:getChildByName("card_"..i):setVisible(false)
    end
    cardPanel:getChildByName("resultType"):setVisible(false)
    cardPanel:getChildByName("ok"):setVisible(false)
    cardPanel:getChildByName("win"):setVisible(false)
    cardPanel:getChildByName("lose"):setVisible(false)  
    --存入牌的位置坐标  
    local pos = cc.p(cardPanel:getPositionX() + cardPanel:getContentSize().width * 0.15, cardPanel:getPositionY() + cardPanel:getContentSize().height/2)
	if playerInfo.chairID == 1 then
		pos.x = cardPanel:getPositionX() + cardPanel:getContentSize().width * 0.27
	end	
	playerInfo.cardPos = playerInfo.cardNode:convertToWorldSpace(cc.p(pos))
	playerInfo.cardPos = self.m_panelAnimation:convertToNodeSpace(cc.p(playerInfo.cardPos))
    --存入头像坐标位置（为了飞金币）
    playerInfo.worldPos = playerNode:convertToWorldSpace(cc.p(playerNode:getChildByName("icon"):getPosition()))
    playerInfo.worldPos = self.m_panelAnimation:convertToNodeSpace(cc.p(playerInfo.worldPos))	
    --初始化玩家牌的数据
    playerInfo.cardValue = {}
    playerInfo.cardType = 0
    
end
--清楚牌面
function GameViewLayer:clearCardsImg()
    for i = 1,6 do
        local cardPanel = self.m_panelPlayer:getChildByName("fileNode_playerCard_"..i)
        for i = 1,5 do            
        end        
    end    
end
--创建所有玩家的牌
function GameViewLayer:createAllCards(cardNum)
	local defaultBackPath = "common/card/cardBack.png"
	local cards = {}
	local max = cardNum
	for i = 1, max do
		local t = {}
		for i = 1, 5 do
			local sprite = cc.Sprite:create(defaultBackPath)
			self.m_panelAnimation:addChild(sprite)
			local pos = self.m_panelAnimation:convertToNodeSpace(cc.p(display.width / 2, display.height / 2))
			sprite:setPosition(pos)
			sprite:setScale(0.3)
			table.insert(t , sprite)
		end
		table.insert(cards,t)
	 end
	 return cards
end
--发牌动画
function GameViewLayer:flyCardToSeatPlayer(cardImags , seatPlayerInfo)
	--飞牌动画表现
	local function flycard( seatIndex,node, endPos ,delaytime, func)
		-- body
		
    	local scale = seatIndex == 1 and 0.75 or 0.55
    	node:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime),cc.Spawn:create(
    		cc.MoveTo:create(0.4,cc.p(endPos)), cc.ScaleTo:create(0.4, scale),cc.CallFunc:create(function ()
				
			end)),cc.CallFunc:create(function ( ... )
				-- body
				if seatIndex == 1 then
--					cc.loaded_packages.KKMusicPlayer:playEffect("tongbiniuniu/sound/onecard.mp3", false)
                    ExternalFun.playSoundEffect("onecard.mp3")
				end
				
				if func then
					print("执行分牌----")
    				func()
    			end
		end)))
	end
                     --第几个玩家的牌    椅子号     第几个玩家
	local function flyPlayer(cardsOne, player_, index)
		local function delayfunc()
			for i = 1, 5 do                
				local endPos = player_.cardPos--飞行的重点位置
				if cardsOne[i] then
					cardsOne[i]:setPosition(cc.p(display.width/2, display.height/2))
					flycard(player_.chairID, cardsOne[i], endPos, i * 0.05, i == 5 and function ()
						print("分牌被执行")
						self:splitCardsAction(cardsOne, player_)
					end or nil  )
				end
		 	end
		end
		 self:runAction( cc.Sequence:create(cc.DelayTime:create(index*0.05),cc.CallFunc:create(delayfunc)))
	end

	local playerIngNum = #seatPlayerInfo
	for key, player_ in ipairs(self.m_playerTable) do
        if player_.isStart == true then
            player_._cardsImg = cardImags[key]
            flyPlayer(cardImags[key], player_, key)
        end
	end

end
--到达目标位置的牌了 开始展开                    本来是椅子号seatIndex，直接传入玩家更方便
function GameViewLayer:splitCardsAction(cardsOne, player_)
	print("展开牌的位置",player_.chairID)
	if not cardsOne then
		cardsOne = self:createDefaulttCards(player_.cardPos)
	end
	for i = 5, 2 , -1 do
		local add = cardsOne[i]:getContentSize().width * 0.25*(i -1)
		local move = cc.Sequence:create(cc.MoveTo:create(0.05, cc.p(cardsOne[i]:getPositionX() + add, cardsOne[i]:getPositionY())))
		local func = cc.Sequence:create(cc.DelayTime:create(0.05), cc.CallFunc:create(function ()
			if player_.chairID == 1 and i == 2 then
				print("执行显示自己的牌")
                self:setCardsValueCards(player_,true)
                if self.m_pAutoState == true then
                    self._scene:sendTanPai()
                end
			end 
		end))

		cardsOne[i]:runAction(cc.Spawn:create( move,func))
	end
end
function GameViewLayer:createDefaulttCards(cardInitPos)
	local defaultNum = 5
	local defaultBackPath = "common/card/cardBack.png"
	local t = {}
	for i = 1 , defaultNum do
		local sprite = cc.Sprite:create(path)
		sprite:setPosition(cc.p(cardInitPos))
		table.insert(t, sprite)
	end
	return  t
end
--展示牌面                                seatIndex
function GameViewLayer:setCardsValueCards( player_, isAnimation,isShowAll)
	-- body
	local cardImgs = player_._cardsImg 
	local cardsvalue = player_.cardValue
	local cardtype = player_.cardType

	if not cardsvalue or #cardsvalue == 0 then
		return 
	end

--	cardsvalue = self:sortOpenCards(cardsvalue,cardtype)
	local mustSortImg = function ()
		print("强制刷新位置")
		if not cardImgs or not cardImgs[1] then
			return 
		end
		local Y = cardImgs[1]:getPositionY()
		for i = 1, 5 do
			local add = cardImgs[i]:getContentSize().width * 0.25*(i -1)
			cardImgs[i]:setPosition(cc.p(player_.cardPos.x + add , Y))
		end
	end

	local mustOpenImgPos = function ()
		print("强制刷新位置")
		if not cardImgs or not cardImgs[1] then
			return 
		end
		local Y = cardImgs[1]:getPositionY()
		for i = 1, 5 do
			local add = cardImgs[i]:getContentSize().width * 0.25*(i -1)
			if i >= 4 then
				cardImgs[i]:setPosition(cc.p(player_.cardPos.x + add+ 15 , Y))
			else
				cardImgs[i]:setPosition(cc.p(player_.cardPos.x + add , Y))
			end
		end
	end

	mustSortImg()

	dump(cardsvalue,"查询到的数据")

	if isAnimation and cardImgs then
--		cc.loaded_packages.KKMusicPlayer:playEffect("tongbiniuniu/sound/open_a_card.mp3",false)
        ExternalFun.playSoundEffect("open_a_card.mp3")
		for i = 1, 5 do
			cardImgs[i]:stopAllActions()
			cardImgs[i]:runAction(cc.Sequence:create(cc.Spawn:create(cc.OrbitCamera:create(0.1, 1, 0, 0, 90, 0, 0), cc.CallFunc:create(function ()
				
				if i >= 4 then
					cardImgs[i]:runAction(cc.MoveTo:create(0.2, cc.p(cardImgs[i]:getPositionX() + 15, cardImgs[i]:getPositionY())))
				end
			end)),cc.CallFunc:create(function ( ... )
				-- body
				self:setCardValue(cardImgs[i], cardsvalue[i])
				cardImgs[i]:setFlipX(true)
			end),cc.OrbitCamera:create(0.1, 1, 0, 90, 90, 0, 0),cc.CallFunc:create(function ()
				mustOpenImgPos()
--				dispatchEvent("tbnn_showCardBtn",seatIndex)
			end)))
		end
	else
		if not cardImgs then
			cardImgs = self:createCards(seatIndex,isShowAll)
		end
	end
end

function GameViewLayer:setCardValue(image,value)
	local function setCard( cardVal, cardType)
		local imagePath 
		if cardType ~= 4 then
			imagePath = string.format('common/card/%s.png', ''..cardType..cardVal)
		else
			local p 
			if cardVal == 14 then
				p = "xiaowang"
			else
				p = "dawang"
			end
			imagePath = string.format('common/card/%s.png', p)
		end	
		if DEBUG == 2 and cc.Sprite:create(imagePath) == nil then
			print('warning: invalid card path:', imagePath) 
		end
		image:setTexture(imagePath)
	end
	local function getTypeValue( cardInfo )
		-- body
--		local ctype = math.floor(cardInfo / 16)
--		ctype = 3 - ctype -- 服务器值转客户端
--		if ctype == -1 then
--			ctype = 4
--		end
--		local val = cardInfo % 16
--		val = val ~= 1 and val or 14

        local ctype,val = math.modf(cardInfo/13)
        val = cardInfo%13
        val = val + 1
        if val == 1 then
            val = 14
        end
        if ctype == 4 then
            val = val + 13
        end
		return ctype, val
	end
	local ctype , val = getTypeValue(value)
	setCard(val, ctype )

end
--机器人托管
function GameViewLayer:autoGameStep()

	local isAuto = self.m_pAutoState
	local gamestate = self.gameState
    if isAuto == true then
        if gamestate == GAME_STATE.BullWait then
            self._scene:sendReady()
        elseif gamestate == GAME_STATE.BullReadyStart then

        elseif gamestate == GAME_STATE.BullDealCards then
            self._scene:sendTanPai()
        elseif gamestate == GAME_STATE.BullShowCards then

        elseif gamestate == GAME_STATE.BullSettle then
            self._scene:sendReady()
        end
    end
end

--设置牛型                                cardsinfo
function GameViewLayer:setResult( cardsinfo )--, isshow)
	-- body
--	if self.myCanClick and not isshow and self._seatInfo.clientIndex == 1 then
--		self.myCanClick = false
--		return 
--	end

--	if isshow and self._seatInfo.clientIndex == 1 then
--		self.myCanClick = true
--	else
--		self.myCanClick = false
--	end
-----------------------------------------------
    local player_ = nil
    for key, player in ipairs(self.m_playerTable) do
        if player.uid == cardsinfo[1] then
            player_ = player
        end
    end    
	local resultImg = player_["cardNode"]:getChildByName("Panel_2"):getChildByName("resultType")

	if not player_._cardsImg then
		return 
	end
	resultImg:setVisible(true)
    local winType = cardsinfo[3]
	local pathFormat = "tongbiniuniu/image/ui/niuniu_type_%d.png"
	local typevalue = winType  > 11 and  winType - 1 or winType
	resultImg:loadTexture(string.format( pathFormat,typevalue ))
--	local data = self:sortOpenCards(cardsinfo, typevalue)
	for i = 1, 5 do
		self:setCardValue(player_._cardsImg[i], cardsinfo[2][i])
	end
    --音效最后加
	if player_.chairID == 1 then
		local path = "card_%d_girl.mp3"
		if typevalue < 12 then
--			cc.loaded_packages.KKMusicPlayer:playEffect(string.format(path,typevalue ),false)
            ExternalFun.playSoundEffect(string.format(path,typevalue ))
		elseif typevalue == 12 or typevalue == 13 then
            ExternalFun.playSoundEffect(string.format(path,winType ))
--			cc.loaded_packages.KKMusicPlayer:playEffect(string.format(path,winType ),false)
		end
	end
end
--输的玩家飞金币到赢的玩家
function GameViewLayer:flyToWinChip( value , winPlayerPos ,player_)
	local nums = {15, 8, 15, 20, 20}
	local a = 0
	local length = cc.pGetDistance(player_.worldPos,winPlayerPos)
	local moveTime = 0.3
	local angle = cc.pGetAngle(player_.worldPos,winPlayerPos)
	print(angle,"弧度")

	local function flyCoin(cardvalue, index)
		local delaytime = index
		local coin = display.newSprite("dt/image/zcmdwc_common/zcmdwc_jb.png")
		coin:setScale(0.8)
		local add = index % 2 == 0 and -1 or 1 
		self.m_panelCoin:addChild(coin, 1000)
		local rand = 1

		local mid = cc.p((player_.worldPos.x+winPlayerPos.x)*0.5, math.max(player_.worldPos.y, winPlayerPos.y)+rand)
		coin:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime*0.04 ),cc.CallFunc:create(function ()
			local x = player_.worldPos.x + (add * math.random(10,25)) 
			local y = player_.worldPos.y + (add * math.random(5,25)) 
			coin:setPosition(cc.p(x,y))
		end), cc.MoveTo:create(0.55,winPlayerPos),
		cc.CallFunc:create(function ()
			if coin then
				coin:stopAllActions()
				coin:removeFromParent()
			end
		end)))
	end
--	dispatchEvent("tbnn_coinfly")--
    self:playGetCoinAnimation(winPlayerPos)
	for i = 1, nums[value] do
		flyCoin(0, i)
	end
end
--玩家获胜 动画
function GameViewLayer:playGetCoinAnimation(winPlayerPos)	
	if self.m_panelCoin:getChildByName("GetCoinAnimation")  then
		return 
	end
--	cc.loaded_packages.KKMusicPlayer:playEffect("tongbiniuniu/sound/collect_chips.mp3", false)
    ExternalFun.playSoundEffect("collect_chips.mp3")
	local anim = cc.CSLoader:createNode("common/game_common/efftct_win/effect_win.csb")
	anim:setPosition(cc.p(winPlayerPos.x ,winPlayerPos.y - 7))

	anim:setName("GetCoinAnimation")
	self.m_panelCoin:addChild(anim)
    local action = cc.CSLoader:createTimeline("common/game_common/efftct_win/effect_win.csb")
    anim:runAction(action)
    action:gotoFrameAndPlay(0,34, true)  --true循环播放，false 播放一次
    anim:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.FadeOut:create(0.1),cc.CallFunc:create(function()
        anim:removeFromParent()
    end)))
end
--倒计时                   
function GameViewLayer:showAllCD(time)
	for key, player_ in ipairs(self.m_playerTable) do
        time = time - 1 < 0 and 0 or time - 1
	    local function cdstart()
		    if not self.m_panelAnimation:getChildByName("progressNode"..player_.chairID) then
                local  cellTime = time / 4
			    for  i=1,4 do
				    local view = self.m_panelAnimation:getChildByName('progressNode' .. player_.chairID..i)
			    	    if view then
			            view:stopAllActions()
			            view:removeFromParent()
			        end

                    local progressSprite = display.newSprite('tongbiniuniu/image/ui/tbnn_cd_'..i..'.png')
                    local progressNode = cc.ProgressTimer:create(progressSprite)
                    progressNode:setReverseDirection(true)
                    progressNode:setPercentage(100)
             	    progressNode:setPosition(cc.p(player_.worldPos.x, player_.worldPos.y+1 ))
                    self.m_panelAnimation:addChild(progressNode,100)

                    progressNode:setName('progressNode' .. player_.chairID..i)
                    local to = cc.ProgressTo:create(time,0)
                    progressNode:setOpacity(0)

                    local showdelay = cc.DelayTime:create(cellTime*(i-1))
                    local hidedelay = cc.DelayTime:create(cellTime)
                    local showA = cc.Sequence:create(showdelay,cc.FadeIn:create(0.5),hidedelay,cc.FadeOut:create(0.5))
                    progressNode:runAction(cc.Spawn:create(to,showA))
                end
		    else
			    print("出错的位置", player_.chairID)
		    end 
	    end
	    local action = cc.Sequence:create(cc.DelayTime:create(0.8), cc.CallFunc:create(cdstart))
	    action:setTag(player_.chairID)
	    if time >= 1 then
		    self.m_panelAnimation:runAction(action)
	    end
    end
end
function GameViewLayer:stopCD( player )
    self.m_panelAnimation:stopActionByTag(player.chairID)
  	for i=1,4 do
	    local view = self.m_panelAnimation:getChildByName('progressNode' .. player.chairID..i)
	    if view then
	        view:stopAllActions()
	        view:removeFromParent()
	    else
	        print('--------------stopCD error-----------------------')
	    end
	end
end
function _:setBtnEnabled(btn, enabled)
    btn:setEnabled(enabled)
    btn:setTouchEnabled(enabled)
    btn:setBright(enabled)
end
-- 防止频繁点击
function _:disableQuickClick(btn)
    _:setBtnEnabled(btn, false)
    performWithDelay(btn, function()
        _:setBtnEnabled(btn, true)
    end, 1)
end

function GameViewLayer:unloadResource()

end

function GameViewLayer:onEnter()


end
function GameViewLayer:onExit()

    self:unloadResource()

    self.m_tabUserItem = {}
end

return GameViewLayer