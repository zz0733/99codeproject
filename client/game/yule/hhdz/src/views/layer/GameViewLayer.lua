--
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")
local module_pre = "game.yule.hhdz.src."

--local CBetManager           = appdf.req(module_pre.."models.CBetManager")
local MsgBoxPreBiz          = appdf.req(module_pre.."models.MsgBoxPreBiz")
local Effect                = appdf.req(module_pre .. "models.Effect");
local PlayerInfo = appdf.req(appdf.EXTERNAL_SRC .. "PlayerInfo")
local RedVsBlackDataManager     = appdf.req(module_pre.."game.redvsblack.manager.RedVsBlackDataManager")
--local CMsgRedVsBlack            = appdf.req(module_pre.."game.redvsblack.proxy.CMsgRedVsBlack")
local RedVsBlackEvent           = appdf.req(module_pre.."game.redvsblack.scene.RedVsBlackEvent")
local MessageBoxNew             = appdf.req(module_pre.."models.MessageBoxNew")
local MsgBoxPreBiz              = appdf.req(module_pre.."models.MsgBoxPreBiz")
local RedVsBlackRes             = appdf.req(module_pre.."game.redvsblack.scene.RedVsBlackRes")
local RedVsBlackDefine             = appdf.req(module_pre.."game.redvsblack.scene.RedVsBlackDefine")
local RedVsBlackTrendLayer      = appdf.req(module_pre.."game.redvsblack.layer.RedVsBlackTrendLayer")
local RedVsBlackRuleLayer       = appdf.req(module_pre.."game.redvsblack.layer.RedVsBlackRuleLayer")
local SettingLayer              = appdf.req(module_pre.."game.redvsblack.layer.SettingLayer")
local HeadSprite               = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
local RedVsBlackOtherInfoLayer  = appdf.req(module_pre.."game.redvsblack.layer.RedVsBlackOtherInfoLayer")
--local IngameBankView            = appdf.req("hall.bean.IngameBankView")
--local RechargeLayer             = appdf.req("hall.layer.RechargeLayer")
appdf.req("game.yule.hhdz.src.models.helper")
appdf.req("game.yule.hhdz.src.models.gameConstants")

local RollMsg            = cc.exports.RollMsg
local scheduler          = appdf.req("game.yule.hhdz.src.models.scheduler")

local FloatMessage = cc.exports.FloatMessage
local GameViewLayer = class("GameViewLayer",function(scene)
        local gameViewLayer = display.newLayer()
    return gameViewLayer
end)
local BET_STAR           = "star"
local BET_END            = "end"

local GameView = {
       GameStatus_BET = 1,
       GameStatus_END = 2,
       GameStatus_FREE = 3,
       GameStatus_WAIT = 0,
}
local LU_TYPE = {
    T1 = 1, -- 红
    T2 = 2, -- 黑
}

local ChipOffSet         = 12 -- 筹码选中状态位移
local CardTypeAniName    = {"Animationdanzhang", "Animationduizi", "Animationshunzi", "Animationjinhua", "Animationshunjin", "Animationbaozi"} -- { "单牌","对子","顺子","金花","顺金","豹子", }

local JETTON_ITEM_COUNT  = 5
local DOWN_COUNT_HOX     = 3 -- 下注区域 共3个
local POKERSCALE         = 0.65 --扑克缩放比例
local CHIPSCALE          = 0.35 --筹码缩放比例
local IPHONEX_OFFSETX    = 45

local CHIP_FLY_STEPDELAY = 0.02 --筹码连续飞行间隔
local CHIP_FLY_TIME      = 0.18 --飞筹码动画时间
local CHIP_JOBSPACETIME  = 0.18 --飞筹码任务队列间隔
local CHIP_FLY_SPLIT     = 15 -- 飞行筹码分组 分XX次飞完
local CHIP_ITEM_COUNT    = DOWN_COUNT_HOX --下注项数
local CHIP_REWARD        = {2, 2, 2}

local ZORDER_OF_MESSAGEBOX = 101

function GameViewLayer:ctor(scene)
    math.randomseed(os.time())
    self:enableNodeEvents()
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
    self.m_pathUI = cc.CSLoader:createNode(RedVsBlackRes.CSB_GAME_MAIN)
--    local diffY = (display.size.height - 750) / 2
--    self.m_pathUI:setPosition(cc.p(0, diffY))
    self.m_pathUI:addTo(self.m_rootUI)

    self._scene = scene
    self:init()
     
end

function GameViewLayer:init()
    self.initUserData()
    math.randomseed(tostring(os.time()):reverse():sub(1,7))
    self.isOpenMenu = false
    self.m_flychipidx = 0
    self.nIndexChoose = 0 -- 当前选择的筹码索引
    
    self.m_pNodeLeft  = {}  -- 左边玩家节点
    self.m_pNodeRight = {}  -- 右边玩家节点
    self.AllTotal = {}
    self.m_myBetMoney = {}
    self.m_randmChipOthers = {} -- 三个地区随机投注点 
    self.m_randmChipSelf = {} -- 三个地区随机投注点 
    self.m_betChipSpSelf = {} -- 自己的三个地区投注筹码精灵 { jettonIndex =  筹码索引, pChipSpr =  筹码精灵对象, pos = 坐标 }
    self.m_betChipSpOthers = {} -- 他人的三个地区投注筹码精灵
    for i = 0, 2 do
        self.m_myBetMoney[i] = 0
        self.AllTotal[i] = 0
        self.m_randmChipOthers[i] = {} -- 三个地区随机投注点 
        self.m_randmChipSelf[i] = {} -- 三个地区随机投注点 
        self.m_betChipSpSelf[i] = {} -- 自己的三个地区投注筹码精灵 { jettonIndex =  筹码索引, pChipSpr =  筹码精灵对象, pos = 坐标 }
        self.m_betChipSpOthers[i] = {} -- 他人的三个地区投注筹码精灵
    end


    self.m_chipAreaRect = {} --筹码放置范围

    self.m_tabPos = {}
    self.m_userBtnVec = {}
    self.m_userBtnResPosVec = {}
    self.m_pControlButtonJetton = {}

    self.Image_zplItem = {}
    self.Image_dlItem = {}
    self.Image_dyzlItem = {}
    self.Image_xlItem = {}
    self.Image_yylItem = {}
    self.Img_HongWenlu = {}
    self.Img_HeiWenlu = {}

    self:initViewNode()
    self:initMyinfo()
    self:initseatinfo()
    self:initRBWarTrend()
    --分辨率自适应
    self:setNodeFixPostion()
    self:resetChipPos()

    --三个飞金币的坐标
    local x, y = self.m_pmyCoin:getPosition()
    self.m_pmyCoin = cc.p(x+95, y+10)
    local x1, y1 = self.m_pBtnOthers:getPosition()
    self.m_otherChipPos = cc.p(x1, y1)

end

function GameViewLayer:onEnter()
    
end

function GameViewLayer:onExit()
    self:clear()
    self:cleanEvent()
    self:stopGameEvent()
    self:removeAllChildren()
end

