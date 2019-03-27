--
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local HeadSprite               = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
--local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
--local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")

local module_pre = "game.yule.lhdz.src."

local LhdzDataMgr           = appdf.req(module_pre.."game.longhudazhan.manager.LhdzDataMgr")
local Lhdz_Res              = appdf.req(module_pre.."game.longhudazhan.scene.Lhdz_Res")
local Lhdz_Const            = appdf.req(module_pre.."game.longhudazhan.scene.Lhdz_Const")
local ParticalPool          = appdf.req(module_pre.."game.longhudazhan.bean.ParticalPool")

local ChipFlyManager        = appdf.req(module_pre.."game.longhudazhan.bean.ChipFlyManager")
local LhdzRuleLayer         = appdf.req(module_pre.."game.longhudazhan.layer.DragonHelpView")
local LhdzUserInfoLayer     = appdf.req(module_pre.."game.longhudazhan.layer.LhdzUserInfoLayer")
local LhdzOtherInfoLayer    = appdf.req(module_pre.."game.longhudazhan.layer.LhdzOtherInfoLayer")
local MessageBoxNew         = appdf.req(module_pre.."game.longhudazhan.layer.LhdzMessageBox")
local TrendView             = appdf.req(module_pre.."game.longhudazhan.trend.TrendView")
local DragonRoundResultView = appdf.req(module_pre.."game.longhudazhan.layer.DragonRoundResultView")
local SettingLayer          = appdf.req(module_pre.."game.longhudazhan.layer.SettingLayer")
local CBetManager           = appdf.req(module_pre.."models.CBetManager")

local MsgBoxPreBiz          = appdf.req(module_pre.."models.MsgBoxPreBiz")
local Effect                = appdf.req(module_pre .. "models.Effect");
local PlayerInfo = appdf.req(appdf.EXTERNAL_SRC .. "PlayerInfo")
appdf.req("game.yule.lhdz.src.models.helper")
appdf.req("game.yule.lhdz.src.models.gameConstants")
local FloatMessage = cc.exports.FloatMessage
local GameViewLayer = class("GameViewLayer",function(scene)
        local gameViewLayer = display.newLayer()
    return gameViewLayer
end)
local Chip_EnableOpacity = 255
local Chip_DisableOpacity = 180

local TAG_ROUNDRESULT_UI = 31

local _ = {}

local function LOG_PRINT(...) if true then printf(...) end end
---------------------------- constructor --------------------------------------
--GameViewLayer.instance_ = nil
--function GameViewLayer.create()
--    GameViewLayer.instance_ = GameViewLayer.new()
--    return GameViewLayer.instance_
--end

--function GameViewLayer.getInstance()
--    return GameViewLayer.instance_
--end

function GameViewLayer:ctor(scene)
    -- 进入游戏重置设计分辨率
    --display.setAutoScale({width = 1280, height = 720, autoscale = "EXACT_FIT"})
    --cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(1280, 720, cc.ResolutionPolicy.EXACT_FIT)
    --cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(1334,750,cc.ResolutionPolicy.NO_BORDER)
    --LuaUtils.setIphoneXDesignResolution()
    self._scene = scene

    self:enableNodeEvents()
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))
end

function GameViewLayer:onEnter()
    LOG_PRINT(" - GameViewLayer onEnter - ")
    self:init()
end

function GameViewLayer:onExit()
    if self._ClockFun then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._ClockFun) 
    end
    if self._XuyaFun then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._XuyaFun)
    end
    self:clear()

    LOG_PRINT(" - GameViewLayer onExit - ")
end

-- 初始化变量
function GameViewLayer:initAllVar_()
    self.m_rootUI = nil             -- 根节点
    -- node.
    self.m_pNodeRoot = nil
    self.m_pNodeTable = nil
    self.m_pNodeBetArea = nil
    self.m_pNodeBetValue = nil
    self.m_pNodeHistory = nil
    self.m_pNodeBanker = nil
    self.m_pNodeCountTime = nil

    self.m_pNodeButton = nil

    self.m_pNodeJetton = nil
    self.m_pNodeUserInfo = nil
    self.m_pNodePlayer = nil
    self.m_pNodeOnliePlayer = nil
    self.m_pNodeShowPlayer = {}
    self.m_pNodeChip = nil
    self.m_pNodeArmature = nil
    self.m_FileNodeStartEnd = nil
    self.m_pNodeBackground = nil
    self.m_pNodeLantern = nil
    self.m_pNodeStar = nil
    self.m_pNodeUserTips = nil
    self.m_pNodeAnimVS = nil
    self.m_pNodeTips = nil
    -- btn
    self.m_pBtnExit = nil
    self.m_pBtnMenuPush = nil
    self.m_pBtnMenuPop = nil
    self.m_pBtnTrend = nil
    self.m_pBtnMenuClose = nil
    self.m_pBtnContinue = nil
    self.m_pBtnRule = nil
    self.m_pBtnEffect = nil
    self.m_pBtnMusic = nil
    self.m_pBtnBank = nil
    self.m_pBtnOnliePlayer = nil
    self.m_pBtnJetton = {}
    self.m_pBtnBetArea = {}
    self.m_pBtnUserInfo = {}
    --
    self.m_pSpCountTime = nil
    self.m_pSpStauts = nil
    self.m_pSpHistoryNew = nil
    self.m_pSpHistoryLight = nil
    self.m_pSpBankerTips = nil
    self.m_pNodeTablePlayer = {}
    self.m_pSpHeadIcon = {}
    self.m_pSpNoPlayer = {}
    self.m_pSpHistory = {}
    self.m_pSpStar = {}
    self.m_pSpWinArea = {}
    self.m_pParticleStar = {}

    self.m_pLbUserName = nil
    self.m_pLbUserGold = nil
    self.m_pLbResultGold = nil
    self.m_pLbCountTime = nil
    self.m_pLbBankerName = nil
    self.m_pLbBankerGold = nil
    self.m_pLbCondition = nil
    self.m_pLbBankerCount = nil
    self.m_pLbOnlieCount = nil
    self.m_pLbAllBetValue = {}
    self.m_pLbMyBetValue = {}
    self.m_pLbMyBetBg = {}
    self.m_pLbShowPlayerName = {}
    self.m_pLbShowPlayerGold = {}
    self.m_pLbTableResultGold = {}

    self.lightStar_bagua = {} --八卦光效
    self.flyStar_bagua = {} --八卦

    ----------------
    -- 自己的下注筹码
    self.m_vecSelfJetton = {}
    for i = 1,3  do
        self.m_vecSelfJetton[i] = 0
    end
    
    -- 上桌玩家的下注筹码
    self.m_vecPlayerJetton = {}
    for i = 1, Lhdz_Const.TABEL_USER_COUNT do
        self.m_vecPlayerJetton[i] = {}
    end
    -- anim
    self.m_pAnimWaitNext = nil
    self.m_pAnimCard = {}
    self.m_bIsShowStar = {false, false, false}
    --self.m_areaWinEffect = {}

    -- 变量
    self.m_bIsMenuMove = false
    self.m_bIsPlayVSAnim = false
    self.m_bIsRequestRank = false
    self.m_isPlayBetSound = false
    self.m_nIndexChoose = 0
    self.m_tmLastClicked = 0
    self.m_iLastPlayerGold = 0
    self.m_getChipEffect = {}
    self.m_userBtnVec = {}
    self.m_userBtnResPosVec = {}
    self.m_particalvec = {}
    self.m_bEnterBackground = false
    self.m_changeUserAniVec = {}            --上桌玩家切换时动画

    --神算子和大富豪中奖特效
    self.m_luckyWinEffect = nil
    self.m_richWinEffect = nil
    self.m_dNo1AllBet = {0,0,0} -- 神算子的投注
    self.m_flyJobVec = {} --飞行筹码任务清空
    self.m_chipMgr = nil
    self.delerID = 0
    self.delermoneys = 0
end
---------------------------- constructor --------------------------------------

---------------------------------- init view start ----------------------------------
function GameViewLayer:init() --onEnter:init
    self:initVar()
    self:initRes()
    self:initCCB()
    self:initNode()
    self:initChipMgr()
    self:initGame()
--    local _do = {
--        { func = self.initVar,      log = "初始化变量",  },
--        { func = self.initCCB,      log = "加载界面",    },
--        { func = self.initNode,     log = "初始化界面",  },
--        { func = self.initChipMgr,  log = "初始飞筹码",  },
--        { func = self.initEvent,    log = "注册监听",    },
--        { func = self.initGame,     log = "初始化游戏",  },
--    }
--    for i, init in pairs(_do) do
--        LOG_PRINT(" - [%d] - [%s] - %s", i, init.func(self) or "ok",  init.log)
--    end
end

function GameViewLayer:clear() --onExit:clear
--    local _do = {
--        { func = self.cleanEvent,   log = "取消监听",   },
--        { func = self.cleanGame,    log = "清理游戏",   },
--    }
--    for i, clean in pairs(_do) do
--        LOG_PRINT(" - [%d] - [%s] - %s", i, clean.func(self) or "ok", clean.log)
--    end
    self:cleanGame()
end

function GameViewLayer:initVar()
    self:initAllVar_()
end

-- 加载界面
function GameViewLayer:initCCB()
    LOG_PRINT("GameViewLayer:initCSB111")
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
    -- load csb.
    self.m_rootWidget = cc.CSLoader:createNode(Lhdz_Res.CSB_OF_MAINSCENE)
    local diffY = (display.size.height - 720) / 2
    -- 屏幕适配，截取可视区域
    local shap = cc.DrawNode:create()
    local pointArr = {cc.p(0,0), cc.p(1624, 0), cc.p(1624, 750), cc.p(0, 750)}
    shap:drawPolygon(pointArr, 4, cc.c4f(255, 255, 255, 0), 2, cc.c4f(255, 255, 255, 0))
    self.m_pClipping = cc.ClippingNode:create(shap)
    self.m_pClipping:setPosition(cc.p(0,diffY))
    --self.m_pClipping:addChild(self.m_rootWidget)
    self.m_rootUI:addChild(self.m_rootWidget)
    
    local diffX = 145 - (1624-display.size.width)/2 
    self.m_pNodeRoot = self.m_rootWidget:getChildByName("Panel_root")
    self.m_pNodeRoot:setPositionX(diffX)
    -----node-----------
    --self.m_pNodeBackground = self.m_pNodeRoot:getChildByName("Node_background")
    -- 灯笼
    --self.m_pNodeLantern = self.m_pNodeRoot:getChildByName("Node_lantern")
    -- 桌子节点
    self.m_pNodeTable = self.m_pNodeRoot:getChildByName("Node_table")
    -- 下注区域节点
    self.m_pNodeBetArea = self.m_pNodeTable:getChildByName("Node_betArea")
    -- 下注数值节点
    self.m_pNodeBetValue = self.m_pNodeTable:getChildByName("Node_betValue")
    -- 历史记录节点
    self.m_pNodeHistory = self.m_pNodeTable:getChildByName("Node_history")
    -- 庄家节点
    self.m_pNodeBanker = self.m_pNodeTable:getChildByName("Node_banker")
    -- 倒计时节点
    self.m_pNodeCountTime = self.m_pNodeTable:getChildByName("Node_countTime")
    -- 神算子星
    self.m_pNodeStar = self.m_pNodeTable:getChildByName("Node_star")
    -- 新下注节点
    self.m_pNodeChipNew = self.m_pNodeTable:getChildByName("Node_chip")

    self.m_pNodeButton = self.m_pNodeRoot:getChildByName("Node_button")

    self.m_pNodeJetton = self.m_pNodeRoot:getChildByName("Node_jetton")

    self.m_pNodeUserInfo = self.m_pNodeRoot:getChildByName("Node_userInfo")
    
    self.m_pNodePlayer = self.m_pNodeRoot:getChildByName("Node_player")
    self.m_pNodeOnliePlayer = self.m_pNodePlayer:getChildByName("Node_onliePlayer")

    -- local animationEvent = function(armatureBack, movementType, movementID)
    --     if movementType == ccs.MovementEventType.complete then
    --         if movementID == Lhdz_Res.ANI_OF_CHANGEUSER.ANILIST.BEGIN.NAME then
    --             local faceid = armatureBack:getTag()
    --             self:replaceUserHeadSprite(armatureBack, Lhdz_Res.ANI_OF_CHANGEUSER.ANILIST.BEGIN, faceid)
    --             armatureBack:getAnimation():play(Lhdz_Res.ANI_OF_CHANGEUSER.ANILIST.END.NAME)
    --         elseif movementID == Lhdz_Res.ANI_OF_CHANGEUSER.ANILIST.END.NAME then

    --         end
    --     end
    -- end
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(Lhdz_Res.ANI_OF_CHANGEUSER.FILEPATH)
    for i=1, Lhdz_Const.TABEL_USER_COUNT do
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
        self.m_pLbShowPlayerGold[i] = self.m_pNodeShowPlayer[i]:getChildByName("BitmapFontLabel_showPlayer_gold")
        self.m_pBtnUserInfo[i] = self.m_pNodeShowPlayer[i]:getChildByName("Button_userInfo")

        self.m_changeUserAniVec[i] = ccs.Armature:create(Lhdz_Res.ANI_OF_CHANGEUSER.FILENAME)
        self.m_changeUserAniVec[i]:addTo(self.m_userBtnVec[i]:getChildByName("Node_ani"))
        self.m_changeUserAniVec[i]:setTag(255)
    end

    self.m_pNodeChip = self.m_pNodeRoot:getChildByName("Node_chip")
    self.m_pNodeUserTips = self.m_pNodeRoot:getChildByName("Node_userTips")
    self.m_pNodeArmature = self.m_pNodeRoot:getChildByName("Node_anim")
    self.m_FileNodeStartEnd = self.m_pNodeRoot:getChildByName("FileNode_start_end")
    self.m_FileNodeStartEnd:setVisible(false)
    self.m_pNodeAnimVS = self.m_pNodeRoot:getChildByName("Panel_animVS")
    self.m_pNodeTips = self.m_pNodeRoot:getChildByName("Node_tips")
    self.m_pNodeTips:setPosition(cc.p(667, 245))
    
    -------------------
    self.m_pSpMenuBg = self.m_pNodeButton:getChildByName("Sprite_menu_bg")
    ----- Button --------
    self.m_pBtnMenuPush = self.m_pNodeButton:getChildByName("Button_push")
    --self.m_pBtnMenuPop = self.m_pNodeButton:getChildByName("Button_pop")
    self.m_pBtnTrend = self.m_pNodeButton:getChildByName("Button_trend")
    self.m_pBtnTrend2 = self.m_pNodeButton:getChildByName("Button_trend2")
    self.m_pBtnContinue = self.m_pNodeButton:getChildByName("Button_continue")
    self.m_pBtnExit = self.m_pSpMenuBg:getChildByName("Button_exit")
    self.m_pBtnMenuClose = self.m_pNodeButton:getChildByName("Button_menu_close")
    self.m_pBtnMenuClose:setVisible(false)
    self.m_pBtnRule = self.m_pSpMenuBg:getChildByName("Button_rule")
    self.m_pBtnSetting = self.m_pSpMenuBg:getChildByName("Button_set")
    --self.m_pBtnEffect = self.m_pSpMenuBg:getChildByName("Button_effect")
    --self.m_pBtnMusic = self.m_pSpMenuBg:getChildByName("Button_music")
    -- 银行保险柜
    self.m_pBtnStrongBox = self.m_pSpMenuBg:getChildByName("Button_strongBox")
    self.m_pBtnBank = self.m_pNodeUserInfo:getChildByName("Button_bank")
    self.m_pBtnBank:setVisible(false)
    self.m_pBtnStrongBox:setBrightStyle(2)
    self.m_pBtnStrongBox:setEnabled(false)
    
    --其他在线玩家
    self.m_pBtnOnliePlayer = self.m_pNodeOnliePlayer:getChildByName("Button_onlie")
    -- 上庄 下庄
    self.m_pBtnUpBanker = self.m_pNodeBanker:getChildByName("Button_upBanker")
    self.m_pBtnDownBanker = self.m_pNodeBanker:getChildByName("Button_downBanker")

    -- 下注筹码
    for i =1, Lhdz_Const.JETTON_ITEM_USE_COUNT do
        self.m_pBtnJetton[i] = self.m_pNodeJetton:getChildByName(string.format("Button_jetton%d", i))
    end

    -- 下注区域
    for i = 1, Lhdz_Const.GAME_DOWN_COUNT do
        self.m_pBtnBetArea[i] = self.m_pNodeBetArea:getChildByName(string.format("Button_betArea_%d", i))
        --self.m_pSp
    end
    ------sprite------
    -- 倒计时
    self.m_pLvCountTime = self.m_pNodeCountTime:getChildByName("listView_countdownLv")
    -- 状态
    self.m_pSpStauts = self.m_pNodeCountTime:getChildByName("Sprite_status")
    self.m_pSpStautsKaipai = self.m_pNodeCountTime:getChildByName("Sprite_status_kaipai")

    -- 历史记录
    for i=1, Lhdz_Const.MAX_HISTORY_COUNT-5 do
        self.m_pSpHistory[i] = self.m_pNodeHistory:getChildByName(string.format("Sprite_history_%d", i))
    end
    self.m_pSpHistoryNew = self.m_pNodeHistory:getChildByName("Sprite_history_new")
    self.m_pSpHistoryLight = self.m_pNodeHistory:getChildByName("Sprite_history_light")
    -- 星星
    for i=1, Lhdz_Const.GAME_DOWN_COUNT do
        self.m_pSpStar[i] = self.m_pNodeStar:getChildByName(string.format("Sprite_star%d", i))
        self.m_pSpStar[i]:setLocalZOrder(100)
        self.m_pSpWinArea[i] = self.m_pNodeBetArea:getChildByName(string.format("Sprite_winArea_%d", i))
    end
    ------label---------
    -- 庄家名称
    self.m_pLbBankerName = self.m_pNodeBanker:getChildByName("Text_banker_name")
    -- 庄家金币
    self.m_pLbBankerGold = self.m_pNodeBanker:getChildByName("BitmapFontLabel_banker_gold")
    -- 上庄条件
    self.m_pLbCondition = self.m_pNodeBanker:getChildByName("Text_condition")
    -- 上庄人数
    self.m_pLbBankerCount = self.m_pNodeBanker:getChildByName("Text_banker_count")
    -- 庄家输赢
    self.m_pLbBankerResultGold = self.m_pNodeBanker:getChildByName("BitmapFontLabel_bankResult")
    self.m_pLbBankerResultGold:setVisible(false)
    self.m_pLbBankerResultGold:setAnchorPoint(0.5, 0.5)
    -- 其他玩家数量
    self.m_pLbOnlieCount = self.m_pNodeOnliePlayer:getChildByName("BitmapFontLabel_online")
    -- 倒计时数字
    self.m_pLbCountTime = self.m_pLvCountTime:getChildByName("BitmapFontLabel_countTime")
    --上庄列表
    self.m_pBtnBankList = self.m_pNodeBanker:getChildByName("btn_bank_list")
    self.m_pBankListNode = self.m_pNodeRoot:getChildByName("banklisgNode")
    self.m_pBankListNode:setVisible(false)
    self.m_pBankListBG = self.m_pBankListNode:getChildByName("banklisgbg")
    self.m_pBankListBG:setVisible(false)
    self.m_pBankNameList = self.m_pBankListBG:getChildByName("bankname_list")
    self.m_pBankNameList:setScrollBarEnabled(false)
    self.m_pClickMoveListBtn = self.m_pNodeRoot:getChildByName("Button_removebanklist")
    self.m_pClickMoveListBtn:setVisible(false)
    -- 玩家下注数
    for i=1, Lhdz_Const.GAME_DOWN_COUNT do
        self.m_pLbAllBetValue[i] = self.m_pNodeBetValue:getChildByName(string.format("BitmapFontLabel_allBetValue_%d", i))
        self.m_pLbMyBetValue[i] = self.m_pNodeBetValue:getChildByName(string.format("Text_myBetValue_%d", i))
        self.m_pLbMyBetBg[i] = self.m_pNodeBetValue:getChildByName(string.format("Sprite_myBetBg_%d", i))
    end
    -- 玩家昵称
    self.m_pLbUserName = self.m_pNodeUserInfo:getChildByName("Text_user_name")
    -- 玩家金币
    self.m_pLbUserGold = self.m_pNodeUserInfo:getChildByName("Node_score"):getChildByName("BitmapFontLabel_user_gold")
    self.m_pLbResultGold = self.m_pNodeUserInfo:getChildByName("BitmapFontLabel_userResult")
    --玩家头像
    self.m_pUserHeadNode = self.m_pNodeUserInfo:getChildByName("Node_ani")
    self.m_pUserHead = HeadSprite:createClipHead(GlobalUserItem.tabAccountInfo,94)
    self.m_pUserHead:addTo(self.m_pUserHeadNode)
    local spTx = cc.Sprite:create("common/tx/tx_2.png")
    spTx:addTo(self.m_pUserHeadNode,2)
    self.m_pNo1BetPre = self.m_pNodeTable:getChildByName("Node_shengsuanzi")
    self.m_pNo1BetPreNum = self.m_pNo1BetPre:getChildByName("BitmapFontLabel_shengshuanzi")
    self.m_pNo1BetPreNum:setString("")
    self.m_pNo1BetPreBar1 = self.m_pNo1BetPre:getChildByName("Image_bar_lift")
    self.m_pNo1BetPreBar2 = self.m_pNo1BetPre:getChildByName("Image_bar_right")
    self.m_pNo1BetPreBar3 = self.m_pNo1BetPre:getChildByName("Image_bar_mid")
    --历史记录节点
    self.m_pNodeHistoryNew = self.m_pNodeRoot:getChildByName("Node_history_new")
    self.m_trendView = TrendView:create( )
    self.m_pNodeHistoryNew:addChild(self.m_trendView)

    --其他玩家节点
    self.m_pNodeOtherPlayer = self.m_pNodeRoot:getChildByName("Node_otherPlayer")
