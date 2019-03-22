--
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local module_pre = "game.yule.ddz.src"
local SettingLayer = appdf.req(module_pre .. ".views.layer.SettingLayer")
local LordScene_Events  = appdf.req(module_pre .. ".game.lord.scene.LordSceneEvent")
local LordSceneRes      = appdf.req(module_pre .. ".game.lord.scene.LordSceneRes")
local CardLayer         = appdf.req(module_pre .. ".game.lord.bean.CardLayer")
local LordPoker         = appdf.req(module_pre .. ".game.lord.bean.LordPoker")
local LordPokerSmall    = appdf.req(module_pre .. ".game.lord.bean.LordPokerSmall")
local LordDataMgr       = appdf.req(module_pre .. ".game.lord.bean.LordDataMgr")
local LordGameLogic     = appdf.req(module_pre .. ".game.lord.bean.LordGameLogic")
local QueryDialog       = appdf.req("app.views.layer.other.QueryDialog")
appdf.req("game.yule.ddz.src.models.helper")
local PlayerInfo = appdf.req(appdf.EXTERNAL_SRC .. "PlayerInfo")
cc.exports.scheduler  = appdf.req("game.yule.ddz.src.models.scheduler")
local scheduler = cc.exports.scheduler
local FloatMessage = cc.exports.FloatMessage
--local Effect = cc.exports.Effect
local SLFacade     = cc.exports.SLFacade

local GUI_PREFIX = "game/lord/gui-image/"

--界面位置
local POS_PREV = 0
local POS_SELF = 1
local POS_NEXT = 2

--闹钟位置
local CLOCK_CALL_SCORE = 1
local CLOCK_QIANG_SCORE = 4
local CLOCK_ADD_TIME = 2
local CLOCK_OUT_CARD = 3

--人物：地主/地主婆/农民/村姑
local LANDLORD_MALE   = 1
local LANDLORD_FEMALE = 2
local FARMER_MALE     = 3
local FARMER_FEMALE   = 4

--动作名：正常/赢/输
local ANIMATION_NAME = {
    [1] = { "animation2", "animation1", "animation3", },
    [2] = { "animation3", "animation1", "animation2", },
    [3] = { "animation3", "animation1", "animation2", },
    [4] = { "animation3", "animation1", "animation2", },
}

--动画文件：地主/地主婆/农民/村姑
local SPINE_NAME = {
    [1] = { "game/lord/effect/doudizhu_nandizhu/doudizhu_nandizhu.json", "game/lord/effect/doudizhu_nandizhu/doudizhu_nandizhu.atlas", },
    [2] = { "game/lord/effect/doudizhu_nvdizhu/doudizhu_nvdizhu.json",   "game/lord/effect/doudizhu_nvdizhu/doudizhu_nvdizhu.atlas",   },
    [3] = { "game/lord/effect/doudizhu_nongmin/doudizhu_nongmin.json",   "game/lord/effect/doudizhu_nongmin/doudizhu_nongmin.atlas",   },
    [4] = { "game/lord/effect/doudizhu_cungu/doudizhu4_cungu.json",      "game/lord/effect/doudizhu_cungu/doudizhu4_cungu.atlas",      },
}

local doudizhu4_dizhumao = "game/lord/effect/doudizhu4_dizhumao/doudizhu4_dizhumao.ExportJson"
local doudizhu4_chuntian = "game/lord/effect/doudizhu4_chuntian/doudizhu4_chuntian.ExportJson"
local doudizhu4_feiji = "game/lord/effect/doudizhu4_feiji/doudizhu4_feiji.ExportJson"
local doudizhu4_huojian = "game/lord/effect/doudizhu4_huojian/doudizhu4_huojian.ExportJson"
local doudizhu4_jiesuan = "game/lord/effect/doudizhu4_jiesuan/doudizhu4_jiesuan.ExportJson"
local doudizhu4_jingdeng = "game/lord/effect/doudizhu4_jingdeng/doudizhu4_jingdeng.ExportJson"
local doudizhu4_liandui = "game/lord/effect/doudizhu4_liandui/doudizhu4_liandui.ExportJson"
local doudizhu4_shunzi = "game/lord/effect/doudizhu4_shunzi/doudizhu4_shunzi.ExportJson"
local doudizhu4_zhadan = "game/lord/effect/doudizhu4_zhadan/doudizhu4_zhadan.ExportJson"
local doudizhu4_beijing = "game/lord/effect/doudizhu4_beijing/doudizhu4_beijing.ExportJson"
local doudizhu4_tishi = "game/lord/effect/doudizhu4_tishi/doudizhu4_tishi.ExportJson"
local doudizhu4_dengdai = "game/lord/effect/doudizhu4_dengdai/doudizhu4_dengdai.ExportJson"
local jueseqiehuan_1 = "game/lord/effect/jueseqiehuan_1/jueseqiehuan_1.ExportJson"

--动作：正常/赢/输
local ACTION_NORMAL = 1
local ACTION_WIN    = 2
local ACTION_LOSE   = 3

--春天/反春天
local INDEX_CHUNTIAN = 1
local INDEX_FANCHUNTIAN = 2

--春天/火箭/炸弹/飞机/连队/顺子
local ACTION_CHUNTIAN = 1
local ACTION_HUOJIAN = 2
local ACTION_ZHADAN = 3
local ACTION_FEIJI = 4
local ACTION_LIANDUI = 5
local ACTION_SHUNZI = 6

-- 最后一手牌动画延时时长
local DELAY_ANIMATION = {
    [CT_MISSILE_CARD]   = 1.8, --火箭
    [CT_BOMB_CARD]      = 1.5, --炸弹
    [CT_THREE_LINE]     = 1.3, --飞机（三连）
    [CT_THREE_TAKE_ONE] = 1.3, --飞机（三带一）
    [CT_THREE_TAKE_TWO] = 1.3, --飞机（三带二）
    [CT_DOUBLE_LINE]    = 1.0, --连对
    [CT_SINGLE_LINE]    = 1.0, --顺子
}

--提示图片
local TEXTURE_TIPS = {
    [1] = "gui-text-no-out.png",       --不要
    [2] = "gui-text-call-score-0.png", --不叫
    [3] = "gui-text-call-score-1.png", --壹分
    [4] = "gui-text-call-score-2.png", --俩分
    [5] = "gui-text-call-score-3.png", --叁分
    [6] = "gui-text-jiabei-ok.png",    --加倍
    [7] = "gui-text-jiabei-no.png",    --不加
}

--提示声音
local SOUNDS_TIPS = {
    [1] = "buyao",    --不要
    [2] = "bujiao",   --不叫
    [3] = "score1",   --壹分
    [4] = "score2",   --俩分
    [5] = "score3",   --叁分
    [6] = "jiabei",   --加倍
    [7] = "bujiabei", --不加
}


--提示类型
local PASS_CARD = 3
local WRONG_TYPE = 4

--pc时间
local TIME_DELAY_FOR_PC = 0.1

local GameViewLayer = class("GameViewLayer",function(scene)
    local gameViewLayer = display.newLayer()
    return gameViewLayer
end)

function GameViewLayer:ctor(scene)
    self:enableNodeEvents()
    self:init()
    self._scene = scene
end

function GameViewLayer:__init__() end

function GameViewLayer:init()
    self:initVar()
    self:initCSB()
    self:onNodeLoaded()
end

function GameViewLayer:initVar()

    self.g_gameDataLogic = LordDataMgr.getInstance()
    
    --变量
    self.m_bIsMoveMenu = false --弹出菜单变量
    self.m_bIsKill = false --被踢变量
    self.m_bEnterBackground = false --进入后台变量
    self.m_bIsExciting = false --播放音乐变量
    self.m_bAutoLastCard = false --最后一手牌
    self.m_bIsAnimationPlay = false
    self.m_bIsAnimationOver = false
    self.m_bIsMsgArrived = false
    self.m_tColorWin = cc.c3b(255, 165, 0)
    self.m_tColorLose = cc.WHITE

    --计数
    self.m_nTimeOutCount = 0 --操作超时计数
    self.m_fDelayOverAnim = 0 -- 最后一手牌的动画时长
    self.m_nClockCount = {} --倒计时
    self.m_nProgressBar = {} --显示用倒计时

    --定时器
    self.m_scheduleClock = {} --倒计时定时器
    self.m_shakeUpdate = nil --震屏定时器
    self.m_scheduleProgressBar = nil --倒计时

    --表
    self.event_ = {}
    self.event_game_ = {}
    self.m_llPlayerGold = {} --玩家金币
    self.m_pSpinePlayer = {} --玩家动画
    self.m_pAnimChange = {} --变身动画
    self.m_pAnimationCard = {} --游戏动画
    self.m_pAnimationOver = nil --结算动画
    self.m_pLordCard = {} --底牌
    self.m_pCardLayer = nil --自己牌
    self.m_showOutCard = {} --出牌
    self.m_posOfLogo = {} --logo坐标
    self.m_posOfEffect = {} --effect坐标
    self.m_pNodesClockBar = {} --倒计时bar
    self.m_posOfOutCard = {} --出牌坐标
--------------------------------------------------------------------------------------------------
    self.position = 0
    self.readytime = 0
    self.call_times = 0
    self.deskinfo = {}
    self.memberinfos = {}
    self.FapaiData = {}
    self.hidecards = {}
    self.num = 0 
    self.istrue = true
end

function GameViewLayer:initCSB()
    
    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)

    --csb
    self.m_pathUI = cc.CSLoader:createNode("game/yule/ddz/res/game/lord/LordGameUI.csb")
    self.m_pathUI:addTo(self.m_rootUI)

    --layer
    self.m_pRootUI = self.m_pathUI:getChildByName("Panel_root")
    self.m_pRootUI:setPositionX(145 - (1624 - display.size.width) / 2)

    --界面：背景/桌子/游戏/底部/按钮/结束/倍数/等待/开始
    self.m_pNodeBg = self.m_pRootUI:getChildByName("Node_bg")
    self.m_pNodeTable = self.m_pRootUI:getChildByName("Node_table")
    self.m_pNodePlay = self.m_pRootUI:getChildByName("Node_play")
    self.m_pNodeBottom = self.m_pRootUI:getChildByName("Node_bottom")
    self.m_pNodeMenu = self.m_pRootUI:getChildByName("Node_menu")
    self.m_pNodeOver = self.m_pRootUI:getChildByName("Node_over")
    self.m_pNodeBeishu = self.m_pRootUI:getChildByName("Node_beishu")
    self.m_pNodeWait = self.m_pRootUI:getChildByName("Node_wait")
    self.m_pNodeStart = self.m_pRootUI:getChildByName("Node_start")

    --桌子层：玩家动画node
    self.m_pNodePlayer = {}
    for i = 0, 2 do
        self.m_pNodePlayer[i] = self.m_pNodeTable:getChildByName("Node_" .. i)
    end

    --游戏层：牌/底牌/计数/提示/分数/叫分/加倍/出牌/地主标志/托管标志/离线标志/倒计时/报警/其他/动画
    self.m_pNodeBezier = self.m_pNodePlay:getChildByName("Node_bezier")
    self.m_pNodeCards = self.m_pNodePlay:getChildByName("Node_cards")
    self.m_pNodeCount = self.m_pNodePlay:getChildByName("Node_count")
    self.m_pNodeLock = self.m_pNodePlay:getChildByName("Node_lock")
    self.m_pNodeTips = self.m_pNodePlay:getChildByName("Node_tips")
    self.m_pNodeCall = self.m_pNodePlay:getChildByName("Node_call")
    self.m_pNodeCall_0 = self.m_pNodePlay:getChildByName("Node_call_0")
    self.m_pNodeJiaBei = self.m_pNodePlay:getChildByName("Node_jiabei")
    self.m_pNodeOutCard = self.m_pNodePlay:getChildByName("Node_out")
    self.m_pNodeLogoLord = self.m_pNodePlay:getChildByName("Node_lord")
    self.m_pNodeLogoDouble = self.m_pNodePlay:getChildByName("Node_double")
    self.m_pNodeLogoRobot = self.m_pNodePlay:getChildByName("Node_robot")
    self.m_pNodeLogoOffline = self.m_pNodePlay:getChildByName("Node_offline")
    self.m_pNodeLogoAlert = self.m_pNodePlay:getChildByName("Node_alert")
    self.m_pNodeClock = self.m_pNodePlay:getChildByName("Node_clock")
    self.m_pNodeOther = self.m_pNodePlay:getChildByName("Node_other")
    self.m_pNodeEffect = self.m_pNodePlay:getChildByName("Node_effect")
    self.m_pNodeScore = self.m_pNodePlay:getChildByName("Node_score")
    self.m_pNodeRobot = self.m_pNodePlay:getChildByName("Node_force")
--    self.m_pNodeLeft = self.m_pNodePlay:getChildByName("Node_histrory")
    --贝塞尔node
    self.m_pNodesBezier = {}
    for i = 0, 2 do
        self.m_pNodesBezier[i] = self.m_pNodeBezier:getChildByName("Node_" .. i)
    end

    --玩家牌node
    self.m_pNodesCard = {}
    for i = 0, 2 do
        self.m_pNodesCard[i] = self.m_pNodeCards:getChildByName("Node_" .. i)
    end
    self.m_pNodesCardSelf = self.m_pNodeCards:getChildByName("Node_self")
    self.m_pBtnTouch = self.m_pNodeCards:getChildByName("m_pBtnTouch")
    self.m_pBtnTouch2 = self.m_pNodeCards:getChildByName("m_pBtnTouch2")

    --计数node
    self.m_pNodesCount = {}
    for i = 0, 2 do
        self.m_pNodesCount[i] = self.m_pNodeCount:getChildByName("Node_" .. i)
    end

    --底牌node
    self.m_pLockCards = {}
    for i = 0, 2 do
        self.m_pLockCards[i] = self.m_pNodeLock:getChildByName("card_" .. i)
    end
    self.m_pLockScore = self.m_pNodeLock:getChildByName("score")

--    --记牌器
--    self.m_pBtnLeft = self.m_pNodeLeft:getChildByName("Button_1")
--    self.m_pLayerLeft = self.m_pNodeLeft:getChildByName("Panel_1"):getChildByName("Image_9")
--    self.m_pLabelLeft = {}
--    for i = 1, 15 do
--        self.m_pLabelLeft[i] = self.m_pLayerLeft:getChildByName("BitmapFontLabel_" .. i)
--    end
    --提示image
    self.m_pSpriteTips = {}
    for i = 0, 4 do
        self.m_pSpriteTips[i] = self.m_pNodeTips:getChildByName("Image_" .. i)
    end
    self.m_bujiao = self.m_pNodeTips:getChildByName("Image"):setVisible(false)
    --叫分button
    self.m_pBtnCallScore = {}
    for i = 0, 1 do
        self.m_pBtnCallScore[i] = self.m_pNodeCall:getChildByName("m_pBtnCall" .. i)
    end
    self.m_pBtnQiangScore = {}
    for i = 0, 1 do
        self.m_pBtnQiangScore[i] = self.m_pNodeCall_0:getChildByName("m_pBtnCall" .. i)
    end
    --加倍/不加载button
    self.m_pBtnJiabei = self.m_pNodeJiaBei:getChildByName("Button_ok")
    self.m_pBtnBuJiabei = self.m_pNodeJiaBei:getChildByName("Button_no")

    --不出/提示/要不起/出牌button
    self.m_pBtnNoOut = self.m_pNodeOutCard:getChildByName("m_pBtnNoOut")
    self.m_pBtnTips = self.m_pNodeOutCard:getChildByName("m_pBtnTips")
    self.m_pBtnPass = self.m_pNodeOutCard:getChildByName("m_pBtnPass")
    self.m_pBtnOut = self.m_pNodeOutCard:getChildByName("m_pBtnOut")

    --地主logo
    self.m_pNodesLogoLord = {}
    for i = 0, 2 do
        self.m_pNodesLogoLord[i] = self.m_pNodeLogoLord:getChildByName("Node_" .. i)
    end

    --加倍logo
    self.m_pNodesLogoDouble = {}
    for i = 0, 2 do
        self.m_pNodesLogoDouble[i] = self.m_pNodeLogoDouble:getChildByName("Node_" .. i)
    end

    --托管logo
    self.m_pNodesLogoRobot = {}
    for i = 0, 2 do
        self.m_pNodesLogoRobot[i] = self.m_pNodeLogoRobot:getChildByName("Node_" .. i)
    end

    --离线logo
    self.m_pNodesLogoOffline = {}
    for i = 0, 2 do
        self.m_pNodesLogoOffline[i] = self.m_pNodeLogoOffline:getChildByName("Node_" .. i)
    end

    --警报node
    self.m_pNodesLogoAlert = {}
    for i = 0, 2 do
        self.m_pNodesLogoAlert[i] = self.m_pNodeLogoAlert:getChildByName("Node_" .. i)
    end

    --闹钟node
    self.m_pNodesClock = {}
    for i = 0, 2 do
        self.m_pNodesClock[i] = self.m_pNodeClock:getChildByName("Node_" .. i)
    end

    --其他用户信息框node
    self.m_pNodesOther = {}
    for i = 0, 2 do
        self.m_pNodesOther[i] = self.m_pNodeOther:getChildByName("Node_" .. i)
    end

    --动画node
    self.m_pNodesEffect = {}
    for i = 0, 2 do
        self.m_pNodesEffect[i] = self.m_pNodeEffect:getChildByName("Node_" .. i)
    end

    --托管button
    self.m_pBtnNoRobot = self.m_pNodeRobot:getChildByName("m_pBtnNoRobot")
    self.m_pSpriteForce = self.m_pNodeRobot:getChildByName("m_pSpriteForce")

    --底部层：名字/金币/倍数/底分/托管
    --名字/金币/倍数/底分node
    self.m_pNodeName = self.m_pNodeBottom:getChildByName("Node_name")
    self.m_pNodeGold = self.m_pNodeBottom:getChildByName("Node_gold")
    self.m_pNodeBei = self.m_pNodeBottom:getChildByName("Node_bei")
    self.m_pNodeDifen = self.m_pNodeBottom:getChildByName("Node_difen")

    --名字/金币/倍数/底分label
    self.m_pLbUserName = self.m_pNodeName:getChildByName("m_pLabelName")
    self.m_pLbUserGold = self.m_pNodeGold:getChildByName("m_pLabelGold")
    self.m_pLbBeishu = self.m_pNodeBei:getChildByName("m_pLabelBeishu")
    self.m_pLbDifen = self.m_pNodeDifen:getChildByName("m_pLabelDifen")
--    self.m_pImgUserVip = self.m_pNodeName:getChildByName("Image_vip")
    --倍数按钮
    self.m_pBtnBeiOpen = self.m_pNodeBei:getChildByName("m_pBtnBeiOpen")
    self.m_pBtnBeiClose = self.m_pNodeBei:getChildByName("m_pBtnBeiClose")

    --菜单层：固定按钮/菜单按钮
    --固定按钮
    self.m_pBtnExit = self.m_pNodeMenu:getChildByName("m_pBtnExit")
    self.m_pBtnPop = self.m_pNodeMenu:getChildByName("m_pBtnPop")
    self.m_pBtnPush = self.m_pNodeMenu:getChildByName("m_pBtnPush")
    self.m_pBtnRobot = self.m_pNodeMenu:getChildByName("m_pBtnRobot")

    --菜单按钮
    self.m_pNodePop = self.m_pNodeMenu:getChildByName("Node_pop")
    self.m_pSpirtePop = self.m_pNodePop:getChildByName("Image_bg")
    self.m_pBtnPush2 = self.m_pNodePop:getChildByName("m_pBtnPush2")
    self.m_pBtnSound = self.m_pNodePop:getChildByName("m_pBtnSound")
    self.m_pBtnMusic = self.m_pNodePop:getChildByName("m_pBtnMusic")
    self.m_pBtnRule = self.m_pNodePop:getChildByName("m_pBtnRule")

    --结束层：动画/信息/结算/按钮
    self.m_pNodeInfo = self.m_pNodeOver:getChildByName("Node_info")
    self.m_pNodeWin = self.m_pNodeOver:getChildByName("Node_win")
    self.m_pNodeContinue = self.m_pNodeOver:getChildByName("Node_continue")

    --得分label
    self.m_pLabelEndScore = {}
    for i = 0, 2 do
        self.m_pLabelEndScore[i] = self.m_pNodeScore:getChildByName("m_pLabelEnd" .. i)
    end

    --背景/地主/名字/倍数/得分/倍数按钮
    self.m_pImageBg = self.m_pNodeInfo:getChildByName("Image_bg")
    self.m_pSpEndLord = {}
    self.m_pLbEndName = {}
    self.m_pLbEndBei = {}
    self.m_pLbEndGold = {}
    for i = 0, 2 do
        self.m_pSpEndLord[i] = self.m_pNodeInfo:getChildByName("m_pSpriteLord" .. i)
        self.m_pLbEndName[i] = self.m_pNodeInfo:getChildByName("m_pLabelName" .. i)
        self.m_pLbEndBei[i] = self.m_pNodeInfo:getChildByName("m_pLabelBei" .. i)
        self.m_pLbEndGold[i] = self.m_pNodeInfo:getChildByName("m_pLabelGold" .. i)
    end
    self.m_pBtnBeishuOpen = self.m_pNodeInfo:getChildByName("m_pBtnBeishuOpen")
    self.m_pBtnBeishuClose = self.m_pNodeInfo:getChildByName("m_pBtnBeishuClose")

    --按钮
    self.m_pBtnEndOver = self.m_pNodeContinue:getChildByName("m_pBtnOver")
    self.m_pBtnEndClose = self.m_pNodeContinue:getChildByName("m_pBtnClose")
    self.m_pBtnEndStart = self.m_pNodeContinue:getChildByName("m_pBtnStart")

    --倍数层：结算btn/1底分/2炸弹/3春天/4加倍/5总倍数
    self.m_pLabelsJiesuan = {}
    for i = 1, 5 do
        self.m_pLabelsJiesuan[i] = self.m_pNodeBeishu:getChildByName("Text_" .. i)
    end

    --开始层：开始按钮
    self.m_pBtnNewSwitch = self.m_pNodeStart:getChildByName("m_pBtnSwitch")
    self.m_pBtnNewStart = self.m_pNodeStart:getChildByName("m_pBtnStart")

end

function GameViewLayer:onEnter()

    if GlobalUserItem.bVoiceAble then
        ExternalFun.playGameBackgroundAudio("game/lord/sound/MusicEx_Normal.mp3")
    end

    self:stopAllScheduleGlobal()
--    self:startGameEvent()
--    self:startLayerEvent()
    self:initGameInfo()
    self:flyIn(true)
end

function GameViewLayer:onExit()
    self:stopAllScheduleGlobal()
    self:stopGameEvent()
    self:stopLayerEvent()
    self:stopAllActions()
    self:stopAllAnimation()

    PlayerInfo.getInstance():setSitSuc(false)
    LordDataMgr.getInstance():Clean()

    if self.m_bEnterBackground == false then
        --释放动画
        for i, name in pairs(LordSceneRes.vecReleaseAnim) do
            ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(name)
        end
        --释放整图
        for i, name in pairs(LordSceneRes.vecReleasePlist) do
            display.removeSpriteFrames(name[1], name[2])
        end
        -- 释放背景图
        for _, strFileName in pairs(LordSceneRes.vecReleaseImg) do
            display.removeImage(strFileName)
        end
        --释放音频
        for i, name in pairs(LordSceneRes.vecReleaseSound) do
            AudioEngine.unloadEffect(name)
        end
    end
end

function GameViewLayer:startGameEvent()

end

function GameViewLayer:stopGameEvent()

end

function GameViewLayer:startLayerEvent()

end

function GameViewLayer:stopLayerEvent()

end

function GameViewLayer:stopAllScheduleGlobal()

    --震屏定时器
    if self.m_shakeUpdate then
        scheduler.unscheduleGlobal(self.m_shakeUpdate)
        self.m_shakeUpdate = nil
    end

    --玩家定时器
    for i = 0, 2 do
        if self.m_scheduleClock[i] then
            scheduler.unscheduleGlobal(self.m_scheduleClock[i])
            self.m_scheduleClock[i] = nil
        end
    end

    --倒计时显示定时器
    if self.m_scheduleProgressBar then
        scheduler.unscheduleGlobal(self.m_scheduleProgressBar)
        self.m_scheduleProgressBar = nil
    end
