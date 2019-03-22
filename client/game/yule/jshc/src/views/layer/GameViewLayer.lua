--
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
--local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
--local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
--local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local module_pre = "game.yule.jshc.src"
--local cmd = appdf.req(module_pre .. ".models.CMD_Game")
--local Define = appdf.req(module_pre .. ".models.Define")
local OtherInfoLayer = appdf.req(module_pre .. ".views.layer.CarOtherInfoLayer")
--local HeadSprite = require(appdf.EXTERNAL_SRC .. "HeadSprite")
--local CardSprite = appdf.req(module_pre .. ".views.layer.gamecard.CardSprite")
--local CardsNode = appdf.req(module_pre .. ".views.layer.gamecard.CardsNode")
--local GameLogic = appdf.req(module_pre .. ".models.GameLogic")
local RulerLayer = appdf.req(module_pre .. ".views.layer.RulerLayer")
local PlayerInfo = appdf.req(appdf.EXTERNAL_SRC .. "PlayerInfo")
local GameViewLayer = class("GameViewLayer",function(scene)
        local gameViewLayer = display.newLayer()
    return gameViewLayer
end)

--游戏当前状态
GameViewLayer.STATE_LATE_GAME = 0       --等待开始
GameViewLayer.STATE_ONXIAZHU = 1        --闲家下注
GameViewLayer.STATE_OVERXIAZHU = 2      --结束阶段
GameViewLayer.STATE_KONGXIAN = 3        --空闲阶段

local CAR_DOWN_COUNT = 8
local JETTON_ITEM_COUNT = 6

local PATH_UI_CAR     = "game/car/CarUi.csb" -- car UI路径
local FNT_RESULT_WIN  = "game/car/fnts/sz_pdk3.fnt"
local FNT_RESULT_LOSE = "game/car/fnts/sz_pdk4.fnt"
local SOUND_OF_WIN    = "game/car/sound/sound-car-win.mp3"
local SOUND_OF_LOSE   = "game/car/sound/sound-car-lose.mp3"
local SOUND_OF_NOBET  = "game/car/soundpublic/sound-result-nobet.mp3"

local bairenniuniu_dengdaikaiju = "game/car/animation/bairenniuniu_dengdaikaiju/bairenniuniu_dengdaikaiju.ExportJson"
local daojishi_1 = "game/car/animation/daojishi_1/daojishi_1.ExportJson"
local benchibaoma_changjingtexiao = "game/car/animation/benchibaoma_changjingtexiao/benchibaoma_changjingtexiao.ExportJson"
local benchibaomaglow = "game/car/animation/benchibaomaglow/benchibaomaglow.ExportJson"
local benchibaoma_xuanzhong = "game/car/animation/benchibaoma_xuanzhong/benchibaoma_xuanzhong.ExportJson"
local feiqinzoushou_kaijiang = "game/car/animation/feiqinzoushou_kaijiang/feiqinzoushou_kaijiang.ExportJson"

plyer = {}
function GameViewLayer:ctor(scene)
print("on enter -----------===========----------    GameViewLayer")
    --注册node事件
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    ExternalFun.registerNodeEvent(self)
    self._scene = scene

    --托管标志位
    self.isShangZhuang = false
    --进入游戏时当前桌面状态--(false是没有进行游戏，true是有游戏牌局在进行)
    self.gameEnterState = false 
    self.ownerState = nil   --玩家状态标志位
    -- --初始化
    self:initVars()

    -- --加载资源
    -- self:loadResource()

    --初始化界面
    self:initViewLayer()
    
    self:initButton()
    self:initMusic()
end

function GameViewLayer:initVars()
    --ui
    self.m_pRootUI = nil
    self.m_pCarUI = nil
    self.Node_anim = nil
    self.m_pNodeBanker = nil
    self.m_pLbResultGoldUser = nil
    self.m_pLbResultGoldBanker = nil
    self.m_pLbResultGoldPlayer = nil
    self.m_pBtnRule = nil
    self.m_pListViewHistory = nil
    self.m_pZhuangPos = cc.p(0, 0)
    self.m_pQiTaWanJiaPos = cc.p(0, 0)
    self.m_pSelfPos = cc.p(0, 0)
    self.m_pNodeClock = nil
    self.m_pLbCountTime = nil
    self.m_pBtnBank2 = nil
    self.Node_Chip = nil
    self.Node_fly_bank = nil
    self.Node_fly_self = nil
    self.Node_fly_other = nil
    self.Node_FlyChip = nil
    self.Node_Background = nil
    self.m_pLbCountTime1 = nil
    self.m_pLbCountTime2 = nil
    self.m_pSpriteStatus_bet = nil
    self.m_pSpriteStatus_awad = nil
    self.pos_of_history = nil
    self.size_of_history = nil
    self.m_pBtnPushClicked = nil
    self.m_pItemRunNode = nil
    self.m_pBtnRequestToZhuang = nil
    self.m_pBtnCancelToZhuang = nil
    self.m_pLbZhuangNum = nil
    self.m_pLbAmountBet = nil
    self.m_pPlayerFlag = nil
    self.m_pLbUsrNickName = nil
    self.m_pLbUsrGold = nil
    self.m_pBtnBank = nil
    self.m_pNodeBetBtn = nil
    self.m_pBtnContinue = nil
    self.m_pBtnClear = nil
    self.m_pNodeNewMsg = nil
    self.m_pNodeMenu = nil
    self.m_pBtnSound = nil
    self.m_pBtnVoice = nil
    self.m_pBtnMenuPop = nil
    self.m_pBtnMenuPush = nil
    self.m_pBtnClose = nil
    self.m_pNodeTips = nil
    self.m_pLbZhuangName = nil
    self.m_pLbZhuangMoney = nil
    self.m_pNodeMain = nil
    self.m_pBetRemaingNode = nil
    self.m_pButtonAnimal = {}
    self.m_pAllBetNum = {}
    self.m_pMyBetNum = {}
    self.m_pAllBetMask = {}
    self.m_pMyBetMask = {}
    self.m_pControlButtonJetton = {}
    self.m_pSpriteSelect = {}
    self.m_iShowAmount = 0
    self.m_iShowIndex = 0
    self.m_fOpenAniTime = 0
    self.m_tmLastClicked = 0
    self.m_pHistoryTableView = nil
    self.m_nHistorySize = 0
    self.m_bNodeMenuMoving = false
    self.m_UpdateFlyChip = nil
----------------------------------------------------------------------------------
    self.m_members = {}
    self.numList = {}
    self.zhuangList = {}
    self.Tab_XuYa = {}
--    self.m_mybet = {}
    self.daojishi_Num = 0
    self.money = 0
    self.Moneydealer = 0
    self.winzodic = 0
    self.lostPos = 0
    self.ButtonJetton = 1
    self.mywin = 0
    self.dealer_win = 0
    self.moneys = {}
    self.win_zodic = 0
    self.m_llMyBetValue = {0,0,0,0,0,0,0,0}
    self.sp_tab = {{},{},{},{},{},{},{},{},}
    self.isShangZhuang = false
    self.m_money = 0
end

function GameViewLayer:initViewLayer(  )
    ExternalFun.playBackgroudAudio("Game.mp3")
