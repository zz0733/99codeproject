--  扎金花
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local module_pre = "game.yule.gold2.src"
local cmd = appdf.req(module_pre .. ".models.CMD_Game")
local Define = appdf.req(module_pre .. ".models.Define")
local GameRoleItem = appdf.req(module_pre .. ".views.layer.GameRoleItem")
local HeadSprite = require(appdf.EXTERNAL_SRC .. "HeadSprite")
local CardSprite = appdf.req(module_pre .. ".views.layer.gamecard.CardSprite")
local CardsNode = appdf.req(module_pre .. ".views.layer.gamecard.CardsNode")
local GameLogic = appdf.req(module_pre .. ".models.GameLogic")
local GameResultLayer = appdf.req(module_pre .. ".views.layer.GameResultLayer")

local SettingLayer          = appdf.req(module_pre .. ".views.layer.SettingLayer")
local RuleLayer             = appdf.req(module_pre .. ".views.layer.RuleLayer")
local Poker                 = require(module_pre .. ".views.layer.Poker")
local ProgressNode          = require(module_pre .. ".views.layer.ProgressNode")

local TAG_ENUM = Define.TAG_ENUM
local TAG_ZORDER = Define.TAG_ZORDER

local GameViewLayer = class("GameViewLayer",function(scene)
        local gameViewLayer = display.newLayer()
    return gameViewLayer
end)

--玩家当前状态
GameViewLayer.STATE_HALFWAY = 0         --中途进入游戏房间
GameViewLayer.STATE_ONZHUNBEI = 1       --玩家准备中
GameViewLayer.STATE_QIPAI = 2           --玩家已弃牌
GameViewLayer.STATE_LIANGPAI = 3        --玩家已亮牌
GameViewLayer.STATE_GAMEOVER = 4        --游戏结束
--按钮tag标识
GameViewLayer.BTN_GENDAODI  = 101       --跟到底
GameViewLayer.BTN_QIPAI     = 102       --弃牌
GameViewLayer.BTN_BIPAI     = 103       --比牌
GameViewLayer.BTN_KANPAI    = 104       --看牌
GameViewLayer.BTN_JIAZHU    = 105       --加注
GameViewLayer.BTN_XIAZHU    = 106       --下注
GameViewLayer.BTN_QUANXIA   = 107       --全下
GameViewLayer.BTN_LIKAIYOUXI    = 108       --离开游戏
GameViewLayer.BTN_JIXUYOUXI     = 109       --继续游戏
GameViewLayer.BTN_LIANGPAI      = 109       --亮牌

GameViewLayer.POKERPOS = {  --每张扑克的坐标
{ cc.p(330.00,485.00),cc.p(352.00,485.00),cc.p(374.00,485.00)},     --左上
{ cc.p(220.00,315.00),cc.p(242.00,315.00),cc.p(264.00,315.00)},     --左下
{ cc.p(650.00,105.00),cc.p(693.00,105.00),cc.p(736.00,105.00)},     --自己
{ cc.p(1005.00,315.00),cc.p(1027.00,315.00),cc.p(1049.00,315.00)},  --右下
{ cc.p(895.00,485.00),cc.p(917.00,485.00),cc.p(939.00,485.00)}      --右上
}
GameViewLayer.CHIPPOS = {   --筹码创建位置的坐标
cc.p(320,550),cc.p(230,300),cc.p(630,180),cc.p(1050,350),cc.p(1030,550)
}
GameViewLayer.QIPAIPOS = {  --弃牌动画的坐标
cc.p(395,505),cc.p(285,335),cc.p(750,155),cc.p(1050,335),cc.p(940,505)
}
GameViewLayer.PAOPAOKUANGPOS = {  --泡泡框提示动画的坐标
cc.p(395,550),cc.p(285,380),cc.p(750,195),cc.p(1050,375),cc.p(940,545)
}
GameViewLayer.PLAYER_ICON_POS = {  --玩家头像的坐标
cc.p(252,626),cc.p(140,368),cc.p(558,202),cc.p(1188,368),cc.p(1070,623)
}
GameViewLayer.WIN_LOSE_LABEL_POS = {  --玩家输赢钱数飘字动画坐标
cc.p(167,25),cc.p(167,25),cc.p(167,25),cc.p(-90,25),cc.p(-90,25)
}
GameViewLayer.chipSpRec = {
        "goold2zjh/zjh/chip/bg-chip-01.png",
        "goold2zjh/zjh/chip/bg-chip-02.png",
        "goold2zjh/zjh/chip/bg-chip-04.png",
        "goold2zjh/zjh/chip/bg-chip-06.png",
        "goold2zjh/zjh/chip/bg-chip-08.png",
        "goold2zjh/zjh/chip/bg-chip-10.png"
}
function GameViewLayer:ctor(scene)
print("on enter -----------===========----------    GameViewLayer")
    --注册node事件
    ExternalFun.registerNodeEvent(self)
    self._scene = scene


    self.pTex = cc.Director:getInstance():getTextureCache():addImage("goold2zjh/zjh/CARD1.png")
    self.pokerTable = {}
    self:createPokerArray()
    --初始化界面
    self:initViewLayer()
    
end

function GameViewLayer:initViewLayer( )
    ExternalFun.playBackgroudAudio("bgm01.mp3")
    self.root = ccs.GUIReader:getInstance():widgetFromJsonFile("goold2zjh/main_ui.json")    
    if not self.root then
        return false
    end
    self:addChild(self.root)
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    --加载资源/动画
    self.chipImageRes = {}
    for key, res_ in ipairs(GameViewLayer.chipSpRec) do
        local chipSpriteFrame = cc.Director:getInstance():getTextureCache():addImage(res_)
        table.insert(self.chipImageRes,chipSpriteFrame)
    end
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("goold2zjh/zjh/effect/heguan_1/heguan_1.ExportJson")   --荷官
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("goold2zjh/zjh/effect/dengdai_1/dengdai_1.ExportJson")   --等待下一局
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("goold2zjh/zjh/effect/wait-player/wait-player.ExportJson")   --等待其他玩家
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("goold2zjh/zjh/effect/paopaokuang_zhajinhua/paopaokuang_zhajinhua.ExportJson")   --泡泡框提示
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("goold2zjh/zjh/effect/pk_bipai/pk_bipai.ExportJson")   --比牌
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("goold2zjh/zjh/effect/qipai/qipai.ExportJson")   --弃牌
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("goold2zjh/zjh/effect/xiazhu_danshou/xiazhu_danshou.ExportJson")   --下注单手左右
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("goold2zjh/zjh/effect/xiazhu_qian/xiazhu_qian.ExportJson")   --下注单手自身
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("goold2zjh/zjh/effect/allin_you2/allin_you2.ExportJson")   --下注双手左右
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("goold2zjh/zjh/effect/allin_qian/allin_qian.ExportJson")   --下注双手自身
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("goold2zjh/zjh/effect/kebipai_1/kebipai_1.ExportJson")        --可比牌
    --给各种层设置ZOder
    self.root:getChildByName("Panel_287"):getChildByName("Panel_ksyx"):setZOrder(100)   --pk动画层
    self.root:getChildByName("Panel_287"):getChildByName("choumaHolder"):setZOrder(99)  --筹码层
    self.root:getChildByName("Panel_287"):getChildByName("animHodler"):setZOrder(98)    --弃牌动画层
    self.root:getChildByName("Panel_287"):getChildByName("Panel_pai"):setZOrder(97)     --扑克层
    --播放荷官动画
    local heguan = ccs.Armature:create("heguan_1")
    heguan:setAnchorPoint(cc.p(0,0))
    heguan:setPosition(cc.p(-30,60))
	heguan:addTo(self.root:getChildByName("Panel_287"):getChildByName("Panel_hg"))
	heguan:getAnimation():playWithIndex(0)
    --全局变量    
    self.playInfoTable = {}     --房间内的玩家
    self.isMyState = false      --是否是自身回合
    self.isHalfWay = false      --是否是中途进入本局游戏
    self.waitNextGame = true    --等待新的一局游戏开始
    self.isKanpai = false       --自己是否看牌
    self.isQipai = false        --自己是否已经弃牌
    self.isGendaodi = false     --是否选择一跟到底
    self.isCanBipai = false     --是否可以发起比牌
    self.isZidongQipai = false  --是否是时间到了自动弃牌
    self.deskState = nil        --桌子状态/回合(中途进入)
    self.antes_ = 0             --底注
    self.straightBet = 0        --单注
    self.straightBet_num = 0    --单注（0-10）
    self.straightBet_Max = 0    --单注最大值