end

function GameViewLayer:startProgressBarSchedule()
    
    if self.m_scheduleProgressBar then
        scheduler.unscheduleGlobal(self.m_scheduleProgressBar)
        self.m_scheduleProgressBar = nil
    end

    if self.m_scheduleProgressBar == nil then
        self.m_scheduleProgressBar = scheduler.scheduleUpdateGlobal(handler(self, self.onUpdateProgressBar))
    end
end

function GameViewLayer:onUpdateProgressBar(dt)
    for i = 0, 2 do
        if self.m_nProgressBar[i][1] > 0 and self.m_nProgressBar[i][2] > 0 then
            self.m_nProgressBar[i][1] = self.m_nProgressBar[i][1] - dt
            self:onUpdateClockBar(i)
        else
            self.m_nProgressBar[i][1] = 0
            self.m_nProgressBar[i][2] = 0
        end
    end
end

function GameViewLayer:stopProgressBarSchedule()
    
    if self.m_scheduleProgressBar then
        scheduler.unscheduleGlobal(self.m_scheduleProgressBar)
        self.m_scheduleProgressBar = nil
    end
end

function GameViewLayer:stopAllAnimation()
    if self.m_pAnimationLord then
        self.m_pAnimationLord:removeFromParent()
        self.m_pAnimationLord = nil
    end
    if self.m_pAnimationOver then
        self.m_pAnimationOver:removeFromParent()
        self.m_pAnimationOver = nil
    end
    for i = ACTION_CHUNTIAN, ACTION_SHUNZI do
        if self.m_pAnimationCard[i] then
            self.m_pAnimationCard[i]:removeFromParent()
            self.m_pAnimationCard[i] = nil
        end
    end
end

function GameViewLayer:onNodeLoaded()

    -- 界面显示 ----------------------------
    self.m_pNodeStart:setVisible(false)
    self.m_pNodeWait:setVisible(false)
    self.m_pNodePlay:setVisible(false)
    self.m_pNodeOver:setVisible(false)

    --Node_play
    self.m_pNodeCall:setVisible(false)
    self.m_pNodeCall_0:setVisible(false)
    self.m_pNodeJiaBei:setVisible(false)
    self.m_pNodeOutCard:setVisible(false)

    --标志
    self.m_pNodeLogoLord:setVisible(true)
    self.m_pNodeLogoDouble:setVisible(true)
    self.m_pNodeLogoRobot:setVisible(true)
    self.m_pNodeLogoOffline:setVisible(true)
    self.m_pNodeLogoAlert:setVisible(true)
    self.m_pNodeClock:setVisible(true)
    for i = 0, 2 do
        self.m_pNodesLogoLord[i]:setVisible(false)
        self.m_pNodesLogoDouble[i]:setVisible(false)
        self.m_pNodesLogoRobot[i]:setVisible(false)
        self.m_pNodesLogoOffline[i]:setVisible(false)
        self.m_pNodesLogoAlert[i]:setVisible(false)
        self.m_pNodesClock[i]:setVisible(false)
    end

    --底牌
    for i = 0, 2 do
        self.m_pLockCards[i]:setVisible(false)
    end

    --其他玩家
    for i = 0, 2, 2 do
        self.m_pNodesOther[i]:setVisible(false)
    end

    --牌数
    for i = 0, 2 do
        self:onUpdateCountShow(i, false)
    end

    --提示
    for i = 0, 4 do
        self:onUpdateTipsOfPlayer(i, false)
    end

    --Node_buttom
    self.m_pNodeScore:setVisible(false)
    self.m_pNodeRobot:setVisible(false)

    --Node_menu
    self.m_pBtnPush:setVisible(false)
    self.m_pBtnRobot:setVisible(false)
    self.m_pNodePop:setVisible(false)

    --clock pos
    self.m_pNodeCall:getChildByName("Sprite_clock"):setVisible(false)
    self.m_pNodeCall_0:getChildByName("Sprite_clock"):setVisible(false)
    self.m_pNodeJiaBei:getChildByName("Sprite_clock"):setVisible(false)
    self.m_pNodeOutCard:getChildByName("Sprite_clock"):setVisible(false)

    --Node_beishu
    self.m_pNodeBeishu:setVisible(false)
    self.m_pBtnBeiClose:setVisible(false)

    --Node_force
    self.m_pSpriteForce:setVisible(false)

        --Node_left
--    self.m_pBtnLeft:setVisible(false)
--    self.m_pLayerLeft:setVisible(false)
    -- 界面显示 --------------------------------------

    -- 绑定按钮 --------------------------------------
    --离开/弹出菜单/收回菜单
    self.m_pBtnExit:addClickEventListener(handler(self, self.onReturnClicked))
    self.m_pBtnPop:addClickEventListener(handler(self, self.onPopClicked))
    self.m_pBtnPush:addClickEventListener(handler(self, self.onPushClicked))
    self.m_pBtnPush2:addClickEventListener(handler(self, self.onPushClicked))
    --规则/音乐/音效
    self.m_pBtnRule:addClickEventListener(handler(self, self.onRuleClicked))
    self.m_pBtnMusic:addClickEventListener(handler(self, self.onMusicClicked))
    self.m_pBtnSound:addClickEventListener(handler(self, self.onSoundClicked))
    --叫分/加倍/不加倍/不出/提示/要不起/出牌/托管/取消托管
    self.m_pBtnCallScore[0]:addClickEventListener(handler(self, self.onCallScoreClicked))
    self.m_pBtnCallScore[1]:addClickEventListener(handler(self, self.onCallScoreClicked))
    self.m_pBtnQiangScore[0]:addClickEventListener(handler(self, self.onQiangScoreClicked))
    self.m_pBtnQiangScore[1]:addClickEventListener(handler(self, self.onQiangScoreClicked))
    self.m_pBtnJiabei:addClickEventListener(handler(self, self.onJiaBeiClicked))
    self.m_pBtnBuJiabei:addClickEventListener(handler(self, self.onJiaBeiClicked))
    self.m_pBtnTouch:addClickEventListener(handler(self, self.onBlankClicked))
    self.m_pBtnTouch2:addClickEventListener(handler(self, self.onBlankClicked))
    self.m_pBtnNoOut:addClickEventListener(handler(self, self.onPassClicked))
    self.m_pBtnTips:addClickEventListener(handler(self, self.onPromptClicked))
    self.m_pBtnPass:addClickEventListener(handler(self, self.onPassClicked))
    self.m_pBtnOut:addClickEventListener(handler(self, self.onOutCardClicked))
    self.m_pBtnRobot:addClickEventListener(handler(self, self.onRobotClicked))
    self.m_pBtnNoRobot:addClickEventListener(handler(self, self.onCancelRobotClicked))
    --结算
    self.m_pBtnEndClose:addClickEventListener(handler(self, self.onCloseClicked))
    self.m_pBtnEndStart:addClickEventListener(handler(self, self.onContinueClicked))
    self.m_pBtnEndOver:addClickEventListener(handler(self, self.onReturnClicked))
    --倍数
    self.m_pBtnBeiOpen:addClickEventListener(handler(self, self.onBeishuOpenFromBottonClicked))
    self.m_pBtnBeiClose:addClickEventListener(handler(self, self.onBeishuCloseFromBottonClicked))
    self.m_pBtnBeishuOpen:addClickEventListener(handler(self, self.onBeishuOpenFromJiesuanClicked))
    self.m_pBtnBeishuClose:addClickEventListener(handler(self, self.onBeishuCloseFromJiesuanClicked))
    --开始
    self.m_pBtnNewStart:addClickEventListener(handler(self, self.onStartClicked))
    self.m_pBtnNewSwitch:addClickEventListener(handler(self, self.onStartClicked))
--    --记牌器
--    self.m_pBtnLeft:addClickEventListener(handler(self, self.onLeftClicked))
    -- 绑定按钮 --------------------------------------

    -- 更新按钮 --------------------------------------
    self:onUpdateMusicButton(GlobalUserItem.bVoiceAble)
    self:onUpdateSoundButton(GlobalUserItem.bSoundAble)
    -- 更新按钮 --------------------------------------

    -- 加载界面 -------------------------------------------
    -- 底牌layer
    for i = 0, 2 do
        self.m_pLordCard[i] = LordPokerSmall:create()
        self.m_pLordCard[i]:setAnchorPoint(0, 0)
        self.m_pLordCard[i]:setPosition(self.m_pLockCards[i]:getPosition())
        self.m_pLordCard[i]:setBack(true)
        self.m_pLordCard[i]:addTo(self.m_pNodeLock)
    end

    -- 自己牌layer
    self.m_pCardLayer = CardLayer:createNormal()
--    self.m_pCardLayer:setIgnoreAnchorPointForPosition(false)
    self.m_pCardLayer:setContentSize(self.m_pNodesCardSelf:getContentSize())
    self.m_pCardLayer:setPosition(0, 0)
    self.m_pCardLayer:setAnchorPoint(0, 0)
    self.m_pCardLayer:setEventCallBack(self)
    self.m_pCardLayer:addTo(self.m_pNodesCardSelf, Z_ORDER_BACKGROUND)

    -- 出牌layer
    for i = 0, 2 do
        self.m_showOutCard[i] = CardLayer:createSmall()
        self.m_showOutCard[i]:setIndexPos(i)
        self.m_showOutCard[i]:ignoreAnchorPointForPosition(false)
        self.m_showOutCard[i]:setContentSize(self.m_pNodesCard[i]:getContentSize())
        self.m_showOutCard[i]:setAnchorPoint(cc.p(0, 0))
        self.m_showOutCard[i]:setPosition(cc.p(0, 0))
        self.m_showOutCard[i]:setVisible(false)
        self.m_showOutCard[i]:setCanTouch(false)
        self.m_showOutCard[i]:addTo(self.m_pNodesCard[i], order)
    end

    -- 标志坐标pos
    for i = 0, 2 do
        self.m_posOfLogo[i] = {}
        self.m_posOfLogo[i][1] = cc.p(self.m_pNodesLogoLord[i]:getPosition())
        self.m_posOfLogo[i][2] = cc.p(self.m_pNodesLogoDouble[i]:getPosition())
        self.m_posOfLogo[i][3] = cc.p(self.m_pNodesLogoRobot[i]:getPosition())
        self.m_posOfLogo[i][4] = cc.p(self.m_pNodesLogoOffline[i]:getPosition())
    end

    --特效坐标pos
    for i = 0, 2 do
        self.m_posOfEffect[i] = cc.p(self.m_pNodesEffect[i]:getPosition())
    end

    --出牌位置
    for i = 0, 2 do
        self.m_posOfOutCard[i] = cc.p(self.m_showOutCard[i]:getPosition())
    end

    --倒计时bar
    for i = 0, 2 do
        local sprite = cc.Sprite:createWithSpriteFrameName(GUI_PREFIX .. "gui-icon-clock-white.png")
        local circleProgressBar = cc.ProgressTimer:create(sprite) --创建进度条
        circleProgressBar:setType(cc.PROGRESS_TIMER_TYPE_RADIAL) --设置类型
        circleProgressBar:setReverseDirection(true) --设置顺时针
        circleProgressBar:setPercentage(0) --设置进度
        self.m_pNodesClockBar[i] = circleProgressBar
        self.m_pNodesClock[i]:addChild(circleProgressBar)
        self.m_pNodesClock[i]:getChildByName("Sprite"):setVisible(false)
    end

    -- 加载界面 -------------------------------------------

    -- 更新界面 -------------------------------------------
    self:onUpdateUserName()
    self:onUpdateUserScore()
    self:onUpdateBeishu()
    self:onUpdateBeishuInfo()
    self:onUpdateDifen()
    self:onUpdateBankerCard(false)
    self:onUpdateBankerScore(false)
    -- 更新界面 -------------------------------------------

    -- 位置设置 -----------------------------------------
    --位置
    self.m_pNodePop:setPositionX(0)
    self.m_pLockScore:setLocalZOrder(10)
    self.m_pBtnNewStart:setPositionY(370)
    self.m_pBtnNewSwitch:setPositionY(370)

    --全面屏
    if LuaUtils.isIphoneXDesignResolution() then
        local offset1= -70
        --离开/姓名/金币/上家信息框
        self:tryFixNodeForIphoneX(self.m_pBtnExit,  offset1)
        self:tryFixNodeForIphoneX(self.m_pNodeName, offset1)
        self:tryFixNodeForIphoneX(self.m_pNodeGold, offset1)
        self:tryFixNodeForIphoneX(self.m_pNodesOther[0], offset1)
        self:tryFixNodeForIphoneX(self.m_pLabelEndScore[0], offset1)
        --弹出/弹入/托管/底分/倍数/下家信息框
        local offset2 = 70
        self:tryFixNodeForIphoneX(self.m_pBtnPop, offset2)
        self:tryFixNodeForIphoneX(self.m_pBtnPush, offset2)
        self:tryFixNodeForIphoneX(self.m_pBtnRobot, offset2)
        self:tryFixNodeForIphoneX(self.m_pNodeDifen, offset2)
        self:tryFixNodeForIphoneX(self.m_pNodeBei, offset2)
        self:tryFixNodeForIphoneX(self.m_pNodesOther[2], offset2)
        self:tryFixNodeForIphoneX(self.m_pLabelEndScore[2], offset2)
        --菜单/规则/音效/音乐
        local offset3 = 70
        self:tryFixNodeForIphoneX(self.m_pSpirtePop, offset3)
        self:tryFixNodeForIphoneX(self.m_pBtnRule, offset3)
        self:tryFixNodeForIphoneX(self.m_pBtnSound, offset3)
        self:tryFixNodeForIphoneX(self.m_pBtnMusic, offset3)
        local offset4 = 50
        --上家牌数/下家牌数
        self:tryFixNodeForIphoneX(self.m_pNodesCount[0], 0 - offset4)
        self:tryFixNodeForIphoneX(self.m_pNodesCount[2], offset4)
        
        self:initbeujing(display.width/2 - 145,display.height/2)
    else
        self:initbeujing(display.width/2,display.height/2)
    end

    --预设位置
    self:flyIn(false)
    -- 位置设置 -----------------------------------------
end

function GameViewLayer:initbeujing(posX,posY)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(doudizhu4_beijing)  
    local armature = ccs.Armature:create("doudizhu4_beijing")  
    armature:setPosition(posX,posY)          
    self.m_pNodeBg:addChild(armature)
    armature:getAnimation():playWithIndex(0)
end

function GameViewLayer:__onMenuClicked__() end

--弹出菜单
function GameViewLayer:onPopClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")

    --测试代码
    --self:test_code()

    if self.m_bIsMoveMenu then
        return
    end
    self.m_bIsMoveMenu = true
    
    self.m_pNodePop:stopAllActions()
    local place = cc.Place:create(cc.p(0, 330))
    local show = cc.Show:create()
    local sp = cc.Spawn:create(
        cc.EaseBackOut:create(cc.MoveTo:create(0.3, cc.p(0, 0))),
        cc.FadeIn:create(0.3))
    local call = cc.CallFunc:create(function()
        self.m_pBtnPop:setVisible(false)
        self.m_pBtnPush:setVisible(true)
        self.m_bIsMoveMenu = false
    end)
    local seq = cc.Sequence:create(place, show, sp, call)
    self.m_pNodePop:runAction(seq)
end

--收回菜单
function GameViewLayer:onPushClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")

    if self.m_bIsMoveMenu then
        return
    end
    self.m_bIsMoveMenu = true
    
    self.m_pNodePop:stopAllActions()
    local place = cc.Place:create(cc.p(0, 0))
    local sp = cc.Spawn:create(
        cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(0, 330))),
        cc.FadeOut:create(0.3))
    local call = cc.CallFunc:create(function()
        self.m_pBtnPop:setVisible(true)
        self.m_pBtnPush:setVisible(false)
        self.m_bIsMoveMenu = false
    end)
    local hide = cc.Hide:create()
    local seq = cc.Sequence:create(place, sp, call, hide)
    self.m_pNodePop:runAction(seq)
end

--声音
function GameViewLayer:onSoundClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")
    if self.m_bIsMoveMenu then
        return
    end
    if GlobalUserItem.bSoundAble then
        GlobalUserItem.setSoundAble(false)
        self:onUpdateSoundButton(false)
    else
        GlobalUserItem.setSoundAble(true)
        self:onUpdateSoundButton(true)
    end
end

--音乐
function GameViewLayer:onMusicClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")
    
    if self.m_bIsMoveMenu then
        return
    end

    if GlobalUserItem.bVoiceAble then
        GlobalUserItem.setVoiceAble(false)
        self:onUpdateMusicButton(false)
    else
        GlobalUserItem.setVoiceAble(true)
        ExternalFun.playGameBackgroundAudio("game/lord/sound/MusicEx_Normal.mp3")
        self:onUpdateMusicButton(true)
    end
end

--返回
function GameViewLayer:onReturnClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")
    self._scene:onQueryExitGame()
end

--规则
function GameViewLayer:onRuleClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")
--    SettingLayer.create():addTo(self.m_rootUI, 100)
    local layer = SettingLayer:new()
    layer:addTo(self.m_pRootUI , 999)
end

--记牌器
--function GameViewLayer:onLeftClicked()
--    ExternalFun.playGameEffect("public/sound/sound-button.mp3")

--    -- 防连点
--    local nCurTime = cc.exports.gettime()
--    if self.m_nLastTouchTime and nCurTime - self.m_nLastTouchTime <= 0.15 then
--        return
--    else
--        self.m_nLastTouchTime = nCurTime
--    end

--    if self.m_pLayerLeft:isVisible() then
--        self:showLeftCard(false)
--    else
--        --已经结束
--        if self.g_gameDataLogic:getGameStatus() ~= GS_T_PLAY then
--            self:showLeftCard(true)

--        --已经获取过记牌器数据
--        elseif self.g_gameDataLogic:IsGetLeftCard() then
--            self:onUpdateLeftCard()
--            self:showLeftCard(true)

--        else --没获取数据
--            CMsgLord:getInstance():sendLeftCard()
--        end
--    end
--end
--开始
function GameViewLayer:onStartClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(doudizhu4_dengdai)  
    local armature = ccs.Armature:create("doudizhu4_dengdai")  
    armature:setPosition(667,375)          
    self.m_pNodeWait:addChild(armature)
    armature:getAnimation():playWithIndex(0)
    self.m_pNodeWait:setVisible(true)
    self:onStartLocal()
end

--托管
function GameViewLayer:onRobotClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")
    
    self:onRobotLocal()

    --隐藏按钮
    self.m_pNodeRobot:setVisible(true)
    self.m_pBtnRobot:setVisible(false)
end

--取消托管
function GameViewLayer:onCancelRobotClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")
    
    self:onRobotCancelLocal()

    --隐藏按钮
    self.m_pNodeRobot:setVisible(false)
    self.m_pBtnRobot:setVisible(true)
end

--叫分
function GameViewLayer:onCallScoreClicked(sender)
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")

    if self.m_pNodeCall:isVisible() == false then
        return
    end

    local tag = sender:getTag()

    --CMsgLord:getInstance():sendCallScore(tag)
    self:onCallScoreLocal(tag)

    --隐藏按钮
    self.m_pNodeCall:setVisible(false)
end

--叫分
function GameViewLayer:onQiangScoreClicked(sender)
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")

    if self.m_pNodeCall_0:isVisible() == false then
        return
    end

    local tag = sender:getTag()

    --CMsgLord:getInstance():sendCallScore(tag)
    self:onQiangScoreLocal(tag)

    --隐藏按钮
    self.m_pNodeCall_0:setVisible(false)
end

--加倍
function GameViewLayer:onJiaBeiClicked(sender)
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")

    if self.m_pNodeJiaBei:isVisible() == false then
        return
    end

    local tag = sender:getTag()
    
    --CMsgLord.getInstance():sendAddTimes(tag)
    self:onAddTimesLocal(tag)

    --隐藏按钮
    self.m_pNodeJiaBei:setVisible(false)
end

--过牌
function GameViewLayer:onPassClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")

    if self.m_pNodeOutCard:isVisible() == false then
        return
    end

    --CMsgLord:getInstance():sendPassCard()
    self:onPassCardLocal()

    --隐藏按钮
    self.m_pNodeOutCard:setVisible(false)
end

--提示
function GameViewLayer:onPromptClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")

    if self.g_gameDataLogic:hasOutCard() then
        self:promptOutCard() --提示牌
        self:judgeOutCard() --判断牌
    else
        self:onPassCardLocal() --过牌
    end
end

--出牌
function GameViewLayer:onOutCardClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")

    if self.m_pNodeOutCard:isVisible() == false then
        return
    end

    if self.g_gameDataLogic:hasOutCard() then
        local cbCardData, cbCardCount = self.m_pCardLayer:GetShootCard()

        --校验数据
        local bValid = LordGameLogic:getInstance():CheckCardData(cbCardData, cbCardCount)
        if not bValid then 
            FloatMessage:getInstance():pushMessageDebug("LANDLORD_0") --牌数据错误
            return
        end

        --校验牌型
        local cardtype = LordGameLogic:getInstance():GetCardType(cbCardData,cbCardCount)
        if cardtype <= CT_ERROR or CT_MISSILE_CARD < cardtype then 
            FloatMessage:getInstance():pushMessageDebug("LANDLORD_1") --出牌类型错误
            return
        end

        --不符合规则
        local bRight = self.g_gameDataLogic:VerdictOutCard(cbCardData, cbCardCount)
        if not bRight then
            self:onUpdateTipsOfPlayer(WRONG_TYPE, true)
            return
        end

        --先出牌，再发送出牌
        self:onOutCardLocal(cbCardData, cbCardCount)

    else --不要
        self:onPassCardLocal()
    end

    --隐藏按钮
    self.m_pNodeOutCard:setVisible(false)
end

--收牌
function GameViewLayer:onBlankClicked()

    if self.g_gameDataLogic:getGameStatus() == GS_T_PLAY then
        local cbCardData, cbCardCount = self.m_pCardLayer:GetShootCard()
        if cbCardCount > 0 then
            self.m_pCardLayer:setAllNotShoot()
        end
    end
end

--继续
function GameViewLayer:onContinueClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")

    self.m_pNodeBeishu:setVisible(false)
    self:onStartLocal()
end

--关闭结算
function GameViewLayer:onCloseClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")

    self.m_pNodeBeishu:setVisible(false)
    self:onShowGameOver()
end

--打开倍数
function GameViewLayer:onBeishuOpenFromBottonClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")

    self.m_pNodeBeishu:setPosition(self.m_pNodeBei:getPositionX() - 60, 10)
    if self.m_pNodeBeishu:isVisible() then
        self.m_pNodeBeishu:setVisible(false)
        self.m_pBtnBeiClose:setVisible(false)
    else
        self.m_pNodeBeishu:setVisible(true)
        self.m_pBtnBeiClose:setVisible(true)
    end
end

function GameViewLayer:onBeishuOpenFromJiesuanClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")

    self.m_pNodeBeishu:setPosition(667, 375)
    if self.m_pNodeBeishu:isVisible() then
        self.m_pNodeBeishu:setVisible(false)
        self.m_pBtnBeishuClose:setVisible(false)
    else
        self.m_pNodeBeishu:setVisible(true)
        self.m_pBtnBeishuClose:setVisible(true)
    end
end

--关闭倍数
function GameViewLayer:onBeishuCloseFromBottonClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")
    self.m_pNodeBeishu:setVisible(false)
    self.m_pBtnBeiClose:setVisible(false)
end

function GameViewLayer:onBeishuCloseFromJiesuanClicked()
    ExternalFun.playGameEffect("public/sound/sound-button.mp3")
    self.m_pNodeBeishu:setVisible(false)
    self.m_pBtnBeishuClose:setVisible(false)
end

-----------------------------------------------------------
function GameViewLayer:__onMsgEvent__() end --监听事件

