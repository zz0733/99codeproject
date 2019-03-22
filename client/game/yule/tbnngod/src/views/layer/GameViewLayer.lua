--
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local module_pre = "game.yule.tbnngod.src"
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

function GameViewLayer:ctor(scene)
print("on enter -----------===========----------    GameViewLayer")
    --注册node事件
    ExternalFun.registerNodeEvent(self)
    self._scene = scene

    --托管标志位
    self.isTuoGuan = false
    --进入游戏时当前桌面状态--(false是没有进行游戏，true是有游戏牌局在进行)
    self.gameEnterState = false 

    -- --初始化
    -- self:paramInit()

    -- --加载资源
    -- self:loadResource()

    --初始化界面
    self:loadLayer()

end


GameViewLayer.POKER_POS = {     --扑克坐标
{cc.p(585, 550),cc.p(625, 550),cc.p(665, 550),cc.p(705, 550),cc.p(745, 550)},
{cc.p(275, 410),cc.p(315, 410),cc.p(355, 410),cc.p(395, 410),cc.p(435, 410)},
{cc.p(175, 210),cc.p(215, 210),cc.p(255, 210),cc.p(295, 210),cc.p(335, 210)},
{cc.p(797, 410),cc.p(837, 410),cc.p(877, 410),cc.p(917, 410),cc.p(957, 410)},
{cc.p(887, 210),cc.p(927, 210),cc.p(967, 210),cc.p(1007, 210),cc.p(1047, 210)},
{cc.p(375, 0),  cc.p(500, 0),  cc.p(625, 0),  cc.p(750, 0),  cc.p(875, 0)}
}
GameViewLayer.HEAD_POS = {      --头像坐标
cc.p(510, 680),cc.p(200, 535),cc.p(100, 335),cc.p(1144, 535),cc.p(1234, 335),cc.p(300, 125)
}
GameViewLayer.FAPAI_POS = {      --发牌折点的位置
cc.p(710, 645),cc.p(400, 500),cc.p(300, 300),cc.p(880, 415),cc.p(975, 335),cc.p(420, 240)
}
function GameViewLayer:loadLayer()    
    ExternalFun.playBackgroudAudio("Game.mp3")

    local rootLayer, csbNode = ExternalFun.loadRootCSB("tbnn/tbnnScene.csb", self)
    self.root = csbNode
    --iphoneX适配
    if LuaUtils.isIphoneXDesignResolution() then
        local width_ = yl.WIDTH - display.size.width
        self.root:setPositionX(self.root:getPositionX() - width_/2)
    end

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("tbnn/effect/qiangzhuangpinshi_jiesuan/qiangzhuangpinshi_jiesuan.ExportJson")               --结算胜利失败特效
    --------------------全局变量--------------------------
    self.playerInfoTable = {}
    self.myPos_ = 0
    self.Pokers = {}
    for i = 1,6 do
        self.Pokers[i] = {}
    end
    
    for i = 1, 6 do
        self.root:getChildByName(string.format("user_panel_%d",i)):setVisible(false)    --玩家panel
        self.root:getChildByName(string.format("user_panel_%d",i)):getChildByName("lab_win_money"):setString("")
        self.root:getChildByName(string.format("user_panel_%d",i)):getChildByName("lab_lose_money"):setString("")
        self.root:getChildByName(string.format("user_panel_%d",i)):getChildByName("timer"):setVisible(false)    --框
        self.root:getChildByName("userState_panel"):getChildByName(string.format("zhunbei_%d",i)):setVisible(false) --准备字样
        self.root:getChildByName("userState_panel"):getChildByName(string.format("tanpai_%d",i)):setVisible(false) --摊牌字样
        self.root:getChildByName("userState_panel"):getChildByName(string.format("niuType_%d",i)):setVisible(false) --牛型字样
    end
    self.root:getChildByName("btn_tanpai"):setVisible(false)

    --------------------button----------------------------
    --菜单按钮
    local touchFunC_menu = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("menu_panel"):setVisible(true)
            self.root:getChildByName("btn_menu"):setVisible(false)
        end
    end
    local btn_menu = self.root:getChildByName("btn_menu"):addTouchEventListener( touchFunC_menu )
    --收起菜单按钮
    local touchFunC_menu_back = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("menu_panel"):setVisible(false)
            self.root:getChildByName("btn_menu"):setVisible(true)
        end
    end
    local btn_menu_back = self.root:getChildByName("menu_panel"):getChildByName("btn_close"):addTouchEventListener( touchFunC_menu_back )
    local panel_menu_back = self.root:getChildByName("menu_panel"):setTouchEnabled(true):addTouchEventListener( touchFunC_menu_back )
    --离开房间按钮
    local touchFunC_leaveGame = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self._scene:onQueryExitGame()
        end
    end
    local btn_leaveGame = self.root:getChildByName("btn_back"):addTouchEventListener( touchFunC_leaveGame )
    --关闭音乐按钮
    local touchFunC_leaveGame = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("menu_panel"):getChildByName("btn_yinyue"):setVisible(false)
            self.root:getChildByName("menu_panel"):getChildByName("btn_yinyue_"):setVisible(true)
