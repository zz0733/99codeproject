--
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun               = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
--local GameChatLayer             = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
--local ClipText                  = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
--local AnimationMgr              = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")
local module_pre                = "game.yule.bjl.src"
local RuleLayer                 = appdf.req(module_pre .. ".views.layer.RuleLayer")
local BaccaratRes               = appdf.req(module_pre .. ".game.baccarat.scene.BaccaratRes")
local BaccaratDefine            = appdf.req(module_pre .. ".game.baccarat.scene.BaccaratDefine")
local BaccaratTrendLayer        = appdf.req(module_pre .. ".views.layer.BaccaratTrendLayer")
local BaccaratOtherInfoLayer    = appdf.req(module_pre .. ".views.layer.BaccaratOtherInfoLayer")
local Poker                     = appdf.req(module_pre .. ".views.layer.BaccaratPoker")
local BaccaratDataMgr           = appdf.req(module_pre .. ".game.baccarat.manager.BaccaratDataMgr")
local BaccaratEvent             = appdf.req(module_pre .. ".game.baccarat.scene.BaccaratEvent")
local Effect                    = appdf.req(module_pre .. ".models.Effect")
local PlayerInfo = appdf.req(appdf.EXTERNAL_SRC .. "PlayerInfo")
local FloatMessage              = cc.exports.FloatMessage
local SLFacade                  = cc.exports.SLFacade

local ChipCount          = 5--6 --筹码数量
local AreaCount          = 8 --投注区域数量
local ChipOffsetY        = 14 --选中筹码位移
local FlyChipScale       = 0.35 --下注筹码缩放比例

local CHIP_FLY_STEPDELAY = 0.02 --筹码连续飞行间隔
local CHIP_FLY_TIME      = 0.25 --飞筹码动画时间
local CHIP_JOBSPACETIME  = 0.2 --飞筹码任务队列间隔
local CHIP_FLY_SPLIT     = 20 -- 飞行筹码分组 分XX次飞完
local CHIP_ITEM_COUNT    = AreaCount --下注项数
local CHIP_REWARD        = {2, 9, 2, 3, 3, 33, 12, 12}
local IPHONEX_OFFSETX    = 60

local ZORDER_OF_RULE = 100
local ZORDER_OF_TREND = 100
local ZORDER_OF_MESSAGEBOX = 101
local ZORDER_OF_FLOATMESSAGE = 102

local FNT_RESULT_WIN  = "game/baccarat/font/sz_pdk3.fnt"
local FNT_RESULT_LOSE = "game/baccarat/font/sz_pdk4.fnt"

local GameViewLayer = class("GameViewLayer",function(scene)
    local gameViewLayer = display.newLayer()
    return gameViewLayer
end)

--otherplayer = {}

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


function GameViewLayer:init()
    --初始化主ui
    self:initUI()

    --注册按钮事件
    self:initBtnClickEvent()

    --初始化变量
    self:initConstVar()

    --初始化数据
    self:initVar()

    --动画进入
    self:flyIn()
end

--初始化变量，此方法内变量在断线重连后，需要重置
function GameViewLayer:initVar()
    self.m_vJettonOfMine    = {} --自己筹码 {pSpr = sp(筹码对象), nIdx = idx(随机坐标索引)}
    self.m_vJettonOfOther   = {} --其他筹码 {pSpr = sp(筹码对象), nIdx = idx(随机坐标索引)}
    self.m_isPlayBetSound   = false --是否正在播放筹码音效
    self.m_isPlayDaojishi   = false --是否在播放最后3秒倒计时动画
    self.m_randmChipSelf    = {} --自己的随机筹码投注区
    self.m_randmChipOthers  = {} --其他玩家的随机筹码投注区
    self.m_flyJobVec        = {} --飞行筹码任务清空
    self.m_sendCard         = {} --前2张发牌
    self.m_nSoundClock      = nil
    self.m_daluMaxCol       = 0
    self.m_zhuluMaxCol      = 0
    self.m_oldScore         = 0
    --self.m_xianPointAni     = nil --闲家点数动画
    --self.m_zhuangPointAni   = nil --庄家点数动画
    self:resetChipPosArea() --重置筹码随机投注坐标
    ---------------------------------------------------------------------------
    self.m_members = {}
    self.numList = {}
    self.Tab_XuYa = {}
    self.m_mybet = {}
    self.daojishi_Num = 0
    self.money = 0
    self.Moneydealer = 0
    self.lostPos = 0
    self.ButtonJetton = 1
    self.mywin = 0
    self.dealer_win = 0
    self.moneys = {}
    self.win_zodic = {}
    self.m_llMyBetValue = {0,0,0,0,0,0,0,0}
    self.isShangZhuang = false
    self.m_vecResultCard = {}
    self.allchipList = {{},{},{},{},{},{},{},{},}
    self.Win_Num = {}
    self.ColorList = {}
    self.tagxuya = true
    for i = 1 ,#BaccaratRes.vecReleaseAnim  do
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(BaccaratRes.vecReleaseAnim[i])
    end
    local armature = ccs.Armature:create("huanle30s_beijing")  
    armature:setPosition(667,375)          
    self.m_rootNode:getChildByName("Node_bg"):getChildByName("Image_bg"):addChild(armature)
    armature:getAnimation():playWithIndex(0)
end

--初始化变量，此方法内变量在断线重连后，不需要重置
function GameViewLayer:initConstVar()
    self.isOpenMenu       = false
    self.m_nIndexChoose   = 0 --选中筹码的索引
    self.m_betChipPos     = {} --筹码原始坐标    
    self.m_flyChipPos     = {} --玩家下注飞行筹码起始坐标    
    for i = 1, ChipCount do
        self.m_betChipPos[i] = cc.p(self.m_pBtnBetChip[i]:getPosition())
        self.m_flyChipPos[i] = cc.p(self.m_nodeFlyChip:getChildByName("Node_pos" .. i):getPosition())
    end

    --region 处理筹码飞行层的定位用节点，处理完后，清空筹码飞行层
    self.m_selfChipPos   = cc.p(self.m_nodeFlyChip:getChildByName("Node_self"):getPosition())
    self.m_otherChipPos  = cc.p(self.m_nodeFlyChip:getChildByName("Node_other"):getPosition())
    self.m_bankerChipPos = cc.p(self.m_nodeFlyChip:getChildByName("Node_banker"):getPosition())
    self.m_vChipArea     = {} --投注区域rect数组
    for i = 1, AreaCount do
        local _node = self.m_nodeFlyChip:getChildByName("Panel_flyarea" .. i)
        local posx, posy = _node:getPosition()
        local sz = _node:getContentSize()
        self.m_vChipArea[i] = cc.rect(posx, posy, sz.width, sz.height )
    end

    self.m_nodeFlyChip:removeAllChildren()
    --endregion

    --region 发牌动画定位用节点，处理完后，清空节点对象
    --[[ 区域显示结构

            获胜/同点平
            ___________
            |  扑克牌 |
            |         |
            |         |
            |天王/对子|
            |         |
            -----------
               点数
    ]]--

    --发牌起始坐标点
    self.m_sendCardBeginPos = cc.p(self.m_nodeCardAni:getChildByName("Node_fapaiqi"):getPosition())

    --闲家牌结束坐标点
    self.m_xianCardEndPos   = cc.p(self.m_nodeCardAni:getChildByName("Node_xiancard"):getPosition())
    --闲家获胜或平的动画坐标
    self.m_xianWinAniPos    = cc.p(self.m_xianCardEndPos.x, self.m_xianCardEndPos.y + 50)
    --闲家牌型坐标
    self.m_xianTypePos      = cc.p(self.m_xianCardEndPos.x + 50, self.m_xianCardEndPos.y)
    --闲家点数坐标
    self.m_xianPointPos     = cc.p(self.m_xianCardEndPos.x, self.m_xianCardEndPos.y - 50)

    --庄家牌结束坐标点
    self.m_zhuangCardEndPos = cc.p(self.m_nodeCardAni:getChildByName("Node_zhuangcard"):getPosition())
    --庄家获胜或平的动画坐标
    self.m_zhuangWinAniPos  = cc.p(self.m_zhuangCardEndPos.x, self.m_zhuangCardEndPos.y + 50)
    --庄家牌型坐标
    self.m_zhuangTypePos    = cc.p(self.m_zhuangCardEndPos.x + 50, self.m_zhuangCardEndPos.y)
    --庄家点数坐标
    self.m_zhuangPointPos   = cc.p(self.m_zhuangCardEndPos.x, self.m_zhuangCardEndPos.y - 50)

    self.m_nodeCardAni:removeAllChildren()
    --endregion

    --扑克配置项
    local offset = 40
    self.m_sendCardConfig = {
        beginRotate = 212, --发牌初始角度
        beginScaleVal = 0.19, --发牌初始缩放
        endScaleVal = 0.7, --发牌结束缩放
        beginPos = self.m_sendCardBeginPos, --发牌起始点
        sendTs = 0.32, --单张发牌时间
        cardNum = 2, --发牌张数
        openCardTs = 0.15, --开牌动画一半所需时间
        cardOffsetX = offset, --发牌的横向间隔距离
        cardOffsetY = -13, --补牌的纵向位移
        pointSoundDelay = 0.6, --牌点数音效延迟
        boneName = {
            VALUE = "A",
            COLOR = "heitao",
        },
        pointAniPos = {
            [BaccaratDataMgr.ePlace_Xian]   = {
                [2] = cc.p(self.m_xianCardEndPos.x + 20, self.m_xianCardEndPos.y - 75), --两张牌坐标
                [3] = cc.p(self.m_xianCardEndPos.x + 40, self.m_xianCardEndPos.y - 75), --三张牌坐标
            },
            
            [BaccaratDataMgr.ePlace_Zhuang] = {
                [2] = cc.p(self.m_zhuangCardEndPos.x + 20, self.m_zhuangCardEndPos.y - 75),
                [3] = cc.p(self.m_zhuangCardEndPos.x + 40, self.m_zhuangCardEndPos.y - 75),
            },
        },
        --前4张牌的配置 13闲家 24庄家
        [1] = {
            cardType  = BaccaratDataMgr.ePlace_Xian,
            cardIndex = 1,
            endPos    = cc.p(self.m_xianCardEndPos.x + offset/2, self.m_xianCardEndPos.y)
            },
        [2] = {
            cardType  = BaccaratDataMgr.ePlace_Zhuang,
            cardIndex = 1,
            endPos    = cc.p(self.m_zhuangCardEndPos.x + offset/2, self.m_zhuangCardEndPos.y)
            },
        [3] = {
            cardType  = BaccaratDataMgr.ePlace_Xian,
            cardIndex = 2,
            endPos    = cc.p(self.m_xianCardEndPos.x + 3*offset/2, self.m_xianCardEndPos.y)
            },
        [4] = {
            cardType  = BaccaratDataMgr.ePlace_Zhuang,
            cardIndex = 2,
            endPos    = cc.p(self.m_zhuangCardEndPos.x + 3*offset/2, self.m_zhuangCardEndPos.y)
            },
    }

    --等待下一局动画坐标点
    self.m_zcAniPos = cc.p(self.m_nodeZCAni:getChildByName("Node_anipos"):getPosition())
    self.m_nodeZCAni:removeAllChildren()
end


