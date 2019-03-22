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

local ChipOffSet         = 12 -- 筹码选中状态位移
local CardTypeAniName    = {"Animationdanzhang", "Animationduizi", "Animationshunzi", "Animationjinhua", "Animationshunjin", "Animationbaozi"} -- { "单牌","对子","顺子","金花","顺金","豹子", }

local JETTON_ITEM_COUNT  = 6
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

----region 初始化
--function GameViewLayer.create()
--    local GameViewLayer = GameViewLayer:new()
--    GameViewLayer:init()
--    return GameViewLayer
--end

function GameViewLayer:ctor(scene)
    math.randomseed(os.time())
    self:enableNodeEvents()
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
    self.m_pathUI = cc.CSLoader:createNode(RedVsBlackRes.CSB_GAME_MAIN)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0, diffY))
    self.m_pathUI:addTo(self.m_rootUI)
    self.isNewView = true
    self._scene = scene
    self:init()
     
end

function GameViewLayer:init()
    self.initUserData()
    math.randomseed(tostring(os.time()):reverse():sub(1,7))
    self.isOpenMenu = false
    self.m_flychipidx = 0
    self.nIndexChoose = 0 -- 当前选择的筹码索引
    self.m_myBetMoney = {}
    for i = 1, 3 do
        self.m_myBetMoney[i] = 0
    end
    --self.m_pStatu = nil -- 筹码光环特效
    self.m_isPlayDaojishi = false
    self.m_nSoundClock = nil
    self.m_cardImgList = {} -- 发牌位置的6张显示用背面牌
    self.m_pokerList = {} -- 发牌位置的6张显示用正面牌
    self.m_pArmDispatch = {} -- 翻牌动画对象
    self.m_pArmCardType = {} -- 牌型动画
    self.m_pLbMyBettingGold = {}
    self.m_pLbBettingGold = {}
    self.m_pControlButtonJetton = {}
    self.m_flyJobVec        = {} --飞行筹码任务清空
    self.m_pWinAreaImg = {}
    self.m_isPlayBetSound = false -- 是否正在播放下注音效
    self.m_zhuanchangAniState = 0 -- 转场动画播放状态 0 未播放 1 开始下注 2 停止下注 3 等待下一局
    self.m_pWinnerTable = nil
    self.m_pCardTypeTable = nil
    self.m_randmChipOthers = { {}, {}, {} } -- 三个地区随机投注点 顺序 黑 红 幸运
    self.m_randmChipSelf = { {}, {}, {} } -- 三个地区随机投注点 顺序 黑 红 幸运
    self.m_betChipSpSelf = { {}, {}, {} } -- 自己的三个地区投注筹码精灵 { jettonIndex =  筹码索引, pChipSpr =  筹码精灵对象, pos = 坐标 }
    self.m_betChipSpOthers = { {}, {}, {} } -- 他人的三个地区投注筹码精灵
    self.m_chipAreaRect = {} --筹码放置范围
    self.m_cardPosArr = {} --发牌坐标
    self.m_chipPosArr = {} --筹码原始坐标

    self:initViewNode()

    --分辨率自适应
    self:setNodeFixPostion()

    self:resetChipPos()

    for i = 1 , #RedVsBlackRes.vecReleaseAnim  do
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(RedVsBlackRes.vecReleaseAnim[i])
    end

    --三个飞金币的坐标
    local x, y = self.m_panel_self:getPosition()
    self.m_selfChipPos = cc.p(x + 23, y + 32)
    local x1, y1 = self.m_panel_other:getPosition()
    local x2, y2 = self.m_pBtnOthers:getPosition()
    self.m_otherChipPos = cc.p(x1 + x2, y1 + y2)
    self.m_bankerChipPos = cc.p(self.m_pNodeChipSpr:getChildByName("Node_banker"):getPosition())

    --牌型动画坐标
    local _cardTypeNode = self.m_rootNode:getChildByName("Node_cardtype")
    self.m_typeAniBlackPos = cc.p(_cardTypeNode:getChildByName("Node_typeblack"):getPosition())
    self.m_typeAniRedPos = cc.p(_cardTypeNode:getChildByName("Node_typered"):getPosition())
    _cardTypeNode:removeFromParent()

    --弹出菜单裁剪区域
    local shap = cc.DrawNode:create()
    local pointArr = {cc.p(1120,430), cc.p(1330, 430), cc.p(1330, 650), cc.p(1120, 650)}
    shap:drawPolygon(pointArr, 4, cc.c4f(255, 255, 255, 255), 2, cc.c4f(255, 255, 255, 255))
    self.m_pClippingMenu = cc.ClippingNode:create(shap)
    self.m_pClippingMenu:setPosition(cc.p(0,0))
    self.m_rootNode:addChild(self.m_pClippingMenu, G_CONSTANTS.Z_ORDER_COMMON + 1)
    self.m_pNodeMenu:removeFromParent()
    self.m_pClippingMenu:addChild(self.m_pNodeMenu)
    self.m_pNodeMenu:setVisible(false)

    --需要格式化名字
    local _bg_self = self.m_panel_self:getChildByName("Sprite_bg")
    local m_pLbUsrNickName = _bg_self:getChildByName("Text_mynick")
    local strName = PlayerInfo.getInstance():getUserName()
    m_pLbUsrNickName:setString(strName)

    --需要格式化金币
    self.m_pLbUsrGold:setString(tostring((PlayerInfo.getInstance():getUserScore())))

    RedVsBlackDataManager.getInstance():synEnterSceneTs()
    local curnum = RedVsBlackDataManager.getInstance():getTimeCount() or "20"
    if curnum > 20 then curnum = 20 end
    self.m_pLbCountTime:setString(curnum)

    self:doSomethingLater(function()
        local bVisible = RedVsBlackDataManager.getInstance():getGameStatus() == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_WAIT
    end, 0.5)
    self.m_zhuanchangAni =  ccs.Armature:create(RedVsBlackRes.ANI_ZHUANCHANG)
    self.m_zhuanchangAni:setAnchorPoint(0.5, 0.5)
    self.m_zhuanchangAni:setPosition(cc.p(667, 345))
    self.m_zhuanchangAni:setVisible(false)
    self.m_nodeAni:addChild(self.m_zhuanchangAni, G_CONSTANTS.Z_ORDER_COMMON)

    self.m_countAni = ccs.Armature:create(RedVsBlackRes.ANI_DAOJISHI)
    self.m_countAni:setPosition(cc.p(667, 345))
                   :addTo(self.m_nodeAni)
                   :setVisible(false)
    -- 筹码光晕创建至一个不可见位置
--    self.m_pStatu = Effect.getInstance():creatEffectWithDelegate(self.m_panel_betarea, "choumaxuanzhongguangxiao_shoujiban", 0, true,  cc.p(-1000,-1000))
--    self.m_pStatu:setVisible(false)

    self:initView()
    --self:initAlreadyJettion()
    self:initClipNode()
    self:initNPCAni()

    local minBankerScore = RedVsBlackDataManager.getInstance():getMinBankerScore()
    self.m_pLbBankerGoldNeed:setString((minBankerScore))

    --通知银行可用状态
    self:notifyBankEnable()

    --刷新其他玩家数量
    self:updateOtherNum()

    self:flyIn()

end

function GameViewLayer:onEnter()
    
    self:initEvent()
    self:startGameEvent()
    self:onMsgCountDown()
end

function GameViewLayer:onExit()
    self:cleanEvent()
    self:stopGameEvent()
    self:removeAllChildren()

    PlayerInfo.getInstance():setSitSuc(false)
end

--------------------------------------------------------------------接受消息--------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------------------------------------------------
function GameViewLayer:event_GameState(dataBuffer)         -- 进入{[1]=66750020 [2]="买卖QQ8646877" [3]=3 [4]=0 [5]=2554.88 [6]=8 }
    RedVsBlackDataManager.getInstance():setGameStatus(dataBuffer.step)
    --玩家列表
    for k , v  in ipairs(dataBuffer.members) do
        RedVsBlackDataManager.getInstance():setRankUser(v)
    end
    self.m_pLbOtherNum:setString("("..table.nums(dataBuffer.members)..")")
    --庄家
    RedVsBlackDataManager.getInstance():setBankerUserId(dataBuffer.win_man[1])
    RedVsBlackDataManager.getInstance():setBankerName(dataBuffer.win_man[2])
    RedVsBlackDataManager.getInstance():setBankerGold(dataBuffer.win_man[5])
    self:onMsgUpdateBnakerInfo()
    --筹码
    for i=1,tonumber(5),1 do
        print(dataBuffer.chips[i])
        RedVsBlackDataManager.getInstance():setJettonScore(i, dataBuffer.chips[i]);
    end
    self:updateJettonState()
    --历史记录
    for i = 1,#dataBuffer.path do   
        local tmp = {
                    bWin = 0 ,
                    bCardType = 0 ,
                }

        tmp.bWin = dataBuffer.path[i][1] - 1
        tmp.bCardType = dataBuffer.path[i][2]
        RedVsBlackDataManager.getInstance():addHistoryToList(tmp)
    end
    RedVsBlackDataManager.getInstance():synTmpHistory()
    self:refreshHistoryView()
    

--    self:initAlreadyJettion()

    RedVsBlackDataManager.getInstance():setTimeCount(self:getIntValue(dataBuffer.timeout))
    self:onMsgGameScene()
    self:onMsgUpdateGameStatue()
    
end
function GameViewLayer:intoBetMoney(dataBuffer)    -- 下注
    RedVsBlackDataManager.getInstance():setGameStatus(1)
    RedVsBlackDataManager.getInstance():setTimeCount(dataBuffer.timeout)
   self:onMsgUpdateGameStatue()
end
function GameViewLayer:onGameEnd(dataBuffer)      -- 结算dataBuffer.win_zodic{[1]=-1 [2]=1 [3]=-1 }dataBuffer.cards[1][1]{[1]=39 [2]=9 [3]=32 }
    RedVsBlackDataManager.getInstance():setGameStatus(2)
    RedVsBlackDataManager.getInstance():setTimeCount(dataBuffer.timeout)
    -- 牌的信息
    local DataCards = {
                        wOpenCards = {},
                        wWinIndex = 0,
                        cbLuckyBeat = 0,
                        wWinCardType = {},
                       }
    if dataBuffer.win_zodic[1] == 1 and dataBuffer.win_zodic[2] == -1 then
        DataCards.wWinIndex = 0
    elseif dataBuffer.win_zodic[1] == -1 and dataBuffer.win_zodic[2] == 1 then
        DataCards.wWinIndex = 1
    end
    if dataBuffer.win_zodic[3] > 0 then
        DataCards.cbLuckyBeat = 1
    else
         DataCards.cbLuckyBeat = 0
    end
    for i = 2, 1 ,-1 do
        table.insert( DataCards.wWinCardType , 1 , dataBuffer.cards[i][2]  )
        for j = 3 , 1 ,-1 do
            table.insert( DataCards.wOpenCards , dataBuffer.cards[i][1][j] )
        end  
    end  
    RedVsBlackDataManager.getInstance():addOpenData(DataCards)
    -- 庄家信息
--    RedVsBlackDataManager.getInstance():setBankerGold()--庄家金币
--    RedVsBlackDataManager.getInstance():setBankerCurrResult()--庄家输赢
    -- 自己信息
    if RedVsBlackDataManager.getInstance():isBanker() then
--        RedVsBlackDataManager.getInstance():setSelfCurrResult()--庄家输赢
--        PlayerInfo.getInstance():setUserScore()--庄家金币
    else
        local curVal = dataBuffer.mywin
        RedVsBlackDataManager.getInstance():setSelfCurrResult(curVal)
        PlayerInfo.getInstance():setUserScore(PlayerInfo.getInstance():getUserScore() + dataBuffer.mywin)
        if curVal == 0 then
            RedVsBlackDataManager.getInstance()._vecUsrChipContinue = {}
        end
    end
    local bankresult = 0
    for i = 1, #dataBuffer.moneys do
--        if dataBuffer.moneys[i][1] == GlobalUserItem.tabAccountInfo.userid then
--            dump(dataBuffer.moneys[i])
--        end
        local moneys = dataBuffer.moneys[i][4];
        bankresult = bankresult + moneys
    end
    RedVsBlackDataManager.getInstance():setBankerCurrResult(bankresult)--庄家输赢
--    print("***********"..dataBuffer.mywin.."**************")
    self:onMsgGameEnd()
    self:onMsgUpdateGameStatue()
    
end
function GameViewLayer:onDeskOver(dataBuffer)        -- 空闲
    RedVsBlackDataManager.getInstance():setGameStatus(3)
    RedVsBlackDataManager.getInstance():setTimeCount(dataBuffer)
    RedVsBlackDataManager.getInstance():updateBetContinueRec()
    self:onMsgUpdateGameStatue()
end

