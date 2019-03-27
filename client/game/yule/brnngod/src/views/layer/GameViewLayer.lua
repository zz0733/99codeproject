-- 百人牛牛
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local module_pre = "game.yule.brnngod.src"
local cmd = appdf.req(module_pre .. ".models.CMD_Game")
local Define = appdf.req(module_pre .. ".models.Define")
local helper = appdf.req(module_pre .. ".models.helper")
local Brnn_Res = appdf.req(module_pre .. ".models.BRNN_Res")
local GameRoleItem = appdf.req(module_pre .. ".views.layer.GameRoleItem")
local HeadSprite = require(appdf.EXTERNAL_SRC .. "HeadSprite")
local CardSprite = appdf.req(module_pre .. ".views.layer.gamecard.CardSprite")
local CardsNode = appdf.req(module_pre .. ".views.layer.gamecard.CardsNode")
local GameLogic = appdf.req(module_pre .. ".models.GameLogic")
local GameResultLayer = appdf.req(module_pre .. ".views.layer.GameResultLayer")
local SettingLayer = appdf.req(module_pre .. ".views.layer.SettingLayer")
local JettonItem = appdf.req(module_pre..".views.layer.JettonItem")

local Handredcattle_Const   = appdf.req(module_pre .. ".views.layer.handClasses.Handredcattle_Const")
local HandredcattleRes      = appdf.req(module_pre .. ".views.layer.handClasses.HandredcattleRes")
local Poker                 = appdf.req(module_pre .. ".views.layer.gamecard.Poker")
local HandredcattleOtherInfoLayer = appdf.req(module_pre .. ".views.layer.HandredcattleOtherInfoLayer")

local TAG_ENUM = Define.TAG_ENUM
local TAG_ZORDER = Define.TAG_ZORDER
local _ = {}


local GameViewLayer = class("GameViewLayer",function(scene)
        local gameViewLayer = display.newLayer()
    return gameViewLayer
end)

GameViewLayer.BEILV = 4         --赔付倍率
--玩家当前状态
GameViewLayer.STATE_WAIT_GAME = 0      --等待开始
GameViewLayer.STATE_PLAYERBETS = 1      --闲家下注
GameViewLayer.STATE_DESKOVER = 2        --结束阶段
GameViewLayer.STATE_FREETIME = 3        --空闲阶段
local myUID = GlobalUserItem.tabAccountInfo.userid  --自己的id
GameViewLayer.CHIP_VALUE = { 100,1000,10000,100000,1000000,10000000 }
local PokerConst = {
        PokerScale              = 0.5, --扑克显示缩放比例
        PokerSpace              = 24,  --两张扑克水平间距
        PokerAniHalfTime        = 0.2, --翻牌动画时间  前半段
        PokerAniRemainTime      = 0.3, --翻牌动画时间  后半段
    }
local openCardOrder = {2, 3, 4, 5, 1} -- 开牌顺序 1是庄家
local CHIP_FLY_STEPDELAY            = 0.02  --筹码连续飞行间隔
local CHIP_FLY_TIME                 = 0.2   --飞筹码动画时间
local CHIP_JOBSPACETIME             = 0.2   --飞筹码任务队列间隔
local CHIP_FLY_SPLIT                = 20    -- 飞行筹码分组 分XX次飞完
local CHIP_ITEM_COUNT               = 4     --下注项数
local STR_CHIP_NUM_RES                  = "game/handredcattle/chip/num-%d.png" 

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

     --加载资源
     self:loadResource()

--    --初始化界面
--    self:initViewLayer()
    
end

function GameViewLayer:onEnter()

    -- 首次进入，显示帮助
    local firstEnter = cc.UserDefault:getInstance():getStringForKey("first_enter_niuniu", "1")
    if tonumber(firstEnter) == 1 then
        cc.UserDefault:getInstance():setStringForKey("first_enter_niuniu", "0")
        local CommonRule = appdf.req(module_pre .. ".views.layer.RuleLayer")
        local pRule = CommonRule:create()
        pRule:addTo(self.m_pNodeDlg, 100)
        pRule:showPopup()
    end
end

function GameViewLayer:loadResource()
    ExternalFun.playBackgroudAudio("Game.mp3")
    local rootLayer, csbNode = ExternalFun.loadRootCSB("game/handredcattle/HandredcattleSceneLayer.csb", self)
    self.m_pathUI = csbNode
    --iphoneX适配
    if LuaUtils.isIphoneXDesignResolution() then
        local width_ = yl.WIDTH - display.size.width
        self.m_pathUI:setPositionX(self.m_pathUI:getPositionX() - width_/2)
    end

    for i = 1,3 do      --加载碎图组资源
        cc.SpriteFrameCache:getInstance():addSpriteFrames(HandredcattleRes.vecReleasePlist[i][1],HandredcattleRes.vecReleasePlist[i][2])
    end
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(HandredcattleRes.JSON_OF_JIEDUAN)          --阶段提示动画
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(HandredcattleRes.JSON_OF_WIN)              --赢动画
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(HandredcattleRes.JSON_OF_DAOJISHI)         --倒计时动画
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(HandredcattleRes.JSON_OF_PAIXING)          --牌型动画
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(HandredcattleRes.JSON_OF_BGNV)             --轮滑女动画
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(HandredcattleRes.JSON_OF_DENGDAI)          --等待阶段动画
--    self.chipImageBgRes = {}  --筹码背景
--    self.chipImageNumRes = {}  --筹码背景
--    for key, res_ in ipairs(HandredcattleRes.vecChipImage_bg) do
--        local chipSpriteFrame = cc.Director:getInstance():getTextureCache():addImage(res_)
--        table.insert(self.chipImageBgRes,chipSpriteFrame)
--    end
    
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    local this = self
    

    self:initVar()
    self:initCCB()
    self._ClockFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                this:updateClockNode()
            end, 1, false)
    

    self:initNode()
    self:initGame()
    if Define.W_Bg_Effect ~= 0 then
        self:playwBgEffect()
    end
--    self:startGameEvent()
--    self:initEvent()
--    self:initUpdate()
end
function GameViewLayer:initVar()
    self.isOpenMenu                 = false
    self.isMusicSound               = true
    self.isEffectSound              = true
    self.isPlayingZuoZhuang         = false
    self._bIsShowSelfHeadAtTable    = false
    self.m_nLastZhuangId            = INVALID_CHAIR
    self.nIndexChoose               = 0
    self.m_pStatu                   = nil
    self._bIsPlayClock              = false
    self._bIsPlayDaojishi           = false
    self.pChatNoticeEffect          = nil
    self.m_vecSpriteOther           = {}
    self._bIsPlaySound              = false
    self.m_isPlayBetSound           = false -- 其他人下注筹码音效播放状态
    self.movementNames              = {}
    self.movementNames1             = {}
    self.m_pSendCardsArmatures      = {}
    self.m_nCardsIndex              = 0
    self.m_nPlayersIndex            = 0
    self.m_vecSpriteSelf            = {}
    self.m_vecSpriteTableUser       = {}
    for i = 1, cmd.TABEL_USER_COUNT do
        self.m_vecSpriteTableUser[i] = {}
    end

    self.m_pLbMyBettingGold         = {}
    self.m_pLbBettingGold           = {}
    self.m_pControlButtonJetton     = {}
    self.m_pControlButtonAnimal     = {}
    self.m_pWinEffect               = {}
    self.cardSp                     = {}
    for i = 1, 5 do
        self.cardSp[i]              = {}
    end
    self.m_pAnimWin                 = {}
    self.m_nodeNVPos                = {}

    self.cardPos                    = {}
    self.pokerPos                   = {}
    self.pokerPathPos               = {}
    self.m_othersPos                = nil
    self.m_selfPos                  = nil
    self.m_bankPos                  = cc.p(391,678)
    self.m_flyJobVec                = {}


    self.m_pNodeTablePlayer         = {}
    self.m_pSpHeadIcon              = {}
    self.m_pSpNoPlayer              = {}
    self.m_pSpHistory               = {}
    self.m_pSpStar                  = {}
    self.m_pSpWinArea               = {}
    self.m_pParticleStar            = {}
    self.m_pNodeShowPlayer          = {}
    self.m_pLbShowPlayerName        = {}
    self.m_pLbShowPlayerGold        = {}
    self.m_pLbTableResultGold       = {}
    self.m_userBtnVec               = {}
    self.m_userBtnResPosVec         = {}
    self.m_pBtnUserInfo             = {}
    self.m_changeUserAniVec         = {}            --上桌玩家切换时动画
    --上一桌玩家列表
    self.m_vecTableUserIdLast       = {}


    self.chips = {}                     --本房间游戏筹码
    self.deskState = GameViewLayer.STATE_WAIT_GAME    --牌局状态    
    self.playerInfoTable = {}           --玩家列表
    self.bankersTable = {}              --上庄玩家列表
    self.bankerUid = nil                --庄家id
    self.isWaitBanker = false           --是否等待玩家上庄
    self.isUpBanker = false             --是否加入上庄列表
    self.banker_time = 0                --连庄次数
    self.allBetMoney = 0                --当前4个区域下的钱总和
    self.histroyTable = {}              --历史记录走势
    self.time_djs = 20                  --倒计时
    self.tdxhTable = {}                 --天地玄黄四个区域 self.tdxhTable[1]["allMoney"],self.tdxhTable[1]["myMoney"],self.tdxhTable[1]["chip_sprite"]
    for i = 1, 4 do
        self.tdxhTable[i] = {}
    end
    self.myIntoMoney = 0                --身上携带的钱
    self.allRemainngBet = 20000000      --剩余可下注的钱数
    self.lastMyBet = {}                 --我上把的投注
    for i = 1, 4 do
        self.lastMyBet[i] = 0
    end
    self.myJjj = 0  --玩家自己下注的总钱数
    --发牌动画用的变量
    self.Pokers = {}
    self.startScale = 0.17
    self.disNum = 0.05
    self.flyDt = 0.35
    self.moveDt = 0.2
    self.allDt = self.disNum + self.flyDt + self.moveDt + PokerConst.PokerAniHalfTime + PokerConst.PokerAniRemainTime
    self.pathPos = {}
    self.targetPos = {}
    self.cardTypeAni = {}
    self.pokerData = {}
    self.num0 = 0

    self.m_seats = {}

    self.m_layerOtherUserInfo = nil
    self.m_layerTrend = nil
    self.m_layerDealerQueue = nil
end
--ui对象引用初始化
function GameViewLayer:initCCB()
    ------------node---------------
--    self.m_pTalkNode            = ccui.Helper:seekWidgetByName(self.m_pathUI, "Node_talk")
    self.m_rootNode             = self.m_pathUI:getChildByName("Panel_node_base")   --父节点   
        --筹码层
    self.m_pNodeChipSpr         = self.m_rootNode:getChildByName("Panel_node_chip")
        --需要播入场动画
    self.m_pNodeMiddle          = self.m_rootNode:getChildByName("Panel_node_middle")       --天地玄黄信息
    self.m_pNodeTopInfo         = self.m_rootNode:getChildByName("Panel_node_top_info")     --庄家信息panel
    self.m_pNodeBottomButton    = self.m_rootNode:getChildByName("Panel_node_bottom_button")    --下注按钮panel
    self.m_pNodeTopButton       = self.m_pathUI:getChildByName("Panel_node_top")        --退出按钮panel
    self.m_pNodeTopClock        = self.m_pathUI:getChildByName("Panel_node_clock")      --倒计时panel
    
    self.m_pNodeTopRight        = self.m_pathUI:getChildByName("Panel_node_top_right")
    self.m_pNodeBottomInfo      = self.m_pathUI:getChildByName("Panel_node_bottom")     --自身信息panel
    self.m_pSpRoomTable         = self.m_rootNode:getChildByName("Sprite_room_table")   --桌子背景
        ----