-- csb
    self.m_pRootUI = cc.CSLoader:createNode(PATH_UI_CAR)
    self.m_pRootUI:addTo(self)
    -- root
    self.m_pCarUI = self.m_pRootUI:getChildByName("Panel_root")
    self.m_pCarUI:setPositionX(145 - (1624 - display.size.width) / 2)


    --尝试UI适配
    self:tryLayoutforIphoneX()
    --------------------------------------
    --Node_bg
    self.Node_bg = self.m_pCarUI:getChildByName("Node_bg")
    self.Node_Scene_Anim = self.Node_bg:getChildByName("Node_Scene_Anim")
    --------------------------------------
    --Node_Background
    self.Node_Background = self.m_pCarUI:getChildByName("Node_Background")

    self.Image_center_bg = self.Node_Background:getChildByName("Image_center_bg")
    self.m_pItemRunNode  = self.Node_Background:getChildByName("m_pItemRunNode") 

    ---------------------------------------
    --Node_Left
    self.Node_Left = self.m_pCarUI:getChildByName("Node_Left")

    self.m_pBtnClose       = self.Node_Left:getChildByName("m_pBtnMenuExit")
    
    self.Node_User         = self.Node_Left:getChildByName("Node_User")
    self.m_pLbUsrNickName  = self.Node_User:getChildByName("m_pLbUsrNickName") 
    self.m_pLbUsrGold      = self.Node_User:getChildByName("Node_8"):getChildByName("m_pLbUsrGold") 
    self.m_pBtnBank        = self.Node_User:getChildByName("m_pBtnBank") 

    self.m_pNodeOther      = self.Node_Left:getChildByName("m_pNodeOther")
    self.m_pBtnOtherPlayer = self.m_pNodeOther:getChildByName("m_pBtnOtherPlayer")
    self.m_pLbOtherCount   = self.m_pNodeOther:getChildByName("BitmapFontLabel_1")
    ---------------------------------------
    --Node_Right
    self.Node_Right = self.m_pCarUI:getChildByName("Node_Right")

    self.m_pBtnMenuPop      = self.Node_Right:getChildByName("m_pBtnMenuPop") 
    self.m_pBtnMenuPush     = self.Node_Right:getChildByName("m_pBtnMenuPush")
    self.m_pListViewHistory = self.Node_Right:getChildByName("ListView_History") --历史记录节点

    ---------------------------------------
    --Node_di
    self.Node_di = self.m_pCarUI:getChildByName("Node_di")

    self.m_pBtnContinue = self.Node_di:getChildByName("m_pBtnContinue") 
    self.m_pBtnClear    = self.Node_di:getChildByName("m_pBtnClear") 
    self.m_pNodeBetBtn  = self.Node_di:getChildByName("m_pNodeBetBtn") 

    ---------------------------------------
    --NodeMain
    self.m_pNodeMain = self.m_pCarUI:getChildByName("m_pNodeMain") 

    --庄家节点
    self.m_pNodeBanker         = self.m_pNodeMain:getChildByName("zhuang")

    --庄家信息
    self.Image_Banker          = self.m_pNodeBanker:getChildByName("Image_Banker")
    self.m_pBtnCancelToZhuang  = self.Image_Banker:getChildByName("m_pBtnCancelToZhuang") 
    self.m_pBtnRequestToZhuang = self.Image_Banker:getChildByName("m_pBtnRequestToZhuang")  
    self.m_pLbAmountBet        = self.Image_Banker:getChildByName("m_pLbAmountBet") 
    self.m_pLbZhuangNum        = self.Image_Banker:getChildByName("m_pLbZhuangNum") 
    self.m_pLbZhuangName       = self.Image_Banker:getChildByName("m_pLbZhuangName") 
    self.m_pLbZhuangMoney      = self.Image_Banker:getChildByName("m_pLbZhuangMoney")
    
    --倒计时
    self.Image_clock          = self.m_pNodeBanker:getChildByName("Image_clock")
    self.m_pLbCountTime1      = self.Image_clock:getChildByName("BitmapFontLabel_clock_1")
    self.m_pLbCountTime2      = self.Image_clock:getChildByName("BitmapFontLabel_clock_2")
    self.m_pSpriteStatus_bet  = self.Image_clock:getChildByName("Image_Status_bet")
    self.m_pSpriteStatus_awad = self.Image_clock:getChildByName("Image_Status_awad")
    --下注按钮节点
    self.m_pBetButton         = self.m_pNodeMain:getChildByName("m_pBetButton")
    --飞筹码节点
    self.Node_Chip            = self.m_pNodeMain:getChildByName("Node_chip")
    self.Node_fly_self        = self.m_pNodeMain:getChildByName("Node_fly_self")
    self.Node_fly_bank        = self.m_pNodeMain:getChildByName("Node_fly_bank")
    self.Node_fly_other       = self.m_pNodeMain:getChildByName("Node_fly_other")
    self.Node_FlyChip         = self.m_pNodeMain:getChildByName("Node_FlyChip")
    --投中动画节点
    self.Node_BetAnim         = self.m_pNodeMain:getChildByName("Node_BetAnim")
    --全部筹码数字
    self.m_pAllBetValueNode   = self.m_pNodeMain:getChildByName("m_pAllBetValueNode")
    --自己筹码数字
    self.m_pMyBetValueNode    = self.m_pNodeMain:getChildByName("m_pMyBetValueNode")
    --已投满图片
    self.m_pBetRemaingNode    = self.m_pNodeMain:getChildByName("m_pBetRemaingNode") 
    --提示节点
    self.m_pNodeTips          = self.m_pNodeMain:getChildByName("Node_Tips") 
    --动作节点
    self.Node_anim            = self.m_pNodeMain:getChildByName("Node_anim")
    ---------------------------------------
    --NodeLeft
    self.m_pNodeRightMenu  = self.m_pCarUI:getChildByName("m_pNodeRightMenu") 

    --弹出菜单
    self.m_pNodeMenu       = self.m_pNodeRightMenu:getChildByName("m_pNodeMenu") 

    --弹出按钮
    self.m_pBtnPushClicked = self.m_pNodeMenu:getChildByName("m_pBtnPushClicked")
    self.m_pBtnBank2       = self.m_pNodeMenu:getChildByName("m_pBtnBank2") 
    self.m_pBtnRule        = self.m_pNodeMenu:getChildByName("m_pBtnRule") 
    self.m_pBtnSound       = self.m_pNodeMenu:getChildByName("m_pBtnSound") 
    self.m_pBtnVoice       = self.m_pNodeMenu:getChildByName("m_pBtnVoice") 

    --金币文字
    self.m_pLbResultGoldUser   = self.Node_User:getChildByName("TXT_result_gold_self")
    self.m_pLbResultGoldBanker = self.Image_Banker:getChildByName("TXT_result_gold_banker")
    self.m_pLbResultGoldPlayer = self.m_pNodeOther:getChildByName("TXT_result_gold_other")
    self.m_pLbResultGoldUser:setVisible(false)
    self.m_pLbResultGoldBanker:setVisible(false)
    self.m_pLbResultGoldPlayer:setVisible(false)
    ---------------------------------------
    
    --车标区域
    --todo：32个节点pos
    self.m_pItemRunSprite = {}
    for i = 0, 31 do
        self.m_pItemRunSprite[i] = self.m_pItemRunNode:getChildByTag(i)
    end
    
    --下注区域
    self.m_pNodeWinAnim = {}
    self.m_pSpRemaining = {}
    for i = 1, CAR_DOWN_COUNT do
        self.m_pButtonAnimal[i] = self.m_pBetButton:getChildByName("m_pButtonAnimal"..(i-1))
        self.m_pAllBetNum[i] = self.m_pAllBetValueNode:getChildByName("m_pAllBetNum_"..(i-1))
        self.m_pMyBetNum[i] = self.m_pMyBetValueNode:getChildByName("m_pMyBetNum_"..(i-1))
        self.m_pSpRemaining[i] = self.m_pBetRemaingNode:getChildByName("Image_"..(i-1)):setVisible(false)

        self.m_pNodeWinAnim[i] = self.Node_BetAnim:getChildByName("Node_"..(i-1))

--        self.m_pAllBetMask[i] =  self.m_pNodeMain:getChildByName("m_pBetMaskNode"):getChildByName(string.format("Image_%d_1" , i-1))
--        self.m_pMyBetMask[i] =  self.m_pNodeMain:getChildByName("m_pBetMaskNode"):getChildByName(string.format("Image_%d_2" , i-1))
    end

    --筹码区域
    for i = 1, JETTON_ITEM_COUNT do
        self.m_pControlButtonJetton[i] = self.m_pNodeBetBtn:getChildByName("m_pControlButtonJetton"..(i-1)) 
    end
    self.m_pControlButtonJetton[6]:setVisible(false)
    --弹出菜单
    self.m_pNodeMenu:setPosition(1334, 750 + 250)
    self.m_pNodeMenu:setVisible(false)
    self.m_pBtnMenuPop:setVisible(true)
    self.m_pBtnMenuPush:setVisible(false)

    --动画节点
    self.Node_anim:setLocalZOrder(999)

    --更换成tableview
    self.pos_of_history = cc.p(self.m_pListViewHistory:getPosition())
    self.size_of_history = self.m_pListViewHistory:getContentSize()
    self.m_pListViewHistory:removeFromParent()


    self.m_pLbCountTime1:setString("0")
    self.m_pLbCountTime2:setString("0")

    self.m_pSpriteStatus_awad:setVisible(true)
    self.m_pSpriteStatus_bet:setVisible(false)
    self.m_pBtnBank:setVisible(false)
    self.m_pBtnBank2:setColor(cc.c3b(127,127,127))
    self.m_pBtnBank2:setEnabled(false)
    --场景特效
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(benchibaoma_changjingtexiao)  
    local armature = ccs.Armature:create("benchibaoma_changjingtexiao")  
    armature:setPosition(667,375)          
    self.m_pCarUI:addChild(armature)
    armature:getAnimation():playWithIndex(0)
