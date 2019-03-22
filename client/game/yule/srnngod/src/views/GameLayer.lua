local GameModel = appdf.req(appdf.CLIENT_SRC.."gamemodel.GameModel")
local GameLayer = class("GameLayer", GameModel)

local module_pre = "game.yule.srnngod.src"
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local cmd = appdf.req(module_pre .. ".models.CMD_Game")
local GameLogic = appdf.req(module_pre .. ".models.GameLogic")
local GameViewLayer = appdf.req(module_pre .. ".views.layer.GameViewLayer")
local GameResultLayer = appdf.req(module_pre .. ".views.layer.GameResultLayer")
local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
GameLayer.Res = "game/yule/tbnngod/res/"

function GameLayer:ctor( frameEngine,scene )      
    cc.FileUtils:getInstance():addSearchPath(GameLayer.Res)  
    GameLayer.super.ctor(self, frameEngine, scene)
    print("on enter -----------===========----------    GameLayer")

end


--获取gamekind
function GameLayer:getGameKind()
    return cmd.KIND_ID
end

--创建场景
function GameLayer:CreateView()
    return GameViewLayer:create(self)
        :addTo(self)
end

function GameLayer:getParentNode( )
    return self._scene
end

function GameLayer:getFrame( )
    return self._gameFrame
end

function GameLayer:logData(msg)
    if nil ~= self._scene.logData then
        self._scene:logData(msg)
    end
end

function GameLayer:reSetData()
    self.m_bIsMyBanker = false
    self.m_tabPromptList = {}
    self.m_tabCurrentCards = {}
    self.m_tabPromptCards = {}
    self.m_bLastCompareRes = false
    self.m_nLastOutViewId = cmd.INVALID_VIEWID
    self.m_tabLastCards = {}  
    self.m_cbBankerChair = yl.INVALID_CHAIR
end

---------------------------------------------------------------------------------------
------继承函数
function GameLayer:getVideoLayerConfig()
    return 
    {
        pos = cc.p(667, 90),
        wChairCount = self._gameFrame._wChairCount,
        maskOpacity = 50
    }
end

function GameLayer:onEnterTransitionFinish()
    GameLayer.super.onEnterTransitionFinish(self)
end

function GameLayer:onExit()
    self:KillGameClock()
    self:dismissPopWait()
    GameLayer.super.onExit(self)
end

--退出桌子
function GameLayer:onExitTable()
    self:KillGameClock()
    self._gameFrame:StandUp()
    self:onExitRoom()
end

--离开房间
function GameLayer:onExitRoom()
    self._scene:onKeyBack()
end

--换位操作
function GameLayer:onChangeDesk()
    self._gameFrame:QueryChangeDesk()
end

-- 计时器响应
function GameLayer:OnEventGameClockInfo(chair,time,clockId)
    if nil ~= self._gameView and nil ~= self._gameView.updateClock then
        self._gameView:updateClock(clockId, time)
    end
end

-- 设置计时器
function GameLayer:SetGameClock(chair,id,time)
    GameLayer.super.SetGameClock(self,chair,id,time)
end

function GameLayer:onGetSitUserNum()
    return table.nums(self._gameView.m_tabUserHead)
end

function GameLayer:getUserInfoByChairID( chairid )
    local viewId = self:SwitchViewChairID(chairid)
    return self._gameView.m_tabUserItem[viewId]
end

function GameLayer:OnResetGameEngine()
    self._gameView:reSetForNewGame()
    self:reSetData() 
    GameLayer.super.OnResetGameEngine(self)
end

--系统消息
function GameLayer:onSystemMessage( wType,szString )
    if self.m_bStartGame then
        local msg = szString or ""
        self.m_querydialog = QueryDialog:create(msg,function()
            self:onExitTable()
        end,nil,1)
        self.m_querydialog:setCanTouchOutside(false)
        self.m_querydialog:addTo(self)
    else
        self.m_bPriScoreLow = true
        self.m_szScoreMsg = szString
    end
end

