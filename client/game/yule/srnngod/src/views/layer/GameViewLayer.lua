-- 四人牛牛
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local module_pre = "game.yule.srnngod.src"
local cmd = appdf.req(module_pre .. ".models.CMD_Game")
local Define = appdf.req(module_pre .. ".models.Define")
local GameRoleItem = appdf.req(module_pre .. ".views.layer.GameRoleItem")
local HeadSprite = require(appdf.EXTERNAL_SRC .. "HeadSprite")
local CardSprite = appdf.req(module_pre .. ".views.layer.gamecard.CardSprite")
local CardsNode = appdf.req(module_pre .. ".views.layer.gamecard.CardsNode")
local GameLogic = appdf.req(module_pre .. ".models.GameLogic")
local GameResultLayer = appdf.req(module_pre .. ".views.layer.GameResultLayer")
local SettingLayer = appdf.req(module_pre .. ".views.layer.SettingLayer")

local Poker = appdf.req(module_pre .. ".views.layer.gamecard.Poker")

local TAG_ENUM = Define.TAG_ENUM
local TAG_ZORDER = Define.TAG_ZORDER

local GameViewLayer = class("GameViewLayer",function(scene)
        local gameViewLayer = display.newLayer()
    return gameViewLayer
end)

--玩家当前状态
GameViewLayer.STATE_LATE_GAME = 0       --中途进入等待中
GameViewLayer.STATE_ONZHUNBEI = 1       --等待所有玩家准备中
GameViewLayer.STATE_QIANGZHUANG = 2     --抢庄中
GameViewLayer.STATE_XIAZHU = 3          --下注中
GameViewLayer.STATE_LIANGPAI = 4        --亮牌中