end

function GameViewLayer:tryLayoutforIphoneX()

--    if LuaUtils.isIphoneXDesignResolution() then

--        --左
--        self:setDeltaPosition2(self.Node_Left, -70, 0)

--        --下方
--        self:setDeltaPosition2(self.Node_di, -70, 0)

--        --右
--        self:setDeltaPosition2(self.Node_Right, 40, 0)

--        self:setDeltaPosition2(self.Node_fly_other, -70, 0)
--        self:setDeltaPosition2(self.Node_fly_self, -70, 0)
--        self:setDeltaPosition2(self.m_pNodeMenu, 40, 0)
--    end
end

function GameViewLayer:setDeltaPosition2(node, x, y)
    local posx, posy = node:getPosition()
    node:setPosition(posx + x, posy + y)
end
function GameViewLayer:initButton()
    for i = 1, JETTON_ITEM_COUNT do --筹码
        self.m_pControlButtonJetton[i]:addTouchEventListener(handler(self, self.onBetNumClicked))
    end
    for i = 1, CAR_DOWN_COUNT do --下注
        self.m_pButtonAnimal[i]:addTouchEventListener(handler(self, self.onAnimalClicked))
    end
    self.m_pBtnContinue:addTouchEventListener(handler(self, self.onBetContinueClicked))         --续投
    self.m_pBtnClear:addTouchEventListener(handler(self, self.onBetClearClicked))               --清理
    self.m_pBtnRequestToZhuang:addTouchEventListener(handler(self, self.onRequestBankerClicked))--上庄
    self.m_pBtnCancelToZhuang:addTouchEventListener(handler(self, self.onCancelBankerClicked))  --下庄
    self.m_pBtnRule:addTouchEventListener(handler(self, self.onRuleClicked))          --规则
    self.m_pBtnOtherPlayer:addTouchEventListener(handler(self, self.onPlayerClicked)) --玩家
    self.m_pBtnBank:addTouchEventListener(handler(self, self.onGoBankClicked))        --银行
    self.m_pBtnMenuPop:addTouchEventListener(handler(self, self.onPopClicked))        --弹出
    self.m_pBtnMenuPush:addTouchEventListener(handler(self, self.onPushClicked))      --收回
    self.m_pBtnPushClicked:addTouchEventListener(handler(self, self.onPushClicked))   --收回
    self.m_pBtnSound:addTouchEventListener(handler(self, self.onSoundClicked))        --音效
    self.m_pBtnVoice:addTouchEventListener(handler(self, self.onMusicClicked))        --音乐
    self.m_pBtnBank2:addTouchEventListener(handler(self, self.onGoBankClicked))       --银行
    self.m_pBtnClose:addTouchEventListener(handler(self, self.onCloseClicked))        --关闭
end


function GameViewLayer:onAnimalClicked(sender, eventType)     -- 下注
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    for i = 1,CAR_DOWN_COUNT do
        if sender == self.m_pButtonAnimal[i] then
            local bet_tag = 0
            if i == 1 then bet_tag = 0
            elseif i == 2 then bet_tag = 2
            elseif i == 3 then bet_tag = 4
            elseif i == 4 then bet_tag = 6
            elseif i == 5 then bet_tag = 1
            elseif i == 6 then bet_tag = 3
            elseif i == 7 then bet_tag = 5
            elseif i == 8 then bet_tag = 7
            end
            self._scene:SendBet({bet_tag,self.ButtonJetton})
            table.insert(self.Tab_XuYa,{bet_tag,self.ButtonJetton})  
        end     
    end
end

function GameViewLayer:onBetNumClicked(sender, eventType)     -- 筹码
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    for i = 1 ,JETTON_ITEM_COUNT do
        if sender == self.m_pControlButtonJetton[i] then
            self.m_pControlButtonJetton[i]:setScale(1.1,1.1)
            self.ButtonJetton = self.chips[i]
        else
            self.m_pControlButtonJetton[i]:setScale(1,1)
        end
    end
end

function GameViewLayer:onBetContinueClicked(sender, eventType)   -- 续投
    if eventType ~= ccui.TouchEventType.ended then    
        return
    end
    ExternalFun.playClickEffect()
    if(self:isDelayHandleEvent())then
            FloatMessage.getInstance():pushMessageForString("请勿频繁点击！");
        return;
    end
    local index = 1   
    self._XuyaFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                if self.Tab_XuYa[index] ~= nil then
                    self._scene:SendBet(self.Tab_XuYa[index])
                else
                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._XuyaFun)  
                end 
                index = index+1               
            end, 0.2, false)
end

function GameViewLayer:onBetClearClicked(sender, eventType)      -- 清理
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
end

function GameViewLayer:onRequestBankerClicked(sender, eventType)      -- 上庄
    if eventType ~= ccui.TouchEventType.ended then  
        return
    end
    if(self:isDelayHandleEvent())then
            FloatMessage.getInstance():pushMessageForString("请勿频繁点击！");
        return;
    end
    self._scene:SendUpdearler()
end

function GameViewLayer:onCancelBankerClicked(sender, eventType)      -- 下庄
    if eventType ~= ccui.TouchEventType.ended then    
        return
    end
    self._scene:SendDowndealer()
end

function GameViewLayer:onRuleClicked(sender, eventType)      -- 规则
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    local layer = RulerLayer:new()
    layer:addTo(self.m_pRootUI , 999)
end

function GameViewLayer:onPlayerClicked(sender, eventType)      -- 玩家
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    ExternalFun.playClickEffect()
    --玩家列表
    local infoLayer = OtherInfoLayer:create()
    infoLayer:setPositionX(-145)
    self.m_pCarUI:addChild(infoLayer,999)
end
function GameViewLayer:onPopClicked(sender, eventType)      -- 弹出
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

        if self.m_bNodeMenuMoving then
        return
    end
    self.m_bNodeMenuMoving = true

    ExternalFun.playClickEffect()

    self.m_pNodeMenu:stopAllActions()
    self.m_pNodeMenu:setPositionY(750 + 250)
    self.m_pNodeMenu:setOpacity(0)
    self.m_pNodeMenu:setVisible(true)

    local move = cc.EaseBackOut:create(cc.MoveBy:create(0.3, cc.p(0, -250)))
    local fade = cc.FadeIn:create(0.3)
    local sp = cc.Spawn:create(move, fade)
    local call = cc.CallFunc:create(function()
        self.m_pBtnMenuPop:setVisible(false)
        self.m_pBtnMenuPush:setVisible(true)
        self.m_bNodeMenuMoving = false
    end)
    local seq = cc.Sequence:create(sp, call)
    self.m_pNodeMenu:runAction(seq)
end
function GameViewLayer:onGoBankClicked(sender, eventType)      -- 银行
    if eventType ~= ccui.TouchEventType.ended then
        return
    end      
    SLFacade:dispatchCustomEvent(Hall_Events.SHOW_OPEN_BANK,"openbank")
end
function GameViewLayer:onPushClicked(sender, eventType)      -- 收回
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    if self.m_bNodeMenuMoving then
        return
    end
    self.m_bNodeMenuMoving = true

    ExternalFun.playClickEffect()

    local move = cc.EaseBackIn:create(cc.MoveBy:create(0.3, cc.p(0, 250)))
    local fade = cc.FadeOut:create(0.3)
    local sp = cc.Spawn:create(move, fade)
    local call = cc.CallFunc:create(function()
        self.m_pNodeMenu:setVisible(false)
        self.m_pBtnMenuPop:setVisible(true)
        self.m_pBtnMenuPush:setVisible(false)
        self.m_bNodeMenuMoving = false
    end)
    local seq = cc.Sequence:create(sp, call)
    self.m_pNodeMenu:stopAllActions()
    self.m_pNodeMenu:setPositionY(750)
    self.m_pNodeMenu:runAction(seq)
