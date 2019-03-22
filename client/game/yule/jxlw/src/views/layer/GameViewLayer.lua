--
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun       = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameChatLayer     = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local ClipText          = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr      = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local module_pre        = "game.yule.jxlw.src"
local cmd               = appdf.req(module_pre .. ".models.CMD_Game")
local Define            = appdf.req(module_pre .. ".models.Define")
local GameRoleItem      = appdf.req(module_pre .. ".views.layer.GameRoleItem")
local HeadSprite        = require(appdf.EXTERNAL_SRC .. "HeadSprite")
local GameLogic         = appdf.req(module_pre .. ".models.GameLogic")
local GameResultLayer   = appdf.req(module_pre .. ".views.layer.GameResultLayer")
local SettingLayer      = appdf.req(module_pre .. ".views.layer.SettingLayer")
local Effect            = appdf.req(module_pre .. ".views.Effect")


local TAG_ENUM = Define.TAG_ENUM
local TAG_ZORDER = Define.TAG_ZORDER

local GameViewLayer = class("GameViewLayer",function(scene)
        local gameViewLayer = display.newLayer()
    return gameViewLayer
end)

local module_pre = "game.yule.jxlw.src.views"
local CMsgTiger             = require(module_pre..".proxy.CMsgTiger")
local TigerRuleLayer        = require(module_pre..".layer.TigerRuleLayer")
local TigerDataMgr          = require(module_pre..".manager.TigerDataMgr")
local Tiger_Events          = require(module_pre..".manager.Tiger_Events")
local Tiger_Res             = require(module_pre..".scene.Tiger_Res")
local TigerConst            = require(module_pre..".scene.Tiger_Const")
local RollNumberView        = require(module_pre..".bean.RollNumberView")
--local GameListConfig        = require("common.config.GameList")    --等级场配置



local FloatMessage  = cc.exports.FloatMessage
local SLFacade      = cc.exports.SLFacade
--local Effect        = require("common.manager.Effect")
local scheduler     = cc.Director:getInstance():getScheduler()--cc.exports.scheduler


local function LOG_PRINT(...) if true then printf(...) end end

local ResultIconNum        = 6      -- 结果展示最多一屏显示数
local IPHONEX_OFFSETX      = 45     -- 宽屏位移
local ZORDER_OF_MESSAGEBOX = 101
local ItemHeight           = 142    -- 每个水果行高
local NodeOffsetY          = 0      -- 每个轴显示节点的y偏移
local ColWidth             = 177.5  -- 每个轴宽度
local LeftOffsetX          = 215    -- 滚动区域左边坐标偏移
local ColHeight            = 428    -- 每个轴高度
local BoundOffsetY         = 100    -- 转动结束回弹动画y偏移
local IconScale            = 0.85   -- 所有滚轴icon和动画缩放比例
---------------------------- constructor --------------------------------------
GameViewLayer.instance_ = nil

---
local G_CONSTANTS = {
    -- UI 显示层级定义
    Z_ORDER_HIDDEN              = -10,
    Z_ORDER_BOTTOM              = 0,
    Z_ORDER_BACKGROUND          = 10,
    Z_ORDER_STATIC              = 20,
    Z_ORDER_MINDDLE             = 40,
    Z_ORDER_COMMON              = 50,
    Z_ORDER_OVERRIDE            = 80,
    Z_ORDER_MODAL               = 90,
    Z_ORDER_TOP                 = 100,

    FACE_NUM = 10,
}

function GameViewLayer:ctor(scene)
print("on enter -----------===========----------    GameViewLayer")
    --注册node事件
    ExternalFun.registerNodeEvent(self)
    self._scene = scene
    for key, var in pairs(Tiger_Res.vecAnim) do
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(Tiger_Res.strAnimPath..var.."/"..var..".ExportJson")
    end
    cc.SpriteFrameCache:getInstance():addSpriteFrames("game/tiger/plist/TigerIconPlist.plist","game/tiger/plist/TigerIconPlist.png")
    self.event_ = {}
    self.handle_ = {}

    math.randomseed(tostring(os.time()):reverse():sub(1, 7))

    LOG_PRINT(" - GameViewLayer onEnter - ")
    self:init()

end

function GameViewLayer:initAllVar_()
    self.m_rootUI = nil             -- 根节点
    -- node.
    self.m_pNodeCenter = nil        -- 中间转盘
    self.m_pNodeMenu = nil          -- 系统菜单
    self.m_pNodeFreeTime = nil      -- 免费次数 Node
    self.m_pNodeLabel = nil         -- 界面Label Node
    self.m_pNodePrize = nil         -- 总池 Node
    self.m_pNodeEffect = nil        -- 动画节点
    self.m_pNodeAnimTop = nil       -- 上层动画节点
    self.m_pNodeMask = nil          -- 动画遮罩层,屏蔽点击
    -- btn
    self.m_pBtnMenuPush = nil   -- 左上角菜单按纽向下
    self.m_pBtnMenuPop  = nil   -- 左上角菜单按纽向上
    self.m_pBtnMenuCancel = nil -- 收回菜单按纽(全屏)
    self.m_pBtnExit = nil       -- 返回
    self.m_pBtnEffect = nil     -- 音效
    self.m_pBtnMusic = nil      -- 音乐
    self.m_pBtnHelp = nil       -- 帮助/规则
    self.m_pBtnBaseScore = nil  -- 底分
    self.m_pBtnBank = nil       -- 银行
    self.m_pBtnAllLine = nil    -- 满线
    self.m_pBtnGameStart = nil  -- 开始
    self.m_pBtnAnimMask = nil   -- 播放动画时屏蔽点击按纽(全屏)
    self.m_pBtnFreeMask = nil   -- 获取免费时屏蔽点击按纽(全屏)

    self.m_pLbNickName = nil        -- 自己昵称
    self.m_pLbUsrGold = nil         -- 自己金币
    self.m_pLbSpePrize = nil        -- 免费次数
    self.m_pLbLineNum = nil         -- 下注线数
    self.m_pLbBetNum = nil          -- 下注底注额
    self.m_pLbTotalBetGold = nil    -- 累计压中
    self.m_pLbCurTotalBetNum = nil  -- 当前下注
    self.m_pClipping = nil          -- 主场景 clipping
    self.m_pClippingMenu = nil      -- 菜单 clipping
    self.m_pNodeNewMsg = nil        -- 聊天消息条数提示 Bg
    self.m_pLbNewMsgNo = nil        -- 聊天消息条数
    
    self.m_pWin777Armature = nil
    self.m_pWinBoxArmature = nil

    self.m_pSchedulerLongPress = nil -- 开始按纽长按倒计时
    
    self.m_pLbResultScore = nil     -- 结算赢取金币 label.

    self.m_vecCliper = {}           -- 每列剪切区域
    self.m_vecColNode = {}          -- 每列显示内容 node.
    self.m_pWinIconArmature = {}      --图标中奖效果
    self.m_pLineArmature = {}    --中奖线动画
    self.m_pLineNodes = {}    --中奖线节点,用来替换中奖线动画
    self.m_pNumCliperArm  = {}      -- 777、box结算动画 随机数字 arm.
    self.m_pWinArmautre = nil   
    self.m_vecCurrentIcon = {}  
    -- 其它玩家信息(暂时没用到)
    self.m_pOtherUserNode = {}
    self.m_pOtherUserIcon = {}
    self.m_pOtherUserGold = {}
    self.m_pOtherUserName = {}
    self.m_pOtherUserGoldBg = {}
    self.m_nOtherUserGoldNum = {}
    self.m_pShineNode = nil         --按钮两侧的闪电
    self.m_pLineHeader = {{},{}}    --连线两端图片

    self.m_nRollStartSoundId = 0
    self.m_nBoxRollSoundId = 0
    self.m_nBetLineNum = 0
    self.m_nUserLoseCount = 0
    self.m_nUserWinCount = 0
    self.m_nSoundType = 0
    self.m_nSoundCount = 0
    self.m_nLastWinSound = 0
    self.m_nLastLoseSound = 0
    self.m_nWinCount = 0        -- 777、box结算动画赢取个数
    self.m_nClickStartBtNum = 0 -- 开始按纽点击次数
    self.m_bLongPress = false   -- 开始按纽是否长按两秒，自动开始
    self.m_bSendGameStart = false
    self.m_bSendGameStop = false
    self.m_eGameState = TigerConst.eGameState.State_Wait
    self.m_bWinChangeScore = false
    self.m_llWinSubScore = 0
    self.m_nCurentWinCount = 0

    self.m_bExit = false
    self.m_bEnterBackground = false
    self.m_menuResPos = {} -- 弹出菜单原始坐标
    self.m_aniSpeed = 0.12  -- 连线动画辐射效果显示时间
    self.m_MoneySyncServer = 0      --同步服务器玩家金钱
    self.m_MoneyYazhuHou = 0        --押注后的钱
    self.isMusicOn = true           --音乐
    self.isEffictOn = true          --音效
end
---------------------------- constructor --------------------------------------

---------------------------- init ---------------------------------------------
function GameViewLayer:init() --onEnter:init
    local _do = {
        { func = self.initVar,      log = "初始化变量",  },
        { func = self.initCCB,      log = "加载界面",    },
        { func = self.initNode,     log = "初始化界面",  },
        { func = self.initGame,     log = "初始化游戏",    },
        { func = self.initEvent,    log = "注册监听",    },
    }
    for i, init in pairs(_do) do
        LOG_PRINT(" - [%d] - [%s] - %s", i, init.func(self) or "ok",  init.log)
    end
end

function GameViewLayer:initVar()
    self:initAllVar_()
end
function GameViewLayer:initCCB()
    LOG_PRINT(" GameViewLayer:initCSB")


    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
    local diffX = 145 - (1624-display.size.width)/2
    self.m_rootUI:setPositionX(diffX)
    -- load csb.
    self.m_rootWidget = cc.CSLoader:createNode(Tiger_Res.CSB_OF_MAINSCENE)
    local diffY = (display.size.height - 750) / 2
    self.m_rootUI:addChild(self.m_rootWidget)

    -- node
    self.m_pNodeCenter = self.m_rootWidget:getChildByName("Node_center")
    self.m_pNodeMenu = self.m_rootWidget:getChildByName("Node_leftMenu")
    self.m_pNodeFreeTime = self.m_rootWidget:getChildByName("Node_freeTime")
    self.m_pNodeLabel = self.m_rootWidget:getChildByName("Node_Lb")
    self.m_pNodePrize = self.m_rootWidget:getChildByName("Node_prize")
    self.m_pNodePrize:setVisible(false)
    self.m_pNodeEffect = self.m_rootWidget:getChildByName("Node_effect")
    self.m_pNodeAnimTop = self.m_rootWidget:getChildByName("Node_effectTop")
    self.m_pBtnNode = self.m_rootWidget:getChildByName("Node_Btn")
    self.m_pNodeMask = self.m_rootWidget:getChildByName("Node_mask")
    self.m_pNodeIconMask = self.m_pNodeEffect:getChildByName("Node_icon_mask")
    self.m_pNodeResultIcon = self.m_rootWidget:getChildByName("Node_ResultIcon")
    self.m_pResultIconBg = self.m_pNodeResultIcon:getChildByName("result_list_bg")


    --初始化控件
    self.m_pBtnMenuPush = self.m_rootWidget:getChildByName("Btn_menu_push")
    self.m_pBtnMenuPop = self.m_rootWidget:getChildByName("Btn_menu_pop")
    self.m_pBtnMenuCancel = self.m_rootWidget:getChildByName("Btn_menu_cancel")
    self.m_pBtnBaseScore = self.m_pBtnNode:getChildByName("Btn_baseScore")
    self.m_pBtnAllLine = self.m_pBtnNode:getChildByName("Btn_allLine")
    self.m_pBtnGameStart = self.m_pBtnNode:getChildByName("Btn_start")      --开始
    self.m_pBtnExit = self.m_rootWidget:getChildByName("Btn_exit")
    local pImage_betlinebg = self.m_pBtnNode:getChildByName("Image_betlinebg")
    self.m_pBtnLineAdd = pImage_betlinebg:getChildByName("Btn_lineadd")
    self.m_pBtnLineReduce = pImage_betlinebg:getChildByName("Btn_linereduce")

    self.m_pImgMenuBg = self.m_pNodeMenu:getChildByName("Img_menuBg")
    self.m_pBtnBank = self.m_pImgMenuBg:getChildByName("Btn_bank")
    self.m_pBtnBank:setTouchEnabled(false)
    self.m_pBtnBank:setColor(cc.c4b(100,100,100,100))
    self.m_pBtnHelp = self.m_pImgMenuBg:getChildByName("Btn_help")
    self.m_pBtnEffect = self.m_pImgMenuBg:getChildByName("Btn_effect")
    self.m_pBtnMusic = self.m_pImgMenuBg:getChildByName("Btn_music")
    self.m_pBtnFreeMask = self.m_pNodeFreeTime:getChildByName("Btn_freeMask")
    
    -- label
    self.m_pLbNickName = self.m_pNodeLabel:getChildByName("Lb_nickName")
    self.m_pLbUsrGold = self.m_pNodeLabel:getChildByName("Lb_usrGold")
    self.m_pLbSpePrize = self.m_pNodeFreeTime:getChildByName("Fnt_freeTimeNum")
    self.m_pLbCurTotalBetNum = self.m_pNodeLabel:getChildByName("Lb_curBetScore")
    self.m_pLbTotalBetGold = self.m_pNodeLabel:getChildByName("Lb_totalWinScore")

    self.m_pImageLine = pImage_betlinebg:getChildByName("Image_line")
    self.m_pLbLineNum = pImage_betlinebg:getChildByName("Fnt_lineNum")

    self.m_pLbBetNum = self.m_pBtnBaseScore:getChildByName("Fnt_baseScore")


    for i = 1, TigerConst.LINE_COUNT do
        self.m_pLineNodes[i] = self.m_pNodeEffect:getChildByName("Node_line" .. i)
        self.m_pLineNodes[i]:setVisible(false)
        self.m_pLineNodes[i]:setZOrder(G_CONSTANTS.Z_ORDER_COMMON - 1)
        for j = 1, 2 do
            self.m_pLineHeader[j][i] = self.m_pNodeCenter:getChildByName( string.format("Image_%d_%d", i, j))
            self.m_pLineHeader[j][i]:setVisible(false)
        end
    end

    local diffX = 145 - (1624-display.size.width)/2


    --适配iphonex
    if LuaUtils.isIphoneXDesignResolution() then
        self.m_pBtnMenuPush:setPositionX(self.m_pBtnMenuPush:getPositionX() + IPHONEX_OFFSETX)
        self.m_pBtnMenuPop:setPositionX(self.m_pBtnMenuPop:getPositionX() + IPHONEX_OFFSETX)
        self.m_pImgMenuBg:setPositionX(self.m_pImgMenuBg:getPositionX() + IPHONEX_OFFSETX)
        self.m_pBtnExit:setPositionX(self.m_pBtnExit:getPositionX() - IPHONEX_OFFSETX)
    end

    --房间号
    self.m_pSpImageBg = self.m_rootWidget:getChildByName("Img_bg")
    self.m_pSpMachine = self.m_pSpImageBg:getChildByName("Image_machine")
    self.m_pSpMachine:setZOrder(1)

    local strName = "1111"
--    local nBaseScore = PlayerInfo.getInstance():getBaseScore()
--    local GameConfig = GameListConfig[PlayerInfo.getInstance():getKindID()]
--    if GameConfig[nBaseScore] and GameConfig[nBaseScore].RoomName then
--        strName = GameConfig[nBaseScore].RoomName
--    end

    local strRoomNo = string.format("%d号房",0001)-- PlayerInfo.getInstance():getCurrentRoomNo())