function GameViewLayer:onMsgGameOutCard()
    print("出牌", os.date("%c", os.time()))
    self:onOutCard(false, false)
end

function GameViewLayer:onMsgLeftCard()
    
    self:onUpdateLeftCard()
end
-----------------------------------------------------------------
function GameViewLayer:__onLayerLogic__() end --界面逻辑

--退出游戏(返回大厅)
function GameViewLayer:onMoveExitView()

    PlayerInfo:getInstance():setChairID(INVALID_CHAIR)
    PlayerInfo:getInstance():setTableID(INVALID_TABLE)
    PlayerInfo:getInstance():setSitSuc(false)
    PlayerInfo:getInstance():setIsQuickStart(false)
    PlayerInfo.getInstance():setIsReLoginInGame(false)
    PlayerInfo.getInstance():setIsGameBackToHall(true)
    PlayerInfo:getInstance():setIsGameBackToHallSuc(false)
    
    --返回大厅
    SLFacade:dispatchCustomEvent(Public_Events.Load_Entry)
end

--移动节点
function GameViewLayer:tryFixNodeForIphoneX(node, offsetX, offsetY)
    local posX, posY = node:getPosition()
    if offsetX then
        node:setPositionX(posX + offsetX)
    end
    if offsetY then
        node:setPositionY(posY + offsetY)
    end
end

--进场动画
function GameViewLayer:flyIn(bFly)
    self:onOpenGame(self.m_pNodeTable,  1, 0, -500, bFly)
    self:onOpenGame(self.m_pNodeStart,  1, 0, -500, bFly)
    self:onOpenGame(self.m_pBtnExit,    2, 0,  100, bFly)
    self:onOpenGame(self.m_pBtnPop,     2, 0,  100, bFly)
    self:onOpenGame(self.m_pBtnRobot,   2, 0,  100, bFly)
end

function GameViewLayer:onOpenGame(node, index, offsetX, offsetY, bFly)

    if PlayerInfo.getInstance():getTableID() == INVALID_TABLE
    and PlayerInfo.getInstance():getChairID() == INVALID_CHAIR
    then
        if bFly then
            local nTime = 0.25
            local pAction = cc.Sequence:create(
                cc.DelayTime:create(nTime * (index - 1)),
                cc.EaseBackOut:create(cc.MoveBy:create(nTime, cc.p(0 - offsetX, 0 - offsetY))))
            node:runAction(pAction)
        else
            local posStop = cc.p(node:getPosition())
            local posStart = cc.pAdd(posStop, cc.p(offsetX, offsetY))
            node:setPosition(posStart)
        end
    end
end

function GameViewLayer:LayerEventCallBack(arg) --CardLayer调用
    if self.g_gameDataLogic:getGameStatus() == GS_T_PLAY then
        ExternalFun.playGameEffect("game/lord/sound/SpecSelectCard.mp3")
        self:judgeOutCard()
    end
end

function GameViewLayer:initGameInfo()

    --更新标志
    for i = 0, 2 do
        self:onUpdateLogoLord(i, false)
        self:onUpdateLogoDouble(i, false)
        self:onUpdateLogoRobot(i, false)
        self:onUpdateLogoOffline(i, false)
        self:onUpdateLogoAlert(i, false)
        self:onUpdateClockCount(i, false)
    end

    --清空显示倒计时
    for i = 0, 2 do
        self.m_nProgressBar[i] = {}
        self.m_nProgressBar[i][1] = 0
        self.m_nProgressBar[i][2] = 0
    end

    --更新底部信息
    self:onUpdateUserName()
    self:onUpdateUserScore()
    self:onUpdateBeishu(0)
    self:onUpdateBeishuInfo()
    self:onUpdateDifen()

    --已经开始
--    if self.g_gameDataLogic:getGameStart() then
--        return

--    --已坐下，发送配置
--    elseif PlayerInfo.getInstance():getChairID() ~= INVALID_CHAIR
--    then
----        CMsgLord:getInstance():sendGameOption()
--        self:onShowGamePlay()

--    --没坐下
--    elseif  PlayerInfo.getInstance():getChairID() == INVALID_CHAIR
--    then
----        快速开始，发送匹配
--        if PlayerInfo.getInstance():getIsQuickStart() then
----            PlayerInfo:getInstance():setIsQuickStart(false)
----            CMsgLord:getInstance():sendMatch()
--            self:onReady()
--        else --显示开始
            self:onShowGameFree()
--        end
--    end

end

--准备
function GameViewLayer:onReady()
    self:onShowGameReady()

    for i = 0, 2 do
        self:showOutCardLayer(i, false)
    end

    for i = 0, 2 do
        self:onUpdateLogoLord(i, false)
        self:onUpdateLogoDouble(i, false)
        self:onUpdateLogoRobot(i, false)
        self:onUpdateLogoRobot(i, false)
        self:onUpdateLogoAlert(i, false)
    end

    for i = 0, 2, 2 do
        self:onUpdateOtherPlayerShow(i, false)
    end

    self:onUpdateBeishu(0)
    self:onUpdateBeishuInfo()
    self:onUpdateDifen()

        -- 底牌隐藏
--    self.m_pBtnLeft:setVisible(false)
--    self.m_pLayerLeft:setVisible(false)
    -- 初始动画
--    PlayerInfo.getInstance():setGender(GlobalUserItem.tabAccountInfo.sex)
    local gender = PlayerInfo.getInstance():getGender()
    local who = gender == 0 and FARMER_MALE or FARMER_FEMALE
    self:onLoadPlayerSpine(POS_SELF, who)
    self:onUpdatePlayerAction(POS_SELF, ACTION_NORMAL)

    self.m_pCardLayer:SetGray(false)
    self.m_pCardLayer:SetBanker(false)
    self.m_pCardLayer:ClearGray()
end

function GameViewLayer:event_GameState(dataBuffer)     -- 自身进入房间
    print("进入!!!")
    
    self.deskinfo = dataBuffer.deskinfo  
    if dataBuffer.deskinfo.calltype == 1 then
        print("1111111111")
    end
    self.memberinfos = dataBuffer.memberinfos
    for key,player  in pairs(self.memberinfos) do
        if player.uid == GlobalUserItem.tabAccountInfo.userid then
            PlayerInfo.getInstance():setChairID(player.position)
        end
    end
    for key,player  in ipairs(self.memberinfos) do
        if player.uid ~= GlobalUserItem.tabAccountInfo.userid then
            local n = self.g_gameDataLogic:SwitchViewChairID(player.position)
            self:onUpdateOtherPlayerGold(n, player.into_money)
            self:onUpdateOtherPlayerName(n, player.nickname)
        end 
    end
end

function GameViewLayer:updataPlayerPanpel(dataBuffer)  -- 有玩家进入
    print("进入")
    table.insert(self.memberinfos,dataBuffer.memberinfo)
    for key,player  in ipairs(self.memberinfos) do
        if player.uid ~= GlobalUserItem.tabAccountInfo.userid then
            local n = self.g_gameDataLogic:SwitchViewChairID(player.position)
            self:onUpdateOtherPlayerGold(n, player.into_money)
            self:onUpdateOtherPlayerName(n, player.nickname)
        end
    end


end

function GameViewLayer:onUserLeave(dataBuffer)     -- 有玩家离开
    print("离开")
    for key,player  in ipairs(self.memberinfos) do
        if player.uid == dataBuffer then
            if player.uid ~= GlobalUserItem.tabAccountInfo.userid then
                local n = self.g_gameDataLogic:SwitchViewChairID(player.position)
                self:onUpdateOtherPlayerGold(n, "")
                self:onUpdateOtherPlayerName(n, "")
            end
            table.remove(self.memberinfos,key)
        end
    end

    
end

function GameViewLayer:updataMyMoney(dataBuffer)   -- 跟新自己背包呢
    print("更新金币")
    self:onUpdateUserScore(dataBuffer)
end

function GameViewLayer:updataFaPai(dataBuffer)   -- 发牌
    print("发牌")
    self.m_pNodeWait:setVisible(false)
--    self.FapaiData = dataBuffer
    for k,v in ipairs(self.memberinfos) do
        if v.uid == dataBuffer.banker then
            self.g_gameDataLogic:setCurrentUser(v.position)
        end
    end
    for i=0,#dataBuffer.mycards - 1 do
        self.g_gameDataLogic.m_cbHandCardData[i] = self:ChangeNumPai( dataBuffer.mycards[i+1] )
    end

    self:onShowGamePlay()
    self:onStart(false)
    self:doSomethingLater(function() self:onStart(true) end, 2)
    
end
--{visible_card=32 mycards={} task_id=8 banker=77164409 timeout=12 task_reward={} }

function GameViewLayer:updataReady(dataBuffer)   -- 其他玩家准备
    print("其他玩家准备")

end

function GameViewLayer:updataReadyTime(dataBuffer)   -- 准备时间
    print("准备时间")
    
    self.readytime = dataBuffer
end

function GameViewLayer:onPlayerShow(dataBuffer)      --叫地主
    print("叫地主")

    self.nextone = dataBuffer.nextone            -- 下个玩家
    self.callpt = dataBuffer.callpt              -- 当前叫分0/1
    self.call_times = dataBuffer.call_times      -- 叫的次数
    self.double = dataBuffer.double              -- 当前总倍数
    self.banker = dataBuffer.banker              -- 新庄家
    self.thisone = dataBuffer.thisone            -- dang qian wan jia, 下一个如果跟当前人一样就表示抢地主结束
    self.g_gameDataLogic:setBankerScore(1)
    self.g_gameDataLogic.m_iMuliple = dataBuffer.double
    self:onUpdateBeishu()
    for k,v in ipairs(self.memberinfos) do
        if v.uid == self.thisone then
            self.g_gameDataLogic:setCurrentUser(v.position)
        end
        if v.uid == self.nextone  then
            self.position = v.position
        end
    end
    if dataBuffer.nextone == GlobalUserItem.tabAccountInfo.userid then
        if dataBuffer.call_times >= 1 then
            self.m_pNodeCall_0:setVisible(true)
            self.m_pNodeCall:setVisible(false)
        else
            self.m_pNodeCall:setVisible(true)
            self.m_pNodeCall_0:setVisible(false)
        end
    else
        self.m_pNodeCall_0:setVisible(false)
        self.m_pNodeCall:setVisible(false)
    end
    if dataBuffer.thisone == dataBuffer.nextone then
        self:onCallScore(true)
    else
        self:onCallScore(false)
    end
    

end
--{nextone=77164409 callpt=0 call_times=0 double=1 banker=2000000 timeout=12 thisone=2000000 }
function GameViewLayer:StartRaise(dataBuffer)            -- 开始加倍
    print("开始加倍")
    for k,v in ipairs(self.memberinfos) do
        if v.uid == dataBuffer.banker then
            self.g_gameDataLogic:setBankerUser(v.position)
            self.g_gameDataLogic:setCurrentUser(v.position)
            self.g_gameDataLogic:setTurnWiner(v.position)
            self.g_gameDataLogic.m_cbHandCardCount[v.position] = 20
            self.g_gameDataLogic.m_SearchCardResult.cbSearchCount = 20
        end
    end
    for i = 0 ,#dataBuffer.hide_cards - 1 do
        self.g_gameDataLogic.m_cbBankerCard[i] = self:ChangeNumPai( dataBuffer.hide_cards[i+1] )
        if dataBuffer.banker == GlobalUserItem.tabAccountInfo.userid then
            self.g_gameDataLogic.m_cbHandCardData[17+i] = self:ChangeNumPai( dataBuffer.hide_cards[i+1] )   
        end
    end
--    local viewChair = 0
--    for k,v in ipairs(self.memberinfos) do
--        if v.uid == dataBuffer.banker then
--            viewChair = self.g_gameDataLogic:SwitchViewChairID(v.position)
--        end
--    end
    self.g_gameDataLogic:setIsAddTimesStatus(1)
    self:onBanker(false)
end
--{hide_cards={} double=1 banker=68905577 timeout=10 thisone=77164409 }
function GameViewLayer:updataRaise(dataBuffer)            -- 加倍
    print("加倍")

--    if GlobalUserItem.tabAccountInfo.userid == dataBuffer.nextone then
--        self.g_gameDataLogic:setAddTimeLocal(1)
--    else
--        self.g_gameDataLogic:setAddTimeLocal(0)
--    end
    self.g_gameDataLogic.m_wAddTimeChairID = dataBuffer.thisone
--    if GlobalUserItem.tabAccountInfo.userid == dataBuffer.thisone and self.istrue == true then
--        self:onBanker(true)
--        self.istrue = false
--    end
    
    if dataBuffer.nextone == dataBuffer.thisone then
        self.g_gameDataLogic.m_cbAddTimeCanOutCard = 1
        self:onAddTimes()
    end
    
    
end
--{nextone=1134319 israise=0 double=1 timeout=10 thisone=98936090 }
function GameViewLayer:ShowCards(dataBuffer)            -- 明牌
    print("明牌")
end

function GameViewLayer:PassCards(dataBuffer)            -- 过牌
    print("过牌")
    local pPassCard = {
                            wCurrentUser = 0,
                            wPassCardUser = 0,
                            cbTurnOver = 0,
                       }
    self.num = self.num + 1
    if self.num == 2  then
        pPassCard.cbTurnOver = 1
        self.num = 0
    end
    for k , v in ipairs(self.memberinfos) do
        if v.uid == dataBuffer.thisone then
            pPassCard.wPassCardUser = v.position
        end
        if v.uid == dataBuffer.nextone then
            pPassCard.wCurrentUser = v.position  
        end
    end
    self.g_gameDataLogic:OnPassCard(pPassCard)
    self:onOutCard(true, false)
end
--{nextone=77164409 thisone=98775463 timeout=15 mycards={} }
function GameViewLayer:PlayCards(dataBuffer)            -- 出牌
    print("出牌")
    self.num = 0
    self.PlayPai = dataBuffer
    local pOutCard = {
                        wCurrentUser = 0,
                        wOutCardUser = 0,
                        cbCardData = {},
                        cbCardCount = 0,
                    }
    for k , v in ipairs(self.memberinfos) do
        if v.uid == dataBuffer.thisone then
            pOutCard.wOutCardUser = v.position
        end
        if v.uid == dataBuffer.nextone then
            pOutCard.wCurrentUser = v.position
        end
    end
    for i = 0 , #dataBuffer.put_cards - 1 do
        pOutCard.cbCardData[i] = self:ChangeNumPai( dataBuffer.put_cards[i+1] )
    end
    pOutCard.cbCardCount = #dataBuffer.put_cards
    self.g_gameDataLogic:OnOutCard(pOutCard)
    self:onOutCard_Before(true, false, false, "msg")
    self:onOutCard(false, true)
end
--{nextone=77164409 timeout=15 put_cards={} hold_num=4 double=12 mycards={} put_type=4 thisone=98928663 }{[1]=13 [2]=26 [3]=9 [4]=22 [5]=35 }
function GameViewLayer:updataDesk(dataBuffer)            -- 重进后刷新牌桌
    print("重进后刷新牌桌")
    self:onShowGamePlay()
    for i = 0, 2 do      
        if i == 0 or i == 2 then
            self.m_pNodesOther[i]:setVisible(true)
        end     
    end
    self.m_pLbUserGold:setString(GlobalUserItem.tabAccountInfo.into_money)
--    self:onUpdateNodeShow(self.m_pBtnNoRobot, true)
    local msg = {}
    --游戏变量
    msg.cbTimeOutCard = 30--dataBuffer.timeout
    msg.cbBombCount = 0
    msg.lCellScore = dataBuffer.double		--单元积分
    msg.wBankerUser = dataBuffer.banker		--庄家用户
    msg.wCurrentUser = dataBuffer.thisone		--当前玩家

    --出牌信息
    msg.wTurnWiner = dataBuffer.lastone		--胜利玩家
    msg.cbTurnCardCount = #dataBuffer.showed_cards	--出牌数目
    msg.cbTurnCardData = {}                     --出牌数据
    if dataBuffer.showed_cards[1] ~= nil then        
        for i = 0, #dataBuffer.showed_cards - 1 do
            msg.cbTurnCardData[i] = self:ChangeNumPai( dataBuffer.showed_cards[i+1] )             
        end
    end
    msg.cbHandCardData = {}
    for i = 0 , #dataBuffer.mycards - 1 do
        msg.cbHandCardData[i] = self:ChangeNumPai( dataBuffer.mycards[i+1] )
    end
    msg.cbBankerCard = {}
    if dataBuffer.hide_cards[1] ~= nil then      
        for i = 0, GAME_PLAYER_LANDLORD-1 do
            msg.cbBankerCard[i] = self:ChangeNumPai( dataBuffer.hide_cards[i+1] )
        end
        self:doSomethingLater(function()
        self:onUpdateBankerCard(true) --底牌
        end,1)
    else
        self:onUpdateBankerCard(false) --底牌
    end
    msg.cbHandCardCount = {}
    for i = 0, GAME_PLAYER_LANDLORD-1 do
        msg.cbHandCardCount[i] = dataBuffer.current_state[i+1].hold_num
    end
    self.g_gameDataLogic:initGameScene(msg)

    for k,v in ipairs(self.memberinfos) do
        if v.uid == msg.wCurrentUser then
            local viewChair = self.g_gameDataLogic:SwitchViewChairID(v.position)
            self:resetClock(viewChair, CLOCK_OUT_CARD, "onOutCard(出牌倒计时)")
        end
        local chair = self.g_gameDataLogic:SwitchViewChairID(v.position)
        self:onUpdateCountShow(chair, true)
        if dataBuffer.banker == v.uid then
            local viewchair = self.g_gameDataLogic:SwitchViewChairID(v.position)
            self.m_pNodesLogoLord[viewchair]:setVisible(true)
        end
        
    end
    self.m_pLbDifen:setString(10)
    self.m_pCardLayer:setVisible(true)
    self.m_pNodeCards:setVisible(true)
--    self.m_pNodeOutCard:setVisible(true)
    for i = 0, 2   do
        self:onChangeCartoon(i, E_GARTOON_STATE.NORMAL, false)
    end
end

function GameViewLayer:updataManage(dataBuffer)            -- 托管
    print("托管")
    if dataBuffer.uid == GlobalUserItem.tabAccountInfo.userid and dataBuffer.managed == true then
        self.m_pNodeRobot:setVisible(true)
    end
end
--{uid=77164409 offline=true managed=false }
function GameViewLayer:GameOverTime(dataBuffer)            -- 结算
    print("结算")
    self.istrue = true
    self.g_gameDataLogic:OnConclude(dataBuffer)
    local cbHandCardData = {}   
    for i = 0, 2  do
        if self.g_gameDataLogic.m_pGameConclude.cbCardCount[i] > 0 then
            for j = 0 ,self.g_gameDataLogic.m_pGameConclude.cbCardCount[i] - 1 do
                table.insert(cbHandCardData ,self:ChangeNumPai( self.g_gameDataLogic.m_pGameConclude.cbHandCardData[i][j+1] ) )
            end   
        end
    end
    for i=0,#cbHandCardData - 1 do
        self.g_gameDataLogic.m_pGameConclude.cbHandCardData[i] = cbHandCardData[i+1]
    end
    for i = 0 ,#dataBuffer.user_win_money[PlayerInfo.getInstance():getChairID()+1].cards - 1 do
        self.g_gameDataLogic.m_cbHandCardData[i] = self:ChangeNumPai( dataBuffer.user_win_money[PlayerInfo.getInstance():getChairID()+1].cards[i+1] )
    end

    self:onConclude()
end
--{bomb_times=0 user_win_money={} double=1 rocket_times=0 is_spring=false system_win=0 winner=68918296 }{winmoney=-20 tax=0 cards={} uid=77164409 }
function GameViewLayer:ChangeNumPai(cardata)
    local realnum = 0;
    if cardata <= 10 then
        realnum = cardata + 3
    elseif cardata == 11 or cardata == 12 then
        realnum = cardata - 10
    elseif cardata >= 13 and cardata <= 23 then
        realnum = cardata + 6
    elseif cardata == 24 or cardata == 25 then
        realnum = cardata - 7
    elseif cardata >= 26 and cardata <= 36 then
        realnum = cardata + 9
    elseif cardata == 37 or cardata == 38 then
        realnum = cardata - 4
    elseif cardata >= 39 and cardata <= 49 then
        realnum = cardata + 12
    elseif cardata == 50 or cardata == 51 then
        realnum = cardata - 1
    elseif cardata == 52 or cardata == 53 then
        realnum = cardata + 26
    end
    return realnum
end

function GameViewLayer:RecoveryNumPai(cardata)
    local realnum = 0;
    if cardata <= 13 and cardata >= 3 then
        realnum = cardata - 3
    elseif cardata == 1 or cardata == 2 then
        realnum = cardata + 10
    elseif cardata >= 19 and cardata <= 29 then
        realnum = cardata - 6
    elseif cardata == 17 or cardata == 18 then
        realnum = cardata + 7
    elseif cardata >= 35 and cardata <= 45 then
        realnum = cardata - 9
    elseif cardata == 33 or cardata == 34 then
        realnum = cardata + 4
    elseif cardata >= 51 and cardata <= 61 then
        realnum = cardata - 12
    elseif cardata == 49 or cardata == 50 then
        realnum = cardata + 1
    elseif cardata == 78 or cardata == 79 then
        realnum = cardata - 26
    end
    return realnum
end

function GameViewLayer:onStart(isStart)
    --更新用户性别
    self.g_gameDataLogic:updateUserGender()

    --重设数据
    self.m_fDelayOverAnim = 0
    self.m_nTimeOutCount = 0

    --开始刷新倒计时
    self:startProgressBarSchedule()

    --界面显示
    self:onShowGamePlay()
    
    self.m_pNodeCall:setVisible(false)
    self.m_pNodeCall_0:setVisible(false)
    self.m_pNodeJiaBei:setVisible(false)
    self.m_pNodeOutCard:setVisible(false)
    self.m_pNodeRobot:setVisible(false)
    self.m_pNodeScore:setVisible(false)
    self.m_pBtnRobot:setVisible(false)
    self.m_pNodeBeishu:setVisible(false)
    
    self.m_pNodeCards:setVisible(true)
    self.m_pNodeCount:setVisible(true)
    self.m_pNodeLock:setVisible(true)
    self.m_pNodeTips:setVisible(true)
    self.m_pNodeClock:setVisible(true)
    self.m_pNodeEffect:setVisible(true)
    self.m_pNodeOther:setVisible(true)

    for i = 0, 2 do
        self:showOutCardLayer(i, false)
        self:onUpdateClockCount(i, false)
        self:onUpdateLogoLord(i, false)
        self:onUpdateLogoDouble(i, false)
        self:onUpdateLogoRobot(i, false)
        self:onUpdateLogoOffline(i, false)
        self:onUpdateTipsOfPlayer(i, false)
    end

    self:onUpdateBankerScore(false) --底分
    self:onUpdateBankerCard(false) --底牌
    self:onUpdateBeishu(0) --倍数
    self:onUpdateBeishuInfo()

    --初始化人物动画
    for i = 0, 2 do 
--        local tableID = PlayerInfo.getInstance():getTableID()
--        local user = CUserManager.getInstance():getUserInfoByChairID(tableID, i);
        local viewChair = self.g_gameDataLogic:SwitchViewChairID(i)
        if viewChair ~= 1 then
--            self.m_llPlayerGold[viewChair] = self.memberinfos[i+1].into_money
            self:onUpdateOtherPlayerShow(viewChair, true)
--            self:onUpdateOtherPlayerGold(viewChair, self.memberinfos[i+1].into_money)
--            self:onUpdateOtherPlayerName(viewChair, self.memberinfos[i+1].nickname)
            self:onChangeCartoon(i, E_GARTOON_STATE.NORMAL, false)
        end
        
    end

    --牌数
    self:onUpdateCountShow(POS_PREV, true)
    self:onUpdateCountShow(POS_NEXT, true)

    --按钮
    self:onUpdateButtonEnable(self.m_pBtnCallScore[0], true)
    self:onUpdateButtonEnable(self.m_pBtnCallScore[1], true)
    self:onUpdateButtonEnable(self.m_pBtnQiangScore[0], true)
    self:onUpdateButtonEnable(self.m_pBtnQiangScore[1], true)
    self:onUpdateButtonEnable(self.m_pBtnNoOut, true)
    self:onUpdateButtonEnable(self.m_pBtnTips, true)
    self:onUpdateButtonEnable(self.m_pBtnPass, true)
    self:onUpdateButtonEnable(self.m_pBtnOut, true)