function GameViewLayer:otherBetMoney(dataBuffer)--{[1]=1 [2]=50 [3]=123173021 [4]=50 [5]=1697.06 }
    print("\n玩家Id："..dataBuffer[3].."\n下注区域   "..dataBuffer[1].."\n下注金额   "..dataBuffer[4].."\n该区域总钱数为："..dataBuffer[2].."\n该玩家持有金币数为："..dataBuffer[5] )
    local lastChip = {};
    if dataBuffer[4] == 1 then lastChip.wJettonIndex = 1
    elseif dataBuffer[4] == 5 then lastChip.wJettonIndex = 2
    elseif dataBuffer[4] == 10 then lastChip.wJettonIndex = 3
    elseif dataBuffer[4] == 50 then lastChip.wJettonIndex = 4
    elseif dataBuffer[4] == 100 then lastChip.wJettonIndex = 5
    elseif dataBuffer[4] == 500 then lastChip.wJettonIndex = 6
    end

    lastChip.wChipIndex = dataBuffer[1] + 1
    lastChip.wChairID = dataBuffer[3]
    RedVsBlackDataManager.getInstance():pushOtherUserChip(lastChip)
    RedVsBlackDataManager.getInstance():setAllChip(lastChip.wChipIndex,dataBuffer[2])
    self:onMsgGameChip()
end
function GameViewLayer:myBetMoney(dataBuffer)--{[1]=5 [2]=0 [3]=819 [4]=92.1 }
    print("\n本人".."\n下注区域   "..dataBuffer[2].."\n下注金额   "..dataBuffer[1].."\n该区域总钱数为："..dataBuffer[3].."\n该玩家持有金币数为："..dataBuffer[4])
    local lastChip = {};
    if     dataBuffer[1] == 1   then lastChip.wJettonIndex = 1
    elseif dataBuffer[1] == 5   then lastChip.wJettonIndex = 2
    elseif dataBuffer[1] == 10  then lastChip.wJettonIndex = 3
    elseif dataBuffer[1] == 50  then lastChip.wJettonIndex = 4
    elseif dataBuffer[1] == 100 then lastChip.wJettonIndex = 5
--    elseif dataBuffer[1] == 500 then lastChip.wJettonIndex = 6
    end

    lastChip.wChipIndex = dataBuffer[2] + 1
    lastChip.wChairID = GlobalUserItem.tabAccountInfo.userid
    RedVsBlackDataManager.getInstance():addUsrChip(lastChip)

    self.m_pLbUsrGold:setString(dataBuffer[4])
    PlayerInfo.getInstance():setUserScore(dataBuffer[4])

    self.m_myBetMoney[lastChip.wChipIndex] = self.m_myBetMoney[lastChip.wChipIndex] + dataBuffer[1]
    RedVsBlackDataManager.getInstance():setMyAllChip(lastChip.wChipIndex,self.m_myBetMoney[lastChip.wChipIndex])
    RedVsBlackDataManager.getInstance():setAllChip(lastChip.wChipIndex,dataBuffer[3])

    self:onMsgGameChip()
end

function GameViewLayer:Nomoney(dataBuffer)
    FloatMessage.getInstance():pushMessageForString("钱数不足"..dataBuffer.."无法上庄!!")
end
function GameViewLayer:updealer(dataBuffer) -- 上庄
    RedVsBlackDataManager.getInstance():addBankerList(dataBuffer[1])
    self:event_BankerList()
end
function GameViewLayer:downDealers(dataBuffer) -- 下庄
    RedVsBlackDataManager.getInstance():delBankerList(dataBuffer[1])
    self:event_BankerList()
end
function GameViewLayer:updataDealers(dataBuffer) -- 换庄
    for k,v in ipairs(RedVsBlackDataManager.getInstance():getRankUserByIndex()) do       
        if v[1] == dataBuffer[1][1] then
            RedVsBlackDataManager.getInstance():setBankerScore(v[6])
        end     
    end
    RedVsBlackDataManager.getInstance():setBankerName(dataBuffer[1][2])
    RedVsBlackDataManager.getInstance():clearBankerList()
    for k,v in ipairs(dataBuffer) do
        RedVsBlackDataManager.getInstance():addBankerList(v[1])
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
            self.m_pLbOtherNum:setString("("..RedVsBlackDataManager.getInstance():getRankUserSize()..")")
        end
    else
        for key, player in ipairs(RedVsBlackDataManager.getInstance():getRankUser()) do
            if player[1] == player_ then
                table.remove(RedVsBlackDataManager.getInstance():getRankUser(),key)
                self.m_pLbOtherNum:setString("("..RedVsBlackDataManager.getInstance():getRankUserSize()..")")
            end
        end
    end
    
end

function GameViewLayer:updataMyMoney(args)
    self.m_pLbUsrGold:setString(args)
    PlayerInfo.getInstance():setUserScore(args)
end

        --------------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------消息完毕--------------------------------------------------------------------

function GameViewLayer:initViewNode()
    self.m_rootNode          = self.m_pathUI:getChildByName("Panel_root")
    self.m_nodeTop           = self.m_rootNode:getChildByName("Node_top")
    self.m_panel_self        = self.m_rootNode:getChildByName("Panel_selfarea")
    local _bg_self           = self.m_panel_self:getChildByName("Sprite_bg")
    local _panel_dealer      = self.m_nodeTop:getChildByName("Panel_dealer"):getChildByName("Image_bg") --- 庄家
    _panel_dealer:setVisible(false)
    local strJson = string.format("game/redvsblack/effect/honghei/heihong.json")
    local strAtlas = string.format("game/redvsblack/effect/honghei/heihong.atlas")
    background = sp.SkeletonAnimation:create(strJson, strAtlas)
    background:setPosition(cc.p(473, 705))
    background:setAnimation(0, "animation", true)
    self.m_nodeTop:getChildByName("Panel_dealer"):addChild(background,100)
    
    self.m_deskbg            = self.m_rootNode:getChildByName("Node_bg"):getChildByName("Image_desk")
    self.m_panel_clock       = self.m_rootNode:getChildByName("Panel_clock")
    self.m_nodeAni           = self.m_rootNode:getChildByName("Node_ani")
    self.m_panel_betarea     = self.m_rootNode:getChildByName("Panel_betarea")
    local _panel_desk        = self.m_rootNode:getChildByName("Panel_desk")
    local _panel_history     = self.m_rootNode:getChildByName("Panel_history")
    self.m_panel_card        = self.m_rootNode:getChildByName("Panel_Card")
    self.m_panel_winner      = _panel_history:getChildByName("Panel_winnerlist")
    self.m_panel_cardtype    = _panel_history:getChildByName("Panel_cardtype")
    self.m_nodeClip          = self.m_rootNode:getChildByName("Panel_node_clip")
    self.m_nodeDlg           = self.m_rootNode:getChildByName("Panel_dialog")
    self.m_pNodeMenu         = self.m_rootNode:getChildByName("Node_menu")
    self.m_menuBG            = self.m_pNodeMenu:getChildByName("Image_menubg")
    self.m_pLbUsrGold        = _bg_self:getChildByName("Node_scale"):getChildByName("Text_mygold")
    self.m_pBtnBank          = _bg_self:getChildByName("Btn_bank")
    self.m_pBtnBank:setVisible(false)
    local _Img_times         = _panel_dealer:getChildByName("Img_times")
    self.m_pLbBankerTimes    = _Img_times:getChildByName("Text_dealnum")
    self.m_pLbBankerApplyStr = _panel_dealer:getChildByName("Text_applyStr") 
    self.m_pLbZhuangGold     = _panel_dealer:getChildByName("Text_dealergold")
    self.m_pNodeClock        = self.m_panel_clock:getChildByName("Img_clock")
    self.m_pLbankneedgold    = _panel_dealer:getChildByName("Text_needgold")
    self.m_pLapplynum        = _panel_dealer:getChildByName("Text_applynum")
    self.m_pLbCountTime      = self.m_pNodeClock:getChildByName("Text_clocknum")
    self.m_pImgState         = self.m_pNodeClock:getChildByName("Image_state")
    self.m_pIconState        = self.m_pNodeClock:getChildByName("Image_icon")
    local node2              = self.m_pLbCountTime:getParent()
    local pos3               = cc.p(self.m_pLbCountTime:getPosition())
    self.m_nodeAniBlack      = self.m_rootNode:getChildByName("Node_aniblack")
    self.m_nodeAniRed        = self.m_rootNode:getChildByName("Node_anired")

    --筹码层
    self.m_pNodeChipSpr = self.m_rootNode:getChildByName("Panel_chip")
    --self.m_pNodeChipSpr:setLocalZOrder(3)

    --飞筹码范围
    for i = 1, DOWN_COUNT_HOX do
        local chiparea = self.m_pNodeChipSpr:getChildByName("chiparea_" .. i)
        local x, y = chiparea:getPosition()
        self.m_chipAreaRect[i] = cc.rect(x, y, chiparea:getContentSize().width, chiparea:getContentSize().height)
    end

    --发牌位置
    for i = 1, JETTON_ITEM_COUNT do
        local cardNode = self.m_panel_card:getChildByName("Card_" .. i)
        self.m_cardPosArr[i] = cc.p(cardNode:getPosition())
    end

    -- 牌桌胜利闪烁图片对象资源
    self.m_pWinAreaImg[1] = _panel_desk:getChildByName( "Img_redarea_lighter" )

    self.m_pWinAreaImg[2] = _panel_desk:getChildByName( "Img_blackarea_lighter" )

    self.m_pWinAreaImg[3] = _panel_desk:getChildByName( "Img_luckyarea_lighter" )

    -- 压注数量
    for i = 1, DOWN_COUNT_HOX do 
        self.m_pLbMyBettingGold[i] = self.m_deskbg:getChildByName( string.format("Text_my_bet_num%d",i) )
        self.m_pLbMyBettingGold[i]:setVisible(false)
        self.m_pLbBettingGold[i] = self.m_deskbg:getChildByName( string.format("Text_total_bet_num%d",i) )
    end

    -- 提升押注筹码节点的层级 避免被下注筹码动画盖住
    self.m_panel_betarea:setLocalZOrder(4)
    for i = 1, 5 do
        self.m_pControlButtonJetton[i] = self.m_panel_betarea:getChildByName( string.format("Btn_jetton_%d",i) )
        self.m_pControlButtonJetton[i]:addClickEventListener(handler(self,function()
            self:onBetNumClicked(i, true)
        end))
        self.m_chipPosArr[i] = cc.p(self.m_pControlButtonJetton[i]:getPosition())
    end
    self.m_panel_betarea:getChildByName( string.format("Btn_jetton_%d",6) ):setVisible(false)
    for i = 1, DOWN_COUNT_HOX do
        local func = handler(self,function() self:onAnimalClicked(i) end)
        _panel_desk:getChildByName( string.format("Btn_bet%d",i)):addClickEventListener(func)
        _panel_desk:getChildByName( string.format("Btn_betsub%d",i)):addClickEventListener(func)
        _panel_desk:getChildByName( string.format("Btn_betsubb%d",i)):addClickEventListener(func)
    end
    
    self.m_pBtnContinue = self.m_rootNode:getChildByName("Btn_xt")
    self.m_pBtnContinue:addClickEventListener(handler(self,self.onBetContinueClicked))

    self.m_pDealerBtn = _panel_dealer:getChildByName("Btn_dealerup")
    self.m_pDealerBtn:addClickEventListener(handler(self,self.onDealerClicked))

    self.m_pDealerdownBtn = _panel_dealer:getChildByName("Btn_dealerdown")
    self.m_pDealerdownBtn:addClickEventListener(handler(self,self.onDealerDownClicked)) 

    self.m_pRecordBtn = _panel_history:getChildByName("Btn_showhistory")
    self.m_pRecordBtn:addClickEventListener(handler(self,self.onRecordClicked))

    self.m_pBtnMenuPop = self.m_rootNode:getChildByName("Btn_menupop")
    self.m_pBtnMenuPop:addClickEventListener(handler(self,self.onPopClicked))
    self.m_pBtnMenuPop:setLocalZOrder(1)

    --全屏关闭按钮
    self.m_pBtnFullClose = self.m_nodeClip:getChildByName("Btn_close")
    self.m_pBtnFullClose:addClickEventListener(handler(self,self.onPushClicked))

    self.m_pBtnReturn = self.m_rootNode:getChildByName("Btn_return")
    self.m_pBtnReturn:addClickEventListener(handler(self,self.onReturnClicked))
    self.m_pBtnReturn:setLocalZOrder(1)

    self.m_pBtnBank2 = self.m_menuBG:getChildByName("Btn_menubank")
    self.m_pBtnBank2:addClickEventListener(handler(self,self.onBankClicked))
    self.m_pBtnBank2:setColor(cc.c3b(127,127,127))
    self.m_pBtnBank2:setEnabled(false)

    self.m_pRuleBtn = self.m_menuBG:getChildByName("Btn_rule")
    self.m_pRuleBtn:addClickEventListener(handler(self,self.onRuleClicked))

    self.m_pBtnSound = self.m_menuBG:getChildByName("Btn_sound")
    self.m_pBtnSound:addClickEventListener(handler(self,self.onSoundClicked))

    self.m_pVoiceBtn = self.m_menuBG:getChildByName("Btn_music") 
    self.m_pVoiceBtn:addClickEventListener(handler(self,self.onVoiceClicked))

    self.m_pLbZhuangName = _panel_dealer:getChildByName("Text_dealername")
    self.m_pLbBankerGoldNeed = _panel_dealer:getChildByName("Text_needgold")

    self.m_pBtnBank:addClickEventListener(handler(self,self.onBankClicked))

    self.m_panel_other = self.m_rootNode:getChildByName("Panel_other")
    self.m_pBtnOthers = self.m_panel_other:getChildByName("Btn_qtwj")
    self.m_pLbOtherNum = self.m_pBtnOthers:getChildByName("TXT_other_num")
    self.m_pBtnOthers:addClickEventListener(handler(self,self.onOtherInfoClicked))

    --房间号