function GameViewLayer:initViewNode()
    ExternalFun.playGameBackgroundAudio("RBWar/sound/bg.mp3")
    self.m_rootNode          = self.m_pathUI
    self.m_pNodeChipSpr = self.m_rootNode:getChildByName("Panel_chip")

    --飞筹码范围
    for i = 0, 2 do
        local chiparea = self.m_pNodeChipSpr:getChildByName("Panel_chip" .. i)
        local x, y = chiparea:getPosition()
        self.m_chipAreaRect[i] = cc.rect(x, y, chiparea:getContentSize().width, chiparea:getContentSize().height)
    end
    -- 我的下注
    self.m_pmyGold = self.m_rootNode:getChildByName("myGold")

    self.Img_R = self.m_pmyGold:getChildByName("R"):setVisible(false)
    self.Img_B = self.m_pmyGold:getChildByName("B"):setVisible(false)
    self.Img_L = self.m_pmyGold:getChildByName("L"):setVisible(false)

    self.Txt_goldR = self.m_pmyGold:getChildByName("R"):getChildByName("Text_coin")
    self.Txt_goldB = self.m_pmyGold:getChildByName("B"):getChildByName("Text_coin")
    self.Txt_goldL = self.m_pmyGold:getChildByName("L"):getChildByName("Text_coin")

    -- 中心下注区域
    self.m_pCenter = self.m_rootNode:getChildByName("center")
    self.m_pareaR = self.m_pCenter:getChildByName("image_areaR")    -- 红方押注区域
    self.m_pareaB = self.m_pCenter:getChildByName("image_areaB")    -- 黑方押注区域
    self.m_pareaL = self.m_pCenter:getChildByName("image_areaL")    -- 幸运押注区域
    
    -- 下注区域闪光
    self:initChipEffect()

    -- 区域下注总数
    self.Txt_areaR = self.m_pareaR:getChildByName("txt_totalR")
    self.Txt_areaB = self.m_pareaB:getChildByName("txt_totalB")
    self.Txt_areaL = self.m_pareaL:getChildByName("txt_totalL")

    -- 下注区域按钮
    local btn_red = self.m_pareaR:getChildByName("Button_areaR")
    btn_red:addClickEventListener(handler(self,function() self:onAnimalClicked(1) end))
    local btn_black = self.m_pareaB:getChildByName("Button_areaB")
    btn_black:addClickEventListener(handler(self,function() self:onAnimalClicked(2) end))
    local btn_luck = self.m_pareaL:getChildByName("Button_areaL")
    btn_luck:addClickEventListener(handler(self,function() self:onAnimalClicked(3) end))

    -- 菜单
    self.m_pBtnMenuPop = self.m_rootNode:getChildByName("button_btnBack")
    self.m_pBtnMenuPop:addClickEventListener(handler(self,self.onPopClicked))
    self.m_pBtnMenuPop:setLocalZOrder(1)
    self.m_pImgMenu = self.m_pBtnMenuPop:getChildByName("Image_5")
    -- 菜单层
    self.m_pPanelMenu = self.m_rootNode:getChildByName("panel_backMenu"):setVisible(false)
    self.m_psettingPanel = self.m_pPanelMenu:getChildByName("image_settingPanel")

    self.m_pBtnExit = self.m_psettingPanel:getChildByName("button_exit")
    self.m_pBtnExit:addClickEventListener(handler(self,self.onReturnClicked))

    self.m_pBtnSetting = self.m_psettingPanel:getChildByName("button_setting")
    self.m_pBtnSetting:addClickEventListener(handler(self,self.onSettingClicked))

    self.m_pBtnHelp = self.m_psettingPanel:getChildByName("button_help")
    self.m_pBtnHelp:addClickEventListener(handler(self,self.onHelpClicked))
    
    self.m_pBtnFullClose = self.m_pPanelMenu:getChildByName("btn_close")
    self.m_pBtnFullClose:addClickEventListener(handler(self,self.onPushClicked))
    -- 底层layout
    self.m_pbottomPanel = self.m_rootNode:getChildByName("bottomPanel")

    local headNode = self.m_pbottomPanel:getChildByName("headNode") 
    self.m_pmyHead = headNode:getChildByName("myHead")                           -- 我的头像
    self.m_pmyName = headNode:getChildByName("myName")                           -- 我的名字
    self.m_pmyCoin = headNode:getChildByName("myCoin")                           -- 飞金币自己
    self.m_pmyMoney = headNode:getChildByName("text_myMoney")                    -- 我的金币

    self.m_pBtnOthers = self.m_pbottomPanel:getChildByName("btnPlayers")        -- 其他玩家
    self.m_pLbOtherNum = self.m_pBtnOthers:getChildByName("text_totalPlayerNum")   -- 人数
    self.m_pBtnOthers:addClickEventListener(handler(self,self.onOtherInfoClicked))


    local centerSelet = self.m_pbottomPanel:getChildByName("centerSelet")
    for i = 1 , JETTON_ITEM_COUNT do
        self.m_pControlButtonJetton[i] = centerSelet:getChildByName( string.format("button_chip_%d",i))
        self.m_pControlButtonJetton[i]:addClickEventListener(handler(self,function ()
        self:onBetNumClicked(i, true)
        end))
        local plane = self.m_pControlButtonJetton[i]:getChildByName("runImg")
        plane:setVisible(false)
        local seq = cc.RotateBy:create(2,360)
        plane:runAction(cc.RepeatForever:create(seq))
    end
    self.m_pControlButtonJetton[1]:getChildByName("runImg"):setVisible(true)

    -- 牌层
    self.m_pCard = self.m_rootNode:getChildByName("image_dealCards"):setVisible(false)
    self.m_pCard:setLocalZOrder(100)
    self.m_pHeiCard = self.m_pCard:getChildByName("node_heiCards")
    self.m_pHongCard = self.m_pCard:getChildByName("node_hongCards")
    -- 状态节点
    self.m_pStatus = self.m_rootNode:getChildByName("Node_Status")


    --滚动消息位置
--    RollMsg.getInstance():setShowPosition(display.cx, display.height-96.0)
end

--------------------------------------------------------------------接受消息--------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------------------------------------------------
function GameViewLayer:event_GameState(dataBuffer)         -- 进入{[1]=66750020 [2]="买卖QQ8646877" [3]=3 [4]=0 [5]=2554.88 [6]=8 }[98932801, "swh通杀888", 5, 0, 4067.1, 10]
    RedVsBlackDataManager.getInstance():setGameStatus(dataBuffer.step)
    --玩家列表
    for k , v  in ipairs(dataBuffer.members) do
        RedVsBlackDataManager.getInstance():setRankUser(v)
    end
    self.m_pLbOtherNum:setString(table.nums(dataBuffer.members))
    --
    self.seatuser = dataBuffer.rich_man
    table.insert(self.seatuser,dataBuffer.win_man)
    self:updataTableMan()

    --筹码
    for i=1,tonumber(JETTON_ITEM_COUNT) do
        print(dataBuffer.chips[i])
        RedVsBlackDataManager.getInstance():setJettonScore(i, dataBuffer.chips[i]);
    end
    RedVsBlackDataManager.getInstance():setLotteryBaseScore(dataBuffer.chips[1])
    self:updateJettonState()
    --历史记录
    self.History_Path = dataBuffer.path
    self:updateRBWarTrend()

    if dataBuffer.step == GameView.GameStatus_BET then
        self:initBetView(2)
        self:initTimer()
        RedVsBlackDataManager.getInstance():setTimeCount(self:getIntValue(dataBuffer.timeout))
        
        self.Txt_areaR:setString(dataBuffer.betmoneys[1])
        self.Txt_areaB:setString(dataBuffer.betmoneys[2])
        self.Txt_areaL:setString(dataBuffer.betmoneys[3])
    elseif dataBuffer.step == GameView.GameStatus_END then
        self:initBetView(4)
        self.Txt_areaR:setString(dataBuffer.betmoneys[1])
        self.Txt_areaB:setString(dataBuffer.betmoneys[2])
        self.Txt_areaL:setString(dataBuffer.betmoneys[3])
    elseif dataBuffer.step == GameView.GameStatus_FREE then
        self:initBetView(1)
    end
   
end
function GameViewLayer:intoBetMoney(dataBuffer)    -- 下注
    RedVsBlackDataManager.getInstance():setGameStatus(GameView.GameStatus_BET)
    RedVsBlackDataManager.getInstance():setTimeCount(self:getIntValue( dataBuffer.timeout))
    self:initTimer()
    self:onMsgUpdateGameStatue()
end
function GameViewLayer:onGameEnd(dataBuffer)      -- 结算dataBuffer.win_zodic{[1]=-1 [2]=1 [3]=-1 }dataBuffer.cards[1][1]{[1]=39 [2]=9 [3]=32 }
    RedVsBlackDataManager.getInstance():setGameStatus(GameView.GameStatus_END)
    self.win_zodic = dataBuffer.win_zodic
    self.m_moneys = dataBuffer.moneys
    self.m_mywin = dataBuffer.mywin
    self.m_cards = dataBuffer.cards
    RedVsBlackDataManager.getInstance():setSelfCurrResult(self.m_mywin)
    --清理计时器
    self:cleanEvent()
    --更新历史记录
    local zodic = {[1] = 0,[2] = 0};
    if self.win_zodic[1] == 1 then
        zodic[1] = 1
        zodic[2] = self.m_cards[1][2]
    else    
        zodic[1] = 2
        zodic[2] = self.m_cards[2][2]
    end
    table.insert(self.History_Path,zodic)
    self:updateRBWarTrend()
    --更新桌上玩家
    self.seatuser = {} 
    self.seatuser = dataBuffer.rich_man
    table.insert(self.seatuser,dataBuffer.win_man)
    
    --更新玩家列表
    for k,v in ipairs(RedVsBlackDataManager.getInstance():getRankUser()) do
        for key,player in ipairs(self.m_moneys) do
            if v[1] == player[1] then
                v[6] = player[2]
            end
        end
    end

    self:onMsgUpdateGameStatue()
end

function GameViewLayer:onDeskOver(dataBuffer)        -- 空闲
    RedVsBlackDataManager.getInstance():setGameStatus(GameView.GameStatus_FREE)
    self:onMsgUpdateGameStatue()
end

function GameViewLayer:otherBetMoney(dataBuffer)--{[1]=1 [2]=50 [3]=123173021 [4]=50 [5]=1697.06 }
    print("\n玩家Id："..dataBuffer[3].."\n下注区域   "..dataBuffer[1].."\n下注金额   "..dataBuffer[4].."\n该区域总钱数为："..dataBuffer[2].."\n该玩家持有金币数为："..dataBuffer[5] )
    self.AllTotal[dataBuffer[1]] = dataBuffer[2]
    self:updateBetMoney(dataBuffer[1])
    self.m_flychipidx = self.m_flychipidx + 1
    if self.m_flychipidx > 2 then self.m_flychipidx = 0 end
    for k,v in  ipairs( self.seatuser ) do
        if v[1] == dataBuffer[3] then
            if k <= 3 then
                self.m_pNodeLeft[k]:getChildByName("money"):setString(dataBuffer[5])
            else
                self.m_pNodeRight[k-3]:getChildByName("money"):setString(dataBuffer[5])
            end
            
            self:playTableUserChipAni(k)
            self:createFlyChipSprite(dataBuffer[4],dataBuffer[1],self.m_tabPos[k],false,k,0.35,true)
            return
        end
    end 
    self:createFlyChipSprite(dataBuffer[4],dataBuffer[1],self.m_otherChipPos,false,false,0.35,true)
end
function GameViewLayer:myBetMoney(dataBuffer)--{[1]=5 [2]=0 [3]=819 [4]=92.1 }
    print("\n本人".."\n下注区域   "..dataBuffer[2].."\n下注金额   "..dataBuffer[1].."\n该区域总钱数为："..dataBuffer[3].."\n该玩家持有金币数为："..dataBuffer[4])
    self.m_pmyMoney:setString(dataBuffer[4])

    self.AllTotal[dataBuffer[2]] = dataBuffer[3]
    self:updateBetMoney(dataBuffer[2])
    self.m_myBetMoney[dataBuffer[2]] = self.m_myBetMoney[dataBuffer[2]] + dataBuffer[1]
    self:updateMyMoney()
    self.m_flychipidx = self.m_flychipidx + 1
    if self.m_flychipidx > 2 then self.m_flychipidx = 0 end
    self:createFlyChipSprite(dataBuffer[1],dataBuffer[2],self.m_pmyCoin,true,false,0.35,true)
end

function GameViewLayer:Badbetmoney(dataBuffer)
    FloatMessage.getInstance():pushMessageForString("下注失败")