end
function GameViewLayer:initMusic()
    if (GlobalUserItem.bSoundAble)then -- 音效开着       
        GlobalUserItem.setSoundAble(true)
        self.m_pBtnSound:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinxiao.png"),ccui.TextureResType.plistType);
    else
        GlobalUserItem.setSoundAble(false)
        self.m_pBtnSound:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinxiaoguan.png"),ccui.TextureResType.plistType);
    end
    if (GlobalUserItem.bVoiceAble)then -- 音乐开着 
        GlobalUserItem.setVoiceAble(true)
        self.m_pBtnVoice:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinyue.png"),ccui.TextureResType.plistType);
    else
        GlobalUserItem.setVoiceAble(false)
        self.m_pBtnVoice:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinyueguan.png"),ccui.TextureResType.plistType);
    end
end
function GameViewLayer:onSoundClicked(sender, eventType)      -- 音效
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    if (GlobalUserItem.bSoundAble)then -- 音效开着
        GlobalUserItem.setSoundAble(false)
        self.m_pBtnSound:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinxiaoguan.png"),ccui.TextureResType.plistType);
    else
        GlobalUserItem.setSoundAble(true)
        self.m_pBtnSound:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinxiao.png"),ccui.TextureResType.plistType);
    end
end
function GameViewLayer:onMusicClicked(sender, eventType)      -- 音乐
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
     ExternalFun.playClickEffect()

    if (GlobalUserItem.bVoiceAble)then -- 音乐开着 
        GlobalUserItem.setVoiceAble(false)
        self.m_pBtnVoice:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinyueguan.png"),ccui.TextureResType.plistType);
    else
        GlobalUserItem.setVoiceAble(true)
        self.m_pBtnVoice:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinyue.png"),ccui.TextureResType.plistType);
    end
end
function GameViewLayer:onCloseClicked(sender, eventType)      -- 关闭
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    ExternalFun.playClickEffect()
--    我上庄家，且有人下注
--    有投注纪录
    self._scene:onQueryExitGame()
end

----------------------------------------------------------初始化界面及button------------------------------------------------------------
function GameViewLayer:initGameData_And_View(bufferData)--{[1]=1 [2]=5 [3]=10 [4]=30 [5]=50 [6]=500 }
    print("Go!")
    -- 转圈圈
    local opacity = {255, 205, 155, 105, 55, 20};
    for i = 1, JETTON_ITEM_COUNT do
        self.m_pSpriteSelect[i] = cc.Sprite:createWithSpriteFrameName(self:getRealFrameName("car-big-bg-light.png"));
        self.m_pSpriteSelect[i]:setPosition(cc.p(0,0))
        self.m_pSpriteSelect[i]:setVisible(false)
        self.m_pSpriteSelect[i]:setOpacity(opacity[i])
        self.m_pSpriteSelect[i]:addTo(self.m_pItemRunNode)
    end
    self.chips = {1,5,10,20,50,100}
--    self.chips = bufferData.chips
--    table.insert(self.chips,500)
    self.m_money = GlobalUserItem.tabAccountInfo.into_money
    --将所有玩家信息存入
    for k, v in ipairs(bufferData.members) do
        table.insert(self.m_members,v)
        table.insert(plyer,v)
    end
    self.numList = bufferData.path
    self:PaixingList()
    for k, v in ipairs(bufferData.members) do
        if v[1] == bufferData.dealer then
        self.m_pLbZhuangMoney:setString(v[6]):setScale(0.8)
        self.m_pLbZhuangName:setString(v[2])
        self.Moneydealer = v[6]
        end
    end

    for k, v in ipairs(bufferData.dealers) do
        table.insert(self.zhuangList,v)
    end
    local numdealer = #bufferData.dealers
    self.m_pLbZhuangNum:setString("申请人数："..numdealer)
    self.m_pLbOtherCount:setString("("..#bufferData.members..")")
    self.m_pControlButtonJetton[1]:setScale(1.1,1.1)
    self.m_pLbAmountBet:setString(bufferData.pot)

--    self.Node_FlyChip:removeAllChildren()
    self.Node_FlyChip:setVisible(false)
    self.step = bufferData.step
    if self.step == GameViewLayer.STATE_LATE_GAME then
        print("等待开始")
--        local timeout = self:getIntValue( bufferData.timeout )
--        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(bairenniuniu_dengdaikaiju)  
--        local armature = ccs.Armature:create("bairenniuniu_dengdaikaiju")  
--        armature:setPosition(667,375)          
--        self.m_pCarUI:addChild(armature)
--        armature:getAnimation():playWithIndex(0)
--        armature:runAction(cc.Sequence:create(cc.DelayTime:create(timeout),cc.CallFunc:create(function()
--		                                            armature:removeFromParent()
--	                                            end)))
        for i=1,CAR_DOWN_COUNT do
            self.m_pAllBetNum[i]:setText(bufferData.betmoneys[i]):setVisible(false)
            self.m_pMyBetNum[i]:setText(bufferData.mybetmoneys[i]):setVisible(false)
        end
        self.desk = GameViewLayer.STATE_LATE_GAME
    elseif self.step == GameViewLayer.STATE_ONXIAZHU then
        print("闲家下注")
        if bufferData.mymoney < 500  then
        self:BtnBetChip(6,false)
        end
        if bufferData.mymoney < 100  then
        self:BtnBetChip(5,false)
        end
        if bufferData.mymoney < 50  then
        self:BtnBetChip(4,false)
        end
        if bufferData.mymoney < 20  then
        self:BtnBetChip(3,false)
        end
        if bufferData.mymoney < 5  then
        self:BtnBetChip(2,false)
        end
        if bufferData.mymoney < 1  then
        self:BtnBetChip(1,false)
        end
        self.m_pSpriteStatus_awad:setVisible(false)
        self.m_pSpriteStatus_bet:setVisible(true)
        self.desk = GameViewLayer.STATE_ONXIAZHU
        local betmoney = bufferData.betmoneys
        for i=1,CAR_DOWN_COUNT do
            self.m_pAllBetNum[i]:setText(betmoney[i]):setVisible(true)
            self.m_pMyBetNum[i]:setText(bufferData.mybetmoneys[i]):setVisible(false)
        end
    elseif self.step == GameViewLayer.STATE_OVERXIAZHU then
        print("结束阶段")
        --钱与筹码
        for i = 1, JETTON_ITEM_COUNT do --筹码
            self:BtnBetChip(i,false)
        end

        --状态图片
        self.m_pSpriteStatus_awad:setVisible(true)
        self.m_pSpriteStatus_bet:setVisible(false)
        self.desk = GameViewLayer.STATE_OVERXIAZHU
        --
        local timeout = self:getIntValue( bufferData.timeout )
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(bairenniuniu_dengdaikaiju)  
        local armature = ccs.Armature:create("bairenniuniu_dengdaikaiju")  
        armature:setPosition(667,375)          
        self.m_pCarUI:addChild(armature)
        armature:getAnimation():playWithIndex(0)
        armature:runAction(cc.Sequence:create(cc.DelayTime:create(timeout),cc.CallFunc:create(function()
		                                            armature:removeFromParent()
	                                            end)))
        --
        local betmoney = bufferData.betmoneys
        for i=1,CAR_DOWN_COUNT do
            self.m_pAllBetNum[i]:setText(betmoney[i]):setVisible(true)
            self.m_pMyBetNum[i]:setText(bufferData.mybetmoneys[i]):setVisible(false)
        end

    elseif self.step == GameViewLayer.STATE_KONGXIAN then
        print("空闲阶段")
        self.desk = GameViewLayer.STATE_KONGXIAN
        self:clearn()
    end

    --文字倒计时
    self.daojishi_Num = bufferData.timeout
    local strCount2 = string.format("%d", math.modf(self.daojishi_Num/1) % 10)
    if self.daojishi_Num<10 then
        self.m_pLbCountTime1:setString("0")
    elseif self.daojishi_Num>=10 and self.daojishi_Num<20 then
        self.m_pLbCountTime1:setString("1")
    else
        self.m_pLbCountTime1:setString("2")
    end
    self.m_pLbCountTime2:setString(strCount2)
    --    --时间调度，更新桌面中间倒计时
    local this = self
    self._ClockFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                this:OnClockUpdata()
            end, 1, false)
end