--    local strRoomNo = string.format(LuaUtils.getLocalString("STRING_187"),PlayerInfo.getInstance():getCurrentRoomNo())
--    self.m_pLbRoomNo = cc.Label:createWithBMFont(RedVsBlackRes.FNT_ROOMNUMBER, strRoomNo)
--	self.m_pLbRoomNo:setAnchorPoint(cc.p(0, 0.5))
--	self.m_pLbRoomNo:setPosition(cc.p(25, 636))
--	self.m_rootNode:addChild(self.m_pLbRoomNo)

    --滚动消息位置
--    RollMsg.getInstance():setShowPosition(display.cx, display.height-96.0)

    self.m_pLbBankerApplyStr:setString(LuaUtils.getLocalString("RVB_TEXT_1"))

    self.m_pLbBankerTimes:setString(RedVsBlackDataManager.getInstance():getViewBankerTimes())
end

function GameViewLayer:initView()
    --音乐 
    local music = GlobalUserItem.bVoiceAble 
    if music then
        GlobalUserItem.setVoiceAble(true)
        ExternalFun.playGameBackgroundAudio(RedVsBlackRes.SOUND_OF_BGM)
        self.m_pVoiceBtn:loadTextureNormal(RedVsBlackRes.IMG_MUSIC_ON, ccui.TextureResType.plistType)
    else
        GlobalUserItem.setVoiceAble(false)
        self.m_pVoiceBtn:loadTextureNormal(RedVsBlackRes.IMG_MUSIC_OFF, ccui.TextureResType.plistType)
    end

    --音效
    local sound = GlobalUserItem.bSoundAble 
    if sound then
        GlobalUserItem.setSoundAble(true)
        self.m_pBtnSound:loadTextureNormal(RedVsBlackRes.IMG_SOUND_ON, ccui.TextureResType.plistType)
    else
        GlobalUserItem.setSoundAble(false)
        self.m_pBtnSound:loadTextureNormal(RedVsBlackRes.IMG_SOUND_OFF, ccui.TextureResType.plistType)
    end

    self:updateBetMoney()
    self:onMsgGameScene(nil)
    self:onMsgUpdateBnakerInfo(nil)
    self:UpdateCotinueAndClearBtState(false)
    RedVsBlackDataManager.getInstance():setContinue(false)

end

function GameViewLayer:initNPCAni()
    -- 国王动画
    self.m_pKingAni = ccs.Armature:create(RedVsBlackRes.ANI_KING)
    self.m_pKingAni:setAnchorPoint(0.5, 0.5)
                   :setPosition(cc.p(0, 0))
                   :addTo(self.m_nodeAniBlack)
                   :getAnimation():play("nomal")

    -- 王后动画
    self.m_pQueenAni = ccs.Armature:create(RedVsBlackRes.ANI_QUEEN)
    self.m_pQueenAni:setAnchorPoint(0.5, 0.5)
                    :setPosition(cc.p(0, 0))
                    :addTo(self.m_nodeAniRed)
                    :getAnimation():play("nomal")
end

--初始化弹出菜单剪切区域
function GameViewLayer:initClipNode()
    local _posx, _ =  self.m_pBtnMenuPop:getPosition()
    local shap = cc.DrawNode:create()
    local width = self.m_menuBG:getContentSize().width
    local pointArr = {cc.p(0,300), cc.p(width, 300), cc.p(width, 650), cc.p(0, 650)}
    shap:drawPolygon(pointArr, 4, cc.c4f(255, 255, 255, 255), 2, cc.c4f(255, 255, 255, 255))
    self.m_pClippingMenu = cc.ClippingNode:create(shap)
    
    local diffX = 0
    if _posx + width/2 > display.size.width then
        diffX = display.size.width - width
    else
        diffX = _posx - width/2
    end

    self.m_pClippingMenu:setPosition(cc.p(diffX,0))
    self.m_nodeClip:addChild(self.m_pClippingMenu, 1)
    self.m_menuBG:removeFromParent()
    self.m_pClippingMenu:addChild(self.m_menuBG)
end

--分辨率适配
function GameViewLayer:setNodeFixPostion()
    local diffX = 145-(1624-display.size.width)/2

    -- 根容器节点
    self.m_rootNode:setPositionX(diffX)

    if LuaUtils.isIphoneXDesignResolution() then
        --左侧节点
        self.m_panel_other:setPositionX(self.m_panel_other:getPositionX() - IPHONEX_OFFSETX)
        self.m_pBtnReturn:setPositionX(self.m_pBtnReturn:getPositionX() - IPHONEX_OFFSETX)
        self.m_panel_self:setPositionX(self.m_panel_self:getPositionX() - IPHONEX_OFFSETX)
--        self.m_pLbRoomNo:setPositionX(self.m_pLbRoomNo:getPositionX() - IPHONEX_OFFSETX)

        --右侧节点
        self.m_pBtnMenuPop:setPositionX(self.m_pBtnMenuPop:getPositionX() + IPHONEX_OFFSETX)
        self.m_pBtnContinue:setPositionX(self.m_pBtnContinue:getPositionX() + IPHONEX_OFFSETX)
    end
end

--初始化胜负图标列表
function GameViewLayer:initWinnerTable()
    self.m_pWinnerTable = cc.TableView:create(cc.size(708, 35))
--    self.m_pWinnerTable:setIgnoreAnchorPointForPosition(false)
    self.m_pWinnerTable:setAnchorPoint(cc.p(0,0))
    self.m_pWinnerTable:setPosition(cc.p(0,0))
    self.m_pWinnerTable:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.m_pWinnerTable:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.m_pWinnerTable:setTouchEnabled(true)
    self.m_pWinnerTable:setDelegate()
    self.m_pWinnerTable:setBounceable(false)
    self.m_panel_winner:addChild(self.m_pWinnerTable)

    local cellSizeForTable = function (table, idx)
        return 35.4, 32
    end

    local numberOfCellsInTableView = function (table)
        return 20
    end

    local tableCellAtIndex = function (table, idx)
        local cell = table:dequeueCell();
        if not cell then
            cell = cc.TableViewCell:new()
        else
            cell:removeAllChildren()
        end

        local curIDx = 0

        if RedVsBlackDataManager.getInstance():getHistoryListSize() < 20 then
            curIDx = idx + 1
        else
            curIDx = RedVsBlackDataManager.getInstance():getHistoryListSize() - 20 + idx + 1
        end

        local tmp = RedVsBlackDataManager.getInstance():getHistoryByIdx(curIDx)
        if tmp then
            local texturepath = 0 == tmp.bWin and RedVsBlackRes.IMG_POINT_RED or RedVsBlackRes.IMG_POINT_BLACK
            local newicon = cc.Sprite:createWithSpriteFrameName(texturepath)
            newicon:setAnchorPoint(0.5, 0.5)
            newicon:setPosition(17.7, 14)
            newicon:addTo(cell)
        end
        return cell
    end

    self.m_pWinnerTable:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.m_pWinnerTable:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.m_pWinnerTable:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
end

--初始化牌型列表
function GameViewLayer:initCardTypeTable()
    self.m_pCardTypeTable = cc.TableView:create(cc.size(711, 32))
--    self.m_pCardTypeTable:setIgnoreAnchorPointForPosition(false)
    self.m_pCardTypeTable:setAnchorPoint(cc.p(0,0))
    self.m_pCardTypeTable:setPosition(cc.p(0,0))
    self.m_pCardTypeTable:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.m_pCardTypeTable:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.m_pCardTypeTable:setTouchEnabled(true)
    self.m_pCardTypeTable:setDelegate()
    self.m_pCardTypeTable:setBounceable(false)
    self.m_panel_cardtype:addChild(self.m_pCardTypeTable)

    local cellSizeForTable = function (table, idx)
        return 79, 32
    end

    local numberOfCellsInTableView = function (table)
        return 9
    end

    local tableCellAtIndex = function (table, idx)
        local cell = table:dequeueCell();
        if not cell then
            cell = cc.TableViewCell:new()
        else
            cell:removeAllChildren()
        end

        local curIDx = 0

        if RedVsBlackDataManager.getInstance():getHistoryListSize() < 9 then
            curIDx = idx + 1
        else
            curIDx = RedVsBlackDataManager.getInstance():getHistoryListSize() - 9 + idx + 1
        end

        local tmp = RedVsBlackDataManager.getInstance():getHistoryByIdx(curIDx)
        if tmp then
            local texturepath = 1 == tmp.bCardType and RedVsBlackRes.IMG_TYPE_SINGLE or RedVsBlackRes.IMG_TYPE_NOSINGLE
            local newicon = cc.Sprite:createWithSpriteFrameName(texturepath)
            newicon:setAnchorPoint(0, 0)
            newicon:setPosition(0, 0)

            local typeStr = RedVsBlackDataManager.getInstance():getCardTypeDesc(tmp.bCardType)
            local label = cc.LabelTTF:create(typeStr, "Arial", 24)
            label:setAnchorPoint(0.5, 0.5)
            label:setPosition(cc.p(79/2, 16))
            label:addTo(newicon)
            newicon:addTo(cell)
        end
        return cell
    end

    self.m_pCardTypeTable:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.m_pCardTypeTable:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.m_pCardTypeTable:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
end

--刷新主界面历史记录显示
function GameViewLayer:refreshHistoryView()
    self.m_pWinnerTable:reloadData()
    self.m_pCardTypeTable:reloadData()

end

-- 显示现有筹码
function GameViewLayer:initAlreadyJettion()
    --self
--    local num = RedVsBlackDataManager.getInstance():getUsrChipCount()
--    for i = 1, num do
--        local selfChip = RedVsBlackDataManager.getInstance():getUsrChipByIdx(i)
--        self:createChipSprite(selfChip.wJettonIndex,selfChip.wChipIndex,true)
--    end
--    --other
--    for i = 1, DOWN_COUNT_HOX do
--        local totalVal = RedVsBlackDataManager.getInstance():getOtherChip(i)
--        while totalVal > 0 do
--            local index = RedVsBlackDataManager.getInstance():GetJettonMaxIdx(totalVal)
--            if index >= 1 then
--                local jettonVal = RedVsBlackDataManager.getInstance():getJettonScore(index)
--                totalVal = totalVal - jettonVal
--                self:createChipSprite(index,i,false)
--            end
--        end
--    end
end

--endregion

--region 事件绑定及实现

function GameViewLayer:initEvent()
--    self.event_ = --自定义事件：1.自定义；2.放到游戏内部；3.使用前缀；4.接收CMsgXX数据
--    {
--        --系统消息
--        [Public_Events.MSG_UPDATE_USER_SCORE]                = { func = self.onMsgGoldChange,        log = "玩家分数", },
--        [Public_Events.MSG_GAME_EXIT]                        = { func = self.onMsgExitGame,          log = "退出游戏", },
--        [Public_Events.MSG_NETWORK_FAILURE]                  = { func = self.onMsgNetWorkFailre,     log = "游戏掉线", },
--        [Public_Events.MSG_SHOW_SHOP]                        = { func = self.showChargeLayer,        log = "弹出充值", },

--        --游戏消息
--        [RedVsBlackEvent.MSG_REDVSBLACK_UPDATE_BANKER_INFO]  = { func = self.onMsgUpdateBnakerInfo,  log = "庄家信息", },
--        [RedVsBlackEvent.MSG_REDVSBLACK_SCENE_UPDATE]        = { func = self.onMsgGameScene,         log = "场景信息", },
--        [RedVsBlackEvent.MSG_REDVSBLACK_UDT_GAME_STATUE]     = { func = self.onMsgUpdateGameStatue,  log = "游戏状态", },
--        [RedVsBlackEvent.MSG_REDVSBLACK_GAME_END]            = { func = self.onMsgGameEnd,           log = "游戏结束", },
--        [RedVsBlackEvent.MSG_GAME_SHIP]                      = { func = self.onMsgGameChip,          log = "玩家下注", },
--        [RedVsBlackEvent.MSG_GAME_CONTINUE_SUCCESS]          = { func = self.onMsgGameContinueSuc,   log = "续投成功", },
--        [RedVsBlackEvent.MSG_REDVSBLACK_REQUEST_BANKER_INFO] = { func = self.onMsgRequestBnakerInfo, log = "申请上庄", },
--        [RedVsBlackEvent.MSG_UPDATE_BANKER_REQUESTLIST]      = { func = self.onMsgRequestBnakerInfo, log = "上庄列表", },
--        [RedVsBlackEvent.MSG_UPDATE_ROLL_MSG]                = { func = self.addRollMessageInfo,     log = "系统消息", },
--    }