--    self.m_pSenderCardsNode     = self.m_pathUI:getChildByName("Panel_node_sendCard")
    self.m_pRootNodeMenu        = self.m_pathUI:getChildByName("Panel_node_menu")       --菜单层
    self.m_pNodeTip             = self.m_pathUI:getChildByName("Panel_node_tip")        --飘出来的字（换庄，输赢金币等），轮滑女飘逸轨迹
    self.m_pNodeClipMenu        = self.m_pathUI:getChildByName("Panel_node_clip")       --关闭菜单层
    self.m_pNodeDlg             = self.m_pathUI:getChildByName("Panel_dialog") 
    --self.m_pNodeTrend           = self.m_pathUI:getChildByName("Panel_node_trend")      --趋势，走向层
    ------------text---------------
    self.m_pLbUsrGold           = self.m_pNodeBottomInfo:getChildByName("Node_usergold"):getChildByName("TXT_player_gold_num")  --用户自己的金币数量
    self.m_pLbZhuangHead        = self.m_pNodeTopInfo:getChildByName("Sprite_zhuang_head")     --庄家头像
    self.m_pLbZhuangGold        = self.m_pNodeTopInfo:getChildByName("TXT_zhuang_gold")     --庄家金币数量
    self.m_pLbAskNum            = self.m_pNodeTopInfo:getChildByName("TXT_ask_num")         --申请上庄人数
    --self.m_pLbResultGold        = self.m_pNodeTip:getChildByName("TXT_result_gold")

    self.m_pLbResultSelf        = self.m_pNodeTip:getChildByName("TXT_result_goldself")     --自己飘的结算结果
    self.m_pLbResultOther       = self.m_pNodeTip:getChildByName("TXT_result_goldother")    --其他玩家飘的结算结果
    self.m_pLbResultBanker      = self.m_pNodeTip:getChildByName("TXT_result_goldbanker")   --庄家飘的结算结果

    for i = 1, Handredcattle_Const.DOWN_COUNT_HOX  do -- 初始化4个玩家的区域
        self.m_pLbMyBettingGold[i]  = self.m_pNodeMiddle:getChildByName( string.format("node_bet_%d",i)):getChildByName("TXT_my_bet_num")   --我在该区域的下注钱数
        self.m_pLbBettingGold[i]    = self.m_pNodeMiddle:getChildByName( string.format("node_bet_%d",i)):getChildByName("TXT_bet_num")      --该区域下注钱数
    end
    self.m_pLbCountTime         = self.m_pNodeTopClock:getChildByName("TXT_count_time")        --倒计时
    self.m_pSpStatus            = self.m_pNodeTopClock:getChildByName("Image_status")          --现在房间状态（倒计时）
    self.m_pLbTotalBetting      = self.m_pNodeMiddle:getChildByName("node_info"):getChildByName("TXT_total_betting")    --已下注的总钱数
    self.m_pLbRemaingBetting    = self.m_pNodeMiddle:getChildByName("node_info"):getChildByName("TXT_remain_betting")   --剩余可下注总钱数
    ------------Sprite-------------
    self.m_pNodeMenu        = self.m_pRootNodeMenu:getChildByName("IMG_menu_bg")        --菜单
    self.m_pLianzhuangImage = self.m_pNodeTip:getChildByName("Sprite_lianzhuang")       --庄家轮换
    ------------Button-------------
    for i = 1, Handredcattle_Const.JETTON_ITEM_COUNT do
        local btn = self.m_pNodeBottomButton:getChildByName( string.format("BTN_jetton_%d",i))     --下注的按钮
        self.m_pControlButtonJetton[i] = JettonItem:create(self, btn, i)
    end
    for i = 1, Handredcattle_Const.DOWN_COUNT_HOX  do
        self.m_pControlButtonAnimal[i] = self.m_pNodeMiddle:getChildByName( string.format("node_bet_%d",i)):getChildByName("BTN_bet")   --天地玄黄按钮
    end
    self.m_pBtnClearBet     = self.m_pNodeBottomButton:getChildByName("BTN_clear_bet")      --资源同续投
    self.m_pBtnClearBet:setVisible(false)
    self.m_pBtnContinue     = self.m_pNodeBottomButton:getChildByName("BTN_continue")       --续投
    self.m_pDealerBtn       = self.m_pNodeTopInfo:getChildByName("BTN_dealer")              --上庄&下注&查看庄列表按钮
    self.m_pImageBeZhuang   = self.m_pDealerBtn:getChildByName("Image_be_zhuang")         --上庄图片
    self.m_pImageCancelZhuang       = self.m_pDealerBtn:getChildByName("Image_cancel_zhuang")     --取消上庄
    self.m_pImageCheckZhuangList    = self.m_pDealerBtn:getChildByName("Image_check_zhuang_list") --查看上庄列表
    --self.m_pRecordBtn       = self.m_pNodeTopRight:getChildByName("BTN_record")
    self.m_pRuleBtn         = self.m_pNodeMenu:getChildByName("BTN_rule")                   --规则
    self.m_pBankmenuBtn     = self.m_pNodeMenu:getChildByName("BTN_menubank")               --保险箱
    self.m_pBankmenuBtn:setTouchEnabled(false)
    self.m_pBankmenuBtn:setColor(cc.c4b(100,100,100,100))
    self.m_pBankBtn         = self.m_pNodeBottomInfo:getChildByName("BTN_bank")             --银行（添加金币）
    self.m_pBankBtn:setTouchEnabled(false)
    self.m_pBankBtn:setColor(cc.c3b(100,100,100))
--    self.m_pChatBtn     = ccui.Helper:seekWidgetByName(self.m_pathUI, "BTN_chat")
    self.m_pBtnMenuPop      = self.m_pNodeTopButton:getChildByName("BTN_menu_pop")                --菜单
    self.m_pBtnTrend        = self.m_pNodeTopButton:getChildByName('BTN_trend')             --走势按钮
    self.m_pImageArrow      = self.m_pBtnMenuPop:getChildByName('Image_arrow')              --菜单按钮上的箭头图片
    self.m_pBtnMenuPush     = self.m_pNodeClipMenu:getChildByName("BTN_bg")
    self.m_pBtnReturn       = self.m_pNodeMenu:getChildByName("BTN_return")            --退出按钮
    self.m_pBtnSetting      = self.m_pNodeMenu:getChildByName("BTN_setting")                  --音效
    self.m_pBtnButtonMark   = self.m_pNodeMenu:getChildByName("BTN_button_mark")              --遮盖层按钮
    self.m_pBtnButtonMark:setVisible(false)

    --self.m_pVoiceBtn        = self.m_pNodeMenu:getChildByName("BTN_music")                  --音乐
    self.m_pBtnOtherInfo    = self.m_pNodeBottomInfo:getChildByName("BTN_other_player")     --其他玩家
    self.m_pLbOtherNum      = self.m_pBtnOtherInfo:getChildByName("TXT_other_num")          --其他玩家人数
    ------------AnimNode-----------
    self.m_pAnimNV          = self.m_rootNode:getChildByName("Arm_node_nv")
    self.m_pNodeShowResult  = self.m_pathUI:getChildByName("Panel_node_anim")

    self.m_pNodeCard        = self.m_rootNode:getChildByName("Node_cardani")

    ------自己信息------
    self.m_pSelfHead        = self.m_pNodeBottomInfo:getChildByName("Sprite_self_head")      --自己头像


    -- 新增其他玩家头像
    self.m_pNodePlayer = self.m_pathUI:getChildByName("Panel_player")
    self.m_pNodeOnliePlayer = self.m_pNodePlayer:getChildByName("Node_onliePlayer")

    for i=1, cmd.TABEL_USER_COUNT do
        self.m_pNodeTablePlayer[i] = self.m_pNodePlayer:getChildByName(string.format("Node_tablePlayer%d",i))
        self.m_pSpNoPlayer[i] = self.m_pNodeTablePlayer[i]:getChildByName("Sprite_noBody")
        self.m_pNodeShowPlayer[i] = self.m_pNodeTablePlayer[i]:getChildByName("Node_showPlayer")
        self.m_pLbTableResultGold[i] = self.m_pNodeTablePlayer[i]:getChildByName("BitmapFontLabel_result")
        self.m_pLbTableResultGold[i]:setVisible(false)
        self.m_userBtnVec[i] = self.m_pNodeShowPlayer[i]:getChildByName("Button_userInfo")
        self.m_userBtnResPosVec[i] = cc.p(self.m_userBtnVec[i]:getPosition())
        self.m_pSpHeadIcon[i] = self.m_userBtnVec[i]:getChildByName("Sprite_head")
        self.m_pSpHeadIcon[i]:setVisible(false)
        self.m_pLbShowPlayerName[i] = self.m_pNodeShowPlayer[i]:getChildByName("Text_showPlayer_name")
        self.m_pLbShowPlayerGold[i] = self.m_pNodeShowPlayer[i]:getChildByName("Text_showPlayer_gold")
        self.m_pBtnUserInfo[i] = self.m_pNodeShowPlayer[i]:getChildByName("Button_userInfo")

        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(Brnn_Res.ANI_OF_CHANGEUSER.FILEPATH)
        self.m_changeUserAniVec[i] = ccs.Armature:create(Brnn_Res.ANI_OF_CHANGEUSER.FILENAME)
        self.m_changeUserAniVec[i]:addTo(self.m_userBtnVec[i]:getChildByName("Node_ani"))
        self.m_changeUserAniVec[i]:setTag(255)
    end
    
    self:initPokerFly()

    self:initBtnClickEvent()
end
--发牌动画的数据
function GameViewLayer:initPokerFly( )
    for i = 1, 5 do
        --存放扑克
        self.Pokers[i] = {}
        for n = 1 ,5 do
            self.Pokers[i][n] = nil
        end
        --扑克坐标
        local cardPos = self.m_pNodeCard:getChildByName(string.format("card_pos_%d",i))
        self.targetPos[i] = cc.p(cardPos:getPosition())
        --扑克移动曲线节点
        local tempNode = self.m_pNodeCard:getChildByName(string.format("card_path_node_%d",i))
        self.pathPos[i] = cc.p(tempNode:getPosition())
    end
    --扑克创建初始坐标
    self.startPos = cc.p(self.m_pNodeCard:getChildByName("card_start_pos"):getPosition())
    
    self.m_cbend = function ()
        ----self:playWinEffect()------暂时屏蔽赢牌动画
        self:playTongEffect()------播放通杀和通赔效果
        self:checkMyJetton()
        self:flychipex()
    end

    self.m_othersPos = cc.p(self.m_pBtnOtherInfo:getPositionX() , self.m_pBtnOtherInfo:getPositionY())
    self.m_selfPos = cc.p(self.m_pNodeBottomInfo:getPositionX() + 50, 33.5)
end

function GameViewLayer:initNode()
    ------self:initClipNode()
--    self:initClockNode()
    self:initMenuView()
--    self:playInGameEffect()
    --[[不显示上庄需...
    local minBankerScore = HoxDataMgr.getInstance():getMinBankerScore()
--    local forMinBankerGold = string.format(LuaUtils.getLocalString("STRING_160"), LuaUtils.getFormatGoldAndNumber(minBankerScore))
    local m_pLbBankerGoldNeed = ccui.Helper:seekWidgetByName(self.m_pathUI, "TXT_banker_gold_need") 
    m_pLbBankerGoldNeed:setString(LuaUtils.getFormatGoldAndNumber(minBankerScore)) --forMinBankerGold)
    --]]
    self.m_pAniStartPos = cc.p(self.m_pNodeCard:getChildByName("card_start_pos"):getPosition())
    for i = 1, 5 do
        self.cardPos[i] = self.m_pNodeCard:getChildByName(string.format("card_pos_%d",i))
        self.pokerPos[i] = cc.p(self.cardPos[i]:getPosition())      --牌的位置

        --移动曲线节点
        local tempNode = self.m_pNodeCard:getChildByName(string.format("card_path_node_%d",i))
        self.pokerPathPos[i] = cc.p(tempNode:getPosition())         --发牌第一个移动到的点
    end
    --滑板女动画轨迹节点
    for i = 1,6 do
        local node = self.m_pNodeTip:getChildByName("Node_nv_" .. i)
        self.m_nodeNVPos[i] = cc.p(node:getPosition())
    end

    local endcb = function()
        self:playWinEffect()
        self:checkMyJetton()
        self:flychipex()
    end
    --轮滑女
    local lunhua = ccs.Armature:create(HandredcattleRes.ANI_OF_BGNV)
    lunhua:setAnchorPoint(cc.p(0.5,1))
    lunhua:setPosition(cc.p(-30,60))
	lunhua:addTo(self.m_pAnimNV)
	lunhua:getAnimation():playWithIndex(0)
--    HandredcattlePokerMgr.getInstance():releaseInstance()
--    HandredcattlePokerMgr.getInstance():setAnimData(self.m_pNodeCard, self.m_pAniStartPos, self.pokerPos, self.pokerPathPos, endcb)

--    --显示房号
--    if PlayerInfo.getInstance():getIsShowRoomNo() then
--        local modeType = HoxDataMgr.getInstance():getModeType()
--        local nRoomNo = PlayerInfo.getInstance():getCurrentRoomNo()
--        local pos = cc.p(self.m_pBtnReturn:getPosition())
--        local m_pLbRoom = cc.Label:createWithBMFont("public/font/11.fnt", string.format("%d倍场\n%d号房", modeType, nRoomNo))
--        m_pLbRoom:setDimensions(100, -1)
--        m_pLbRoom:setAlignment(cc.TEXT_ALIGNMENT_CENTER) -- 单行文字 居中显示
--        m_pLbRoom:setAnchorPoint(cc.p(0.5, 0.5))
--        m_pLbRoom:setPosition(cc.p(pos.x - 1, pos.y - 70))
--        m_pLbRoom:addTo(self.m_pNodeTopButton)
--    end

    
end

-- 初始化弹出菜单剪切区域
function GameViewLayer:initClipNode()
    local shap = cc.DrawNode:create()
    local pointArr = {cc.p(0,300), cc.p(400, 300), cc.p(400, 650), cc.p(0, 650)}
    shap:drawPolygon(pointArr, 4, cc.c4f(255, 255, 255, 255), 2, cc.c4f(255, 255, 255, 255))
    self.m_pClippingMenu = cc.ClippingNode:create(shap)

    self.m_pClippingMenu:setPosition(cc.p(1095,0))
    self.m_pNodeClipMenu:addChild(self.m_pClippingMenu)
    self.m_pNodeMenu:removeFromParent()
    self.m_pClippingMenu:addChild(self.m_pNodeMenu)
end
--更新倒计时
function GameViewLayer:updateClockNode()  
    local ttt = 0
    self.time_djs,ttt = math.modf(self.time_djs/1)
    if self.time_djs<0 then
        self.time_djs = 0
    end
    if self.deskState == GameViewLayer.STATE_WAIT_GAME then         -- = 0      --等待开始
        self.m_pSpStatus:loadTexture("game/handredcattle/image/brnn_zt_1.png", ccui.TextureResType.localType)
    elseif self.deskState == GameViewLayer.STATE_PLAYERBETS then    -- = 1      --闲家下注
        self.m_pSpStatus:loadTexture("game/handredcattle/image/brnn_zt_2.png", ccui.TextureResType.localType)
        if self.time_djs <= 3 then
            self:showDaojishi(self.time_djs)
        end
    elseif self.deskState == GameViewLayer.STATE_DESKOVER then      -- = 2        --结束阶段
        self.m_pSpStatus:loadTexture("game/handredcattle/image/brnn_zt_4.png", ccui.TextureResType.localType)
        if self.time_djs == 3 then
            self:disCardAnimAll()
        end
    elseif self.deskState == GameViewLayer.STATE_FREETIME then      -- = 3        --空闲阶段

    end
    self.m_pLbCountTime:setString(self.time_djs)
    self.time_djs = self.time_djs-1
end