-- 用户截屏
function GameLayer:onTakeScreenShot(imagepath)
    if type(imagepath) == "string" then
        local exit = cc.FileUtils:getInstance():isFileExist(imagepath)
        print(exit)
        if exit then
            local shareLayer = cc.CSLoader:createNode("game/ShareLayer.csb"):addTo(self)
            local TAG_WXSHARE = 101
            local TAG_CYCLESHARE = 102
            local MASK_PANEL = 103
            -- 按钮事件
            local touchFunC = function(ref, tType)
                if tType == ccui.TouchEventType.ended then
                    local tag = ref:getTag()
                    local target = nil
                    if TAG_WXSHARE == tag then
                        target = yl.ThirdParty.WECHAT
                    elseif TAG_CYCLESHARE == tag then
                        target = yl.ThirdParty.WECHAT_CIRCLE
                    elseif MASK_PANEL == tag then
                        
                    end
                    if nil ~= target then
                        MultiPlatform:getInstance():shareToTarget(
                            target, 
                            function(isok)

                            end,
                            "截图分享", 
                            "分享我的游戏截图", 
                            yl.HTTP_URL, 
                            imagepath, 
                            "true"
                        )
                    end
                    shareLayer:removeFromParent()
                end
            end
            -- 微信按钮
            local btn = shareLayer:getChildByName("btn_wxshare")
            btn:setTag(TAG_WXSHARE)
            btn:addTouchEventListener( touchFunC )
            -- 朋友圈按钮
            btn = shareLayer:getChildByName("btn_cycleshare")
            btn:setTag(TAG_CYCLESHARE)
            btn:addTouchEventListener( touchFunC )
            -- 屏蔽层
            local panel = shareLayer:getChildByName("share_panel")
            panel:setTag(MASK_PANEL)
            panel:addTouchEventListener( touchFunC )
        else
            print("no image")
        end
    end
end