--    local function onMsgUpdate_(event)  --接收自定义事件
--        local name = event:getEventName()
--        local msg = unpack(event._userdata)
--        local func = self.event_[name].func
--        func(self, msg)
--    end

--    for key in pairs(self.event_) do   --监听事件
--         SLFacade:addCustomEventListener(key, onMsgUpdate_, self.__cname) 
--    end

    self:initTimer()
end

function GameViewLayer:cleanEvent() --清理事件监听
--    for key in pairs(self.event_) do
--        SLFacade:removeCustomEventListener(key, self.__cname)
--    end
    if self._XuyaFun then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._XuyaFun)  
    end   
    --注销倒计时
    if self.timerHandle then
        scheduler.unscheduleGlobal(self.timerHandle)
    end
end

function GameViewLayer:startGameEvent()
--    self.event_game_ = {  
--        [Public_Events.MSG_GAME_NETWORK_FAILURE]  =  { func = self.onMsgEnterNetWorkFail, log = "网络中断"  ,   debug = true,},
--        [Public_Events.MSG_GAME_ENTER_BACKGROUND] =  { func = self.onMsgEnterBackGround,  log = "切换至后台",   debug = true, },
--        [Public_Events.MSG_GAME_ENTER_FOREGROUND] =  { func = self.onMsgEnterForeGround,  log = "切换至前台",   debug = true, },
--        [Public_Events.MSG_GAME_RELOGIN_SUCCESS]  =  { func = self.onMsgReloginSuccess,   log = "重登录成功",   debug = true, },
--    }
--    for key, event in pairs(self.event_game_) do   --监听事件
--         SLFacade:addCustomEventListener(key, handler(self, event.func), self.__cname)
--    end
end

function GameViewLayer:stopGameEvent()
--    for key in pairs(self.event_game_) do   --监听事件
--         SLFacade:removeCustomEventListener(key, self.__cname)
--    end
--    self.event_game_ = {}
    RedVsBlackDataManager.getInstance():clear()
    self:cleanPlayerData()

    --释放动画
    for i, name in pairs(RedVsBlackRes.vecReleaseAnim) do
        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(name)
    end
    --释放整图
    for i, name in pairs(RedVsBlackRes.vecReleasePlist) do
        display.removeSpriteFrames(name[1], name[2])
    end
    -- 释放背景图
    for i, name in pairs(RedVsBlackRes.vecReleaseImg) do
        display.removeImage(name)
    end
    --释放音频
    for i, name in pairs(RedVsBlackRes.vecReleaseSound) do
        AudioEngine.unloadEffect(name)
    end
end

function GameViewLayer:onMsgEnterNetWorkFail()
    self:onMsgEnterBackGround()
end

--进入后台
function GameViewLayer:onMsgEnterBackGround()
    self:cleanEvent()
    self:stopAllActions()

    --清空自己下注筹码
    self:clearVecSpriteSelf()

    --清空其他玩家下注筹码精灵
    self:clearVecSpriteOther()

    --清空筹码结算飞行任务
    self.m_flyJobVec = {}

    --停止牌动画
    for k,v in pairs(self.m_cardImgList) do
        if v then
            v:stopAllActions()
        end
    end

    RedVsBlackDataManager.getInstance():clear()
    self:cleanPlayerData()

end

--进入前台
function GameViewLayer:onMsgEnterForeGround()
end

--重登录成功
function GameViewLayer:onMsgReloginSuccess()
end

--注册倒计时
function GameViewLayer:initTimer()
    self.timerHandle = scheduler.scheduleGlobal(handler(self,self.onMsgCountDown), 1)
end

--打开充值
function GameViewLayer:showChargeLayer()
--    local pRecharge = RechargeLayer:create()
--    pRecharge:setPositionY((display.height - 750)/2)
--    pRecharge:addTo(self.m_rootUI, ZORDER_OF_MESSAGEBOX)
end

--上庄点击
function GameViewLayer:onDealerClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)

    --金币不足
    if PlayerInfo.getInstance():getUserScore() < RedVsBlackDataManager.getInstance():getMinBankerScore() then 
        local str = string.format(LuaUtils.getLocalString("STRING_239") , (RedVsBlackDataManager.getInstance():getMinBankerScore()))
        FloatMessage.getInstance():pushMessageForString(str)
        self:showMessageBox(LuaUtils.getLocalString("STRING_059"), MsgBoxPreBiz.PreDefineCallBack.CB_RECHARGE)
        return
    end

    --上庄
--    CMsgRedVsBlack.getInstance():sendMsgOfReqHost(true)
end

--下庄点击
function GameViewLayer:onDealerDownClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)

    --下庄
--    CMsgRedVsBlack.getInstance():sendMsgOfReqHost(false)
end

--显示历史记录
function GameViewLayer:onRecordClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
    --弹出记录弹窗
    local trendLayer = RedVsBlackTrendLayer:create()
    self.m_pathUI:addChild(trendLayer, G_CONSTANTS.Z_ORDER_TOP)
end

--规则
function GameViewLayer:onRuleClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
--    local CommonRule = require("common.layer.CommonRule")
--    local nKind = PlayerInfo.getInstance():getKindID()
--    local pRule = CommonRule.new(nKind)
--    pRule:addTo(self.m_rootUI, 5)
    local pRule = RedVsBlackRuleLayer.create()
    pRule:addTo(self.m_pathUI, 5)
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
        self:showMessageBox(LuaUtils.getLocalString("STRING_059"), MsgBoxPreBiz.PreDefineCallBack.CB_RECHARGE)
        return
    end

    if RedVsBlackDataManager.getInstance():checkCanBet(nIndex, RedVsBlackDataManager.getInstance():getLotteryBaseScore()) then
        local _data = {}
        _data.wChipIndex = nIndex - 1
--        _data.wJettonIndex = RedVsBlackDataManager.getInstance():getLotteryBaseScoreIndex()
        _data.wJettondata = RedVsBlackDataManager.getInstance():getJettonScore(RedVsBlackDataManager.getInstance():getLotteryBaseScoreIndex()+1)
--        CMsgRedVsBlack.getInstance():sendMsgOfChipStart(_data)
        self._scene:SendBet(_data)
    else
        FloatMessage.getInstance():pushMessage("RVB_WARN_3")
        return
    end
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

--银行
function GameViewLayer:onBankClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
    SLFacade:dispatchCustomEvent(Hall_Events.SHOW_OPEN_BANK,"openbank")
    -- 非投注状态不能操作保险箱
--    if RedVsBlackDataManager.getInstance():getGameStatus() ~= RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP then
--        FloatMessage.getInstance():pushMessage("BANK_30")
--        return
--    end

--    if PlayerInfo.getInstance():getIsInsurePass() == 0 then
--        FloatMessage.getInstance():pushMessage("STRING_033")
--        return
--    end

    --弹出银行界面
--    local ingameBankView = IngameBankView:create()
--    ingameBankView:setName("IngameBankView")
--    ingameBankView:setCloseAfterRecharge(false)
--    self:addChild(ingameBankView, 500)
end

--续投
function GameViewLayer:onBetContinueClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
    
    if RedVsBlackDataManager.getInstance():getGameStatus() ~= RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP then
        FloatMessage.getInstance():pushMessage("STRING_026")
        return
    end
    
    local count = RedVsBlackDataManager.getInstance():getUsrContinueChipCount()
    if count <= 0 then
        FloatMessage.getInstance():pushMessage("STRING_027")
        return
    end
    
--    if RedVsBlackDataManager.getInstance():getContinue() then
--        FloatMessage.getInstance():pushMessage("STRING_004")
--        return
--    end
    
    if RedVsBlackDataManager.getInstance():getBankerUserId() == PlayerInfo.getInstance():getUserID() then
        FloatMessage.getInstance():pushMessage("RVB_WARN_2")
        return
    end 
    
    local continueChip = {}
    continueChip.llDownTotal = {}
    for i = 1, DOWN_COUNT_HOX do
        continueChip.llDownTotal[i] = 0
    end
--    _vecUsrChipContinue
    local data = {}
    for i = 1, count do
        data[i] = {}
        data[i].wChipIndex = 0
        data[i].wJettondata = 0
    end
    
    local llSumScore = 0
    for i = 1, count do
        local chip = RedVsBlackDataManager.getInstance():getUsrContinueChipByIdx(i)
        if chip then
            local baseVale = RedVsBlackDataManager.getInstance():getJettonScore(chip.wJettonIndex)
            local score = continueChip.llDownTotal[chip.wChipIndex]
            continueChip.llDownTotal[chip.wChipIndex] = baseVale + score
            llSumScore = baseVale + llSumScore
            data[i].wChipIndex = chip.wChipIndex-1
            data[i].wJettondata = baseVale
        end
    end
    
    if PlayerInfo.getInstance():getUserScore() < llSumScore then
        --self:showMessageBox("message-box")
        self:showMessageBox(LuaUtils.getLocalString("STRING_059"), MsgBoxPreBiz.PreDefineCallBack.CB_RECHARGE)
        return
    end
    local index = 1   
    self._XuyaFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        if data[index] ~= nil then
            self._scene:SendBet(data[index])
        else
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._XuyaFun)  
        end 
        index = index+1               
    end, 0.2, false)
--    CMsgRedVsBlack.getInstance():sendMsgOfContinueChip(continueChip)
end

--弹出菜单
function GameViewLayer:onPopClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
    local str = self.isOpenMenu and RedVsBlackRes.IMG_MENU_POP or RedVsBlackRes.IMG_MENU_PUSH
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

--关闭菜单
function GameViewLayer:onPushClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
    if not self.isOpenMenu then return end

    local str = RedVsBlackRes.IMG_MENU_POP
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

--退出
function GameViewLayer:onReturnClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_CLOSE)
    if RedVsBlackDataManager.getInstance():isBanker() then
        if RedVsBlackDataManager.getInstance():getOtherAllChip() > 0 then
            FloatMessage.getInstance():pushMessage("RVB_WARN_4")
        else
            --没有投注纪录,直接退回游戏
            self:onMoveExitView(nil,nil,true)
        end
    else
        if RedVsBlackDataManager.getInstance():getUsrChipCount() <= 0
            or RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP > RedVsBlackDataManager.getInstance():getGameStatus() then
            --没有投注纪录,直接退回游戏
            self:onMoveExitView(nil,nil,true)
        else
            FloatMessage.getInstance():pushMessage("本轮游戏尚未结束，不能退出游戏！")
--            self:showMessageBox(LuaUtils.getLocalString("MESSAGE_27"), MsgBoxPreBiz.PreDefineCallBack.CB_EXITROOM)
        end
    end
end

--音效
function GameViewLayer:onSoundClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
    --音效
    local sound = GlobalUserItem.bSoundAble 
    if sound then
        GlobalUserItem.setSoundAble(false)
        
        self.m_pBtnSound:loadTextureNormal(RedVsBlackRes.IMG_SOUND_OFF,ccui.TextureResType.plistType)
    else
        GlobalUserItem.setSoundAble(true)
        self.m_pBtnSound:loadTextureNormal(RedVsBlackRes.IMG_SOUND_ON,ccui.TextureResType.plistType)
    end
end

--音乐
function GameViewLayer:onVoiceClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
    --音乐
    local music = GlobalUserItem.bVoiceAble 
    if music then
        GlobalUserItem.setVoiceAble(false)
        self.m_pVoiceBtn:loadTextureNormal(RedVsBlackRes.IMG_MUSIC_OFF, ccui.TextureResType.plistType)
    else
        --打开
        GlobalUserItem.setVoiceAble(true)
        ExternalFun.playGameBackgroundAudio(RedVsBlackRes.SOUND_OF_BGM)
        self.m_pVoiceBtn:loadTextureNormal(RedVsBlackRes.IMG_MUSIC_ON, ccui.TextureResType.plistType)
    end
end

--其他玩家信息
function GameViewLayer:onOtherInfoClicked()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BUTTON)
    --玩家列表
    local infoLayer = RedVsBlackOtherInfoLayer:create()
    self.m_nodeDlg:addChild(infoLayer,1)
end

--下注信息
function GameViewLayer:onMsgGameChip()
    -- 获取到下注成功消息 必定是处于下注状态，为了避免网络及其他原因造成的业务问题导致等待转场动画一直播放
    --print("m_zhuanchangAniState : " .. self.m_zhuanchangAniState)
    if self.m_zhuanchangAniState > 0 then -- 2秒后隐藏其他动画
        self:doSomethingLater(function()
            self.m_zhuanchangAni:setVisible(false)
            self.m_zhuanchangAniState = 0
        end, 2)
    end

    self:updateBetMoney()
    self:updateJettonState()
    self:updateChipSuc()
end