--    --记牌器
--    self:resetLeftCard()
    self:dispatchCard(isStart)
end

--叫分
function GameViewLayer:onCallScore(isStart)
    
    self:onShowGameCallScore()

    self:onUpdateBankerCard(false) --底牌
    self:onUpdateBankerScore(false) --底分
    
    --更新倍数
    self:onUpdateBeishu(1)
    self:onUpdateBeishuInfo()

    --更新加倍标识
    for i = 0, 2 do
        self:onShowPlayerLogo(i)
    end

    --已经开始
    if isStart then
        
    else --进行中
        local score = self.g_gameDataLogic:getCurrentUser()
        local viewChair = self.g_gameDataLogic:SwitchViewChairID(score)
        local path = ""
        if self.callpt == 0 and self.call_times == 0 then
            -- bujiao
            path = GUI_PREFIX .. TEXTURE_TIPS[2]
            self.m_pSpriteTips[viewChair]:setSpriteFrame(path)
            self.m_pSpriteTips[viewChair]:setVisible(true)
        elseif self.callpt == 1 and self.call_times == 1 then
            -- jiaodizhu
            path = "game/lord/gui/jdz.png"
            self.m_pSpriteTips[viewChair]:setTexture(path)
            self.m_pSpriteTips[viewChair]:setVisible(true)
        elseif self.callpt == 1 and self.call_times > 1 then
            -- qiangdizhu
            path = "game/lord/gui/qdz.png"
            self.m_pSpriteTips[viewChair]:setTexture(path)
            self.m_pSpriteTips[viewChair]:setVisible(true)
        elseif self.callpt == 0 and self.call_times >= 1 then
            -- buqiang
            path = "game/lord/gui/bq.png"
            self.m_pSpriteTips[viewChair]:setTexture(path)
            self.m_pSpriteTips[viewChair]:setVisible(true)
        end  
        local currentChair = self.g_gameDataLogic:SwitchViewChairID(self.position)
        self:resetClock(currentChair, CLOCK_CALL_SCORE, "onShowCallScore(叫分倒计时)")
--        self:onUpdateTipsType(viewChair, nScoreType)
--        self:onUpdateTipsOfPlayer(viewChair, bScoreShow)
    end
end

--确定地主
function GameViewLayer:onBanker(isStart)

    --自己是地主不显示加倍
    local banker = self.g_gameDataLogic:getBankerUser()
    local chairId = self.g_gameDataLogic:GetMeChairID()
    if self.g_gameDataLogic:getAddTimeLocal() == 1 then
        self:onShowGameAddTime(true)
    else
        self:onShowGameAddTime(false)
    end

    self:onUpdateNodeShow(self.m_pBtnRobot, false)
    self:onUpdateNodeShow(self.m_pNodeRobot, false)

    --叫分结束
    for i = 0, 2 do
        self:onUpdateTipsOfPlayer(i, false)
    end

    for i = PASS_CARD, WRONG_TYPE do
        self:onUpdateTipsOfPlayer(i, false)
    end

    for i = 0, 2 do
        self:onShowPlayerLogo(i) --加倍标识
    end
    
    self:onUpdateBankerScore(true) --底分
    self:onUpdateBankerCard(true) --底牌
    self:onUpdateBeishu()
    self:onUpdateBeishuInfo()

    local banker = self.g_gameDataLogic:getBankerUser()
    local bankerChair = self.g_gameDataLogic:SwitchViewChairID(banker)
--    local isRobot = self.g_gameDataLogic:getUserRobot(banker) > 0
    self:onChangeCartoon(banker, E_GARTOON_STATE.NORMAL, not isStart)
    
    self.m_pCardLayer:setCanTouch(true)

    if not isStart then
        self:playSoundDelay("game/lord/sound/Special_querendizhu.mp3", 0)
        self:startDispatchLord(bankerChair)
    end

    for i  = 0, 2 do
        local viewChair = self.g_gameDataLogic:SwitchViewChairID(i)
        local cardCount = self.g_gameDataLogic.m_cbHandCardCount[i]
        self:onUpdateCountLabel(viewChair, cardCount)
    end
    
    if self.g_gameDataLogic:bankIsMe() then
        local chair = PlayerInfo.getInstance():getChairID()
        local cardData = self.g_gameDataLogic.m_cbHandCardData
        local cardCount = self.g_gameDataLogic.m_cbHandCardCount[chair]
        self.m_pCardLayer:SetCardData(cardData, cardCount)
        self.m_pCardLayer:SetBanker(true)
        self.g_gameDataLogic:SortCardListOfSelf()
        if not isStart then
            self.m_pCardLayer:downShoot(self.g_gameDataLogic.m_cbBankerCard, 3)
        end
    else
        self.m_pCardLayer:SetBanker(false)
    end

    if self.g_gameDataLogic:getIsAddTimesStatus() == 1 then   

        --显示加倍按钮
        if self.g_gameDataLogic:bankIsMe() == false
        and self.g_gameDataLogic.m_iAddTimes[self.g_gameDataLogic:GetMeChairID()] == 0 then
            self.m_pNodeJiaBei:setVisible(true)
        end

        --加倍倒计时
        for i = 0, 2 do
            local viewChair = self.g_gameDataLogic:SwitchViewChairID(i)
            if self.g_gameDataLogic.m_iAddTimes[i] == 0 and banker ~= i then
                self:startClock(viewChair, CLOCK_ADD_TIME, "onBanker(加倍倒计时)")
            else
                self:stopClock(viewChair)
            end
        end
    else
        self.g_gameDataLogic:setGameStatus(GS_T_PLAY);

        --首出倒计时
        local index = self.g_gameDataLogic:curentUserChairId()
        self:resetClock(index, CLOCK_OUT_CARD, "onBanker(首出倒计时)")
    end
    
    self:onChangeCartoon(banker, E_GARTOON_STATE.NORMAL, not isStart)
end

--加倍
function GameViewLayer:onAddTimes()

    local banker = self.g_gameDataLogic:getBankerUser()
    local chairId = self.g_gameDataLogic:GetMeChairID()
    local current = self.g_gameDataLogic.m_wAddTimeChairID
    local addTimes = self.g_gameDataLogic.m_iAddTimeCurrentTime
    local canOutCard = self.g_gameDataLogic.m_cbAddTimeCanOutCard

    --自己是地主，不显示加倍按钮
    if 
    --自己已表态，不显示加倍按钮
     (chairId == current and self.g_gameDataLogic:getAddTimeLocal() > 0)
    then
        self:onShowGameAddTime(false)
    end

    --其他玩家加倍，播放加倍，重置计时
    if (chairId ~= current)
    --自己超时没表态，播放加倍，重置计时
    or (chairId == current and self.g_gameDataLogic:getAddTimeLocal() == 0)
    then
        local cbGender = self.g_gameDataLogic.m_cbGender[current]
        local viewChair = self.g_gameDataLogic:SwitchViewChairID(current)
        local nAddTimes = self:getAddTimeType(addTimes)
        local isDouble = addTimes == 2 
        self:onShowAddTime(viewChair, nAddTimes, cbGender, isDouble)
        self:stopClock(viewChair)
    end

    --出错时，未隐藏出牌
    for i = 0 , 2 do
        self:showOutCardLayer(i, false)
    end

    self:onUpdateBeishu()
    self:onUpdateBeishuInfo()

    --开始出牌
    if canOutCard > 0  then
        self.g_gameDataLogic:setIsAddTimesStatus(0) --结束加倍阶段
        self.g_gameDataLogic:setGameStatus(GS_T_PLAY) --出牌阶段

        if self.g_gameDataLogic:bankIsMe() then
            self.m_pCardLayer:setCanTouch(true)
            self.m_pNodeCall:setVisible(false)
            self.m_pNodeCall_0:setVisible(false)
            self.m_pNodeJiaBei:setVisible(false)
            self.m_pNodeOutCard:setVisible(true)
        end

        --隐藏过牌
        self:onUpdateNodeShow(self.m_pBtnNoOut, true)
        self:onUpdateNodeShow(self.m_pBtnPass, false)
        self:onUpdateNodeShow(self.m_pBtnTips, true)
        self:onUpdateNodeShow(self.m_pBtnOut, true)
        self:onUpdateNodeShow(self.m_pBtnRobot, true)
            
        --置灰不出
        self:onUpdateButtonEnable(self.m_pBtnNoOut, false)
        self:onUpdateButtonEnable(self.m_pBtnPass, true)
        self:onUpdateButtonEnable(self.m_pBtnTips, true)
        self:onUpdateButtonEnable(self.m_pBtnOut, true)
        self:onUpdateButtonEnable(self.m_pBtnRobot, true)

        --首出计时器
        local index = self.g_gameDataLogic:curentUserChairId()
        self:resetClock(index, CLOCK_OUT_CARD, "onAddTimes(首出计时器)")

         --优化:开始出牌时,重新设置下牌数据和选中状态
        local function resetCard()
            local cbCardData, cbCardCount = self.m_pCardLayer:GetShootCard()
            local nMeChair = PlayerInfo.getInstance():getChairID()
            local nMeCount = self.g_gameDataLogic.m_cbHandCardCount[nMeChair]
            local cbMeCard = self.g_gameDataLogic.m_cbHandCardData
            self.m_pCardLayer:SetCardData(cbMeCard, nMeCount, false)
            self.m_pCardLayer:SetShootCard(cbCardData, cbCardCount)
            self:showOutCardLayer(nMeChair, false)
        end
        if self.g_gameDataLogic:CurrentUserIsMe() then
            if self.m_pCardLayer:getIsInAction() then
                self:doSomethingLater(resetCard, 1.0)
            else
                resetCard()
            end
        end

--        --显示记牌器按钮
--        self.m_pBtnLeft:setVisible(true)
--        self:showLeftCard(true)

--        --获取记牌器数据
--        if not self.g_gameDataLogic:IsGetLeftCard() then
--            CMsgLord:getInstance():sendLeftCard()
--        end
    end

    --重置数据
    if chairId == PlayerInfo.getInstance():getChairID() then
        self.g_gameDataLogic:setAddScoreLocal(false)
        self.g_gameDataLogic:setAddTimeLocal(0)
    end
end

--出牌前，检查网络事件/动画播放->下一步
function GameViewLayer:onOutCard_Before(isMsgArrive, isAnimationPlay, isAnimationOver, log)
    
    if isMsgArrive then
        self.m_bIsMsgArrived = true
    end
    if isAnimationPlay then
        self.m_bIsAnimationPlay = true
    end
    if isAnimationOver then
        self.m_bIsAnimationOver = true
    end

    if (self.m_bIsMsgArrived and self.m_bIsAnimationPlay and self.m_bIsAnimationOver) --王炸播放完
    or (self.m_bIsMsgArrived and not self.m_bIsAnimationPlay and not self.m_bIsAnimationOver) --普通牌
    then
        self.m_bIsMsgArrived = false
        self.m_bIsAnimationPlay = false
        self.m_bIsAnimationOver = false
        self:onMsgGameOutCard()
    end

    --print("out card log", log)
end

--出牌
function GameViewLayer:onOutCard(isPass, isStart)
    
    if PlayerInfo.getInstance():getChairID() == INVALID_CHAIR then
        return
    end

    --重设显示
    self:onShowGameOutCard()

    --更新托管
    self:onUpdateRobotForce()

    --更新倍数
    self:onUpdateBeishu()
    self:onUpdateBeishuInfo()

        --更新底牌
--    self:onUpdateLeftCard()

--    --显示记牌器按钮
--    local bVisible = self.g_gameDataLogic:getGameStatus() == GS_T_PLAY
--    if bVisible then
--        self.m_pBtnLeft:setVisible(true)
--    else
--        self.m_pBtnLeft:setVisible(false)
--    end
    --加倍结束
    self.g_gameDataLogic:setIsAddTimesStatus(0)

    --牌型
    local _outCardData = self.g_gameDataLogic.m_cbOutCardData
    local _outCardCount = self.g_gameDataLogic.m_cbOutCardCount
    local _cardtype = LordGameLogic:getInstance():GetCardType(_outCardData, _outCardCount)

    --出牌玩家
    local outUser = self.g_gameDataLogic:getOutCardUser()
    local outChair = self.g_gameDataLogic:SwitchViewChairID(outUser)

    --当前玩家
    local currentUser = self.g_gameDataLogic:getCurrentUser()
    local currentChair = self.g_gameDataLogic:SwitchViewChairID(currentUser)

    --该轮玩家
    local winner = self.g_gameDataLogic:getTurnWiner()
    local winnerChair = self.g_gameDataLogic:SwitchViewChairID(winner)

    --可过牌
    local bCanPass = true or self.g_gameDataLogic:canPass()
    --可出牌
    local bHasCard = self.g_gameDataLogic:hasOutCard()
    --首出牌
    local bHeadCard = (bCanPass == false)
    --要不起
    local bPassOnly = (bHasCard == false)
    --是否能出
    local bCanOut = true or self.g_gameDataLogic:VerdictOutCard(self.m_pCardLayer:GetShootCard())

    --自己位置
    local selfChair = PlayerInfo.getInstance():getChairID()
    local selfViewChair = self.g_gameDataLogic:SwitchViewChairID(selfChair)

    --是否显示出牌按钮
    local isNotAuto = (self.m_bAutoLastCard == false)
    local isSelfCard = (currentUser == selfChair)
    local nCountCard = self.g_gameDataLogic.m_cbHandCardCount[selfChair]
    local nTimes = self.g_gameDataLogic.m_cbUserOffLineTimes[selfChair]
    local nLimit = self.g_gameDataLogic:getOverTimeLimt()
    local bRobot = self.g_gameDataLogic:getUserRobot(selfChair) > 0
    local bNotRobot = bRobot == false and nTimes < nLimit
    if isNotAuto and isSelfCard and nCountCard > 0  then
        self.m_pNodeOutCard:setVisible(true)
    else
        self.m_pNodeOutCard:setVisible(false)
    end


    if currentUser == selfChair and isNotAuto then
        self:showOutCardLayer(POS_SELF, false)

        self:onUpdateTipsOfPlayer(PASS_CARD, bPassOnly)

        self:onUpdateNodeShow(self.m_pBtnNoOut, bHasCard)
        self:onUpdateNodeShow(self.m_pBtnTips, bHasCard)
        self:onUpdateNodeShow(self.m_pBtnPass, bPassOnly)
        self:onUpdateNodeShow(self.m_pBtnOut, bHasCard)

        self:onUpdateButtonEnable(self.m_pBtnNoOut, bCanPass)
        self:onUpdateButtonEnable(self.m_pBtnTips, bHasCard)
        self:onUpdateButtonEnable(self.m_pBtnPass, bCanPass)
        self:onUpdateButtonEnable(self.m_pBtnOut, bCanOut)

        self:robotHandle() --托管操作
    else
        self:onUpdateTipsOfPlayer(PASS_CARD, false)
        self:onUpdateTipsOfPlayer(WRONG_TYPE, false)
    end

    for i = 0, 2 do --更新所有玩家状态
        self:onShowPlayerLogo(i)
        self:onShowPlayerCount(i)
    end

    self:onUpdateTipsOfPlayer(outChair, false)
    self:onUpdateTipsOfPlayer(currentChair, false)
    
    if isStart then --已经开始，加载牌

        do --出牌玩家
            self:onUpdateTipsOfPlayer(outChair, false)
            LordGameLogic:getInstance():SortCardList(_outCardData, _outCardCount)
            self.m_showOutCard[outChair]:SetCardData(_outCardData, _outCardCount)
            self:showOutCardLayer(outChair, true)
        end

        do --当前玩家
            self:onUpdateTipsOfPlayer(currentChair, false)
            self.m_showOutCard[currentChair]:SetCardData({}, 0)
            self:showOutCardLayer(currentChair, false)
        end

        do --出牌倒计时
            self:resetClock(currentChair, CLOCK_OUT_CARD, "onOutCard(已经开始)")
        end

        --补充过牌提示（断线重连情况）：
        --1.下家出牌+上家过牌+到自己表态->补充上家过牌提示
        --2.上家出牌+自己过牌+到下家表态->补充自己过牌提示
        --3.自己出牌+下家过牌+到上家表态->补充下家过牌提示
        if winnerChair == POS_NEXT and currentChair == POS_SELF then
            self:onUpdateTipsType(POS_PREV, E_TIP_TYPE.E_TIP_TYPE_CANCEL)
        elseif winnerChair == POS_PREV and currentChair == POS_NEXT then
            self:onUpdateTipsType(POS_SELF, E_TIP_TYPE.E_TIP_TYPE_CANCEL)
        elseif winnerChair == POS_SELF and currentChair == POS_PREV then
            self:onUpdateTipsType(POS_NEXT, E_TIP_TYPE.E_TIP_TYPE_CANCEL)
        end

        --补充上上家出牌（断线重连情况/没有数据）
        return
    end
    
    if isPass then --过牌
        if self.g_gameDataLogic:getPassCardLocal() then
        else
            local passUser = self.g_gameDataLogic:getPassCardUser()
            passUser = self.g_gameDataLogic:SwitchViewChairID(passUser)

            --提示
            self:showOutCardLayer(passUser, false)
            --self:showTip(passUser, E_TIP_TYPE.E_TIP_TYPE_CANCEL)
            self:onUpdateTipsType(passUser, E_TIP_TYPE.E_TIP_TYPE_CANCEL)

            --播放声音
            local cbGender = self.g_gameDataLogic.m_cbGender[self.g_gameDataLogic:getPassCardUser()]
            --local soundIndex = math.floor(math.random()*100%4) + 1
            --self:playSoundGender(cbGender, string.format("buyao%d",soundIndex))
            self:onUpdateTipsSound(cbGender, E_TIP_TYPE.E_TIP_TYPE_CANCEL)

            --self:hideTip(currentChair)
            --self:onUpdateTipsShow(currentChair, false)

            --出牌倒计时
            --self:showCountDown(currentChair)
            self:resetClock(currentChair, CLOCK_OUT_CARD, "onOutCard(出牌倒计时)")

            self:showOutCardLayer(currentChair, false)
        end

        --一轮结束清理提示和出的牌
        if (self.g_gameDataLogic:getTurnOver() == true) then
            for i  = 0, 2 do
                
                --self:hideTip(i, i == passUser)
                --self:onUpdateTipsShow(i, false, true)

                self:showOutCardLayer(i, false)
            end
        end

        --重设本地过牌
        if self.g_gameDataLogic:getPassCardLocal() then
            self.g_gameDataLogic:setPassCardLocal(false)
        end
    end

    if not isPass and isNotAuto then --出牌动作

        --已出牌的玩家
        if outUser ~= INVALID_CHAIR then
            if outUser == selfChair then
                if self.g_gameDataLogic:getOutCardLocal() == false then

                    --出牌动作
                    local _cardData = self.g_gameDataLogic.m_cbOutCardData
                    local _cardCount = self.g_gameDataLogic.m_cbOutCardCount
                    self:onShowCardOut(POS_SELF, _cardData, _cardCount)
                    self:outcardAnimation()
                end

            else --其他人出牌

                --出牌动作
                local _cardData = self.g_gameDataLogic.m_cbOutCardData
                local _cardCount = self.g_gameDataLogic.m_cbOutCardCount
                self:onShowCardOut(outChair, _cardData, _cardCount)
                self:outcardAnimation()
            end
        end

        --当前出牌的玩家
        if currentUser ~= INVALID_CHAIR then
            if _cardtype == CT_MISSILE_CARD then --王炸
                self:resetClock(currentChair, CLOCK_OUT_CARD, "onOutCard(出牌倒计时)")
                for i  = 0, 2 do
                    if i ~= outChair then
                        self:showOutCardLayer(i, false)
                    end
                end
            else
                if self.g_gameDataLogic:getOutCardLocal() == false then
                    -- 有玩家出完牌则牌局结束，不再显示下一个出牌玩家闹钟
                    if self.g_gameDataLogic.m_cbHandCardCount[outUser] > 0 then --出牌倒计时
                        self:resetClock(currentChair, CLOCK_OUT_CARD, "onOutCard(出牌倒计时)")
                    end
                end

                if self.g_gameDataLogic.m_cbHandCardCount[outUser] > 0 then
                    self:showOutCardLayer(currentChair, false)
                end
            end
        end
        
        --记录大小
        if _cardtype == CT_MISSILE_CARD then
            self.g_gameDataLogic:setLastOutCardCount(0)
        else
            local nLastCount = self.g_gameDataLogic.m_cbOutCardCount
            self.g_gameDataLogic:setLastOutCardCount(nLastCount)
        end

        --警报音效
        self:onShowPlayerAlert(outUser)

        --重设本地出牌
        if self.g_gameDataLogic:getOutCardLocal() then
            self.g_gameDataLogic:setOutCardLocal(false)
        end
    end

    --检查自己手上的牌 是否没有删除已出的牌
    local _recordCardData = self.g_gameDataLogic.m_cbRecordOutCardData--self.g_gameDataLogic.m_cbOutCardData
    local _recordCardCount = self.g_gameDataLogic.m_cbRecountOutCardCount--self.g_gameDataLogic.m_cbOutCardCount
    self.m_pCardLayer:checkOutCard(_recordCardData, _recordCardCount)
    --重新显示一遍已有的牌
    self:onShowCardShoot()

    --优化：首出时，剩一手牌，由本地自动出牌
--    self:onAutoOutCard()
end

--结算
function GameViewLayer:onConclude()
    
    self:onShowGameStop()

    self.m_pNodeCall:setVisible(false)
    self.m_pNodeCall_0:setVisible(false)
    self.m_pNodeJiaBei:setVisible(false)
    self.m_pNodeOutCard:setVisible(false)
    self.m_pNodeTips:setVisible(false)
    self.m_pNodeRobot:setVisible(false)
    self.m_pBtnRobot:setVisible(false)
    self.m_pCardLayer:setCanTouch(false)
    self.m_pNodeOver:setVisible(false)
    self.m_pNodeContinue:setVisible(false)

    --隐藏托管界面
    self:onUpdateNodeShow(self.m_pBtnNoRobot, false)
    self:onUpdateNodeShow(self.m_pSpriteForce, false)

    --停止倒计时
    for i = 0, 2 do
        self:stopClock(i)
    end

    --读取剩余牌
    local index = 0
    for  i = 0, 2 do
        local score = self.g_gameDataLogic.m_pGameConclude.lGameScore[i]
        
        --输赢动画
        local state = (score > 0) and E_GARTOON_STATE.WIN or E_GARTOON_STATE.LOSE
        self:onChangeCartoon(i, state, false)

        --剩余牌
        local viewChair = self.g_gameDataLogic:SwitchViewChairID(i)
        local selfChair = PlayerInfo.getInstance():getChairID()
        if self.g_gameDataLogic.m_pGameConclude.cbCardCount[i] > 0 then
            if selfChair == i then
                
                local cbCardData = self.g_gameDataLogic.m_cbHandCardData
                local cbCardCount = table.nums(cbCardData)
                LordGameLogic:getInstance():SortCardList(cbCardData, cbCardCount)
                self.m_showOutCard[POS_SELF]:SetCardData(cbCardData, cbCardCount)
                self:showOutCardLayer(viewChair, false, false) --fixbug:SetCardData完就显示了
                self:doSomethingLater(function()
                    self.m_pCardLayer:SetShootCard(cbCardData, cbCardCount)
                    self.m_pCardLayer:RemoveShootItem()
                    self:showOutCardLayer(viewChair, true, true)
                end, 1.0)
            else
                local cpCardData = {}
                local n = 0
                for k = index, index + self.g_gameDataLogic.m_pGameConclude.cbCardCount[i] - 1 do
                    cpCardData[n] = self.g_gameDataLogic.m_pGameConclude.cbHandCardData[k]
                    n = n + 1
                end
                local cpCardCount = self.g_gameDataLogic.m_pGameConclude.cbCardCount[i]
                LordGameLogic:getInstance():SortCardList(cpCardData, cpCardCount)
                self.m_showOutCard[viewChair]:SetCardData(cpCardData, cpCardCount, true)
                self:showOutCardLayer(viewChair, false, false) --fixbug:SetCardData完就显示了
                self:doSomethingLater(function()
                    self:showOutCardLayer(viewChair, true, true)
                end, 1.0)
            end
            index = index + self.g_gameDataLogic.m_pGameConclude.cbCardCount[i]
        else
            self:doSomethingLater(function()
                self:showOutCardLayer(viewChair, true)
            end, 1.0)
        end

        --剩余牌数
        local nCount = self.g_gameDataLogic.m_pGameConclude.cbCardCount[i]
        self:onUpdateCountLabel(viewChair, nCount)
        self:onUpdateCountShow(viewChair, nCount > 0) --优化：牌数0时隐藏
    end

    --输赢分数信息
    self:onUpdateBeishu()
    self:onUpdateBeishuInfo()
    self:onUpdateWinInfo()
    
    --先播放输赢音乐
    local chair = PlayerInfo.getInstance():getChairID()
    local score = self.g_gameDataLogic.m_pGameConclude.lGameScore[chair]
    local strMusic = score > 0 and "game/lord/sound/MusicEx_Win.mp3" or "game/lord/sound/MusicEx_Lose.mp3"
    self:doSomethingLater(function()
        ExternalFun.playGameBackgroundAudio(strMusic, false)
    end, 0.5)

    --金币动作
    self:doSomethingLater(function()
        self:showConcludeScore()
    end, 1.5)

    --(春天/反春天)->结算
    self:doSomethingLater(function()
        self:handleConclude()
    end, 2.0)

    --再播放背景音乐
    self:doSomethingLater(function()
        if  self.g_gameDataLogic:getGameStatus() ~= GS_T_CALL
        and self.g_gameDataLogic:getGameStatus() ~= GS_T_PLAY
        then
            ExternalFun.playGameBackgroundAudio("game/lord/sound/MusicEx_Normal2.mp3")
        end
    end, 6.0)