--更新自身icon，昵称等信息
function GameViewLayer:updataPlayerPanpel(player_)
    local isHavePlayer = false
    for key, player in ipairs(self.m_members) do
        if player[1] == player_[1] then
            isHavePlayer = true
        end
    end
    if isHavePlayer == false then
        table.insert(self.m_members,player_)
        table.insert(plyer,player_)
        self.m_pLbOtherCount:setString("("..#self.m_members..")")
    end
    if player_[1] == GlobalUserItem.tabAccountInfo.userid then
        --设置玩家金币数
        local money_num = player_[6]
        self.m_pLbUsrGold:setString(tostring(money_num))
        local place_where = player_[2]
        self.m_pLbUsrNickName:setString(tostring(place_where))
    end
end

------------------------------------------------------------下注阶段---------------------------------------------------------------
function GameViewLayer:intoBetMoney(Data)        
    ExternalFun.playGameEffect("game/car/soundpublic/sound-start-wager.mp3")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(feiqinzoushou_kaijiang) 
    local armature = ccs.Armature:create("feiqinzoushou_kaijiang")  
    armature:setPosition(667,375)                   
    self.m_pCarUI:addChild(armature)                      
    armature:getAnimation():playWithIndex(1)
    armature:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(function()
		                                            armature:removeFromParent()
	                                            end)))
    self.m_pSpriteStatus_awad:setVisible(false)
    self.m_pSpriteStatus_bet:setVisible(true)

    self.desk = GameViewLayer.STATE_ONXIAZHU
    self.daojishi_Num = self:getIntValue(Data.timeout)

    if self.isShangZhuang == false then
        for i = 1, JETTON_ITEM_COUNT do --筹码
            self:BtnBetChip(i,true)
        end
    end
    
end

function GameViewLayer:BtnBetChip(index ,istype)
    self.m_pControlButtonJetton[index]:setBright(istype)
    self.m_pControlButtonJetton[index]:setTouchEnabled(istype)
    if istype == true then
        self.m_pControlButtonJetton[index]:setColor(cc.c3b(255,255,255))
    else
        self.m_pControlButtonJetton[index]:setColor(cc.c3b(127,127,127))
    end
end
-- 以往的牌型列表
function GameViewLayer:PaixingList()
    self.m_nHistorySize = self.m_historyNum
    if self.m_pHistoryTableView then
        self.m_pHistoryTableView:reloadData()
    else
        self:initTableView()
    end
    
    if self.m_historyNum < 7 then
        local offset = (7 - self.m_nHistorySize) * 65
        self.m_pHistoryTableView:setContentOffset(cc.p(0, offset))
    else
        self.m_pHistoryTableView:setContentOffset(cc.p(0, 0))
    end

end

function GameViewLayer:initTableView()

    local function initTableViewCell(cell, idx)
        if idx < 0 then
            return
        end
        local scale = { 0.35, 0.3, 0.35, 0.3, 0.35, 0.3, 0.35, 0.3, }
        local needPicIndex = { 0, 0, 1, 1, 2, 2, 3, 3, }
        local value = self.numList[idx+1]
        local strBig = string.format("car-%d-4.png", needPicIndex[value+1])
        local strSmall = string.format("car-%d-23.png", needPicIndex[value+1])
        local strIcon = scale[value+1] == 0.35 and strBig or strSmall
        local strPath = self:getRealFrameName(strIcon)
        local spIcon = cc.Sprite:createWithSpriteFrameName(strPath)
        spIcon:setPosition(self.size_of_history.width / 2, 33)
        spIcon:addTo(cell)

        --最新标记
        if idx == self.m_historyNum - 1 then
            local spNew = cc.Sprite:createWithSpriteFrameName(self:getRealFrameName("car-history-new2.png"))
            spNew:setPosition(self.size_of_history.width / 2, 35)
            spNew:addTo(cell)

            local spZi = cc.Sprite:createWithSpriteFrameName(self:getRealFrameName("car-history-new1.png"))
            spZi:setPosition(self.size_of_history.width - 10, 58)
            spZi:addTo(cell)
        end
    end
    local function tableCellTouched(table, cell)
        --printf("%d \n", cell:getIdx())
    end
    local function tableCellAtIndex(table, idx)
        local cell = table:cellAtIndex(idx)
        if not cell then
            cell = cc.TableViewCell:new()
        else
            cell:removeAllChildren()
        end
        initTableViewCell(cell, idx)
        return cell
    end
    local function cellSizeForTable(table, idx)
        return self.size_of_history.width, 65
    end
    local function numberOfCellsInTableView(table)
        self.m_historyNum = #self.numList
        return self.m_historyNum
    end
    
    if not self.m_pHistoryTableView then
        self.m_pHistoryTableView = cc.TableView:create(self.size_of_history)
--        self.m_pHistoryTableView:setIgnoreAnchorPointForPosition(false)
        self.m_pHistoryTableView:setAnchorPoint(cc.p(0,0))
        self.m_pHistoryTableView:setContentSize(self.size_of_history)
        self.m_pHistoryTableView:setPosition(self.pos_of_history)
        self.m_pHistoryTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        self.m_pHistoryTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.m_pHistoryTableView:setTouchEnabled(true)
        self.m_pHistoryTableView:setDelegate()
        self.m_pHistoryTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
        self.m_pHistoryTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
        self.m_pHistoryTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
        self.m_pHistoryTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
        self.m_pHistoryTableView:reloadData()
        self.m_pHistoryTableView:addTo(self.Node_Right)
    end
end

--筹码飞入动画(飞入的区域，筹码大小)
function GameViewLayer:chipAnimation(tdxh_id,value,begin_x,begin_y)
    ExternalFun.playGameEffect("game/car/sound/sound-bet-low.mp3")
    local end_x,end_y = 0,0,0,0
    if value == 30 then
        value = 20

    end
    local sp_chip = cc.Sprite:createWithSpriteFrameName("cm/"..tostring(value)..".png")
    sp_chip:setScale(0.3)
    self.Node_Chip:addChild(sp_chip)
    
    sp_chip:setPosition(cc.p(begin_x,begin_y))
    if tdxh_id == 0 then
        end_x = math.random(310,400)
        end_y = math.random(460,510)
        table.insert(self.sp_tab[1],sp_chip)
    elseif tdxh_id == 1 then
        end_x = math.random(300,390)
        end_y = math.random(300,350)
        table.insert(self.sp_tab[2],sp_chip)
    elseif tdxh_id == 2 then
        end_x = math.random(540,640)
        end_y = math.random(460,510)
        table.insert(self.sp_tab[3],sp_chip)
    elseif tdxh_id == 3 then
        end_x = math.random(550,630)
        end_y = math.random(300,350)
        table.insert(self.sp_tab[4],sp_chip)
    elseif tdxh_id == 4 then
        end_x = math.random(780,870)
        end_y = math.random(460,510)
        table.insert(self.sp_tab[5],sp_chip)
    elseif tdxh_id == 5 then
        end_x = math.random(790,870)
        end_y = math.random(300,350)
        table.insert(self.sp_tab[6],sp_chip)
    elseif tdxh_id == 6 then
        end_x = math.random(1020,1090)
        end_y = math.random(460,510)
        table.insert(self.sp_tab[7],sp_chip)
    elseif tdxh_id == 7 then
        end_x = math.random(1000,1050)
        end_y = math.random(300,350)
        table.insert(self.sp_tab[8],sp_chip)
    end
    
    sp_chip:runAction(cc.Sequence:create(cc.MoveTo:create(0.2,cc.p(end_x,end_y))))
end

function GameViewLayer:otherBetMoney(Data)         --其他人下注
    
    local index = 0
    if Data[1] == 0 then index = 1
    elseif Data[1] == 1 then index = 5
    elseif Data[1] == 2 then index = 2
    elseif Data[1] == 3 then index = 6
    elseif Data[1] == 4 then index = 3
    elseif Data[1] == 5 then index = 7
    elseif Data[1] == 6 then index = 4
    elseif Data[1] == 7 then index = 8
    end

    local numMoney = Data[1]                       --下注区域
    local otherMoney = Data[2]                     --该区域总钱数
    local heMoney = Data[3]                        --下注钱数
    print(numMoney.."区域下注"..heMoney.."该区域共"..otherMoney)
    if numMoney ~= nil or "" then
       self.m_pAllBetNum[index]:setText(otherMoney):setVisible(true)
    end
    self:updataAllMoney(heMoney)

    local x = self.Node_fly_other:getPositionX()
    local y = self.Node_fly_other:getPositionY()
    self:chipAnimation(Data[1],Data[3],x,y)
