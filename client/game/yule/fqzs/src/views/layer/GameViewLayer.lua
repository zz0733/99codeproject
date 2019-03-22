--
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local module_pre = "game.yule.fqzs.src"
local GameViewLayer = class("GameViewLayer",function(scene)
        local gameViewLayer = display.newLayer()
    return gameViewLayer
end)
local CBetManager          = appdf.req(module_pre .. ".manager.CBetManager")
local Effect          = appdf.req(module_pre .. ".manager.fqzsEffect")
local RulerLayer           = appdf.req(module_pre .. ".layer.RulerLayer") 
local CMsgAnimal           = appdf.req(module_pre .. ".proxy.CMsgAnimal")
local AnimalSceneRes       = appdf.req(module_pre .. ".scene.AnimalSceneRes")
local AnimalOtherInfoLayer = appdf.req(module_pre .. ".layer.AnimalOtherInfoLayer")
local CChipCacheManager    = appdf.req(module_pre .. ".manager.CChipCacheManager")
local MessageBoxNew        = appdf.req(module_pre .. ".manager.MessageBoxNew")
local MsgBoxPreBiz         = appdf.req(module_pre .. ".public.MsgBoxPreBiz")
local PlayerInfo = appdf.req(appdf.EXTERNAL_SRC .. "PlayerInfo")  

local CUserManager         = cc.exports.CUserManager
local FloatMessage = cc.exports.FloatMessage

local HANDLE_NORMAL        = 1  --正常下注
local HANDLE_CONTINU       = 2  --续投
local HANDLE_CLEAN         = 3  --清除
local JETTON_ITEM_COUNT    = 5  --6  --6个筹码
local CHIP_ITEM_COUNT      = 11 --下注项数 （ 4飞禽项 4走兽项 鲨鱼项 2双倍项 ）
local CHIP_FLY_STEPDELAY   = 0.02 --筹码连续飞行间隔
local CHIP_FLY_TIME        = 0.2 --飞筹码动画时间
local CHIP_JOBSPACETIME    = 0.1 --飞筹码任务队列间隔
local CHIP_FLY_SPLIT       = 20 -- 飞行筹码分组 分XX次飞完
local CHIP_REWARD          = { 8,8,6,12,8,8,6,12,24,2,2} -- 投注区域赔率

--动物的常量定义
local AnimalDefine = {
    [0]  = {STRING_ANIMATION_NAME = "Animation8",               STRING_ANIMAL_TEXT = "燕子飞禽X6",  STRING_ANIMALS = "fqzs_animal_yanzi"    } ,
    [1]  = {STRING_ANIMATION_NAME = "Animation3",               STRING_ANIMAL_TEXT = "孔雀飞禽X8",  STRING_ANIMALS = "fqzs_animal_kongque"  } ,
    [2]  = {STRING_ANIMATION_NAME = "Animation1",               STRING_ANIMAL_TEXT = "鸽子飞禽X8",  STRING_ANIMALS = "fqzs_animal_gezi"     } ,
    [3]  = {STRING_ANIMATION_NAME = "Animation4",               STRING_ANIMAL_TEXT = "老鹰飞禽X12", STRING_ANIMALS = "fqzs_animal_ying"     } ,
    [4]  = {STRING_ANIMATION_NAME = "Animation6",               STRING_ANIMAL_TEXT = "兔子走兽X6",  STRING_ANIMALS = "fqzs_animal_tuzi"     } ,
    [5]  = {STRING_ANIMATION_NAME = "Animation7",               STRING_ANIMAL_TEXT = "熊猫走兽X8",  STRING_ANIMALS = "fqzs_animal_xiongmao" } ,
    [6]  = {STRING_ANIMATION_NAME = "Animation2",               STRING_ANIMAL_TEXT = "猴子走兽X8",  STRING_ANIMALS = "fqzs_animal_houzi"    } ,
    [7]  = {STRING_ANIMATION_NAME = "Animation5",               STRING_ANIMAL_TEXT = "狮子走兽X12", STRING_ANIMALS = "fqzs_animal_shizi"    } ,
    [8]  = {STRING_ANIMATION_NAME = "feiqinzoushou_shayu25",    STRING_ANIMAL_TEXT = "鲨鱼X24",     STRING_ANIMALS = "fqzs_animal_shayu"    } ,
    [9]  = {STRING_ANIMATION_NAME = "feiqinzoushou_jinshax100", STRING_ANIMAL_TEXT = "黄金鲨X100",  STRING_ANIMALS = "fqzs_animal_shayuX100"} ,
    [10] = {STRING_ANIMATION_NAME = "feiqinzoushou_tongchi",    STRING_ANIMAL_TEXT = "通吃",        STRING_ANIMALS = "fqzs_animal_tongchi"  } ,
    [11] = {STRING_ANIMATION_NAME = "feiqinzoushou_tongpei",    STRING_ANIMAL_TEXT = "通赔",        STRING_ANIMALS = "fqzs_animal_tongpei"  } ,
}

-- 游戏状态图片资源文件描述
local GameStatusDesc = {
    [CMsgAnimal.GAMESTATUS.STATUS_BEGANCHIP] = "fqzs_status_xiazhu.png",   --下注
    [CMsgAnimal.GAMESTATUS.STATUS_STOPCHIP]  = "fqzs_status_xiazhu.png",   --停止下注
    [CMsgAnimal.GAMESTATUS.STATUS_LOTTERY]   = "fqzs_status_kaijiang.png", --开奖
    [CMsgAnimal.GAMESTATUS.STATUS_IDLETIME]  = "fqzs_status_kaijiang.png"  --空闲
}

--声音文件路径
local SOUND_OF_SYSTEM = {
    "game/animals/soundpublic/sound-win-big-1.mp3",     --0: >1000000 win
    "game/animals/soundpublic/sound-win-big-2.mp3",     --1: >1000000
    "game/animals/soundpublic/sound-win-middle-1.mp3",  --2: >500000
    "game/animals/soundpublic/sound-win-middle-2.mp3",  --3: >500000
    "game/animals/soundpublic/sound-win-small-1.mp3",   --4: >200000
    "game/animals/soundpublic/sound-win-small-2.mp3",   --5: >200000
    "game/animals/soundpublic/sound-lose-big-",         --6: >1000000 lost
    "game/animals/soundpublic/sound-lose-middle-1.mp3", --7: >500000
    "game/animals/soundpublic/sound-lose-middle-2.mp3", --8: >500000
    "game/animals/soundpublic/sound-lose-small-1.mp3",  --9: >200000
    "game/animals/soundpublic/sound-lose-small-2.mp3",  --10:>200000
    "game/animals/sound/sound-fly-turn.mp3",            --11:跑马灯  已经使用
    "game/animals/sound/sound-fly-",                    --12:动物   已使用
    "game/animals/soundpublic/sound-clock-ring.mp3",    --13:闹钟声音 未使用
    "game/animals/soundpublic/sound-count-down.mp3",    --14:倒数时间
    "game/animals/sound/sound-fly-bg.mp3",              --15:背景音乐
    "game/animals/soundpublic/sound-start-wager.mp3",   --16:播放开始投注
    "game/animals/soundpublic/sound-end-wager.mp3",     --17:播放停止下注
    "game/animals/soundpublic/sound-pond-",             --18:播放投注
    "game/animals/soundpublic/sound-gold.wav",          --19:金币更新
    "game/animals/soundpublic/zhuang-1.mp3",            --20:庄家
    "game/animals/soundpublic/zhuang-2.mp3",            --21:庄家
    "game/animals/soundpublic/sound-jetton.mp3",        --22:筹码
    "game/animals/soundpublic/sound-close.mp3",         --23:关闭
    "game/animals/soundpublic/sound-clear.mp3",         --24:清除
}

function GameViewLayer:ctor(scene)
    -- 进入游戏重置设计分辨率
    math.randomseed(os.time())
    self:enableNodeEvents()
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
    self.m_pRootUI = cc.CSLoader:createNode("game/animals/FQZS_Game_UI.csb")
    local diffY = (display.size.height - 750) / 2
    self.m_pRootUI:setPosition(cc.p(0, diffY))
    self.m_pRootUI:addTo(self.m_rootUI)
--    self:init()
    ExternalFun.registerNodeEvent(self)
    self._scene = scene
    self.m_bEnterBackground = false
end

function GameViewLayer:initVars()
    
--    self.m_pRootUI = nil
    self.m_pAnimalUI = nil
    self.m_PanelGameLayer = nil
    self.m_pListViewHistory = nil
    self.m_pPanelRounder = nil
    self.m_pPanelRounderSelect = nil
    self.m_pSpWaitNext = nil
    self.m_pNodeMenu = nil
    self.m_pNodeLeft = nil
    self.m_pNodeFlyIcon = nil
    self.m_pNodeTips = nil
    self.m_pNodeChat = nil
    self.m_pNodeNewMsg = nil
    self.m_pLbUsrNickName = nil
    self.m_pLbUsrGold = nil
    self.m_pLbZhuangNum = nil
    self.m_pLbAmountBet = nil
    self.m_pLbZhuangName = nil
    self.m_pLbZhuangMoney = nil
    self.m_pLbNewMsgNo = nil
    self.m_pLbLotteryGoldCount = {}
    self.m_pLbLotteryGoldAll = {}
    self.m_pBtnMenuPop = nil
    self.m_pBtnMenuPush = nil
    self.m_pBtnSound = nil
    self.m_pBtnVoice = nil
    self.m_pBtnContinue = nil
    --self.m_pBtnClear = nil
    self.m_pBtnReturnGame = nil
    self.m_pLbStatus = nil
    self.m_pLbCountTime = nil
    self.m_pBtnBank = nil -- 金币旁边的保险箱按钮
    self.m_pBtnBank2 = nil -- 菜单的保险箱按钮
    self.m_pBtnRequestToZhuang = nil -- 申请上庄
    self.m_pBtnCancelToZhuang = nil -- 取消上庄
    self.m_pControlButtonChip = {} -- 下注按钮
    self.m_pBlinkImg = {} -- 下注按钮对应的闪烁图片
    self.m_pControlButtonJetton = {} -- 筹码按钮
    self.m_pSpZhunagTips = nil    --庄家提示
    self.m_pSpLes = nil           --mm提示
    self.m_pStatu = nil           --筹码选中节点
    --self.m_pSpBetNo = {}    --下注满
    self.m_pSpriteSelect = {} --跑马灯
    self.m_pPlayerName = nil --左边的名字
    self.m_pBtnRule = nil -- 规则按钮
    self.m_pTableViewHistory = nil -- 开奖历史记录view
    --self.m_pLotteryGoldAllZheZhao = {} --全局遮罩
    self.m_pAnimVeil = nil -- 动物动画遮罩
    self.m_pQiTaWanJia = nil --其他玩家
    self.m_pQiTaWanJiaNum = nil
    -- local --
    --self.m_zhuangPos = cc.p(0, 0) --庄家位置
    --self.m_otherPos = cc.p(0, 0) --其他玩家位置
    --self.m_selfScorePos = cc.p(0, 0) --自己分数的位置
    self.m_flyJobVec = {} -- 结算飞筹码任务
    self.nIndexChoose = 0 --6个筹码选中INDEX
    self.m_iShowAmount = 0
    self.m_iShowIndex = 0
    self.m_fOpenAniTime = 0.0
    self.m_chip_scale = 0.4
    self.m_chip_seloffset = 15.0 --选中筹码位置
    self.m_chip_nmoffset = 15.0 --恢复筹码位置
    self._nCountdownSoundId = 0
    --self._nClockSoundId = 0
    self._bIsPlaySound = false
    self._bIsPlayDaojishi = false
    self._bIsPlayClock = false
    self.m_lTempUserGoldof = 0
    self._nUserLoseCount = 0 --连续输的计数
    self._nUserWinCount = 0 --连续赢的计数
    self._nSoundCount = 0
    self._nLastWinSound = 0
    self._nLastLoseSound = 0
    self.m_bEnterFirst = true
    self.m_dAnimationCount = 0
    self.m_bIsCanClickContinue = true --是否能点续投  点击续投后1秒后才能点这个
    self.m_diffY = (display.size.height - 750) / 2
    self.m_historyNum = 0 -- 历史记录数量，用于列表刷新
    self.m_viewHistoryEffect = false -- 控制历史记录刷新时是否使用动画
    self._nSoundType = math.random(1,2)
    self.m_randmChipSelf = {} -- 自己的随机投注点
    self.m_randmChipOthers = {} -- 其他玩家随机投注点
    self.m_betChipSpSelf = {} -- 自己的11个地区投注筹码精灵 { jettonIndex =  筹码索引, pChipSpr =  筹码精灵对象, pos = 坐标 }
    self.m_betChipSpOthers = {} -- 他人的11个地区投注筹码精灵
    self.m_isPlayBetSound = false -- 其他人下注筹码音效播放状态
    self.m_flychipidx = 0 -- 投注筹码随机时间序列参数
    self.m_rectOfBet = {}    --下注矩形范围位置数组
    self.m_posOfJetton = {}    --筹码位置
    self.m_otherChip = false -- 其他人是否投过注
    self.m_selfChip = false -- 自己是否投过注
    self.m_iLastPlayerGold = PlayerInfo.getInstance():getUserScore() -- 自己最后记录的金币
    self.m_lastCount = -1


    self.amountBet = 0
--    nativeMessageBox("initVars", "")
--    self:initUI()   
end

function GameViewLayer:onEnter()
    self:init()
    self:startGameEvent()
--    nativeMessageBox("onEnter", "")
end

function GameViewLayer:onExit()
    print("GameViewLayer:onExit")
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._ClockFun) 
    if self._XuyaFun then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._XuyaFun)
    end
    self:unRegistNetCallback()
    self:stopGameEvent()

    CChipCacheManager.getInstance():Clear()
    CChipCacheManager.getInstance():resetChipZOrder()


    if self.m_bEnterBackground == false then
        --释放动画
        for i, name in pairs(AnimalSceneRes.vecReleaseAnim) do
            ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(name)
        end

        --释放整图
        for i, name in pairs(AnimalSceneRes.vecReleasePlist) do
            local strPlistName = name .. ".plist"
            local strPngName = name .. ".png"
            display.removeSpriteFrames(strPlistName, strPngName)
            --display.removeSpriteFrames(name[1], name[2])
        end

        -- 释放背景图
        for _, strFileName in pairs(AnimalSceneRes.vecReleaseImg) do
            display.removeImage(strFileName)
        end

        --释放音频
        for i, name in pairs(AnimalSceneRes.vecReleaseSound) do
            AudioEngine.unloadEffect(name)
        end
    end
end

function GameViewLayer:init()
--    nativeMessageBox("init", "")
    self:initVars()-- 清除变量
    self:initUI()
end

function GameViewLayer:initUI()
--    nativeMessageBox("initUI1", "")
    self.m_pAnimalUI = self.m_pRootUI:getChildByName("Panel_Root")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pAnimalUI:setPositionX(diffX)
    print("---加载UI成功")
    
    -- 初始化网络事件
    self:initNetEvent()
    print("---初始化 NetEvent 成功")
--    nativeMessageBox("initUI2", "")
    -- 初始化CCS
    self:initCCS()
    print("---初始化CCS成功")

    -- 初始化按钮
    self:initCCSButton()
    print("---初始化CCS BTN 成功")



    --ruleUI
    self:initRulePanel()
    print("--- initRulePanel 成功")

    --播放音乐
    ExternalFun.playGameBackgroundAudio(SOUND_OF_SYSTEM[16])

    --替换筹码
    self:onMsgGameInit()

    self:initChip()
end

function GameViewLayer:initChip()

    local llChipsValues = {1,5,10,50,100}
    for i = 1, 5 do
        CBetManager.getInstance():setJettonScore(i,llChipsValues[i])
    end
--    --调用历史默认
--    self:onGameHistory(0,nil)
--    print("---调用历史默认 成功")

    --更新筹码状态
    self:updateJettonState()

    --add by nick 重进时没有显示自己已经投的注
    self:updateLottery()
    self:updateLotteryAll()

    --缓存管理添加委托构造筹码方法
    CChipCacheManager.getInstance():setCreateChipDelegate(
        function(nIndex)
            local sp = cc.Sprite:createWithSpriteFrameName(self:getFileOfChip(nIndex))
            self.m_pNodeFlyIcon:addChild(sp)
            return sp
        end
    )

end

function GameViewLayer:initCCS()
    self.m_PanelGameLayer = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Panel_GameLayer") --主游戏层