-- 刷新提示列表
-- @param[cards]        出牌数据
-- @param[handCards]    手牌数据
-- @param[outViewId]    出牌视图id
-- @param[curViewId]    当前视图id
function GameLayer:updatePromptList(cards, handCards, outViewId, curViewId)
    self.m_tabCurrentCards = cards
    self.m_tabPromptList = {}

    local result = {}
    if outViewId == curViewId then
        self.m_tabCurrentCards = {}
        result = GameLogic:SearchOutCard(handCards, #handCards, {}, 0)
    else
        result = GameLogic:SearchOutCard(handCards, #handCards, cards, #cards)
    end

    --dump(result, "出牌提示", 6)    
    local resultCount = result[1]
    print("## 提示牌组 " .. resultCount)
    for i = resultCount, 1, -1 do
        local tmplist = {}
        local total = result[2][i]
        local cards = result[3][i]
        local cardscount = #cards
        if cardscount > total then
            --print("## 组合列表 ##")
            local combins = ExternalFun.idx_combine(cardscount, total, true)
            for k = 1, #combins do
                local comb = combins[k]
                if #comb == total then
                    --print(" #组合" .. k .. "# ")
                    local combCard = {}
                    for m, n in pairs(comb) do
                        --print(" comb k, v", m, n)
                        local cbCardData = cards[n] or 0
                        combCard[m] = cbCardData
                    end
                    table.insert(self.m_tabPromptList, combCard)
                end
            end
        else
            for j = 1, total do
                local cbCardData = cards[j] or 0
                table.insert(tmplist, cbCardData)
            end
            table.insert(self.m_tabPromptList, tmplist)
        end
    end
    
    self.m_tabPromptCards = self.m_tabPromptList[#self.m_tabPromptList] or {}
    self._gameView.m_promptIdx = 0
end

-- 扑克对比
-- @param[cards]        当前出牌
-- @param[outView]      出牌视图id
function GameLayer:compareWithLastCards( cards, outView)
    local bRes = false
    self.m_bLastCompareRes = false
    local outCount = #cards
    if outCount > 0 then
        if outView ~= self.m_nLastOutViewId then
            --返回true，表示cards数据大于m_tagLastCards数据
            self.m_bLastCompareRes = GameLogic:CompareCard(self.m_tabLastCards, #self.m_tabLastCards, cards, outCount)
            self.m_nLastOutViewId = outView
        end
        self.m_tabLastCards = cards
    end
    return bRes
end

------------------------------------------------------------------------------------------------------------
--网络处理
------------------------------------------------------------------------------------------------------------

-- 发送准备
function GameLayer:sendReady()
    --self:KillGameClock()  --倒计时进度条 暂时还没写
    local msgdata = {}
    msgdata["type"] = "djnn"
    msgdata["tag"] = "start"
    msgdata["body"] = nil
    local strvalue = cjson.encode(msgdata)
    self._gameFrame:sendSocketData(strvalue)
end
-- 发送摊牌
function GameLayer:sendTanPai()
    --self:KillGameClock()    --倒计时进度条 暂时还没写
    local msgdata = {}
    msgdata["type"] = "djnn"
    msgdata["tag"] = "ok"
    msgdata["body"] = nil
    local strvalue = cjson.encode(msgdata)
    self._gameFrame:sendSocketData(strvalue)
end
-- 发送换桌
function GameLayer:sendChangeTable()
    --self:KillGameClock()    --倒计时进度条 暂时还没写
    local msgdata = {}
    msgdata["type"] = "game"
    msgdata["tag"] = "changedesk"
    local strvalue = cjson.encode(msgdata)
    self._gameFrame:sendSocketData(strvalue)
end
-- 发送抢/不抢庄
function GameLayer:sendAskBanker(isQiang)
    local msgdata = {}
    msgdata["type"] = "djnn"
    msgdata["tag"] = "re_banker"
    msgdata["body"] = isQiang
    local strvalue = cjson.encode(msgdata)
    self._gameFrame:sendSocketData(strvalue)
end
-- 发送下注
function GameLayer:sendChip_in(num)
    local msgdata = {}
    msgdata["type"] = "djnn"
    msgdata["tag"] = "chip_in"
    msgdata["body"] = num
    local strvalue = cjson.encode(msgdata)
    self._gameFrame:sendSocketData(strvalue)
end

-- 发送叫分
function GameLayer:sendCallScore( score )
    self:KillGameClock()
    local cmddata = CCmd_Data:create(1)
    cmddata:pushbyte(score)
    self:SendData(cmd.SUB_C_CALL_SCORE,cmddata)
end

-- 发送出牌
function GameLayer:sendOutCard(cards, bPass)
    self:KillGameClock()
    if bPass then
        local cmddata = CCmd_Data:create()
        self:SendData(cmd.SUB_C_PASS_CARD,cmddata)
    else
        local cardcount = #cards
        local cmddata = CCmd_Data:create(1 + cardcount)
        cmddata:pushbyte(cardcount)
        for i = 1, cardcount do
            cmddata:pushbyte(cards[i])
        end
        self:SendData(cmd.SUB_C_OUT_CARD,cmddata)
    end
end

-- 发送查询记录
function GameLayer:sendRequestRecord()
    local cmddata = CCmd_Data:create(0)
    --self:SendData(cmd.SUB_C_REQUEST_RCRecord,cmddata)
end

-- 场景信息
function GameLayer:onEventGameScene(cbGameStatus,dataBuffer)
    print("场景数据:" .. cbGameStatus)
    if self.m_bOnGame then
        return
    end
    self.m_cbGameStatus = cbGameStatus
    self.m_bOnGame = true

    --清理玩家
    for i=1,cmd.PLAYER_COUNT do
        local wViewChairId = self:SwitchViewChairID(i-1)
        local roleItem = self._gameView.m_tabUserHead[wViewChairId]
        if nil ~= roleItem then
            roleItem:removeFromParent()
            self._gameView.m_tabUserHead[wViewChairId] = nil
        end
        self._gameView:onUserReady(wViewChairId, false)
    end

    --初始化已有玩家
    for i = 1, cmd.PLAYER_COUNT do
        local userItem = self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), i-1)
        if nil ~= userItem then
            local wViewChairId = self:SwitchViewChairID(i-1)
            self._gameView:OnUpdateUser(wViewChairId, userItem)
            if PriRoom then
                PriRoom:getInstance():onEventUserState(wViewChairId, userItem, false)
            end
        end
    end
    
    if cbGameStatus == cmd.GAME_SCENE_FREE then                                 --空闲状态
        self:onEventGameSceneFree(dataBuffer)
    elseif cbGameStatus == cmd.GAME_SCENE_CALL then                             --叫分状态
        self.m_bCallStateEnter = true
        self:onEventGameSceneCall(dataBuffer)        
    elseif cbGameStatus == cmd.GAME_SCENE_PLAY then                             --游戏状态
        self:onEventGameScenePlay(dataBuffer)
    end
    -- 查询记录
    if GlobalUserItem.bPrivateRoom then
        self:sendRequestRecord()
    end
    self:dismissPopWait()
end

function GameLayer:onEventGameSceneFree( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_StatusFree, dataBuffer)
    dump(cmd_table, "scene free", 6)
    cmd.COUNTDOWN_READY = cmd_table.cbTimeStartGame
    cmd.COUNTDOWN_CALLSCORE = cmd_table.cbTimeCallScore
    cmd.COUNTDOWN_OUTCARD = cmd_table.cbTimeOutCard
    cmd.COUNTDOWN_HANDOUTTIME = cmd_table.cbTimeHeadOutCard
    -- 更新底分
    self._gameView:onGetCellScore(cmd_table.lCellScore)
    self.m_nDiFen = cmd_table.lCellScore

    -- 空闲消息
    self._gameView:onGetGameFree()

    self:KillGameClock()
    -- 私人房无倒计时
    if not GlobalUserItem.bPrivateRoom then
        -- 设置倒计时
        self:SetGameClock(self:GetMeChairID(), cmd.TAG_COUNTDOWN_READY, cmd.COUNTDOWN_READY)  
    else
    -- 私人房直接发送准备 20170724屏蔽 不需要发送准备
        --self._gameView:onClickReady()
    end    
end

function GameLayer:onEventGameSceneCall( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_StatusCall, dataBuffer)
    dump(cmd_table, "scene call", 6)
    cmd.COUNTDOWN_READY = cmd_table.cbTimeStartGame
    cmd.COUNTDOWN_CALLSCORE = cmd_table.cbTimeCallScore
    cmd.COUNTDOWN_OUTCARD = cmd_table.cbTimeOutCard
    cmd.COUNTDOWN_HANDOUTTIME = cmd_table.cbTimeHeadOutCard

    self._gameView:onGetGameCallScore()
    self.m_bRoundOver = false
    -- 更新底分
    self._gameView:onGetCellScore(cmd_table.lCellScore)
    self.m_nDiFen = cmd_table.lCellScore
 
    -- 叫分信息
    local scoreinfo = cmd_table.cbScoreInfo[1]
    local tmpScore = 0
    local lastScore = 0
    local lastViewId = self:SwitchViewChairID(cmd_table.wCurrentUser)
    for i = 1, 3 do
        local chair = i - 1
        local score = scoreinfo[i]
        -- 扑克
        local viewId = self:SwitchViewChairID(chair)
        if chair ~= cmd_table.wCurrentUser and 0 ~= score then
            self._gameView:onGetCallScore(-1, viewId, 0, score, true)
        end

        if 0 ~= score then
            tmpScore = ((score == 255) and 0 or score)
        end

        if tmpScore > lastScore then
            lastScore = tmpScore
            lastViewId = viewId
        end
    end
    -- 叫分状态
    local currentScore = cmd_table.cbBankerScore
    local curViewId = self:SwitchViewChairID(cmd_table.wCurrentUser)

    -- 玩家拿牌
    local cards = GameLogic:SortCardList(cmd_table.cbHandCardData[1], cmd.NORMAL_COUNT, 0)
    self._gameView:onGetGameCard(cmd.MY_VIEWID, cards, true)
    -- 其余玩家
    local empTyCard = GameLogic:emptyCardList(cmd.NORMAL_COUNT)
    self._gameView:onGetGameCard(cmd.LEFT_VIEWID, empTyCard, true)
    empTyCard = GameLogic:emptyCardList(cmd.NORMAL_COUNT)
    self._gameView:onGetGameCard(cmd.RIGHT_VIEWID, empTyCard, true)

    self._gameView:onGetCallScore(curViewId, lastViewId, currentScore, lastScore, false)
    -- 设置倒计时
    self:SetGameClock(cmd_table.wCurrentUser, cmd.TAG_COUNTDOWN_CALLSCORE, cmd.COUNTDOWN_CALLSCORE)
    -- 庄家扑克
    for k,v in pairs(self._gameView.m_tabBankerCard) do
        v:setVisible(true)
    end

    -- 刷新局数
    if PriRoom and GlobalUserItem.bPrivateRoom then
        local curcount = PriRoom:getInstance().m_tabPriData.dwPlayCount
        PriRoom:getInstance().m_tabPriData.dwPlayCount = curcount - 1
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            self._gameView._priView:onRefreshInfo()
        end
    end
    -- 倍数
    self._gameView:onGetGameTimes(cmd_table.lScoreTimes)
end

function GameLayer:onEventGameScenePlay( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_StatusPlay, dataBuffer)
    --dump(cmd_table, "scene play", 6)
    cmd.COUNTDOWN_READY = cmd_table.cbTimeStartGame
    cmd.COUNTDOWN_CALLSCORE = cmd_table.cbTimeCallScore
    cmd.COUNTDOWN_OUTCARD = cmd_table.cbTimeOutCard
    cmd.COUNTDOWN_HANDOUTTIME = cmd_table.cbTimeHeadOutCard

    self._gameView:onGetGamePlay()
    self.m_bRoundOver = false
    -- 更新底分
    self._gameView:onGetCellScore(cmd_table.lCellScore)
    self.m_nDiFen = cmd_table.lCellScore

    -- 用户手牌
    local countlist = cmd_table.cbHandCardCount[1]
    for i = 1, 3 do
        local chair = i - 1
        local cards = {}
        local count = countlist[i]
        local viewId = self:SwitchViewChairID(chair)
        if cmd.MY_VIEWID == viewId then
            local tmp = cmd_table.cbHandCardData[1]
            for j = 1, count do
                table.insert(cards, tmp[j])
            end
            cards = GameLogic:SortCardList(cards, count, 0)
        else
            cards = GameLogic:emptyCardList(count)
        end
        self._gameView:onGetGameCard(viewId, cards, true)
    end

    -- 庄家信息    
    local bankerView = self:SwitchViewChairID(cmd_table.wBankerUser)
    local bankerCards = GameLogic:SortCardList(cmd_table.cbBankerCard[1], 3, 0)
    local bankerscore = cmd_table.cbBankerScore
    if self:IsValidViewID(bankerView) then
        self._gameView:onGetBankerInfo(bankerView, bankerscore, bankerCards, true)
    end
    self.m_cbBankerChair = cmd_table.wBankerUser
    -- 自己是否庄家
    self.m_bIsMyBanker = (bankerView == cmd.MY_VIEWID)
    
    -- 出牌信息
    local cbOutTime = cmd_table.cbTimeOutCard
    local lastOutView = self:SwitchViewChairID(cmd_table.wTurnWiner)
    local outCards = {}
    local serverOut = cmd_table.cbTurnCardData[1]
    for i = 1, cmd_table.cbTurnCardCount do
        table.insert(outCards, serverOut[i])
    end
    outCards = GameLogic:SortCardList(outCards, cmd_table.cbTurnCardCount, 0)
    local currentView = self:SwitchViewChairID(cmd_table.wCurrentUser)
    if self:IsValidViewID(lastOutView) and self:IsValidViewID(currentView) then
        self.m_nLastOutViewId = lastOutView
        self:compareWithLastCards(outCards, lastOutView)

        --if currentView == cmd.MY_VIEWID then
            -- 构造提示
            local handCards = self._gameView.m_tabNodeCards[cmd.MY_VIEWID]:getHandCards()
            self:updatePromptList(outCards, handCards, currentView, lastOutView)
        --end

        -- 不出按钮
        --[[if #self.m_tabPromptList > 0 then
            --#self.m_tabPromptList > 0
            self._gameView:onChangePassBtnState(not (currentView == lastOutView))
        else
            self._gameView:onChangePassBtnState( true )
        end]]      

        self._gameView:onGetOutCard(currentView, lastOutView, outCards, true)

        -- 设置倒计时
        self:SetGameClock(cmd_table.wCurrentUser, cmd.TAG_COUNTDOWN_OUTCARD, cmd.COUNTDOWN_OUTCARD)
    end

    -- 倍数
    self._gameView:onGetGameTimes(cmd_table.lScoreTimes)
end

function GameLayer:onEventGameMessage(sub,dataBuffer)   --接收消息通知
    print(sub.."--------------------------------")
    dump(dataBuffer,"***************************")
    if nil == self._gameView then
        return
    end
    if sub == "enter" then      --自身玩家进入房间    
        dump(dataBuffer)
        self._gameView:initGameData_And_View(dataBuffer)
    elseif sub == "ready" then  --id为uid的玩家准备开始游戏
        self._gameView:updataUserState(dataBuffer)
    elseif sub == "come" then   --有玩家进入房间
        self._gameView:updataPlayerPanpel(dataBuffer.memberinfo)
    elseif sub == "ok" then     --该uid玩家点击摊牌
        print("该uid玩家点击摊牌")
        self._gameView:onPlayerShow(dataBuffer)
    elseif sub == "leave" then     --该uid玩家离开房间
        print("该uid玩家离开房间")
        self._gameView:onUserLeave(dataBuffer)
    elseif sub == "run" then     --开始游戏 发前4张牌
        self._gameView:onFaPai(dataBuffer)
        --托管翻牌
        if self._gameView.isTuoGuan then
            self._gameView:onTanPai()
        end
    elseif sub == "end" then      --结算
        self._gameView:onGameEnd(dataBuffer)
    elseif sub == "deskover" then     --该局结束 
        self._gameView:onDeskOver()
        --托管准备
        if self._gameView.isTuoGuan then
            self._gameView:onReady()
        end
    elseif sub == "update_intomoney" then      --更新自身玩家的背包金额
        self._gameView:updataMyMoney(dataBuffer)
    elseif sub == "on_update" then      --更新该uid账号玩家的背包金额
        self._gameView:updatdOthersMoney(dataBuffer)
    elseif sub == "late" then      --自身玩家中途进入房间-----------
        dump(dataBuffer)
        print("__________________________________________")
        self._gameView:intoGameLate(dataBuffer)
    elseif sub == "ask_banker" then      --玩家开始叫庄
        dump(dataBuffer)
        self._gameView:onBeginZhuang(dataBuffer)
    elseif sub == "start_chip" then      --开始下注
        dump(dataBuffer)
        self._gameView:onXiazhu(dataBuffer)
    elseif sub == "chip" then      --该uid玩家下注chip
        self._gameView:theUidChip(dataBuffer)
    elseif sub == "deal" then      --下注结束 发第5张牌------------
        dump(dataBuffer)
        self._gameView:onFifthCard(dataBuffer)
    elseif sub == "update_intomoney" then      --更新自身玩家的背包金额-----------
        self._gameView:updataSelfMoney(dataBuffer)
    elseif sub == "on_update" then      --更新该uid账号玩家的背包金额----------------
        self._gameView:updataOtherMoney(dataBuffer)
     elseif sub == "grab_banker_info" then      --收到玩家叫庄倍数
        self._gameView:onEventGrab_banker_info(dataBuffer)
    elseif sub == "grab_banker_result" then      --收到叫庄结果
        self._gameView:onEventGrab_banker_result(dataBuffer)
    end
end

-- 文本聊天
function GameLayer:onUserChat(chatdata, chairid)
    local viewid = self:SwitchViewChairID(chairid)    
    if self:IsValidViewID(viewid) then
        self._gameView:onUserChat(chatdata, viewid)
    end
end

-- 表情聊天
function GameLayer:onUserExpression(chatdata, chairid)
    local viewid = self:SwitchViewChairID(chairid)
    if self:IsValidViewID(viewid) then
        self._gameView:onUserExpression(chatdata, viewid)
    end
end

-- 语音播放开始
function GameLayer:onUserVoiceStart( useritem, filepath )
    local viewid = self:SwitchViewChairID(useritem.wChairID)
    local roleItem = self._gameView.m_tabUserHead[viewid]
    if nil ~= roleItem then
        roleItem:onUserVoiceStart()
    end
end

-- 语音播放结束
function GameLayer:onUserVoiceEnded( useritem, filepath )
    local viewid = self:SwitchViewChairID(useritem.wChairID)
    local roleItem = self._gameView.m_tabUserHead[viewid]
    if nil ~= roleItem then
        roleItem:onUserVoiceEnded()
    else
        for k,v in pairs(self._gameView.m_tabUserHead) do
            v:onUserVoiceEnded()
        end
    end
end

-- 游戏开始
function GameLayer:onSubGameStart(dataBuffer)
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_GameStart, dataBuffer)
    local this = self
    --dump(cmd_table, "onSubGameStart", 6)

    self.m_bRoundOver = false
    self:reSetData()
    --游戏开始
    self._gameView:onGameStart()
    local curView = self:SwitchViewChairID(cmd_table.wCurrentUser)
    local startView = self:SwitchViewChairID(cmd_table.wStartUser)   

    self:KillGameClock()
    if self:IsValidViewID(curView) and self:IsValidViewID(startView) then
        print("&& 游戏开始 " .. curView .. " ## " .. startView)
        -- 音效
        ExternalFun.playSoundEffect( "start.wav" )
        --发牌
        local carddata = GameLogic:SortCardList(cmd_table.cbCardData[1], cmd.NORMAL_COUNT, 0)
        self._gameView:onGetGameCard(cmd.MY_VIEWID, carddata, false, cc.CallFunc:create(function()
            this._gameView:onGetCallScore(curView, startView, 0, -1)
            -- 设置倒计时
            this:SetGameClock(cmd_table.wCurrentUser, cmd.TAG_COUNTDOWN_CALLSCORE, cmd.COUNTDOWN_CALLSCORE)
        end))
    else
        print("viewid invalid" .. curView .. " ## " .. startView)
    end
end

-- 用户叫分
function GameLayer:onSubCallScore(dataBuffer)
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_CallScore, dataBuffer)
    --dump(cmd_table, "CMD_S_CallScore", 3)

    local curView = self:SwitchViewChairID(cmd_table.wCurrentUser)
    local lastView = self:SwitchViewChairID(cmd_table.wCallScoreUser)    

    self:KillGameClock()
    if self:IsValidViewID(curView) and self:IsValidViewID(lastView) then
        print("&& 游戏叫分 " .. curView .. " ## " .. lastView)
        self._gameView:onGetCallScore(curView, lastView, cmd_table.cbCurrentScore, cmd_table.cbUserCallScore)

        -- 设置倒计时
        self:SetGameClock(cmd_table.wCurrentUser, cmd.TAG_COUNTDOWN_CALLSCORE, cmd.COUNTDOWN_CALLSCORE)
    else
        print("viewid invalid" .. curView .. " ## " .. lastView)
    end    