--初始化UI组件 此方法内变量在断线重连后，不需要重置
function GameViewLayer:initUI()
    self.m_rootNode    = self.m_pathUI:getChildByName("Panel_root")

    self.m_nodeBottom  = self.m_rootNode:getChildByName("Node_bottom")
    self.m_nodeLeft    = self.m_rootNode:getChildByName("Node_left")
    self.m_nodeRight   = self.m_rootNode:getChildByName("Node_right")
    self.m_nodeClip    = self.m_rootNode:getChildByName("Panel_node_clip")
    self.m_nodeBet     = self.m_rootNode:getChildByName("Node_betarea")
    self.m_nodeFlyChip = self.m_rootNode:getChildByName("Node_flychip")
    self.m_nodeTop     = self.m_rootNode:getChildByName("Node_top")
    self.m_nodeDlg     = self.m_rootNode:getChildByName("Panel_dialog")

    --动画展示节点，包含：转场动画,发牌动画,开牌动画,等待开始动画
    self.m_nodeAni     = self.m_rootNode:getChildByName("Node_ani")
    
    --转场动画节点
    self.m_nodeZCAni   = self.m_nodeAni:getChildByName("Node_zhuanchang")

    --牌动画节点 包含：发牌动画,开牌动画,牌型动画，获胜动画
    self.m_nodeCardAni = self.m_nodeAni:getChildByName("Node_cardani")

    --桌子背景
    self.m_pImgDesk    = self.m_rootNode:getChildByName("Image_desk")

    --倒计时
    self.m_pImgTimer   = self.m_pImgDesk:getChildByName("Image_timerbg")
    self.m_pImgState   = self.m_pImgTimer:getChildByName("Image_state")
    self.m_pLbTimerNum = self.m_pImgTimer:getChildByName("Text_timernum")

    --动画闪烁区域
    self.m_nodeBlink   = self.m_pImgDesk:getChildByName("Node_blink")
    self.m_pBlink = {}
    for i = 1, AreaCount do
        self.m_pBlink[i] = self.m_nodeBlink:getChildByName("Sprite_blink" .. i)
    end

    --玩家信息
    self.m_selfPanel    = self.m_nodeLeft:getChildByName("Panel_self")
    local _Image_selfbg = self.m_selfPanel:getChildByName("Image_selfbg")
    self.m_pLbSelfName  = _Image_selfbg:getChildByName("Text_selfname")
    self.m_pLbSelfGold  = _Image_selfbg:getChildByName("Node_scale"):getChildByName("Text_selfgold")
    self.m_pBtnBank     = _Image_selfbg:getChildByName("Btn_bank")
    self.m_pBtnBank:setVisible(false)
    --庄家信息
    local _Image_bankbg  = self.m_nodeTop:getChildByName("Image_5")
    self.m_pLbBankerName = _Image_bankbg:getChildByName("Text_bankname")
    self.m_pLbBankerGold = _Image_bankbg:getChildByName("Text_bankgold")
    self.m_pLbApplyNum   = _Image_bankbg:getChildByName("Text_apply")
    self.m_pBtnApply     = _Image_bankbg:getChildByName("Btn_applybanker")
    self.m_pBtnDown      = _Image_bankbg:getChildByName("Btn_downbanker")

    --主界面路数展示信息
    self.m_nodeSmallroad   = self.m_nodeTop:getChildByName("Node_smallroad")
    local _Sprite_bg       = self.m_nodeSmallroad:getChildByName("Sprite_bg")
    self.m_pNodeTableWin   = _Sprite_bg:getChildByName("Node_win")
    self.m_pNodeTableRoad  = _Sprite_bg:getChildByName("Node_road")
    self.m_pLbPingNum      = _Sprite_bg:getChildByName("Text_pingnum")
    self.m_pLbZhuangNum    = _Sprite_bg:getChildByName("Text_zhuangnum")
    self.m_pLbXianNum      = _Sprite_bg:getChildByName("Text_xiannum")
    self.m_pLbZhuangDuiNum = _Sprite_bg:getChildByName("Text_zhuangduinum")
    self.m_pLbXianDuiNum   = _Sprite_bg:getChildByName("Text_xianduinum")

    --其他玩家按钮
    local _Panel_other   = self.m_nodeLeft:getChildByName("Panel_other")
    self.m_pBtnOthers    = _Panel_other:getChildByName("Btn_qtwj")
    self.m_pLbOtherNum   = _Panel_other:getChildByName("TXT_other_num")

    --六个筹码
    self.m_pBtnBetChip = {}
    local _chipbg = self.m_nodeBottom:getChildByName("Image_chipbg")
    for i = 1, ChipCount do
        self.m_pBtnBetChip[i] = _chipbg:getChildByName("Btn_chip" .. i)
    end
    self.m_pBtnBetChip[6] = _chipbg:getChildByName("Btn_chip" .. 6):setVisible(false)
    --续投按钮
    self.m_pBtnContinue  = _chipbg:getChildByName("Btn_continue")

    --全屏关闭按钮
    self.m_pBtnFullClose = self.m_nodeClip:getChildByName("Btn_close")

    --退出按钮
    self.m_pBtnReturn    = self.m_nodeLeft:getChildByName("Btn_exit")

    --路数按钮
    self.m_pBtnRoad      = self.m_nodeRight:getChildByName("Btn_road")

    --菜单按钮
    self.m_pBtnMenuPop   = self.m_nodeRight:getChildByName("Btn_pop")

    --弹出菜单
    self.m_nodeMenu     = self.m_rootNode:getChildByName("Node_menu")
    self.m_menuBG       = self.m_nodeMenu:getChildByName("Image_menubg")
    self.m_pBtnSound    = self.m_menuBG:getChildByName("Btn_sound")
    self.m_pBtnMusic    = self.m_menuBG:getChildByName("Btn_music")
    self.m_pBtnMenuBank = self.m_menuBG:getChildByName("Btn_menubank")
    self.m_pBtnRule     = self.m_menuBG:getChildByName("Btn_rule")
    self.m_pBtnMenuBank:setColor(cc.c3b(127,127,127))
    self.m_pBtnMenuBank:setEnabled(false)
    self.m_nodeBetnum   = self.m_pImgDesk:getChildByName("Node_betnum")

    --总下注
    self.m_pLbTotalBet  = self.m_nodeBetnum:getChildByName("Text_bettotal")
    
    --区域下注
    self.m_pLbAreaTotal = {}

    --我的下注
    self.m_pLbSelfTotal = {}

    for i = 1, AreaCount do
        self.m_pLbAreaTotal[i] = self.m_nodeBetnum:getChildByName("Text_betnum_total" .. i)
        self.m_pLbSelfTotal[i] = self.m_nodeBetnum:getChildByName("Text_betnum_self" .. i)
    end

    self.m_vChipArea = {} --记录投注区域rect 用于重置随机投注点用

    --庄家提示动画节点
    self.m_pSpbankerTip = self.m_nodeAni:getChildByName("Sprite_bankertip")

    --分辨率自适应
    self:setNodeFixPostion()

    --初始化弹出菜单
    self:initClipNode()
    self:initMenuView()

    --初始化主界面大路
    self:initMainViewDalu()

    --初始化主界面珠路
    self:initMainViewZhulu()

    --刷新珠路显示
    self:updateMainRoadView()
end

--初始化ui组件的显示内容 断线重连后应重置
function GameViewLayer:resetNodeView()
    --玩家信息显示
    self:updateUsrName()
    self:updateUsrGold()

    --庄家信息显示
    self:updateBankerInfo()

    --其他玩家数量
    self:updateOtherNum()

    --倒计时
    self:onTimeCountDown()

    --下注金额显示
    self:updateBetValueOfAll()

end

--初始化弹出菜单剪切区域
function GameViewLayer:initClipNode()
    local _posx, _ =  self.m_pBtnMenuPop:getPosition()
    local shap = cc.DrawNode:create()
    local width = self.m_menuBG:getContentSize().width
    local pointArr = {cc.p(0,300), cc.p(400, 300), cc.p(400, 650), cc.p(0, 650)}
    shap:drawPolygon(pointArr, 4, cc.c4f(255, 255, 255, 255), 2, cc.c4f(255, 255, 255, 255))
    self.m_pClippingMenu = cc.ClippingNode:create(shap)
    
    local diffX = 0
    if _posx + width/2 > display.size.width then
        diffX = display.size.width - width
    else
        diffX = _posx - width/2 + 10
    end

    self.m_pClippingMenu:setPosition(cc.p(diffX,0))
    self.m_nodeClip:addChild(self.m_pClippingMenu)
    self.m_menuBG:removeFromParent()
    self.m_pClippingMenu:addChild(self.m_menuBG)
end

--初始化音效音乐
function GameViewLayer:initMenuView()
    --音乐 
    local music = GlobalUserItem.bVoiceAble   
    if music then
        GlobalUserItem.setVoiceAble(true)
        ExternalFun.playGameBackgroundAudio(BaccaratRes.SOUND_OF_BG)
        self.m_pBtnMusic:loadTextureNormal(BaccaratRes.IMG_MUSIC_ON, ccui.TextureResType.plistType)
    else
        GlobalUserItem.setVoiceAble(false)
        self.m_pBtnMusic:loadTextureNormal(BaccaratRes.IMG_MUSIC_OFF, ccui.TextureResType.plistType)
    end

    --音效
    local sound = GlobalUserItem.bSoundAble
    if sound then
        GlobalUserItem.setSoundAble(true)
        self.m_pBtnSound:loadTextureNormal(BaccaratRes.IMG_SOUND_ON, ccui.TextureResType.plistType)
    else
        GlobalUserItem.setSoundAble(false)
        self.m_pBtnSound:loadTextureNormal(BaccaratRes.IMG_SOUND_OFF, ccui.TextureResType.plistType)
    end

end

--分辨率适配
function GameViewLayer:setNodeFixPostion()
    local diffX = 145-(1624-display.size.width)/2

    -- 根容器节点
    self.m_rootNode:setPositionX(diffX)

    if LuaUtils.isIphoneXDesignResolution() then
        --左侧节点
        self.m_nodeLeft:setPositionX(self.m_nodeLeft:getPositionX() - IPHONEX_OFFSETX)
        local _node1 = self.m_nodeFlyChip:getChildByName("Node_self")
        _node1:setPositionX(_node1:getPositionX() - IPHONEX_OFFSETX)
        local _node2 = self.m_nodeFlyChip:getChildByName("Node_other")
        _node2:setPositionX(_node2:getPositionX() - IPHONEX_OFFSETX)

        --右侧节点
        self.m_nodeRight:setPositionX(self.m_nodeRight:getPositionX() + IPHONEX_OFFSETX)

        --顶部显示
        self.m_nodeSmallroad:setPositionX(self.m_nodeSmallroad:getPositionX() - IPHONEX_OFFSETX/2)

    end
end

--endregion

--region 按钮事件及绑定处理

--按钮事件
function GameViewLayer:initBtnClickEvent()
    --绑定筹码点击
    for i = 1, ChipCount do
        self.m_pBtnBetChip[i]:addClickEventListener(handler(self,function()
            --主动点击筹码才播放音效
            ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_JETTON)
            self:onBetNumClicked(i)
        end))
    end

    self.m_pBtnReturn:addClickEventListener(handler(self,self.onReturnClicked))                 -- 退出
    self.m_pBtnSound:addClickEventListener(handler(self,self.onSoundClicked))                   -- 音效
    self.m_pBtnMusic:addClickEventListener(handler(self,self.onMusicClicked))                   -- 音乐
    self.m_pBtnMenuBank:addClickEventListener(handler(self,self.onBankClicked))                 -- 银行
    self.m_pBtnBank:addClickEventListener(handler(self,self.onBankClicked))                     -- 银行
    self.m_pBtnRule:addClickEventListener(handler(self,self.onRuleClicked))                     -- 规则
    self.m_pBtnMenuPop:addClickEventListener(handler(self,self.onPopClicked))                   -- 弹出
    self.m_pBtnFullClose:addClickEventListener(handler(self,self.onPushClicked))                -- 收回
    self.m_pBtnRoad:addClickEventListener(handler(self,self.onTrendClicked))                    -- 路子
    self.m_pBtnOthers:addClickEventListener(handler(self,self.onOtherInfoClicked))              -- 玩家
    self.m_pBtnApply:addClickEventListener(handler(self,self.onRequestToZhuangClicked))         -- 上庄
    self.m_pBtnDown:addClickEventListener(handler(self,self.onCancelToZhuangClicked))           -- 下庄
    self.m_pBtnContinue:addClickEventListener(handler(self,self.onBetContinueClicked))          -- 续投

    --绑定点击投注区域
    for i = 1, 8 do
        local _node = self.m_nodeBet:getChildByName("Node_bet" .. i)
        local j = 1
        while true do
            local _betBtn = _node:getChildByTag(j)
            if not _betBtn then break end
            _betBtn:addClickEventListener(handler(self,function()
                self:onBetClicked(i)
            end))
            j = j + 1
        end
    end
end

function GameViewLayer:onPopClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
    local str = self.isOpenMenu and BaccaratRes.IMG_POP or BaccaratRes.IMG_PUSH
    self.m_pBtnMenuPop:loadTextureNormal(str, ccui.TextureResType.plistType)
    self.m_pBtnMenuPop:loadTexturePressed(str, ccui.TextureResType.plistType)

    if self.isOpenMenu then
        self.m_menuBG:stopAllActions()
        local seq = cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(2, 740)), cc.CallFunc:create(function()
            self.m_menuBG:setVisible(false)
            self.m_pBtnFullClose:setVisible(false)
        end))
        self.m_menuBG:runAction(seq)
    else
        self.m_menuBG:setVisible(true)
        self.m_menuBG:stopAllActions()
        self.m_menuBG:setPosition(cc.p(2, 740))
        local seq = cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(2, 650)), cc.CallFunc:create(function()
            self.m_menuBG:setVisible(true)
            self.m_pBtnFullClose:setVisible(true)
        end))
        self.m_menuBG:runAction(seq)
    end
    self.isOpenMenu = not self.isOpenMenu
end

function GameViewLayer:onPushClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
    if not self.isOpenMenu then return end

    local str = BaccaratRes.IMG_POP
    self.m_pBtnMenuPop:loadTextureNormal(str, ccui.TextureResType.plistType)
    self.m_pBtnMenuPop:loadTexturePressed(str, ccui.TextureResType.plistType)
    self.isOpenMenu = false
    self.m_menuBG:stopAllActions()
    local seq = cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(2, 730)), cc.CallFunc:create(function()
        self.m_menuBG:setVisible(false)
        self.m_pBtnFullClose:setVisible(false)
    end))
    self.m_menuBG:runAction(seq)
end

--其他玩家信息
function GameViewLayer:onOtherInfoClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
    --玩家列表
    local infoLayer = BaccaratOtherInfoLayer:create()
    self.m_nodeDlg:addChild(infoLayer,4)
end

--退出
function GameViewLayer:onReturnClicked()
    self._scene:onQueryExitGame()
end

--点击音乐
function GameViewLayer:onMusicClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
    local music = GlobalUserItem.bVoiceAble;
    local resName = music and BaccaratRes.IMG_MUSIC_OFF or BaccaratRes.IMG_MUSIC_ON
    GlobalUserItem.setVoiceAble(not music)
    self.m_pBtnMusic:loadTextureNormal(resName,ccui.TextureResType.plistType)
    if not music then
        ExternalFun.playGameBackgroundAudio(BaccaratRes.SOUND_OF_BG)
    end
    
end

--点击音效
function GameViewLayer:onSoundClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
    --音效
    local sound = GlobalUserItem.bSoundAble
    local resName = sound and BaccaratRes.IMG_SOUND_OFF or BaccaratRes.IMG_SOUND_ON
    GlobalUserItem.setSoundAble(not sound)
    self.m_pBtnSound:loadTextureNormal(resName,ccui.TextureResType.plistType)
end

--筹码点击
function GameViewLayer:onBetNumClicked(nIndex)
    if not nIndex then return end
    if self.m_nIndexChoose == nIndex then
        return
    end
    if nIndex ~= 1 then
        self.m_pBtnBetChip[1]:setPositionY(self.m_betChipPos[1].y)
    end
    --让先前选中的变成原始位置
    if self.m_nIndexChoose > 0 then
        --local posNowY = self.m_pBtnBetChip[self.m_nIndexChoose]:getPositionY()
        self.m_pBtnBetChip[self.m_nIndexChoose]:setPositionY(self.m_betChipPos[self.m_nIndexChoose].y)
    end
    self.m_pBtnBetChip[nIndex]:setPositionY(self.m_betChipPos[nIndex].y + ChipOffsetY)
    self.ButtonJetton = self.chips[nIndex]--1,5,20,50,100
    self.m_nIndexChoose = nIndex