--    self.roundNumber = 0        --回合数
    self.totalBet = 0           --总下注
    self.myPos_ = 0             --进入房间时我的坐标
    self.chipButtonLabel = {}   --加注按钮的标签
    self.chip_sprite_table = {} --存放筹码精灵

    self.m_pProgressTimer = {}      --头像进度条
    self.timeOut_progress = 0       --消息中的timeout，用于进度条倒计时
    self.waitOthers = nil       --等待其他玩家进来的动画
    self.waitNext = nil         --等待下一局开始的动画
    self.waitPlayer = nil       --正在匹配玩家文字
    --初始化时隐藏的
    self.root:getChildByName("Panel_Entrust"):setVisible(false)
    
    
    --按钮及其回调
    local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
           self:onButtonClickedEvent(ref:getTag(),ref)
        end
    end
        --跟到底
    local btn_gdd = self.root:getChildByName("Panel_287"):getChildByName("CheckBox_gdd")     
    btn_gdd:setTag( GameViewLayer.BTN_GENDAODI )
    btn_gdd:addTouchEventListener( touchFunC )
    btn_gdd:setPressedActionEnabled(true)
        --弃牌
    local btn_qp = self.root:getChildByName("Panel_287"):getChildByName("Button_qp")
    btn_qp:setTag( GameViewLayer.BTN_QIPAI )
    btn_qp:addTouchEventListener( touchFunC )
    btn_qp:setPressedActionEnabled(true)
        --比牌   
    local btn_bp = self.root:getChildByName("Panel_287"):getChildByName("Button_bp") 
    btn_bp:setTag( GameViewLayer.BTN_BIPAI )
    btn_bp:addTouchEventListener( touchFunC )
    btn_bp:setPressedActionEnabled(true)
        --看牌    
    local btn_kp = self.root:getChildByName("Panel_287"):getChildByName("Button_kp")   
    btn_kp:setTag( GameViewLayer.BTN_KANPAI )
    btn_kp:addTouchEventListener( touchFunC )
    btn_kp:setPressedActionEnabled(true) 
        --下注
    local btn_gz = self.root:getChildByName("Panel_287"):getChildByName("Button_gz")  
    btn_gz:setTag( GameViewLayer.BTN_XIAZHU )
    btn_gz:addTouchEventListener( touchFunC )
    btn_gz:setPressedActionEnabled(true)
        --加注  
    local btn_jz = self.root:getChildByName("Panel_287"):getChildByName("Button_jz")    
    btn_jz:setTag( GameViewLayer.BTN_JIAZHU )
    btn_jz:addTouchEventListener( touchFunC )
    btn_jz:setPressedActionEnabled(true)
        --全下
    local btn_qx = self.root:getChildByName("Panel_287"):getChildByName("Button_qx")   
    btn_qx:setTag( GameViewLayer.BTN_QUANXIA )
    btn_qx:addTouchEventListener( touchFunC )
    btn_qx:setPressedActionEnabled(true)
        --离开游戏
    local btn_lkyx = self.root:getChildByName("Panel_Entrust"):getChildByName("Button_Exit")   
    btn_lkyx:setTag( GameViewLayer.BTN_LIKAIYOUXI )
    btn_lkyx:addTouchEventListener( touchFunC )
    btn_lkyx:setPressedActionEnabled(true)
        --继续游戏
    local btn_jxyx = self.root:getChildByName("Panel_Entrust"):getChildByName("Button_Goon")   
    btn_jxyx:setTag( GameViewLayer.BTN_JIXUYOUXI )
    btn_jxyx:addTouchEventListener( touchFunC )
    btn_jxyx:setPressedActionEnabled(true)
        --亮牌
    local btn_lp = self.root:getChildByName("Panel_287"):getChildByName("Button_lp")   
    btn_lp:setTag( GameViewLayer.BTN_LIANGPAI )
    btn_lp:addTouchEventListener( touchFunC )
    btn_lp:setPressedActionEnabled(true)
        --加注界面
    local panelTouchFunc = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self.root:getChildByName("Panel_chips"):setVisible(false)
        end
    end
    self.root:getChildByName("Panel_chips"):setTouchEnabled(true):addTouchEventListener( panelTouchFunc )
        --加注的五个按钮
    for i = 1, 5 do
        local bet_touchFunC = function(ref, tType)
            if tType == ccui.TouchEventType.ended then
                local beishu = i*2
--                if self.straightBet_num < beishu then
--                    if self.straightBet_num == 0 then
--                        self.straightBet_num = 1
--                    end
--                    beishu = beishu - self.straightBet_num
--                end
                if self.isKanpai == true then
                    beishu = beishu*2
                end
                self._scene:sendAdd(beishu*self.antes_)
                self.root:getChildByName("Panel_chips"):setVisible(false)
            end
        end
        local btn_bet = self.root:getChildByName("Panel_chips"):getChildByName(string.format("Button_chip%d",i-1)):addTouchEventListener( bet_touchFunC )
       
    end
        --返回按钮
    local backTouchFunc = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self._scene:onQueryExitGame()
        end
    end
    self.root:getChildByName("Panel_287"):getChildByName("Button_return"):setZOrder(102)
    self.root:getChildByName("Panel_287"):getChildByName("Button_return"):addTouchEventListener( backTouchFunc )
    --规则按钮
    local ruleTouchFunc = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            local ruleLayer = RuleLayer.new(self)
            self:addChild(ruleLayer)
        end
    end
    self.root:getChildByName("Panel_287"):getChildByName("Button_rule"):setZOrder(102)
    self.root:getChildByName("Panel_287"):getChildByName("Button_rule"):addTouchEventListener( ruleTouchFunc )
    --声音按钮
    local soundsTouchFunc = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            local setingLayer = SettingLayer.new(self)
            self:addChild(setingLayer)
        end
    end
    self.root:getChildByName("Panel_287"):getChildByName("Button_voice"):setZOrder(102)
    self.root:getChildByName("Panel_287"):getChildByName("Button_voice"):addTouchEventListener( soundsTouchFunc )
end
--进入游戏
function GameViewLayer:onEventEnter(bufferData) 
    self.max_player_num = bufferData.deskinfo.max_player_num
    for key, player_ in ipairs(bufferData.memberinfos) do
        if player_.uid == GlobalUserItem.tabAccountInfo.userid then
            self.myPos_ = player_.position
        end
    end
    
    --加载玩家信息
    for key, player_ in ipairs(bufferData.memberinfos) do
        self:loadPlayerInfo(player_)
    end
    --加载房间信息
    self.antes_ = bufferData.deskinfo.unit_money             --底注
    self.root:getChildByName("Panel_287"):getChildByName("Label_uplimit_bet"):setString(self.antes_)
    self.straightBet_Max = self.antes_*10--bufferData.deskinfo.init_money
    self.straightBet = bufferData.deskinfo.unit_money
    
    if #self.playInfoTable == 1 then
        --显示等待其他玩家进入房间
        self.waitOthers = ccs.Armature:create("wait-player")
        self.waitOthers:setAnchorPoint(cc.p(0,0))
        self.waitOthers:setPosition(cc.p(650,180))
	    self.waitOthers:addTo(self.root:getChildByName("Panel_287"):getChildByName("animHodler"))
	    self.waitOthers:getAnimation():playWithIndex(0)
        self.waitNextGame = true
    end
    --初始化加注panel
    for i = 1, 5 do
        local parent_node = self.root:getChildByName("Panel_chips"):getChildByName(string.format("Button_chip%d",i-1))
        parent_node:getChildByName(string.format("Label_chip%d",i-1)):setVisible(false)
        local label_money = cc.LabelBMFont:create("", "goold2zjh/fnt/xuanbeishu.fnt")
        label_money:setPosition(50,50)
        parent_node:addChild(label_money)
        local label_value = 0
        if self.isKanpai == false then
            label_value = self.antes_*i*2
        else
            label_value = self.antes_*i*4
        end
        label_money:setString(label_value)
        table.insert(self.chipButtonLabel,label_money)
    end
    self:buttonState()
end
--有玩家进入房间
function GameViewLayer:onEventCome(bufferData)
    print("***********--------onEventCome")
    self:loadPlayerInfo(bufferData.memberinfo)
    if self.waitPlayer ~= nil then
        self.waitPlayer:removeFromParent()
        self.waitPlayer = nil
    end
end
--有玩家离开房间
function GameViewLayer:onEventLeave(bufferData)   
    print("***********--------onEventLeave")
    for key, player_ in ipairs(self.playInfoTable) do
        if player_.uid == bufferData then
            player_.panel:removeFromParent()
            table.remove(self.playInfoTable,key)
            for key, card_ in ipairs(player_.cardSpTab) do
                card_:removeFromParent()
                table.remove(player_.cardSpTab,key)
            end
            player_.cardSpTab = {}
        end
    end
    
end
--有玩家准备
function GameViewLayer:onEventReady(bufferData)  
    if bufferData == GlobalUserItem.tabAccountInfo.userid then
        for i=#self.playInfoTable,1,-1 do
            local player_ = self.playInfoTable[i]
            if player_.uid ~= bufferData then
                player_.panel:removeFromParent()
                table.remove(self.playInfoTable,key)
                for key, card_ in ipairs(player_.cardSpTab) do
                    card_:removeFromParent()
                    table.remove(player_.cardSpTab,key)
                end
                player_.cardSpTab = {}
            end
        end
        self.waitPlayer = cc.LabelTTF:create("正在为您匹配桌子，请稍后···",  "Arial", 28)
        self.waitPlayer:setPosition(cc.p(667,375))
        self.waitPlayer:addTo(self.root:getChildByName("Panel_287"))
    end
end
--更新自身钱包
function GameViewLayer:onEventUpdate_intomoney(bufferData)   
    for key, player_ in ipairs(self.playInfoTable) do
        if player_.uid == GlobalUserItem.tabAccountInfo.userid then
            player_.panel:getChildByName("Label_score"):setString(bufferData)
        end
    end
    
