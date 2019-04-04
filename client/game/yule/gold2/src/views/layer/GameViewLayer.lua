--  扎金花
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local module_pre = "game.yule.gold2.src"
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
local ZhajinhuaVsView = appdf.req(module_pre .. ".views.layer.ZhajinhuaVsView")

local Poker                 = require(module_pre .. ".views.layer.Poker")
local ProgressNode          = require(module_pre .. ".views.layer.ProgressNode")

local TAG_ENUM = Define.TAG_ENUM
local TAG_ZORDER = Define.TAG_ZORDER
local SELF_UID = GlobalUserItem.tabAccountInfo.userid

local GameViewLayer = class("GameViewLayer",function(scene)
        local gameViewLayer = display.newLayer()
    return gameViewLayer
end)

local chipNum = { 2, 5, 10}
function GameViewLayer:ctor(scene)
print("on enter -----------===========----------    GameViewLayer")
    --注册node事件
    ExternalFun.registerNodeEvent(self)
    self._scene = scene

    local rootLayer, csbNode = ExternalFun.loadRootCSB("zhajinhua/ZhajhScene.csb", self)
    self.m_rootWidget = csbNode
    --iphoneX适配
    if LuaUtils.isIphoneXDesignResolution() then
        local width_ = yl.WIDTH - display.size.width
        self.m_rootWidget:setPositionX(self.m_rootWidget:getPositionX() - width_/2)
    end
    
    self:initVar()
    self:initNode()
end
function GameViewLayer:initVar()
    
    self.m_pMenuState = false   --菜单界面是否点开
    self.m_unitMoney = 0    --底注
    self.m_initMoney = 0    --当前暗注		#当前暗注是底注倍数
    self.m_niuBeilv = {}
    self.m_playerTable = {}
    self.m_pSelfKanpai = false  --自己是否已经看牌
    self.m_pTime = 0    --玩家计时
    self.myPosition = nil       --玩家自己带入房间的position
    self.m_onGamePlayers = {}   -- 本局参与游戏的玩家
    self.m_allCards = {}        --所有玩家的牌
    self.m_allAboutChip = {}    --所有跟下注有关的东西 #收到消息 opt
    self.isGenDaodi = false
    self.isBipaiIng = false     --是否在比牌中
    SLFacade:addCustomEventListener(GameRoleItem.ONEVENT_KANPAI_CLICK, handler(self, self.onKanpaiClickEvent), self.__cname)    --添加自己点击看牌按钮的事件监听
    SLFacade:addCustomEventListener(GameRoleItem.ONEVENT_BIPAI_CLICK, handler(self, self.onBipaiClickEvent), self.__cname)    --添加自己点击玩家比牌的事件监听
    SLFacade:addCustomEventListener("bipai_state", handler(self, self.setBipaiState), self.__cname)    --设置比牌状态