end

-- 初始化界面
function GameViewLayer:initNode()
    LOG_PRINT(" GameViewLayer:initNode")
    --self.m_pBtnMenuPop:setVisible(false)
    --self.m_pSpMenuBg:setVisible(false)
    --local shap = cc.DrawNode:create()
    --local pointArr = {cc.p(1080,300), cc.p(1320, 300), cc.p(1320, 640), cc.p(1080, 640)}
    --shap:drawPolygon(pointArr, 4, cc.c4f(255, 255, 255, 255), 2, cc.c4f(255, 255, 255, 255))
    --self.m_pClippingMenu = cc.ClippingNode:create(shap)
    --self.m_pClippingMenu:addTo(self.m_pNodeMenu)
    --self.m_pSpMenuBg:removeFromParent()
    --self.m_pSpMenuBg:addTo(self.m_pClippingMenu)
    --self.m_pClippingMenu:setPosition(cc.p(0,0))

    self.m_pLbCountTime:setVisible(false)
    --展示桌面动画取消
    --self:showBackgroundAnim() --耗时
    -- 初始化按纽响应
    self:initBtnClickEvent()

    self:updateButtonOfSound()

    self:updateButtonOfMusic()

--    self:updateOnliePlayerCount()

    self:clearNo1BetStar()

    self:initChipEffect()

    self:initGetChipEffect() --耗时

    self:updateLuckerInfo()

    self:initTopWinEffect()

    self:tryLayoutforIphoneX()

    self.m_pLbUserName:setString(GlobalUserItem.tabAccountInfo.nickname)
    self.m_pUserHead = HeadSprite:createClipHead(GlobalUserItem.tabAccountInfo,94)
    self.m_pUserHead:addTo(self.m_pUserHeadNode)

    --房间号
--    local rooms = GameListManager.getInstance():getStructRoomByKindID(PlayerInfo.getInstance():getKindID(), PlayerInfo.getInstance():getBaseScore())
--    if #rooms > 1 then
--        local strRoomNo = string.format(LuaUtils.getLocalString("LHDZ_7"), PlayerInfo.getInstance():getCurrentRoomNo())
--        local m_pLbRoomNo = cc.Label:createWithBMFont(Lhdz_Res.FONT_ROOM, strRoomNo)
--        m_pLbRoomNo:setAnchorPoint(cc.p(0.5, 0.5))
--        m_pLbRoomNo:setPosition(cc.p(140, self.m_pBtnExit:getContentSize().height/2))
--        self.m_pBtnExit:addChild(m_pLbRoomNo)
--    end

    local scoreVal = GlobalUserItem.tabAccountInfo.into_money
--    if 0 == scoreVal and LhdzDataMgr.getInstance():getBankerId() == PlayerInfo.getInstance():getChairID() then
--        --自己是庄家，且分数为0，则可能是正好输完，或者退出重进过，则以庄家分数为准
--        scoreVal = LhdzDataMgr.getInstance():getBankerScore()
--    else
--        --非下注阶段加入游戏，则扣除赢取的金额
--        if Lhdz_Const.STATUS.GAME_SCENE_BET ~= LhdzDataMgr.getInstance():getGameStatus() then
--            local llAwardValue = LhdzDataMgr.getInstance():getMyResult()
--            if llAwardValue > 0 then
--                scoreVal = scoreVal - llAwardValue/(1 - Lhdz_Const.RESULT_PUMP) - LhdzDataMgr.getInstance():getAllMyBetValue()
--            else
--                scoreVal = scoreVal - llAwardValue - LhdzDataMgr.getInstance():getAllMyBetValue()
--            end
--        end
--    end
    self.m_pLbUserGold:setString(scoreVal)
    PlayerInfo.getInstance():setUserScore(scoreVal)
    -----------------------------------------------------------------------------
    
    for i = 1, Lhdz_Const.GAME_DOWN_COUNT do
        self.m_particalvec[i] = {}
        for j = 1, Lhdz_Const.FLYPARTICAL_COUNT do
            ParticalPool.getInstance():setResName(Lhdz_Res.PLIST_OF_BAGUA)
            self.m_particalvec[i][j] = ParticalPool.getInstance():takePartical()
            self.m_particalvec[i][j]:setPosition(Lhdz_Const.FLYSTAR.STAR_BEGINPOS)
            self.m_pNodeStar:addChild(self.m_particalvec[i][j])
        end
    end
    self:clearFlyStatus()
end

function GameViewLayer:initRes()
    -- 释放动画
    for _, strPathName in pairs(Lhdz_Res.vecAnim) do
        local strJsonName = string.format("%s%s/%s.ExportJson", Lhdz_Res.strAnimPath, strPathName, strPathName)
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(strJsonName)
    end
    -- 释放整图
    for _, strPathName in pairs(Lhdz_Res.vecPlist) do
        display.loadSpriteFrames(strPathName[1], strPathName[2])
    end
    -- 释放背景图
    for _, strFileName in pairs(Lhdz_Res.vecReleaseImg) do
        display.loadImage(strFileName)
    end
    -- 释放音频
    for _, strFileName in pairs(Lhdz_Res.vecSound) do
        AudioEngine.preloadEffect(strFileName)
    end
    -- 释放背景音乐
    for _, strFileName in pairs(Lhdz_Res.vecLoadingMusic) do
        AudioEngine.preloadEffect(strFileName)
    end
end

function GameViewLayer:initChipMgr()
    self.m_chipMgr = ChipFlyManager.getInstance()
    local data = {}
    data.chipNode = self.m_pNodeChipNew
    data.chipAreaVec = {}
    data.bankerPos = cc.p(244, 540)
    data.selfPos = cc.p(52, 24)
    --data.otherPos = cc.p(68, 125)
    data.otherPos = cc.p(self.m_pNodeOnliePlayer:getPosition())
    data.tableUserPos = {}
    data.chipPosVec = {}
    data.getChipEffect = self.m_getChipEffect

    for i = 1, 3 do
        local _node = self.m_pNodeChip:getChildByName("Panel_" .. i)
        local posx, posy = _node:getPosition()
        local sz = _node:getContentSize()
        _node:removeFromParent()
        data.chipAreaVec[i] = cc.rect(posx, posy, sz.width, sz.height )
    end

    for i = 1, 6 do
        data.tableUserPos[i] = cc.p(self.m_pNodeTablePlayer[i]:getPosition())
    end

    for i = 1, Lhdz_Const.JETTON_ITEM_USE_COUNT do
        data.chipPosVec[i] = cc.p(self.m_pBtnJetton[i]:getPosition())
        data.chipPosVec[i].y = data.chipPosVec[i].y + 14
    end

    self.m_chipMgr:setData(data)
end

-- 初始化按钮监听器
function GameViewLayer:initBtnClickEvent()
    self.m_pBtnExit:addClickEventListener(handler(self, self.onBtnExitClicked))
    self.m_pBtnMenuPush:addClickEventListener(handler(self, self.onClickBackMenu))
    --self.m_pBtnMenuPop:addClickEventListener(handler(self, self.onBtnMenuPopClicked))
    self.m_pBtnTrend:addClickEventListener(handler(self, self.onBtnTrendClicked))
    self.m_pBtnTrend2:addClickEventListener(handler(self, self.onBtnTrendClicked))
    self.m_pBtnMenuClose:addClickEventListener(handler(self, self.onClickHideMenu))
    self.m_pBtnContinue:addClickEventListener(handler(self, self.onBtnContinueClicked))
    self.m_pBtnRule:addClickEventListener(handler(self, self.onBtnRuleClicked))
    self.m_pBtnSetting:addClickEventListener(handler(self, self.onBtnSettingClicked))
    --self.m_pBtnEffect:addClickEventListener(handler(self, self.onBtnEffectClicked))
    --self.m_pBtnMusic:addClickEventListener(handler(self, self.onBtnMusicClicked))
    self.m_pBtnBank:addClickEventListener(handler(self, self.onBtnBankClicked))
    self.m_pBtnStrongBox:addClickEventListener(handler(self, self.onBtnBankClicked))
    self.m_pBtnOnliePlayer:addClickEventListener(handler(self, self.onBtnOtherPlayerClicked))
    self.m_pBtnBankList:addClickEventListener(handler(self, self.ClickBankList))
    self.m_pClickMoveListBtn:addClickEventListener(handler(self, self.ClickRemoveBankList))
    for i =1, Lhdz_Const.JETTON_ITEM_USE_COUNT do
        self.m_pBtnJetton[i]:addClickEventListener(handler(self, self.onBtnJettonNumClicked))
    end
    for i = 1, Lhdz_Const.GAME_DOWN_COUNT do
        self.m_pBtnBetArea[i]:addClickEventListener(handler(self, self.onBtnAreaClicked))
    end
    self.m_pBtnUpBanker:addClickEventListener(handler(self, self.onBtnUpBankerClicked))
    self.m_pBtnDownBanker:addClickEventListener(handler(self, self.onBtnDownBankerClicked))
    for i=1, Lhdz_Const.TABEL_USER_COUNT do
        self.m_pBtnUserInfo[i]:setTag(i)
        self.m_pBtnUserInfo[i]:addClickEventListener(handler(self, self.onBtnUserInfoClicked))
    end
end

-- 初始化事件
function GameViewLayer:initEvent()

end

-- 清理事件监听
function GameViewLayer:cleanEvent()

end

-- 清理游戏
function GameViewLayer:cleanGame()
    self.m_rootUI:stopAllActions()
    if self.m_bEnterBackground == false then
        --清理游戏数据
--        CMsgLhdz.getInstance():destroyCountDownShedule()
        LhdzDataMgr.getInstance():clear()
        LhdzDataMgr.releaseInstance()
        CBetManager.getInstance():clearUserChip()
        ParticalPool.getInstance():clearPool()
        ParticalPool.getInstance():releaseInstance()

        -- 释放动画
        for _, strPathName in pairs(Lhdz_Res.vecAnim) do
            local strJsonName = string.format("%s%s/%s.ExportJson", Lhdz_Res.strAnimPath, strPathName, strPathName)
            ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(strJsonName)
        end
        -- 释放整图
        for _, strPathName in pairs(Lhdz_Res.vecPlist) do
            display.removeSpriteFrames(strPathName[1], strPathName[2])
        end
        -- 释放背景图
        for _, strFileName in pairs(Lhdz_Res.vecReleaseImg) do
            display.removeImage(strFileName)
        end
        -- 释放音频
        for _, strFileName in pairs(Lhdz_Res.vecSound) do
            AudioEngine.unloadEffect(strFileName)
        end
        -- 释放背景音乐
        for _, strFileName in pairs(Lhdz_Res.vecLoadingMusic) do
            AudioEngine.unloadEffect(strFileName)
        end
    end

    self.m_chipMgr:clearAllChip()
    self.m_chipMgr:releaseInstance()
    self.m_chipMgr = nil
    PlayerInfo.getInstance():setEnterGame(false)
    PlayerInfo.getInstance():setSitSuc(false)

    LhdzDataMgr.getInstance():clearAllUserChip()

    self:removeAllChildren()
end

-- 进入游戏初始化
function GameViewLayer:initGame()
    --重置下注区域
    self.m_chipMgr:resetChipPosArea()
    -- 更新历史记录
    self:updateGameRecord()
    -- 更新庄家信息
    self:updatebankerInfo()
    -- 更新筹码面值
    self:updateJettonValues()
    -- 更新游戏状态
    self:updateGameStatus()
    -- 更新上桌玩家信息
    self:updateTableUserInfo()
    -- 更新筹码
    self:onBtnJettonNumClicked(self.m_pBtnJetton[1])
    self:updateJettonStatus()
    self:showWaitNextAnim()
    self:showSendCardAnim(false)
    self:updateContinueStatus(false)
    if LhdzDataMgr.getInstance():getGameStatus() ~= Lhdz_Const.STATUS.GAME_SCENE_FREE then
        -- 初始化刚进游戏已经下注的筹码
        self:initAlreadyJettion()
        -- 是否是神算子下注区域
        self:playFlyStarAnim(true)
        self:updateContinueStatus(true)
        if LhdzDataMgr.getInstance():getAllMyBetValue() > 0 then
            self:updateContinueStatus(false)
        end
    end
    -- 更新下注区域的数值
    self:updateBetAreaValue()

    --初始化庄家列表
    self:initBankListTable()

    --请求rank数据 更新神算子胜率
--    CMsgLhdz.getInstance():sendMsgRank(1)
end

-- 初始筹码
function GameViewLayer:initAlreadyJettion()
    local chipCount = LhdzDataMgr.getInstance():getAllUserChipCount()
    for i=1, chipCount do
        local chip = LhdzDataMgr.getInstance():getAllUserChipByIndex(i)
        if chip then
            self.m_chipMgr:createStaticChip(chip.wJettonIndex, chip.wChipIndex, chip.dwUserID)
        end
    end
end

---------------------------------- init view end ----------------------------------
function GameViewLayer:event_GameState(dataBuffer)         -- 进入
    PlayerInfo.getInstance():setChairID(GlobalUserItem.tabAccountInfo.userid)
    LhdzDataMgr.getInstance():setGameStatus(dataBuffer.step)
    self.money = GlobalUserItem.tabAccountInfo.into_money
    for k,v in ipairs(dataBuffer.members) do
        LhdzDataMgr.getInstance():addRankUserToList(v)
        if v[1] == dataBuffer.dealer then
            LhdzDataMgr.getInstance():setBankerName(v[2])
            LhdzDataMgr.getInstance():setBankerScore(v[6])
        end
    end
    self.m_pLbOnlieCount:setString("(" .. table.nums(dataBuffer.members) .. ")")
    for k,v in ipairs(dataBuffer.dealers) do
        LhdzDataMgr.getInstance():addBankerList(v[1])
    end
    self.delerID = dataBuffer.dealer
    local chip = {1,10,50,100,500};
    for i=1,tonumber(Lhdz_Const.JETTON_ITEM_COUNT),1 do
        print(dataBuffer.chips[i])
        CBetManager.getInstance():setJettonScore(i,dataBuffer.chips[i]);
    end
    self:updateJettonValues()
    LhdzDataMgr.getInstance():setBankerResult(dataBuffer.dealer_winlost)
    LhdzDataMgr.getInstance():setMinBankerScore(dataBuffer.min_dealermoney)
    LhdzDataMgr.getInstance():setBankerTimes(dataBuffer.dealer_times)

    for i =1, Lhdz_Const.TABEL_USER_COUNT do
        LhdzDataMgr.getInstance():addTableUserInfo(dataBuffer.rank8[i+1])
        LhdzDataMgr.getInstance():addTableUserIdLast(dataBuffer.rank8[i+1][1])
    end
    self:updateTableUserInfo()
    
    for i = 1,#dataBuffer.path do   
        local cbHistorys = {}
        cbHistorys.cbAreaType = 0
        cbHistorys.bNewest = true
        --cbAreaType = 0,bNewest = true      
        if     dataBuffer.path[i][1] == 1 then   cbHistorys.cbAreaType = 1
        elseif dataBuffer.path[i][2] == 1 then   cbHistorys.cbAreaType = 2
        else cbHistorys.cbAreaType = 3
        end
        LhdzDataMgr.getInstance():addTempHistory(cbHistorys)
    end

    CBetManager.getInstance():setTimeCount(dataBuffer.timeout)
    self._ClockFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                self:event_CountTime()
            end, 1, false)   
    self:event_GameStatus()
    --更新走势界面
    self.m_trendView:updateTrend()