end
--更新自身icon，昵称等信息
function GameViewLayer:updataPlayerPanpel(player_,plyertype)
    if plyertype then
        if player_[1] == GlobalUserItem.tabAccountInfo.userid then
            return
        end
        local isHavePlayer = false
        for key, player in ipairs(RedVsBlackDataManager.getInstance():getRankUser()) do
            if player[1] == player_[1] then
                isHavePlayer = true
            end
        end
        local remeber = {};
        remeber = player_
        table.insert(remeber,4,0)
        if isHavePlayer == false then
            RedVsBlackDataManager.getInstance():setRankUser(remeber)
            self.m_pLbOtherNum:setString(RedVsBlackDataManager.getInstance():getRankUserSize())
        end
    else
        for key, player in ipairs(RedVsBlackDataManager.getInstance():getRankUser()) do
            if player[1] == player_ then
                table.remove(RedVsBlackDataManager.getInstance():getRankUser(),key)
                self.m_pLbOtherNum:setString(RedVsBlackDataManager.getInstance():getRankUserSize())
            end
        end
    end
    
end

function GameViewLayer:updataMyMoney(args)
    self.m_pmyMoney:setString(args)
    PlayerInfo.getInstance():setUserScore(args)
end

        --------------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------消息完毕--------------------------------------------------------------------


function GameViewLayer:initseatinfo()
    local ani = cc.CSLoader:createNode("RBWar/Node_RBWarAllPlayer.csb")
    self.m_pCenter:addChild(ani)
    for i = 1,3 do
        local leftseat = ani:getChildByName(string.format("head_L_%d",i))
        leftseat:removeAllChildren()
        local person = cc.CSLoader:createNode("RBWar/Node_RBWarPlayer.csb")
        leftseat:addChild(person)
        self.m_pNodeLeft[i] = person
        table.insert(self.m_userBtnVec,leftseat)
        local x,y = leftseat:getPosition()
        table.insert(self.m_userBtnResPosVec,{x = x,y = y })
        local x1,y1 = self.m_pCenter:getPosition()
        local pos = cc.p(x+x1,y+y1);
        table.insert(self.m_tabPos,pos)
    end
    for i = 1,3 do
        local rightseat = ani:getChildByName(string.format("head_R_%d",i))
        rightseat:removeAllChildren()
        local person = cc.CSLoader:createNode("RBWar/Node_RBWarPlayer.csb")
        rightseat:addChild(person)
        self.m_pNodeRight[i] = person
        table.insert(self.m_userBtnVec,rightseat)
        local x,y = rightseat:getPosition()
        table.insert(self.m_userBtnResPosVec,{x = x,y = y })
        local x1,y1 = self.m_pCenter:getPosition()
        local pos = cc.p(x+x1,y+y1);
        table.insert(self.m_tabPos,pos)
    end
end
function GameViewLayer:initMyinfo()
    local head = HeadSprite:createClipHead(GlobalUserItem.tabAccountInfo,94)
    head:setAnchorPoint(cc.p(0,0))
    self.m_pmyHead:addChild(head)
    self.m_pmyName:setString(GlobalUserItem.tabAccountInfo.nickname)
    self.m_pmyMoney:setString(GlobalUserItem.tabAccountInfo.into_money)
end

-- 开始下注and结束下注
function GameViewLayer:initStarAndEnd(iswhat)
    local ani = cc.CSLoader:createNode("RBWar/Node_RBWarBetTip.csb")
    local diffX = 145-(1624-display.size.width)/2
    ani:setPosition(display.size.width/2 - diffX,display.size.height/2)
    self.m_pathUI:addChild(ani,100)
    local action = cc.CSLoader:createTimeline("RBWar/Node_RBWarBetTip.csb")
    ani:runAction(action)
    if iswhat == BET_STAR then
        ExternalFun.playGameEffect("RBWar/sound/betStart.mp3")
        ani:setVisible(true)
        action:gotoFrameAndPlay(0,25, false)  --true循环播放，false 播放一次
        self:doSomethingLater(function()
            ani:removeFromParent()
        end, 1)
    elseif iswhat == BET_END then
        ExternalFun.playGameEffect("RBWar/sound/betEnd.mp3")
        ani:setVisible(true)
        action:gotoFrameAndPlay(30,55, false)  --true循环播放，false 播放一次
        self:doSomethingLater(function()
            ani:removeFromParent()
        end, 1)
    else
        print("播放失败！")
    end
end

--分辨率适配
function GameViewLayer:setNodeFixPostion()
    local diffX = 145-(1624-display.size.width)/2

    -- 根容器节点
    self.m_rootNode:setPositionX(diffX)

    if LuaUtils.isIphoneXDesignResolution() then
        print("666")
--        --左侧节点
--        self.m_panel_other:setPositionX(self.m_panel_other:getPositionX() - IPHONEX_OFFSETX)
--        self.m_pBtnReturn:setPositionX(self.m_pBtnReturn:getPositionX() - IPHONEX_OFFSETX)
--        self.m_panel_self:setPositionX(self.m_panel_self:getPositionX() - IPHONEX_OFFSETX)
----        self.m_pLbRoomNo:setPositionX(self.m_pLbRoomNo:getPositionX() - IPHONEX_OFFSETX)

--        --右侧节点
--        self.m_pBtnMenuPop:setPositionX(self.m_pBtnMenuPop:getPositionX() + IPHONEX_OFFSETX)
--        self.m_pBtnContinue:setPositionX(self.m_pBtnContinue:getPositionX() + IPHONEX_OFFSETX)
    end
end

--endregion

--region 事件绑定及实现
--注册倒计时
function GameViewLayer:initTimer()
    ExternalFun.playGameEffect("RBWar/sound/betPreStart.mp3")
    self.timerHandle = scheduler.scheduleGlobal(handler(self,self.onMsgCountDown), 1)
end

function GameViewLayer:clear()
    for i = 0, 2 do
        self.m_myBetMoney[i] = 0
        self.m_betChipSpSelf[i] = {}
        self.m_betChipSpOthers[i] = {}
    end
end
function GameViewLayer:cleanEvent() --清理事件监听  
    --注销倒计时
    if self.timerHandle then
        scheduler.unscheduleGlobal(self.timerHandle)
    end
end

function GameViewLayer:stopGameEvent()
    RedVsBlackDataManager.getInstance():clear()
    self:cleanPlayerData()
end
--倒计时
function GameViewLayer:onMsgCountDown(value)
    --每秒刷新其他玩家数量
--    self:updateOtherNum()

    --游戏状态
    if RedVsBlackDataManager.getInstance():getGameStatus() == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP then
        --倒计时
        local ts = RedVsBlackDataManager.getInstance():getTimeCount()
        ts = ts < 1 and 0 or ts - 1
        RedVsBlackDataManager.getInstance():setTimeCount(ts)
        self.m_pLbCountTime:setString(("%d").format(ts))
        if ts <= 3 then
            ExternalFun.playGameEffect("RBWar/sound/countdown3.mp3")
        end
    end

end
--规则
function GameViewLayer:onHelpClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
    local pRule = RedVsBlackRuleLayer.create()
    pRule:addTo(self.m_pathUI, 1000)
end
--设置
function GameViewLayer:onSettingClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
    local pSet = SettingLayer.create()
    pSet:addTo(self.m_pathUI,1000)
end

--点击下注区域 进行下注
function GameViewLayer:onAnimalClicked(nIndex)
    if RedVsBlackDataManager.getInstance():isBanker() then
        FloatMessage.getInstance():pushMessage("RVB_WARN_2")
        return
    end

    if RedVsBlackDataManager.getInstance():getGameStatus() ~= RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP then
        FloatMessage.getInstance():pushMessage("RVB_WARN_1")
        return
    end

    if not nIndex then return end

    if RedVsBlackDataManager.getInstance():getLotteryBaseScore() > PlayerInfo.getInstance():getUserScore() then
        return
    end

    local _data = {}
    _data.wChipIndex = nIndex - 1
    _data.wJettondata = RedVsBlackDataManager.getInstance():getJettonScore(RedVsBlackDataManager.getInstance():getLotteryBaseScoreIndex()+1)
    self._scene:SendBet(_data)

end

--点击筹码 禁用状态按钮是接受不到点击事件的
function GameViewLayer:onBetNumClicked(nIndex, bPlaySound)
    if nIndex < 1 then return end

    if bPlaySound then
        ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
    end
    self.nIndexChoose = nIndex
    self:updateJettonState()
end

--弹出菜单
function GameViewLayer:onPopClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
    if self.isOpenMenu == false then
        self.m_pImgMenu:setRotation(-90)
        self.m_pPanelMenu:setVisible(true)
        self.m_psettingPanel:runAction(cc.MoveBy:create(0.2,cc.p(200,0)))
        self.isOpenMenu = true
    else
        self.m_pImgMenu:setRotation(90)
        self.m_pPanelMenu:setVisible(false)
        self.m_psettingPanel:runAction(cc.MoveBy:create(0.2,cc.p(-200,0)))
        self.isOpenMenu = false
    end
end

--关闭菜单
function GameViewLayer:onPushClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
    if self.isOpenMenu == true then
        self.m_pImgMenu:setRotation(90)
        self.m_pPanelMenu:setVisible(false)
        self.m_psettingPanel:runAction(cc.MoveBy:create(0.2,cc.p(-200,0)))
        self.isOpenMenu = false
    end

end

--退出
function GameViewLayer:onReturnClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
    self:onMoveExitView()
end

--其他玩家信息
function GameViewLayer:onOtherInfoClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
    --玩家列表
    local infoLayer = RedVsBlackOtherInfoLayer:create()
    self.m_pathUI:addChild(infoLayer,1000)
end