--            AudioEngine.setMusicVolume(0)
            GlobalUserItem.setVoiceAble(false)
        end
    end
    local btn_leaveGame = self.root:getChildByName("menu_panel"):getChildByName("btn_yinyue"):addTouchEventListener( touchFunC_leaveGame )
    --打开音乐按钮
    local touchFunC_leaveGame = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("menu_panel"):getChildByName("btn_yinyue"):setVisible(true)
            self.root:getChildByName("menu_panel"):getChildByName("btn_yinyue_"):setVisible(false)
--            AudioEngine.setMusicVolume(1)
            GlobalUserItem.setVoiceAble(true)
        end
    end
    local btn_leaveGame = self.root:getChildByName("menu_panel"):getChildByName("btn_yinyue_"):addTouchEventListener( touchFunC_leaveGame )
    if (GlobalUserItem.bVoiceAble)then
        GlobalUserItem.setVoiceAble(true)
        self.root:getChildByName("menu_panel"):getChildByName("btn_yinyue"):setVisible(true)
        self.root:getChildByName("menu_panel"):getChildByName("btn_yinyue_"):setVisible(false)
    else
        GlobalUserItem.setVoiceAble(false)
        self.root:getChildByName("menu_panel"):getChildByName("btn_yinyue"):setVisible(false)
        self.root:getChildByName("menu_panel"):getChildByName("btn_yinyue_"):setVisible(true)    
    end
    if (GlobalUserItem.bSoundAble)then
        GlobalUserItem.setSoundAble(true)
        self.root:getChildByName("menu_panel"):getChildByName("btn_yinxiao"):setVisible(true)
        self.root:getChildByName("menu_panel"):getChildByName("btn_yinxiao_"):setVisible(false)
    else
        GlobalUserItem.setSoundAble(false)
        self.root:getChildByName("menu_panel"):getChildByName("btn_yinxiao"):setVisible(false)
        self.root:getChildByName("menu_panel"):getChildByName("btn_yinxiao_"):setVisible(true)    
    end
    --关闭音效按钮
    local touchFunC_leaveGame = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("menu_panel"):getChildByName("btn_yinxiao"):setVisible(false)
            self.root:getChildByName("menu_panel"):getChildByName("btn_yinxiao_"):setVisible(true)
--            AudioEngine.setEffectsVolume(0)
            GlobalUserItem.setSoundAble(false)
        end
    end
    local btn_leaveGame = self.root:getChildByName("menu_panel"):getChildByName("btn_yinxiao"):addTouchEventListener( touchFunC_leaveGame )
    --打开音效按钮
    local touchFunC_leaveGame = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("menu_panel"):getChildByName("btn_yinxiao"):setVisible(true)
            self.root:getChildByName("menu_panel"):getChildByName("btn_yinxiao_"):setVisible(false)