end

-- 庄家信息
function GameLayer:onSubBankerInfo(dataBuffer)
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_BankerInfo, dataBuffer)
    --dump(cmd_table, "onSubBankerInfo", 6)
    local bankerView = self:SwitchViewChairID(cmd_table.wBankerUser)
    local curView = self:SwitchViewChairID(cmd_table.wCurrentUser)

    -- 自己是否庄家
    self.m_bIsMyBanker = (bankerView == cmd.MY_VIEWID)

    self:KillGameClock()
    -- 庄家信息
    if self:IsValidViewID(bankerView) and self:IsValidViewID(curView) then
        print("&& 庄家信息 " .. bankerView .. " ## " .. curView)
        -- 音效
        ExternalFun.playSoundEffect( "bankerinfo.wav" )

        self.m_cbBankerChair = cmd_table.wBankerUser
        local bankercard = GameLogic:SortCardList(cmd_table.cbBankerCard[1], 3, 0)
        self._gameView:onGetBankerInfo(bankerView, cmd_table.cbBankerScore, bankercard, false)

        self.m_nLastOutViewId = bankerView
        -- 构造提示
        local handCards = self._gameView.m_tabNodeCards[bankerView]:getHandCards()
        if bankerView == cmd.MY_VIEWID then
            self:updatePromptList({}, handCards, cmd.MY_VIEWID, cmd.MY_VIEWID)

            -- 不出按钮
            --self._gameView:onChangePassBtnState(false)

            -- 开始出牌
            self._gameView:onGetOutCard(curView, curView, {})
        end
        -- 设置倒计时
        self:SetGameClock(cmd_table.wBankerUser, cmd.TAG_COUNTDOWN_OUTCARD, cmd.COUNTDOWN_HANDOUTTIME)
    else
        print("viewid invalid" .. bankerView .. " ## " .. curView)
    end
    -- 倍数
    self._gameView:onGetGameTimes(cmd_table.lScoreTimes)

    -- 刷新局数
    if PriRoom and GlobalUserItem.bPrivateRoom then
        local curcount = PriRoom:getInstance().m_tabPriData.dwPlayCount
        PriRoom:getInstance().m_tabPriData.dwPlayCount = curcount + 1
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            self._gameView._priView:onRefreshInfo()
        end
    end
    self.m_bCallStateEnter = false