--游戏状态切换
function GameViewLayer:onMsgUpdateGameStatue()
    local status = RedVsBlackDataManager.getInstance():getGameStatus()
    if status == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_IDLE then
        print("空闲时间..........................")
        self:clear()
        self:resetChipPos()
        self:initBetView(1)
        self:updateBetMoney(3)
        self:resetCard()
    elseif status == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP then
        print("投注时间..........................")
        self:updateJettonState()
        self:initStarAndEnd(BET_STAR)
        self:initBetView(2)

    elseif status == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_END then
        print("开奖时间..........................")
        self:updateJettonState()
        self:initStarAndEnd(BET_END)
        self:initBetView(4)
        self:OpenCard()
    end
end

function GameViewLayer:initBetView(status)
    local clockState = self.m_pStatus:getChildByName("sprite_clockStateTxt")
    clockState:setTexture(RedVsBlackRes.spriteState[status])
    self.m_pLbCountTime = self.m_pStatus:getChildByName("atlas_clockNum"):setVisible(false)
    local clockSpr = self.m_pStatus:getChildByName("sprite_clockSpr"):setVisible(false)
    local clockSPR = self.m_pStatus:getChildByName("sprite_clockSpr_0"):setVisible(false)
    if status == 2 then
        self.m_pLbCountTime:setVisible(true)
        self.m_pLbCountTime:setString(RedVsBlackDataManager.getInstance():getTimeCount())
        clockSpr:setVisible(true)
        clockSPR:setVisible(true)
    elseif status == 5 then
        self:FlyChip()
    end
end

--退出游戏
function GameViewLayer:onMoveExitView()
    -----------------------------
    -- add by JackyXu.
    -- 防连点
    local nCurTime = os.time()
    if self.m_nLastTouchTime and nCurTime - self.m_nLastTouchTime <= 0 then
        return
    end
    self.m_nLastTouchTime = nCurTime
    -----------------------------
    self._scene:onQueryExitGame()
end

--endregion

--更新下注筹码按钮状态
function GameViewLayer:updateJettonState()
    -- 设置筹码可用状态
    for i = 5, 1, -1 do
        self.m_pControlButtonJetton[i]:setEnabled(RedVsBlackDataManager.getInstance():getJettonEnableState(i))
        if RedVsBlackDataManager.getInstance():getJettonEnableState(i) == false then
            self.m_pControlButtonJetton[i]:setColor(cc.c3b(127,127,127))
        else
            self.m_pControlButtonJetton[i]:setColor(cc.c3b(255,255,255))
        end
    end
    --计算当前筹码
    local nIndex = 0
    if self.nIndexChoose > 0 then
        if PlayerInfo.getInstance():getUserScore() >= RedVsBlackDataManager.getInstance():getJettonScore(self.nIndexChoose) then 
            nIndex = self.nIndexChoose
        else
            nIndex = RedVsBlackDataManager.getInstance():getJettonSelAdjust()
        end
    else
        -- 初次进入游戏 选择最小
        if PlayerInfo.getInstance():getUserScore() >= RedVsBlackDataManager.getInstance():getJettonScore(1) then
            nIndex = 1
        else
            nIndex = 0
        end
    end
    if nIndex <= 0 then 
        return
    end
    self.nIndexChoose = nIndex

     --设置当前筹码值
    local score = RedVsBlackDataManager.getInstance():getJettonScore(self.nIndexChoose)
    RedVsBlackDataManager.getInstance():setLotteryBaseScore(score)

    --筹码的位移
    for i=1,tonumber(5),1 do     
        local jettonnum = RedVsBlackDataManager.getInstance():getJettonScore(i)
        if jettonnum >= 10000 then
            jettonnum = tostring(jettonnum/10000).."w"
        end
        self.m_pControlButtonJetton[i]:loadTextureNormal( string.format("common/game_common/chip/chip_%s.png",jettonnum),ccui.TextureResType.localType)
        if self.nIndexChoose == i then
            self.m_pControlButtonJetton[i]:getChildByName("runImg"):setVisible(true)
        else
            self.m_pControlButtonJetton[i]:getChildByName("runImg"):setVisible(false)
        end
    end
end
function GameViewLayer:updateMyMoney()
    if self.m_myBetMoney[0] ~= 0 then
        self.Img_R:setVisible(true)
        self.Txt_goldR:setString(self.m_myBetMoney[0])
    end
    if self.m_myBetMoney[1] ~= 0 then
        self.Img_B:setVisible(true)
        self.Txt_goldB:setString(self.m_myBetMoney[1])
    end
    if self.m_myBetMoney[2] ~= 0 then
        self.Img_L:setVisible(true)
        self.Txt_goldL:setString(self.m_myBetMoney[2])
    end
end
--更新下注金币
function GameViewLayer:updateBetMoney(numquyu)
    if     numquyu == 0 then
        self.Txt_areaR:setString(self.AllTotal[0])
    elseif numquyu == 1 then
        self.Txt_areaB:setString(self.AllTotal[1])
    elseif numquyu == 2 then
        self.Txt_areaL:setString(self.AllTotal[2])
    else
        self.Txt_areaR:setString(0)
        self.Txt_areaB:setString(0)
        self.Txt_areaL:setString(0)
    end
    
end
--endregion
function GameViewLayer:updataTableMan()
    for k,v in ipairs(self.seatuser) do
        if k<=3 then
            local icon = self.m_pNodeLeft[k]:getChildByName("icon")
            local head = HeadSprite:createClipHead({userid = v[1], nickname = v[2], avatar_no = v[6]},124)
            head:setAnchorPoint(cc.p(0,0))
            icon:addChild(head)
            local name = self.m_pNodeLeft[k]:getChildByName("name")
            name:setString(v[2])
            local money = self.m_pNodeLeft[k]:getChildByName("money")
            money:setString(v[5])
        else
            local icon = self.m_pNodeRight[k-3]:getChildByName("icon")
            local head = HeadSprite:createClipHead({userid = v[1], nickname = v[2], avatar_no = v[6]},124)
            head:setAnchorPoint(cc.p(0,0))
            icon:addChild(head)
            local name = self.m_pNodeRight[k-3]:getChildByName("name")
            name:setString(v[2])
            local money = self.m_pNodeRight[k-3]:getChildByName("money")
            money:setString(v[5])
        end
    end
end
--上桌玩家投注时头像抖动动画
function GameViewLayer:playTableUserChipAni(idx)
    --[[
        桌子玩家位置索引
        1 4
        2 5
        3 6
        
    ]]--
    local offsetX = {  30, 30, 30, -30, -30, -30 }
    local ts = 0.1

    self.m_userBtnVec[idx]:stopAllActions()
    self.m_userBtnVec[idx]:setPosition(self.m_userBtnResPosVec[idx])

    local moveTo = cc.MoveTo:create(ts, cc.p(self.m_userBtnResPosVec[idx].x + offsetX[idx], self.m_userBtnResPosVec[idx].y))
    local moveBack = cc.MoveTo:create(ts, self.m_userBtnResPosVec[idx])
    local seq = cc.Sequence:create(moveTo, moveBack)

    self.m_userBtnVec[idx]:runAction(seq)
end
--[Comment]
-- 创建一个飞筹码动画并保存
-- jettonIndex: 筹码索引
-- wChipIndex: 押注区索引
-- startPos: 动画起始点
-- isMyFly: 是否我下的筹码
-- isAndroid: 是否机器人
-- iFinishTime: 动画持续时间
-- isNeedDelay: 是否需要随机延迟执行
function GameViewLayer:createFlyChipSprite(jettonIndex,wChipIndex,startPos,isMyFly,isAndroid,iFinishTime,isNeedDelay)
    -- 动态创建飞筹码对象
    local pSpr = cc.Sprite:create(self:getJettonIconFile(jettonIndex))
    if pSpr == nil then 
       pSpr = cc.Sprite:create("common/game_common/chip/chip_100.png")
    end
    local scale = CHIPSCALE
    pSpr:setScale(scale)
    pSpr:setPosition(startPos)
    pSpr:setTag(jettonIndex)
    self.m_pNodeChipSpr:addChild(pSpr,1)

    local oldSp = nil
    local idx, endPos = self:getChipEndPosition(wChipIndex, isMyFly)
    if isMyFly then
        local chiptg = self.m_betChipSpSelf[wChipIndex][idx]
        if nil ~= chiptg then
            oldSp = chiptg.pChipSpr
            self.m_betChipSpSelf[wChipIndex][idx].pChipSpr = pSpr
            self.m_betChipSpSelf[wChipIndex][idx].wJettonIndex = jettonIndex
            self.m_betChipSpSelf[wChipIndex][idx].wChipIndex = wChipIndex
            self.m_betChipSpSelf[wChipIndex][idx].nIdx = idx
        else
            chiptg = {}
            chiptg.pChipSpr = pSpr
            chiptg.wJettonIndex = jettonIndex
            chiptg.wChipIndex = wChipIndex
            chiptg.nIdx = idx
            self.m_betChipSpSelf[wChipIndex][idx] = chiptg
        end
    else
        local chiptg = self.m_betChipSpOthers[wChipIndex][idx]
        if nil ~= chiptg then
            oldSp = chiptg.pChipSpr
            self.m_betChipSpOthers[wChipIndex][idx].pChipSpr = pSpr
            self.m_betChipSpOthers[wChipIndex][idx].wJettonIndex = jettonIndex
            self.m_betChipSpOthers[wChipIndex][idx].wChipIndex = wChipIndex
            self.m_betChipSpOthers[wChipIndex][idx].nIdx = idx
            self.m_betChipSpOthers[wChipIndex][idx].tab = isAndroid
        else
            chiptg = {}
            chiptg.pChipSpr = pSpr
            chiptg.wJettonIndex = jettonIndex
            chiptg.wChipIndex = wChipIndex
            chiptg.nIdx = idx
            chiptg.tab = isAndroid
            self.m_betChipSpOthers[wChipIndex][idx] = chiptg
        end
    end

    if nil ~= oldSp then
        oldSp:runAction(self:createAutoDelAnim(oldSp))
    end

    local forward = cc.MoveTo:create(iFinishTime,endPos)
    local eMove = cc.EaseSineOut:create(forward) 
    local Value = 0
    if (not isMyFly) and isNeedDelay then
        Value = self.m_flychipidx * 0.4 + ( math.random(0,10) % 100)/100.0
    end

    local func = function()
        if not self.m_isPlayBetSound then
            if jettonIndex > 3 then -- 分段播放音效
                ExternalFun.playGameEffect("RBWar/sound/new_chips.mp3")
            else
                ExternalFun.playGameEffect("RBWar/sound/on_bet.mp3")
            end
            -- 尽量避免重复播放
            self:doSomethingLater(function() self.m_isPlayBetSound  = false end, math.random(2,4)/10)
            self.m_isPlayBetSound = true
        end
    end

    local seq = cc.Sequence:create(cc.Hide:create(), cc.DelayTime:create( Value ),cc.Show:create(), cc.CallFunc:create(func), eMove)
    pSpr:runAction(seq)