end

function GameViewLayer:handleConclude(dt)
    self:doSomethingLater(function()
        if self.g_gameDataLogic.m_pGameConclude.bChunTian  then
            self:onAnimationChuntian(INDEX_CHUNTIAN)
        elseif self.g_gameDataLogic.m_pGameConclude.bFanChunTian  then
            self:onAnimationChuntian(INDEX_FANCHUNTIAN)
        else
            self:showResult()
        end
    end, self.m_fDelayOverAnim)
end

--显示结果
function GameViewLayer:showResult()

    if self.g_gameDataLogic:getGameStatus() ~= GS_T_CONCLUDE then
        return
    end

    self.m_pNodeOver:setVisible(true)
    self.m_pNodeWin:setVisible(true)
    self.m_pNodeInfo:setVisible(true)
    self.m_pNodeBeishu:setVisible(false)
    self.m_pBtnNewStart:setPositionY(225)
    self.m_pBtnNewSwitch:setPositionY(225)

    --输赢动画
    self:onUpdateWinAction()
    self:onUpdateInfoAction()
end

function GameViewLayer:showResultEnd()
    
    self.m_pNodeCall:setVisible(false)
    self.m_pNodeCall_0:setVisible(false)
    self.m_pNodeJiaBei:setVisible(false)
    self.m_pNodeOutCard:setVisible(false)

    for i = 0, 2 do
        self:stopClock(i)
    end
    for i = 0, 2 do
        self:onUpdateLogoAlert(i, false)
    end
    for i = 0, 4 do
        self:onUpdateTipsOfPlayer(i, false)
    end
--    for i = 0, 2 do --玩家金币数
--        local viewChair = self.g_gameDataLogic:SwitchViewChairID(i)
--        local score = self.g_gameDataLogic.m_pGameConclude.lGameScore[i]
--        self.m_llPlayerGold[viewChair] = self.m_llPlayerGold[viewChair] + score
--        self:onUpdateOtherPlayerGold(viewChair, self.m_llPlayerGold[viewChair])
--    end

    self:setRobot(0)
    self.m_pBtnRobot:setVisible(false)
    self.m_pNodeRobot:setVisible(false)
    self.m_pNodeContinue:setVisible(true)
    self.m_pCardLayer:ClearGray()

    --停止倒计时更新
    self:stopProgressBarSchedule()
    --设置状态
    self.g_gameDataLogic:setGameStatus(GS_T_FREE)
    --结束起立
    PlayerInfo.getInstance():setSitSuc(false)
    --清理数据
    self.g_gameDataLogic:Clean()
    --界面变量
    self.m_bIsExciting = false
    self.m_bAutoLastCard = false
    self.m_bIsAnimationPlay = false
    self.m_bIsAnimationOver = false
    self.m_bIsMsgArrived = false

    if self.m_bIsKill then
        self:doSomethingLater(handler(self, self.onMoveExitView), 1.0)
    end
end

--发牌
function GameViewLayer:dispatchCard(isStart)
    self.m_pCardLayer:setVisible(true)
    self.m_pCardLayer:setCanTouch(false)

    --给自己发牌
    local chair = PlayerInfo.getInstance():getChairID()

    if isStart then
        self:dispatchCardFinish()
        self:onUpdateBankerCard(false)
        self.g_gameDataLogic:SortCardListOfSelf()
        self.m_pCardLayer:SetCardData(self.g_gameDataLogic.m_cbHandCardData, self.g_gameDataLogic.m_cbHandCardCount[chair], false)
    else
        self.m_pCardLayer:SetCardData(self.g_gameDataLogic.m_cbHandCardData, self.g_gameDataLogic.m_cbHandCardCount[chair], false)
        self.g_gameDataLogic:SortCardListOfSelf()
        self:startDispatchCard(self.m_pCardLayer.m_vCardSp, self.m_pLordCard, self.g_gameDataLogic.m_cbHandCardData)
    end
end

--发牌完成
function GameViewLayer:dispatchCardFinish()
    if self.g_gameDataLogic:getGameStatus() == GS_T_FREE then
        return
    end
    for i = 0, 2 do
        self:onUpdateCountLabel(i, NORMAL_COUNT)
    end
    self:doSomethingLater(function ()
    if (self.g_gameDataLogic:canCallScore()) then
        self.m_pNodeCall:setVisible(true)
    end
    local currentViewChair = self.g_gameDataLogic:curentUserChairId()
    self:resetClock(currentViewChair, CLOCK_CALL_SCORE, "dispatchCardFinish(叫分倒计时)")
    end ,3)
end

--提示可出牌
function GameViewLayer:promptOutCard()
    
    if self.g_gameDataLogic:getGameStatus() == GS_T_PLAY then
        if self.g_gameDataLogic:CurrentUserIsMe() then
            local cbCardData = {}
            local cbCardCount = 0
            cbCardData, cbCardCount = self.g_gameDataLogic:getNextSearchCard(cbCardData, cbCardCount)
            self.m_pCardLayer:SetShootCard(cbCardData, cbCardCount)
        end
    end
end

--判断牌型是否能出
function GameViewLayer:judgeOutCard()
    if self.g_gameDataLogic:getGameStatus() == GS_T_PLAY then
        if self.g_gameDataLogic:CurrentUserIsMe() then
            local cbCardData, cbCardCount = self.m_pCardLayer:GetShootCard()
            local bEnable = self.g_gameDataLogic:VerdictOutCard(cbCardData, cbCardCount)
            self:onUpdateButtonEnable(self.m_pBtnOut, bEnable)
        end
    end
end

--显示出牌动作
function GameViewLayer:showOutCardLayer(i, bShow, bAnim)
    
    if i < 0 or 2 < i then
        return
    end
    bShow = bShow or false
    bAnim = bAnim or false

    local bankerId = self.g_gameDataLogic:getBankerUser()
    local viewChair = self.g_gameDataLogic:SwitchViewChairID(bankerId)
    local isBanker = viewChair == i
    self.m_showOutCard[i]:SetBanker(isBanker)

    if bShow then
        if bAnim then
            local posOffset = {
                [0] = cc.p(-200, 50),
                [1] = cc.p(50, -200),
                [2] = cc.p(200, 50),
            }
            local posStop = self.m_posOfOutCard[i]
            local posStart = cc.pAdd(posStop, posOffset[i])

            local pAction = cc.Sequence:create(
                cc.Place:create(posStart),
                cc.Show:create(),
                cc.MoveTo:create(0.2, posStop),
                cc.Place:create(posStop))
            self.m_showOutCard[i]:runAction(pAction)
        else
            self.m_showOutCard[i]:setPosition(self.m_posOfOutCard[i])
            self.m_showOutCard[i]:setVisible(true)
        end
    else
        self.m_showOutCard[i]:setVisible(false)
    end
end

--重置一个玩家倒计时
function GameViewLayer:resetClock(user, status, log)
    
    if user < 0 or 2 < user then
        return
    end

    for i = 0, 2 do
        if i == user then
            self:startClock(i, status, log)
        else
            self:stopClock(i)
        end
    end
end

function GameViewLayer:stopClock(index)
    
    if index < 0 and 2 < index then
        return
    end
    self.m_pNodesClock[index]:setVisible(false)

    if self.m_scheduleClock[index] then
        scheduler.unscheduleGlobal(self.m_scheduleClock[index])
        self.m_scheduleClock[index] = nil
    end
end

function GameViewLayer:startClock(index, status, log)
    
    if index < 0 or 2 < index then
        return
    end

    if index == POS_SELF and self.g_gameDataLogic:getIsRobot() then
        return
    end

    --显示闹钟
    self.m_pNodesClock[index]:setVisible(true)

    --闹钟位置
    local pos_clock = cc.p(0, 0)
    if status == CLOCK_CALL_SCORE then
        pos_clock = cc.p(self.m_pNodeCall:getChildByName("Sprite_clock"):getPosition())
    elseif status == CLOCK_ADD_TIME then
        pos_clock = cc.p(self.m_pNodeJiaBei:getChildByName("Sprite_clock"):getPosition())
    elseif status == CLOCK_OUT_CARD then
        pos_clock = cc.p(self.m_pNodeOutCard:getChildByName("Sprite_clock"):getPosition())
    elseif status == CLOCK_QIANG_SCORE then
        pos_clock = cc.p(self.m_pNodeCall_0:getChildByName("Sprite_clock"):getPosition())
    end
    self.m_pNodesClock[POS_SELF]:setPosition(pos_clock)

    --获取倒计时
    if self.g_gameDataLogic:getGameStatus() == GS_T_CALL then
        if self.g_gameDataLogic:getIsAddTimesStatus() == 1 then --叫分倒计时
            self.m_nClockCount[index] = self.g_gameDataLogic:getTimeCallScore()
        elseif self.g_gameDataLogic:getIsAddTimesStatus() == 0 then --加倍倒计时
            self.m_nClockCount[index] = self.g_gameDataLogic:getTimeAddTimes()
        end
    elseif self.g_gameDataLogic:getGameStatus() == GS_T_PLAY then
        
        if self.g_gameDataLogic:getIsHeadOutCard() then --首出倒计时
            self.m_nClockCount[index] = self.g_gameDataLogic:getTimeHeadOutCard()
        else
            if self.g_gameDataLogic:GetMeViewChairID() == index
            and self.g_gameDataLogic:CurrentUserIsMe() == true
            and self.g_gameDataLogic:hasOutCard() == false
            then --要不起倒计时
                self.m_nClockCount[index] = 5
            else --出牌倒计时
                self.m_nClockCount[index] = self.g_gameDataLogic:getTimeOutCard()
            end
        end
    end

    --fixbug:未知情况下为空
    if self.m_nClockCount[index] == nil then
        return
    end

    --更新倒计时用的计数
    if self.m_nClockCount[index] > 0 then
        self.m_nProgressBar[index][1] = self.m_nClockCount[index] --剩余
        self.m_nProgressBar[index][2] = self.m_nClockCount[index] --时长
    end

    --更新计数
    self:onUpdateClockCount(index, true, self.m_nClockCount[index])

    --开始倒计时
    if self.m_scheduleClock[index] then
        scheduler.unscheduleGlobal(self.m_scheduleClock[index])
        self.m_scheduleClock[index] = nil
    end
    local updateClockFunc = {
        [POS_PREV] = self.updateClockCount0,
        [POS_SELF] = self.updateClockCount1,
        [POS_NEXT] = self.updateClockCount2,
    }
    self.m_scheduleClock[index] = scheduler.scheduleGlobal(handler(self, updateClockFunc[index]), 1.0)
end

function GameViewLayer:updateClockCount0(dt) self:updateClockCount(POS_PREV) end
function GameViewLayer:updateClockCount1(dt) self:updateClockCount(POS_SELF) end
function GameViewLayer:updateClockCount2(dt) self:updateClockCount(POS_NEXT) end

function GameViewLayer:updateClockCount(index)
    
    --停止倒计时
    if self.m_nClockCount[index] == nil or self.m_nClockCount[index] == 0 then
        if self.m_scheduleClock[index] then
            scheduler.unscheduleGlobal(self.m_scheduleClock[index])
            self.m_scheduleClock[index] = nil
        end
        return
    end

    --更新倒计时
    self.m_nClockCount[index] = self.m_nClockCount[index] - 1

    --更新显示计数
    self:onUpdateClockLabel(index, self.m_nClockCount[index])

    --播放声音
    if 0 < self.m_nClockCount[index] and self.m_nClockCount[index] <= 5 then
        self:playSoundDelay("game/lord/sound/audio_reminded.mp3", 0)

    --超时处理
    elseif self.m_nClockCount[index] <= 0 then
        --计时清零
        self.m_nClockCount[index] = 0

        --停止倒计时
        self:stopClock(index)

        --其他玩家返回
        if index == POS_PREV or index == POS_NEXT then
            return
        end

        --叫分倒数完
        if  self.g_gameDataLogic:getGameStatus() == GS_T_CALL --叫分环节
        and self.g_gameDataLogic:getIsAddTimesStatus() == 0 --叫地主环节
        and self.g_gameDataLogic:bankIsMe() == false --不是地主
        and self.g_gameDataLogic:getIsRobot() == false --未托管
        then
            self:onUpdateNodeShow(self.m_pNodeCall, false)
            self:onUpdateNodeShow(self.m_pNodeCall_0, false)
            self:doSomethingLater(function()
                self.g_gameDataLogic:setMeRobot(1)
                self:callRobotCallBack()
                self.g_gameDataLogic:setMeRobot(0)
            end, 0.5)
        end

        --加倍倒数完
        if  self.g_gameDataLogic:getGameStatus() == GS_T_CALL --叫分环节
        and self.g_gameDataLogic:getIsAddTimesStatus() == 1 --加倍环节
        and self.g_gameDataLogic:bankIsMe() == false --不是地主
        and self.g_gameDataLogic:getIsRobot() == false --未托管
        then
            self:onUpdateNodeShow(self.m_pNodeJiaBei, false)
            self:doSomethingLater(function()
                self.g_gameDataLogic:setMeRobot(1)
                self:callRobotCallBack()
                self.g_gameDataLogic:setMeRobot(0)
            end, 0.5)
        end

        --出牌倒数完,过牌
        if  self.g_gameDataLogic:getGameStatus() == GS_T_PLAY --出牌环节
        and self.g_gameDataLogic:CurrentUserIsMe() == true --轮到自己
        and self.g_gameDataLogic:getIsRobot() == false --没有托管
        then
            self:onUpdateNodeShow(self.m_pNodeOutCard, false)
            self:doSomethingLater(function()
                
                --首出超时出牌/非首发超时过牌
                if self.g_gameDataLogic:canPass() == false then
                    self.g_gameDataLogic:setMeRobot(1)
                    self:callRobotCallBack()
                    self.g_gameDataLogic:setMeRobot(0)
                else
                    self._scene:SendPass()
                end

                --超时过2次过牌，发送托管
                self.m_nTimeOutCount = self.m_nTimeOutCount + 1
                if self.m_nTimeOutCount >= 2 then
                    self.m_nTimeOutCount = 0
                    self._scene:SendManage(true)
                end
            end, 0.5)
        end
    end
end

--设置机器人
function GameViewLayer:setRobot(iRobot)

    self.g_gameDataLogic:setMeRobot(iRobot)
    self.m_pCardLayer:setCanTouch(iRobot == 0)
    self.m_pCardLayer:setAllNotShoot()
    self:onUpdateNodeShow(self.m_pNodeRobot, iRobot > 0)
    self:onUpdateNodeShow(self.m_pBtnRobot, iRobot == 0)
    self:onUpdateLogoRobot(POS_SELF, iRobot > 0)
    
    if iRobot > 0 then
        self:robotHandle()
    end

    if iRobot == 0 then
        if self.g_gameDataLogic:CurrentUserIsMe() then
            if self.g_gameDataLogic:getGameStatus() == GS_T_PLAY then
                self.m_pNodeOutCard:setVisible(true)
                self:resetClock(POS_SELF, CLOCK_OUT_CARD, "robot")
            end
        end
    end
end

function GameViewLayer:robotHandle()
    if self.g_gameDataLogic:CurrentUserIsMe() then
        if self.g_gameDataLogic:getIsRobot() then

            self.m_pNodeCall:setVisible(false)
            self.m_pNodeCall_0:setVisible(false)
            self.m_pNodeJiaBei:setVisible(false)
            self.m_pNodeOutCard:setVisible(false)

            for i = 0, 2 do
                self:stopClock(i)
            end
            
            self:doSomethingLater(handler(self, self.callRobotCallBack), 1.0 + math.random(0, 1))
        end
    end
end

function GameViewLayer:callRobotCallBack()
    local chair = PlayerInfo.getInstance():getChairID()
    local offTimes = self.g_gameDataLogic.m_cbUserOffLineTimes[chair]
    local nLimit = self.g_gameDataLogic:getOverTimeLimt()
    local status = self.g_gameDataLogic:getGameStatus()

    --取消托管时，可能已经进来
    if self.g_gameDataLogic:getIsRobot() == false then
        return
    end

    if status == GS_T_CALL then
--        if self.g_gameDataLogic:getIsAddTimesStatus() == 0 then
--            CMsgLord:getInstance():sendCallScore(255) --超时不叫分
--        elseif self.g_gameDataLogic:getIsAddTimesStatus() == 1 then
--            CMsgLord:getInstance():sendAddTimes(0) --超时不加倍
--        end

    elseif status == GS_T_PLAY then

        --超出次数由服务器出牌
        if offTimes >= nLimit then
            return
        end

        self.m_pCardLayer:setAllNotShoot()

        if self.g_gameDataLogic:hasOutCard() then

            local bCanOut = true

            --获取可出牌型
            local cbCardData, cbCardCount = {}, 0
            self.g_gameDataLogic:resetSearchIndexToStart()
            cbCardData, cbCardCount = self.g_gameDataLogic:getNextSearchCard(cbCardData, cbCardCount)

            --校验数据
            local bValid = LordGameLogic:getInstance():CheckCardData(cbCardData, cbCardCount)
            if not bValid then
                FloatMessage:getInstance():pushMessageDebug("LANDLORD_0") --牌数据错误
                bCanOut = false
            end

             --校验牌型
            local cardtype = LordGameLogic:getInstance():GetCardType(cbCardData, cbCardCount)
            if (cbCardCount>0 and (cardtype <= CT_ERROR or cardtype > CT_MISSILE_CARD)) then
                FloatMessage:getInstance():pushMessageDebug("LANDLORD_1") --出牌类型错误
                bCanOut = false
            end

            --不符合规则
            local bEnable = self.g_gameDataLogic:VerdictOutCard(cbCardData, cbCardCount)
            if not bEnable then
                bCanOut = false
            end

            if bCanOut then --超时出牌
                --CMsgLord:getInstance():sendOutCard(cbCardData,cbCardCount)
                self:onOutCardLocal(cbCardData,cbCardCount)
                return
            end
        end
        --超时过牌
        self._scene:SendPass()
    end
end

function GameViewLayer:onChangeCartoon(chairID, state, bAni)
    if chairID < 0 or 2 < chairID then
        return
    end

    local viewChair = self.g_gameDataLogic:SwitchViewChairID(chairID)
    local cbGender = self.g_gameDataLogic.m_cbGender[chairID]
    local isBanker = self.g_gameDataLogic:getBankerUser() == chairID

    local strName = FARMER_FEMALE --动画
    if     cbGender == 0 then strName = isBanker and LANDLORD_MALE or FARMER_MALE
    elseif cbGender == 1 then strName = isBanker and LANDLORD_FEMALE or FARMER_FEMALE
    end

    local strAniName = E_GARTOON_STATE.NORMAL -- 动作
    if     state == E_GARTOON_STATE.NORMAL then strAniName = ACTION_NORMAL
    elseif state == E_GARTOON_STATE.WIN    then strAniName = ACTION_WIN
    elseif state == E_GARTOON_STATE.LOSE   then strAniName = ACTION_LOSE
    end

    --地主标志
    self:onUpdateLogoLord(viewChair, isBanker)
    
    --变身/加载/动作
    if bAni then
        self:onUpdateChangePlayer(viewChair)
    end
    self:onLoadPlayerSpine(viewChair, strName)
    self:onUpdatePlayerAction(viewChair, strAniName)
end

function GameViewLayer:showConcludeScore()

    self.m_pNodeScore:setVisible(true)
    
    for i = 0, GAME_PLAYER_LANDLORD - 1 do --金币落下
        local viewChair = self.g_gameDataLogic:SwitchViewChairID(i)
        local score = self.g_gameDataLogic.m_pGameConclude.lGameScore[i]
        self:onUpdateWinScore(viewChair, score)
    end

--    self:doSomethingLater(function() --自己金币
--        local nowScore = PlayerInfo.getInstance():getUserScore()
--        local lastScore = PlayerInfo.getInstance():getLastUserScore()
--        Effect:getInstance():showScoreChangeEffect(self.m_pLbUserGold, lastScore, nowScore - lastScore, nowScore)
--    end, 0.5)
end

function GameViewLayer:outcardAnimation()
    local cardData = self.g_gameDataLogic.m_cbOutCardData
    local cardCount = self.g_gameDataLogic.m_cbOutCardCount
    local cardtype = LordGameLogic:getInstance():GetCardType(cardData, cardCount)
    local value = GetCardValue(self.g_gameDataLogic.m_cbOutCardData[0])
    local outUser = self.g_gameDataLogic:getOutCardUser()
    local cbGender = self.g_gameDataLogic.m_cbGender[outUser]
    local viewChair = self.g_gameDataLogic:SwitchViewChairID(outUser)
    local bDani = self.g_gameDataLogic:getLastOutCardCount()
    local random = math.floor(math.random()*100%3)
    local strDani = string.format("dani%d",math.abs(random)+1)
    local cbCardCount = self.g_gameDataLogic.m_cbOutCardCount
    self:outcardAnimation_(cardtype, value, outUser, cbGender, viewChair, bDani, strDani, cbCardCount)
end

function GameViewLayer:onShowCallScore(viewChair, nScoreType, cbGender, currentIndex) --叫分
    
    --提示叫分
    self:onUpdateTipsType(viewChair, nScoreType)
    --播放叫分
    self:onUpdateTipsSound(cbGender, nScoreType)
    --重置下家叫分
    self:onUpdateTipsOfPlayer(currentIndex, false)
end

function GameViewLayer:onShowAddTime(viewChair, nAddType, cbGender, isDouble) --加倍
    
    --提示加倍
    self:onUpdateTipsType(viewChair, nAddType)
    --播放加倍
    self:onUpdateTipsSound(cbGender, nAddType)
    --显示加倍logo
    self:onUpdateLogoDouble(viewChair, isDouble)
end

function GameViewLayer:onShowCardPass(viewChair, nTipsType, cbGender, currentChair) --过牌
    
    --提示过牌
    self:onUpdateTipsType(viewChair, nTipsType)
    --播放过牌
    self:onUpdateTipsSound(cbGender, nTipsType)
    --重置下家提示
    self:onUpdateTipsOfPlayer(currentChair, false)
    --重置下家出牌
    self:showOutCardLayer(currentChair, false)
    --重设自己牌显示
    self.m_pCardLayer:setAllNotShoot()