end

--下注区域点击
function GameViewLayer:onBetClicked(nIndex) --点击下注
    local bet_tag = self:getRealNum(nIndex)
    self._scene:SendBet({bet_tag,self.ButtonJetton})
    if self.tagxuya == true then
    table.insert(self.Tab_XuYa,{bet_tag,self.ButtonJetton})
    else
    self.Tab_XuYa = {}
    table.insert(self.Tab_XuYa,{bet_tag,self.ButtonJetton})
    self.tagxuya = true
    end
    
    table.insert(self.m_mybet,bet_tag)
end

function GameViewLayer:getRealNum(nIndex)
    local realnum = 0
    if     nIndex == 1 then realnum = 0 
    elseif nIndex == 2 then realnum = 6
    elseif nIndex == 3 then realnum = 3
    elseif nIndex == 4 then realnum = 2
    elseif nIndex == 5 then realnum = 5
    elseif nIndex == 6 then realnum = 7
    elseif nIndex == 7 then realnum = 1
    elseif nIndex == 8 then realnum = 4
    end
    return realnum
end

--点击上庄
function GameViewLayer:onRequestToZhuangClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
    if BaccaratDataMgr.getInstance():getGameState() == 1 then
        self:showFloatmessage("下注阶段，无法上庄")
    end
    self._scene:SendUpdearler()
end

--点击取消上庄
function GameViewLayer:onCancelToZhuangClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
    self._scene:SendDowndealer()
end

--点击续投
function GameViewLayer:onBetContinueClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
        --庄家
    if BaccaratDataMgr.getInstance():isBanker() then
        self:showFloatmessage("BACCARAT_9")
        return
    end

    --非下注状态
    if BaccaratDataMgr.eType_Bet ~= BaccaratDataMgr.getInstance():getGameState() then
        self:showFloatmessage("BACCARAT_11")
        return
    end

    local index = 1   
    if self.Tab_XuYa[index] == nil then
        self:showFloatmessage("您还没有下注，无法续投")
        return
    end
    self._XuyaFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        if self.Tab_XuYa[index] ~= nil then
            self._scene:SendBet(self.Tab_XuYa[index])
        else
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._XuyaFun)  
        end 
        index = index+1
    end, 0.2, false)
end

--点击银行
function GameViewLayer:onBankClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
    SLFacade:dispatchCustomEvent(Hall_Events.SHOW_OPEN_BANK,"openbank")
end

--点击路子
function GameViewLayer:onTrendClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
    self:showTrendLayer()
end

--点击规则
function GameViewLayer:onRuleClicked()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_BUTTON)
    RuleLayer.create():addTo(self.m_rootUI, ZORDER_OF_TREND)
--    local set = RuleLayer:create( self )
--    self:addToRootLayer(set, ZORDER_OF_TREND)
end

--endregion

function GameViewLayer:setPathValue(m_vecResultCard)
    self.ValueList = {}
    for i = 1 ,2 do
        for  j = 1, 3 do
            if m_vecResultCard[i][j] ~= nil then
                if m_vecResultCard[i][j] < 13 and m_vecResultCard[i][j] >=0 then
                    table.insert(self.ValueList,{m_vecResultCard[i][j],iColor = 0,iValue = m_vecResultCard[i][j] + 1})
                elseif m_vecResultCard[i][j] >= 13 and m_vecResultCard[i][j] < 26 then
                    table.insert(self.ValueList,{m_vecResultCard[i][j],iColor = 1,iValue = m_vecResultCard[i][j] - 12})
                elseif m_vecResultCard[i][j] >= 26 and m_vecResultCard[i][j] < 39 then
                    table.insert(self.ValueList,{m_vecResultCard[i][j],iColor = 2,iValue = m_vecResultCard[i][j] - 25})
                elseif m_vecResultCard[i][j] >= 39 and m_vecResultCard[i][j] < 52 then
                    table.insert(self.ValueList,{m_vecResultCard[i][j],iColor = 3,iValue = m_vecResultCard[i][j] - 38})
                end
            else
                table.insert(self.ValueList,0)
            end
            
        end
        
    end
end

----------------------------------------------------游戏状态--------------------------------------------------
function GameViewLayer:LeiXing(numList)
    local records = {}
    for i = 1, #numList do
        local record = 
        {
            cbKingWinner    = self:isTianWan(numList[i])   ,    -- 天王赢家 -- 0,3,4
            bPlayerTwoPair  = self:isXianDuiZi(numList[i])   ,-- 对子标识
            bBankerTwoPair  = self:isZhuangDuiZi(numList[i])   ,-- 对子标识
            cbPlayerCount   = self:setNum(numList[i])[1]   ,--闲家点数
            cbBankerCount   = self:setNum(numList[i])[2]   ,--庄家点数
        }
        table.insert(records, record)
    end

    --保存
    for k, v in pairs(records) do
        BaccaratDataMgr.getInstance():addGameRecord(records[k])
    end
    BaccaratDataMgr.getInstance():synCacheRecord()
    self:notifyTrendRefresh()
end
function GameViewLayer:isZhuangDuiZi(duizi)
    local count = #duizi[2]
    if count < 2 then
        return false
    end
    self:setPathValue(duizi)
    local cards = {}
    for i = 1, count do
        cards[i] = self.ValueList[i+3]
    end
    if not cards[1] or not cards[2] then
        return false
    end
    local ret = cards[1].iValue == cards[2].iValue
    return ret
end
function GameViewLayer:isXianDuiZi(duizi)
    local count = #duizi[1]
    if count < 2 then
        return false
    end
    self:setPathValue(duizi)
    local cards = {}
    for i = 1, count do
        cards[i] = self.ValueList[i]
    end
    if not cards[1] or not cards[2] then
        return false
    end
    local ret = cards[1].iValue == cards[2].iValue
    return ret
end

function GameViewLayer:isTianWan(king)
    local nKingWinner = 0
    local nPoints = self:setNum(king)
    if nPoints[1] > 7 and nPoints[1] > nPoints[2] then
        nKingWinner = 3
    end
    if nPoints[2] > 7 and nPoints[2] > nPoints[1] then
        nKingWinner = 4
    end
    return nKingWinner
end

function GameViewLayer:event_GameState(msg)
    --将所有玩家信息存入
    PlayerInfo.getInstance():setChairID(GlobalUserItem.tabAccountInfo.userid)
    PlayerInfo.getInstance():setUserScore(GlobalUserItem.tabAccountInfo.into_money)

    self.chips = {}
    self.chips = msg.chips
    for i = 1 , #self.chips do
        BaccaratDataMgr.getInstance():setJettonScoreByIndex(i,self.chips[i])
    end

    self.numList = msg.handpath
    self:LeiXing(self.numList)
    BaccaratDataMgr.getInstance():setBankerId(msg.dealer)
    for k, v in ipairs(msg.members) do
        if v[1] == msg.dealer then
            BaccaratDataMgr.getInstance():setBankerName(v[2])
            BaccaratDataMgr.getInstance():setBankerScore(v[6])
        end
        BaccaratDataMgr.getInstance():setMembers(v)
        table.insert(self.m_members,v)
    end
    for k, v in ipairs(msg.dealers) do
        BaccaratDataMgr.getInstance():addBankerList(v[1])
    end
    --更新庄家
    self:updateBankerInfo()
    self.m_pLbOtherNum:setString("("..#msg.members..")")
    self.m_pBtnBetChip[1]:setPositionY(self.m_betChipPos[1].y + ChipOffsetY)

    self.m_pLbTotalBet:setString(msg.pot)

    --重置随机下注点
    self:resetChipPosArea()
    
    local state = msg.step
    BaccaratDataMgr.getInstance():setGameState(state)
    if state == 3 then -- 空闲
        self:clearn()
    elseif state == 1 then -- 下注
        if msg.mymoney < 500  then
            self:BtnBetChip(6,false)
        end
        if msg.mymoney < 100  then
            self:BtnBetChip(5,false)
        end
        if msg.mymoney < 50  then
            self:BtnBetChip(4,false)
        end
        if msg.mymoney < 20  then
            self:BtnBetChip(3,false)
        end
        if msg.mymoney < 5  then
            self:BtnBetChip(2,false)
        end
        if msg.mymoney < 1  then
            self:BtnBetChip(1,false)
        end
        
        self.m_pImgState:loadTexture(BaccaratRes.IMG_GAMECHIP,ccui.TextureResType.plistType)

        local betmoney = msg.betmoneys
        for i=1,#betmoney do
            self.m_pLbAreaTotal[i]:setString(betmoney[self:getRealNum(i)+1]):setVisible(true)
            self.m_pLbSelfTotal[i]:setVisible(false)
        end
        
    elseif state == 2 then -- 开奖
        --钱与筹码
        self:playWaitAni()
        for i = 1, 6 do --筹码
            self:BtnBetChip(i,false)
        end
        --状态图片
        self.m_pImgState:loadTexture(BaccaratRes.IMG_GAMEOPEN,ccui.TextureResType.plistType)
        --
        local timeout = self:getIntValue( msg.timeout )

        for i=1,8 do
            self.m_pLbAreaTotal[i]:setVisible(false)
            self.m_pLbSelfTotal[i]:setVisible(false)
        end
    end
    self.daojishi_Num = msg.timeout
    local tt = 0
    self.daojishi_Num,tt = math.modf(self.daojishi_Num/1);
    self.m_pLbTimerNum:setText(tostring(self.daojishi_Num))

--    --时间调度，更新桌面中间倒计时
    local this = self
    self._ClockFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                this:OnClockUpdata()
            end, 1, false)
end