end
function GameViewLayer:intoBetMoney(dataBuffer)    -- 下注

    LhdzDataMgr.getInstance():setGameStatus(1)
    CBetManager.getInstance():setTimeCount(dataBuffer.timeout)
    self:event_GameStatus()
--    self:event_Chip(msg)
end
function GameViewLayer:onGameEnd(dataBuffer)      -- 结算
    LhdzDataMgr.getInstance():setGameStatus(2)
    CBetManager.getInstance():setTimeCount(dataBuffer.timeout)

    for k,v in ipairs(dataBuffer.moneys) do
        if self.delerID == v[1] then
            self.delermoneys = v[2]
        end
    end 

    local cbHistorys = {
                               cbAreaType = 0,
                               bNewest = true 
                        }
   
    if     dataBuffer.win_zodics[1] == 1 then cbHistorys.cbAreaType = 1
    elseif dataBuffer.win_zodics[2] == 1 then cbHistorys.cbAreaType = 2
    else   cbHistorys.cbAreaType = 3
    end
    LhdzDataMgr.getInstance():addTempHistory(cbHistorys)
--    LhdzDataMgr.getInstance():addHistoryToList(cbHistorys)
    if dataBuffer.mywin == 0 then
        LhdzDataMgr.getInstance():clearMyUserChip()
        LhdzDataMgr.getInstance().m_vecContinueChip = {}
    end
      
    local handcard = {}
    for i = 1, 2 do
        if dataBuffer.hands[i] >= 0 and dataBuffer.hands[i] <= 12 then
            handcard[i] = dataBuffer.hands[i]+1
        elseif dataBuffer.hands[i] >= 13 and dataBuffer.hands[i] <= 25 then
            handcard[i] = dataBuffer.hands[i]+4
        elseif dataBuffer.hands[i] >= 26 and dataBuffer.hands[i] <= 38 then
            handcard[i] = dataBuffer.hands[i]+7
        elseif dataBuffer.hands[i] >= 39 and dataBuffer.hands[i] <= 51 then
            handcard[i] = dataBuffer.hands[i]+10
        end
    end
    LhdzDataMgr.getInstance():setCards(handcard)

    local AreaType = 0
    --添加结果类型 符合新代码
    local resultType = nil
    if dataBuffer.win_zodics[1] == 1 then
        AreaType = 1
        resultType = 0
    elseif dataBuffer.win_zodics[2] == 1 then
        AreaType = 2
        resultType = 2
    else
        AreaType = 3
        resultType = 1
    end
    LhdzDataMgr:getInstance():setAreaType(AreaType)    
    LhdzDataMgr:getInstance():setMyResult(dataBuffer.mywin)
    LhdzDataMgr:getInstance():setBankerResult(dataBuffer.dealer_win)
    local result = {
        cards = handcard,
        playercoinchange = dataBuffer.mywin,
        dealerwincoin = dataBuffer.dealer_win,
        result = resultType,
    }
    LhdzDataMgr.getInstance():setResult(result)
    for i =1, Lhdz_Const.TABEL_USER_COUNT do
        LhdzDataMgr:getInstance():setTableResult(i,dataBuffer.rank8_wins[i][2])
    end
  
    self:event_GameStatus()
    self:event_GameResult()
end
function GameViewLayer:onDeskOver(dataBuffer)        -- 空闲
    LhdzDataMgr.getInstance():setGameStatus(3)
--    CBetManager.getInstance():setTimeCount(dataBuffer)
    self.m_BetMoney = 0
    for i = 1 , 3 do
        LhdzDataMgr.getInstance():setMyBetValue(i,self.m_BetMoney)
        LhdzDataMgr.getInstance():setOtherBetValue(i,0)
        self.m_vecSelfJetton[i] = 0
    end
    LhdzDataMgr.getInstance():clearTableBetValues()
    LhdzDataMgr.getInstance():clearNo1Bet()
    self:doSomethingLater(function( ... )
        self:event_CountTime()
        self:event_GameStatus()
    end, 1)

end

function GameViewLayer:otherBetMoney(dataBuffer)
    print(dataBuffer[4])
    local lastChip = {};
    --if dataBuffer[4] == 1 then lastChip.wJettonIndex = 1
    ----elseif dataBuffer[4] == 5 then lastChip.wJettonIndex = 2
    --elseif dataBuffer[4] == 10 then lastChip.wJettonIndex = 2
    --elseif dataBuffer[4] == 50 then lastChip.wJettonIndex = 3
    --elseif dataBuffer[4] == 100 then lastChip.wJettonIndex = 4
    --elseif dataBuffer[4] == 500 then lastChip.wJettonIndex = 5
    --end

    for i = 1, Lhdz_Const.JETTON_ITEM_COUNT do
        local jetton = CBetManager.getInstance():getJettonScore(i)
        if jetton == dataBuffer[4] then
            lastChip.wJettonIndex = i
            break
        end
    end
    
    lastChip.wChipIndex = dataBuffer[1] + 1
    lastChip.wChairID = dataBuffer[3]
    LhdzDataMgr.getInstance():addAllUserChip(lastChip)
    LhdzDataMgr.getInstance():setOtherBetValue(dataBuffer[1]+1,dataBuffer[2])
    for i = 1,Lhdz_Const.TABEL_USER_COUNT do
        for j = 1,Lhdz_Const.GAME_DOWN_COUNT do
            if dataBuffer[5][i+1][2][j] ~= 0 then
                LhdzDataMgr.getInstance():addTableBetValue(dataBuffer[5][i+1][1],j,dataBuffer[5][i+1][2][j])
            end
        end
    end
    if LhdzDataMgr.getInstance():getTableUserInfo(1)[1] == dataBuffer[3] then
        LhdzDataMgr.getInstance():setIsNo1BetByIndexAndChairId(dataBuffer[1]+1,dataBuffer[3])
    end
    local msg = {}
    msg.wChairID = dataBuffer[3]
    self:event_Chip(msg)
end
function GameViewLayer:myBetMoney(dataBuffer)
    local lastChip = {};
    --if dataBuffer[1] == 1 then lastChip.wJettonIndex = 1
    ----elseif dataBuffer[1] == 5 then lastChip.wJettonIndex = 2
    --elseif dataBuffer[1] == 10 then lastChip.wJettonIndex = 2
    --elseif dataBuffer[1] == 50 then lastChip.wJettonIndex = 3
    --elseif dataBuffer[1] == 100 then lastChip.wJettonIndex = 4
    --elseif dataBuffer[1] == 500 then lastChip.wJettonIndex = 5
    --end

    for i = 1, Lhdz_Const.JETTON_ITEM_COUNT do
        local jetton = CBetManager.getInstance():getJettonScore(i)
        if jetton == dataBuffer[1] then
            lastChip.wJettonIndex = i
            break
        end
    end
    
    lastChip.wChipIndex = dataBuffer[2] + 1
    lastChip.wChairID = GlobalUserItem.tabAccountInfo.userid
    LhdzDataMgr.getInstance():addAllUserChip(lastChip)
    LhdzDataMgr.getInstance():addMyUserChip(lastChip)
    self.m_vecSelfJetton[dataBuffer[2]+1] = self.m_vecSelfJetton[dataBuffer[2]+1] + dataBuffer[1]
    LhdzDataMgr.getInstance():setMyBetValue(dataBuffer[2]+1,self.m_vecSelfJetton[dataBuffer[2]+1])
    local msg = {}
    msg.wChairID = GlobalUserItem.tabAccountInfo.userid
    self.money = self.money - dataBuffer[1]
    self.m_pLbUserGold:setString(self.money)
    PlayerInfo.getInstance():setUserScore(self.money)

    self:event_Chip(msg)
end

function GameViewLayer:updataSeatinfo(dataBuffer)--{seats={} rank8={} }{[1]={} [2]={} [3]={} [4]={} [5]={} [6]={} [7]={} [8]={} [9]={} }
    LhdzDataMgr.getInstance():clearTableUserInfo()
    for i =1, Lhdz_Const.TABEL_USER_COUNT do
        LhdzDataMgr.getInstance():addTableUserInfo(dataBuffer.rank8[i])
    end
    self:updateTableUserInfo()
end

function GameViewLayer:updataSitup(dataBuffer)--{no=1 members={} }{[1]=68913414 [2]="闽北幽灵" }
    print("...")
end

function GameViewLayer:updataSitdown(dataBuffer)--{no=1 members={} }{[1]=98902625 [2]="小麻麻最可爱" }
    print("...")
end
function GameViewLayer:Nomoney(dataBuffer)
    FloatMessage.getInstance():pushMessageForString("钱数不足"..dataBuffer.."无法上庄!!")
end
function GameViewLayer:updealer(dataBuffer) -- 上庄
    LhdzDataMgr.getInstance():addBankerList(dataBuffer[1])
    self:event_BankerList()
end
function GameViewLayer:downDealers(dataBuffer) -- 下庄{[1]=66687911 [2]="你妈如此疯骚" }
    LhdzDataMgr.getInstance():delBankerList(dataBuffer[1])
    local banklist = LhdzDataMgr.getInstance():getBankerList()
    if banklist[1] == self.delerID then print("ok")
    else 
        for k,v in ipairs(LhdzDataMgr.getInstance():getRankUserByIndex()) do       
        if v[1] == banklist[1] then
            self.delerID = banklist[1]
            LhdzDataMgr.getInstance():setBankerScore(v[6])
            LhdzDataMgr.getInstance():setBankerName(v[2])
        end     
        end
    end

    self:updatebankerInfo()
    self:event_BankerList()
end
function GameViewLayer:updataDealers(dataBuffer) -- 换庄
    self.delerID = dataBuffer[1][1]
    for k,v in ipairs(LhdzDataMgr.getInstance():getRankUserByIndex()) do       
        if v[1] == dataBuffer[1][1] then
            LhdzDataMgr.getInstance():setBankerScore(v[6])
        end     
    end
    
    LhdzDataMgr.getInstance():setBankerName(dataBuffer[1][2])
    LhdzDataMgr.getInstance():clearBankerList()
    for k,v in ipairs(dataBuffer) do
        LhdzDataMgr.getInstance():addBankerList(v[1])
    end
    --初始化庄家列表
    local msg = {};
    msg.attachment = "CHANGEBANKER"
    self:event_BankerInfo(msg)
    self:event_BankerList()
end
--更新自身icon，昵称等信息
function GameViewLayer:updataPlayerPanpel(player_,plyertype)
    if plyertype then
        if player_[1] == GlobalUserItem.tabAccountInfo.userid then
            return
        end
        local isHavePlayer = false
        for key, player in ipairs(LhdzDataMgr.getInstance():getRankUserByIndex()) do
            if player[1] == player_[1] then
                isHavePlayer = true
            end
        end
        if isHavePlayer == false then
            LhdzDataMgr.getInstance():addRankUserToList(player_)
            self.m_pLbOnlieCount:setString("(" ..LhdzDataMgr.getInstance():getRankUserSize() .. ")")
        end
    else
        for key, player in ipairs(LhdzDataMgr.getInstance():getRankUserByIndex()) do
            if player[1] == player_ then
                table.remove(LhdzDataMgr.getInstance():getRankUserByIndex(),key)
                self.m_pLbOnlieCount:setString("(" ..LhdzDataMgr.getInstance():getRankUserSize() .. ")")
            end
        end
    end
    
end

function GameViewLayer:updataMyMoney(args)
    self.m_pLbUserGold:setString(args)
    self.money = args
    PlayerInfo.getInstance():setUserScore(args)
end


---------------------------------- btn click event start ----------------------------------
-- 退出游戏
function GameViewLayer:onBtnExitClicked(sender)
    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)

    if(LhdzDataMgr.getInstance():isBanker())then
        if(LhdzDataMgr.getInstance():getAllOtherBetValue() > 0)then
            --我是庄家，且有人下注
            FloatMessage.getInstance():pushMessage("LHDZ_1");
            return
        end
    end
    --有投注纪录
    if (LhdzDataMgr.getInstance():getUserChipCount() > 0)then
        if self.m_rootUI:getChildByName("Notice") then
            self.m_rootUI:getChildByName("Notice"):setVisible(true)
            return
        end
        --有投注纪录，则需要提示
        FloatMessage.getInstance():pushMessage("本轮游戏尚未结束，不能退出游戏！")
--        self:showMessageBox(Lhdz_Res.MESSAGEBOX_IMG.QUIT, MsgBoxPreBiz.PreDefineCallBack.CB_EXITROOM, true)
        return 
    end

--    self.m_pBtnExit:setEnabled(false)
--    PlayerInfo.getInstance():setEnterGame(false)
--    CMsgLhdz.getInstance():sendTableStandUp()
--    PlayerInfo.getInstance():setSitSuc(false)
    self:event_ExitGame()
end

function GameViewLayer:showMessageBox(msg, cb, timer) --打开确认框
    local box = self:getChildByName("MessageBox")
    if box then
        box:removeFromParent()
    end
    local pMessageBox = MessageBoxNew.create(msg, cb, timer)
    pMessageBox:setName("MessageBox")
    self:addChild(pMessageBox, 101)
end

-- 返回菜单
function GameViewLayer:onClickBackMenu()
    if self.m_bIsMenuMove then
        self.m_pSpMenuBg:stopAllActions()
        if LuaUtils.isIphoneXDesignResolution() then
            self.m_pSpMenuBg:runAction(cc.MoveTo:create(0.2, cc.p(-280, self.m_pSpMenuBg:getPositionY())))
        else
            self.m_pSpMenuBg:runAction(cc.MoveTo:create(0.2, cc.p(-100, self.m_pSpMenuBg:getPositionY())))
        end
        self.m_pBtnMenuPush:getChildByName("Image_4"):runAction(cc.Sequence:create(cc.RotateTo:create(0.2, 90),cc.CallFunc:create(function()
            self.m_pBtnMenuClose:setVisible(not self.m_pBtnMenuClose:isVisible())
            self.m_bIsMenuMove = not self.m_bIsMenuMove
        end)
        ))
    else
        self.m_pBtnMenuClose:setVisible(not self.m_pBtnMenuClose:isVisible())
        self.m_bIsMenuMove = not self.m_bIsMenuMove
        self.m_pSpMenuBg:stopAllActions()
        if LuaUtils.isIphoneXDesignResolution() then
            self.m_pSpMenuBg:runAction(cc.MoveTo:create(0.2, cc.p(100, self.m_pSpMenuBg:getPositionY())))
        else
            self.m_pSpMenuBg:runAction(cc.MoveTo:create(0.2, cc.p(100, self.m_pSpMenuBg:getPositionY())))
        end
        self.m_pBtnMenuPush:getChildByName("Image_4"):runAction(cc.RotateTo:create(0.2, -180))
        self.leftPanelDt = 5
    end
end

-- 点击隐藏菜单
function GameViewLayer:onClickHideMenu()
    -- self.backMenu:setVisible(false)
    self:onClickBackMenu()
end

---- 菜单下拉
--function GameViewLayer:onBtnMenuPushClicked(sender)
--    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
--    if self.m_bIsMenuMove then return end
--    self.m_bIsMenuMove = true
--
--    self.m_pSpMenuBg:setVisible(true)
--    self.m_pSpMenuBg:stopAllActions()
--    self.m_pSpMenuBg:setPositionY(955)
--    local moveTo = cc.MoveTo:create(0.2, cc.p(self.m_pSpMenuBg:getPositionX(), 485))
--    local callBack = cc.CallFunc:create(function()
--            self.m_bIsMenuMove = false
--            --self.m_pBtnMenuPop:setVisible(true)
--            self.m_pBtnMenuClose:setVisible(true)
--            self.m_pBtnMenuPush:setVisible(false)
--        end)
--    local seq = cc.Sequence:create(moveTo, callBack)
--    self.m_pSpMenuBg:runAction(seq)
--end
--
---- 菜单上移
--function GameViewLayer:onBtnMenuPopClicked(sender)
--    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
--    if self.m_bIsMenuMove then return end
--    self.m_bIsMenuMove = true
--
--    self.m_pSpMenuBg:stopAllActions()
--    local moveTo = cc.MoveTo:create(0.2, cc.p(self.m_pSpMenuBg:getPositionX(), 955))
--    local callBack = cc.CallFunc:create(function()
--            self.m_bIsMenuMove = false
--            self.m_pSpMenuBg:setVisible(false)
--            self.m_pBtnMenuPop:setVisible(false)
--            self.m_pBtnMenuClose:setVisible(false)
--            self.m_pBtnMenuPush:setVisible(true)
--        end)
--    local seq = cc.Sequence:create(moveTo, callBack)
--    self.m_pSpMenuBg:runAction(seq)
--end

-- 续投
function GameViewLayer:onBtnContinueClicked(sender)
    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
    if self:isDelayHandleEvent() then return end
    if (LhdzDataMgr.getInstance():getGameStatus() ~= Lhdz_Const.STATUS.GAME_SCENE_BET)then
        FloatMessage.getInstance():pushMessage("STRING_026");
        return;
    end

    -- 庄家不能续投
    if (LhdzDataMgr.getInstance():isBanker())then
        FloatMessage.getInstance():pushMessage("LHDZ_4");
        return;
    end
    -- 上局没有投注
    local count = LhdzDataMgr.getInstance():getContinueChipSize();
    if (count <= 0)then
        FloatMessage.getInstance():pushMessage("STRING_027");
        return;
    end