GameViewLayer.POKER_POS = {     --扑克坐标
{cc.p(175, 315),cc.p(215, 315),cc.p(255, 315),cc.p(295, 315),cc.p(335, 315)},
{cc.p(585, 540),cc.p(625, 540),cc.p(665, 540),cc.p(705, 540),cc.p(745, 540)},
{cc.p(887, 315),cc.p(927, 315),cc.p(967, 315),cc.p(1007, 315),cc.p(1047, 315)},
{cc.p(375, 0),  cc.p(500, 0),  cc.p(625, 0),  cc.p(750, 0),  cc.p(875, 0)}
}
GameViewLayer.FAPAI_POS = {      --发牌折点的位置
cc.p(400, 400),cc.p(710, 520),cc.p(915, 300),cc.p(420, 240)
}
GameViewLayer.HEAD_POS = {      --头像位置
cc.p(95, 435),cc.p(500, 660),cc.p(1245, 435),cc.p(290, 120)
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

function GameViewLayer:initViewLayer(  )
    ExternalFun.playBackgroudAudio("Game.mp3")
--    audio.stopAllSounds()

    self.isJieSuan = false  --false是等待全部准备发牌；true是等待亮牌
    local rootLayer, csbNode = ExternalFun.loadRootCSB("4rennn/4rennn_gameScene.csb", self)
    self.root = csbNode
    --iphoneX适配
    if LuaUtils.isIphoneXDesignResolution() then
        local width_ = yl.WIDTH - display.size.width
        self.root:setPositionX(self.root:getPositionX() - width_/2)
    end
    --隐藏所有的玩家panel
    for i = 1,4 do
        local panel = self.root:getChildByName("player_Panel_"..tostring(i)):setVisible(false)
        panel:getChildByName("lose_money_bg"):setVisible(false)
        panel:getChildByName("win_money_bg"):setVisible(false)
        panel:getChildByName("qiang_image"):setVisible(false)
        panel:getChildByName("chip_bg"):setVisible(false)
    end
    self.root:getChildByName("tips_wait_opencard_1"):setVisible(false)
    self.root:getChildByName("setting_Pannel"):setVisible(false)
    self.root:getChildByName("btn_tanpai"):setVisible(false)
    self.root:getChildByName("btn_tishi"):setVisible(false)
    self.root:getChildByName("btn_tuoguan"):setVisible(false)
    self.root:getChildByName("btn_tuoguan_cancel"):setVisible(false)
    self.root:getChildByName("Panel_menu"):setVisible(false)
    self.root:getChildByName("setting_Pannel"):setVisible(false)
    self.root:getChildByName("help_Pannel"):setVisible(false)
    self.root:getChildByName("qiangzhuang_Panel"):setVisible(false)
    self.root:getChildByName("jiaofen_Panel"):setVisible(false)
    self.root:getChildByName("zhuangAnimation_sprite"):setVisible(false)

    self.cardTexture  = cc.Director:getInstance():getTextureCache():addImage("4rennn/card.png")
    self.jinbiTexture  = cc.Director:getInstance():getTextureCache():addImage("4rennn/effect/qiangzhuangpinshi_jiesuan/jbi_lizi.png")
    self.oneRoundMoney = nil    --一局游戏的底分
    self.playerList = {}
    self.Pokers = {}
    for i = 1,4 do
        self.Pokers[i] = {}
    end
    self.spriteFrameCache_niuniu_xin = cc.SpriteFrameCache:getInstance():addSpriteFrames("4rennn/qznn_plist.plist","4rennn/qznn_plist.png")
    self.spriteFrameCache_niuniu = cc.SpriteFrameCache:getInstance():addSpriteFrames("4rennn/cardtype.plist","4rennn/cardtype.png")
    self.jinbi_action_frameCache = cc.SpriteFrameCache:getInstance():addSpriteFrames("4rennn/gold_full_eff0.plist","4rennn/gold_full_eff0.png")
    self.qiangzhuang_frameCache = cc.SpriteFrameCache:getInstance():addSpriteFrames("4rennn/qiangzhuang_shing.plist","4rennn/qiangzhuang_shing.png")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("4rennn/effect/errenniuniu4_zhuang/errenniuniu4_zhuang.ExportJson")                               --抢庄
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("4rennn/effect/qiangzhuangpinshi_beijing/qiangzhuangpinshi_beijing.ExportJson")                   --背景
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("4rennn/effect/qiangzhuangpinshi_dengdaixiaju/qiangzhuangpinshi_dengdaixiaju.ExportJson")         --耐心等待下局
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("4rennn/effect/qiangzhuangpinshi_jiesuan/qiangzhuangpinshi_jiesuan.ExportJson")               --结算（金币/输赢）



    --播放背景动画
    local heguan = ccs.Armature:create("qiangzhuangpinshi_beijing")
    heguan:setAnchorPoint(cc.p(0,0))
    heguan:setPosition(cc.p(0,465))
	heguan:addTo(self.root:getChildByName("Image_3"))
	heguan:getAnimation():playWithIndex(0)
    ---------------------------button----------------------------
    --菜单按钮
    local touchFunC_menu = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("Panel_menu"):setVisible(true)
            ref:setVisible(false)         
        end
    end
    local btn_menu = self.root:getChildByName("btn_menu"):addTouchEventListener( touchFunC_menu )
    --收起菜单按钮
    local touchFunC_menu_back = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("Panel_menu"):setVisible(false) 
            self.root:getChildByName("btn_menu"):setVisible(true)          
        end
    end
    local btn_menu_back = self.root:getChildByName("Panel_menu"):getChildByName("btn_close"):addTouchEventListener( touchFunC_menu_back )
    --菜单按钮空白处
    local touchFunC_setting = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("Panel_menu"):setVisible(false) 
            self.root:getChildByName("btn_menu"):setVisible(true)
        end
    end
    self.root:getChildByName("Panel_menu"):setTouchEnabled(true):addTouchEventListener( touchFunC_setting )
    --帮助按钮
    local touchFunC_help = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("help_Pannel"):setVisible(true)
            self.root:getChildByName("Panel_menu"):setVisible(false)
            self.root:getChildByName("btn_menu"):setVisible(true)
        end
    end
    local btn_help = self.root:getChildByName("Panel_menu"):getChildByName("btn_help"):addTouchEventListener( touchFunC_help )
    --帮助按钮的关闭按钮
    local touchFunC_help_close = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("help_Pannel"):setVisible(false)
        end
    end
    local btn_help_close = self.root:getChildByName("help_Pannel"):getChildByName("btn_close"):addTouchEventListener( touchFunC_help_close )
    --离开房间按钮
    local touchFunC_leaveGame = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self._scene:onQueryExitGame()
        end
    end
    local btn_leaveGame = self.root:getChildByName("Panel_menu"):getChildByName("btn_leaveGame"):addTouchEventListener( touchFunC_leaveGame )
    --关闭音乐按钮
    local touchFunC_leaveGame = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("Panel_menu"):getChildByName("btn_yinyue"):setVisible(false)
            self.root:getChildByName("Panel_menu"):getChildByName("btn_yinyue_"):setVisible(true)
--            AudioEngine.setMusicVolume(0)
            GlobalUserItem.setVoiceAble(false)
        end
    end
    local btn_leaveGame = self.root:getChildByName("Panel_menu"):getChildByName("btn_yinyue"):addTouchEventListener( touchFunC_leaveGame )
    --打开音乐按钮
    local touchFunC_leaveGame = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("Panel_menu"):getChildByName("btn_yinyue"):setVisible(true)
            self.root:getChildByName("Panel_menu"):getChildByName("btn_yinyue_"):setVisible(false)
--            AudioEngine.setMusicVolume(1)
            GlobalUserItem.setVoiceAble(true)
        end
    end
    local btn_leaveGame = self.root:getChildByName("Panel_menu"):getChildByName("btn_yinyue_"):addTouchEventListener( touchFunC_leaveGame )
    if (GlobalUserItem.bVoiceAble)then
        GlobalUserItem.setVoiceAble(true)
        self.root:getChildByName("Panel_menu"):getChildByName("btn_yinyue"):setVisible(true)
        self.root:getChildByName("Panel_menu"):getChildByName("btn_yinyue_"):setVisible(false)
    else
        GlobalUserItem.setVoiceAble(false)
        self.root:getChildByName("Panel_menu"):getChildByName("btn_yinyue"):setVisible(false)
        self.root:getChildByName("Panel_menu"):getChildByName("btn_yinyue_"):setVisible(true)    
    end
    if (GlobalUserItem.bSoundAble)then
        GlobalUserItem.setSoundAble(true)
        self.root:getChildByName("Panel_menu"):getChildByName("btn_yinxiao"):setVisible(true)
        self.root:getChildByName("Panel_menu"):getChildByName("btn_yinxiao_"):setVisible(false)
    else
        GlobalUserItem.setSoundAble(false)
        self.root:getChildByName("Panel_menu"):getChildByName("btn_yinxiao"):setVisible(false)
        self.root:getChildByName("Panel_menu"):getChildByName("btn_yinxiao_"):setVisible(true)    
    end
    --关闭音效按钮
    local touchFunC_leaveGame = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("Panel_menu"):getChildByName("btn_yinxiao"):setVisible(false)
            self.root:getChildByName("Panel_menu"):getChildByName("btn_yinxiao_"):setVisible(true)
--            AudioEngine.setEffectsVolume(0)
            GlobalUserItem.setSoundAble(false)
        end
    end
    local btn_leaveGame = self.root:getChildByName("Panel_menu"):getChildByName("btn_yinxiao"):addTouchEventListener( touchFunC_leaveGame )
    --打开音效按钮
    local touchFunC_leaveGame = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("Panel_menu"):getChildByName("btn_yinxiao"):setVisible(true)
            self.root:getChildByName("Panel_menu"):getChildByName("btn_yinxiao_"):setVisible(false)
            AudioEngine.setEffectsVolume(1)
            GlobalUserItem.setSoundAble(true)
        end
    end
    local btn_leaveGame = self.root:getChildByName("Panel_menu"):getChildByName("btn_yinxiao_"):addTouchEventListener( touchFunC_leaveGame )
    --离开房间按钮
    local touchFunC_changeTable = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self._scene:onQueryExitGame()
        end
    end
    self.btn_changeTable = self.root:getChildByName("btn_changeTable"):addTouchEventListener( touchFunC_changeTable )
    --抢庄按钮1
    local touchFunC_qiangzhuang1 = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self:onZhuang(1)
        end
    end
    local btn_qiangzhuang1 = self.root:getChildByName("qiangzhuang_Panel"):getChildByName("btn_qiang1"):addTouchEventListener( touchFunC_qiangzhuang1 )
    --抢庄按钮2
    local touchFunC_qiangzhuang2 = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self:onZhuang(2)
        end
    end
    local btn_qiangzhuang2 = self.root:getChildByName("qiangzhuang_Panel"):getChildByName("btn_qiang2"):addTouchEventListener( touchFunC_qiangzhuang2 )
    --抢庄按钮4
    local touchFunC_qiangzhuang4 = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self:onZhuang(4)
        end
    end
    local btn_qiangzhuang4 = self.root:getChildByName("qiangzhuang_Panel"):getChildByName("btn_qiang4"):addTouchEventListener( touchFunC_qiangzhuang4 )
    --不抢按钮
    local touchFunC_buqiangzhuang = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self:onZhuang(0)
        end
    end
    local btn_buqiangzhuang = self.root:getChildByName("qiangzhuang_Panel"):getChildByName("btn_buqiang"):addTouchEventListener( touchFunC_buqiangzhuang )
    --下注按钮
    for i = 1,4 do
        local touchFunC_xiazhu = function(ref, tType)
            if tType == ccui.TouchEventType.ended then            
                self:onXiazhuCallback(i)
            end
        end
        local btn_xiazhu = self.root:getChildByName("jiaofen_Panel"):getChildByName("btn_xiazhu_"..tostring(i)):addTouchEventListener( touchFunC_xiazhu )
    end
    -- 音乐滑动
    local sliderFunC_bg = function( sender, eventType )
        local changePer = sender:getPercent()
        GlobalUserItem.nMusic = changePer
        if eventType == ccui.SliderEventType.percentChanged then
            if changePer>100 then
                changePer = 100
            elseif changePer<0 then
                changePer = 0
            end    
            AudioEngine.setMusicVolume(changePer/100.0)
        end
    end
    local slider_bg = self.root:getChildByName("setting_Pannel"):getChildByName("yinyue_Slider")
    slider_bg:addEventListener(sliderFunC_bg)
    slider_bg:setPercent(GlobalUserItem.nMusic)

    -- 音效滑动
    local sliderFunC_effect = function( sender, eventType )
        local changePer = sender:getPercent()
        GlobalUserItem.nSound = changePer
        if eventType == ccui.SliderEventType.percentChanged then
            if changePer>100 then
                changePer = 100
            elseif changePer<0 then
                changePer = 0
            end
            AudioEngine.setEffectsVolume(changePer/100.0)
        end
    end
    local slider_effect = self.root:getChildByName("setting_Pannel"):getChildByName("yinxiao_Slider")
    slider_effect:setPercent(GlobalUserItem.nSound)
    slider_effect:addEventListener(sliderFunC_effect)

end
function GameViewLayer:setNodeFixPostion()
    local diffX = 145-(1624-display.size.width)/2

    -- 根容器节点
    self.m_rootWidget:setPositionX(diffX)

    if LuaUtils.isIphoneXDesignResolution() then
        self.m_pBtnMenu:setPositionX(self.m_pBtnMenu:getPositionX() + IPHONEX_OFFSETX)
        self.btn_changeTable:setPositionX(self.m_pBtnReturn:getPositionX() - IPHONEX_OFFSETX)
        self.m_pNodeMenu:setPositionX(self.m_pNodeMenu:getPositionX() + IPHONEX_OFFSETX + 30)
    end
end
--初始化界面及button
function GameViewLayer:initGameData_And_View(bufferData)
    self.ownerState = GameViewLayer.STATE_ONZHUNBEI
    --            dump(GlobalUserItem.tabAccountInfo)--玩家所有信息
    self.oneRoundMoney = bufferData.deskinfo.unit_money
    self.daojishi_Num = bufferData.deskinfo.continue_timeout
    local tt = 0
    self.daojishi_Num,tt = math.modf(self.daojishi_Num/1);
    self.root:getChildByName("Panel_1"):getChildByName("str_daojishi"):setString(tostring(self.daojishi_Num))
    self.root:getChildByName("lab_dizhu"):setString("底注："..bufferData.deskinfo.unit_money)
    --将所有玩家信息存入playerList
    for k, v in ipairs(bufferData.memberinfos) do
        table.insert(self.playerList,v)
        if v.uid == GlobalUserItem.tabAccountInfo.userid then
            self.position = v.position
        end        
        if v.waiting==false then
            self.gameEnterState = true            
        end
    end
    
    if self.gameEnterState then
        self.root:getChildByName("btn_begin"):setVisible(false)        
        self.root:getChildByName("tips_wait_opencard_1"):setVisible(true)
        --播放背景动画
        local heguan = ccs.Armature:create("qiangzhuangpinshi_dengdaixiaju")
        heguan:setAnchorPoint(cc.p(0.5,0.5))
        heguan:setPosition(cc.p(667,375))
	    heguan:addTo(self.root:getChildByName("tips_wait_opencard_1"))
	    heguan:getAnimation():playWithIndex(0)
    end
    --初始化玩家panel
    for k, player in ipairs(self.playerList) do
        self:updataPlayerPanpel(player)
    end

    --开始/准备按钮
    local touchFunC_begin = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self:onReady()           
        end
    end
    local btn_begin = self.root:getChildByName("btn_begin"):addTouchEventListener( touchFunC_begin )
    --提示按钮
    local touchFunC_tishi = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self:onShowTishi()           
        end
    end
    local btn_tishi = self.root:getChildByName("btn_tishi"):addTouchEventListener( touchFunC_tishi )
    --摊牌按钮
    local touchFunC_tanpai = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onTanPai()
        end
    end
    local btn_tanpai = self.root:getChildByName("btn_tanpai"):addTouchEventListener( touchFunC_tanpai )
    --托管按钮
    local touchFunC_onTuoguan = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onTuoguan()
        end
    end
    local btn_onTuoguan = self.root:getChildByName("btn_tuoguan"):addTouchEventListener( touchFunC_onTuoguan )
    --取消托管按钮
    local touchFunC_offTuoguan = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:offTuoguan()
        end
    end
    local btn_offTuoguan = self.root:getChildByName("btn_tuoguan_cancel"):addTouchEventListener( touchFunC_offTuoguan )
    
    --时间调度，更新桌面中间倒计时
    local this = self
    self._ClockFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                this:OnClockUpdata()
            end, 1, false)