--            AudioEngine.setEffectsVolume(1)
            GlobalUserItem.setSoundAble(true)
        end
    end
    local btn_leaveGame = self.root:getChildByName("menu_panel"):getChildByName("btn_yinxiao_"):addTouchEventListener( touchFunC_leaveGame )
    --规则按钮
    local touchFunC_rule = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("rule_panel"):setVisible(true)
            self.root:getChildByName("menu_panel"):setVisible(false)
            self.root:getChildByName("btn_menu"):setVisible(true)
        end
    end
    local btn_rule = self.root:getChildByName("menu_panel"):getChildByName("btn_rule"):addTouchEventListener( touchFunC_rule )
    --规则关闭按钮
    local touchFunC_rule_close = function(ref, tType)
        if tType == ccui.TouchEventType.ended then            
            self.root:getChildByName("rule_panel"):setVisible(false)
        end
    end
    local btn_rule_close = self.root:getChildByName("rule_panel"):getChildByName("btn_close"):addTouchEventListener( touchFunC_rule_close )
    local panel_rule_close = self.root:getChildByName("rule_panel"):setTouchEnabled(true):addTouchEventListener( touchFunC_rule_close )
    --摊牌按钮
    local touchFunC_tanpai = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self._scene:sendTanPai()
            self.root:getChildByName("btn_tanpai"):setVisible(false)
        end
    end
    local btn_tanpai = self.root:getChildByName("btn_tanpai"):addTouchEventListener( touchFunC_tanpai )
    --准备按钮
    local touchFunC_zhunbei = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self._scene:sendReady()
            self.root:getChildByName("btn_zhunbei"):setVisible(false)
        end
    end
    local btn_zhunbei = self.root:getChildByName("btn_zhunbei"):addTouchEventListener( touchFunC_zhunbei )

    local this = self
    self.timeout_ = 0
    self._ClockFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                this:OnClockUpdata()
            end, 1, false)
end
function GameViewLayer:OnClockUpdata()
    
    self.root:getChildByName("jishi_panel"):getChildByName("label_time"):setString(self.timeout_)
    self.timeout_ = self.timeout_ - 1
    if self.timeout_ < 0 then
        self.root:getChildByName("jishi_panel"):setVisible(false)
    end
end
function GameViewLayer:onEventEnter(bufferData)
    for key, player_ in ipairs(bufferData.memberinfos) do
        if player_.uid == GlobalUserItem.tabAccountInfo.userid then
            self.myPos_ = player_.position
        end
    end
    self.root:getChildByName("lab_dizhu"):setString(string.format("底注：%d",bufferData.deskinfo.unit_money))
    --加载玩家信息
    for key, player_ in ipairs(bufferData.memberinfos) do
        self:loadPlayerInfo(player_)
    end
    
end

function GameViewLayer:loadPlayerInfo(playerInfo)
    local isHave = false    --判断玩家信息表中是否已存在该玩家信息
    for key, player_ in ipairs(self.playerInfoTable) do
        if playerInfo.uid == player_.uid then
            isHave = true
        end
    end
    if isHave ~= true then
        table.insert(self.playerInfoTable,playerInfo)
    end
    if playerInfo.uid ~= GlobalUserItem.tabAccountInfo.userid then
        if playerInfo.position < self.myPos_ then
            playerInfo["chairID"] = playerInfo.position + 1
        else
            playerInfo["chairID"] = playerInfo.position
        end
    else
        playerInfo["chairID"] = 6
    end
    local panel_ = self.root:getChildByName(string.format("user_panel_%d",playerInfo["chairID"]))
    panel_:setVisible(true)
    panel_:getChildByName("name"):setString(playerInfo.nickname)
    panel_:getChildByName("money"):setString(playerInfo.into_money)
    local icon = panel_:getChildByName("bg")
    local head = HeadSprite:createNormal(playerInfo, 100)
    head:setPosition(cc.p(65,125))
    head:setAnchorPoint(cc.p(0.5,0.5))
    head:setScale(105/head:getContentSize().width)
    icon:addChild(head)
    playerInfo["panel"] = panel_
end

function GameViewLayer:onEventCome(bufferData)
    self:loadPlayerInfo(bufferData.memberinfo)