end

function GameViewLayer:FlyChip()

    local winArea = {}
    winArea[1] = 1  == self.win_zodic[1] -- 红方赢
    winArea[2] = 1  == self.win_zodic[2] -- 黑方赢
    winArea[3] = -1 ~= self.win_zodic[3]

    local bankerwinvec = {} -- 庄家获取的筹码
    local bankerlostvec = {} -- 庄家赔付筹码
    local selfwinvec = {} -- 我获取的筹码
    local otherwinvec = {} -- 其他人获取的筹码
    local selfvec = {} -- 我的所有区域筹码
    local othervec = {} -- 其他人的所有区域筹码
    local bankerwin = false
    local bankerlose = false
    local otherwin = false
    local selfwin = false

    --初始化并标记庄家获胜区域
    for i = 1, DOWN_COUNT_HOX do
        bankerwinvec[i] = {}
        bankerlostvec[i] = {}
        selfwinvec[i] = {}
        otherwinvec[i] = {}
        selfvec[i] = {winmark = winArea[i], vec = {}}
        othervec[i] = {winmark = winArea[i], vec = {}}
    end

    for i = 1, DOWN_COUNT_HOX do
        for k, v in pairs(self.m_betChipSpSelf[i-1]) do
             table.insert(selfvec[v.wChipIndex+1].vec, v)
        end

        for k, v in pairs(self.m_betChipSpOthers[i-1]) do
            table.insert(othervec[v.wChipIndex+1].vec, v)
        end
    end

    -- 遍历获胜的区域 必须用pairs方式 保证所有筹码遍历到
    local selfPos = self:getSelfChipBeginPosition()
    local otherPos = self:getOtherChipBeginPosition()
    for i = 1, CHIP_ITEM_COUNT do
        for k, v in pairs(selfvec[i].vec) do
            if v then
                table.insert(selfwinvec[i], {sp = v.pChipSpr, endpos = selfPos, winmark = selfvec[i].winmark})
                selfwin = true
            end
        end

        for k, v in pairs(othervec[i].vec) do
            if v then
                if v.tab ~= false then
                    table.insert(otherwinvec[i], {sp = v.pChipSpr, endpos = self.m_tabPos[v.tab], winmark = selfvec[i].winmark})
                    otherwin = true
                else
                    table.insert(otherwinvec[i], {sp = v.pChipSpr, endpos = otherPos, winmark = selfvec[i].winmark})
                    otherwin = true
                end              
            end
        end
    end

   

--    -- 庄家获取筹码
--    local jobitem1 = {
--        flytime       = CHIP_FLY_TIME,                                -- 飞行时间
--        flytimedelay  = false,                                        -- 飞行时间延长随机时间(0.05~0.15)
--        flysteptime   = CHIP_FLY_STEPDELAY,                           -- 筹码队列飞行间隔
--        nextjobtime   = CHIP_JOBSPACETIME,                            -- 下个任务执行间隔时间
--        chips         = bankerwinvec,                                 -- 筹码队列集合 二维数组[下注区域索引][筹码对象引用]
--        preCB         = function()                                    -- 任务开始时执行的回调，此回调根据preCBExec控制只执行一次
--                            if bankerwin then
--                                ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_GETGOLD)
--                            end
--                        end,
--        preCBExec     = false,
--        --overCB        = function() print("庄家获胜筹码飞行完毕") end, -- 动画任务完成后回调
--        hideAfterOver = true                                          -- 动画完成后隐藏
--    }

    -- 其他人赢得的筹码
    local jobitem3 = {
        flytime       = CHIP_FLY_TIME + 0.1,
        flysteptime   = CHIP_FLY_STEPDELAY,
        nextjobtime   = CHIP_JOBSPACETIME,
        chips         = otherwinvec,
        preCB         = function()
                            if otherwin then
                                ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_GETGOLD)
                            end
                        end,
        preCBExec     = false,
        --overCB        = function() print("其他人获胜筹码飞行完毕") end,
        hideAfterOver = true
    }

    -- 自己赢得的筹码
    local jobitem4 = {
        flytime       = CHIP_FLY_TIME + 0.1,
        flytimedelay  = true,                                        -- 飞行时间延长随机时间(0.05~0.15)
        flysteptime   = 0.01,
        nextjobtime   = CHIP_JOBSPACETIME,
        chips         = selfwinvec,
        preCB         = function()
                            if selfwin then
                                ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_GETGOLD)
                            end
                        end,
        preCBExec     = false,
        --overCB        = function() print("自己获胜筹码飞行完毕") end,
        hideAfterOver = true
    }

    self.m_flyJobVec = {}
    self.m_flyJobVec.nIdx = 1 -- 任务处理索引
    self.m_flyJobVec.flyIdx = 1 -- 飞行队列索引
    self.m_flyJobVec.jobVec = {} -- 任务对象
    self.m_flyJobVec.overCB = function()
        print("所有飞行任务执行完毕")
        self.m_flyJobVec = {}
        self:playUserScoreEffect()
    end

--    table.insert(self.m_flyJobVec.jobVec, { jobitem1 }) -- 1 飞行庄家获取筹码
--    table.insert(self.m_flyJobVec.jobVec, { jobitem2 }) -- 2 飞行庄家赔付筹码
    table.insert(self.m_flyJobVec.jobVec, { jobitem3, jobitem4 }) -- 3 其他人筹码和自己筹码一起飞行
    self:doFlyJob()
end