function GameViewLayer:BtnBetChip(index ,istype)
    self.m_pBtnBetChip[index]:setBright(istype)
    self.m_pBtnBetChip[index]:setTouchEnabled(istype)
    if istype == true then
        self.m_pBtnBetChip[index]:setColor(cc.c3b(255,255,255))
    else
        self.m_pBtnBetChip[index]:setColor(cc.c3b(127,127,127))
    end
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
        self.m_pLbOtherNum:setString("("..#self.m_members..")")
--        table.insert(otherplayer,player_)
    end
    if player_[1] == GlobalUserItem.tabAccountInfo.userid then

        --设置玩家金币数
        local money_num = player_[6]
        self.m_pLbSelfGold:setString(tostring(money_num))

        local my_name = player_[2]
        self.m_pLbSelfName:setString(tostring(my_name))
    end
end


------------------------------------------------------------下注阶段---------------------------------------------------------------
function GameViewLayer:intoBetMoney(Data)        
   
    BaccaratDataMgr.getInstance():setGameState(1)
    self:playBeginChipAni()
    self.daojishi_Num = self:getIntValue(Data.timeout)

    self.m_pImgState:loadTexture(BaccaratRes.IMG_GAMECHIP,ccui.TextureResType.plistType)

    if self.isShangZhuang == false then

        for i = 1, 6 do --筹码
            self:BtnBetChip(i,true)
        end
        if PlayerInfo.getInstance():getUserScore() < 500  then
            self:BtnBetChip(6,false)
        end
        if PlayerInfo.getInstance():getUserScore() < 100  then
            self:BtnBetChip(5,false)
        end
        if PlayerInfo.getInstance():getUserScore() < 50  then
            self:BtnBetChip(4,false)
        end
        if PlayerInfo.getInstance():getUserScore() < 20  then
            self:BtnBetChip(3,false)
        end
        if PlayerInfo.getInstance():getUserScore() < 5  then
            self:BtnBetChip(2,false)
        end
        if PlayerInfo.getInstance():getUserScore() < 1  then
            self:BtnBetChip(1,false)
        end

    end
    
end


function GameViewLayer:getFileNum(num)
    local realnum = 0
    if     num == 0 then realnum = 1 
    elseif num == 1 then realnum = 7
    elseif num == 2 then realnum = 4
    elseif num == 3 then realnum = 3
    elseif num == 4 then realnum = 8
    elseif num == 5 then realnum = 5
    elseif num == 6 then realnum = 2
    elseif num == 7 then realnum = 6
    end
    return realnum
end

function GameViewLayer:otherBetMoney(Data)         --其他人下注

    local numMoney = Data[1]                       --下注区域
    local otherMoney = Data[2]                     --该区域总钱数
    local heMoney = Data[4]                        --下注钱数
    local IDMoney = Data[3]

    print("\nID:\t"..Data[3].."\n在\t"..self:getFileNum(numMoney).."\t区域下注\t"..heMoney.."\n该区域共\t"..otherMoney)
    if numMoney ~= nil or "" then
       self.m_pLbAreaTotal[self:getFileNum(numMoney)]:setText(otherMoney):setVisible(true)
    end
    self:updataAllMoney(heMoney)

    self:playBetChipAni(self:getFileNum(numMoney),heMoney,IDMoney)
end

function GameViewLayer:myBetMoney(Data)            --等待自己下注

    local numMoney = Data[2]    --下注区域
    local heMoney  = Data[1]
    self.m_llMyBetValue[self:getFileNum(numMoney)] = Data[1] + self.m_llMyBetValue[self:getFileNum(numMoney)]
    self.m_pLbSelfTotal[self:getFileNum(numMoney)]:setText(self.m_llMyBetValue[self:getFileNum(numMoney)]):setVisible(true)
    self.m_pLbAreaTotal[self:getFileNum(numMoney)]:setText(Data[3]):setVisible(true)
    self.m_pLbSelfGold:setString(tostring(PlayerInfo.getInstance():getUserScore() - Data[1])) 
    PlayerInfo.getInstance():setUserScore(PlayerInfo.getInstance():getUserScore() - Data[1])
    BaccaratDataMgr.getInstance():setMyBetValue(self:getFileNum(numMoney),heMoney)
    self:playBetChipAni(self:getFileNum(numMoney),heMoney,GlobalUserItem.tabAccountInfo.userid)
end

function GameViewLayer:updataAllMoney(num)
    self.money = tonumber(tonumber(num) + tonumber(self.money))
    self.m_pLbTotalBet:setString(tostring(self.money)):setVisible(true)
end


function GameViewLayer:onUserLeave(userId)      --该uid玩家离开房间
    for key, player in ipairs(self.m_members) do
        if player[1] == userId then
            print(player[2].."------------------->已离开房间")
            table.remove(self.m_members,key)
            self.m_pLbOtherNum:setString("("..#self.m_members..")")
        end
    end
end

---游戏结算--（需要加判断自身玩家是否参与本局游戏）------------------------------------------------
function GameViewLayer:changehands(hands)
    local ret = {};
    for i = 1, 2 do
        ret[i] = {}
        for j = 1, #hands[i] do
            if hands[i][j] <= 12 then ret[i][j] = hands[i][j] + 1            
            elseif hands[i][j] <= 25 and hands[i][j] >= 13 then ret[i][j] = hands[i][j] + 4
            elseif hands[i][j] <= 38 and hands[i][j] >= 26 then ret[i][j] = hands[i][j] + 7
            elseif hands[i][j] <= 51 and hands[i][j] >= 39 then ret[i][j] = hands[i][j] + 10
            end 
        end
    end
    return ret
end 
function GameViewLayer:onGameEnd(args)
    print("结算！！！")
    self.tagxuya = false
    self.daojishi_Num = self:getIntValue(args.timeout)
    --状态图片
    self.m_pImgState:loadTexture(BaccaratRes.IMG_GAMEOPEN,ccui.TextureResType.plistType)

    if self.isShangZhuang == false then
        for i = 1, 6 do --筹码
            self:BtnBetChip(i,false)
        end
    end
    local win_hands = self:changehands(args.win_hands)

    -- 数据
    local msg = {}
    ---- 下局信息
    msg.cbTimeLeave = args.timeout -- 剩余时间
    ---- 扑克信息
    msg.cbCardCount = {}                  -- 扑克数目
    for i = 1, 2 do
        msg.cbCardCount[i] = #win_hands[i]
    end
    msg.cbTableCardArray = {}             -- 桌面扑克
    for i = 1, 2 do
        msg.cbTableCardArray[i] = {}
        for j = 1, #win_hands[i] do
--            if args.win_hands[i][j] == nil then break end
            msg.cbTableCardArray[i][j] = win_hands[i][j]
        end
    end
     ---- 庄家信息
     msg.lBankerScore = args.dealer_win        -- 庄家成绩
     msg.lBankerTotallScore = args.dealer_win  -- 庄家成绩
--     msg.nBankerTime = _buffer:readInt()              -- 做庄次数
     msg.lPlayAllScore = 0                        --玩家成绩
     msg.lPlayAllScore = args.mywin

    -- 保存
    BaccaratDataMgr.getInstance():setGameState(BaccaratDataMgr.eType_Award)
    BaccaratDataMgr.getInstance():setBankerResult(msg.lBankerScore)
    BaccaratDataMgr.getInstance():cleanCard()   --牌面
    for i = 1, 2 do
        for n = 1, 3 do
            if n <= msg.cbCardCount[i] then
                local card = {}
                card.iValue = BaccaratDataMgr.getInstance():GetCardValue(msg.cbTableCardArray[i][n])
                card.iColor = BaccaratDataMgr.getInstance():GetCardColor(msg.cbTableCardArray[i][n])
                BaccaratDataMgr.getInstance():setCard(i, n, card)
            end
        end
    end

    if BaccaratDataMgr.getInstance():isBanker() then    --庄家
        BaccaratDataMgr.getInstance():setMyResult(msg.lBankerScore)
    else
        BaccaratDataMgr.getInstance():setMyResult(msg.lPlayAllScore)
    end

    self:playStopChipAni()
end

function GameViewLayer:setColorValue()
    for i = 1 ,2 do
        for  j = 1, 3 do
            if self.m_vecResultCard[i][j] ~= nil then
                if self.m_vecResultCard[i][j] < 13 and self.m_vecResultCard[i][j] >=0 then
                    table.insert(self.ColorList,{color = 0,iValue = self.m_vecResultCard[i][j] + 1})

                elseif self.m_vecResultCard[i][j] >= 13 and self.m_vecResultCard[i][j] < 26 then
                    table.insert(self.ColorList,{color = 1,iValue = self.m_vecResultCard[i][j] - 12})

                elseif self.m_vecResultCard[i][j] >= 26 and self.m_vecResultCard[i][j] < 39 then
                    table.insert(self.ColorList,{color = 2,iValue = self.m_vecResultCard[i][j] - 25})

                elseif self.m_vecResultCard[i][j] >= 39 and self.m_vecResultCard[i][j] < 52 then
                    table.insert(self.ColorList,{color = 3,iValue = self.m_vecResultCard[i][j] - 38})

                end
            else
                table.insert(self.ColorList,0)
            end
        end
    end
end

--更新自己金钱
function GameViewLayer:updataMyMoney(args)
    self.m_pLbSelfGold:setString(tostring(args))
    PlayerInfo.getInstance():setUserScore(args)
end

function GameViewLayer:updealer(dataBuffer)                   -- 加入上庄列表
    if dataBuffer[1] == GlobalUserItem.tabAccountInfo.userid then
        self:showFloatmessage("您已加入上庄列表！")
        self.m_pBtnApply:setVisible(false)
        self.m_pBtnDown:setVisible(true)
    end
    BaccaratDataMgr.getInstance():addBankerList(dataBuffer[1])
    self.m_pLbApplyNum:setString("申请人数："..BaccaratDataMgr.getInstance():getBankerListSize())
end

function GameViewLayer:updataDealers(dataBuffer)               -- 换庄
    for key,player in ipairs(BaccaratDataMgr.getInstance():getMembers()) do
        if player[1] == dataBuffer[1][1] then
            BaccaratDataMgr.getInstance():setBankerId(player[1])
            self.m_pLbBankerGold:setString(player[6])
            self.m_pLbBankerName:setString(player[2])
            self.Moneydealer = player[6]
        end
        if player[1] == GlobalUserItem.tabAccountInfo.userid then
            self.isShangZhuang = true
        end
        self.isShangZhuang = false
    end

    self.m_pLbZhuangNum:setString("申请人数："..BaccaratDataMgr.getInstance():getBankerListSize())
    local spchipbg = cc.Sprite:createWithSpriteFrameName("gui-baccarat-huanzhuang.png"):setPosition(self.m_pSpbankerTip:getPosition()):addTo(self.m_pSpbankerTip,100)
    spchipbg:runAction(cc.Sequence:create( cc.DelayTime:create(2),cc.CallFunc:create(function()
                spchipbg:removeFromParent()
            end) ))
end

function GameViewLayer:onPlayerShow()                     -- 系统坐庄
--    self.m_pLbBankerGold:setString("999999999")
--    self.m_pLbBankerName:setString("系统坐庄")
--    self.Moneydealer = 999999999
--    self.m_pLbZhuangNum:setString("申请人数：0")
end

function GameViewLayer:downDealers(dataBuffer)             -- 下庄

    BaccaratDataMgr.getInstance():delBankerList(dataBuffer[1])
    if dataBuffer[1] == GlobalUserItem.tabAccountInfo.userid then
        self:showFloatmessage("您已下庄！")
        self.isShangZhuang = false
        self.m_pBtnDown:setVisible(false)
        self.m_pBtnApply:setVisible(true)
    end
    self.m_pLbZhuangNum:setString("申请人数："..BaccaratDataMgr.getInstance():getBankerListSize())
end

function GameViewLayer:Nomoney(dataBuffer)                            -- 上庄失败
    self:showFloatmessage("金币不足"..dataBuffer.."无法上庄！")
end


--本局游戏结束-------------------------------------------------空闲--------------------------------------
function GameViewLayer:onDeskOver(args)
    print("空闲！！！")
    BaccaratDataMgr.getInstance():setGameState(3)
    self.daojishi_Num = self:getIntValue(args)
    self:clearn()
end


--金币不足
function GameViewLayer:Badbetmoney(dataBuffer)
    if dataBuffer == 0 then     self:showFloatmessage("到庄家上限！")
    elseif dataBuffer == 1 then self:showFloatmessage("到达玩家上限！")
    elseif dataBuffer == 2 then self:showFloatmessage("钱不够了！")
    elseif dataBuffer == 3 then self:showFloatmessage("到达盘面上限！")
    end
end

function GameViewLayer:setNum(Data)
    local num = Data
    self.numxian = {}
    for i=1,#num do
        self.xian = 0
        for j=1,#num[i] do
            local xian = num[i][j]
            if xian<9 then
                self.xian = self.xian + xian + 1
            elseif 12<xian and xian<22 then
                self.xian = self.xian + xian - 12
            elseif 25<xian and xian<35 then
                self.xian = self.xian + xian - 25
            elseif 38<xian and xian<48 then
                self.xian = self.xian + xian - 38
            else
                self.xian = self.xian + 0
            end
        end
        self.numxian[i] = self.xian%10
    end
    return self.numxian
end

------------------------------------------------------------------------------------------------------------------------------------
--endregion
--region 动画相关

--开场动画进入
function GameViewLayer:flyIn()
    local deskAniTime  = 0.3
    local otherAniTime = 0.4
    local offset = 15

    --桌子下方进入
    local posx, posy = self.m_pImgDesk:getPosition()
    self.m_pImgDesk:setPositionY(posy - 400)
    self.m_pImgDesk:setScale(1.3)
    local tableMove = cc.MoveTo:create(deskAniTime, cc.p(posx,posy))
    local tableScale = cc.ScaleTo:create(deskAniTime, 1)
    local tableSpawn = cc.Spawn:create(tableScale, tableMove)
    local callfun = cc.CallFunc:create(function()
                        self:viewBetChip()
                    end)
    self.m_pImgDesk:runAction(cc.Sequence:create(tableSpawn, callfun))

    --筹码区下方进入
    posx, posy = self.m_nodeBottom:getPosition()
    self.m_nodeBottom:setPositionY(posy - 400)
    self.m_nodeBottom:setOpacity(0)
    local bottomMove = cc.MoveTo:create(otherAniTime, cc.p(posx,posy + offset))
    local bottomMove2 = cc.MoveTo:create(0.2, cc.p(posx,posy))
    local spawn = cc.Spawn:create(cc.FadeIn:create(0.2), bottomMove)
    local seq = cc.Sequence:create(spawn, bottomMove2)
    self.m_nodeBottom:runAction(seq)

    --玩家信息区域
    posx, posy = self.m_selfPanel:getPosition()
    self.m_selfPanel:setPositionY(posy - 400)
    self.m_selfPanel:setOpacity(0)
    self.m_selfPanel:runAction(seq:clone())

    --上部节点
    posx, posy = self.m_nodeTop:getPosition()
    self.m_nodeTop:setPositionY(posy + 400)
    self.m_nodeTop:setOpacity(0)
    local topMove = cc.MoveTo:create(otherAniTime, cc.p(posx,posy - offset))
    local topMove2 = cc.MoveTo:create(0.2, cc.p(posx,posy))
    spawn = cc.Spawn:create(cc.FadeIn:create(0.2), topMove)
    seq = cc.Sequence:create(spawn, topMove2)
    self.m_nodeTop:runAction(seq)

    --右侧节点
    posx, posy = self.m_nodeRight:getPosition()
    self.m_nodeRight:setPositionY(posy + 400)
    self.m_nodeRight:setOpacity(0)
    self.m_nodeRight:runAction(seq:clone())

    --退出和其他玩家按钮
    posx, posy = self.m_pBtnReturn:getPosition()
    self.m_pBtnReturn:setPositionY(posy + 400)
    self.m_pBtnReturn:setOpacity(0)
    topMove = cc.MoveTo:create(otherAniTime, cc.p(posx,posy - offset))
    topMove2 = cc.MoveTo:create(0.2, cc.p(posx,posy))
    spawn = cc.Spawn:create(cc.FadeIn:create(0.2), topMove)
    seq = cc.Sequence:create(spawn, topMove2)
    self.m_pBtnReturn:runAction(seq)

    posx, posy = self.m_pBtnOthers:getPosition()
    self.m_pBtnOthers:setPositionY(posy + 400)
    self.m_pBtnOthers:setOpacity(0)
    topMove = cc.MoveTo:create(otherAniTime, cc.p(posx,posy - offset))
    topMove2 = cc.MoveTo:create(0.2, cc.p(posx,posy))
    spawn = cc.Spawn:create(cc.FadeIn:create(0.2), topMove)
    seq = cc.Sequence:create(spawn, topMove2)
    self.m_pBtnOthers:runAction(seq)
end

function GameViewLayer:viewBetChip()

end

--开始下注动画
function GameViewLayer:playBeginChipAni()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_WAGER_START)
--    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(kaishixiazhu_kaijiang) 
    local armature = ccs.Armature:create("kaishixiazhu_kaijiang")  
    armature:setPosition(667,375)                   
    self.m_nodeZCAni:addChild(armature)                      
    armature:getAnimation():playWithIndex(1)
    armature:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(function()
		                                            armature:removeFromParent()
	                                            end)))
end

--停止下注动画
function GameViewLayer:playStopChipAni()
    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_WAGER_STOP)
--    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(kaishixiazhu_kaijiang) 
    local armature = ccs.Armature:create("kaishixiazhu_kaijiang")  
    armature:setPosition(667,375)                   
    self.m_nodeZCAni:addChild(armature)                      
    armature:getAnimation():playWithIndex(0)
    armature:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(function()
		                                            armature:removeFromParent()
                                                    self:sendCard(1)
	                                            end)))
end

--下注筹码动画
function GameViewLayer:playBetChipAni(betArea, betScore, chairId)
    if betScore <= 0 then
        return
    end
    if BaccaratDataMgr.getInstance():getGameState() == BaccaratDataMgr.eType_Bet then
        local isSelf = PlayerInfo.getInstance():getChairID() == chairId
        local beginPos = isSelf and self:getSelfChipBeginPos(betScore) or self:getOtherChipBeginPosition()
        local idx, endPos = self:getChipEndPosition(betArea, isSelf)
        local sp = self:flyJetton(beginPos, endPos, betScore, isSelf)
        sp:setTag(betScore)
        if isSelf then
            table.insert(self.m_vJettonOfMine, { pChipSpr = sp, nIdx = idx, wChipIndex = betArea})
        else
            table.insert(self.m_vJettonOfOther, { pChipSpr = sp, nIdx = idx, wChipIndex = betArea })
        end
    end