end
--玩家弃牌
function GameViewLayer:onEventDrop(bufferData)
    local soundIndex = math.random(1,5)
    ExternalFun.playSoundEffect(string.format("Quit_0%d.mp3",soundIndex))
    if bufferData.uid == GlobalUserItem.tabAccountInfo.userid then
        self.waitNextGame = true
        if bufferData.pk == 1 then
            self.isCanBipai = true
        else
            self.isCanBipai = false
        end
        if self.isZidongQipai == true then
            self.isZidongQipai = false
        else
            self.isZidongQipai = true
        end
     end

    for key, player_ in ipairs(self.playInfoTable) do
        if bufferData.uid == player_.uid then
            --播放弃牌动画
            local qipai = ccs.Armature:create("qipai")
            qipai:setAnchorPoint(cc.p(0.5,0.5))
            qipai:setPosition(GameViewLayer.QIPAIPOS[player_.chairID+1])
	        qipai:addTo(self.root:getChildByName("Panel_287"):getChildByName("animHodler"))
	        qipai:getAnimation():playWithIndex(0) 
            if player_.chairID ~= 2 then
                qipai:setScale(0.7)
            end     
            if player_.chairID == 1 or player_.chairID == 0 then
                for i = 1, 3 do
                    self:PokerInitWithTexture(player_.cardSpTab[i],56)
                    player_.cardSpTab[i]:setSkewX(0)
                end
                player_.cardSpTab[1]:runAction(cc.Sequence:create( cc.MoveBy:create(0,cc.p(30,-7)),cc.RotateTo:create(0.5,-20) ))
                player_.cardSpTab[2]:runAction(cc.MoveBy:create(0,cc.p(20,0)))
                player_.cardSpTab[3]:runAction(cc.Sequence:create( cc.MoveBy:create(0,cc.p(10,7)),cc.RotateTo:create(0.5,20) ))
            elseif player_.chairID == 3 or player_.chairID == 4 then
                for i = 1, 3 do
                    self:PokerInitWithTexture(player_.cardSpTab[i],56)
                    player_.cardSpTab[i]:setSkewX(0)
                end
                player_.cardSpTab[1]:runAction(cc.Sequence:create( cc.MoveBy:create(0,cc.p(-10,-7)),cc.RotateTo:create(0.5,-20) ))
                player_.cardSpTab[2]:runAction(cc.MoveBy:create(0,cc.p(-20,0)))
                player_.cardSpTab[3]:runAction(cc.Sequence:create( cc.MoveBy:create(0,cc.p(-30,7)),cc.RotateTo:create(0.5,20) ))
            elseif player_.chairID == 2 then
                if self.isKanpai == false then
                    for i = 1, 3 do
                        self:PokerInitWithTexture(player_.cardSpTab[i],56)
                    end
                end                
            end 
            --播放泡泡框动画
            local qipaiAct = ccs.Armature:create("paopaokuang_zhajinhua")
            qipaiAct:setAnchorPoint(cc.p(0,0))
            qipaiAct:setPosition(GameViewLayer.PAOPAOKUANGPOS[player_.chairID+1])
	        qipaiAct:addTo(self.root:getChildByName("Panel_287"):getChildByName("choumaHolder"))
	        qipaiAct:getAnimation():play("Animation7")
            local func = function (armature,movementType,movementID)
                    if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
                        if armature then 
                            armature:removeFromParent()
                        end
                    end
                end
            qipaiAct:getAnimation():setMovementEventCallFunc(func)
            player_["isCanBipai"] = false                                     
        end
    end
    if bufferData.ply == GlobalUserItem.tabAccountInfo.userid then
        self.isMyState = true
    end
    self:buttonState()
    --倒计时
    for key, player_ in ipairs(self.playInfoTable) do
        if bufferData.ply == player_.uid then
            local chair_id = player_.chairID;
            self.timeOut_progress = bufferData.time
            self:showProgrssTimer(chair_id+1)
        end
    end
end
--跟注/加注
function GameViewLayer:onEventAdd(bufferData)
    
    local straightBet_num_last = self.straightBet_num
    self.straightBet = bufferData.chip[1] * self.antes_
    self.straightBet_num = bufferData.chip[1]
    self.root:getChildByName("Panel_287"):getChildByName("Label_unit_bet"):setString(self.straightBet)
    self.root:getChildByName("Panel_287"):getChildByName("Image_zzbg"):getChildByName("Label_current_total_bet"):setString(bufferData.chip[2])

    local chair_id_ = 0         --获取下注玩家的位置
    local isKanpai_ = false     --获取下注玩家是否看牌，用作动画的选择
    for key, player_ in ipairs(self.playInfoTable) do       --设置加注的玩家的金钱改变
        if bufferData.uid == player_.uid then
            player_.panel:getChildByName("BitmapLabel_21"):setString(bufferData.chip[4])
            player_.panel:getChildByName("Label_score"):setString(bufferData.chip[3])
            player_.money_now = bufferData.chip[3]
            chair_id_ = player_.chairID
            isKanpai_ = player_.isKanpai
        end        
    end
    if bufferData.ply == GlobalUserItem.tabAccountInfo.userid then  --是否轮到自身回合
        self.isMyState = true
        if bufferData.pk == 1 then
            self.isCanBipai = true
        else
            self.isCanBipai = false
        end
    else
        self.isMyState = false
    end
    --播放泡泡框提示动画
    if straightBet_num_last == bufferData.chip[1] or bufferData.chip[1] == 1 then
        local soundIndex = math.random(1,3)
        ExternalFun.playSoundEffect(string.format("Call_0%d.mp3",soundIndex))
        local genzhuAct = ccs.Armature:create("paopaokuang_zhajinhua")
        genzhuAct:setAnchorPoint(cc.p(0,0))
        genzhuAct:setPosition(GameViewLayer.PAOPAOKUANGPOS[chair_id_+1])
	    genzhuAct:addTo(self.root:getChildByName("Panel_287"):getChildByName("choumaHolder"))
	    genzhuAct:getAnimation():play("Animation1")
        local func = function (armature,movementType,movementID)
                if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
                    if armature then 
                        armature:removeFromParent()
                    end
                end
            end
        genzhuAct:getAnimation():setMovementEventCallFunc(func)
    else
        local soundIndex = math.random(1,4)
        ExternalFun.playSoundEffect(string.format("Add_0%d.mp3",soundIndex))
        local jiazhuAct = ccs.Armature:create("paopaokuang_zhajinhua")
        jiazhuAct:setAnchorPoint(cc.p(0,0))
        jiazhuAct:setPosition(GameViewLayer.PAOPAOKUANGPOS[chair_id_+1])
	    jiazhuAct:addTo(self.root:getChildByName("Panel_287"):getChildByName("choumaHolder"))
	    jiazhuAct:getAnimation():play("Animation4")
        local func = function (armature,movementType,movementID)
                if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
                    if armature then 
                        armature:removeFromParent()
                    end
                end
            end
        jiazhuAct:getAnimation():setMovementEventCallFunc(func)
    end
--    --播放手的动画 
    local shouAction = nil
    local name = "anim" .. chair_id_
    if chair_id_ == 2 then
        shouAction = ccs.Armature:create("xiazhu_qian")        
        shouAction:setPosition(cc.p(667,0))
	    shouAction:getAnimation():playWithIndex(0)
    elseif chair_id_ == 1 then
        shouAction = ccs.Armature:create("xiazhu_danshou")        
        shouAction:setPosition(cc.p(0,230))
	    shouAction:getAnimation():playWithIndex(0)
    elseif chair_id_ == 0 then
        shouAction = ccs.Armature:create("xiazhu_danshou")        
        shouAction:setPosition(cc.p(0,500))
	    shouAction:getAnimation():playWithIndex(0)
    elseif chair_id_ == 3 then
        shouAction = ccs.Armature:create("xiazhu_danshou")        
        shouAction:setPosition(cc.p(1000,230))
	    shouAction:getAnimation():playWithIndex(1)
    elseif chair_id_ == 4 then
        shouAction = ccs.Armature:create("xiazhu_danshou")        
        shouAction:setPosition(cc.p(1000,500))
	    shouAction:getAnimation():playWithIndex(1)
    end
    shouAction:setAnchorPoint(cc.p(0,0))
    shouAction:addTo(self.root:getChildByName("Panel_287"):getChildByName("choumaHolder"))
	shouAction:setName(name)
    local funcShou = function(armature,movementType,movementID)
        if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
            self.root:getChildByName("Panel_287"):getChildByName("choumaHolder"):removeChildByName(name)
        end
    end
    shouAction:getAnimation():setMovementEventCallFunc(funcShou)
    --创建筹码及其动画
    local x_1 = math.random(410, 910)
    local y_1 = math.random(330, 410)
    local move_1 = cc.MoveTo:create(0.3,cc.p(x_1,y_1))
    local chip_parent_node = self.root:getChildByName("Panel_287"):getChildByName("choumaHolder")
    if isKanpai_ == false then
        local beishu,ttt = math.modf(bufferData.chip[1]/2)+1
        local chip_1 = cc.Sprite:createWithTexture(self.chipImageRes[beishu])
        chip_parent_node:addChild(chip_1)
        chip_1:setPosition(GameViewLayer.CHIPPOS[chair_id_+1])
        chip_1:setScale(0.6)
        local label_money = cc.LabelBMFont:create("", "goold2zjh/fnt/xuanbeishu.fnt")
        label_money:setPosition(54,55)
        chip_1:addChild(label_money)
        label_money:setString(bufferData.chip[5])
        chip_1:runAction(move_1)
        
        table.insert(self.chip_sprite_table,chip_1)
    else
        local beishu,ttt = math.modf(bufferData.chip[1]/2)+1
        local chip_1 = cc.Sprite:createWithTexture(self.chipImageRes[beishu])
        chip_parent_node:addChild(chip_1)
        chip_1:setPosition(GameViewLayer.CHIPPOS[chair_id_+1])
        chip_1:setScale(0.6)
        local label_money = cc.LabelBMFont:create("", "goold2zjh/fnt/xuanbeishu.fnt")
        label_money:setPosition(54,55)
        chip_1:addChild(label_money)
        label_money:setString(bufferData.chip[5]/2)
        chip_1:runAction(move_1)
        
        local chip_2 = cc.Sprite:createWithTexture(self.chipImageRes[beishu])
        chip_parent_node:addChild(chip_2)
        chip_2:setPosition(GameViewLayer.CHIPPOS[chair_id_+1])
        chip_2:setScale(0.6)
        local label_money_2 = cc.LabelBMFont:create("", "goold2zjh/fnt/xuanbeishu.fnt")
        label_money_2:setPosition(54,55)
        chip_2:addChild(label_money_2)
        label_money_2:setString(bufferData.chip[5]/2)
        local x_2 = math.random(410, 910)
        local y_2 = math.random(330, 410)
        local move_2 = cc.MoveTo:create(0.3,cc.p(x_2,y_2))
        chip_2:runAction(move_2)

        table.insert(self.chip_sprite_table,chip_1)
        table.insert(self.chip_sprite_table,chip_2)
    end
    self:buttonState()
    --倒计时
    for key, player_ in ipairs(self.playInfoTable) do
        if bufferData.ply == player_.uid then
            local chair_id = player_.chairID;
            self.timeOut_progress = bufferData.time
            self:showProgrssTimer(chair_id+1)
        end
    end