--    if (LhdzDataMgr.getInstance():getIsContinued())then
--        FloatMessage.getInstance():pushMessage("STRING_004");
--        return;
--    end
    local continueChip = {};
    for i=1,tonumber(Lhdz_Const.GAME_DOWN_COUNT) do
        continueChip[i] = 0;
    end
    local llSumScore = 0;
    for i=1,tonumber(count),1 do
        local chip = LhdzDataMgr.getInstance():getContinueChipByIndex(i);
        local baseVale = CBetManager.getInstance():getLotteryBaseScoreByIndex(chip.wJettonIndex);
        continueChip[chip.wChipIndex] = continueChip[chip.wChipIndex] + baseVale;
        llSumScore = llSumScore + baseVale;
    end

    if (PlayerInfo.getInstance():getUserScore() < llSumScore) then
        --金钱不够
--        self:showMessageBox(Lhdz_Res.MESSAGEBOX_IMG.RECHARGE, MsgBoxPreBiz.PreDefineCallBack.CB_RECHARGE, true)
        FloatMessage.getInstance():pushMessage("LHDZ_3")
        return;
    end
    local index = 1   
    self._XuyaFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        if index > count then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._XuyaFun)
            return
        end
        if LhdzDataMgr.getInstance():getContinueChipByIndex(index) ~= nil then
            local chip = LhdzDataMgr.getInstance():getContinueChipByIndex(index)
            local baseVale = CBetManager.getInstance():getLotteryBaseScoreByIndex(chip.wJettonIndex)
            self._scene:SendBet(chip.wChipIndex-1, baseVale);
        end 
        index = index+1
    end, 0.2, false)
end

function GameViewLayer:onBtnSettingClicked(sender)
    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
    self:onClickBackMenu()
    local pSet = SettingLayer.create()
    pSet:addTo(self.m_rootUI)
end

-- 音效
function GameViewLayer:onBtnEffectClicked(sender)
    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
    local bEnable = false
    if (GlobalUserItem.bSoundAble)then -- 音效开着
        GlobalUserItem.setSoundAble(false)
    else
        bEnable = true
        GlobalUserItem.setSoundAble(true)
    end
    self:updateButtonOfSound(bEnable)
end

-- 音乐
function GameViewLayer:onBtnMusicClicked(sender)
    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
    local bEnable = false
    if (GlobalUserItem.bVoiceAble)then -- 
        GlobalUserItem.setVoiceAble(false)
    else
        bEnable = true
        GlobalUserItem.setVoiceAble(true)
    end
    self:updateButtonOfMusic(bEnable)
end

-- 银行
function GameViewLayer:onBtnBankClicked(sender)
    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
    SLFacade:dispatchCustomEvent(Hall_Events.SHOW_OPEN_BANK,"openbank")
--    if PlayerInfo.getInstance():getIsInsurePass() == 0 then
--        FloatMessage.getInstance():pushMessage("STRING_033")
--        return
--    end
--    --弹出银行界面
--    local ingameBankView = IngameBankView:create()
--    ingameBankView:setName("IngameBankView")
--    self:addChild(ingameBankView, 500)
end

-- 上庄
function GameViewLayer:onBtnUpBankerClicked()
    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
    if (LhdzDataMgr.getInstance():getGameStatus() == Lhdz_Const.STATUS.GAME_SCENE_BET)then
        FloatMessage.getInstance():pushMessage("下注时间，不能进行上下庄操作！");
        return;
    end
    self._scene:SendUpdearler()
--    CMsgLhdz.getInstance():sendMsgBanker(true);
end

-- 下庄
function GameViewLayer:onBtnDownBankerClicked()
    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
    if (LhdzDataMgr.getInstance():getGameStatus() == Lhdz_Const.STATUS.GAME_SCENE_BET)then
        FloatMessage.getInstance():pushMessage("下注时间，不能进行上下庄操作！");
        return;
    end
    self._scene:SendDowndealer()
--    CMsgLhdz.getInstance():sendMsgBanker(false);
end

-- 选取筹码
function GameViewLayer:onBtnJettonNumClicked(sender)
    local nIndex = sender:getTag()

    local score = CBetManager.getInstance():getJettonScore(nIndex)
    if LhdzDataMgr.getInstance():getGameStatus() ~= Lhdz_Const.STATUS.GAME_SCENE_BET or PlayerInfo.getInstance():getUserScore() < score or LhdzDataMgr.getInstance():isBanker() then
        self.m_pBtnJetton[nIndex]:setColor(cc.c3b(160,160,160))
        self.m_pBtnJetton[nIndex]:setOpacity(Chip_DisableOpacity)
        self.m_chipEffect:setVisible(false)
        return
    else
        self.m_pBtnJetton[nIndex]:setColor(cc.c3b(255,255,255))
        self.m_pBtnJetton[nIndex]:setOpacity(Chip_EnableOpacity)
    end

    self.m_chipEffect:setColor(Lhdz_Const.BTNEFFCRT_COLOR[nIndex])
    self.m_chipEffect:setPosition(cc.p(self.m_pBtnJetton[nIndex]:getPositionX(), self.m_pBtnJetton[nIndex]:getPositionY()))
    self.m_chipEffect:setVisible(Chip_EnableOpacity == self.m_pBtnJetton[nIndex]:getOpacity())
    
    CBetManager.getInstance():setLotteryBaseScore(score); 
    if (self.m_nIndexChoose ~= nIndex)then
        ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_JETTON)
    end
    
    self.m_chipEffect:setPosition(cc.p(self.m_pBtnJetton[nIndex]:getPositionX(), self.m_pBtnJetton[nIndex]:getPositionY()))
    self.m_nIndexChoose = nIndex;
end

-- 下注
function GameViewLayer:onBtnAreaClicked(sender)
    local index = sender:getTag();
    -- 未到下注时间不能下注
    if LhdzDataMgr.getInstance():getGameStatus() ~= Lhdz_Const.STATUS.GAME_SCENE_BET then
        FloatMessage.getInstance():pushMessage("STRING_024")
        return
    end

    -- 庄家不能下注
    if (LhdzDataMgr.getInstance():isBanker())then
        FloatMessage.getInstance():pushMessage("LHDZ_4")
        return;
    end

    -- 金币不够不能下注
    if PlayerInfo.getInstance():getUserScore() < CBetManager.getInstance():getLotteryBaseScore() then
--        self:showMessageBox(Lhdz_Res.MESSAGEBOX_IMG.RECHARGE, MsgBoxPreBiz.PreDefineCallBack.CB_RECHARGE, true)
        FloatMessage.getInstance():pushMessage("LHDZ_3")
        return
    end
    self._scene:SendBet(index, CBetManager.getInstance():getLotteryBaseScore());
end

-- 其他玩家排行
function GameViewLayer:onBtnOtherPlayerClicked(sender)
    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
    if self:isDelayHandleEvent() then return end
    --玩家列表
    local infoLayer = LhdzOtherInfoLayer:create()
    self.m_pNodeOtherPlayer:addChild(infoLayer)
end

function GameViewLayer:ClickRemoveBankList()
    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
    self.m_pClickMoveListBtn:setVisible(false)
    if self.m_bIsBankListMove then return end
    self.m_bIsBankListMove = true
    self.m_pSpMenuBg:stopAllActions()
    local moveTo = cc.MoveTo:create(0.2, cc.p(0, 200))
    local callBack = cc.CallFunc:create(function()
            self.m_bIsBankListMove = false
            self.m_pBankListBG:setVisible(false)
            self.m_pBankListNode:setVisible(false)
        end)
    local seq = cc.Sequence:create(moveTo, callBack)
    self.m_pBankListBG:runAction(seq)
end

function GameViewLayer:ClickBankList()
    self.m_pBankListNode:setVisible(true)
    if self.m_pBankListBG:isVisible() then
        ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
        if self.m_bIsBankListMove then return end
        self.m_pClickMoveListBtn:setVisible(false)
        self.m_bIsBankListMove = true
        self.m_pSpMenuBg:stopAllActions()
        local moveTo = cc.MoveTo:create(0.2, cc.p(0, 200))
        local callBack = cc.CallFunc:create(function()
                self.m_bIsBankListMove = false
                self.m_pBankListBG:setVisible(false)
            end)
        local seq = cc.Sequence:create(moveTo, callBack)
        self.m_pBankListBG:runAction(seq)
    else
        ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
        if self.m_bIsBankListMove then return end
        self.m_bIsBankListMove = true

        self.m_pBankListBG:setVisible(true)
        self.m_pBankListBG:stopAllActions()
        self.m_pBankListBG:setPositionY(200)
        local moveTo = cc.MoveTo:create(0.2, cc.p(0, 0))
        local callBack = cc.CallFunc:create(function()
                self.m_bIsBankListMove = false
                self.m_pClickMoveListBtn:setVisible(true)
            end)
        local seq = cc.Sequence:create(moveTo, callBack)
        self.m_pBankListBG:runAction(seq)

        if self.m_pTableView then 
            self.m_pTableView:reloadData()
        end
    end
end

function GameViewLayer:initBankListTable() --庄家列表

    local size = cc.size(230,146)
    local function initTableViewCell(cell, idx)
        local list = LhdzDataMgr.getInstance():getBankerList()
        local nickmame = "";
        for k,v in ipairs(LhdzDataMgr.getInstance():getRankUserByIndex()) do
            if v[1] == list[idx+1] then
                nickmame = v[2]
            end
        end    
--        local tableID = PlayerInfo:getInstance():getTableID()
--        local userInfo = CUserManager:getInstance():getUserInfoByChairID(tableID, list[idx+1])   
        local pLbNick = cc.Label:createWithSystemFont(nickmame, "Helvetica", 20)    
        pLbNick:setAnchorPoint(cc.p(0.5,0.5))
        pLbNick:setPosition(cc.p(size.width/2,20))
        pLbNick:setColor(cc.c3b(191,178,248))
        pLbNick:addTo(cell)

        local spLine = cc.Sprite:createWithSpriteFrameName(Lhdz_Res.PNG_OF_BANKER_SPLINE)
        spLine:setPosition(cc.p(size.width/2,5))
        spLine:addTo(cell)
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
        return size.width, 32
    end
    local function numberOfCellsInTableView(table)
         return  LhdzDataMgr.getInstance():getBankerListSize()
    end
    
    if not self.m_pTableView then
        self.m_pTableView = cc.TableView:create(size)
--        self.m_pTableView:setIgnoreAnchorPointForPosition(false)
        self.m_pTableView:setAnchorPoint(cc.p(0,0))
        self.m_pTableView:setPosition(cc.p(12, 15))
        self.m_pTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        self.m_pTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.m_pTableView:setTouchEnabled(true)
        self.m_pTableView:setDelegate()
        self.m_pTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
        self.m_pTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
        self.m_pTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
        self.m_pTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
        self.m_pTableView:addTo(self.m_pBankListBG)
    end
end

-- 上桌玩家信息
function GameViewLayer:onBtnUserInfoClicked(sender)
    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
    local index = sender:getTag()
    if self.m_pNodeUserTips:getChildByTag(100+index) then
        return
    end
    local userInfo = LhdzDataMgr:getInstance():getTableUserInfo(index)
    local dialog = LhdzUserInfoLayer.create()
    local posX, posY = self.m_pNodeTablePlayer[index]:getPosition()
    if index == 2 or index == 3 or index == 4 then
        posX = posX + 150
    else
        posX = posX - 150
    end
    dialog:setPosition(cc.p(posX, posY - 20))
    dialog:setTag(100+index)
    dialog:updateUserInfoByInfo(userInfo)
    self.m_pNodeUserTips:addChild(dialog)
end

-- 走势界面
function GameViewLayer:onBtnTrendClicked(sender)
    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
    self:updateTrendLayer(true)
end

-- 规则界面
function GameViewLayer:onBtnRuleClicked(sender)
    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BUTTON)
    self:onClickBackMenu()
    local pLhdzRuleLayer = LhdzRuleLayer.create()
    pLhdzRuleLayer:setName("LhdzRulelayer")
    self.m_rootUI:addChild(pLhdzRuleLayer, G_CONSTANTS.Z_ORDER_COMMON)

end
---------------------------------- btn click event end ----------------------------------

---------------------------------- on msg event start ----------------------------------
-- 退出游戏
function GameViewLayer:event_ExitGame(msg)
--    self.m_bEnterBackground = false
--    PlayerInfo.getInstance():setIsGameBackToHall(true)
--    SLFacade:dispatchCustomEvent(Public_Events.Load_Entry)
    self._scene:onQueryExitGame()
end

-- 联网失败
function GameViewLayer:event_NetWorkFailre(msg)
    FloatMessage.getInstance():pushMessage("STRING_023")
    self:event_ExitGame()
end

-- 更新玩家金币
function GameViewLayer:event_UpdateScore(msg)
    if self.m_pLbUserGold and self.m_pLbUserGold:getTag() ~= -1 then
        local strUsrGold = PlayerInfo.getInstance():getUserScore();
        self.m_pLbUserGold:setString(strUsrGold)
    end
    self:updateJettonStatus()
end

-- 玩家金币发生变化
function GameViewLayer:event_UserScore(msg)
--    --只针对下注过程中 庄家操作银行取金币导致的庄家金币变化
--    if Lhdz_Const.STATUS.GAME_SCENE_BET ~= LhdzDataMgr.getInstance():getGameStatus() then
--        return
--    end

--    local chairid = LhdzDataMgr.getInstance():getBankerId()
--    if chairid == G_CONSTANTS.INVALID_CHAIR then
--        return
--    end

--    local uid = CUserManager:getInstance():getUserIDScoreGR()
--    local tableID = PlayerInfo:getInstance():getTableID()
--    local userInfo = CUserManager:getInstance():getUserInfoByChairID(tableID, chairid)

--    --判断是否庄家分数发生变化
--    if userInfo.dwUserID == uid then
--        local score = CUserManager:getInstance():getUserScoreByUserID(uid)
--        print("通知庄家分数为:" .. score)
--        if 0 == score then return end
--        LhdzDataMgr.getInstance():setBankerScore(score)
--        self:updatebankerInfo()
--    end
end


-- 显示商店
function GameViewLayer:event_ShowShop(msg)
--    local pRecharge = self.m_rootUI:getChildByName("RechargeLayer")
--    if pRecharge then
--        pRecharge:setVisible(true)
--        return
--    end
--    local isClosedAppStore = GameListManager.getInstance():getGameSwitch(G_CONSTANTS.GAMESWITCH.CLOSE_RECHARGE_APPSTORE);

--    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
--    if not (cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform or cc.PLATFORM_OS_MAC == targetPlatform) then 
--        isClosedAppStore = true;
--    end

--    if isClosedAppStore then
--        pRecharge = RechargeLayer:create()
--    else
--        pRecharge = AppStoreView:create()
--    end
--    pRecharge:setName("RechargeLayer")
--    self.m_rootUI:addChild(pRecharge, G_CONSTANTS.Z_ORDER_TOP)
end

-- 游戏初始化
function GameViewLayer:event_GameInit(msg)
    self:initGame()
end

-- 游戏状态
function GameViewLayer:event_GameStatus(msg)
    local status = LhdzDataMgr.getInstance():getGameStatus()
    --下注状态和空闲状态时，确保重置了翻牌扑克动画的状态，避免显示为正面牌型
    if status == Lhdz_Const.STATUS.GAME_SCENE_BET then
        LhdzDataMgr.getInstance():updateContinueInfo()
        self:clearFlyStatus()
        self:resetCardAnim()
        self:updateLuckerInfo()
        self.m_pLbUserGold:setTag(1)
        self:clearWaitNextPlay()
        self.m_pNodeCountTime:setVisible(true)
        self:updateContinueStatus(true)
        self:showGameStatusAnim()
        self:updatebankerInfo()
--        self:updateBankStatus(true)
        self:updateTempGameRecord()
    elseif status == Lhdz_Const.STATUS.GAME_SCENE_RESULT then
        --开奖阶段停止星星倒计时动画特效
--        for i = 1, Lhdz_Const.GAME_DOWN_COUNT do
--            self.m_pSpStar[i]:stopAllActions()
--            self.m_pSpStar[i]:setScale(1)
--        end
        self.m_bIsPlayVSAnim = false
        self.m_pNodeCountTime:setVisible(true)
--        self:updateBankStatus(false)
--        self:clearWaitNextPlay()
        self:updatebankerInfo()
        self:updateTempGameRecord()
        self:showGameStatusAnim()
    elseif status == Lhdz_Const.STATUS.GAME_SCENE_FREE then
        self:clearFlyStatus()
        self.m_bIsRequestRank = false
        self.m_pNodeCountTime:setVisible(false)
        self:showBankerTips(false)
        --self:showSendCardAnim(false)
        self:resetCardAnim()
        self:updateBetAreaValue()
--        self:clearWaitNextPlay()
        self.m_chipMgr:clearAllChip()
        self:clearNo1BetStar()
        self:hideTableUserWinAnim()
        self:hideWinAreaAnim()
        self:updateBetAreaValue()
        self:updatebankerInfo()
        self:showGameVSAnim()
        self.m_chipMgr:resetChipPosArea()
        self:updateTempGameRecord()
--        self.m_pLbUserGold:setString(strUsrGold)
    end
    self:updateGameStatus()
    self:updateJettonStatus()
end

-- 游戏结算
function GameViewLayer:event_GameResult(msg)
    self.m_pLbUserGold:setTag(-1)
    self.m_iLastPlayerGold = PlayerInfo.getInstance():getUserScore()
    self:updateContinueStatus(false)
    self:doSomethingLater(function( ... )
        self:showSendCardAnim(true)
    end, 0)
--    CMsgLhdz.getInstance():sendMsgRank(1)
end

-- 玩家下注
function GameViewLayer:event_Chip(msg)
    self:handleUserChip(msg)
end