--续投成功
function GameViewLayer:onMsgGameContinueSuc(msg)
    self:updateBetMoney()

    if msg and msg.packet == "MyContinueSuc" then -- 自己续投
        local lContinueCount = RedVsBlackDataManager.getInstance():getUsrContinueChipCount()
        for i = 1, lContinueCount do
            local chip = RedVsBlackDataManager.getInstance():getUsrContinueChipByIdx(i)
            local beginPos = self:getBeginPosition(chip.wJettonIndex)
            self:createFlyChipSprite(chip.wJettonIndex,chip.wChipIndex,beginPos,true,false,0.35,false)
        end
        self:UpdateCotinueAndClearBtState(false)
        self:updateJettonState() -- 自己续投后 刷新筹码可选状态
    else -- 他人续投 (只有区域筹码总量，需要自己计算筹码组合)
        local othersVec = RedVsBlackDataManager.getInstance()._queueOtherUserContinueChip
        for i = 1, DOWN_COUNT_HOX do
            local tmp = othersVec[i]
            if nil ~= tmp and 0 < tmp.llTotalChipVale then
                local chipvec = RedVsBlackDataManager.getInstance():splitChip(tmp.llTotalChipVale)
                for m = 1, JETTON_ITEM_COUNT do
                    if nil ~= chipvec[m] then
                        for n = 1, chipvec[m] do
                            self:createFlyChipSprite(m,i,self.m_otherChipPos,false,false,0.35,true)
                        end
                    end
                end
            end
        end
    end
end

--游戏状态切换
function GameViewLayer:onMsgUpdateGameStatue()
    local status = RedVsBlackDataManager.getInstance():getGameStatus()
    if status == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_IDLE then
        print("空闲时间..........................")
        -- 如果有最新未处理历史记录可能就是玩家在开牌阶段加入的游戏 延迟显示结果
        if RedVsBlackDataManager.getInstance():getUnhandleHistory() then
            RedVsBlackDataManager.getInstance():synLastHistory()
--            local _event = {
--                name = RedVsBlackEvent.MSG_REDVSBLACK_UPDATE_HISTORY_INFO,
--                packet = nil,
--            }
--            SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_REDVSBLACK_UPDATE_HISTORY_INFO, _event)
        end
        self:refreshHistoryView()        
        self:resetChipPos()

    elseif status == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP then
        --清空自己下注筹码
        self:clearVecSpriteSelf()
        --清空其他玩家下注筹码精灵
        self:clearVecSpriteOther()
        --清空筹码结算飞行任务
        self.m_flyJobVec = {}

        self.m_pNodeChipSpr:removeAllChildren()
        self:stopBlinkWinArea()
        self:ClearOldBetScore()
        self:ClearOldCard()
        self:ClearOldAni()
        self:SendCard()
        self.m_pLbBankerTimes:setString(RedVsBlackDataManager.getInstance():getViewBankerTimes())
        print("投注时间..........................")
        --投注
        --为了避免网络及其他原因造成的业务问题导致等待转场动画一直播放
        --print("m_zhuanchangAniState : " .. self.m_zhuanchangAniState)
        if self.m_zhuanchangAniState > 0 then -- 2秒后隐藏其他动画
            self:doSomethingLater(function()
                self.m_zhuanchangAni:setVisible(false)
                self.m_zhuanchangAniState = 0
            end, 2)
        end
        self:showBeganBetAni()
        self:updateBtStateAtAward()
        self:exitResultView()

--        local _event = {
--            name = Public_Events.MSG_BANK_STATUS,
--            packet = "1",
--        }
--        SLFacade:dispatchCustomEvent(Public_Events.MSG_BANK_STATUS, _event)

    elseif status == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_END then
        self:stopLastTimeAni()
        print("开奖时间..........................")
        self.m_zhuanchangAniState = 0
        self.m_zhuanchangAni:setVisible(false)
        --self.m_pNodeClock:setVisible(false)
        --开奖
        self:updateBetMoney()
        self:showStopBetAni()
--        local _event = {
--            name = Public_Events.MSG_BANK_STATUS,
--            packet = "0",
--        }
--        SLFacade:dispatchCustomEvent(Public_Events.MSG_BANK_STATUS, _event)
    end

    --通知银行可用状态
    self:notifyBankEnable()
end

--更新庄家状态
function GameViewLayer:onMsgUpdateBnakerInfo()
    local llGold = RedVsBlackDataManager.getInstance():getBankerGold()
    self.m_pLbZhuangGold:setString((llGold))
    local strName = RedVsBlackDataManager.getInstance():getBankerName()
    local strNick = LuaUtils.getDisplayNickNameInGame(strName)
    self.m_pLbZhuangName:setString(strNick)
    self.m_pLbBankerTimes:setString(RedVsBlackDataManager.getInstance():getViewBankerTimes())
    local isBanker = RedVsBlackDataManager.getInstance():isBanker()
    local nRank = RedVsBlackDataManager.getInstance():isInBnakerList()
    if isBanker or (-1 == nRank) then
        self.m_pLbBankerApplyStr:setString(LuaUtils.getLocalString("RVB_TEXT_1"))
        self.m_pLapplynum:setString(RedVsBlackDataManager.getInstance():getBankerListSize())
    else
        self.m_pLbBankerApplyStr:setString(LuaUtils.getLocalString("RVB_TEXT_2"))
        self.m_pLapplynum:setString(nRank)
    end
    self:updateBankerButtonStatus(isBanker)
end

--用户金币变更信息
function GameViewLayer:onMsgGoldChange()
    if not self.m_pLbUsrGold then return end
    if RedVsBlackDataManager.getInstance():getGameStatus() == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_END then
        --self:playUserScoreEffect()
    else
        local curScore = PlayerInfo.getInstance():getUserScore()
        print("user score:" .. curScore)
        local strUsrBanlance = (curScore)
        self.m_pLbUsrGold:setString(tostring(strUsrBanlance))
    end
    self:updateJettonState()
end

--网络异常
function GameViewLayer:onMsgNetWorkFailre()
    FloatMessage.getInstance():pushMessage("STRING_023")
    self:onMoveExitView(nil,true,true)
end

--退出游戏
function GameViewLayer:onMsgExitGame()
    self:onMoveExitView(nil,nil,true)
end

--游戏结束(开始开奖)
function GameViewLayer:onMsgGameEnd()
    self:showStopBetAni()
    self:OpenCard()
    self:updateBtStateAtAward()
end

--申请庄家返回信息
function GameViewLayer:onMsgRequestBnakerInfo(msg)
    if not msg then return end
    local pStrChairID = tonumber(msg.packet)
    local isBanker = RedVsBlackDataManager.getInstance():isBanker()
    local nRank = RedVsBlackDataManager.getInstance():isInBnakerList()
    --print("我的申请上庄位置:" .. nRank)

    -- 切换坐庄按钮和提示文字
    if PlayerInfo.getInstance():getChairID() == pStrChairID then
        self:updateBankerButtonStatus(isBanker)
    end

    -- 我是庄家或我不在上庄列表 则显示实际人数 否则显示我前面的人数
    if isBanker or (-1 == nRank) then
        self.m_pLapplynum:setString( RedVsBlackDataManager.getInstance():getBankerListSize())
        self.m_pLbBankerApplyStr:setString(LuaUtils.getLocalString("RVB_TEXT_1"))
    else
        self.m_pLapplynum:setString(nRank)
        self.m_pLbBankerApplyStr:setString(LuaUtils.getLocalString("RVB_TEXT_2"))
    end
end

--进入游戏时调用
function GameViewLayer:onMsgGameScene()
    --更新上庄需要的金币
    local minBankerScore = RedVsBlackDataManager.getInstance():getMinBankerScore()
    self.m_pLbBankerGoldNeed:setString((minBankerScore))--forMinBankerGold)

    --第一次进默认最高筹码
    self:updateJettonState()

    --遍历最新历史20局数据 并添加在桌面显示上
    self:initWinnerTable()
    self:initCardTypeTable()
    self:refreshHistoryView()

    -- 显示申请上庄人数
    self.m_pLapplynum:setString( string.format("%d", RedVsBlackDataManager.getInstance():getBankerListSize()))
    --print("初始申请上庄人数:" .. RedVsBlackDataManager.getInstance():getBankerListSize())

    -- 显示上庄条件
    local bankerneedgold = RedVsBlackDataManager.getInstance():getMinBankerScore()
    self.m_pLbankneedgold:setString((bankerneedgold))

    -- 场景状态初始化
    self:viewUnOpenCard()
    if RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_WAIT == RedVsBlackDataManager.getInstance():getGameStatus() then -- 等待下一局
        self:showWaitBetAni(true)
    --elseif RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_IDLE == RedVsBlackDataManager.getInstance():getGameStatus() then -- 发牌时间
    --    self:viewUnOpenCard()
    --elseif RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP == RedVsBlackDataManager.getInstance():getGameStatus() then -- 正在下注
    --    self:viewUnOpenCard()
    elseif RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_END == RedVsBlackDataManager.getInstance():getGameStatus() then -- 已经开牌
        self:showWaitBetAni(true)
    end
end

--退出游戏
function GameViewLayer:onMoveExitView(gameID, noNeedStadUp, isShowGameList)
    if not noNeedStadUp then
--        CMsgRedVsBlack.getInstance():sendTableStandUp()
    end

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
--    SLFacade:dispatchCustomEvent(Public_Events.Load_Entry)
end

--倒计时
function GameViewLayer:onMsgCountDown(value)
    --每秒刷新其他玩家数量
--    self:updateOtherNum()

    --游戏状态
    if RedVsBlackDataManager.getInstance():getGameStatus() == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP then
        self.m_pImgState:loadTexture(RedVsBlackRes.IMG_GAMECHIP,ccui.TextureResType.plistType)
        self.m_pIconState:loadTexture(RedVsBlackRes.IMG_GAMECHIP_ICON,ccui.TextureResType.plistType)
        
    else
        self.m_pImgState:loadTexture(RedVsBlackRes.IMG_GAMEOPEN,ccui.TextureResType.plistType)    
        self.m_pIconState:loadTexture(RedVsBlackRes.IMG_GAMECHIP_OPEN,ccui.TextureResType.plistType)
    end

    --倒计时
    local ts = RedVsBlackDataManager.getInstance():getTimeCount()
    ts = ts < 1 and 0 or ts - 1
    RedVsBlackDataManager.getInstance():setTimeCount(ts)
    self.m_pLbCountTime:setString(("%d").format(ts))

    --显示最后3秒倒计时动画
    if ts < 4 
    and not self.m_isPlayDaojishi
    and RedVsBlackDataManager.getInstance():getGameStatus() == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP then
        self.m_isPlayDaojishi = true
        self:playLastTimeAni(ts)
    end
end

--endregion

--region UI刷新

--更新上庄按钮状态
function GameViewLayer:updateBankerButtonStatus(isBanker)
    -- 1 我是庄家 显示下庄
    -- 2 我不是庄家 但是在申请上庄列表中 显示下庄
    -- 3 我不是庄家 并且我没有申请上庄 显示上庄
    local isRequest = -1 ~= RedVsBlackDataManager.getInstance():isInBnakerList()
    local viewDown = isBanker or isRequest
    self.m_pDealerBtn:setVisible(not viewDown)
    self.m_pDealerdownBtn:setVisible(viewDown)
end

--更新续投按钮状态
function GameViewLayer:UpdateCotinueAndClearBtState(curState,isHide)
    if isHide then
        self.m_pBtnContinue:setVisible(true)
        self.m_pBtnContinue:setEnabled(false)
    else
        self.m_pBtnContinue:setVisible(true)
        if RedVsBlackDataManager.getInstance():isBanker() then
            self.m_pBtnContinue:setEnabled(false)
        else
            self.m_pBtnContinue:setEnabled(curState)
        end
    end
end

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
--        if self.m_pStatu then 
--            self.m_pStatu:setVisible(false)
--        end
        return
    end
    self.nIndexChoose = nIndex

     --设置当前筹码值
    local score = RedVsBlackDataManager.getInstance():getJettonScore(self.nIndexChoose)
    RedVsBlackDataManager.getInstance():setLotteryBaseScore(score)

    --筹码的位移
    for i=1,tonumber(5),1 do
        local _BTN_Chip = self.m_pControlButtonJetton[i]
        if self.nIndexChoose == i then
            _BTN_Chip:setPositionY(self.m_chipPosArr[i].y + ChipOffSet)
            --self.m_pStatu:setPosition(cc.p(_BTN_Chip:getPositionX(), _BTN_Chip:getPositionY()))
        else
            _BTN_Chip:setPositionY(self.m_chipPosArr[i].y)
        end
    end
    
    --选中筹码动画
    local canbet = RedVsBlackDataManager.getInstance():getGameStatus() == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP
    local notbanker = not RedVsBlackDataManager.getInstance():isBanker()
    --self.m_pStatu:setVisible(canbet and notbanker)
end

--显示已发牌背面
function GameViewLayer:viewUnOpenCard()
    self:clearCardList()
    for i = 1, 6 do
        local sp = cc.Sprite:createWithSpriteFrameName( RedVsBlackRes.IMG_POKER_BACKBG )
        if sp then
            sp:setAnchorPoint(cc.p(0.5,0.5))
            sp:setPosition(self.m_cardPosArr[i])
            sp:setScale(POKERSCALE)
            self.m_panel_card:addChild(sp,G_CONSTANTS.Z_ORDER_COMMON)     
            self.m_cardImgList[i] = sp
        end
    end
end