-- 显示最后3秒倒计时和播放音效
function GameViewLayer:showDaojishi(count)
    local armature = self.m_pNodeTip:getChildByTag(Handredcattle_Const.daojishiArmTag)
    --if self.m_pNodeTip:getChildByTag(Handredcattle_Const.daojishiArmTag) then return end
    if nil == armature then
        armature = ccs.Armature:create(HandredcattleRes.ANI_OF_DAOJISHI)
        armature:setPosition(Handredcattle_Const.daojishiArmPos)
        armature:setName(HandredcattleRes.ANI_OF_DAOJISHI)
        armature:setTag(Handredcattle_Const.daojishiArmTag)
        self.m_pNodeTip:addChild(armature)
    end
    
    armature:getAnimation():playWithIndex(0, -1, -1)
    --armature:getAnimation():play("Animation1")

    local frameIndex = math.ceil((3 -count) * 60 + 1)
    if frameIndex > 170 then frameIndex = 170 end 
    armature:getAnimation():gotoAndPlay(frameIndex)

    --帧回调无效？使用延迟播放
    for i = 1, count do
        self:doSomethingLater(function ()
            if self.m_nSoundClock then
                AudioManager.getInstance():stopSound(self.m_nSoundClock)
                self.m_nSoundClock = nil
            end
            if self._bIsPlayDaojishi then
                self.m_nSoundClock = AudioManager.getInstance():playSound("game/handredcattle/sound/sound-countdown.mp3")
            end
        end , i - 1)
    end
end

function GameViewLayer:initMenuView()   --菜单
    --[[
    --音乐
    local music = GlobalUserItem.bVoiceAble
    if music then
        GlobalUserItem.setVoiceAble(true)
        self.m_pVoiceBtn:loadTextureNormal(HandredcattleRes.IMG_MUSIC_ON, ccui.TextureResType.plistType)
    else
        GlobalUserItem.setVoiceAble(false)
        self.m_pVoiceBtn:loadTextureNormal(HandredcattleRes.IMG_MUSIC_OFF, ccui.TextureResType.plistType)
    end

--    --音效
    local sound = GlobalUserItem.bSoundAble
    if sound then
        GlobalUserItem.setSoundAble(true)
        self.m_pBtnSetting:loadTextureNormal(HandredcattleRes.IMG_SOUND_ON, ccui.TextureResType.plistType)
    else
        GlobalUserItem.setSoundAble(false)
        self.m_pBtnSetting:loadTextureNormal(HandredcattleRes.IMG_SOUND_OFF, ccui.TextureResType.plistType)
    end]]--

--    -- 播放背景音樂
--    AudioManager.getInstance():stopMusic(false)
--    AudioManager.getInstance():playMusic(HandredcattleRes.MUSIC_OF_BGM)
end

function GameViewLayer:initGame()
--    self:initSelfInfo()
--    self:doSomethingLater(function()
--        local nStatus = HoxDataMgr.getInstance():getGameStatus()
--        if nStatus ~= HoxDataMgr.E_GAME_STATUE.eGAME_STATUS_CHIP then
--            self:initWaitingAnim()
--        end
--    end, 0.5)
--    self:updateBetMoney()
--    self:onMsgGameScene(nil)
--    self:onMsgUpdateBnakerInfo(nil)
--    self:UpdateCotinueAndClearBtState(false)
--    NiuNiuCBetManager.getInstance():setContinue(false)
--    self:initAlreadyJettion()
--    self:updateOtherNum()
    -- 更新上桌玩家信息
    self:updateTableUserInfo()

    self:onBetNumClicked(1)
    self.m_pLbTotalBetting:setString(0)
    self.m_pLbRemaingBetting:setString(0)
    for i = 1, 4 do
        self.tdxhTable[i]["allMoney"] = 0
        self.tdxhTable[i]["myMoney"] = 0
    end
    
end

function GameViewLayer:initAlreadyJettion()
    --self
    local num = HoxDataMgr.getInstance():getUsrChipCount()
    for i = 1, num do
        local selfChip = HoxDataMgr.getInstance():getUsrChipByIdx(i)
        local endPos = self:getEndPositon(selfChip.wChipIndex)
        self:createChipSprite(selfChip.wJettonIndex, selfChip.wChipIndex, endPos, true)
    end
    --other
    for i = 1, Handredcattle_Const.DOWN_COUNT_HOX  do
        local totalVal = HoxDataMgr.getInstance():getOtherChip(i)
        while totalVal > 0 do
            local index = HoxDataMgr.getInstance():GetJettonMaxIdx(totalVal)
            if index >= 1 then
                local jettonVal = NiuNiuCBetManager.getInstance():getJettonScore(index)
                totalVal = totalVal - jettonVal
                local endPos = self:getEndPositon(i)
                self:createChipSprite(index,i,endPos,false)
            end
        end
    end
end

function GameViewLayer:initSelfInfo()--没用
    --需要格式化名字长度
    local m_pLbUsrNickName = self.m_pNodeBottomInfo:getChildByName("TXT_player_name")
    local name = PlayerInfo.getInstance():getUserName()
    if string.utf8len(name) > 6 then
        name = LuaUtils.getDisplayNickName(name, 10,true)
    end
    m_pLbUsrNickName:setString(name)

    --需要格式化金币
    local nScore = PlayerInfo.getInstance():getUserScore()
    local strScore = LuaUtils.getFormatGoldAndNumber(nScore)
    self.m_pLbUsrGold:setString(strScore)
end
--endregion

--region 事件绑定

--按钮事件绑定
function GameViewLayer:initBtnClickEvent()
    for i = 1, Handredcattle_Const.JETTON_ITEM_COUNT do
        ----self.m_pControlButtonJetton[i]:addClickEventListener(handler(self,function()
        ----    --主动点击筹码才播放音效
--      ----      AudioManager.getInstance():playSound(HandredcattleRes.SOUND_OF_JETTON)
        ----    self:onBetNumClicked(i)
        ----end))
        self.m_pControlButtonJetton[i]:setEnabled(false)
        ------self.m_pControlButtonJetton[i]:setColor(cc.c3b(125,125,125))
        ------self.m_pControlButtonJetton[i]:setOpacity(175)
    end
    for i = 1, Handredcattle_Const.DOWN_COUNT_HOX  do       --四个区域
        self.m_pControlButtonAnimal[i]:addClickEventListener(handler(self,function()
            self:onAnimalClicked(i-1)     
        end))
    end
    --self.m_pBtnClearBet:addClickEventListener(handler(self,self.onBetClearClicked))
    self.m_pBtnContinue:addClickEventListener(handler(self,self.onBetContinueClicked))      --续投
    self.m_pBtnContinue:setEnabled(false)
    self.m_pDealerBtn:addClickEventListener(handler(self,self.onDealerClicked))             --上庄
    --self.m_pRecordBtn:addClickEventListener(handler(self,self.onRecordClicked))
    self.m_pRuleBtn:addClickEventListener(handler(self,self.onRuleClicked))                 --规则
    self.m_pBankBtn:addClickEventListener(handler(self,self.onBankClicked))                 --银行按钮
    self.m_pBankmenuBtn:addClickEventListener(handler(self,self.onBankClicked))             --保险箱
    
--    self.m_pChatBtn:addClickEventListener(handler(self,self.onMsgClicked))
    self.m_pBtnMenuPop:addClickEventListener(handler(self,self.onPopClicked))               --倒三角菜单按钮
    self.m_pBtnMenuPush:addClickEventListener(handler(self,self.onPushClicked))             --关闭菜单按钮
    self.m_pBtnReturn:addClickEventListener(handler(self,self.onReturnClicked))             --退出按钮
    self.m_pBtnSetting:addClickEventListener(handler(self,self.onSettingClicked))               --设置按钮
    self.m_pBtnButtonMark:addClickEventListener(handler(self,self.onPushClicked))             --关闭菜单按钮
    ------self.m_pVoiceBtn:addClickEventListener(handler(self,self.onVoiceClicked))               --音乐
    self.m_pBtnOtherInfo:addClickEventListener(handler(self,self.onOtherInfoClicked))       --其他玩家
    self.m_pBtnTrend:addClickEventListener(handler(self,self.onTrendClicked))
end

--@@@@@@@@@@@@ 服务器消息

function GameViewLayer:onEventEnterGame(bufferdate)
    --初始化数据
    self.deskState = bufferdate.step
    self.chips = bufferdate.chips
--    for key, chip_ in ipairs(self.chips) do
--        local chipSpriteFrame = cc.Director:getInstance():getTextureCache():addImage(string.format(STR_CHIP_NUM_RES,chip_))
--        table.insert(self.chipImageNumRes,chipSpriteFrame)
--    end
    if bufferdate.step == 2 then
        local armature = ccs.Armature:create(HandredcattleRes.ANI_OF_DENGDAI)
        armature:setPosition(Handredcattle_Const.waitArmPos)
        armature:getAnimation():play("Animation1")
        armature:setName(HandredcattleRes.ANI_OF_DENGDAI)
        armature:setTag(Handredcattle_Const.waitArmTag)
        self.m_pNodeTip:addChild(armature)
    end
    for key, player_ in ipairs(bufferdate.members) do
        table.insert(self.playerInfoTable,player_)
    end
    for key, player_ in ipairs(bufferdate.dealers) do
        table.insert(self.bankersTable,player_)
    end

    --设置筹码按钮
    for i ,v in pairs(self.chips) do
        if i > 5 then break end
        self:addJettonLabel(self.m_pControlButtonJetton[i]:getButtonNode(), v)
    end

    self.min_dealermoney = bufferdate.min_dealermoney
    self.m_seats = bufferdate.seats
    ------更新桌面玩家
    self:updateTableUserInfo()

    dump(bufferdate.dealers)
    for i = 1, 4 do
        self.tdxhTable[i]["allMoney"] = bufferdate.betmoneys[i]
        self.tdxhTable[i]["myMoney"] = bufferdate.mybetmoneys[i]
        self.tdxhTable[i]["chip_sprite"] = {}
    end
    
    self.bankerUid = bufferdate.dealer
    self.banker_time = bufferdate.dealer_times
    self.allBetMoney = bufferdate.pot
    self.histroyTable = bufferdate.path
    self.time_djs = bufferdate.timeout

    self:paixuPlayerTable()
    --初始化界面丶
    for key, player_ in ipairs(self.playerInfoTable) do
        if player_[1] == myUID then        --用户自身信息
            self.m_pNodeBottomInfo:getChildByName("TXT_player_name"):setString(player_[2])
            self.m_pLbUsrGold:setString(player_[6])
            self.myIntoMoney = player_[6]
            --设置自己头像
            loadHeadMiddleSprite(self.m_pSelfHead,player_[3], player_[5])
            createStencilAvatar(self.m_pSelfHead)
        end
        if player_[1] == self.bankerUid then   --庄家信息
            loadHeadMiddleSprite(self.m_pLbZhuangHead,player_[3], player_[5])
            createStencilAvatar(self.m_pLbZhuangHead)
            self.m_pNodeTopInfo:getChildByName("TXT_zhuang_name"):setString(player_[2])
            self.m_pLbZhuangGold:setString(player_[6])

        end
    end
    local count = #self.playerInfoTable
    local playerNum = count > 6 and count - 6 or 0
    self.m_pLbOtherNum:setString('('..playerNum..')')     --其他玩家人数
    local bankerNum = #self.bankersTable
    self.m_pLbAskNum:setString(bankerNum)       --申请上庄玩家人数
    for i = 1, 4 do
        self.m_pLbBettingGold[i]:setString(self.tdxhTable[i]["allMoney"])       --每个区域下注钱数
        self.m_pLbMyBettingGold[i]:setString(self.tdxhTable[i]["myMoney"])      --每个区域玩家自身下注钱数
    end
    self.m_pLbTotalBetting:setString(self.allBetMoney)          --已下注的总钱数
    
    --历史记录
    --self.trendLayer = HandredcattleTrendLayer.new(self.histroyTable)
    --self.trendLayer:setVisible(false)
    --self.m_pNodeTrend:addChild(self.trendLayer)
end
--【1】区域，【2】区域总钱数，【3】uid,【4】下注钱数，【5】剩余可下注
function GameViewLayer:onEventBet(bufferdate)
    local chipBegin_x,chipBegin_y = 0,0     --筹码起飞的位置

    --筹码终点位置
    local chipEnd_x,chipEnd_y = self:getJettonEndPosByIndex(bufferdate[1])

    self.tdxhTable[bufferdate[1]+1]["allMoney"] = bufferdate[2]
    self.m_pLbBettingGold[bufferdate[1]+1]:setString(self.tdxhTable[bufferdate[1]+1]["allMoney"])       --天区域下注钱数

    self.allBetMoney = self.allBetMoney + bufferdate[4]
    self.m_pLbTotalBetting:setString(self.allBetMoney)          --已下注的总钱数
    self.m_pLbRemaingBetting:setString(bufferdate[5]-bufferdate[5]%0.01)
--    self:chipAnimation(bufferdate[1],bufferdate[4])
    self.allRemainngBet = 200000000--bufferdate[5] --剩余可下注钱数
    local isMyFly_ = false
    local bInTable, tableUserIndex = self:isInTable(bufferdate[3])
    --判断是不是自己
    if bufferdate[3] == GlobalUserItem.tabAccountInfo.userid then
        chipBegin_x = 60
        chipBegin_y = 40
        isMyFly_ = true
    --桌上玩家
    elseif bInTable then
        chipBegin_x, chipBegin_y= self.m_pNodeTablePlayer[tableUserIndex]:getPosition()

        --播放桌上玩家动画
        self:playTableUserChipAni(tableUserIndex)
    else
        chipBegin_x = self.m_othersPos.x
        chipBegin_y = self.m_othersPos.y
    end

    self:createFlyChipSprite(bufferdate[4],cc.p(chipBegin_x,chipBegin_y),cc.p(chipEnd_x,chipEnd_y),bufferdate[1],isMyFly_, tableUserIndex)
    self:refreshJettonState()

    --更新桌面玩家分数
    self:updateTableUserScore()
end

--自己下注
function GameViewLayer:onEventMybet(bufferdate)
    self.myJjj = self.myJjj + bufferdate[1]
    self.tdxhTable[bufferdate[2]+1]["myMoney"] = bufferdate[1]+self.tdxhTable[bufferdate[2]+1]["myMoney"]
    self.tdxhTable[bufferdate[2]+1]["allMoney"] = bufferdate[3]
    self.allBetMoney = self.allBetMoney + bufferdate[1]
    self.m_pLbTotalBetting:setString(self.allBetMoney)          --已下注的总钱数
    self.m_pLbBettingGold[bufferdate[2]+1]:setString(self.tdxhTable[bufferdate[2]+1]["allMoney"])       --区域下注钱数
    self.m_pLbMyBettingGold[bufferdate[2]+1]:setString(self.tdxhTable[bufferdate[2]+1]["myMoney"])      --玩家自身在区域下注的钱数

    local chipEnd_x, chipEnd_y = self:getJettonEndPosByIndex(bufferdate[2])
    self:createFlyChipSprite(bufferdate[1],cc.p(60,40),cc.p(chipEnd_x,chipEnd_y),bufferdate[2],true, nil)
    self:refreshJettonState()
    for key, player_ in ipairs(self.playerInfoTable) do
        if player_[1] == myUID then        --用户自身信息
            self.m_pLbUsrGold:setString(player_[6] - self.myJjj)
        end
    end