end

--筹码飞行
function GameViewLayer:flyJetton(beginPos, endPos, betScore, isSelf)
    local sp = self:getSpriteOfJetton(betScore)
            :setName(betScore)
            :setScale(FlyChipScale)
            :setAnchorPoint(cc.p(0.5, 0.5))
            :setPosition(beginPos)
            :addTo(self.m_nodeFlyChip)

    local soundPath = betScore > 100 and BaccaratRes.SOUND_OF_BETHIGH or BaccaratRes.SOUND_OF_BETLOW

    local call = cc.CallFunc:create(function ()
        if isSelf then -- 自己的音效立刻播放
             ExternalFun.playGameEffect(soundPath)
        else
            if not self.m_isPlayBetSound then
                ExternalFun.playGameEffect(soundPath)
                -- 尽量避免重复播放
                self:doSomethingLater(function() self.m_isPlayBetSound  = false end, math.random(2,4)/10)
                self.m_isPlayBetSound = true
            end
        end
    end)

    local forward = cc.MoveTo:create(0.35, endPos)
    local eMove = cc.EaseSineOut:create(forward)
    --local Value = isNeedDelay and ( math.random(0,10) % 100)/100.0 or 0 
    local seq = cc.Sequence:create(call, eMove)
    sp:runAction(seq)

    return sp
end
--单张发牌和开牌
function GameViewLayer:sendCard(nIndex)

    local card = BaccaratDataMgr.getInstance():getCardAtIndex(self.m_sendCardConfig[nIndex].cardType, self.m_sendCardConfig[nIndex].cardIndex)
    if not card then return end
    local poker = Poker:create()
    poker:setData(card.iColor, card.iValue)
    poker:setPosition(self.m_sendCardConfig.beginPos)
    poker:setBack()
    poker:setRotation(self.m_sendCardConfig.beginRotate)
    poker:setScale(self.m_sendCardConfig.beginScaleVal)
    poker:addTo(self.m_nodeCardAni)

    local moveTo = cc.MoveTo:create(self.m_sendCardConfig.sendTs, self.m_sendCardConfig[nIndex].endPos)
    local rotateBy = cc.RotateBy:create(self.m_sendCardConfig.sendTs, 360 - self.m_sendCardConfig.beginRotate)
    local scaleTo = cc.ScaleTo:create(self.m_sendCardConfig.sendTs, self.m_sendCardConfig.endScaleVal)
    local spawn = cc.Spawn:create(moveTo, rotateBy, scaleTo)

    local callBack1 = cc.CallFunc:create(
        function ()
            if nIndex < self.m_sendCardConfig.cardNum then
                self:sendCard(nIndex + 1)
            else
                --if 2 == nIndex then --闲家发第二张牌
                    self:xianAddCardAni(1)
--                    local point = BaccaratDataMgr.getInstance():getResultPoints(BaccaratDataMgr.ePlace_Zhuang, 2)
--                    self.m_zhuangPointAni = self:playCardPointAni(self.m_sendCardConfig.pointAniPos[BaccaratDataMgr.ePlace_Zhuang][3], point)
--                    ExternalFun.playGameEffect( string.format( BaccaratRes.SOUND_OF_ZPOINT, point))
                --end
            end
        end
    )

    local callBack2 = cc.CallFunc:create(function ()
        poker:showCard()
    end)

    local seq = cc.Sequence:create(spawn,
        cc.ScaleTo:create(self.m_sendCardConfig.openCardTs, 0.03, self.m_sendCardConfig.endScaleVal),
        callBack2,
        cc.ScaleTo:create(self.m_sendCardConfig.openCardTs, self.m_sendCardConfig.endScaleVal, self.m_sendCardConfig.endScaleVal),
        callBack1)

    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_CARD)
    self.m_sendCard[nIndex] = poker
    poker:runAction(seq)
end

--补牌动画
function GameViewLayer:playAddCardAni()
    --是否显示加牌
    if BaccaratDataMgr.getInstance():getCardCount(BaccaratDataMgr.ePlace_Xian) > 2 then
        --self:doSomethingLater(function() self:xianAddCardAni(2) end, self.m_sendCardConfig.pointSoundDelay)
        self:xianAddCardAni(2)
    elseif BaccaratDataMgr.getInstance():getCardCount(BaccaratDataMgr.ePlace_Zhuang) > 2 then
        --self:doSomethingLater(function() self:zhuangAddCardAni(2) end, self.m_sendCardConfig.pointSoundDelay)
        self:zhuangAddCardAni(2)
    else
        --不需要补牌 直接播放结果动画
        --self:doSomethingLater(function() self:playCardResultAni() end, 1.2)
        self:playCardResultAni()
    end
end

--闲家补牌
function GameViewLayer:xianAddCardAni(nIndex)
    --补的牌在发完后以牌背方式横向显示
    local poker = Poker:create()
    poker:setPosition(self.m_sendCardConfig.beginPos)
    poker:setBack()
    poker:setRotation(self.m_sendCardConfig.beginRotate)
    poker:setScale(self.m_sendCardConfig.beginScaleVal)
    poker:addTo(self.m_nodeCardAni)

    local endpos = cc.p(self.m_xianCardEndPos.x + nIndex*self.m_sendCardConfig.cardOffsetX, self.m_xianCardEndPos.y + self.m_sendCardConfig.cardOffsetY)

    local moveTo = cc.MoveTo:create(self.m_sendCardConfig.sendTs, endpos)
    local rotateBy = cc.RotateBy:create(self.m_sendCardConfig.sendTs, 90 - self.m_sendCardConfig.beginRotate)
    local scaleTo = cc.ScaleTo:create(self.m_sendCardConfig.sendTs, self.m_sendCardConfig.endScaleVal)
    local spawn = cc.Spawn:create(moveTo, rotateBy, scaleTo)

    local callBack1 = cc.CallFunc:create(
        function ()
            poker:removeFromParent()
            self:xianOpenCard(nIndex)
        end
    )

    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_CARD)
    local seq = cc.Sequence:create(spawn, callBack1)
    poker:runAction(seq)
    if 2 == nIndex then
        self.m_sendCard[1]:runAction(cc.MoveBy:create(self.m_sendCardConfig.sendTs, cc.p(-self.m_sendCardConfig.cardOffsetX/2, 0)))
        self.m_sendCard[3]:runAction(cc.MoveBy:create(self.m_sendCardConfig.sendTs, cc.p(-self.m_sendCardConfig.cardOffsetX/2, 0)))
    end
end

--闲家开最后一张牌
function GameViewLayer:xianOpenCard(nIndex)
    local card = BaccaratDataMgr.getInstance():getCardAtIndex(BaccaratDataMgr.ePlace_Xian, nIndex + 1)
    if not card then return end

    local armature = ccs.Armature:create(BaccaratRes.ANI_FILE_FANPAI)
    if armature == nil then
        return
    end
    local pos = cc.p(self.m_xianCardEndPos.x + nIndex*self.m_sendCardConfig.cardOffsetX, self.m_xianCardEndPos.y + self.m_sendCardConfig.cardOffsetY)
    armature:setPosition(pos) 
    self.m_nodeCardAni:addChild(armature)

    local pathVal = string.format("value-%d-%d.png", card.iValue, card.iColor%2)
    local pathColor = string.format("color-%d.png", card.iColor), ccui.TextureResType.plistType
    self:replaceArmatureSprite(armature, self.m_sendCardConfig.boneName.VALUE, pathVal)
    self:replaceArmatureSprite(armature, self.m_sendCardConfig.boneName.COLOR, pathColor)
    local animationEvent = function(armatureBack, movementType, movementID)
        if movementType == ccs.MovementEventType.complete 
        or movementType == ccs.MovementEventType.loopComplete
        then
            armature:removeFromParent()
            self:xianViewCard(nIndex)
        end
    end
    armature:getAnimation():setMovementEventCallFunc(animationEvent)
    armature:getAnimation():playWithIndex(0)
end

--闲家最后一张牌显示
function GameViewLayer:xianViewCard(nIndex)
    local card = BaccaratDataMgr.getInstance():getCardAtIndex(BaccaratDataMgr.ePlace_Xian, nIndex + 1)
    if not card then return end
    local poker = Poker:create()
    poker:setData(card.iColor, card.iValue)
    poker:setPosition(cc.p(self.m_xianCardEndPos.x + (2 + nIndex)*self.m_sendCardConfig.cardOffsetX/2, self.m_xianCardEndPos.y))
    poker:showCard()
    poker:addTo(self.m_nodeCardAni)

    --牌的抖动动画
    poker:setScale(1)
    poker:setRotation(-40)

    local rotae1 = cc.RotateTo:create(3 * 0.017, -15)
    local rotae2 = cc.RotateTo:create(4 * 0.017, 10)
    local rotae3 = cc.RotateTo:create(6 * 0.017, 0)
    local scale1 = cc.ScaleTo:create(3 * 0.017, self.m_sendCardConfig.endScaleVal)
    local callBack = cc.CallFunc:create(
        function ()
            self:zhuangAddCardAni(nIndex)
        end
    )
    local seq = cc.Sequence:create(cc.Spawn:create(rotae1, scale1), rotae2, rotae3, callBack)
    poker:runAction(seq)
    if 1 == nIndex then
        self.m_sendCard[3] = poker
    end
end

--庄家补牌
function GameViewLayer:zhuangAddCardAni(nIndex)
    if 2 == nIndex and BaccaratDataMgr.getInstance():getCardCount(BaccaratDataMgr.ePlace_Zhuang) < 3 then
        self:playCardResultAni()
        return
    end

    local poker = Poker:create()
    poker:setPosition(self.m_sendCardConfig.beginPos)
    poker:setBack()
    poker:setRotation(self.m_sendCardConfig.beginRotate)
    poker:setScale(self.m_sendCardConfig.beginScaleVal)
    poker:addTo(self.m_nodeCardAni)

    local endpos = cc.p(self.m_zhuangCardEndPos.x + nIndex*self.m_sendCardConfig.cardOffsetX, self.m_zhuangCardEndPos.y + self.m_sendCardConfig.cardOffsetY)
    local moveTo = cc.MoveTo:create(self.m_sendCardConfig.sendTs, endpos)
    local rotateBy = cc.RotateBy:create(self.m_sendCardConfig.sendTs, 90 - self.m_sendCardConfig.beginRotate)
    local scaleTo = cc.ScaleTo:create(self.m_sendCardConfig.sendTs, self.m_sendCardConfig.endScaleVal)
    local spawn = cc.Spawn:create(moveTo, rotateBy, scaleTo)

    local callBack1 = cc.CallFunc:create(
        function ()
            poker:removeFromParent()
            self:zhuangOpenCard(nIndex)
        end
    )

    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_CARD)
    local seq = cc.Sequence:create(spawn, callBack1)
    poker:runAction(seq)
    if 2 == nIndex then
        self.m_sendCard[2]:runAction(cc.MoveBy:create(self.m_sendCardConfig.sendTs, cc.p(-self.m_sendCardConfig.cardOffsetX/2, 0)))
        self.m_sendCard[4]:runAction(cc.MoveBy:create(self.m_sendCardConfig.sendTs, cc.p(-self.m_sendCardConfig.cardOffsetX/2, 0)))
    end
end

--庄家开最后一张牌
function GameViewLayer:zhuangOpenCard(nIndex)
    local card = BaccaratDataMgr.getInstance():getCardAtIndex(BaccaratDataMgr.ePlace_Zhuang, nIndex + 1)
    if not card then
        return
    end
    
    local armature = ccs.Armature:create(BaccaratRes.ANI_FILE_FANPAI)
    if armature == nil then
        return
    end
    local pos = cc.p(self.m_zhuangCardEndPos.x + 2*self.m_sendCardConfig.cardOffsetX, self.m_zhuangCardEndPos.y + self.m_sendCardConfig.cardOffsetY)
    armature:setPosition(pos) 
    self.m_nodeCardAni:addChild(armature)


    local pathVal = string.format("value-%d-%d.png", card.iValue, card.iColor%2)
    local pathColor = string.format("color-%d.png", card.iColor), ccui.TextureResType.plistType
    self:replaceArmatureSprite(armature, self.m_sendCardConfig.boneName.VALUE, pathVal)
    self:replaceArmatureSprite(armature, self.m_sendCardConfig.boneName.COLOR, pathColor)

    local animationEvent = function(armatureBack, movementType, movementID)
        if movementType == ccs.MovementEventType.complete 
        or movementType == ccs.MovementEventType.loopComplete
        then
            armature:removeFromParent()
            self:zhuangViewCard(nIndex)
        end
    end
    armature:getAnimation():setMovementEventCallFunc(animationEvent)
    armature:getAnimation():playWithIndex(0)
end

--庄家最后一张牌显示
function GameViewLayer:zhuangViewCard(nIndex)
    local card = BaccaratDataMgr.getInstance():getCardAtIndex(BaccaratDataMgr.ePlace_Zhuang, nIndex + 1)
    if not card then return end
    local poker = Poker:create()
    poker:setData(card.iColor, card.iValue)
    poker:setPosition(cc.p(self.m_zhuangCardEndPos.x + (2 + nIndex)*self.m_sendCardConfig.cardOffsetX/2, self.m_zhuangCardEndPos.y))
    poker:showCard()

    poker:addTo(self.m_nodeCardAni)

    --牌的抖动动画
    poker:setScale(1)
    poker:setRotation(-40)

    local rotae1 = cc.RotateTo:create(3 * 0.017, -15)
    local rotae2 = cc.RotateTo:create(4 * 0.017, 10)
    local rotae3 = cc.RotateTo:create(6 * 0.017, 0)
    local scale1 = cc.ScaleTo:create(3 * 0.017, self.m_sendCardConfig.endScaleVal)
    local callBack = cc.CallFunc:create(
        function ()
            if 1 == nIndex then
                self:playAddCardAni()
            else
                self:playCardResultAni()
            end
        end
    )
    local seq = cc.Sequence:create(cc.Spawn:create(rotae1, scale1), rotae2, rotae3, callBack)
    poker:runAction(seq)
    if 1 == nIndex then
        self.m_sendCard[4] = poker
    end