--显示下注筹码
function GameViewLayer:updateChipSuc()
    local len = #RedVsBlackDataManager.getInstance()._queueOtherUserChip
    local index = 1
    while len > 0 do
        local chipInfo = RedVsBlackDataManager.getInstance():getOtherUserChip(index)
        index = index + 1
        local isAndroid = chipInfo.bIsAndroid
        local isMyFly = chipInfo.bIsSelf
        local wUserChairId = chipInfo.wChairID
        local wChipIndex = chipInfo.wChipIndex
        local wJettonIndex= chipInfo.wJettonIndex
        local UserChairIndex = RedVsBlackDataManager.getInstance():GetArrTableIndexByChairId(wUserChairId)
        local beginPos = {}
        if isMyFly then
            beginPos = self:getBeginPosition(wJettonIndex)
        else
            beginPos = self:getBeginPositionForAllOther(UserChairIndex)
        end
        self.m_flychipidx = self.m_flychipidx + 1
        if self.m_flychipidx > 2 then self.m_flychipidx = 0 end
        self:createFlyChipSprite(wJettonIndex,wChipIndex,beginPos,isMyFly,isAndroid,0.35,true)
        if isMyFly then
            self:UpdateCotinueAndClearBtState(false)
            self:updateJettonState()
        end
        len = len  - 1
    end
    RedVsBlackDataManager.getInstance():clearOtherUserChip()
end

--更新筹码状态
function GameViewLayer:updateBtStateAtAward()
    --self:refreshJettonState()
    self:updateJettonState()
    
    local bShow = RedVsBlackDataManager.getInstance():getGameStatus() == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP and not RedVsBlackDataManager.getInstance():isBanker()
    if self.m_pBtnContinue then
        self.m_pBtnContinue:setEnabled(bShow)
    end

    local iShow = RedVsBlackDataManager.getInstance():getGameStatus() == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_END
    if self.m_pBtnBank then
        self.m_pBtnBank:setEnabled(not iShow)
    end

end

--结算信息
function GameViewLayer:exitResultView()

    self:updateBetMoney()
    self:checkIsShowContinuBt()
    
    local bankerScore = RedVsBlackDataManager.getInstance():getBankerGold()
    self.m_pLbZhuangGold:setString((bankerScore))
    print("--------void GameViewLayer::exitResultView()------------")
end

--更新续投按钮状态
function GameViewLayer:checkIsShowContinuBt()
    local isShow = true
    local countData = RedVsBlackDataManager.getInstance():getUsrContinueChipCount()
    if not countData or countData == 0 then
        isShow = false
    end
    self:UpdateCotinueAndClearBtState(isShow)
end

--其他玩家数量显示
function GameViewLayer:updateOtherNum()
--    local userTab = CUserManager.getInstance():getUserInfoInTable(PlayerInfo.getInstance():getTableID())
    self.m_pLbOtherNum:setString(string.format("(%d)", 0))
end

--更新下注金币
function GameViewLayer:updateBetMoney()
    local llTotalValue = 0
    for i = 1, DOWN_COUNT_HOX do
        --自己下注
        local llUserValue = RedVsBlackDataManager.getInstance():getMyAllChip(i)
        if llUserValue > 0 then
            self.m_pLbMyBettingGold[i]:setVisible(true)
            self.m_pLbMyBettingGold[i]:setString((llUserValue))
        end
        --单区域总下注
        local llValue = RedVsBlackDataManager.getInstance():getAllChip(i)
        self.m_pLbBettingGold[i]:setString((llValue))
    end
end
--endregion

--region 动画相关

--入场动画
function GameViewLayer:flyIn()
    local deskAniTime  = 0.3
    local otherAniTime = 0.4
    local offset = 15

    --下方筹码区域
    local posx, posy = self.m_panel_betarea:getPosition()
    self.m_panel_betarea:setPositionY(posy - 400)
    self.m_panel_betarea:setOpacity(0)
    local bottomMove = cc.MoveTo:create(otherAniTime, cc.p(posx,posy + offset))
    local bottomMove2 = cc.MoveTo:create(0.2, cc.p(posx,posy))
    local spawn = cc.Spawn:create(cc.FadeIn:create(0.2), bottomMove)
    local seq = cc.Sequence:create(spawn, bottomMove2)
    self.m_panel_betarea:runAction(seq)

    --续投按钮
    posx, posy = self.m_pBtnContinue:getPosition()
    self.m_pBtnContinue:setPositionY(posy - 400)
    self.m_pBtnContinue:setOpacity(0)
    bottomMove = cc.MoveTo:create(otherAniTime, cc.p(posx,posy + offset))
    bottomMove2 = cc.MoveTo:create(0.2, cc.p(posx,posy))
    spawn = cc.Spawn:create(cc.FadeIn:create(0.2), bottomMove)
    seq = cc.Sequence:create(spawn, bottomMove2)
    self.m_pBtnContinue:runAction(seq)

    --玩家信息区域
    posx, posy = self.m_panel_self:getPosition()
    self.m_panel_self:setPositionY(posy - 400)
    self.m_panel_self:setOpacity(0)
    bottomMove = cc.MoveTo:create(otherAniTime, cc.p(posx,posy + offset))
    bottomMove2 = cc.MoveTo:create(0.2, cc.p(posx,posy))
    spawn = cc.Spawn:create(cc.FadeIn:create(0.2), bottomMove)
    seq = cc.Sequence:create(spawn, bottomMove2)
    self.m_panel_self:runAction(seq:clone())

    --退出
    posx, posy = self.m_pBtnReturn:getPosition()
    self.m_pBtnReturn:setPositionY(posy + 400)
    self.m_pBtnReturn:setOpacity(0)
    local topMove = cc.MoveTo:create(otherAniTime, cc.p(posx,posy - offset))
    local topMove2 = cc.MoveTo:create(0.2, cc.p(posx,posy))
    spawn = cc.Spawn:create(cc.FadeIn:create(0.2), topMove)
    seq = cc.Sequence:create(spawn, topMove2)
    self.m_pBtnReturn:runAction(seq)

    --其他玩家
    posx, posy = self.m_panel_other:getPosition()
    self.m_panel_other:setPositionX(posx - 200)
    self.m_panel_other:setOpacity(0)
    local leftMove = cc.MoveTo:create(otherAniTime, cc.p(posx + offset,posy))
    local leftMove2 = cc.MoveTo:create(0.2, cc.p(posx,posy))
    spawn = cc.Spawn:create(cc.FadeIn:create(0.2), leftMove)
    seq = cc.Sequence:create(spawn, leftMove2)
    self.m_panel_other:runAction(seq)

    --菜单
    posx, posy = self.m_pBtnMenuPop:getPosition()
    self.m_pBtnMenuPop:setPositionY(posy + 400)
    self.m_pBtnMenuPop:setOpacity(0)
    topMove = cc.MoveTo:create(otherAniTime, cc.p(posx,posy - offset))
    topMove2 = cc.MoveTo:create(0.2, cc.p(posx,posy))
    spawn = cc.Spawn:create(cc.FadeIn:create(0.2), topMove)
    seq = cc.Sequence:create(spawn, topMove2)
    self.m_pBtnMenuPop:runAction(seq)

    --庄家信息
    posx, posy = self.m_nodeTop:getPosition()
    self.m_nodeTop:setPositionY(posy + 400)
    self.m_nodeTop:setOpacity(0)
    topMove = cc.MoveTo:create(otherAniTime, cc.p(posx,posy - offset))
    topMove2 = cc.MoveTo:create(0.2, cc.p(posx,posy))
    spawn = cc.Spawn:create(cc.FadeIn:create(0.2), topMove)
    seq = cc.Sequence:create(spawn, topMove2)
    self.m_nodeTop:runAction(seq)


    --倒计时
    posx, posy = self.m_panel_clock:getPosition()
    self.m_panel_clock:setPositionY(posy + 400)
    self.m_panel_clock:setOpacity(0)
    topMove = cc.MoveTo:create(otherAniTime, cc.p(posx,posy - offset))
    topMove2 = cc.MoveTo:create(0.2, cc.p(posx,posy))
    spawn = cc.Spawn:create(cc.FadeIn:create(0.2), topMove)
    seq = cc.Sequence:create(spawn, topMove2)
    self.m_panel_clock:runAction(seq)

    --左右npc动画
    posx, posy = self.m_nodeAniBlack:getPosition()
    self.m_nodeAniBlack:setPositionX(posx - 200)
    self.m_nodeAniBlack:setOpacity(0)
    leftMove = cc.MoveTo:create(otherAniTime, cc.p(posx + offset,posy))
    leftMove2 = cc.MoveTo:create(0.2, cc.p(posx,posy))
    spawn = cc.Spawn:create(cc.FadeIn:create(0.2), leftMove)
    seq = cc.Sequence:create(spawn, leftMove2)
    self.m_nodeAniBlack:runAction(seq)

    posx, posy = self.m_nodeAniRed:getPosition()
    self.m_nodeAniRed:setPositionX(posx + 200)
    self.m_nodeAniRed:setOpacity(0)
    leftMove = cc.MoveTo:create(otherAniTime, cc.p(posx - offset,posy))
    leftMove2 = cc.MoveTo:create(0.2, cc.p(posx,posy))
    spawn = cc.Spawn:create(cc.FadeIn:create(0.2), leftMove)
    seq = cc.Sequence:create(spawn, leftMove2)
    self.m_nodeAniRed:runAction(seq)

    --桌子背景
    posx, posy = self.m_deskbg:getPosition()
    self.m_deskbg:setPositionY(posy - 400)
    self.m_deskbg:setOpacity(0)
    bottomMove = cc.MoveTo:create(deskAniTime, cc.p(posx,posy))
    spawn = cc.Spawn:create(cc.FadeIn:create(0.2), bottomMove)
    local callfun = cc.CallFunc:create(function()
                        
                    end)
    self.m_deskbg:runAction(cc.Sequence:create(spawn, callfun))
end

--开始下注
function GameViewLayer:showBeganBetAni()
    self.m_zhuanchangAni:setVisible(true)
    self.m_zhuanchangAniState = 1
    local func = function(armature,movementType,strName)
        if movementType == ccs.MovementEventType.complete then
            self.m_zhuanchangAni:setVisible(false)
            self.m_zhuanchangAniState = 0
        end
    end
    self.m_zhuanchangAni:getAnimation():setMovementEventCallFunc(func)
    self.m_zhuanchangAni:getAnimation():play("startbet")
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_STARTBET)
end

--停止下注
function GameViewLayer:showStopBetAni()
    self.m_zhuanchangAni:setVisible(true)
    self.m_zhuanchangAniState = 2
    local func = function(armature,movementType,strName)
        if movementType == ccs.MovementEventType.complete then
            self.m_zhuanchangAni:setVisible(false)
            self.m_zhuanchangAniState = 0
        end
    end
    self.m_zhuanchangAni:getAnimation():setMovementEventCallFunc(func)
    self.m_zhuanchangAni:getAnimation():play("stopbet")
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_STOPBET)
end

--等待下一局
function GameViewLayer:showWaitBetAni(loopplay)
    self.m_zhuanchangAni:setVisible(true)
    self.m_zhuanchangAniState = 3
    local func = function(armature,movementType,strName)
        if movementType == ccs.MovementEventType.complete then
            self.m_zhuanchangAni:setVisible(false)
            self.m_zhuanchangAniState = 0
        end
    end
    self.m_zhuanchangAni:getAnimation():setMovementEventCallFunc(func)
    if loopplay then
        self.m_zhuanchangAni:getAnimation():play("wait", -1, 1)
    else
        self.m_zhuanchangAni:getAnimation():play("wait")
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
    local pSpr = cc.Sprite:createWithSpriteFrameName(self:getJettonIconFile(jettonIndex))
    if pSpr == nil then return end
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
            --chiptg.pos = self.m_randmChipOthers[wChipIndex][idx]
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
        else
            chiptg = {}
            chiptg.pChipSpr = pSpr
            chiptg.wJettonIndex = jettonIndex
            chiptg.wChipIndex = wChipIndex
            chiptg.nIdx = idx
            self.m_betChipSpOthers[wChipIndex][idx] = chiptg
        end
    end

    if nil ~= oldSp then
        oldSp:runAction(self:createAutoDelAnim(oldSp))
    end

    local forward = cc.MoveTo:create(iFinishTime,endPos)
    local eMove = cc.EaseSineOut:create(forward) --cc.EaseExponentialOut:create(cc.EaseSineOut:create(forward))
    local Value = 0
    if (not isMyFly) and isNeedDelay then
        Value = self.m_flychipidx * 0.4 + ( math.random(0,10) % 100)/100.0
    end

--    local scaleAnim = cc.ScaleBy:create(0.1,0.85)
--    local scaleRev = scaleAnim:reverse()

    local func = function()
        if not self.m_isPlayBetSound then
            if jettonIndex > 3 then -- 分段播放音效
                ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BETHIGH)
            else
                ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_BETLOW)
            end
            -- 尽量避免重复播放
            self:doSomethingLater(function() self.m_isPlayBetSound  = false end, math.random(2,4)/10)
            self.m_isPlayBetSound = true
        end
    end

    local seq = cc.Sequence:create(cc.Hide:create(), cc.DelayTime:create( Value ),cc.Show:create(), cc.CallFunc:create(func), eMove)
    --, scaleAnim, scaleRev) --math.max(0.02,Value)

    pSpr:runAction(seq)