end
--计时器更新
function GameViewLayer:OnClockUpdata()
--    if  self._ClockID ~= yl.INVALID_ITEM then
--        self._ClockTime = self._ClockTime - 1
--        local result = self:OnEventGameClockInfo(self._ClockChair,self._ClockTime,self._ClockID)
--        if result == true   or self._ClockTime < 1 then
--            self:KillGameClock()
--        end
--    end

    
--    if self.isJiesuan == true then        
--        self.root:getChildByName("Panel_1"):getChildByName("str_wenzi"):setString("亮牌中…")
--        self.root:getChildByName("Panel_1"):getChildByName("str_daojishi"):setString(tostring(self.daojishi_Num))
--    else
--        self.root:getChildByName("Panel_1"):getChildByName("str_wenzi"):setString("即将开始")
--        self.root:getChildByName("Panel_1"):getChildByName("str_daojishi"):setString(tostring(self.daojishi_Num))
--    end
    if self.ownerState == GameViewLayer.STATE_LATE_GAME then
        self.root:getChildByName("Panel_1"):getChildByName("str_wenzi"):setString("等待下手")
        self.root:getChildByName("Panel_1"):getChildByName("str_daojishi"):setString(tostring(self.daojishi_Num))
        self.root:getChildByName("Panel_1"):setVisible(false)
    elseif self.ownerState == GameViewLayer.STATE_ONZHUNBEI then
        self.root:getChildByName("Panel_1"):getChildByName("str_wenzi"):setString("即将开始")
        self.root:getChildByName("Panel_1"):getChildByName("str_daojishi"):setString(tostring(self.daojishi_Num))
        self.root:getChildByName("Panel_1"):setVisible(false)
    elseif self.ownerState == GameViewLayer.STATE_QIANGZHUANG then
        self.root:getChildByName("Panel_1"):getChildByName("str_wenzi"):setString("请抢庄:")
        self.root:getChildByName("Panel_1"):getChildByName("str_daojishi"):setString(tostring(self.daojishi_Num))
        self.root:getChildByName("Panel_1"):setVisible(true)
    elseif self.ownerState == GameViewLayer.STATE_XIAZHU then
        self.root:getChildByName("Panel_1"):getChildByName("str_wenzi"):setString("请投注:")
        self.root:getChildByName("Panel_1"):getChildByName("str_daojishi"):setString(tostring(self.daojishi_Num))
        self.root:getChildByName("Panel_1"):setVisible(true)
    elseif self.ownerState == GameViewLayer.STATE_LIANGPAI then
        self.root:getChildByName("Panel_1"):getChildByName("str_wenzi"):setString("请摊牌:")
        self.root:getChildByName("Panel_1"):getChildByName("str_daojishi"):setString(tostring(self.daojishi_Num))
        self.root:getChildByName("Panel_1"):setVisible(true)
    end
    self.daojishi_Num = self.daojishi_Num - 1    
end
-- 关闭计时器
function GameViewLayer:KillGameClock(notView)
    print("KillGameClock")
    self._ClockID = yl.INVALID_ITEM
    self._ClockTime = 0
    self._ClockChair = yl.INVALID_CHAIR
    self._ClockViewChair = yl.INVALID_CHAIR
    if self._ClockFun then
        --注销时钟
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._ClockFun) 
        self._ClockFun = nil
    end
    if not notView then
        self:OnUpdataClockView()
    end
end
--更新玩家icon，昵称等信息
function GameViewLayer:updataPlayerPanpel(player_)
    local isHavePlayer = false
    for key, player in ipairs(self.playerList) do
        if player.uid == player_.uid then
            isHavePlayer = true
        end
    end
    if isHavePlayer == false then
        table.insert(self.playerList,player_)
    end
    
    
    local position_ = player_.position
    if position_ == self.position then
        position_ = 4
        player_.position = 4
    elseif position_ < self.position then
        position_ = position_ + 1
    end
    local node = self.root:getChildByName("player_Panel_"..tostring(position_)):setVisible(true)    --确定玩家在哪个panel上
    player_["panel"] = node
    player_["panel_Id"] = position_


    local icon = node:getChildByName("sp_icon")--:loadTexture("client/res/plaza/plaza_sp_cliphead.png")
    --头像加了 但是id比资源多
    local head = HeadSprite:createNormal(player_, 100)
    head:setAnchorPoint(cc.p(0,0))
    head:setPosition(cc.p(20,75))
    icon:addChild(head)
    local name = node:getChildByName("str_player_name"):setString(player_.client_address)
    local ready_ok = node:getChildByName("ready_ok"):setVisible(false)
    local ready_ok_tanpai = node:getChildByName("ready_ok_tanpai"):setVisible(false)
    local sp_qiangzhuangResult = node:getChildByName("sp_qiangzhuangResult"):setVisible(false)
    --设置玩家金币数
    local money_num = player_.into_money
    player_.playerMoney = money_num
    local money_str = node:getChildByName("str_player_money")
    if money_num >= 100000000 then
        money_str:setString(tostring(money_num/100000000).."亿")
    elseif money_num >= 10000 then
        money_str:setString(tostring(money_num/10000).."万")
    else
        money_str:setString(tostring(money_num))
    end
    --如果玩家已准备，设置为准备状态
    if player_.ready and player_.waiting then
        ready_ok:setVisible(true)
    end
    
end

function GameViewLayer:updataUserState(userId)  --id为uid的玩家准备开始游戏

    for key, player in ipairs(self.playerList) do
        if player.uid == userId then
            print(player.nickname.."------------------->已准备")
            player.panel:getChildByName("ready_ok"):setVisible(true)
        end
    end    
end

function GameViewLayer:onPlayerShow(user)       --该uid玩家点击摊牌(需要加判断自身玩家是否参与本局游戏)    
    if self.gameEnterState == false then
        for key, player in ipairs(self.playerList) do
            if player.uid == user.uid then
                print(player.nickname.."------------------->已摊牌")
                player.panel:getChildByName("ready_ok_tanpai"):setVisible(true)
            end
        end
    end
end

function GameViewLayer:onUserLeave(userId)      --该uid玩家离开房间
    for key, player in ipairs(self.playerList) do
        if player.uid == userId then
            print(player.nickname.."------------------->已离开房间")
            player.panel:setVisible(false)
            player.panel:getChildByName("sp_icon"):removeAllChildren()
            table.remove(self.playerList,key)
            self.Pokers[player.panel_Id] = {}

            player.panel:getChildByName("animation_panel"):removeAllChildren()
        end
    end
end

function GameViewLayer:onFaPai(args)
    --音效（开始游戏）
    ExternalFun.playSoundEffect("start.ogg")
    self.isJiesuan = true
    self.daojishi_Num = 15
    
    self.root:getChildByName("sp_gameBegin"):runAction( cc.Sequence:create( cc.MoveTo:create(0.35,cc.p(727,400)),cc.MoveTo:create(0.2,cc.p(627,400)),cc.MoveTo:create(0.2,cc.p(727,400)),cc.MoveTo:create(0.1,cc.p(677,400)),cc.MoveTo:create(0.15,cc.p(1600,400)),cc.DelayTime:create(1),cc.CallFunc:create(function()
            self.root:getChildByName("sp_gameBegin"):setPosition(cc.p(-500,400))
        end) ))