end
function GameViewLayer:initNode()
    self.m_pImageBg         = self.m_rootWidget:getChildByName("image_bg")
    self.m_pNomoneyWarning  = self.m_rootWidget:getChildByName("image_nomoneyFol")  --提示金钱不足
    self.m_pPanelPlayer     = self.m_rootWidget:getChildByName("panel_playerPanel")
    self.m_pVsSelectWarning = self.m_rootWidget:getChildByName("image_vsTpsSelect") --提示语 请选择vs对象
    self.m_pPanel_setting   = self.m_rootWidget:getChildByName("panel_backMenu")    --设置层   监听关闭
    self.m_pAtlas_winCoin   = self.m_rootWidget:getChildByName("atlas_winCoinNum")  --赢钱飘分
    self.m_pAtlas_lostCoin  = self.m_rootWidget:getChildByName("atlas_loseCoinNum") --输钱飘分
    self.m_pImageDaojishi   = self.m_rootWidget:getChildByName("image_lastTime")    --开牌前倒计时
    self.m_pPanelLight      = self.m_rootWidget:getChildByName("panel_lightPanel")  --
    self.m_pNodesCard       = {}                                                    --所有玩家放牌的节点
    for i = 1,5 do                                  --1为自身，2为右边第一个，逆时针依次
        local cardNode = self.m_rootWidget:getChildByName("fileNode_showAllHandFile_"..i) 
        table.insert(self.m_pNodesCard,cardNode)
    end
    self.m_pTextDizhu       = self.m_pImageBg:getChildByName("Image_49"):getChildByName("text_guize1")  --底注
    self.m_pTextShangxian   = self.m_pImageBg:getChildByName("Image_49"):getChildByName("text_guize2")  --上限
    self.m_pTextHuihe       = self.m_pImageBg:getChildByName("Image_49"):getChildByName("text_jushu")   --回合
    self.m_pTextAllChip     = self.m_pImageBg:getChildByName("Image_49"):getChildByName("image_jiangchi"):getChildByName("text_jiangjin")   --下注总额
    self.m_pBtnBuy          = self.m_pImageBg:getChildByName("Node_7"):setVisible(false)                --商城按钮游戏中没有
    self.m_pBtnMenu         = self.m_pImageBg:getChildByName("button_back")                             --按钮 菜单
    self.m_pImageMenu       = self.m_pBtnMenu:getChildByName("Image_5")                                 --菜单按钮上的箭头
    self.m_pBtnYjsf         = self.m_pImageBg:getChildByName("button_yjsf")                             --按钮 一决胜负
    self.m_pBtnQxgz         = self.m_pImageBg:getChildByName("button_contrast")                         --按钮 取消跟注
    self.m_pBtnDdd          = self.m_pImageBg:getChildByName("button_gdd")                              --按钮 跟到底
    self.m_pBtnZhyb         = self.m_pImageBg:getChildByName("button_zhyb")                             --按钮 最后一搏
    self.m_pBtnXiazhu1      = self.m_pImageBg:getChildByName("button_xiazhu1")                          --按钮 下注1
    self.m_pBtnXiazhu2      = self.m_pImageBg:getChildByName("button_xiazhu2")                          --按钮 下注2
    self.m_pBtnXiazhu3      = self.m_pImageBg:getChildByName("button_xiazhu3")                          --按钮 下注3
    self.m_pBtnGenzhu       = self.m_pImageBg:getChildByName("button_followBtn")                        --按钮 跟注
    self.m_pBtnZhunbei       = self.m_pImageBg:getChildByName("button_showHandBtn"):setVisible(false)    --按钮 全压 --作为准备按钮使用
    self.m_pBtnLastFuck     = self.m_pImageBg:getChildByName("button_lastFuckBtn")                      --按钮 最后一搏
    self.m_pBtnVS           = self.m_pImageBg:getChildByName("button_vsBtn")                            --按钮 比牌
    self.m_pBtnGiveUp       = self.m_pImageBg:getChildByName("button_giveBtn")                          --按钮 弃牌
    self.m_pBtnLastLife     = self.m_pImageBg:getChildByName("button_lastLifeBtn")                      --按钮 一决胜负
    self.m_pBtnFollowEnd    = self.m_pImageBg:getChildByName("button_followendBtn")                     --按钮 跟到底
    self.m_pBtnLiangPai     = self.m_pImageBg:getChildByName("button_liangpai")                         --按钮 亮牌
    self.m_pPanelCoin       = self.m_pPanelPlayer:getChildByName("panel_coinPanel")                     --金币动画层 
    self.m_pPanelAnimation  = self.m_pPanelPlayer:getChildByName("panel_animationPanel")                --动画层 
    self.m_pPanelCards      = self.m_pPanelPlayer:getChildByName("panel_allCardPanel")                  --扑克层
    self.m_pPanelFullWord   = self.m_pPanelPlayer:getChildByName("panel_addFullWordPanel")              
    self.m_pNodeMidCenter   = self.m_pPanelPlayer:getChildByName("node_midCenterNode")       
    self.m_pImageSettingBg  = self.m_pPanel_setting:getChildByName("image_settingPanel")                --设置层背景 移动的节点
    self.m_pBtnBack         = self.m_pImageSettingBg:getChildByName("button_BtnBack")                   --按钮 退出游戏
    self.m_pBtnHelp         = self.m_pImageSettingBg:getChildByName("button_BtnHelp")                   --按钮 帮助
    self.m_pBtnSet          = self.m_pImageSettingBg:getChildByName("button_BtnSet")                    --按钮 设置
    self.m_pNumDaojishi     = self.m_pImageDaojishi:getChildByName("image_lastBack"):getChildByName("text_lastTimeText")    --倒计时数字


    self.m_pBtnGenzhu:addClickEventListener(handler(self, self.onGenzhuClicked))        --按钮 跟注
    self.m_pBtnVS:addClickEventListener(handler(self, self.onVSClicked))                --按钮 比牌
    self.m_pBtnGiveUp:addClickEventListener(handler(self, self.onGiveUpClicked))        --按钮 弃牌
    self.m_pBtnFollowEnd:addClickEventListener(handler(self, self.onFollowEndClicked))  --按钮 跟到底
    self.m_pBtnFollowEnd:getChildByName("Image_226"):getChildByName("image_followendImg"):setVisible(false)
    self.m_pBtnLiangPai:addClickEventListener(handler(self, self.onLiangpaiClicked))    --按钮 亮牌（游戏结束亮牌给其他玩家看）
    self.m_pBtnXiazhu1:addClickEventListener(handler(self, self.onXiazhu1Clicked))      --按钮 下注1
    self.m_pBtnXiazhu2:addClickEventListener(handler(self, self.onXiazhu2Clicked))      --按钮 下注2
    self.m_pBtnXiazhu3:addClickEventListener(handler(self, self.onXiazhu3Clicked))      --按钮 下注3
    self.m_pBtnMenu:addClickEventListener(handler(self, self.onMenuClicked))        --按钮 菜单
    self.m_pPanel_setting:addClickEventListener(handler(self, self.onMenuClicked))  --按钮 关闭菜单
    self.m_pBtnBack:addClickEventListener(handler(self, self.onExitClicked))    --按钮 退出游戏
    self.m_pBtnHelp:addClickEventListener(handler(self, self.onHelpClicked))    --按钮 帮助
    self.m_pBtnSet:addClickEventListener(handler(self, self.onSettingClicked))  --按钮 设置
    self.m_pBtnZhunbei:addClickEventListener(handler(self, self.onZhunbeiClicked))  --按钮 准备
    ---------------
    self.m_pBtnYjsf:setVisible(false)--:addClickEventListener(handler(self, self.onMenuClicked))        --按钮 一决胜负
    self.m_pBtnQxgz:setVisible(false)--:addClickEventListener(handler(self, self.onMenuClicked))        --按钮 取消跟注
    self.m_pBtnDdd:setVisible(false)--:addClickEventListener(handler(self, self.onMenuClicked))         --按钮 跟到底
    self.m_pBtnZhyb:setVisible(false)--:addClickEventListener(handler(self, self.onMenuClicked))        --按钮 最后一搏
    self.m_pBtnLastFuck:setVisible(false)--:addClickEventListener(handler(self, self.onMenuClicked))    --按钮 最后一搏    
    self.m_pBtnLastLife:setVisible(false)--:addClickEventListener(handler(self, self.onMenuClicked))    --按钮 一决胜负
    self.m_pPanelCoin:setVisible(false)         --金币动画层 
    self.m_pPanelAnimation:setVisible(true)    --动画层 
    self.m_pPanelCards:setVisible(false)        --扑克层
    self.m_pNomoneyWarning:setVisible(false)    --提示金钱不足
    self.m_pVsSelectWarning:setVisible(false)   --提示语 请选择vs对象
    self.m_pPanel_setting:setVisible(false)     --设置层   监听关闭
    self.m_pAtlas_winCoin:setVisible(false)     --赢钱飘分
    self.m_pAtlas_lostCoin:setVisible(false)    --输钱飘分
    self.m_pImageDaojishi:setVisible(false)     --开牌前倒计时
    self.m_pPanelLight:setVisible(false)
    self.m_pPanelPlayer:getChildByName("fileNode_player_1"):getChildByName("panel_playerInfoBg"):getChildByName("button_kanpai"):setVisible(false)
    for i = 1,5 do
        self.m_pPanelPlayer:getChildByName("fileNode_player_"..i):setVisible(false)
        self.m_rootWidget:getChildByName("fileNode_showAllHandFile_"..i):setVisible(false)
    end
    ExternalFun.playBackgroudAudio("BACK_GROUND.mp3")