end

--得分动画
function GameViewLayer:playUserScoreEffect()
    local selfcurscore = 0 -- 自己最终得分
    local bankercurscore = 0 -- 庄家最终得分
    local othercurscore = 0 -- 其他玩家最终得分
    local isbanker = RedVsBlackDataManager.getInstance():isBanker()

    selfcurscore, othercurscore, bankercurscore = self:calcCurScore()

    --用户当前积分
    local llUserScore = PlayerInfo.getInstance():getUserScore()
    local str = ""
    local curpath = ""

    -- 显示庄家分数动画
    str = (bankercurscore)
    if bankercurscore > 0 then
        str = "+" .. str
    end
    curpath = bankercurscore < 0 and RedVsBlackRes.FNT_RESULT_LOSE or RedVsBlackRes.FNT_RESULT_WIN
    local cb = function()
        --self:updateBankerInfo()
    end

    self:flyNumOfGoldChange(cc.p(self.m_bankerChipPos.x, self.m_bankerChipPos.y + 17), curpath, str, cb)

    -- 显示其他玩家分数动画
    str = (othercurscore)
    if othercurscore > 0 then
        str = "+" .. str
    end
    local posOther = cc.p(self.m_otherChipPos)
    posOther.x = posOther.x - 20
    posOther.y = posOther.y + 110
    curpath = othercurscore < 0 and RedVsBlackRes.FNT_RESULT_LOSE or RedVsBlackRes.FNT_RESULT_WIN
    self:flyNumOfGoldChange(posOther, curpath, str)

    -- 显示自己分数动画
    local selfbet = RedVsBlackDataManager.getInstance():getUserTotalChip()
    if selfbet > 0 or isbanker then
        str = (selfcurscore)
        if selfcurscore > 0 then
            str = "+" .. str
        end

        local posSelf = cc.p(self.m_selfChipPos)
        posSelf.y = posSelf.y + 150
        curpath = selfcurscore < 0 and RedVsBlackRes.FNT_RESULT_LOSE or RedVsBlackRes.FNT_RESULT_WIN
        self:flyNumOfGoldChange(posSelf, curpath, str)
    end

    --自己金币变化动画
    if selfcurscore > 0 then
        Effect:getInstance():showScoreChangeEffect(self.m_pLbUsrGold, llUserScore - selfcurscore   , selfcurscore, llUserScore + selfbet, 1, 10)
    else
        self.m_pLbUsrGold:setString((llUserScore + selfbet))
    end
    
    local llGold = RedVsBlackDataManager.getInstance():getBankerGold()
    self.m_pLbZhuangGold:setString((llGold))
end

--弹金币动画
function GameViewLayer:flyNumOfGoldChange(beginPos, filepath, str, cb)
    local lb = cc.Label:createWithBMFont(filepath, str)
                :setAnchorPoint(0, 0.5)
                :setOpacity(255)
                :setScale(0.5)
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

--发牌
function GameViewLayer:SendCard()
    -- 发牌位置    1 2 3 4 5 6
    self:playNpcAnim(0)
    self.m_zhuanchangAni:setVisible(false)

    -- 清除旧的显示动画
    self:clearCardList()
    self.m_panel_card:removeAllChildren()
    self.m_pokerList = {}

    local nIndex = 0
    for i = 1, 6 do
        local callback = cc.CallFunc:create(function ()
            self.m_cardImgList[i] = self:SendCardEffect(nil, self.m_panel_card, cc.p(464, 69.3), self.m_cardPosArr[i])
        end)
        local seq = cc.Sequence:create( cc.DelayTime:create(i*0.2), callback )
        self.m_rootNode:runAction(seq)
        self:doSomethingLater(function()
            ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_FAPAI)
        end, ( i - 1 ) * 0.23)
    end    
end

--发牌动画
function GameViewLayer:SendCardEffect(sp, parentNode, beganPos, endPos)
    -- 在开牌动画中 背景牌对象已经被变形 需要先设置为正常状态
    if sp then
        sp:setScale(POKERSCALE)
        sp:setVisible(true)        
        sp:setPosition(beganPos)
        sp:runAction(cc.Sequence:create(cc.MoveTo:create(0.2, endPos)))
        return
    end

    sp = cc.Sprite:createWithSpriteFrameName( RedVsBlackRes.IMG_POKER_BACKBG )

    if sp then
        sp:setAnchorPoint(cc.p(0.5,0.5))
        sp:setPosition(beganPos)
        sp:setScale(POKERSCALE)
        parentNode:addChild(sp,G_CONSTANTS.Z_ORDER_COMMON)     
        sp:runAction(cc.Sequence:create(cc.MoveTo:create(0.2, endPos)))
    end
    return sp
end

--开牌动画
function GameViewLayer:OpenCard()
    self:OpenCardLoop(1, true)
end

--循环开牌逻辑
function GameViewLayer:OpenCardLoop(i, bPlayEffect)
    local tem = RedVsBlackDataManager.getInstance():getOpenData()
    if nil == next(tem) then return end

    if 7 == i then -- 所有牌开牌完成
        self:showRedCardTypeEffect(tem.wWinCardType[1])
        self:playCardTypeSound(tem.wWinCardType[1]) -- 播放红方牌型声音
        return
    end

    if 4 == i and bPlayEffect then -- 左边开牌完成 显示左侧牌型动画
        self:showBlackCardTypeEffect(tem.wWinCardType[2])
        self:playCardTypeSound(tem.wWinCardType[2]) -- 播放黑方牌型声音
        return
    end
    self:playOpenCardsSound()
    self:showOpenCardAnimation(i, self.m_cardPosArr[i])
end

--原始开牌动画偶尔会出现牌面信息精灵无法正常显示，变成空白牌，原因位置，用新的代码方式实现替换测试
function GameViewLayer:showOpenCardAnimation(i, cardpos)
    local cardsp = self.m_cardImgList[i]
    if nil == cardsp then print("nil opencard object") return end

    cardsp:setPosition(cardpos)
    cardsp:setVisible(true)

    -- 网络出问题时候 延迟执行序列中的poker对象 可能已经被释放掉了，导致序列动画中的poker对象使用失败
    local callBack = cc.CallFunc:create(function ()
        local callFun = cc.CallFunc:create(function() self:OpenCardLoop(i+1, true) end)
        local poker = self:createViewPoker(i)
        if not poker then return end
        poker:setScaleX(0.03)
        poker:setScaleY(0.7)
        poker:setAnchorPoint(0.5, 0.5)
        poker:setPosition(cardpos)
        poker:setVisible(false)
        self.m_panel_card:addChild(poker,G_CONSTANTS.Z_ORDER_COMMON)
        self.m_pokerList[i] = poker
        poker:setVisible(true)
        poker:runAction(cc.Sequence:create(cc.ScaleTo:create(0.23, POKERSCALE, POKERSCALE), callFun))
    end)

    cardsp:runAction(cc.Sequence:create(cc.ScaleTo:create(0.23, 0.03, 0.7), cc.Hide:create(), callBack))

end
function GameViewLayer:getCardValue(cbCardData) 
    return cbCardData%13
end

--获取花色
function GameViewLayer:getCardColor(cbCardData) 
    return math.floor(cbCardData/13)
end
--创建一个正面扑克
function GameViewLayer:createViewPoker(idx)
    local newsp = cc.Sprite:createWithSpriteFrameName( RedVsBlackRes.IMG_POKER_FRONTBG )
    local openData = RedVsBlackDataManager.getInstance():getOpenData()
    if not next(openData) then return nil end
    local pokerVal = openData.wOpenCards[idx]
    local color = self:getCardColor(pokerVal)
    local value = self:getCardValue(pokerVal) + 1
    local strColorFrame = string.format("color-%d.png",color)
    local strValFrame =  string.format("value-%d-%d.png",value,color%2)

    display.loadSpriteFrames(RedVsBlackRes.vecReleasePlist[1][1],RedVsBlackRes.vecReleasePlist[1][2])
    local col1frame = display.newSpriteFrame(strColorFrame)
    local val1frame = display.newSpriteFrame(strValFrame)

    cc.Sprite:createWithSpriteFrame(val1frame) -- 上方牌值
        :setAnchorPoint(0.5, 0.5)
        :setPosition(cc.p(31, 158))
        :addTo(newsp)

    cc.Sprite:createWithSpriteFrame(col1frame) -- 上方花色
        :setAnchorPoint(0.5, 0.5)
        :setPosition(cc.p(31, 117))
        :addTo(newsp)

    cc.Sprite:createWithSpriteFrame(col1frame) -- 下方花色
        :setAnchorPoint(0.5, 0.5)
        :setPosition(cc.p(112, 81))
        :setScale(-1)
        :addTo(newsp)

    cc.Sprite:createWithSpriteFrame(val1frame) -- 下方牌值
        :setAnchorPoint(0.5, 0.5)
        :setPosition(cc.p(112, 40))
        :setScale(-1)
        :addTo(newsp)
    return newsp
end

function GameViewLayer:playOpenCardsSound()
    ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_FANPAI)
end

--黑方牌型动画
function GameViewLayer:showBlackCardTypeEffect(typeIndex)
    local func = function(armature,movementType,strName)
        if movementType == ccs.MovementEventType.complete then
            self:cardTypeEffectEnd(armature,ccs.MovementEventType.complete,strName, 0, typeIndex)
        end
    end
    self:playCardTypeEffect(typeIndex, self.m_typeAniBlackPos, func) -- 避免挡住花型
end

--红方牌型动画
function GameViewLayer:showRedCardTypeEffect(typeIndex)
    local func = function(armature,movementType,strName)
        if movementType == ccs.MovementEventType.complete then
            self:cardTypeEffectEnd(armature,ccs.MovementEventType.complete,strName, 1, typeIndex)
        end
    end
    self:playCardTypeEffect(typeIndex, self.m_typeAniRedPos, func) -- 避免挡住花型
end

function GameViewLayer:playCardTypeEffect(typeIndex, showpos, func)
    local strname = CardTypeAniName[typeIndex]
    local armature =  ccs.Armature:create(RedVsBlackRes.ANI_CARDTYPE)
    armature:setPosition(showpos)
    armature:setAnchorPoint(0.5, 0.5)
    self.m_nodeAni:addChild(armature, G_CONSTANTS.Z_ORDER_COMMON)
    if armature ~= nil then
        armature:getAnimation():setMovementEventCallFunc(func)
    end
    armature:getAnimation():play(strname)
end

--牌型动画完成回调
function GameViewLayer:cardTypeEffectEnd(armature,movementEventType,name, nIndex, typeIndex)
    --armature:removeFromParent() -- 动画暂不移除  等待开局再移除
    self.m_pArmCardType[#self.m_pArmCardType + 1] = armature
    if 0 == nIndex then -- 黑方牌型动画完成 继续翻红方牌
        self:OpenCardLoop(4, false)
    else
        print("动画完成，开始分配奖励筹码")
        self:playNpcAnim(1)
        local winVal = RedVsBlackDataManager.getInstance():getSelfCurrResult()
        if 0 == betVal then
            ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_NOBET)
        else
            if winVal > 0 then
                ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_WIN)
            else
                ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_LOSE)
            end
        end
--        local tem = RedVsBlackDataManager.getInstance():getOpenData()
--        if tem.llFinaResult > 0 then
--            ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_WIN)
--        end
        self:playWinAreaAnim()
        self:flychipex()
        --RedVsBlackDataManager.getInstance():clearUsrChip()
        RedVsBlackDataManager.getInstance():synTmpHistory()
        self:refreshHistoryView()
--        local _event = {
--            name = RedVsBlackEvent.MSG_REDVSBLACK_UPDATE_HISTORY_INFO,
--            packet = nil,
--        }
--        SLFacade:dispatchCustomEvent(RedVsBlackEvent.MSG_REDVSBLACK_UPDATE_HISTORY_INFO, _event)
    end
end

function GameViewLayer:createChipSprite(jettonIndex, wChipIndex, isMyFly)
    local idx, endPos = self:getChipEndPosition(wChipIndex, isMyFly)
    if isMyFly then
        if nil ~= self.m_betChipSpSelf[wChipIndex][idx] then return end
    else
        if nil ~= self.m_betChipSpOthers[wChipIndex][idx] then return end
    end

    local pSpr = cc.Sprite:createWithSpriteFrameName(self:getJettonIconFile(jettonIndex))
    pSpr:setTag(jettonIndex)
    if not pSpr then return end
    
    local tg = {}
    tg.pChipSpr = pSpr
    tg.wJettonIndex = jettonIndex
    tg.wChipIndex = wChipIndex
    tg.nIdx = idx

    pSpr:setScale(CHIPSCALE)

    if isMyFly then
        self.m_betChipSpSelf[wChipIndex][idx] = tg
        pSpr:setPosition(endPos)
    else
        self.m_betChipSpOthers[wChipIndex][idx] = tg
        pSpr:setPosition(endPos)
    end
    self.m_pNodeChipSpr:addChild(pSpr,1)