end

--播放点数 牌型 和胜利动画
function GameViewLayer:playCardResultAni()
    local countxian   = 0
    local countzhuang = 0
    local pointxian   = 0
    local pointzhuang = 0
    local isDuiZi     = false
    local isTianWang  = false
    local posx        = 0
    local posy        = 0
    local imgWidth    = 66 + 10

    --region 闲家
    --点数
    countxian = BaccaratDataMgr.getInstance():getCardCount(BaccaratDataMgr.ePlace_Xian)
    pointxian = BaccaratDataMgr.getInstance():getResultPoints(BaccaratDataMgr.ePlace_Xian, countxian)

    --牌型
    isDuiZi = BaccaratDataMgr.getInstance():getResultIsTwoPair(BaccaratDataMgr.ePlace_Xian)
    isTianWang = pointxian > 7

    --计算牌型动画的展示原点
    posx = self.m_xianCardEndPos.x + 2*self.m_sendCardConfig.cardOffsetX/2
    posy = self.m_xianCardEndPos.y - 10

    if isDuiZi and isTianWang then
        ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_TIANWANG)
        local pos1 = cc.p(posx - imgWidth/2, posy)
        local pos2 = cc.p(posx + imgWidth/2, posy)
        self:playCardTypeAni(pos1, BaccaratRes.ANI_CARDTYPE_NAME.NAME_DUIZI)
        self:playCardTypeAni(pos2, BaccaratRes.ANI_CARDTYPE_NAME.NAME_TIANWANG)
    elseif isDuiZi then
        ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_TIANWANG)
        self:playCardTypeAni(cc.p(posx, posy), BaccaratRes.ANI_CARDTYPE_NAME.NAME_DUIZI)
    elseif isTianWang then
        ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_TIANWANG)
        self:playCardTypeAni(cc.p(posx, posy), BaccaratRes.ANI_CARDTYPE_NAME.NAME_TIANWANG)
    end

    self:playCardPointAni(self.m_sendCardConfig.pointAniPos[BaccaratDataMgr.ePlace_Xian][3], pointxian)
    --endregion

    --region 庄家
    --点数
    countzhuang = BaccaratDataMgr.getInstance():getCardCount(BaccaratDataMgr.ePlace_Zhuang)
    pointzhuang = BaccaratDataMgr.getInstance():getResultPoints(BaccaratDataMgr.ePlace_Zhuang, countzhuang)

    --牌型
    isDuiZi = BaccaratDataMgr.getInstance():getResultIsTwoPair(BaccaratDataMgr.ePlace_Zhuang)
    isTianWang = pointzhuang > 7

    --计算牌型动画的展示原点
    posx = self.m_zhuangCardEndPos.x + 2*self.m_sendCardConfig.cardOffsetX/2
    posy = self.m_zhuangCardEndPos.y - 10

    if isDuiZi and isTianWang then
        ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_TIANWANG)
        local pos1 = cc.p(posx - imgWidth/2, posy)
        local pos2 = cc.p(posx + imgWidth/2, posy)
        self:playCardTypeAni(pos1, BaccaratRes.ANI_CARDTYPE_NAME.NAME_DUIZI)
        self:playCardTypeAni(pos2, BaccaratRes.ANI_CARDTYPE_NAME.NAME_TIANWANG)
    elseif isDuiZi then
        ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_TIANWANG)
        self:playCardTypeAni(cc.p(posx, posy), BaccaratRes.ANI_CARDTYPE_NAME.NAME_DUIZI)
    elseif isTianWang then
        ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_TIANWANG)
        self:playCardTypeAni(cc.p(posx, posy), BaccaratRes.ANI_CARDTYPE_NAME.NAME_TIANWANG)
    end
    self:playCardPointAni(self.m_sendCardConfig.pointAniPos[BaccaratDataMgr.ePlace_Zhuang][3], pointzhuang)
    --endregion

    --获胜动画
    local soundStr = ""
    if BaccaratDataMgr.getInstance():getResultIsTongDianPing() then --同点平
        posx = self.m_xianCardEndPos.x + 2*self.m_sendCardConfig.cardOffsetX/2
        posy = self.m_xianCardEndPos.y + 75
        self:playResultPingAni(cc.p(posx, posy), BaccaratRes.ANI_CARDTYPE_NAME.NAME_SAMEPING)

        posx = self.m_zhuangCardEndPos.x + 2*self.m_sendCardConfig.cardOffsetX/2
        posy = self.m_zhuangCardEndPos.y + 75
        self:playResultPingAni(cc.p(posx, posy), BaccaratRes.ANI_CARDTYPE_NAME.NAME_SAMEPING)

        soundStr = BaccaratRes.SOUND_OF_PING
        --ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_PING)
    elseif pointxian == pointzhuang then --平
        posx = self.m_xianCardEndPos.x + 2*self.m_sendCardConfig.cardOffsetX/2
        posy = self.m_xianCardEndPos.y + 75
        self:playResultPingAni(cc.p(posx, posy), BaccaratRes.ANI_CARDTYPE_NAME.NAME_PING)

        posx = self.m_zhuangCardEndPos.x + 2*self.m_sendCardConfig.cardOffsetX/2
        posy = self.m_zhuangCardEndPos.y + 75
        self:playResultPingAni(cc.p(posx, posy), BaccaratRes.ANI_CARDTYPE_NAME.NAME_PING)

        soundStr = BaccaratRes.SOUND_OF_PING
        --ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_PING)
    elseif pointxian > pointzhuang then--闲赢
        posx = self.m_xianCardEndPos.x + 2*self.m_sendCardConfig.cardOffsetX/2
        posy = self.m_xianCardEndPos.y + 75
        self:playResultWinAni(cc.p(posx, posy))
        soundStr = BaccaratRes.SOUND_OF_XIANWIN
        --ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_XIANWIN)
    else --庄赢
        posx = self.m_zhuangCardEndPos.x + 2*self.m_sendCardConfig.cardOffsetX/2
        posy = self.m_zhuangCardEndPos.y + 75
        self:playResultWinAni(cc.p(posx, posy))
        soundStr = BaccaratRes.SOUND_OF_ZHUANGWIN
        --ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_ZHUANGWIN)
    end

    --闲家点数
    ExternalFun.playGameEffect( string.format( BaccaratRes.SOUND_OF_XPOINT, pointxian))

    --闲家
    self:doSomethingLater(function() ExternalFun.playGameEffect( string.format( BaccaratRes.SOUND_OF_ZPOINT, pointzhuang)) end, 1.2)
    
    --结果音效
    self:doSomethingLater(function() ExternalFun.playGameEffect(soundStr) end, 2.4)

    -- 0胜 1负 2平
    local winArea = {
        [1] = pointzhuang < pointxian, --闲
        [2] = pointzhuang == pointxian, --平
        [3] = pointzhuang > pointxian, --庄
        [4] = pointxian > 7, --闲天王
        [5] = pointzhuang > 7, --庄天王
        [6] = BaccaratDataMgr.getInstance():getResultIsTongDianPing(), --同点平
        [7] = BaccaratDataMgr.getInstance():getResultIsTwoPair(BaccaratDataMgr.ePlace_Xian), --闲对
        [8] = BaccaratDataMgr.getInstance():getResultIsTwoPair(BaccaratDataMgr.ePlace_Zhuang), --庄对
    }

    for i = 1, AreaCount do
        if winArea[i] then self:playAreaBlink(i) end
    end

    --更新历史记录
    BaccaratDataMgr.getInstance():addGameRecordByOpen()
    self:notifyTrendRefresh()

    --延迟1秒后 播放飞筹码动画
    self:doSomethingLater(function() self:flychipex() end, 1)

    --提示本局有无下注
    self:showResultTips()
end

--提示本局有无下注
function GameViewLayer:showResultTips()
    if BaccaratDataMgr.getInstance():isBanker() then
        return
    end

    if BaccaratDataMgr.getInstance():getMyAllBetValue() > 0 then
        return
    end

    FloatMessage.getInstance():pushMessageForString("本局您没有下注!")
end

--显示牌点动画
function GameViewLayer:playCardPointAni(pos, point)
--    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(huanle30s_kaipai) 
    local armature = ccs.Armature:create("huanle30s_kaipai")
    armature:setPosition(pos) 
    self.m_nodeCardAni:addChild(armature)

    if point < 8 then
        self:replaceArmatureSprite(armature, BaccaratRes.ANI_CARDTYPE_NAME.BONE_LOWPOINT, string.format( BaccaratRes.IMG_CARDPOINT, point))
    else
        self:replaceArmatureSprite(armature, BaccaratRes.ANI_CARDTYPE_NAME.BONE_HIGHPOINT, string.format( BaccaratRes.IMG_CARDPOINT, point))
    end

    armature:getAnimation():play(BaccaratRes.ANI_CARDTYPE_NAME[point])

    return armature
end

--显示牌型动画
function GameViewLayer:playCardTypeAni(pos, aniName)
--    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(huanle30s_kaipai) 
    local armature = ccs.Armature:create("huanle30s_kaipai")
    armature:setPosition(pos) 
    self.m_nodeCardAni:addChild(armature)
    armature:getAnimation():play(aniName)
end

--显示平/同点平动画
function GameViewLayer:playResultPingAni(pos, aniName)
--    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(huanle30s_kaipai) 
    local armature = ccs.Armature:create("huanle30s_kaipai")
    armature:setPosition(pos) 
    self.m_nodeCardAni:addChild(armature)
    armature:getAnimation():play(aniName)
end

--显示赢动画
function GameViewLayer:playResultWinAni(pos)
--    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(jiesuan_ying) 
    local armature = ccs.Armature:create("jiesuan_ying")
    armature:setPosition(pos) 
    self.m_nodeCardAni:addChild(armature)
    armature:getAnimation():play(BaccaratRes.ANI_YING_NAME.BEGAN)
    local animationEvent = function (armatureBack, movementType, movementID)
        if movementType == ccs.MovementEventType.complete then
            armature:getAnimation():play(BaccaratRes.ANI_YING_NAME.LOOP)
        end
    end
    armature:getAnimation():setMovementEventCallFunc(animationEvent)
end

--替换动画的节点资源
function GameViewLayer:replaceArmatureSprite(armature, boneName, newName)
    local bone = armature:getBone(boneName)
    local manager = bone:getDisplayManager()
    local vecDisplay = manager:getDecorativeDisplayList()
    for k, v in pairs(vecDisplay) do
        if v then
            local spData = v:getDisplay()
            if spData then
                spData:setSpriteFrame(newName)
            end
        end
    end
end

--清理所有扑克牌动画
function GameViewLayer:cleanCardAni()
    --self.m_xianPointAni = nil
    --self.m_zhuangPointAni = nil
    self.m_sendCard = {}
    self.m_nodeCardAni:stopAllActions()
    self.m_nodeCardAni:removeAllChildren()
end

--播放等待下一局动画
function GameViewLayer:playWaitAni()

--    ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_WAGER_STOP)
--    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(huanle30s_dengdaixiaju) 
    local armature = ccs.Armature:create("huanle30s_dengdaixiaju")  
    armature:setPosition(667,375)                   
    self.m_nodeZCAni:addChild(armature)                      
    armature:getAnimation():playWithIndex(0)
    armature:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(function()
		                                            armature:removeFromParent()
	                                            end)))

end

--清理所有转场动画
function GameViewLayer:cleanZhuanChangAni()
    self.m_nodeZCAni:stopAllActions()
    self.m_nodeZCAni:removeAllChildren()
end

--刷新庄家信息显示
function GameViewLayer:updateBankerInfo()--更新庄家信息
    --庄家名字
    local name = BaccaratDataMgr.getInstance():getBankerName()
--    if INVALID_CHAIR == BaccaratDataMgr.getInstance():getBankerId() then
--        name = LuaUtils.getLocalString("STRING_240")
--    end
    local strName = LuaUtils.getDisplayNickNameInGame(name)
    self.m_pLbBankerName:setString(strName)

    --庄家分数
    local llScore = BaccaratDataMgr.getInstance():getBankerScore()
    local strScore = llScore--LuaUtils.getFormatGoldAndNumber(llScore)
    self.m_pLbBankerGold:setString(strScore)
    
    --申请上庄人数
    local listSize = BaccaratDataMgr.getInstance():getBankerListSize()
    local strList = string.format(LuaUtils.getLocalString("STRING_241"), listSize)
    local bInList = BaccaratDataMgr.getInstance():isInBankerList()
    if bInList ~= -1 and not BaccaratDataMgr.getInstance():isBanker() then
        strList = string.format(LuaUtils.getLocalString("STRING_242"), bInList - 1)
    end
    self.m_pLbApplyNum:setString(strList)

    --上庄按钮
    local bIsAsk = (BaccaratDataMgr.getInstance():isBanker() or (bInList ~= -1))
    self.m_pBtnApply:setVisible(not bIsAsk)
    self.m_pBtnDown:setVisible(bIsAsk)
end