end
--发牌
function GameViewLayer:onEventRun(bufferData) 
    print("********************------------onEventRun")
    ExternalFun.playSoundEffect("heguan-fapai.mp3")
    if self.waitOthers ~= nil then
        self.waitOthers:removeFromParent()
        self.waitOthers = nil
    end
    if self.waitNext ~= nil then
        self.waitNext:removeFromParent()
        self.waitNext = nil
    end
    self.straightBet_num = bufferData.rm[2]
    for key, uid_ in ipairs(bufferData.us) do
        if uid_ == GlobalUserItem.tabAccountInfo.userid then
            self.waitNextGame = false
        end
        for key_, player_ in ipairs(self.playInfoTable) do
            if uid_ == player_.uid then
                player_["isCanBipai"] = true
            end
        end
        
    end
    if bufferData.ply == GlobalUserItem.tabAccountInfo.userid then
        self.isMyState = true
        if bufferData.pk == 1 then
            self.isCanBipai = true
        else
            self.isCanBipai = false
        end
    else
        self.isMyState = false
    end
    --压底注动画
    for key, player_ in ipairs(self.playInfoTable) do
        for key, uid_ in ipairs(bufferData.us) do
            if uid_ == player_.uid then
                local chair_id = player_.chairID
                local x_1 = math.random(410, 910)
                local y_1 = math.random(330, 410)
                local move_1 = cc.MoveTo:create(0.3,cc.p(x_1,y_1))
                local chip_parent_node = self.root:getChildByName("Panel_287"):getChildByName("choumaHolder")
                local chip_1 = cc.Sprite:createWithTexture(self.chipImageRes[1])
                chip_parent_node:addChild(chip_1)
                chip_1:setPosition(GameViewLayer.CHIPPOS[chair_id+1])
                chip_1:setScale(0.6)
                local label_money = cc.LabelBMFont:create("", "goold2zjh/fnt/xuanbeishu.fnt")
                label_money:setPosition(54,55)
                chip_1:addChild(label_money)
                label_money:setString(self.antes_)
                chip_1:runAction(move_1)
                table.insert(self.chip_sprite_table,chip_1)
                player_.panel:getChildByName("BitmapLabel_21"):setString(self.antes_)
            end
        end        
    end
    
    self.root:getChildByName("Panel_287"):getChildByName("Image_zzbg"):getChildByName("Label_current_total_bet"):setString(#bufferData.us*self.antes_)
    
    --发牌动画
    local playerNumber = #bufferData.us --本局参与玩家的总数
    local js = 0                        --计数器
    local cardNums = playerNumber *3    --需要创建的牌的总数
    local OnFapaiUpdata = function ()
        if js == cardNums then
            --倒计时
            for key, player_ in ipairs(self.playInfoTable) do
                if bufferData.ply == player_.uid then
                    local chair_id = player_.chairID;
                    self.timeOut_progress = bufferData.time - 3 
                    self:showProgrssTimer(chair_id+1)
                end
            end
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._FaPaiFun)
            self._FaPaiFun = nil
            self:buttonState()
            ExternalFun.playSoundEffect("lottery_xz_start.mp3")
        else
            ExternalFun.playSoundEffect("fapai.mp3")
            local chairId_ = js % playerNumber
            local card_index,ttt = math.modf(js/playerNumber)+1 --第几张牌
            local scaleX_num = 1     --最后的缩放系数X
            local scaleY_num = 1     --最后的缩放系数Y
            local player_ = self.playInfoTable[chairId_+1]
            local card_ = self:createPoker(55)
            card_:addTo(self.root:getChildByName("Panel_287"):getChildByName("Panel_pai"))
            table.insert(player_.cardSpTab,card_)
            card_:setPosition(cc.p(645,475))
            card_:setScale(0.2)
            if player_.chairID == 0 then
                scaleX_num = 0.45
                scaleY_num = 0.35
                card_:setSkewX(20)
            elseif player_.chairID == 1 then
                scaleX_num = 0.55
                scaleY_num = 0.4
                card_:setSkewX(20)
            elseif player_.chairID == 3 then
                scaleX_num = 0.55
                scaleY_num = 0.4
                card_:setSkewX(-20)
            elseif player_.chairID == 4 then
                scaleX_num = 0.45
                scaleY_num = 0.35
                card_:setSkewX(-20)
            end
            card_:runAction(cc.Spawn:create(cc.ScaleTo:create(0.3,scaleX_num,scaleY_num),cc.MoveTo:create(0.3,GameViewLayer.POKERPOS[player_.chairID+1][card_index])))            
        end
        js = js+1
    end
    self._FaPaiFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                OnFapaiUpdata()
            end, 0.2, false) 