end
--下注失败
function GameViewLayer:onEventBadbet(bufferdate)

end
function GameViewLayer:onEventWaitPlayerBet(bufferdate)
    self.deskState = GameViewLayer.STATE_PLAYERBETS
    self.time_djs = 15
    self:showTimeTips(1)
    self:refreshJettonState()
    local isXuTou = 0
    for i = 1,4 do
        self.m_pLbMyBettingGold[i]:setString(self.tdxhTable[i]["myMoney"])      --玩家自身在区域下注的钱数
        isXuTou = isXuTou + self.lastMyBet[i]
    end
    if isXuTou>0 then
        self.m_pBtnContinue:setEnabled(true)--setTouchEnabled(true):setBright(true)
    else
        self.m_pBtnContinue:setEnabled(false)--setTouchEnabled(false):setBright(false)
    end
    self.allBetMoney = 0
    self.m_pLbTotalBetting:setString(self.allBetMoney)          --已下注的总钱数
    self.allRemainngBet = 20000000 
    self.m_pLbRemaingBetting:setString(0)  
end
function GameViewLayer:onEventFreeTime(bufferdate)

end

function GameViewLayer:onEventGetSeatInfo(bufferdate)
    self.m_seats = bufferdate.seats
end

function GameViewLayer:onEventDownDealers(bufferdate)
    dump(self.bankersTable)
    if bufferdate[1] == GlobalUserItem.tabAccountInfo.userid then
        self.isUpBanker = false
    end
    for key, var in ipairs(self.bankersTable) do
        if bufferdate[1] == var[1] then
            table.remove(self.bankersTable,key)
        end
    end
    local bankers_num = #self.bankersTable
    self.m_pLbAskNum:setString(bankers_num)       --申请上庄玩家人数

    --更新申请上庄列表
    if self.m_layerDealerQueue then
        self.m_layerDealerQueue:recvNnGetApplyUpBankerRes()
    end
end

function GameViewLayer:onEventWaitUpDealer(bufferdate)
    dump(self.bankersTable)
    self.isWaitBanker = true           --是否等待玩家上庄

end

function GameViewLayer:onEventUpDealer(bufferdate)
    dump(self.bankersTable)
    if bufferdate[1] == GlobalUserItem.tabAccountInfo.userid then   --玩家申请上庄
        self.isUpBanker = true

        --切换按钮显示
        self:switchDealerImage()
    end

    for key, player_ in ipairs(self.playerInfoTable) do
        if player_[1] == bufferdate[1] then
            if self.isWaitBanker then
                self.bankersTable[1] = player_
            else
                table.insert(self.bankersTable,player_)
            end
        end
    end

    local bankerNum = #self.bankersTable
    self.m_pLbAskNum:setString(bankerNum)       --申请上庄玩家人数

    if self.isWaitBanker then        
        local player_ = self.bankersTable[1]
        self.bankerUid = player_[1]
        self:setBankerHeadByUid()
        self.m_pNodeTopInfo:getChildByName("TXT_zhuang_name"):setString(player_[2])
        self.m_pLbZhuangGold:setString(player_[6])
        self.banker_time = 0
        self.isWaitBanker = false
    end

    --更新申请上庄列表
    if self.m_layerDealerQueue then
        self.m_layerDealerQueue:recvNnGetApplyUpBankerRes()
    end
end

function GameViewLayer:onEventUpdateDealers(bufferdate)
    dump(self.bankersTable)
    self.bankersTable = bufferdate
    local bankerNum = #self.bankersTable
    self.m_pLbAskNum:setString(bankerNum)       --申请上庄玩家人数

    local player_ = self.bankersTable[1]
    self.bankerUid = player_[1]
    self:setBankerHeadByUid()
    self.m_pNodeTopInfo:getChildByName("TXT_zhuang_name"):setString(player_[2])
    for key, player_ in ipairs(self.playerInfoTable) do
        if player_[1] == self.bankerUid then
            self.m_pLbZhuangGold:setString(player_[6])
        end
    end  
    self.banker_time = 0

    --更新申请上庄列表
    if self.m_layerDealerQueue then
        self.m_layerDealerQueue:recvNnGetApplyUpBankerRes()
    end
end

function GameViewLayer:onEventPlayerCome(bufferdate)
    if bufferdate[1] ~= myUID then
        local player_ = bufferdate
        table.insert(self.playerInfoTable,player_)
    end
    self:paixuPlayerTable()
    local playerNum = #self.playerInfoTable
    local showNum = playerNum > cmd.TABEL_USER_COUNT and playerNum - cmd.TABEL_USER_COUNT or playerNum
    self.m_pLbOtherNum:setString('('..showNum..')')     --其他玩家人数

    self:updateTableUserInfo()

end

function GameViewLayer:onEventPlayerLeave(bufferdate)
    for key, player in ipairs(self.playerInfoTable) do
        if player[1] == bufferdate then
            print("玩家："..player[2].."离开房间")
            table.remove(self.playerInfoTable,key)
        end
    end
    self:paixuPlayerTable()
    local playerNum = #self.playerInfoTable
    self.m_pLbOtherNum:setString('('..playerNum..')')     --其他玩家人数

    self:updateTableUserInfo()
end

function GameViewLayer:onEventUpdateIntoMoney(bufferdate)

end
function GameViewLayer:onEventGameOver(bufferdate)
    self.deskState = GameViewLayer.STATE_DESKOVER
    self.time_djs = bufferdate.timeout
    

    for key, player_ in ipairs(self.playerInfoTable) do
        for key_, player__ in ipairs(bufferdate.moneys) do
            if player_[1] == player__[1]  then
                player_[6] = player__[2]
            end
        end        
    end
    self:paixuPlayerTable()
    
    for i=1, 4  do
        self.lastMyBet[i] = self.tdxhTable[i]["myMoney"]
        self.tdxhTable[i]["myMoney"] = 0
    end
    self.m_pBtnContinue:setEnabled(false)  
    self.pokerData = bufferdate.hands
    self.player_winZodics = bufferdate.win_zodics
    self.selfcurscore = bufferdate.mywin -- 自己最终得分
    self.bankercurscore = bufferdate.dealer_win -- 庄家最终得分
    self.m_tableUserWins = bufferdate.rank8_wins -- 桌上玩家输赢
    self.m_topWinners = bufferdate.top4_wins     -- 赢钱最多的四个人

    self:refreshJettonState()
    self:showTimeTips(2)
    --更新走势图
    --self:runAction(cc.Sequence:create( cc.DelayTime:create(8),cc.CallFunc:create(function()
    --    self.trendLayer:onEventUpdata(bufferdate.win_zodics)
    --end) ))
    
end
function GameViewLayer:onEventUpdealer_fail_nomoney(bufferdate)
    FloatMessage:getInstance():pushMessage("背包金币不足"..bufferdate)
end


--@@@@@@@@@@@@@@@                                                              按钮回调

--点击下注筹码
function GameViewLayer:onBetNumClicked( nIndex )
    if not nIndex then return end
    if self.nIndexChoose == nIndex then
        return
    end

    --让先前选中的变成原始位置
    local fNormalY = 24
    local fSelectY = 38
    
    --原来选择的需要飞回来
    if self.nIndexChoose > 0 then
        ------local posNowX, posNowY = self.m_pControlButtonJetton[self.nIndexChoose]:getPosition()
        ------self.m_pControlButtonJetton[self.nIndexChoose]:setPosition(cc.p(posNowX,fNormalY))
        self.m_pControlButtonJetton[self.nIndexChoose]:setSel(false)
    end
    
    --新选择的需要飞出去
    ------local posNewX, posNewY = self.m_pControlButtonJetton[nIndex]:getPosition()
    ------self.m_pControlButtonJetton[nIndex]:setPosition(cc.p(posNewX, fSelectY))
    self.m_pControlButtonJetton[nIndex]:setSel(true)

    self.nIndexChoose = nIndex
end
--点击四个区域下注
function GameViewLayer:onAnimalClicked(nIndex)
    if not nIndex then return end
    local bet_value = self.chips[self.nIndexChoose]
    self._scene:sendBet_in({nIndex,bet_value})
end
function GameViewLayer:onBetContinueClicked()

    local func1 = cc.CallFunc:create(function()
            if self.lastMyBet[1] ~= 0 then
                self._scene:sendBet_in({0,self.lastMyBet[1]})
            end
        end)
    local func2 = cc.CallFunc:create(function()
            if self.lastMyBet[2] ~= 0 then
                self._scene:sendBet_in({1,self.lastMyBet[2]})
            end
        end)
    local func3 = cc.CallFunc:create(function()
            if self.lastMyBet[3] ~= 0 then
                self._scene:sendBet_in({2,self.lastMyBet[3]})
            end
        end)
    local func4 = cc.CallFunc:create(function()
            if self.lastMyBet[4] ~= 0 then
                self._scene:sendBet_in({3,self.lastMyBet[4]})
            end
        end)
    local delay_ = cc.DelayTime:create(0.1)
    self.m_pBtnContinue:runAction(cc.Sequence:create( func1,delay_,func2,delay_,func3,delay_,func4 ))
    self.m_pBtnContinue:setEnabled(false)
end
--退出房间
function GameViewLayer:onReturnClicked()
    self:hideReturnMenu()
    self._scene:onQueryExitGame()
end
--其他玩家
function GameViewLayer:onOtherInfoClicked()

    if self.m_layerOtherUserInfo ~= nil then
        return
    end

    ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_BUTTON)
    --玩家列表
    --local infoLayer = HandredcattleOtherInfoLayer.create(self.playerInfoTable)
    --self.m_pNodeDlg:addChild(infoLayer,4)

    local layernew = appdf.req(module_pre..'.views.layer.PlayerListView')
    local layerInfo = layernew:create(self, self.playerInfoTable)
    layerInfo:addTo(self.m_pNodeDlg, 100)
    layerInfo:showPopup()

    self.m_layerOtherUserInfo = layerInfo
end

--走势按钮回调
function GameViewLayer:onTrendClicked()
    if self.m_layerTrend ~= nil then
        return
    end

    ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_BUTTON)

    local layer = appdf.req(module_pre .. ".views.layer.TrendLayer")

    local layerInfo = layer:create(self)
    layerInfo:addTo(self.m_pNodeDlg, 100)
    layerInfo:setTrendData(self.histroyTable)
    layerInfo:showPopup()

    self.m_layerTrend = layerInfo
end

function GameViewLayer:onPopClicked()
    ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_BUTTON)

    local originalX = -1280
    if self.isOpenMenu then
        self.m_pNodeMenu:stopAllActions()
        if LuaUtils.isIphoneXDesignResolution() then
            self.m_pNodeMenu:runAction(cc.MoveTo:create(0.2, cc.p(-140 + originalX, self.m_pNodeMenu:getPositionY())))
        else
            self.m_pNodeMenu:runAction(cc.MoveTo:create(0.2, cc.p(-165 + originalX, self.m_pNodeMenu:getPositionY())))
        end

        self.m_pImageArrow:runAction(cc.Sequence:create(cc.RotateTo:create(0.2, -90),cc.CallFunc:create(function()
            ------self.backMenu:setVisible(not self.backMenu:isVisible())
            self.isOpenMenu = not self.isOpenMenu
            self.m_pBtnButtonMark:setVisible(not self.m_pBtnButtonMark:isVisible())
        end)
        ))
    else
        ------self.backMenu:setVisible(not self.backMenu:isVisible())
        self.m_pNodeMenu:setVisible(true)
        self.m_pNodeMenu:stopAllActions()
        if LuaUtils.isIphoneXDesignResolution() then
            self.m_pNodeMenu:runAction(cc.MoveTo:create(0.2, cc.p(140 + originalX, self.m_pNodeMenu:getPositionY())))
        else
            self.m_pNodeMenu:runAction(cc.MoveTo:create(0.2, cc.p(165 + originalX, self.m_pNodeMenu:getPositionY())))
        end
        self.m_pImageArrow:runAction(cc.RotateTo:create(0.2, 0))
        self.m_pBtnButtonMark:setVisible(not self.m_pBtnButtonMark:isVisible())
        self.isOpenMenu = not self.isOpenMenu
    end

end
function GameViewLayer:onPushClicked()
    ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_BUTTON)

    self:hideReturnMenu()
end

function GameViewLayer:hideReturnMenu()
    if not self.isOpenMenu then return end

    self.m_pImageArrow:setRotation(-90)

    self.isOpenMenu = false
    self.m_pNodeMenu:stopAllActions()

    local originalX = -1280
    local moveX = -165
    if LuaUtils.isIphoneXDesignResolution() then
        moveX = -140
    end
    local seq = cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(moveX + originalX, self.m_pNodeMenu:getPositionY())), cc.CallFunc:create(function()
        self.m_pNodeMenu:setVisible(false)
        self.m_pBtnMenuPush:setVisible(false)
        self.m_pBtnButtonMark:setVisible(not self.m_pBtnButtonMark:isVisible())
    end))
    self.m_pNodeMenu:runAction(seq)
end

function GameViewLayer:onSettingClicked()
    ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_BUTTON)
    self:hideReturnMenu()

    local layerInfo = SettingLayer.create()
    layerInfo:addTo(self.m_pNodeDlg, 100)
    layerInfo:showPopup()

end