end

function GameViewLayer:onShowCardOut(index, cbCardData, cbCardCount) --出牌
    
    if index < 0 or 2 < index then
        return
    end

    if type(cbCardData) ~= "table" or type(cbCardCount) ~= "number" then
        return
    end

    --出牌声音
    self:playSoundDelay("game/lord/sound/Special_give.mp3", 0)

    --设置牌数据
    LordGameLogic:getInstance():SortCardList(cbCardData, cbCardCount, ST_COUNT)
    self.m_showOutCard[index]:SetCardData(cbCardData, cbCardCount, true)

    --本地显示出牌
    self:showOutCardLayer(index, true, true)

    --自己删除出牌
    if index == POS_SELF then
        self.m_pCardLayer:SetShootCard(cbCardData, cbCardCount)
        self.m_pCardLayer:RemoveShootItem()
    end
end

function GameViewLayer:onShowCardShoot() --重新显示一遍已有的牌，防止错误显示
    if self.g_gameDataLogic:CurrentUserIsMe() then
        local cbCardData, cbCardCount = self.m_pCardLayer:GetShootCard()
        local nMeChair = PlayerInfo.getInstance():getChairID()
        local nMeCount = self.g_gameDataLogic.m_cbHandCardCount[nMeChair]
        local cbMeCard = self.g_gameDataLogic.m_cbHandCardData
        self.m_pCardLayer:SetCardData(cbMeCard, nMeCount, false)
        self.m_pCardLayer:SetShootCard(cbCardData, cbCardCount)
    end
end

function GameViewLayer:onAutoOutCard() --优化：首出时，剩一手牌，由本地自动出牌
    
--	local nMeChair = PlayerInfo.getInstance():getChairID()
--    local cbCardData = self.g_gameDataLogic.m_cbHandCardData
--    local cbCardCount = self.g_gameDataLogic.m_cbHandCardCount[nMeChair]
--    local nCardType = LordGameLogic:getInstance():GetCardType(cbCardData, cbCardCount)

--    --自动出牌条件
--    local nTypeAuto = {
--        [0]  = { false, "非一手牌", }, 
--        [1]  = { true,  "单牌类型", }, 
--        [2]  = { true,  "对牌类型", }, 
--        [3]  = { true,  "三条类型", }, 
--        [4]  = { true,  "单连类型", }, 
--        [5]  = { true,  "对连类型", },
--        [6]  = { true,  "三连类型", }, 
--        [7]  = { true,  "三带一单", }, 
--        [8]  = { true,  "三带一对", },
--        [9]  = { false, "四带两单", }, 
--        [10] = { false, "四带两对", }, 
--        [11] = { true,  "炸弹类型", },
--        [12] = { true,  "火箭类型", },
--    }

--    if self.g_gameDataLogic:getIsAddTimesStatus() == 0 then --加倍结束
--        if self.g_gameDataLogic:getGameStatus() == GS_T_PLAY then --出牌阶段
--            if self.g_gameDataLogic:CurrentUserIsMe() then --轮到自己
--                if self.g_gameDataLogic:canPass() == false then --首出时
--                    if not self.g_gameDataLogic:getIsHaveTwoKing(cbCardData) then --不含王炸
--                        if nTypeAuto[nCardType][1] then --可自动牌型

--                            self.m_bAutoLastCard = true
--                            self.m_pNodeOutCard:setVisible(false)
--                            self:stopClock(POS_SELF)
--                            self:doSomethingLater(function()
--                                self:onOutCardLocal(cbCardData, cbCardCount)
--                            end, 0.5 + math.random(0, 1))
--                            FloatMessage.getInstance():pushMessageDebug("自动出牌：" .. nTypeAuto[nCardType][2])
--                        end
--                    end
--                end
--            end
--        end
--    end
end

--玩家所有标志
function GameViewLayer:onShowPlayerLogo(chair)
    
    local viewChair = self.g_gameDataLogic:SwitchViewChairID(chair)
    local cbGender = self.g_gameDataLogic.m_cbGender[chair]
    local banker = self.g_gameDataLogic:getBankerUser()

    --地主标志
    local isBanker = (banker == chair)
    self:onUpdateLogoLord(viewChair, isBanker)

    --加倍标志
    local isDouble = self.g_gameDataLogic.m_iAddTimes[chair] == 2
    self:onUpdateLogoDouble(viewChair, isDouble)

    --托管标志
    local isRobot = self.g_gameDataLogic:getUserRobot(chair) > 0
    self:onUpdateLogoRobot(viewChair, isRobot)

    --离线标志
--    local table = PlayerInfo.getInstance():getTableID()
--    local user = CUserManager.getInstance():getUserInfoByChairID(table, chair)
--    local isOffLine = (user.cbUserStatus == G_CONSTANTS.US_OFFLINE)
--    self:onUpdateLogoOffline(viewChair, isOffLine)

    --更新标志位置
    self:onUpdateLogoPosistion(viewChair)
end

--玩家剩余牌数
function GameViewLayer:onShowPlayerCount(chair)

    local viewChair = self.g_gameDataLogic:SwitchViewChairID(chair)

    --剩余牌数
    local nCount = self.g_gameDataLogic.m_cbHandCardCount[chair]
    self:onUpdateCountLabel(viewChair, nCount)

    --报警灯
    local isAlert = (nCount == 1 or nCount == 2)
    self:onUpdateLogoAlert(viewChair, isAlert)
end

--玩家报警
function GameViewLayer:onShowPlayerAlert(chair)
    
    local count = self.g_gameDataLogic.m_cbHandCardCount[chair]
    local cbGender = self.g_gameDataLogic.m_cbGender[chair]
    if count == 2 or count == 1 then
        
        --背景音乐
        if not self.m_bIsExciting then
            ExternalFun.playGameBackgroundAudio("game/lord/sound/MusicEx_Exciting.mp3")
            self.m_bIsExciting = true
        end

        --报警音效
        self:playSoundDelay("game/lord/sound/Special_Baojingjiacheng.mp3", 0.2)

        --报警人声
        local strSound =  "baojing" ..count
        self:playSoundGender(cbGender, strSound, 0.3)
    end
end

function GameViewLayer:onShowGameFree()
    
    self.m_pNodeStart:setVisible(true)
    self.m_pNodeWait:setVisible(false)
    self.m_pNodePlay:setVisible(false)
    self.m_pNodeOver:setVisible(false)
end

function GameViewLayer:onShowGameReady()

    self.m_pNodeStart:setVisible(false)
    self.m_pNodeWait:setVisible(true)
    self.m_pNodePlay:setVisible(false)
    self.m_pNodeOver:setVisible(false)
end

function GameViewLayer:onShowGamePlay()
    
    self.m_pNodeStart:setVisible(false)
    self.m_pNodeWait:setVisible(false)
    self.m_pNodePlay:setVisible(true)
    self.m_pNodeOver:setVisible(false)
end

function GameViewLayer:onShowGameStop()

    self.m_pNodeStart:setVisible(false)
    self.m_pNodeWait:setVisible(false)
    self.m_pNodePlay:setVisible(true)
    self.m_pNodeOver:setVisible(true)
end

function GameViewLayer:onShowGameOver()

    self.m_pNodeStart:setVisible(true)
    self.m_pNodeWait:setVisible(false)
    self.m_pNodePlay:setVisible(true)
    self.m_pNodeOver:setVisible(false)
end

function GameViewLayer:onShowGameCallScore()

    self:onShowGamePlay()

    self.m_pNodeJiaBei:setVisible(false)
    self.m_pNodeOutCard:setVisible(false)

    self.m_pNodeLock:setVisible(true)
    self.m_pNodeCount:setVisible(true)
end
function GameViewLayer:onShowGameAddTime(bAdd)

    self:onShowGamePlay()

    self.m_pNodeCall:setVisible(false)
    self.m_pNodeCall_0:setVisible(false)
    self.m_pNodeJiaBei:setVisible(bAdd)
    self.m_pNodeOutCard:setVisible(false)

    self.m_pNodeLock:setVisible(true)
    self.m_pNodeCount:setVisible(true)
end

function GameViewLayer:onShowGameOutCard()

    self:onShowGamePlay()

    self.m_pNodeCall:setVisible(false)
    self.m_pNodeCall_0:setVisible(false)
    self.m_pNodeJiaBei:setVisible(false)
    self.m_pNodeOutCard:setVisible(true)

    self.m_pNodeLock:setVisible(true)
    self.m_pNodeCount:setVisible(true)
end

function GameViewLayer:onUpdateBeishuInfo()
    
    local vecBeishu = self:getGameBeishu()
    for i = 1, 5 do
        if vecBeishu[i] == 0 then
            self.m_pLabelsJiesuan[i]:setString("--")
        else
            self.m_pLabelsJiesuan[i]:setString(vecBeishu[i])
        end
    end
end

function GameViewLayer:__onAction__() end --动作

--发牌动作
function GameViewLayer:startDispatchCard(selfCards, lordCards, cbCardData)

    --所有位置
    local posOf_Start = cc.p(self.m_pLordCard[1]:getPosition()) --发牌位置
    local posOf_0_Player = cc.p(self.m_pNodesCount[0]:getPosition()) --上家最终位置
    local posOf_2_Player = cc.p(self.m_pNodesCount[2]:getPosition()) --下家最终位置
    local posOf_1_Player = {} --自己最终位置
    for i = 0, 16 do
        posOf_1_Player[i] = cc.p(selfCards[i]:getPosition())
    end
    local posOf_Bezier = {} --贝塞尔点
    for i = 0, 2 do
        posOf_Bezier[i] = cc.p(self.m_pNodesBezier[i]:getPosition())
    end

    --调整位置（锚点）
    local posOf_CardCount = cc.p(-99 / 2 * 0.55, -124 / 2 * 0.55)
    posOf_0_Player = cc.pAdd(posOf_0_Player, posOf_CardCount)
    posOf_2_Player = cc.pAdd(posOf_2_Player, posOf_CardCount)

    --调整位置（父节点）
    local posOf_CardLayer = cc.p(self.m_pNodesCardSelf:getPosition())
    for i = 0, 16 do
        posOf_1_Player[i] = cc.pAdd(posOf_1_Player[i], posOf_CardLayer)
    end

    --准备所有牌
    local m_queueCard = {}
    for i = 0, 16 do --51张牌
        for j = 0, 2 do
            local card1 = cc.Sprite:createWithSpriteFrameName(GUI_PREFIX .. "gui-icon-card-lock.png")
            card1:setPosition(posOf_Start)
            card1:setAnchorPoint(0, 0)
            card1:setVisible(false)
            card1:setTag(j)
            card1:addTo(self.m_pNodeCount, -1)
            table.insert(m_queueCard, card1)
        end
    end

    --牌最终大小
    local SCALE_CARD_STOP = {
        [0] =  56.0 / 99.0 - 0.01, --上家
        [1] = 155.0 / 99.0 + 0.05, --自己
        [2] =  56.0 / 99.0 - 0.01, --下家
    }

    --隐藏牌
    for i = 0, 16 do
        selfCards[i]:setVisible(false)
    end
    for i = 0, 2 do
        lordCards[i]:setVisible(i == 1)
        lordCards[i]:setBack(true)
    end

    local function faDipai() --展开底牌
        for i = 0, 2, 2 do
            local PosStart = cc.p(self.m_pLordCard[1]:getPosition())
            local posStop = cc.pAdd(PosStart, cc.p((i - 1) * 40, 0))
            local timeSpace = 0.15
            local pAction = cc.Sequence:create(
                cc.Place:create(PosStart),
                cc.DelayTime:create(timeSpace * 2),
                cc.Show:create(),
                cc.EaseBackOut:create(cc.MoveTo:create(timeSpace, posStop)))
            self.m_pLordCard[i]:runAction(pAction)
        end
    end

    local function sortCards() --收缩排序展开
        ExternalFun.playGameEffect("game/lord/sound/Special_Sort.mp3")
        local posMiddle = cc.p(selfCards[8]:getPosition())
        local timeSpace = 0.15
        for i = 0, 16 do
            local posStop = cc.p(selfCards[i]:getPosition())
            local posOffset = cc.p(posMiddle.x + i, posMiddle.y)
            local pAction = cc.Sequence:create(
                cc.EaseSineIn:create(cc.MoveTo:create(timeSpace, posOffset)),
                cc.DelayTime:create(timeSpace),
                cc.CallFunc:create(function()
                    selfCards[i]:setCardData(cbCardData[i])
                end),
                cc.EaseBackOut:create(cc.MoveTo:create(timeSpace, posStop)))
            selfCards[i]:runAction(pAction)
        end
    end

    local function sendCardsEnd()
        faDipai()
        sortCards()
        self:dispatchCardFinish()
    end

    --移动数据
    local m_queueData = {}
    for i = 0, 16 do
        --上家
        local data1 = {}
        data1.PosStart = posOf_Start
        data1.PosStop = posOf_0_Player
        data1.PosEase = cc.p(posOf_0_Player.x - 10, posOf_0_Player.y)
        data1.PosBezier = posOf_Bezier[0]
        data1.ScaleStart = 1.0
        data1.ScaleStop = SCALE_CARD_STOP[0]
        data1.Tag = 0
        table.insert(m_queueData, data1)

        --自己
        local data2 = {}
        data2.PosStart = posOf_Start
        data2.PosStop = posOf_1_Player[i]
        data2.PosEase = cc.p(posOf_1_Player[i].x, posOf_1_Player[i].y - 25)
        data2.PosBezier = posOf_Bezier[1]
        data2.ScaleStart = 1.0
        data2.ScaleStop = SCALE_CARD_STOP[1]
        data2.Tag = 1
        data2.Card = selfCards[i]
        table.insert(m_queueData, data2)

        --下家
        local data3 = {}
        data3.PosStart = posOf_Start
        data3.PosStop = posOf_2_Player
        data3.PosEase = cc.p(posOf_2_Player.x + 10, posOf_2_Player.y)
        data3.PosBezier = posOf_Bezier[2]
        data3.ScaleStart = 1.0
        data3.ScaleStop = SCALE_CARD_STOP[2]
        data3.Tag = 2
        table.insert(m_queueData, data3)
    end

    --时间间隔
    for i = 1, 51 do
        if i <= 18 then
            m_queueData[i].DelayStart = i * 0.01
        elseif i <= 36 then 
            m_queueData[i].DelayStart = i * 0.01 + 0.3
        elseif i <= 51 then
            m_queueData[i].DelayStart = i * 0.01 + 0.6
        end
    end

    --移动坐标
    for i = 1, 51 do
        m_queueData[i].PosBeziers = {
            m_queueData[i].PosStart,
            m_queueData[i].PosBezier,
            m_queueData[i].PosEase,
        }
    end

    local len = #m_queueCard
    local nTimeMove = 0.20
    local nTimeBack = 0.15
    local nTimeShow = 0.01
    for i = 1, len do

        local card = m_queueCard[i]
        local data = m_queueData[i]
        local pAction = cc.Sequence:create(
            cc.Place:create(data.PosStart),
            cc.DelayTime:create(data.DelayStart),
            cc.Show:create(),
            cc.CallFunc:create(function() 
                if i == 1 or i == 19 or i == 37 then --播放声音
                    ExternalFun.playGameEffect("game/lord/sound/Special_Send.mp3")
                end
            end),
            cc.DelayTime:create(nTimeShow),
            --直接飞
            --cc.Spawn:create(
            --    cc.MoveTo:create(nTimeMove, data.PosEase),
            --    cc.ScaleTo:create(nTimeMove, data.ScaleStop)),
            --贝塞尔曲线飞
            cc.Spawn:create(
                cc.BezierTo:create(nTimeMove, data.PosBeziers),
                cc.ScaleTo:create(nTimeMove, data.ScaleStop)),
            cc.MoveTo:create(nTimeBack, data.PosStop),
            cc.CallFunc:create(function()
                if data.Tag == 0 or data.Tag == 2 then
                    self:onUpdateCountLabel(data.Tag, math.ceil(i / 3))
                elseif data.Tag == 1 then
                    data.Card:setVisible(true)
                end
                if len == i then
                    sendCardsEnd()
                end
                card:removeFromParent()
            end))
        card:runAction(pAction)
    end
end

function GameViewLayer:startDispatchLord(bankerChair)

    local function fly(bankerChair) --logo飞
        local posStart = cc.p(667, 420)
        local posStop= cc.p(self.m_pNodesLogoLord[bankerChair]:getPosition())
        local pAction = cc.Sequence:create(
            cc.MoveTo:create(0.25, posStop),
            cc.ScaleTo:create(0.25, 1.1),
            cc.ScaleTo:create(0.25, 0.9),
            cc.ScaleTo:create(0.25, 1.0)) 
        self.m_pNodesLogoLord[bankerChair]:getChildByName("Image"):setVisible(true)
        self.m_pNodesLogoLord[bankerChair]:setPosition(posStart)
        self.m_pNodesLogoLord[bankerChair]:runAction(pAction)
    end

    if self.m_pAnimationLord == nil then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(doudizhu4_dizhumao) 
        self.m_pAnimationLord = ccs.Armature:create("doudizhu4_dizhumao")
        local function animationEnd(armature, movementType, action)
            if movementType == ccs.MovementEventType.complete
            or movementType == ccs.MovementEventType.loopComplete
            then
                self.m_pAnimationLord:removeFromParent()
                self.m_pAnimationLord = nil

                local banker = self.g_gameDataLogic:getBankerUser()
                local bankerChair = self.g_gameDataLogic:SwitchViewChairID(banker)
                fly(bankerChair)
            end
        end
        self.m_pAnimationLord:getAnimation():setMovementEventCallFunc(animationEnd)
        self.m_pAnimationLord:setVisible(false)
        self.m_pAnimationLord:setPosition(cc.p(667, 418))
        self.m_pAnimationLord:addTo(self.m_pNodeLogoLord)
    end

    self.m_pNodesLogoLord[bankerChair]:getChildByName("Image"):setVisible(false)
    self.m_pAnimationLord:getAnimation():play("Animation1")
    self.m_pAnimationLord:setVisible(true)
end

function GameViewLayer:shakeLayer(duration, strength, frequency)
   
    local m_pDuration = duration or 10.0
    local m_pStrength = strength or 100
    local m_pFrequency = frequency or 0.03

    local init_x, init_y = self.m_pRootUI:getPosition()
    local m_dt = 0
    local m_rand_x = 0
    local m_rand_y = 0

    if self.m_shakeUpdate then
        scheduler.unscheduleGlobal(self.m_shakeUpdate)
        self.m_shakeUpdate = nil
    end

    self.m_shakeUpdate = scheduler.scheduleGlobal(function(dt)
        m_dt = m_dt + dt

        if self.m_shakeUpdate == nil then
            return
        end

        if m_dt < m_pDuration then
            m_rand_x = dt * math.random(0 - m_pStrength, m_pStrength)
            m_rand_y = dt * math.random(0 - m_pStrength, m_pStrength)
            self.m_pRootUI:setPosition(init_x + m_rand_x, init_y + m_rand_y)
        else
            if self.m_shakeUpdate then
                scheduler.unscheduleGlobal(self.m_shakeUpdate)
                self.m_shakeUpdate = nil
            end
            self.m_pRootUI:setPosition(init_x, init_y)
        end
    end, m_pFrequency)
end

function GameViewLayer:playSoundGender(cbGender, str, delayTime)
    if not delayTime then
        delayTime = 0
    end
    
    local strGender = (cbGender == 0) and "Man" or "Woman" --服务器：0男/1女
    local strSound = string.format("game/lord/sound/%s_%s.mp3", strGender, str)

    if (delayTime <=0) then
        ExternalFun.playGameEffect(strSound)
        return
    end

    self:doSomethingLater(function()
        ExternalFun.playGameEffect(strSound)
    end, delayTime)
end

function GameViewLayer:playMusicDelay(strMusic, delayTime, isLoop)
    if (string.len(strMusic) == 0) then
        return
    end
    if (delayTime <=0) then
        ExternalFun.playGameBackgroundAudio(strMusic, isLoop)
        return
    end

    self:doSomethingLater(function()
        ExternalFun.playGameBackgroundAudio(strMusic, isLoop)
    end, delayTime)
end

function GameViewLayer:playSoundDelay(strSound, delayTime)
    if (string.len(strSound) == 0) then
        return
    end

    if (delayTime <=0) then
        ExternalFun.playGameEffect(strSound)
        return
    end

    self:doSomethingLater(function()
        ExternalFun.playGameEffect(strSound)
    end, delayTime)
end

function GameViewLayer:doSomethingLater(call, time)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(time), cc.CallFunc:create(call)))
end

function GameViewLayer:resetLeftCard()
    self.m_bLayerMoving = false
    self.m_bLeftCard = POS_CLOSE
    self.m_pLayerLeft:setPosition(cc.p(-680, 50))

    self.m_pLordCard[0]:setPosition(583, 620)
    self.m_pLordCard[1]:setPosition(623, 620)
    self.m_pLordCard[2]:setPosition(663, 620)
    self.m_pLockScore:setPosition(730, 710)

    self.m_pLordCard[0]:setScale(1.0)
    self.m_pLordCard[1]:setScale(1.0)
    self.m_pLordCard[2]:setScale(1.0)
    self.m_pLockScore:setScale(0.85)
end

function GameViewLayer:showLeftCard(bShow)

    --状态改变
    if bShow == true then
        if self.m_bLeftCard == POS_CLOSE then
            self.m_bLeftCard = POS_OPEN
        else
            return
        end
    elseif bShow == false then
        if self.m_bLeftCard == POS_OPEN then
            self.m_bLeftCard = POS_CLOSE
        else
            return
        end
    end

    --正在移动中
    if self.m_bLayerMoving then
        return
    end
    self.m_bLayerMoving = true

    local Time_Move = 0.08
    local Pos_Show = cc.p(0, 50)
    local Pos_Hide = cc.p(-680, 50)

    --记牌栏
    if bShow then --打开
        local _Show = cc.Show:create()
        local _Move = cc.MoveTo:create(Time_Move, Pos_Show)
        local _Call = cc.CallFunc:create(function()
            self.m_bLayerMoving = false
        end)
        local action = cc.Sequence:create(_Show, _Move, _Call)
        self.m_pLayerLeft:setPosition(Pos_Hide)
        self.m_pLayerLeft:runAction(action)
    else --关闭
        local _Move = cc.MoveTo:create(Time_Move, Pos_Hide)
        local _Hide = cc.Hide:create()
        local _Call = cc.CallFunc:create(function()
            self.m_bLayerMoving = false
        end)
        local action = cc.Sequence:create(_Move, _Hide, _Call)
        self.m_pLayerLeft:setPosition(Pos_Show)
        self.m_pLayerLeft:runAction(action)
    end

    --底牌
    local start_data = {
        { 583, 620, 1.00, }, --x/y/scale
        { 623, 620, 1.00, },
        { 663, 620, 1.00, },
        { 730, 710, 0.85, },
    }
    local stop_data = {
        { 1000, 654, 0.78, }, --x/y/scale
        { 1035, 654, 0.78, },
        { 1070, 654, 0.78, },
        { 1122, 723, 0.70, },
    }
    local move_sprite = {
        self.m_pLordCard[0], self.m_pLordCard[1],
        self.m_pLordCard[2], self.m_pLockScore,
    }
    if bShow then --打开
        for i = 1, 4 do
            move_sprite[i]:setPosition(start_data[i][1], start_data[i][2])
            move_sprite[i]:setScale(start_data[i][3])
            local posStop = cc.p(stop_data[i][1], stop_data[i][2])
            local actionMove = cc.MoveTo:create(Time_Move, posStop)
            local actionScale = cc.ScaleTo:create(Time_Move, stop_data[i][3])
            local actionOpen = cc.Spawn:create(actionMove, actionScale)
            move_sprite[i]:runAction(actionOpen)
        end
    else --关闭
        for i = 1, 4 do
            move_sprite[i]:setPosition(stop_data[i][1], stop_data[i][2])
            move_sprite[i]:setScale(stop_data[i][3])
            local posStop = cc.p(start_data[i][1], start_data[i][2])
            local actionMove = cc.MoveTo:create(Time_Move, posStop)
            local actionScale = cc.ScaleTo:create(Time_Move, start_data[i][3])
            local actionOpen = cc.Spawn:create(actionMove, actionScale)
            move_sprite[i]:runAction(actionOpen)
        end
    end