--    self.gameEnterState = true
    for key, player in ipairs(self.playerList) do
        player.panel:getChildByName("ready_ok"):setVisible(false)        
    end


    self.ownerState = GameViewLayer.STATE_QIANGZHUANG

    for key, player_ in ipairs(self.playerList) do
        player_.panel:getChildByName("ready_ok"):setVisible(false)
        player_.isShowJinbi = true
        if player_.uid ~= GlobalUserItem.tabAccountInfo.userid then
            self:showFaPaiAni(player_.panel_Id)
        else
            self:showFaPaiAni(player_.panel_Id,args.cards)
        end
    end
end

function GameViewLayer:showFaPaiAni(chair_id,pokerDatas)
    --发牌延时
    local faPaiDt = {1.3, 1.2, 1.1, 1.0}
    local poker_panel = self.root:getChildByName("card_panel")
    --创建5张牌 发牌
    for n = 1 ,4 do
        --创建牌
        self.Pokers[chair_id][n] = Poker:create()
        poker_panel:addChild(self.Pokers[chair_id][n])
        --设置牌背面
        self.Pokers[chair_id][n]:setBack()

        --重置位置 重置大小
        self.Pokers[chair_id][n]:setPosition(cc.p(cc.Director:getInstance():getWinSize().width*0.5,cc.Director:getInstance():getWinSize().height*0.5))
        self.Pokers[chair_id][n]:setScale(0.2)
        self.Pokers[chair_id][n]:setSkewX(0)
        self.Pokers[chair_id][n]:setRotation(0)


        --自己带翻牌
        if chair_id == 4 then
            --执行对应的缩放变化
            self.Pokers[chair_id][n]:runAction(cc.Sequence:create(
                cc.DelayTime:create(faPaiDt[chair_id]), --不同玩家分开执行发牌动作
                cc.DelayTime:create((n-1)*0.05),            --不同牌分开发出
                cc.ScaleTo:create(0.35, 0.95),          --最后缩放的大小
                cc.DelayTime:create(0.05*4 - 0.05*(n-1)),   --等待所有牌缩放动作完成在左边集合
                cc.DelayTime:create(0.2)                --move的时间

            ))

            local bezier = {  
                GameViewLayer.FAPAI_POS[chair_id],--self.pathPos[idx],
                GameViewLayer.FAPAI_POS[chair_id],--self.pathPos[idx],      --折点的位置
                GameViewLayer.POKER_POS[chair_id][1]--self.targetPos[idx],    --第一张牌的位置
            }  

            self.Pokers[chair_id][n]:runAction(cc.Sequence:create(
                cc.DelayTime:create(faPaiDt[chair_id]),
                cc.DelayTime:create((n-1)*0.05),
                cc.BezierTo:create(0.35, bezier),--array
                cc.DelayTime:create(0.05*4 - 0.05*(n-1)),
                cc.MoveTo:create(0.2,GameViewLayer.POKER_POS[chair_id][n]),
                cc.OrbitCamera:create(0.2,1,0,0,90,0,0),
                cc.CallFunc:create(function()
                    self.Pokers[chair_id][n]:setCardData(pokerDatas[n])
                end),
                cc.OrbitCamera:create(0.3,1,0,270,90,0,0)
            ))
        else
            --其他玩家
            self.Pokers[chair_id][n]:setScale(0.2)
            --执行对应的缩放变化
            self.Pokers[chair_id][n]:runAction(cc.Sequence:create(
                cc.DelayTime:create(faPaiDt[chair_id]),
                cc.DelayTime:create((n-1)*0.05),

                cc.ScaleTo:create(0.35,0.8),
                cc.DelayTime:create(0.05*4 - 0.05*(n-1)),
                cc.ScaleTo:create(0.2,0.8)
            ))

            --旋转变化 
            self.Pokers[chair_id][n]:runAction(cc.Sequence:create(
                cc.DelayTime:create(faPaiDt[chair_id]),
                cc.DelayTime:create((n-1)*0.05),

                cc.DelayTime:create(0.35),
                cc.DelayTime:create(0.05*4 - 0.05*(n-1)),
                cc.DelayTime:create(0.2)
            ))

            local bezier = {  
                GameViewLayer.FAPAI_POS[chair_id],--self.pathPos[idx],
                GameViewLayer.FAPAI_POS[chair_id],--self.pathPos[idx],      --折点的位置
                GameViewLayer.POKER_POS[chair_id][1]--self.targetPos[idx],    --第一张牌的位置  
            }  
            self.Pokers[chair_id][n]:runAction(cc.Sequence:create(
                cc.DelayTime:create(faPaiDt[chair_id]),
                cc.DelayTime:create((n-1)*0.05),

                cc.BezierTo:create(0.35, bezier),
                cc.DelayTime:create(0.05*4 - 0.05*(n-1)),
                cc.MoveTo:create(0.2,GameViewLayer.POKER_POS[chair_id][n])
            ))
        end
    end
end

function GameViewLayer:fapaiAction()
    dump(self.playerList)
    for j=0,3 do
        for i=1,4 do
            for key, player in ipairs(self.playerList) do
                if player.panel_Id == i then
                    local x = self.root:getChildByName("Image_1"):getPositionX()
                    local y = self.root:getChildByName("Image_1"):getPositionY()
                    local card = self:setCardImage(54,self.root:getChildByName("Image_1")):setPosition(cc.p(500,300)) 
                    if player.panel_Id ~= 4 then
                        card:setScale(0.75)
                    end                   
                    local xTo = self.root:getChildByName("player_Panel_"..tostring(i)):getPositionX()+j*35-64
                    local yTo = self.root:getChildByName("player_Panel_"..tostring(i)):getPositionY()-65
                    if player.panel_Id == 3  then
                        xTo = self.root:getChildByName("player_Panel_"..tostring(i)):getPositionX()+j*35-195
                        yTo = self.root:getChildByName("player_Panel_"..tostring(i)):getPositionY()-65
                    end
                    card:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(xTo,yTo)),cc.DelayTime:create(0.5),cc.CallFunc:create(function()
		                                    card:removeFromParent()
	                                    end)))
                end
            end        
        end
    end
end