function GameViewLayer:onVoiceClicked()
    ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_BUTTON)
    --音乐
    self.isMusicSound = GlobalUserItem.bVoiceAble
    if self.isMusicSound then
        GlobalUserItem.setVoiceAble(false)
        self.m_pVoiceBtn:loadTextureNormal(HandredcattleRes.IMG_MUSIC_OFF,ccui.TextureResType.plistType)
        self.isMusicSound = false
    else
        --打开
        GlobalUserItem.setVoiceAble(true)
        self.m_pVoiceBtn:loadTextureNormal(HandredcattleRes.IMG_MUSIC_ON,ccui.TextureResType.plistType)
        self.isMusicSound = true
    end
end

function GameViewLayer:onBankClicked()

end
function GameViewLayer:onRuleClicked()
    ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_BUTTON)
    self:hideReturnMenu()
    --弹出规则弹窗

    local CommonRule = appdf.req(module_pre .. ".views.layer.RuleLayer")

    local pRule = CommonRule.new()
    pRule:addTo(self.m_pNodeDlg, 100)
    pRule:showPopup()

end

--上庄&取消上庄&查看上庄列表
function GameViewLayer:onDealerClicked()
    ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_BUTTON)

    if self:isBanker() then
        self._scene:sendDownDealer()
    elseif self.isUpBanker == false then
        self._scene:sendUpDealer()
    else--显示申请列表
        local layer = appdf.req(module_pre .. ".views.layer.DealerQueueView")
        local dealerQueueView = layer:create(self,self.min_dealermoney)
        dealerQueueView:addTo(self.m_pNodeDlg)
        dealerQueueView:showPopup()
        self.m_layerDealerQueue = dealerQueueView
    end
end

function GameViewLayer:DownDealer()
    self._scene:sendDownDealer()
end

function GameViewLayer:UpDealer()
    if self.isUpBanker == false then
        self._scene:sendUpDealer()
    end
end
--@@@@@@@@@@@@@@@                                                                      工具方法

--通过玩家身上钱数对玩家排序
function GameViewLayer:paixuPlayerTable()
    local function playerMoneyCompareFun(role1,role2)
        return role1[6] > role2[6]
    end
    table.sort(self.playerInfoTable,playerMoneyCompareFun)
end
--下注按钮的状态
function GameViewLayer:refreshJettonState(  )
    for i = 1, Handredcattle_Const.JETTON_ITEM_COUNT do
        local bStatue = self:getJettonEnableState(i)
        self.m_pControlButtonJetton[i]:setEnabled(bStatue)
        if bStatue == true then
            ------self.m_pControlButtonJetton[i]:setColor(cc.c3b(255,255,255))
            ------self.m_pControlButtonJetton[i]:setOpacity(255)
        else
            ------self.m_pControlButtonJetton[i]:setColor(cc.c3b(125,125,125))
            ------self.m_pControlButtonJetton[i]:setOpacity(175)
        end
    end

    self:updateJettonSelAdjust()
end
function GameViewLayer:getJettonEnableState(index)
    if self.deskState ~= GameViewLayer.STATE_PLAYERBETS then
        --非投注状态
        return false
    end
    
    if self:isBanker() then
        return false
    end

    local llTotalValue = 0
    for i = 1, 4 do
        --自己下注
        local llUserValue = self:getUserAllChip(i)---------------?
        llTotalValue = llUserValue + llTotalValue
    end

    local nextCost = (llTotalValue + self:getJettonScore(index)) * GameViewLayer.BEILV---------------?
    if self.myIntoMoney < llTotalValue * GameViewLayer.BEILV
        or self.myIntoMoney < nextCost then
        --玩家的钱不够赔时
        return false
    end
    
    if self.myIntoMoney < self:getJettonScore(index) * GameViewLayer.BEILV then
        --玩家钱币不足
        return false
    end
    
    if self.allRemainngBet < self:getJettonScore(index) then
        --剩下投注金币过小
        return false
    end
    
    return true
end

function GameViewLayer:updateJettonSelAdjust()
    local newSelIndex = self:getJettonSelAdjust()
    if newSelIndex >= 1 and  newSelIndex < self.nIndexChoose then
        self:onBetNumClicked(newSelIndex)
    end
end
function GameViewLayer:getJettonSelAdjust()
    local nModeType = GameViewLayer.BEILV
    local nMeScore = self.myIntoMoney
    local nRemain = self.allRemainngBet
--    local nBaseScore = NiuNiuCBetManager.getInstance():getLotteryBaseScore()
--    local nJetton = NiuNiuCBetManager.getInstance().m_llJettonValue

    local llTotalValue = 0
    for i = 1, CHIP_ITEM_COUNT do --自己下注
        llTotalValue = llTotalValue + self:getUserAllChip(i)
    end
    for i = Handredcattle_Const.JETTON_ITEM_COUNT, 1, -1 do
        if (nMeScore + llTotalValue) >= (llTotalValue + self:getJettonScore(i)) * nModeType --自己的积分够赔付
            and self:getJettonScore(i) * GameViewLayer.BEILV <= nRemain then --庄家积分够赔付
            if i < self.nIndexChoose then --新的筹码索引比现有选中的小
                return i
            else
                return self.nIndexChoose
            end
        end
    end

    return 1 --默认选中第一个
end
function GameViewLayer:getJettonScore(index_)
    local chip_value = self.chips
    if index_<1 or index_>5 then
        return chip_value[1]
    end
    return chip_value[index_]
end
function GameViewLayer:getUserAllChip(quyu_)
    if quyu_<1 or quyu_>4 then
        return
    end
    return self.tdxhTable[quyu_]["myMoney"]
end
--系统提示
function GameViewLayer:showTimeTips(_nType)
    --[[ 
         1 -- 开始投注   
         2 -- 开始开奖  
         3 -- 玩家坐庄
         4 -- 系统坐庄 
    --]]
    if _nType == 1 then
        if self.m_pNodeTip:getChildByTag(Handredcattle_Const.waitArmTag) then 
            self.m_pNodeTip:removeChildByTag(Handredcattle_Const.waitArmTag) 
        end
        ExternalFun.playSoundEffect(HandredcattleRes.SOUND_START_WAGER)
        self:initJieduanAnim(_nType)---------------
--        if HoxDataMgr.getInstance():getBankerChairId() ~= G_CONSTANTS.INVALID_CHAIR then
--            -- 玩家庄家 连庄
--            local times = HoxDataMgr.getInstance():getCurBankerTimes()
--            if times > 1 and times <= 10 then
--                self.m_pLianzhuangImage:setSpriteFrame( string.format(HandredcattleRes.IMG_LIANZHUANG[_nType], times))
--                self.m_pLianzhuangImage:setVisible(true)
--            end
--        end
    elseif _nType == 2 then
        ExternalFun.playSoundEffect(HandredcattleRes.SOUND_END_WAGER)
        self:initJieduanAnim(_nType)
    end

    if _nType == 3 or _nType == 4 then
        self.m_pLianzhuangImage:setSpriteFrame(HandredcattleRes.IMG_LIANZHUANG[_nType])
        local randomIndex = math.random(1,2)
        local audioPath = (randomIndex%2 == 0) and HandredcattleRes.SOUND_ZHUANG_1 or HandredcattleRes.SOUND_ZHUANG_2
        ExternalFun.playSoundEffect(audioPath)
        self.m_pLianzhuangImage:setVisible(true)
    end
end
function GameViewLayer:isBanker()
    if self.bankerUid == GlobalUserItem.tabAccountInfo.userid then
        return true
    end
    return false
end
--@@@@@@@@@@@@@@@@@@ 动画
function GameViewLayer:createFlyChipSprite(money_, flyBegin_pos, flyEnd_pos, quyu_, isMyFly, tableUserIndex)
    local pSpr = nil
    local jettonIndex = 0
    
    for i=1,6 do
        if money_ == self.chips[i] then
--          pSpr = cc.Sprite:createWithTexture(self.chipImageBgRes[1])
            jettonIndex = i
            break
        end
    end
    pSpr = cc.Sprite:createWithSpriteFrameName(HandredcattleRes.vecChipImage[jettonIndex])
    if pSpr == nil then return end
    local scale =  0.3
    pSpr:setScale(scale)
    pSpr:setAnchorPoint(cc.p(0.5,0.5))
    pSpr:setPosition(flyBegin_pos)
    self.m_pNodeChipSpr:addChild(pSpr,1)

    self:addJettonLabel(pSpr, money_)

--    local pSp_num = cc.Sprite:createWithTexture(self.chipImageNumRes[jettonIndex])
--    pSpr:addChild(pSp_num)
--    pSp_num:setAnchorPoint(cc.p(0.5,0.5))
--    pSp_num:setPosition(cc.p(55,50))

    local forward = cc.MoveTo:create(0.35,flyEnd_pos)
    local eMove = cc.EaseSineOut:create(forward)
    local Value = false and ( math.random(0,10) % 100)/100.0 or 0 
    local call = cc.CallFunc:create(function ()
        if isMyFly then -- 自己的音效立刻播放
             if jettonIndex > 4 then -- 分投注级别播放音效 金额大于100块的播放高价值音效
                 ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_BETHIGH)
             else
                 ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_BETLOW)
             end            
        else
            if not self.m_isPlayBetSound then
                if jettonIndex > 4 then -- 分投注级别播放音效 金额大于100块的播放高价值音效
                    ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_BETHIGH)
                else
                    ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_BETLOW)
                end
                -- 尽量避免重复播放
                self:doSomethingLater(function() self.m_isPlayBetSound  = false end, math.random(2,4)/10)
                self.m_isPlayBetSound = true
            end
        end
    end)
    local seq = cc.Sequence:create(cc.Hide:create(), cc.DelayTime:create( Value ),cc.Show:create(), call, eMove)
    pSpr:runAction(seq)

    if isMyFly then
        local chipInfo = {}
        chipInfo.wChipIndex = quyu_     --区域
        chipInfo.wJettonIndex = jettonIndex     --级别
        chipInfo.pChipSpr = pSpr
        table.insert(self.m_vecSpriteSelf,chipInfo)
    elseif tableUserIndex then
        local chipInfo = {}
        chipInfo.wChipIndex = quyu_     --区域
        chipInfo.wJettonIndex = jettonIndex     --级别
        chipInfo.pChipSpr = pSpr
        table.insert(self.m_vecSpriteTableUser[tableUserIndex],chipInfo)
    else
        local chipInfo = {}
        chipInfo.wChipIndex = quyu_
        chipInfo.wJettonIndex = jettonIndex
        chipInfo.pChipSpr = pSpr
        table.insert(self.m_vecSpriteOther, #self.m_vecSpriteOther + 1, chipInfo)
    end
end
function GameViewLayer:doSomethingLater(call, time)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(time), cc.CallFunc:create(call)))
end

--转场动画(开始/停止下注)
function GameViewLayer:initJieduanAnim(index)
    local armature = ccs.Armature:create("kaishixiazhu_kaijiang")--(HandredcattleRes.ANI_OF_JIEDUAN)
    armature:setPosition(Handredcattle_Const.jieduanArmPos)
    local animationEvent = function(armature, movementType, movementID)
        if (movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete) then
            self.m_pLianzhuangImage:setVisible(false)
            armature:removeFromParent()

            if 2 == index then
                self:playCardsEffect()
            end
        end
    end
    armature:getAnimation():play(string.format("Animation%d",index) )
    armature:getAnimation():setMovementEventCallFunc(animationEvent)
    armature:setName(HandredcattleRes.ANI_OF_JIEDUAN)
    armature:setTag(Handredcattle_Const.jieduanArmTag)
    self.m_pNodeTip:addChild(armature)
end
--替换开牌牌面资源
function GameViewLayer:playCardsEffect()
    local nMulti = 0
    local nBase = 5
    self.m_nCardsIndex = 1
    self.m_nPlayersIndex = 1
    local tem = self.pokerData
    local nCardNum = 0
    --开牌动画
    local boneName = "%d-%d_Copy1"
    -- 1是庄家 2-5下方从左至右，天地玄黄
    -- 发牌顺序:1->5
    ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_FAPAI)
    for i = 1, Handredcattle_Const.PLAYERS_COUNT_HOX do
        local index = openCardOrder[i]
        self:showFaPaiAni(i,tem[index][1])
    end
end
--发牌
function GameViewLayer:showFaPaiAni(idx,pokerDatas, cb)
    local faPaiDt       = {0.0, 0.1, 0.2, 0.3, 0.4} --发牌延时
    --创建5张牌 发牌
    for n = 1 ,5 do
        --没有创建
        if self.Pokers[idx][n] == nil then
            self.Pokers[idx][n] = Poker:create()
            self.m_pNodeCard:addChild(self.Pokers[idx][n])
        end
        self.Pokers[idx][n]:stopAllActions()
        --设置牌背面
        self.Pokers[idx][n]:setBack()

        --重置位置 重置大小
        self.Pokers[idx][n]:setPosition(self.startPos)
        self.Pokers[idx][n]:setScale(self.startScale)
        self.Pokers[idx][n]:setSkewX(0)
        self.Pokers[idx][n]:setRotation(30)

        --设置牌数据
        self.Pokers[idx][n]:setData(pokerDatas[n])
        self.Pokers[idx][n]:setVisible(true)

        --执行对应的缩放变化
        self.Pokers[idx][n]:runAction(cc.Sequence:create(
            cc.DelayTime:create(faPaiDt[idx]),
            cc.DelayTime:create(n*self.disNum),

            cc.ScaleTo:create(self.flyDt,PokerConst.PokerScale),
            cc.DelayTime:create(self.disNum*4 - self.disNum*n),
            cc.ScaleTo:create(self.moveDt,PokerConst.PokerScale)
        ))

        --旋转变化 
        self.Pokers[idx][n]:runAction(cc.Sequence:create(
            cc.DelayTime:create(faPaiDt[idx]),
            cc.DelayTime:create(n*self.disNum),

            cc.DelayTime:create(self.flyDt),
            cc.DelayTime:create(self.disNum*4 - self.disNum*n),
            cc.DelayTime:create(self.moveDt)
        ))

        local bezier = {  
            self.pathPos[idx],
            self.pathPos[idx],
            self.targetPos[idx],  
        }

        local seq = nil
        if 5 == n and 5 == idx then -- 最后一张发牌完成后 开始翻牌
            seq = cc.Sequence:create(
                cc.DelayTime:create(faPaiDt[idx]),
                cc.DelayTime:create(n*self.disNum),
                --cc.BezierTo:create(self.flyDt, bezier),
                cc.Spawn:create(cc.BezierTo:create(self.flyDt, bezier),cc.RotateTo:create(0.15, 0)),
                cc.DelayTime:create(self.disNum*4 - self.disNum*n),
                cc.MoveTo:create(self.moveDt,cc.p(self.targetPos[idx].x + n*PokerConst.PokerSpace ,self.targetPos[idx].y)),
                cc.DelayTime:create(0.3), 
                cc.CallFunc:create(handler(self, self.showFanPaiAni))
            )
        else
            seq = cc.Sequence:create(
                cc.DelayTime:create(faPaiDt[idx]),
                cc.DelayTime:create(n*self.disNum),
                cc.Spawn:create(cc.BezierTo:create(self.flyDt, bezier),cc.RotateTo:create(0.15, 0)),
                cc.DelayTime:create(self.disNum*4 - self.disNum*n),
                cc.MoveTo:create(self.moveDt,cc.p(self.targetPos[idx].x + n*PokerConst.PokerSpace ,self.targetPos[idx].y))
            )
        end

        self.Pokers[idx][n]:runAction(seq)
    end