end

-- 用户出牌
function GameLayer:onSubOutCard(dataBuffer)
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_OutCard, dataBuffer)
    dump(cmd_table, "onSubOutCard", 6)

    local curView = self:SwitchViewChairID(cmd_table.wCurrentUser)
    local outView = self:SwitchViewChairID(cmd_table.wOutCardUser)

    print("&& 出牌 " .. outView .. " ## " .. curView)
    local outCard = cmd_table.cbCardData[1]
    local outCount = cmd_table.cbCardCount
    local outCardData = {}
    for i = 1, outCount do
        local cbData = outCard[i]
        if nil ~= cbData then
            table.insert(outCardData, cbData)
        end
    end
    local carddata = GameLogic:SortCardList(outCardData, outCount, 0)
    -- 扑克对比
    self:compareWithLastCards(carddata, outView)

    -- 构造提示
    local handCards = self._gameView.m_tabNodeCards[cmd.MY_VIEWID]:getHandCards()
    self:updatePromptList(carddata, handCards, outView, curView)

    -- 不出按钮
    --self._gameView:onChangePassBtnState(true)

    self._gameView:onGetOutCard(curView, outView, carddata)
    -- 倍数
    self._gameView:onGetGameTimes(cmd_table.lScoreTimes)

    self:KillGameClock()
    -- 设置倒计时
    self:SetGameClock(cmd_table.wCurrentUser, cmd.TAG_COUNTDOWN_OUTCARD, cmd.COUNTDOWN_OUTCARD)