--得分动画
function GameViewLayer:playUserScoreEffect()
    local selfcurscore = 0 -- 自己最终得分
    local bankercurscore = 0 -- 庄家最终得分
    local othercurscore = 0 -- 其他玩家最终得分
    local isbanker = BaccaratDataMgr.getInstance():isBanker()

    selfcurscore, othercurscore, bankercurscore = self:calcCurScore()

    --用户当前积分
    local llUserScore = PlayerInfo.getInstance():getUserScore()--self.m_oldScore
    local str = ""
    local curpath = ""

    -- 显示庄家分数动画
    str = bankercurscore--LuaUtils.getFormatGoldAndNumber(bankercurscore)
    if bankercurscore > 0 then
        str = "+" .. str
    end
    curpath = bankercurscore < 0 and BaccaratRes.FNT_RESULT_LOSE or BaccaratRes.FNT_RESULT_WIN
    BaccaratDataMgr.getInstance():setBankerScore(BaccaratDataMgr.getInstance():getBankerScore() + bankercurscore)
    local cb = function()
        self:updateBankerInfo()
    end

    self:flyNumOfGoldChange(cc.p(self:getBankerChipBeginPosition()), curpath, str, cb)

    -- 显示其他玩家分数动画
    str = othercurscore--LuaUtils.getFormatGoldAndNumber(othercurscore)
    if othercurscore > 0 then
        str = "+" .. str
    end
    local posOther = cc.p(self:getOtherChipBeginPosition())
    posOther.x = posOther.x - 20
    posOther.y = posOther.y + 110
    curpath = othercurscore < 0 and BaccaratRes.FNT_RESULT_LOSE or BaccaratRes.FNT_RESULT_WIN
    self:flyNumOfGoldChange(posOther, curpath, str)

    -- 显示自己分数动画
    local selfbet = BaccaratDataMgr.getInstance():getMyAllBetValue()
    if selfbet > 0 or isbanker then
        str = selfcurscore--LuaUtils.getFormatGoldAndNumber(selfcurscore)
        if selfcurscore > 0 then
            str = "+" .. str
        end

        local posSelf = cc.p(self:getSelfChipBeginPosition())
        posSelf.y = posSelf.y + 150
        curpath = selfcurscore < 0 and BaccaratRes.FNT_RESULT_LOSE or BaccaratRes.FNT_RESULT_WIN
        self:flyNumOfGoldChange(posSelf, curpath, str)
    end

    --自己金币变化动画
    local soundPath = ""
    if selfcurscore > 0 then
        local lastSore = llUserScore + selfcurscore + selfbet
--        Effect:getInstance():showScoreChangeEffect(self.m_pLbSelfGold, llUserScore , selfcurscore, lastSore, 1, 10)
        --播放分级音效
        if selfcurscore >= 50 then
            soundPath = BaccaratRes.SOUND_OF_CMD[ math.random(1, 2) ]
        elseif selfcurscore >= 20 then
            soundPath = BaccaratRes.SOUND_OF_CMD[ math.random(3, 4) ]
        elseif selfcurscore >= 5 then
            soundPath = BaccaratRes.SOUND_OF_CMD[ math.random(5, 6) ]
        else
            soundPath = BaccaratRes.SOUND_OF_WIN
        end
    else
        if 0 == BaccaratDataMgr.getInstance():getUserBetSize() then
            soundPath = BaccaratRes.SOUND_OF_NOBET
        else
            if selfcurscore <= -1000 then
                soundPath = string.format(BaccaratRes.SOUND_OF_CMD[7], math.random(1, 4))
            elseif selfcurscore <= -500 then
                soundPath = BaccaratRes.SOUND_OF_CMD[ math.random(8, 9) ]
            elseif selfcurscore <= -200 then
                soundPath = BaccaratRes.SOUND_OF_CMD[ math.random(10, 11) ]
            else
                soundPath = BaccaratRes.SOUND_OF_LOSE
            end
        end
        self.m_pLbSelfGold:setString(llUserScore)
    end

    ExternalFun.playGameEffect(soundPath)

end

--弹金币动画
function GameViewLayer:flyNumOfGoldChange(beginPos, filepath, str, cb)
    local lb = cc.Label:createWithBMFont(filepath, str)
                :setAnchorPoint(0, 0.5)
                :setOpacity(255)
                :setScale(0.6)
                :setVisible(true)
                :setPosition(beginPos)
                :addTo(self.m_nodeFlyChip)

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


--克隆一个赔付的筹码对象
function GameViewLayer:clonePayoutChip(jettonIndex)
    local pos = self:getBankerChipBeginPosition()
    local pSpr = self:getSpriteOfJetton(jettonIndex)
    if not pSpr then return end
    pSpr:setScale(0.35)
    pSpr:setPosition(pos)
    pSpr:setLocalZOrder(10)
    self.m_nodeFlyChip:addChild(pSpr)
    return pSpr
end

--以队列方式进行飞筹码
function GameViewLayer:flychipex()
    -- 处理现有的筹码对象列表
    local countXian  = BaccaratDataMgr.getInstance():getCardCount(BaccaratDataMgr.ePlace_Xian)
    local pointXian  = BaccaratDataMgr.getInstance():getResultPoints(BaccaratDataMgr.ePlace_Xian, countXian)
    local countZhuang = BaccaratDataMgr.getInstance():getCardCount(BaccaratDataMgr.ePlace_Zhuang)
    local pointZhuang = BaccaratDataMgr.getInstance():getResultPoints(BaccaratDataMgr.ePlace_Zhuang, countZhuang)


    -- 0胜 1负 2平
    local winArea = {
        [1] = pointZhuang < pointXian and 0 or 1 , --闲
        [2] = pointZhuang == pointXian and 0 or 1 , --平
        [3] = pointZhuang > pointXian and 0 or 1 , --庄
        [4] = pointXian > 7 and 0 or 1 , --闲天王
        [5] = pointZhuang > 7 and 0 or 1 , --庄天王
        [6] = BaccaratDataMgr.getInstance():getResultIsTongDianPing() and 0 or 1 , --同点平
        [7] = BaccaratDataMgr.getInstance():getResultIsTwoPair(BaccaratDataMgr.ePlace_Xian) and 0 or 1 , --闲对
        [8] = BaccaratDataMgr.getInstance():getResultIsTwoPair(BaccaratDataMgr.ePlace_Zhuang) and 0 or 1 , --庄对
    }

    if 0 == winArea[2] or 0 == winArea[6] then
        winArea[1] = 2
        winArea[3] = 2
    end

    local tem = BaccaratDataMgr.getInstance():getLastGameRecord()
    if not tem then return end

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

    for k, v in pairs(self.m_vJettonOfMine) do
         table.insert(selfvec[v.wChipIndex].vec, v)
    end

    for k, v in pairs(self.m_vJettonOfOther) do
        table.insert(othervec[v.wChipIndex].vec, v)
    end

    -- 遍历获胜的区域 必须用pairs方式 保证所有筹码遍历到
    local selfPos = self:getSelfChipBeginPosition()
    local bankerPos = self:getBankerChipBeginPosition()
    local otherPos = self:getOtherChipBeginPosition()
    for i = 1, CHIP_ITEM_COUNT do
        for k, v in pairs(selfvec[i].vec) do
            if v then
                if 1 == selfvec[i].winmark then
                    table.insert(bankerwinvec[i], {sp = v.pChipSpr, endpos = bankerPos})
                    bankerwin = true
                else
                    table.insert(selfwinvec[i], {sp = v.pChipSpr, endpos = selfPos, winmark = selfvec[i].winmark})
                    selfwin = true
                end
            end
        end

        for k, v in pairs(othervec[i].vec) do
            if v then
                if 1 == othervec[i].winmark then
                    table.insert(bankerwinvec[i], {sp = v.pChipSpr, endpos = bankerPos})
                    bankerwin = true
                else
                    table.insert(otherwinvec[i], {sp = v.pChipSpr, endpos = otherPos, winmark = selfvec[i].winmark})
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
        rewardCount = 0
        for m = 1, CHIP_REWARD[i] - 1 do
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
                if oldsp and 0 == selfwinvec[i][j].winmark then
                    local newsp = self:clonePayoutChip(oldsp:getTag())
                    -- 初始点在庄家处
                    newsp:setPosition(bankerPos)
                    -- 加入赔付队列 落点坐标直接从预定义的随机落点取 赔付的筹码使用随机区域落点互换
                    local posIdx = j % #self.m_randmChipOthers[i].vec
                    posIdx = posIdx > 0 and posIdx or 1
                    table.insert( bankerlostvec[i], { sp = newsp, endpos = self.m_randmChipOthers[i].vec[posIdx]})
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
            if oldsp and 0 == otherwinvec[i][j].winmark then
                local newsp = self:clonePayoutChip(oldsp:getTag())
                newsp:setPosition(bankerPos)
                local randx = (math.random(-offset*100, offset*100)) / 100
                local randy = (math.random(-offset*100, offset*100)) / 100
                local posIdx = j % #self.m_randmChipSelf[i].vec
                posIdx = posIdx > 0 and posIdx or 1
                table.insert( bankerlostvec[i], { sp = newsp, endpos = self.m_randmChipSelf[i].vec[posIdx] })
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
                                ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_GETGOLD)
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
                                ExternalFun.playGameEffect(BaccaratRes.SOUND_OF_GETGOLD)
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

    table.insert(self.m_flyJobVec.jobVec, { jobitem1 }) -- 1 飞行庄家获取筹码
    table.insert(self.m_flyJobVec.jobVec, { jobitem2 }) -- 2 飞行庄家赔付筹码
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

--闪烁获胜区域
function GameViewLayer:playAreaBlink(nIndex)
    local _node = self.m_pBlink[nIndex]
    if not _node then return end
    _node:runAction(cc.Sequence:create(cc.Blink:create(5, 5), cc.Show:create()))
end

--隐藏所有获胜闪烁区域
function GameViewLayer:hideAllAreaBlink()
    for i = 1, AreaCount do
        self.m_pBlink[i]:stopAllActions()
        self.m_pBlink[i]:setVisible(false)
    end
end

--endregion

--region 其他弹出层

function GameViewLayer:showTrendLayer() --打开路子
    BaccaratTrendLayer.create():addTo(self.m_rootUI, ZORDER_OF_TREND)
end

function GameViewLayer:showRuleLayer() --打开规则
--    local CommonRule = require("common.layer.CommonRule")
--    local nKind = PlayerInfo.getInstance():getKindID()
--    local pRule = CommonRule.new(nKind)
--    pRule:addTo(self.m_rootUI, ZORDER_OF_RULE)
end

function GameViewLayer:showIngameBank() --打开银行
--    IngameBankView.create():addTo(self.m_rootUI, ZORDER_OF_FLOATMESSAGE)
end

function GameViewLayer:showMessageBox(msg, cb) --打开确认框
    --MessageBox.create(msg):addTo(self.m_rootUI, ZORDER_OF_MESSAGEBOX)
--    local pMessageBox = MessageBoxNew.create(msg, cb)
--    self.m_rootUI:addChild(pMessageBox, ZORDER_OF_MESSAGEBOX)
end

function GameViewLayer:showFloatmessage(msg) --打开提示信息
    FloatMessage.getInstance():pushMessage(msg)
end

function GameViewLayer:showChargeLayer() --打开充值

end

--endregion

--显示主界面上端的大路
function GameViewLayer:initMainViewDalu()
    local rows = 5
    local cols = 7
    local border = 1
    local bgwidth = 23
    local cellwidth = border + bgwidth
    local cellheight = rows * cellwidth
    local scale = 0.7

    local cellSizeForTable = function (table, idx)
        return cellwidth, cellheight
    end

    local numberOfCellsInTableView = function (table)
        return self.m_daluMaxCol > cols and self.m_daluMaxCol or cols
    end

    local tableCellAtIndex = function (table, idx)
        local cell = table:dequeueCell()
        if not cell then
            cell = cc.TableViewCell:new()
        else
            cell:removeAllChildren()
        end

        for i = 0, rows - 1 do
            --背景方块
            local spBg = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_ROADSMALL_BG)
                :setAnchorPoint(cc.p(0, 0))
                :setPosition(cc.p(border, cellheight - (i + 1)*cellwidth))
                :addTo(cell)

            local record = BaccaratDataMgr.getInstance():getDaLuRecordByPosition(i, idx)
            if record.bExist then
                local posx = bgwidth/2
                local posy = posx

                if record.cbWin == 4 then   --起始开平
                    cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_TABLE_PING)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(posx, posy)
                        :setScale(scale)
                        :addTo(spBg)
                elseif record.cbWin >= 2 then--平
                    local spName1 = ((record.cbWin-2)==1)
                        and BaccaratRes.IMG_TABLE_ZHUANGWIN
                        or BaccaratRes.IMG_TABLE_XIANWIN

                    cc.Sprite:createWithSpriteFrameName(spName1)
                        :setScale(scale)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(posx, posy)
                        :addTo(spBg)

                    local spName2 = ((record.cbWin-2)==1)
                        and BaccaratRes.IMG_TABLE_ZHUANGPING
                        or BaccaratRes.IMG_TABLE_XIANPING

                    cc.Sprite:createWithSpriteFrameName(spName2)
                        :setScale(scale)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(posx, posy)
                        :addTo(spBg)
                else
                    local spName = (record.cbWin == 1)
                        and BaccaratRes.IMG_TABLE_ZHUANGWIN
                        or BaccaratRes.IMG_TABLE_XIANWIN

                    cc.Sprite:createWithSpriteFrameName(spName)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(posx, posy)
                        :setScale(scale)
                        :addTo(spBg)
                end

                if record.bBankerTwoPair then
                    cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_TABLE_ZHUANGDUI)
                        :setScale(0.3)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(posx - 6, posy + 6)
                        :addTo(spBg)
                end
                if record.bPlayerTwoPair then
                    cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_TABLE_XIANDUI)
                        :setScale(0.3)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(posx + 6, posy - 6)
                        :addTo(spBg)
                end
            end
        end

        return cell
    end

    self.m_pDaluView = cc.TableView:create(cc.size(cellwidth * cols, cellheight))
--    self.m_pDaluView:setIgnoreAnchorPointForPosition(false)
    self.m_pDaluView:setAnchorPoint(cc.p(0,0))
    self.m_pDaluView:setPosition(cc.p(0,0))
    self.m_pDaluView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.m_pDaluView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.m_pDaluView:setTouchEnabled(true)
    self.m_pDaluView:setDelegate()
    self.m_pNodeTableRoad:addChild(self.m_pDaluView)
    self.m_daluMaxCol = BaccaratDataMgr.getInstance():getDaLuColCount()
    self.m_daluMaxCol = self.m_daluMaxCol > cols and self.m_daluMaxCol or cols
    self.m_pDaluView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.m_pDaluView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.m_pDaluView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