--    local m_pLbRoomFiled = cc.Label:createWithBMFont(Tiger_Res.FONT_ROOM, strName)
--	m_pLbRoomFiled:setAnchorPoint(cc.p(0.5, 0.5))
--    m_pLbRoomFiled:setScale(0.6)
--	m_pLbRoomFiled:setPosition(cc.p(self.m_pBtnExit:getContentSize().width/2, -16))
--	self.m_pBtnExit:addChild(m_pLbRoomFiled)
--    local m_pLbRoomNo = cc.Label:createWithBMFont(Tiger_Res.FONT_ROOM, strRoomNo)
--	m_pLbRoomNo:setAnchorPoint(cc.p(0.5, 0.5))
--    m_pLbRoomNo:setScale(0.6)
--	m_pLbRoomNo:setPosition(cc.p(self.m_pBtnExit:getContentSize().width/2, -41))
--	self.m_pBtnExit:addChild(m_pLbRoomNo)

    self.m_menuResPos = cc.p(self.m_pImgMenuBg:getPosition())
    print(self.m_menuResPos.x .. "====" .. self.m_menuResPos.y)

--    RollMsg.getInstance():setShowPosition(display.cx, display.height-150.0)

    local armature1 = self:createSpineAni(Tiger_Res.strAnimPath .. Tiger_Res.SPINE_OF_BG)
    armature1:setAnimation(0, "animation1", true)
    armature1:setPosition(cc.p(1334/2 + 145, 750/2))
    armature1:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_pSpImageBg:addChild(armature1,0)

    local armature2 = self:createSpineAni(Tiger_Res.strAnimPath .. Tiger_Res.SPINE_OF_BG)
    armature2:setAnimation(0, "animation2", true)
    armature2:setPosition(cc.p(1334/2 + 165, 750/2))
    armature2:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_pSpImageBg:addChild(armature2,0)


    self.m_pShineNode = self.m_pSpMachine:getChildByName("Node_thunder")
    self.m_pShineNode:setVisible(false)

    self.m_pAniStart = self.m_pBtnGameStart:getChildByName("Arm_start")

    --滚动数字节点
    local Node_jokerscore = self.m_pNodePrize:getChildByName("Node_jokerscore")
    local posVec = {}
    for i = 1, 12 do
        local sp = Node_jokerscore:getChildByName("Image_" .. i)
        local pos = cc.p(sp:getPosition())
        sp:removeFromParent()
        posVec[i] = pos
    end
    self.m_pRollNumber = RollNumberView.create(33, 46, posVec, 10,
                                               Tiger_Res.PNG_OF_FMT_NUM_ICON,
                                               Tiger_Res.PNG_OF_NULL_ICON)
    self.m_pRollNumber:setAnchorPoint(0, 0)
    self.m_pRollNumber:setPosition(cc.p(0, 0))
    self.m_pRollNumber:addTo(Node_jokerscore)
    self.m_pRollNumber:setVisible(false)
end

--function GameViewLayer:testuse()
--    local btnadd = self.m_rootWidget:getChildByName("Button_add")
--    local btnsub = self.m_rootWidget:getChildByName("Button_sub")
--    local textspeed = self.m_rootWidget:getChildByName("Text_speed")
--    textspeed:setString(self.m_aniSpeed)

--    local onBtnAdd = function()
--        self.m_aniSpeed = self.m_aniSpeed + 0.01
--        textspeed:setString(self.m_aniSpeed)
--        self:showLineViewEffect(self.m_aniSpeed)
--    end

--    local onBtnSub = function()
--        self.m_aniSpeed = self.m_aniSpeed - 0.01
--        textspeed:setString(self.m_aniSpeed)
--        self:showLineViewEffect(self.m_aniSpeed)
--    end

--    btnadd:addClickEventListener(handler(self, onBtnAdd))
--    btnsub:addClickEventListener(handler(self, onBtnSub))
--end

function GameViewLayer:initNode()
    --系统下拉菜单
    self.m_pImgMenuBg:setVisible(false)
    local sz = self.m_pImgMenuBg:getContentSize()
    local shap = cc.DrawNode:create()
    local pointArr = {cc.p(self.m_menuResPos.x, self.m_menuResPos.y),
                      cc.p(self.m_menuResPos.x + sz.width, self.m_menuResPos.y),
                      cc.p(self.m_menuResPos.x + sz.width, self.m_menuResPos.y + sz.height + 5),
                      cc.p(self.m_menuResPos.x, self.m_menuResPos.y + sz.height + 5)}
    shap:drawPolygon(pointArr, 4, cc.c4f(255, 255, 255, 255), 2, cc.c4f(255, 255, 255, 255))
    self.m_pClippingMenu = cc.ClippingNode:create(shap)
    self.m_pClippingMenu:addTo(self.m_rootUI)
    self.m_pImgMenuBg:removeFromParent()
    self.m_pImgMenuBg:addTo(self.m_pClippingMenu)
    self.m_pClippingMenu:setPosition(cc.p(0,0))
    -- 初始化按纽响应
    self:initBtnClickEvent()

    self.m_nSoundType = math.random(1,5)%2
    
    self.m_pNodeFreeTime:setVisible(false)
    self.m_pNodeIconMask:setVisible(false)
    self.m_pNodeResultIcon:setVisible(false)
    self.m_pNodeMask:removeFromParent()
    self.m_pNodeAnimTop:removeFromParent()
    self.m_rootUI:addChild(self.m_pNodeMask)
    self.m_rootUI:addChild(self.m_pNodeAnimTop)
    self.m_pNodeMask:setVisible(false)
    
    self.m_pLbBetNum:setString("")
    self.m_pLbLineNum:setString("")
    self.m_pLbBetNum:setVisible(true)
    self.m_pLbLineNum:setVisible(true)
    
    local strTemp = GlobalUserItem.tabAccountInfo.nickname--    Player:getInstance():getNameNick()      --玩家名字
    local strNickName = GameViewLayer.getDisplayNickNameInGame(strTemp, 10, 10)
    self.m_pLbNickName:setString(strNickName)
    
    local strUsrBanlance = GameViewLayer.getFormatGoldAndNumber(self.m_MoneySyncServer)
    print("Lb_usrGold________________________________1")
    self.m_pLbUsrGold:setString(strUsrBanlance)
    
    -- 初始化音乐音效开关
    local bEnable = GlobalUserItem.bSoundAble   --音效
    GlobalUserItem.setSoundAble(bEnable)
    self:updateButtonOfSound(bEnable)

    bEnable = GlobalUserItem.bVoiceAble
    GlobalUserItem.setVoiceAble(bEnable)    
    self:updateButtonOfMusic()

    --播放声音
--    AudioManager:getInstance():stopMusic()
    ExternalFun.playBackgroudAudio(Tiger_Res.vecMusic.MUSIC_OF_BGM)
end

function GameViewLayer:initBtnClickEvent()
    -- 系统下拉菜单按纽
    self.m_pBtnMenuPush:addClickEventListener(handler(self, self.onMenuClicked))
    self.m_pBtnMenuPop:addClickEventListener(handler(self, self.onMenuCancel))
    self.m_pBtnMenuPop:setVisible(false)
    self.m_pBtnMenuCancel:addClickEventListener(handler(self, self.onMenuCancel))
    self.m_pBtnMenuCancel:setVisible(false)
    self.m_pBtnExit:addClickEventListener(handler(self, self.onBtnExitClicked))
    self.m_pBtnEffect:addClickEventListener(handler(self, self.onEffectClicked))
    self.m_pBtnMusic:addClickEventListener(handler(self, self.onMusicClicked))
    self.m_pBtnHelp:addClickEventListener(handler(self, self.onRuleClicked))
    self.m_pBtnBank:addClickEventListener(handler(self, self.onBankClicked)) -- 银行
    self.m_pBtnAllLine:addClickEventListener(handler(self, self.onAllLineClicked)) -- 最大押注
    self.m_pBtnLineAdd:addTouchEventListener(handler(self, self.onLineAddTouched)) -- 线数
    self.m_pBtnLineReduce:addTouchEventListener(handler(self, self.onLineReduceTouched)) -- 线数
    self.m_pBtnBaseScore:addTouchEventListener(handler(self, self.onBetNumChangeTouched))  -- 底分
    self.m_pBtnGameStart:addTouchEventListener(handler(self, self.onStartTouched)) -- 开始
    -- 屏蔽点击按纽
    self.m_pBtnFreeMask:addClickEventListener(function() LOG_PRINT("---- FreeTime mask btn clicked-----")  end)
    self.m_pBtnFreeMask:setVisible(false)
end

--初始化事件
function GameViewLayer:initEvent()  
    self.event_ = --自定义事件：1.自定义；2.放到游戏内部；3.使用前缀；4.接收CMsgXX数据
    {
        ["gameExit"]                = { func = self.event_ExitGame,         log = "退出游戏",   debug = true, },
        ["updateUserScore"]         = { func = self.event_UpdateUserScore,  log = "玩家分数",   debug = true, },
        ["game_enter_background"]   = { func = self.event_EnterBackGroud,   log = "进入后台",      debug = true, },
        ["showShop"]                = { func = self.showChargeLayer,        log = "弹出充值", },

        [Tiger_Events.MSG_TIGER_GAME_START]         = { func = self.event_GameStart,     log = "游戏开始",   debug = true, },
        [Tiger_Events.MSG_TIGER_GAME_END]           = { func = self.event_GameEnd,       log = "游戏结束",   debug = true, },
        [Tiger_Events.MSG_TIGER_GAME_LIB_SCORE]     = { func = self.event_LibScore,      log = "彩金库",     debug = true, },
        [Tiger_Events.MSG_TIGER_GAME_ERROR]         = { func = self.event_Error,         log = "错误消息",   debug = true, },
  
    }

    local function onMsgUpdate_(event)  --接收自定义事件
        local name = event:getEventName()
        local msg = unpack(event._userdata)
        local processer = self.event_[name]
        LOG_PRINT("-- %s process: [%s] --", self.__cname, processer.log)
        processer.func(self, msg)
    end
    for key in pairs(self.event_) do   --监听事件
        SLFacade:addCustomEventListener(key, onMsgUpdate_, self.__cname)
    end

    --事件循环
    self.m_pLoopMsgHandler          = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.loopProcessMsg), 0.05 , false)
end

function GameViewLayer:cleanEvent() --清理事件监听
    for key in pairs(self.event_) do
        SLFacade:removeCustomEventListener(key, self.__cname)
    end
    self.event_ = {}

    if self.m_pLoopMsgHandler then
       cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_pLoopMsgHandler)
        self.m_pLoopMsgHandler = nil
    end
end

function GameViewLayer:initGame() -- 进入游戏初始化
    --保存
--    GameListManager.getInstance():setIsLoginGameSucFlag(true)

    self:addClipers()
    self:creatCliperNode()
    self:_initView()
    self:initEffectView()
    self:_initData()
    self:flyIn()

    --添加测试代码-------------------------------
    --self:testuse()
end

function GameViewLayer:flyIn()
    
    local deskAniTime  = 0.3
    local otherAniTime = 0.4
    local offset = 15

    local moveUpFun = function(node)
        local posx, posy = node:getPosition()
        node:setPositionY(posy - 400)

        local tableMove = cc.MoveTo:create(deskAniTime, cc.p(posx,posy))
        local tableScale = cc.ScaleTo:create(deskAniTime, 1)
        local tableSpawn = cc.Spawn:create(tableScale, tableMove)
        node:runAction(cc.Sequence:create(tableSpawn))
    end

    --下方进入
    moveUpFun(self.m_pSpMachine)
    moveUpFun(self.m_pNodeCenter)
    moveUpFun(self.m_pBtnNode)
    moveUpFun(self.m_pNodeLabel)
    moveUpFun(self.m_pNodeResultIcon)
    
    local moveDownFun = function(node)
        local posx, posy = node:getPosition()
        node:setPositionY(posy + 400)
        node:setOpacity(0)
        local topMove = cc.MoveTo:create(otherAniTime, cc.p(posx,posy - offset))
        local topMove2 = cc.MoveTo:create(0.2, cc.p(posx,posy))
        local spawn = cc.Spawn:create(cc.FadeIn:create(0.2), topMove)
        local seq = cc.Sequence:create(spawn, topMove2)
        node:runAction(seq)
    end

    --上部节点
    moveDownFun(self.m_pBtnExit)
    moveDownFun(self.m_pBtnMenuPush)
    moveDownFun(self.m_pBtnMenuPop)
    moveDownFun(self.m_pNodePrize)
end

function GameViewLayer:cleanGame() --清理游戏最后一步
    self:unscheduleLongPress_cb()
    --停止动作
    self.m_rootUI:stopAllActions()
    -- 清除所有动画
    self.m_pNodeEffect:removeAllChildren()
    self.m_pNodeAnimTop:removeAllChildren()
    --处理声音
    AudioManager:getInstance():stopAll()

    self:removeAllChildren()
    
--    --释放单例
--    TigerMainLayer.instance_ = nil
    
    if self.m_bEnterBackground then 
        return
    end
    --清理数据
    TigerDataMgr:getInstance():Clear()
    CUserManager:getInstance():clearUserInfo()
    -- 释放动画
    for i, strArmName in pairs(Tiger_Res.vecAnim) do
        local strJsonName = string.format("%s%s/%s.ExportJson", Tiger_Res.strAnimPath, strArmName, strArmName)
        local strPlistName = string.format("%s%s/%s0.plist", Tiger_Res.strAnimPath, strArmName, strArmName)
        local strPngName = string.format("%s%s/%s0.png", Tiger_Res.strAnimPath, strArmName, strArmName)
        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(strJsonName)
        display.removeSpriteFrames(strPlistName, strPngName)
    end
    -- 释放整图
    for i, name in pairs(Tiger_Res.vecPlist) do
        display.removeSpriteFrames(name[1], name[2])
    end
    -- 释放背景图
    for i, name in pairs(Tiger_Res.vecReleaseImg) do
        display.removeImage(name)
    end
    -- 释放音频
    for i, name in pairs(Tiger_Res.vecSound) do
        AudioManager.getInstance():unloadEffect(name)
    end
    -- 释放构建的帧图片
    cc.SpriteFrameCache:getInstance():removeSpriteFrameByName(Tiger_Res.TIGER_BTN_NORMAL)
    cc.SpriteFrameCache:getInstance():removeSpriteFrameByName(Tiger_Res.TIGER_BTN_PRESS)
    cc.SpriteFrameCache:getInstance():removeSpriteFrameByName(Tiger_Res.TIGER_BTN_DISABLE)


end

function GameViewLayer:addClipers()
    for i=1,TigerConst.ICON_COL do
        -- 绘制裁剪区域
        local shap = cc.DrawNode:create()
        local vecPoint = {cc.p(0,0), cc.p(ColWidth, 0), cc.p(ColWidth, ColHeight), cc.p(0, ColHeight)}
        shap:drawPolygon(vecPoint, 4, cc.c4f(255, 255, 255, 255), 2, cc.c4f(255, 255, 255, 255))
        self.m_vecCliper[i] = cc.ClippingNode:create(shap)
        self.m_vecCliper[i]:setAnchorPoint(cc.p(0,0))
        self.m_vecCliper[i]:setPosition(cc.p(LeftOffsetX + ((i-1)*ColWidth), 208))
        self.m_pNodeCenter:addChild(self.m_vecCliper[i],G_CONSTANTS.Z_ORDER_OVERRIDE)
        
        self.m_vecColNode[i] = cc.Node:create()
        self.m_vecColNode[i]:setAnchorPoint(cc.p(0,0))
        self.m_vecColNode[i]:setPosition(cc.p(0, NodeOffsetY))
        self.m_vecColNode[i]:setTag(i)
        self.m_vecCliper[i]:addChild(self.m_vecColNode[i])
    end

end

