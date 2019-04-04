--
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun               = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local module_pre                = "game.yule.bjl.src"
local HeadSprite                = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
local RuleLayer                 = appdf.req(module_pre .. ".views.layer.RuleLayer")
local SettingLayer              = appdf.req(module_pre .. ".views.layer.SettingLayer")
local ResoultLayer              = appdf.req(module_pre .. ".views.layer.ResoultLayer")
local BaccaratRes               = appdf.req(module_pre .. ".game.baccarat.scene.BaccaratRes")
local BaccaratDefine            = appdf.req(module_pre .. ".game.baccarat.scene.BaccaratDefine")
local BaccaratOtherInfoLayer    = appdf.req(module_pre .. ".views.layer.BaccaratOtherInfoLayer")
local BaccaratDataMgr           = appdf.req(module_pre .. ".game.baccarat.manager.BaccaratDataMgr")
local Effect                    = appdf.req(module_pre .. ".models.Effect");
local PlayerInfo                = appdf.req(appdf.EXTERNAL_SRC .. "PlayerInfo")
local scheduler                 = appdf.req("game.yule.bjl.src.models.scheduler")
local FloatMessage              = cc.exports.FloatMessage

local ChipCount          = 5--6 --筹码数量
local AreaCount          = 5 --投注区域数量
local ChipOffsetY        = 14 --选中筹码位移
local FlyChipScale       = 0.35 --下注筹码缩放比例

local CHIP_FLY_STEPDELAY = 0.02 --筹码连续飞行间隔
local CHIP_FLY_TIME      = 0.25 --飞筹码动画时间
local CHIP_JOBSPACETIME  = 0.2 --飞筹码任务队列间隔
local CHIP_FLY_SPLIT     = 20 -- 飞行筹码分组 分XX次飞完
local CHIP_ITEM_COUNT    = AreaCount --下注项数
local CHIP_REWARD        = {2, 9, 2, 3, 3, 33, 12, 12}
local IPHONEX_OFFSETX    = 60


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

function GameViewLayer:ctor(scene)
    math.randomseed(os.time())
    self:enableNodeEvents()
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
    self.m_pathUI = cc.CSLoader:createNode(BaccaratRes.CSB_GAME_MAIN)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0, diffY))
    self.m_pathUI:addTo(self.m_rootUI)
    self:init()
    ExternalFun.registerNodeEvent(self)
    self._scene = scene
end

function GameViewLayer:onEnter()
    
end

function GameViewLayer:onExit()
    --清理计时器
    self:cleanEvent()
end

function GameViewLayer:init()
    --初始化数据
    self:initVar()
    --初始化主ui
    self:initUI()
    --注册按钮事件
    self:initBtnClickEvent()
    --初始化桌上玩家
    self:initseatinfo()
    --重置筹码随机投注坐标
    self:resetChipPos() 
    --分辨率自适应
    self:setNodeFixPostion()
    --初始化路子
    self:initTrendChart()
end

--分辨率适配
function GameViewLayer:setNodeFixPostion()
    local diffX = 145-(1624-display.size.width)/2

    -- 根容器节点
    self.m_rootNode:setPositionX(diffX)

    if LuaUtils.isIphoneXDesignResolution() then
        self.m_ImageBg:setContentSize(display.size.width,display.size.height)
        self.m_pPanelPlayers:setContentSize(display.size.width,display.size.height)
        self.m_pPanelMenu:setContentSize(display.size.width,display.size.height)
        self.m_pPanelMenu:setPositionX(-diffX)

        self.m_opBar:setPositionX(diffX)
--        self.m_NodebetTip:setPositionX(self.m_NodebetTip:getPositionX() + diffX)
        self.m_pNodestu:setPositionX(self.m_pNodestu:getPositionX() + diffX)
        for i = 1 , 5  do
            self.m_PanelBetPos[i]:setPositionX(self.m_PanelBetPos[i]:getPositionX() + diffX)
            self.m_BtnChooseBet[i]:setPositionX(self.m_BtnChooseBet[i]:getPositionX() + diffX)
        end
        
    end
end
--初始化变量，此方法内变量在断线重连后，需要重置
function GameViewLayer:initVar()
    self.m_vJettonOfMine        = {} --自己筹码 {pSpr = sp(筹码对象), nIdx = idx(随机坐标索引)}
    self.m_vJettonOfOther       = {} --其他筹码 {pSpr = sp(筹码对象), nIdx = idx(随机坐标索引)}
    self.m_isPlayBetSound       = false --是否正在播放筹码音效
    self.m_isPlayDaojishi       = false --是否在播放最后3秒倒计时动画
    self.m_randmChipSelf        = {} --自己的随机筹码投注区
    self.m_randmChipOthers      = {} --其他玩家的随机筹码投注区
    self.m_flyJobVec            = {} --飞行筹码任务清空
    self.m_sendCard             = {} --前2张发牌
    self.m_nSoundClock          = nil
    self.m_daluMaxCol           = 0
    self.m_zhuluMaxCol          = 0
    self.m_oldScore             = 0
    self.m_flychipidx           = 0
    self.isOpenMenu             = false
    self.nIndexChoose           = 0 --选中筹码的索引
    self.m_pControlButtonJetton = {}
    self.Betitem                = {}
    self.m_pNodeSeat            = {}
    self.Node_seatPos           = {}
    self.m_tabPos               = {}
    self.m_userBtnVec           = {}
    self.m_userBtnResPosVec     = {}
    self.m_Seatcoin             = {}
    self.m_chipAreaRect         = {} --筹码放置范围

    self.img_xianCard           = {}
    self.img_xianCardBg         = {}
    self.img_zhuangCard         = {}
    self.img_zhuangCardBg       = {}

    self.m_PanelBetPos          = {}
    self.m_BtnChooseBet         = {}
    self.m_textPoolnum          = {}
    self.m_textSelfnum          = {}

    self.win_zodic              = {}

    self.m_betChipSpSelf   = {} -- 自己的5个地区投注筹码精灵 { jettonIndex =  筹码索引, pChipSpr =  筹码精灵对象, pos = 坐标 }
    self.m_betChipSpOthers = {} -- 他人的5个地区投注筹码精灵
    self.m_myBetMoney      = {}
    for i = 1 , 5 do
        self.m_betChipSpSelf[i]   = {} -- 自己的5个地区投注筹码精灵 { jettonIndex =  筹码索引, pChipSpr =  筹码精灵对象, pos = 坐标 }
        self.m_betChipSpOthers[i] = {} -- 他人的5个地区投注筹码精灵
        self.m_myBetMoney[i]      = 0
    end
    
    self:initUserData()
    self.m_mymoney = GlobalUserItem.tabAccountInfo.into_money
    ---------------------------------------------------------------------------
end
-- 初始化数据
function GameViewLayer:initUserData()
    PlayerInfo.getInstance():setChairID(GlobalUserItem.tabAccountInfo.userid)
    PlayerInfo.getInstance():setUserScore(GlobalUserItem.tabAccountInfo.into_money)
    PlayerInfo.getInstance():setUserName(GlobalUserItem.tabAccountInfo.nickname)
end

