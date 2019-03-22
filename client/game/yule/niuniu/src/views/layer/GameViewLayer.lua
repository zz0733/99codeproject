--  二人牛牛
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local module_pre = "game.yule.niuniu.src"
local cmd = appdf.req(module_pre .. ".models.CMD_Game")
local Define = appdf.req(module_pre .. ".models.Define")
local GameRoleItem = appdf.req(module_pre .. ".views.layer.GameRoleItem")
local HeadSprite = require(appdf.EXTERNAL_SRC .. "HeadSprite")
local CardSprite = appdf.req(module_pre .. ".views.layer.gamecard.CardSprite")
local CardsNode = appdf.req(module_pre .. ".views.layer.gamecard.CardsNode")
local GameLogic = appdf.req(module_pre .. ".models.GameLogic")
local GameResultLayer = appdf.req(module_pre .. ".views.layer.GameResultLayer")
local SettingLayer = appdf.req(module_pre .. ".views.layer.SettingLayer")
local Poker                 = require(module_pre .. ".views.layer.Poker")
local ProgressNode          = require(module_pre .. ".views.layer.ProgressNode")

local TAG_ENUM = Define.TAG_ENUM
local TAG_ZORDER = Define.TAG_ZORDER

local GameViewLayer = class("GameViewLayer",function(scene)
        local gameViewLayer = display.newLayer()
    return gameViewLayer
end)

--玩家当前状态
GameViewLayer.STATE_ONZHUNBEI = 1       --等待所有玩家准备中
GameViewLayer.STATE_QIANGZHUANG = 2     --抢庄中
GameViewLayer.STATE_XIAZHU = 3          --下注中
GameViewLayer.STATE_LIANGPAI = 4        --亮牌中
GameViewLayer.POKERPOS = {
{ cc.p(-615.00,-230.00),cc.p(-535.00,-230.00),cc.p(-455.00,-270.00),cc.p(-375.00,-270.00),cc.p(-300.00,-270.00)},
{ cc.p(-520.00, 220.00),cc.p(-475.00, 220.00),cc.p(-430.00, 185.00),cc.p(-385.00, 185.00),cc.p(-340.00, 185.00)}
}

function GameViewLayer:ctor(scene)
print("on enter -----------===========----------    GameViewLayer")
    --注册node事件
    ExternalFun.registerNodeEvent(self)
    self._scene = scene

    --托管标志位
    self.isTuoGuan = false
    --进入游戏时当前桌面状态--(false是没有进行游戏，true是有游戏牌局在进行)
    self.gameEnterState = false 
    self.ownerState = nil   --玩家状态标志位
    -- --初始化
    -- self:paramInit()

    -- --加载资源
    -- self:loadResource()

    --初始化界面
    self:initViewLayer()
    