end

-- 用户放弃
function GameLayer:onSubPassCard(dataBuffer)
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_PassCard, dataBuffer)
    --dump(cmd_table, "onSubPassCard", 6)

    local curView = self:SwitchViewChairID(cmd_table.wCurrentUser)
    local passView = self:SwitchViewChairID(cmd_table.wPassCardUser)

    self:KillGameClock()
    -- 是否必须出牌
    local bMustOut = false
    if self:IsValidViewID(curView) and self:IsValidViewID(passView) then
        print("&& pass " .. curView .. " ## " .. passView)
        if 1 == cmd_table.cbTurnOver then
            print("一轮结束")
            self:compareWithLastCards({}, curView)
            -- 构造提示
            local handCards = self._gameView.m_tabNodeCards[cmd.MY_VIEWID]:getHandCards()
            self:updatePromptList({}, handCards, curView, curView)
            bMustOut = true
        end
        -- 不出牌
        self._gameView:onGetPassCard(passView)
        if curView == cmd.MY_VIEWID then
            self._gameView:onGetOutCard(curView, self.m_nLastOutViewId, self.m_tabLastCards, false, true)
        else
            self._gameView:onGetOutCard(curView, self.m_nLastOutViewId, {}, false, true)
        end

        if bMustOut then
            -- 不出按钮
            self._gameView:onChangePassBtnState(false)
        end
        -- 设置倒计时
        self:SetGameClock(cmd_table.wCurrentUser, cmd.TAG_COUNTDOWN_OUTCARD, cmd.COUNTDOWN_OUTCARD)
    else
        print("viewid invalid" .. curView .. " ## " .. passView)
    end