end

--进入游戏
function GameViewLayer:onEventEnter(bufferData) 
    dump(bufferData)
    self.m_unitMoney = bufferData.deskinfo.unit_money
    self.m_initMoney = bufferData.deskinfo.init_money/bufferData.deskinfo.unit_money
    self.m_pTime = bufferData.deskinfo.continue_timeout
    self.m_pTextDizhu:setString(self.m_unitMoney)  --底注
    self.m_pTextShangxian:setString(bufferData.deskinfo.top_money)--上限
    for key, player_ in ipairs(bufferData.memberinfos) do
        if player_.uid == SELF_UID then
            self.myPosition = player_.position
        end
    end
    for key, player_ in ipairs(bufferData.memberinfos) do
        local player_ = GameRoleItem.new( self.myPosition, player_, self.m_pPanelPlayer, self.m_pPanelAnimation, self.m_pNodeMidCenter )
        table.insert(self.m_playerTable, player_)
    end
    self:hideAllBtn()
end
--有玩家进入房间
function GameViewLayer:onEventCome(bufferData)
    dump(bufferData)
    local player_ = GameRoleItem.new( self.myPosition, bufferData.memberinfo, self.m_pPanelPlayer, self.m_pPanelAnimation, self.m_pNodeMidCenter )
    table.insert(self.m_playerTable, player_)
end
--有玩家离开房间
function GameViewLayer:onEventLeave(bufferData)   
    dump(bufferData)
    for key, player_ in ipairs(self.m_playerTable) do
        if bufferData == player_.uid then
            player_:onEventPlayerLeave()
            table.remove(self.m_playerTable,key)
        end
    end
--    self._scene:sendReady()
end
--有玩家准备
function GameViewLayer:onEventReady(bufferData)
    print("玩家准备-------------------")
    dump(bufferData)
    if bufferData == SELF_UID then
        self.m_pBtnZhunbei:setVisible(false)
    end
end
--更新自身钱包
function GameViewLayer:onEventUpdate_intomoney(bufferData)   
    
end
--玩家弃牌
function GameViewLayer:onEventDrop(bufferData)
    print("玩家弃牌-------------------")
    dump(bufferData)
    for key, player_ in ipairs(self.m_playerTable) do
        if bufferData.uid == player_:getUserid() then
            player_:onEventPlayerDrop()
            self:showQuitCardAction(player_)
            self:updateButton(false)
        end
    end

    for key, player_ in ipairs(self.m_playerTable) do        
        if player_:getUserid() == SELF_UID then
            if bufferData.ply == SELF_UID then
                --第一次轮到自己以后就可以看牌
                player_:showKanpaiButton(true)
                self.m_allAboutChip = bufferData.opt
                self:updateButton(true)
            end 
           if bufferData.uid == SELF_UID then
                --如果自己还没看牌就弃牌
                player_:showKanpaiButton(false)
                self:hideAllBtn()
            end  
        end
        --开启倒计时
        if player_:getUserid() == bufferData.ply then
            self:doAction(player_,bufferData.time)
        end
    end 
end
--跟注/加注
function GameViewLayer:onEventAdd(bufferData)
    print("跟注/加注-------------------")
    dump(bufferData)
    local isGenzhu = true --#true 跟注，false 加注
    local lastInitMoney = self.m_initMoney
    self.m_initMoney = bufferData.chip[1]
    if self.m_initMoney>lastInitMoney then
        isGenzhu = false
    end
    for key, player_ in ipairs(self.m_playerTable) do
        if bufferData.uid == player_:getUserid() then
            --自己回合结束
            player_:onEventPlayerAdd(bufferData , isGenzhu)
            self:updateButton(false)
            player_:updateMoney( bufferData.chip[3], bufferData.chip[4] )  --更新自己的钱  背包的钱/总下注的钱  
	        player_:flytoCenterCoin(bufferData.chip[5])	    --飞金币  发起比牌的玩家交钱     --本次下的钱
            self:setColorPool(bufferData.chip[2])           --更新桌面显示的钱      总下注
        end
    end
    for key, player_ in ipairs(self.m_playerTable) do        
        if player_:getUserid() == SELF_UID then
            if bufferData.ply == SELF_UID then
                --轮到自己
                player_:showKanpaiButton(true)
                self.m_allAboutChip = bufferData.opt
                self:updateButton(true)
            end  
        end
        --开启倒计时
        if player_:getUserid() == bufferData.ply then
            self:doAction(player_,bufferData.time)
        end
    end 