function GameViewLayer:creatCliperNode()
    -- 添加新的中奖的
    local gameResult = TigerDataMgr:getInstance():getGameResult()
    for i=0,TigerConst.ICON_ROW-1 do    --3
        for j=1,TigerConst.ICON_COL do  --5
            local iconIdex = gameResult.cbCardIndex[i*TigerConst.ICON_COL + j]
            local strIconFile = string.format(Tiger_Res.PNG_OF_FMT_ICON, iconIdex)
            local icon = cc.Sprite:createWithSpriteFrameName(strIconFile)
            icon:setAnchorPoint(cc.p(0.5,0))
            icon:setScale(IconScale)
            icon:setPosition(cc.p(ColWidth/2, (2-i)*ItemHeight))
            self.m_vecColNode[j]:addChild(icon)
        end
    end
end

--初始化图片
function GameViewLayer:_initView()
    --结算分数
    self.m_pLbResultScore = cc.Label:createWithBMFont(Tiger_Res.FONT_GOLDEN, "")
    self.m_pLbResultScore:setPosition(cc.p(655/0.8, 295/0.8))
    local node = cc.Node:create()
    node:setScale(0.8)
    node:setPosition(0, 0)
    node:setAnchorPoint(cc.p(0, 0))
    self.m_pLbResultScore:addTo(node)
    self.m_pNodeAnimTop:addChild(node, G_CONSTANTS.Z_ORDER_TOP)


    --奖池分数
    local strPool = GameViewLayer.getFormatGoldAndNumber(TigerDataMgr:getInstance():getPrizePool())
    self.m_pRollNumber:setInitNum(TigerDataMgr:getInstance():getPrizePool())
    self.m_pRollNumber:setVisible(true)

    --累计中奖
    self.m_pLbTotalBetGold:setString(self:getWinAwardNumStr())
end

--显示获胜线数动画
function GameViewLayer:initEffectView()
    --构建遮罩，利用滑动裁剪区域的方式来制造线条动画效果
    self.m_pAniShap = cc.DrawNode:create()
    local vecPoint = {cc.p(60, 180), cc.p(1250, 180), cc.p(1250, 660), cc.p(60, 660)}
    self.m_pAniShap:drawPolygon(vecPoint, 4, cc.c4f(255, 255, 255, 255), 2, cc.c4f(255, 255, 255, 255))
    self.m_pCliper = cc.ClippingNode:create(self.m_pAniShap)
    self.m_pCliper:setAnchorPoint(cc.p(0,0))
    self.m_pCliper:setPosition(cc.p(0, 0))
    self.m_pNodeEffect:addChild(self.m_pCliper, G_CONSTANTS.Z_ORDER_COMMON)

    --移动9条中奖线至剪切区域
    --移动连接图案至剪切区域
    for i = 1, TigerConst.LINE_COUNT do
        self.m_pLineNodes[i]:removeFromParent()
        self.m_pLineNodes[i]:addTo(self.m_pCliper)
        for j = 1, 2 do
            self.m_pLineHeader[j][i]:removeFromParent()
            self.m_pLineHeader[j][i]:addTo(self.m_pCliper)
        end
    end

    --init win effect
    self.m_pWinArmautre = ccs.Armature:create(Tiger_Res.vecAnim["YOU_WIN"])
    self.m_pWinArmautre:getAnimation():setSpeedScale(1.1)
    self.m_pWinArmautre:setPosition(cc.p(666,370))
    self.m_pNodeAnimTop:addChild(self.m_pWinArmautre, G_CONSTANTS.Z_ORDER_OVERRIDE)
    self.m_pWinArmautre:setVisible(false)

    self.m_pBigWinArmautre = ccs.Armature:create(Tiger_Res.vecAnim["BIG_WIN"])
    self.m_pBigWinArmautre:setPosition(cc.p(645,371.8))
    self.m_pNodeAnimTop:addChild(self.m_pBigWinArmautre, G_CONSTANTS.Z_ORDER_OVERRIDE)
    self.m_pBigWinArmautre:setVisible(false)
end

function GameViewLayer:_initData()
    --开始不显示线
    TigerDataMgr:getInstance():setIsShowLine(false)

        --如果有未完的免费次数
    if TigerDataMgr:getInstance():getFreeTimes() > 0  then 
        self:continueFreeTimes()
        self:_updateData()
        --fix 防止先收到开始游戏消息，后进入界面 不转动bug
        if TigerDataMgr:getInstance():getTigerState() == TigerConst.GAME_TIGER_PLAY then 
            self:event_GameStart()
        end
        return
    end

    --设置线数
    local lastLineNum =  TigerDataMgr:getInstance():getLastLineNum()
    if lastLineNum ~= 0 then
        TigerDataMgr:getInstance():setLineNum(lastLineNum)
    else
         --设置为可下注最大线数
        for i=TigerConst.MAX_LINE_NUM, 1, -1 do
            if self.m_MoneySyncServer >= TigerDataMgr:getInstance():getMinBetNum()*i then
                TigerDataMgr:getInstance():setLineNum(i)
                break
            end
        end
    end
    --设置底分
    local lastBet =  TigerDataMgr:getInstance():getLastBetNumIndex()
    if lastBet ~= 0 then 
        TigerDataMgr:getInstance():setBetNumIndex(lastBet)
    end

    --更新线数和倍数
    self:_updateData()
end
---------------------------- init ---------------------------------------------

----------------------------------- on msg event ------------------------------
function GameViewLayer:event_ExitGame(msg)--退出游戏
    if msg == 1 then self.m_bIsKill = true end
    self.m_bEnterBackground = false
    self.m_bExit = true
    self:onSendStandUpAndExit()
end


function GameViewLayer:event_EnterBackGroud()

    self.m_pLbTotalBetGold:setString(self:getWinAwardNumStr())
    self.m_bEnterBackground = true
end

function GameViewLayer:event_UpdateUserScore(msg)--更新玩家分数
    -- 游戏过程中不更新金币，等游戏结算后更新金币
    if TigerConst.GAME_TIGER_PLAY ~= TigerDataMgr:getInstance():getTigerState() then
        local strGold = GameViewLayer.getFormatGoldAndNumber(self.m_MoneySyncServer)
        print("Lb_usrGold________________________________2")
        self.m_pLbUsrGold:setString(strGold)
    end
end

function GameViewLayer:event_GameStart(msg)--游戏开始
    if TigerDataMgr:getInstance():getFreeTimes() <= 0 then
        local nLineNum = TigerDataMgr:getInstance():getLineNum()
        local nBetMoney = TigerDataMgr:getInstance():getMinBetNum() * TigerDataMgr:getInstance():getBetNumIndex()
        local nCurrentBetMoney = nLineNum * nBetMoney
        
		--修复:使用临时金币显示-------------------------------
        local nScoreOld = TigerDataMgr:getInstance():getGameResultLast().llResultMoney
        if self.session_id == 1 then
            nScoreOld = self.m_MoneySyncServer
        end
        local nScoreNew = nScoreOld - nCurrentBetMoney
        local strScore = GameViewLayer.getFormatGoldAndNumber(nScoreNew)
--        PlayerInfo.getInstance():setTempUserScore(nScoreNew)
        self.m_MoneyYazhuHou = nScoreNew
        ------------------------------------------------------
        self.m_pLbUsrGold:stopAllActions()
        print("Lb_usrGold________________________________3")
        self.m_pLbUsrGold:setString(strScore)
    else
        local nScoreOld = TigerDataMgr:getInstance():getGameResultLast().llResultMoney
        print("当前分数："..nScoreOld)
--        PlayerInfo.getInstance():setTempUserScore(nScoreOld)
        self.m_MoneyYazhuHou = nScoreOld
    end

    self.m_pBtnBaseScore:setEnabled(false)
    self.m_pBtnAllLine:setEnabled(false)
    self.m_pBtnLineAdd:setEnabled(false)
    self.m_pBtnLineReduce:setEnabled(false)
    self.m_pLbLineNum:setEnabled(false)
    self:setLineEnable(false)

    if self.m_pNodeFreeTime:isVisible() then
        local count = TigerDataMgr:getInstance():getFreeTimes()
        self.m_pLbSpePrize:setString(string.format("%d", count))
        if count <= 0 then
            self:_closeSpecialPrize()
        end
    end
    if self.m_pLbResultScore then 
        self.m_pLbResultScore:stopAllActions()
        self.m_pLbResultScore:setVisible(false)
    end
    self:cleanResultIcon()

    self.m_nCurentWinCount = 0
    self.m_bWinChangeScore = false
    self.m_bSendGameStart = false
    self.m_bSendGameStop = false
    self.m_eGameState = TigerConst.eGameState.State_Turn
    self:_updateShowSprite()
end
function GameViewLayer:event_Update(msg)--更新数据
    self:_updateData()
end

function GameViewLayer:event_GameEnd(msg)--游戏结束
    self.m_bSendGameStop = false
    self.m_bSendGameStart = false
    local nFreeTimes = TigerDataMgr:getInstance():getFreeTimes()
    if (nFreeTimes <= 0) then
        self:_closeSpecialPrize()
    end

    local bIsAuto = TigerDataMgr:getInstance():getIsAuto()
    if bIsAuto and nFreeTimes <= 0 then
        self:setBtnStartGameEnable(true)
        self.m_pBtnBaseScore:setEnabled(false)
        self.m_pBtnAllLine:setEnabled(false)
        self.m_pBtnLineAdd:setEnabled(false)
        self.m_pBtnLineReduce:setEnabled(false)
        self.m_pLbLineNum:setEnabled(false)
        self:setLineEnable(false)
        
        local nCurrentBetMoney = TigerDataMgr:getInstance():getMinBetNum() * TigerDataMgr:getInstance():getBetNumIndex()
        if nCurrentBetMoney <= 0 then
            self:showFloatmessage("TIGER_3")
            self:cancelAutoStart()
            return
        end
        self:_startGame()
    elseif nFreeTimes > 0 then
        self:setBtnStartGameEnable(false)
        self.m_pBtnBaseScore:setEnabled(false)
        self.m_pBtnAllLine:setEnabled(false)
        self.m_pBtnLineAdd:setEnabled(false)
        self.m_pBtnLineReduce:setEnabled(false)
        self.m_pLbLineNum:setEnabled(false)
        self:setLineEnable(false)
    else
        self:setBtnStartGameEnable(true)
        self.m_pBtnBaseScore:setEnabled(true)
        self.m_pBtnAllLine:setEnabled(true)
        self.m_pBtnLineAdd:setEnabled(true)
        self.m_pBtnLineReduce:setEnabled(true)
        self:setLineEnable(true)
    end
end

function GameViewLayer:event_LibScore(msg)--彩金库
    local strPool = GameViewLayer.getFormatGoldAndNumber(TigerDataMgr:getInstance():getPrizePool())

    self.m_pRollNumber:rollToNum(TigerDataMgr:getInstance():getPrizePool())
end
function GameViewLayer:event_Error(msg)--错误消息
    TigerDataMgr:getInstance():setIsAuto(false)
    TigerDataMgr:getInstance():setTigerState(TigerConst.GAME_TIGER_FREE)
    
    self:cancelAutoStart()
    self:setBtnStartGameEnable(true)
    --self.m_pBtnLineNum:setEnabled(true)
    self.m_pBtnBaseScore:setEnabled(true)
    self.m_pBtnAllLine:setEnabled(true)
    self.m_pBtnLineAdd:setEnabled(true)
    self.m_pBtnLineReduce:setEnabled(true)
    self:setLineEnable(true)
end
function GameViewLayer:event_ShowPlayer(msg) -- 展示其他玩家
--    local curOtherUser = TigerDataMgr:getInstance():getGameOtherPlayers()

--    for i=1,4 do
--        if curOtherUser.wChairID[i] >=0 and curOtherUser.wChairID[i] < 100 then
--            self.m_pOtherUserIcon[i]:setVisible(true)
--            self.m_pOtherUserGold[i]:setVisible(true)
--            self.m_pOtherUserName[i]:setVisible(true)
--            self.m_pOtherUserGoldBg[i]:setVisible(true)
--            self.m_nOtherUserGoldNum[i] = CUserManager:getInstance():getUserGoldByChairID(curOtherUser.wChairID[i])

--            self:setOtherUserInfoByIndex(i)
--        else
--            self.m_pOtherUserIcon[i]:setVisible(false)
--            self.m_pOtherUserGold[i]:setVisible(false)
--            self.m_pOtherUserName[i]:setVisible(false)
--            self.m_pOtherUserGoldBg[i]:setVisible(false)
--            self.m_nOtherUserGoldNum[i] = 0
--        end
--    end
end
function GameViewLayer:event_UpdateOther(msg)--其他玩家金币更新
--    local iUpdateUserId = CUserManager:getInstance():getUserIDScore()
--    local curOtherUser = TigerDataMgr:getInstance():getGameOtherPlayers()

--    for i=1,4 do
--        if not (curOtherUser.wChairID[i] < 0 or curOtherUser.wChairID[i] >=100) then
--            local iOtherUserId = CUserManager:getInstance():getUserIdByChairID(curOtherUser.wChairID[i])
--            if(iUpdateUserId == iOtherUserId) then
--                local iCurGoldNum = CUserManager:getInstance():getUserGoldByChairID(curOtherUser.wChairID[i])
--                self.m_nOtherUserGoldNum[i] = iCurGoldNum
--                self.m_pOtherUserGold[i]:setString(self:getOtherUserGoldNumStr(iCurGoldNum))
--            end
--        end
--    end
end

function GameViewLayer:onUpdateOtherUsersGoldByGR(msg) -- 其他玩家金币变化 广播
--    local nUpdateUserId = CUserManager:getInstance():getUserIDScoreGR()
--    local curOtherUser = TigerDataMgr:getInstance():getGameOtherPlayers()

--    for i=1,4 do
--        if not (curOtherUser.wChairID[i] < 0 or curOtherUser.wChairID[i] >= 100) then
--            local nOtherUserId = CUserManager:getInstance():getUserIdByChairID(curOtherUser.wChairID[i])
--            if(nUpdateUserId == nOtherUserId) then
--                local iCurGoldNum = CUserManager:getInstance():getUserGoldByChairID(curOtherUser.wChairID[i])
--                local offsetVal = iCurGoldNum - self.m_nOtherUserGoldNum[i]

--                if (offsetVal > 0 and nUpdateUserId ~= Player:getInstance():getUserID()) then
--                    local pos = self.m_pOtherUserNode[i]:getPosition()
--                    self:flyNumOfGoldChange(nSubSocre, pos, self.m_pNodeAnimTop)
--                end

--                self.m_pOtherUserGold[i]:setString(self:getOtherUserGoldNumStr(iCurGoldNum))
--            end
--        end
--    end
end



----------------------------------- on msg event end ------------------------------

----------------------------------- update view start -------------------------------
function GameViewLayer:loopProcessMsg(dt)
    self:updateLabelBMResult()
end