end

-- 播放npc胜利动画 
-- actType 0:普通 1:胜负
function GameViewLayer:playNpcAnim(actType)

    if 0 == actType then
        self.m_pKingAni:getAnimation():play("nomal")
        self.m_pQueenAni:getAnimation():play("nomal")
    elseif 1 == actType then
        local tem = RedVsBlackDataManager.getInstance():getOpenData()
        if not tem or next(tem) == nil then return end
        if 1 == tem.wWinIndex then -- 黑方胜利
            self.m_pKingAni:getAnimation():play("laugh")
            self.m_pQueenAni:getAnimation():play("cry")
        else
            self.m_pKingAni:getAnimation():play("cry")
            self.m_pQueenAni:getAnimation():play("laungh")
        end
    else
        self.m_pKingAni:getAnimation():play("nomal")
        self.m_pQueenAni:getAnimation():play("nomal")
    end
end

-- 获胜区域闪烁动画
function GameViewLayer:playWinAreaAnim()
    local tem = RedVsBlackDataManager.getInstance():getOpenData()
    if not tem or next(tem) == nil then return end
    if 0 == tem.wWinIndex   then self:blinkWinArea(1) end
    if 1 == tem.wWinIndex   then self:blinkWinArea(2) end
    if 1 == tem.cbLuckyBeat then self:blinkWinArea(3) end
end

function GameViewLayer:blinkWinArea(nIndex)
    self.m_pWinAreaImg[nIndex]:runAction(cc.Sequence:create(cc.Blink:create(7, 7), cc.Show:create()))
end

function GameViewLayer:stopBlinkWinArea()
    for i = 1, DOWN_COUNT_HOX do
        self.m_pWinAreaImg[i]:stopAllActions()
        self.m_pWinAreaImg[i]:setVisible(false)
    end
end

function GameViewLayer:clearCardList()
    if 0 == #self.m_cardImgList then return end
    for k,v in pairs(self.m_cardImgList) do
        if v then
            v:stopAllActions()
            v:removeFromParent()
        end
    end
    self.m_cardImgList = {}
end

--最后3秒倒计时
function GameViewLayer:playLastTimeAni(ts)
    local frameIndex = math.ceil((3 -ts) * 60 + 1)
    if frameIndex > 170 then frameIndex = 170 end 
    self.m_countAni:setVisible(true)
    self.m_countAni:getAnimation():playWithIndex(0, -1, -1)
    self.m_countAni:getAnimation():gotoAndPlay(frameIndex)

    --帧回调无效？使用延迟播放
    for i = 1, ts do
        self:doSomethingLater(function ()
            if self.m_nSoundClock then
                
                self.m_nSoundClock = nil
            end
            if self.m_isPlayDaojishi then
                self.m_nSoundClock = ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_COUNT)
            end
        end , i - 1)
    end
end

function GameViewLayer:stopLastTimeAni()
    self.m_isPlayDaojishi = false
    self.m_countAni:setVisible(false)
end

--endregion

--region 辅助方法

function GameViewLayer:showMessageBox(msg, cb) --打开确认框
    --MessageBox.create(msg):addTo(self.m_rootUI, ZORDER_OF_MESSAGEBOX)
    local pMessageBox = MessageBoxNew.create(msg, cb)
    self.m_rootUI:addChild(pMessageBox, ZORDER_OF_MESSAGEBOX)
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
    local tax = 1 - RedVsBlackDataManager.getInstance():getGameTax()
    local isbanker = RedVsBlackDataManager.getInstance():isBanker()

    --庄家本局结算得分
    bankercurscore = RedVsBlackDataManager.getInstance():getBankerCurrResult()
    bankercurscore = bankercurscore > 0 and bankercurscore/tax or bankercurscore

    --用户本局结算积分(下注阶段压分然后退出再进，服务端结算本局游戏返回的用户积分是0，使用本地计算)
    if isbanker then
        selfcurscore = bankercurscore
    else
        selfcurscore = RedVsBlackDataManager.getInstance():getSelfCurrResult()
        selfcurscore = selfcurscore > 0 and selfcurscore/tax or selfcurscore
    end

    --其他玩家计算积分
    othercurscore = isbanker and -bankercurscore or -bankercurscore - selfcurscore
    othercurscore = othercurscore > 0 and othercurscore * tax or othercurscore
    selfcurscore = RedVsBlackDataManager.getInstance():getSelfCurrResult()
    bankercurscore = RedVsBlackDataManager.getInstance():getBankerCurrResult()

    print("庄家实际得分:" .. bankercurscore)
    print("自己实际得分:" .. selfcurscore)
    print("其他玩家实际得分:" .. othercurscore)

    return selfcurscore, othercurscore, bankercurscore
end

--计算玩家实际获得积分
function GameViewLayer:calcSelfCurScore()
    local selfBetVal = RedVsBlackDataManager.getInstance():getUserTotalChip()

    if 0 == selfBetVal then return 0 end

    local selfWinVal = 0

    local tem = RedVsBlackDataManager.getInstance():getOpenData()

    --{ "单牌","对子","顺子","金花","顺金","豹子", }
    local tbRatio = {
        0, -- 单牌
        1, -- 对子
        2, -- 顺子
        3, -- 金花
        5, -- 顺金
        10 -- 豹子
    }

    local winnerArea = {}
    winnerArea[1] = { iswin =  0 == tem.wWinIndex,   ratio = 2} -- 红方赢
    winnerArea[2] = { iswin =  1 == tem.wWinIndex,   ratio = 2} -- 红方赢
    winnerArea[3] = { iswin =  1 == tem.cbLuckyBeat, ratio = tbRatio[tem.wWinCardType[tem.wWinIndex + 1]] + 1}
    print("牌型索引:" .. tem.wWinCardType[tem.wWinIndex + 1])
    for i = 1, DOWN_COUNT_HOX do
        if winnerArea[i].iswin then
            selfWinVal = selfWinVal + RedVsBlackDataManager.getInstance():getUserAllChip(i) * winnerArea[i].ratio
        end
    end

    return selfWinVal - selfBetVal
end

--克隆一个赔付的筹码对象
function GameViewLayer:clonePayoutChip(jettonIndex)
    local pos = cc.p(self.m_bankerChipPos)
    local pSpr = cc.Sprite:createWithSpriteFrameName(self:getJettonIconFile(jettonIndex))
    if not pSpr then return end
    pSpr:setScale(0.35)
    pSpr:setPosition(pos)
    pSpr:setLocalZOrder(G_CONSTANTS.Z_ORDER_COMMON)
    self.m_pNodeChipSpr:addChild(pSpr)
    return pSpr
end

--以队列方式进行飞筹码
function GameViewLayer:flychipex()
    local tem = RedVsBlackDataManager.getInstance():getOpenData()

    if not tem or next(tem) == nil then return end

    local winArea = {}
    winArea[1] = 0 == tem.wWinIndex -- 红方赢
    winArea[2] = 1 == tem.wWinIndex -- 黑方赢
    winArea[3] = 1 == tem.cbLuckyBeat

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

    --[[
            self.m_betChipSpSelf[wChipIndex][idx].pChipSpr = pSpr
            self.m_betChipSpSelf[wChipIndex][idx].wJettonIndex = jettonIndex
            self.m_betChipSpSelf[wChipIndex][idx].wChipIndex = wChipIndex
            self.m_betChipSpSelf[wChipIndex][idx].nIdx = idx
    ]]--

    for i = 1, DOWN_COUNT_HOX do
        for k, v in pairs(self.m_betChipSpSelf[i]) do
             table.insert(selfvec[v.wChipIndex].vec, v)
        end

        for k, v in pairs(self.m_betChipSpOthers[i]) do
            table.insert(othervec[v.wChipIndex].vec, v)
        end
    end

    -- 遍历获胜的区域 必须用pairs方式 保证所有筹码遍历到
    local selfPos = self:getSelfChipBeginPosition()
    local bankerPos = self:getBankerChipBeginPosition()
    local otherPos = self:getOtherChipBeginPosition()
    for i = 1, CHIP_ITEM_COUNT do
        for k, v in pairs(selfvec[i].vec) do
            if v then
                if not selfvec[i].winmark then
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
                if not othervec[i].winmark then
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
                if oldsp and selfwinvec[i][j].winmark then
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
--        countother = #otherwinvec[i]
--        countother = countother > 8 and countother/2 or countother
        for j = 1, #otherwinvec[i] do
            local oldsp = otherwinvec[i][j].sp
            if oldsp and otherwinvec[i][j].winmark then
                local newsp = self:clonePayoutChip(oldsp:getTag())
                newsp:setPosition(bankerPos)
                local randx = (math.random(-offset*100, offset*100)) / 100
                local randy = (math.random(-offset*100, offset*100)) / 100
                local posIdx = j % #self.m_randmChipSelf[i].vec
                posIdx = posIdx > 0 and posIdx or 1
                table.insert( bankerlostvec[i], { sp = newsp, endpos = self.m_randmChipSelf[i].vec[posIdx] })
                bankerlose = true
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
                                ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_GETGOLD)
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
                                ExternalFun.playGameEffect(RedVsBlackRes.SOUND_OF_GETGOLD)
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

function GameViewLayer:ClearOldCard()
    if 0 == #self.m_pArmDispatch then return end
    for i = 1, #self.m_pArmDispatch do
        self.m_pArmDispatch[i]:removeFromParent()
    end
    self.m_pArmDispatch = {}
end

function GameViewLayer:ClearOldAni()
    for i = 1, #self.m_pArmCardType do
        self.m_pArmCardType[i]:removeFromParent()
    end
    self.m_pArmCardType = {}
end

function GameViewLayer:ClearOldBetScore()
    for i = 1, 3 do -- 清除金币
        self.m_pLbMyBettingGold[i]:setString("0")
        self.m_pLbMyBettingGold[i]:setVisible(false)
        self.m_pLbBettingGold[i]:setString("0")
        self.m_myBetMoney[i] = 0
    end
    RedVsBlackDataManager.getInstance():clearAllChip()
end

function GameViewLayer:doSomethingLater(call, time)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(time), cc.CallFunc:create(call)))
end

-- 重置随机投注点
function GameViewLayer:resetChipPos()
    --self.m_lastflynum = 0
    local offsetVec = {10, 10, 8}
    local rowVal = {4, 4, 3}
    local colVal = {9, 9, 10}
    for i = 1, DOWN_COUNT_HOX do
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
function GameViewLayer:initUserData()
    PlayerInfo.getInstance():setChairID(GlobalUserItem.tabAccountInfo.userid)
    PlayerInfo.getInstance():setUserScore(GlobalUserItem.tabAccountInfo.into_money)
--    PlayerInfo.getInstance():setUser(GlobalUserItem.tabAccountInfo.userid)
    PlayerInfo.getInstance():setUserName(GlobalUserItem.tabAccountInfo.nickname)
end
--通知银行可用状态
function GameViewLayer:notifyBankEnable()
    --通知银行可用状态
--    local _event = {
--        name = Public_Events.MSG_BANK_STATUS,
--        packet = RedVsBlackDataManager.getInstance():getGameStatus() == RedVsBlackDataManager.E_GAME_STATUE.eGAME_STATUS_CHIP and "1" or "0",
--    }
--    SLFacade:dispatchCustomEvent(Public_Events.MSG_BANK_STATUS, _event)

end

function GameViewLayer:clearVecSpriteOther()
    for i = 1,DOWN_COUNT_HOX do
        self.m_betChipSpSelf[i] = {}
    end
end

function GameViewLayer:clearVecSpriteSelf()
    for i = 1,DOWN_COUNT_HOX do
        self.m_betChipSpOthers[i] = {}
    end
end

-- 我方投注筹码动画起始位置
function GameViewLayer:getBeginPosition(index)
    --return cc.p(self.m_chipPosArr[index])
    local pos
    if index == 1 then
        pos = cc.p(400, 50)
    elseif index == 2 then
        pos = cc.p(505, 50)
    elseif index == 3 then
        pos = cc.p(620, 50)
    elseif index == 4 then
        pos = cc.p(730, 50)
    elseif index == 5 then
        pos = cc.p(836, 50)
    elseif index == 6 then
        pos = cc.p(946, 50)
    end
    return pos
end

-- 其他人投注筹码动画起始位置
function GameViewLayer:getBeginPositionForAllOther(iOtherIndex)
    return self.m_otherChipPos
end

function GameViewLayer:getJettonIconFile(nIndex)
    -- new-game-jetton-100.png
    local str = RedVsBlackRes.IMG_JETTON_DEFAULT
    if not nIndex then 
        return str
    end
    str = string.format(RedVsBlackRes.IMG_JETTON ,RedVsBlackDataManager.getInstance():getJettonScore(nIndex))
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

--提示消息
function GameViewLayer:addRollMessageInfo(msg)
    if not msg or next(msg.packet) == nil then return end
    local pSysMessage = msg.packet
    if pSysMessage.wSysType == 1 then-- UPRUN_MSG
        local strMessage = string.trim(pSysMessage.szSysMessage) or ""
        FloatMessage.getInstance():pushMessageForString(strMessage)
    end
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

return GameViewLayer