end
function GameViewLayer:showFanPaiAni()
    self:showFanPaiAniByIndex(1)
end

function GameViewLayer:showFanPaiAniByIndex(idx)
    if idx > 5 then
        if self.m_cbend then self.m_cbend() end
        return
    end

    local cbend = cc.CallFunc:create(
                    function()
                        local tem = self.pokerData
--                        local markIndex = self.pokerData[index][2]--tem.bMoveMarkIndex[openCardOrder[idx]]
--                        if markIndex > 0 then
--                            for i = 1, 5 do
--                                if i <= markIndex then
--                                    self.Pokers[openCardOrder[idx]][i]:runAction(cc.Sequence:create(cc.MoveBy:create(0.2,cc.p(-6,0))))
--                                else
--                                    self.Pokers[openCardOrder[idx]][i]:runAction(cc.Sequence:create(cc.MoveBy:create(0.2,cc.p(6,0))))
--                                end
--                            end
--                        end
                        self:playImageEffect(idx)
                        local call = function() self:showFanPaiAniByIndex(idx + 1) end
                        self.m_pNodeCard:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), cc.CallFunc:create(call)))
                    end)

    -- 播放5张牌的翻牌
    ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_FANPAI)
    for j = 1, 5 do
        local seq = nil
        local cbshow = cc.CallFunc:create(
                        function()
                            self.Pokers[openCardOrder[idx]][j]:setCardData(self.pokerData[openCardOrder[idx]][1][j])
                        end)

        ---调整扑克位置
        local cbAdjustCardPos = cc.CallFunc:create(
                function()
                    self:adjustCardPos(openCardOrder[idx])
                end)

        local aroundhalf = cc.OrbitCamera:create(PokerConst.PokerAniHalfTime,1,0,0,90,0,0)
        local aroundtail = cc.OrbitCamera:create(PokerConst.PokerAniRemainTime,1,0,270,90,0,0)
        if 5 == j then
            seq = cc.Sequence:create(
                    aroundhalf,
                    cbshow,
                    cbAdjustCardPos, --调整位置
                    aroundtail,
                    cbend)
        else
            seq = cc.Sequence:create(
                    aroundhalf,
                    cbshow,
                    aroundtail)
        end
        self.Pokers[openCardOrder[idx]][j]:runAction(seq)
    end
end
function GameViewLayer:playImageEffect(target)
    
    if not target then return end
    local index = openCardOrder[target]
    local animaName = "a3"
    local boneName = ""
    local nDealerValue = self.pokerData[index][2]--[target][2]
    if nDealerValue == 0 then
        animaName = "Animation3"
        boneName = "a3"
    elseif nDealerValue >= 10 then
        animaName = "Animation1"
        boneName = "a1"
    else
        animaName = "Animation2"
        boneName = "a2"
    end

    local armature = ccs.Armature:create(HandredcattleRes.ANI_OF_PAIXING)
    armature:setPosition(Handredcattle_Const.resultPos[index])
    if "a2" == boneName then
        self:replaceResultArmatureSprite(armature, "a2_Copy2", nDealerValue, HandredcattleRes.IMG_RESULT)
    end
    self:replaceResultArmatureSprite(armature, boneName, nDealerValue, HandredcattleRes.IMG_RESULT)
    armature:getAnimation():play(animaName)
    armature:setName(HandredcattleRes.ANI_OF_PAIXING)
    self.m_pNodeCard:addChild(armature)

    table.insert( self.cardTypeAni, armature)

    self:playCardTypeSound(index)
end
function GameViewLayer:replaceResultArmatureSprite(m_pArmature, boneName, cardTypeIndex, strRes)
    if not m_pArmature then return end
    local pBone = m_pArmature:getBone(boneName)
    local pManager = pBone:getDisplayManager()
    local vecDisplay = pManager:getDecorativeDisplayList()
    local strFrame = string.format(strRes, cardTypeIndex)

    for k,v in pairs(vecDisplay) do
        if v then
            local spData = v:getDisplay()
            spData = tolua.cast(spData, "cc.Sprite")
            if spData then
                spData:setSpriteFrame(strFrame)
            end
        end
    end
end
function GameViewLayer:playCardTypeSound(iUserIndex)
    local nDealerValue = self.pokerData[iUserIndex][2]
    local sex_random = math.random(1, 2)
    local path_sex = sex_random == 1 and "NiuSpeak_M" or "NiuSpeak_W"
    local path_sound = string.format("%s/cow_%d.mp3", path_sex,nDealerValue)
    ExternalFun.playSoundEffect(path_sound)
end

--赢牌动画
function GameViewLayer:playWinEffect()
    local tem = self.player_winZodics
    local showWinEffect = false
    for i = 1, 4 do
        if self:isBanker() then
            if tem[i]>0 then
                showWinEffect = false
            else
                showWinEffect = true
            end
        else
            if tem[i]<0 then
                showWinEffect = false
            else
                showWinEffect = true
            end
        end

        if showWinEffect then
            local ani = ccs.Armature:create(HandredcattleRes.ANI_OF_WIN)
            ani:setPosition(Handredcattle_Const.winArmPos[i])
            ani:getAnimation():play("Animation1")
            ani:setName(HandredcattleRes.ANI_OF_WIN)
            ani:setTag(Handredcattle_Const.winArmTag+i)
            local func = function(armature,movementType,strName)
                if movementType == ccs.MovementEventType.complete then
                    self:effectEnd(ani,ccs.MovementEventType.complete,i)
                end
            end
            ani:getAnimation():setMovementEventCallFunc(func)
            self.m_pNodeTip:addChild(ani)
            table.insert( self.m_pWinEffect, ani)
        end
    end

--    --同步历史记录 -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
--    HoxDataMgr.getInstance():addBoardCount()
--    --通知结算界面更新历史数据
--    local _event = {
--        name = Handredcattle_Events.MSG_HOX_UPDATE_HISTORY_INFO,
--        packet = nil,
--    }
--    SLFacade:dispatchCustomEvent(Handredcattle_Events.MSG_HOX_UPDATE_HISTORY_INFO, _event)
end
function GameViewLayer:checkMyJetton()
--    local i = HoxDataMgr.getInstance():getUsrChipCount()
--    if i <= 0 and not HoxDataMgr.getInstance():isBanker() then
--        FloatMessage.getInstance():pushMessageForString("本局您没有下注")
--    end
end
function GameViewLayer:flychipex()
    -- 处理现有的筹码对象列表
    -- 筹码精灵对象  tag() 代表投注在哪个区域
    local tem = self.player_winZodics

    local bankerwinvec = {} -- 庄家获取的筹码
    local bankerlostvec = {} -- 庄家赔付筹码
    local selfwinvec = {} -- 我获取的筹码
    local otherwinvec = {} -- 其他人获取的筹码
    local tablewinvec = {} -- 桌上玩家的筹码
    local selfvec = {} -- 我的所有区域筹码
    local othervec = {} -- 其他人的所有区域筹码
    local tablevec = {} --桌上人所有区域筹码
    local bankerwin = false
    local bankerlose = false
    local otherwin = false
    local selfwin = false

    for i = 1, cmd.TABEL_USER_COUNT do
        tablevec[i] = {}
        tablewinvec[i] = {}
    end

    for i = 1, 4 do
        bankerwinvec[i] = {}
        bankerlostvec[i] = {}
        selfwinvec[i] = {}
        otherwinvec[i] = {}
        local isTem = tem[i]>0
        selfvec[i] = {bankwin = not isTem, vec = {}}-------------------------------需要修改
        othervec[i] = {bankwin = not isTem, vec = {}}

        for j = 1, cmd.TABEL_USER_COUNT do
            tablevec[j][i] = {bankwin = not isTem, vec = {}}
            tablewinvec[j][i] = {}
        end
    end

    for k, v in pairs(self.m_vecSpriteSelf) do
         table.insert(selfvec[v.wChipIndex+1].vec, v)
    end

    for k, v in pairs(self.m_vecSpriteOther) do
        table.insert(othervec[v.wChipIndex+1].vec, v)
    end

    for i = 1, cmd.TABEL_USER_COUNT  do
        for k, v in pairs(self.m_vecSpriteTableUser[i]) do
            table.insert(tablevec[i][v.wChipIndex+1].vec, v)
        end
    end

    -- 遍历获胜的区域 必须用pairs方式 保证所有筹码遍历到
    local selfPos = self.m_selfPos
    local bankerPos = self.m_bankPos
    local otherPos = self.m_othersPos
    local tableuserPos = {}

    for i = 1, cmd.TABEL_USER_COUNT do
        tableuserPos[i] = {}
        tableuserPos[i].x, tableuserPos[i].y = self.m_pNodeTablePlayer[i]:getPosition()
    end

    for i = 1, 4 do
        for k, v in pairs(selfvec[i].vec) do
            if v then
                v.pChipSpr:setTag(v.wJettonIndex)
                if selfvec[i].bankwin then
                    table.insert(bankerwinvec[i], {sp = v.pChipSpr, endpos = bankerPos})
                    bankerwin = true
                else
                    table.insert(selfwinvec[i], {sp = v.pChipSpr, endpos = selfPos})
                    selfwin = true
                end
            end
        end

        for k, v in pairs(othervec[i].vec) do
            if v then
                v.pChipSpr:setTag(v.wJettonIndex)
                if selfvec[i].bankwin then
                    table.insert(bankerwinvec[i], {sp = v.pChipSpr, endpos = bankerPos})
                    bankerwin = true
                else
                    self.num0 = self.num0 +1
                    v.pChipSpr:setName("___"..self.num0)
                    table.insert(otherwinvec[i], {sp = v.pChipSpr, endpos = otherPos})
                    otherwin = true
                end
            end
        end

        for j = 1, cmd.TABEL_USER_COUNT do
            for k, v in pairs(tablevec[j][i].vec) do
                if v then
                    v.pChipSpr:setTag(v.wJettonIndex)
                    if selfvec[i].bankwin then
                        table.insert(bankerwinvec[i], {sp = v.pChipSpr, endpos = bankerPos})
                        bankerwin = true
                    else
                        self.num0 = self.num0 +1
                        v.pChipSpr:setName("___"..self.num0)
                        table.insert(tablewinvec[j][i], {sp = v.pChipSpr, endpos = tableuserPos[j]})
                        otherwin = true
                    end
                end
            end
        end
    end

    -- 处理庄家需要赔付的筹码 庄家赔付的筹码是多个区域的 需要分区域处理
    -- 同时新建的赔付的筹码引用需要加在玩家获胜筹码集合中 赔付筹码大余8个 则取半
    -- 按倍率赔付筹码数量 大于一定数量的筹码 则不再增加
    -- 赔付筹码是否需要随机分配结束pos飞行？
    local countself = 0
    local countother = 0
    local countTableUser = {}
    local rewardCount = 0
    local rewardCountMax = 30 -- 最多一个区域赔付30个筹码
    local offset = 7
    for i = 1, CHIP_ITEM_COUNT do
        countself = #selfwinvec[i] -- 后面会对vec进行插入 所以保存一个初始的索引
        for j = 1, countself do
            -- 取出原始的筹码对象复制
            local oldsp = selfwinvec[i][j].sp
            if oldsp then
                local newsp = self:clonePayoutChip(oldsp:getTag())
                -- 初始点在庄家处
                newsp:setPosition(bankerPos)
                -- 加入赔付队列 落点坐标直接从预定义的随机落点取 赔付的筹码使用随机区域落点互换
                
                table.insert( bankerlostvec[i], { sp = newsp, endpos = cc.p(oldsp:getPosition())})
                bankerlose = true
                -- 加入自己的获胜队列
                table.insert( selfwinvec[i], { sp = newsp, endpos = selfPos })

            end
        end

        countother = #otherwinvec[i]
        countother = countother > 8 and countother/2 or countother
        for j = 1, countother do
            local oldsp = otherwinvec[i][j].sp
            if oldsp then
                local newsp = self:clonePayoutChip(oldsp:getTag())
                newsp:setPosition(bankerPos)
                local randx = (math.random(-offset*100, offset*100)) / 100
                local randy = (math.random(-offset*100, offset*100)) / 100