end
--发牌
function GameViewLayer:onEventRun(bufferData) 
    print("玩家发牌-------------------")
    dump(bufferData)
    self.m_onGamePlayers = bufferData.us
    self.m_pPanelCards:removeAllChildren()
    self.m_pPanelLight:removeAllChildren()
	self.m_pPanelCards:setVisible(true)
    self:isShowMaskPanel(false)	--遮罩
    self:updateButton(false)
    --清除玩家自己位置前的等待下局游戏动画
--    self:freshXiaZhuBtn(false, tableinfo.basecoin)
    for key, player_ in ipairs(self.m_playerTable) do
        --清除所有玩家的状态
        player_:reSetPlayer()
    end
    --飞底注金币
    self:setColorPool(#bufferData.us * self.m_unitMoney)           --更新桌面显示的钱      总下注
    for key, player_ in ipairs(self.m_playerTable) do
        for key_, user in ipairs(bufferData.surplus_money_info) do
            if player_:getUserid() == user[1] then
                player_:updateMoney( user[2], self.m_unitMoney )  --更新自己的钱  背包的钱/总下注的钱  
	            player_:flytoCenterCoin(self.m_unitMoney)	    --飞金币  发起比牌的玩家交钱     --本次下的钱
            end
        end
    end    
    --发牌动画
    self:crateFlyCards()

    for key, player_ in ipairs(self.m_playerTable) do        
        if player_:getUserid() == SELF_UID then
            if bufferData.ply == SELF_UID then
                --第一次轮到自己以后就可以看牌                
                local showBut = function()
                    player_:showKanpaiButton(true)
                end
                self:doSomethingLater(showBut,1.5)
                self.m_allAboutChip = bufferData.opt
                self:updateButton(true)
            else
                self:updateButton(false)
            end
            
        end
        --开启倒计时
        if player_:getUserid() == bufferData.ply then
            self:doAction(player_,bufferData.time)
        end  
    end 
end
--中途进入房间
function GameViewLayer:onEventRun2(bufferData) 
    print("中途进入房间-------------------")
    dump(bufferData)
end
--看牌
function GameViewLayer:onEventShow(bufferData) 
    print("玩家看牌-------------------")
   dump(bufferData)
    for key, player_ in ipairs(self.m_playerTable) do
        if bufferData.uid == player_:getUserid() then
            player_:onEventPlayerShow(bufferData)
        end
        if bufferData.uid == SELF_UID then
            --第一次轮到自己以后就可以看牌
            player_:showKanpaiButton(false)
            self.m_allAboutChip = bufferData.opt
            self:kanUptadeButton()
        end 
    end
end
--比牌
function GameViewLayer:onEventVS(bufferData)  
    print("比牌-------------------")
    dump(bufferData)

    local finfo_id = bufferData.pid[1][1]
    local win_id = bufferData.pid[1][2]
    local lose_id = bufferData.pid[1][3]
    local cInfo_id = 0
    if finfo_id == win_id then
        cInfo_id = lose_id
    else
        cInfo_id = win_id
    end
    local fInfo,cInfo = nil
    for key, player_ in ipairs(self.m_playerTable) do
        if player_:getUserid() == finfo_id then
            fInfo = player_
        end
        if player_:getUserid() == cInfo_id then
            cInfo = player_
        end
        if player_:getUserid() == lose_id then
            player_:setIsQipai( true )
        end
        --开启倒计时
        if player_:getUserid() == bufferData.ply then
            self:doAction(player_,bufferData.time)
        end
    end  
	dump(fInfo,"发起人的数据")
	if fInfo:getChairId() == 1 then
--		dispatchEvent("stopCountdown")  -- 关闭倒计时
	end
    fInfo:updateMoney( bufferData.chip[5], bufferData.chip[4] )  --更新自己的钱  背包的钱/总下注的钱  
	fInfo:flytoCenterCoin(bufferData.chip[2])	    --飞金币  发起比牌的玩家交钱     --本次下的钱
    self:setColorPool(bufferData.chip[3])           --更新桌面显示的钱      总下注

---------------------以上部分需要保留

--	local sex = cc.loaded_packages.ZhajinhuaModel:getPlayerSexByClientIndex(fclient)
--	local sexName = sex == 0 and "woman/F_BIPAI" or "man/M_BIPAI"
--	performWithDelay(self, function ()
--		cc.loaded_packages.KKMusicPlayer:playEffect(string.format("zhajinhua/sound/%s.mp3", sexName),false)
--	end,0.5)
    local sound = function()
        ExternalFun.playSoundEffect("man/M_BIPAI.mp3")
    end
    self:doSomethingLater(sound,0.5)
	self:doSomethingLater(function ()
		    local view = ZhajinhuaVsView.create()   --添加比牌的层   --cc.loaded_packages.App:createLayer("app.games.zhajinhua.ZhajinhuaVsView")	
		    view:setData(fInfo,cInfo,win_id,self)	--pk层的
		    self:addChild(view)
	    end,0.1)

--	local winClient = cc.loaded_packages.ZhajinhuaModel:changeSeat(info.winnerseatindex)    --待删除
	if finfo_id == SELF_UID or cInfo_id == SELF_UID then
		if win_id ~= SELF_UID then
			cInfo:isCanPai(false)
            cInfo:showKanpaiButton(false)
		end
	end
	local delayFunc = function ()
		print(finfo_id,"----",cInfo_id,"---------",win_id)
		if win_id == cInfo_id then
			if finfo_id == SELF_UID then
				self:hideAllBtn()
				fInfo:showDoActionResult("比牌失败")
			end
			fInfo:showResultCard(1)
			fInfo:showPlayerState(3)
			fInfo:isCanPai(false)
            fInfo:showKanpaiButton(false)
		elseif win_id == finfo_id then
			if cInfo_id == SELF_UID then
				self:hideAllBtn()
				cInfo:showDoActionResult("比牌失败")
			end
			cInfo:showResultCard(1)
			cInfo:showPlayerState(3)
			cInfo:isCanPai(false)
            cInfo:showKanpaiButton(false)
		end
        if bufferData.ply == SELF_UID then --如果下个玩家是自己
            self.m_allAboutChip = bufferData.opt
            self:updateButton(true)
        end        
	end

	self:doSomethingLater(delayFunc , 1.4)	--当比牌失败的为自己的时候
end
--结算
function GameViewLayer:onEventOver(bufferData)    
    print("结算-------------------")
    dump(bufferData)
    self:isShowMaskPanel(false)
    self:allPlayerStopCD()
    self:hideAllBtn()
    local allChild = self.m_pPanelAnimation:getChildren()
    for key, player_ in ipairs(self.m_playerTable) do
		player_:stopCD()
		player_:clearAllLight() --清除着火动画
		player_:clearLoseAnimation()
		player_:isCanPai(false)
        player_:showKanpaiButton(false)
	end

    local isWin = false
	local winClient = bufferData.win
    for key, player_ in ipairs(self.m_playerTable) do
        for key, info_ in ipairs(bufferData.cs) do
            if player_:getUserid() == info_[1] then
                --获胜玩家
                if player_:getUserid() == winClient then
--		            player_:synSeatInfo()
	                player_:delayCenterCoinToHead()
	                player_:delayShowWinMoney(info_[2], self.m_pAtlas_winCoin)--self.winCoinNum)
                    if player_:getUserid() == SELF_UID then
                        player_:showSelfWinAnimation()
			            isWin = true
                    end
		        end
                player_:updateMoney( info_[6], 0 )
                --展示牌
                player_:setCardValue(info_[3],info_[4])  --1.牌面，2.牌型
            end
        end
        --开启倒计时
        if player_:getUserid() == SELF_UID then
            self:doAction(player_,bufferData.time)
        end	
	end

    self:setColorPool(0)
	self:hideVsTps()
    self:runAction(cc.Sequence:create(cc.DelayTime:create(3),cc.CallFunc:create(function()
        self.m_pBtnZhunbei:setVisible(true)
    end)))