--    self.m_pLbResultGold = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "TXT_result_gold") 
--    self.m_pLbResultGold:setLocalZOrder(999)

    self.m_pNode_Left = self.m_PanelGameLayer:getChildByName("Node_Left")
    self.m_pPanel_Chips = self.m_PanelGameLayer:getChildByName("Panel_Chips")
    self.m_pNodeFlyAnimNode = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "NodeFlyAnimNode")

    --尝试UI适配
    self:tryLayoutforIphoneX()



    self.m_pPanelRounder = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Panel_Rounder") --跑马灯区域
    self.m_pPanelRounderSelect = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Panel_RounderSelect") --跑马灯选择区域

    local opacity = {255, 205, 155, 105, 55, 20}
    for i=1,tonumber(JETTON_ITEM_COUNT),1 do
         local _sprite = cc.Sprite:createWithSpriteFrameName(self:getRealFrameName("fqzs_xuanzhong.png"))
         _sprite:setOpacity(opacity[i])
         self.m_pSpriteSelect[i] = _sprite
         self.m_pSpriteSelect[i]:setVisible(false)
         self.m_pPanelRounderSelect:addChild(_sprite)
    end

    self.m_pNodeMenu = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Panel_NodeMenu"):getChildByName("Image_BG") --弹窗按钮
    self.m_pNodeMenu:setVisible(false)

    self.m_pNodeTips = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Panel_tips")--提示节点
    self.m_pNodeTips:setVisible(false)

    --local formatNickName = LuaUtils.getDisplayNickName(PlayerInfo.getInstance():getNameNick(), 8, true)
    self.m_pLbUsrNickName = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Label_nickname") --label name
    --self.m_pLbUsrNickName:setString(formatNickName)
    self.m_pLbUsrNickName:setString(GlobalUserItem.tabAccountInfo.nickname)

    local _Panel_Left_Bottom = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Panel_Left_Bottom")
    local _Node_selfGold = _Panel_Left_Bottom:getChildByName("Node_selfGold")
    --self.m_pLbUsrGold = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Label_xian_gold") --label score
    self.m_pLbUsrGold = _Node_selfGold:getChildByName("Label_xian_gold")
    self.m_pLbUsrGold:setString(GlobalUserItem.tabAccountInfo.into_money)

    self.m_pLbZhuangNum = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Label_shenqingrenshu_count") --申请人数
    self.m_pLbAmountBet = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Label_xiazhu_count") --总下注
    self.m_pLbZhuangName = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Label_zhuangjiamingzi") --庄家名字
    self.m_pLbZhuangMoney = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Label_zhuangjiafenshu") --庄家分数
    self.m_pNodeFlyIcon = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "NodeFlyIcon") --筹码飞的地方
    self.m_pNodeBetWinAnim = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "NodeBetWinAnim") --播放胜利动画的地方
    self.m_pSpZhunagTips = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Image_zhuangTips") --庄家提示
    
    self.m_pAnimVeil = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "NodeAnimVeil")
    self.m_pAnimVeil:setVisible(false)

    self.m_pBtnContinue = self.m_pPanel_Chips:getChildByName("BTN_ContinueChips")
    self.m_pBtnContinue:setVisible(true)
    self.m_pBtnContinue:setEnabled(false)
    
--    self.m_pBtnClear = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "BTN_ClearChips") --清空
--    self.m_pBtnClear:setVisible(false)

    self.m_pBtnBank = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "BTN_Bank") --银行
    self.m_pBtnBank2 = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "BTN_Bank2") --银行
    self.m_pBtnVoice = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "BTN_yinyue") --音乐
    self.m_pBtnSound = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "BTN_yinxiao") --音效
    self.m_pQiTaWanJia = self.m_pNode_Left:getChildByName("Button_qtwj") --其他玩家
    self.m_pQiTaWanJiaNum = self.m_pQiTaWanJia:getChildByName("BitmapFontLabel_5") 
    -- 提高其他玩家按钮层级
    self.m_pQiTaWanJia:setLocalZOrder(self.m_pNodeFlyIcon:getLocalZOrder() + 1)

    self.Node_other_anim = self.m_pNodeFlyAnimNode:getChildByName("Node_other_anim") 
    --self.m_otherPos = cc.p(self.Node_other_anim:getPosition())
    self._Panel_Title_Zhuang = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Panel_Title_Zhuang") --其他玩家
    self.Node_zhuang_anim = self.m_pNodeFlyAnimNode:getChildByName("Node_zhuang_anim")
    self.Node_self_anim = self.m_pNodeFlyAnimNode:getChildByName("Node_self_anim")
    --self.m_zhuangPos = cc.p(self.Node_zhuang_anim:getPosition())
    --self.m_selfScorePos = cc.p(self.m_pNodeFlyAnimNode:getChildByName("Node_self_anim"):getPosition())
    self.m_pSpWaitNext = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Panel_next") --等待下局开始
    self.m_pSpWaitNext:setVisible(false)

    self.m_pBtnRequestToZhuang = self._Panel_Title_Zhuang:getChildByName("BTN_shangzhuang")
    self.m_pBtnCancelToZhuang = self._Panel_Title_Zhuang:getChildByName("BTN_xiazhuang")

    self.m_pPanelChipsAnimals = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Panel_ChipsAnimals") --中间区域
    --self.m_pPanelChipsAnimalsLOCK = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Panel_ChipsAnimals_LOCK") --中间锁

    local pPanel_ChipsScore = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Panel_ChipsScore") --筹码分数

    -- 初始化筹码下注面板 11个 
    -- 对应的动物下注按钮 获胜闪烁边框属性 普通(坐标(73, 60) 尺寸(125, 105)) 鲨鱼(坐标(132, 60) 尺寸(258, 105))
    -- 获胜时需要闪烁对应的区域
    local imgpath = self:getRealFrameName("fqzs_bgblink.png")
    for i=1,tonumber(CHIP_ITEM_COUNT),1 do
        self.m_pControlButtonChip[i] = self.m_pPanelChipsAnimals:getChildren()[i]-- 下注按钮
--        local x = self.m_pControlButtonChip[i]:getContentSize()
        local w = 135
        local h = 145
        if 9 < i then
            w = 270
            h = 99
        elseif 9 == i then
            w = 302
            h = 199
        end
        self.m_pBlinkImg[i] = cc.Sprite:createWithSpriteFrameName(imgpath)
        self.m_pBlinkImg[i]:setAnchorPoint(0, 0)
        self.m_pBlinkImg[i]:setPosition(0, 0)
--        self.m_pBlinkImg[i]:setContentSize(cc.size(w, h))
        self.m_pBlinkImg[i]:setScaleX(w/125)
        self.m_pBlinkImg[i]:setScaleY(h/105)
        self.m_pBlinkImg[i]:setVisible(false)
        self.m_pBlinkImg[i]:addTo(self.m_pControlButtonChip[i])

        --自己的分数区域 
        self.m_pLbLotteryGoldCount[i] = pPanel_ChipsScore:getChildByName("Label_Player"..i)
        self.m_pLbLotteryGoldCount[i]:setString("")
        self.m_pLbLotteryGoldCount[i]:setVisible(true)

        --公共区域分数
        self.m_pLbLotteryGoldAll[i] = pPanel_ChipsScore:getChildByName("Label_Total"..i)
        self.m_pLbLotteryGoldAll[i]:setString("")
        self.m_pLbLotteryGoldAll[i]:setVisible(true)

--        self.m_pLotteryGoldAllZheZhao[i] = self.m_PanelGameLayer:getChildByName("NodeZheZhao"):getChildByName("Image_ZheZhao" ..i)
--        self.m_pLotteryGoldAllZheZhao[i]:setName("m_pLbLotteryGoldAll"..i)
--        self.m_pLotteryGoldAllZheZhao[i]:setVisible(false)

        --投注满
--        self.m_pSpBetNo[i] = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Image_SpBetNo"..i) 
--        self.m_pSpBetNo[i]:setVisible(false)

        self.m_pAction = cc.CSLoader:createTimeline("game/animals/FQZS_Game_UI.csb")
        self.m_pAnimalUI:runAction(self.m_pAction)

        -- 11个投注区域范围 获取数据完毕后 删除节点
        local tmpnode = self.m_pNodeFlyIcon:getChildByName("Panel_Chip" .. i)
        -- 按钮上下不可投注区域为26+26 = 52
        local posx, posy = tmpnode:getPosition()
        local sz = tmpnode:getContentSize()
        self.m_rectOfBet[i] = cc.rect(posx, posy, sz.width, sz.height )
        self.m_betChipSpSelf[i] = {}
        self.m_betChipSpOthers[i] = {}
        tmpnode:removeFromParent()
    end

    self:resetChipPos()

    --local offsetX = 0.33 * display.width
    local offsetX = 0
    for i=1,tonumber(JETTON_ITEM_COUNT),1 do
        local _BTN_Chip = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "BTN_Chip"..i)
        self.m_chip_seloffset = _BTN_Chip:getPositionY()+15
        self.m_chip_nmoffset = _BTN_Chip:getPositionY()

        self.m_pControlButtonJetton[i] = _BTN_Chip

        --投注筹码动画出发位置
        self.m_posOfJetton[CBetManager.getInstance():getJettonScore(i)] = cc.p(self.m_pNodeFlyAnimNode:getChildByName("Node_chip"..i):getPosition())
    end
    ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "BTN_Chip"..6):setVisible(false)
    self.m_pLbStatus = self.m_PanelGameLayer:getChildByName("Label_status")
    self.m_pLbCountTime = self.m_PanelGameLayer:getChildByName("Label_counttime")

    local _btn_return = self.m_pNode_Left:getChildByName("Btn_return")
    _btn_return:addClickEventListener(handler(self,self.onReturnClick))

    self.m_BTN_MenuPush_AllScreen = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Panel_MenuPush_AllScreen")
    self.m_BTN_MenuPush_AllScreen:setVisible(false)

    self.m_pBtnMenuPush = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "BTN_MenuPush")
    self.m_pBtnMenuPush:setVisible(false)

    self.m_pBtnMenuPop = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "BTN_MenuPop")
    self.m_pBtnMenuPop:addClickEventListener(handler(self,self.onPopMenuClick))

    --场景特效
    self:showAnimationWithName(self.m_pAnimalUI:getChildByName("Node_Scene_Anim"), "feiqinzoushou_changjingtexiao" , "Animation1" ,nil , true)
    self:showAnimationWithName(self.m_pAnimalUI:getChildByName("Node_Scene_Anim"), "feiqinzoushou_changjingtexiao" , "Animation2" ,nil , true)
    self:showAnimationWithName(self.m_pAnimalUI:getChildByName("Node_Scene_Anim"), "feiqinzoushou_changjingtexiao" , "Animation3" ,nil , true)

--    --显示房号
--    if PlayerInfo.getInstance():getIsShowRoomNo() then
--        local nRoomNo = PlayerInfo.getInstance():getCurrentRoomNo()
--        local pos = cc.p(_btn_return:getPosition())
--        local m_pLbRoom = cc.Label:createWithBMFont("public/font/nmb-new.fnt", nRoomNo)
--	    m_pLbRoom:setAnchorPoint(cc.p(0.5, 0.5))
--	    m_pLbRoom:setPosition(cc.p(pos.x - 20, pos.y - 55))
--        m_pLbRoom:addTo(self.m_pNode_Left)

--        local m_pSpRoom = display.newSprite("public/font/nmb-room.png")
--        local size = m_pLbRoom:getContentSize()
--        m_pSpRoom:setAnchorPoint(0, 0.5)
--        m_pSpRoom:setPosition(size.width / 2 + 10, size.height / 2)
--        m_pSpRoom:addTo(m_pLbRoom)
--    end

--    self.m_pLbCountTime:setLocalZOrder(2)
--    self.m_countbumBGAni = ccs.Armature:create("countnum_background") 
--                            :setPosition(self.m_pLbCountTime:getPosition())
--                            :setLocalZOrder(1)
--                            :setVisible(false)
--                            --:setScale(1.3)
--    self.m_PanelGameLayer:addChild(self.m_countbumBGAni)

    local viewChip = function()
        local llScore = 0
        for i=1,tonumber(CHIP_ITEM_COUNT),1 do
            -- 显示自己已下注筹码
            llScore = CBetManager.getInstance():getScoreShip(i)
            if llScore > 0 then
                local vecSelf = CBetManager.getInstance():getSplitGold(llScore)
                for j=1,table.maxn(vecSelf),1 do
                    self:createStaticSpriteOfChip(vecSelf[j], i, true)
                end
            end

            -- 显示他人已下注筹码
--            llScore = CBetManager.getInstance():getAllServerEveryAmount(i)
--            if llScore > 0 then
--                print("他人有下注筹码：" .. llScore)
--                local vecOther = CBetManager.getInstance():getSplitGold(llScore)
--                for j=1,table.maxn(vecOther),1 do
--                    self:createStaticSpriteOfChip(vecOther[j], i, false)
--                end
--            end
        end
        --添加等待特效
        self:showAnimationWithIndex(self.m_pSpWaitNext:getChildByName("Node_anim") , "bairenniuniu_dengdaikaiju" , nil , true)
    end

    self:FlyIn(viewChip)
end

function GameViewLayer:initHistoryView()
    self.m_historyNum = CBetManager.getInstance():getGameOpenLogCount()

    if CBetManager.getInstance():getStatus() ~= CMsgAnimal.GAMESTATUS.STATUS_BEGANCHIP then
        self.m_historyNum = self.m_historyNum - 1
    end

    self.m_historyNum = self.m_historyNum > 0 and self.m_historyNum or 0

    local aniOverCB = function()
        self.m_viewHistoryEffect = false
    end

    local cellSizeForTable = function(table, idx)
        return 65, 60
    end

    local numberOfCellsInTableView = function(table)
        return self.m_historyNum
    end

    local tableCellAtIndex = function(table, idx)
        local nIdx = idx + 1
        local cell = table:dequeueCell()
        if not cell then
            cell = cc.TableViewCell:new()
        else
            -- 是否能直接重用原来的图片精灵？在中奖记录相等时
            cell:removeAllChildren()
        end

        local value = CBetManager.getInstance():getGameOpenLog(nIdx)
        local _Image = cc.Sprite:createWithSpriteFrameName(self:getRealFrameName(AnimalDefine[value].STRING_ANIMALS .. "_s.png"))
        _Image:setAnchorPoint(0, 0)
        _Image:setPosition(3, 3)
        _Image:setScale(0.85)
        if nIdx == self.m_historyNum then
            local spNew = cc.Sprite:createWithSpriteFrameName(self:getRealFrameName("fqzs_jilu.png"))
            spNew:setPosition(_Image:getContentSize().width/2,_Image:getContentSize().height/2)
            _Image:addChild(spNew , -1)
            if self.m_viewHistoryEffect then
                local seq = cc.Sequence:create(cc.FadeIn:create(1.5), cc.CallFunc:create(aniOverCB))
                spNew:setOpacity(0)
                _Image:setOpacity(0)
                spNew:runAction(seq:clone())
                _Image:runAction(seq)
            end
        end
        _Image:addTo(cell)
        return cell
    end

    self.m_pTableViewHistory = cc.TableView:create(cc.size(65, 481))
    self.m_pTableViewHistory:setAnchorPoint(cc.p(0,0))
    self.m_pTableViewHistory:setPosition(cc.p(10.08,13.62))
--    self.m_pTableViewHistory:setIgnoreAnchorPointForPosition(false)
    self.m_pTableViewHistory:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.m_pTableViewHistory:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.m_pTableViewHistory:setDelegate()
    self.m_pTableViewHistory:registerScriptHandler(cellSizeForTable, CCTableView.kTableCellSizeForIndex)
    self.m_pTableViewHistory:registerScriptHandler(tableCellAtIndex, CCTableView.kTableCellSizeAtIndex)
    self.m_pTableViewHistory:registerScriptHandler(numberOfCellsInTableView, CCTableView.kNumberOfCellsInTableView)
    self.m_PanelGameLayer:getChildByName("Panel_History"):addChild(self.m_pTableViewHistory)
    self.m_pTableViewHistory:reloadData()
    if self.m_historyNum > 7 then
        self.m_pTableViewHistory:setContentOffset(cc.p(0, 0))
    end
end