end
---------------------------------------------------------------
function GameViewLayer:__onLocal__() end --动作先行

--发送匹配
function GameViewLayer:onStartLocal()

--    if AudioManager.getInstance():getStrMusicPath() ~= "game/lord/sound/MusicEx_Normal.mp3" then
--        ExternalFun.playGameBackgroundAudio("game/lord/sound/MusicEx_Normal.mp3")
--    end

    self:onShowGameReady()
    
    self:onReady()

    if device.platform == "windows" then
        self._scene:SendReady()
        self.g_gameDataLogic:setGameStatus(100)
    else
        self._scene:SendReady()
        self.g_gameDataLogic:setGameStatus(100)
    end
end

--先显示叫分，再发送叫分
function GameViewLayer:onCallScoreLocal(tag)

    --显示叫分
    local score = tag

    --切换计时器
    self:resetClock(POS_NEXT, CLOCK_CALL_SCORE, "onShowCallScore(叫分倒计时)")

    --本地叫分
    self.g_gameDataLogic:setCallScoreLocal(true)
    self.g_gameDataLogic:setCallTimeLocal(score)
    if tag == 255 then
        tag = 0
    elseif tag > 0 then
        tag = 1 
    end
    --发送叫分
    if device.platform == "windows"  then
        cc.exports.scheduler.performWithDelayGlobal(function()
--            CMsgLord:getInstance():sendCallScore(tag)
            self._scene:SendCall(tag)
        end, TIME_DELAY_FOR_PC)
    else
        self._scene:SendCall(tag)
    end

    --隐藏按钮
    self.m_pNodeCall:setVisible(false)
end



--先显示叫分，再发送叫分
function GameViewLayer:onQiangScoreLocal(tag)

    --显示叫分
    local score = tag
    local callUser = PlayerInfo.getInstance():getChairID()
--    local cbGender = self.g_gameDataLogic.m_cbGender[callUser]
    local scoreType = self:getCallScoreType(score)
    self:onShowCallScore(POS_SELF, scoreType, cbGender, POS_NEXT)

    --切换计时器
    self:resetClock(POS_NEXT, CLOCK_QIANG_SCORE, "onShowCallScore(叫分倒计时)")

    --本地叫分
    self.g_gameDataLogic:setCallScoreLocal(true)
    self.g_gameDataLogic:setCallTimeLocal(score)
    if tag == 182 then
        tag = 0
    elseif tag == 184 then
        tag = 1 
    end
    --发送叫分
    if device.platform == "windows"  then
        cc.exports.scheduler.performWithDelayGlobal(function()
--            CMsgLord:getInstance():sendCallScore(tag)
            self._scene:SendCall(tag)
        end, TIME_DELAY_FOR_PC)
    else
        self._scene:SendCall(tag)
    end

    --隐藏按钮
    self.m_pNodeCall_0:setVisible(false)
end