--初始化UI组件 此方法内变量在断线重连后，不需要重置
function GameViewLayer:initUI()
    self.m_rootNode          = self.m_pathUI
    self.m_ImageBg           = self.m_pathUI:getChildByName("image_bg")
    self.m_pNodeChipSpr      = self.m_pathUI:getChildByName("nodeFlyChip")
    -- 1. 闲对子 ； 2，庄对子 ；3 ，闲； 4 ，和 ； 5 ， 庄
    for i = 1, 5 do
        self.m_PanelBetPos[i]  = self.m_pNodeChipSpr:getChildByName("panel_betPos"..i)
        local x, y = self.m_PanelBetPos[i]:getPosition()
        self.m_chipAreaRect[i] = cc.rect(x, y, self.m_PanelBetPos[i]:getContentSize().width, self.m_PanelBetPos[i]:getContentSize().height)

        self.m_BtnChooseBet[i] = self.m_ImageBg:getChildByName("button_choosebet"..i)
        self.m_BtnChooseBet[i]:addClickEventListener(handler(self,function() self:onAnimalClicked(i) end))

        self.m_textPoolnum[i] = self.m_ImageBg:getChildByName("button_choosebet"..i):getChildByName("Sprite_60"):getChildByName("text_poolNum"..i)
        self.m_textSelfnum[i] = self.m_ImageBg:getChildByName("button_choosebet"..i):getChildByName("Sprite_60"):getChildByName("text_selfBetCnt"..i)
    end
    --
    self.m_pNodestu = self.m_ImageBg:getChildByName("Node_1")
    -- 菜单
    self.m_pBtnMenuPop = self.m_ImageBg:getChildByName("button_back")   
    self.m_pBtnMenuPop:setLocalZOrder(1)
    self.m_pImgMenu    = self.m_pBtnMenuPop:getChildByName("Image_5")
    -- 菜单层
    self.m_pPanelMenu    = self.m_rootNode:getChildByName("panel_backMenu"):setVisible(false)
    self.m_psettingPanel = self.m_pPanelMenu:getChildByName("image_settingPanel")
    self.m_pBtnExit      = self.m_psettingPanel:getChildByName("button_exit")
    self.m_pBtnSetting   = self.m_psettingPanel:getChildByName("button_setting")
    self.m_pBtnHelp      = self.m_psettingPanel:getChildByName("button_helpX")  
    self.m_pBtnFullClose = self.m_pPanelMenu:getChildByName("btn_close")
    -- 牌层
    self.m_ImagedealCards  = self.m_pathUI:getChildByName("image_dealCards"):setVisible(false)
    self.m_resultType      =  self.m_ImagedealCards:getChildByName("image_resultType"):setVisible(false)  -- 和局，庄赢，闲赢

    for i = 1, 3 do
        self.img_xianCard[i]     = self.m_ImagedealCards:getChildByName("node_xianCards"):getChildByName("image_xianCard"..i):setVisible(false)
        self.img_xianCardBg[i]   = self.m_ImagedealCards:getChildByName("node_xianCards"):getChildByName( string.format("image_xianCard%d_bg",i)):setVisible(false)

        self.img_zhuangCard[i]   = self.m_ImagedealCards:getChildByName("node_zhuangCards"):getChildByName("image_zhuangCard"..i):setVisible(false)
        self.img_zhuangCardBg[i] = self.m_ImagedealCards:getChildByName("node_zhuangCards"):getChildByName( string.format("image_zhuangCard%d_bg",i)):setVisible(false)
    end
    self.m_NodexiangCards  = self.m_ImagedealCards:getChildByName("node_xianCards")
    self.m_NodezhuangCards = self.m_ImagedealCards:getChildByName("node_zhuangCards")
    -- 路子层
    self.m_ImagebgTrendChart = self.m_pathUI:getChildByName("image_bgTrendChart")   
    -- 开始下注and结束下注
    self.m_NodebetTip = self.m_pathUI:getChildByName("fileNode_betTip"):setVisible(false)
    -- 桌上玩家
    self.m_pPanelPlayers = self.m_rootNode:getChildByName("panel_panelPlayers")
    self.m_btnPlayer     = self.m_pPanelPlayers:getChildByName("node_seatPos7"):getChildByName("button_allPlayersBtn")
    local x1, y1 = self.m_pPanelPlayers:getChildByName("node_seatPos7"):getPosition()
    self.m_otherChipPos = cc.p(x1, y1)

    self.m_btnPlayerNum  = self.m_pPanelPlayers:getChildByName("node_seatPos7"):getChildByName("button_allPlayersBtn"):getChildByName("text_allPlayerText")
    -- 个人信息
    self.m_opBar    = self.m_ImageBg:getChildByName("image_opBar")
    self.m_pmyHead  = self.m_opBar:getChildByName("Node_selfInfomation"):getChildByName("image_selfAvatar")
    self.m_pmyName  = self.m_opBar:getChildByName("Node_selfInfomation"):getChildByName("text_selfName")
    self.m_pmyMoney = self.m_opBar:getChildByName("Node_selfInfomation"):getChildByName("text_selfMoneyNum")
    
    self.m_pNodecoin = self.m_opBar:getChildByName("Node_selfInfomation"):getChildByName("node_coinAnimNode")   -- 飞筹码
    local x, y = self.m_pNodecoin:getPosition()
    self.m_pmyCoin = cc.p(x, y)
    self.m_pwinCoinNum = self.m_opBar:getChildByName("Node_selfInfomation"):getChildByName("atlas_winCoinNum")   -- 赢钱
    self.m_ploseCoinNum = self.m_opBar:getChildByName("Node_selfInfomation"):getChildByName("atlas_loseCoinNum")   -- 输钱
    
end
-- 初始化按钮回调
function GameViewLayer:initBtnClickEvent()
    self.m_pBtnExit:addClickEventListener(handler(self,self.onReturnClicked))        -- 退出
    self.m_pBtnSetting:addClickEventListener(handler(self,self.onSettingClicked))    -- 设置
    self.m_pBtnHelp:addClickEventListener(handler(self,self.onHelpClicked))          -- 规则
    self.m_pBtnFullClose:addClickEventListener(handler(self,self.onPushClicked))     -- 关闭
    self.m_pBtnMenuPop:addClickEventListener(handler(self,self.onPopClicked))        -- 弹出
    self.m_btnPlayer:addClickEventListener(handler(self,self.onOtherInfoClicked))    -- 玩家
end
-- 开始下注and结束下注
function GameViewLayer:initStarAndEnd(iswhat)
--    local ani = cc.CSLoader:createNode("Baccarat/Node_RBWarBetTip.csb")
--    ani:setPosition(display.width/2,display.height/2)
--    self.m_pathUI:addChild(ani,100)
    self.m_NodebetTip:setVisible(true)
    local action = cc.CSLoader:createTimeline("Baccarat/BaccaratBetTip.csb")
    self.m_NodebetTip:runAction(action)
    if iswhat == BET_STAR then
        ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_WAGER_START)
        action:gotoFrameAndPlay(0,25, false)  --true循环播放，false 播放一次
        self:doSomethingLater(function()
            self.m_NodebetTip:setVisible(false)
        end, 1)
    elseif iswhat == BET_END then
        ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_WAGER_STOP)
        action:gotoFrameAndPlay(30,55, false)  --true循环播放，false 播放一次
        self:doSomethingLater(function()
            self.m_NodebetTip:setVisible(false)
        end, 1)
    else
        print("播放失败！")
    end
end
-- 初始化桌上玩家
function GameViewLayer:initseatinfo()

    for i = 1, 6  do
        local ani = cc.CSLoader:createNode("Baccarat/BaccaratSeat.csb")
        ani:setScale(0.8)
        self.Node_seatPos[i] = self.m_pPanelPlayers:getChildByName("node_seatPos"..i)
        ani:addTo(self.Node_seatPos[i])
        self.m_pNodeSeat[i] = ani
        table.insert(self.m_userBtnVec,self.Node_seatPos[i])
        local x,y = self.Node_seatPos[i]:getPosition()
        table.insert(self.m_userBtnResPosVec,{x = x,y = y })
        local pos = cc.p(x,y);
        table.insert(self.m_tabPos,pos)
    end