end
--游戏结束
function GameViewLayer:onEventDeskover(bufferData)
    print("游戏结束-------------------")
    dump(bufferData)
    
    
end
-----------------------------------------------------------------------------------
function GameViewLayer:onHelpClicked( sender )
--帮助按钮
    ExternalFun.playClickEffect()
    local gameRuleLayer = GameRuleLayer.create()
    gameRuleLayer:addTo(self.m_rootWidget)
end
function GameViewLayer:onMenuClicked( sender )
--菜单按钮
    ExternalFun.playClickEffect()
--    _:disableQuickClick(self.m_btnMenu)
    local jiantou = self.m_pBtnMenu:getChildByName("Image_5")
    if self.m_pMenuState == false then
        self.m_pPanel_setting:setVisible(true)
        self.m_pImageSettingBg:runAction(cc.MoveBy:create(0.3,cc.p(190,0)))
        jiantou:runAction(cc.RotateTo:create(0.2,180))
        self.m_pMenuState = true
    else        
        self.m_pImageSettingBg:runAction(cc.Sequence:create(cc.MoveBy:create(0.3,cc.p(-190,0)),cc.CallFunc:create(function()
                self.m_pPanel_setting:setVisible(false)
            end)))
        jiantou:runAction(cc.RotateTo:create(0.2,90))
        self.m_pMenuState = false
    end

end
--准备按钮
function GameViewLayer:onZhunbeiClicked()
    ExternalFun.playClickEffect() 
    local clearFunc = function()
        for key, player_ in ipairs(self.m_playerTable) do
            player_:reSetPlayer()   --最后刷新这个
            player_:stopCD()
        end
	end
    self:runAction(cc.Sequence:create(cc.CallFunc:create(function()
        clearFunc()
    end),cc.DelayTime:create(0.5),cc.CallFunc:create(function()
        self._scene:sendReady()
    end)))
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
    settingLayer:addTo(self.m_rootWidget)
end

function GameViewLayer:onKanpaiClickEvent(  )
    --自身点击看牌
    self._scene:sendShow()
end
function GameViewLayer:onBipaiClickEvent( event )
    local uid = event.uid
    --点击比牌对象
    self._scene:sendVS( uid )
    --先在这里清除选择比牌对象的动画
    self:hideVsTps()
--    self.m_pVsSelectWarning:setVisible(false)
--    for k,player_ in pairs(self.m_playerTable) do
--		player_:clearSelectAnimation()
--	end
end
function GameViewLayer:onVSClicked(  )
    ExternalFun.playClickEffect() 
    --比牌
    --self._scene:sendVS(uid)
    local inGameNum = 0
    local inGamePlayers = {}
    for key, player_ in ipairs(self.m_playerTable) do
        if player_:getIsQiPai() == false then  
            if player_:getUserid() ~= SELF_UID then
                inGameNum = inGameNum +1
                table.insert(inGamePlayers,player_)
            end
        end
    end
    print("剩余玩家____________________"..inGameNum)
    --如果只剩一个玩家直接比牌
    if inGameNum == 1 then
        self._scene:sendVS(inGamePlayers[1]:getUserid())
        return
    end