end

-- 游戏结束
function GameLayer:onSubGameConclude(dataBuffer)
    self.m_bStartGame = false
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_GameConclude, dataBuffer)
    --dump(cmd_table, "onSubGameConclude", 6)
    local handCards = {}

    self.m_bRoundOver = true
    local str = ""
    local rs = GameResultLayer.getTagGameResult()

    local scorelist = cmd_table.lGameScore[1]
    local countlist = cmd_table.cbCardCount[1]
    local cardlist = cmd_table.cbHandCardData[1]
    local haveCount = 0
    -- 处理数据
    for i = 1, 3 do
        local chair = i - 1
        local viewId = self:SwitchViewChairID(chair)

        -- 结算
        local score = scorelist[i]
        if score > 0 then
            str = "+" .. score
        else
            str = "" .. score
        end
        local settle = GameResultLayer.getTagSettle()
        settle.m_userName = self._gameView:getUserNick(viewId)
        settle.m_settleCoin = str
        if cmd.MY_VIEWID == viewId then
            rs.enResult = self:getWinDir(score)
        end
        rs.settles[i] = settle

        -- 手牌
        local count = countlist[i]
        local cards = {}
        for j = 1, count do
            local carddata = cardlist[j + haveCount]
            if nil ~= carddata then
                table.insert(cards, carddata)
            else
                local targetPlatform = cc.Application:getInstance():getTargetPlatform()
                local tab = cmd_table
                tab.msg = "结算数据异常"
                tab.errorcount = count
                tab.errorcountidx1 = j
                tab.errorcountidx2 = haveCount
                local cachemsg = cjson.encode(tab) or ""
                if cc.PLATFORM_OS_WINDOWS == targetPlatform then
                    LogAsset:getInstance():logData(cachemsg,true)
                else
                    buglyReportLuaException(cachemsg, debug.traceback())
                end
            end
        end
        haveCount = haveCount + count
        if count > 0 then
            handCards[viewId] = cards
        end
    end
    local this = self
    self._gameView:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function()
        -- 音效
        ExternalFun.playSoundEffect( "gameconclude.wav" )
        -- 刷新用户手牌
        for k, v in pairs(handCards) do
            this._gameView.m_tabNodeCards[k]:showLeftCards(v)
        end
        -- 标志
        for i = 1, 3 do
            local chair = i - 1
            -- 春天
            if 1 == cmd_table.bChunTian then
                rs.cbFlag = cmd.kFlagChunTian
                if chair == this.m_cbBankerChair then
                    rs.settles[i].m_cbFlag = cmd.kFlagChunTian
                end
            end

            -- 反春天
            if 1 == cmd_table.bFanChunTian then
                rs.cbFlag = cmd.kFlagFanChunTian
                if chair ~= this.m_cbBankerChair then
                    rs.settles[i].m_cbFlag = cmd.kFlagFanChunTian
                end
            end
        end
        -- 倍数
        this._gameView:onGetGameTimes(cmd_table.lScoreTimes)

        this._gameView:onGetGameConclude( rs )

        this:KillGameClock()
        -- 私人房无倒计时
        if not GlobalUserItem.bPrivateRoom then
            -- 设置倒计时
            this:SetGameClock(this:GetMeChairID(), cmd.TAG_COUNTDOWN_READY, cmd.COUNTDOWN_READY)
        end

        this:reSetData()
    end)))