--执行单个的飞行任务
function GameViewLayer:doFlyJob()
    -- 全部任务执行完成之前，被清理重置
    if nil == self.m_flyJobVec.nIdx or nil == self.m_flyJobVec.jobVec then return end

    -- 任务处理完了
    if self.m_flyJobVec.nIdx > #self.m_flyJobVec.jobVec then
        if self.m_flyJobVec.overCB then
            self.m_flyJobVec.overCB()
        end
        return
    end

    -- 取出一个当前需要处理的飞行任务
    local job = self.m_flyJobVec.jobVec[self.m_flyJobVec.nIdx]
    if not job then return end
    if 0 == #job then return end

    -- 按队列取出需要飞行的对象进行动画处理
    local flyvec = {}
    local mf = math.floor
    if self.m_flyJobVec.flyIdx <= CHIP_FLY_SPLIT then
        for i = 1, #job do
            if job[i] then
                if job[i].preCB and (not job[i].preCBExec) then
                    job[i].preCB()
                    job[i].preCBExec = true
                end
                for j = 1, #job[i].chips do
                    local segnum = mf(#job[i].chips[j] / CHIP_FLY_SPLIT) -- 计算需要分成几段
                    for m = 0, segnum do
                        local tgg = job[i].chips[j][m*CHIP_FLY_SPLIT + self.m_flyJobVec.flyIdx]
                        if tgg then
                            table.insert(flyvec, { sptg = tgg, idx = i })
                        end                    
                    end
                end
            end
        end
    end

    -- 当前队列都飞完了
    if 0 == #flyvec then
        -- 下个任务的执行
        self.m_flyJobVec.nIdx = self.m_flyJobVec.nIdx + 1
        self.m_flyJobVec.flyIdx = 1
        self:doSomethingLater(function ()
            for i = 1, #job do
                if job[i].overCB then job[i].overCB() end
            end
            self:doFlyJob()
        end , job[1].nextjobtime) -- 多个任务时 取第一个任务的时间
        return
    end

    -- 开始飞筹码
    for i = 1, #flyvec do
        local tg = flyvec[i]
        if tg and tg.sptg then
            local ts = job[tg.idx].flytimedelay and job[tg.idx].flytime + math.random(5,15) / 100 or job[tg.idx].flytime
            local mt = cc.MoveTo:create(ts, tg.sptg.endpos)
            if i == #flyvec then -- 最后一个筹码飞行完成后执行下一次的飞行回调
                self.m_flyJobVec.flyIdx = self.m_flyJobVec.flyIdx + 1
                self:doSomethingLater(function ()
                    self:doFlyJob()
                end , job[tg.idx].flysteptime)
            end

            if job[tg.idx].hideAfterOver then
                tg.sptg.sp:runAction(cc.Sequence:create(cc.Show:create(), mt, cc.Hide:create()))
            else
                tg.sptg.sp:runAction(cc.Sequence:create(cc.Show:create(), mt))
            end
        end
    end
end
--游戏结果分配胜负筹码动画
function GameViewLayer:createAutoDelAnim(sper)
    local func = function()
        sper:stopAllActions()
        sper:removeFromParent()
        sper = nil
    end

    local delay = cc.DelayTime:create(1.8)
    local seq = cc.Sequence:create(delay, cc.Hide:create(), cc.CallFunc:create(func))
    return seq
end
--得分动画
function GameViewLayer:playUserScoreEffect()
    local selfcurscore = 0 -- 自己最终得分
    selfcurscore = RedVsBlackDataManager.getInstance():getSelfCurrResult()
    --用户当前积分
    local llUserScore = PlayerInfo.getInstance():getUserScore()
    local str = ""
    local curpath = ""

    -- 显示自己分数动画
    if selfcurscore ~= 0 then
        str = (selfcurscore)
        if selfcurscore > 0 then
            str = "+" .. str
        end
        local posSelf = cc.p(self.m_pmyCoin)
        posSelf.y = posSelf.y + 150
        curpath = selfcurscore < 0 and RedVsBlackRes.FNT_RESULT_LOSE or RedVsBlackRes.FNT_RESULT_WIN
        self:flyNumOfGoldChange(posSelf, curpath, str)    
    end

    --自己金币变化动画
    if selfcurscore > 0 then
        ExternalFun.playGameEffect("RBWar/sound/music_win.mp3")
        Effect:getInstance():showScoreChangeEffect(self.m_pmyMoney, llUserScore - selfcurscore   , selfcurscore, llUserScore + selfcurscore, 1, 10)
    else
        self.m_pmyMoney:setString((llUserScore + selfcurscore))
    end
    
end

--弹金币动画
function GameViewLayer:flyNumOfGoldChange(beginPos, filepath, str, cb)
    local lb = cc.Label:createWithBMFont(filepath, str)
                :setAnchorPoint(0, 0.5)
                :setOpacity(255)
                :setScale(1.2)
                :setVisible(true)
                :setPosition(beginPos)
                :addTo(self.m_pNodeChipSpr)

    local pos = cc.p(lb:getPosition())
    local callBack = cc.CallFunc:create(function ()
        lb:setVisible(false)
        lb:setPosition(pos)
        lb:stopAllActions()
        if cb then cb() end
    end)

    local pSeq = cc.Sequence:create(
        cc.EaseBounceOut:create(cc.MoveBy:create(0.8, cc.p(0,-50))),
        cc.DelayTime:create(2.0),
        cc.FadeOut:create(0.4),
        callBack
        )

    lb:runAction(pSeq)   
end

function GameViewLayer:resetCard()
    self.m_pCard:setVisible(false)
    for i = 1,3 do
        self.m_pHeiCard:getChildByName(string.format("image_heiCard%d",i)):setVisible(false)
        self.m_pHeiCard:getChildByName(string.format("image_heiCard%d_bg",i)):setVisible(true)

        self.m_pHongCard:getChildByName(string.format("image_hongCard%d",i)):setVisible(false)
        self.m_pHongCard:getChildByName(string.format("image_hongCard%d_bg",i)):setVisible(true)
    end
    self.m_pHongCard:getChildByName("image_hongPX"):setVisible(false)
    self.m_pHeiCard:getChildByName("image_heiPX"):setVisible(false)

    self.m_pHongCard:getChildByName("image_hongWinWin"):setVisible(false)
    self.m_pHeiCard:getChildByName("image_heiWinWin"):setVisible(false)

    self.m_chipEffect2:setVisible(false)
    self.m_chipEffect:setVisible(false)

    self.Img_R:setVisible(false)
    self.Img_B:setVisible(false)
    self.Img_L:setVisible(false)
end


--开牌动画
function GameViewLayer:OpenCard()
    self.m_pCard:setVisible(true)
    local i = 1;
    self:OpenCardLoop(i,true)
end

--循环开牌逻辑
function GameViewLayer:OpenCardLoop(i, bPlayEffect)
    if bPlayEffect == false then
        if 4 == i then -- 左边开牌完成 显示左侧牌型动画
            self:playCardTypeSound(self.m_cards[2][2]) -- 播放黑方牌型声音
            self:showHongORHeiPX(false)
            self:showWinResult()
            return
        end
        local card = self.m_pHeiCard:getChildByName(string.format("image_heiCard%d",i))
        local card_bg = self.m_pHeiCard:getChildByName(string.format("image_heiCard%d_bg",i))
        card:loadTexture(RedVsBlackRes.IMG_CARDS[self.m_cards[2][1][i]])
        local callFun1 = cc.CallFunc:create(function() card_bg:setVisible(false)  card:setVisible(true)  end)
        local callFun2 = cc.CallFunc:create(function() self:OpenCardLoop(i+1,false) end)
        local orbit = cc.OrbitCamera:create(0.15, 1, 0, 270, 90, 0, 0)
        card_bg:runAction(cc.Sequence:create(cc.DelayTime:create(0.6),orbit,callFun1 ,callFun2))
    end
    if i ~= 4 then
         ExternalFun.playGameEffect("RBWar/sound/afx_turn.mp3")
    end
   
    if bPlayEffect == true then
        if 4 == i then -- 所有牌开牌完成
            self:playCardTypeSound(self.m_cards[1][2]) -- 播放红方牌型声音
            self:showHongORHeiPX(true)
            self:OpenCardLoop(1,false)
            return
        end
        local card = self.m_pHongCard:getChildByName(string.format( "image_hongCard%d",i) )
        local card_bg = self.m_pHongCard:getChildByName(string.format("image_hongCard%d_bg",i))
        card:loadTexture(RedVsBlackRes.IMG_CARDS[self.m_cards[1][1][i]])
        local callFun1 = cc.CallFunc:create(function() card_bg:setVisible(false)  card:setVisible(true)  end)
        local callFun2 = cc.CallFunc:create(function() self:OpenCardLoop(i+1,true) end)
        local orbit = cc.OrbitCamera:create(0.15, 1, 0, 270, 90, 0, 0)
        card_bg:runAction(cc.Sequence:create(cc.DelayTime:create(0.6),orbit,callFun1 ,callFun2))
    end

end
--胜利区域光效动画
function GameViewLayer:initChipEffect()
    self.m_chipEffect = cc.Sprite:create("RBWar/image/new/hongsheng_02.png")
    self.m_chipEffect:setAnchorPoint(0.5, 0.5)
    self.m_chipEffect:addTo(self.m_pCenter)
    self.m_chipEffect:setVisible(false)
    self.m_chipEffect:setBlendFunc(cc.blendFunc(GL_ONE, GL_ONE))
    self.m_chipEffect:runAction(
        cc.RepeatForever:create(
            cc.Sequence:create(
                cc.FadeTo:create(0.5, 100),
                cc.FadeTo:create(0.5, 255)
            )
        )
    )
    self.m_chipEffect2 = cc.Sprite:create("RBWar/image/new/xyyj_02.png")
    self.m_chipEffect2:setAnchorPoint(0.5, 0.5)
    self.m_chipEffect2:addTo(self.m_pCenter)
    self.m_chipEffect2:setVisible(false)
    self.m_chipEffect2:setBlendFunc(cc.blendFunc(GL_ONE, GL_ONE))
    self.m_chipEffect2:runAction(
        cc.RepeatForever:create(
            cc.Sequence:create(
                cc.FadeTo:create(0.5, 100),
                cc.FadeTo:create(0.5, 255)
            )
        )
    )
end
function GameViewLayer:showWinResult()
    
    if self.win_zodic[1] == 1 then
        self.m_pHongCard:getChildByName("image_hongWinWin"):setVisible(true)
        self.m_pHeiCard:getChildByName("image_heiWinWin"):setVisible(false)
        self.m_chipEffect:setPosition(self.m_pareaR:getPosition())
        self.m_chipEffect:setColor(cc.c3b(255,255,255))
        self.m_chipEffect:setVisible(true)
        local adAnim = self.m_pareaR:getChildByName("particle") 
        local lizi = cc.ParticleSystemQuad:create("RBWar/effect/hhs.plist")
        lizi:setPosition(adAnim:getPosition())
        lizi:setScale(0.6)
        lizi:addTo(self.m_pareaR)
    end
    if self.win_zodic[2] == 1 then
        self.m_pHeiCard:getChildByName("image_heiWinWin"):setVisible(true)
        self.m_pHongCard:getChildByName("image_hongWinWin"):setVisible(false)
        self.m_chipEffect:setPosition(self.m_pareaB:getPosition())
        self.m_chipEffect:setColor(cc.c3b(255,255,255))
        self.m_chipEffect:setVisible(true)
        local adAnim = self.m_pareaB:getChildByName("particle") 
        local lizi = cc.ParticleSystemQuad:create("RBWar/effect/hhs.plist")
        lizi:setPosition(adAnim:getPosition())
        lizi:setScale(0.6)
        lizi:addTo(self.m_pareaB)
    end
    if self.win_zodic[3] ~= -1 then
        self.m_chipEffect2:setPosition(self.m_pareaL:getPosition())
        self.m_chipEffect2:setColor(cc.c3b(255,255,255))
        self.m_chipEffect2:setVisible(true)
        local adAnim = self.m_pareaL:getChildByName("particle") 
        local lizi = cc.ParticleSystemQuad:create("RBWar/effect/hhs.plist")
        lizi:setScale(0.6)
        lizi:setPosition(adAnim:getPosition())
        lizi:addTo(self.m_pareaL)
    end
    self:initBetView(5)
    self:doSomethingLater(function ()
        self:updataTableMan()
    end,3)
end
function GameViewLayer:showHongORHeiPX(entble)
    if entble == true then
        local px = self.m_pHongCard:getChildByName("image_hongPX")
        px:setVisible(true)
        px:loadTexture(RedVsBlackRes.IMG_ECardType[self.m_cards[1][2]])
    end
    if entble == false then
        local px = self.m_pHeiCard:getChildByName("image_heiPX")
        px:setVisible(true)
        px:loadTexture(RedVsBlackRes.IMG_ECardType[self.m_cards[2][2]])
    end
end
--endregion

--region 辅助方法
--获取投注筹码动画落点坐标
function GameViewLayer:getChipEndPosition(areaIndex, isSelf)
    local idx = 0
    local pos = cc.p(0, 0)
    if isSelf then
        if self.m_randmChipSelf[areaIndex].idx > #self.m_randmChipSelf[areaIndex].vec then
            idx = math.random(1, #self.m_randmChipSelf[areaIndex].vec)
        else
            idx = self.m_randmChipSelf[areaIndex].idx
            self.m_randmChipSelf[areaIndex].idx = idx + 1
        end
        pos = self.m_randmChipSelf[areaIndex].vec[idx]
    else
        if self.m_randmChipOthers[areaIndex].idx > #self.m_randmChipOthers[areaIndex].vec then
            idx = math.random(1, #self.m_randmChipOthers[areaIndex].vec)
        else
            idx = self.m_randmChipOthers[areaIndex].idx
            self.m_randmChipOthers[areaIndex].idx = idx + 1
        end
        pos = self.m_randmChipOthers[areaIndex].vec[idx]
    end

    return idx, pos
end

--获取自己筹码动画起点坐标
function GameViewLayer:getSelfChipBeginPosition()
    return self.m_pmyCoin
end

--获取其他玩家筹码动画起点坐标
function GameViewLayer:getOtherChipBeginPosition()
    return self.m_otherChipPos
end

--获取庄家筹码动画起点坐标
function GameViewLayer:getBankerChipBeginPosition()
    return self.m_bankerChipPos
end

function GameViewLayer:doSomethingLater(call, time)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(time), cc.CallFunc:create(call)))
end

-- 重置随机投注点
function GameViewLayer:resetChipPos()
    --self.m_lastflynum = 0
    local offsetVec = {3, 3, 6}
    local rowVal = {6, 6, 8}
    local colVal = {15, 15, 20}
    for i = 1, 3 do
        self.m_randmChipSelf[i-1] = {
            idx = 1, -- pos点的索引，原则上按递增方式取点，保证首次最大化铺满区域，然后随机取点
            vec = self:getRandomChipPosVec(self.m_chipAreaRect[i-1], 40, rowVal[i], colVal[i], offsetVec[i])
        }
        self.m_randmChipOthers[i-1] = {
            idx = 1,
            vec = self:getRandomChipPosVec(self.m_chipAreaRect[i-1], 40, rowVal[i], colVal[i], offsetVec[i])
        }

    end
end

-- 获取区域范围内指定数量的随机下注点
-- rect cc.rect矩形范围
-- num 需要的随机点数量
-- rowNum 显示多少行筹码 以能相互覆盖到为标准
-- colNum 显示多少列筹码 以能相互覆盖到为标准
-- offset 允许的随机偏移量
-- 返回值为筹码放置对象集合
function GameViewLayer:getRandomChipPosVec(rect, num, rowNum, colNum, offset)
    local rowStep = (math.floor(rect.height*100 / (rowNum + 1))) / 100
    local colStep = (math.floor(rect.width*100 / (colNum + 1))) / 100

    -- 计算逻辑矩形中总的筹码放置位置
    local chipPosVec = {}
    for m = 1, rowNum do
        for n = 1, colNum do
            local randx = (math.random(-offset*100, offset*100)) / 100
            local randy = (math.random(-offset*100, offset*100)) / 100
            local posx = rect.x + n*colStep + randx
            local posy = rect.y + m*rowStep + randy
            table.insert(chipPosVec, cc.p(posx, posy))
        end
    end

    -- 乱序排列
    local count = #chipPosVec

    for i = 1, count do
        local tmp = math.random(i, count)
        chipPosVec[i], chipPosVec[tmp] = chipPosVec[tmp], chipPosVec[i]
    end

    return chipPosVec
end
function GameViewLayer:initUserData()
    PlayerInfo.getInstance():setChairID(GlobalUserItem.tabAccountInfo.userid)
    PlayerInfo.getInstance():setUserScore(GlobalUserItem.tabAccountInfo.into_money)
    PlayerInfo.getInstance():setUserName(GlobalUserItem.tabAccountInfo.nickname)
end

function GameViewLayer:getJettonIconFile(nIndex)
    local str = "common/game_common/chip/chip_100.png"
    if not nIndex then 
        return str
    end
    if nIndex >= 10000 then
        nIndex = tostring(nIndex/10000).."w"
    end
    str = string.format(string.format("common/game_common/chip/chip_%s.png",nIndex))
    return str
end

--清理用户信息
function GameViewLayer:cleanPlayerData()
    --删除layer时，清理数据
    PlayerInfo.getInstance():setChairID(G_CONSTANTS.INVALID_CHAIR)
    PlayerInfo.getInstance():setTableID(G_CONSTANTS.INVALID_TABLE)
    PlayerInfo.getInstance():setSitSuc(false)
    PlayerInfo.getInstance():setIsQuickStart(false)
    PlayerInfo.getInstance():setIsGameBackToHall(true)
    PlayerInfo:getInstance():setIsGameBackToHallSuc(false)
end


--牌型音效
function GameViewLayer:playCardTypeSound(typeIndex)
    -- { "单牌","对子","顺子","金花","顺金","豹子", }
    local soundfilepath = string.format(RedVsBlackRes.SOUND_OF_CARDTYPE, typeIndex)
    -- 牌型音乐
    ExternalFun.playGameEffect(soundfilepath)
end

--得到整数部分
function GameViewLayer:getIntValue(num)
    local tt = 0
    num,tt = math.modf(num/1);
    return num
end
--endregion
----------------------------------------------------------------------------------------------Trend----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------Trend----------------------------------------------------------------------------------------------------------
function GameViewLayer:initRBWarTrend()
    local trend = cc.CSLoader:createNode("RBWar/RBWarTrend.csb")
    self.m_pathUI:addChild(trend)
    -- node
    self.trendBg = trend:getChildByName("image_bg")
    self.NodeCon_zpl = self.trendBg:getChildByName("node_zplContainer")
    self.NodeCon_dl  = self.trendBg:getChildByName("node_dlContainer")
    self.NodeCon_dyzl = self.trendBg:getChildByName("node_dyzlContainer")
    self.NodeCon_xl = self.trendBg:getChildByName("node_xlContainer")
    self.NodeCon_yyl = self.trendBg:getChildByName("node_yylContainer")

    -- txtnum
    self.Round_red   = self.trendBg:getChildByName("atlas_round_red")     -- 红赢次数
    self.Round_black = self.trendBg:getChildByName("atlas_round_black")   -- 黑赢次数
    self.Round_lucky = self.trendBg:getChildByName("atlas_round_lucky")   -- 幸运一击次数
    self.Round_total = self.trendBg:getChildByName("atlas_round_total")   -- 总次数
    
    -- 类型list
    self.ListView_CartType = self.trendBg:getChildByName("listView_lvCartType")

    -- 红黑问路
    for i = 1 , 3 do
        self.Img_HongWenlu[i]   = self.trendBg:getChildByName(string.format("image_wenlu_2_%d",i))
        self.Img_HeiWenlu[i]    = self.trendBg:getChildByName(string.format("image_wenlu_1_%d",i))
    end
    -- 红黑 item
    for i = 1 , 2 do
        self.Image_zplItem[i]  = trend:getChildByName(string.format("image_zplItem_%d",i))
        self.Image_dlItem[i]   = trend:getChildByName(string.format("image_dlItem_%d",i))
        self.Image_dyzlItem[i] = trend:getChildByName(string.format("image_dyzlItem_%d",i))
        self.Image_xlItem[i]   = trend:getChildByName(string.format("image_xlItem_%d",i))
        self.Image_yylItem[i]  = trend:getChildByName(string.format("image_yylItem_%d",i))
    end
    -- 牌的类型
    self.Image_cardTypeItem  = trend:getChildByName("image_cardTypeItem")
    self.Txt_cardTypeName = self.Image_cardTypeItem:getChildByName("text_cardTypeName")
    self.Image_careType = self.Image_cardTypeItem:getChildByName("Image_10")


end
function GameViewLayer:updateCardType()
    self.ListView_CartType:removeAllItems()
    local data = self.History_Path
    local lastItem
    for i, v in ipairs(data) do
        local item = self.Image_cardTypeItem:clone()
        local textType = item:getChildByName('text_cardTypeName')
        textType:setString(RedVsBlackRes.ECardType[v[2]])
        if v[2] > 1 then
            item:loadTexture('RBWar/image/trend/trendluckyes.png')
            textType:setTextColor(cc.c4b(191, 76, 9, 255))
        end
        self.ListView_CartType:pushBackCustomItem(item)
        self.ListView_CartType:jumpToRight()
        lastItem = item
    end
    if lastItem then
        local newIcon = display.newSprite('RBWar/image/trend/hh_new.png')
        newIcon:setScale(0.7)
        newIcon:setPosition(cc.p(50, 34))
        lastItem:addChild(newIcon)
    end
end

function GameViewLayer:updateRoundNum()
    local data = self.History_Path
    local gameInfo = {
                        redcnt   = 0,
                        blackcnt = 0,
                        luckycnt = 0,
                        roundcnt = 0,
                    };
    gameInfo.roundcnt = #data
    for k,v in ipairs(data) do
        if v[1] == LU_TYPE.T1 then
            gameInfo.redcnt = gameInfo.redcnt + 1
        elseif v[1] == LU_TYPE.T2 then
            gameInfo.blackcnt = gameInfo.blackcnt + 1
        end
        if v[2] >= 2 then
            gameInfo.luckycnt = gameInfo.luckycnt + 1
        end
    end
    
    if not gameInfo then
        return
    end
    local redRound = gameInfo.redcnt or 0
    local blackRound = gameInfo.blackcnt or 0
    local luckyRound = gameInfo.luckycnt or 0
    local totalRound = gameInfo.roundcnt or 0
    self.Round_red:setString(redRound)
    self.Round_black:setString(blackRound)
    self.Round_lucky:setString(luckyRound)
    self.Round_total:setString(totalRound)
end
function GameViewLayer:updateT1WenLu()
    local data = self.History_Path
    local len  = #data
    self.Img_HongWenlu[1]:setVisible(nil ~= data)
    if data then
        if LU_TYPE.T1 == data[len][1] then
            self.Img_HongWenlu[1]:loadTexture('RBWar/image/trend/hh_pl3.png')
        elseif LU_TYPE.T2 == data[len][1] then
            self.Img_HongWenlu[1]:loadTexture('RBWar/image/trend/hh_pl6.png')
        end
    end
--    data = TrendHelper.getLastXL()
    self.Img_HongWenlu[2]:setVisible(nil ~= data)
    if data then
        if LU_TYPE.T1 == data[len][1] then
            self.Img_HongWenlu[2]:loadTexture('RBWar/image/trend/hh_pl4.png')
        elseif LU_TYPE.T2 == data[len][1] then
            self.Img_HongWenlu[2]:loadTexture('RBWar/image/trend/hh_pl7.png')
        end
    end
--    data = TrendHelper.getLastYYL()
    self.Img_HongWenlu[3]:setVisible(nil ~= data)
    if data then
        if LU_TYPE.T1 == data[len][1] then
            self.Img_HongWenlu[3]:loadTexture('RBWar/image/trend/hh_pl5.png')
        elseif LU_TYPE.T2 == data[len][1] then
            self.Img_HongWenlu[3]:loadTexture('RBWar/image/trend/hh_pl8.png')
        end
    end
end

function GameViewLayer:updateT2WenLu()
    local data = self.History_Path
    local len  = #data
    self.Img_HeiWenlu[1]:setVisible(nil ~= data)
    if data then
        if LU_TYPE.T2 == data[len][1] then
            self.Img_HeiWenlu[1]:loadTexture('RBWar/image/trend/hh_pl3.png')
        elseif LU_TYPE.T1 == data[len][1] then
            self.Img_HeiWenlu[1]:loadTexture('RBWar/image/trend/hh_pl6.png')
        end
    end
    self.Img_HeiWenlu[2]:setVisible(nil ~= data)
    if data then
        if LU_TYPE.T2 == data[len][1] then
            self.Img_HeiWenlu[2]:loadTexture('RBWar/image/trend/hh_pl4.png')
        elseif LU_TYPE.T1 == data[len][1] then
            self.Img_HeiWenlu[2]:loadTexture('RBWar/image/trend/hh_pl7.png')
        end
    end
    self.Img_HeiWenlu[3]:setVisible(nil ~= data)
    if data then
        if LU_TYPE.T2 == data[len][1] then
            self.Img_HeiWenlu[3]:loadTexture('RBWar/image/trend/hh_pl5.png')
        elseif LU_TYPE.T1 == data[len][1] then
            self.Img_HeiWenlu[3]:loadTexture('RBWar/image/trend/hh_pl8.png')
        end
    end
end
local function overflowIndex(total, max, m)
    local startIdx = 1
	if max < total then
		local mod = total % m
		local left = (0 == mod) and 0 or (m - mod)
        startIdx = total - max + 1 + left
    end
    return startIdx
end
function GameViewLayer:updateZPL()
    self.NodeCon_zpl:removeAllChildren()
    local data = self.History_Path
    local itemWH = 38.5

    local len = #data
    local startIdx = overflowIndex(len, 48, 6)
    local lastNode
    for i = startIdx, len do
        local idx = i - startIdx
        local cloneNode = self.Image_zplItem[data[i][1]]
        if cloneNode then
            local nodeItem = cloneNode:clone()
            local row = idx % 6
            local column = math.modf(idx / 6)
            nodeItem:setPosition(column * itemWH, -row * itemWH)
            self.NodeCon_zpl:addChild(nodeItem)
            lastNode = nodeItem
        end
    end
    if lastNode then
        lastNode:runAction(cc.Blink:create(3, 5))
    end
end

function GameViewLayer:updateDL()
    self.NodeCon_dl:removeAllChildren()
    local data = self.History_Path
    local Num = {}
    local a = 1;
    local b = 0;
    local c = 1;
    Num[a] = {}
    for k = 1, #data do
        if k == #data then
            Num[a][c] = data[k][1]
            break
        end
        
        if data[k][1] == data[k+1][1] then
            Num[a][c] = data[k][1]
            b = a
        else
            Num[a][c] = data[k][1]       
            a = a + 1
            Num[a] = {}
        end
        if a == b then
            c = c + 1
        else
            c = 1
        end
    end  
    local len = #Num
    local startIdx = 1
    if 24 < len then
        startIdx = startIdx + len - 24
    end
    local lastNode
    for i = startIdx, len do
        local columnData = Num[i]    
        for j = 1, table.maxn(columnData) do
            if table.maxn(columnData) > 6 then
                i = i + (table.maxn(columnData) - 6)
                j = j - (table.maxn(columnData) - 6)
            end
            local dataItem = columnData[j]
            if dataItem then
                local nodeItem = self.Image_dlItem[Num[i][1]]:clone()
                nodeItem:setPosition((i - startIdx) * 18.4, -(j - 1) * 19.2)
                self.NodeCon_dl:addChild(nodeItem)
                lastNode = nodeItem
            end
        end
    end
    if lastNode then
        lastNode:runAction(cc.Blink:create(3, 5))
    end
end
function GameViewLayer:updateDYZL()
    self.NodeCon_dyzl:removeAllChildren()
    local data = self.History_Path
    local Num = {}
    local a = 1;
    local b = 0;
    local c = 1;
    Num[a] = {}
    for k = 1, #data do
        if k == #data then
            Num[a][c] = data[k][1]
            break
        end
        
        if data[k][1] == data[k+1][1] then
            Num[a][c] = data[k][1]
            b = a
        else
            Num[a][c] = data[k][1]       
            a = a + 1
            Num[a] = {}
        end
        if a == b then
            c = c + 1
        else
            c = 1
        end
    end  
    local len = #Num
    local startIdx = 1
    if 24 < len then
        startIdx = startIdx + len - 24
    end
    local lastNode
    for i = startIdx, len do
        local columnData = Num[i]    
        for j = 1, table.maxn(columnData) do
            if table.maxn(columnData) > 6 then
                i = i + (table.maxn(columnData) - 6)
                j = j - (table.maxn(columnData) - 6)
            end
            local dataItem = columnData[j]
            if dataItem then
                local nodeItem = self.Image_dyzlItem[Num[i][1]]:clone()
                nodeItem:setPosition((i - startIdx) * 9.2, -(j - 1) * 9.75)
                self.NodeCon_dyzl:addChild(nodeItem)
                lastNode = nodeItem
            end
        end
    end
    if lastNode then
        lastNode:runAction(cc.Blink:create(3, 5))
    end
end
function GameViewLayer:updateXL()
    self.NodeCon_xl:removeAllChildren()
    local data = self.History_Path
    local Num = {}
    local a = 1;
    local b = 0;
    local c = 1;
    Num[a] = {}
    for k = 1, #data do
        if k == #data then
            Num[a][c] = data[k][1]
            break
        end
        
        if data[k][1] == data[k+1][1] then
            Num[a][c] = data[k][1]
            b = a
        else
            Num[a][c] = data[k][1]       
            a = a + 1
            Num[a] = {}
        end
        if a == b then
            c = c + 1
        else
            c = 1
        end
    end  
    local len = #Num
    local startIdx = 1
    if 24 < len then
        startIdx = startIdx + len - 24
    end
    local lastNode
    for i = startIdx, len do
        local columnData = Num[i]    
        for j = 1, table.maxn(columnData) do
            if table.maxn(columnData) > 6 then
                i = i + (table.maxn(columnData) - 6)
                j = j - (table.maxn(columnData) - 6)
            end
            local dataItem = columnData[j]
            if dataItem then
                local nodeItem = self.Image_xlItem[Num[i][1]]:clone()
                nodeItem:setPosition((i - startIdx) * 9.2, -(j - 1) * 9.75)
                self.NodeCon_xl:addChild(nodeItem)
                lastNode = nodeItem
            end
        end
    end
    if lastNode then
        lastNode:runAction(cc.Blink:create(3, 5))
    end
end

function GameViewLayer:updateYYL()
    self.NodeCon_yyl:removeAllChildren()
    local data = self.History_Path
    local Num = {}
    local a = 1;
    local b = 0;
    local c = 1;
    Num[a] = {}
    for k = 1, #data do
        if k == #data then
            Num[a][c] = data[k][1]
            break
        end
        
        if data[k][1] == data[k+1][1] then
            Num[a][c] = data[k][1]
            b = a
        else
            Num[a][c] = data[k][1]       
            a = a + 1
            Num[a] = {}
        end
        if a == b then
            c = c + 1
        else
            c = 1
        end
    end  
    local len = #Num
    local startIdx = 1
    if 24 < len then
        startIdx = startIdx + len - 24
    end
    local lastNode
    for i = startIdx, len do
        local columnData = Num[i]    
        for j = 1, table.maxn(columnData) do
            if table.maxn(columnData) > 6 then
                i = i + (table.maxn(columnData) - 6)
                j = j - (table.maxn(columnData) - 6)
            end
            local dataItem = columnData[j]
            if dataItem then
                local nodeItem = self.Image_yylItem[Num[i][1]]:clone()
                nodeItem:setPosition((i - startIdx) * 9.2, -(j - 1) * 9.75)
                self.NodeCon_yyl:addChild(nodeItem)
                lastNode = nodeItem
            end
        end
    end
    if lastNode then
        lastNode:runAction(cc.Blink:create(3, 5))
    end
end

function GameViewLayer:updateRBWarTrend()

    self:updateZPL()
    self:updateDL()
    self:updateDYZL()
    self:updateXL()
    self:updateYYL()
    self:updateT1WenLu()
    self:updateT2WenLu()
    self:updateRoundNum()
    self:updateCardType()

end



return GameViewLayer