function GameViewLayer:initCCSButton()
    if CBetManager.getInstance():getStatus() ~= CMsgAnimal.GAMESTATUS.STATUS_BEGANCHIP then
        self.m_pBtnBank:setEnabled(false)
    end

    local onBetNumClicked = function (sender,eventType)
        self:onBetNumClicked(sender,eventType)
    end    

    --监听6个筹码按钮
    for i=1,tonumber(JETTON_ITEM_COUNT),1 do
        self.m_pControlButtonJetton[i]:addTouchEventListener(onBetNumClicked)
    end

    onBetNumClicked(self.m_pControlButtonJetton[1],ccui.TouchEventType.ended)

    -- onAnimalClicked --  点11动物下注
    local onAnimalClicked = function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end

        --未到事件下注
        if (CBetManager.getInstance():getStatus() ~= CMsgAnimal.GAMESTATUS.STATUS_BEGANCHIP)then
            FloatMessage.getInstance():pushMessage("STRING_024")
            return
        end

        --不够筹码 增加一个条件
        if (PlayerInfo.getInstance():getTempUserScore() <= 0 or PlayerInfo.getInstance():getTempUserScore() < CBetManager.getInstance():getLotteryBaseScore())then
            --打开充值
            --MsgCenter::getInstance()->postMsg(MSG_SHOW_VIEW, __String::create("message-box"))
            --FloatMessage.getInstance():pushMessageForString("当前金额不足，请充值后下注!!")
            self:viewRecharge()
            FloatMessage.getInstance():pushMessageForString("筹码不足，无法下注!!")
            return
        end

        --庄家不能下注
        if (CBetManager.getInstance():getBankerUserId() == PlayerInfo.getInstance():getUserID())then
            FloatMessage.getInstance():pushMessage("FLY_14")
            return
        end

        --增加一个，倒计时1秒时候不允许投注
        local count = CBetManager.getInstance():getTimeCount()
        if count <= 0 then
            return
        end
        local num = self:recovernum(sender:getTag())
        --下注
        self._scene:SendBet({num,CBetManager.getInstance():getLotteryBaseScore()})
        table.insert(CBetManager.getInstance().m_vecUserShipLast,{num,CBetManager.getInstance():getLotteryBaseScore()})
        --下注
        --CMsgFly msg
        --msg.sendMsgChip(((ControlButton*)pSender)->getTag(), CBetManager::getInstance()->getLotteryBaseScore())        
    end

    --local _Panel_ChipsAnimals = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "Panel_ChipsAnimals")
    for i=1,tonumber(CHIP_ITEM_COUNT),1 do
        self.m_pControlButtonChip[i]:addTouchEventListener(onAnimalClicked)
        --_Panel_ChipsAnimals:getChildren()[i]:setTag(i)
        --print(_Panel_ChipsAnimals:getChildren()[i]:getName())
    end
    -- onAnimalClicked --

    -- 续投 --
    -- 续投onBetContinueClicked --
    local onBetContinueClicked = function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end

        --不允许连续点续投
        if self.m_bIsCanClickContinue == false then
            --FloatMessage.getInstance():pushMessageForString("请勿频繁点击！")
            return
        end

        --没有到下注时间
        if (CBetManager.getInstance():getStatus() ~= CMsgAnimal.GAMESTATUS.STATUS_BEGANCHIP)then
            FloatMessage.getInstance():pushMessage("STRING_026")
            return
        end

        --没有下注记录
        local count = CBetManager.getInstance():getUserShipLastCount()
        if (count <= 0)then
            FloatMessage.getInstance():pushMessage("STRING_027")
            return
        end

        --已经续投过
--        if (CBetManager.getInstance():getContinue() == true)then
--            FloatMessage.getInstance():pushMessage("STRING_004")
--            return
--        end

        --庄家不能下注
        if (CBetManager.getInstance():getBankerUserId() == PlayerInfo.getInstance():getUserID())then
            FloatMessage.getInstance():pushMessage("FLY_14")
            return
        end

--        local tmpllUserChip = {}
--        for i=1,tonumber(CHIP_ITEM_COUNT),1 do
--            tmpllUserChip[i] = 0
--        end

--        local llSumScore = 0
--        for i=1,tonumber(count),1 do
--            local chip = CBetManager.getInstance():getUserShipLast(i)
--            tmpllUserChip[chip.wChipIndex+1] = tmpllUserChip[chip.wChipIndex+1] + chip.llChipValue
--            llSumScore = llSumScore + chip.llChipValue
--        end

--        if (llSumScore > PlayerInfo.getInstance():getTempUserScore())then
--            --MsgCenter::getInstance()->postMsg(MSG_SHOW_VIEW, __String::create("message-box"))
--            --FloatMessage.getInstance():pushMessageForString("续投资金不足！")
----            self:viewRecharge()
--            FloatMessage.getInstance():pushMessageForString("筹码不足，无法续投!!")
--            return
--        end

        --续投
        --Veil::getInstance()->setEnabled(true, VEIL_DEFAULT)
--        CMsgAnimal.getInstance():sendMsgContinueChip(tmpllUserChip)
        local index = 1   
        self._XuyaFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
            if CBetManager.getInstance().m_vecUserShipLast[index] ~= nil then
                self._scene:SendBet(CBetManager.getInstance().m_vecUserShipLast[index])
            else
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._XuyaFun)
            end       
            index = index+1 
        end, 0.1, false)
       
        self.m_pBtnContinue:setEnabled(false)
        --点击了续投CD时间1秒后才能点清空
        self.m_bIsCanClickContinue = false
        local _dt = cc.DelayTime:create(tonumber(1.5))
        local _call = cc.CallFunc:create(function ()
            self.m_bIsCanClickContinue = true 
        end)
        self:runAction(cc.Sequence:create(_dt,_call))

        ExternalFun.playGameEffect("game/animals/soundpublic/sound-jetton.mp3")
    end

    self.m_pBtnContinue:addTouchEventListener(onBetContinueClicked)
    -- 续投

--    -- 清空
--    local onBetClearClicked = function (sender,eventType)
--        if eventType ~= ccui.TouchEventType.ended then
--            return
--        end

--        ExternalFun.playGameEffect("game/animals/soundpublic/sound-clear.mp3")

--        --//没有到下注时间
--        if (CBetManager.getInstance():getStatus() ~= CMsgAnimal.GAMESTATUS.STATUS_BEGANCHIP)then
--           FloatMessage.getInstance():pushMessage("STRING_026")
--            return
--        end

--        --//清空
--        CMsgAnimal.getInstance():sendMsgClearChip()
--    end
    --self.m_pBtnClear:addTouchEventListener(onBetClearClicked)
    -- 清空

    -- onRequestToZhuangClicked 上庄 -- 
    local onRequestToZhuangClicked = function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end

        ExternalFun.playGameEffect("game/animals/soundpublic/sound-button.mp3")

        --资金不足
--        if (PlayerInfo.getInstance():getUserScore() < CBetManager.getInstance():getBankerScoreNeed())then
--            local str = string.format(LuaUtils.getLocalString("STRING_239") , LuaUtils.getFormatGoldAndNumber( CBetManager.getInstance():getBankerScoreNeed()))
--            FloatMessage.getInstance():pushMessageForString(str)
--            --打开充值
--            self:viewRecharge()
--            return
--        end
    
        self._scene:SendUpdearler()
    end
    self.m_pBtnRequestToZhuang:addTouchEventListener(onRequestToZhuangClicked)
    -- onRequestToZhuangClicked 上庄 -- 

    -- onCancelToZhuangClicked 下庄 -- 
    local onCancelToZhuangClicked = function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end
        ExternalFun.playGameEffect("game/animals/soundpublic/sound-button.mp3")

        self._scene:SendDowndealer()
    end
    self.m_pBtnCancelToZhuang:addTouchEventListener(onCancelToZhuangClicked)

    -- 银行按钮
    self.m_pBtnBank:addClickEventListener(handler(self,self.onBankClick))
    self.m_pBtnBank2:addClickEventListener(handler(self,self.onBankClick))
    self.m_pBtnBank:setVisible(false)
    self.m_pBtnBank2:setColor(cc.c3b(127,127,127))
    self.m_pBtnBank2:setEnabled(false)
    -- onPushClicked --
    local onBtnMenuPush =  function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end

        if self.m_bNodeMenuMoving then
            return
        end

        ExternalFun.playGameEffect("game/animals/soundpublic/sound-button.mp3")
        self.m_bNodeMenuMoving = true
        self.m_pNodeMenu:stopAllActions()
        self.m_pNodeMenu:setPosition(cc.p(113, 270))
        self.m_pNodeMenu:setOpacity(255)
        local moveTo = cc.MoveTo:create(10/60, cc.p(113, 350))
        local fadeOut = cc.FadeOut:create(10/60) 
        local sp = cc.Spawn:create(moveTo , fadeOut)
        local callback = cc.CallFunc:create(function ()
            self.m_pNodeMenu:setVisible(false)
            self.m_pBtnMenuPop:setVisible(true)
            self.m_pBtnMenuPush:setVisible(false)
            self.m_bNodeMenuMoving = false
            self.m_BTN_MenuPush_AllScreen:setVisible(false)
        end)
        local seq = cc.Sequence:create(sp, callback)
        self.m_pNodeMenu:runAction(seq)
    end

    self.m_pBtnMenuPush:addTouchEventListener(onBtnMenuPush)
    self.m_BTN_MenuPush_AllScreen:addTouchEventListener(onBtnMenuPush)
    -- onPushClicked --   

    -- m_pBtnVoice --
    self.m_pBtnVoice:addTouchEventListener(function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end

        ExternalFun.playGameEffect("game/animals/soundpublic/sound-button.mp3")


        if (GlobalUserItem.bVoiceAble)then -- 音乐开着 
            GlobalUserItem.setVoiceAble(false)
            self.m_pBtnVoice:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinyueguan.png"),ccui.TextureResType.plistType)
        else
            GlobalUserItem.setVoiceAble(true)
            self.m_pBtnVoice:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinyue.png"),ccui.TextureResType.plistType)
            --播放音乐
            ExternalFun.playGameBackgroundAudio(SOUND_OF_SYSTEM[16])
        end

    end)

    -- m_pBtnVoice --

    -- m_pBtnSound --
    self.m_pBtnSound:addTouchEventListener(function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end

        ExternalFun.playGameEffect("game/animals/soundpublic/sound-button.mp3")


        if (GlobalUserItem.bSoundAble)then -- 音效开着
            GlobalUserItem.setSoundAble(false)
            self.m_pBtnSound:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinxiaoguan.png"),ccui.TextureResType.plistType)
        else
            GlobalUserItem.setSoundAble(true)
            self.m_pBtnSound:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinxiao.png"),ccui.TextureResType.plistType)

            if (CBetManager.getInstance():getStatus() == CMsgAnimal.GAMESTATUS.STATUS_BEGANCHIP)then
                local count = CBetManager.getInstance():getTimeCount()
                if(0 < count and count <= 5)then
                    
                    --self._nClockSoundId = ExternalFun.playGameEffect(SOUND_OF_SYSTEM[14])
                elseif(count > 5)then
                    self._nCountdownSoundId = ExternalFun.playGameEffect(SOUND_OF_SYSTEM[15],true)
                end
            end
        end
    end)
    -- m_pBtnSound --

    if (GlobalUserItem.bVoiceAble)then -- 音乐开着 
        self.m_pBtnVoice:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinyue.png"),ccui.TextureResType.plistType)
    else
        self.m_pBtnVoice:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinyueguan.png"),ccui.TextureResType.plistType)
    end
    
    if (GlobalUserItem.bSoundAble)then -- 音效开着
        self.m_pBtnSound:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinxiao.png"),ccui.TextureResType.plistType)
    else
        self.m_pBtnSound:loadTextureNormal(self:getRealFrameName("fqzs_btn_yinxiaoguan.png"),ccui.TextureResType.plistType)
    end

    self.m_pQiTaWanJia:addTouchEventListener(function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end        
        ExternalFun.playGameEffect("game/animals/soundpublic/sound-jetton.mp3")
        --玩家列表
        local infoLayer = AnimalOtherInfoLayer:create()
        infoLayer:setPositionX(-145)
        self.m_pAnimalUI:addChild(infoLayer,999)
    end)
end
function GameViewLayer:recovernum(sendnum)
    local numquyu = 0
    if sendnum == 11 then numquyu = 10       
    elseif sendnum == 1 then  numquyu = 2
    elseif sendnum == 2 then  numquyu = 0
    elseif sendnum == 3 then  numquyu = 1
    elseif sendnum == 4 then  numquyu = 3
    elseif sendnum == 5 then  numquyu = 6
    elseif sendnum == 6 then  numquyu = 4
    elseif sendnum == 7 then  numquyu = 5
    elseif sendnum == 8 then  numquyu = 7
    elseif sendnum == 9 then  numquyu = 8
    elseif sendnum == 10 then  numquyu = 9
    end
    return  numquyu
end
function GameViewLayer:initRulePanel()
    --规则按钮
    self.m_pBtnRule = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "BTN_Rule")
    self.m_pBtnRule:addTouchEventListener(function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then return end

        ExternalFun.playGameEffect("game/animals/soundpublic/sound-button.mp3")

        local layer = RulerLayer:new()
        layer:addTo(self.m_pRootUI , 999)
        
--        local CommonRule = require("common.layer.CommonRule")
--        local nKind = PlayerInfo.getInstance():getKindID()
--        local pRule = CommonRule.new(nKind)
--        pRule:addTo(self.m_pRootUI, 999)
    end)
end

-- iphonex适配
function GameViewLayer:tryLayoutforIphoneX()
    if LuaUtils.isIphoneXDesignResolution() then
        -- 重写适配位移业务 使用相对位移方式
        local offset = (1624-display.size.width)/2 -- 分辨率适配偏移
        local chipoffset = -50

        -- [其他玩家][退出游戏按钮][玩家信息框]左移
        self.m_pNode_Left:setPositionX(self.m_pNode_Left:getPositionX() - 75 + offset)
        self.m_PanelGameLayer:getChildByName("Panel_Left_Bottom"):setPositionX(-75 + offset)
        local _panel_chip = self.m_PanelGameLayer:getChildByName("Panel_Chips")
        _panel_chip:setPositionX(_panel_chip:getPositionX() + chipoffset)

        --self.m_PanelGameLayer:getChildByName("Panel_Chips"):setPositionX(254 + offset)
        --self.m_PanelGameLayer:getChildByName("Button_qtwj"):setPositionX(-29 + offset)
        --self.m_PanelGameLayer:getChildByName("Btn_return"):setPositionX(-29 + offset)

        -- [弹出菜单][弹出/收缩按钮][历史记录]右移
        self.m_pAnimalUI:getChildByName("Panel_NodeMenu"):setPositionX(1190.20)
        --self.m_PanelGameLayer:getChildByName("BTN_ContinueChips"):setPositionX(1130 + offset)
        --self.m_PanelGameLayer:getChildByName("BTN_ClearChips"):setPositionX(1130)
        --self.m_PanelGameLayer:getChildByName("Image_chip_bg"):setPositionX(730 + offset)
        self.m_PanelGameLayer:getChildByName("Image_History_bg"):setPositionX(1300.20)
        self.m_PanelGameLayer:getChildByName("Panel_History"):setPositionX(1260)
        --self.m_PanelGameLayer:getChildByName("BTN_Rule"):setPositionX(1332.00)
        self.m_PanelGameLayer:getChildByName("BTN_MenuPop"):setPositionX(1300.20)
        self.m_PanelGameLayer:getChildByName("BTN_MenuPush"):setPositionX(1300.20)
        self.m_pNodeFlyAnimNode:getChildByName("Node_other_anim"):setPositionX(-320.3 + offset)
        self.m_pNodeFlyAnimNode:getChildByName("Node_self_anim"):setPositionX(-340.6 + offset)

        for i = 1, JETTON_ITEM_COUNT do
            local _node = self.m_pNodeFlyAnimNode:getChildByName("Node_chip" .. i)
            _node:setPositionX(_node:getPositionX() + chipoffset)
        end
    end
end

-- 开场组件动画
function GameViewLayer:FlyIn(cb)
    --主界面下移
    local deltaY = -520
    local backY = 10
    local ac1 = cc.MoveBy:create(20/60 ,  cc.p(0 , deltaY))
    local ac2 = cc.MoveBy:create(15/60 ,  cc.p(0 , 10))
    local fadeIn = cc.FadeIn:create(20/60)
    local ac3 = cc.Sequence:create(ac1 ,ac2)
    local ac4 = cc.Spawn:create(ac3 , fadeIn)

    self:setDeltaPosition(self.m_pAnimalUI:getChildByName("Image_ContentBg") , cc.p(0 , -deltaY-backY))
    self:setDeltaPosition(self.m_pAnimalUI:getChildByName("Node_anim") , cc.p(0 , -deltaY-backY))
    self:setDeltaPosition(self.m_pLbStatus , cc.p(0 , -deltaY-backY))
    self:setDeltaPosition(self.m_pLbCountTime , cc.p(0 , -deltaY-backY))
    self:setDeltaPosition(self.m_pPanelRounder, cc.p(0 , -deltaY-backY))
    self:setDeltaPosition(self._Panel_Title_Zhuang, cc.p(0 , -deltaY-backY))
    self:setDeltaPosition(self.m_pPanelChipsAnimals, cc.p(0 , -deltaY-backY))
    --self:setDeltaPosition(self.m_PanelGameLayer:getChildByName("NodeZheZhao"), cc.p(0 , -deltaY-backY))
    self:setDeltaPosition(self.m_PanelGameLayer:getChildByName("Panel_ChipsScore"), cc.p(0 , -deltaY-backY))

    self.m_pAnimalUI:getChildByName("Image_ContentBg"):setOpacity(0)
    self.m_pPanelRounder:setOpacity(0)
    self._Panel_Title_Zhuang:setOpacity(0)
    self.m_pPanelChipsAnimals:setOpacity(0)
    --self.m_PanelGameLayer:getChildByName("NodeZheZhao"):setOpacity(0)
    self.m_PanelGameLayer:getChildByName("Panel_ChipsScore"):setOpacity(0)

    
    --self.m_pAnimalUI:getChildByName("Image_ContentBg"):runAction(ac4:clone())
    self.m_pAnimalUI:getChildByName("Image_ContentBg"):runAction(cc.Sequence:create(ac4:clone(), cc.CallFunc:create(cb)))
    self.m_pAnimalUI:getChildByName("Node_anim"):runAction(ac4:clone())
    self.m_pPanelRounder:runAction(ac4:clone())
    self.m_pLbStatus:runAction(ac4:clone())
    self.m_pLbCountTime:runAction(ac4:clone())
    self._Panel_Title_Zhuang:runAction(ac4:clone())
    self.m_pPanelChipsAnimals:runAction(ac4:clone())
    --self.m_PanelGameLayer:getChildByName("NodeZheZhao"):runAction(ac4:clone())
    self.m_PanelGameLayer:getChildByName("Panel_ChipsScore"):runAction(ac4:clone())

    --左边右移
    local deltaX1 = 197
    local backX1 = -10
    local acl1 = cc.DelayTime:create(14/60)
    local acl2 = cc.MoveBy:create(16/60 ,  cc.p(deltaX1 , 0))
    local acl3 = cc.MoveBy:create(15/60 ,  cc.p(backX1 , 0))
    local acl4 = cc.Sequence:create(acl1 ,acl2 , acl3)

    self:setDeltaPosition(self.m_pNode_Left, cc.p(-deltaX1-backX1, 0))
    self.m_pNode_Left:runAction(acl4:clone())
    --self:setDeltaPosition(self.m_PanelGameLayer:getChildByName("Button_qtwj") , cc.p(-deltaX1-backX1, 0))
    --self:setDeltaPosition(self.m_PanelGameLayer:getChildByName("Btn_return") , cc.p(-deltaX1-backX1, 0))