--处理下注信息
function GameViewLayer:handleUserChip(msg)
    local delayTs = msg.wChairID == PlayerInfo.getInstance():getChairID() and 0 or math.random(0, 8)/10

    -- 更新下注筹码数值
    self:updateBetAreaValue()
    -- 更新筹码状态
    self:updateJettonStatus()
    --更新上桌玩家分数
    self:updateTableUserScore()
    -- 神算子下注
    self:playFlyStarAnim()
    -- 筹码飞向下注区
    local nSize = LhdzDataMgr.getInstance():getAllUserChipCount();
    local lastChip = nil
    if nSize > 0 then
        lastChip = LhdzDataMgr.getInstance():getAllUserChipByIndex(nSize)
        self:doSomethingLater(function()
            self.m_chipMgr:playFlyJettonToBetArea(lastChip.wJettonIndex, lastChip.wChipIndex, lastChip.wChairID)
            --如果是界面显示玩家投注，则进行头像抖动动画
            local userIndex = LhdzDataMgr.getInstance():getUserByChirId(lastChip.wChairID)
            if userIndex > 0 then
                self:playTableUserChipAni(userIndex)
            end

            if LhdzDataMgr.getInstance():getIsNo1BetByChairID(lastChip.wChairID) then
                self:SetNo1BetPercentage(lastChip)
            end
        end, delayTs)
    else
        return
    end
    self:doSomethingLater(function()
        if msg.wChairID == PlayerInfo.getInstance():getChairID() then
            local score = CBetManager.getInstance():getJettonScore(lastChip.wJettonIndex)
            if score >= 10000 then -- 分投注级别播放音效 金额大于100块的播放高价值音效
                ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_JETTON_HIGH)
            else
                ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_JETTON_LOW)
            end
            self:updateContinueStatus(false)
        else
            if not self.m_isPlayBetSound then
                local score = CBetManager.getInstance():getJettonScore(lastChip.wJettonIndex)
                if score >= 10000 then -- 分投注级别播放音效 金额大于100块的播放高价值音效
                    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_JETTON_HIGH)
                else
                    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_JETTON_LOW)
                end
                -- 尽量避免重复播放
                self:doSomethingLater(function() self.m_isPlayBetSound  = false end, math.random(2,4)/10)
                self.m_isPlayBetSound = true
            end
        end
    end, delayTs)
end

function GameViewLayer:SetNo1BetPercentage(msg)
    self.m_pNo1BetPreBar3:setPositionX(661)
    local betToNum = {1,10,50,100,500,1000}
    self.m_dNo1AllBet[msg.wChipIndex] = self.m_dNo1AllBet[msg.wChipIndex] + betToNum[msg.wJettonIndex]

    local preNum1 =  self.m_pNo1BetPreBar1:getChildByName("Text_prenum")
    local preNum2 =  self.m_pNo1BetPreBar2:getChildByName("Text_prenum")
    local preNum3 =  self.m_pNo1BetPreBar3:getChildByName("Text_prenum")
    local all = self.m_dNo1AllBet[1] + self.m_dNo1AllBet[2] + self.m_dNo1AllBet[3]
    if all ~= 0 then
        local offsetX = 551
        local pre1 = self.m_dNo1AllBet[1]/all
        local pre2 = self.m_dNo1AllBet[2]/all
        local pre3 = self.m_dNo1AllBet[3]/all
        local lostPre = 0
        self.m_pNo1BetPreBar1:setVisible(pre1>0)
        if pre1>0 then
            local w1 = math.floor(220*pre1)
            if w1 < 40 then
                w1 = 40
            end
            w1 = (w1>180 and pre1~=1) and 180 or w1
            offsetX = offsetX + w1
            self.m_pNo1BetPreBar1:setContentSize(cc.size(w1, self.m_pNo1BetPreBar1:getContentSize().height))
            lostPre = math.ceil(pre1*100)>1 and math.floor(pre1*100) or 1
            preNum1:setString(lostPre.."%")
        end
        self.m_pNo1BetPreBar2:setVisible(pre2>0)
        if pre2>0 then
            local pre = math.ceil(pre2*100)>1 and math.floor(pre2*100) or 1
            if pre3 > 0 then
                preNum2:setString(pre.."%")
            else
                preNum2:setString((100-lostPre).."%")
            end
            lostPre = lostPre + pre
            local w2 = math.floor(220*pre2)
            if w2<40 then
                w2 = 40
            end
            w2 = (w2>180 and pre2~=1) and 180 or w2
            offsetX = offsetX + w2
            self.m_pNo1BetPreBar2:setContentSize(cc.size(w2, self.m_pNo1BetPreBar2:getContentSize().height))
            preNum2:setPositionX(w2-15)
        end
        self.m_pNo1BetPreBar3:setVisible(pre3>0)
        if pre3>0 then
            preNum3:setString((100-lostPre).."%")
            local w3 = 220+551-offsetX
            if w3<40 then
                w3 = 40
            end
            self.m_pNo1BetPreBar3:setContentSize(cc.size(w3, self.m_pNo1BetPreBar3:getContentSize().height))
            self.m_pNo1BetPreBar3:setPositionX(self.m_pNo1BetPreBar1:getContentSize().width+551)
            preNum3:setPositionX(w3/2)
        end
        --print (" ------------------------------------------------------00000---------- ",lostPre,100-lostPre)
    end
end

-- 取消下注
function GameViewLayer:event_Cancel(msg)
    -- 更新下注筹码数值
    self:updateBetAreaValue()
    -- 更新筹码状态
    self:updateJettonStatus()
    if not msg then
        self:updateContinueStatus(true)
    end
end

-- 玩家续投
function GameViewLayer:event_Continue(msg)
    self:updateBetAreaValue()
    self:updateJettonStatus()
    --更新上桌玩家分数
    self:updateTableUserScore()
    -- 神算子下注
    self:playFlyStarAnim()
    local betHigh = false
    if msg and msg == "MyContinueSuc" then
        for i=1,Lhdz_Const.GAME_DOWN_COUNT do
            local downTotal = LhdzDataMgr.getInstance():getMyBetValue(i)
            while downTotal > 0 do
                local userChip = {}
                userChip.wChairID = PlayerInfo.getInstance():getChairID()
                userChip.wChipIndex = i
                local index = LhdzDataMgr.getInstance():GetJettonMaxIndexByValue(downTotal)
                if index > 0 then
                    userChip.wJettonIndex = index
                    downTotal = downTotal - CBetManager.getInstance():getJettonScore(index)
                end
                local beginPos = self:getUserPosition(userChip.wChairID, true, userChip.wJettonIndex)
                if LhdzDataMgr.getInstance():getIsNo1BetByChairID(userChip.wChairID) then
                    self:SetNo1BetPercentage(userChip)
                end
                self.m_chipMgr:playFlyJettonToBetArea(userChip.wJettonIndex, userChip.wChipIndex, userChip.wChairID)
                if downTotal>1000 then
                    betHigh = true
                end
            end
        end

        self:updateContinueStatus(false)
    else
        local lOtherContinueCount = LhdzDataMgr.getInstance():getOtherContinueChipSize()
        for i = 1, lOtherContinueCount do
            local chip = LhdzDataMgr.getInstance():getOtherContinueChipByIndex(i)
            local beginPos = self:getUserPosition(chip.wChairID, true, chip.wJettonIndex)
            if LhdzDataMgr.getInstance():getIsNo1BetByChairID(chip.wChairID) then
                self:SetNo1BetPercentage(chip)
            end
            self.m_chipMgr:playFlyJettonToBetArea(chip.wJettonIndex, chip.wChipIndex, chip.wChairID)
            local score = CBetManager.getInstance():getJettonScore(chip.wJettonIndex)
            if score > 1000 then
                betHigh = true
            end
        end
        LhdzDataMgr.getInstance():clearOtherContinueChip()
    end
    local soundPath = betHigh and Lhdz_Res.vecSound.SOUND_OF_JETTON_HIGH or Lhdz_Res.vecSound.SOUND_OF_JETTON_LOW
    ExternalFun.playGameEffect(soundPath)
end

-- 更新庄家列表
function GameViewLayer:event_BankerList(msg)
    -- 自己是否上庄
    local bIsBanker =  LhdzDataMgr.getInstance():isBanker() 
    local bInList = LhdzDataMgr.getInstance():isInBankerList()
    self.m_pBtnUpBanker:setVisible(not(bIsBanker or bInList ~= -1))
    self.m_pBtnDownBanker:setVisible(bIsBanker or bInList ~= -1)
    -- 限制条件
    local strBankerMinGold = LhdzDataMgr.getInstance():getMinBankerScore()
    self.m_pLbCondition:setString(string.format("%s", (strBankerMinGold)))
    -- 上庄人数
    local nBankerCount = LhdzDataMgr.getInstance():getBankerListSize()
    local strNum = string.format("%d", nBankerCount)
    self.m_pLbBankerCount:setString(strNum)
end

-- 更新庄家
function GameViewLayer:event_BankerInfo(msg)
    self:updatebankerInfo()
    if(msg)then
        --//change banker
        local str = msg.attachment
        if(str == "CHANGEBANKER")then
            ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BANKER)
            self:showBankerTips(true);
        end
    end
end

-- 倒计时更新
function GameViewLayer:event_CountTime(msg)
    self.m_pLbCountTime:setVisible(true)
    self:updateCountTime()
    
end

-- 更新上桌玩家
function GameViewLayer:event_TableUser(msg)
    --self:updateTableUserInfo()
end

function GameViewLayer:event_Rank(msg)
    self.m_bIsRequestRank = false
    local pLhdzRankLayer = self.m_rootUI:getChildByName("LhdzRankLayer")
    if pLhdzRankLayer then
        pLhdzRankLayer:updateTableView()
    end
end

function GameViewLayer:event_BankerScore(msg)
    self:updatebankerInfo()
end

function GameViewLayer:onMsgEnterNetWorkFail()
    --相当于进入后台
    self:onMsgEnterBackGround()
end

function GameViewLayer:onMsgEnterBackGround()
    --进入后台返回时,不删资源
    self.m_bEnterBackground = true
end

function GameViewLayer:onMsgEnterForeGround()
end

function GameViewLayer:onMsgReloginSuccess()
end

---------------------------------- on msg event end ----------------------------------

---------------------------------- update view start ----------------------------------
-- 更新倒计时
function GameViewLayer:updateCountTime()
    local count = CBetManager.getInstance():getTimeCount();
    if self.m_pLbCountTime then
        count = count < 0 and 0 or count
        count = math.floor(count)
        self.m_pLbCountTime:setString(count)
        CBetManager.getInstance():setTimeCount(CBetManager.getInstance():getTimeCount() - 1)
        if LhdzDataMgr.getInstance():getGameStatus() == Lhdz_Const.STATUS.GAME_SCENE_BET then
            if count > 0 and count < 4 then
                self:showCountDownAnim(count)
                ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_RING);
            end
        end
    end
end

-- 更新音效图标
function GameViewLayer:updateButtonOfSound(enable)
    local bEnable = enable or GlobalUserItem.bSoundAble
    local path = bEnable and Lhdz_Res.PNG_OF_SOUND_ON or Lhdz_Res.PNG_OF_SOUND_OFF
    --self.m_pBtnEffect:loadTextureNormal(path, ccui.TextureResType.plistType)
end

-- 更新音乐图标
function GameViewLayer:updateButtonOfMusic(enable)
    local bEnable = enable or GlobalUserItem.bVoiceAble
    local path = bEnable and Lhdz_Res.PNG_OF_MUSIC_ON or Lhdz_Res.PNG_OF_MUSIC_OFF
    --self.m_pBtnMusic:loadTextureNormal(path, ccui.TextureResType.plistType)
    if bEnable then
        --播放音乐
        ExternalFun.playGameBackgroundAudio(Lhdz_Res.vecLoadingMusic.MUSIC_OF_BGM)
    end
end

-- 更新游戏状态
function GameViewLayer:updateGameStatus()
    local status = LhdzDataMgr.getInstance():getGameStatus()
    local bPre = status == Lhdz_Const.STATUS.GAME_SCENE_BET
    self.m_pSpStauts:setVisible(bPre)
    self.m_pSpStautsKaipai:setVisible(not bPre)
    self.m_pLbCountTime:setVisible(bPre)
end

-- 更新神算子胜率
function GameViewLayer:updateLuckerInfo()
    local tableUser = LhdzDataMgr.getInstance():getTableUserInfo(1)
    if tableUser then
        self.m_pNo1BetPreNum:setString("50%")--(math.floor((tableUser.cbWinCount/20)*100).."%")
    end
end

-- 更新庄家提示
function GameViewLayer:showBankerTips(isUpBanker)
--[[    local strTips = "";
    local strPath = nil
    local bSystemBanker = LhdzDataMgr.getInstance():getBankerId() == G_CONSTANTS.INVALID_CHAIR
    if (isUpBanker)then
    --// 庄家轮换
        strTips = Lhdz_Res.PNG_OF_BANKERCHANGE
    else
    --// 玩家庄家 连庄
        local times = LhdzDataMgr.getInstance():getBankerTimes();
        if(times <= 1 or times >10)then
            return;
        end
        strTips = string.format(Lhdz_Res.PNG_OF_BANKER_CONTINUE, times);
    end
    --strTips = self:getRealFrameName(strTips)
    if(self.m_pSpBankerTips == nil)then
        self.m_pSpBankerTips = cc.Sprite:createWithSpriteFrameName(strTips);
        self.m_pNodeTips:addChild(self.m_pSpBankerTips);
    else
        self.m_pSpBankerTips:setSpriteFrame(strTips);
    end
    self.m_pNodeTips:setVisible(false);
    self.m_pNodeTips:setOpacity(255)
    self.m_pNodeTips:stopAllActions()
    local callback1 = cc.CallFunc:create(function ()
        self.m_pNodeTips:setVisible(true);
        if strPath then
            ExternalFun.playGameEffect(SOUND_OF_BANKER);
        end
    end)

    local callback = cc.CallFunc:create(function ()
        self.m_pNodeTips:setVisible(false);
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(3.0), callback1, cc.DelayTime:create(1.0), cc.FadeOut:create(0.2), callback);
    self.m_pNodeTips:runAction(seq);]]
end

-- 更新筹码面值
function GameViewLayer:updateJettonValues()
    local strChipName = "ChipNum"
    for i=1, Lhdz_Const.JETTON_ITEM_USE_COUNT do
        local needSocre = CBetManager.getInstance():getJettonScore(i)
--        if needSocre < 100 then return end
--        if needSocre == 1 then needSocre = 500
--        elseif needSocre == 5 then needSocre = 1000
--        elseif needSocre == 10 then needSocre = 5000
--        elseif needSocre == 50 then needSocre = 10000
--        elseif needSocre == 100 then needSocre = 50000
--        elseif needSocre == 500 then needSocre = 100000
--        end
        local strFile = Lhdz_Res.PNG_OF_JETTON
        local txtnum = needSocre
        if needSocre >= 10000 then
            txtnum = tostring(needSocre/10000).."万"
        end
        local childNum = self.m_pBtnJetton[i]:getChildByName(strChipName)
        if childNum then
            childNum:setString(txtnum)
        else
            local label = ccui.Text:create(txtnum,"fonts/round_body.ttf",26)
            label:setColor(cc.c3b(21,21,21))
            --label:enableOutline(cc.c4b(0,0,0,255), 1)
            label:enableShadow(cc.c3b(110,110,110), cc.size(0,-2), 1)  --阴影
            label:setPosition(cc.p(52,57))
            self.m_pBtnJetton[i]:addChild(label)
            label:setName(strChipName)
        end


        local str1 =  string.format(strFile, i)
        print("=============================" .. str1)
        self.m_pBtnJetton[i]:loadTextureNormal(str1)
        self.m_pBtnJetton[i]:loadTexturePressed(str1)
        self.m_pBtnJetton[i]:loadTextureDisabled(str1)
    end
end

-- 更新庄家信息
function GameViewLayer:updatebankerInfo()
    -- 庄家名称
    local strBankerName = LhdzDataMgr.getInstance():getBankerName()
    self.m_pLbBankerName:setString(LuaUtils.getDisplayNickName(strBankerName, 8, true))
    -- 庄家金币
    local strBankerGold = LhdzDataMgr.getInstance():getBankerScore()
    self.m_pLbBankerGold:setString(strBankerGold)
    -- 自己是否上庄
    local bIsBanker =  LhdzDataMgr.getInstance():isBanker() 
    local bInList = LhdzDataMgr.getInstance():isInBankerList()
    self.m_pBtnUpBanker:setVisible(not(bIsBanker or bInList ~= -1))
    self.m_pBtnDownBanker:setVisible(bIsBanker or bInList ~= -1)
    -- 限制条件
    local strBankerMinGold = LhdzDataMgr.getInstance():getMinBankerScore()
    self.m_pLbCondition:setString(string.format("%s", (strBankerMinGold)))
    -- 上庄人数
    local nBankerCount = LhdzDataMgr.getInstance():getBankerListSize()
    --if bIsBanker == false and bInList ~= -1 then
        --local strNum = string.format(LuaUtils.getLocalString("FLY_13"), bInList);
        --local strNum = string.format("%d", bInList)
        --self.m_pLbBankerCount:setString(strNum)
    --else
        --local strNum = string.format(LuaUtils.getLocalString("FLY_12"), nBankerCount);
        local strNum = string.format("%d", nBankerCount)
        self.m_pLbBankerCount:setString(strNum)
    --end
end

-- 更新上桌玩家信息
function GameViewLayer:updateTableUserInfo()
    for i=1, Lhdz_Const.TABEL_USER_COUNT do
        local pTableUser = LhdzDataMgr.getInstance():getTableUserInfo(i)
        if (not pTableUser) or (pTableUser[1] == G_CONSTANTS.INVALID_CHAIR) then
            self.m_pSpNoPlayer[i]:setVisible(true)
            self.m_pNodeShowPlayer[i]:setVisible(false)
            LhdzDataMgr.getInstance():setTableUserIdLast(i, G_CONSTANTS.INVALID_CHAIR)
        else
            --换人播放动画
            local newuid = pTableUser[1]
            local lastuid = LhdzDataMgr.getInstance():getTableUserIdLast(i)

            local func = function(armatureBack, movementType, movementID)
                if movementType == ccs.MovementEventType.complete then
                    if movementID == Lhdz_Res.ANI_OF_CHANGEUSER.ANILIST.BEGIN.NAME then
                        local faceid = armatureBack:getTag()
                        self:replaceUserHeadSprite(armatureBack, Lhdz_Res.ANI_OF_CHANGEUSER.ANILIST.BEGIN, faceid)
                        armatureBack:getAnimation():play(Lhdz_Res.ANI_OF_CHANGEUSER.ANILIST.END.NAME)
                    elseif movementID == Lhdz_Res.ANI_OF_CHANGEUSER.ANILIST.END.NAME then
                        self.m_pSpNoPlayer[i]:setVisible(false)
                        self.m_pNodeShowPlayer[i]:setVisible(true)
                        self.m_pLbShowPlayerName[i]:setString(LuaUtils.getDisplayNickName(pTableUser[2], 8, true))
                        self.m_pLbShowPlayerGold[i]:setString((pTableUser[3]))
                    end
                end
            end