end
--中途进入房间
function GameViewLayer:onEventRun2(bufferData) 
    --设置中途进入的自身状态
    for key, info_ in ipairs(bufferData.cs) do
        if info_[1] == GlobalUserItem.tabAccountInfo.userid then
            if info_[4] == 1 then
                self.isHalfWay = true
                --等待下一局游戏开始
                self.waitNext = ccs.Armature:create("dengdai_1")
                self.waitNext:setAnchorPoint(cc.p(0,0))
                self.waitNext:setPosition(cc.p(650,180))
	            self.waitNext:addTo(self.root:getChildByName("Panel_287"):getChildByName("animHodler"))
	            self.waitNext:getAnimation():playWithIndex(0)
            end
        end
    end
    --加载桌面信息
    self.root:getChildByName("Panel_287"):getChildByName("Label_unit_bet"):setString(bufferData.chip[1]*self.antes_)    --当前底注
    for key, player_ in ipairs(self.playInfoTable) do           --遍历表里玩家
        for key_, playerinfo_ in ipairs(bufferData.cs) do
            if player_.uid == playerinfo_[1] then
                player_.panel:getChildByName("BitmapLabel_21"):setString(playerinfo_[3])
                if playerinfo_[4] == 0 then     --参与了本局游戏的玩家
                    if playerinfo_[2] == 0 then         --该玩家为暗牌
                        for i = 1, 3 do
                            player_.isCanBipai = true
                            local card_ = self:createPoker(55)
                            card_:addTo(self.root:getChildByName("Panel_287"):getChildByName("Panel_pai"))
                            table.insert(player_.cardSpTab,card_)
                            if player_.chairID == 2 then-------------------------------------------------
                                card_:setPosition(GameViewLayer.POKERPOS[player_.chairID+1][i])
                                self.isHalfWay = false
                                self.waitNextGame = false
                            elseif player_.chairID == 1 then
                                card_:setSkewX(20)
                                card_:setScaleX(0.55)
                                card_:setScaleY(0.4)
                                card_:setPosition(GameViewLayer.POKERPOS[player_.chairID+1][i])
                            elseif player_.chairID == 0 then
                                card_:setSkewX(20)
                                card_:setScaleX(0.45)
                                card_:setScaleY(0.35)
                                card_:setPosition(GameViewLayer.POKERPOS[player_.chairID+1][i])
                            elseif player_.chairID == 3 then
                                card_:setSkewX(-20)
                                card_:setScaleX(0.55)
                                card_:setScaleY(0.4)
                                card_:setPosition(GameViewLayer.POKERPOS[player_.chairID+1][i])
                            elseif player_.chairID == 4 then
                                card_:setSkewX(-20)
                                card_:setScaleX(0.45)
                                card_:setScaleY(0.35)
                                card_:setPosition(GameViewLayer.POKERPOS[player_.chairID+1][i])
                            end
                        end
                    elseif playerinfo_[2] == 1 then     --该玩家已亮牌
                        player_.isKanpai = true
                        player_.isCanBipai = true
                        for i = 1, 3 do
                            local card_ = self:createPoker(55)
                            card_:addTo(self.root:getChildByName("Panel_287"):getChildByName("Panel_pai"))
                            table.insert(player_.cardSpTab,card_)
                            if player_.chairID == 2 then
                                card_:setPosition(GameViewLayer.POKERPOS[player_.chairID+1][i])                                
                                self.isKanpai = true
                                self.isHalfWay = false
                                self.waitNextGame = false
                            elseif player_.chairID == 1 then
                                card_:setSkewX(20)
                                card_:setScaleX(0.55)
                                card_:setScaleY(0.4)
                                card_:setPosition(GameViewLayer.POKERPOS[player_.chairID+1][i])
                                if i == 3 then
                                    self:PokerInitWithTexture(card_,59)
                                end
                            elseif player_.chairID == 0 then
                                card_:setSkewX(20)
                                card_:setScaleX(0.45)
                                card_:setScaleY(0.35)
                                card_:setPosition(GameViewLayer.POKERPOS[player_.chairID+1][i])
                                if i == 3 then
                                    self:PokerInitWithTexture(card_,59)
                                end
                            elseif player_.chairID == 3 then
                                card_:setSkewX(-20)
                                card_:setScaleX(0.55)
                                card_:setScaleY(0.4)
                                card_:setPosition(GameViewLayer.POKERPOS[player_.chairID+1][i])
                                if i == 3 then
                                    self:PokerInitWithTexture(card_,59)
                                end
                            elseif player_.chairID == 4 then
                                card_:setSkewX(-20)
                                card_:setScaleX(0.45)
                                card_:setScaleY(0.35)
                                card_:setPosition(GameViewLayer.POKERPOS[player_.chairID+1][i])
                                if i == 3 then
                                    self:PokerInitWithTexture(card_,59)
                                end
                            end
                            
                        end
                    elseif playerinfo_[2] == 2 then     --该玩家为弃牌
                        for i = 1, 3 do
                            player_.isCanBipai = false
                            local card_ = self:createPoker(56)
                            card_:addTo(self.root:getChildByName("Panel_287"):getChildByName("Panel_pai"))
                            table.insert(player_.cardSpTab,card_)
                            local shibai = cc.Sprite:create("goold2zjh/zjh/ts/paimian_qipai.png")
                            shibai:setPosition(GameViewLayer.QIPAIPOS[player_.chairID+1])
                            self.root:getChildByName("Panel_287"):getChildByName("animHodler"):addChild(shibai)
                            if player_.chairID == 2 then
                                card_:setPosition(GameViewLayer.POKERPOS[player_.chairID+1][i])
                                self.isQipai = true
                            elseif player_.chairID == 1 then
                                card_:setScaleX(0.55)
                                card_:setScaleY(0.4)
                                card_:setPosition(GameViewLayer.POKERPOS[player_.chairID+1][i])
                                if i == 1 then
                                    card_:setRotation(-20)
                                    card_:runAction(cc.MoveBy:create(0,cc.p(30,-7)))
                                elseif i == 2 then
                                    card_:runAction(cc.MoveBy:create(0,cc.p(20,0)))
                                elseif i == 3 then
                                    card_:setRotation(20)
                                    card_:runAction(cc.MoveBy:create(0,cc.p(10,7)))
                                end
                            elseif player_.chairID == 0 then
                                card_:setScaleX(0.45)
                                card_:setScaleY(0.35)
                                card_:setPosition(GameViewLayer.POKERPOS[player_.chairID+1][i])
                                if i == 1 then
                                    card_:setRotation(-20)
                                    card_:runAction(cc.MoveBy:create(0,cc.p(30,-7)))
                                elseif i == 2 then
                                    card_:runAction(cc.MoveBy:create(0,cc.p(20,0)))
                                elseif i == 3 then
                                    card_:setRotation(20)
                                    card_:runAction(cc.MoveBy:create(0,cc.p(10,7)))
                                end
                            elseif player_.chairID == 3 then
                                card_:setScaleX(0.55)
                                card_:setScaleY(0.4)
                                card_:setPosition(GameViewLayer.POKERPOS[player_.chairID+1][i])
                                if i == 1 then
                                    card_:setRotation(-20)
                                    card_:runAction(cc.MoveBy:create(0,cc.p(-10,-7)))
                                elseif i == 2 then
                                    card_:runAction(cc.MoveBy:create(0,cc.p(-20,0)))
                                elseif i == 3 then
                                    card_:setRotation(20)
                                    card_:runAction(cc.MoveBy:create(0,cc.p(-30,7)))
                                end
                            elseif player_.chairID == 4 then
                                card_:setScaleX(0.45)
                                card_:setScaleY(0.35)
                                card_:setPosition(GameViewLayer.POKERPOS[player_.chairID+1][i])
                                if i == 1 then
                                    card_:setRotation(-20)
                                    card_:runAction(cc.MoveBy:create(0,cc.p(-10,-7)))
                                elseif i == 2 then
                                    card_:runAction(cc.MoveBy:create(0,cc.p(-20,0)))
                                elseif i == 3 then
                                    card_:setRotation(20)
                                    card_:runAction(cc.MoveBy:create(0,cc.p(-30,7)))
                                end
                            end                                                       
                        end
                    end                
                end
            end
        end        
    end
    for key, player_ in ipairs(self.playInfoTable) do
        if player_.uid == GlobalUserItem.tabAccountInfo.userid and #bufferData.cards == 3 then
            for i = 1, 3 do
                self:PokerInitWithTexture(player_.cardSpTab[i],bufferData.cards[i]+1)
            end            
        end
        --倒计时
        if bufferData.pid[2] == player_.uid then
            local chair_id = player_.chairID;
            self.timeOut_progress = bufferData.time
            self:showProgrssTimer(chair_id+1)
        end
    end

    
    if bufferData.pid[2] == GlobalUserItem.tabAccountInfo.userid then
        self.isMyState = true
    end
    self:buttonState()

    
end
--看牌
function GameViewLayer:onEventShow(bufferData) 
    local soundIndex = math.random(1,3)
    ExternalFun.playSoundEffect(string.format("Look_0%d.mp3",soundIndex))
    for key, player_ in ipairs(self.playInfoTable) do
        if bufferData.uid == player_.uid then
            self:PokerInitWithTexture(player_.cardSpTab[3],59)
            player_.isKanpai = true
            if bufferData.uid == GlobalUserItem.tabAccountInfo.userid then
                self.isKanpai = true
                for i = 1, 3 do
                    self:PokerInitWithTexture(player_.cardSpTab[i],bufferData.cards[i]+1)
                end                
                for i = 1, 5 do
                    self.chipButtonLabel[i]:setString(self.antes_*i*4)
                end                
            end
            --播放泡泡框动画
            local kanpaiAct = ccs.Armature:create("paopaokuang_zhajinhua")
            kanpaiAct:setAnchorPoint(cc.p(0,0))
            kanpaiAct:setPosition(GameViewLayer.PAOPAOKUANGPOS[player_.chairID+1])
	        kanpaiAct:addTo(self.root:getChildByName("Panel_287"):getChildByName("choumaHolder"))
	        kanpaiAct:getAnimation():play("Animation5")
            local func = function (armature,movementType,movementID)
                    if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
                        if armature then 
                            armature:removeFromParent()
                        end
                    end
                end
            kanpaiAct:getAnimation():setMovementEventCallFunc(func)
        end
    end    
    self:buttonState()
end
--比牌
function GameViewLayer:onEventVS(bufferData)  
    ExternalFun.playSoundEffect("PK_01.mp3")
    for key, player_ in ipairs(self.playInfoTable) do
        player_.panel:getChildByName("Image_select"):removeAllChildren()
    end
    
    if bufferData.pid[1][3] == GlobalUserItem.tabAccountInfo.userid then
        self.waitNextGame = true
    end
    
    for key, player_ in ipairs(self.playInfoTable) do
        if player_.uid == bufferData.pid[1][3] then
            player_["isCanBipai"] = false
        end
    end
    
    self.root:getChildByName("Panel_287"):getChildByName("Image_zzbg"):getChildByName("Label_current_total_bet"):setString(bufferData.chip[3])  --更新总下注
    for key, player_ in ipairs(self.playInfoTable) do
        if player_.uid == bufferData.pid[1][1] then
            player_.panel:getChildByName("BitmapLabel_21"):setString(bufferData.chip[4])    --更新发起PK玩家下注钱数
            player_.panel:getChildByName("Label_score"):setString(bufferData.chip[5])       --更新发起PK玩家剩余钱数
        end
    end
    
    --播放比牌动画--------------------------------------------------------------------------------------------------------------
    local pk_parent_node = self.root:getChildByName("Panel_287"):getChildByName("Panel_touch"):setZOrder(101)
    pk_parent_node:setTouchEnabled(false)
    pk_parent_node:setSwallowTouches(false)
    pk_parent_node:setVisible(true)
    local bipai = ccs.Armature:create("pk_bipai")
    bipai:setAnchorPoint(cc.p(0.5,0))
    bipai:setPosition(cc.p( 667, 0))
	bipai:addTo(pk_parent_node)
	bipai:getAnimation():playWithIndex(0)
    local func = function (armature,movementType,movementID)
            if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
                if armature then 
                    armature:removeFromParent()
                end
            end
        end
    bipai:getAnimation():setMovementEventCallFunc(func)
    
    --创建头像动画---------------------------------
    local str_namePk_1 = nil    --发起比牌玩家的名字
    local str_namePk_2 = nil
    local sp_iconPk_1 = nil     --发起比牌玩家的头像
    local sp_iconPk_2 = nil
    local biPai_uid_1 = bufferData.pid[1][1]    --发起比牌玩家的ID
    local biPai_uid_2 = nil
    local bipai_chairId_1 = nil --发起比牌玩家的椅子坐标
    local bipai_chairId_2 = nil 
    if bufferData.pid[1][2] == biPai_uid_1 then
        biPai_uid_2 = bufferData.pid[1][3]
    else
        biPai_uid_2 = bufferData.pid[1][2]
    end
    for key, player_ in ipairs(self.playInfoTable) do
        if player_.uid == biPai_uid_1 then     --发起比牌的玩家
            str_namePk_1 = player_.nickname
            sp_iconPk_1 = HeadSprite:createClipHead(player_, 100)
            sp_iconPk_1:setAnchorPoint(cc.p(0.5,0.5))
            bipai_chairId_1 = player_.chairID
        end
        if player_.uid == biPai_uid_2 then     --被比牌的玩家
            str_namePk_2 = player_.nickname
            sp_iconPk_2 = HeadSprite:createClipHead(player_, 100)
            sp_iconPk_2:setAnchorPoint(cc.p(0.5,0.5))
            bipai_chairId_2 = player_.chairID
        end
    end
    
    local label0 = ccui.Text:create(str_namePk_1 , "Arial", 18)
    label0:setTextColor(cc.c3b(255,255,255))
    
    local label1 = ccui.Text:create(str_namePk_2 , "Arial", 18)
    label1:setTextColor(cc.c3b(255,255,255))
    
    local namebg0 = ccui.ImageView:create("goold2zjh/zjh/bipai_name.png", ccui.TextureResType.localType)
    local namebg1 = ccui.ImageView:create("goold2zjh/zjh/bipai_name.png", ccui.TextureResType.localType)