end

function GameViewLayer:myBetMoney(Data)            --等待自己下注
    local  index = 0
    if     Data[2] == 0 then index = 1
    elseif Data[2] == 1 then index = 5
    elseif Data[2] == 2 then index = 2
    elseif Data[2] == 3 then index = 6
    elseif Data[2] == 4 then index = 3
    elseif Data[2] == 5 then index = 7
    elseif Data[2] == 6 then index = 4
    elseif Data[2] == 7 then index = 8
    end

    self.m_llMyBetValue[index] = Data[1] + self.m_llMyBetValue[index]
    self.m_pMyBetNum[index]:setText(self.m_llMyBetValue[index]):setVisible(true)
    self.m_pAllBetNum[index]:setText(Data[3]):setVisible(true)
    self:updataAllMoney(Data[1])
    self.m_money = self.m_money - Data[1]
    self.m_pLbUsrGold:setString(tostring(self.m_money))
    local x = self.Node_fly_self:getPositionX()
    local y = self.Node_fly_self:getPositionY()
    self:chipAnimation(Data[2],Data[1],x,y)
end

function GameViewLayer:updataAllMoney(num)
    self.money = tonumber(tonumber(num) + tonumber(self.money))
    self.m_pLbAmountBet:setString(tostring(self.money)):setVisible(true)
end


--计时器更新
function GameViewLayer:OnClockUpdata()

    if self.daojishi_Num == 3 then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(daojishi_1)     -- 加载动画所用到的数据

        armature = ccs.Armature:create("daojishi_1")  -- 创建动画对象

        armature:setPosition(667,375)                    -- 设置位置

        self.m_pCarUI:addChild(armature)                      -- 把动画对象加载到场景内
        armature:getAnimation():playWithIndex(0)
    end
    if self.daojishi_Num == 2 or self.daojishi_Num == 1 then

    end

    local strCount2 = string.format("%d", math.modf(self.daojishi_Num/1) % 10)
    if self.daojishi_Num<10 then
        self.m_pLbCountTime1:setString("0")
    elseif self.daojishi_Num>=10 and self.daojishi_Num<20 then
        self.m_pLbCountTime1:setString("1")
    else
        self.m_pLbCountTime1:setString("2")
    end
    self.m_pLbCountTime2:setString(strCount2)
    self.daojishi_Num = self.daojishi_Num - 1    
end




function GameViewLayer:onUserLeave(userId)      --该uid玩家离开房间
    for key, player in ipairs(self.m_members) do
        if player[1] == userId then
            print(player[2].."------------------->已离开房间")
            table.remove(self.m_members,key)
            table.remove(plyer,key)
        end
    end
    self.m_pLbOtherCount:setString("("..#self.m_members..")")
end



---游戏结算--（需要加判断自身玩家是否参与本局游戏）------------------------------------------------
function GameViewLayer:onGameEnd(args)
    print("结算！！！")
--    args.win_zodic             args.moneys
    -- 筹码禁用
    for i = 1, JETTON_ITEM_COUNT do --筹码
        self:BtnBetChip(i,false)
    end
    if args.mywin > 0  then
        self.m_money = self.m_money + args.mywin + self.m_llMyBetValue[args.win_zodic]
    end
    
    -- 停止下注动画
    ExternalFun.playGameEffect("game/car/soundpublic/sound-end-wager.mp3")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(feiqinzoushou_kaijiang) 
    local armature = ccs.Armature:create("feiqinzoushou_kaijiang")  
    armature:setPosition(667,375)                   
    self.m_pCarUI:addChild(armature)                      
    armature:getAnimation():playWithIndex(0)
    armature:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(function()   armature:removeFromParent()    end)))
    -- 更新状态
    self.desk = GameViewLayer.STATE_OVERXIAZHU
    -- 更新倒计时
    self.daojishi_Num = self:getIntValue(args.timeout)
    -- 更新倒计时图片
    self.m_pSpriteStatus_awad:setVisible(true)
    self.m_pSpriteStatus_bet:setVisible(false)

    self:setIndexNum(args.win_zodic)
    

    self.dealer_win = args.dealer_win
    self.mywin = args.mywin
    self.win_zodic = args.win_zodic
    self.moneys = args.moneys
    
    --庄家位置
    self.m_pZhuangPos = cc.p(self.Node_fly_bank:getPosition())
    --其他玩家
    self.m_pQiTaWanJiaPos = cc.p(self.Node_fly_other:getPosition())
    --自己位置
    self.m_pSelfPos = cc.p(self.Node_fly_self:getPosition())

    self:doSomethingLater(function()
        self:showOpenAnimation()
    end, 1.0)    
end
function GameViewLayer:doSomethingLater(call, time)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(time), cc.CallFunc:create(call)))
end
-- 筹码飞出
function GameViewLayer:flyChipInGameEnd()
    
    --飞行速度
    local speed = 2500

    --(1)庄家吃掉筹码(0.5s/最长距离670/随机时间0.2s/飞行时间0.3s)
    local function flyToBanker(chip)
        local distance = 670
        local flyTime = math.min(distance / speed, 0.3)
        local tempTime = (0.45 - flyTime) * 100
        local delayTime = math.random(1, tempTime) / 100
        chip:runAction(cc.Sequence:create(
            cc.DelayTime:create(delayTime),
            cc.MoveTo:create(flyTime, self.m_pZhuangPos),
            cc.Hide:create()))
    end

    --(2)庄家赔付筹码(0.5s/最长距离670/随机时间0.2s/飞行时间0.3s)
    local function flyFromBanker(chip)
        
        local distance = 670
        local flyTime = math.min(distance / speed, 0.3)
        local tempTime = (0.45 - flyTime) * 100
        local delayTime = math.random(1, tempTime) / 100
        local chebiao_num = self:getNumwinChebiao(self.win_zodic)
        local x,y = self.m_pNodeWinAnim[chebiao_num + 1]:getPosition()
        chip:runAction(cc.Sequence:create(
            cc.Show:create(),
            cc.DelayTime:create(delayTime),
            cc.MoveTo:create(flyTime, cc.p(x,y))))
    end

    --(3)筹码飞回原处(1.0s/最长距离1090/随机时间0.55s/飞行时间0.45s)
    local function flyToPlayer(chip)
        local endPos =  self.m_pQiTaWanJiaPos
        local distance = 1090
        local flyTime = math.min(distance / speed, 0.45)
        local tempTime = (0.95 - flyTime) * 100
        local delayTime = math.random(1, tempTime) / 100
        chip:runAction(cc.Sequence:create(
            cc.Show:create(),
            cc.DelayTime:create(delayTime),
            cc.MoveTo:create(flyTime, endPos),
            cc.Hide:create()))
    end

    local winJettonIndex = self.win_zodic + 1 --中奖区域
    local vecBankerWin  = {} --庄家赢的
    local vecBankerLost = {} --庄家输的
    local vecPlayerChip = {} --原始筹码

    --筹码飞出
    for i=1,CAR_DOWN_COUNT do
        if winJettonIndex == i then
            for key, chip in ipairs(self.sp_tab[i]) do
                table.insert(vecBankerLost,chip)
            end
        else
            for key, chip in ipairs(self.sp_tab[i]) do
                table.insert(vecBankerWin,chip)
            end
        end
        for key, chip in ipairs(self.sp_tab[i]) do
            table.insert(vecPlayerChip,chip)
        end
    end

    --执行飞筹码动画
    local m_UpdateFlyStep = 0

    self.m_UpdateFlyChip =cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(dt)
        m_UpdateFlyStep = m_UpdateFlyStep + 1
        if     m_UpdateFlyStep == 1 then --1.庄家吃掉筹码
            for i, chip in pairs(vecBankerWin) do flyToBanker(chip) end
            ExternalFun.playGameEffect("game/car/sound/sound-get-gold.mp3")
        elseif m_UpdateFlyStep == 2 then --2.庄家赔付筹码
            for i, chip in pairs(vecBankerWin) do flyFromBanker(chip) end
            for i, chip in pairs(vecBankerLost) do flyFromBanker(chip) end
            ExternalFun.playGameEffect("game/car/sound/sound-get-gold.mp3")
        elseif m_UpdateFlyStep == 3 then --3.筹码返还
            for i, chip in pairs(vecPlayerChip) do flyToPlayer(chip) end