end
function GameViewLayer:initViewLayer( )
    ExternalFun.playBackgroudAudio("table_music.mp3")
    local rootLayer, csbNode = ExternalFun.loadRootCSB("niuniu/niuniu_scene.csb", self)
    self.root = csbNode
    --iphoneX适配
    if LuaUtils.isIphoneXDesignResolution() then
        local width_ = yl.WIDTH - display.size.width
        self.root:setPositionX(self.root:getPositionX() - width_/2)
    end
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))

    cc.SpriteFrameCache:getInstance():addSpriteFrames("niuniu/plist/tniuniu-poker.plist","niuniu/plist/tniuniu-poker.png")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("niuniu/plist/gui-poker-1.plist","niuniu/plist/gui-poker-1.png")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("niuniu/plist/twoniuniu.plist","niuniu/plist/twoniuniu-1.png")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("niuniu/effect/errenniuniu4_zhuang/errenniuniu4_zhuang.ExportJson")
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("niuniu/effect/errenniuniu4_fapai/errenniuniu4_fapai.ExportJson")
    self.chipImageRes = {}
    for key, res_ in ipairs(GameViewLayer.chipSpRec) do
        local chipSpriteFrame = cc.Director:getInstance():getTextureCache():addImage(res_)
        table.insert(self.chipImageRes,chipSpriteFrame)
    end

    self.fourChip = {}  --收到下注消息存储四个下注的值
    self.robot_chipID = 0       --取值1-4，用于托管选择下第几个注
    self.deskState = GameViewLayer.STATE_ONZHUNBEI --当前桌子状态，进入房间时是准备状态
    self.robotState = false     --机器人托管状态
    self.bankerUid = nil        --庄家ID
    self.pokerNode_Ani = {}     --发牌动画节点，1是自身，2是对手
    self.pokerNode_Ani[1] = self.root:getChildByName("sp_pokerBg_1")
    self.pokerNode_Ani[2] = self.root:getChildByName("sp_pokerBg_2")
    self.poker_Ani = {}         --扑克动画
    self.myCardData = {}        --存放发牌后自己的牌
    self.jiesuanPokerValue = {} --存放结算时双方的牌
    self.jiesuanPokerSprite = {}    --存放结算后双方牌的精灵
    self.jiesuanPokerSprite[1] = {}
    self.jiesuanPokerSprite[2] = {}
    self.myMoneyNum = 0         --自身金币数量
    self.otherMoneyNum = 0      --对方玩家金币数量
    self.historicalProNum = 0   --历史成绩
    self.lastProNum = 0         --上一局的成绩
    self.chipSpriteTable = {}   --存放下注筹码的精灵
    self.chipnum = 0    --下注额
    self.m_pProgressBg = {}         --头像进度条背景
    self.m_pProgressBg[1] = self.root:getChildByName("playerInfoPanel_1"):getChildByName("pProgressBg")
    self.m_pProgressBg[2] = self.root:getChildByName("playerInfoPanel_2"):getChildByName("pProgressBg")
    self.m_pProgressTimer = {}      --头像进度条
    self.timeOut_progress = 0       --消息中的timeout，用于进度条倒计时
    
    ----------------------------------setVisible(false)
    self.root:getChildByName("sp_waitCallFen"):setVisible(false)
    self.root:getChildByName("sp_waitCallZhuang"):setVisible(false)
    self.root:getChildByName("btn_callfen_panel"):setVisible(false)
    self.root:getChildByName("btn_tanpai"):setVisible(false)
    self.root:getChildByName("btn_callZhuang"):setVisible(false)
    self.root:getChildByName("btn_noCall"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_1"):getChildByName("sp_bujiao"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_1"):getChildByName("sp_liangpai"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_1"):getChildByName("sp_ready"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_1"):getChildByName("sp_zhuang"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_1"):getChildByName("str_loseMoneyValue"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_1"):getChildByName("str_winMoneyValue"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_2"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_2"):getChildByName("sp_bujiao"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_2"):getChildByName("sp_liangpai"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_2"):getChildByName("sp_ready"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_2"):getChildByName("sp_zhuang"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_2"):getChildByName("str_loseMoneyValue"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_2"):getChildByName("str_winMoneyValue"):setVisible(false)
    self.root:getChildByName("btn_cancelRobot"):setVisible(false)
    self.root:getChildByName("robot_panel"):setVisible(false)
    self.root:getChildByName("menu_panel"):setVisible(false)
    self.root:getChildByName("menu_panel"):getChildByName("btn_openYinxiao"):setVisible(false)
    self.root:getChildByName("menu_panel"):getChildByName("btn_openYinyue"):setVisible(false)
    self.root:getChildByName("rule_panel"):setVisible(false)
    self.root:getChildByName("str_thisChip"):setString("")
    self.root:getChildByName("sp_pokerBg_1"):removeAllChildren()
    self.root:getChildByName("sp_pokerBg_2"):removeAllChildren() 
    --播放骨骼动画背景
    self.bgAnimation = sp.SkeletonAnimation:create("niuniu/effect/errenniuniu_beijing/errenniuniu_beijing.json", "niuniu/effect/errenniuniu_beijing/errenniuniu_beijing.atlas")
    self.bgAnimation:setPosition(cc.p(800, 375))
--    self.root:getChildByName("bg"):setTimeScale(2)
    self.root:getChildByName("bg"):addChild(self.bgAnimation)
    self.bgAnimation:setAnimation(0, "animation", true)
    --------------------------button
        --菜单按钮
    local touchFunC_menu = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("menu_panel"):setVisible(true)
            ref:setVisible(false)
        end
    end
    local btn_menu = self.root:getChildByName("btn_menu"):addTouchEventListener( touchFunC_menu )
        --菜单关闭按钮
    local touchFunC_closeMenu = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("menu_panel"):setVisible(false)
            self.root:getChildByName("btn_menu"):setVisible(true)
        end
    end
    local btn_closeMenu = self.root:getChildByName("menu_panel"):getChildByName("btn_close"):addTouchEventListener( touchFunC_closeMenu )
    local btn_panel = self.root:getChildByName("menu_panel"):setTouchEnabled(true):addTouchEventListener(touchFunC_closeMenu)
        --规则按钮
    local touchFunC_Rule = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("rule_panel"):setVisible(true)
        end
    end
    local btn_Rule = self.root:getChildByName("menu_panel"):getChildByName("btn_rule"):addTouchEventListener( touchFunC_Rule )
        --规则界面关闭按钮
    local touchFunC_closeRule = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("rule_panel"):setVisible(false)
        end
    end
    local btn_closeRule = self.root:getChildByName("rule_panel"):getChildByName("btn_close"):addTouchEventListener( touchFunC_closeRule )
    local btn_panelRule = self.root:getChildByName("rule_panel"):setTouchEnabled(true):addTouchEventListener(touchFunC_closeRule)
        --开始按钮
    local touchFunC_start = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self:onClilcButton_Start()                     
        end
    end
    local btn_start = self.root:getChildByName("btn_start"):addTouchEventListener( touchFunC_start )
        --抢庄按钮
    local touchFunC_callZhuang = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self:onClilcButton_callZhuang(true)                     
        end
    end
    local btn_callZhuang = self.root:getChildByName("btn_callZhuang"):addTouchEventListener( touchFunC_callZhuang )
        --不叫庄按钮
    local touchFunC_noCall = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self:onClilcButton_callZhuang(false)                     
        end
    end
    local btn_noCall = self.root:getChildByName("btn_noCall"):addTouchEventListener( touchFunC_noCall )
        --下注panel按钮监听
    local touchFunC_jiaofen1 = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self:onClilcButton_jiaofen(self.fourChip[1])                     
        end
    end
    local btn_jiaofen1 = self.root:getChildByName("btn_callfen_panel"):getChildByName("sp_jiaofenBg_1"):setTouchEnabled(true):addTouchEventListener( touchFunC_jiaofen1 )----1
    local touchFunC_jiaofen2 = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self:onClilcButton_jiaofen(self.fourChip[2])                     
        end
    end
    local btn_jiaofen2 = self.root:getChildByName("btn_callfen_panel"):getChildByName("sp_jiaofenBg_2"):setTouchEnabled(true):addTouchEventListener( touchFunC_jiaofen2 )---------2
    local touchFunC_jiaofen3 = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self:onClilcButton_jiaofen(self.fourChip[3])                     
        end
    end
    local btn_jiaofen3 = self.root:getChildByName("btn_callfen_panel"):getChildByName("sp_jiaofenBg_3"):setTouchEnabled(true):addTouchEventListener( touchFunC_jiaofen3 )--3
    local touchFunC_jiaofen4 = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self:onClilcButton_jiaofen(self.fourChip[4])                     
        end
    end
    local btn_jiaofen4 = self.root:getChildByName("btn_callfen_panel"):getChildByName("sp_jiaofenBg_4"):setTouchEnabled(true):addTouchEventListener( touchFunC_jiaofen4 )------4
        --摊牌按钮
    local touchFunC_tanpai = function(ref, tType)
        if tType == ccui.TouchEventType.ended then 
            self:onClilcButton_tanpai()
        end
    end
    local btn_tanpai = self.root:getChildByName("btn_tanpai"):addTouchEventListener( touchFunC_tanpai )
        --退出游戏按钮
    local touchFunC_leave = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self._scene:onQueryExitGame()
        end
    end
    local btn_leave = self.root:getChildByName("btn_leave"):addTouchEventListener( touchFunC_leave )
        --托管按钮
    local touchFunC_robot = function(ref, tType)
        if tType == ccui.TouchEventType.ended then   
            self.root:getChildByName("robot_panel"):setVisible(true)       
        end
    end
    local btn_robot = self.root:getChildByName("btn_robot"):addTouchEventListener( touchFunC_robot )
        --取消托管按钮
    local touchFunC_cancelRobot = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self:onClilcButton_Robot(false)
        end
    end
    local btn_cancelRobot = self.root:getChildByName("btn_cancelRobot"):addTouchEventListener( touchFunC_cancelRobot )
        --托管界面关闭按钮
    local touchFunC_closeRobot = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self.root:getChildByName("robot_panel"):setVisible(false)
        end
    end
    local btn_closeRobot = self.root:getChildByName("robot_panel"):getChildByName("btn_close"):addTouchEventListener( touchFunC_closeRobot )
        --托管按钮筹码选择--Max
    local touchFunC_maxRobot = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self:onClilcButton_Robot(true,1)
        end
    end
    local btn_maxRobot = self.root:getChildByName("robot_panel"):getChildByName("btn_1"):addTouchEventListener( touchFunC_maxRobot )
        --托管按钮筹码选择--1/2
    local touchFunC_2Robot = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self:onClilcButton_Robot(true,2)
        end
    end
    local btn_2Robot = self.root:getChildByName("robot_panel"):getChildByName("btn_2"):addTouchEventListener( touchFunC_2Robot )
        --托管按钮筹码选择--1/4
    local touchFunC_3Robot = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self:onClilcButton_Robot(true,3)
        end
    end
    local btn_3Robot = self.root:getChildByName("robot_panel"):getChildByName("btn_3"):addTouchEventListener( touchFunC_3Robot )
        --托管按钮筹码选择--1/8
    local touchFunC_4Robot = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self:onClilcButton_Robot(true,4)
        end
    end
    local btn_4Robot = self.root:getChildByName("robot_panel"):getChildByName("btn_4"):addTouchEventListener( touchFunC_4Robot )
        --托管按钮筹码选择--随机下注
    local touchFunC_0Robot = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self:onClilcButton_Robot(true,0)
        end
    end
    local btn_0Robot = self.root:getChildByName("robot_panel"):getChildByName("btn_random"):addTouchEventListener( touchFunC_0Robot )
        --打开音效
    local touchFunC_0Robot = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self.root:getChildByName("menu_panel"):getChildByName("btn_closeYinxiao"):setVisible(true)
            self.root:getChildByName("menu_panel"):getChildByName("btn_openYinxiao"):setVisible(false)
            GlobalUserItem.setSoundAble(true)
        end
    end
    local btn_0Robot = self.root:getChildByName("menu_panel"):getChildByName("btn_openYinxiao"):addTouchEventListener( touchFunC_0Robot )
        --关闭音效
    local touchFunC_0Robot = function(ref, tType)
        if tType == ccui.TouchEventType.ended then 
            self.root:getChildByName("menu_panel"):getChildByName("btn_closeYinxiao"):setVisible(false)
            self.root:getChildByName("menu_panel"):getChildByName("btn_openYinxiao"):setVisible(true)
            GlobalUserItem.setSoundAble(false)
        end
    end
    local btn_0Robot = self.root:getChildByName("menu_panel"):getChildByName("btn_closeYinxiao"):addTouchEventListener( touchFunC_0Robot )
        --打开音乐
    local touchFunC_0Robot = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self.root:getChildByName("menu_panel"):getChildByName("btn_openYinyue"):setVisible(false)
            self.root:getChildByName("menu_panel"):getChildByName("btn_closeYinyue"):setVisible(true)
            GlobalUserItem.setVoiceAble(true)
        end
    end
    local btn_0Robot = self.root:getChildByName("menu_panel"):getChildByName("btn_openYinyue"):addTouchEventListener( touchFunC_0Robot )
        --关闭音乐
    local touchFunC_0Robot = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
            self.root:getChildByName("menu_panel"):getChildByName("btn_openYinyue"):setVisible(true)
            self.root:getChildByName("menu_panel"):getChildByName("btn_closeYinyue"):setVisible(false)
            GlobalUserItem.setVoiceAble(false)
        end
    end
    local btn_0Robot = self.root:getChildByName("menu_panel"):getChildByName("btn_closeYinyue"):addTouchEventListener( touchFunC_0Robot )
    if (GlobalUserItem.bVoiceAble)then
        GlobalUserItem.setVoiceAble(true)
        self.root:getChildByName("menu_panel"):getChildByName("btn_openYinyue"):setVisible(true)
        self.root:getChildByName("menu_panel"):getChildByName("btn_closeYinyue"):setVisible(false)
    else
        GlobalUserItem.setVoiceAble(false)
        self.root:getChildByName("menu_panel"):getChildByName("btn_openYinyue"):setVisible(false)
        self.root:getChildByName("menu_panel"):getChildByName("btn_closeYinyue"):setVisible(true)    
    end
    if (GlobalUserItem.bSoundAble)then
        GlobalUserItem.setSoundAble(true)
        self.root:getChildByName("menu_panel"):getChildByName("btn_openYinxiao"):setVisible(true)
        self.root:getChildByName("menu_panel"):getChildByName("btn_closeYinxiao"):setVisible(false)
    else
        GlobalUserItem.setSoundAble(false)
        self.root:getChildByName("menu_panel"):getChildByName("btn_openYinxiao"):setVisible(false)
        self.root:getChildByName("menu_panel"):getChildByName("btn_closeYinxiao"):setVisible(true)    
    end
end
function GameViewLayer:onClilcButton_Start()        --开始准备按钮
    self.root:getChildByName("btn_start"):setVisible(false)
    self._scene:sendReady()
    if self.m_pProgressTimer[1] then
        self.m_pProgressTimer[1]:setVisible(false)
    end
end
function GameViewLayer:onClilcButton_callZhuang(isCall)   --叫庄/不叫庄
    self._scene:sendAskBanker(isCall)
    self.root:getChildByName("btn_callZhuang"):setVisible(false)
    self.root:getChildByName("btn_noCall"):setVisible(false)
    if self.m_pProgressTimer[1] then
        self.m_pProgressTimer[1]:setVisible(false)
    end
end
function GameViewLayer:onClilcButton_jiaofen(callValue)   --叫分
    self._scene:sendChip_in(callValue)
    self.root:getChildByName("btn_callfen_panel"):setVisible(false)
    if self.m_pProgressTimer[1] then
        self.m_pProgressTimer[1]:setVisible(false)
    end
end
function GameViewLayer:onClilcButton_tanpai()   --摊牌
    self._scene:sendTanPai()
    self.root:getChildByName("playerInfoPanel_1"):getChildByName("sp_liangpai"):setVisible(true)
    self.root:getChildByName("btn_tanpai"):setVisible(false)
    if self.m_pProgressTimer[1] then
        self.m_pProgressTimer[1]:setVisible(false)
    end
end
function GameViewLayer:onClilcButton_Robot(robot_state,btn_id)   --托管
    self.robotState = robot_state
    if robot_state == true then
        --机器人托管中
        self.root:getChildByName("btn_robot"):setVisible(false)
        self.root:getChildByName("btn_cancelRobot"):setVisible(true)
        if btn_id == 5 then
            local chipID = math.random(1,4)
            self.robot_chipID = chipID
        else
             self.robot_chipID = btn_id
        end
    else
        --取消机器人托管
        self.root:getChildByName("btn_robot"):setVisible(true)
        self.root:getChildByName("btn_cancelRobot"):setVisible(false)
    end

    if self.robotState == true then
        if self.deskState == GameViewLayer.STATE_ONZHUNBEI then
            self:onClilcButton_Start()
        elseif self.deskState == GameViewLayer.STATE_QIANGZHUANG then
            self:onClilcButton_callZhuang(false)
        elseif self.deskState == GameViewLayer.STATE_XIAZHU then
            self:onClilcButton_jiaofen(self.fourChip[self.robot_chipID])
        elseif self.deskState == GameViewLayer.STATE_LIANGPAI then
            self:onClilcButton_tanpai()
        end
    end
    self.root:getChildByName("robot_panel"):setVisible(false)
end
-----------------------处理收到的消息
--进入游戏
function GameViewLayer:onEventEnter(bufferData) 
    self.deskState = GameViewLayer.STATE_ONZHUNBEI  
    for key, player in ipairs(bufferData.memberinfos) do
        local playerPanel = nil
        if player.uid == GlobalUserItem.tabAccountInfo.userid then
            playerPanel = self.root:getChildByName("playerInfoPanel_1")
            self.myMoneyNum = player.into_money
        else
            playerPanel = self.root:getChildByName("playerInfoPanel_2")
            playerPanel:setVisible(true)
            self.otherMoneyNum = player.into_money
        end
        playerPanel:getChildByName("str_userName"):setString(player.nickname)
        playerPanel:getChildByName("str_goldNum"):setString(player.into_money)
        local icon = playerPanel:getChildByName("sp_icon")
        local head = HeadSprite:createNormal(player, 100)
        head:setScale(icon:getContentSize().width/head:getContentSize().width)
        head:setAnchorPoint(cc.p(0.53,0.5))
        head:setPosition(cc.p(75,75))
        icon:addChild(head)
    end
    self.timeOut_progress = bufferData.deskinfo.continue_timeout
    self:showProgrssTimer( 1 )
end
--有玩家进入房间
function GameViewLayer:onEventCome(bufferData)
    local player = bufferData.memberinfo
    local playerPanel = self.root:getChildByName("playerInfoPanel_2")
    playerPanel:setVisible(true)
    playerPanel:getChildByName("str_userName"):setString(player.nickname)
    playerPanel:getChildByName("str_goldNum"):setString(player.into_money)
    self.otherMoneyNum = player.into_money
    local icon = playerPanel:getChildByName("sp_icon")
    local head = HeadSprite:createNormal(player, 100)
    head:setScale(icon:getContentSize().width/head:getContentSize().width)
    head:setAnchorPoint(cc.p(0.53,0.5))
    head:setPosition(cc.p(75,75))
    icon:addChild(head)
end
--有玩家离开房间
function GameViewLayer:onEventLeave(bufferData)   
    local playerPanel = self.root:getChildByName("playerInfoPanel_2")
    playerPanel:setVisible(false)
    playerPanel:getChildByName("sp_icon"):removeAllChildren()
end
--有玩家准备
function GameViewLayer:onEventReady(bufferData)  
    ExternalFun.playSoundEffect("sound-ready.mp3")
    if bufferData == GlobalUserItem.tabAccountInfo.userid then
        local playerPanel = self.root:getChildByName("playerInfoPanel_1"):getChildByName("sp_ready"):setVisible(true)
        if self.m_pProgressTimer[1] then
            self.m_pProgressTimer[1]:setVisible(false)
        end
    else
        local playerPanel = self.root:getChildByName("playerInfoPanel_2"):getChildByName("sp_ready"):setVisible(true)
        if self.m_pProgressTimer[2] then
            self.m_pProgressTimer[2]:setVisible(false)
        end
    end
end
--更新自身钱包
function GameViewLayer:onEventUpdate_intomoney(bufferData)   
    self.root:getChildByName("playerInfoPanel_1"):getChildByName("str_goldNum"):setString(bufferData)
    self.myMoneyNum = bufferData
end
--该谁抢庄
function GameViewLayer:onEventAsk_banker(bufferData)
    if self.beginSound == nil then
        ExternalFun.playSoundEffect("sound-star.mp3")
        self.beginSound = true
    end
    self.timeOut_progress = bufferData.timeout
    self.root:getChildByName("chipFly_panel"):removeAllChildren()
    self.deskState = GameViewLayer.STATE_QIANGZHUANG
    self.root:getChildByName("playerInfoPanel_1"):getChildByName("sp_ready"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_2"):getChildByName("sp_ready"):setVisible(false)
    self.root:getChildByName("btn_callZhuang"):setVisible(false)
    self.root:getChildByName("btn_noCall"):setVisible(false)
    self.root:getChildByName("sp_waitCallZhuang"):setVisible(false)

    for key, player in ipairs(bufferData.money_list) do
        if player.uid == GlobalUserItem.tabAccountInfo.userid then
            self.myMoneyNum = player.money
            self.root:getChildByName("playerInfoPanel_1"):getChildByName("str_goldNum"):setString(player.money)
        else
            self.otherMoneyNum = player.money
            self.root:getChildByName("playerInfoPanel_2"):getChildByName("str_goldNum"):setString(player.money)
        end
    end
    if bufferData.uid == GlobalUserItem.tabAccountInfo.userid then
        self.root:getChildByName("btn_callZhuang"):setVisible(true)
        self.root:getChildByName("btn_noCall"):setVisible(true)
        self:showProgrssTimer( 1 )
        if self.m_pProgressTimer[2] then
            self.m_pProgressTimer[2]:setVisible(false)
        end
        --机器人帮助中
        if self.robotState == true then
            self:onClilcButton_callZhuang(false)
        end
    else
        self:showProgrssTimer( 2 )
        self.root:getChildByName("sp_waitCallZhuang"):setVisible(true)
    end       
end
--开始叫分
function GameViewLayer:onEventStart_chip(bufferData)
    self.beginSound = nil
    --播放抢庄音效
    ExternalFun.playSoundEffect("sound-banker.mp3")

    self.timeOut_progress = bufferData.timeout
    self.bankerUid = bufferData.bid
    self.deskState = GameViewLayer.STATE_XIAZHU  
    self.root:getChildByName("btn_callZhuang"):setVisible(false)
    self.root:getChildByName("btn_noCall"):setVisible(false)
    self.root:getChildByName("sp_waitCallZhuang"):setVisible(false)
    if bufferData.bid ~= GlobalUserItem.tabAccountInfo.userid then
        --在对手那里播放庄的动画
        local zhangJiaobiao = self.root:getChildByName("playerInfoPanel_2"):getChildByName("sp_zhuang")
        zhangJiaobiao:setVisible(true)
        self.zhuangAction(zhangJiaobiao)
        self.root:getChildByName("btn_callfen_panel"):setVisible(true)
        self.fourChip = bufferData.chip
        for key, chipValue in ipairs(bufferData.chip) do
            self.root:getChildByName("btn_callfen_panel"):getChildByName("str_jiaofen_"..tostring(key)):setString(chipValue)
        end
        --机器人帮助中
        if self.robotState == true then
            self:onClilcButton_jiaofen(self.fourChip[self.robot_chipID])
        end
        if self.m_pProgressTimer[2] then
            self.m_pProgressTimer[2]:setVisible(false)
        end
        self:showProgrssTimer( 1 )
    else
        --在自己这边播放抢庄成功的动画
        local zhangJiaobiao = self.root:getChildByName("playerInfoPanel_1"):getChildByName("sp_zhuang")
        zhangJiaobiao:setVisible(true)        
        self.zhuangAction(zhangJiaobiao)
        self.root:getChildByName("sp_waitCallFen"):setVisible(true)

        self:showProgrssTimer( 2 )
    end
end
--发牌
function GameViewLayer:onEventDeal(bufferData) 
    --播放下注音效
    ExternalFun.playSoundEffect("sound-jetton.mp3")


    self.timeOut_progress = bufferData.timeout
    self.deskState = GameViewLayer.STATE_LIANGPAI
    self.root:getChildByName("sp_waitCallFen"):setVisible(false)
    self.root:getChildByName("btn_callfen_panel"):setVisible(false) 
    self.root:getChildByName("str_thisChip"):setString(bufferData.chipnum)
    self.root:getChildByName("btn_tanpai"):setVisible(true)
    self.myCardData = bufferData.cards
--    --机器人帮助中
--    if self.robotState == true then
--        self:onClilcButton_tanpai()
--    end
    --下注动画
    self:xiazhuAction( bufferData.chipnum )
    self.chipnum = bufferData.chipnum
    --发牌动画
    for i = 1,2 do
        self:fapaiAction(i)
        ExternalFun.playSoundEffect("sound-fapai.mp3")
        self:showProgrssTimer( i )
    end    
    
end
--对方摊牌
function GameViewLayer:onEventCommit(bufferData)   
    if self.m_pProgressTimer[2] then
            self.m_pProgressTimer[2]:setVisible(false)
        end
    self.root:getChildByName("playerInfoPanel_2"):getChildByName("sp_liangpai"):setVisible(true)
end
--结算
function GameViewLayer:onEventGameover(bufferData)  
    self.root:getChildByName("btn_tanpai"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_1"):getChildByName("sp_liangpai"):setVisible(false)
    self.root:getChildByName("playerInfoPanel_2"):getChildByName("sp_liangpai"):setVisible(false)
    self.root:getChildByName("sp_pokerBg_1"):removeAllChildren()
    self.root:getChildByName("sp_pokerBg_2"):removeAllChildren() 
--    for key, playerInfo in ipairs(bufferData.infos) do
--        local user_panel = nil
--        if playerInfo == GlobalUserItem.tabAccountInfo.userid then
--            user_panel = self.root:getChildByName("playerInfoPanel_1")
--        else
--            user_panel = self.root:getChildByName("playerInfoPanel_2")
--        end
----        user_panel:getChildByName("str_goldNum"):setString(playerInfo.)
--    end
    for key, playerInfo in ipairs(bufferData.infos) do
        if playerInfo.uid == GlobalUserItem.tabAccountInfo.userid then
            self.jiesuanPokerValue[1] = playerInfo.cards
            self.myMoneyNum = self.myMoneyNum + playerInfo.final
            self.root:getChildByName("playerInfoPanel_1"):getChildByName("str_goldNum"):setString(self.myMoneyNum)
            self.historicalProNum = self.historicalProNum + playerInfo.final    --历史成绩
            self.lastProNum = playerInfo.final                                  --上一局的成绩
            local str_moneyLabel = nil
            if playerInfo.final > 0 then
                str_moneyLabel = self.root:getChildByName("playerInfoPanel_1"):getChildByName("str_winMoneyValue")
                str_moneyLabel:setString("+"..playerInfo.final)
            else
                str_moneyLabel = self.root:getChildByName("playerInfoPanel_1"):getChildByName("str_loseMoneyValue")
                str_moneyLabel:setString(playerInfo.final)
            end            
            str_moneyLabel:setVisible(true)
            str_moneyLabel:setScale(0.8)
            str_moneyLabel:runAction(cc.Sequence:create( cc.MoveBy:create(0.5,cc.p(0,150)),cc.DelayTime:create(3),cc.CallFunc:create(function()
                    str_moneyLabel:setVisible(false)
                    str_moneyLabel:setPosition(cc.p(100,100))
                end) ))
            self:fanpaiAction(1, playerInfo.type) 
        else
            self.jiesuanPokerValue[2] = playerInfo.cards
            self.otherMoneyNum = self.otherMoneyNum + playerInfo.final
            self.root:getChildByName("playerInfoPanel_2"):getChildByName("str_goldNum"):setString(self.otherMoneyNum)
            local str_moneyLabel = nil
            if playerInfo.final > 0 then
                str_moneyLabel = self.root:getChildByName("playerInfoPanel_2"):getChildByName("str_winMoneyValue")
                str_moneyLabel:setString("+"..playerInfo.final)
            else
                str_moneyLabel = self.root:getChildByName("playerInfoPanel_2"):getChildByName("str_loseMoneyValue")
                str_moneyLabel:setString(playerInfo.final)
            end            
            str_moneyLabel:setVisible(true)
            str_moneyLabel:setScale(0.8)
            str_moneyLabel:runAction(cc.Sequence:create( cc.MoveBy:create(0.5,cc.p(0,150)),cc.DelayTime:create(3),cc.CallFunc:create(function()
                    str_moneyLabel:setVisible(false)
                    str_moneyLabel:setPosition(cc.p(100,100))
                end) ))
            self:fanpaiAction(2, playerInfo.type) 
        end        
    end
    
end
--结束
function GameViewLayer:onEventDeskover(bufferData)
    
    self.deskState = GameViewLayer.STATE_ONZHUNBEI       
    if self.lastProNum>0 then
        ExternalFun.playSoundEffect("win.mp3")
        self.root:getChildByName("str_lastPro"):setString("+"..self.lastProNum)
    else
        ExternalFun.playSoundEffect("fail.mp3")
        self.root:getChildByName("str_lastPro"):setString(self.lastProNum)
    end
    self.root:getChildByName("str_historicalPro"):setString(self.historicalProNum)

    local callF1 = cc.CallFunc:create(function()
            local end_X,end_Y = 0,0
            if self.lastProNum > 0 then
                --筹码从自己面前飞出
                end_X = 320
                end_Y = 155
            else
                --筹码从对手面前飞出
                end_X = 420
                end_Y = 600
            end
            for key, chipSp in ipairs(self.chipSpriteTable) do
                chipSp:runAction(cc.Sequence:create(cc.MoveTo:create(1,cc.p(end_X,end_Y)),cc.CallFunc:create(function()
                        chipSp:removeFromParent()
                        table.remove(self.chipSpriteTable,key)
                    end)))
            end
            
        end)
    local callF2 = cc.CallFunc:create(function()
		                                    self.root:getChildByName("btn_start"):setVisible(true)
                                            self.root:getChildByName("str_thisChip"):setString("")
                                            self.root:getChildByName("playerInfoPanel_1"):getChildByName("sp_zhuang"):removeAllChildren()
                                            self.root:getChildByName("playerInfoPanel_2"):getChildByName("sp_zhuang"):removeAllChildren()                                          
                                            self.chipSpriteTable = {}
--                                            self.root:getChildByName("chipFly_panel"):removeAllChildren()
                                            --机器人帮助中
                                            if self.robotState == true then
                                                self:onClilcButton_Start()
                                            end
                                            self.root:getChildByName("sp_pokerBg_1"):removeAllChildren()
                                            self.root:getChildByName("sp_pokerBg_2"):removeAllChildren()
	                                    end)

    self:runAction(cc.Sequence:create(callF1,cc.DelayTime:create(1),cc.CallFunc:create(function ()
        self:chipFlyingAction()
    end),cc.DelayTime:create(3),callF2))

    self.timeOut_progress = bufferData
    for i = 1, 2 do
        self:showProgrssTimer( i )
    end   
    
end

--播放上庄动画_加载资源
function GameViewLayer.zhuangAction(node)
	
	local armature = ccs.Armature:create("errenniuniu4_zhuang")
    armature:setAnchorPoint(cc.p(0.5,0.5))
    armature:setPosition(cc.p(0,0))
	armature:addTo(node)
	armature:getAnimation():playWithIndex(0)
	return armature
end
 -- 发牌动画替换节点
GameViewLayer.vecCardBoneName = {
        {"up_color_1", "up_value_1", "down_color_1", "down_value_1"},
        {"up_color_2", "up_value_2", "down_color_2", "down_value_2"},
        {"up_color_3", "up_value_3", "down_color_3", "down_value_3"},
        {"up_color_4", "up_value_4", "down_color_4", "down_value_4"},
        {"up_color_5", "up_value_5", "down_color_5", "down_value_5"},
}
--播放发牌动画_加载资源
function GameViewLayer:fapaiAction(i)
    local pos = 1 == i and cc.p(20, 30) or cc.p(0,0)
	self.poker_Ani[i] = ccs.Armature:create("errenniuniu4_fapai")
    self.poker_Ani[i]:setAnchorPoint(cc.p(0,0))
    self.poker_Ani[i]:setPosition(pos)
	self.poker_Ani[i]:addTo(self.pokerNode_Ani[i])

    local strAniName = nil
    if i == 1 then
        strAniName = "Animation2"   -- 自己
    elseif i == 2 then
        strAniName = "Animation1"   -- 对家发牌
    elseif i == 3 then
        strAniName = "Animation3"   -- 对家翻牌
    end

    if i == 1 then
        for m = 1, 5 do
            local cardData = self.myCardData[m]
            for n = 1, 4 do
                local strBoneName = GameViewLayer.vecCardBoneName[m][n]
                self:replaceArmatureSprite(self.poker_Ani[1], strBoneName, cardData, (n-1)%2)
            end            
        end        
    end

	self.poker_Ani[i]:getAnimation():play(strAniName)

    --监听我的发牌动画完成
    if i == 1 then
        local animationEvent = function(armatureBack, movementType, movementID)
            if movementType == ccs.MovementEventType.complete 
            or movementType == ccs.MovementEventType.loopComplete
            then
                self:dispatchCardEnd()
            end
        end
        self.poker_Ani[i]:getAnimation():setMovementEventCallFunc(animationEvent)
    end
end

function GameViewLayer:replaceArmatureSprite(m_pArmature, boneName, cbCardData, typeNum)
    if not m_pArmature then return end
    local color = math.floor(cbCardData/13)
    local value = cbCardData%13+1
    local strFrame = (typeNum == 0) and string.format("color-%d.png",color) or string.format("value-%d-%d.png",value,color%2)
    if cbCardData == 52 or cbCardData == 53 then
        strFrame = "game/twoniuniu/gui/gui-texture-null.png"
    end
    local pBone = m_pArmature:getBone(boneName)
    local pManager = pBone:getDisplayManager()
    local vecDisplay = pManager:getDecorativeDisplayList()
    for k,v in pairs(vecDisplay) do
        if v then
            local spData = v:getDisplay()
            spData = tolua.cast(spData, "cc.Sprite")
            if spData then
                spData:setSpriteFrame(strFrame)
            end
            if cbCardData == 52 or cbCardData == 53 then
                spData:setSpriteFrame(strFrame)
            end
        end
    end
    
    if boneName == "up_color_1" or boneName == "up_color_2" or boneName == "up_color_3" or boneName == "up_color_4" or boneName == "up_color_5" then
        if cbCardData == 52 then
            local dxw = cc.Sprite:create()
            dxw:setSpriteFrame("value-53.png")
            dxw:setPosition(cc.p(40,-15))
            pBone:addDisplay(dxw,0)
        elseif cbCardData == 53 then
            local dxw = cc.Sprite:create()
            dxw:setSpriteFrame("value-54.png")
            dxw:setPosition(cc.p(40,-15))
            pBone:addDisplay(dxw,0)
        end
    end
end
--发牌完成
function GameViewLayer:dispatchCardEnd( dt)

    --机器人帮助中
    if self.robotState == true then
        self:onClilcButton_tanpai()
    end
end
--翻牌动画
function GameViewLayer:fanpaiAction( i,itype )
    for n = 1,5 do
        local cbCardData = self.jiesuanPokerValue[i][6-n]
        local color = math.floor(cbCardData/13)
        local value = cbCardData%13+1

        self.jiesuanPokerSprite[i][n] = Poker:create()
        self.jiesuanPokerSprite[i][n]:setCardData(color, value)
        local pos = GameViewLayer.POKERPOS[i][n]
        self.jiesuanPokerSprite[i][n]:setPosition(pos)
        if itype == 0 then
            if i == 1 then
                self.jiesuanPokerSprite[i][n]:setPositionY(-270)                
            elseif i == 2 then
                self.jiesuanPokerSprite[i][n]:setPositionY(185)
            end            
        end
        self.pokerNode_Ani[i]:addChild(self.jiesuanPokerSprite[i][n])
        if i == 2 then
            self.jiesuanPokerSprite[i][n]:setScale(0.8)
        end
    end
    local niuTypeSp = cc.Sprite:create()
    niuTypeSp:setSpriteFrame(string.format("game/twoniuniu/gui/gui-tniuniu-niu-%d.png",itype))
    
    niuTypeSp:addTo(self.pokerNode_Ani[i])
    niuTypeSp:setAnchorPoint(cc.p(0.5,-0.3))
    niuTypeSp:setPosition(GameViewLayer.POKERPOS[i][4])
    if i == 2 then
        niuTypeSp:setScale(0.8)
        niuTypeSp:runAction(cc.Sequence:create( cc.ScaleTo:create(0.1,1),cc.ScaleTo:create(0.1,0.8) ))
    else
        niuTypeSp:runAction(cc.Sequence:create( cc.ScaleTo:create(0.1,1.2),cc.ScaleTo:create(0.1,1) ))
        ExternalFun.playSoundEffect(string.format("N%d_1.mp3",itype))
    end
end
--筹码
GameViewLayer.chipNUM = {
        1000000,100000,10000,1000,100,10,1
}
GameViewLayer.chipSpRec = {
        "niuniu/chip/game-jetton-100w.png",
        "niuniu/chip/game-jetton-10w.png",
        "niuniu/chip/game-jetton-1w.png",
        "niuniu/chip/game-jetton-1000.png",
        "niuniu/chip/game-jetton-100.png",
        "niuniu/chip/game-jetton-10.png",
        "niuniu/chip/game-jetton-1.png"
}

function GameViewLayer:xiazhuAction( value )
    local beginX,beginY,end_X,end_Y = 0,0,0,0
    if self.bankerUid ~= GlobalUserItem.tabAccountInfo.userid then
        --筹码从自己面前飞出
        beginX = 400
        beginY = 150
    else
        --筹码从对手面前飞出
        beginX = 580
        beginY = 480
    end
    
    local chipNumTable = GameViewLayer.chipNUM  --筹码从大到小的数组
    local chipValue = value                     --下注额

    local chipNumber = 0    --创建筹码精灵的个数
    for i = 1, #chipNumTable do
        local num = math.floor( chipValue/chipNumTable[i] )
        if num >= 30 then 
            num = 30 
        end
        chipNumber = chipNumber + num
        if chipNumber > 30 then break end
        for n = 1, num do
            local spJetton = cc.Sprite:createWithTexture(self.chipImageRes[i])
            self.root:getChildByName("chipFly_panel"):addChild(spJetton)
            spJetton:setPosition(cc.p(beginX,beginY))
            spJetton:setScale(0.6)
            table.insert(self.chipSpriteTable, spJetton)
        end
        chipValue = chipValue - chipNumTable[i] * num
    end
    
    for key, chipSp in ipairs(self.chipSpriteTable) do
        end_X = math.random(515, 870)
        end_Y = math.random(330, 420)
        chipSp:runAction( cc.Sequence:create( cc.MoveTo:create(0.5,cc.p(end_X,end_Y)),cc.JumpTo:create(1 , cc.p(end_X,end_Y) , 20 , 0.1) ) )
    end    
end
--结算时从玩家头像飞出的筹码
function GameViewLayer:chipFlyingAction( value )
    local beginX,beginY,end_X,end_Y = 0,0,0,0
    if self.lastProNum > 0 then
        --筹码从对手面前飞出
        beginX = 420
        beginY = 600
        end_X = 320
        end_Y = 155
    else
        --筹码从自己面前飞出
        beginX = 320
        beginY = 155
        end_X = 420
        end_Y = 600        
    end
    
    local chipSpriteTable_ = {}
    local chipNumTable = GameViewLayer.chipNUM  --筹码从大到小的数组
    local chipValue = math.abs( self.lastProNum ) - self.chipnum                    --下注额
    if chipValue <= 0 then
        return
    end
    local chipNumber = 0    --创建筹码精灵的个数
    for i = 1, #chipNumTable do
        local num = math.floor( chipValue/chipNumTable[i] )
        if num >= 30 then 
            num = 30 
        end
        chipNumber = chipNumber + num
        if chipNumber > 30 then break end
        for n = 1, num do
            local spJetton = cc.Sprite:createWithTexture(self.chipImageRes[i])
            self.root:getChildByName("chipFly_panel"):addChild(spJetton)
            spJetton:setPosition(cc.p(beginX,beginY))
            spJetton:setScale(0.6)            
            table.insert(chipSpriteTable_, spJetton)
        end
        chipValue = chipValue - chipNumTable[i] * num
    end
    local flyTimes = 0
    local tabNumber = #chipSpriteTable_
    local scheduleUpdata = function () 
        if flyTimes < tabNumber then
            chipSpriteTable_[tabNumber-flyTimes]:runAction(cc.Sequence:create( cc.MoveTo:create(0.5,cc.p(end_X,end_Y)),cc.CallFunc:create(function ()            
            end) ))
        else
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.chipFlyAction_)
            self.chipFlyAction_ = nil
            for key, var in ipairs(chipSpriteTable_) do
                var:removeFromParent()
                table.remove(chipSpriteTable_,key)
            end           
        end
        flyTimes = flyTimes+1
    end
    self.chipFlyAction_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                scheduleUpdata()
            end, 0.05, false)      
end
--玩家头像进度条
function GameViewLayer:showProgrssTimer( i)
    if i < 1 or i > 2 then return end

    if not self.m_pProgressTimer[i] then
        self.m_pProgressTimer[i] = ProgressNode.create()
        if not self.m_pProgressTimer[i] then return end
        self.m_pProgressTimer[i]:setPosition(cc.p(self.m_pProgressBg[i]:getContentSize().width*0.5, self.m_pProgressBg[i]:getContentSize().height*0.5))

        self.m_pProgressBg[i]:addChild(self.m_pProgressTimer[i])
    end
    
    local countTime = 0 
    local gameStatus = self.deskState
    if self.deskState == GameViewLayer.STATE_ONZHUNBEI then
        countTime = self.timeOut_progress
    elseif self.deskState == GameViewLayer.STATE_QIANGZHUANG then
        countTime = self.timeOut_progress
    elseif self.deskState == GameViewLayer.STATE_XIAZHU then
        countTime = self.timeOut_progress
    elseif self.deskState == GameViewLayer.STATE_LIANGPAI then
        countTime = self.timeOut_progress
    end

    self.m_pProgressTimer[i]:setParameters(countTime,cc.c3b(255,255,255), 100)
    self.m_pProgressTimer[i]:setVisible(true)
    self.m_pProgressBg[i]:setVisible(true)

    self.m_pProgressTimer[i]:startCount()
end
-------------------------------------------------------分界线-------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------- 分界线 --------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------


function GameViewLayer:getParentNode()
    return self._scene
end






function GameViewLayer:unloadResource()
    if self.chipFlyAction_ then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.chipFlyAction_)
        self.chipFlyAction_ = nil
    end
    
    for i = 1,2 do
        if self.m_pProgressTimer[i] then
            self.m_pProgressTimer[i]:removeFromParent()
        end
    end
    self.root:getChildByName("chipFly_panel"):removeAllChildren()
    self.root:getChildByName("playerInfoPanel_1"):getChildByName("sp_icon"):removeAllChildren()
    self.root:getChildByName("playerInfoPanel_2"):getChildByName("sp_icon"):removeAllChildren()

    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("niuniu/effect/errenniuniu4_zhuang/errenniuniu4_zhuang.ExportJson")
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("niuniu/effect/errenniuniu4_fapai/errenniuniu4_fapai.ExportJson")
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("niuniu/plist/tniuniu-poker.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("niuniu/plist/tniuniu-poker.png")
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("niuniu/plist/gui-poker-1.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("niuniu/plist/gui-poker-1.png")
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("niuniu/plist/twoniuniu.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("niuniu/plist/twoniuniu.png")
    for key, res_ in ipairs(GameViewLayer.chipSpRec) do
        cc.Director:getInstance():getTextureCache():removeTextureForKey(res_)
    end
        
    self.root:getChildByName("bg"):removeAllChildren()

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