--            local wFaceID = newuid % G_CONSTANTS.FACE_NUM + 1--math.random(1,10);
            if newuid ~= lastuid then
                LhdzDataMgr.getInstance():setTableUserIdLast(i, newuid)
                --新用户和老用户都是有效用户，则播放转动动画
                if lastuid ~= G_CONSTANTS.INVALID_CHAIR and newuid ~= G_CONSTANTS.INVALID_CHAIR then
                    
                    self.m_changeUserAniVec[i]:setTag(newuid)
                    self.m_changeUserAniVec[i]:getAnimation():play(Lhdz_Res.ANI_OF_CHANGEUSER.ANILIST.BEGIN.NAME)
                    self.m_changeUserAniVec[i]:getAnimation():setMovementEventCallFunc(func)
                else
                    self:replaceUserHeadSprite(self.m_changeUserAniVec[i], Lhdz_Res.ANI_OF_CHANGEUSER.ANILIST.BEGIN, newuid )
                    self.m_pSpNoPlayer[i]:setVisible(false)
                    self.m_pNodeShowPlayer[i]:setVisible(true)
                    self.m_pLbShowPlayerName[i]:setString(LuaUtils.getDisplayNickName(pTableUser[2], 8, true))
                    self.m_pLbShowPlayerGold[i]:setString((pTableUser[3]))
                end
            else
                self:replaceUserHeadSprite(self.m_changeUserAniVec[i], Lhdz_Res.ANI_OF_CHANGEUSER.ANILIST.BEGIN, newuid)
                self.m_pSpNoPlayer[i]:setVisible(false)
                self.m_pNodeShowPlayer[i]:setVisible(true)
                self.m_pLbShowPlayerName[i]:setString(LuaUtils.getDisplayNickName(pTableUser[2], 8, true))
                self.m_pLbShowPlayerGold[i]:setString((pTableUser[3]))
            end
    
        end
    end
end

-- 更新上桌玩家分数
function GameViewLayer:updateTableUserScore()
    for i=1, Lhdz_Const.TABEL_USER_COUNT do
        local pTableUser = LhdzDataMgr.getInstance():getTableUserInfo(i)
        if pTableUser and (pTableUser[1] ~= G_CONSTANTS.INVALID_CHAIR) then
            self.m_pLbShowPlayerGold[i]:setString((pTableUser[3]))
        end
    end
end

-- 更新在线玩家数量
function GameViewLayer:updateOnliePlayerCount( )
--    local function refresh( ... )
--        local tableID = PlayerInfo:getInstance():getTableID()
--        local users = CUserManager:getInstance():getUserInfoInTable(tableID, true)
--        self.m_pLbOnlieCount:setString(table.nums(users))
--    end
--    self:shedule(self.m_pLbOnlieCount , function ( ... )
--        refresh()
--    end, 1)
--    refresh()
end

-- 更新历史记录
function GameViewLayer:updateGameRecord()
    local nSize = LhdzDataMgr.getInstance():getHistoryListSize()
    if nSize > Lhdz_Const.MAX_HISTORY_COUNT-5 then
        nSize = Lhdz_Const.MAX_HISTORY_COUNT-5
    end
    --for i = nSize, 1, -1 do
    for i = 1, nSize do
        local pHistory = LhdzDataMgr.getInstance():getHistoryByIndex(nSize-i+1)
        local path = Lhdz_Res.PNG_OF_ICON_DRAW
        if pHistory.cbAreaType == Lhdz_Const.AREA.DRAGON then
            path = Lhdz_Res.PNG_OF_ICON_DRAGON
        elseif pHistory.cbAreaType == Lhdz_Const.AREA.TIGER then
            path = Lhdz_Res.PNG_OF_ICON_TIGER
        end
        self.m_pSpHistory[i]:setVisible(true)
        if i == nSize then
            self.m_pSpHistoryNew:setVisible(true)
            self.m_pSpHistoryNew:setPosition(cc.p(self.m_pSpHistory[i]:getPositionX()-4.7, self.m_pSpHistory[i]:getPositionY()+5.5))
            self.m_pSpHistoryLight:stopAllActions()
            self.m_pSpHistoryLight:setVisible(true)
            self.m_pSpHistoryLight:setPosition(cc.p(self.m_pSpHistory[i]:getPositionX(), self.m_pSpHistory[i]:getPositionY()))
            self.m_pSpHistoryLight:runAction(cc.Repeat:create(cc.Sequence:create(cc.FadeOut:create(0.5), cc.FadeIn:create(0.5)), 5))
        end
        self.m_pSpHistory[i]:setSpriteFrame(path)
    end
end

--更新显示临时历史记录
function GameViewLayer:updateTempGameRecord()
    if 0 == LhdzDataMgr.getInstance():synTempHistory() then
        return
    end
    self:updateGameRecord()
    self:updateTrendLayer(false)
end

-- 更新筹码状态
function GameViewLayer:updateJettonStatus()
    for i = 1, Lhdz_Const.JETTON_ITEM_USE_COUNT do
        local bStatus = LhdzDataMgr.getInstance():getJettonEnableStatus(i)
        local color = bStatus and cc.c3b(255,255,255) or cc.c3b(160,160,160)
        local opacity = bStatus and Chip_EnableOpacity or Chip_DisableOpacity
        self.m_pBtnJetton[i]:setEnabled(bStatus)
        self.m_pBtnJetton[i]:setColor(color)
        self.m_pBtnJetton[i]:setOpacity(opacity)
    end
    local newSelIndex = LhdzDataMgr.getInstance():getJettonSelAdjust();
    if (newSelIndex > 0) then
        self:onBtnJettonNumClicked(self.m_pBtnJetton[newSelIndex]);
    else
        self.m_nIndexChoose = self.m_nIndexChoose<1 and 1 or self.m_nIndexChoose
        self:onBtnJettonNumClicked(self.m_pBtnJetton[self.m_nIndexChoose]);
    end
end

-- 更新续投按钮状态
function GameViewLayer:updateContinueStatus(enable)
    
    if LhdzDataMgr.getInstance():getContinueChipSize() <= 0 then
        enable = false
    end

    self.m_pBtnContinue:setEnabled(enable)
    local color = enable and cc.c3b(255,255,255) or cc.c3b(160,160,160)
    self.m_pBtnContinue:setColor(color)
end

-- 更新银行状态
function GameViewLayer:updateBankStatus(bEnabled)
    self.m_pBtnBank:setEnabled(bEnabled)
    local color = bEnabled and cc.c3b(255,255,255) or cc.c3b(160,160,160)
    --self.m_pBtnBank:setColor(color)
    self.m_pBtnStrongBox:setEnabled(bEnabled)
    
    local status = bEnabled and "1" or "0"
    --设置银行按钮状态
    local _event = {
        name = Public_Events.MSG_BANK_STATUS,
        packet = status,
    }
    SLFacade:dispatchCustomEvent(Public_Events.MSG_BANK_STATUS, _event)
end

-- 更新下注区域的下注数
function GameViewLayer:updateBetAreaValue()
    for i=1,tonumber(Lhdz_Const.GAME_DOWN_COUNT) do
        local llMyValue = LhdzDataMgr.getInstance():getMyBetValue(i);
        local llOtherValue = LhdzDataMgr.getInstance():getOtherBetValue(i);
        
        self.m_pLbMyBetValue[i]:setString(llMyValue)
        self.m_pLbAllBetValue[i]:setString((llMyValue + llOtherValue))

        self.m_pLbMyBetValue[i]:setVisible(llMyValue > 0)
        self.m_pLbMyBetBg[i]:setVisible(llMyValue > 0)
        self.m_pLbAllBetValue[i]:setVisible((llMyValue + llOtherValue) > 0)
    end
end

-- 更新走势界面
function GameViewLayer:updateTrendLayer(bOpen)
    --local pLhdzTrendLayer = self.m_rootUI:getChildByName("LhdzTrendLayer")
    --if not pLhdzTrendLayer and bOpen then
    --    pLhdzTrendLayer = LhdzTrendLayer.create()
    --    pLhdzTrendLayer:setName("LhdzTrendLayer")
    --    self.m_rootUI:addChild(pLhdzTrendLayer, G_CONSTANTS.Z_ORDER_COMMON)
    --end
    --if pLhdzTrendLayer then
    --    pLhdzTrendLayer:updateInfo()
    --end
end

-- 清除等待下局
function GameViewLayer:clearWaitNextPlay()
    if self.m_pAnimWaitNext then
        self.m_pAnimWaitNext:removeFromParent()
        self.m_pAnimWaitNext = nil
    end
end

function GameViewLayer:clearNo1BetStar()
    for i=1, Lhdz_Const.GAME_DOWN_COUNT do
        self.m_pSpStar[i]:setVisible(false)
        self.m_bIsShowStar[i] = false
    end
    self.m_dNo1AllBet = {0,0,0}
    self.m_pNo1BetPreBar1:setVisible(false)
    self.m_pNo1BetPreBar2:setVisible(false)
    self.m_pNo1BetPreBar3:setVisible(false)
    self.m_pNo1BetPreBar1:setContentSize(cc.size(0, self.m_pNo1BetPreBar1:getContentSize().height))
    self.m_pNo1BetPreBar2:setContentSize(cc.size(0, self.m_pNo1BetPreBar2:getContentSize().height))
    self.m_pNo1BetPreBar3:setContentSize(cc.size(0, self.m_pNo1BetPreBar3:getContentSize().height))
end
---------------------------------- update view end ----------------------------------

---------------------------------- play animation start ----------------------------------
-- 背景动画
function GameViewLayer:showBackgroundAnim()
    for i = 1, 2 do
    -- 背景
        local background = self.m_pNodeBackground:getChildByName("background"..i)
        if not background then
--            local strJson = string.format(Lhdz_Res.ANI_OF_BACKGROUND, "json")
--            local strAtlas = string.format(Lhdz_Res.ANI_OF_BACKGROUND, "atlas")
--            background = sp.SkeletonAnimation:create(strJson, strAtlas)
            ParticalPool.getInstance():createBGEffect(i)
            background = ParticalPool.getInstance():getBGEffect(i)
            background:setPosition(cc.p(667, 375))
            background:setName("background"..i)
            background:setAnimation(0, "animation"..i, true)
            self.m_pNodeBackground:addChild(background, Z_ORDER_BOTTOM)
        end
        -- 灯笼
        local lantern = self.m_pNodeLantern:getChildByName("Lantern"..i)
        if not lantern then
--            local strJson = string.format(Lhdz_Res.ANI_OF_LANTERN, "json")
--            local strAtlas = string.format(Lhdz_Res.ANI_OF_LANTERN, "atlas")
--            lantern = sp.SkeletonAnimation:create(strJson, strAtlas)
            ParticalPool.getInstance():createLanternEffect(i)
            lantern = ParticalPool.getInstance():getLanternEffect(i)
            local pos = i == 1 and cc.p(147, 530) or cc.p(1182, 530)
            if i == 2 then
                lantern:setScaleX(-1)
            end
            lantern:setPosition(pos)
            lantern:setName("Lantern"..i)
            lantern:setAnimation(0, "animation", true)
            self.m_pNodeLantern:addChild(lantern, Z_ORDER_BOTTOM)
        end
        
        -- 动物
        local animal = self.m_pNodeLantern:getChildByName("Animal"..i)
        if not animal then
--            local strJson = string.format(Lhdz_Res.ANI_OF_ANIMAL, "json")
--            local strAtlas = string.format(Lhdz_Res.ANI_OF_ANIMAL, "atlas")
--            animal = sp.SkeletonAnimation:create(strJson, strAtlas)
            ParticalPool.getInstance():createAnimalEffect(i)
            animal = ParticalPool.getInstance():getAnimalEffect(i)
            local pos = i == 1 and cc.p(391, 660) or cc.p(1016, 690)
            animal:setPosition(pos)
            animal:setName("Animal"..i)
            animal:setAnimation(0, "animation"..i, true)
            animal:update(0)
            self.m_pNodeLantern:addChild(animal, Z_ORDER_BOTTOM)
        end
    end
end

--等待下局开始
function GameViewLayer:showWaitNextAnim()
    if LhdzDataMgr.getInstance():getGameStatus() ~= Lhdz_Const.STATUS.GAME_SCENE_BET then
        if not self.m_pAnimWaitNext then
            local strJson = string.format(Lhdz_Res.ANI_OF_NEXT_GAME, "json")
            local strAtlas = string.format(Lhdz_Res.ANI_OF_NEXT_GAME, "atlas")
            self.m_pAnimWaitNext = sp.SkeletonAnimation:create(strJson, strAtlas)
            self.m_pAnimWaitNext:setPosition(cc.p(667, 375))
            self.m_pAnimWaitNext:setAnimation(0, "animation", true)
            self.m_pNodeArmature:addChild(self.m_pAnimWaitNext, Z_ORDER_BOTTOM)
        end
        self.m_pAnimWaitNext:setVisible(true)
    else
        self:clearWaitNextPlay()
    end
end

--重置扑克动画状态
function GameViewLayer:resetCardAnim()
    for i = 1, Lhdz_Const.CARD_COUNT do
        if self.m_pAnimCard[i] then
            self.m_pAnimCard[i]:stopAllActions()
            self.m_pAnimCard[i]:getAnimation():play("Animation2")
            self.m_pAnimCard[i]:getAnimation():setMovementEventCallFunc(function()
                return nil
            end)
        end

        local pokerAnim = self.m_pNodeArmature:getChildByName("PokerAnimation"..i)
        if pokerAnim then
            pokerAnim:setVisible(true)
            pokerAnim:stopAllActions()
            pokerAnim:setAnimation(0, "animation1", true)
        end
    end
end

--发牌动画
function GameViewLayer:showSendCardAnim(isResule)
    self.callBackResult = function ()
        if self.m_trendView then
            self.m_trendView:updateTrend()
        end
    end
    if isResule then
        local result = LhdzDataMgr.getInstance():getResult()
        local view = DragonRoundResultView:create(self.callBackResult)
        self:removeChildByTag(TAG_ROUNDRESULT_UI)
        self:addChild(view)
        view:setTag(TAG_ROUNDRESULT_UI)
        view:setRoundResult(result)
        --self:updateGameRecord()
        --self:updateTempGameRecord()
        --self:showWinAreaAnim()
        self:doSomethingLater(function( ... )
            local areaType = LhdzDataMgr:getInstance():getAreaType()
            local areaSound = Lhdz_Res.vecSound.SOUND_OF_DRAW
            if areaType == Lhdz_Const.AREA.DRAGON then
                areaSound = Lhdz_Res.vecSound.SOUND_OF_DRAGON
            elseif areaType == Lhdz_Const.AREA.TIGER then
                areaSound = Lhdz_Res.vecSound.SOUND_OF_TIGER
            end
            ExternalFun.playGameEffect(areaSound)
            self.m_chipMgr:flychipex(function()
                self:playUserScoreEffect()
            end)
        end, 3)

    end

--[[    local cards = LhdzDataMgr.getInstance():getCards()
    for i = 1, Lhdz_Const.CARD_COUNT do
        if not self.m_pAnimCard[i] then
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/longhudazhan/effect/longhudazhan4_fanpai/longhudazhan4_fanpai.ExportJson") 
            self.m_pAnimCard[i] = ccs.Armature:create(Lhdz_Res.vecAnim.SendCard)
            self.m_pAnimCard[i]:setScale(1.2)
            self.m_pAnimCard[i]:update(0)
            local pos = i == 1 and cc.p(576, 670)or cc.p(756, 670)
            self.m_pAnimCard[i]:setPosition(pos)
            self.m_pNodeArmature:addChild(self.m_pAnimCard[i])
        end
        if isResule then
            if i == 1 then
                ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_FLOP_CARD)
                self:replaceArmatureSprite(self.m_pAnimCard[i], cards[i])
                self.m_pAnimCard[i]:getAnimation():play("Animation1")
            end
            local animationEvent = function(armatureBack, movementType, movementID)
                 if movementType == ccs.MovementEventType.complete then
                    if i == 1 then
                        local value, color = LhdzDataMgr.getInstance():getCardValueAndColor(cards[i])
                        ExternalFun.playGameEffect(string.format(Lhdz_Res.vecSound.SOUND_OF_VALUE, value))
                        self:doSomethingLater(function( ... )
                            ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_FLOP_CARD)
                            self:replaceArmatureSprite(self.m_pAnimCard[i+1], cards[i+1])
                            self.m_pAnimCard[i+1]:getAnimation():play("Animation1")
                        end, 0.5)
                    else
                        local value, color = LhdzDataMgr.getInstance():getCardValueAndColor(cards[i])
                        ExternalFun.playGameEffect(string.format(Lhdz_Res.vecSound.SOUND_OF_VALUE, value))
                        self:doSomethingLater(function( ... )
                            local areaType = LhdzDataMgr:getInstance():getAreaType()
                            local areaSound = Lhdz_Res.vecSound.SOUND_OF_DRAW
                            if areaType == Lhdz_Const.AREA.DRAGON then
                                areaSound = Lhdz_Res.vecSound.SOUND_OF_DRAGON
                            elseif areaType == Lhdz_Const.AREA.TIGER then
                                areaSound = Lhdz_Res.vecSound.SOUND_OF_TIGER
                            end
                            ExternalFun.playGameEffect(areaSound)
                            self.m_chipMgr:flychipex(function()
                                 self:playUserScoreEffect()
                            end)
                            --self:updateGameRecord()
                            self:updateTempGameRecord()
                            self:showWinAreaAnim()
                        end, 1)
                    end
                 end
            end
            self.m_pAnimCard[i]:getAnimation():setMovementEventCallFunc(animationEvent)
        else
            self.m_pAnimCard[i]:getAnimation():play("Animation2")
            self.m_pAnimCard[i]:getAnimation():setMovementEventCallFunc(function()
                return nil
            end)
        end
    end

    self:showPokerAmin(isResule)]]
end