end
function GameViewLayer:onEventLeave(bufferData)
    for key, player_ in ipairs(self.playerInfoTable) do
        if bufferData == player_.uid then
            player_.panel:setVisible(false)
            table.remove(self.playerInfoTable,key)
            self.Pokers[player_.chairID] = {}
        end
    end
end
function GameViewLayer:onEventReady(bufferData)
    local chair_id = nil
    for key, player_ in ipairs(self.playerInfoTable) do
        if bufferData == player_.uid then
            chair_id = player_.chairID
        end
    end

    self.root:getChildByName("userState_panel"):getChildByName(string.format("zhunbei_%d",chair_id)):setVisible(true)
end
function GameViewLayer:onEventOK(bufferData)
    local chair_id = nil
    for key, player_ in ipairs(self.playerInfoTable) do
        if bufferData.uid == player_.uid then
            chair_id = player_.chairID
        end
    end

    self.root:getChildByName("userState_panel"):getChildByName(string.format("tanpai_%d",chair_id)):setVisible(true)
end
function GameViewLayer:onEventDeal(bufferData)
    --音效（开始游戏）
    ExternalFun.playSoundEffect("start.ogg")
    local ttt = 0
    self.timeout_,ttt = math.modf(bufferData.t/1)
    self.root:getChildByName("jishi_panel"):setVisible(true)

    self.root:getChildByName("sp_gameBegin"):runAction( cc.Sequence:create( cc.MoveTo:create(0.35,cc.p(727,400)),cc.MoveTo:create(0.2,cc.p(627,400)),cc.MoveTo:create(0.2,cc.p(727,400)),cc.MoveTo:create(0.1,cc.p(677,400)),cc.MoveTo:create(0.15,cc.p(1600,400)),cc.DelayTime:create(1),cc.CallFunc:create(function()
            self.root:getChildByName("sp_gameBegin"):setPosition(cc.p(-500,400))
            self.root:getChildByName("btn_tanpai"):setVisible(true)
        end) ))
    --隐藏准备
    for i = 1,6 do
        self.root:getChildByName("userState_panel"):getChildByName(string.format("zhunbei_%d",i)):setVisible(false)
    end
    for key, player_ in ipairs(self.playerInfoTable) do
        if player_.uid ~= GlobalUserItem.tabAccountInfo.userid then
            self:showFaPaiAni(player_.chairID)
        else
            self:showFaPaiAni(player_.chairID,bufferData.cards)
        end
    end

end
function GameViewLayer:showFaPaiAni(chair_id,pokerDatas)
    --发牌延时
    local faPaiDt = {1.3, 1.4, 1.5, 1.2, 1.1, 1.0}
    local poker_panel = self.root:getChildByName("card_panel")
    --创建5张牌 发牌
    for n = 1 ,5 do
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

        --设置牌数据