--    self.vsTpsSelect:show()
    self.m_pVsSelectWarning:setVisible(true)
    for k,player_ in pairs(inGamePlayers) do
		player_:showSelectAnimation()
	end
end
function GameViewLayer:onGiveUpClicked(  )
    ExternalFun.playClickEffect() 
    --弃牌
    self._scene:sendDrop()
end
function GameViewLayer:onFollowEndClicked(  )
    ExternalFun.playClickEffect() 
    --跟到底
    if self.isGenDaodi == false then
        self.m_pBtnFollowEnd:getChildByName("Image_226"):getChildByName("image_followendImg"):setVisible(true)
        self.isGenDaodi = true
        self._scene:sendAdd(0)
    else
        self.isGenDaodi =false
        self.m_pBtnFollowEnd:getChildByName("Image_226"):getChildByName("image_followendImg"):setVisible(false)
    end
    
end
function GameViewLayer:onGenzhuClicked()
    ExternalFun.playClickEffect() 
    --跟注
    self._scene:sendAdd(0)
end
function GameViewLayer:onXiazhu1Clicked()
    ExternalFun.playClickEffect() 
    --下注1
    local beishu = 1
    for key, player_ in ipairs(self.m_playerTable) do
        if player_:getUserid() == SELF_UID then
            if player_:getIsKanPai() == true then
                beishu = 2
            end
        end
    end    
    self._scene:sendAdd(chipNum[1] * self.m_unitMoney * beishu)
end
function GameViewLayer:onXiazhu2Clicked()
    ExternalFun.playClickEffect() 
    --下注2
    local beishu = 1
    for key, player_ in ipairs(self.m_playerTable) do
        if player_:getUserid() == SELF_UID then
            if player_:getIsKanPai() == true then
                beishu = 2
            end
        end
    end
    self._scene:sendAdd(chipNum[2] * self.m_unitMoney * beishu)
end
function GameViewLayer:onXiazhu3Clicked()
    ExternalFun.playClickEffect() 
    --下注3
    local beishu = 1
    for key, player_ in ipairs(self.m_playerTable) do
        if player_:getUserid() == SELF_UID then
            if player_:getIsKanPai() == true then
                beishu = 2
            end
        end
    end
    self._scene:sendAdd(chipNum[3] * self.m_unitMoney * beishu)
end

----------------------------------------工具------------------------------------------
function GameViewLayer:hideVsTps()
	self.m_pVsSelectWarning:setVisible(false)
	--清除选中状态表现动画
	for key, player_ in ipairs(self.m_playerTable) do
		player_:clearSelectAnimation()
	end
end
function GameViewLayer:allPlayerStopCD()
	for key, player_ in ipairs(self.m_playerTable) do
		player_:stopCD()
	end
end
function GameViewLayer:setColorPool( allChip )
    self.m_pTextAllChip:setString(allChip)
end
function GameViewLayer:setBipaiState( event )
    --设置是否在比牌的状态
    self.isBipaiIng = event.ing
end

--是否展示遮罩
function GameViewLayer:isShowMaskPanel( ishow )
    if not ishow then
		self.m_pPanelCoin:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.CallFunc:create(function ()
			self.m_pPanelCoin:setVisible(ishow)
		end)))
	else
		self.m_pPanelCoin:setVisible(ishow)
	end
end
--刷新所有下注按钮上的金币数       是否看牌   单注钱
function GameViewLayer:freshXiaZhuBtn(isopen,base)
	for i = 1, 3 do
		if isopen then
			self["xiazhuv_"..i]:setString(string.format("+%d$", self["xiazhu"..i].add * base *2))
		else
			self["xiazhuv_"..i]:setString(string.format("+%d$", self["xiazhu"..i].add * base))
		end
	end
end
--创建牌并飞牌
function GameViewLayer:crateFlyCards()
    if self.m_pPanelCards then
        self.m_pPanelCards:setVisible(true)
        local cards = {}
	    self.m_allCards = {}
        for i = 1, #self.m_onGamePlayers * 3 do
		    local cardSpr = cc.Sprite:create("common/card/cardBack.png")
		    cardSpr:setScaleX(71/156)--setContentSize(cc.size(96,132))--:setContentSize(cc.size(71,98))
            cardSpr:setScaleY(98/214)
		    cardSpr:setPosition(cc.p(display.center.x, display.center.y + cardSpr:getContentSize().height/2))
		    self.m_pPanelCards:addChild(cardSpr, i)
		    table.insert(cards, cardSpr)
	    end
	    self.m_allCards = cards
    end
    --动画
    --筛选当前参与的玩家
	local haveNum = #self.m_onGamePlayers 
	print(haveNum,"当前人数")