end

--显示主界面上端的珠路
function GameViewLayer:initMainViewZhulu()
    local rows = 5
    local cols = 7
    local border = 1
    local bgwidth = 23
    local cellwidth = border + bgwidth
    local cellheight = rows * cellwidth
    local scale = 0.7

    local cellSizeForTable = function (table, idx)
        return cellwidth, cellheight
    end

    local numberOfCellsInTableView = function (table)
        return self.m_zhuluMaxCol > cols and self.m_zhuluMaxCol or cols
    end

    local tableCellAtIndex = function (table, idx)
        local cell = table:dequeueCell()
        if not cell then
            cell = cc.TableViewCell:new()
        else
            cell:removeAllChildren()
        end

        for i = 0, rows - 1 do
            --背景方块
            local spBg = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_ROADSMALL_BG)
                :setAnchorPoint(cc.p(0, 0))
                :setPosition(cc.p(border, cellheight - (i + 1)*cellwidth))
                :addTo(cell)

            local rIndex = idx*rows+i
            if rIndex <  BaccaratDataMgr.getInstance():getGameRecordSize() then
                local record = BaccaratDataMgr.getInstance():getGameRecordAtIndex(rIndex+1)
                local strSpName
                if record.cbPlayerCount < record.cbBankerCount then
                    --庄赢
                    strSpName = BaccaratRes.IMG_SMALL_ZHUANG
                elseif record.cbPlayerCount > record.cbBankerCount then
                    --闲赢
                    strSpName = BaccaratRes.IMG_SMALL_XIAN
                else
                    --平
                    strSpName = BaccaratRes.IMG_SMALL_PING
                end
                local spIcon = cc.Sprite:createWithSpriteFrameName(strSpName)
                                :setPosition(cc.p(bgwidth/2, bgwidth/2))
                                :setScale(scale)
                                :addTo(spBg)

                if record.bBankerTwoPair then
                    cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_TABLE_ZHUANGDUI)
                        :setScale(0.3)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(bgwidth/2 - 6, bgwidth/2 + 6)
                        :addTo(spBg)
                end
                if record.bPlayerTwoPair then
                    cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_TABLE_XIANDUI)
                        :setScale(0.3)
                        :setAnchorPoint(0.5, 0.5)
                        :setPosition(bgwidth/2 + 6, bgwidth/2 - 6)
                        :addTo(spBg)
                end
            end
        end

        return cell
    end

    self.m_pZhuluView = cc.TableView:create(cc.size(cellwidth * cols, cellheight))
--    self.m_pZhuluView:setIgnoreAnchorPointForPosition(false)
    self.m_pZhuluView:setAnchorPoint(cc.p(0,0))
    self.m_pZhuluView:setPosition(cc.p(0,0))
    self.m_pZhuluView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.m_pZhuluView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.m_pZhuluView:setTouchEnabled(true)
    self.m_pZhuluView:setDelegate()
    self.m_pNodeTableWin:addChild(self.m_pZhuluView)
    self.m_zhuluMaxCol = math.floor( BaccaratDataMgr.getInstance():getGameRecordSize() / rows) + 1
    self.m_zhuluMaxCol = self.m_zhuluMaxCol > cols and self.m_zhuluMaxCol or cols
    self.m_pZhuluView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.m_pZhuluView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.m_pZhuluView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

end

--刷新主界面路子
function GameViewLayer:updateMainRoadView()
    --大路刷新
    self.m_daluMaxCol = BaccaratDataMgr.getInstance():getDaLuColCount()
    self.m_pDaluView:reloadData()
    if self.m_daluMaxCol > 7 then
        self.m_pDaluView:setContentOffset(
            cc.p(self.m_pDaluView:getViewSize().width - self.m_pDaluView:getContentSize().width, 0))
    end

    --珠路刷新
    self.m_zhuluMaxCol = math.floor( BaccaratDataMgr.getInstance():getGameRecordSize() / 5) + 1
    self.m_pZhuluView:reloadData()
    if self.m_zhuluMaxCol > 7 then
        self.m_pZhuluView:setContentOffset(
            cc.p(self.m_pZhuluView:getViewSize().width - self.m_pZhuluView:getContentSize().width, 0))
    end

    --统计数据显示
    self.m_pLbZhuangNum:setString( string.format("庄:%d", BaccaratDataMgr.getInstance():getGameRecordCountByType(BaccaratDataMgr.ePlace_Zhuang)) )
    self.m_pLbXianNum:setString( string.format("闲:%d", BaccaratDataMgr.getInstance():getGameRecordCountByType(BaccaratDataMgr.ePlace_Xian)) )
    self.m_pLbPingNum:setString( string.format("平:%d", BaccaratDataMgr.getInstance():getGameRecordCountByType(BaccaratDataMgr.ePlace_Ping)) )
    self.m_pLbZhuangDuiNum:setString( string.format("庄对:%d", BaccaratDataMgr.getInstance():getGameRecordCountByType(BaccaratDataMgr.ePlace_ZhuangDui)) )
    self.m_pLbXianDuiNum:setString( string.format("闲对:%d", BaccaratDataMgr.getInstance():getGameRecordCountByType(BaccaratDataMgr.ePlace_XianDui)) )
end

--endregion

--region 辅助方法

function GameViewLayer:getSpriteOfJetton(score)
    local name = string.format("cm/%d.png", score)
    local sprite = cc.Sprite:createWithSpriteFrameName(name)
    return sprite
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
    return self.m_selfChipPos
end

--获取其他玩家筹码动画起点坐标
function GameViewLayer:getOtherChipBeginPosition()
    return self.m_otherChipPos
end

--获取庄家筹码动画起点坐标
function GameViewLayer:getBankerChipBeginPosition()
    return self.m_bankerChipPos
end

--重置筹码投注区
function GameViewLayer:resetChipPosArea()
    local offset = 7
    local cfg = {
        {row = 6, col = 9}, --庄
        {row = 5, col = 12}, --平
        {row = 6, col = 9}, --闲
        {row = 4, col = 7}, --闲天王
        {row = 4, col = 7}, --庄天王
        {row = 4, col = 4}, --同点平
        {row = 4, col = 7}, --闲对
        {row = 4, col = 7}, --庄对
    }
    for i = 1, AreaCount do
        self.m_randmChipSelf[i] = {
            idx = 1, -- pos点的索引，原则上按递增方式取点，保证首次最大化铺满区域，然后随机取点
            vec = self:getRandomChipPosVec(self.m_vChipArea[i], 30, cfg[i].row, cfg[i].col, offset)
        }
        self.m_randmChipOthers[i] = {
            idx = 1,
            vec = self:getRandomChipPosVec(self.m_vChipArea[i], 30, cfg[i].row, cfg[i].col, offset)
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

    -- 获取指定数量的随机放置点
--    local takenum = (#chipPosVec > num) and (#chipPosVec - num) or 0
--    for i = 1, takenum do
--        local delIdx = math.random(1, #chipPosVec)
--        table.remove(chipPosVec, delIdx)
--    end

    return chipPosVec
end

--清理显示筹码
function GameViewLayer:cleanChip()
    self.m_vJettonOfMine = {}
    self.m_vJettonOfOther = {}
    self.m_nodeFlyChip:removeAllChildren()
    self.m_flyJobVec = {}
end

--通知路子层刷新历史记录
function GameViewLayer:notifyTrendRefresh()
    SLFacade:dispatchCustomEvent(BaccaratEvent.MSG_GAME_BACCARAT_UPDATERECORD, "")
    --刷新主界面的路子显示
    self:updateMainRoadView()
end

--获取坐标点
function GameViewLayer:getSubNodePos(parentNode, subNodeName)
    local _node = parentNode:getChildByName(subNodeName)
    if _node then 
        return cc.p(_node:getPosition())
    else
        return cc.p(0, 0)
    end
end

--计算最终显示的积分
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
    local tax = 1 - BaccaratDataMgr.getInstance():getGameTax()
    local isbanker = BaccaratDataMgr.getInstance():isBanker()

    --庄家本局结算得分
    bankercurscore = BaccaratDataMgr.getInstance():getBankerResult()
    bankercurscore = bankercurscore > 0 and bankercurscore/tax or bankercurscore

    --用户本局结算积分(下注阶段压分然后退出再进，服务端结算本局游戏返回的用户积分是0，使用本地计算)
--    selfcurscore = BaccaratDataMgr.getInstance():getMyResult()
    --selfcurscore = selfcurscore > 0 and selfcurscore/tax or selfcurscore
    if isbanker then
        selfcurscore = bankercurscore
    else
        selfcurscore = BaccaratDataMgr.getInstance():getMyResult()--self:caleSelfWinScore(tax)
    end

    --其他玩家计算积分
    othercurscore = isbanker and -bankercurscore or -bankercurscore - selfcurscore

    selfcurscore = selfcurscore > 0 and selfcurscore * tax or selfcurscore
    othercurscore = othercurscore > 0 and othercurscore * tax or othercurscore
    bankercurscore = bankercurscore > 0 and bankercurscore * tax or bankercurscore

    return selfcurscore, othercurscore, bankercurscore
end

--计算玩家的获胜分数
function GameViewLayer:caleSelfWinScore(tax)
    local _REWARD        = {2, 9, 2, 3, 3, 33, 12, 12}

    -- 处理现有的筹码对象列表
    local countXian  = BaccaratDataMgr.getInstance():getCardCount(BaccaratDataMgr.ePlace_Xian)
    local pointXian  = BaccaratDataMgr.getInstance():getResultPoints(BaccaratDataMgr.ePlace_Xian, countXian)
    local countZhuang = BaccaratDataMgr.getInstance():getCardCount(BaccaratDataMgr.ePlace_Zhuang)
    local pointZhuang = BaccaratDataMgr.getInstance():getResultPoints(BaccaratDataMgr.ePlace_Zhuang, countZhuang)

    -- 0胜 1负 2平
    local winArea = {
        [1] = pointZhuang < pointXian, --闲
        [2] = pointZhuang == pointXian, --平
        [3] = pointZhuang > pointXian, --庄
        [4] = pointXian > 7, --闲天王
        [5] = pointZhuang > 7, --庄天王
        [6] = BaccaratDataMgr.getInstance():getResultIsTongDianPing(), --同点平
        [7] = BaccaratDataMgr.getInstance():getResultIsTwoPair(BaccaratDataMgr.ePlace_Xian), --闲对
        [8] = BaccaratDataMgr.getInstance():getResultIsTwoPair(BaccaratDataMgr.ePlace_Zhuang), --庄对
    }

    if winArea[2] or winArea[6] then
        _REWARD[1] = 1
        _REWARD[3] = 1
        winArea[1] = true
        winArea[3] = true
    end
    
    local myWinScore = 0
    local myBetScore = BaccaratDataMgr.getInstance():getMyAllBetValue()

    for i = 1, AreaCount do
        if winArea[i] then --胜
            myWinScore = myWinScore + _REWARD[i] * BaccaratDataMgr.getInstance():getMyBetValueAtIndex(i)
        end
    end

--    local ret = myWinScore - myBetScore 

--    return ret > 0 and ret * tax or ret

    return myWinScore - myBetScore 

end

function GameViewLayer:doSomethingLater( call, delay )
    self.m_rootUI:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(call)))
end

--获取玩家下注筹码起始坐标
function GameViewLayer:getSelfChipBeginPos(score)
    local idx = BaccaratDataMgr.getInstance():getJettonIndexByValue(score)
    return cc.p(self.m_flyChipPos[idx])
end

        -----------------------------------------------------------------------------------


--计时器更新
function GameViewLayer:OnClockUpdata()
    self.m_pLbTimerNum:setString(tostring(self.daojishi_Num))
    if self.daojishi_Num == 3 then
--        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(daojishi_1)  
        local armature = ccs.Armature:create("daojishi_1")  
        armature:setPosition(667,375)          
        self.m_nodeZCAni:addChild(armature)
        armature:getAnimation():playWithIndex(0)
    end
    self.daojishi_Num = self.daojishi_Num - 1    
end

--清除下注金额显示
function GameViewLayer:cleanBetNum()
    self.m_pLbTotalBet:setString("")
    --每个区域的下注额
    for i = 1, AreaCount do
        self.m_pLbAreaTotal[i]:setString("")
        self.m_pLbSelfTotal[i]:setString("")
    end
end

--得到整数部分
function GameViewLayer:getIntValue(num)
    local tt = 0
    num,tt = math.modf(num/1);
    return num
end

--function GameViewLayer:getMembers()
--    return  otherplayer
--end

function GameViewLayer:clearn()
    for i=1,8 do
        self.m_pLbAreaTotal[i]:setVisible(false)
        self.m_pLbSelfTotal[i]:setVisible(false)
    end
    self.m_mybet = {}
    self.money = 0
    self.m_llMyBetValue = {0,0,0,0,0,0,0,0}
    self.m_pLbTotalBet:setString("0"):setVisible(false)
    BaccaratDataMgr.getInstance():cleanMyBetValue()
    --停止所有动画
    self:stopAllActions()

    --清理显示的筹码
    self:cleanChip()

    --清理转场动画
    self:cleanZhuanChangAni()

    --清理扑克动画
    self:cleanCardAni()

    --清理下注金额显示
    self:cleanBetNum()

    --隐藏所有闪烁获胜动画
    self:hideAllAreaBlink()

    self.ColorList = {}
    self.allchipList = {{},{},{},{},{},{},{},{},}
end

function GameViewLayer:onExit()
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._ClockFun) 
    if self._FaPaiActionFun then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._FaPaiActionFun) 
    end
    if self._XuyaFun then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._XuyaFun)
    end
    
    for i = 1 ,#BaccaratRes.vecReleaseAnim  do
        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(BaccaratRes.vecReleaseAnim[i])
    end
end
return GameViewLayer