end
-- 更新桌上玩家
function GameViewLayer:updataTableMan()
    for k,v in ipairs(self.seatuser) do
        for key,vec in ipairs( BaccaratDataMgr.getInstance():getMembers()) do
            if vec[1] == v then
                local icon = self.m_pNodeSeat[k]:getChildByName("node_nodeAvatar")
                local head = HeadSprite:createClipHead({userid = vec[1], nickname = vec[2], avatar_no = vec[3]},124)
                head:setAnchorPoint(cc.p(0.5,0.5))
                head:setPositionY(head:getPositionY() + 10)
                icon:addChild(head)     
                
                local name = self.m_pNodeSeat[k]:getChildByName("image_infoBg"):getChildByName("text_nickname")
                name:setString(vec[2])
                local money = self.m_pNodeSeat[k]:getChildByName("image_infoBg"):getChildByName("text_coin")
                money:setString(vec[6])
                self.m_Seatcoin[k] = vec[6]
            end
        end   
    end
end
-- 更新自己信息
function GameViewLayer:initMyinfo()
    self.m_pmyName:setString(GlobalUserItem.tabAccountInfo.nickname)
    self.m_pmyMoney:setString(GlobalUserItem.tabAccountInfo.into_money)
end
-- 初始化筹码
function GameViewLayer:initChips()
    self.betListView  = self.m_opBar:getChildByName("Image_10"):getChildByName("listView_betListView")
    self.betListView:setScrollBarEnabled(false)
    self.itemModelBet = self.m_pathUI:getChildByName("panel_itemModelBet")

    for k,v in ipairs(self.chips) do
        local item = self.itemModelBet:clone()
        item:addTo(self.betListView)
        self.Betitem[k] = item
        self.m_pControlButtonJetton[k]  = item:getChildByName("button_btn")
        if v >= 10000 then
            v = tostring(v/10000).."w"
        end
        self.m_pControlButtonJetton[k]:loadTextureNormal( string.format("common/game_common/chip/chip_%s.png",v),ccui.TextureResType.localType)
        self.m_pControlButtonJetton[k]:addClickEventListener(handler(self,function ()
        self:onBetNumClicked(k, true)
        end))
        local sel  = item:getChildByName("image_sel")
        sel:setVisible(false)
        local seq = cc.RotateBy:create(2,360)
        sel:runAction(cc.RepeatForever:create(seq))
        local gray = item:getChildByName("button_gray")
        gray:setVisible(false)
    end
    self.Betitem[1]:getChildByName("image_sel"):setVisible(true)
end
----------------------------------------------------游戏状态--------------------------------------------------