-- 播放牌的特效
function GameViewLayer:showPokerAmin(isResule)
    for i=1, 2 do
        local pokerAnim = self.m_pNodeArmature:getChildByName("PokerAnimation"..i)
        if not pokerAnim then
            local strJson = string.format(Lhdz_Res.ANI_OF_PAIXIAO, "json")
            local strAtlas = string.format(Lhdz_Res.ANI_OF_PAIXIAO, "atlas")
            pokerAnim = sp.SkeletonAnimation:create(strJson, strAtlas)
            pokerAnim:setScale(1.1)
            local pos = i == 1 and cc.p(576, 670)or cc.p(756, 670)
            pokerAnim:setPosition(pos)
            pokerAnim:setName("PokerAnimation"..i)
            self.m_pNodeArmature:addChild(pokerAnim, Z_ORDER_BOTTOM)
        end
        local animation = isResule and "animation2" or "animation1"
        pokerAnim:setAnimation(0, animation, true)
        pokerAnim:update(0)
        if animation == "animation2" then
            pokerAnim:setPositionY(672)
        else
            pokerAnim:setPositionY(665)
        end
        pokerAnim:setVisible(not isResule)
        if isResule then
            local func = cc.CallFunc:create(function()
                local areaType = LhdzDataMgr.getInstance():getAreaType()
                if i == Lhdz_Const.AREA.DRAGON then
                    pokerAnim:setVisible(areaType~=2 or (not isResule))
                else
                    pokerAnim:setVisible(areaType~=1 or (not isResule))
                end
            end)
            pokerAnim:runAction(cc.Sequence:create(cc.DelayTime:create(2.5), func))
        end
    end
end

-- 开始下注or结算下注
function GameViewLayer:showGameStatusAnim()
    if LhdzDataMgr.getInstance():getGameStatus() == Lhdz_Const.STATUS.GAME_SCENE_BET then
        ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_START_BET)
        self.m_FileNodeStartEnd:setVisible(true)
        _:playTimelineAction('game/longhudazhan/DragonBetTip.csb', 'kaishixiazhu', self.m_FileNodeStartEnd, false)
        performWithDelay(self.m_FileNodeStartEnd, function()
            self.m_FileNodeStartEnd:setVisible(false)
        end, 1.2)
    elseif LhdzDataMgr.getInstance():getGameStatus() == Lhdz_Const.STATUS.GAME_SCENE_RESULT then
        ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_STOP_BET)
        self.m_FileNodeStartEnd:setVisible(true)
        _:playTimelineAction('game/longhudazhan/DragonBetTip.csb', 'xiazhujieshu', self.m_FileNodeStartEnd, false)
        performWithDelay(self.m_FileNodeStartEnd, function()
            self.m_FileNodeStartEnd:setVisible(false)
        end, 1.2)
    end
end

-- VS动画
function GameViewLayer:showGameVSAnim()
--[[    if LhdzDataMgr.getInstance():getGameStatus() == Lhdz_Const.STATUS.GAME_SCENE_FREE then
        ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_BATTLE)
        if not self.m_pAnimVs then
            local strJson = string.format(Lhdz_Res.ANI_OF_ANIMAL, "json")
            local strAtlas = string.format(Lhdz_Res.ANI_OF_ANIMAL, "atlas")
            self.m_pAnimVs = sp.SkeletonAnimation:create(strJson, strAtlas)
            self.m_pAnimVs:setPosition(cc.p(637+145, 375))
            self.m_pNodeAnimVS:addChild(self.m_pAnimVs, Z_ORDER_BOTTOM)
        end
        self.m_pAnimVs:setToSetupPose()
        self.m_pAnimVs:setAnimation(0, "animation3", false)
        self.m_pNodeAnimVS:setVisible(true)
        self:doSomethingLater(function()
            self.m_pNodeAnimVS:setVisible(false)
        end,2)

    end]]
end

-- 神算子下注飘星
function GameViewLayer:playFlyStarAnim(isInitGame)
--[[    for i=1, Lhdz_Const.GAME_DOWN_COUNT do
        local isNo1Bet = LhdzDataMgr.getInstance():getIsNo1BetByIndex(i)
        if isNo1Bet and (not self.m_bIsShowStar[i]) then
            self.m_bIsShowStar[i] = true
            if isInitGame then
                self.m_pSpStar[i]:setVisible(true)
            else
                self:playstar(i)
            end
        end
    end]]
end

-- 结算飘数字动画
--[[
    弹分规则：
    1 宽屏显示下，一律与头像居中显示
    2 非宽屏显示，数值展示宽度小于指定值，则居中显示(锚点x=0.5)，否则按左右对齐显示(右侧显示锚点x=1 左侧显示锚点x=0)
]]--
function GameViewLayer:playUserScoreEffect()
    local llAwardValue = 0
    local bBanker = LhdzDataMgr.getInstance():isBanker()
    if bBanker then
        llAwardValue = LhdzDataMgr.getInstance():getBankerResult()
    else
        llAwardValue = LhdzDataMgr.getInstance():getMyResult() 
    end

    for i = 1, Lhdz_Const.TABEL_USER_COUNT do
        if LhdzDataMgr.getInstance():getTableBetValue(i) > 0 and --有投注行为
            not ((LhdzDataMgr.getInstance():getAreaType() == Lhdz_Const.AREA.DRAW) and
                 (0 == LhdzDataMgr.getInstance():getTableAreaBetValue(i, Lhdz_Const.AREA.DRAW))) --非开和没下和
            then
            local tableUser = LhdzDataMgr.getInstance():getTableUserInfo(i)
            if tableUser and tableUser[1] then
                local tableUserResult = LhdzDataMgr.getInstance():getTableResult(i)
                if tableUserResult > 0 then
                    self:showTableUserWinAnim(i)
                    self.m_getChipEffect[i]:setVisible(true)
                    self.m_getChipEffect[i]:setAnimation(0, "animation", true)
                    self:doSomethingLater(function()
                        self.m_getChipEffect[i]:setToSetupPose()
                        self.m_getChipEffect[i]:setVisible(false)
                    end, 2.2)
                end
                local fntfile = (tableUserResult >= 0) and Lhdz_Res.FNT_OF_RESULT_WIN or Lhdz_Res.FNT_OF_RESULT_LOSE
                self.m_pLbTableResultGold[i]:setFntFile(fntfile)
            
                --设置正确显示的位置
                local scoreWidth = self:getScoreWidth(tableUserResult)
                local anchor, posx = self:getScoreViewPos(i, scoreWidth)
--                print("分值:" .. tableUserResult)
--                print("数值宽度:" .. scoreWidth)
--                print("计算锚点:" .. anchor)
--                print("位移坐标:" .. posx)
--                print("玩家索引:" .. i)
                self.m_pLbTableResultGold[i]:setAnchorPoint(anchor, 0.5)
                self.m_pLbTableResultGold[i]:setPosition(posx, 0)
            
                local fuhaoStr = ((tableUserResult >= 0)) and "+" or ""
                local nNum,decimal = math.modf(tableUserResult)
                if math.abs(decimal)==0 then
                    local goldStr = string.format("%+d元",tableUserResult)
                    self.m_pLbTableResultGold[i]:setString(goldStr)
                else
                    self.m_pLbTableResultGold[i]:setString( string.format("%+0.2f元",tableUserResult))
                end
                
                self.m_pLbTableResultGold[i]:setPosition(cc.p(self.m_pLbTableResultGold[i]:getPositionX(), -30))
                --self.m_pLbTableResultGold[i]:runAction(cc.Sequence:create(
                local action = cc.Sequence:create(
                    cc.Show:create(),
                    cc.EaseBounceOut:create(cc.MoveBy:create(0.6, cc.p(0, 50))), 
                    cc.DelayTime:create(1.8), 
                    cc.FadeOut:create(0.5),
                    cc.CallFunc:create(function()
                        self.m_pLbTableResultGold[i]:stopAllActions()
                end))
                self.m_pLbTableResultGold[i]:setOpacity(255)
                self.m_pLbTableResultGold[i]:runAction(action)
            end
        end
    end

    self:updateTableUserScore()

    --local stateBanker = (LhdzDataMgr.getInstance():getAllOtherBetValue() > 0) and bBanker
    --if not bBanker or stateBanker then
    if LhdzDataMgr.getInstance():getAllMyBetValue() > 0 and --有投注行为
        not ((LhdzDataMgr.getInstance():getAreaType() == Lhdz_Const.AREA.DRAW) and
             (0 == LhdzDataMgr.getInstance():getMyBetValue(Lhdz_Const.AREA.DRAW))) --非开和没下和
        then
        if not bBanker then
            local fntfile = (llAwardValue >= 0) and Lhdz_Res.FNT_OF_RESULT_WIN or Lhdz_Res.FNT_OF_RESULT_LOSE
            self.m_pLbResultGold:setFntFile(fntfile)
            local fuhaoStr =  ((llAwardValue >= 0)) and "+" or ""
            local goldStr = string.format("%s%s元",fuhaoStr,(llAwardValue))
            local decimal = math.modf(llAwardValue)
            if math.abs(decimal)==0 then
                goldStr = string.format("%s%s元",fuhaoStr,llAwardValue)
            end
            self.m_pLbResultGold:setString(goldStr)
        else
            local fntfile = (llAwardValue >= 0) and Lhdz_Res.FNT_OF_RESULT_WIN or Lhdz_Res.FNT_OF_RESULT_LOSE
            self.m_pLbResultGold:setFntFile(fntfile)
            local fuhaoStr = ((llAwardValue >= 0)) and "+" or ""
            if ( (llAwardValue ) < 0) and ( (llAwardValue ) > -1) then fuhaoStr = "" end
            local goldStr = string.format("%s%s元",fuhaoStr,(llAwardValue))
            local decimal = math.modf(llAwardValue)
            if math.abs(decimal)==0 then
                goldStr = string.format("%s%s元",fuhaoStr,llAwardValue)
            end
            self.m_pLbResultGold:setString(goldStr)
        end
        local pos = cc.p(self.m_pLbResultGold:getPosition())
        local action = cc.Sequence:create(
            cc.Show:create(),
            cc.EaseBounceOut:create(cc.MoveBy:create(0.6, cc.p(0,25))),
            cc.DelayTime:create(1.8),
            cc.FadeOut:create(0.5),
            cc.CallFunc:create(function ()
                self.m_pLbResultGold:setVisible(false)
                self.m_pLbResultGold:setPosition(pos)
                self.m_pLbResultGold:stopAllActions()
        end))
        if LhdzDataMgr.getInstance():getAllMyBetValue() > 0 or bBanker then
            self.m_pLbResultGold:setOpacity(255)
            self.m_pLbResultGold:setVisible(true)
            self.m_pLbResultGold:runAction(action)
        end
    end

        --庄家飘数字
        self.m_pLbBankerResultGold:setVisible(true)
        self.m_pLbBankerResultGold:setOpacity(255)
        --local posBankGold = cc.p(self.m_pLbBankerResultGold:getPosition())
        local posBankGold = cc.p(335, 553)
        self.m_pLbBankerResultGold:setPosition(posBankGold)
        local action1 = cc.Sequence:create(
            cc.Show:create(),
            cc.EaseBounceOut:create(cc.MoveBy:create(0.6, cc.p(0,25))),
            cc.DelayTime:create(1.8),
            cc.FadeOut:create(0.5),
            cc.CallFunc:create(function ()
                self.m_pLbBankerResultGold:setVisible(false)
                self.m_pLbBankerResultGold:setPosition(posBankGold)
                self.m_pLbBankerResultGold:stopAllActions()
                
        end))
        local bankscore = LhdzDataMgr.getInstance():getBankerResult()
        local fntfile = (bankscore >= 0) and Lhdz_Res.FNT_OF_RESULT_WIN or Lhdz_Res.FNT_OF_RESULT_LOSE
        self.m_pLbBankerResultGold:setFntFile(fntfile)
        local fuhaoStr =  ((bankscore >= 0)) and "+" or ""
        local goldStr = string.format("%s%s元",fuhaoStr,(bankscore))
        local decimal = math.modf(bankscore)
        if math.abs(decimal)==0 then
            goldStr = string.format("%s%s元",fuhaoStr,bankscore)
        end
        self.m_pLbBankerResultGold:setString(goldStr)
        
        self.m_pLbBankerResultGold:runAction(action1)
    --end

    
    if not bBanker and LhdzDataMgr.getInstance():getAllMyBetValue() == 0 then
        --FloatMessage.getInstance():pushMessageForString("本局您没有下注!");
    end

    local llUserScore = self.m_iLastPlayerGold
    local call_back = function()
        self.m_pLbUserGold:setString((PlayerInfo.getInstance():getUserScore()))
    end

    local iLastScore = self.m_iLastPlayerGold + llAwardValue + LhdzDataMgr.getInstance():getAllMyBetValue()

    --自己金币变化动画
    if llAwardValue > 0 then
        --Effect:getInstance():showScoreChangeEffect(self.m_pLbUserGold, llUserScore, llAwardValue, llUserScore + (PlayerInfo.getInstance():getUserScore() - llUserScore) ,1,10, nil, handler(self, call_back))
        Effect:getInstance():showScoreChangeEffectWithNoSound(self.m_pLbUserGold, llUserScore, llAwardValue, iLastScore)
    else
        self.m_pLbUserGold:setString((iLastScore))
    end
    LhdzDataMgr.getInstance():setBankerScore(self.delermoneys)
    self:updatebankerInfo()
--    if llAwardValue > 0 then
--        ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_WIN)
--    elseif (not bBanker and LhdzDataMgr.getInstance():getAllMyBetValue() > 0 ) or (bBanker and llAwardValue < 0) then
--        ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_LOSE)
--    else
--        ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_NOBET)
--    end
    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_POPGOLD)
    self:doSomethingLater(function()
        ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_POPSCORE)
    end, 0.3)
end

-- 上桌玩家获胜动画
function GameViewLayer:showTableUserWinAnim(index)

--[[    --神算子和富豪的特效  屏蔽
    if 1 == index then
        self.m_luckyWinEffect:getAnimation():play(Lhdz_Res.ANI_OF_TOPWINEFFECT.ANILIST.LUCKYPLAY.NAME, -1, -1)
    elseif 2 == index then
        self.m_richWinEffect:getAnimation():play(Lhdz_Res.ANI_OF_TOPWINEFFECT.ANILIST.RICHPLAY.NAME, -1, -1)
    end

    local userInfoP = self.m_pNodeShowPlayer[index]:getChildByName("Button_userInfo")
    local tableUser = userInfoP:getChildByName("Node_winAnim")
    local userWin = tableUser:getChildByName("UserWin"..index)
    if not userWin then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(Lhdz_Res.ANI_OF_WINNER.FILEPATH)  
        userWin = ccs.Armature:create(Lhdz_Res.ANI_OF_WINNER.FILENAME)
        userWin:getAnimation():playWithIndex(0,-1,-1)
        userWin:getAnimation():setSpeedScale(0.8)
        userWin:setPosition(cc.p(0, 0))
        userWin:setName("UserWin"..index)
        userWin:setVisible(false)
        tableUser:addChild(userWin, Z_ORDER_BOTTOM)
    end
    userWin:setVisible(true)]]
end

-- 隐藏上桌玩家获胜动画
function GameViewLayer:hideTableUserWinAnim()
--[[    --神算子和富豪的特效
    self.m_luckyWinEffect:getAnimation():play(Lhdz_Res.ANI_OF_TOPWINEFFECT.ANILIST.LUCKYNORMAL.NAME, -1, 0)
    self.m_richWinEffect:getAnimation():play(Lhdz_Res.ANI_OF_TOPWINEFFECT.ANILIST.RICHNORMAL.NAME, -1, 0)]]

    for i = 1, Lhdz_Const.TABEL_USER_COUNT do
        local userInfoP = self.m_pNodeShowPlayer[i]:getChildByName("Button_userInfo")
        local tableUser = userInfoP:getChildByName("Node_winAnim")
        local userWin = tableUser:getChildByName("UserWin"..i)
        if userWin then
            userWin:setVisible(false)
        end
    end
end

-- 获胜区域动画
function GameViewLayer:showWinAreaAnim()
    local areaType = LhdzDataMgr.getInstance():getAreaType()
    if not self.m_pSpWinArea[areaType] then
        return
    end
    self.m_pSpWinArea[areaType]:setVisible(true)
    self.m_pSpWinArea[areaType]:runAction(cc.Repeat:create(cc.Sequence:create(cc.FadeIn:create(0.5), cc.FadeOut:create(0.5)), 5))
    self.m_trendView:updateTrend()
    --todo
    local soundPath = Lhdz_Res.vecSound.SOUND_OF_ANIDRAGONWIN
    local strEfc = "Animation1"
    --local strEfc = "Animation2"
    if areaType == 2 then
        strEfc = "Animation3"
        --strEfc = "Animation2"
        soundPath = Lhdz_Res.vecSound.SOUND_OF_ANITIGERWIN
    end
    if areaType == 3 then 
        strEfc = "Animation2"
        soundPath = nil
    end
    if not self._longhuTeXiao then
        local animationEvent = function (armatureBack, movementType, movementID)
            if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
                self._longhuTeXiao:setVisible(false)
            end
        end
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(Lhdz_Res.ANI_OF_LAOHUTEXIAO.FILEPATH)
        self._longhuTeXiao = ccs.Armature:create(Lhdz_Res.ANI_OF_LAOHUTEXIAO.FILENAME)
        self._longhuTeXiao:setPosition(cc.p(962, 281))
        self.m_pNodeArmature:addChild(self._longhuTeXiao)
        self._longhuTeXiao:getAnimation():setMovementEventCallFunc(animationEvent)
        self._longhuTeXiao:getAnimation():setSpeedScale(0.8)
        self._longhuTeXiao:setScale(2)
    end
    if self._longhuTeXiao then
        self._longhuTeXiao:setVisible(true)
        self._longhuTeXiao:getAnimation():play(strEfc)
        if soundPath then
            ExternalFun.playGameEffect(soundPath)
        end
    end

end

-- 隐藏获胜区域动画
function GameViewLayer:hideWinAreaAnim()
    for i = 1, Lhdz_Const.GAME_DOWN_COUNT do
        self.m_pSpWinArea[i]:setVisible(false)
        self.m_pSpWinArea[i]:stopAllActions()
    end
end