--游戏结算--（需要加判断自身玩家是否参与本局游戏）
function GameViewLayer:onGameEnd(args)
    self.isJiesuan = false
    self.daojishi_Num = 10
    local btn_tanpai = self.root:getChildByName("btn_tanpai"):setVisible(false)
    local btn_tishi = self.root:getChildByName("btn_tishi"):setVisible(false)
    self.root:getChildByName("tips_wait_opencard_1"):setVisible(false)
    for key, player in ipairs(self.playerList) do
        player.panel:getChildByName("ready_ok_tanpai"):setVisible(false)
        for k, playerInfo in ipairs(args.gold_nn) do
            if playerInfo[1] == GlobalUserItem.tabAccountInfo.userid then
                if playerInfo[4]>0 then
                    --音效（胜利）
                    ExternalFun.playSoundEffect("win.ogg")
                    --播放胜利动画
                    local qipaiAct = ccs.Armature:create("qiangzhuangpinshi_jiesuan")
                    qipaiAct:setAnchorPoint(cc.p(0.5,0.5))
                    qipaiAct:setPosition(cc.p(667,375))
	                qipaiAct:addTo(self.root:getChildByName("Image_1"))
	                qipaiAct:getAnimation():play("Animation1")
                    local func = function (armature,movementType,movementID)
                            if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
                                if armature then 
                                    armature:removeFromParent()
                                end
                            end
                        end
                    qipaiAct:getAnimation():setMovementEventCallFunc(func)
                elseif playerInfo[4]<0 then
                    --音效（失败）
                    ExternalFun.playSoundEffect("lose.ogg")
                    --播放失败动画
                    local qipaiAct = ccs.Armature:create("qiangzhuangpinshi_jiesuan")
                    qipaiAct:setAnchorPoint(cc.p(0.5,0.5))
                    qipaiAct:setPosition(cc.p(667,375))
	                qipaiAct:addTo(self.root:getChildByName("Image_1"))
	                qipaiAct:getAnimation():play("Animation2")
                    local func = function (armature,movementType,movementID)
                            if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
                                if armature then 
                                    armature:removeFromParent()
                                end
                            end
                        end
                    qipaiAct:getAnimation():setMovementEventCallFunc(func)
                end
            end
            if playerInfo[1] == player.uid then
                --展示所有牌面
                local chair_id = player.panel_Id
                local panel_ = player.panel
                --展示所有玩家的牌
                for i = 1,5 do  
                    if #self.Pokers[chair_id] > 0  then
                        self.Pokers[chair_id][i]:setCardData(playerInfo[2][i])
                    end                    
                end
                 --有牛的牌前三张上移
                if playerInfo[3]>0 then
                    if #self.Pokers[chair_id] > 0  then
                        for i = 1,3 do 
                            self.Pokers[chair_id][i]:runAction(cc.MoveBy:create(0.1,cc.p(0,20)))
                        end
                    end
                end
                --更新金币
                player.playerMoney = player.playerMoney + playerInfo[4] 
                local money_num = player.playerMoney
                local money_str = player.panel:getChildByName("str_player_money")
                if money_num >= 100000000 then
                    money_str:setString(string.format("%.1f", money_num/100000000).."亿")
                elseif money_num >= 10000 then
                    money_str:setString(string.format("%.1f", money_num/10000).."万")
                else
                    money_str:setString(tostring(money_num))
                end
                print(playerInfo[3].."____________________________________牛型")
                -----------------------------------------------------------------------------------------------
                if self.gameEnterState == false then
                    --音效（牛型）
                    ExternalFun.playSoundEffect(tostring(playerInfo[3]+1)..".ogg")

                    local frame = self.spriteFrameCache_niuniu:getSpriteFrameByName("game/qznn/plist/gui-qz-niu-"..tostring(playerInfo[3])..".png")
                    local ox = cc.Sprite:createWithSpriteFrame(frame):setPosition(cc.p(0,0))
                    player.panel:getChildByName("animation_panel"):addChild(ox):setAnchorPoint(cc.p(0.1,0))
                    ox:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,0.3),cc.ScaleTo:create(0.2,1)))

                    local winMoneyBg = player.panel:getChildByName("win_money_bg")
                    local loseMoneyBg = player.panel:getChildByName("lose_money_bg")
                    ----------------------------------------------------------------
                    if playerInfo[4]>0 then
                        winMoneyBg:getChildByName("money_num"):setText("+"..playerInfo[4])
                        winMoneyBg:setVisible(true)
                        winMoneyBg:runAction(cc.Sequence:create(cc.CallFunc:create(function()
		                            winMoneyBg:setVisible(true)                                                                        
	                            end),cc.DelayTime:create(4.0),cc.CallFunc:create(function()
		                            winMoneyBg:setVisible(false)                                                                        
	                            end)))
                    else
                        loseMoneyBg:getChildByName("money_num"):setText(playerInfo[4])
                        loseMoneyBg:setVisible(true)
                        loseMoneyBg:runAction(cc.Sequence:create(cc.CallFunc:create(function()
		                            loseMoneyBg:setVisible(true)                                                                        
	                            end),cc.DelayTime:create(4.0),cc.CallFunc:create(function()
		                            loseMoneyBg:setVisible(false)                                                                        
	                            end)))
                    end
                    --------------------------飞金币特效--------------------------
                    if self.zhuangjiaUID == playerInfo[1] then
                        local x_zhuang = 0  --庄家位置
                        local y_zhuang = 0
                        local x_xian = 0    --闲家位置
                        local y_xian = 0
                        x_zhuang = GameViewLayer.HEAD_POS[player.panel_Id].x
                        y_zhuang = GameViewLayer.HEAD_POS[player.panel_Id].y

                        local flyTime = 0                        
                        local OnJinbiFlyUpdata = function ()
                            if flyTime < 120 then

                            elseif flyTime<135 then
                                 for k_, playerInfo_ in ipairs(args.gold_nn) do
                                    for key__, player__ in ipairs(self.playerList) do
                                        if playerInfo_[1] == player__.uid then
                                            if playerInfo_.uid ~= self.zhuangjiaUID then
                                                x_xian = GameViewLayer.HEAD_POS[player__.panel_Id].x
                                                y_xian = GameViewLayer.HEAD_POS[player__.panel_Id].y
                                                if playerInfo_[4]<0 then
                                                        local targetPos = cc.p(x_zhuang,y_zhuang)
                                                        local startPos = cc.p(x_xian,y_xian)
                                                        --计算距离
                                                        local distance = ccpDistance(targetPos,startPos)
                                                        local offset = 10
                                                        local flyDt = 0.5
                                                        local randomX = math.random()*3 - 1
                                                        local randomY = math.random()*3 - 1
                                                        local bezier = {  
                                                                            ccp((startPos.x + targetPos.x)*0.5 + randomX*offset ,(startPos.y + targetPos.y)*0.5 + randomY*offset),
                                                                            ccp((startPos.x + targetPos.x)*0.5 + randomX*offset ,(startPos.y + targetPos.y)*0.5 + randomY*offset),
                                                                            cc.p(targetPos.x + math.random()*10, targetPos.y + math.random()*10),
                                                                        }
                                                        local totalDt = 0.9
                                                        local flyDtOffset = (totalDt - flyDt) / 15
                                                        local ooo = cc.Sprite:createWithTexture(self.jinbiTexture):setPosition(cc.p(x_xian,y_xian)):setAnchorPoint(cc.p(0.5,0.5))
                                                        self.root:addChild(ooo)
                                                        ooo:runAction(cc.Sequence:create(
                                                            cc.EaseExponentialInOut:create(cc.BezierTo:create(flyDt+flyDtOffset*(flyTime-120), bezier)),
--                                                            cc.MoveTo:create(0.4,cc.p(x_zhuang,y_zhuang)),
                                                            cc.CallFunc:create(function()
                                                                ooo:removeFromParent()     
                                                            end)))
                                                end 
                                            end
                                        end
                                    end
                                end
                            elseif flyTime < 175 then
                                
                            elseif flyTime < 190 then
                                for k_, playerInfo_ in ipairs(args.gold_nn) do
                                    for key__, player__ in ipairs(self.playerList) do
                                        if playerInfo_[1] == player__.uid then
                                            if playerInfo_.uid ~= self.zhuangjiaUID then
                                                x_xian = GameViewLayer.HEAD_POS[player__.panel_Id].x
                                                y_xian = GameViewLayer.HEAD_POS[player__.panel_Id].y
                                                if playerInfo_[4]>0 then
                                                        local targetPos = cc.p(x_xian,y_xian)
                                                        local startPos = cc.p(x_zhuang,y_zhuang)
                                                        --计算距离
                                                        local distance = ccpDistance(targetPos,startPos)
                                                        local offset = 10
                                                        local flyDt = 0.4
                                                        local randomX = math.random()*3 - 1
                                                        local randomY = math.random()*3 - 1
                                                        local bezier = {  
                                                                            ccp((startPos.x + targetPos.x)*0.5 + randomX*offset ,(startPos.y + targetPos.y)*0.5 + randomY*offset),
                                                                            ccp((startPos.x + targetPos.x)*0.5 + randomX*offset ,(startPos.y + targetPos.y)*0.5 + randomY*offset),
                                                                            cc.p(targetPos.x + math.random()*10, targetPos.y + math.random()*10),
                                                                        }
                                                        local totalDt = 0.9
                                                        local flyDtOffset = (totalDt - flyDt) / 15
                                                        local ooo = cc.Sprite:createWithTexture(self.jinbiTexture):setPosition(cc.p(x_zhuang,y_zhuang)):setAnchorPoint(cc.p(0.5,0.5))
                                                        self.root:addChild(ooo)
                                                        ooo:runAction(cc.Sequence:create(
                                                            cc.EaseExponentialInOut:create(cc.BezierTo:create(flyDt+flyDtOffset*(flyTime-175) , bezier)),
--                                                            cc.MoveTo:create(0.4,cc.p(x_xian,y_xian)),
                                                            cc.CallFunc:create(function()
                                                                ooo:removeFromParent()     
                                                            end))) 
                                                end 
                                            end
                                        end
                                    end
                                end      
                            else
                                if self.jinbiFlyFunc_ ~= nil then
                                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.jinbiFlyFunc_) 
                                end
                            end
                            flyTime = flyTime +1
                        end
                        self.jinbiFlyFunc_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                            OnJinbiFlyUpdata()
                        end, 0.002, false) 
                    end
                    --------------------------------------------------------------
                end
                
            end
        end
    end
end

function GameViewLayer:beZhuangAnimation(Panel_id)
      


    local x,y;
    for key, player in ipairs(self.playerList) do
        if player.panel_Id == Panel_id then
            if Panel_id == 3 then
                x = player.panel:getPositionX()+120                
                y = player.panel:getPositionY()-30
            elseif Panel_id == 4 then
                x = player.panel:getPositionX()-170     
                y = player.panel:getPositionY()-30           
            else
                x = player.panel:getPositionX()-150
                y = player.panel:getPositionY()-20
            end
            
        end
    end