--	for i = 1, #sortClientAttr do
--		--设置下注和剩余的钱
--	end
	for y = 1, 3 do
        for key, player_ in ipairs(self.m_playerTable) do
            for i = 1, haveNum do
                if self.m_onGamePlayers[i] == player_:getUserid() then
                    local ac = cc.MoveTo:create(0.1,cc.p(player_:getCardsPos()[y]))
			        local xuanzhuan = cc.RotateBy:create(0.1 , 360)
			        if player_:getUserid() == SELF_UID then
				        local wwc = cc.Spawn:create(ac,xuanzhuan,cc.CallFunc:create(function ()
--					        self.m_allCards[i + (y - 1) * haveNum]:setContentSize(cc.size(96,132))
                            self.m_allCards[i + (y - 1) * haveNum]:setScaleX(96/156)--setContentSize(cc.size(96,132))--:setContentSize(cc.size(71,98))
                            self.m_allCards[i + (y - 1) * haveNum]:setScaleY(132/214)
				        end))
				        self.m_allCards[i + (y - 1) * haveNum]:runAction(cc.Sequence:create(cc.DelayTime:create( i * 0.1 + (y - 1)* 0.1*haveNum),wwc,cc.CallFunc:create(function ()
--					        cc.loaded_packages.KKMusicPlayer:playEffect("zhajinhua/sound/FAIPAI.mp3",false)
                            ExternalFun.playSoundEffect("FAIPAI.mp3")
				        end)))
			        else
				        local wwc = cc.Spawn:create(ac,xuanzhuan,cc.CallFunc:create(function ()
				        end))
				        self.m_allCards[i + (y - 1) * haveNum]:runAction(cc.Sequence:create(cc.DelayTime:create( i * 0.1+ (y - 1)* 0.1 *haveNum),wwc,cc.CallFunc:create(function ()
--					        cc.loaded_packages.KKMusicPlayer:playEffect("zhajinhua/sound/FAIPAI.mp3",false)
                            ExternalFun.playSoundEffect("FAIPAI.mp3")
				        end)))
			        end
                end			        
		    end
        end  
	end
        
    local callF = cc.CallFunc:create(function()
        if self and self.removeCardAndToHeadCard then
			self:removeCardAndToHeadCard()
		end
        for key, player_ in ipairs(self.m_playerTable) do
            for _,v in pairs(self.m_onGamePlayers) do
                local uid = player_:getUserid()
                if v == uid then
                    player_:showCard()
                end
            end
		end
    end)
    self:runAction(cc.Sequence:create( cc.DelayTime:create(1.4),callF))
end

function GameViewLayer:removeCardAndToHeadCard()
	for i = 1, #self.m_allCards do
		if self.m_allCards[i] then
			self.m_pPanelCards:removeChild(self.m_allCards[i],true)
		end
	end
	self.m_pPanelCards:setVisible(false)
	self.m_allCards = {}
end
--弃牌飞牌动画
function GameViewLayer:showQuitCardAction( player_ )
    for i = 1, 3 do
        local ac = cc.MoveTo:create(0.3,cc.p(display.center.x, display.center.y + 59))
        local xuanzhuan = cc.RotateBy:create(0.3 , 360)
        local scaleTo = cc.ScaleTo:create(0.3, 0.5)

        local cardBei = cc.Sprite:create("common/card/cardBack.png")
        cardBei:setPosition(player_:getCardsPos()[i])
        self.m_pPanelCards:addChild(cardBei)   --self.m_pPanelCards --self.m_pPanelAnimation
        self.m_pPanelCards:setVisible(true)
        if player_:getChairId() == 1 then
            cardBei:setContentSize(cc.size(96,132))
        else
            cardBei:setContentSize(cc.size(71,98))
        end

        local wwc = cc.Spawn:create(ac,xuanzhuan,scaleTo)
        cardBei:runAction(cc.Sequence:create(wwc,cc.FadeOut:create(0.05),cc.CallFunc:create(function ()
            cardBei:setVisible(false)
            self.m_pPanelCards:setVisible(false)
        end),cc.RemoveSelf:create()))
    end
end
--隐藏所有按钮
function GameViewLayer:hideAllBtn(  )
    self.m_pBtnLiangPai:setVisible(false)     --= self.m_pImageBg:getChildByName("button_liangpai")                         --按钮 亮牌
    self.m_pBtnDdd:setVisible(false)          --= self.m_pImageBg:getChildByName("button_gdd")                              --按钮 跟到底
    self.m_pBtnXiazhu1:setVisible(false)      --= self.m_pImageBg:getChildByName("button_xiazhu1")                          --按钮 下注1
    self.m_pBtnXiazhu2:setVisible(false)      --= self.m_pImageBg:getChildByName("button_xiazhu2")                          --按钮 下注2
    self.m_pBtnXiazhu3:setVisible(false)      --= self.m_pImageBg:getChildByName("button_xiazhu3")                          --按钮 下注3
    self.m_pBtnGenzhu:setVisible(false)       --= self.m_pImageBg:getChildByName("button_followBtn")                        --按钮 跟注
    self.m_pBtnGiveUp:setVisible(false)                                                                                     --按钮 弃牌
    self.m_pBtnVS:setVisible(false)                                                                                         --按钮 比牌
    self.m_pBtnFollowEnd:setVisible(false)    --= self.m_pImageBg:getChildByName("button_followendBtn")                     --按钮 跟到底
--    self.m_pBtnFollowEnd:getChildByName("Image_226"):getChildByName("image_followendImg"):setVisible(false)
end