--            for i, chip in pairs(vecBankerLost) do flyToPlayer(chip) end
            ExternalFun.playGameEffect("game/car/sound/sound-get-gold.mp3")
        elseif m_UpdateFlyStep == 4 then
        elseif m_UpdateFlyStep == 5 then --4.显示加金币
            self:showGameResult()
        elseif m_UpdateFlyStep == 6 then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_UpdateFlyChip)
        end
    end, 0.50,false)
end

-- 筹码飞出结果
function GameViewLayer:showGameResult()
    -- 金币输赢提示文字
    self:showMoneyResult(self.m_pLbResultGoldBanker,self.dealer_win)
    self.Moneydealer = self.Moneydealer + self.dealer_win
    self.m_pLbZhuangMoney:setString(self.Moneydealer):setScale(0.8)
    if self.mywin ~= 0 then
        self:showMoneyResult(self.m_pLbResultGoldUser,self.mywin)
    else
        self.Tab_XuYa = {}   -- xuya
    end
    local numplayer = (self.dealer_win*0.05)-self.dealer_win
    self:showMoneyResult(self.m_pLbResultGoldPlayer,numplayer)
    --  更新记录列表
    table.insert(self.numList,self.win_zodic)
    table.remove(self.numList,1)
    self:PaixingList()
    -- 更新玩家列表金币
    for key, player in ipairs(self.m_members) do
        for i = 1, #self.moneys  do
            if player[1] == self.moneys[i][1] then
                player[6] = self.moneys[i][2]
            end
        end
    end
    for k, v in ipairs(self.m_members) do
        table.insert(plyer,v)
    end
end
-- 转圈 序号
function GameViewLayer:setIndexNum(winzodic)
    self.winzodic = 0
    local suijishu = math.random(1,4)

    for i = 0,7 do
        if winzodic == i then
            self.winzodic = (suijishu-1)*8+i
        end
    end
--    if winzodic == 0 then
----        local biao = {0,8,16,24}
--    elseif winzodic == 1 then
----        local biao = {1,9,17,25}
--    elseif winzodic == 2 then 
----        local biao = {2,10,18,26}
--    elseif winzodic == 3 then
----        local biao = {3,11,19,27}
--    elseif winzodic == 4 then
----        local biao = {4,12,20,28}
--    elseif winzodic == 5 then
----        local biao = {5,13,21,29}
--    elseif winzodic == 6 then
----        local biao = {6,14,22,30}
--    elseif winzodic == 7 then
----        local biao = {7,15,23,31}
--    end
--    return self.winzodic
end
-- 转圈开始
function GameViewLayer:showOpenAnimation()

    --// 计算移动的总数量和开始位置
    local lCount = 32 --32个一圈
    local lRound = 3 --转3圈
    local fAniTime = 0.5

    local beginIndex = self.lostPos or 0
    local endIndex = self.winzodic

    local subIndex = 0

    if beginIndex > endIndex then
        subIndex = lCount - (beginIndex + 1) + (endIndex + 1)
    else
        subIndex = endIndex - beginIndex
    end

    self.m_iShowAmount = lCount * lRound + beginIndex + subIndex
    self.m_iShowIndex = beginIndex
    self.m_fOpenAniTime = fAniTime
    self.m_pSpriteSelect[1]:setVisible(true)

    print("begin", beginIndex, "end", endIndex, "show", self.m_iShowIndex, "amount", self.m_iShowAmount)
    self:updateOpenAnimation()
    self.lostPos = self.winzodic
end

--  转圈结束
function GameViewLayer:updateOpenAnimation()

    if (self.m_iShowIndex == self.m_iShowAmount + 1) then --转圈结束
        self.m_iShowIndex = 0
        self:flyChipInGameEnd()
        return
    end
    
    if(self.m_iShowIndex == self.m_iShowAmount)then
        print("turn end sound", self.m_iShowIndex)
        ExternalFun.playGameEffect("game/car/sound/sound-car-turn-end.mp3")

        --开奖结束
        self:openAnimationEnd()
    else
        if self.m_fOpenAniTime  == 0.01  then
            if self.m_iShowIndex % 3 == 0 then
                ExternalFun.playGameEffect("game/car/sound/sound-car-turn.mp3")
            end
        else
                ExternalFun.playGameEffect("game/car/sound/sound-car-turn.mp3")
        end
    end

    if ((self.m_fOpenAniTime - 0.05) <= 0.01) then
        self.m_fOpenAniTime  = 0.01
    else
        self.m_fOpenAniTime  = self.m_fOpenAniTime - 0.05
    end

    if (self.m_fOpenAniTime <= 0.01) then
        for i = 1, JETTON_ITEM_COUNT do
            self.m_pSpriteSelect[i]:setVisible(true)
        end
    end

    local index = self.m_iShowIndex % 32
    local subIndex = self.m_iShowAmount - self.m_iShowIndex
    if (0 <= subIndex and subIndex <= 5)then
        for i=2,tonumber(JETTON_ITEM_COUNT),1 do
            self.m_pSpriteSelect[i]:setVisible(false)
        end
        self.m_fOpenAniTime = (6 - subIndex) * 0.2
    elseif 6 <= subIndex and subIndex <= 8 then
        self.m_fOpenAniTime = (9 - subIndex) * 0.05
    end

    for i = 1, 6 do
        local nIndex = 0
        if index - (i - 1) < 0 then
            nIndex = 32 - i
        else                  
            nIndex = index - (i - 1)
        end
        local posX, posY = self.m_pItemRunSprite[nIndex]:getPosition()

        if nIndex % 2 == 0 then
            self.m_pSpriteSelect[i]:setSpriteFrame(self:getRealFrameName("car-big-bg-light.png"))
        else
            self.m_pSpriteSelect[i]:setSpriteFrame(self:getRealFrameName("car-min-bg-light.png"))
        end
        self.m_pSpriteSelect[i]:setPosition(posX, posY)
    end

    self.m_iShowIndex = self.m_iShowIndex + 1

    local seq = cc.Sequence:create(
        cc.DelayTime:create(self.m_fOpenAniTime),
        cc.CallFunc:create(function() self:updateOpenAnimation() end))
    self:runAction(seq);
end

-- 开奖
function GameViewLayer:openAnimationEnd()

    local endIndex= self.winzodic
    local posX,posY = self.m_pItemRunSprite[endIndex]:getPosition()
    print("end Select", endIndex)
    self.m_pSpriteSelect[1]:setPosition(cc.p(posX,posY))
    self.m_pSpriteSelect[2]:setVisible(false)
    self.m_pSpriteSelect[3]:setVisible(false)
    
    --选中闪烁
    local pSeq = cc.Sequence:create(
        cc.Blink:create(0.8, 3),
        cc.DelayTime:create(0.6 + 5),
        cc.CallFunc:create(function()        
    end))
    self.m_pSpriteSelect[1]:runAction(pSeq)

    --闪烁动画
--    local anim = self:showAnimationWithIndex(self.m_pItemRunNode , "benchibaoma_xuanzhong")
--    anim:setPosition(cc.p(posX , posY))
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(benchibaoma_xuanzhong) 
    local armature = ccs.Armature:create("benchibaoma_xuanzhong")  
    armature:setPosition(cc.p(posX , posY))                   
    self.m_pCarUI:addChild(armature)                      
    armature:getAnimation():playWithIndex(0)
    armature:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(function()   armature:removeFromParent()    end)))
--    --投中闪烁
--    self:showBetSuccessAreaEffect()

    
    -- 车标闪烁
    local chebiao_num = self:getNumwinChebiao(self.win_zodic)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(benchibaomaglow) 
    local armature = ccs.Armature:create("benchibaomaglow")  
    
    local x = self.m_pNodeWinAnim[chebiao_num+1]:getPositionX()
    local y = self.m_pNodeWinAnim[chebiao_num+1]:getPositionY()
    armature:setPosition(cc.p(x,y))
    self.m_pCarUI:addChild(armature)                      
    armature:getAnimation():playWithIndex(chebiao_num)
    armature:runAction(cc.Sequence:create(cc.DelayTime:create(10),cc.CallFunc:create(function()   armature:removeFromParent()    end)))


end