--    self.m_PanelGameLayer:getChildByName("Button_qtwj"):runAction(acl4:clone())
--    self.m_PanelGameLayer:getChildByName("Btn_return"):runAction(acl4:clone())

    --右边左移
    local deltaX2 = -206
    local backX1 = 5
    local acr1 = cc.DelayTime:create(14/60)
    local acr2 = cc.MoveBy:create(16/60 ,  cc.p(deltaX2 , 0))
    local acr3 = cc.MoveBy:create(15/60 ,  cc.p(backX1 , 0))
    local acr4 = cc.Sequence:create(acr1 ,acr2 , acr3)

    self:setDeltaPosition(self.m_PanelGameLayer:getChildByName("Image_History_bg") , cc.p(-deltaX2-backX1, 0))
    self:setDeltaPosition(self.m_PanelGameLayer:getChildByName("Panel_History"), cc.p(-deltaX2-backX1, 0))
    self:setDeltaPosition(self.m_PanelGameLayer:getChildByName("BTN_MenuPush"), cc.p(-deltaX2-backX1, 0))
    self:setDeltaPosition(self.m_PanelGameLayer:getChildByName("BTN_MenuPop"), cc.p(-deltaX2-backX1, 0))

    --self:setDeltaPosition(self.m_PanelGameLayer:getChildByName("BTN_Rule"), cc.p(-deltaX2-backX1, 0))

    self.m_PanelGameLayer:getChildByName("Image_History_bg"):runAction(acr4:clone())
    self.m_PanelGameLayer:getChildByName("Panel_History"):runAction(acr4:clone())
    self.m_PanelGameLayer:getChildByName("BTN_MenuPush"):runAction(acr4:clone())
    self.m_PanelGameLayer:getChildByName("BTN_MenuPop"):runAction(acr4:clone())
    --self.m_PanelGameLayer:getChildByName("BTN_Rule"):runAction(acr4:clone())

    --下边上移
    local deltaY2 = 143
    local backY2 = -10
    local acb1 = cc.DelayTime:create(14/60)
    local acb2 = cc.MoveBy:create(16/60 ,  cc.p(0 , deltaY2))
    local acb3 = cc.MoveBy:create(15/60 ,  cc.p(0 , backY2))
    local fadeIn = cc.FadeIn:create(45/60)
    local acb4 = cc.Sequence:create(acb1 ,acb2 , acb3)
    local acb5 = cc.Spawn:create(acb4 ,fadeIn)

    --self:setDeltaPosition(self.m_PanelGameLayer:getChildByName("BTN_ContinueChips") , cc.p(0 , -deltaY2-backY2))
    self:setDeltaPosition(self.m_PanelGameLayer:getChildByName("Panel_Chips"), cc.p(0 , -deltaY2-backY2))
    --self:setDeltaPosition(self.m_PanelGameLayer:getChildByName("Image_chip_bg"), cc.p(0 , -deltaY2-backY2))
    self:setDeltaPosition(self.m_PanelGameLayer:getChildByName("Panel_Left_Bottom"), cc.p(0 , -deltaY2-backY2))
    --self:setDeltaPosition(self.m_PanelGameLayer:getChildByName("BTN_Bank"), cc.p(0 , -deltaY2-backY2))

    --self.m_PanelGameLayer:getChildByName("BTN_ContinueChips"):setOpacity(0)
    self.m_PanelGameLayer:getChildByName("Panel_Chips"):setOpacity(0)
    --self.m_PanelGameLayer:getChildByName("Image_chip_bg"):setOpacity(0)    
    self.m_PanelGameLayer:getChildByName("Panel_Left_Bottom"):setOpacity(0)    
    --self.m_PanelGameLayer:getChildByName("BTN_Bank"):setOpacity(0)    

    --self.m_PanelGameLayer:getChildByName("BTN_ContinueChips"):runAction(acb5:clone())
    self.m_PanelGameLayer:getChildByName("Panel_Chips"):runAction(acb5:clone())
    --self.m_PanelGameLayer:getChildByName("Image_chip_bg"):runAction(acb5:clone())    
    self.m_PanelGameLayer:getChildByName("Panel_Left_Bottom"):runAction(acb5:clone())    
    --self.m_PanelGameLayer:getChildByName("BTN_Bank"):runAction(acb5:clone())    

end

--endregion 初始化