--更新按钮的显示    #isMyRound true自己回合，false其他玩家回合   self.m_unitMoney = 0    --底注
function GameViewLayer:updateButton( isMyRound )
    self:hideAllBtn()
    for key, player_ in ipairs(self.m_playerTable) do
        if player_:getUserid() == SELF_UID then
            if player_:getIsQiPai() == true then
                return
            end
        end
    end
    
    if not isMyRound then        
        --只显示跟到底
        self.m_pBtnFollowEnd:setVisible(true)
        return
    end
    if self.isGenDaodi == true then
        self._scene:sendAdd(0)
        return
    end
    local initMoney = self.m_initMoney  --当前暗注		#当前暗注是底注倍数
    local opt = self.m_allAboutChip
    local isKanpai = 1
    for key, player_ in ipairs(self.m_playerTable) do
        if player_:getUserid() == SELF_UID then            
            if player_:getIsKanPai() == true then
                isKanpai = 2
            end
        end
    end
    self.m_pBtnXiazhu1:getChildByName("bmfont_xiazhuv_1"):setString(string.format("+%d$",chipNum[1]*isKanpai*self.m_unitMoney))
    self.m_pBtnXiazhu2:getChildByName("bmfont_xiazhuv_2"):setString(string.format("+%d$",chipNum[2]*isKanpai*self.m_unitMoney))
    self.m_pBtnXiazhu3:getChildByName("bmfont_xiazhuv_3"):setString(string.format("+%d$",chipNum[3]*isKanpai*self.m_unitMoney))
    if initMoney < chipNum[1] then
        self.m_pBtnXiazhu1:setVisible(true)
        self.m_pBtnXiazhu2:setVisible(true)
        self.m_pBtnXiazhu3:setVisible(true)
    elseif initMoney < chipNum[2] then
        self.m_pBtnXiazhu2:setVisible(true)
        self.m_pBtnXiazhu3:setVisible(true)
    elseif initMoney < chipNum[3] then
        self.m_pBtnXiazhu3:setVisible(true)
    end
    self.m_pBtnGenzhu:getChildByName("text_genCoin"):setString("%&"..opt[3].."$")
    self.m_pBtnGenzhu:setVisible(true)
    if opt[4] == 1 then --是否可以比牌
        self.m_pBtnVS:setVisible(true)    
    end
    if opt[7] == 1 then --是否可以弃牌
        self.m_pBtnGiveUp:setVisible(true)    
    end
end
--看牌更新按钮显示
function GameViewLayer:kanUptadeButton(  )
    local initMoney = self.m_initMoney  --当前暗注		#当前暗注是底注倍数
    local opt = self.m_allAboutChip
    local isKanpai = 1
    for key, player_ in ipairs(self.m_playerTable) do
        if player_:getUserid() == SELF_UID then            
            if player_:getIsKanPai() == true then
                isKanpai = 2
            end
        end
    end
    self.m_pBtnXiazhu1:getChildByName("bmfont_xiazhuv_1"):setString(string.format("+%d$",chipNum[1]*isKanpai*self.m_unitMoney))
    self.m_pBtnXiazhu2:getChildByName("bmfont_xiazhuv_2"):setString(string.format("+%d$",chipNum[2]*isKanpai*self.m_unitMoney))
    self.m_pBtnXiazhu3:getChildByName("bmfont_xiazhuv_3"):setString(string.format("+%d$",chipNum[3]*isKanpai*self.m_unitMoney))
    self.m_pBtnGenzhu:getChildByName("text_genCoin"):setString("%&"..opt[3].."$")
end
function GameViewLayer:doAction(player,time)  
    for key, player_ in ipairs(self.m_playerTable) do
        player_:stopCD()
    end
      
    player:startCD(time)
end

--延时回调
function GameViewLayer:doSomethingLater( call, delay )
    self.m_rootWidget:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(call)))
end

-----------------------------------------------------------------------------------------------------------------



function GameViewLayer:getParentNode()
    return self._scene
end






function GameViewLayer:unloadResource()
--    if self.bgAnimation then
--        self.bgAnimation:removeFromParent()    
--    end ONEVENT_BIPAI_CLICK "bipai_state"
    SLFacade:removeCustomEventListener(GameRoleItem.ONEVENT_KANPAI_CLICK, self.__cname)
    SLFacade:removeCustomEventListener(GameRoleItem.ONEVENT_BIPAI_CLICK, self.__cname)
    SLFacade:removeCustomEventListener("bipai_state", self.__cname)
--    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/heguan_1/heguan_1.ExportJson")   --荷官
--    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/dengdai_1/dengdai_1.ExportJson")   --等待下一局
--    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/wait-player/wait-player.ExportJson")   --等待其他玩家
--    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/paopaokuang_zhajinhua/paopaokuang_zhajinhua.ExportJson")   --泡泡框提示
--    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/pk_bipai/pk_bipai.ExportJson")   --比牌
--    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/qipai/qipai.ExportJson")   --弃牌
--    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/xiazhu_danshou/xiazhu_danshou.ExportJson")   --下注单手左右
--    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/xiazhu_qian/xiazhu_qian.ExportJson")   --下注单手自身
--    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/allin_you2/allin_you2.ExportJson")   --下注双手左右
--    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/allin_qian/allin_qian.ExportJson")   --下注双手自身
--    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/kebipai_1/kebipai_1.ExportJson")        --可比牌



    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
end
-- 重置
function GameViewLayer:reSetGame( bFreeState )
    
end

-- 重置(新一局)
function GameViewLayer:reSetForNewGame()
    
end

-- 重置用户状态
function GameViewLayer:reSetUserState()
    
end

-- 重置用户信息
function GameViewLayer:reSetUserInfo()

end

function GameViewLayer:onExit()
    --cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._ClockFun) 
    if self._FaPaiFun ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._FaPaiFun) 
    end
    if nil ~= self.m_actRocketRepeat then
        self.m_actRocketRepeat:release()
        self.m_actRocketRepeat = nil
    end

    if nil ~= self.m_actRocketShoot then
        self.m_actRocketShoot:release()
        self.m_actRocketShoot = nil
    end

    if nil ~= self.m_actPlaneRepeat then
        self.m_actPlaneRepeat:release()
        self.m_actPlaneRepeat = nil
    end

    if nil ~= self.m_actPlaneShoot then
        self.m_actPlaneShoot:release()
        self.m_actPlaneShoot = nil
    end

    if nil ~= self.m_actBomb then
        self.m_actBomb:release()
        self.m_actBomb = nil
    end
    self:unloadResource()

    self.m_tabUserItem = {}
    
end


return GameViewLayer