end

-- 房卡记录
function GameLayer:onSubRoomCardRecord( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(cmd.CMD_S_RoomCardRecord, dataBuffer)
    --dump(cmd_table, "CMD_S_RoomCardRecord", 6)
    self.m_tabMarkRecord = {}
    local nCount = cmd_table.nCount
    for i = 1, nCount do
        local round = {}
        -- 玩家1
        table.insert(round, cmd_table.lDetailScore[1][i])
        -- 玩家2
        table.insert(round, cmd_table.lDetailScore[2][i])
        -- 玩家3
        table.insert(round, cmd_table.lDetailScore[3][i])

        table.insert(self.m_tabMarkRecord, round)
    end
end
------------------------------------------------------------------------------------------------------------
--网络处理
------------------------------------------------------------------------------------------------------------

function GameLayer:getWinDir( score )
    print("## is my Banker")
    print(self.m_bIsMyBanker)
    print("## is my Banker")
    if true == self.m_bIsMyBanker then
        if score > 0 then
            return cmd.kLanderWin
        elseif score < 0 then
            return cmd.kLanderLose
        end
    else
        if score > 0 then
            return cmd.kFarmerWin
        elseif score < 0 then
            return cmd.kFarmerLose
        end
    end
    return cmd.kDefault
end

----加载卡牌
--function GameLayer:setCardImage(cardData,cardPanel)
--    local card_color,value = math.modf((cardData+1)/13);
--    local card_value = (cardData+1)%13
--    if card_value == 0 then
--        card_color = card_color-1
--        card_value = 13
--    end

--    local fWidth = 90
--    local fHeight = 119
--    local x = (card_value-1)*fWidth
--	local y = card_color*fHeight
--    local cardRect = cc.rect(x,y,fWidth,fHeight);
--    local sprite_card = cc.Sprite:createWithTexture(self.cardTexture,cardRect):setScaleX(1.32):setScaleY(1.36)
----    local sprite_image = cc.SpriteFrameCache:getInstance():createWithTexture(self.cardTexture,cardRect)
----    cardPanel:loadTexture(sprite_image)
--    sprite_card:setPosition(cc.p(0,0))
--    sprite_card:setAnchorPoint(cc.p(0,0))
--    cardPanel:addChild(sprite_card,10)
--    print("创建牌-------------------------------------")
--end
return GameLayer