function GameViewLayer:event_GameState(msg)--msg.path
    ExternalFun.playGameBackgroundAudio("Baccarat/sound/bg.mp3")
    BaccaratDataMgr.getInstance():setGameState(msg.step)
    -- 玩家列表
    self.m_btnPlayerNum:setString(#msg.members)
    for k,v in ipairs(msg.members) do
        BaccaratDataMgr.getInstance():setMembers(v)
    end
    -- 路子
    self.m_pathZodics = msg.handpath
    self:initpathzodics()
    self:updateTrendChart()
    -- 桌上玩家
    self.seatuser = {}
    for i = 1,6 do
        self.seatuser[i] = msg.rank8[i][1] -- 桌上玩家
    end 
    self:updataTableMan()
    -- 初始化筹码
    self.chips = msg.chips
    for k,v in ipairs(self.chips) do
        BaccaratDataMgr.getInstance():setJettonScoreByIndex(k,v)
    end  
    BaccaratDataMgr.getInstance().m_eLotteryBaseScore = msg.chips[1]
    self:initChips()
    -- 个人信息
    self:initMyinfo()

    if msg.step == GameView.GameStatus_BET then
        self:initBetView(1)
    elseif msg.step == GameView.GameStatus_END then
        self:initBetView(3)
 
    elseif msg.step == GameView.GameStatus_FREE then
        self:initBetView(2)
    end
end

------------------------------------------------------------下注阶段---------------------------------------------------------------
function GameViewLayer:intoBetMoney(Data)         
    BaccaratDataMgr.getInstance():setGameState(GameView.GameStatus_BET)
    self.TimeCount = Data.timeout
    self:initTimer()
    self:onMsgUpdateGameStatue()
end

---游戏结算--（需要加判断自身玩家是否参与本局游戏）------------------------------------------------
function GameViewLayer:onGameEnd(args)
    print("结算！！！")
    BaccaratDataMgr.getInstance():setGameState(GameView.GameStatus_END)
    for i = 1 ,#args.win_zodic do
        if args.win_zodic[i] == 1 then
            table.insert(self.win_zodic , 1)
        end
        if args.win_zodic[i] == 4 then
            table.insert(self.win_zodic , 2)
        end
        if args.win_zodic[i] == 0 then
            table.insert(self.win_zodic , 3)
        end
        if args.win_zodic[i] == 6 then
            table.insert(self.win_zodic , 4)
        end
        if args.win_zodic[i] == 3 then
            table.insert(self.win_zodic , 5)
        end
    end
    --更新玩家列表
    for k,v in ipairs(BaccaratDataMgr.getInstance():getMembers()) do
        for key,player in ipairs(args.moneys) do
            if v[1] == player[1] then
                v[6] = player[2]
            end
        end
    end
    BaccaratDataMgr.getInstance():setMyResult(args.mywin)
    -- 桌上玩家
--    self.seatuser = {}
    if #args.rank8_wins >= 6 then
        for i = 1,6 do
            self.seatuser[i] = args.rank8_wins[i][1] -- 桌上玩家
        end 
    else
        for i = 1 ,#args.rank8_wins do
            self.seatuser[i] = args.rank8_wins[i][1]
        end
    end
    
    
    --清理计时器
    self:cleanEvent()
    
    self.win_hands = args.win_hands
    BaccaratDataMgr.getInstance():setData(self.win_hands)
    table.insert(self.m_pathZodics,args.win_hands)
    self:initpathzodics()
    
    self:onMsgUpdateGameStatue()
end

--本局游戏结束-------------------------------------------------空闲--------------------------------------
function GameViewLayer:onDeskOver(args)
    print("空闲！！！")
    BaccaratDataMgr.getInstance():setGameState(GameView.GameStatus_FREE)
    self.TimeCount = args
    self:onMsgUpdateGameStatue()
end

function GameViewLayer:otherBetMoney(Data)         --其他人下注

    local numMoney   = Data[1]                        --下注区域
    local otherMoney = Data[2]                        --该区域总钱数
    local heMoney    = Data[4]                        --下注钱数
    local IDMoney    = Data[3]                        --下注id

    print("\nID:\t"..Data[3].."\n在\t"..numMoney.."\t区域下注\t"..heMoney.."\n该区域共\t"..otherMoney)
    local areanum = 0;
    if numMoney == 1 or numMoney == 4 or numMoney == 0 or numMoney == 6 or numMoney == 3 then
        areanum = numMoney == 1 and 1 or numMoney == 4 and 2 or numMoney == 0 and 3 or numMoney == 6 and 4 or numMoney == 3 and 5 or "失败"
    else
        return
    end
    if areanum == "失败" then return end
    self.m_textPoolnum[areanum]:setString(otherMoney)
    self.m_flychipidx = self.m_flychipidx + 1
    if self.m_flychipidx > 2 then self.m_flychipidx = 0 end
    for k,v in  ipairs( self.seatuser ) do
        if v == IDMoney then
            self.m_Seatcoin[k] = self.m_Seatcoin[k] - heMoney
            self.m_pNodeSeat[k]:getChildByName("image_infoBg"):getChildByName("text_coin"):setString(self.m_Seatcoin[k])
            self:playTableUserChipAni(k)
            self:createFlyChipSprite(heMoney,areanum,self.m_tabPos[k],false,k,0.35,true)
            return
        end
    end 
    self:createFlyChipSprite(heMoney,areanum,self.m_otherChipPos,false,false,0.35,true)
end

function GameViewLayer:myBetMoney(Data)            --等待自己下注
    local heMoney     = Data[1]    --下注钱数
    local numMoney    = Data[2]    --下注区域
    local otherMoney  = Data[3]    --该区域总钱数

    local areanum = 0;
    if numMoney == 1 or numMoney == 4 or numMoney == 0 or numMoney == 6 or numMoney == 3 then
        areanum = numMoney == 1 and 1 or numMoney == 4 and 2 or numMoney == 0 and 3 or numMoney == 6 and 4 or numMoney == 3 and 5 or "失败"
    else
        return
    end
    if areanum == "失败" then return end
    self.m_textSelfnum[areanum]:setVisible(true)
    self.m_textPoolnum[areanum]:setString(otherMoney)   
    self.m_myBetMoney[areanum] = self.m_myBetMoney[areanum] + heMoney
    BaccaratDataMgr.getInstance():setPlayScore(areanum,self.m_myBetMoney[areanum])
    self.m_textSelfnum[areanum]:setString(self.m_myBetMoney[areanum])   
    self.m_mymoney = self.m_mymoney - heMoney
    self.m_pmyMoney:setString(self.m_mymoney)
    self.m_flychipidx = self.m_flychipidx + 1
    if self.m_flychipidx > 2 then self.m_flychipidx = 0 end
    self:createFlyChipSprite(heMoney,areanum,self.m_pmyCoin,true,false,0.35,true)
end
--更新自身icon，昵称等信息
function GameViewLayer:updataPlayerPanpel(player_,plyertype)
    if plyertype then
        if player_[1] == GlobalUserItem.tabAccountInfo.userid then
            return
        end
        local isHavePlayer = false
        for key, player in ipairs(BaccaratDataMgr.getInstance():getMembers()) do
            if player[1] == player_[1] then
                isHavePlayer = true
            end
        end
        local remeber = {};
        remeber = player_
--        table.insert(remeber,4,0)
        if isHavePlayer == false then
            BaccaratDataMgr.getInstance():setMembers(remeber)
            self.m_btnPlayerNum:setString(BaccaratDataMgr.getInstance():getMembersSize())
        end
    else
        for key, player in ipairs(BaccaratDataMgr.getInstance():getMembers()) do
            if player[1] == player_ then
                table.remove(BaccaratDataMgr.getInstance():getMembers(),key)
                self.m_btnPlayerNum:setString(BaccaratDataMgr.getInstance():getMembersSize())
            end
        end
    end
    
end

--更新自己金钱
function GameViewLayer:updataMyMoney(args)
    self.m_pmyMoney:setString(self:getIntValue(args))
    PlayerInfo.getInstance():setUserScore(self:getIntValue(args))
end

--金币不足
function GameViewLayer:Badbetmoney(dataBuffer)
    if     dataBuffer == 0 then self:showFloatmessage("到庄家上限！")
    elseif dataBuffer == 1 then self:showFloatmessage("到达玩家上限！")
    elseif dataBuffer == 2 then self:showFloatmessage("钱不够了！")
    elseif dataBuffer == 3 then self:showFloatmessage("到达盘面上限！")
    else self:showFloatmessage("下注失败")
    end
end

------------------------------------------------------------------------------------------------------------------------------------
--游戏状态切换
function GameViewLayer:onMsgUpdateGameStatue()
    local status = BaccaratDataMgr.getInstance():getGameState()
    if status == BaccaratDataMgr.eType_Wait then
        print("空闲时间..........................")
        self:clear()
        self:resetChipPos()
        self:initBetView(2)
        self:resetCard()
    elseif status == BaccaratDataMgr.eType_Bet then
        print("投注时间..........................")
        self:updateJettonState()
        self:initStarAndEnd(BET_STAR)
        self:initBetView(1)

    elseif status == BaccaratDataMgr.eType_Award then
        print("开奖时间..........................")
        self:updateJettonState()
        self:initStarAndEnd(BET_END)
        self:initBetView(3)
        self:OpenCard()
    end
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
    local scale = FlyChipScale
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
                ExternalFun.playGameEffect("Baccarat/sound/throw_chips.mp3")
            else
                ExternalFun.playGameEffect("Baccarat/sound/throw_chip.mp3")
            end
            -- 尽量避免重复播放
            self:doSomethingLater(function() self.m_isPlayBetSound  = false end, math.random(2,4)/10)
            self.m_isPlayBetSound = true
        end
    end

    local seq = cc.Sequence:create(cc.Hide:create(), cc.DelayTime:create( Value ),cc.Show:create(), cc.CallFunc:create(func), eMove)
    pSpr:runAction(seq)

end
-- 飞筹码
function GameViewLayer:FlyChip()

    local winArea = {
            [1] = false,
            [2] = false,
            [3] = false,
            [4] = false,
            [5] = false,
    }
    for i = 1 , #self.win_zodic do
        winArea[self.win_zodic[i]] = true
    end
    
--    winArea[1] = 1  == self.win_zodic[1] -- 红方赢
--    winArea[2] = 1  == self.win_zodic[2] -- 黑方赢
--    winArea[3] = -1 ~= self.win_zodic[3]

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
    for i = 1, CHIP_ITEM_COUNT do
        bankerwinvec[i] = {}
        bankerlostvec[i] = {}
        selfwinvec[i] = {}
        otherwinvec[i] = {}
        selfvec[i] = {winmark = winArea[i], vec = {}}
        othervec[i] = {winmark = winArea[i], vec = {}}
    end

    for i = 1, CHIP_ITEM_COUNT do
        for k, v in pairs(self.m_betChipSpSelf[i]) do
             table.insert(selfvec[v.wChipIndex].vec, v)
        end

        for k, v in pairs(self.m_betChipSpOthers[i]) do
            table.insert(othervec[v.wChipIndex].vec, v)
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
--                                ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_GETGOLD)
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
                                ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_GETGOLD)
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
                                ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_GETGOLD)
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
    selfcurscore = BaccaratDataMgr.getInstance():getMyResult()
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
        curpath = selfcurscore < 0 and BaccaratRes.FNT_RESULT_LOSE or BaccaratRes.FNT_RESULT_WIN
        self:flyNumOfGoldChange(posSelf, curpath, str)    
    end

    --自己金币变化动画
    if selfcurscore > 0 then
        ExternalFun.playGameEffect("Baccarat/sound/win_bet.mp3")
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
                :addTo(self.m_pPanelPlayers,1000)

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
-- 还原牌面
function GameViewLayer:resetCard()
    self.m_ImagedealCards:setVisible(false)
    for i = 1,3 do
        self.img_xianCard[i]:setVisible(false)
        self.img_xianCardBg[i]:setVisible(false)

        self.img_zhuangCard[i]:setVisible(false)
        self.img_zhuangCardBg[i]:setVisible(false)
    end
    self.m_resultType :setVisible(false)

    self.m_ImagedealCards:getChildByName("image_resultZhuang"):getChildByName("Image_11"):getChildByName("image_resultZhuangDian"):loadTexture( string.format(BaccaratRes.vecResult.ZHUANG,0))
    self.m_ImagedealCards:getChildByName("image_resultXian"):getChildByName("Image_11"):getChildByName("image_resultXianDian"):loadTexture( string.format(BaccaratRes.vecResult.XIAN,0))

end
--开牌动画
function GameViewLayer:OpenCard()
    self.m_ImagedealCards:setVisible(true)
   
    local i = 1;
    self:OpenCardLoop(i,true)
end
--循环开牌逻辑
function GameViewLayer:OpenCardLoop(i, bPlayEffect)
    if bPlayEffect == false then
        if 3 == i then -- 左边开牌完成 显示左侧牌型动画