--    local head0 = ccui.ImageView:create(strHeadIcon, ccui.TextureResType.localType)
--    local head1 = ccui.ImageView:create(strHeadIcon1, ccui.TextureResType.localType)

    local scaleHead = 110/sp_iconPk_1:getContentSize().width
    
    sp_iconPk_1:setScale(110/sp_iconPk_1:getContentSize().width)
    sp_iconPk_2:setScale(110/sp_iconPk_2:getContentSize().width)

    pk_parent_node:addChild(sp_iconPk_1,100)
    pk_parent_node:addChild(sp_iconPk_2,100)

    sp_iconPk_1:addChild(namebg0,100)
    sp_iconPk_2:addChild(namebg1,100)
    namebg0:setPosition(cc.p(sp_iconPk_1:getContentSize().width/2, -20))
    namebg1:setPosition(cc.p(sp_iconPk_2:getContentSize().width/2, -20))
    
    namebg0:addChild(label0)
    namebg1:addChild(label1)
    label0:setPosition(cc.p(namebg0:getContentSize().width/2, namebg0:getContentSize().height/2))
    label1:setPosition(cc.p(namebg1:getContentSize().width/2, namebg0:getContentSize().height/2))
    --坐标和动作列表
    local headPy = pk_parent_node:getContentSize().height/2+ sp_iconPk_1:getContentSize().height/2 -35
    
    sp_iconPk_1:setPosition(cc.p(-230, headPy))
    sp_iconPk_2:setPosition(cc.p(pk_parent_node:getContentSize().width+230, headPy))
    

    --头像入场终点坐标
    local leftEnd = cc.p(430,headPy + 50)
    local rightEnd = cc.p(904,headPy+20)

    --头像回去的坐标
    local backLeftPos = cc.p(70, 98)
    backLeftPos = GameViewLayer.PLAYER_ICON_POS[bipai_chairId_1+1]
    
    local backrightPos = cc.p(70, 98)    --fakePlayerPos[i]
    backrightPos = GameViewLayer.PLAYER_ICON_POS[bipai_chairId_2+1]

    --头像入场动作
    local moveleft = cc.MoveTo:create(0.3, leftEnd)
    local moveRight = cc.MoveTo:create(0.3, rightEnd)
    --比牌缩放
--    local flag = (biPai_uid_1 == bufferData.pid[3])
    local function func()
        if biPai_uid_1 == bufferData.pid[3] then
            sp_iconPk_1:setColor(cc.c3b(150,150,150))
        else
            sp_iconPk_2:setColor(cc.c3b(150,150,150))
        end
    end
    local scaleSmall =  cc.Spawn:create(cc.ScaleTo:create(0.5,scaleHead-0.03),cc.CallFunc:create(func))
    local scaleBig = cc.Spawn:create(cc.ScaleTo:create(0.5,scaleHead+0.03))

    local function funcT()
        namebg0:setVisible(false)
    end

    local function funcTh()
        namebg1:setVisible(false)
    end
    
    --比牌结束后返回 并隐藏名字
    local moveBack_left = cc.Spawn:create(cc.MoveTo:create(0.5,backLeftPos), cc.CallFunc:create(funcT))
    local moveBack_right = cc.Spawn:create(cc.MoveTo:create(0.5,backrightPos), cc.CallFunc:create(funcTh))
    --最终回调  比牌结束 和 比牌 后 牌的状态改变    
    local function funcF(args)
        pk_parent_node:setVisible(true)
        pk_parent_node:stopAllActions()
        pk_parent_node:removeAllChildren()
        for key, player_ in ipairs(self.playInfoTable) do
            if bufferData.pid[1][3] == player_.uid then
                player_.panel:setColor(cc.c3b(150,150,150))               
                if bufferData.pid[1][3] ~= GlobalUserItem.tabAccountInfo.userid then
                    for i = 1,3 do
                        self:PokerInitWithTexture(player_.cardSpTab[i],56)
                    end
                else
                    if self.isKanpai == false then
                        for i = 1,3 do
                            self:PokerInitWithTexture(player_.cardSpTab[i],56)
                        end
                    end
                end
                local shibai = cc.Sprite:create("goold2zjh/zjh/ts/lose_b.png")
                shibai:setPosition(GameViewLayer.QIPAIPOS[player_.chairID+1])                
                if bufferData.pid[1][3] ~= GlobalUserItem.tabAccountInfo.userid then
                    shibai:setScale(0.7)
                end
                self.root:getChildByName("Panel_287"):getChildByName("animHodler"):addChild(shibai)
            end
        end
        
    end
    local fun_left = nil
    local fun_right = nil
    if biPai_uid_1 == bufferData.pid[3] then
        fun_left = scaleSmall
        fun_right = scaleBig
    else
        fun_left = scaleBig
        fun_right = scaleSmall
    end
    local actionList_left = cc.Sequence:create(moveleft, cc.DelayTime:create(0.5),fun_left, cc.DelayTime:create(1.0),moveBack_left)
    local actionList_right = cc.Sequence:create(moveRight, cc.DelayTime:create(0.5),fun_right, cc.DelayTime:create(1.0),moveBack_right,cc.CallFunc:create(funcF))
    
    sp_iconPk_1:runAction(actionList_left)
    sp_iconPk_2:runAction(actionList_right)
    
    local function funcFi()
        ExternalFun.playSoundEffect("goold2zjh/zjh/sound/gamesolo.mp3")
    end
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(funcFi)))
    --倒计时
    for key, player_ in ipairs(self.playInfoTable) do
        if bufferData.ply == player_.uid then
            local chair_id = player_.chairID;
            self.timeOut_progress = bufferData.time
            self:showProgrssTimer(chair_id+1)
        end
    end
    if bufferData.ply == GlobalUserItem.tabAccountInfo.userid then
        self.isMyState = true
        if bufferData.pk == 1 then
            self.isCanBipai = true
        else
            self.isCanBipai = false
        end
        self:runAction(cc.Sequence:create( cc.DelayTime:create(3),cc.CallFunc:create(function()
                self:buttonState()
            end) ))
    else
        self:buttonState()
    end
    
end
--结算
function GameViewLayer:onEventOver(bufferData)    
    
    local isZdqp = true --self.isZidongQipai   --是否是自动弃牌
    local funAction = cc.CallFunc:create(function()
        self.timeOut_progress = 3
        self:showProgrssTimer(3)
        local winMoney = 0;
        local winChairId = nil
        for key, info_ in ipairs(bufferData.cs) do
            if bufferData.win == info_[1] then
                winMoney = info_[2]
            end
        end
    
        for key, player_ in ipairs(self.playInfoTable) do
            player_.panel:getChildByName("BitmapLabel_21"):setString(0)
            if bufferData.win == player_.uid then
                player_.money_now = player_.money_now + winMoney
                player_.panel:getChildByName("Label_score"):setString(player_.money_now)
                winChairId = player_.chairID
            end
        end
    
        for key, info_ in ipairs(bufferData.gold_nn) do
            for key_, player_ in ipairs(self.playInfoTable) do
                if info_[2][1] ~= nil then      --展示可以展示的牌面
                    if info_[1] == player_.uid then
                        for i = 1, 3 do
                            local card_ = player_.cardSpTab[i]
                            self:PokerInitWithTexture(card_,info_[2][i]+1)
                        end
                    end
                end
                if info_[1] == player_.uid then
                    local panel_win_lose = nil      --展示输赢的钱数动画
                    if info_[4] > 0 then    
                        player_.panel:getChildByName("Panel_y"):setVisible(true)
                        panel_win_lose = player_.panel:getChildByName("Panel_y"):getChildByName("BitmapLabel_WinScore"):setString("+"..info_[4])
                        player_.panel:getChildByName("Panel_y"):getChildByName("Image_24"):setVisible(true)
                        if player_.uid == GlobalUserItem.tabAccountInfo.userid then
                            ExternalFun.playSoundEffect("game_win.mp3")
                        end
                    else
                        player_.panel:getChildByName("Panel_s"):setVisible(true)
                        panel_win_lose = player_.panel:getChildByName("Panel_s"):getChildByName("BitmapLabel_WinScore"):setString(info_[4])
                        if player_.uid == GlobalUserItem.tabAccountInfo.userid and info_[2] ~= 0 then
                            ExternalFun.playSoundEffect("game_lose.mp3")
                        end
                    end
                    panel_win_lose:runAction( cc.Sequence:create( cc.MoveBy:create(1,cc.p(0,10)),cc.CallFunc:create(function()
                    end) ) )
                end
            end       
        end
        for key, chip_ in ipairs(self.chip_sprite_table) do
            chip_:runAction(cc.Sequence:create( cc.MoveTo:create(1,GameViewLayer.PLAYER_ICON_POS[winChairId+1]),cc.CallFunc:create(function()
                chip_:removeFromParent()
            end) ))
        end
    end)
    --延时恢复为初始状态的
    local funTo0 = cc.CallFunc:create(function()         
        for key, player_ in ipairs(self.playInfoTable) do
            for key_, card_ in ipairs(player_.cardSpTab) do
                card_:removeFromParent()
            end
            player_.cardSpTab = {}
            player_.isKanpai = false
            self.root:getChildByName("Panel_287"):getChildByName("animHodler"):removeAllChildren()
            self.waitNext = nil
            --输赢钱归位
            player_.panel:getChildByName("Panel_y"):setVisible(false)
            player_.panel:getChildByName("Panel_s"):setVisible(false)
            player_.panel:getChildByName("Panel_y"):getChildByName("BitmapLabel_WinScore"):setPosition(GameViewLayer.WIN_LOSE_LABEL_POS[player_.chairID+1])
            player_.panel:getChildByName("Panel_s"):getChildByName("BitmapLabel_WinScore"):setPosition(GameViewLayer.WIN_LOSE_LABEL_POS[player_.chairID+1])
        end
        --清楚全部筹码
        self.root:getChildByName("Panel_287"):getChildByName("choumaHolder"):removeAllChildren()
        self.chip_sprite_table = {}
        
    end)
    --延时发送准备
    local fun_ready = cc.CallFunc:create(function()
        if isZdqp == false then
            self._scene:sendReady()
        else 
            self.root:getChildByName("compareBg"):setVisible(true)
            self.root:getChildByName("Panel_Entrust"):setVisible(true)
            self.isZidongQipai = false
        end
    end)
    self:runAction(cc.Sequence:create( funAction,cc.DelayTime:create(2),funTo0,cc.DelayTime:create(1),fun_ready ))