function GameViewLayer:refreshIcon()
    local nICON_COL = TigerConst.ICON_COL
    local nICON_ROW = TigerConst.ICON_ROW
    --先清除原来的结果
    for i=1,nICON_COL do
        self.m_vecColNode[i]:removeAllChildren()
    end
    self.m_vecCurrentIcon = {}

    --添加上一轮的开奖图标的图标
    local gameResultLast = TigerDataMgr:getInstance():getGameResultLast()
    for i=0, nICON_ROW-1 do
        for j=1, nICON_COL do
            local iconIndex = (gameResultLast.cbCardIndex[i*nICON_COL + j] > 0 and gameResultLast.cbCardIndex[i*nICON_COL + j] or math.random(1,15)%14+1)
            local strIconFile = string.format(Tiger_Res.PNG_OF_FMT_ICON, iconIndex)
            local icon = cc.Sprite:createWithSpriteFrameName(strIconFile)
            icon:setAnchorPoint(cc.p(0.5,0))
            icon:setScale(IconScale)
            icon:setPosition(cc.p(ColWidth/2, (2-i)*ItemHeight))
            self.m_vecColNode[j]:addChild(icon)
        end
    end
    
    --添加中间的图标
    for i=nICON_ROW, TigerConst.MAX_LINE_ICON_NUM-2 do
        for j=1, nICON_COL do
            local strIconFile = string.format(Tiger_Res.PNG_OF_FMT_MIX_ICON, math.random(1,15)%14+1)
            local icon = cc.Sprite:createWithSpriteFrameName(strIconFile)
            icon:setAnchorPoint(cc.p(0.5,0))
            icon:setScale(IconScale)
            icon:setPosition(cc.p(ColWidth/2, i*ItemHeight-20))
            self.m_vecColNode[j]:addChild(icon)
        end
    end

    --添加新的中奖的
    local gameResult = TigerDataMgr:getInstance():getGameResult()
    for i=0, nICON_ROW-1 do
        for j=1, nICON_COL do
            local iconIdex = gameResult.cbCardIndex[i*nICON_COL + j]
            local strIconFile = string.format(Tiger_Res.PNG_OF_FMT_ICON, iconIdex)
            local icon = cc.Sprite:createWithSpriteFrameName(strIconFile)
            icon:setAnchorPoint(cc.p(0.5,0))
            icon:setScale(IconScale)
            icon:setPosition(cc.p(ColWidth/2, (3-i+TigerConst.MAX_LINE_ICON_NUM-2)*ItemHeight))
            self.m_vecColNode[j]:addChild(icon)
            icon:setTag(iconIdex)
            table.insert(self.m_vecCurrentIcon,icon)
        end
    end
end

function GameViewLayer:setOtherUserInfoByIndex(nIndex)
--    local curOtherUser = TigerDataMgr:getInstance():getGameOtherPlayers()
--    local iOtherUserId = CUserManager:getInstance():getUserIdByChairID(curOtherUser.wChairID[nIndex])
--    local strNickName = ""
--    local nFaceID = 0
--    local llScore = 0
--    if(iOtherUserId == Player:getInstance():getUserID()) then
--        strNickName = Player:getInstance():getNameNick()
--        nFaceID = Player:getInstance():getFaceID()
--        llScore = self.m_MoneySyncServer
--    else
--        local otherInfo = CUserManager:getInstance():getUserInfoByUserID(iOtherUserId)
--        strNickName = otherInfo.szNickName
--        nFaceID = otherInfo.wFaceID
--        llScore = otherInfo.lScore
--    end
--    local strNick = LuaUtils.getDisplayNickName2(strNickName,self.m_pOtherUserName[nIndex]:getContentSize().width,"Helvetica",16,"...")
--    self.m_pOtherUserName[nIndex]:setString(strNick)

--    local strHeadIcon = string.format(Tiger_Res.PNG_OF_HEAD, nFaceID % G_CONSTANTS.FACE_NUM + 1)
--    local pTexture = cc.Director:getInstance():getTextureCache():addImage(strHeadIcon)
--    self.m_pOtherUserIcon[nIndex]:setTexture(pTexture)
--    self.m_pOtherUserGold[nIndex]:setString(self:getOtherUserGoldNumStr(llScore))
end

function GameViewLayer:_showLineByIdx(nLineIdx)
    assert(nLineIdx<=9 and nLineIdx >= 1, "Invalid nLineIdx for LineSprite!")
    if (nLineIdx < 1 or  nLineIdx > 9) then
        LOG_PRINT("Invalid nLineIdx for LineSprite!")
        return
    end

    for i=1,nLineIdx do

        if (not self.m_pLineNodes[i]:isVisible()) then
            self.m_pLineNodes[i]:setVisible(true)
        end
    end
    
    for i=nLineIdx + 1, TigerConst.MAX_LINE_NUM do

        if (self.m_pLineNodes[i]:isVisible()) then
            self.m_pLineNodes[i]:setVisible(false)
        end
    end
    
    for i=1,nLineIdx do
        local strFilePath = string.format(Tiger_Res.FMT_NUM_LIGHT_IMG, i)
        local strNumName = string.format(Tiger_Res.FMT_NODE_NUM_IMG, i)
        local spLineLeft = self.m_pNodeCenter:getChildByName(strNumName)
        if spLineLeft then
            spLineLeft:setSpriteFrame(strFilePath)
        end
        strNumName = string.format(Tiger_Res.FMT_NODE_NUM_IMG, 9 + i)
        local spLineRight = self.m_pNodeCenter:getChildByName(strNumName)
        if spLineRight then
            spLineRight:setSpriteFrame(strFilePath)
        end
    end
    
    for i=nLineIdx+1,TigerConst.MAX_LINE_NUM do
        local strFilePath = string.format(Tiger_Res.FMT_NUM_GRAY_IMG, i)
        local strNumName = string.format(Tiger_Res.FMT_NODE_NUM_IMG, i)
        local spLineLeft = self.m_pNodeCenter:getChildByName(strNumName)
        if spLineLeft then
            spLineLeft:setSpriteFrame(strFilePath)
        end
        strNumName = string.format(Tiger_Res.FMT_NODE_NUM_IMG, 9 + i)
        local spLineRight = self.m_pNodeCenter:getChildByName(strNumName)
        if spLineRight then
            spLineRight:setSpriteFrame(strFilePath)
        end
    end
end

function GameViewLayer:_downLine(nLineIdx)
    TigerDataMgr:getInstance():setIsShowLine(true)
    TigerDataMgr:getInstance():setLineNum(nLineIdx)
    TigerDataMgr:getInstance():setLastLineNum(nLineIdx)
end

function GameViewLayer:_changeJetton()
    local betIndex  = TigerDataMgr:getInstance():getBetNumIndex() >= TigerConst.MAX_MULTIPLE and 1 or TigerDataMgr:getInstance():getBetNumIndex() +1
    TigerDataMgr:getInstance():setBetNumIndex(betIndex)
    TigerDataMgr:getInstance():setLastBetNumIndex(betIndex)
    self:_updateData()
end

function GameViewLayer:_startGame()
    local nLineNum = TigerDataMgr:getInstance():getLineNum()
    local nBetMoney = TigerDataMgr:getInstance():getMinBetNum() * TigerDataMgr:getInstance():getBetNumIndex()
    local nCurrentBetMoney = nLineNum * nBetMoney
    if (self.m_MoneySyncServer >= nCurrentBetMoney) then
        self:doSendGameStart()
    else
        nCurrentBetMoney = TigerDataMgr:getInstance():getMinBetNum() * TigerDataMgr:getInstance():getBetNumIndex()
        if (not self.m_pBtnBaseScore:isEnabled()) then self.m_pBtnBaseScore:setEnabled(true) end
        if (not self.m_pBtnAllLine:isEnabled()) then self.m_pBtnAllLine:setEnabled(true) end
        if (not self.m_pBtnGameStart:isEnabled()) then self:setBtnStartGameEnable(true) end
        if (not self.m_pBtnLineAdd:isEnabled()) then self.m_pBtnLineAdd:setEnabled(true) end
        if (not self.m_pBtnLineReduce:isEnabled()) then self.m_pBtnLineReduce:setEnabled(true) end
        self:setLineEnable(true)
        -- 停止自动开始状态
        self:cancelAutoStart()

        FloatMessage:getInstance():pushMessage("游戏币不足")

    end
end

function GameViewLayer:_stopGame()
    --累计押中
    self.m_pLbTotalBetGold:setString(self:getWinAwardNumStr())
    self.m_bSendGameStop = true
    self.m_eGameState = TigerConst.eGameState.State_Wait
    self:doSendGameStop()
    self:playCommodSound()
end

function GameViewLayer:_updateData()
    local nLineNum = TigerDataMgr:getInstance():getLineNum()
    local nBetMoney = TigerDataMgr:getInstance():getMinBetNum() * TigerDataMgr:getInstance():getBetNumIndex()
    
    local nCurrentBetMoney = nLineNum * nBetMoney
    
    local str = string.format("%d", nLineNum)
    self.m_pLbLineNum:setString(str)
    self.m_pLbBetNum:setString(GameViewLayer.getFormatGoldAndNumber(nBetMoney))

    --使用绘制方式构建三态图片,这样使得底分显示可以跟随按钮移动
    local texturename = self:getNormalFrame(GameViewLayer.getFormatGoldAndNumber(nBetMoney))
    self.m_pBtnBaseScore:loadTextureNormal(texturename, ccui.TextureResType.plistType)

    local texturename2 = self:getPressFrame(GameViewLayer.getFormatGoldAndNumber(nBetMoney))
    self.m_pBtnBaseScore:loadTexturePressed(texturename2, ccui.TextureResType.plistType)

    local texturename3 = self:getDisableFrame(GameViewLayer.getFormatGoldAndNumber(nBetMoney))
    self.m_pBtnBaseScore:loadTextureDisabled(texturename3, ccui.TextureResType.plistType)
    

    self.m_pLbBetNum:setVisible(false)

    self.m_pLbCurTotalBetNum:setString(GameViewLayer.getFormatGoldAndNumber(nCurrentBetMoney))
    if TigerDataMgr:getInstance():getIsShowLine() then
        self:cleanLineEffect()
        self:_showLineByIdx(nLineNum)
    end
    TigerDataMgr:getInstance():setIsShowLine(false)
end

function GameViewLayer:_updateShowSprite()
    self:cleanWinIconEffect()
    self:cleanLineEffect()
    self:refreshIcon()
    self:playEffect()
end

function GameViewLayer:_showSpecialPrize()
    self:setBtnStartGameEnable(false)

    self.m_pRollNumber:setVisible(false)
    self.m_pLbSpePrize:setString(string.format("%d", TigerDataMgr:getInstance():getFreeTimes()))
    self.m_pNodeFreeTime:setPosition(cc.p(0, 80))
    self.m_pNodeFreeTime:setVisible(true)
    
    local mv1 = cc.MoveTo:create(0.5, cc.p(0,0))
    self.m_pNodeFreeTime:runAction(cc.EaseElasticInOut:create(mv1))
end

function GameViewLayer:_closeSpecialPrize()

    local mv1 = cc.MoveTo:create(0.5, cc.p(0,80))
    local call1 = cc.CallFunc:create(function()
        self.m_pNodeFreeTime:setVisible(false)

        self.m_pRollNumber:setVisible(true)
    end)
    local seq1 = cc.Sequence:create(cc.EaseElasticInOut:create(mv1), call1)
    self.m_pNodeFreeTime:runAction(seq1)
end

function GameViewLayer:setBankBtByPlayerState(bCurState)

end
----------------------------------- update view end-------------------------------

----------------------------------- play animation start ----------------------------
function GameViewLayer:playEffect() -- 游戏开始，转盘动画
    local actionDelay = {}
    local actionCallBack = {}
    for i=1,TigerConst.ICON_COL do
        self.m_vecColNode[i]:stopAllActions()
        self.m_vecColNode[i]:setPosition(0.0, NodeOffsetY)
        local moveAct1 = cc.MoveTo:create(TigerConst.vecSectionTimeFirst[i], cc.p(0, -400))
        local easeExpon  = cc.EaseExponentialIn:create(moveAct1)
        local moveAct2 = cc.MoveTo:create(TigerConst.vecSectionTimeSecond[i], cc.p(0, -ItemHeight*(TigerConst.MAX_LINE_ICON_NUM-3)+BoundOffsetY))
        local moveAct3 = cc.MoveTo:create(TigerConst.vecSectionTimeEnd[i], cc.p(0, -ItemHeight*(TigerConst.MAX_LINE_ICON_NUM-3)-2*ItemHeight + NodeOffsetY))
        local easeAct = cc.EaseBackOut:create(moveAct3)
        if TigerConst.ICON_COL == i then
            local callback = cc.CallFunc:create(function()
                    self:showResultEffect()
                end)
            local seq = cc.Sequence:create(easeExpon, moveAct2, easeAct, callback)
            self.m_vecColNode[i]:runAction(seq)
        elseif i == 1 then
            local callback = cc.CallFunc:create(function()
                self.m_eGameState = TigerConst.eGameState.State_Nothing
            end)
            local seq = cc.Sequence:create(easeExpon, moveAct2, callback, easeAct)
            self.m_vecColNode[i]:runAction(seq)
        else
            local seq = cc.Sequence:create(easeExpon, moveAct2, easeAct)
            self.m_vecColNode[i]:runAction(seq)
        end
        --结束音效播放
        local delayTime = {1.6, 0.3, 0.3, 0.3, 0.3}
        local callback = cc.CallFunc:create(function()
            ExternalFun.playSoundEffect(Tiger_Res.vecSound.SOUND_OF_ROLL_END)
        end)
        local delay = cc.DelayTime:create(delayTime[i])
        table.insert(actionDelay,delay )
        table.insert(actionCallBack,callback)
    end
    local seq = cc.Sequence:create(actionDelay[1],actionCallBack[1],actionDelay[2],actionCallBack[2],actionDelay[3],actionCallBack[3],
    actionDelay[4],actionCallBack[4],actionDelay[5],actionCallBack[5])
    self.m_pNodeAnimTop:runAction(seq)

    self.m_nRollStartSoundId = ExternalFun.playSoundEffect(Tiger_Res.vecSound.SOUND_OF_GAME_START)
end

function GameViewLayer:instantPlayResultEffect()

    self.m_eGameState = TigerConst.eGameState.State_Nothing
    for i=1,TigerConst.ICON_COL do 
        self.m_vecColNode[i]:stopAllActions()
        self.m_vecColNode[i]:setPosition(cc.p(0, -ItemHeight*(TigerConst.MAX_LINE_ICON_NUM-3)+BoundOffsetY))
        local moveAct3 = cc.MoveTo:create(TigerConst.vecSectionTimeEnd[i], cc.p(0, -ItemHeight*(TigerConst.MAX_LINE_ICON_NUM-3)- 2*ItemHeight + NodeOffsetY))
        local easeAct = cc.EaseBackOut:create(moveAct3)
        if TigerConst.ICON_COL == i then
            local callback = cc.CallFunc:create(function()
                    ExternalFun.playSoundEffect(Tiger_Res.vecSound.SOUND_OF_ROLL_END)
                    self:showResultEffect()
                end)
            local seq = cc.Sequence:create(easeAct, callback)
            self.m_vecColNode[i]:runAction(seq)
        else
            self.m_vecColNode[i]:runAction(easeAct)
        end
    end
    self.m_pNodeAnimTop:stopAllActions()

end

function GameViewLayer:continueFreeTimes()

    self.m_eGameState = TigerConst.eGameState.State_SpecialWin
    self:setBtnAnimMaskEnable(true)
    self:_showSpecialPrize()
    local strName = Tiger_Res.vecAnim.GAMEOVER_SPICAIL
    local armature = Effect:getInstance():creatEffectWithDelegate2(self.m_pNodeAnimTop, strName, "Animation1", true, cc.p(667,375))
    if armature ~= nil then
        -- 回调
        local animationEvent = function(armatureBack, movementType, movementID)
            if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
                armatureBack:removeFromParent()
                self:setBtnAnimMaskEnable(false)
            end
        end
        armature:getAnimation():setMovementEventCallFunc(animationEvent)
    end
end

function GameViewLayer:showResultEffect()----------------------------------
--    AudioManager.getInstance():stopSound(self.m_nRollStartSoundId)

    local gameResult = TigerDataMgr:getInstance():getGameResult()
    print("转动结束  分数：".. gameResult.llResult.. "    免费次数："..TigerDataMgr:getInstance():getFreeTimes())

    if (gameResult.llResult > 0 or TigerDataMgr:getInstance():getFreeTimes() > 0) then
        self.m_nBetLineNum = TigerDataMgr:getInstance():getLineNum()

        --修复:使用临时金币设置玩家金币-------------------------------
        local nScoreOld = self.m_MoneyYazhuHou      --Player:getInstance():getTempUserScore()
        local nScoreNew = gameResult.llResultMoney    --nScoreOld + gameResult.llResult