--先显示加倍，再发送加倍
function GameViewLayer:onAddTimesLocal(tag)

    --显示加倍
    local nAddTime = self:getAddTimeType(tag + 1)
    local chairID = PlayerInfo.getInstance():getChairID()
    local cbGender = self.g_gameDataLogic.m_cbGender[chairID]
    local isDouble = (tag + 1 == 2)
    self:onShowAddTime(POS_SELF, nAddTime, cbGender, isDouble)

    --停止闹钟
    self:stopClock(POS_SELF)

    --本地加倍保存(不加倍1/加倍2）
    self.g_gameDataLogic:setAddScoreLocal(true)
    self.g_gameDataLogic:setAddTimeLocal(tag + 1)
    if tag == 1 then tag = 0
    elseif tag == 2 then tag = 1
    end
    --发送加倍
    if device.platform == "windows" then
        cc.exports.scheduler.performWithDelayGlobal(function()
            self._scene:SendRaise(tag)
        end, TIME_DELAY_FOR_PC)
    else
        self._scene:SendRaise(tag)
    end

    --隐藏按钮
    self.m_pNodeJiaBei:setVisible(false)
end

--先显示过牌，再发送过牌
function GameViewLayer:onPassCardLocal()

    --过牌动作
    local outUser = PlayerInfo.getInstance():getChairID()
    local cbGender = self.g_gameDataLogic.m_cbGender[outUser]
    local nTipsType = E_TIP_TYPE.E_TIP_TYPE_CANCEL
    self:onShowCardPass(POS_SELF, nTipsType, cbGender, POS_NEXT)

    --切换倒计时
    self:resetClock(POS_NEXT, CLOCK_OUT_CARD, "onPassCardLocal(出牌倒计时)")

    --隐藏出牌按钮
    self.m_pNodeOutCard:setVisible(false)

    --本地过牌
    self.g_gameDataLogic:setPassCardLocal(true)
    self.g_gameDataLogic:setLastOutCardData({}, 0)

    --发送过牌
    if device.platform == "windows" then
        cc.exports.scheduler.performWithDelayGlobal(function()
            self._scene:SendPass()
        end, TIME_DELAY_FOR_PC)
    else
        self._scene:SendPass()
    end
end

--先显示出牌，再发送出牌
function GameViewLayer:onOutCardLocal(cbCardData, cbCardCount)

    --出牌动作
    self:onShowCardOut(POS_SELF, cbCardData, cbCardCount)

    --出牌特效和声音
    local cardtype = LordGameLogic:getInstance():GetCardType(cbCardData, cbCardCount)
    local value = GetCardValue(cbCardData[0])
    local outUser = PlayerInfo.getInstance():getChairID()
    local cbGender = self.g_gameDataLogic.m_cbGender[outUser]
    local bDani = self.g_gameDataLogic:getLastOutCardCount()
    local strDani = string.format("dani%d", math.random(1, 3))
    self:outcardAnimation_(cardtype, value, outUser, cbGender, 1, bDani, strDani, cbCardCount)

    --倒计时
    if self.m_bAutoLastCard then
        self:onUpdateNodeShow(self.m_pNodeOutCard, false)
        self:stopClock(POS_SELF)
    else
        self:resetClock(POS_NEXT, CLOCK_OUT_CARD, "onOutCardClicked(出牌倒计时)")
    end

    --本次由本地出牌
    self.g_gameDataLogic:setOutCardLocal(true) 
    self.g_gameDataLogic:setLastOutCardData(cbCardData, cbCardCount)
    local sendcards = {} 
    --发送出牌
    if device.platform == "windows" then
        cc.exports.scheduler.performWithDelayGlobal(function()
            --测试：测试错误数据 ----------------------------
            --table.insert(cbCardData, 100)
            --cbCardCount = cbCardCount + 1
            --------------------------------------------------
            
            for i = 0 , cbCardCount - 1 do
                sendcards[i+1] = self:RecoveryNumPai(cbCardData[i] )
            end
            dump(sendcards)
            self._scene:SendPlay(sendcards)
--            CMsgLord:getInstance():sendOutCard(cbCardData, cbCardCount)
        end, TIME_DELAY_FOR_PC)
    else
        for i = 0 , cbCardCount - 1 do
                sendcards[i+1] = self:RecoveryNumPai(cbCardData[i] )
        end
        dump(sendcards)
        self._scene:SendPlay(sendcards)
--        CMsgLord:getInstance():sendOutCard(cbCardData, cbCardCount)
    end
end

--先托管，再发送托管
function GameViewLayer:onRobotLocal()

    --托管
    self:setRobot(1)

    if device.platform == "windows" then
        self:doSomethingLater(function()
            self._scene:SendManage(true)         
        end, TIME_DELAY_FOR_PC)
    else
        self._scene:SendManage(true)
    end
end

--先取消，再发送取消
function GameViewLayer:onRobotCancelLocal()
    
    --取消托管
    self:setRobot(0)

    if device.platform == "windows" then
        self:doSomethingLater(function()
            self._scene:SendManage(false)
        end, TIME_DELAY_FOR_PC)
    else
        self._scene:SendManage(false)
    end
end

--抽牌
--收牌
function GameViewLayer:onBlankLocal()
    
end

function GameViewLayer:__onAnimation__() end

function GameViewLayer:outcardAnimation_(cardtype, value, outUser, cbGender, viewChair, bDani, strDani, cbCardCount)

    --最后一手牌有牌型动画延时时长
    if self.g_gameDataLogic.m_cbHandCardCount[outUser] == 0 then
        if (cardtype == CT_MISSILE_CARD) --火箭
        or (cardtype == CT_BOMB_CARD)    --炸弹
        or (cardtype == CT_THREE_LINE)   --飞机
        or (cardtype == CT_THREE_TAKE_ONE and self.g_gameDataLogic.m_cbOutCardCount > 4)
        or (cardtype == CT_THREE_TAKE_TWO and self.g_gameDataLogic.m_cbOutCardCount > 5)
        or (cardtype == CT_DOUBLE_LINE)  --连对
        or (cardtype == CT_SINGLE_LINE)  --顺子
        then
            self.m_fDelayOverAnim = DELAY_ANIMATION[cardtype]
        else
            self.m_fDelayOverAnim = 0
        end
    end

    if (cardtype == CT_MISSILE_CARD) --火箭
    then
        --等待播放完毕
        self:onOutCard_Before(false, true, false, "王炸")
    end

    if cardtype == CT_MISSILE_CARD then
        self:onAnimationRocket(viewChair)
        self:playSoundGender(cbGender, "wangzha", 0)

    elseif cardtype == CT_BOMB_CARD then
        self:onAnimationBomb(viewChair)
        self:playSoundGender(cbGender, "zhadan", 0)

    elseif cardtype == CT_DOUBLE_LINE then
        local strSound = (bDani > 0) and strDani or "liandui"
        self:playSoundGender(cbGender, strSound, 0)
        self:onAnimationLiandui(viewChair)

    elseif cardtype == CT_SINGLE_LINE then
        local strSound = (bDani > 0) and strDani or "shunzi"
        self:playSoundGender(cbGender, strSound, 0)
        self:onAnimationShunzi(viewChair)

    elseif cardtype == CT_THREE_LINE then
        local strSound = (bDani > 0) and strDani or "feiji"
        self:playSoundGender(cbGender, strSound, 0)
        self:onAnimationPlane(viewChair)

    elseif cardtype == CT_SINGLE then
        self:playSoundGender(cbGender, string.format("%d", value), 0)

    elseif cardtype == CT_DOUBLE then
        self:playSoundGender(cbGender, string.format("dui%d", value), 0)

    elseif cardtype == CT_THREE then
        self:playSoundGender(cbGender, string.format("tuple%d", value), 0)

    elseif cardtype == CT_THREE_TAKE_ONE then
        if cbCardCount > 4 then --飞机
            local strSound = (bDani > 0) and strDani or "feiji"
            self:playSoundGender(cbGender, strSound, 0)
            self:onAnimationPlane(viewChair)

        else --三带一
            local strSound = (bDani > 0) and strDani or "sandaiyi"
            self:playSoundGender(cbGender, strSound, 0)
        end

    elseif cardtype == CT_THREE_TAKE_TWO then
        if cbCardCount > 5 then --飞机
            local strSound = (bDani > 0) and strDani or "feiji"
            self:playSoundGender(cbGender, strSound, 0)
            self:onAnimationPlane(viewChair)

        else --三带一对
            local strSound = (bDani > 0) and strDani or "sandaiyidui"
            self:playSoundGender(cbGender, strSound, 0)
        end

    elseif cardtype == CT_FOUR_TAKE_ONE then
        local strSound = (bDani > 0) and strDani or "sidaier"
        self:playSoundGender(cbGender, strSound, 0)

    elseif cardtype == CT_FOUR_TAKE_TWO then
        local strSound = (bDani > 0) and strDani or "sidailiangdui"
        self:playSoundGender(cbGender, strSound, 0)
    end
end

function GameViewLayer:onAnimationChuntian(index) --春天1/反春天2
    
    if self.m_pAnimationCard[ACTION_CHUNTIAN] == nil then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(doudizhu4_chuntian)
        self.m_pAnimationCard[ACTION_CHUNTIAN] = ccs.Armature:create("doudizhu4_chuntian")
        self.m_pAnimationCard[ACTION_CHUNTIAN]:setName("chuntian")
        local function animationEnd(armature, movementType, action)
            if movementType == ccs.MovementEventType.complete then
                self:doSomethingLater(function()
                    self.m_pAnimationCard[ACTION_CHUNTIAN]:setVisible(false)

                    --结算
                    self:showResult()
                end, 1.0)
            end
        end
        self.m_pAnimationCard[ACTION_CHUNTIAN]:getAnimation():setMovementEventCallFunc(animationEnd)
        self.m_pAnimationCard[ACTION_CHUNTIAN]:addTo(self.m_pNodeEffect)
    end

    self.m_pAnimationCard[ACTION_CHUNTIAN]:setPosition(667, display.cy)
    self.m_pAnimationCard[ACTION_CHUNTIAN]:setVisible(true)
    self.m_pAnimationCard[ACTION_CHUNTIAN]:getAnimation():play("Animation" .. index)

    self:playSoundDelay("game/lord/sound/Special_Chuntian.mp3", 0.0)
end

function GameViewLayer:onAnimationRocket(index) --火箭
    
    if self.m_pAnimationCard[ACTION_HUOJIAN] == nil then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(doudizhu4_huojian)
        self.m_pAnimationCard[ACTION_HUOJIAN] = ccs.Armature:create("doudizhu4_huojian")
        self.m_pAnimationCard[ACTION_HUOJIAN]:setName("huojian")
        local function animationEnd(armature, movementType, action)
            if movementType == ccs.MovementEventType.complete then
                self.m_pAnimationCard[ACTION_HUOJIAN]:setVisible(false)
                
                --可以下一步了
                self:onOutCard_Before(false, false, true, "王炸完")
            end
        end
        self.m_pAnimationCard[ACTION_HUOJIAN]:getAnimation():setMovementEventCallFunc(animationEnd)
        self.m_pAnimationCard[ACTION_HUOJIAN]:addTo(self.m_pNodeEffect)
    end
    
    self.m_pAnimationCard[ACTION_HUOJIAN]:setPosition(667, display.cy)
    self.m_pAnimationCard[ACTION_HUOJIAN]:setVisible(true)
    self.m_pAnimationCard[ACTION_HUOJIAN]:getAnimation():play("Animation1")

    self:doSomethingLater(function()
        self:shakeLayer(0.5, 100)
    end, 0.0) --小震0.5s

    self:doSomethingLater(function()
        self:shakeLayer(1.0, 100)
    end, 1.0) --爆炸1.0s

    self:playSoundDelay("game/lord/sound/Special_Long_Bomb.mp3", 1.0)
end

function GameViewLayer:onAnimationBomb(index) --炸弹

    if self.m_pAnimationCard[ACTION_ZHADAN] == nil then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(doudizhu4_zhadan) 
        self.m_pAnimationCard[ACTION_ZHADAN] = ccs.Armature:create("doudizhu4_zhadan")
        self.m_pAnimationCard[ACTION_ZHADAN]:setName("zhadan")
        local function animationEnd(armature, movementType, action)
            if movementType == ccs.MovementEventType.complete then
                self.m_pAnimationCard[ACTION_ZHADAN]:setVisible(false)
            end
        end
        self.m_pAnimationCard[ACTION_ZHADAN]:getAnimation():setMovementEventCallFunc(animationEnd)
        self.m_pAnimationCard[ACTION_ZHADAN]:addTo(self.m_pNodeEffect)
    end

    self.m_pAnimationCard[ACTION_ZHADAN]:setPosition(677, display.cy)
    self.m_pAnimationCard[ACTION_ZHADAN]:setVisible(true)
    self.m_pAnimationCard[ACTION_ZHADAN]:getAnimation():play("Animation1")

    self:doSomethingLater(function()
        self:shakeLayer(0.8, 100)
    end, 0.5) --小震0.5s
   
    self:playSoundDelay("game/lord/sound/Special_Bomb_New.mp3", 0.0)
end

function GameViewLayer:onAnimationPlane(index) --飞机

    if self.m_pAnimationCard[ACTION_FEIJI] == nil then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(doudizhu4_feiji) 
        self.m_pAnimationCard[ACTION_FEIJI] = ccs.Armature:create("doudizhu4_feiji")
        self.m_pAnimationCard[ACTION_FEIJI]:setName("feiji")
        local function animationEnd(armature, movementType, action)
            if movementType == ccs.MovementEventType.complete then
                self.m_pAnimationCard[ACTION_FEIJI]:setVisible(false)
            end
        end
        self.m_pAnimationCard[ACTION_FEIJI]:getAnimation():setMovementEventCallFunc(animationEnd)
        self.m_pAnimationCard[ACTION_FEIJI]:addTo(self.m_pNodeEffect)
    end

    self.m_pAnimationCard[ACTION_FEIJI]:setPosition(667, display.cy)
    self.m_pAnimationCard[ACTION_FEIJI]:setVisible(true)
    self.m_pAnimationCard[ACTION_FEIJI]:getAnimation():play("Animation1")

    self:playSoundDelay("game/lord/sound/Special_plane.mp3", 0.0)
end

function GameViewLayer:onAnimationLiandui(index) --连对

    if self.m_pAnimationCard[ACTION_LIANDUI] == nil then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(doudizhu4_liandui) 
        self.m_pAnimationCard[ACTION_LIANDUI] = ccs.Armature:create("doudizhu4_liandui")
        self.m_pAnimationCard[ACTION_LIANDUI]:setName("liandui")
        local function animationEnd(armature, movementType, action)
            if movementType == ccs.MovementEventType.complete then
                self.m_pAnimationCard[ACTION_LIANDUI]:setVisible(false)
            end
        end
        self.m_pAnimationCard[ACTION_LIANDUI]:getAnimation():setMovementEventCallFunc(animationEnd)
        self.m_pAnimationCard[ACTION_LIANDUI]:addTo(self.m_pNodeEffect)
    end

    --移到牌上
    self.m_pAnimationCard[ACTION_LIANDUI]:setPosition(self.m_posOfEffect[index])
    self.m_pAnimationCard[ACTION_LIANDUI]:setVisible(true)
    self.m_pAnimationCard[ACTION_LIANDUI]:getAnimation():play("Animation1")

    self:playSoundDelay("game/lord/sound/Special_star.mp3", 0.0)
end

function GameViewLayer:onAnimationShunzi(index) --顺子

    if self.m_pAnimationCard[ACTION_SHUNZI] == nil then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(doudizhu4_shunzi) 
        self.m_pAnimationCard[ACTION_SHUNZI] = ccs.Armature:create("doudizhu4_shunzi")
        self.m_pAnimationCard[ACTION_SHUNZI]:setName("shunzi")
        local function animationEnd(armature, movementType, action)
            if movementType == ccs.MovementEventType.loopComplete then
                self.m_pAnimationCard[ACTION_SHUNZI]:setVisible(false)
            end
        end
        self.m_pAnimationCard[ACTION_SHUNZI]:getAnimation():setMovementEventCallFunc(animationEnd)
        self.m_pAnimationCard[ACTION_SHUNZI]:addTo(self.m_pNodeEffect)
    end

    --移到牌上
    self.m_pAnimationCard[ACTION_SHUNZI]:setPosition(self.m_posOfEffect[index])
    self.m_pAnimationCard[ACTION_SHUNZI]:setVisible(true)
    self.m_pAnimationCard[ACTION_SHUNZI]:getAnimation():play("Animation1")

    self:playSoundDelay("game/lord/sound/Special_star.mp3", 0.0)
end


------------------------------------------------------------------------------
function GameViewLayer:__onUpdateLayer__() end --更新界面元素

--更新音乐按钮
function GameViewLayer:onUpdateMusicButton(bBool)
    if bBool then
        self.m_pBtnMusic:loadTextureNormal(GUI_PREFIX .. "gui-menu-btn-music-1.png", ccui.TextureResType.plistType)
        self.m_pBtnMusic:loadTexturePressed(GUI_PREFIX .. "gui-menu-btn-music-2.png", ccui.TextureResType.plistType)
    else
        self.m_pBtnMusic:loadTextureNormal(GUI_PREFIX .. "gui-menu-btn-music-2.png", ccui.TextureResType.plistType)
        self.m_pBtnMusic:loadTexturePressed(GUI_PREFIX .. "gui-menu-btn-music-1.png", ccui.TextureResType.plistType)
    end
end

--更新音效按钮
function GameViewLayer:onUpdateSoundButton(bBool)
    
    if bBool then
        self.m_pBtnSound:loadTextureNormal(GUI_PREFIX .. "gui-menu-btn-sound-1.png", ccui.TextureResType.plistType)
        self.m_pBtnSound:loadTexturePressed(GUI_PREFIX .. "gui-menu-btn-sound-2.png", ccui.TextureResType.plistType)
    else
        self.m_pBtnSound:loadTextureNormal(GUI_PREFIX .. "gui-menu-btn-sound-2.png", ccui.TextureResType.plistType)
        self.m_pBtnSound:loadTexturePressed(GUI_PREFIX .. "gui-menu-btn-sound-1.png", ccui.TextureResType.plistType)
    end
end

--更新名字
function GameViewLayer:onUpdateUserName()
    local name = GlobalUserItem.tabAccountInfo.nickname
    local strName = LuaUtils.getDisplayNickNameInGame(name, 13, 13)
    self.m_pLbUserName:setString(strName)
end

--更新金币
function GameViewLayer:onUpdateUserScore(score)

    score = score or GlobalUserItem.tabAccountInfo.into_money

    local strScore = (score)

    self.m_pLbUserGold:setString(strScore)
end

--更新倍数
function GameViewLayer:onUpdateBeishu(beishu)
    if beishu and beishu == 0 then
        self.m_pLbBeishu:setString(0)
    else
        local iBeishu = self.g_gameDataLogic:getCurrentMuliple() == 0 and 1 or self.g_gameDataLogic:getCurrentMuliple()
--        local iJiabei = self:getJiaBeiCount()
        self.m_pLbBeishu:setString(iBeishu )
    end
end

--更新底分
function GameViewLayer:onUpdateDifen(difen)
    if self.deskinfo.unit_money and difen == nil then
        difen = self.deskinfo.unit_money
    else
        difen = 0
    end

    local serverType = PlayerInfo.getInstance():getServerType()
    if serverType == 2 then -- 体验房的底分从情景消息读取
        difen = self.g_gameDataLogic:getBaseScore()
    end
    local strScore = (difen)

    self.m_pLbDifen:setString(strScore)
end

--更新其他玩家显示
function GameViewLayer:onUpdateOtherPlayerShow(index, isShow)
    
    if index < 0 or 2 < index or index == 1 then
        return
    end

    self.m_pNodesOther[index]:setVisible(isShow)
end

--更新其他玩家姓名
function GameViewLayer:onUpdateOtherPlayerName(index, name)

    if index < 0 or 2 < index or index == 1 or name == nil then
        return
    end
    local strName = LuaUtils.getDisplayNickNameInGame(name)
    self.m_pNodesOther[index]:getChildByName("Name"):setString(strName)
end

--更新其他玩家金币
function GameViewLayer:onUpdateOtherPlayerGold(index, gold)
    if index < 0 or 2 < index or index == 1 or gold == nil then
        return
    end
    local strGold = (gold)
    self.m_pNodesOther[index]:getChildByName("Gold"):setString(strGold)
end

--更新叫牌
function GameViewLayer:onUpdateBankerCard(isShow)

    isShow = isShow or false
    
    for i = 0, 2 do
        if isShow then
            local data = self.g_gameDataLogic.m_cbBankerCard[i]
            self.m_pLordCard[i]:setCardData(data)
            self.m_pLordCard[i]:setBack(false)
        else
            self.m_pLordCard[i]:setBack(true)
        end
    end
end

--更新叫分
function GameViewLayer:onUpdateBankerScore(isShow)
    
    isShow = isShow or false

    if isShow then
        local score = 3
        local path = string.format("game/lord/gui-image/gui-icon-score-%d.png", score)
        self.m_pLockScore:loadTexture(path, ccui.TextureResType.plistType)
        self.m_pLockScore:setVisible(true)
    else
        self.m_pLockScore:setVisible(false)
    end
end

--显示牌剩余数
function GameViewLayer:onUpdateCountShow(index, isShow)
    
    if index < 0 or 2 < index or index == 1 then
        return
    end

    self.m_pNodesCount[index]:setVisible(isShow)
end

--更新牌剩余数
function GameViewLayer:onUpdateCountLabel(index, count)

    if index < 0 or 2 < index then
        return
    end
    self.m_pNodesCount[index]:getChildByName("Label_card"):setString(count)
end

--显示提示
function GameViewLayer:onUpdateTipsOfPlayer(i, isShow)
    
    if i < 0 or 4 < i then
        return
    end

    self.m_pSpriteTips[i]:setVisible(isShow)
end

--提示
function GameViewLayer:onUpdateTipsType(i, nType)

    --fixbug:未知情况下为空
    if i == nil or nType == nil then
        return
    end

    if i < 0 or 2 < i then
        return
    end

    if nType < 1 or 7 < nType then
        return
    end

    local path = GUI_PREFIX .. TEXTURE_TIPS[nType]
    self.m_pSpriteTips[i]:setSpriteFrame(path)
    self.m_pSpriteTips[i]:setVisible(true)
end

--提示声音
function GameViewLayer:onUpdateTipsSound(nGender, nType)

    --fixbug:未知情况下为空
    if nGender == nil or nType == nil then
        return
    end

    if nGender < 0 or 1 < nGender then
        return
    end

    if nType < 1 or 7 < nType then
        return
    end

    if nType == E_TIP_TYPE.E_TIP_TYPE_CANCEL then
        self:playSoundGender(nGender, SOUNDS_TIPS[nType] .. math.random(1, 4))
    else
        self:playSoundGender(nGender, SOUNDS_TIPS[nType])
    end
end

--显示节点
function GameViewLayer:onUpdateNodeShow(node, bVisible)
    node:setVisible(bVisible)
end

--更新按钮
function GameViewLayer:onUpdateButtonEnable(button, bEnable)

    button:setTouchEnabled(bEnable)
--    button:setBright(false)
    if bEnable == false then
        button:setColor(cc.c3b(230, 230, 230))
    end
end

--是否托管
function GameViewLayer:onUpdateRobotAuto(index)
    
    local bRobot = self.g_gameDataLogic:getUserRobot(index) > 0
    local nTimes = self.g_gameDataLogic.m_cbUserOffLineTimes[index]
    local nLimit = self.g_gameDataLogic:getOverTimeLimt()
    local bForce = nTimes >= nLimit
    local viewChair = self.g_gameDataLogic:SwitchViewChairID(index)
    self:onUpdateLogoRobot(viewChair, bRobot or bForce)
end

--是否强制托管
function GameViewLayer:onUpdateRobotForce()

    local chair = PlayerInfo.getInstance():getChairID()
    local bRobot = self.g_gameDataLogic:getUserRobot(chair) > 0
    local nTimes = self.g_gameDataLogic.m_cbUserOffLineTimes[chair]
    local nLimit = self.g_gameDataLogic:getOverTimeLimt()
    local bForce = nTimes >= nLimit
    self:onUpdateNodeShow(self.m_pNodeRobot, (bRobot or bForce) == true)
    self:onUpdateNodeShow(self.m_pBtnRobot, (bRobot or bForce) == false)
    self:onUpdateNodeShow(self.m_pBtnNoRobot, bForce == false)
    self:onUpdateNodeShow(self.m_pSpriteForce, bForce == true)
    self.m_pCardLayer:setCanTouch((bRobot or bForce) == false)
end

--斗地主标识
function GameViewLayer:onUpdateLogoLord(index, isShow)
    
    if index < 0 or 2 < index then
        return
    end

    self.m_pNodesLogoLord[index]:setVisible(isShow)
    self:onUpdateLogoPosistion(index)
end

--加倍标志
function GameViewLayer:onUpdateLogoDouble(index, isShow)
    
    if index < 0 or 2 < index then
        return
    end

    self.m_pNodesLogoDouble[index]:setVisible(isShow)
    self:onUpdateLogoPosistion(index)
end

--托管标志
function GameViewLayer:onUpdateLogoRobot(index, isShow)
    
    if index < 0 or 2 < index then
        return
    end

    self.m_pNodesLogoRobot[index]:setVisible(isShow)

    if isShow == false then
        return
    end

    if self.m_pNodesLogoRobot[index]:getChildByName("Logo_Robot") == nil then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(doudizhu4_tishi)  
        local pAnim = ccs.Armature:create("doudizhu4_tishi")
        pAnim:getAnimation():play("Animation1")
        pAnim:setName("Logo_Robot")
        
        self.m_pNodesLogoRobot[index]:removeAllChildren()
        self.m_pNodesLogoRobot[index]:addChild(pAnim)
    end

    self.m_pNodesLogoRobot[index]:getChildByName("Logo_Robot"):getAnimation():play("Animation1")
    self:onUpdateLogoPosistion(index)
end

--离线标志
function GameViewLayer:onUpdateLogoOffline(index, isShow)

    if index < 0 or 2 < index then
        return
    end

    self.m_pNodesLogoOffline[index]:setVisible(isShow)

    if isShow == false then
        return
    end

    if self.m_pNodesLogoOffline[index]:getChildByName("Logo_Offline") == nil then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(doudizhu4_tishi)
        local pAnim = ccs.Armature:create("doudizhu4_tishi")
        pAnim:setName("Logo_Offline")
        pAnim:getAnimation():play("Animation2")
        
        self.m_pNodesLogoOffline[index]:removeAllChildren()
        self.m_pNodesLogoOffline[index]:addChild(pAnim)
    end

    self.m_pNodesLogoOffline[index]:getChildByName("Logo_Offline"):getAnimation():play("Animation2")
    self:onUpdateLogoPosistion(index)
end

--更新logo位置
function GameViewLayer:onUpdateLogoPosistion(i)
    local currentIndex = 0
    local currentPosition = cc.p(0, 0)
    if self.m_pNodesLogoLord[i]:isVisible() then
        currentIndex = currentIndex + 1
        currentPosition = self.m_posOfLogo[i][currentIndex]
        self.m_pNodesLogoLord[i]:setPosition(currentPosition)
    end
    if self.m_pNodesLogoDouble[i]:isVisible() then
        currentIndex = currentIndex + 1
        currentPosition = self.m_posOfLogo[i][currentIndex]
        self.m_pNodesLogoDouble[i]:setPosition(currentPosition)
    end
    if self.m_pNodesLogoRobot[i]:isVisible() then
        currentIndex = currentIndex + 1
        currentPosition = self.m_posOfLogo[i][currentIndex]
        self.m_pNodesLogoRobot[i]:setPosition(currentPosition)
    end
    if self.m_pNodesLogoOffline[i]:isVisible() then
        currentIndex = currentIndex + 1
        currentPosition = self.m_posOfLogo[i][currentIndex]
        self.m_pNodesLogoOffline[i]:setPosition(currentPosition)
    end
end

--报警标志
function GameViewLayer:onUpdateLogoAlert(index, isShow)
    
    if index < 0 or 2 < index then
        return
    end    

    self.m_pNodesLogoAlert[index]:setVisible(isShow)

    if self.m_pNodesLogoAlert[index]:getChildByName("Logo_Alert") == nil then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(doudizhu4_jingdeng) 
        local pAnim = ccs.Armature:create("doudizhu4_jingdeng")
        pAnim:getAnimation():play("Animation1")
        pAnim:setName("Logo_Alert")

        self.m_pNodesLogoAlert[index]:removeAllChildren()
        self.m_pNodesLogoAlert[index]:addChild(pAnim)
    end
end

--更新闹钟
function GameViewLayer:onUpdateClockCount(index, isShow, nCount)
    
    if index < 0 or 2 < index then
        return
    end

    isShow = isShow and nCount >= 0

    if isShow then
        self.m_pNodesClock[index]:setVisible(isShow)
        self:onUpdateClockLabel(index, nCount)
    else
        self:stopClock(index)
    end
end

--更新闹钟数字
function GameViewLayer:onUpdateClockLabel(index, nCount)
    
    if index < 0 or 2 < index then
        return
    end

    nCount = nCount or 0

    self.m_pNodesClock[index]:getChildByName("Label"):setString(nCount)
end

--更新闹钟倒计时
function GameViewLayer:onUpdateClockBar(index)
    if index < 0 or 2 < index then
        return
    end

    local percent = 0 
    if self.m_nProgressBar[index][1] > 0 and self.m_nProgressBar[index][2] > 0 then
        percent = self.m_nProgressBar[index][1] / self.m_nProgressBar[index][2] * 100
    end
    self.m_pNodesClockBar[index]:setPercentage(percent)

    local color = self:getColorByValue(percent)
    self.m_pNodesClockBar[index]:setColor(color)
end

--更新玩家变身
function GameViewLayer:onUpdateChangePlayer(index)
    
    if index < 0 or 2 < index then
        return
    end

    if self.m_pAnimChange[index] == nil then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(jueseqiehuan_1)
        self.m_pAnimChange[index] = ccs.Armature:create("jueseqiehuan_1")
        self.m_pAnimChange[index]:setPositionY(120)
        self.m_pAnimChange[index]:setScale(1.3)
        self.m_pAnimChange[index]:addTo(self.m_pNodePlayer[index], 1)
    end
    self.m_pAnimChange[index]:getAnimation():play("Animation1")
end

--更新玩家动画：位置/人物
function GameViewLayer:onLoadPlayerSpine(index, who)

    if index < 0 or 2 < index or who < LANDLORD_MALE or FARMER_FEMALE < who then
        return
    end

    if self.m_pSpinePlayer[index] then
        self.m_pSpinePlayer[index]:removeFromParent()
        self.m_pSpinePlayer[index] = nil
    end

    if self.m_pSpinePlayer[index] == nil then
        local strJson, strAtlas = SPINE_NAME[who][1], SPINE_NAME[who][2]
        if self.m_pSpinePlayer[index] == nil then
            self.m_pSpinePlayer[index] = sp.SkeletonAnimation:create(strJson, strAtlas)
            self.m_pSpinePlayer[index]:setName(who)
            self.m_pSpinePlayer[index]:addTo(self.m_pNodePlayer[index])
        end
    end
end

--更新玩家动作:位置/动作
function GameViewLayer:onUpdatePlayerAction(index, doing)

    if index < 0 or 2 < index  or doing < ACTION_NORMAL or ACTION_LOSE < doing then
        return
    end

    if self.m_pSpinePlayer[index] then
        local name = self.m_pSpinePlayer[index]:getName()
        local stringAnim = ANIMATION_NAME[tonumber(name)][tonumber(doing)]
        self.m_pSpinePlayer[index]:setAnimation(0, stringAnim, true)
    end
end

--更新结算动画
function GameViewLayer:onUpdateWinAction()

    if self.m_pAnimationOver == nil then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(doudizhu4_jiesuan)
        self.m_pAnimationOver = ccs.Armature:create("doudizhu4_jiesuan")
        local function animationEnd(armature,movementType,strName)
            if movementType == ccs.MovementEventType.complete then
                if self:getIsWinInTheEnd() then
                    self.m_pAnimationOver:getAnimation():play("Animation2")
                end
                self:showResultEnd()
            end
        end
        self.m_pAnimationOver:getAnimation():setMovementEventCallFunc(animationEnd)
        self.m_pAnimationOver:addTo(self.m_pNodeWin)
    end

    local isWin = self:getIsWinInTheEnd()
    local pName = isWin and "Animation1" or "Animation3"
    self.m_pAnimationOver:getAnimation():play(pName)
end

function GameViewLayer:onUpdateInfoAction(isWin)
    
    local pAction = cc.Sequence:create(
        cc.Show:create(),
        cc.FadeIn:create(0.4))
    self.m_pNodeInfo:setOpacity(0)
    self.m_pNodeInfo:runAction(pAction)
end

function GameViewLayer:onUpdateWinInfo()
    
    local banker = self.g_gameDataLogic:getBankerUser()
    --当前底分
    local iBeishu = self.g_gameDataLogic:getCurrentMuliple()
    --结算倍数
    local vecBeishu = {}
    for i = 0, 2 do
        if i ~= banker then
            vecBeishu[i] = iBeishu --* self.g_gameDataLogic.m_iAddTimes[i]
        end
    end
    --地主倍数
    local sumBeishu = 0
    for i = 0, 2 do
        if i ~= banker then
            sumBeishu = sumBeishu + vecBeishu[i]
        end
    end
    vecBeishu[banker] = sumBeishu 

    for i = 0, 2 do
        local viewChair = self.g_gameDataLogic:SwitchViewChairID(i)
        local user = {}
        for k,v in ipairs(self.memberinfos) do
            if v.position == i then
                user = v
            end
        end
  
        local score = self.g_gameDataLogic.m_pGameConclude.lGameScore[i]
--        local bomb = self.g_gameDataLogic.m_pGameConclude.cbEachBombCount[i]
        local bLandlord = banker == user.position
        local strName = string.format("%s", user.nickname)
        if viewChair ~= POS_SELF then
            strName = LuaUtils.getDisplayNickNameInGame(user.nickname)
        end
        local strBeishu = string.format("x%d", vecBeishu[i])
        local strScore = (score > 0 and "+" or "") .. string.format("%0.2f", score )
        self.m_pSpEndLord[viewChair]:setVisible(bLandlord)
        self.m_pLbEndName[viewChair]:setString(strName)
        self.m_pLbEndBei[viewChair]:setString(strBeishu)
        self.m_pLbEndGold[viewChair]:setString(strScore)
    end
    
    local isWin = self:getIsWinInTheEnd()

    --颜色
    local color = isWin and self.m_tColorWin or self.m_tColorLose
    self.m_pLbEndName[POS_SELF]:setTextColor(color)
    self.m_pLbEndBei[POS_SELF]:setColor(color)
    self.m_pLbEndGold[POS_SELF]:setColor(color)

    --背景图
    local path = isWin and "gui-bg-over-win.png" or "gui-bg-over-lose.png"
    self.m_pImageBg:loadTexture("game/lord/gui/" .. path, ccui.TextureResType.localType)
end

--结算得分
function GameViewLayer:onUpdateWinScore(index, score)
    
    if index < 0 or 2 < index then
        return
    end

    local fontName = "" --字体
    if score > 0 then
        fontName = "game/lord/font/ddz_sz3.fnt"
    else
        fontName = "game/lord/font/ddz_sz2.fnt"
    end
    self.m_pLabelEndScore[index]:setFntFile(fontName)

    local strScore = "" --分数
    if score > 0 then
        strScore = string.format("+%0.2f", score )
    else
        strScore = string.format("%0.2f", score )
    end
    self.m_pLabelEndScore[index]:setString(strScore)

    --动作
    local posX, posY = self.m_pLabelEndScore[index]:getPosition()
    local size = self.m_pLabelEndScore[index]:getContentSize()
    local pAction = cc.Sequence:create(
        cc.Place:create(cc.p(posX, posY + size.height * 2)),
        cc.Show:create(),
        cc.Spawn:create(
            cc.EaseBounceOut:create(cc.MoveBy:create(0.5, cc.p(0, - size.height * 2))),
            cc.FadeIn:create(0.5)),
        cc.Place:create(cc.p(posX, posY)))
    self.m_pLabelEndScore[index]:stopAllActions()
    self.m_pLabelEndScore[index]:runAction(pAction)
end

function GameViewLayer:__get__() end

function GameViewLayer:getCallScoreType(nType)

    local nScoreType = {
        [0] = E_TIP_TYPE.E_TIP_TYPE_SCORE0,
        [1] = E_TIP_TYPE.E_TIP_TYPE_SCORE1,
        [2] = E_TIP_TYPE.E_TIP_TYPE_SCORE2,
        [3] = E_TIP_TYPE.E_TIP_TYPE_SCORE3,
    } --没叫分是（-2）
    setDefault(nScoreType, E_TIP_TYPE.E_TIP_TYPE_SCORE0)
    return nScoreType[nType]
end

function GameViewLayer:getAddTimeType(nType)

    local nAddTime = {
        [1] = E_TIP_TYPE.E_TIP_TYPE_NO_ADDTIMES,
        [2] = E_TIP_TYPE.E_TIP_TYPE_ADDTIMES,
    }
    setDefault(nAddTime, E_TIP_TYPE.E_TIP_TYPE_NO_ADDTIMES)
    return nAddTime[nType]
end

function GameViewLayer:getColorByValue(nValue)--100-0

    if nValue < 0 or 100 < nValue then
        return cc.c3b(255, 255, 255)
    end

    local nColor = 100 - nValue --0-100

    --由绿到黄到红的渐变色值(0,255,0)->(255,255,0)->(255,0,0)
    local r, g, b = 0, 0, 0
    if nColor < 50 then
        r = 255 * (nColor / 50)
        g = 255
    else
        r = 255
        g = 255 * ((100 - nColor) / 50)
    end
    --printf("%03.2f, %03.2f, %03.2f, %03.2f", nColor, r, g, b)
    return cc.c3b(r, g, b)
end

function GameViewLayer:getIsWinInTheEnd()
    local nMeChair = PlayerInfo.getInstance():getChairID()
    local score = self.g_gameDataLogic.m_pGameConclude.lGameScore[nMeChair]
    if not score then
        nMeChair = self.g_gameDataLogic:getGameOverChairID()
        score = self.g_gameDataLogic.m_pGameConclude.lGameScore[nMeChair]
    end
    return score > 0
end

function GameViewLayer:getGameBeishu()
    
    local vecBeishu = { 0, 0, 0, 0, 0, }

    --1底分:0/1/2/3
    vecBeishu[1] = self.g_gameDataLogic:getBankerScore()
    --2炸弹:0/1/2/3
    vecBeishu[2] = self.g_gameDataLogic:getBombCount()
    --3春天:0/1
    vecBeishu[3] = self.g_gameDataLogic:getChuntianCount()
    --4加倍:0/1/2/3/4
    vecBeishu[4] = self.g_gameDataLogic:getJiaBeiCount()
    --5总倍数
    vecBeishu[5] = vecBeishu[1] * math.pow(2, vecBeishu[2]) * math.pow(2, vecBeishu[3]) * vecBeishu[4]

    if vecBeishu[2] > 0 then
        vecBeishu[2] = math.pow(2, vecBeishu[2])
    end
    if vecBeishu[3] > 0 then
        vecBeishu[3] = math.pow(2, vecBeishu[3])
    end

    if self.g_gameDataLogic:isMeBanker() then
        vecBeishu[1] = vecBeishu[1] * vecBeishu[4]
        vecBeishu[4] = 0
    end

    return vecBeishu
end

function GameViewLayer:__test_code__() end --测试代码

function GameViewLayer:test_code()
    --self:test_logo_position() --测试标志显示
    --self:test_lord_spine() --测试人物显示
    --self:test_sure_lord() --测试确定地主
    --self:test_card_position() --测试牌坐标
    --self:test_card_fapai() --测试发牌动作
    --self:test_card_animation() --测试牌型
    --self:test_clock_bar() --测试倒计时颜色
    --self:test_game_over() --测试结算界面
    self.m_bIsMoveMenu = true
end

function GameViewLayer:test_logo_position()
    
    self.m_pNodePlay:setVisible(true)
    
    for i = 0, 2 do
        self:onUpdateLogoLord(i, true)
        self:onUpdateLogoDouble(i, true)
        self:onUpdateLogoRobot(i, true)
        self:onUpdateLogoOffline(i, true)
        self:onUpdateLogoAlert(i, true)
        self:onUpdateCountShow(i, true)
        self:onUpdateOtherPlayerShow(i, true)
    end
end

local countRen = 0
function GameViewLayer:test_lord_spine() --测试人物动画
    
    --玩家动画
    if countRen == 4 then countRen = 1
    else                  countRen = countRen + 1
    end
    local who = countRen
    for i = 0, 2 do
        self:onUpdateChangePlayer(i)
        self:onLoadPlayerSpine(i, who)
    end
    self:onUpdatePlayerAction(0, 1)
    self:onUpdatePlayerAction(1, 2)
    self:onUpdatePlayerAction(2, 3)
end

function GameViewLayer:test_sure_lord()
    self.m_pNodeStart:setVisible(false)
    self.m_pNodePlay:setVisible(true)
    self.m_pNodeLogoLord:setVisible(true)
    self:startDispatchLord(1)
end

local countPos = 0
function GameViewLayer:test_card_position() --测试牌位置
    if countPos < 20 then countPos = countPos + 1
    else                  countPos = 1
    end

    self.m_pNodePlay:setVisible(true)
    self.m_pNodeStart:setVisible(false)

    for i = 0, 2, 1 do
        local cbCardData = {}
        local cbCardCount = countPos
        local iStartIndex = math.random(1, 54 - cbCardCount)
        for index = 0, cbCardCount - 1 do
            cbCardData[index] = m_cbCardData[index + iStartIndex]
        end
        self.m_showOutCard[i]:SetCardData(cbCardData, cbCardCount)
        self.m_showOutCard[i]:setVisible(true)

        if i == 1 then
            self.m_pCardLayer:SetCardData(cbCardData, cbCardCount, false)
        end
    end
end

function GameViewLayer:test_card_fapai() --测试发牌

    self.m_pNodeStart:setVisible(false)
    self.m_pNodePlay:setVisible(true)
    self.m_pNodeLock:setVisible(true)
    self.m_pNodeCount:setVisible(true)
    for i = 0, 2 do
        self.m_pLockCards[i]:setVisible(false)
    end
    self.m_pLockScore:setVisible(false)
    self:onUpdateCountShow(0, true)
    self:onUpdateCountShow(2, true)
    --self:onUpdateBankerCard(true)

    local cbCardData = {}
    local cbCardCount = 17
    local nCount = #m_cbCardData
    for i = 0, cbCardCount - 1 do
        cbCardData[i] = m_cbCardData[i + 10]
    end
    self.m_pCardLayer:SetCardData(cbCardData, cbCardCount, true)
    LordGameLogic.getInstance():SortCardList(cbCardData, cbCardCount)
    self:startDispatchCard(self.m_pCardLayer.m_vCardSp, self.m_pLordCard, cbCardData)
end

local countAnim = 0
function GameViewLayer:test_card_animation() --测试动画
    if countAnim < 3 then countAnim = countAnim + 1
    else                   countAnim = 0
    end

    self.m_pNodeStart:setVisible(false)
    self.m_pNodePlay:setVisible(true)
    self.m_pNodeEffect:setVisible(true)

    --self:onAnimationChuntian(math.random(1, 2)) --春天
    --self:onAnimationRocket(math.random(1, 3) - 1) --火箭
    --self:onAnimationBomb(math.random(1, 3) - 1) --炸弹
    --self:onAnimationPlane(math.random(1, 3) - 1) --飞机
    --self:onAnimationLiandui(math.random(1, 3) - 1) --连对
    --self:onAnimationShunzi(math.random(1, 3) - 1) --顺子
end

function GameViewLayer:test_clock_bar() --测试转圈

    self.m_pNodeStart:setVisible(false)
    self.m_pNodePlay:setVisible(true)
    self.m_pNodeClock:setVisible(true)
    self:startProgressBarSchedule()
    self.g_gameDataLogic:setGameStatus(GS_T_CALL)
    self.g_gameDataLogic:setIsAddTimesStatus(1)
    self.g_gameDataLogic:setTimeCallScore(10)

    self:startClock(POS_SELF, CLOCK_CALL_SCORE, "test")
end

function GameViewLayer:test_game_over() --测试结算动画
    
    self.m_pNodeStart:setVisible(false)
    self.m_pNodeWait:setVisible(false)
    self.m_pNodePlay:setVisible(false)
    self.m_pNodeOver:setVisible(true)

    self.m_pNodeWin:setVisible(true)
    self.m_pNodeInfo:setVisible(true)
    self:onUpdateWinAction()
    self:onUpdateInfoAction()
end

return GameViewLayer
--endregion