end
--游戏结束
function GameViewLayer:onEventDeskover(bufferData)
--    if self.isZidongQipai == true then                 --时间到了自动弃牌
--        self.root:getChildByName("compareBg"):setVisible(true)
--        self.root:getChildByName("Panel_Entrust"):setVisible(true)
--        self.isZidongQipai = false
--    end
    --及时恢复为初始状态的
    self.root:getChildByName("Panel_287"):getChildByName("CheckBox_gdd"):getChildByName("Image_a"):setVisible(true)
    self.root:getChildByName("Panel_287"):getChildByName("CheckBox_gdd"):getChildByName("Image_l"):setVisible(false)
    self.isKanpai =  false
    self.isHalfWay = false
    self.isQipai = false
    self.isGendaodi = false    
    self.straightBet = 0        --单注
    self.straightBet_num = 0    --单注（0-10）
    self.totalBet = 0           --总下注
    self.root:getChildByName("Panel_287"):getChildByName("Label_unit_bet"):setString(self.straightBet)
    self.root:getChildByName("Panel_287"):getChildByName("Image_zzbg"):getChildByName("Label_current_total_bet"):setString(self.totalBet)
    for i = 1, 5 do
        self.chipButtonLabel[i]:setString(self.antes_*i*2)
    end
end
--加载玩家信息
function GameViewLayer:loadPlayerInfo(playerInfo)
    local isHave = false    --判断玩家信息表中是否已存在该玩家信息
    for key, player_ in ipairs(self.playInfoTable) do
        if playerInfo.uid == player_.uid then
            isHave = true
        end
    end
    if isHave ~= true then
        table.insert(self.playInfoTable,playerInfo)
    end
    playerInfo["chairID"] = self:SwitchViewChairID(playerInfo.position)

    local panel_ = nil
    if playerInfo.chairID == 2 then
        panel_ = ccs.GUIReader:getInstance():widgetFromJsonFile("goold2zjh/player_ui_me.json") 
    elseif playerInfo.chairID == 1 or playerInfo.chairID == 0 then
        panel_ = ccs.GUIReader:getInstance():widgetFromJsonFile("goold2zjh/player_ui.json")
    elseif playerInfo.chairID == 3 or playerInfo.chairID == 4 then
        panel_ = ccs.GUIReader:getInstance():widgetFromJsonFile("goold2zjh/player_ui_0.json") 
    end
    panel_:getChildByName("Label_name"):setString(playerInfo.nickname)
    panel_:getChildByName("Label_score"):setString(playerInfo.into_money)
    local icon = panel_:getChildByName("Button_head")
    local head = HeadSprite:createClipHead(playerInfo, 100)
    head:setAnchorPoint(cc.p(0.08,0.08))
    head:setScale(120/head:getContentSize().width)
    icon:addChild(head)
    panel_:addTo(self.root:getChildByName("Panel_287"):getChildByName("node_player"):getChildByName("player_node_"..playerInfo.chairID))
    playerInfo["money_now"] = playerInfo.into_money         --玩家身上的钱
    playerInfo["panel"] = panel_                            --玩家panel
    panel_:getChildByName("BitmapLabel_21"):setString("0")  --玩家自身总下注
    panel_:getChildByName("Image_Banker"):setVisible(false) --庄家角标
    playerInfo["cardSpTab"] = {}                            --存放玩家牌的表
    playerInfo["isKanpai"] = false                          --玩家是否看牌标志位
    playerInfo["isCanBipai"] = false                           --玩家是否可以被比牌
    local fun_bipai = function(ref, tType)
        if tType == ccui.TouchEventType.ended then          
           self._scene:sendVS(playerInfo.uid)
        end
    end
    panel_:getChildByName("Image_select"):addTouchEventListener(fun_bipai)
end
--按钮的回调事件
function GameViewLayer:onButtonClickedEvent(Tag,Ref)
    for key, player_ in ipairs(self.playInfoTable) do
        player_.panel:getChildByName("Image_select"):removeAllChildren()
        player_.panel:getChildByName("Image_select"):setVisible(false)
    end

    if Tag == GameViewLayer.BTN_GENDAODI then       --跟到底
        if self.isGendaodi == false then
            self.isGendaodi = true
            self.root:getChildByName("Panel_287"):getChildByName("CheckBox_gdd"):getChildByName("Image_l"):setVisible(true)
            self.root:getChildByName("Panel_287"):getChildByName("CheckBox_gdd"):getChildByName("Image_a"):setVisible(false)
            self:buttonState()
        else
            self.root:getChildByName("Panel_287"):getChildByName("CheckBox_gdd"):getChildByName("Image_a"):setVisible(true)
            self.root:getChildByName("Panel_287"):getChildByName("CheckBox_gdd"):getChildByName("Image_l"):setVisible(false)
            self.isGendaodi = false
            self:buttonState()
        end        
    elseif Tag == GameViewLayer.BTN_QIPAI then      --弃牌
        self.isZidongQipai = true
        self._scene:sendDrop()
    elseif Tag == GameViewLayer.BTN_BIPAI then      --比牌
        self:onClickBipaiEvent()
    elseif Tag == GameViewLayer.BTN_KANPAI then     --看牌
        self._scene:sendShow()
    elseif Tag == GameViewLayer.BTN_JIAZHU then     --加注
        self.root:getChildByName("Panel_chips"):setVisible(true)
        for i = 1, 5 do
            local btn_bet = self.root:getChildByName("Panel_chips"):getChildByName(string.format("Button_chip%d",i-1))
            if self.straightBet_num >= i*2 then
                btn_bet:setTouchEnabled(false)
                btn_bet:setBright(false)
            else
                btn_bet:setTouchEnabled(true)
                btn_bet:setBright(true)
            end
        end        
    elseif Tag == GameViewLayer.BTN_XIAZHU then     --下注
--        self._scene:sendAdd(self.straightBet_num)
        self._scene:sendAdd(0)
    elseif Tag == GameViewLayer.BTN_QUANXIA then    --全下---------------
    
    elseif Tag == GameViewLayer.BTN_LIKAIYOUXI then --离开游戏
        self.root:getChildByName("compareBg"):setVisible(false)
        self.root:getChildByName("Panel_Entrust"):setVisible(false)
        self._scene:onQueryExitGame()
    elseif Tag == GameViewLayer.BTN_JIXUYOUXI then  --继续游戏
        self.root:getChildByName("compareBg"):setVisible(false)
        self.root:getChildByName("Panel_Entrust"):setVisible(false)
        self._scene:sendReady()
    elseif Tag == GameViewLayer.BTN_LIANGPAI then   --亮牌----------------

    end 
end
function GameViewLayer:onClickBipaiEvent()
    for key, player_ in ipairs(self.playInfoTable) do
        if player_.uid ~= GlobalUserItem.tabAccountInfo.userid then
            if player_.isCanBipai == true then
                --播放泡泡框动画
                local node_actParent = player_.panel:getChildByName("Image_select"):setVisible(true)
                local kebipaiAct = ccs.Armature:create("kebipai_1")
                kebipaiAct:setAnchorPoint(cc.p(0,0))
                kebipaiAct:setPosition(cc.p(0,0))
                node_actParent:removeAllChildren()
	            kebipaiAct:addTo(node_actParent)
	            kebipaiAct:getAnimation():playWithIndex(0)
                node_actParent:setTouchEnabled(true)
            end
        end
    end
    