--region 按钮事件
-- 点击筹码
function GameViewLayer:onBetNumClicked(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    ExternalFun.playGameEffect("game/animals/soundpublic/sound-jetton.mp3")

    local nIndex = sender:getTag()
    if self.nIndexChoose == nIndex then
        return
    end

    local score = CBetManager.getInstance():getJettonScore(nIndex)
    if (PlayerInfo.getInstance():getTempUserScore() < score) then
        return
    end

    --筹码的位移
    local _BTN_Chip_select = nil
    for i=1,tonumber(JETTON_ITEM_COUNT),1 do
        --local _BTN_Chip = ccui.Helper:seekWidgetByName(self.m_pAnimalUI, "BTN_Chip"..i)
        local _BTN_Chip = self.m_pControlButtonJetton[i]
        local offset_y = 0
        if (nIndex == i)then
            offset_y = self.m_chip_seloffset
            _BTN_Chip_select = _BTN_Chip
        else
            offset_y = self.m_chip_nmoffset
        end
        _BTN_Chip:setPositionY(offset_y)
    end
             
    self.nIndexChoose = nIndex
    CBetManager.getInstance():setLotteryBaseScore(score)
end

-- 保险箱
function GameViewLayer:onBankClick()
    ExternalFun.playGameEffect("game/animals/soundpublic/sound-button.mp3")
    
    -- 非投注状态不能操作保险箱
--    if CBetManager.getInstance():getStatus() ~= CMsgAnimal.GAMESTATUS.STATUS_BEGANCHIP then
--        FloatMessage.getInstance():pushMessage("BANK_30")
--        return
--    end
    SLFacade:dispatchCustomEvent(Hall_Events.SHOW_OPEN_BANK,"openbank")
--    --没有设置密码
--    if (PlayerInfo.getInstance():getIsInsurePass() == 0) then
--        FloatMessage.getInstance():pushMessage("STRING_033")
--        return
--    end

--    --弹出银行界面
--    local ingameBankView = IngameBankView:create()
--    ingameBankView:setName("IngameBankView")
--    ingameBankView:setPositionY(-self.m_diffY)
--    ingameBankView:setCloseAfterRecharge(false)
--    self:addChild(ingameBankView, 500)
end

-- 退出游戏
function GameViewLayer:onReturnClick()
    ExternalFun.playGameEffect("game/animals/soundpublic/sound-button.mp3")
    
--    --未下庄
--    if (CBetManager.getInstance():getBankerUserId() == PlayerInfo.getInstance():getUserID())then
--        FloatMessage.getInstance():pushMessage("FLY_15")
--        return
--    end

--    --有投注纪录
--    if (CBetManager.getInstance():getUserShipCount() > 0)then
--        local pMessageBox = MessageBoxNew.create(LuaUtils.getLocalString("MESSAGE_27"), MsgBoxPreBiz.PreDefineCallBack.CB_EXITROOM)
--        self:addChild(pMessageBox, 1000)
--        return 
--    end

--    --退出游戏
--    PlayerInfo.getInstance():setEnterGame(false)
    
    --发送起立
--    CMsgAnimal.getInstance():sendTableStandUp()
    
    -----------------------------
    -- add by JackyXu.
    -- 防连点,返回大厅执行多次会闪退
    --self.m_pBtnReturnGame:setEnabled(false)
    -----------------------------
    
    --PlayerInfo.getInstance():setIsGameBackToHall(true)
    --SLFacade:dispatchCustomEvent(Public_Events.Load_Entry)
	self:onMsgExitGame()
end

function GameViewLayer:onPopMenuClick()
    ExternalFun.playGameEffect("game/animals/soundpublic/sound-button.mp3")
    self.m_bNodeMenuMoving = true
    self.m_BTN_MenuPush_AllScreen:setVisible(true)
    self.m_pNodeMenu:setVisible(true)
    self.m_pNodeMenu:stopAllActions()
    self.m_pNodeMenu:setPosition(cc.p(113, 350))
    self.m_pNodeMenu:setOpacity(0)
    local moveTo = cc.MoveTo:create(12/60, cc.p(113, 240))
    local backAc = cc.MoveTo:create(7/60, cc.p(113, 270))
    local callback = cc.CallFunc:create(function ()
        self.m_pBtnMenuPop:setVisible(false)
        self.m_pBtnMenuPush:setVisible(true)
        self.m_bNodeMenuMoving = false
    end)
    local seq = cc.Sequence:create(moveTo , backAc , callback)
    local fadeIn = cc.FadeIn:create(17/60)
    local sp = cc.Spawn:create(seq , fadeIn)
    self.m_pNodeMenu:runAction(sp)
end

--endregion 按钮事件

--region UI组件刷新

-- 更新历史记录
function GameViewLayer:updateHistoryByFirst(_event)
    if self.m_bEnterFirst then return end
    self.m_viewHistoryEffect = true
    self.m_historyNum = CBetManager.getInstance():getGameOpenLogCount()
    self.m_pTableViewHistory:reloadData()
    if self.m_historyNum > 7 then
        self.m_pTableViewHistory:setContentOffset(cc.p(0, 0))
    end
end

--更新金币
function GameViewLayer:updateLotterySuccess(eventID, msg)
    if(msg == NULL)then
        self:updatePlayerGoldNumByChip(HANDLE_CLEAN,0)
        return
    end

    local nSize = CBetManager.getInstance():getUserShipCount()
    local winScore =  CBetManager.getInstance():getWinScore()
    local statue = CBetManager.getInstance():getStatus()
    if (winScore <= 0 and statue ~= CMsgAnimal.GAMESTATUS.STATUS_LOTTERY and statue ~= CMsgAnimal.GAMESTATUS.STATUS_IDLETIME )then
        if(msg ~= nil and nSize > 0)then
            local usership = CBetManager.getInstance():getUserShip(nSize)
            self:updatePlayerGoldNumByChip(HANDLE_NORMAL, usership.llChipValue)
        else
            self:updatePlayerGoldNumByChip(HANDLE_NORMAL,0)
        end
    end
end

--玩家下注本地扣除下注
function GameViewLayer:updatePlayerGoldNumByChip(curHandleType,continuCostGold)
    if(self.m_pLbUsrGold == nil)then
        return
    end
    self.m_lTempUserGoldof = PlayerInfo.getInstance():getUserScore()
    if(HANDLE_CLEAN == curHandleType)then
        self.m_lTempUserGoldof = PlayerInfo.getInstance():getUserScore()
        PlayerInfo.getInstance():setTempUserScore(self.m_lTempUserGoldof)
        --self.m_pLbUsrGold:setString(self:getFormatGold(self.m_lTempUserGoldof))
    elseif(HANDLE_CONTINU == curHandleType)then
        self.m_lTempUserGoldof = self.m_lTempUserGoldof - continuCostGold
        PlayerInfo.getInstance():setTempUserScore(self.m_lTempUserGoldof)
        PlayerInfo.getInstance():setUserScore(self.m_lTempUserGoldof)
        local strUsrBanlance = ""
        if (self.m_lTempUserGoldof >= 0) then
             strUsrBanlance = self.m_lTempUserGoldof
        else
             strUsrBanlance = 0
        end
        self.m_pLbUsrGold:setString(strUsrBanlance)
    elseif(HANDLE_NORMAL == curHandleType)then
    --获取当前投注值
        if(continuCostGold == 0)then
            local i = CBetManager.getInstance():getUserShipCount()
            if(0 == i)then
                return
            end

            local usership = CBetManager.getInstance():getUserShip(i)
            if (usership.llChipValue > 0)then
                self.m_lTempUserGoldof = self.m_lTempUserGoldof - usership.llChipValue
            end
        else
            self.m_lTempUserGoldof = self.m_lTempUserGoldof-continuCostGold
        end

        PlayerInfo.getInstance():setTempUserScore(self.m_lTempUserGoldof)
        PlayerInfo.getInstance():setUserScore(self.m_lTempUserGoldof)
        
        local strUsrBanlance = ""
        if (self.m_lTempUserGoldof >= 0) then
             strUsrBanlance = self.m_lTempUserGoldof
        else
             strUsrBanlance = 0
        end
        self.m_pLbUsrGold:setString(strUsrBanlance)
    end
end

--更新自己分数
function GameViewLayer:updateLottery()  
    for i=1,tonumber(CHIP_ITEM_COUNT),1 do
        local llScore = CBetManager.getInstance():getScoreShip(i)
        if (llScore > 0)then
            self.m_pLbLotteryGoldCount[i]:setString(llScore)
        else
            self.m_pLbLotteryGoldCount[i]:setString("")
        end
    end
end

--更新系统分数
function GameViewLayer:updateLotteryAll()   
    --更新每个区域的总的下注
    for i=1,tonumber(CHIP_ITEM_COUNT),1 do
        local llScore = CBetManager.getInstance():getAllServerAllStatic(i)
        if (llScore > 0)then
            self.m_pLbLotteryGoldAll[i]:setString(llScore)
            --self.m_pLotteryGoldAllZheZhao[i]:setVisible(true)
        else
            self.m_pLbLotteryGoldAll[i]:setString("")
            --self.m_pLotteryGoldAllZheZhao[i]:setVisible(false)
        end
    end
    
    --更新总的下注
    local amountBet = 0
    for i=1,tonumber(CHIP_ITEM_COUNT),1 do
        amountBet = amountBet + CBetManager.getInstance():getAllServerAllStatic(i)
    end
    self.m_pLbAmountBet:setString(string.format("总下注：%s", amountBet))
end

--更新筹码按钮状态
function GameViewLayer:updateJettonState()
    for i=1,tonumber(JETTON_ITEM_COUNT),1 do
        local bStatue = CBetManager.getInstance():getJettonEnableState(i)
            and CBetManager.getInstance():getBankerUserId() ~=  PlayerInfo.getInstance():getUserID()
        self.m_pControlButtonJetton[i]:setEnabled(bStatue)
        if bStatue == true then
            self.m_pControlButtonJetton[i]:setColor(cc.c3b(255,255,255))
        else
            self.m_pControlButtonJetton[i]:setColor(cc.c3b(127,127,127))
        end
    end

    local bMoney = false
    local bShow = false
    if(CBetManager.getInstance():getStatus() == CMsgAnimal.GAMESTATUS.STATUS_BEGANCHIP)then
        bShow = true
    end

    if(PlayerInfo.getInstance():getTempUserScore() >= CBetManager.getInstance():getJettonScore(1))then
        bMoney = true
    end
end



-- 每局游戏开始前更新续投按钮状态
function GameViewLayer:updateContinueStatus(enable)
    --没有到下注时间
    if CMsgAnimal.GAMESTATUS.STATUS_BEGANCHIP ~= CBetManager.getInstance():getStatus() then
        self.m_pBtnContinue:setEnabled(false)
        return
    end

    --自己是庄家
    if CBetManager.getInstance():getBankerUserId() ==  PlayerInfo.getInstance():getUserID() then
        --print("庄家无法续投")
        self.m_pBtnContinue:setEnabled(false)
        return
    end

    --没有下注记录
    if 0 >= CBetManager.getInstance():getUserShipLastCount() then
        self.m_pBtnContinue:setEnabled(false)
        return
    end

    --已经续投过
--    if CBetManager.getInstance():getContinue() then
--        self.m_pBtnContinue:setEnabled(false)
--        return
--    end

    self.m_pBtnContinue:setEnabled(true)
end

--endregion UI组件刷新
--gamelayer 接收消息-------------------------------------------------------------------------------------------------------------------------------------------------------
function GameViewLayer:EnterGame(dataBuffer)         -- 进入{[1]=1 [2]=5 [3]=10 [4]=50 [5]=100 }
    PlayerInfo.getInstance():setUserID(GlobalUserItem.tabAccountInfo.userid)
--    self.chips = {}
--    self.chips = msg.chips
--    table.insert(self.chips,500)
    self.m_lTempUserGoldof = PlayerInfo.getInstance():getUserScore()
    CBetManager.getInstance():setStatus(dataBuffer.step)
    for k,v in ipairs(dataBuffer.path) do
        CBetManager.getInstance():addGameOpenLog(v)
    end
    CBetManager.getInstance():setBankerUserId(dataBuffer.dealer)
    CBetManager.getInstance():setBankerTimes(dataBuffer.dealer_times)
    
    for k,v in ipairs(dataBuffer.dealers) do
        CBetManager.getInstance():addBankerListByUserId(v[1])
    end
    for k,v in ipairs(dataBuffer.members) do
        CBetManager.getInstance():setUserInfoList(v)
        if dataBuffer.dealer == v[1] then
            CBetManager.getInstance():setBankerName(v[2])
            CBetManager.getInstance():setBankerGold(v[6])
        end
    end
    self.m_pQiTaWanJiaNum:setString("("..#dataBuffer.members..")")
    if(CBetManager.getInstance():getStatus() ~= CMsgAnimal.GAMESTATUS.STATUS_BEGANCHIP)then
        self.m_pSpWaitNext:setVisible(true)
    end

    --初始化庄家列表
    self:onMsgUpdateZhuangInfo()
    --初始化历史记录列表
    self:initHistoryView()

    CBetManager.getInstance():setTimeCount(dataBuffer.timeout)
    self._ClockFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                self:updateCountDown()
            end, 1, false)
end
function GameViewLayer:intoBetMoney(dataBuffer)    -- 下注
    self.m_pSpWaitNext:setVisible(false)
    CBetManager.getInstance():setTimeCount(dataBuffer.timeout)
    CBetManager.getInstance():setStatus(1)
    self:onBeganChip()
end
function GameViewLayer:onGameEnd(dataBuffer)      --结算
    CBetManager.getInstance():setTimeCount(dataBuffer.timeout)
    CBetManager.getInstance():setStatus(2)
--    dataBuffer.win_zodic = 11
    print("*****************************************"..dataBuffer.win_zodic)
    CBetManager.getInstance():setDstIndex(self:changeQuyu( dataBuffer.win_zodic))
    CBetManager.getInstance():addGameOpenLog(self:changeQuyu(dataBuffer.win_zodic))
    local desPos = self:changNum(dataBuffer.win_zodic)
    CBetManager.getInstance():setLastPos(CBetManager.getInstance():getDstPos())
    CBetManager.getInstance():setDstPos(desPos)
    CBetManager.getInstance():setBankerResultGold(dataBuffer.dealer_win)
    CBetManager.getInstance():setPlayerResultGold(dataBuffer.mywin) 
    if dataBuffer.mywin == 0 then
        CBetManager.getInstance().m_vecUserShipLast = {}
    end
    CBetManager.getInstance():setLastBankerUserId(CBetManager.getInstance():getBankerUserId())
    self:onStopChip()
    self:doSomethingLater(function ()
        self:onLottery()
    end,1)
end

function GameViewLayer:changNum(win_num)
--    #[孔雀,鸽子,燕子,老鹰,熊猫,猴子,兔子,狮子,鲨鱼,金鲨,通赔,通杀] 这个是中奖坐标 0~11
-- 0 (18,19,20 )孔雀-- 1 (22,23,24)鸽子-- 2 (25,26,27)燕子-- 3 (15,16,17)老鹰-- 4 (8,9,10)熊猫-- 5 (4,5,6 )猴子-- 6 (1,2,3 )兔子-- 7 (11,12,13)狮子-- 8 (14, )鲨鱼-- 9 (28,)金鲨-- 10 (21, )通赔-- 11 (7 )通杀
    local end_num = 0;
    if win_num == 0 then    end_num = math.random(18,20)
    elseif win_num == 1 then    end_num = math.random(22,24)
    elseif win_num == 2 then    end_num = math.random(25,27)
    elseif win_num == 3 then    end_num = math.random(15,17)
    elseif win_num == 4 then    end_num = math.random(8,10)
    elseif win_num == 5 then    end_num = math.random(4,6)
    elseif win_num == 6 then    end_num = math.random(1,3)
    elseif win_num == 7 then    end_num = math.random(11,13)
    elseif win_num == 8 then    end_num = 14
    elseif win_num == 9 then    end_num = 28
    elseif win_num == 10 then   end_num = 7
    elseif win_num == 11 then   end_num = 21
    end
    return end_num
end

function GameViewLayer:onDeskOver(dataBuffer)        -- 空闲
    CBetManager.getInstance():setTimeCount(dataBuffer)
    CBetManager.getInstance():setStatus(3)

    
end
function GameViewLayer:Badbetmoney(dataBuffer)
--    if dataBuffer == 0 then
--        FloatMessage.getInstance():pushMessageForString("到庄家上限!!")
--    elseif dataBuffer == 1 then
--        FloatMessage.getInstance():pushMessageForString("到达玩家上限!!")
--    elseif dataBuffer == 2 then
--        FloatMessage.getInstance():pushMessageForString("筹码不足，无法下注!!")
--    elseif dataBuffer == 3 then
--        FloatMessage.getInstance():pushMessageForString("到达盘面上限!!")
--    elseif dataBuffer == 4 then
--        FloatMessage.getInstance():pushMessageForString("押注金额超过您总金额的四分之一!!")
--    end
end
function GameViewLayer:myBetMoney(dataBuffer)
    local ship = {}
    ship.llChipValue = dataBuffer[1]
    ship.wChipIndex = self:changeQuyu(dataBuffer[2]) 
    self.m_pLbLotteryGoldAll[ship.wChipIndex+1]:setString(dataBuffer[3])
    if ship.llChipValue > 0 then
        CBetManager.getInstance():addUserShip(ship)
    end
    
--    self:onMsgGameAllServer()
    self:onMsgGameShip(ship)
end

function GameViewLayer:otherBetMoney(dataBuffer)--{[1]=4 [2]=100000 [3]=100000 }
    print(dataBuffer[3])
    local num = self:changeQuyu(dataBuffer[1])+1
    CBetManager.getInstance():setAllServerAllStatic(num, dataBuffer[2])--//所有下注
    CBetManager.getInstance():setAllServerStatic(num, dataBuffer[3])--//这次下注
    CBetManager.getInstance():setAllServerEveryAmount(num, dataBuffer[3])--非玩家下注

    self:onMsgGameAllServer(num)
end
function GameViewLayer:changeQuyu(quyunum)
    local numquyu = 0
    if quyunum == 0 then numquyu = 1
    elseif quyunum == 1 then  numquyu = 2
    elseif quyunum == 2 then  numquyu = 0
    elseif quyunum == 3 then  numquyu = 3
    elseif quyunum == 4 then  numquyu = 5
    elseif quyunum == 5 then  numquyu = 6
    elseif quyunum == 6 then  numquyu = 4
    elseif quyunum == 7 then  numquyu = 7
    elseif quyunum == 8 then  numquyu = 8
    elseif quyunum == 9 then  numquyu = 9
    elseif quyunum == 10 then  numquyu = 10
    elseif quyunum == 11 then  numquyu = 11
    end
    return  numquyu
end
--更新自身icon，昵称等信息
function GameViewLayer:updataPlayerPanpel(player_,plyertype)
    if plyertype then
        if player_[1] == GlobalUserItem.tabAccountInfo.userid then
            return
        end
        local isHavePlayer = false
        for key, player in ipairs(CBetManager.getInstance():getUserInfoList()) do
            if player[1] == player_[1] then
                isHavePlayer = true
            end
        end
        if isHavePlayer == false then
            CBetManager.getInstance():setUserInfoList(player_)
            self.m_pQiTaWanJiaNum:setString("("..CBetManager.getInstance():getUserInfoListSize()..")")
        end
    else
        for key, player in ipairs(CBetManager.getInstance():getUserInfoList()) do
            if player[1] == player_ then
                table.remove(CBetManager.getInstance():getUserInfoList(),key)
                self.m_pQiTaWanJiaNum:setString("("..CBetManager.getInstance():getUserInfoListSize()..")")
            end
        end
    end
    
end
function GameViewLayer:updataMyMoney(args)
    self.m_pLbUsrGold:setString(args)    
    PlayerInfo.getInstance():setUserScore(args)
    PlayerInfo.getInstance():saveUserScore()
    self:updateJettonState()
end

function GameViewLayer:Nomoney(dataBuffer)
    FloatMessage.getInstance():pushMessageForString("钱数不足"..dataBuffer.."无法上庄!!")
end
function GameViewLayer:updealer(dataBuffer) -- 上庄
    print("...")
    CBetManager.getInstance():addBankerListByUserId(dataBuffer[1])
    --初始化庄家列表
    self:onMsgUpdateZhuangInfo()
end
function GameViewLayer:downDealers(dataBuffer) -- 下庄
    print("...")
    local nListCount = CBetManager.getInstance():getBankerListSize()
    for i=1,tonumber(nListCount),1 do
        local tmp = CBetManager.getInstance():getBankerListByIndex(i)
        if (dataBuffer[1] == tmp)then
            table.remove(CBetManager.getInstance().m_vecReqUserID, i)
        end
    end
    --初始化庄家列表
    self:onMsgUpdateZhuangInfo()
end
function GameViewLayer:updataDealers(dataBuffer) -- 换庄
    CBetManager.getInstance():setLastBankerUserId(CBetManager.getInstance():getBankerUserId())

    CBetManager.getInstance():setBankerUserId(dataBuffer[1][1])
    CBetManager.getInstance():setBankerTimes(1)
    CBetManager.getInstance():setBankerName(dataBuffer[1][2])
    CBetManager.getInstance():setBankerGold(dataBuffer[1][4])
    CBetManager.getInstance():cleanBankerList()
    for k,v in ipairs(dataBuffer) do
        CBetManager.getInstance():addBankerListByUserId(v[1])
        if v[1] == GlobalUserItem.tabAccountInfo.userid then
            CBetManager.getInstance():setSelfSlot(k - 1)
        end
    end

    --初始化庄家列表
    self:onMsgUpdateZhuangInfo()
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------

--region 事件绑定及处理
function GameViewLayer:initNetEvent()
    self.m_lTempUserGoldof = PlayerInfo.getInstance():getUserScore()
    PlayerInfo.getInstance():setTempUserScore(self.m_lTempUserGoldof)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/animals/animation/feiqinzoushou_jinshax100/feiqinzoushou_jinshax100.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/animals/animation/feiqinzoushou_shayu25/feiqinzoushou_shayu25.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/animals/animation/feiqinzoushou_tongchi/feiqinzoushou_tongchi.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/animals/animation/feiqinzoushou_tongpei/feiqinzoushou_tongpei.ExportJson")
--    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/animals/animation/naozhong_2/naozhong_2.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/animals/animation/bairenniuniu_dengdaikaiju/bairenniuniu_dengdaikaiju.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/animals/animation/daojishi_1/daojishi_1.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/animals/animation/feiqinzoushou_changjingtexiao/feiqinzoushou_changjingtexiao.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/animals/animation/feiqinzoushou_touzhong/feiqinzoushou_touzhong.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/animals/animation/feiqinzoushou_xuanzhong/feiqinzoushou_xuanzhong.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/animals/animation/feiqinzoushou_jiesuandongwu/feiqinzoushou_jiesuandongwu.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/animals/animation/kaishixiazhu_kaijiang/kaishixiazhu_kaijiang.ExportJson")
    
end

function GameViewLayer:unRegistNetCallback()

end

function GameViewLayer:startGameEvent()

end

function GameViewLayer:stopGameEvent()

end

function GameViewLayer:onMsgEnterNetWorkFail()
    self:onMsgEnterBackGround()
end

--进入后台
function GameViewLayer:onMsgEnterBackGround()

end

--进入前台
function GameViewLayer:onMsgEnterForeGround()

end

--重登录成功
function GameViewLayer:onMsgReloginSuccess()

end

function GameViewLayer:onMsgExitGame(msg)
    self._scene:onQueryExitGame()
end

function GameViewLayer:onNetworkFail(msg)
    FloatMessage.getInstance():pushMessage("STRING_023")
    PlayerInfo.getInstance():setIsGameBackToHall(true)
    SLFacade:dispatchCustomEvent(Public_Events.Load_Entry)
end

function GameViewLayer:onMsgGameInit()
    self:updateLottery()
    self:updateLotteryAll()
end

--游戏变化
--开始下注   下注结束,等待开奖    开始开奖    开奖结束
--开始下注
function GameViewLayer:onBeganChip()
    --开始下注时 同步一次金币
    self.m_pLbUsrGold:setString(PlayerInfo.getInstance():getUserScore())
    print("------ 开始下注")
    if self.m_bEnterFirst then
        self.m_bEnterFirst = false
        self:updateHistoryByFirst()
    end
    --开始下注前清空显示
    self:clearAtGameEndding()
    self._bIsPlaySound = false
    self._bIsPlayDaojishi= false
    self._bIsPlayClock = false
        
    -- 更新续投按钮状态
    self:updateContinueStatus()
    self.m_pBtnBank:setEnabled(true)

    for i=1,tonumber(CHIP_ITEM_COUNT),1 do
        self.m_pControlButtonChip[i]:setEnabled(true)
        self.m_pControlButtonChip[i]:setVisible(true)
    end

    --self.m_pPanelChipsAnimalsLOCK:setVisible(false)

    self:showBeginBetting()
    --重置音乐
--    ExternalFun.playGameEffect(SOUND_OF_SYSTEM[15])
    --延迟播放特效音乐
    --//播放开始投注
    ExternalFun.playGameEffect(SOUND_OF_SYSTEM[17])
    --播放开始下注特效
    self:showAnimationWithName(self.m_pAnimalUI:getChildByName("Node_anim") , "kaishixiazhu_kaijiang" , "Animation1")

    --下注完成后需要进行调整
    local _dt = cc.DelayTime:create(tonumber(0.1))
    local _call = cc.CallFunc:create(function ()
        local newSelIndex = CBetManager.getInstance():getJettonSelAdjust()
        if newSelIndex > 0 and newSelIndex < self.nIndexChoose then
            -- 最大可选筹码比当前选择筹码小的情况，才更新选择筹码
            self:onBetNumClicked(self.m_pControlButtonJetton[newSelIndex],ccui.TouchEventType.ended)
        end
    end)
    self:runAction(cc.Sequence:create(_dt,_call))

    --提示银行可用
--    local _event = {
--        name = Public_Events.MSG_BANK_STATUS,
--        packet = "1",
--    }
--    SLFacade:dispatchCustomEvent(Public_Events.MSG_BANK_STATUS, _event)              

    --更新筹码状态
    self:updateJettonState()
end

--停止下注
function GameViewLayer:onStopChip()
    print("------ 结束下注")
    -- 记录金币
    self.m_iLastPlayerGold = PlayerInfo.getInstance():getUserScore()
    self:updateContinueStatus()
    self.m_pBtnContinue:setVisible(true)
    self.m_pBtnBank:setEnabled(false)

    for i=1,tonumber(CHIP_ITEM_COUNT),1 do
        local llScore = CBetManager.getInstance():getScoreShip(i)
        if llScore <= 0 then        
            CBetManager.getInstance().m_vecUserShip = {}
        end
        local dt = cc.DelayTime:create(1)
        local call = cc.CallFunc:create(function ()
            self.m_pControlButtonChip[i]:setEnabled(false)
        end)
        local seq = cc.Sequence:create(dt, call)
        self.m_pControlButtonChip[i]:runAction(seq)
    end
            
    --//播放停止下注
    ExternalFun.playGameEffect(SOUND_OF_SYSTEM[18])

    --更新筹码状态
    self:updateJettonState()
end

--开始开奖
function GameViewLayer:onLottery()
    print("------ 游戏开奖")
    self:showOpenAnimation()
    self.m_bEnterFirst = true
    --更新筹码状态
    self:updateJettonState()
end

--押注清空
function GameViewLayer:onMsgGameShipClean(_event)
    self:onMsgGameShip(nil)
end

--押注成功
function GameViewLayer:onMsgGameShip(_event)
    --print("自己下注.......................")
    local msg = nil
    if _event then
        msg = _event
    end

    self.m_selfChip = true
    --Veil::getInstance()->setEnabled(false, VEIL_DEFAULT)
    self:updateLottery()

    local i = CBetManager.getInstance():getUserShipCount()
    if (i <= 0)then--清空成功
        --没有清空了
    else
        self.m_pBtnContinue:setEnabled(false)
    end

    if(msg == nil) then
        self:updateLotterySuccess(eventID, msg)
        self:updateJettonState()
        local newSelIndex = CBetManager.getInstance():getJettonSelAdjust()
        if newSelIndex > 0 and newSelIndex < self.nIndexChoose then
            -- 最大可选筹码比当前选择筹码小的情况，才更新选择筹码
            self:onBetNumClicked(self.m_pControlButtonJetton[newSelIndex],ccui.TouchEventType.ended)
        end
        return
    end

    if(CBetManager.getInstance():getUserShipCount() <= 0) then
        return --清空下注
    end

    local llChipValue = msg.llChipValue
    local wChipIndex = msg.wChipIndex + 1
    if (llChipValue <= 0)then
        return
    end

    --ExternalFun.playGameEffect("game/animals/soundpublic/sound-jetton.mp3")

    local sp = self:createSpriteOfChip(llChipValue,wChipIndex,true)
    self:updateLotterySuccess(eventID, msg)
    self:updateJettonState()
    local newSelIndex = CBetManager.getInstance():getJettonSelAdjust()
    if newSelIndex > 0 and newSelIndex < self.nIndexChoose then
        -- 最大可选筹码比当前选择筹码小的情况，才更新选择筹码
        self:onBetNumClicked(self.m_pControlButtonJetton[newSelIndex],ccui.TouchEventType.ended)
    end
end

--//续投成功
function GameViewLayer:onMsgContinueSuccess(_event)
    local msg = unpack(_event._userdata)
    if(msg == nil)then
        return
    end

    if not msg.wResult or msg.wResult ~= 0 then return end
--    local lContinueCount = CBetManager.getInstance():getUserShipLastCount()
--    for i=1,tonumber(lContinueCount),1 do
--        local chip = CBetManager.getInstance():getUserShipLast(i)
--        CBetManager.getInstance():addUserShip(chip)

--        --续投筹码动作
--        local vecAtion = CBetManager.getInstance():getSplitGold(chip.llChipValue) --self:getSplitGold(chip.llChipValue)
--        for i=1,table.maxn(vecAtion),1 do
--            --print("------------------------------------------------------------"..(chip.wChipIndex+1).."      "..vecAtion[i])
--            self:createSpriteOfChip(vecAtion[i], chip.wChipIndex+1, true)
--            --self.m_pNodeFlyIcon:addChild(sp)
--        end
--    end
    self.m_selfChip = true
    self:playContinueChipAnim()

    --用户最新金币
    local nUsrBanlance = PlayerInfo.getInstance():getUserScore()

    --移除下注金币
    local nUserChip = CBetManager.getInstance():getUserAllChips()
    if nUserChip > 0 then
        nUsrBanlance = nUsrBanlance - nUserChip
    end

    --设置显示金币
    local strUsrBanlance = self:getFormatGold(nUsrBanlance)
    self.m_lTempUserGoldof = nUsrBanlance
    PlayerInfo.getInstance():setTempUserScore(self.m_lTempUserGoldof)
    self.m_pLbUsrGold:setString(self.m_lTempUserGoldof)
    self.m_pBtnContinue:setEnabled(false)
    self:updateLottery()
    self:updateJettonState()
    local newSelIndex = CBetManager.getInstance():getJettonSelAdjust()
    if newSelIndex > 0 and newSelIndex < self.nIndexChoose then
        -- 最大可选筹码比当前选择筹码小的情况，才更新选择筹码
        self:onBetNumClicked(self.m_pControlButtonJetton[newSelIndex],ccui.TouchEventType.ended)
    end
end

--更新庄家信息
function GameViewLayer:onMsgUpdateZhuangInfo()
    local fWidthOfName = 150
    local name = CBetManager.getInstance():getBankerNickName()
    local strName = LuaUtils.getDisplayNickNameInGame(name)
    self.m_pLbZhuangName:setString(strName)

    local bClear = false
    if (CBetManager.getInstance():getBankerUserId() == -1) then
        bClear = true
    end

    local strGold = CBetManager.getInstance():getBankerGold()
    self.m_pLbZhuangMoney:setString(strGold)

    local bankerId = CBetManager.getInstance():getBankerUserId()
    local usrId = PlayerInfo.getInstance():getUserID()
    local isBanker = false
    local isInList = false

    if (bankerId == usrId) then
        isBanker = true
    end

    local nListCount = CBetManager.getInstance():getBankerListSize()
    for i=1,tonumber(nListCount),1 do
        local tmp = CBetManager.getInstance():getBankerListByIndex(i)
        if (usrId == tmp)then
            isInList = true
            break
        end
    end

    if (isInList == true and isBanker == false)then
        --string strNum = StringWithFormat(LocalString("FLY_13"),CBetManager.getInstance():getSelfSlot())
                --string strNum = StringWithFormat(LocalString("FLY_13"),CBetManager.getInstance():getSelfSlot())
        local strNum = CBetManager.getInstance():getSelfSlot()

        self.m_pLbZhuangNum:setString("前面人数："..strNum)
    else
        --string strNum = StringWithFormat(LocalString("FLY_12"),CBetManager.getInstance():getBankerListSize())
        local strNum = CBetManager.getInstance():getBankerListSize()
        self.m_pLbZhuangNum:setString("申请人数："..strNum)
    end

    local isCanReq = false

    if(isBanker == false) and (isInList == false) then
        isCanReq = true
    end

    if isCanReq == false then
        self.m_pBtnRequestToZhuang:setVisible(false)
        self.m_pBtnCancelToZhuang:setVisible(true)
    else
        self.m_pBtnRequestToZhuang:setVisible(true)
        self.m_pBtnCancelToZhuang:setVisible(false)
    end

    --只有下局开始之前才会有庄的提示信息
    if CBetManager.getInstance():getStatus() ~= CMsgAnimal.GAMESTATUS.STATUS_IDLETIME then
        return 
    end
    local isShowTips = false
    local isUpBanker = false
    if (CBetManager.getInstance():getBankerUserId() ~= CBetManager.getInstance():getLastBankerUserId())then
        -- 庄家轮换
        isUpBanker = true
        local strFrame = self:getRealFrameName("gui-wz-wanj.png")
        self.m_pSpZhunagTips:loadTexture(strFrame,ccui.TextureResType.plistType)
        self.m_pSpZhunagTips:setContentSize(cc.size(222,65))
        isShowTips = true
    elseif(CBetManager.getInstance():getBankerUserId() ~= -1)then
        -- 玩家庄家 连庄
        local times = CBetManager.getInstance():getBankerTimes()
        if(times <1 or times >10)then
            return
        end
        local strFrame = self:getRealFrameName("gui-wz-" .. times .. ".png")
        self.m_pSpZhunagTips:loadTexture(strFrame,ccui.TextureResType.plistType)
        self.m_pSpZhunagTips:setContentSize(cc.size(199,63))
        isShowTips = true
    end
    if isShowTips then
        -- //提示庄家
        self.m_pNodeTips:setOpacity(255)
        local show = cc.Show:create()
        local delay = cc.DelayTime:create(1.0)
        local fade = cc.FadeOut:create(0.2)
        local hide = cc.Hide:create()
        local seq = cc.Sequence:create(show, delay,
            cc.CallFunc:create(function()
                if isUpBanker then
                    if self._nSoundType > 0 then
                        ExternalFun.playGameEffect(SOUND_OF_SYSTEM[21])
                    else
                        ExternalFun.playGameEffect(SOUND_OF_SYSTEM[22])
                    end
                end
            end),
            fade, hide)
        self.m_pNodeTips:runAction(seq)
    end
end

function GameViewLayer:onMsgGameAllServer(msg)
    --print("他人下注.......................")
    --如果是第一次进入，需要播放所有的筹码，而不是最近一秒发生的筹码
    --print("-----------------------------------")
--    for i=1,tonumber(CHIP_ITEM_COUNT),1 do
        local valueAmount = 0
        --if (self.m_bEnterFirst)then
--            valueAmount = CBetManager.getInstance():getAllServerAllStatic(i)
--        else
            valueAmount = CBetManager.getInstance():getAllServerEveryAmount(msg)
--        end

        if valueAmount < 0 then
            valueAmount = 0
        end 
--print("---------valueAmount="..valueAmount)
        local recRet = CBetManager.getInstance():getSplitGold(valueAmount) -- self:getSplitGold(valueAmount)
        for j=1,tonumber(table.maxn(recRet)),1 do
            self.m_flychipidx = self.m_flychipidx + 1
            if self.m_flychipidx > 2 then self.m_flychipidx = 0 end
            local sp = self:createSpriteOfChip(recRet[j], msg, false)
        end
--    end
    --print("-----------------------------------")
--    self.m_bEnterFirst = false
    self.m_otherChip = true
    --add by nick
--    self:updateLottery()
    self:updateLotteryAll()
end

--银行
function GameViewLayer:showShop()
--    local pRecharge = self:getChildByName("RechargeLayer")
--    if pRecharge then
--        pRecharge:setVisible(true)
--        return
--    end

--    local isClosedAppStore = GameListManager.getInstance():getGameSwitch(G_CONSTANTS.GAMESWITCH.CLOSE_RECHARGE_APPSTORE)
--    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
--    if not (cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform or cc.PLATFORM_OS_MAC == targetPlatform) then 
--        isClosedAppStore = true
--    end

--    if isClosedAppStore then
--        pRecharge = RechargeLayer:create()
--    else
--        pRecharge = AppStoreView:create()
--    end

--    pRecharge:setPosition(0, (display.height - 750)/2)
--    pRecharge:setName("RechargeLayer")
--    pRecharge:setPositionY(pRecharge:getPositionY()-self.m_diffY)
--    self:addChild(pRecharge,20)
end

--endregion 事件绑定及处理

-- region 辅助方法

-- 获取自己的飞筹码坐标点
function GameViewLayer:getSelfFlyPos()
    return cc.p(self.Node_self_anim:getPosition())
end

-- 获取其他玩家的飞筹码坐标点
function GameViewLayer:getOtherFlyPos()
    return cc.p(self.Node_other_anim:getPosition())
end

-- 获取庄家的飞筹码坐标点
function GameViewLayer:getBankerFlyPos()
    return cc.p(self.Node_zhuang_anim:getPosition())
end

-- 检查自己是否中奖
function GameViewLayer:checkSelfBetWinWithIndex(index)
    for k, v in pairs(self.m_betChipSpSelf[index]) do
        if v then return true end
    end
    return false
end

-- 传入筹码钱 给一个图片
function GameViewLayer:getFileOfChip(llShipValue)
--    if llShipValue/10000 >= 1 then
--        llShipValue = tostring( llShipValue/10000 ).."w"
--    end
    return "cm/"..llShipValue..".png"
end

--取得起始筹码位置的 xy
function GameViewLayer:getBeginPosition(value)
    -- 每次需要进行遍历查找和两次坐标系转换，效率极低
--    local index = 1 
--    for i=1,tonumber(JETTON_ITEM_COUNT),1 do    
--        if (value == CBetManager.getInstance():getJettonScore(i))then
--            index = i
--            break
--        end
--    end

--    local worldPos = self.m_pControlButtonJetton[index]:convertToWorldSpaceAR(cc.p(0 , 0))
--    local pos = self.m_pNodeFlyIcon:convertToNodeSpaceAR(worldPos)

--    return {[1] = pos.x , [2] = pos.y}

    return self.m_posOfJetton[value]
end

-- 游戏结束时清理
function GameViewLayer:clearAtGameEndding()
    print("游戏完成,清理数据.................")
    for i=1,tonumber(CHIP_ITEM_COUNT),1 do
        self.m_pLbLotteryGoldAll[i]:setString("")
        self.m_pLbLotteryGoldCount[i]:setString("")
        --self.m_pSpBetNo[i]:setVisible(false)
        --self.m_pLotteryGoldAllZheZhao[i]:setVisible(false)
        self.m_pBlinkImg[i]:stopAllActions()
        self.m_pBlinkImg[i]:setVisible(false)
        -- 缓存筹码 此时缓存筹码，如果数据包延迟导致的连续业务包，可能会有筹码飞行异常
        for k, v in pairs(self.m_betChipSpSelf[i]) do
            if v then
                --v:setVisible(false)
                CChipCacheManager.getInstance():putChip(v, v:getTag())
            end
        end
        for k, v in pairs(self.m_betChipSpOthers[i]) do
            if v then
                --v:setVisible(false)
                CChipCacheManager.getInstance():putChip(v, v:getTag())
            end
        end
        self.m_betChipSpSelf[i] = {}
        self.m_betChipSpOthers[i] = {}
    end

    CBetManager.getInstance():clearAllServerAllStatic()
    CBetManager.getInstance():clearUserChip()
    -- 避免网络问题引起的筹码显示残留，隐藏所有管理的筹码
    CChipCacheManager.getInstance():HideAll()
    CChipCacheManager.getInstance():resetChipZOrder()
    print("缓存筹码数量：" .. CChipCacheManager.getInstance():getCacheNum())
    self:resetChipPos()
    self.m_flyJobVec = {}
    self.m_otherChip = false
    self.m_selfChip = false
    --self.m_pNodeFlyIcon:removeAllChildren()
    self.m_pNodeBetWinAnim:removeAllChildren()
    self.m_pLbUsrGold:setTag(1)
end

--格式化金钱显示
function GameViewLayer:getFormatGold(goldNo)
   goldNo = goldNo / 100
   goldNo = string.format("%.2f",goldNo)
   return goldNo
end

function GameViewLayer:getSplitGold(llValue)
    local vecRet = {}
    local baseValue = 10 --1000
    for i=1,tonumber(6),1 do
        local singleCount = (value % (baseValue*10)) / baseValue
        for j=1,tonumber(singleCount),1 do
            table.insert(vecRet,baseValue)
        end
        baseValue = baseValue*10
    end
    return vecRet
end

--获取有效的纹理路径
function GameViewLayer:getRealFrameName(name)
    local realName = string.format( "game/animals/gui/%s", name)
    return realName
end

function GameViewLayer:doSomethingLater(call, delay, ...)
    self.m_pAnimalUI:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(call, {...})))