--                dump(oldsp:getPosition())
                print(oldsp:getName())

                --table.insert( bankerlostvec[i], { sp = newsp, endpos = self.m_randmChipSelf[i][j % #self.m_randmChipSelf[i]] })
                table.insert( bankerlostvec[i], { sp = newsp, endpos = cc.p(oldsp:getPosition()) })
                bankerlose = true
                --table.insert( bankerlostvec[i], { sp = newsp, endpos = cc.p(oldsp:getPosition()) })
                table.insert( otherwinvec[i], { sp = newsp, endpos = otherPos })
            end
        end

        for j = 1, cmd.TABEL_USER_COUNT do
            countTableUser[j] = #tablewinvec[j][i]
            countTableUser[j] = countTableUser[j] > 8 and countTableUser[j]/2 or countTableUser[j]

            for k = 1,countTableUser[j] do
                local oldsp = tablewinvec[j][i][k].sp
                if oldsp then
                    local newsp = self:clonePayoutChip(oldsp:getTag())
                    newsp:setPosition(bankerPos)

                    print(oldsp:getName())

                    table.insert( bankerlostvec[i], { sp = newsp, endpos = cc.p(oldsp:getPosition()) })
                    bankerlose = true
                    table.insert( tablewinvec[j][i], { sp = newsp, endpos = tableuserPos[j] })
                end

            end

        end
    end

    -- 庄家获取筹码
    local jobitem1 = {
        flytime       = CHIP_FLY_TIME,                                -- 飞行时间
        flytimedelay  = false,                                        -- 飞行时间延长随机时间(0.05~0.15)
        flysteptime   = CHIP_FLY_STEPDELAY,                           -- 筹码队列飞行间隔
        nextjobtime   = CHIP_JOBSPACETIME,                            -- 下个任务执行间隔时间
        chips         = bankerwinvec,                                 -- 筹码队列集合 二维数组[下注区域索引][筹码对象引用]
        preCB         = function()                                    -- 任务开始时执行的回调，此回调根据preCBExec控制只执行一次
                            if bankerwin then
                                ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_GETGOLD)
                            end
                        end,
        preCBExec     = false,
        --overCB        = function() print("庄家获胜筹码飞行完毕") end, -- 动画任务完成后回调
        hideAfterOver = true                                          -- 动画完成后隐藏
    }

    -- 庄家赔付筹码
    local jobitem2 = {
        flytime       = CHIP_FLY_TIME,
        flysteptime   = CHIP_FLY_STEPDELAY,
        nextjobtime   = CHIP_JOBSPACETIME,
        chips         = bankerlostvec,
        preCB         = function()
                            if bankerlose then
                                ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_GETGOLD)
                            end
                        end,
        overCB        = function() print("庄家赔付筹码飞行完毕") end,
        hideAfterOver = false
    }

    -- 其他人赢得的筹码
    local jobitem3 = {
        flytime       = CHIP_FLY_TIME + 0.1,
        flysteptime   = CHIP_FLY_STEPDELAY,
        nextjobtime   = CHIP_JOBSPACETIME,
        chips         = otherwinvec,
        preCB         = function()
                            if otherwin then
                                ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_GETGOLD)
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
                                ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_GETGOLD)
                            end
                        end,
        preCBExec     = false,
        --overCB        = function() print("自己获胜筹码飞行完毕") end,
        hideAfterOver = true
    }

    local newVec = {}
    for i = 1, cmd.TABEL_USER_COUNT do
        for j = 1, CHIP_ITEM_COUNT do
            table.insert(newVec, tablewinvec[i][j])
        end
    end

    local jobitem5 = {
        flytime       = CHIP_FLY_TIME + 0.1,
        flytimedelay  = true,                                        -- 飞行时间延长随机时间(0.05~0.15)
        flysteptime   = 0.01,
        nextjobtime   = CHIP_JOBSPACETIME,
        --chips         = tablewinvec,
        chips = newVec,
        preCB         = function()
            if selfwin then
                ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_GETGOLD)
            end
        end,
        preCBExec     = false,
        --overCB        = function() print("自己获胜筹码飞行完毕") end,
        hideAfterOver = true
    }

    self.m_flyJobVec.nIdx = 1 -- 任务处理索引
    self.m_flyJobVec.flyIdx = 1 -- 飞行队列索引
    self.m_flyJobVec.jobVec = {} -- 任务对象
    self.m_flyJobVec.overCB = function()
        print("所有飞行任务执行完毕")
        self.m_flyJobVec = {}
        --self:showGoldChangeAnimation()
        self:playUserScoreEffect()
    end

    table.insert(self.m_flyJobVec.jobVec, { jobitem1 }) -- 1 飞行庄家获取筹码
    table.insert(self.m_flyJobVec.jobVec, { jobitem2 }) -- 2 飞行庄家赔付筹码
    table.insert(self.m_flyJobVec.jobVec, { jobitem3, jobitem4, jobitem5 }) -- 3 其他人筹码和自己筹码一起飞行

    self:doFlyJob()
end
-- 执行单个的飞行任务
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

            if tg.sptg.endpos or true  then

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
end
--得分动画
function GameViewLayer:playUserScoreEffect()

    local tableuserTotal = 0                    -- 桌面玩家总输赢
    for i ,v in pairs(self.m_tableUserWins) do
        tableuserTotal = tableuserTotal + v[2]
    end

    local tableUserWins = self.m_tableUserWins                 -- 桌面玩家输赢
    local selfcurscore = self.selfcurscore --+ self.myJjj      -- 自己最终得分
    local bankercurscore = self.bankercurscore  -- 庄家最终得分
    local othercurscore = self.bankercurscore*-1 - tableuserTotal -self.selfcurscore  -- 其他玩家最终得分
    self.myJjj = 0
    --加钱
--    local tem = HoxDataMgr.getInstance():getOpenData()
--    local llAwardValue = 0
--    if self:isBanker() then
--        llAwardValue = tem.llBankerResult
--    else
--        llAwardValue = tem.llFinaResult
--    end

--    local llUserScore = PlayerInfo.getInstance():getUserScore()

    local str = ""
    local curpath = ""
--    local tax = 1 - CBetManager.getInstance():getGameTax()

    -- 显示庄家分数动画
    str = bankercurscore--LuaUtils.getFormatGoldAndNumber(bankercurscore)
    if bankercurscore > 0 then
        str = "+" .. str
    end
    curpath = bankercurscore < 0 and HandredcattleRes.FNT_RESULT_LOSE or HandredcattleRes.FNT_RESULT_WIN
    self:flyNumOfGoldChange(self.m_pLbResultBanker, curpath, str)

    -- 显示其他玩家分数动画
--    if HoxDataMgr.getInstance():isBanker() then
--        othercurscore = bankercurscore > 0 and -bankercurscore/tax or -bankercurscore
--    else
--        for i = 1, 4 do
--            othercurscore = othercurscore + tem.llAreaTotalResult[i] - tem.llAreaMyResult[i]
--        end
--    end

--    if othercurscore > 0 then -- 其他玩家返回的胜利分数是没有扣税的
--        othercurscore = othercurscore * (1 - CBetManager.getInstance():getGameTax())
--    end

    str = othercurscore--LuaUtils.getFormatGoldAndNumber(othercurscore)
    if othercurscore > 0 then
        str = "+" .. str
    end
    curpath = othercurscore < 0 and HandredcattleRes.FNT_RESULT_LOSE or HandredcattleRes.FNT_RESULT_WIN
    self:flyNumOfGoldChange(self.m_pLbResultOther, curpath, str)

    -- 显示自己分数动画
    if selfcurscore ~= 0 or self:isBanker() then
--        if HoxDataMgr.getInstance():isBanker() then
--            selfcurscore = bankercurscore
--        else
--            selfcurscore = tem.llFinaResult
--        end
        str = selfcurscore--LuaUtils.getFormatGoldAndNumber(selfcurscore)
        if selfcurscore > 0 then
            str = "+" .. str
        end

        curpath = selfcurscore < 0 and HandredcattleRes.FNT_RESULT_LOSE or HandredcattleRes.FNT_RESULT_WIN
        self:flyNumOfGoldChange(self.m_pLbResultSelf, curpath, str)
    end

    -- 显示桌面分数动画
    for i, v in pairs(tableUserWins) do

        if i > cmd.TABEL_USER_COUNT then
            break
        end


        if v[2] ~= 0 then
            local userinfo = self:getUserInfoByUid((self.m_seats[i+1] or {})[1])
            if v[1] == self.m_seats[i+1][1] and userinfo then
                str = v[2]
                if v[2] > 0 then
                    str = "+" .. str
                    curpath = HandredcattleRes.FNT_RESULT_WIN
                else
                    curpath = HandredcattleRes.FNT_RESULT_LOSE
                end

                self:flyNumOfGoldChange(self.m_pLbTableResultGold[i], curpath, str)
            else
                print('GameViewLayer:playUserScoreEffect 玩家信息对不上')
            end

        end
    end

--    --自己金币变化动画
--    if llAwardValue > 0 then
--        Effect:getInstance():showScoreChangeEffect(self.m_pLbUsrGold, llUserScore - llAwardValue, llAwardValue, PlayerInfo.getInstance():getUserScore(), 1, 10)
--        AudioManager.getInstance():playSound(HandredcattleRes.SOUND_OF_WIN)
--    else
--        local soundStr = (llAwardValue == 0) and  HandredcattleRes.SOUND_OF_NOBET or HandredcattleRes.SOUND_OF_LOSE
--        AudioManager.getInstance():playSound(soundStr)
--        self.m_pLbUsrGold:setString(LuaUtils.getFormatGoldAndNumber(PlayerInfo.getInstance():getUserScore()))
--    end

--    local llGold = 0
--    if HoxDataMgr.getInstance():isBanker() then
--        HoxDataMgr.getInstance():setBankerGold(PlayerInfo.getInstance():getUserScore())
--    end
--    local llGold = HoxDataMgr.getInstance():getBankerChairId() == INVALID_CHAIR
--                    and "999999999"
--                    or HoxDataMgr.getInstance():getBankerGold()
--    self.m_pLbZhuangGold:setString(LuaUtils.getFormatGoldAndNumber(llGold))
        
        for key, player_ in ipairs(self.playerInfoTable) do
            if player_[1] == GlobalUserItem.tabAccountInfo.userid then
                self.m_pLbUsrGold:setString(player_[6])
            end
            if player_[1] == self.bankerUid then
                self.m_pLbZhuangGold:setString(player_[6])
            end
        end
    self.allBetMoney = 0
    self.m_pLbTotalBetting:setString(self.allBetMoney)          --已下注的总钱数
    self.allRemainngBet = 20000000 
    self.m_pLbRemaingBetting:setString(0)  
end
--弹金币动画
function GameViewLayer:flyNumOfGoldChange(lb, filepath, str)
    lb:setFntFile(filepath)
    lb:setString(str)
    lb:setOpacity(255)
    lb:setScale(0.6)
    lb:setVisible(true)
    local pos = cc.p(lb:getPosition())
    local callBack = cc.CallFunc:create(function ()
        lb:setVisible(false)
        lb:setPosition(pos)
        lb:stopAllActions()
    end)

    local pSeq = cc.Sequence:create(
        cc.EaseBounceOut:create(cc.MoveBy:create(0.8, cc.p(0,50))),
        cc.DelayTime:create(2.0),
        cc.FadeOut:create(0.4),
        callBack,
        cc.DelayTime:create(2.0)
        )

    lb:runAction(pSeq)   
end
-- 克隆一个赔付的筹码对象
function GameViewLayer:clonePayoutChip(jettonIndex)
    local pos = cc.p(411,678)

--    local pSpr = cc.Sprite:createWithTexture(self.chipImageBgRes[jettonIndex])
    local pSpr = cc.Sprite:createWithSpriteFrameName(HandredcattleRes.vecChipImage[jettonIndex])
    if not pSpr then return end
    pSpr:setScale(0.35)
    pSpr:setPosition(pos)
--    pSpr:setLocalZOrder(G_CONSTANTS.Z_ORDER_COMMON)
    self.m_pNodeChipSpr:addChild(pSpr)

    self:addJettonLabel(pSpr, self:getJettonScore(jettonIndex))
    return pSpr
end 
function GameViewLayer:effectEnd(armature,movementEventType,name)
    if not armature then return end
    local strEffecName = armature:getName()
    if strEffecName == HandredcattleRes.ANI_OF_NAOZHONG then

        if self.m_pNodeTip:getChildByTag(Handredcattle_Const.daojishiArmTag) then
            self.m_pNodeTip:removeChildByTag(Handredcattle_Const.daojishiArmTag)
            self._bIsPlayDaojishi = false
        end

    elseif strEffecName == HandredcattleRes.ANI_OF_WIN then
        armature:getAnimation():play("Animation2")
        return

    end  
    armature:removeFromParent()
end
--设置自己的牌动画不可见
function GameViewLayer:disCardAnimAll()
    for i = 1, 5 do
        for j = 1, 5 do
            if self.Pokers[i][j] ~= nil then
                self.Pokers[i][j]:setVisible(false)
            end
        end
    end

    for k, v in pairs(self.cardTypeAni) do
        if v then v:removeFromParent() end
    end
    for i = 1, #self.m_pWinEffect do
        if self.m_pWinEffect[i] then
            self.m_pWinEffect[i]:removeFromParent()
        end
    end
    self.m_pWinEffect = {}
    self.cardTypeAni = {}
    self.m_pNodeChipSpr:removeAllChildren()
    self.m_vecSpriteOther = {}
    self.m_vecSpriteSelf = {}
    self.m_vecSpriteTableUser = {}

    for i = 1, cmd.TABEL_USER_COUNT do
        self.m_vecSpriteTableUser[i] = {}
    end

end

--背景动画
function GameViewLayer:playwBgEffect()
    --背景动画
    self.m_pAnimNV:stopAllActions()
    --第一段固定4秒
    self.m_pAnimNV:setPosition(self.m_nodeNVPos[1])
    local move1 = cc.MoveTo:create(4.0,self.m_nodeNVPos[2])
    local move2 = cc.MoveTo:create(2.1,self.m_nodeNVPos[3])
    local move3 = cc.MoveTo:create(2.6,self.m_nodeNVPos[4])
    local move4 = cc.MoveTo:create(3.0,self.m_nodeNVPos[5])
    local move5 = cc.MoveTo:create(4.0,self.m_nodeNVPos[6])

    local randomTime = (math.random()) * 3
    local delayTime = cc.DelayTime:create(randomTime)
    local callFunc = cc.CallFunc:create(function()
        self:playwBgEffect()
    end)
    self.m_pAnimNV:runAction(cc.Sequence:create(move1, move2, move3, move4, move5, delayTime, callFunc))
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------