--    local act = cc.Spawn:create(action,cc.MoveTo:create(1,cc.p(x,y)))
--    self.root:getChildByName("zhuangAnimation_sprite"):setVisible(true):runAction(act)
    self.root:getChildByName("zhuangAnimation_sprite"):setVisible(true)
    --播放抢庄动画
    local heguan = ccs.Armature:create("errenniuniu4_zhuang")
    heguan:setAnchorPoint(cc.p(0,0))
    heguan:setPosition(cc.p(-30,60))
	heguan:addTo(self.root:getChildByName("zhuangAnimation_sprite"))
	heguan:getAnimation():playWithIndex(0)

    self.root:getChildByName("zhuangAnimation_sprite"):runAction(cc.MoveTo:create(1,cc.p(x,y)))
end
--本局游戏结束
function GameViewLayer:onDeskOver(args)
    
    self.gameEnterState = false
    self.root:getChildByName("qiangzhuang_Panel"):setVisible(false)
    self.root:getChildByName("jiaofen_Panel"):setVisible(false)
    self.root:getChildByName("zhuangAnimation_sprite"):setVisible(false):setPosition(cc.p(667,375))
    for key, player in ipairs(self.playerList) do
        player.panel:getChildByName("chip_bg"):setVisible(false)
        player.panel:getChildByName("sp_qiangzhuangResult"):setVisible(false)
    end
    self.isIntoGameLate = false

    self:runAction(cc.Sequence:create( cc.DelayTime:create(4),cc.CallFunc:create(function ()
            for key, pokers_ in ipairs(self.Pokers) do
                print("扑克牌组中元素个数为："..#pokers_)
                for key_, poker_ in ipairs( pokers_ ) do
                    if poker_ ~= nil then
                        poker_:removeFromParent()
                    end                
                end
            end
            for i = 1,4 do
                self.root:getChildByName("player_Panel_"..i):getChildByName("animation_panel"):removeAllChildren()
            end
            
            self.root:getChildByName("card_panel"):removeAllChildren()
--            self._scene:sendReady()
            self.root:getChildByName("btn_begin"):setVisible(true)
        end) ))
    self.ownerState = GameViewLayer.STATE_ONZHUNBEI
end
--更新自己金钱
function GameViewLayer:updataMyMoney(args)
    for key, player in ipairs(self.playerList) do
        if player.uid == GlobalUserItem.tabAccountInfo.userid then
            print(player.nickname.."------------------->更新金币")
            --设置玩家金币数
            local money_num = args
            local node = self.root:getChildByName("player_Panel_"..player.panel_Id)
            local money_str = node:getChildByName("str_player_money")
            if money_num >= 100000000 then
                money_str:setString(tostring(money_num/100000000).."亿")
            elseif money_num >= 10000 then
                money_str:setString(tostring(money_num/10000).."万")
            else
                money_str:setString(tostring(money_num))
            end
        end
    end
end
--更新其他玩家金钱
function GameViewLayer:updatdOthersMoney(user)
    for key, player in ipairs(self.playerList) do
        if player.uid == user.uid then
            print(player.nickname.."------------------->更新金币")
            --设置玩家金币数
            local node = self.root:getChildByName("player_Panel_"..player.panel_Id)
            local money_num = user.money
            local money_str = node:getChildByName("str_player_money")
            if money_num >= 100000000 then
                money_str:setString(tostring(money_num/100000000).."亿")
            elseif money_num >= 10000 then
                money_str:setString(tostring(money_num/10000).."万")
            else
                money_str:setString(tostring(money_num))
            end
        end
    end
end

--收到开始叫庄消息
function GameViewLayer:onBeginZhuang(bufferData)
    if bufferData.uid ~= GlobalUserItem.tabAccountInfo.userid then
        self.root:getChildByName("qiangzhuang_Panel"):setVisible(false)
    end
    for i = 1, 4 do
        self.root:getChildByName("player_Panel_"..tostring(i)):getChildByName("qiang_image"):stopAllActions():setVisible(false)
    end
    for key, player in ipairs(self.playerList) do
        if bufferData.uid == player.uid then
            if player.uid == GlobalUserItem.tabAccountInfo.userid then
                self.root:getChildByName("qiangzhuang_Panel"):setVisible(true)
            end
            self.daojishi_Num = bufferData.timeout
            local tt = 0
            self.daojishi_Num,tt = math.modf(self.daojishi_Num/1);
--            local jiaobiao = player.panel:getChildByName("qiang_image"):setVisible(true)
--            jiaobiao:runAction(cc.Blink:create(10,30))
        end
    end
    self.multiple = bufferData.multiple
    dump(self.multiple)
    local qiang_1 = self.root:getChildByName("qiangzhuang_Panel"):getChildByName("btn_qiang1")
    local qiang_2 = self.root:getChildByName("qiangzhuang_Panel"):getChildByName("btn_qiang2")
    local qiang_4 = self.root:getChildByName("qiangzhuang_Panel"):getChildByName("btn_qiang4")
    for key, bet_ in ipairs(self.multiple) do
        if key == 5 then
            if bet_ > 0 then
                qiang_4:setEnabled(true)
                qiang_4:setColor(cc.c3b(255,255,255))
            else
                qiang_4:setEnabled(false)
                qiang_4:setColor(cc.c3b(125,125,125))
            end
        end
        if key == 3 then
            if bet_ > 0 then
                qiang_2:setEnabled(true)
                qiang_2:setColor(cc.c3b(255,255,255))
            else
                qiang_2:setEnabled(false)
                qiang_2:setColor(cc.c3b(125,125,125))
            end
        end
        if key == 2 then
            if bet_ > 0 then
                qiang_1:setEnabled(true)
                qiang_1:setColor(cc.c3b(255,255,255))
            else
                qiang_1:setEnabled(false)
                qiang_1:setColor(cc.c3b(125,125,125))
            end
        end
    end
    
--    if #bufferData.multiple == 4 then
--        qiang_4:setEnabled(false)
--        qiang_4:setColor(cc.c3b(125,125,125))
--    elseif #bufferData.multiple == 2 then
--        qiang_4:setEnabled(false)
--        qiang_4:setColor(cc.c3b(125,125,125))
--        qiang_2:setEnabled(false)
--        qiang_2:setColor(cc.c3b(125,125,125))
--    elseif #bufferData.multiple == 1 then
--        qiang_4:setEnabled(false)
--        qiang_4:setColor(cc.c3b(125,125,125))
--        qiang_2:setEnabled(false)
--        qiang_2:setColor(cc.c3b(125,125,125))
--        qiang_1:setEnabled(false)
--        qiang_1:setColor(cc.c3b(125,125,125))
--    end
end
--收到玩家叫庄倍数
function GameViewLayer:onEventGrab_banker_info(bufferData)
    if bufferData.multiple == 3 then
        bufferData.multiple = 4
        print("收到玩家叫庄倍数     =     "..bufferData.multiple)
    end
    for key, player in ipairs(self.playerList) do
        if bufferData.uid == player.uid then
            player.panel:getChildByName("sp_qiangzhuangResult"):setSpriteFrame(string.format("game/qznn/plist/gui-qznn-tip-callx%d.png",bufferData.multiple)):setVisible(true)
        end
    end
end
 --收到叫庄结果
function GameViewLayer:onEventGrab_banker_result(bufferData)
    if bufferData.grab_multiple == 3 then
        bufferData.grab_multiple = 4
        print("收到叫庄结果    =    "..bufferData.grab_multiple)
    end
    for key_, uid_ in ipairs(bufferData.random_uid_list) do
        for key, player in ipairs(self.playerList) do
            if uid_ == player.uid then
                player.panel:getChildByName("sp_qiangzhuangResult"):setSpriteFrame(string.format("game/qznn/plist/gui-qznn-tip-callx%d.png",bufferData.grab_multiple)):setVisible(true)
            else
                player.panel:getChildByName("sp_qiangzhuangResult"):setVisible(false)
            end
        end
    end
    local  blink_ = cc.CallFunc:create(function()
            for key_, uid_ in ipairs(bufferData.random_uid_list) do
                for key, player in ipairs(self.playerList) do
                    if uid_ == player.uid then
                        local jiaobiao = player.panel:getChildByName("qiang_image"):setVisible(true)
                        jiaobiao:runAction(cc.Blink:create(2,10))
                    end
                end
            end
        end)
    local  callF_ = cc.CallFunc:create(function()
            for i = 1, 4 do
                self.root:getChildByName("player_Panel_"..tostring(i)):getChildByName("qiang_image"):stopAllActions():setVisible(false)
            end
            for key, player in ipairs(self.playerList) do
                if bufferData.bid == player.uid then
                    player.panel:getChildByName("sp_qiangzhuangResult"):setSpriteFrame(string.format("game/qznn/plist/gui-qznn-tip-callx%d.png",bufferData.grab_multiple)):setVisible(true)
                else
                    player.panel:getChildByName("sp_qiangzhuangResult"):setVisible(false)
                end
            end
        end)
    self:runAction(cc.Sequence:create(blink_,cc.DelayTime:create(2),callF_))
end
--收到开始下注消息
function GameViewLayer:onXiazhu(bufferData)
    self.root:getChildByName("qiangzhuang_Panel"):setVisible(false)
    self.zhuangjiaUID = bufferData.bid
    self.ownerState = GameViewLayer.STATE_XIAZHU
    for key, player in ipairs(self.playerList) do
        if bufferData.bid == player.uid then
            self:beZhuangAnimation(player.panel_Id)
        end
    end
    
    for key, bet_ in ipairs(bufferData.chip) do
        local btn_bet = self.root:getChildByName(string.format("jiaofen_Panel")):getChildByName(string.format("btn_xiazhu_%d",key))
        if  bet_ > 0 then
            btn_bet:setEnabled(true)
            btn_bet:setColor(cc.c3b(255,255,255))
        else
            btn_bet:setEnabled(false)
            btn_bet:setColor(cc.c3b(125,125,125))
        end
    end
    
    
    if bufferData.bid ~= GlobalUserItem.tabAccountInfo.userid then
        if self.isIntoGameLate ~= true then
            self.root:getChildByName("jiaofen_Panel"):setVisible(true)
        end
        self.chip_value = bufferData.chip
        self.daojishi_Num = bufferData.timeout
        local tt = 0
        self.daojishi_Num,tt = math.modf(self.daojishi_Num/1);
        for i = 1,4 do
            self.root:getChildByName("jiaofen_Panel"):getChildByName("btn_xiazhu_"..tostring(i)):getChildByName("jiaofen_num"):setString("x"..tostring(bufferData.chip[i]))
        end        
    end        
end
--该uid玩家下注chip
function GameViewLayer:theUidChip(bufferData)
    if bufferData[1] == GlobalUserItem.tabAccountInfo.userid then
        self.root:getChildByName("jiaofen_Panel"):setVisible(false)
        self.daojishi_Num = 15
    end
    if self.isIntoGameLate ~= true then
        for key, player in ipairs(self.playerList) do
            if player.uid == bufferData[1] then
                local bg = player.panel:getChildByName("chip_bg"):setVisible(true)
                bg:getChildByName("chip_Text"):setString(bufferData[2])
            end        
        end
    end    
end
--下注结束，发第五张牌
function GameViewLayer:onFifthCard(bufferData)
    self.niuType_self = self:getNiuType(bufferData.cards)

    --发牌延时
    local faPaiDt = {0.3, 0.4, 0.5, 0.2, 0.1, 0.0}
    local poker_panel = self.root:getChildByName("card_panel")

    local fapaiAct = function(chair_id,card)
        for i, player in ipairs(self.playerList) do
            self.Pokers[chair_id][5] = Poker:create()
            poker_panel:addChild(self.Pokers[chair_id][5])
            --设置牌背面
            self.Pokers[chair_id][5]:setBack()

            --重置位置 重置大小
            self.Pokers[chair_id][5]:setPosition(cc.p(cc.Director:getInstance():getWinSize().width*0.5,cc.Director:getInstance():getWinSize().height*0.5))
            self.Pokers[chair_id][5]:setScale(0.2)
            self.Pokers[chair_id][5]:setSkewX(0)
            self.Pokers[chair_id][5]:setRotation(0)
            if chair_id == 4 then
                self.Pokers[chair_id][5]:runAction(cc.Sequence:create(
                    cc.DelayTime:create(faPaiDt[chair_id]), --不同玩家分开执行发牌动作
                    cc.DelayTime:create((5-1)*0.05),            --不同牌分开发出
                    cc.ScaleTo:create(0.35, 0.95),          --最后缩放的大小
                    cc.DelayTime:create(0.05*4 - 0.05*(5-1)),   --等待所有牌缩放动作完成在左边集合
                    cc.DelayTime:create(0.2)                --move的时间

                ))

                local bezier = {  
                    GameViewLayer.FAPAI_POS[chair_id],--self.pathPos[idx],
                    GameViewLayer.FAPAI_POS[chair_id],--self.pathPos[idx],      --折点的位置
                    GameViewLayer.POKER_POS[chair_id][1]--self.targetPos[idx],    --第一张牌的位置
                }  

                self.Pokers[chair_id][5]:runAction(cc.Sequence:create(
                    cc.DelayTime:create(faPaiDt[chair_id]),
                    cc.DelayTime:create((5-1)*0.05),
                    cc.BezierTo:create(0.35, bezier),--array
                    cc.DelayTime:create(0.05*4 - 0.05*(5-1)),
                    cc.MoveTo:create(0.2,GameViewLayer.POKER_POS[chair_id][5]),
                    cc.OrbitCamera:create(0.2,1,0,0,90,0,0),
                    cc.CallFunc:create(function()
                        self.Pokers[chair_id][5]:setCardData(card)
                    end),
                    cc.OrbitCamera:create(0.3,1,0,270,90,0,0)
                ))
            else
                --其他玩家
                self.Pokers[chair_id][5]:setScale(0.2)
                --执行对应的缩放变化
                self.Pokers[chair_id][5]:runAction(cc.Sequence:create(
                    cc.DelayTime:create(faPaiDt[chair_id]),
                    cc.DelayTime:create((5-1)*0.05),

                    cc.ScaleTo:create(0.35,0.8),
                    cc.DelayTime:create(0.05*4 - 0.05*(5-1)),
                    cc.ScaleTo:create(0.2,0.8)
                ))

                --旋转变化 
                self.Pokers[chair_id][5]:runAction(cc.Sequence:create(
                    cc.DelayTime:create(faPaiDt[chair_id]),
                    cc.DelayTime:create((5-1)*0.05),

                    cc.DelayTime:create(0.35),
                    cc.DelayTime:create(0.05*4 - 0.05*(5-1)),
                    cc.DelayTime:create(0.2)
                ))

                local bezier = {  
                    GameViewLayer.FAPAI_POS[chair_id],--self.pathPos[idx],
                    GameViewLayer.FAPAI_POS[chair_id],--self.pathPos[idx],      --折点的位置
                    GameViewLayer.POKER_POS[chair_id][1]--self.targetPos[idx],    --第一张牌的位置  
                }  
                self.Pokers[chair_id][5]:runAction(cc.Sequence:create(
                    cc.DelayTime:create(faPaiDt[chair_id]),
                    cc.DelayTime:create((5-1)*0.05),

                    cc.BezierTo:create(0.35, bezier),
                    cc.DelayTime:create(0.05*4 - 0.05*(5-1)),
                    cc.MoveTo:create(0.2,GameViewLayer.POKER_POS[chair_id][5])
                ))
            end
        end
    end
    if self.isIntoGameLate ~= true then
        for key, player_ in ipairs(self.playerList) do
            if player_.isShowJinbi then
                if player_.uid ~= GlobalUserItem.tabAccountInfo.userid then
                    fapaiAct(player_.panel_Id)
                else
                    fapaiAct(player_.panel_Id,bufferData.cards[5])
                end
            end            
        end
        self.root:getChildByName("btn_tanpai"):setVisible(true)
    end

    self.ownerState = GameViewLayer.STATE_LIANGPAI
    
end
--自身玩家中途进入游戏房间
function GameViewLayer:intoGameLate(bufferData)
    self.ownerState = GameViewLayer.STATE_LATE_GAME
    self.isIntoGameLate = true
    self.daojishi_Num = bufferData.t
    local tt = 0
    self.daojishi_Num,tt = math.modf(self.daojishi_Num/1);

end
--更新其他玩家金钱
function GameViewLayer:updataOtherMoney(bufferData)
    for key, player in ipairs(self.playerList) do
        if bufferData[1] == player.uid then
            local money_num = bufferData[2]
            local money_str = player.panel:getChildByName("str_player_money")
            if money_num >= 100000000 then
                money_str:setString(tostring(money_num/100000000).."亿")
            elseif money_num >= 10000 then
                money_str:setString(tostring(money_num/10000).."万")
            else
                money_str:setString(tostring(money_num))
            end
        end
    end   
end
--更新自己背包金钱
function GameViewLayer:updataSelfMoney(bufferData)   
    local money_num = bufferData
    local money_str = self.root:getChildByName("player_Panel_4"):getChildByName("str_player_money")
    if money_num >= 100000000 then
        money_str:setString(tostring(money_num/100000000).."亿")
    elseif money_num >= 10000 then
        money_str:setString(tostring(money_num/10000).."万")
    else
        money_str:setString(tostring(money_num))
    end
end


--加载卡牌
function GameViewLayer:setCardImage(cardData,cardPanel)
    local card_color,value = math.modf((cardData+1)/13);
    local card_value = (cardData+1)%13
    if card_value == 0 then
        card_color = card_color-1
        card_value = 13
    end

    local fWidth = 90
    local fHeight = 119
    local x = (card_value-1)*fWidth
	local y = card_color*fHeight
    local cardRect = cc.rect(x,y,fWidth,fHeight);
    local sprite_card = cc.Sprite:createWithTexture(self.cardTexture,cardRect)--:setScaleX(1.1)--:setScaleY(1.36)
--    local sprite_image = cc.SpriteFrameCache:getInstance():createWithTexture(self.cardTexture,cardRect)
--    cardPanel:loadTexture(sprite_image)
    sprite_card:setPosition(cc.p(0,0))
    sprite_card:setAnchorPoint(cc.p(0,0))
    cardPanel:addChild(sprite_card,10)
    print("创建牌-------------------------------------")
    return sprite_card
end

--开启托管
function GameViewLayer:onTuoguan()
    self.isTuoGuan = true
    self.root:getChildByName("btn_tuoguan"):setVisible(false)
    self.root:getChildByName("btn_tuoguan_cancel"):setVisible(true)
    self.root:getChildByName("btn_tanpai"):setOpacity(0):setTouchEnabled(false)
    self.root:getChildByName("btn_tishi"):setOpacity(0):setTouchEnabled(false)
    if self.gameEnterState then
--        self:onTanPai()
        self._scene:sendTanPai()
        print("_________________________托管摊牌")
    else
--        self:onReady()
        self._scene:sendReady()
        print("_________________________托管准备")
    end
end
--关闭托管
function GameViewLayer:offTuoguan()
    self.isTuoGuan = false
    self.root:getChildByName("btn_tuoguan_cancel"):setVisible(false)
    self.root:getChildByName("btn_tuoguan"):setVisible(true)
    self.root:getChildByName("btn_tanpai"):setOpacity(255):setTouchEnabled(true)
    self.root:getChildByName("btn_tishi"):setOpacity(255):setTouchEnabled(false)
end
--开始准备按钮
function GameViewLayer:onReady()
    local btn_tanpai = self.root:getChildByName("btn_tanpai"):setVisible(false)
    local btn_tishi = self.root:getChildByName("btn_tishi"):setVisible(false)
    self._scene:sendReady()
    local btn_ready = self.root:getChildByName("btn_begin"):setVisible(false) 

    for i = 1,4 do
        self.root:getChildByName("player_Panel_"..tostring(i)):getChildByName("lose_money_bg"):setVisible(false)
        self.root:getChildByName("player_Panel_"..tostring(i)):getChildByName("win_money_bg"):setVisible(false)
    end
end
--摊牌按钮
function GameViewLayer:onTanPai()
    self.gameEnterState = false
    self._scene:sendTanPai()
    local btn_tanpai = self.root:getChildByName("btn_tanpai"):setVisible(false)
    local btn_tishi = self.root:getChildByName("btn_tishi"):setVisible(false)
end
--提示按钮
function GameViewLayer:onShowTishi()
    local frame = self.spriteFrameCache_niuniu:getSpriteFrameByName("game71/ctwin/ct"..tostring(self.niuType_self+1)..".png")
    local ox = cc.Sprite:createWithSpriteFrame(frame):setPosition(cc.p(0,0))
    self.root:getChildByName("player_Panel_4"):getChildByName("animation_panel"):addChild(ox):setAnchorPoint(cc.p(0,0))
    ox:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,3),cc.ScaleTo:create(0.1,1)))
    ExternalFun.playSoundEffect(tostring(self.niuType_self+1)..".ogg")