--            self:playCardTypeSound(self.m_cards[2][2]) -- 播放黑方牌型声音
--            self:showHongORHeiPX(false)
--            self:showWinResult()
            if #self.win_hands[1] == 3 then
                self:OpenCardLoop(4,true)
            elseif  #self.win_hands[2] == 3 then
                self:OpenCardLoop(4,false)
            else
                self:showresultType()
            end
            return
        end
        if 4 == i then
--            self.img_zhuangCardBg[3]:setVisible(true)
            self.img_zhuangCard[3]:loadTexture(BaccaratRes.IMG_CARDS[self.win_hands[2][3]])
            local orbit = cc.OrbitCamera:create(0.15, 1, 0, 0, 90, 0, 0)
            local callFun1 = cc.CallFunc:create(function() self.img_zhuangCardBg[3]:setVisible(false)  self.img_zhuangCard[3]:setVisible(true)  end)
            local callFun2 = cc.CallFunc:create(function() 
                local ZhuangDian =  self.m_ImagedealCards:getChildByName("image_resultZhuang"):getChildByName("Image_11"):getChildByName("image_resultZhuangDian")
                local num = (self:getCardNum(self.win_hands[2][3]) + self:getCardNum(self.win_hands[2][2]) + self:getCardNum(self.win_hands[2][1])) % 10
                ZhuangDian:loadTexture( string.format(BaccaratRes.vecResult.ZHUANG,num) )
                ExternalFun.playGameEffect( string.format("Baccarat/sound/point_%d.mp3",num))
            end)
            local callFun3 = cc.CallFunc:create(function() self:showresultType()   end)
            self.img_zhuangCardBg[3]:runAction(cc.Sequence:create(cc.DelayTime:create(0.6),cc.CallFunc:create(function() self.img_zhuangCardBg[3]:setVisible(true) ExternalFun.playGameEffect( "Baccarat/sound/show_third_card.mp3") end),orbit,callFun1 ,callFun2,cc.DelayTime:create(0.6),callFun3))
            return
        end
        
        self.img_zhuangCard[i]:loadTexture(BaccaratRes.IMG_CARDS[self.win_hands[2][i]])
        local callFun1 = cc.CallFunc:create(function() self.img_zhuangCardBg[i]:setVisible(false)  self.img_zhuangCard[i]:setVisible(true)  end)
        local callFun3 = cc.CallFunc:create(function() self.img_zhuangCardBg[i]:setVisible(true)  ExternalFun.playGameEffect( "Baccarat/sound/flip_card.mp3")  end)
        local callFun2 = cc.CallFunc:create(function() 
                local ZhuangDian =  self.m_ImagedealCards:getChildByName("image_resultZhuang"):getChildByName("Image_11"):getChildByName("image_resultZhuangDian")
                local num = 0;
                if     i == 1 then  num = self:getCardNum(self.win_hands[2][1])
                elseif i == 2 then  num = (self:getCardNum(self.win_hands[2][2]) + self:getCardNum(self.win_hands[2][1])) % 10
                end
                ZhuangDian:loadTexture( string.format(BaccaratRes.vecResult.ZHUANG,num) )
                ExternalFun.playGameEffect( string.format("Baccarat/sound/point_%d.mp3",num))
                self:OpenCardLoop(i+1,false) 
            end)
        local orbit = cc.OrbitCamera:create(0.15, 1, 0, 270, 90, 0, 0)
        self.img_zhuangCardBg[i]:runAction(cc.Sequence:create(cc.DelayTime:create(0.6),callFun3,orbit,callFun1 ,callFun2))
    end
   
    if bPlayEffect == true then
        if 3 == i then -- 所有牌开牌完成
--            self:playCardTypeSound(self.m_cards[1][2]) -- 播放红方牌型声音
--            self:showHongORHeiPX(true)
            self:OpenCardLoop(1,false)
            return
        end
        if 4 == i then
--            self.img_xianCardBg[3]:setVisible(true)
            self.img_xianCard[3]:loadTexture(BaccaratRes.IMG_CARDS[self.win_hands[1][3]])
            local orbit = cc.OrbitCamera:create(0.15, 1, 0, 0, 90, 0, 0)
            local callFun1 = cc.CallFunc:create(function() self.img_xianCardBg[3]:setVisible(false)  self.img_xianCard[3]:setVisible(true)  end)
            local callFun2 = cc.CallFunc:create(function() 
                    local XianDian   =  self.m_ImagedealCards:getChildByName("image_resultXian"):getChildByName("Image_11"):getChildByName("image_resultXianDian")
                    local num = (self:getCardNum(self.win_hands[1][3]) + self:getCardNum(self.win_hands[1][2]) + self:getCardNum(self.win_hands[1][1])) % 10
                    XianDian:loadTexture( string.format(BaccaratRes.vecResult.XIAN,num) )
                    ExternalFun.playGameEffect( string.format("Baccarat/sound/point_%d.mp3",num))
            end)
            local callFun3 = cc.CallFunc:create(function() 
                    if #self.win_hands[2] == 3 then
                        self:OpenCardLoop(4,false)
                    else
                        self:showresultType()
                    end
               end)
            self.img_xianCardBg[3]:runAction(cc.Sequence:create(cc.DelayTime:create(0.6),cc.CallFunc:create(function() self.img_xianCardBg[3]:setVisible(true) ExternalFun.playGameEffect( "Baccarat/sound/show_third_card.mp3") end),orbit,callFun1 ,callFun2,cc.DelayTime:create(0.6),callFun3))
            return
        end
        
        self.img_xianCard[i]:loadTexture(BaccaratRes.IMG_CARDS[self.win_hands[1][i]])
        local callFun1 = cc.CallFunc:create(function() self.img_xianCardBg[i]:setVisible(false)  self.img_xianCard[i]:setVisible(true)  end)
        local callFun2 = cc.CallFunc:create(function() 
                local XianDian   =  self.m_ImagedealCards:getChildByName("image_resultXian"):getChildByName("Image_11"):getChildByName("image_resultXianDian")
                local num = 0;
                if     i == 1 then  num = self:getCardNum(self.win_hands[1][1])
                elseif i == 2 then  num = (self:getCardNum(self.win_hands[1][2]) + self:getCardNum(self.win_hands[1][1])) % 10
                end
                XianDian:loadTexture( string.format(BaccaratRes.vecResult.XIAN,num) )
                ExternalFun.playGameEffect( string.format("Baccarat/sound/point_%d.mp3",num))
                self:OpenCardLoop(i+1,true) 
            end)
        local callFun3 = cc.CallFunc:create(function() self.img_xianCardBg[i]:setVisible(true) ExternalFun.playGameEffect( "Baccarat/sound/flip_card.mp3")   end)
        local orbit = cc.OrbitCamera:create(0.15, 1, 0, 270, 90, 0, 0)
        self.img_xianCardBg[i]:runAction(cc.Sequence:create(cc.DelayTime:create(0.6),callFun3,orbit,callFun1 ,callFun2))
    end