--        self.Pokers[chair_id][n]:setData(pokerDatas[n])
--        self.Pokers[chair_id][n]:setVisible(true)

        --自己带翻牌
        if chair_id == 6 then
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
function GameViewLayer:onEventEnd(bufferData)
    self.root:getChildByName("jishi_panel"):setVisible(false)
    self.root:getChildByName("btn_tanpai"):setVisible(false)

    local winChair = 0
    for key, playerEndInfo_ in ipairs(bufferData.gold_nn) do
        for key, player_ in ipairs(self.playerInfoTable) do
            if playerEndInfo_[1] == player_.uid then
                local chair_id = player_.chairID
                local panel_ = player_.panel
                --展示所有玩家的牌
                for i = 1,5 do  
                    if #self.Pokers[chair_id] > 0  then
                        self.Pokers[chair_id][i]:setCardData(playerEndInfo_[2][i])
                    end                    
                end
                 --有牛的牌前三张上移
                if playerEndInfo_[3]>0 then
                    for i = 1,3 do 
                        self.Pokers[chair_id][i]:runAction(cc.MoveBy:create(0.1,cc.p(0,20)))
                    end
                end
                panel_:getChildByName("money"):setString(playerEndInfo_[7])
                --展示牛型字样
                local niuType = self.root:getChildByName("userState_panel"):getChildByName(string.format("niuType_%d",chair_id))    
                niuType:setVisible(true) 
                niuType:setSpriteFrame(string.format("game/qznn/plist/gui-qz-niu-%d.png",playerEndInfo_[3]))
                niuType:runAction(cc.Sequence:create( cc.ScaleTo:create(0.1,0.5),cc.ScaleTo:create(0.2,1) ))
                --音效（牛型）
                ExternalFun.playSoundEffect(tostring(playerEndInfo_[3]+1)..".ogg")
                --记录胜利的椅子号，飞金币特效使用
                if playerEndInfo_[4] > 0 then
                    winChair = chair_id
                end
                local label_fly = nil
                if playerEndInfo_[4] > 0 then
                    label_fly = panel_:getChildByName("lab_win_money")
                    label_fly:setString("+"..playerEndInfo_[4]):setVisible(true)
                elseif playerEndInfo_[4] < 0 then
                    label_fly = panel_:getChildByName("lab_lose_money")
                    label_fly:setString(playerEndInfo_[4]):setVisible(true)
                end
                label_fly:setScale(0.8)
                local move1 = cc.MoveTo:create(0.5,cc.p(100,200))
                local move2 = cc.MoveTo:create(0.5,cc.p(250,160))
                local callF = cc.CallFunc:create(function()
                        label_fly:setString("")
                        label_fly:setPosition(cc.p(100,160))
                    end)
                
                if chair_id ~= 1 then
                    label_fly:runAction(cc.Sequence:create( move1,cc.DelayTime:create(2.5),callF ))
                else
                    label_fly:runAction(cc.Sequence:create( move2,cc.DelayTime:create(2.5),callF ))
                end
            end
        end
    end
    
    
    local callF1 = cc.CallFunc:create(function()
        for key, playerEndInfo_ in ipairs(bufferData.gold_nn) do
            --播放胜利失败动画
            if playerEndInfo_[1] == GlobalUserItem.tabAccountInfo.userid then
                if playerEndInfo_[4]>0 then
                    --音效（胜利）
                    ExternalFun.playSoundEffect("win.ogg")
                    --播放胜利动画
                    local jiesuAct = ccs.Armature:create("qiangzhuangpinshi_jiesuan")
                    jiesuAct:setAnchorPoint(cc.p(0.5,0.5))
                    jiesuAct:setPosition(cc.p(667,375))
	                jiesuAct:addTo(self.root:getChildByName("animation_panel"))
	                jiesuAct:getAnimation():play("Animation1")
                    local func = function (armature,movementType,movementID)
                            if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
                                if armature then 
                                    armature:removeFromParent()
                                end
                            end
                        end
                    jiesuAct:getAnimation():setMovementEventCallFunc(func)
                elseif playerEndInfo_[4]<0 then
                    --音效（失败）
                    ExternalFun.playSoundEffect("lose.ogg")
                    --播放失败动画
                    local jiesuAct = ccs.Armature:create("qiangzhuangpinshi_jiesuan")
                    jiesuAct:setAnchorPoint(cc.p(0.5,0.5))
                    jiesuAct:setPosition(cc.p(667,375))
	                jiesuAct:addTo(self.root:getChildByName("animation_panel"))
	                jiesuAct:getAnimation():play("Animation2")
                    local func = function (armature,movementType,movementID)
                            if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
                                if armature then 
                                    armature:removeFromParent()
                                end
                            end
                        end
                    jiesuAct:getAnimation():setMovementEventCallFunc(func)
                end
            end
        end
    end)
    local callF2 = cc.CallFunc:create(function()
        --飞金币特效
        local targetPos = GameViewLayer.HEAD_POS[winChair] --飞金币终点位置
        for key, playerEndInfo_ in ipairs(bufferData.gold_nn) do
            for key_, player_ in ipairs(self.playerInfoTable) do
                if playerEndInfo_[1] == player_.uid then
                    local chair_id = 10
                    if playerEndInfo_[4] < 0 then
                        chair_id = player_.chairID
                    else
                        break
                    end
                    if chair_id>6 or chair_id<1 then
                        break
                    end
                    
                    local startPos = GameViewLayer.HEAD_POS[chair_id]
                    for i = 1,15 do                  
                        --计算距离
                        local distance = cc.pGetDistance(targetPos,startPos)
                        local offset = 10
                        local flyDt = 0.5
                        local randomX = math.random()*3 - 1
                        local randomY = math.random()*3 - 1
                        local bezier = {  
                                            cc.p((startPos.x + targetPos.x)*0.5 + randomX*offset ,(startPos.y + targetPos.y)*0.5 + randomY*offset),
                                            cc.p((startPos.x + targetPos.x)*0.5 + randomX*offset ,(startPos.y + targetPos.y)*0.5 + randomY*offset),
                                            cc.p(targetPos.x + math.random()*10, targetPos.y + math.random()*10),
                                        }
                        local totalDt = 0.9
                        local flyDtOffset = (totalDt - flyDt) / 30
                        local ooo = cc.Sprite:create()
                        ooo:setSpriteFrame("game/qznn/plist/tbnn_coin.png")
                        ooo:setPosition(startPos)
                        ooo:setScale(0.4)
                        self.root:getChildByName("userState_panel"):addChild(ooo)
                        ooo:runAction(cc.Sequence:create(
                            cc.EaseExponentialInOut:create(cc.BezierTo:create(flyDt+flyDtOffset*i, bezier)),
                            cc.CallFunc:create(function()
                                ooo:removeFromParent()     
                            end)))
                    end                
                end
            end
        end
    end)

    local callF3 = cc.CallFunc:create(function()
        for i =1,6 do
            self.root:getChildByName("userState_panel"):getChildByName(string.format("tanpai_%d",i)):setVisible(false) --摊牌字样
            self.root:getChildByName("userState_panel"):getChildByName(string.format("niuType_%d",i)):setVisible(false) --牛型字样
        end
        for key, pokers_ in ipairs(self.Pokers) do
            print("扑克牌组中元素个数为："..#pokers_)
            for key_, poker_ in ipairs( pokers_ ) do
                if poker_ ~= nil then
                    poker_:removeFromParent()
                end                
            end
        end
        self.root:getChildByName("card_panel"):removeAllChildren()

--        self._scene:sendReady()
        self.root:getChildByName("btn_zhunbei"):setVisible(true)
    end)

    self:runAction(cc.Sequence:create(
        cc.DelayTime:create(1),
        callF1,
        cc.DelayTime:create(1),
        callF2,
        cc.DelayTime:create(2),
        callF3
    ))
end
function GameViewLayer:onEventDeskover(bufferData)
    
    dump(bufferData)
    
end
function GameViewLayer:onEventLate(bufferData)
    dump(bufferData)
    self.root:getChildByName("btn_zhunbei"):setVisible(false)
    local poker_panel = self.root:getChildByName("card_panel")
    for key, playerInfo_ in ipairs(bufferData.infos) do
        for key_, player_ in ipairs(self.playerInfoTable) do
            if playerInfo_[1] == player_.uid then
                local chair_id = player_.chairID
                if playerInfo_[2] == 1 then
                    self.root:getChildByName("userState_panel"):getChildByName("zhunbei_"..playerInfo_[2])
                end
                if playerInfo_[3] == 1 then
                    self.root:getChildByName("userState_panel"):getChildByName("tanpai_"..playerInfo_[2])
                end
                if #playerInfo_[4] > 0 then
                    for i = 1, 5 do
                        self.Pokers[chair_id][i] = Poker:create()
                        poker_panel:addChild(self.Pokers[chair_id][i])
                        self.Pokers[chair_id][i]:setScale(0.8)
                        --设置牌背面
                        self.Pokers[chair_id][i]:setBack()
                        self.Pokers[chair_id][i]:setPosition(GameViewLayer.POKER_POS[chair_id][i])
                        if playerInfo_[1] == GlobalUserItem.tabAccountInfo.userid then
                            self.Pokers[chair_id][i]:setCardData(playerInfo_[4][i])
                            self.Pokers[chair_id][i]:setScale(0.95)
                        end
                    end                    
                end
            end
        end        
    end
    
end
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
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
    self:unloadResource()

    self.m_tabUserItem = {}
end

return GameViewLayer