--        Player:getInstance().m_lUserScore = nScoreNew
        --------------------------------------------------------------
        local vecWinSpecial = {}
        local vecWinSpecialCount = {}
        for i=1, self.m_nBetLineNum do
            local nCount = TigerDataMgr:getInstance():GetLineTypeCount(i-1)
            local nDim = TigerDataMgr:getInstance():GetDiamondCount(i-1)
            local tType = TigerDataMgr:getInstance():GetLineType(i-1)
            if tType == TigerConst.eResultType.Type_Diamond then 
                print("个数："..nCount.. "    钻石个数："..nDim)
            end
            ----------需要改---------------
            if (nCount >= 3 or  nDim >= 3  or  (tType == TigerConst.eResultType.Type_BAR and nCount >= 3)) then
                --线
                print(tType.."__个数："..nCount.. "    钻石个数："..nDim)
                self:showResultLineEffect(i)
                if(tType == TigerConst.eResultType.Type_Diamond) then -- 钻石优先显示
                    table.insert(vecWinSpecial, 1, tType)
                    table.insert(vecWinSpecialCount, 1, nDim)
                    
                elseif (tType == TigerConst.eResultType.Type_Gold or tType == TigerConst.eResultType.Type_777) then
                    vecWinSpecial[#vecWinSpecial + 1] = tType
                    vecWinSpecialCount[#vecWinSpecialCount + 1] = nCount
                end
            end
        end
        
        if gameResult.llResult > 0 then
            self:blinkThunder()
            self:showLineViewEffect(self.m_aniSpeed)
        end

        if( #vecWinSpecial > 0) then --特殊奖励----------------------------
            --FloatMessage.getInstance():pushMessageDebug("特殊奖励")
            self.m_eGameState = TigerConst.eGameState.State_SpecialWin
            self:showWinIconEffect()
            self:showSpecialWinEffect(vecWinSpecial[1],vecWinSpecialCount[1])

        elseif(gameResult.llResult > 0) then --普通中奖
            local betBaseScore = TigerDataMgr:getInstance():getMinBetNum()*TigerDataMgr:getInstance():getBetNumIndex()
            local currentMub = gameResult.llResult/betBaseScore
            if currentMub >= TigerConst.BIG_WIN_MULTIPLE then
                self.m_eGameState = TigerConst.eGameState.State_BigWin
            else
                self.m_eGameState = TigerConst.eGameState.State_NormalWin
            end 
            self:showWinIconEffect()
            local callback = cc.CallFunc:create(function()
                self:showYouWinEffect()
                self:showLabelBMResult(true)
            end)
            local callback2 = cc.CallFunc:create(function()
                self:showResultIcon(true)
            end)
            local seq = cc.Sequence:create(cc.DelayTime:create(0.7), callback, cc.DelayTime:create(0.2), callback2)
            self.m_pNodeAnimTop:runAction(seq)
        else
            self:_stopGame()
        end
    else
        self:_stopGame()
    end
end

function GameViewLayer:instantPlayWinEffect()
    self.m_pNodeAnimTop:stopAllActions()
    if self.m_pWinArmautre then 
        self.m_pWinArmautre:getAnimation():gotoAndPause(0)
        self.m_pWinArmautre:setVisible(false)
    end 

    if self.m_pBigWinArmautre then 
        self.m_pBigWinArmautre:getAnimation():gotoAndPause(0)
        self.m_pBigWinArmautre:setVisible(false)
    end 

    self:showLabelBMResult(false)
    self:showResultIcon(false)
    self:showGoldChangeAndFly(false)
    self:_stopGame()
end

function GameViewLayer:showResultLineEffect(nIndex)
    if (nIndex < 1 or  nIndex > 9 or self.m_pLineNodes[nIndex] == nil) then return end
    
    ExternalFun.playSoundEffect(Tiger_Res.vecSound.SOUND_OF_WIN_LINE)
    self.m_pLineNodes[nIndex]:setVisible(true)
    self.m_pLineHeader[1][nIndex]:setVisible(true)
    self.m_pLineHeader[2][nIndex]:setVisible(true)
end

--中奖图标
function GameViewLayer:showWinIconEffect()
    self.m_pNodeIconMask:setVisible(true)
    local vecCardIndex = {}
    for i=1,TigerConst.CARD_INDEX do
        vecCardIndex[i] = 0
    end
    local gameResult = TigerDataMgr:getInstance():getGameResult()
    vecCardIndex = TigerDataMgr:getInstance():GetCardFlash(vecCardIndex) -- 判断牌子是否中奖
    --已中奖icon隐藏
    for i=1, #self.m_vecCurrentIcon do 
        if vecCardIndex[i] ~= 0 then
            self.m_vecCurrentIcon[i]:setVisible(false)
        end
    end
    --显示icon中奖效果

    local offsetPos = { -- 动画位置微调
        cc.p(-6, 0),    --荔枝
        cc.p(10, 0),    --橘子
        cc.p(0, 0),    --芒果
        cc.p(0, 0),    --西瓜
        cc.p(-10, 0),    --苹果
        cc.p(0, 0),    --樱桃
        cc.p(0, 13),    --葡萄
        cc.p(0, 0),    --铃铛
        cc.p(-5, 3),    --香蕉
        cc.p(-10, 0),    --菠萝
        cc.p(0, -5),    --BAR
        cc.p(0, 0),    --钻石
        cc.p(0, 0),    --宝箱
        cc.p(0, 0),    --777
    }
    for i=1,TigerConst.CARD_INDEX do
        if vecCardIndex[i] ~= 0 then
            local nIndex = gameResult.cbCardIndex[i]
            local pos = cc.p(LeftOffsetX + ColWidth/2 + (i-1)%5*ColWidth + offsetPos[nIndex].x, ColHeight + ItemHeight/2 - math.floor((i-1)/5)*ItemHeight + offsetPos[nIndex].y)
            local path = Tiger_Res.strAnimPath.."fruit/"
            local pathJson = path..Tiger_Res.vecFruitAnim[nIndex][1]
            local pathAtlas = path..Tiger_Res.vecFruitAnim[nIndex][2]
            self.m_pWinIconArmature[i] = sp.SkeletonAnimation:create(pathJson, pathAtlas)
            self.m_pWinIconArmature[i]:setPosition(pos)
            self.m_pWinIconArmature[i]:setScale(IconScale)
            self.m_pNodeEffect:addChild(self.m_pWinIconArmature[i], G_CONSTANTS.Z_ORDER_STATIC)
            self.m_pWinIconArmature[i]:setAnimation(0, "animation", true)
        end
    end
end

--获奖特效
function GameViewLayer:showYouWinEffect() -- 显示结算框
    ExternalFun.playSoundEffect(Tiger_Res.vecSound.SOUND_OF_WIN_GAME)
    ExternalFun.playSoundEffect(Tiger_Res.vecSound.SOUND_OF_GET_GOLD) -- 播放获得金币音效
    --self:setBtnAnimMaskEnable(true)
    local gameResult = TigerDataMgr:getInstance():getGameResult()
    if (gameResult.llResult <= 0) then return end

    local betBaseScore = TigerDataMgr:getInstance():getMinBetNum()*TigerDataMgr:getInstance():getBetNumIndex()
    local currentMub = gameResult.llResult/betBaseScore
    local bSendEnd = false
    if currentMub >= TigerConst.BIG_WIN_MULTIPLE then  --大于100倍显示大奖效果
        self.m_pBigWinArmautre:setVisible(true)
        self.m_pBigWinArmautre:getAnimation():play("Animation1")
        if (self.m_pBigWinArmautre ~= nil) then
            -- 回调
            local animationEvent = function(armatureBack, movementType, movementID)
                if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
                    armatureBack:setVisible(false)
                    armatureBack:getAnimation():gotoAndPause(0)
                    if not self.m_bSendGameStop then 
                        self:showGoldChangeAndFly(true)
                        if not bSendEnd then
                            self:_stopGame()
                        end 
                    end
                end
            end
            self.m_pBigWinArmautre:getAnimation():setMovementEventCallFunc(animationEvent)
        end
    else
        self.m_pWinArmautre:setVisible(true)
        self.m_pWinArmautre:getAnimation():play("Animation1")
        if (self.m_pWinArmautre ~= nil) then
            -- 回调
            local animationEvent = function(armatureBack, movementType, movementID)
                if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
                    armatureBack:setVisible(false)
                    armatureBack:getAnimation():gotoAndPause(0)
                    if not self.m_bSendGameStop then 
                        self:showGoldChangeAndFly(true)
                        if not bSendEnd then
                            self:_stopGame()
                        end 
                    end
                end
            end
            self.m_pWinArmautre:getAnimation():setMovementEventCallFunc(animationEvent)
        end
    end
    

    --大奖 自动和免费次数还是需要特效播完再结束
    if currentMub < TigerConst.BIG_WIN_MULTIPLE and  not TigerDataMgr:getInstance():getIsAuto() and TigerDataMgr:getInstance():getFreeTimes() <=0 then 
        self:_stopGame() 
        bSendEnd = true
    end
end

-- 赢取分数显示
function GameViewLayer:showLabelBMResult(bChange)

    self.m_pLbResultScore:setVisible(true)
    self.m_pLbResultScore:setScale(1)
    if bChange then 
        self.m_bWinChangeScore = true
        self.m_llWinSubScore = 0
        self.m_pLbResultScore:setString("0")
    else
        self.m_bWinChangeScore = false
        local gameResult = TigerDataMgr:getInstance():getGameResult()
        local nResult = GameViewLayer.getFormatGoldAndNumber(gameResult.llResult)
        local strResult = string.format("+ %s", nResult)
        self.m_pLbResultScore:setString(strResult)
    end

    local callback = cc.CallFunc:create(function()
        self.m_pLbResultScore:setVisible(false)
    end)
    local scale = cc.ScaleTo:create(0.1,1.2)
    local seq = cc.Sequence:create(cc.DelayTime:create(1.9), scale, callback)
    self.m_pLbResultScore:runAction(seq)
end

function GameViewLayer:updateLabelBMResult()

    if self.m_bWinChangeScore == false then
        return
    end

    local gameResult = TigerDataMgr:getInstance():getGameResult()
    if self.m_llWinSubScore >= gameResult.llResult then 
        local nResult = GameViewLayer.getFormatGoldAndNumber(gameResult.llResult)
        local strResult = string.format("+ %s", nResult)
        self.m_pLbResultScore:setString(strResult)
        return
    end
    local subScore =  math.floor(gameResult.llResult/20) <= 1 and 1 or math.floor(gameResult.llResult/20)
    self.m_llWinSubScore = self.m_llWinSubScore + subScore
    local nResult = GameViewLayer.getFormatGoldAndNumber(self.m_llWinSubScore)
    local strResult = string.format("+ %s", nResult)
    self.m_pLbResultScore:setString(strResult)
end

--结算图标x倍数
function GameViewLayer:showResultIcon(bAni)
    
    local offy = bAni and 10 or 0
    self.m_pNodeResultIcon:setPositionY(-offy)
    self.m_pNodeResultIcon:setVisible(true)
    if bAni then 
        local move = cc.EaseBackOut:create(cc.MoveBy:create(0.1,cc.p(0,offy)))
        self.m_pNodeResultIcon:runAction(move)
    end
    if self.m_pNodeResultIcon:getChildByName("ResultIcons") then
        self.m_pNodeResultIcon:removeChildByName("ResultIcons")
    end
    --计算总共中了几条线
    local nWinCount = 0
    for i=1, self.m_nBetLineNum do
        local nCount = TigerDataMgr:getInstance():GetLineTypeCount(i-1)
        local tType = TigerDataMgr:getInstance():GetLineType(i-1)
        if (nCount >= 3 or (tType == TigerConst.eResultType.Type_BAR and nCount >=3)) then
            nWinCount = nWinCount + 1
        end
    end
    self.m_pResultIconBg:setScaleX(1+(nWinCount-1)*0.25)
    --添加中奖图标
    local _Node = ccui.Layout:create()
    local allWidth = 0
    for i=1, self.m_nBetLineNum do
        local nCount = TigerDataMgr:getInstance():GetLineTypeCount(i-1)
        local tType =  TigerDataMgr:getInstance():GetLineType(i-1)
        if (nCount >= 3 or (tType == TigerConst.eResultType.Type_BAR and nCount >=3)) then
            local strIconFile = string.format(Tiger_Res.PNG_OF_FMT_ICON, tType)
            local icon = cc.Sprite:createWithSpriteFrameName(strIconFile)
            icon:setScale(0.3)
            icon:setAnchorPoint(cc.p(0,0))
            local iconWidth = icon:getContentSize().width*0.3
            icon:setPosition(cc.p(allWidth,0))
            _Node:addChild(icon)

            local strBei = ""
            if tType == TigerConst.eResultType.Type_BAR then
                strBei = string.format("x%d", TigerConst.vecBarBeiLv[nCount-1])
            elseif tType == TigerConst.eResultType.Type_777 then
                local mulit = TigerConst.vec777BeiLv[nCount-2]+TigerDataMgr:getInstance():getExtraTimes()
                strBei = string.format("x%d", mulit)
            elseif tType == TigerConst.eResultType.Type_Gold then
                strBei = string.format("x%d", TigerConst.vecBoxPercent[nCount-2])
                strBei = strBei.."%"
            else
                strBei = string.format("x%d", TigerConst.vecBeiLv[tType][nCount-2])
            end
            local lb_count = cc.Label:createWithBMFont(Tiger_Res.FONT_WHITE, strBei)
            lb_count:setAnchorPoint(cc.p(0, 0))
            lb_count:setPosition(cc.p(allWidth+iconWidth, 8))
            lb_count:setScale(0.68)
            _Node:addChild(lb_count)
            local lbWidth = lb_count:getContentSize().width*0.68
            local offx = nWinCount > 1 and 5 or 0
            allWidth = allWidth + iconWidth + lbWidth + offx
        end
    end
    --调整中下部中奖图标列表位置
    _Node:setPosition(cc.p(667-allWidth/2,206))
    _Node:setName("ResultIcons")
    self.m_pNodeResultIcon:addChild(_Node)


end

--特殊奖励
function GameViewLayer:showSpecialWinEffect(nType, nCount)
    self:cleanSpecialWinEffect()

    if nType == TigerConst.eResultType.Type_Diamond then-- 钻石
        self:showWinDiamEffect()
        local strPath = (self.m_nSoundType == 1 and Tiger_Res.vecSound.SOUND_OF_WIN_DIAM1 or Tiger_Res.vecSound.SOUND_OF_WIN_DIAM2)
        ExternalFun.playSoundEffect(strPath)
        return true

    elseif  nType == TigerConst.eResultType.Type_Gold then -- 宝箱
        self:showWinBoxEffect(nCount)
        local strPath = (self.m_nSoundType == 1 and Tiger_Res.vecSound.SOUND_OF_WIN_BOX1 or Tiger_Res.vecSound.SOUND_OF_WIN_BOX2)
        ExternalFun.playSoundEffect(strPath)
        return true

    elseif  nType == TigerConst.eResultType.Type_777 then -- 777
        self:showWin777Effect(nCount)
        local strPath = (self.m_nSoundType == 1 and Tiger_Res.vecSound.SOUND_OF_WIN_777_1 or Tiger_Res.vecSound.SOUND_OF_WIN_777_2)
        ExternalFun.playSoundEffect(strPath)
        return true
    end

    return false
end

function GameViewLayer:showWinDiamEffect()
    self:setBtnAnimMaskEnable(true)

    local strName = Tiger_Res.vecAnim.GAMEOVER_SPICAIL
    local callback = cc.CallFunc:create(function()
        self:_showSpecialPrize()
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(0.2), callback)
    self.m_pNodeFreeTime:runAction(seq)
    local armature = Effect:getInstance():creatEffectWithDelegate2(self.m_pNodeAnimTop, strName, "Animation1", true, cc.p(667,375))-----------------------------------------
    if armature ~= nil then
        -- 回调
        local animationEvent = function(armatureBack, movementType, movementID)
            if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
                self:effectEnd(armatureBack, movementType, movementID)
            end
        end
        armature:getAnimation():setMovementEventCallFunc(animationEvent)
    end
end

function GameViewLayer:showWinBoxEffect(nCount)
    self:setBtnAnimMaskEnable(true)

    local strName = Tiger_Res.vecAnim.GAMEOVER_BOX
    self.m_nWinCount = nCount
    self.m_pWinBoxArmature = Effect:getInstance():creatEffectWithDelegate2(self.m_pNodeAnimTop, strName, Tiger_Res.vec777BoxAnim.MAIN_SCENE,true,cc.p(667, 500), G_CONSTANTS.Z_ORDER_TOP)
    if not self.m_pWinBoxArmature then return end

    -- 中奖个数
    local lb_count = cc.Label:createWithBMFont(Tiger_Res.FONT_PURPLE, string.format("x%d", self.m_nWinCount))
    lb_count:setPosition(cc.p(705,545))
    lb_count:setTag(TigerConst.TAG_777_BOX_START)
    self.m_pNodeAnimTop:addChild(lb_count,G_CONSTANTS.Z_ORDER_TOP)
    
    for i=0,9 do
        --转盘区域动画
        local pos = cc.p(1060 - i*87, 427)
        self.m_pNumCliperArm[i+1] = Effect:getInstance():creatEffectWithDelegate2(self.m_pNodeAnimTop, strName, Tiger_Res.vec777BoxAnim.RUN_ROUND, true,pos, G_CONSTANTS.Z_ORDER_TOP)
        self.m_pNumCliperArm[i+1]:setTag(TigerConst.TAG_777_BOX_NUM_START + i)
    end

    self.m_nWinCount = nCount
    self:showNumCliperArm(2,1)
end

function GameViewLayer:showWin777Effect(nCount)
    self:setBtnAnimMaskEnable(true)

    local strName = Tiger_Res.vecAnim.GAMEOVER_777
    self.m_pWin777Armature = Effect:getInstance():creatEffectWithDelegate2(self.m_pNodeAnimTop, strName, Tiger_Res.vec777BoxAnim.MAIN_SCENE,true,cc.p(667, 500), G_CONSTANTS.Z_ORDER_TOP)
    if not self.m_pWin777Armature then return end

    local nTag = TigerConst.TAG_777_BOX_START
    -- 中奖个数
    local lb_count = cc.Label:createWithBMFont(Tiger_Res.FONT_PURPLE, string.format("x%d", nCount))
    lb_count:setPosition(cc.p(698,537))
    lb_count:setTag(nTag)
    self.m_pNodeAnimTop:addChild(lb_count,G_CONSTANTS.Z_ORDER_TOP)
    
    -- 倍率文字图片
    local Img_multiple = cc.Sprite:createWithSpriteFrameName(Tiger_Res.PNG_OF_MULTIPLE)
    Img_multiple:setPosition(cc.p(320,425))
    Img_multiple:setTag(nTag+1)
    self.m_pNodeAnimTop:addChild(Img_multiple,G_CONSTANTS.Z_ORDER_TOP)

    -- 基础倍率
    local lb_bei = cc.Label:createWithBMFont(Tiger_Res.FONT_YELLOW, string.format("%d+", TigerConst.vec777BeiLv[nCount-2]))
    lb_bei:setPosition(cc.p(457,425))
    lb_bei:setTag(nTag+2)
    self.m_pNodeAnimTop:addChild(lb_bei,G_CONSTANTS.Z_ORDER_TOP)
    
    for i=0,3 do
        --转盘区域动画
        local pos = cc.p(840 - i*84, 427)
        self.m_pNumCliperArm[i+1] = Effect:getInstance():creatEffectWithDelegate2(self.m_pNodeAnimTop, strName, Tiger_Res.vec777BoxAnim.RUN_ROUND, true,pos, G_CONSTANTS.Z_ORDER_TOP)
        self.m_pNumCliperArm[i+1]:setTag(TigerConst.TAG_777_BOX_NUM_START + i)
    end

    self.m_nWinCount = nCount
    self:showNumCliperArm(1,1)
end

-- 显示选中随机数字动画
-- nType: 1--777, 2--box
-- nShowCount: 当前显示第几个数字
function GameViewLayer:showNumCliperArm(nType, nShowCount)
    if not self.m_pNumCliperArm[nShowCount] then return end

    local nBeilv = 0
    -- 添加随机倍率
    if nType == 1 then -- 777
        local times = TigerDataMgr:getInstance():getExtraTimes()

        if nShowCount == 1 then
            nBeilv = times%10
            ExternalFun.playSoundEffect(Tiger_Res.vecSound.SOUND_OF_777)
        elseif nShowCount == 2 then  nBeilv = math.floor(times%100/10)
        elseif nShowCount == 3 then  nBeilv = math.floor(times%1000/100)
        elseif nShowCount == 4 then  nBeilv = math.floor(times/1000)
        end
    elseif nType == 2 then -- box
        local gameResult = TigerDataMgr:getInstance():getGameResult()
        local socre = gameResult.llResult

        if nShowCount == 1 then
            nBeilv = socre%10
--            AudioManager.getInstance():stopSound(self.m_nBoxRollSoundId)
            self.m_nBoxRollSoundId = ExternalFun.playSoundEffect(Tiger_Res.vecSound.SOUND_OF_BOX,true)
        elseif nShowCount == 2  then nBeilv = math.floor(socre%100/10)
        elseif nShowCount == 3  then nBeilv = -1 --第三位放置小数点
        elseif nShowCount == 4  then nBeilv = math.floor(socre%1000/100)
        elseif nShowCount == 5  then nBeilv = math.floor(socre%10000/1000)
        elseif nShowCount == 6  then nBeilv = math.floor(socre%100000/10000)
        elseif nShowCount == 7  then nBeilv = math.floor(socre%1000000/100000)
        elseif nShowCount == 8  then nBeilv = math.floor(socre%10000000/1000000)
        elseif nShowCount == 9  then nBeilv = math.floor(socre%100000000/10000000)
        elseif nShowCount == 10 then nBeilv = math.floor(socre/1000000000)
        end
    end

    -- 替换动画节点
    local strFilePath = ""
    if nBeilv == -1 then -- 宝箱动画小数点
        strFilePath = Tiger_Res.PNG_NUM_POINT_IMG
    else
        strFilePath = string.format(Tiger_Res.FMT_NUM_RESULT_IMG, nBeilv)
    end
    --print("filepaht:"..strFilePath)
    self:replaceArmatureSprite(self.m_pNumCliperArm[nShowCount], Tiger_Res.str777BoxReplaceNode, strFilePath)
    -- 转盘出数字动画
    self.m_pNumCliperArm[nShowCount]:getAnimation():play(Tiger_Res.vec777BoxAnim.RUN_NUMBER) 
    
    -- 回调
    local animationEvent = function(armatureBack, movementType, movementID)
        if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
            if nType == 1 and nShowCount == 4 then -- 777 动画播完
                --添加最后结算倍率
                local amount = TigerConst.vec777BeiLv[self.m_nWinCount-2] + TigerDataMgr:getInstance():getExtraTimes()
                local lb_amout = cc.Label:createWithBMFont(Tiger_Res.FONT_YELLOW, string.format("=%d", amount))
                lb_amout:setPosition(cc.p(310+667,425))
                lb_amout:setTag(TigerConst.TAG_777_BOX_START + 3)
                self.m_pNodeAnimTop:addChild(lb_amout,G_CONSTANTS.Z_ORDER_TOP+1)
                -- 延时移除动画
                self:doSomethingLater(function()
                    if self.m_pNumCliperArm[nShowCount] then
                        self:effectEnd(armatureBack, movementType, movementID)
                    end
                end, 1.8)
                self:showLabelBMResult(true)
                self:showResultIcon(true)
            elseif nType == 2 and nShowCount == 10 then -- box 动画播完
--                AudioManager.getInstance():stopSound(self.m_nBoxRollSoundId)
                -- 延时移除动画
                self:doSomethingLater(function()
                    if self.m_pNumCliperArm[nShowCount] then
                        self:effectEnd(armatureBack, movementType, movementID)
                    end
                end, 1.8)
                self:showLabelBMResult(true)
                self:showResultIcon(true)
            else
                self:showNumCliperArm(nType, nShowCount + 1)
            end
        end
    end
    self.m_pNumCliperArm[nShowCount]:getAnimation():setMovementEventCallFunc(animationEvent)
end

function GameViewLayer:effectEnd(armature, type, movementID)
    if armature == nil then return end

    local bIsRemoveArm = true
    local strName = armature:getName()
    if strName == Tiger_Res.vecAnim.GAMEOVER_BOX
        or strName == Tiger_Res.vecAnim.GAMEOVER_777
    then
        self:setBtnAnimMaskEnable(false)
        self:cleanSpecialWinEffect()

        -- 777、box 动画已经在 cleanSpecialWinEffect 接口中释放
        if (strName == Tiger_Res.vecAnim.GAMEOVER_BOX
            or strName == Tiger_Res.vecAnim.GAMEOVER_777)
        then
            bIsRemoveArm = false
        end
        self:showGoldChangeAndFly(true)
        self:_stopGame()
    elseif strName == Tiger_Res.vecAnim.GAMEOVER_SPICAIL then
        self:setBtnAnimMaskEnable(false)
        self:_stopGame()
    end

    if bIsRemoveArm then
        armature:removeFromParent()
    end
end

function GameViewLayer:showGoldChangeAndFly(bChange)
    --累计押中
    self.m_pLbTotalBetGold:setString(self:getWinAwardNumStr())
    --自己金币
    local nScoreNow = self.m_MoneySyncServer
    local nScoreOld = self.m_MoneyYazhuHou--Player:getInstance():getTempUserScore()
    local nSubSocre = nScoreNow - nScoreOld
    ---------------------------------------------------------
    local gameResult = TigerDataMgr:getInstance():getGameResult()
    print("Now:"..nScoreNow..";Old:"..nScoreOld..";Add:"..nSubSocre..";Result:"..gameResult.llResult)
    if gameResult.llResult ~= nSubSocre then --玩家金币有可能被刷新了,导致显示不正确
--        FloatMessage.getInstance():pushMessageDebug("Now:"..nScoreNow..";Old:"..nScoreOld..";Add:"..nSubSocre..";Result:"..gameResult.llResult)
        nSubSocre = gameResult.llResult
        nScoreNow = nScoreOld + nSubSocre
    end
--    if TigerDataMgr:getInstance():getFreeTimes() > 0 then 
--        Player:getInstance():setUserScore(nScoreNow+gameResult.llResult)
--    end 
    self.m_pLbUsrGold:stopAllActions()
    print("Lb_usrGold________________________________4")
    self.m_pLbUsrGold:setString(GameViewLayer.getFormatGoldAndNumber(nScoreNow))

end
-- 玩家赢取金币加金币飘数字动画
function GameViewLayer:flyNumOfGoldChange(nWinScore, pos, pParent)
    if pParent == nil then return end
    if nWinScore <= 0 then return end
    
    if pParent:getChildByName("LbAddScore") ~= nil then 
        pParent:removeChildByName("LbAddScore")
    end
    local strScore = GameViewLayer.getFormatGoldAndNumber(nWinScore)
    local strResult = "+"..strScore
    local pLbAddScore = cc.Label:createWithBMFont(Tiger_Res.FONT_GREEN, strResult)
    pLbAddScore:setAnchorPoint(cc.p(0.5, 0.5))
    pLbAddScore:setString(strResult)
    pLbAddScore:setScale(0.3)
    pLbAddScore:setPosition(pos)
    pLbAddScore:setName("LbAddScore")
    pParent:addChild(pLbAddScore,G_CONSTANTS.Z_ORDER_TOP)
    
    local move = cc.MoveBy:create(0.2, cc.p(0,50))
    --[[local ease = cc.EaseBackInOut:create(move)]]
    local pFadein = cc.FadeIn:create(0.2)
    local pDelay = cc.DelayTime:create(3)
    local pFadeout = cc.FadeOut:create(0.8)
    local callBack = cc.CallFunc:create(function()
        pLbAddScore:removeFromParent()
    end)
    
    pLbAddScore:runAction(cc.Sequence:create(cc.Spawn:create(pFadein,move),pDelay,pFadeout,callBack))
end

function GameViewLayer:cleanSpecialWinEffect()
    if self.m_pWinBoxArmature then
        self.m_pWinBoxArmature:removeFromParent()
        self.m_pWinBoxArmature = nil
    end
    if self.m_pWin777Armature then
        self.m_pWin777Armature:removeFromParent()
        self.m_pWin777Armature = nil
    end

    -- 移除 win 777 / box 随机数字动画
    for i=0,9 do
        local node = self.m_pNodeAnimTop:getChildByTag(TigerConst.TAG_777_BOX_NUM_START + i)
        if node then node:removeFromParent() end
    end
    self.m_pNumCliperArm = {}

    -- 移除显示 win 777 / box 动画时创建的UI
    for i=0,3 do
        local node = self.m_pNodeAnimTop:getChildByTag(TigerConst.TAG_777_BOX_START + i)
        if node then node:removeFromParent() end
    end

    -- 停止转数字音效
--    AudioManager.getInstance():stopSound(self.m_nBoxRollSoundId)
end
function GameViewLayer:cleanWinIconEffect()
    for i=1,TigerConst.CARD_INDEX do
        if self.m_pWinIconArmature[i] then
            self.m_pWinIconArmature[i]:removeFromParent()
        end
    end
    self.m_pWinIconArmature = {}
    self.m_pNodeIconMask:setVisible(false)
end
function GameViewLayer:cleanLineEffect()
    for i=1,TigerConst.LINE_COUNT do
        if self.m_pLineNodes[i] ~= nil then
             self.m_pLineNodes[i]:setVisible(false)
        end
        for j = 1, 2 do
            if nil ~= self.m_pLineHeader[j][i] then
                self.m_pLineHeader[j][i]:setVisible(false)
            end
        end
    end
    self.m_pShineNode:stopAllActions()
    self.m_pShineNode:setVisible(false)

end
function GameViewLayer:cleanResultIcon()
    self.m_pNodeResultIcon:setVisible(false)

end
----------------------------------- play animation end ----------------------------

----------------------------------- help func start -------------------------------

-- 替换动画 sprite
function GameViewLayer:replaceArmatureSprite(armuture, boneName, strPathName)
    local pBone = armuture:getBone(boneName)
    assert(pBone)
    
    local pManager = pBone:getDisplayManager()
    assert(pManager)
    
    local vecDisplay = pManager:getDecorativeDisplayList()
    assert(vecDisplay)

    for k, v in pairs(vecDisplay) do
        if v and v:getDisplay() then
            local spData = v:getDisplay()
            spData:setSpriteFrame(strPathName)
        end
    end
end

function GameViewLayer:setBtnAnimMaskEnable(isEnabled)
    isEnabled = (isEnabled and true or false)
    self.m_pNodeMask:setVisible(isEnabled)
end

function GameViewLayer:setBtnStartGameEnable(isEnabled)

end

-- 停止自动开始状态
function GameViewLayer:cancelAutoStart()
    self.m_bLongPress = false
    TigerDataMgr:getInstance():setIsAuto(false)
    self.m_pBtnGameStart:loadTextureNormal(Tiger_Res.PNG_OF_START_NOMAL, ccui.TextureResType.plistType)
    self.m_pBtnGameStart:loadTexturePressed(Tiger_Res.PNG_OF_START_NOMAL_PRESS, ccui.TextureResType.plistType)

end

function GameViewLayer:onLongPressCallBack()
    self.m_bLongPress = true
    self:unscheduleLongPress_cb()
    self:onAutoClicked()
end

function GameViewLayer:unscheduleLongPress_cb() -- 取消定时器
    if self.m_pSchedulerLongPress then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_pSchedulerLongPress)
    end
    self.m_pSchedulerLongPress = nil
end

function GameViewLayer:isHandelingLongPressEvent()
    local bState = false
    
    if self.m_bLongPress then
        self.m_nClickStartBtNum = self.m_nClickStartBtNum + 1
        bState = true
    end
    
    if(self.m_bLongPress and (self.m_nClickStartBtNum >= 2)) then
        self:onStopClicked()
        self.m_nClickStartBtNum = 0
        bState = true
    end
    
    return bState
end

function GameViewLayer:playCommodSound()
    local gameResult = TigerDataMgr:getInstance():getGameResult()
    local nWinSocre = gameResult.llResult
    if (nWinSocre > 0) then
        self.m_nUserWinCount = self.m_nUserWinCount + 1
        self.m_nUserLoseCount = 0
        local strPath = ""
        local nWinSound = 0
        
        if (nWinSocre >= 1000000 or self.m_nUserWinCount >= 5) then
            strPath = (self.m_nSoundType == 1 and Tiger_Res.vecSound.SOUND_OF_BIG_WIN_1 or Tiger_Res.vecSound.SOUND_OF_BIG_WIN_2)
            nWinSound = 3
        elseif (nWinSocre >= 500000 or self.m_nUserWinCount >= 3) then
            strPath = (self.m_nSoundType == 1 and Tiger_Res.vecSound.SOUND_OF_MIDDLE_WIN_1 or Tiger_Res.vecSound.SOUND_OF_MIDDLE_WIN_2)
            nWinSound = 2
        elseif (nWinSocre >= 200000 or self.m_nUserWinCount >= 2) then
            strPath = (self.m_nSoundType == 1 and Tiger_Res.vecSound.SOUND_OF_SMALL_WIN_1 or Tiger_Res.vecSound.SOUND_OF_SMALL_WIN_2)
            nWinSound = 1
        end

        if (nWinSound > self.m_nLastWinSound) then
            self.m_nLastWinSound = nWinSound
            self.m_nSoundCount = 0
            ExternalFun.playSoundEffect(strPath)
        end

    elseif(TigerDataMgr:getInstance():getFreeTimes() <= 0) then
        self.m_nUserWinCount = 0
        self.m_nUserLoseCount = self.m_nUserLoseCount + 1

        local strPath = ""
        local nLoseSound = 0
        if (self.m_nUserLoseCount >= 5) then
            local str1 = string.format("SOUND_OF_BIG_LOSE_%d",math.random(1,3)%2 + 1)
            local str2 = string.format("SOUND_OF_BIG_LOSE_%d",math.random(1,3)%2 + 3)
            strPath = (self.m_nSoundType == 1 and Tiger_Res.vecSound[str1] or Tiger_Res.vecSound[str2])
            nLoseSound = 3
        elseif (self.m_nUserLoseCount >= 3) then
            strPath = (self.m_nSoundType == 1 and Tiger_Res.vecSound.SOUND_OF_MIDDLE_LOSE_1 or Tiger_Res.vecSound.SOUND_OF_MIDDLE_LOSE_2)
            nLoseSound = 2
        elseif (self.m_nUserLoseCount >= 2) then
            strPath = (self.m_nSoundType == 1 and Tiger_Res.vecSound.SOUND_OF_SMALL_LOSE_1 or Tiger_Res.vecSound.SOUND_OF_SMALL_LOSE_2)
            nLoseSound =1
        end

        if (nLoseSound > self.m_nLastLoseSound) then
            self.m_nLastLoseSound = nLoseSound
            self.m_nSoundCount = 0
            ExternalFun.playSoundEffect(strPath)
        end
    end

    if self.m_nLastWinSound > 0 or self.m_nLastLoseSound > 0 then
        self.m_nSoundCount = self.m_nSoundCount + 1
        if self.m_nSoundCount >= 10 then
            self.m_nSoundCount = 0
            self.m_nUserWinCount = 0
            self.m_nUserLoseCount = 0
            self.m_nLastLoseSound = 0
            self.m_nLastWinSound = 0
        end
    end
end

-- 得到其它玩家金币显示字符串
function GameViewLayer:getOtherUserGoldNumStr(nGoldNum)
--    local strResult = ""
--    local nNum = 0

--    if nGoldNum >= 100000000 then
--        nNum = nGoldNum * 0.00000001
--        strResult = string.format(LuaUtils.getLocalString("TIGER_10"),nNum)
--    elseif nGoldNum >= 10000 then
--        nNum = nGoldNum * 0.0001
--        strResult = string.format(LuaUtils.getLocalString("TIGER_11"),nNum)
--    else
--        strResult = string.format(LuaUtils.getLocalString("TIGER_12"),nGoldNum)
--    end

--    return strResult
end

function GameViewLayer:getWinAwardNumStr()
    local strResult = ""

    local nCurSumNum = TigerDataMgr:getInstance():getAllBetWinGold()
    strResult = GameViewLayer.getFormatGoldAndNumber(nCurSumNum)
    --[[if nCurSumNum >= 10000 then
        nCurSumNum = nCurSumNum / 10000
        strResult = string.format(LuaUtils.getLocalString("TIGER_9"),nCurSumNum)
    else
        strResult = string.format(LuaUtils.getLocalString("TIGER_2"),nCurSumNum)
    end]]

    return strResult
end

function GameViewLayer:updateButtonOfMusic(enable)
    local bEnable = enable
    local path = bEnable and Tiger_Res.PNG_OF_MUSIC_ON or Tiger_Res.PNG_OF_MUSIC_OFF
    self.m_pBtnMusic:loadTextureNormal(path,ccui.TextureResType.plistType)
end

function GameViewLayer:updateButtonOfSound(enable)
    local bEnable = enable
    local path = bEnable and Tiger_Res.PNG_OF_SOUND_ON or Tiger_Res.PNG_OF_SOUND_OFF
    self.m_pBtnEffect:loadTextureNormal(path,ccui.TextureResType.plistType)
end

--打开充值
function GameViewLayer:showChargeLayer()
    local pRecharge = self:getChildByName("RechargeLayer")
    if pRecharge then
        pRecharge:setVisible(true)
        return
    end
    local isClosedAppStore = GameListManager.getInstance():getGameSwitch(G_CONSTANTS.GAMESWITCH.CLOSE_RECHARGE_APPSTORE);

    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if not (cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform or cc.PLATFORM_OS_MAC == targetPlatform) then 
        isClosedAppStore = true;
    end

    if isClosedAppStore then
        pRecharge = RechargeLayer:create()
    else
        pRecharge = AppStoreView:create()
    end
    pRecharge:setName("RechargeLayer")
    self:addChild(pRecharge, G_CONSTANTS.G_CONSTANTS.Z_ORDER_TOP)
end

-- 发送站起并退出
function GameViewLayer:onSendStandUpAndExit()

    self._scene:onQueryExitGame()
end

----------------------------------- help func end -------------------------------

---------------------------------- btn click event  start ---------------------------------------
function GameViewLayer:onMenuClicked()
    ExternalFun.playSoundEffect(Tiger_Res.SOUND_OF_BUTTON)
    -- 动画过程中不响应
    if self.m_bIsMenuMove then return end
    self.m_bIsMenuMove = true

    self.m_pImgMenuBg:setVisible(true)
    self.m_pImgMenuBg:stopAllActions()
    self.m_pImgMenuBg:setPosition(cc.p(self.m_menuResPos.x, 967))
    local moveTo = cc.MoveTo:create(0.2, cc.p(self.m_menuResPos.x, self.m_menuResPos.y))
    local callBack = cc.CallFunc:create(function()
            self.m_bIsMenuMove = false
            self.m_pBtnMenuPop:setVisible(true)
            self.m_pBtnMenuCancel:setVisible(true)
            self.m_pBtnMenuPush:setVisible(false)
        end)
    local seq = cc.Sequence:create(moveTo, callBack)
    self.m_pImgMenuBg:runAction(seq)
end

function GameViewLayer:onMenuCancel()
    if self.m_bIsShowAddScoreBar then
        self:updateAddScoreBtnBar(false)
        self:updateGameInfo()
    end
    -- 动画过程中不响应
    if self.m_bIsMenuMove then return end
    self.m_bIsMenuMove = true

    self.m_pImgMenuBg:stopAllActions()
    local moveTo = cc.MoveTo:create(0.2, cc.p(self.m_menuResPos.x, 967))
    local callBack = cc.CallFunc:create(function()
            self.m_bIsMenuMove = false
            self.m_pImgMenuBg:setVisible(false)
            self.m_pBtnMenuPop:setVisible(false)
            self.m_pBtnMenuCancel:setVisible(false)
            self.m_pBtnMenuPush:setVisible(true)
        end)
    local seq = cc.Sequence:create(moveTo, callBack)
    self.m_pImgMenuBg:runAction(seq)
end

-- 退出按纽
function GameViewLayer:onBtnExitClicked()

    ExternalFun.playSoundEffect(Tiger_Res.SOUND_OF_BUTTON)
    self._scene:onQueryExitGame()

--    if TigerDataMgr:getInstance():getTigerState() == TigerConst.GAME_TIGER_FREE then
--        self:onSendStandUpAndExit()
--    else
--        --有投注纪录，则需要提示
--        self:showMessageBox(LuaUtils.getLocalString("MESSAGE_10"), MsgBoxPreBiz.PreDefineCallBack.CB_EXITROOM)
--    end
end

-- 音效
function GameViewLayer:onEffectClicked()
    ExternalFun.playSoundEffect(Tiger_Res.SOUND_OF_BUTTON)
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
function GameViewLayer:onMusicClicked()
    ExternalFun.playSoundEffect(Tiger_Res.SOUND_OF_BUTTON)
    local bEnable = false
    if (GlobalUserItem.bVoiceAble)then -- 音乐开着 
        GlobalUserItem.setVoiceAble(false)
    else
        bEnable = true
        GlobalUserItem.setVoiceAble(true)
        --播放音乐
--        local strPath = AudioManager.getInstance():getStrMusicPath()
--        AudioManager.getInstance():playMusic(strPath)
    end

    self:updateButtonOfMusic(bEnable)
end
-- 帮助按纽
function GameViewLayer:onRuleClicked()
    ExternalFun.playSoundEffect(Tiger_Res.SOUND_OF_BUTTON)
    self:showRuleLayer()
end
-- 银行按纽
function GameViewLayer:onBankClicked()
    ExternalFun.playSoundEffect(Tiger_Res.SOUND_OF_BUTTON)

--    --没有设置密码
--    if (PlayerInfo.getInstance():getIsInsurePass() == 0) then
--        FloatMessage.getInstance():pushMessage("STRING_033")
--        return
--    end

--    --弹出银行界面
--    local ingameBankView = IngameBankView:create()
--    ingameBankView:setName("IngameBankView")
--    ingameBankView:setCloseAfterRecharge(false)
--    self:addChild(ingameBankView, 500)
end

function GameViewLayer:onAutoClicked()
    local nCurrentBetMoney = TigerDataMgr:getInstance():getMinBetNum() * TigerDataMgr:getInstance():getBetNumIndex() * TigerDataMgr:getInstance():getLineNum()
    
    if nCurrentBetMoney > self.m_MoneySyncServer then
        FloatMessage:getInstance():pushMessage("游戏币不足")
        return
    end
    
    if (TigerDataMgr:getInstance():getTigerState() == TigerConst.GAME_TIGER_FREE) then
        local nCurrentBetMoney = TigerDataMgr:getInstance():getMinBetNum() * TigerDataMgr:getInstance():getBetNumIndex()
        if (nCurrentBetMoney <= 0) then
            self:showFloatmessage("TIGER_3")
            return
        end
        self:_startGame()
    end
    TigerDataMgr:getInstance():setIsAuto(true)
    
    self.m_pBtnGameStart:loadTextureNormal(Tiger_Res.PNG_OF_START_AUTO, ccui.TextureResType.plistType)
    self.m_pBtnGameStart:loadTexturePressed(Tiger_Res.PNG_OF_START_AUTO_PRESS, ccui.TextureResType.plistType)
end

function GameViewLayer:onStopClicked()
    ExternalFun.playSoundEffect(Tiger_Res.vecSound.SOUND_OF_GAME_STOP)
    
    self:cancelAutoStart()
    if TigerDataMgr:getInstance():getTigerState() == TigerConst.GAME_TIGER_PLAY then 
        self:setBtnStartGameEnable(false)
    end
end

function GameViewLayer:onStartTouched(sender,eventType)
    if eventType == ccui.TouchEventType.began then
        self.m_pAniStart:setVisible(false)
        ExternalFun.playSoundEffect(Tiger_Res.SOUND_OF_BUTTON)
        if not TigerDataMgr:getInstance():getIsAuto() and TigerDataMgr:getInstance():getFreeTimes() <= 0 then
            self.m_bLongPress = false
            self:unscheduleLongPress_cb()
            self.m_pSchedulerLongPress = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onLongPressCallBack), 1.2,false) -- 长按2秒，自动开始
        end

    elseif eventType == ccui.TouchEventType.moved then
        local touchPos = cc.p(sender:getTouchMovePosition())
        local point = cc.p(touchPos.x, touchPos.y -(display.height - 750) / 2)
        if LuaUtils.isIphoneXDesignResolution() then
            local diffX = 145 - (1624-display.size.width)/2
            point = cc.p(touchPos.x-diffX, touchPos.y -(display.height - 750) / 2)
        end
        local startBtnPos = cc.p(sender:getPosition())
        local btnSize = sender:getContentSize()
        local rect = cc.rect(startBtnPos.x - btnSize.width / 2, startBtnPos.y-btnSize.height/2, btnSize.width, btnSize.height)
        if not cc.rectContainsPoint(rect, point) then -- 移出按纽区域
            if self.m_pSchedulerLongPress then
                self:unscheduleLongPress_cb()
            end
        end

    elseif eventType == ccui.TouchEventType.ended then
        self:unscheduleLongPress_cb()
        self:onGameStartClicked() -- 响应开始按纽
        self.m_pAniStart:setVisible(true)
    else
        self.m_pAniStart:setVisible(true)
        self:unscheduleLongPress_cb()
    end