end
--不同回合和自身回合按钮的状态
function GameViewLayer:buttonState()
    local btn_Gendaodi = self.root:getChildByName("Panel_287"):getChildByName("CheckBox_gdd")     --跟到底
    local btn_Qipai = self.root:getChildByName("Panel_287"):getChildByName("Button_qp")     --弃牌
    local btn_Bipai = self.root:getChildByName("Panel_287"):getChildByName("Button_bp")     --比牌
    local btn_Kanpai = self.root:getChildByName("Panel_287"):getChildByName("Button_kp")    --看牌
    local btn_Genzhu = self.root:getChildByName("Panel_287"):getChildByName("Button_gz")    --跟注
    local btn_Jiazhu = self.root:getChildByName("Panel_287"):getChildByName("Button_jz")    --加注
    local btn_Quanxia = self.root:getChildByName("Panel_287"):getChildByName("Button_qx")   --全下
    --自身回合
    if self.isMyState == true then

        if self.isGendaodi == true then
            print("_________________________________true")
            self._scene:sendAdd(0)
        else
            print("_________________________________false")
        end
        btn_Gendaodi:setTouchEnabled(true)
        btn_Gendaodi:setBright(true)
        btn_Qipai:setTouchEnabled(true)
        btn_Qipai:setBright(true)
        if self.isCanBipai == true then
            btn_Bipai:setTouchEnabled(true)
            btn_Bipai:setBright(true)
        else
            btn_Bipai:setTouchEnabled(false)
            btn_Bipai:setBright(false)
        end        
        btn_Kanpai:setTouchEnabled(true)
        btn_Kanpai:setBright(true)
        btn_Genzhu:setTouchEnabled(true)
        btn_Genzhu:setBright(true)            
        btn_Quanxia:setVisible(true)
        btn_Quanxia:setVisible(false)
        btn_Jiazhu:setTouchEnabled(false)
        btn_Jiazhu:setBright(false)
        if self.straightBet < self.straightBet_Max then
            btn_Jiazhu:setTouchEnabled(true)
            btn_Jiazhu:setBright(true)
        end
        if self.isKanpai == true then
            btn_Kanpai:setTouchEnabled(false)
            btn_Kanpai:setBright(false)
        end
    else
        btn_Gendaodi:setTouchEnabled(true)
        btn_Gendaodi:setBright(true)
        btn_Qipai:setTouchEnabled(false)
        btn_Qipai:setBright(false)
        btn_Bipai:setTouchEnabled(false)
        btn_Bipai:setBright(false)            
        btn_Genzhu:setTouchEnabled(false)
        btn_Genzhu:setBright(false)
        btn_Jiazhu:setTouchEnabled(false)
        btn_Jiazhu:setBright(false)
        btn_Quanxia:setVisible(false)
        if self.isKanpai then
            btn_Kanpai:setTouchEnabled(false)
            btn_Kanpai:setBright(false)
        else
            btn_Kanpai:setTouchEnabled(true)
            btn_Kanpai:setBright(true)
        end
    end
    --已经弃牌
    if self.isQipai == true then
        btn_Gendaodi:setTouchEnabled(false)
        btn_Gendaodi:setBright(false)
        btn_Qipai:setTouchEnabled(false)
        btn_Qipai:setBright(false)
        btn_Bipai:setTouchEnabled(false)
        btn_Bipai:setBright(false)
        btn_Kanpai:setTouchEnabled(false)
        btn_Kanpai:setBright(false)
        btn_Genzhu:setTouchEnabled(false)
        btn_Genzhu:setBright(false)
        btn_Jiazhu:setTouchEnabled(false)
        btn_Jiazhu:setBright(false)
        btn_Quanxia:setVisible(false)
        self.root:getChildByName("Panel_chips"):setVisible(false)
    end
    --中途进入游戏
    if self.isHalfWay == true or self.waitNextGame == true then
        btn_Gendaodi:setTouchEnabled(false)
        btn_Gendaodi:setBright(false)
        btn_Qipai:setTouchEnabled(false)
        btn_Qipai:setBright(false)
        btn_Bipai:setTouchEnabled(false)
        btn_Bipai:setBright(false)
        btn_Kanpai:setTouchEnabled(false)
        btn_Kanpai:setBright(false)
        btn_Genzhu:setTouchEnabled(false)
        btn_Genzhu:setBright(false)
        btn_Jiazhu:setTouchEnabled(false)
        btn_Jiazhu:setBright(false)
        btn_Quanxia:setVisible(false)
    end
end
--创建存放全部扑克精灵的数组
function GameViewLayer:createPokerArray()
    local fWidth = self.pTex:getContentSize().width % 13
    local fHeight = self.pTex:getContentSize().height / 13
    for i = 1, 59 do
        local index_ = i
        if index_ == 53 then
            index_ = 54
        elseif index_ == 54 then
            index_ = 53
        end
        local value = index_%13
        local color ,ttt = math.modf(index_-1/13);
        local x = (value-1)*fWidth
	    local y = color*fHeight
        local cardRect = cc.rect(x,y,fWidth,fHeight);
        local card_ = cc.Sprite:createWithTexture(self.pTex,cardRect)
        card_:setPosition(cc.p(0,0))
        card_:setAnchorPoint(cc.p(0,0))
        table.insert(self.pokerTable,card_)
    end
end
function GameViewLayer:createPoker(pDate)
    
    local fWidth = self.pTex:getContentSize().width / 13
    local fHeight = self.pTex:getContentSize().height / 5

    local index_ = pDate
    if pDate == 53 then
        index_ = 54
    elseif pDate == 54 then
        index_ = 53
    end
    local value = index_%13
    local color ,ttt = math.modf((index_-1)/13);
    local x = (value-1)*fWidth
	local y = color*fHeight
    local cardRect = cc.rect(x,y,fWidth,fHeight);
    local card_ = cc.Sprite:createWithTexture(self.pTex,cardRect)
    card_:setPosition(cc.p(0,0))
    card_:setAnchorPoint(cc.p(0,0))
    return card_
end

function GameViewLayer:PokerInitWithTexture(Poker_,pDate)
    local fWidth = self.pTex:getContentSize().width / 13
    local fHeight = self.pTex:getContentSize().height / 5
    
    if pDate == 14 then
        pDate = 1
    elseif pDate == 27 then
        pDate = 14
    elseif pDate == 40 then
        pDate = 27
    elseif pDate == 53 then
        pDate = 40
    end    
    local index_ = pDate - 1
    if pDate == 53 then
        index_ = 54
    elseif pDate == 54 then
        index_ = 53
    end
    local value = index_%13
    local color ,ttt = math.modf(index_/13);
    local x = value*fWidth
	local y = color*fHeight
    local cardRect = cc.rect(x,y,fWidth,fHeight);
    if Poker_ then
        Poker_:initWithTexture(self.pTex,cardRect)
        Poker_:setAnchorPoint(cc.p(0,0))
    end    
end
-- 时钟接口
--玩家头像进度条
function GameViewLayer:showProgrssTimer( i)
    if i < 1 or i > 6 then return end
    local node_parent = self.root:getChildByName("Panel_287"):getChildByName("node_player")
    if not self.m_pProgressTimer[i] then
        self.m_pProgressTimer[i] = ProgressNode.create()
        if not self.m_pProgressTimer[i] then return end
        self.m_pProgressTimer[i]:setPosition(GameViewLayer.PLAYER_ICON_POS[i])

        node_parent:addChild(self.m_pProgressTimer[i],99,999)
    end
    for m = 1, 5 do
        if self.m_pProgressTimer[m] and i ~= m then
            self.m_pProgressTimer[m]:setVisible(false)
        end
    end
    
    local countTime = 0 
    countTime = self.timeOut_progress
--    local gameStatus = self.deskState
--    if self.deskState == GameViewLayer.STATE_ONZHUNBEI then
--        countTime = self.timeOut_progress
--    elseif self.deskState == GameViewLayer.STATE_QIANGZHUANG then
--        countTime = self.timeOut_progress
--    elseif self.deskState == GameViewLayer.STATE_XIAZHU then
--        countTime = self.timeOut_progress
--    elseif self.deskState == GameViewLayer.STATE_LIANGPAI then
--        countTime = self.timeOut_progress
--    end

    self.m_pProgressTimer[i]:setParameters(countTime,cc.c3b(255,255,255), 100)
    self.m_pProgressTimer[i]:setVisible(true)

    self.m_pProgressTimer[i]:startCount()
end

function GameViewLayer:SwitchViewChairID(chair)
    local viewid = yl.INVALID_CHAIR
    local nChairCount = self.max_player_num
    local nChairID = self.myPos_
    if chair ~= yl.INVALID_CHAIR and chair < nChairCount then
        viewid = math.mod(chair + math.floor(nChairCount * 3/2) - nChairID, nChairCount)
--        viewid = math.mod(chair + self.max_player_num +1 - nChairID, nChairCount) - 1
    end
    return viewid
end
-----------------------------------------------------------------------------------------------------------------
--*************************************************************************************************************--
-----------------------------------------------------------------------------------------------------------------
-------------------------------------------------------分界线-------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------- 分界线 --------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------


function GameViewLayer:getParentNode()
    return self._scene
end






function GameViewLayer:unloadResource()
--    if self.bgAnimation then
--        self.bgAnimation:removeFromParent()    
--    end
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/heguan_1/heguan_1.ExportJson")   --荷官
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/dengdai_1/dengdai_1.ExportJson")   --等待下一局
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/wait-player/wait-player.ExportJson")   --等待其他玩家
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/paopaokuang_zhajinhua/paopaokuang_zhajinhua.ExportJson")   --泡泡框提示
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/pk_bipai/pk_bipai.ExportJson")   --比牌
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/qipai/qipai.ExportJson")   --弃牌
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/xiazhu_danshou/xiazhu_danshou.ExportJson")   --下注单手左右
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/xiazhu_qian/xiazhu_qian.ExportJson")   --下注单手自身
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/allin_you2/allin_you2.ExportJson")   --下注双手左右
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/allin_qian/allin_qian.ExportJson")   --下注双手自身
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("goold2zjh/zjh/effect/kebipai_1/kebipai_1.ExportJson")        --可比牌
    for key, res_ in ipairs(GameViewLayer.chipSpRec) do
        cc.Director:getInstance():getTextureCache():removeTextureForKey(res_)
    end


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
    if self._FaPaiFun ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._FaPaiFun) 
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


return GameViewLayer