end
-- 显示结果类型
function GameViewLayer:showresultType()
    self.m_resultType:loadTexture(BaccaratRes.vecResult.TYPE[self.data[#self.data]])
    self.m_resultType:setVisible(true)
    if     self.data[#self.data] == 1 then  ExternalFun.playGameEffect( "Baccarat/sound/player_win.mp3")
    elseif self.data[#self.data] == 2 then  ExternalFun.playGameEffect( "Baccarat/sound/banker_win.mp3")
    elseif self.data[#self.data] == 3 then  ExternalFun.playGameEffect( "Baccarat/sound/tie.mp3")
    end
    self:doSomethingLater(function ()
        local infoLayer = ResoultLayer:create()
        self.m_pathUI:addChild(infoLayer,1001)
    end,1)
    self:doSomethingLater(function ()
        self:updateTrendChart()
        self:initBetView(4)
    end,4)
end
-- 更新游戏状态
function GameViewLayer:initBetView(status)
    local clockState = self.m_ImageBg:getChildByName("Node_1"):getChildByName("image_clockStateTxt"):setVisible(false) 
    self.m_pLbCountTime = self.m_ImageBg:getChildByName("Node_1"):getChildByName("atlas_clockNum"):setVisible(false)

    if status == 1  then
        self.m_pLbCountTime:setVisible(true)
        clockState:setVisible(true)
        clockState:loadTexture(BaccaratRes.spriteState[status])
        self.m_pLbCountTime:setString(self.TimeCount)   
    elseif  status == 2  then    
        clockState:loadTexture(BaccaratRes.spriteState[status])
        clockState:setVisible(true)
    elseif status == 4 then
        self:FlyChip()
        self:updataTableMan()
    end
end
--更新下注筹码按钮状态
function GameViewLayer:updateJettonState()
    -- 设置筹码可用状态
    for i = #self.chips, 1, -1 do
        self.m_pControlButtonJetton[i]:setEnabled(BaccaratDataMgr.getInstance():getJettonEnableState(i))
        if BaccaratDataMgr.getInstance():getJettonEnableState(i) == false then
            self.m_pControlButtonJetton[i]:setColor(cc.c3b(127,127,127))
        else
            self.m_pControlButtonJetton[i]:setColor(cc.c3b(255,255,255))
        end

        if self.nIndexChoose == i then
            self.Betitem[i]:getChildByName("image_sel"):setVisible(true)
        else
            self.Betitem[i]:getChildByName("image_sel"):setVisible(false)
        end
    end
    --计算当前筹码
    local nIndex = 0
    if self.nIndexChoose > 0 then
        if PlayerInfo.getInstance():getUserScore() >= BaccaratDataMgr.getInstance():getScoreByJetton(self.nIndexChoose) then 
            nIndex = self.nIndexChoose
        else
            nIndex = BaccaratDataMgr.getInstance():getJettonSelAdjust()
        end
    else
        -- 初次进入游戏 选择最小
        if PlayerInfo.getInstance():getUserScore() >= BaccaratDataMgr.getInstance():getScoreByJetton(1) then
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
    local score = BaccaratDataMgr.getInstance():getScoreByJetton(self.nIndexChoose)
    BaccaratDataMgr.getInstance():setLotteryBaseScore(score)

end
--region 辅助方法
--region 事件绑定及实现
--注册倒计时
function GameViewLayer:initTimer()
    ExternalFun.playGameEffect()

    self.timerHandle = scheduler.scheduleGlobal(handler(self,self.onMsgCountDown), 1)
    
end
-- 退出清理
function GameViewLayer:cleanEvent() 
    --注销倒计时
    if self.timerHandle then
        scheduler.unscheduleGlobal(self.timerHandle)
    end
end
--倒计时
function GameViewLayer:onMsgCountDown(value)
    --每秒刷新其他玩家数量
--    self:updateOtherNum()

    --游戏状态
    if BaccaratDataMgr.getInstance():getGameState() ~= BaccaratDataMgr.eType_Award then
        --倒计时
        local ts = self.TimeCount
        ts = ts < 1 and 0 or ts - 1
        self.TimeCount = ts
        self.m_pLbCountTime:setString(("%d").format(ts))
        ExternalFun.playGameEffect("Baccarat/sound/countdown.mp3")
    end

end
-- 延时进行
function GameViewLayer:doSomethingLater( call, delay )
    self.m_rootUI:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(call)))
end

--region 辅助方法

-- 重置随机投注点
function GameViewLayer:resetChipPos()
    --self.m_lastflynum = 0
    local offsetVec = {3,3,8,3,8}
    local rowVal = {4, 4, 6, 4, 6}
    local colVal = {6, 6, 15, 6,15}
    for i = 1, 5 do
        self.m_randmChipSelf[i] = {
            idx = 1, -- pos点的索引，原则上按递增方式取点，保证首次最大化铺满区域，然后随机取点
            vec = self:getRandomChipPosVec(self.m_chipAreaRect[i], 40, rowVal[i], colVal[i], offsetVec[i])
        }
        self.m_randmChipOthers[i] = {
            idx = 1,
            vec = self:getRandomChipPosVec(self.m_chipAreaRect[i], 40, rowVal[i], colVal[i], offsetVec[i])
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
--获取筹码图片
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
-- 得到整数部分
function GameViewLayer:getIntValue(num)
    local tt = 0
    num,tt = math.modf(num/1);
    return num
end
-- 提示消息
function GameViewLayer:showFloatmessage(args)
    FloatMessage.getInstance():pushMessageForString(args)
end
-- 空闲清理
function GameViewLayer:clear()
    self.win_zodic = {}
    
    for i = 1, 5 do
        BaccaratDataMgr.getInstance():getPlayScore()[i] = 0
        self.m_myBetMoney[i] = 0
        self.m_betChipSpSelf[i] = {}
        self.m_betChipSpOthers[i] = {}
        self.m_textPoolnum[i]:setString("0")
        self.m_textSelfnum[i]:setVisible(false)
    end
end
--------------------------------------------------------------------------------按钮点击---------------------------------------------------------------------------------------------------------------------
--弹出菜单
function GameViewLayer:onPopClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
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
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
    if self.isOpenMenu == true then
        self.m_pImgMenu:setRotation(90)
        self.m_pPanelMenu:setVisible(false)
        self.m_psettingPanel:runAction(cc.MoveBy:create(0.2,cc.p(-200,0)))
        self.isOpenMenu = false
    end

end

--退出
function GameViewLayer:onReturnClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
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

--其他玩家信息
function GameViewLayer:onOtherInfoClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
    --玩家列表
    local infoLayer = BaccaratOtherInfoLayer:create()
    self.m_pathUI:addChild(infoLayer,1000)
end

--规则
function GameViewLayer:onHelpClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
    local pRule = RuleLayer.create()
    pRule:addTo(self.m_pathUI, 1000)
end
--设置
function GameViewLayer:onSettingClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
    local pSet = SettingLayer.create()
    pSet:addTo(self.m_pathUI,1000)
end
--点击筹码 禁用状态按钮是接受不到点击事件的
function GameViewLayer:onBetNumClicked(nIndex, bPlaySound)
    if nIndex < 1 then return end

    if bPlaySound then
        ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
    end
    self.nIndexChoose = nIndex
    self:updateJettonState()
end
--点击下注区域 进行下注0闲, 1闲对, 2闲天王, 3庄, 4庄对, 5庄天王, 6平, 7同点平
function GameViewLayer:onAnimalClicked(nIndex)
    print(nIndex)
--    if RedVsBlackDataManager.getInstance():isBanker() then
--        FloatMessage.getInstance():pushMessage("RVB_WARN_2")
--        return
--    end

    if BaccaratDataMgr.getInstance():getGameState() ~= GameView.GameStatus_BET then
        FloatMessage.getInstance():pushMessage("未到下注时间！")
        return
    end

    if not nIndex then return end

    if BaccaratDataMgr.getInstance():getLotteryBaseScore() > PlayerInfo.getInstance():getUserScore() then
        FloatMessage.getInstance():pushMessage("钱不够啦！")
        return
    end
    local num = 0
    if     nIndex == 1 then num = 1
    elseif nIndex == 2 then num = 4
    elseif nIndex == 3 then num = 0
    elseif nIndex == 4 then num = 6
    elseif nIndex == 5 then num = 3    
    end
    local _data = {num,BaccaratDataMgr.getInstance():getLotteryBaseScore()}
    self._scene:SendBet(_data)

end
--------------------------------------------------------------------------------按钮点击--------------end----------------------------------------------------------------------------------------------------
--endregion
------------------------------------------------------------------------------------------------------路子------------------------------------------------------------------------------------
-- 获取牌的数据
function GameViewLayer:getCardNum(args)
    local card = args
    local num =  0;
    if                     card <= 8  then num = card + 1
    elseif  card >= 9  and card <= 12 then num = 0
    elseif  card >= 13 and card <= 21 then num = card - 12
    elseif  card >= 22 and card <= 25 then num = 0
    elseif  card >= 26 and card <= 34 then num = card - 25
    elseif  card >= 35 and card <= 38 then num = 0
    elseif  card >= 39 and card <= 47 then num = card - 38
    elseif  card >= 48 and card <= 51 then num = 0
    else    print("错误！！！")
    end
    return num
end
-- 初始化ui
function GameViewLayer:initTrendChart()
    self.zhuPanLu = self.m_ImagebgTrendChart:getChildByName("panel_zhuPanLu")
    self.daLu = self.m_ImagebgTrendChart:getChildByName("panel_daLu")
    self.daYanZaiLu = self.m_ImagebgTrendChart:getChildByName("panel_daYanZaiLu")
    self.xiaoLu = self.m_ImagebgTrendChart:getChildByName("panel_xiaoLu")
    self.yueYouLu = self.m_ImagebgTrendChart:getChildByName("panel_yueYouLu")
    self.imgZWL = {}
    self.imgXWL = {}
    for i = 1, 3 do
        self.imgZWL[i] = self.m_ImagebgTrendChart:getChildByName("node_nodeZWL"):getChildByName("image_imgZWL_"..i)
        self.imgXWL[i] = self.m_ImagebgTrendChart:getChildByName("node_nodeXWL"):getChildByName("image_imgXWL_"..i)
    end
    self.zhuangNum = self.m_ImagebgTrendChart:getChildByName("Image_26"):getChildByName("Node_4"):getChildByName("atlas_zhuangNum")    -- 庄
    self.xianNum = self.m_ImagebgTrendChart:getChildByName("Image_26"):getChildByName("Node_4"):getChildByName("atlas_xianNum")     -- 闲
    self.heNum = self.m_ImagebgTrendChart:getChildByName("Image_26"):getChildByName("Node_4"):getChildByName("atlas_heNum")    -- 和
    self.zhuangDuiNum = self.m_ImagebgTrendChart:getChildByName("Image_26"):getChildByName("Node_4"):getChildByName("atlas_zhuangDuiNum")   -- 庄对子
    self.xianDuiNum = self.m_ImagebgTrendChart:getChildByName("Image_26"):getChildByName("Node_4"):getChildByName("atlas_xianDuiNum")    -- 闲对子
    self.dianNum = self.m_ImagebgTrendChart:getChildByName("Image_26"):getChildByName("Node_4"):getChildByName("atlas_dianNum")     -- 8、9点数目
    self.roundNum = self.m_ImagebgTrendChart:getChildByName("Image_26"):getChildByName("Node_4"):getChildByName("atlas_roundNum")     -- 局数

    self.num = 0
end
-- 初始化数据
function GameViewLayer:initpathzodics()
    self.num = 0
    self.data = {}
    self.zhuangduizi = 0
    self.xianduizi = 0
    for k = 1 , #self.m_pathZodics do
        local a,b,c = self:getResult(self.m_pathZodics[k])
        if     b == true then self.zhuangduizi = self.zhuangduizi + 1
        elseif c == true then self.xianduizi = self.xianduizi + 1
        end
        table.insert(self.data , a)
    end
    self.dataNum = {}
    local a = 1;
    local b = 0;
    local c = 1;
    self.dataNum[a] = {}
    for l = 1, #self.data do
        if l == #self.data then
            self.dataNum[a][c] = self.data[l]
            break
        end

        if self.data[l] == self.data[l + 1]  then
            self.dataNum[a][c] = self.data[l]
            b = a
        else
            self.dataNum[a][c] = self.data[l] 
            a = a + 1
            self.dataNum[a] = {}
        end

        if a == b then
            c = c + 1
        else
            c = 1
        end
    end

end

function GameViewLayer:updateTrendChart()
    
    self:updateZhuPanLu()
    self:updateDaLu()
    self:updateDaYanZaiLu()
    self:updateXiaoLu()
    self:updateYueYouLu()
    self:updateTotal()
--    self:updateWenLu()
end
-- 输赢数据
function GameViewLayer:updateTotal()
    local data = {
            bankercnt = 0,
            playercnt = 0,
            unknowncnt = 0,
    }
    for k,v in ipairs(self.data) do
        if v == 1 then
            data.playercnt = data.playercnt +1
        end
        if v == 2 then
            data.bankercnt = data.bankercnt +1
        end
        if v == 3 then
            data.unknowncnt = data.unknowncnt +1
        end
    end
    self.zhuangNum:setString(data.bankercnt)
    self.xianNum:setString(data.playercnt)
    self.heNum:setString(data.unknowncnt)
    self.zhuangDuiNum:setString(self.zhuangduizi)
    self.xianDuiNum:setString(self.xianduizi)
    self.dianNum:setString(self.num )
    self.roundNum:setString(#self.m_pathZodics)
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
-- 输赢结果
function GameViewLayer:getResult(item)
    local win_result  = 0
    local zhuangduizi = false
    local xianduizi   = false
    local num = {
            [1] = 0,
            [2] = 0,
    };
    for i = 1 , 2 do
        for j = 1 , #item[i] do
            num[i] = num[i] + self:getCardNum(item[i][j])
            if math.abs(item[i][1] - item[i][2]) % 13 == 0  then
                if i == 1 then
                    xianduizi = true
                else 
                    zhuangduizi = true
                end
            end
        end 
    end
    num[1] = num[1] % 10
    num[2] = num[2] % 10
    if num[1] > 8 or num[2] > 8 then
        self.num = self.num + 1
    end
    win_result = num[1] > num[2] and 1 or num[1] == num[2] and 3 or 2 
    return win_result,zhuangduizi,xianduizi
end
-- 主路item
function GameViewLayer:getBaccaratResultItem(item)
    local ani = cc.CSLoader:createNode("Baccarat/BaccaratResultItem.csb")
    local a = ani:getChildByName("image_imgType")
    local b = a:getChildByName("image_imgZhuangDuizi")
    local c = a:getChildByName("image_imgXianDuizi")

    local win_result,zhuangduizi,xianduizi = self:getResult(item)

    if     win_result == 1 then
        a:loadTexture('Baccarat/image/trend_chart/quan_xian.png')
    elseif win_result == 3 then
        a:loadTexture('Baccarat/image/trend_chart/quan_he.png')
    elseif win_result == 2 then
        a:loadTexture('Baccarat/image/trend_chart/quan_zhuang.png')
    end

    if   zhuangduizi == true then
        b:setVisible(true)
    elseif xianduizi == true then
        c:setVisible(true)
    else
        c:setVisible(false)
        b:setVisible(false)
    end
    return ani
end
-- 主路
function GameViewLayer:updateZhuPanLu()
    self.zhuPanLu:removeAllChildren()
    local panelHeight = 230
    local itemWH = 37.6
    local results = self.m_pathZodics
    local total = #results
    local startIdx = overflowIndex(total, 48, 6)
    local lastNode
    for i = startIdx, total do
        local idx = i - startIdx
        local view = self:getBaccaratResultItem(results[i])
        local row = idx % 6
        local column = math.modf(idx / 6)
        view:setPosition((column + 0.5) * itemWH + 5, panelHeight - (row + 0.5) * itemWH)
        self.zhuPanLu:addChild(view)
        lastNode = view
    end
    if lastNode then
        lastNode:runAction(cc.Blink:create(3, 5))
    end
end

function GameViewLayer:updateDaLu()
    self.daLu:removeAllChildren()
    local panelHeight = 112
    local itemWH = 18.1

    local daLu = self.dataNum
    local total = #daLu
    local startIdx = 1
    if 24 < total then
        startIdx = startIdx + total - 24
    end
    local lastNode
    for i = startIdx, total do
        local v = daLu[i]
        local len = table.maxn(v)
        for i2 = 1, len do
            local daLuDataItem = v[i2]
            if daLuDataItem then
                local circleFile = 'Baccarat/image/trend_chart/blue_quan.png'
                if 1 == daLuDataItem then
                    circleFile = 'Baccarat/image/trend_chart/blue_quan.png'
                elseif 2 == daLuDataItem then
                    circleFile = 'Baccarat/image/trend_chart/red_quan.png'
                end
                local img = cc.Sprite:create(circleFile)
                img:setPosition((i - startIdx + 0.5) * itemWH + 5, panelHeight - (i2 - 1 + 0.5) * itemWH - 5)
                self.daLu:addChild(img)
                lastNode = img

                if 3 == daLuDataItem then
                    local text = cc.Label:create()
                    text:setString("和")
                    text:setSystemFontSize(10)
                    text:setTextColor(cc.c4b(28, 181, 6, 255))
                    text:setPosition(9, 9)
                    img:addChild(text)
                end
            end
        end
    end
    if lastNode then
        lastNode:runAction(cc.Blink:create(3, 5))
    end
end

function GameViewLayer:updateDaYanZaiLu()
    self.daYanZaiLu:removeAllChildren()
    local panelHeight = 56
    local itemWH = 9

    local datas = self.dataNum
    local total = #datas
    local startIdx = 1
    if 24 < total then
        startIdx = startIdx + total - 24
    end
    local lastNode
    for i = startIdx, total do
        local v = datas[i]
        local len = table.maxn(v)
        for i2 = 1, len do
            local daLuDataItem = v[i2]
            if daLuDataItem ~= 3 then
                local circleFile = 'Baccarat/image/trend_chart/quan_s_blue.png'
                if 1 == daLuDataItem then
                    circleFile = 'Baccarat/image/trend_chart/quan_s_blue.png'
                elseif 2 == daLuDataItem then
                    circleFile = 'Baccarat/image/trend_chart/red_quan_s.png'
                end
                local img = cc.Sprite:create(circleFile)
                img:setScale(0.5)
                img:setPosition((i - startIdx + 0.5) * itemWH, panelHeight - (i2 - 1 + 0.5) * itemWH)
                self.daYanZaiLu:addChild(img)
                lastNode = img
            else
                local text = cc.Label:create()
                text:setString("和")
                text:setSystemFontSize(9)
                text:setTextColor(cc.c4b(28, 181, 6, 255))
                text:setPosition((i - startIdx + 0.5) * itemWH, panelHeight - (i2 - 1 + 0.5) * itemWH)
                self.daYanZaiLu:addChild(text)
            end
        end
    end
    if lastNode then
        lastNode:runAction(cc.Blink:create(3, 5))
    end
end

function GameViewLayer:updateXiaoLu()
    self.xiaoLu:removeAllChildren()
    local panelHeight = 56
    local itemWH = 9

    local datas = self.dataNum
    local total = #datas
    local startIdx = 1
    if 24 < total then
        startIdx = startIdx + total - 24
    end
    local lastNode
    for i = startIdx, total do
        local v = datas[i]
        local len = table.maxn(v)
        for i2 = 1, len do
            local daLuDataItem = v[i2]
            if daLuDataItem ~= 3 then
                local circleFile = 'Baccarat/image/trend_chart/blue_dian_s.png'
                if 1 == daLuDataItem then
                    circleFile = 'Baccarat/image/trend_chart/blue_dian_s.png'
                elseif 2 == daLuDataItem then
                    circleFile = 'Baccarat/image/trend_chart/red_dian_s.png'
                end
                local img = cc.Sprite:create(circleFile)
                img:setScale(0.5)
                img:setPosition((i - startIdx + 0.5) * itemWH, panelHeight - (i2 - 1 + 0.5) * itemWH)
                self.xiaoLu:addChild(img)
                lastNode = img
            else
                local text = cc.Label:create()
                text:setString("和")
                text:setSystemFontSize(9)
                text:setTextColor(cc.c4b(28, 181, 6, 255))
                text:setPosition((i - startIdx + 0.5) * itemWH, panelHeight - (i2 - 1 + 0.5) * itemWH)
                self.xiaoLu:addChild(text)
            end
        end
    end
    if lastNode then
        lastNode:runAction(cc.Blink:create(3, 5))
    end
end
-- 
function GameViewLayer:updateYueYouLu()
    self.yueYouLu:removeAllChildren()
    local panelHeight = 56
    local itemWH = 9

    local datas = self.dataNum
    local total = #datas
    local startIdx = 1
    if 24 < total then
        startIdx = startIdx + total - 24
    end
    local lastNode
    for i = startIdx, total do
        local v = datas[i]
        local len = table.maxn(v)
        for i2 = 1, len do
            local daLuDataItem = v[i2]
            if daLuDataItem ~= 3 then
                local circleFile = 'Baccarat/image/trend_chart/blue_gang_s.png'
                if 1 == daLuDataItem then
                    circleFile = 'Baccarat/image/trend_chart/blue_gang_s.png'
                elseif 2 == daLuDataItem then
                    circleFile = 'Baccarat/image/trend_chart/red_gang_s.png'
                end
                local img = cc.Sprite:create(circleFile)
                img:setScale(0.5)
                img:setPosition((i - startIdx + 0.5) * itemWH, panelHeight - (i2 - 1 + 0.5) * itemWH)
                self.yueYouLu:addChild(img)
                lastNode = img
            else
                local text = cc.Label:create()
                text:setString("和")
                text:setSystemFontSize(9)
                text:setTextColor(cc.c4b(28, 181, 6, 255))
                text:setPosition((i - startIdx + 0.5) * itemWH, panelHeight - (i2 - 1 + 0.5) * itemWH)
                self.yueYouLu:addChild(text)
            end
        end
    end
    if lastNode then
        lastNode:runAction(cc.Blink:create(3, 5))
    end
end
-- 问路
function GameViewLayer:updateWenLu()
    local BaccaratModel = cc.loaded_packages.BaccaratTigerLogic:getModel()
    local picPath = 'Baccarat/image/trend_chart/'
    local picName
    local zhuangWenLu, xianWenLu = BaccaratModel:getWenLu()
    for i = 1, 3 do
        local img = self.imgZWL[i]
        local wlData = zhuangWenLu[i]
        if wlData then
            picName = nil
            if Role.Player == wlData.role then
                if 1 == i then
                    picName = 'quan_s_blue.png'
                elseif 2 == i then
                    picName = 'blue_dian_s.png'
                else
                    picName = 'blue_gang_s.png'
                end
            elseif Role.Banker == wlData.role then
                if 1 == i then
                    picName = 'red_quan_s.png'
                elseif 2 == i then
                    picName = 'red_dian_s.png'
                else
                    picName = 'red_gang_s.png'
                end
            end
            if picName then
                img:setVisible(true)
                img:loadTexture(picPath .. picName)
            end
        else
            img:setVisible(false)
        end

        img = self['imgXWL_' .. i]
        wlData = xianWenLu[i]
        if wlData then
            picName = nil
            if Role.Player == wlData.role then
                if 1 == i then
                    picName = 'quan_s_blue.png'
                elseif 2 == i then
                    picName = 'blue_dian_s.png'
                else
                    picName = 'blue_gang_s.png'
                end
            elseif Role.Banker == wlData.role then
                if 1 == i then
                    picName = 'red_quan_s.png'
                elseif 2 == i then
                    picName = 'red_dian_s.png'
                else
                    picName = 'red_gang_s.png'
                end
            end
            if picName then
                img:setVisible(true)
                img:loadTexture(picPath .. picName)
            end
        else
            img:setVisible(false)
        end
    end
end

return GameViewLayer