--    if eventType == ccui.TouchEventType.ended then
--        self._scene:sendStart(9,180)
--    end
end
function GameViewLayer:onGameStartClicked()
    if self:isHandelingLongPressEvent() then return end
    
    if self.m_eGameState == TigerConst.eGameState.State_Nothing or
        self.m_eGameState == TigerConst.eGameState.State_BigWin or 
        self.m_eGameState == TigerConst.eGameState.State_SpecialWin then 
        return
    end
    --停止转动
    if self.m_eGameState == TigerConst.eGameState.State_Turn then 
        self:instantPlayResultEffect()
        return
    end
    --直接显示分数和中奖结果
    if self.m_eGameState == TigerConst.eGameState.State_NormalWin then
        self:instantPlayWinEffect()
        return
    end
     --空闲状态 发送游戏开始
    if self.m_eGameState == TigerConst.eGameState.State_Wait then
        if self.m_bSendGameStart or self.m_bSendGameStop then --* TigerDataMgr:getInstance():getFreeTimes() > 0 or
            return
        end
        local nCurrentBetMoney = TigerDataMgr:getInstance():getMinBetNum() * TigerDataMgr:getInstance():getBetNumIndex() * TigerDataMgr:getInstance():getLineNum()
        if nCurrentBetMoney <= 0 then
            self:showFloatmessage("TIGER_3")
            return
        end
    
        if nCurrentBetMoney > self.m_MoneySyncServer then
            FloatMessage:getInstance():pushMessage("游戏币不足")
            return
        end
        if self.m_pWinArmautre then 
            self.m_pWinArmautre:getAnimation():gotoAndPause(0)
            self.m_pWinArmautre:setVisible(false)
        end 
        self.m_bSendGameStart = true
        self:_startGame()
        --self.m_pBtnLineNum:setEnabled(true)
        self.m_pBtnBaseScore:setEnabled(true)
        self.m_pBtnAllLine:setEnabled(true)
        self.m_pBtnLineAdd:setEnabled(true)
        self.m_pBtnLineReduce:setEnabled(true)
        self:setLineEnable(true)
    end