function GameViewLayer:unloadResource()
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(HandredcattleRes.JSON_OF_JIEDUAN)   --阶段提示动画
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(HandredcattleRes.JSON_OF_WIN)   --赢动画
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(HandredcattleRes.JSON_OF_DAOJISHI)   --倒计时动画
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(HandredcattleRes.JSON_OF_PAIXING)   --牌型动画
    for key, res_ in ipairs(HandredcattleRes.vecChipImage_bg) do
        cc.Director:getInstance():getTextureCache():removeTextureForKey(res_)
    end
    for key, chip_ in ipairs(self.chips) do
        cc.Director:getInstance():getTextureCache():removeTextureForKey(string.format(STR_CHIP_NUM_RES,chip_))
    end
    for i = 1,3 do      --加载碎图组资源
        cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(HandredcattleRes.vecReleasePlist[i][1])
    end
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game/animation.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("game/animation.png")
    AnimationMgr.removeCachedAnimation(Define.CALLSCORE_ANIMATION_KEY)
    AnimationMgr.removeCachedAnimation(Define.CALLONE_ANIMATION_KEY)
    AnimationMgr.removeCachedAnimation(Define.CALLTWO_ANIMATION_KEY)
    AnimationMgr.removeCachedAnimation(Define.CALLTHREE_ANIMATION_KEY)
    AnimationMgr.removeCachedAnimation(Define.AIRSHIP_ANIMATION_KEY)
    AnimationMgr.removeCachedAnimation(Define.ROCKET_ANIMATION_KEY)
    AnimationMgr.removeCachedAnimation(Define.ALARM_ANIMATION_KEY)
    AnimationMgr.removeCachedAnimation(Define.BOMB_ANIMATION_KEY)
    AnimationMgr.removeCachedAnimation(Define.VOICE_ANIMATION_KEY)

    cc.Director:getInstance():getTextureCache():removeTextureForKey("game/card.png")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("game/cardsmall.png")
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game/game.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("game/game.png")
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("public_res/public_res.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("public_res/public_res.png")
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

    if self._ClockFun then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._ClockFun) 
    end    
    if self._FaPaiActionFun~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._FaPaiActionFun)  
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

------
-- 更新上桌玩家信息
function GameViewLayer:updateTableUserInfo()
    for i=1, cmd.TABEL_USER_COUNT do
        local pTableUser =  self:getUserInfoByUid((self.m_seats[i+1] or {})[1])
        if (not pTableUser) or (pTableUser[1] == cmd.INVALID_CHAIR) then
            self.m_pSpNoPlayer[i]:setVisible(true)
            self.m_pNodeShowPlayer[i]:setVisible(false)
            ------LhdzDataMgr.getInstance():setTableUserIdLast(i, G_CONSTANTS.INVALID_CHAIR)
            self.m_vecTableUserIdLast[i] = cc.exports.INVALID_CHAIR
        else
            --换人播放动画
            local newuid = pTableUser[1]
            ------local lastuid = LhdzDataMgr.getInstance():getTableUserIdLast(i)
            local lastuid = self.m_vecTableUserIdLast[i] and self.m_vecTableUserIdLast[i] or cc.exports.INVALID_CHAIR

            local func = function(armatureBack, movementType, movementID)
                if movementType == ccs.MovementEventType.complete then
                    if movementID == Brnn_Res.ANI_OF_CHANGEUSER.ANILIST.BEGIN.NAME then
                        local faceid = armatureBack:getTag()
                        self:replaceUserHeadSprite(armatureBack, Brnn_Res.ANI_OF_CHANGEUSER.ANILIST.BEGIN,pTableUser[5], pTableUser[3])
                        armatureBack:getAnimation():play(Brnn_Res.ANI_OF_CHANGEUSER.ANILIST.END.NAME)
                    elseif movementID == Brnn_Res.ANI_OF_CHANGEUSER.ANILIST.END.NAME then
                        self.m_pSpNoPlayer[i]:setVisible(false)
                        self.m_pNodeShowPlayer[i]:setVisible(true)
                        self.m_pLbShowPlayerName[i]:setString(LuaUtils.getDisplayNickName(pTableUser[2], 8, true))
                        self.m_pLbShowPlayerGold[i]:setString((pTableUser[6]))
                        self.m_pLbShowPlayerGold[i]:setVisible(true)
                    end
                end
            end
            --            local wFaceID = newuid % G_CONSTANTS.FACE_NUM + 1--math.random(1,10);
            if newuid ~= lastuid then
                self.m_vecTableUserIdLast[i] = newuid
                --新用户和老用户都是有效用户，则播放转动动画
                if lastuid ~= cc.exports.INVALID_CHAIR and newuid ~= cc.exports.INVALID_CHAIR then

                    self.m_changeUserAniVec[i]:setTag(newuid)
                    self.m_changeUserAniVec[i]:getAnimation():play(Brnn_Res.ANI_OF_CHANGEUSER.ANILIST.BEGIN.NAME)
                    self.m_changeUserAniVec[i]:getAnimation():setMovementEventCallFunc(func)
                else
                    self:replaceUserHeadSprite(self.m_changeUserAniVec[i], Brnn_Res.ANI_OF_CHANGEUSER.ANILIST.BEGIN,pTableUser[5], pTableUser[3] )
                    self.m_pSpNoPlayer[i]:setVisible(false)
                    self.m_pNodeShowPlayer[i]:setVisible(true)
                    self.m_pLbShowPlayerName[i]:setString(LuaUtils.getDisplayNickName(pTableUser[2], 8, true))
                    self.m_pLbShowPlayerGold[i]:setString((pTableUser[6]))
                    self.m_pLbShowPlayerGold[i]:setVisible(true)
                end
            else
                self:replaceUserHeadSprite(self.m_changeUserAniVec[i], Brnn_Res.ANI_OF_CHANGEUSER.ANILIST.BEGIN,pTableUser[5], pTableUser[3])
                self.m_pSpNoPlayer[i]:setVisible(false)
                self.m_pNodeShowPlayer[i]:setVisible(true)
                self.m_pLbShowPlayerName[i]:setString(LuaUtils.getDisplayNickName(pTableUser[2], 8, true))
                self.m_pLbShowPlayerGold[i]:setString((pTableUser[6]))
                self.m_pLbShowPlayerGold[i]:setVisible(true)
            end

        end
    end
end

-- 更新上桌玩家分数
function GameViewLayer:updateTableUserScore()
    for i=1, cmd.TABEL_USER_COUNT do
        local pTableUser =  self:getUserInfoByUid((self.m_seats[i+1] or {})[1])
        if pTableUser and (pTableUser[1] ~= cc.exports.INVALID_CHAIR) then
            self.m_pLbShowPlayerGold[i]:setString((pTableUser[6]))
            self.m_pLbShowPlayerGold[i]:setVisible(true)
        end
    end
end

--切换用户头像
function GameViewLayer:replaceUserHeadSprite(armature, cfg, sex, faceId)
    if not cfg then
        return
    end

    local pBone = armature:getBone(cfg.NODES.HEAD)
    if pBone then
        local pNode = display.newNode()
        --local pSpValue1 = cc.Sprite:create('game/handredcattle/image/file/gui-icon-head-01.png')
        local pSpValue1 = cc.Sprite:create()
        local name = nil
        if sex ~= 0 then
            name = string.format('head_mman_%02d.png', faceId % 10 + 1)
        else
            name = string.format('head_mwoman_%02d.png', faceId % 10 + 1)
        end

        pSpValue1:setSpriteFrame( name )
        pNode:addChild(pSpValue1)
        pBone:addDisplay(pNode, 0)
        pBone:changeDisplayWithIndex(0, true)
    end
end


--上桌玩家投注时头像抖动动画
function GameViewLayer:playTableUserChipAni(idx)
    --[[
        桌子玩家位置索引
        2 1
        3 5
        4 6
        1是神算子 2-6富豪榜1-5名
    ]]--
    local offsetX = { -30, 30, 30, 30, -30, -30 }
    local ts = 0.1

    print('idx='..idx)
    self.m_userBtnVec[idx]:stopAllActions()
    self.m_userBtnVec[idx]:setPosition(self.m_userBtnResPosVec[idx])

    local moveTo = cc.MoveTo:create(ts, cc.p(self.m_userBtnResPosVec[idx].x + offsetX[idx], self.m_userBtnResPosVec[idx].y))
    local moveBack = cc.MoveTo:create(ts, self.m_userBtnResPosVec[idx])
    local seq = cc.Sequence:create(moveTo, moveBack)

    self.m_userBtnVec[idx]:runAction(seq)
end

function GameViewLayer:switchDealerImage()

    if self.isUpBanker and not self:isBanker() then
        self.m_pImageBeZhuang:setVisible(false)
        self.m_pImageCancelZhuang:setVisible(false)
        self.m_pImageCheckZhuangList:setVisible(true)
    elseif self:isBanker() then
        self.m_pImageBeZhuang:setVisible(false)
        self.m_pImageCancelZhuang:setVisible(true)
        self.m_pImageCheckZhuangList:setVisible(false)
    end

end

function GameViewLayer:getDealerQueue()

    return self.bankersTable
end

function GameViewLayer:isSelfInDealerQueue()
    for i, v in pairs(self.bankersTable) do
        if v[1] ==  GlobalUserItem.tabAccountInfo.userid then
            return true
        end
    end

    return false
end

--判断是否为当前庄家
function GameViewLayer:isCurDealer(uid)
    if uid == self.bankerUid and uid ~= nil then
        return true
    end

    return false
end

--根据牌值调整牌位置
function GameViewLayer:adjustCardPos(idx)

    local nDealerValue = self.pokerData[idx][2]--[target][2]
    if nDealerValue ~= 0 then
        self.Pokers[idx][1]:setPositionY(self.Pokers[idx][1]:getPositionY() + 20)
        self.Pokers[idx][2]:setPositionY(self.Pokers[idx][2]:getPositionY() + 20)
        self.Pokers[idx][3]:setPositionY(self.Pokers[idx][3]:getPositionY() + 20)

        self.Pokers[idx][4]:setPositionX(self.Pokers[idx][4]:getPositionX() + 10)
        self.Pokers[idx][5]:setPositionX(self.Pokers[idx][5]:getPositionX() + 10)
    end
end

-- 通杀、通赔
function GameViewLayer:playTongEffect()

    local tem = self.player_winZodics
    local showTongShaEffect = true
    local showTongPeiEffect = true
    for i = 1, 4 do
        if tem[i]<0 then
            showTongPeiEffect = false
        end
        if tem[i]>0 then
            showTongShaEffect = false
        end
    end

    print('GameViewLayer:playTongEffect')

    ------local tongType = event._userdata
    ------local animNode = self['tongResult'..tongType]
    ------local animNode = cc.Node:create()


    local tongType = nil
    if showTongShaEffect then
        tongType = 1
    elseif showTongPeiEffect then
        tongType = 2
    else
        return
    end

    local csbPath = string.format('game/handredcattle/HandredcattleResutl%d.csb', tongType)
    local animNode = cc.Sprite:create('game/handredcattle/image/empty.png')
    local animNode = cc.CSLoader:createNode(csbPath)
    if animNode == nil then
        print('invalid tong anim node type:')
        return
    end

    animNode:setPosition(0,0)
    animNode:addTo(self.m_pNodeDlg, 100)
    --animNode:setScale(100)

    animNode:setVisible(true)
    _:playTimelineAction(csbPath, 'animation0', animNode, false)
    ExternalFun.playSoundEffect(string.format('game/handredcattle/sound/tong_%d.mp3', tonumber(tongType)), false)
    Define:performWithDelay(animNode, function()
        animNode:removeFromParent()
    end, 1.2)
end

--设置庄家头像
function GameViewLayer:setBankerHeadByUid()

    local bankerInfo = nil
    for i , v in pairs(self.playerInfoTable) do
        if self.bankerUid == v[1] then
            bankerInfo = v
        end
    end

    if bankerInfo then
        loadHeadMiddleSprite(self.m_pLbZhuangHead,bankerInfo[3], bankerInfo[5])
        createStencilAvatar(self.m_pLbZhuangHead)
    end
end

--根据uid获取玩家信息
function GameViewLayer:getUserInfoByUid(uid)

    if not uid then
        return nil
    end

    for i , v in pairs(self.playerInfoTable) do
        if uid == v[1] then
            return v
        end
    end

    return nil
end

--判断是否是桌上用户
function GameViewLayer:isInTable(uid)

    -- 第一个是庄,所以要加1 减1
    if not uid then
        return false
    end

    for i, v in pairs(self.m_seats) do

        if i > cmd.TABEL_USER_COUNT + 1 then
            return false
        end

        if i ~= 1 then
            if uid == v[1] then
                return true, i-1
            end
        end
    end

    return false
end

--添加筹码文字
function GameViewLayer:addJettonLabel(psprite, money_)

    if not psprite or not money_ then
        return
    end

    --筹码
    local txtnum = ""
    txtnum = money_
    if money_ >= 10000 then
        txtnum = tostring(money_/10000).."万"
    end

    local rect = psprite:getContentSize()
    local label = ccui.Text:create(txtnum,"fonts/round_body.ttf",25)
    label:enableOutline(cc.c4b(0,0,0,255), 1)
    label:enableShadow(cc.c3b(0,0,0), cc.size(0,-2), 1)  --阴影
    label:setPosition(cc.p(rect.width/2,rect.height/2+9))
    psprite:addChild(label,1)

end

function GameViewLayer:getJettonEndPosByIndex(areaIndex)

    local chipEnd_x , chipEnd_y = 0 , 0
    if areaIndex == 0 then
        chipEnd_x = math.random(210,370)
        chipEnd_y = math.random(310,400)
    elseif areaIndex == 1 then
        chipEnd_x = math.random(460,620)
        chipEnd_y = math.random(310,400)
    elseif areaIndex == 2 then
        chipEnd_x = math.random(700,865)
        chipEnd_y = math.random(310,400)
    elseif areaIndex == 3 then
        chipEnd_x = math.random(940,1110)
        chipEnd_y = math.random(310,400)
    end

    return chipEnd_x, chipEnd_y
end

------
------------------------------------------------------------------------
function _:playTimelineAction(path, actionName, root, repeat_)
    if repeat_ == nil then
        repeat_ = true
    end

    local ac2 = cc.CSLoader:createTimeline(path)
    if ac2:IsAnimationInfoExists(actionName) == true then
        ac2:play(actionName, repeat_)
    end
    root:runAction(ac2)
end
------------------------------------------------------------------------

return GameViewLayer