--序号转换
function GameViewLayer:getNumwinChebiao(winnum)
    local num_win = nil
    if winnum == 0 then num_win = 0
    elseif winnum == 1 then num_win = 4
    elseif winnum == 2 then num_win = 1
    elseif winnum == 3 then num_win = 5
    elseif winnum == 4 then num_win = 2
    elseif winnum == 5 then num_win = 6
    elseif winnum == 6 then num_win = 3
    elseif winnum == 7 then num_win = 7
    else
        showToast(self,"cuocuocuo",2)
    end
    return num_win
end

-- 金币结算
function GameViewLayer:showMoneyResult(Money,num)
    if num < 0 then
        Money:setFntFile(FNT_RESULT_LOSE)
        Money:setString(num):setVisible(true)
        Money:runAction(cc.Sequence:create(cc.MoveBy:create(1,cc.p(0,50)),
            cc.DelayTime:create(1.0),
            cc.CallFunc:create(function()   
                Money:setVisible(false)    
            end),cc.MoveBy:create(1,cc.p(0,-50))))
    else
        Money:setFntFile(FNT_RESULT_WIN)
        Money:setString("+"..num):setVisible(true)
        Money:runAction(cc.Sequence:create(cc.MoveBy:create(1,cc.p(0,50)),
            cc.DelayTime:create(1.0),
            cc.CallFunc:create(function()   
                Money:setVisible(false)    
            end),cc.MoveBy:create(1,cc.p(0,-50))))
    end
end
--更新自己金钱
function GameViewLayer:updataMyMoney(args)
    for key, player in ipairs(self.m_members) do
        if player[1] == GlobalUserItem.tabAccountInfo.userid then
            print(player[2].."------------------->更新金币")
            --设置玩家金币数
            local money_num = args
            self.m_pLbUsrGold:setString(tostring(money_num))
        end
    end
    if args < 500  then
    self:BtnBetChip(6,false)
    end
    if args < 100  then
    self:BtnBetChip(5,false)
    end
    if args < 50  then
    self:BtnBetChip(4,false)
    end
    if args < 20  then
    self:BtnBetChip(3,false)
    end
    if args < 5  then
    self:BtnBetChip(2,false)
    end
    if args < 1  then
    self:BtnBetChip(1,false)
    end
end

function GameViewLayer:updealer(dataBuffer)                   -- 加入上庄列表
    if dataBuffer[1] == GlobalUserItem.tabAccountInfo.userid then
        showToast(self,"您已加入上庄列表！",2)
        self.m_pBtnRequestToZhuang:setVisible(false)
        self.m_pBtnCancelToZhuang:setVisible(true)
    end
    table.insert(self.zhuangList,dataBuffer)
--    self.m_pLbZhuangMoney:setString(v[4]):setScale(0.8)
--    self.m_pLbZhuangName:setString(v[2])
--    self.Moneydealer = v[4]

    local numdealer = #self.zhuangList
    self.m_pLbZhuangNum:setString("申请人数："..numdealer)
end

function GameViewLayer:updataDealers(dataBuffer)               -- 换庄
    self.m_pLbZhuangName:setVisible(true)
    self.m_pLbZhuangMoney:setVisible(true)
    self.zhuangList = {}
    for k, v in ipairs(dataBuffer) do
        table.insert(self.zhuangList,v)
        if k == 1 then
            self.m_pLbZhuangMoney:setString(v[4]):setScale(0.8)
            self.m_pLbZhuangName:setString(v[2])
            self.Moneydealer = v[4]
            if v[1] == GlobalUserItem.tabAccountInfo.userid then
                self.isShangZhuang = true
            else
                self.isShangZhuang = false
            end
        end
    end

    local numdealer = #self.zhuangList
    self.m_pLbZhuangNum:setString("申请人数："..numdealer)
    for i = 1, CAR_DOWN_COUNT do --下注
        self.m_pButtonAnimal[i]:setEnabled(true)
    end
--    local filebg = self.spanimals:getSpriteFrame("game/animals/gui/gui-wz-wanj.png")
--    local spchipbg = cc.Sprite:createWithSpriteFrameName("game/car/gui/gui-wz-wanj.png"):setPosition(self.m_pNodeTips:getPosition()):addTo(self.m_pNodeTips,100)
--    spchipbg:runAction(cc.Sequence:create( cc.DelayTime:create(2),cc.CallFunc:create(function()
--                spchipbg:removeFromParent()
--            end) ))
end

function GameViewLayer:onPlayerShow()                     -- 系统坐庄
    print("123")
    showToast(self,"等待玩家上庄！",2)
    self.m_pLbZhuangName:setVisible(false)
    self.m_pLbZhuangMoney:setVisible(false)
--    self.Node_FlyChip:setVisible(true)
    for i = 1, JETTON_ITEM_COUNT do --筹码
        self:BtnBetChip(i,false)
    end
    for i = 1, CAR_DOWN_COUNT do --下注
        self.m_pButtonAnimal[i]:setEnabled(false)
    end
end

function GameViewLayer:downDealers(dataBuffer)             -- 下庄
    for k, v in ipairs(self.zhuangList) do
        if v[1] == dataBuffer[1] then
            table.remove(self.zhuangList,k)
        end
    end
    if dataBuffer[1] == GlobalUserItem.tabAccountInfo.userid then
        self.isShangZhuang = false
        self.m_pBtnCancelToZhuang:setVisible(false)
        self.m_pBtnRequestToZhuang:setVisible(true)
    end
    local numdealer = #self.zhuangList
    self.m_pLbZhuangNum:setString("申请人数："..numdealer)
    
end

--本局游戏结束-------------------------------------------------空闲--------------------------------------
function GameViewLayer:onDeskOver(args)
    print("空闲！！！")
    self.desk = GameViewLayer.STATE_KONGXIAN
--    self.daojishi_Num = self:getIntValue(args)
    self:clearn()
end


--金币不足
function GameViewLayer:Badbetmoney(dataBuffer)
    if dataBuffer == 0 then
    local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
            local querydialog = QueryDialog:create("到庄家上限！", function ()
				
		        end,nil,1):setCanTouchOutside(false)
                :addTo(self._scene)
    elseif dataBuffer == 1 then
    local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
            local querydialog = QueryDialog:create("到达玩家上限！", function ()
				
		        end,nil,1):setCanTouchOutside(false)
                :addTo(self._scene)
    elseif dataBuffer == 2 then
    local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
            local querydialog = QueryDialog:create("钱不够了！", function ()
				
		        end,nil,1):setCanTouchOutside(false)
                :addTo(self._scene)
    elseif dataBuffer == 3 then
    local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
            local querydialog = QueryDialog:create("到达盘面上限！", function ()
				
		        end,nil,1):setCanTouchOutside(false)
                :addTo(self._scene)
    end
end

function GameViewLayer:Nomoney(dataBuffer)                            -- 上庄失败
    local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
    local querydialog = QueryDialog:create("你的金币不足"..dataBuffer.."无法上庄", function ()			
	end,nil,1):setCanTouchOutside(false)
    :addTo(self._scene)
end

function GameViewLayer:isDelayHandleEvent()

    --//2秒钟只能点击一次
    local tmNow = os.time()
    local defaultCDtime = 1.5

    if (tmNow - self.m_tmLastClicked <= defaultCDtime)then
        return true;
    end

    self.m_tmLastClicked = tmNow; 
    return false;
end

--得到整数部分
function GameViewLayer:getIntValue(num)
    local tt = 0
    num,tt = math.modf(num/1);
    return num
end


function GameViewLayer:getRealFrameName( name )
    return string.format( "game/car/gui/%s", name)
end

function GameViewLayer:getMembers()
    return  plyer
end

function GameViewLayer:clearn()
    for i = 1, CAR_DOWN_COUNT do
        self.m_pAllBetNum[i]:setVisible(false)
        self.m_pMyBetNum[i]:setVisible(false)
    end
    self.m_llMyBetValue = {0,0,0,0,0,0,0,0}
    self.m_pLbAmountBet:setString("0")
    self.money = 0

    self.mywin = 0
    self.dealer_win = 0
    self.moneys = {}
    self.win_zodic = 0


    self.sp_tab = {{},{},{},{},{},{},{},{},}

end

function GameViewLayer:onExit()
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._ClockFun) 
    if self.m_UpdateFlyChip then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_UpdateFlyChip) 
    end
    if self._XuyaFun then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._XuyaFun)
    end

end


return GameViewLayer