end

function GameViewLayer:onBtnUIChanged(sender,eventType) -- 按纽上 UI 随按纽点击一起缩放
    if eventType==ccui.TouchEventType.began then
        local pBtnUI = sender:getChildByName("Node_BtnUI")
        if pBtnUI then
            pBtnUI:stopAllActions()
            local _zoomScale = sender:getZoomScale()
            local pZoomTitleAction = cc.ScaleTo:create(TigerConst.ZOOM_ACTION_TIME_STEP, 1.0+_zoomScale, 1.0+_zoomScale)
            pBtnUI:runAction(pZoomTitleAction)
        end
    elseif eventType==ccui.TouchEventType.canceled then
        local pBtnUI = sender:getChildByName("Node_BtnUI")
        if pBtnUI then
            pBtnUI:stopAllActions()
            pBtnUI:setScale(1.0)
        end
    elseif eventType==ccui.TouchEventType.ended then 
        local pBtnUI = sender:getChildByName("Node_BtnUI")
        if pBtnUI then
            pBtnUI:stopAllActions()
            pBtnUI:setScale(1.0)
        end
    end
end

function GameViewLayer:onBetNumChangeTouched(sender,eventType)
    if TigerDataMgr:getInstance():getTigerState() ~= TigerConst.GAME_TIGER_FREE then return end

    self:onBtnUIChanged(sender,eventType)

    print(eventType)

    if eventType==ccui.TouchEventType.began then
        ExternalFun.playSoundEffect(Tiger_Res.SOUND_OF_BUTTON)
    elseif eventType==ccui.TouchEventType.ended then
        self:_changeJetton()
    end