-- 倒计时动画
function GameViewLayer:showCountDownAnim(val)
    local scaleTo = cc.ScaleTo:create(0.15, 1.4)
    local scaleBack = cc.ScaleTo:create(0.15, 1)
    local seq = cc.Sequence:create(scaleTo, scaleBack)
    self.m_pLbCountTime:runAction(seq)

    local fntstr = Lhdz_Res.FNT_OF_COUNTDOWN
    -- 数字扩张发散动画
    local aniscale = 1.5
    local aniscaletime = 0.3
    local fadetotime = 0.3
    local lb1 = cc.Label:createWithBMFont(fntstr, string.format("%d", val))
                --:setPosition(cc.p( self.m_pLbCountTime:getPosition()))
                :setAnchorPoint(0, 0)
                :setOpacity(0)
                :addTo(self.m_pLbCountTime)

    local seq1 = cc.Sequence:create(cc.Spawn:create(cc.FadeTo:create(fadetotime, 70),
                                                    cc.ScaleTo:create(fadetotime, aniscale)),
                                    cc.Spawn:create(cc.FadeOut:create(0.5),
                                                    cc.ScaleTo:create(0.3, 2.5)),
                                    cc.RemoveSelf:create())
    lb1:runAction(seq1)
end

function GameViewLayer:clearFlyStatus()
    print ("-----------------------------------------------------------------------------------------------------")
    print ("-----------------------------------------------------------------------------------------------------")
    print ("-----------------------------------------------------------------------------------------------------function GameViewLayer:clearFlyStatus()")
    for i=1,Lhdz_Const.GAME_DOWN_COUNT do
        if not self.flyStar_bagua[i] then
            self.flyStar_bagua[i] = cc.Sprite:createWithSpriteFrameName(Lhdz_Res.PNG_OF_BAGUAFLY)
            self.flyStar_bagua[i]:addTo(self.m_pNodeStar)
        end
        self.flyStar_bagua[i]:setVisible(false)
        self.flyStar_bagua[i]:stopAllActions()
        self.flyStar_bagua[i]:setPosition(Lhdz_Const.FLYSTAR.STAR_BEGINPOS)

        if not self.lightStar_bagua[i] then
            self.lightStar_bagua[i] = cc.Sprite:createWithSpriteFrameName(Lhdz_Res.PNG_OF_BAGUAEFFECT)
            self.lightStar_bagua[i]:addTo(self.m_pNodeStar)
        end
        self.lightStar_bagua[i]:stopAllActions()
        self.lightStar_bagua[i]:setPosition(Lhdz_Const.FLYSTAR.STAR_ENDPOS[i])
        self.lightStar_bagua[i]:setOpacity(0)

        for j = 1, Lhdz_Const.FLYPARTICAL_COUNT do
            self.m_particalvec[i][j]:stopAllActions()
            self.m_particalvec[i][j]:setPosition(Lhdz_Const.FLYSTAR.STAR_BEGINPOS)
            self.m_particalvec[i][j]:setVisible(false)
            self.m_particalvec[i][j]:resetSystem()
        end
    end
end

--神算子飞星
function GameViewLayer:playstar(i)
--[[
    1 光效八卦在飞星到位后，从透明度0递增到255同时旋转720度，时间35帧，然后10帧渐隐消失
    2 飞行八卦在飞星到位后，从透明度255递减到0同时旋转720度消失
    3 显示八卦在飞星到位后，从透明度0递增到255同时旋转720度保持显示
]]--

    self.m_pSpStar[i]:setVisible(false)
    for j = 1, Lhdz_Const.FLYPARTICAL_COUNT do
        self.m_particalvec[i][j]:stopAllActions()
        self.m_particalvec[i][j]:setPosition(Lhdz_Const.FLYSTAR.STAR_BEGINPOS)
        self.m_particalvec[i][j]:setVisible(true)
        self.m_particalvec[i][j]:resetSystem()
    end

    --飞行八卦
    self.flyStar_bagua[i]:setVisible(true)
    self.flyStar_bagua[i]:setOpacity(255)
    self.flyStar_bagua[i]:setPosition(Lhdz_Const.FLYSTAR.STAR_BEGINPOS)
    self.flyStar_bagua[i]:setLocalZOrder(101)
    --self.flyStar_bagua:addTo(self.m_pNodeStar)

    local func = cc.CallFunc:create(function()
        --光效
        self.lightStar_bagua[i]:setBlendFunc(cc.blendFunc(GL_ONE, GL_ONE))
        self.lightStar_bagua[i]:setPosition(Lhdz_Const.FLYSTAR.STAR_ENDPOS[i])
        self.lightStar_bagua[i]:setOpacity(0)
        self.lightStar_bagua[i]:setLocalZOrder(102)
        --self.lightStar_bagua[i]:addTo(self.m_pNodeStar)
        self.lightStar_bagua[i]:runAction(cc.Sequence:create(
                                cc.EaseQuadraticActionIn:create(cc.Spawn:create(cc.RotateBy:create(35/60, 720), cc.FadeTo:create(35/60, 255))),
                                cc.FadeTo:create(10/60, 0)
                                --cc.RemoveSelf:create()
                                ))


        --显示八卦
        self.m_pSpStar[i]:setVisible(true)
        self.m_pSpStar[i]:setRotation(0)
        self.m_pSpStar[i]:setOpacity(0)
        self.m_pSpStar[i]:setPosition(Lhdz_Const.FLYSTAR.STAR_ENDPOS[i])
        self.m_pSpStar[i]:runAction(cc.EaseQuadraticActionIn:create(cc.Spawn:create(cc.RotateBy:create(35/60, 720), cc.FadeTo:create(35/60, 255))))
    end)

    local bezier = {
        Lhdz_Const.FLYSTAR.BEZIERPOS[i][1],
        Lhdz_Const.FLYSTAR.BEZIERPOS[i][2],
        Lhdz_Const.FLYSTAR.STAR_ENDPOS[i],
    }

    self.flyStar_bagua[i]:runAction(cc.Sequence:create(
                         cc.BezierTo:create(Lhdz_Const.FLYSTAR.FLY_TIME[i], bezier),
                         func,
                         cc.EaseQuadraticActionIn:create(cc.Spawn:create(cc.RotateBy:create(35/60, 720), cc.FadeTo:create(35/60, 0)))
                         --cc.RemoveSelf:create()
                         )
                     )

    for j = 1, Lhdz_Const.FLYPARTICAL_COUNT do
        self:doSomethingLater(function()
            self.m_particalvec[i][j]:runAction(
                cc.BezierTo:create(Lhdz_Const.FLYSTAR.FLY_TIME[i], bezier)
            )                
        end, 1/60 * j)
    end
    ExternalFun.playGameEffect(Lhdz_Res.vecSound.SOUND_OF_STAR)
end

--筹码光效动画
function GameViewLayer:initChipEffect()
    self.m_chipEffect = cc.Sprite:create(Lhdz_Res.PNG_OF_CHIP_EFFECT)
    self.m_chipEffect:setAnchorPoint(0.5, 0.5)
    self.m_chipEffect:addTo(self.m_pNodeJetton)
    self.m_chipEffect:setVisible(false)
    self.m_chipEffect:setBlendFunc(cc.blendFunc(GL_ONE, GL_ONE))
    self.m_chipEffect:runAction(cc.RepeatForever:create(cc.RotateBy:create(1.5, 360)))
end

--头像获取筹码动画
function GameViewLayer:initGetChipEffect()
    local strJson = string.format(Lhdz_Res.ANI_OF_GETCHIP2, "json")
    local strAtlas = string.format(Lhdz_Res.ANI_OF_GETCHIP2, "atlas")
    for i = 1, 6 do
        local userInfoP = self.m_pNodeShowPlayer[i]:getChildByName("Button_userInfo")
        local node = userInfoP:getChildByName("Node_winAnim")
        self.m_getChipEffect[i] = sp.SkeletonAnimation:create(strJson, strAtlas)
        self.m_getChipEffect[i]:setScale(0.7)
        self.m_getChipEffect[i]:setPositionY(-14)
        self.m_getChipEffect[i]:setVisible(false)
        self.m_getChipEffect[i]:addTo(node)
    end
end

--初始化大富豪和神算子获胜特效
function GameViewLayer:initTopWinEffect()
--[[    --神算子
    
    ParticalPool.getInstance():createLuckyWinEffect()
    self.m_luckyWinEffect = ParticalPool.getInstance():getLuckyWinEffect()
    self.m_luckyWinEffect:setPosition(cc.p(58, 111.5))
    self.m_luckyWinEffect:addTo(self.m_pNodeShowPlayer[1]:getChildByName("Button_userInfo"))

    --大富豪
    
    ParticalPool.getInstance():createRichWinEffect()
    self.m_richWinEffect = ParticalPool.getInstance():getRichWinEffect()
    self.m_richWinEffect:setPosition(cc.p(59.5, 110))
    self.m_richWinEffect:addTo(self.m_pNodeShowPlayer[2]:getChildByName("Button_userInfo"))]]
end

--初始化获胜区域动画
function GameViewLayer:initAreaWinEffect()
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(Lhdz_Res.ANI_OF_WINHU.FILEPATH) 
    self.m_areaWinEffect[2] = ccs.Armature:create(Lhdz_Res.ANI_OF_WINHU.FILENAME)
    self.m_areaWinEffect[2]:setPosition(cc.p(971.81, 248.20))
    self.m_areaWinEffect[2]:setVisible(false)
    self.m_pNodeArmature:addChild(self.m_areaWinEffect[2], Z_ORDER_BOTTOM)

    local animationEvent = function(armatureBack, movementType, movementID)
        if movementType == ccs.MovementEventType.complete then
            self.m_areaWinEffect[2]:setVisible(false)
        end
    end
    self.m_areaWinEffect[2]:getAnimation():setMovementEventCallFunc(animationEvent)

end

---------------------------------- play animation end ----------------------------------

---------------------------------- help func start ----------------------------------
-- 获取玩家的位置
function GameViewLayer:getUserPosition(wChairID, isBet, wJettonIndex)
    local userIndex = LhdzDataMgr.getInstance():getUserByChirId(wChairID)
    local pos = cc.p(0, 0)
    if userIndex == 0 then
        -- 玩家自己
        if isBet then
            pos.x = self.m_pBtnJetton[wJettonIndex]:getPositionX()
            pos.y = self.m_pBtnJetton[wJettonIndex]:getPositionY()
        else
            pos.x = 52
            pos.y = 24
        end
    elseif userIndex == -1 then
        -- 其他玩家
        pos.x = 47
        pos.y = 120
    else
        -- 上桌玩家
        pos.x = self.m_pNodeTablePlayer[userIndex]:getPositionX()
        pos.y = self.m_pNodeTablePlayer[userIndex]:getPositionY()
    end
    return pos
end

function GameViewLayer:replaceArmatureSprite(armature, card)
    local value, color = LhdzDataMgr.getInstance():getCardValueAndColor(card)
    local pBone = armature:getBone("jiedian")
        if pBone then
            local pNode = display.newNode()
            local pSpValue1 = cc.Sprite:createWithSpriteFrameName(string.format(Lhdz_Res.PNG_OF_CARD_VALUE, value, color%2))
            pSpValue1:setPosition(cc.p(-24, 33))
            pNode:addChild(pSpValue1)
            local pSpColor1 = cc.Sprite:createWithSpriteFrameName(string.format(Lhdz_Res.PNG_OF_CARD_COLOR, color))
            pSpColor1:setPosition(cc.p(-24, 4))
            pNode:addChild(pSpColor1)
            local pSpColor2 = cc.Sprite:createWithSpriteFrameName(string.format(Lhdz_Res.PNG_OF_CARD_BIGCOLOR, color))
            pSpColor2:setPosition(cc.p(18, -30))
            pNode:addChild(pSpColor2)
            pBone:addDisplay(pNode, 0)
            pBone:changeDisplayWithIndex(0, true)
        end
end

--切换用户头像
function GameViewLayer:replaceUserHeadSprite(armature, cfg, faceId)
    if not cfg then
        return
    end

    local pBone = armature:getBone(cfg.NODES.HEAD)
    if pBone then
        local pNode = display.newNode()
        local pSpValue1 = cc.Sprite:create()
        pSpValue1:setSpriteFrame( string.format(Lhdz_Res.PNG_OF_HEAD, faceId % G_CONSTANTS.FACE_NUM + 1))
        pNode:addChild(pSpValue1)
        pBone:addDisplay(pNode, 0)
        pBone:changeDisplayWithIndex(0, true)
    end
end

-- 请勿频繁点击
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

function GameViewLayer:shedule(node , callback ,  time)
    node:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(time),cc.CallFunc:create(
        callback
     ))))
end

---------------------------------- help func end ----------------------------------

---------------------------------- resource start ----------------------------------
--延时播放音效
function GameViewLayer:doSoundPlayLater(strSound, delay)
    if delay <= 0 then
        ExternalFun.playGameEffect(strSound)
    else
        self:doSomethingLater(function()
            ExternalFun.playGameEffect(strSound)
        end, delay)
    end
end

function GameViewLayer:doSomethingLater(call, delay, ...)
    self.m_rootUI:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(call, {...})))
end
---------------------------------- resource end ----------------------------------

--region 动画

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

    self.m_userBtnVec[idx]:stopAllActions()
    self.m_userBtnVec[idx]:setPosition(self.m_userBtnResPosVec[idx])

    local moveTo = cc.MoveTo:create(ts, cc.p(self.m_userBtnResPosVec[idx].x + offsetX[idx], self.m_userBtnResPosVec[idx].y))
    local moveBack = cc.MoveTo:create(ts, self.m_userBtnResPosVec[idx])
    local seq = cc.Sequence:create(moveTo, moveBack)

    self.m_userBtnVec[idx]:runAction(seq)
end

--endregion

--region 辅助方法
function GameViewLayer:tryLayoutforIphoneX()
    if LuaUtils.isIphoneXDesignResolution() then
        local offset = 200
        --self.m_pBtnExit:setPositionX(self.m_pBtnExit:getPositionX() - offset)
        --self.m_pBtnMenuPush:setPositionX(self.m_pBtnMenuPush:getPositionX() + offset)
        --self.m_pBtnMenuPop:setPositionX(self.m_pBtnMenuPop:getPositionX() + offset)
        --self.m_pClippingMenu:setPositionX(self.m_pClippingMenu:getPositionX() + offset - 20)
        self.m_pSpMenuBg:setPositionX(self.m_pSpMenuBg:getPositionX() - offset)
    end
end
function GameViewLayer:showRecharge()
    local pMessageBox = MessageBoxNew.create(Lhdz_Res.MESSAGEBOX_IMG.RECHARGE, MsgBoxPreBiz.PreDefineallBack.CB_RECHARGE)
    self:addChild(pMessageBox, 1000)
    pMessageBox:setPositionY(pMessageBox:getPositionY()-((display.height - 750) / 2))
end

--获取弹分的宽度
function GameViewLayer:getScoreWidth(score)
    if 0 == score then
        return 0
    end

    local retLen = Lhdz_Const.SCOREWIDTH.PRE + 34
    local v1, v2 = math.modf(score / 100)
    if v2 > 0 then
        retLen = retLen + Lhdz_Const.SCOREWIDTH.DOT + 2*Lhdz_Const.SCOREWIDTH.NUM
    end

    retLen = retLen + #tostring(v1) * Lhdz_Const.SCOREWIDTH.NUM
    return retLen
end

--根据上桌玩家索引和数值显示宽度获取显示锚点X和坐标X
function GameViewLayer:getScoreViewPos(index, scoreWidth)
    if LuaUtils.isIphoneXDesignResolution() then
        return 0.5, 0
    end

    local isLeft = false
    if 2 == index or 3 == index or 4 == index then
        isLeft = true
    end

    local retAnchor = 0.5
    local retX = 0
    --if scoreWidth > Lhdz_Const.SCOREWIDTH.MAXWIDTH then
    --    retAnchor = isLeft and 0 or 1
    --    retX = isLeft and -78 or 75
    --end

    return retAnchor, retX
end
--endregion

--飞星星贝塞尔测试按钮
function GameViewLayer:addTestBtn()
    self.m_p1 = cc.p(1000, 590)
    self.m_p2 = cc.p(510, 487)
    local btnp1 = ccui.Button:create()
    btnp1:setTitleText("测试点1")
    btnp1:setTitleFontSize(30)
    btnp1:setContentSize(cc.size(150, 40))
    btnp1:setColor(cc.c3b(241,14,99))
    local labelp1 = cc.Label:createWithSystemFont("", "", 24)
    labelp1:setPosition(cc.p(0, 40))
    labelp1:setString("测试点1")
    labelp1:setColor(cc.c3b(241,14,99))
    btnp1:addChild(labelp1)
    btnp1:setPosition(cc.p(1000, 590))
    self.m_pNodeStar:addChild(btnp1)

    btnp1:addTouchEventListener(function (sender,eventType)
        if eventType == ccui.TouchEventType.moved then
            local posMove = sender:getTouchMovePosition()
            btnp1:setPositionX(posMove.x - 145)
            btnp1:setPositionY(posMove.y)
            labelp1:setString( string.format("x:%d, y:%d", posMove.x - 145, posMove.y) )
            self.m_p1 = cc.p(posMove.x - 145, posMove.y)
        end
    end)

    local btnp2 = ccui.Button:create()
    btnp2:setTitleText("测试点2")
    btnp2:setTitleFontSize(30)
    btnp2:setColor(cc.c3b(241,14,99))
    btnp2:setContentSize(cc.size(150, 40))
    local labelp2 = cc.Label:createWithSystemFont("", "", 24)
    labelp2:setPosition(cc.p(0, 40))
    labelp2:setString("测试点2")
    labelp2:setColor(cc.c3b(241,14,99))
    btnp2:addChild(labelp2)
    btnp2:setPosition(cc.p(510, 487))
    self.m_pNodeStar:addChild(btnp2)

    btnp2:addTouchEventListener(function (sender,eventType)
        if eventType == ccui.TouchEventType.moved then
            local posMove = sender:getTouchMovePosition()
            btnp2:setPositionX(posMove.x - 145)
            btnp2:setPositionY(posMove.y)
            labelp2:setString( string.format("x:%d, y:%d", posMove.x - 145, posMove.y) )
            self.m_p2 = cc.p(posMove.x - 145, posMove.y)
        end
    end)
end
----------------------------------------------------------------
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
    end, 0.5)
end

return GameViewLayer
--endregion