end
--换桌按钮
function GameViewLayer:onChangeTable()
    
    for key, player in ipairs(self.playerList) do
        player.panel:setVisible(false)
        player.panel:getChildByName("sp_icon"):removeAllChildren()        
        for i = 1,5 do
            player.panel:getChildByName("card_"..tostring(i)):removeAllChildren():setVisible(false)
        end
        player.panel:getChildByName("animation_panel"):removeAllChildren()
        table.remove(self.playerList,key)
    end
    self._scene:sendChangeTable()
end
--抢/不抢庄按钮
function GameViewLayer:onZhuang(_id)
    self.root:getChildByName("qiangzhuang_Panel"):setVisible(false)
    if self.multiple == nil then
        self.multiple = {0,1,2,3,4}
    end
    
    self._scene:sendAskBanker(self.multiple[_id+1])
end
--下注按钮
function GameViewLayer:onXiazhuCallback(num)
    self.root:getChildByName("jiaofen_Panel"):setVisible(false)
    self._scene:sendChip_in(self.chip_value[num])
end
--------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------- 分界线 --------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------


function GameViewLayer:unloadResource()
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
    if self.jinbiFlyFunc_ ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.jinbiFlyFunc_) 
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

--获取牛型
function GameViewLayer:getNiuType(cardTab)
    local card_value_tab = {}   --（1-10）
    local card_num_tab ={}      -- (1-13)
    local card_color_tab = {}   --花色
    for key, card_value in ipairs(cardTab) do
        local card_color,tt = math.modf((card_value+1)/13);
        card_color = card_color+1
        local card_value = (card_value+1)%13
        if card_value == 0 then
            card_value = 13
        end
        table.insert(card_color_tab,card_color)
        table.insert(card_num_tab,card_value)
        if card_value>=10 then
            card_value = 10
        end
        table.insert(card_value_tab,card_value)
    end
    local function compareFun(value1,value2)
        return value1<value2
    end
    table.sort(card_value_tab,compareFun)
    table.sort(card_num_tab,compareFun)
    --求普通牛型
    local function getNiubyCards(cards)
        local lave = 0     --余数
        for i = 1,#cards do
            lave = lave + cards[i]
        end
        lave = lave % 10
        for i = 1,#cards - 1 do
            for j = i + 1,#cards do
                if(cards[i]+cards[j])%10 == lave then
                    if lave == 0 then
                        return 10
                    else
                        return lave
                    end
                end
            end
        end 
        return 0
    end
    --五小牛    
    local function is_small_niu(cards)
        local sum = 0     
        for i = 1,#cards do
            sum = sum + cards[i]
        end
        if sum <= 10 then
            return 13     --应该是几
        else
            return false
        end
    end
    --炸弹牛（传牌上的数值，11=11）
    local function is_bomb(cards) 
        if cards[1] == cards[4] then
            return 16
        elseif cards[2] == cards[5] then
            return 16
        else
            return false
        end
    end
    --黄金牛牛/五花牛  （传牌上的数值，11=11）   
    local function is_gold_niu(cards)
        if cards[1] > 10 then
            return 12
        else
            return false
        end
    end
    --银牛/四花牛      （传牌上的数值，11=11）
    local function is_silver_niu(cards)
        if cards[2] > 10 and cards[1] == 10 then
            return true
        else
            return false
        end
    end
    --同花牛
    local function is_sameColor_niu(cards)
        if cards[1] == cards[2] == cards[3] == cards[4] == cards[5] then
            return 14
        end
        return false
    end
    --顺子牛
    local function is_straight_niu(cards)
        if cards[5]-cards[4] == 1 then
            if cards[4]-cards[3] == 1 then
                if cards[3]-cards[2] == 1 then
                    if cards[2]-cards[1] == 1 then
                        return 11
                    end
                end
            end
        end
        return false
    end
    --葫芦牛
    local function is_cucurbit_niu(cards)
        for key, card in ipairs(cards) do
            for key_, card_ in ipairs(cards) do
                if key ~= key_ then
                    if card == card_ then
                        for key__, card__ in ipairs(cards) do
                            if key__ ~= key and key__ ~= key_ then
                                if card == card__ then
                                    for key___, card___ in ipairs(cards) do
                                        if key___~=key and key~= key_ and key~= key__ then
                                            for key____, card____ in ipairs(cards) do
                                                if key____~=key and key____~= key_ and key____~= key__ and key____ ~= key___ then
                                                    if card___ == card____ then
                                                        return 15
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end            
        end
        return false
    end
    if is_bomb(card_num_tab) then
        return is_bomb(card_num_tab)
    elseif is_cucurbit_niu(card_num_tab) then
        return is_cucurbit_niu(card_num_tab)
    elseif is_sameColor_niu(card_color_tab) then
        return is_sameColor_niu(card_color_tab)
    elseif is_small_niu(card_num_tab) then
        return is_small_niu(card_num_tab)
    elseif is_gold_niu(card_num_tab) then
        return is_gold_niu(card_num_tab)
    elseif is_straight_niu(card_num_tab) then
        return is_straight_niu(card_num_tab)
    else
        return getNiubyCards(card_value_tab)
    end
end

return GameViewLayer