end

function GameViewLayer:shedule(node, callback, time)
    node:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(time),cc.CallFunc:create(
        callback
     ))))
end

function GameViewLayer:setDeltaPosition(node , pos)
    local posx , posy = node:getPosition()
    node:setPosition(posx + pos.x , posy + pos.y)
end

-- 重置随机投注点
function GameViewLayer:resetChipPos()
    local offset = 7
    local rowVal = 3
    local colVal = 4
    for i = 1, CHIP_ITEM_COUNT do
        -- 鲨鱼的可投注行列数量
        if 9 == i then
            colVal = 8
            rowVal = 5
        end

        self.m_randmChipSelf[i] = self:getRandomChipPosVec(self.m_rectOfBet[i], 20, rowVal, colVal, offset)
        self.m_randmChipOthers[i] = self:getRandomChipPosVec(self.m_rectOfBet[i], 20, rowVal, colVal, offset)
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

    -- 如果有需要 可以再附加一部分随机点 注意避免重复
--    if num > #chipPosVec then
--        for m = 1, num - #chipPosVec do
--            local posx = math.random(1, newrect.width*100) / 100
--            local posy = math.random(1, newrect.height*100) / 100
--            table.insert(chipPosVec, cc.p(newrect.x + posx, newrect.y + posy))        
--        end
--    end

    -- 获取指定数量的随机放置点
    local takenum = (#chipPosVec > num) and (#chipPosVec - num) or 0
    for i = 1, takenum do
        local delIdx = math.random(1, #chipPosVec)
        table.remove(chipPosVec, delIdx)
    end

    return chipPosVec
end

--[Comment]
-- 计算最终显示的积分
function GameViewLayer:calcCurScore()
    --[[
    假设税率为0.05
    开奖时  玩家，如果中的积分小于等于自己总押注 则返回积分为完全分
            否则返回值 = (中的积分 - 总押注) * 0.95 + 总押注
                       = 中的积分*0.95 + 总押注*0.05

            庄家，积分>0时*0.95 小于0时为实际输分

    a:庄家免税积分 b:自己实际获得免税积分 c:其他玩家免税得分
    c + b = -a
    c = -a - b
    ]]--

    local selfcurscore = 0 -- 自己最终得分
    local bankercurscore = 0 -- 庄家最终得分
    local othercurscore = 0 -- 其他玩家最终得分
    local tax = 1 - CBetManager.getInstance():getGameTax() -- 扣掉明税税率

    -- 庄家胜负(免税)
    local bankerscore = CBetManager.getInstance():getBankerResultGold()
    bankercurscore = bankerscore > 0 and bankerscore / tax or bankerscore

    -- 自己总押注
--    local selfcost = 0
--    for i = 1, CHIP_ITEM_COUNT do
--        selfcost = selfcost + CBetManager.getInstance():getScoreShip(i)
--    end

    -- 自己实际胜负(免税)
    local selfscore = CBetManager.getInstance():getPlayerResultGold()
    selfcurscore = selfscore -- selfcost
    selfcurscore = selfcurscore > 0 and selfcurscore / tax or selfcurscore

    -- 计算其他玩家胜负(免税)
    if PlayerInfo.getInstance():getUserID() == CBetManager.getInstance():getBankerUserId() then -- 自己是庄家 其他玩家输赢等于庄家输赢
        selfcurscore = bankercurscore
        othercurscore = -bankercurscore
    else -- 自己不是庄家
        othercurscore = -bankercurscore - selfcurscore
    end

    selfcurscore = selfcurscore > 0 and selfcurscore * tax or selfcurscore
    othercurscore = othercurscore > 0 and othercurscore * tax or othercurscore

    return selfcurscore, othercurscore, bankerscore
end

function GameViewLayer:viewRecharge()
--    local pMessageBox = MessageBoxNew.create(LuaUtils.getLocalString("STRING_050"), MsgBoxPreBiz.PreDefineCallBack.CB_RECHARGE)
--    self:addChild(pMessageBox, 1000)
--    pMessageBox:setPositionY(pMessageBox:getPositionY()-self.m_diffY)
end

-- endregion 辅助方法

-- region 音效播放

function GameViewLayer:showScoreAnimation()
    local nMoeny = 0
    if(CBetManager.getInstance():IsBanker())then
        nMoeny = CBetManager.getInstance():getBankerResultGold()
    else
        nMoeny = CBetManager.getInstance():getPlayerResultGold()
    end

    if(nMoeny ~= 0)then
        --胜利动画
        ExternalFun.playGameEffect(SOUND_OF_SYSTEM[20])
    end
end

-- 开奖结束播放声音
function GameViewLayer:playCommodSound()
    local winSocre = CBetManager.getInstance():getWinScore()

    -- 自己总押注
    local selfcost = 0
    for i = 1, CHIP_ITEM_COUNT do
        selfcost = selfcost + CBetManager.getInstance():getScoreShip(i)
    end

--    if selfcost == 0 then
--        FloatMessage.getInstance():pushMessageForString("本局您没有下注!")
--    end

    -- 自己胜负分数
    winSocre = winSocre - selfcost

    -- 实际赢取的分数大于0才播放音效，避免和后面的最终结算分数音效不一致
    if (winSocre > 0) then
        self._nUserWinCount = self._nUserWinCount + 1
        self._nUserLoseCount = 0
        local strPath = ""
        local winSound = 0
        if (winSocre >= 1000000 or self._nUserWinCount >= 5) then
            if self._nSoundType > 0 then
                strPath = SOUND_OF_SYSTEM[1]
            else
                strPath = SOUND_OF_SYSTEM[2]
            end
            winSound = 3
        elseif (winSocre >= 500000 or self._nUserWinCount >= 3) then
            if self._nSoundType > 0 then
                strPath = SOUND_OF_SYSTEM[3]
            else
                strPath = SOUND_OF_SYSTEM[4]
            end
            winSound = 2
        elseif (winSocre >= 200000 or self._nUserWinCount >= 2) then
            if self._nSoundType > 0 then
                strPath = SOUND_OF_SYSTEM[5]
            else
                strPath = SOUND_OF_SYSTEM[6]
            end
            winSound = 1
        end

        if (winSound > self._nLastWinSound) then
            self._nLastWinSound = winSound
            self._nSoundCount = 0
            ExternalFun.playGameEffect(strPath)
        end
    elseif(CBetManager.getInstance():getUserShipCount() > 0) then
        self._nUserWinCount = 0 
        self._nUserLoseCount = self._nUserLoseCount + 1
        local strPath
        local loseSound = 0
        local betScore = CBetManager.getInstance():getShipScore()
        if (betScore >= 1000000 or self._nUserLoseCount >= 5) then
            strPath = SOUND_OF_SYSTEM[7] .. math.random(1,4) .. ".mp3"
            loseSound = 3
        elseif (betScore >= 500000 or self._nUserLoseCount >= 3) then
            if self._nSoundType > 0 then
                strPath = SOUND_OF_SYSTEM[8]
            else
                strPath = SOUND_OF_SYSTEM[9]
            end
            loseSound = 2
        elseif (betScore >= 200000 or self._nUserLoseCount >= 2) then
            if self._nSoundType > 0 then
                strPath = SOUND_OF_SYSTEM[10]
            else
                strPath = SOUND_OF_SYSTEM[11]
            end
            loseSound =1
        end

        if (loseSound > self._nLastLoseSound) then
            self._nLastLoseSound = loseSound
            self._nSoundCount = 0
            ExternalFun.playGameEffect(strPath)
        end
    end
    if (self._nLastWinSound>0 or self._nLastLoseSound>0) then
        self._nSoundCount = self._nSoundCount + 1
        if (self._nSoundCount >= 10) then
            self._nSoundCount = 0
            self._nUserWinCount = 0
            self._nUserLoseCount = 0
            self._nUserLoseCount = 0
            self._nLastLoseSound = 0
            self._nLastWinSound = 0
        end
    end
end

-- endregion 音效播放

--region 倒计时及闹钟

-- 更新当前业务状态提示
function GameViewLayer:updateStatusDesc()
    local val = CBetManager.getInstance():getStatus()
    self.m_pLbStatus:setSpriteFrame(self:getRealFrameName(GameStatusDesc[val]))
end

-- 倒计时
function GameViewLayer:updateCountDown()
    if (true)then
        local count = CBetManager.getInstance():getTimeCount()
        if count > 0 then self:updateStatusDesc() end
        if self.m_pLbCountTime then
            -- 倒计时数字
            local num1 = math.floor(count/10)
            local num2 = count%10
            local curstr = string.format("%d%d", num1, num2)
            self.m_pLbCountTime:setString(curstr)
            CBetManager.getInstance():setTimeCount(count - 1)
            if self.m_lastCount ~= count then
                self.m_lastCount = count

--            if count > 0 then
--                self.m_countbumBGAni:setVisible(true)
--                self.m_countbumBGAni:getAnimation():play("Animation1", -1, -1)
--            end
                
                local fntstr = "game/animals/fnts/number-h.fnt"
                -- 数字扩张发散动画
                local aniscale = 1.5
                local aniscaletime = 0.3
                local fadetotime = 0.4

                local lb1 = cc.Label:createWithBMFont(fntstr, string.format("%d", num1))
                            :setPosition(self.m_pLbCountTime:getPositionX() - 3, self.m_pLbCountTime:getPositionY() + 2)
                            :setAnchorPoint(0.5, 0.5)
                            --:setColor(cc.c3b(0,0,0))
                            :setOpacity(0)
                            :addTo(self.m_PanelGameLayer)

                local seq1 = cc.Sequence:create(cc.Spawn:create(cc.FadeTo:create(fadetotime, 50),
                                                                cc.ScaleBy:create(fadetotime, aniscale),
                                                                cc.MoveBy:create(fadetotime, cc.p(-10.0, 0))),
                                                cc.Spawn:create(cc.FadeOut:create(0.5),
                                                                cc.ScaleBy:create(0.3, 1.2)),
                                                cc.RemoveSelf:create())
                lb1:runAction(seq1)


                local lb2 = cc.Label:createWithBMFont(fntstr, string.format("%d", num2))
                            :setPosition(self.m_pLbCountTime:getPositionX() + 3, self.m_pLbCountTime:getPositionY() + 2)
                            :setAnchorPoint(0.5, 0.5)
                            --:setColor(cc.c3b(0,0,0))
                            :setOpacity(0)
                            :addTo(self.m_PanelGameLayer)

                local seq2 = cc.Sequence:create(cc.Spawn:create(cc.FadeTo:create(fadetotime, 50),
                                                                cc.ScaleBy:create(fadetotime, aniscale),
                                                                cc.MoveBy:create(fadetotime, cc.p(10.0, 0))),
                                                cc.Spawn:create(cc.FadeOut:create(0.5),
                                                                cc.ScaleBy:create(0.3, 1.2)),
                                                cc.RemoveSelf:create())
                lb2:runAction(seq2)

                
                local scaleAnim = cc.ScaleBy:create(0.3, 1.10)
                local scaleRev = scaleAnim:reverse()
                local seq = cc.Sequence:create(scaleAnim, scaleRev)
                self.m_pLbCountTime:runAction(seq)

            end
        end

        if CBetManager.getInstance():getStatus() == CMsgAnimal.GAMESTATUS.STATUS_BEGANCHIP and count <= 3 then
            
            if not self._bIsPlayDaojishi then
                self._bIsPlayDaojishi = true
                --显示321
                self:showDaojishi(count)
            end
        end
    end
end

-- 显示最后3秒倒计时和播放音效
function GameViewLayer:showDaojishi(count)
    local armature = self:showAnimationWithIndex(self.m_pAnimalUI:getChildByName("Node_anim") , "daojishi_1")
    local frameIndex = math.ceil((3 -count) * 60 + 1)
    if frameIndex > 170 then frameIndex = 170 end 
    armature:getAnimation():gotoAndPlay(frameIndex)

    --帧回调无效？使用延迟播放
    for i = 1, count do
        self:doSomethingLater(function ()
            if self.m_nSoundClock then
                
                self.m_nSoundClock = nil
            end
            self.m_nSoundClock = ExternalFun.playGameEffect("game/animals/soundpublic/sound-countdown.mp3")
        end , i - 1)
    end
end

-- 显示闹钟
function GameViewLayer:showNaoZhongEffect(count)
    if self.m_PanelGameLayer == nil then
        return
    end    

    local armature = self:showAnimationWithIndex(self._Panel_Title_Zhuang , "naozhong_2" , function (  )
        self.m_pBtnContinue:setEnabled(false)
    end)

    --从当前秒数开始播特效
    --local frameIndex = math.ceil((5 -count) * 61)
    --if frameIndex > 300 then frameIndex = 300 end 
    --armature:getAnimation():gotoAndPlay(frameIndex)
    --armature:setName("showNaoZhongEffect")
    --armature:setPosition(self.m_pNodeClock:getPositionX(),self.m_pNodeClock:getPositionY()+12)
end

--endregion 闹钟

--region 动画相关
-- 自删除动画
function GameViewLayer:createAutoDelAnim(sp, delay)
    -- 缓存筹码，不再remove
    local func = function()
        CChipCacheManager.getInstance():putChip(sp, sp:getTag())
    end
    local delay = cc.DelayTime:create(delay)
    local seq = cc.Sequence:create(delay, cc.Hide:create(), cc.CallFunc:create(func))
    return seq
end

--金币变更动画
function GameViewLayer:showGoldChangeAnimation()
    local selfcurscore = 0 -- 自己最终得分
    local bankercurscore = 0 -- 庄家最终得分
    local othercurscore = 0 -- 其他玩家最终得分

    selfcurscore, othercurscore, bankercurscore = self:calcCurScore()

    local pathwin = "game/animals/fnts/sz_pdk3.fnt"
    local pathlose = "game/animals/fnts/sz_pdk4.fnt"
    local beganpos = cc.p(0, 0)
    local str = ""
    local curpath = ""

    -- 0分也显示
    -- 显示庄家分数动画
    --if 0 ~= bankerscore then
        --print("显示庄家分数动画")
        beganpos = self:getBankerFlyPos()
        beganpos.x = beganpos.x + 10
        beganpos.y = beganpos.y + 50
        str = bankercurscore
        if bankercurscore > 0 then str = "+" .. str end
        curpath = bankercurscore < 0 and pathlose or pathwin
        self:flyNumOfGoldChange(curpath, str, beganpos)
        self.m_pLbZhuangMoney:setString(CBetManager.getInstance():getBankerGold()+bankercurscore)
        CBetManager.getInstance():setBankerGold(CBetManager.getInstance():getBankerGold()+bankercurscore)
        
    --end

    -- 显示其他玩家分数动画
    if self.m_otherChip or 0 ~= othercurscore then
        --print("显示其他玩家分数动画")
        beganpos = self:getOtherFlyPos()
        beganpos.x = beganpos.x - 25
        beganpos.y = beganpos.y + 25
        str = othercurscore
        if othercurscore > 0 then str = "+" .. str end
        curpath = othercurscore < 0 and pathlose or pathwin
        self:flyNumOfGoldChange(curpath, str, beganpos)
    end

    -- 显示自己分数动画
    if self.m_selfChip or 0 ~= selfcurscore then
        --print("显示自己分数动画")
        beganpos = self:getSelfFlyPos()
        beganpos.x = beganpos.x + 10
        beganpos.y = beganpos.y + 70
        str = selfcurscore
        if selfcurscore > 0 then
            str = "+" .. str
        end

        curpath = selfcurscore < 0 and pathlose or pathwin
        self:flyNumOfGoldChange(curpath, str, beganpos)

        if selfcurscore > 0 then
            ExternalFun.playGameEffect("game/animals/soundpublic/sound-gold.wav")
            local llAwardValue = selfcurscore
            local llStartScore = self.m_iLastPlayerGold
            local llStopScore  = PlayerInfo.getInstance():getUserScore()
            -- 通用动画内部包含了金币音效
--            Effect:getInstance():showScoreChangeEffect(self.m_pLbUsrGold, llStartScore, llAwardValue, llStopScore, 1, 10, nil, nil, true)
--            Effect:getInstance():showScoreChangeEffectWithNoSound(self.m_pLbUsrGold, llStartScore, llAwardValue, llStopScore)
        elseif selfcurscore == 0 then
            ExternalFun.playGameEffect("game/animals/soundpublic/sound-gold.wav")
            self.m_pLbUsrGold:setString(PlayerInfo.getInstance():getTempUserScore())
        else
            ExternalFun.playGameEffect("game/animals/soundpublic/sound-lose.mp3")
            self.m_pLbUsrGold:setString(PlayerInfo.getInstance():getTempUserScore())
        end
    end

end

-- 弹金币动画
function GameViewLayer:flyNumOfGoldChange(filepath, iOffset, benginePos)
    local pSprResult = cc.LabelBMFont:create(iOffset,filepath)
    pSprResult:setAnchorPoint(0,0)
    pSprResult:setPosition(benginePos)
    pSprResult:setScale(0.6)
    self.m_pNodeFlyIcon:addChild(pSprResult,1)

    local size = pSprResult:getContentSize()
    local offset = size.height * 1.2
    local move = cc.MoveBy:create(0.2, cc.p(0.0,10.0))
    local pFadein = cc.FadeIn:create(0.2)
    local pDelay = cc.DelayTime:create(1.8)
    --local pFadeout = cc.FadeOut:create(0.8)
    local pFadeout = cc.Spawn:create(
                        cc.FadeOut:create(0.4),
                        cc.EaseExponentialOut:create(cc.MoveBy:create(0.4, cc.p(0, offset))))
    local callBack = cc.CallFunc:create(function ()
        pSprResult:removeFromParent()
    end)

    local pSeq = cc.Sequence:create(cc.Spawn:create(pFadein,move),pDelay,pFadeout,callBack)
    pSprResult:runAction(pSeq)   
end

--等待提示
function GameViewLayer:showBeginBetting()   
    local fadeout = cc.FadeOut:create(0.5)
    local hide = cc.Hide:create()
    local seq = cc.Sequence:create(fadeout, hide)
    self.m_pSpWaitNext:runAction(seq)
end

-- 打开转盘动画
function GameViewLayer:showOpenAnimation()
    --计算移动的总数量和开始位置
    local lCount = 28 --总共一圈28个
    local lRound = 3  --转3圈
    local fAniTime = 0.5
    local beginIndex = CBetManager.getInstance():getLastPos()
    local endIndex = CBetManager.getInstance():getDstPos()
    local subIndex = 0

    if beginIndex > endIndex then
        subIndex = lCount - beginIndex + endIndex
    else
        subIndex = endIndex - beginIndex
    end

    self.m_iShowAmount = (lCount * lRound + beginIndex) + subIndex
    if (beginIndex - 1 >= 0) then
        self.m_iShowIndex = (beginIndex - 1)
    else
        self.m_iShowIndex = (lCount - 1)
    end

    self.m_fOpenAniTime = fAniTime 
    self:showAnimationWithName(self.m_pAnimalUI:getChildByName("Node_anim") , "kaishixiazhu_kaijiang" , "Animation2" , function ( ... )
        self:updateOpenAnimation()
    end)

    self.m_pLbUsrGold:setTag(-1)
end

-- 更新转盘动画
function GameViewLayer:updateOpenAnimation()
    --open end
    if self.m_iShowIndex >= self.m_iShowAmount then
        self.m_iShowIndex = 0
        self:openAnimationEnd()
        local endIndex = CBetManager.getInstance():getDstPos() 
        if 0 == endIndex then return end -- tofix: 出现为0的情况 后面会崩溃 原因暂时未知
        return
    end


    if ((self.m_fOpenAniTime - 0.05) <= 0.01) then
        self.m_fOpenAniTime  = 0.01
    else
        self.m_fOpenAniTime  = self.m_fOpenAniTime - 0.05
    end
    self.m_iShowIndex = self.m_iShowIndex + 1
    local index = self.m_iShowIndex % 28
    local subIndex = self.m_iShowAmount - self.m_iShowIndex
    if (0 <= subIndex and subIndex <= 5)then
        self.m_fOpenAniTime = (6 - subIndex) * 0.2
    elseif 6 <= subIndex and subIndex <= 8 then
        self.m_fOpenAniTime = (9 - subIndex) * 0.05
    end


    -- 让6个有影子的感觉
    for i=1,tonumber(JETTON_ITEM_COUNT),1 do
        local bFast = false
        local bFirst = false
        if (self.m_fOpenAniTime <= 0.02) then
            bFast = true
        end

        if (i == 1) then
            bFirst = true
        end

        if bFast or bFirst then
            self.m_pSpriteSelect[i]:setVisible(true)
        else
            self.m_pSpriteSelect[i]:setVisible(false)
        end

        local nSelectIndex = 1
        if (index - i >= 0) then
            nSelectIndex = index - i + 1
        else
            nSelectIndex = 28
        end

        local _x = self.m_pPanelRounder:getChildren()[nSelectIndex]:getPositionX()
        local _y = self.m_pPanelRounder:getChildren()[nSelectIndex]:getPositionY()
        self.m_pSpriteSelect[i]:setPositionX(_x)
        self.m_pSpriteSelect[i]:setPositionY(_y)
    end
    
    local _dt = cc.DelayTime:create(tonumber(self.m_fOpenAniTime))
    local _call = cc.CallFunc:create(function ()
        self:updateOpenAnimation()
    end)
    self.m_pPanelRounder:runAction(cc.Sequence:create(_dt,_call))
    --play effect
    if self.m_fOpenAniTime == 0.01 then 
        if self.m_iShowIndex % 3 == 0  then
            --print("m_fOpenAniTime: " .. self.m_fOpenAniTime .. "   m_iShowAmount: " .. self.m_iShowAmount .. "   m_iShowIndex: " .. self.m_iShowIndex )
            ExternalFun.playGameEffect(SOUND_OF_SYSTEM[12])
        end
    else
        ExternalFun.playGameEffect(SOUND_OF_SYSTEM[12])
    end
    
end

-- 开始结算动画
function GameViewLayer:openAnimationEnd()
    local dstIndex = CBetManager.getInstance():getDstIndex()
    --play animation
    self.m_pAnimVeil:setVisible(true)
    if nil == AnimalDefine[dstIndex] then
        print("无效的开奖数据~~~~~~~~~~~~~" .. dstIndex)
        return
    end
    local animationName = dstIndex > 7 and AnimalDefine[dstIndex].STRING_ANIMATION_NAME or "feiqinzoushou_jiesuandongwu"
    local substr = dstIndex > 7 and "" or AnimalDefine[dstIndex].STRING_ANIMATION_NAME
    local anim = self:showAnimationWithIndex(self.m_pAnimalUI:getChildByName("Node_anim"),
                                             animationName,
                                             function ( ... ) self:showBetWinEffect() end,
                                             false,
                                             substr,
                                             true)

    anim:setPosition(cc.p(0,-90))
    
    --play music 动物
    ExternalFun.playGameEffect(SOUND_OF_SYSTEM[13]..dstIndex..".mp3")
end

-- 显示中奖动画
function GameViewLayer:showBetWinEffect()
    local dstIndex = CBetManager.getInstance():getDstIndex()

    --自己投中的才播放投中特效
    local runSelect = function(index,bAnimal)
        if self:checkSelfBetWinWithIndex(index) then
            local node = self.m_pNodeBetWinAnim
            local position = cc.p(self.m_pControlButtonChip[index]:getPosition())
            position.x = position.x
            position.y = position.y - 25
            local animBegin = self:showAnimationWithName(node,"feiqinzoushou_touzhong","Animation1" , function ( ... )
                local animLoop = self:showAnimationWithName(node,"feiqinzoushou_touzhong","Animation2")
                animLoop:setPosition(position)
            end , true)
            --animBegin:setLocalZOrder(10)
            animBegin:setPosition(position)
        end
        self.m_pBlinkImg[index]:runAction(cc.Sequence:create(cc.Blink:create(5, 5), cc.Show:create()))
    end

    if dstIndex > 9 then
        if 11 == dstIndex then -- 通赔显示全部 通吃不做任何选择
            for i=1,tonumber(CHIP_ITEM_COUNT),1 do
                runSelect(i)
            end
        end
    elseif dstIndex > 7 then
        runSelect(9)
    elseif dstIndex > 3 then
        runSelect(11)
        runSelect(dstIndex+1)
    elseif dstIndex >= 0 then
        runSelect(10)
        runSelect(dstIndex+1)
    else
        -- 出现-1的情况是CBetManager被重置数据了
        print("异常的开奖业务数据：" .. dstIndex)
        return
    end

    self:doSomethingLater(function ()
        self:playCommodSound()
        --self:flyChip()
        self:flychipex()
    end , 1.0)
end

--创建一个静态放置筹码
function GameViewLayer:createStaticSpriteOfChip(jettonIndex,index,bSelf)
    local pSpr = CChipCacheManager.getInstance():getChip(jettonIndex)
    pSpr:setTag(jettonIndex)

    local endpos = cc.p(0, 0)
    local idx = 0
    local oldSp = nil
    if bSelf == true then
        idx = math.random(1, #self.m_randmChipSelf[index])
        oldSp = self.m_betChipSpSelf[index][idx]
        self.m_betChipSpSelf[index][idx] = pSpr
        endpos = self.m_randmChipSelf[index][idx]
    else
        idx = math.random(1, #self.m_randmChipOthers[index])
        oldSp = self.m_betChipSpOthers[index][idx]
        self.m_betChipSpOthers[index][idx] = pSpr
        endpos = self.m_randmChipOthers[index][idx]
    end

    if oldSp then
        oldSp:runAction(self:createAutoDelAnim(oldSp, 0.1))
    end

    pSpr:setVisible(true)
    pSpr:setScale(self.m_chip_scale - 0.05)
    pSpr:setPosition(endpos)
end

--创建一个飞行筹码 值 中间目标的位置
function GameViewLayer:createSpriteOfChip(jettonIndex,index,bSelf) 
    local pSpr = CChipCacheManager.getInstance():getChip(jettonIndex)
    pSpr:setTag(jettonIndex)

    local endpos = cc.p(0, 0)
    local begin = cc.p(0, 0)
    local idx = 0
    local oldSp = nil
    if bSelf == true then
        idx = math.random(1, #self.m_randmChipSelf[index])
        oldSp = self.m_betChipSpSelf[index][idx]
        self.m_betChipSpSelf[index][idx] = pSpr
        endpos = self.m_randmChipSelf[index][idx]
        --begin = cc.p(self:getBeginPosition(jettonIndex))
        begin = self:getSelfFlyPos()
    else
        idx = math.random(1, #self.m_randmChipOthers[index])
        oldSp = self.m_betChipSpOthers[index][idx]
        self.m_betChipSpOthers[index][idx] = pSpr
        endpos = self.m_randmChipOthers[index][idx]
        begin = self:getOtherFlyPos()
    end

    if oldSp then
        oldSp:runAction(self:createAutoDelAnim(oldSp, 2))
    end

    local move = cc.MoveTo:create(0.25, endpos)
--    local scale = cc.ScaleBy:create(0.1,0.65)
--    local scaleRev = scale:reverse()
    local time = 0
    if  bSelf == true then
        time = 0
    else
        time = (self.m_flychipidx * 0.3) + (math.random(0, 20) / 40)
    end

    local delay = cc.DelayTime:create(time)
    local call = cc.CallFunc:create(function ()
        pSpr:setVisible(true)
        if bSelf == true then -- 自己的音效立刻播放
             if jettonIndex > 10000 then -- 分投注级别播放音效 金额大于100块的播放高价值音效
                 ExternalFun.playGameEffect("game/animals/soundpublic/sound-bethigh.mp3")
             else
                 ExternalFun.playGameEffect("game/animals/soundpublic/sound-betlow.mp3")
             end            
        else
            if not self.m_isPlayBetSound then
                if jettonIndex > 10000 then -- 分投注级别播放音效 金额大于100块的播放高价值音效
                    ExternalFun.playGameEffect("game/animals/soundpublic/sound-bethigh.mp3")
                else
                    ExternalFun.playGameEffect("game/animals/soundpublic/sound-betlow.mp3")
                end
                --ExternalFun.playGameEffect("game/animals/soundpublic/sound-jetton.mp3")
                -- 尽量避免重复播放
                self:doSomethingLater(function() self.m_isPlayBetSound  = false end, math.random(2,4)/10)
                self.m_isPlayBetSound = true
            end
        end
    end)

    --local seq = cc.Sequence:create(delay, call, move, scale, scaleRev)
    local seq = cc.Sequence:create(delay, call, move)
    pSpr:setVisible(false)
    pSpr:setScale(self.m_chip_scale - 0.05)
    pSpr:setPosition(begin)
    pSpr:runAction(seq)

    return pSpr
end

function GameViewLayer:showAnimationWithIndex(node , name , callback, notCleanFlag, subname, anihide)
    local x = 0 
    local y = 0 
    local zorder = zorder or 1 
    local armature = ccs.Armature:create(name) 
    node:addChild(armature) 
    if "" == subname or nil == subname then
        armature:getAnimation():playWithIndex(0, -1, -1)
    else
        armature:getAnimation():play(subname)
    end

    local animationEvent = function (armatureBack, movementType, movementID)
        if movementType == ccs.MovementEventType.complete then
            if callback then callback() end
            if anihide then
                self.m_pAnimVeil:setVisible(false)
                local scaleTo = cc.ScaleTo:create(0.4, 0.0)
                local endpos = cc.p(self.m_PanelGameLayer:getChildByName("Panel_History"):getPosition())
                endpos.x = endpos.x - 620
                if self.m_historyNum > 7 then
                    endpos.y = endpos.y - 430
                else
                    endpos.y = endpos.y - 430 + (8 - self.m_historyNum) * 60
                end
                local moveTo = cc.MoveTo:create(0.4, endpos)
                local callback = cc.CallFunc:create(function ()
                    armature:removeFromParent()
                end)
                local seq = cc.Sequence:create(cc.Spawn:create(scaleTo, moveTo), callback)
                armature:runAction(seq)
            else
                if not notCleanFlag then armature:removeFromParent(true) end
            end
            
        end
    end
    armature:getAnimation():setMovementEventCallFunc(animationEvent)
    return  armature   
end

function GameViewLayer:showAnimationWithName(node , name , animationName , callback , notCleanFlag)
    local x = node:getContentSize().width/2
    local y = node:getContentSize().height/2
    local zorder = zorder or 1 
  
--    ccs.ArmatureDataManager:getInstance():getAnimationData(name)
    local armature = ccs.Armature:create(name) 
    armature:setPosition(x,y) 
    node:addChild(armature) 
    armature:getAnimation():play(animationName , -1, -1)  
    local animationEvent = function (armatureBack, movementType, movementID)
        if movementType == ccs.MovementEventType.complete then
            if callback then callback() end
            if not notCleanFlag then armature:removeFromParent(true) end
        end
    end
    armature:getAnimation():setMovementEventCallFunc(animationEvent)
    return  armature   
end

-- 续投筹码播放动画
function GameViewLayer:playContinueChipAnim()
    local lContinueCount = CBetManager.getInstance():getUserShipLastCount()
    -- 优化续投业务
    local chipvalVec = {}
    for i = 1, CHIP_ITEM_COUNT do chipvalVec[i] = 0 end
    for i=1,tonumber(lContinueCount),1 do
        local chip = CBetManager.getInstance():getUserShipLast(i)
        chipvalVec[chip.wChipIndex+1] = chipvalVec[chip.wChipIndex+1] + chip.llChipValue
        CBetManager.getInstance():addUserShip(chip)
    end

    for i = 1, CHIP_ITEM_COUNT do
        --print(string.format( "续投情况,区域[%d]投注[%d]", i, chipvalVec[i]))
        local vecAtion = CBetManager.getInstance():getSplitGold(chipvalVec[i]) --self:getSplitGold(chip.llChipValue)
        --print("拆分筹码数量：" .. #vecAtion)
        for j=1, table.maxn(vecAtion) do
            self:createSpriteOfChip(vecAtion[j], i, true)
            --self.m_pNodeFlyIcon:addChild(sp)
        end
    end

end

-- 克隆一个赔付的筹码对象(注意克隆的对象里面不包含任何数据信息以及纹理路径地址)
function GameViewLayer:clonePayoutChip(sp)
    local newsp = CChipCacheManager.getInstance():getChip(sp:getTag())
                    :setAnchorPoint(sp:getAnchorPoint())
                    :setScale(sp:getScale())
                    :setTag(sp:getTag())
                    :setVisible(false)
    return newsp
end

-- 以队列方式进行飞筹码
function GameViewLayer:flychipex()
    -- 处理现有的筹码对象列表
    -- 筹码精灵对象  tag() 代表投注在哪个区域
    local dstIndex = CBetManager.getInstance():getDstIndex()
    local winBetsIndex = {} -- 获胜区域
    if(dstIndex == 0 or dstIndex == 1 or dstIndex == 2 or dstIndex == 3) then -- 飞禽
        table.insert(winBetsIndex,dstIndex+1) 
        table.insert(winBetsIndex,10) 
    elseif(dstIndex == 4  or dstIndex == 5 or dstIndex == 6 or dstIndex == 7) then -- 走兽
        table.insert(winBetsIndex,dstIndex+1) 
        table.insert(winBetsIndex,11) 
    elseif(dstIndex == 8  or dstIndex == 9) then --shark 鲨鱼
        table.insert(winBetsIndex,9) 
    elseif(dstIndex == 11) then --通赔
        for i=1,tonumber(CHIP_ITEM_COUNT),1 do
            table.insert(winBetsIndex,i) 
        end
    end

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

    for i = 1, CHIP_ITEM_COUNT do
        bankerwinvec[i] = {}
        bankerlostvec[i] = {}
        selfwinvec[i] = {}
        otherwinvec[i] = {}
        selfvec[i] = {bankwin = true, vec = self.m_betChipSpSelf[i]}
        othervec[i] = {bankwin = true, vec = self.m_betChipSpOthers[i]}
    end

    -- 标记玩家获胜的区域
    for i = 1, #winBetsIndex do
        selfvec[winBetsIndex[i]].bankwin = false
        othervec[winBetsIndex[i]].bankwin = false
    end

    -- 遍历获胜的区域 必须用pairs方式 保证所有筹码遍历到
    local selfPos = self:getSelfFlyPos()
    local bankerPos = self:getBankerFlyPos()
    local otherPos = self:getOtherFlyPos()
    for i = 1, CHIP_ITEM_COUNT do
        for k, v in pairs(selfvec[i].vec) do
            if v then
                if selfvec[i].bankwin then
                    table.insert(bankerwinvec[i], {sp = v, endpos = bankerPos})
                    bankerwin = true
                else
                    table.insert(selfwinvec[i], {sp = v, endpos = selfPos})
                    selfwin = true
                end
            end
        end

        for k, v in pairs(othervec[i].vec) do
            if v then
                if selfvec[i].bankwin then
                    table.insert(bankerwinvec[i], {sp = v, endpos = bankerPos})
                    bankerwin = true
                else
                    table.insert(otherwinvec[i], {sp = v, endpos = otherPos})
                    otherwin = true
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
    local rewardCount = 0
    local rewardCountMax = 30 -- 最多一个区域赔付30个筹码
    local offset = 7
    for i = 1, CHIP_ITEM_COUNT do
        countself = #selfwinvec[i] -- 后面会对vec进行插入 所以保存一个初始的索引
        --countself = countself > 8 and countself/2 or countself
        rewardCount = 0
        for m = 1, CHIP_REWARD[i] do
            if rewardCount > rewardCountMax then
                break
            end
            for j = 1, countself do
                rewardCount = rewardCount + 1
                if rewardCount > rewardCountMax then
                    break
                end
                -- 取出原始的筹码对象复制
                local oldsp = selfwinvec[i][j].sp
                if oldsp then
                    local newsp = self:clonePayoutChip(oldsp)
                    -- 初始点在庄家处
                    newsp:setPosition(bankerPos)
                    -- 加入赔付队列 落点坐标直接从预定义的随机落点取 赔付的筹码使用随机区域落点互换
                    local posIdx = j % #self.m_randmChipOthers[i]
                    posIdx = posIdx > 0 and posIdx or 1
                    table.insert( bankerlostvec[i], { sp = newsp, endpos = self.m_randmChipOthers[i][posIdx]})
                    bankerlose = true
                    -- 加入自己的获胜队列
                    table.insert( selfwinvec[i], { sp = newsp, endpos = selfPos })
                end
            end
        end
        countother = #otherwinvec[i]
        countother = countother > 8 and countother/2 or countother
        for j = 1, countother do
            local oldsp = otherwinvec[i][j].sp
            if oldsp then
                local newsp = self:clonePayoutChip(oldsp)
                newsp:setPosition(bankerPos)
                local randx = (math.random(-offset*100, offset*100)) / 100
                local randy = (math.random(-offset*100, offset*100)) / 100
                local posIdx = j % #self.m_randmChipSelf[i]
                posIdx = posIdx > 0 and posIdx or 1
                table.insert( bankerlostvec[i], { sp = newsp, endpos = self.m_randmChipSelf[i][posIdx] })
                bankerlose = true
                --table.insert( bankerlostvec[i], { sp = newsp, endpos = cc.p(oldsp:getPosition()) })
                table.insert( otherwinvec[i], { sp = newsp, endpos = otherPos })
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
                                ExternalFun.playGameEffect("game/animals/soundpublic/sound-get-gold.mp3")
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
                                ExternalFun.playGameEffect("game/animals/soundpublic/sound-get-gold.mp3")
                            end
                        end,
        --overCB        = function() print("庄家赔付筹码飞行完毕") end,
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
                                ExternalFun.playGameEffect("game/animals/soundpublic/sound-get-gold.mp3")
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
                                ExternalFun.playGameEffect("game/animals/soundpublic/sound-get-gold.mp3")
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
        self:showGoldChangeAnimation()
    end

    table.insert(self.m_flyJobVec.jobVec, { jobitem1 }) -- 1 飞行庄家获取筹码
    table.insert(self.m_flyJobVec.jobVec, { jobitem2 }) -- 2 飞行庄家赔付筹码
    table.insert(self.m_flyJobVec.jobVec, { jobitem3, jobitem4 }) -- 3 其他人筹码和自己筹码一起飞行

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

--endregion 动画相关

return GameViewLayer