end

function GameViewLayer:onLineAddTouched(sender,eventType)
    if TigerDataMgr:getInstance():getTigerState() ~= TigerConst.GAME_TIGER_FREE then return end
    
    self:onBtnUIChanged(sender,eventType)

    if eventType==ccui.TouchEventType.began then
        ExternalFun.playSoundEffect(Tiger_Res.vecSound.SOUND_OF_LINE_BTN)
    elseif eventType==ccui.TouchEventType.ended then
        local nLine = TigerDataMgr:getInstance():getLineNum()
        if nLine >= TigerConst.MAX_LINE_NUM then
            nLine = TigerConst.MIN_LINE_NUM
        else
            nLine = nLine + 1
        end
        self:_downLine(nLine)
        self:_updateData()
    end
end

function GameViewLayer:onLineReduceTouched(sender,eventType)
    if TigerDataMgr:getInstance():getTigerState() ~= TigerConst.GAME_TIGER_FREE then return end
    
    self:onBtnUIChanged(sender,eventType)

    if eventType==ccui.TouchEventType.began then
        ExternalFun.playSoundEffect(Tiger_Res.vecSound.SOUND_OF_LINE_BTN)
    elseif eventType==ccui.TouchEventType.ended then
        local nLine = TigerDataMgr:getInstance():getLineNum()
        if nLine <= TigerConst.MIN_LINE_NUM then
            nLine = TigerConst.MAX_LINE_NUM
        else
            nLine = nLine - 1
        end
        self:_downLine(nLine)
        self:_updateData()
    end
end

--最大押注 满线加底分最大
function GameViewLayer:onAllLineClicked()
    ExternalFun.playSoundEffect(Tiger_Res.vecSound.SOUND_OF_LINE_BTN)
    if TigerDataMgr:getInstance():getLineNum() == TigerConst.MAX_LINE_NUM and TigerDataMgr:getInstance():getBetNumIndex() == TigerConst.MAX_MULTIPLE then
        FloatMessage.getInstance():pushMessage("已处于最大押注状态")
        return
    end
    --加线
    self:_downLine(TigerConst.MAX_LINE_NUM)
    --加底分  
    TigerDataMgr:getInstance():setBetNumIndex(TigerConst.MAX_MULTIPLE)
    TigerDataMgr:getInstance():setLastBetNumIndex(TigerConst.MAX_MULTIPLE)

    self:_updateData()
end


---------------------------------- btn click event end ---------------------------------------

---------------------------------- resource -----------------------------------
function GameViewLayer:doSoundPlayLater(strSound, delay)
    if delay <= 0 then
        ExternalFun.playSoundEffect(strSound)
    else
        self:doSomethingLater(function()
            ExternalFun.playSoundEffect(strSound)
        end, delay)
    end
end
function GameViewLayer:doSomethingLater(call, delay, ...)
    self.m_rootUI:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(call, {...})))
end
---------------------------------- resource -----------------------------------

---------------------------------- open layer --------------------------------
function GameViewLayer:showRuleLayer() --打开规则
    TigerRuleLayer.create():addTo(self, G_CONSTANTS.Z_ORDER_COMMON)
end
function GameViewLayer:showMessageBox(msg, cb) --打开确认框
    local pMessageBox = MessageBoxNew.create(msg, cb)
    self:addChild(pMessageBox, ZORDER_OF_MESSAGEBOX)
end
function GameViewLayer:showFloatmessage(msg) --提示信息
    FloatMessage:getInstance():pushMessage(msg)
end

function GameViewLayer:showIngameBank() --打开银行
    SLFacade:dispatchCustomEvent(Public_Events.MSG_SHOW_INGAMEBANK)
end
---------------------------------- other layer --------------------------------

----------------- send msg start -----------------
function GameViewLayer:doSendStandUp() -- 站立
    CMsgTiger:getInstance():sendStandUp()
end

function GameViewLayer:doSendGameStart() -- 开始游戏
    if TigerDataMgr:getInstance():getFreeTimes() > 0 then
        TigerDataMgr:getInstance():itIsFree()
        return
    end
    local line = TigerDataMgr:getInstance():getLineNum()
    local jetton = TigerDataMgr:getInstance():getMinBetNum() * TigerDataMgr:getInstance():getBetNumIndex()  
    self._scene:sendStart(line,jetton)
end

function GameViewLayer:doSendGameStop() -- 停止游戏
--    CMsgTiger:getInstance():sendGameStop()
    -- 设置游戏状态
    TigerDataMgr:getInstance():setTigerState(TigerConst.GAME_TIGER_FREE);

    --日志
    LOG_PRINT("游戏结束")
    --FloatMessage.getInstance():pushMessageDebug("收到游戏结束")
    -- 通知 
    SLFacade:dispatchCustomEvent(Tiger_Events.MSG_TIGER_GAME_END)
end
----------------- send msg end -----------------

function GameViewLayer:getNormalFrame(str)
    local framename = Tiger_Res.TIGER_BTN_NORMAL
    local Img_multiple = cc.Sprite:createWithSpriteFrameName(Tiger_Res.PNG_OF_BET_NOMAL)
    Img_multiple:setPosition(cc.p(0, 0))
        :setAnchorPoint(cc.p(0, 0))
        :setFlippedY(true)
    local lb = cc.Label:createWithBMFont(Tiger_Res.FONT_DIZHU_NORMAL, str)
    lb:setPosition(cc.p(158.75, 21))
        :setAnchorPoint(cc.p(0.5, 0.5))
        :setScaleY(-1)
    local renderTexture = cc.RenderTexture:create(243, 66, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
    renderTexture:begin()
    Img_multiple:visit()
    lb:visit()
    renderTexture:endToLua()

    local sp = renderTexture:getSprite()
    local fm = sp:getSpriteFrame()
    cc.SpriteFrameCache:getInstance():addSpriteFrame(fm, framename)
    return framename
end

function GameViewLayer:getPressFrame(str)
    local framename = Tiger_Res.TIGER_BTN_PRESS
    local Img_multiple = cc.Sprite:createWithSpriteFrameName(Tiger_Res.PNG_OF_BET_PRESS)
    Img_multiple:setPosition(cc.p(0, 0))
        :setAnchorPoint(cc.p(0, 0))
        :setFlippedY(true)
    local lb = cc.Label:createWithBMFont(Tiger_Res.FONT_DIZHU_NORMAL, str)
    lb:setPosition(cc.p(158.75, 26))
        :setAnchorPoint(cc.p(0.5, 0.5))
        :setScaleY(-1)
    local renderTexture = cc.RenderTexture:create(243, 66, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
    renderTexture:begin()
    Img_multiple:visit()
    lb:visit()
    renderTexture:endToLua()

    local sp = renderTexture:getSprite()
    local fm = sp:getSpriteFrame()
    cc.SpriteFrameCache:getInstance():addSpriteFrame(fm, framename)
    return framename
end

function GameViewLayer:getDisableFrame(str)
    local framename = Tiger_Res.TIGER_BTN_DISABLE
    local Img_multiple = cc.Sprite:createWithSpriteFrameName(Tiger_Res.PNG_OF_BET_DISABLE)
    Img_multiple:setPosition(cc.p(0, 0))
        :setAnchorPoint(cc.p(0, 0))
        :setFlippedY(true)
    local lb = cc.Label:createWithBMFont(Tiger_Res.FONT_DIZHU_DISABLE, str)
    lb:setPosition(cc.p(158.75, 21))
        :setAnchorPoint(cc.p(0.5, 0.5))
        :setScaleY(-1)
    local renderTexture = cc.RenderTexture:create(243, 66, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
    renderTexture:begin()
    Img_multiple:visit()
    lb:visit()
    renderTexture:endToLua()
    local sp = renderTexture:getSprite()
    local fm = sp:getSpriteFrame()
    cc.SpriteFrameCache:getInstance():addSpriteFrame(fm, framename)
    return framename
end

function GameViewLayer:setLineEnable(enable)
    local fntstr = enable and Tiger_Res.FONT_LINE_NORMAL or Tiger_Res.FONT_LINE_DISABLE
    local imgstr = enable and Tiger_Res.PNG_OF_LINE_NORMAL or Tiger_Res.PNG_OF_LINE_DISABLE
    self.m_pImageLine:loadTexture(imgstr, ccui.TextureResType.plistType)

    self.m_pLbLineNum:setFntFile(fntstr)
end

function GameViewLayer:createSpineAni(key)
    local strJson = string.format("%s.json", key)
    local strAtlas = string.format("%s.atlas", key)
    return sp.SkeletonAnimation:create(strJson, strAtlas, 1)
end

function GameViewLayer:showLineViewEffect(ts)
    --滑动裁剪区域，制造射线效果
    self.m_pAniShap:setPosition(-1300, 0)
    self.m_pAniShap:runAction(cc.MoveBy:create(ts, cc.p(1300, 0)))
end 

--闪烁两侧的闪电
function GameViewLayer:blinkThunder()
    self.m_pShineNode:setVisible(true)
    self.m_pShineNode:runAction(cc.Blink:create(1.2, 5))
end
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
--@brief 切割字符串，并用“...”替换尾部
--@param sName:要切割的字符串
--@return nMaxCount，字符串上限,中文字为2的倍数
--@param nShowCount：显示英文字个数，中文字为2的倍数,可为空
--@note 函数实现：截取字符串一部分，剩余用“...”替换
function GameViewLayer.getDisplayNickNameInGame(sName, nMaxCount, nShowCount)
    if sName == nil or nMaxCount == nil then
        return
    end
    local sStr = sName
    local tCode = {}
    local tName = {}
    local nLenInByte = #sStr
    local nWidth = 0
    if nShowCount == nil then
       nShowCount = nMaxCount - 3
    end
    for i=1,nLenInByte do
        local curByte = string.byte(sStr, i)
        local byteCount = 0;
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        local char = nil
        if byteCount > 0 then
            char = string.sub(sStr, i, i+byteCount-1)
            i = i + byteCount -1
        end
        if byteCount == 1 then
            nWidth = nWidth + 1
            table.insert(tName,char)
            table.insert(tCode,1)
            
        elseif byteCount > 1 then
            nWidth = nWidth + 2
            table.insert(tName,char)
            table.insert(tCode,2)
        end
    end
    
    if nWidth > nMaxCount then
        local _sN = ""
        local _len = 0
        for i=1,#tName do
            _sN = _sN .. tName[i]
            _len = _len + tCode[i]
            if _len >= nShowCount then
                break
            end
        end
        sName = _sN .. "..."
    end
    return sName
end

function GameViewLayer.getFormatGoldAndNumber(n)
    local gold = tonumber(n) or 0
    local strFormatGold = string.format("%d.%02d", gold, (math.abs(0)%100))
    if -100 < gold and gold < 0 then
        strFormatGold = "-" .. strFormatGold
    end
    return n--strFormatGold
end

----------------------------------- server -----------------------------------
function GameViewLayer:onEventUpdate_intomoney(bufferData)
    print("onEventUpdate_intomoney________________")
    self.m_MoneySyncServer = bufferData
--    self:updataMoney()
end

function GameViewLayer:onEventCome(bufferData)
    if bufferData[1] == GlobalUserItem.tabAccountInfo.userid then
        self.m_MoneySyncServer = bufferData[6]
    end
    self:updataMoney()
end

function GameViewLayer:onEventEnter(bufferData)
    for key, var in ipairs(bufferData.members) do
        if var[1] == GlobalUserItem.tabAccountInfo.userid then
            self.m_MoneySyncServer = var[6]
        end
    end
    TigerDataMgr:getInstance():setMinBetNum(bufferData.unit_money)

--    local nLineNum = TigerDataMgr:getInstance():getLineNum()
--    local nBetMoney = TigerDataMgr:getInstance():getMinBetNum() * TigerDataMgr:getInstance():getBetNumIndex()
--    local nCurrentBetMoney = nLineNum * nBetMoney
--    self.m_pLbBetNum:setString(GameViewLayer.getFormatGoldAndNumber( nBetMoney ))
--    self.m_pLbCurTotalBetNum:setString(GameViewLayer.getFormatGoldAndNumber(nCurrentBetMoney))
    self:_updateData()

    self:updataMoney()

--    self:updateButtonOfSound(GlobalUserItem.bSoundAble)
--    self:updateButtonOfMusic(GlobalUserItem.bVoiceAble)
end

function GameViewLayer:onEventPool(bufferData)
    self.m_pRollNumber:rollToNum(bufferData.money*100)--TigerDataMgr:getInstance():getPrizePool())
end

function GameViewLayer:onEventStart(bufferData)
    self.session_id = bufferData[6]
end

function GameViewLayer:updataMoney()
    print("Lb_usrGold________________________________5")
    self.m_pLbUsrGold:setString(self.m_MoneySyncServer)
end
--------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------- 分界线 --------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

function GameViewLayer:unloadResource()
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("tbnn/effect/qiangzhuangpinshi_jiesuan/qiangzhuangpinshi_jiesuan.ExportJson")               --结算胜利失败特效

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
    if self.m_pLoopMsgHandler then
       cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_pLoopMsgHandler)
        self.m_pLoopMsgHandler = nil
    end
    ----------****------------------------------------***-------------------------------**----------------*-------------
    if self._ClockFun then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._ClockFun)
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
--    self:unloadResource()

    self.m_tabUserItem = {}
end

return GameViewLayer