-- region FishMainView.lua
-- Date     2017.04.07
-- zhiyuan
-- Desc 主页面 layer.

local module_pre = "game.yule.monkeyfish.src"
local FishPaoView     = appdf.req(module_pre ..".views.layer.FishPaoView")
local FishRuleView    = appdf.req(module_pre ..".views.layer.FishRuleView")
local FishSettingView = appdf.req(module_pre ..".views.layer.FishSettingView")
local FishDataMgr     = appdf.req(module_pre ..".views.manager.FishDataMgr")
local FishSceneMgr    = appdf.req(module_pre ..".views.manager.FishSceneMgr")    
local FishTraceMgr    = appdf.req(module_pre ..".views.manager.FishTraceMgr")    
local ResourceManager = appdf.req(module_pre ..".views.manager.ResourceManager")
local CMsgFish        = appdf.req(module_pre ..".views.proxy.CMsgFish")
local FishEvent       = appdf.req(module_pre ..".views.scene.FishEvent")
local FishRes         = appdf.req(module_pre ..".views.scene.FishSceneRes")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local scheduler = cc.Director:getInstance():getScheduler()

--玩家不操作倒计时时间间隔
local EXIT_GAME_TIME_FISH = 30

local FishMainView = class("FishMainView", cc.Layer)

function FishMainView:ctor(scene)
    --FloatMessage.getInstance():setPositionX((display.width - 1334) / 2)
    self._scene = scene
    self:enableNodeEvents()

    self.updateHandler = nil 
    self.m_shakeUpdata = nil 

    self.m_pFishPaoView = nil
    self.m_pNodeBg = nil
    self.m_pNodeFunction = nil
    self.m_pBG = nil
    self.m_pShowButton = nil
    self.m_pExitButton = nil
    self.m_pSoundButton = nil
    self.m_pHelpButton = nil
    self.m_pInputNode = nil
    self.m_pOutputNode = nil
    self.m_pLabaBackBtn = nil
    self.m_pOutputInfo = nil
    self.m_pOutputInfoNode = nil
    self.m_strMsg = ""
    self.m_llTimeLast = 0
    self.m_bIsAction = false
    self.m_pEditLabaMsg = nil
    self.m_pLbExitGame = nil
    self.m_pActionShake = nil

    self.m_pClippingMenu = nil  --裁剪

    self.m_bIsPresssDown = false
    self.m_bIsShowExitTips = false
    self.m_nTargetPoint = cc.p(0, 0)
    self.m_nIsShowFuncton = false
    self.m_pQiPaoArm = {}
    for i = 1, 5 do
        self.m_pQiPaoArm[i] = nil
    end
    self.m_fCountDownTime = EXIT_GAME_TIME_FISH
    self.m_pEventListener = nil
    self.m_bIsAutoFire = false
    self.m_nIsOpenCloseBox = false
    self.m_nLaBaId = 0
    self.m_bIsCloseEnterView = false

    self.m_nDeltaHeight = (display.height-750)/2

    --震屏参数
    self.m_strength_x = 2
    self.m_strength_y = 2
    self.m_initial_x = 677
    self.m_initial_y = 375
    self.m_duration = 1.5
    self.m_dt = 0

    --记录进入后台
    self.m_bEnterBackground = false

    self:init()

    --检查帧数效率，是否开启流畅模式
    --self.MAX_SWITCH_TIME = 30               -- 检测时间周期
    --self.LESS_FRAME_NUM = 20                -- 检测的最低帧数
    --self.m_bAlreadySwitchSetting = false    -- 是否已经是流畅模式
    --self.m_switchUpdateTime = cc.exports.gettime()             -- 检测的更新时间
    --self.m_lessFrameNumber = 0              -- 累积的低帧数总值
    --local  bMusic = AudioManager.getInstance():getMusicOn()
    --local  bSound = AudioManager.getInstance():getSoundOn() 
    --local  bShadow = cc.UserDefault:getInstance():getIntegerForKey("fish_shadow", 0)
    --local  bEffect = cc.UserDefault:getInstance():getIntegerForKey("fish_effect", 0)   
    --if not bMusic and not bSound and bShadow == 1 and bEffect == 1 then
    --    self.m_bAlreadySwitchSetting = true
    --end
end

function FishMainView:init()
    self:initCSB()
    self:initLayer()
end

function FishMainView:initCSB()

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)

    --csb
    self.m_pFishMainView = cc.CSLoader:createNode("game/monkeyfish/csb/gui-fish-main.csb")
    self.m_pFishMainView:setPositionX((display.width - 1334) / 2)
    self.m_pFishMainView:addTo(self.m_rootUI)

    --背景
    self.m_pNodeMain = self.m_pFishMainView:getChildByName("NodeMain")
    self.m_pBG = self.m_pNodeMain:getChildByName("Sprite_1")
    self.m_pNewBG = self.m_pNodeMain:getChildByName("Sprite_2")

    --提示
    self.m_pNodeTips      = self.m_pFishMainView:getChildByName("m_pNodeTips")
    self.m_pLbExitGame    = self.m_pNodeTips:getChildByName("m_LbExitGameTips")

    --按钮
    self.m_pNodeFunction  = self.m_pFishMainView:getChildByName("m_pNodeFunction")
    self.m_pShowButton    = self.m_pNodeFunction:getChildByName("m_pShowButton")
    self.m_pHideButton    = self.m_pNodeFunction:getChildByName("m_pHideButton")
    self.m_pExitButton    = self.m_pNodeFunction:getChildByName("m_pExitButton")
    self.m_pRuleButton    = self.m_pNodeFunction:getChildByName("m_pRuleButton")
    self.m_pSettingButton = self.m_pNodeFunction:getChildByName("m_pSettingButton")

    --绑定按钮
    self.m_pShowButton:addClickEventListener(handler(self, self.onFunctionClicked))
    self.m_pHideButton:addClickEventListener(handler(self, self.onFunctionClicked))
    self.m_pExitButton:addClickEventListener(handler(self, self.onExitClicked))
    self.m_pRuleButton:addClickEventListener(handler(self, self.onHelpClicked))
    self.m_pSettingButton:addClickEventListener(handler(self, self.onSettingClicked))

    --坐标
    self.m_vecButton = {
        self.m_pExitButton,
        self.m_pRuleButton,
        self.m_pSettingButton,
    }
    self.m_posOpen = {
        cc.p(self.m_pExitButton:getPosition()),
        cc.p(self.m_pRuleButton:getPosition()),
        cc.p(self.m_pSettingButton:getPosition()),
    }
    self.m_posClose = cc.p(self.m_pShowButton:getPosition())

    --显示
    self.m_pShowButton:setVisible(true)
    self.m_pHideButton:setVisible(false)
    self.m_pExitButton:setVisible(false)
    self.m_pRuleButton:setVisible(false)
    self.m_pSettingButton:setVisible(false)
    self.m_pExitButton:setPosition(self.m_posClose)
    self.m_pRuleButton:setPosition(self.m_posClose)
    self.m_pSettingButton:setPosition(self.m_posClose)

    self.m_pBG:setVisible(true)
    self.m_pNewBG:setVisible(false)
end

function FishMainView:initLayer()

    --炮台界面
    self.m_pFishPaoView = FishPaoView.create()
    self.m_pFishPaoView:addTo(self.m_pFishMainView)
    self.m_pFishPaoView:setBg(self.m_pBG, self.m_pNewBG)

    --层级
    self.m_pNodeMain:setLocalZOrder(10) --10
    self.m_pFishPaoView:setLocalZOrder(20) --20
    self.m_pNodeTips:setLocalZOrder(100) --100
    self.m_pNodeFunction:setLocalZOrder(100) --100

    --宽屏
    if LuaUtils.isIphoneXDesignResolution() then
        self.m_pNodeFunction:setPositionX(self.m_pNodeFunction:getPositionX() - 85)
    end
end

function FishMainView:initGameEvent()

    --注册事件监听
    self.event_game_ = {
        [FishEvent.MSG_FISH_CHANGE_BG]        = { func =  self.onMsgNewScene,       },
        [FishEvent.MSG_SHAKE_SCREEN]          = { func =  self.onMsgShake,          },
--        [Public_Events.MSG_FISH_CLOSE]        = { func =  self.onMsgClose,          },
--        [Public_Events.MSG_NETWORK_FAILURE]   = { func =  self.onMsgNetworkFail,    },
--        [Public_Events.MSG_APP_RESIGN_ACTIVE] = { func =  self.onMsgResignActive,   },
        [Hall_Events.MSG_SHOW_FISH_EFFECT]  = { func =  self.onMsgShowFishEffect, },
    }
    for key, event in pairs(self.event_game_) do
         SLFacade:addCustomEventListener(key, handler(self, event.func), self.__cname)
    end
end

function FishMainView:stopGameEvent()

    --注销监听事件
    for key in pairs(self.event_game_) do
         SLFacade:removeCustomEventListener(key, self.__cname)
    end
    self.event_game_ = {}
end

function FishMainView:initLayerEvent()

    --监听事件
    self.event_layer_  = {}
--    self.event_layer_ = {
--        [Public_Events.MSG_GAME_NETWORK_FAILURE]  =  { func = self.onMsgEnterNetWorkFail, },
--        [Public_Events.MSG_GAME_ENTER_BACKGROUND] =  { func = self.onMsgEnterBackGround,  },
--        [Public_Events.MSG_GAME_ENTER_FOREGROUND] =  { func = self.onMsgEnterForeGround,  },
--        [Public_Events.MSG_GAME_RELOGIN_SUCCESS]  =  { func = self.onMsgReloginSuccess,   },
--    }
--    for key, event in pairs(self.event_layer_) do
--        SLFacade:addCustomEventListener(key, handler(self, event.func), self.__cname)
--    end
end

function FishMainView:stopLayerEvent()
    --注销监听事件
    for key in pairs(self.event_layer_) do
         SLFacade:removeCustomEventListener(key, self.__cname)
    end
    self.event_layer_ = {}
end

function FishMainView:initUpdateEvent()
    --事件循环
    self.updateHandler = scheduler:scheduleScriptFunc(handler(self, self.update), 0.03, false)
end

function FishMainView:stopUpdateEvent()

    --停止循环定时器
    if self.updateHandler then
        scheduler:unscheduleScriptEntry(self.updateHandler)
        self.updateHandler = nil
    end
    --停止震动定时器
    if self.m_shakeUpdata then
        scheduler:unscheduleScriptEntry(self.m_shakeUpdata)
        self.m_shakeUpdata = nil
    end
    --注销体验房提示
    --if self.m_nScheduleTips then
    --    scheduler.unscheduleGlobal(self.m_nScheduleTips)
    --    self.m_nScheduleTips = nil
    --end
end

function FishMainView:initTouchEvent()

    -- 添加触摸事件处理函数
    self.m_pEventListener = cc.EventListenerTouchOneByOne:create()
    self.m_pEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.m_pEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.m_pEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self.m_pEventListener:registerScriptHandler(handler(self, self.onTouchCancelled), cc.Handler.EVENT_TOUCH_CANCELLED)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_pEventListener, self)
end

function FishMainView:stopTouchEvent()
    --注销触摸事件
    if self.m_pEventListener then
        self:getEventDispatcher():removeEventListener(self.m_pEventListener)
        self.m_pEventListener = nil
    end
end

function FishMainView:onEnter()

    self:initGameEvent()
    self:initLayerEvent()
    self:initUpdateEvent()
    self:initTouchEvent()

    --设置背景音乐
    self:playBgMusic()

    --播放气泡
    self:playQipao()

    --玩家未操作倒计时
    self:begineCountDown()

    --????????
    --FishDataMgr.getInstance():sendExchangeFishScore(-2)
    --测试鱼潮
--    cc.exports.g_index = 1
--    cc.exports.scheduler.scheduleGlobal(function()
--        g_index = g_index + 1
--        if g_index == 8 then
--            g_index = 0
--        end
--        --数据
--        local pswitchscene = {}
--        pswitchscene.next_scene = g_index
--        pswitchscene.tick_count = 1
--        pswitchscene.create_time = cc.exports.gettime() --创建鱼阵的时间
--        --保存
--        FishDataMgr.getInstance():loadSwitchScene(pswitchscene)
--    end, 10.0)
    ------------------------------------------

--    --体验房提示
--    if PlayerInfo.getInstance():getServerType() == 2 then
--        local nCountUpdate = 60.0 * 10
--        self.m_nScheduleTips = scheduler.scheduleGlobal(function()
--            local pMessageBox = self:getChildByName("fish-recharge")
--            if pMessageBox then
--                return
--            end
--            pMessageBox = MessageBox.create("fish-recharge")
--            pMessageBox:setName("fish-recharge")
--            pMessageBox:setPosition(cc.p(0,(display.height-750)/2))
--            pMessageBox:addTo(self.m_rootUI, 1000)

--        end, nCountUpdate)
--    end
end

function FishMainView:onExit()

    self:stop()     --停止更新和监听
    self:reset()    --重设数据
    self:clear()    --清理缓存
end

function FishMainView:stop()
    
    self:stopGameEvent()
    self:stopLayerEvent()
    self:stopUpdateEvent()
    self:stopTouchEvent()
end

function FishMainView:reset()
    
--    PlayerInfo.getInstance():setSitSuc(false)
--    PlayerInfo.getInstance():setChairID(INVALID_CHAIR)
--    PlayerInfo.getInstance():setTableID(INVALID_TABLE)
--    PlayerInfo.getInstance():setIsQuickStart(false)
--    PlayerInfo.getInstance():setIsReLoginInGame(false)
--    PlayerInfo:getInstance():updateExperience()
--    PlayerInfo.getInstance():setIsGameBackToHall(true)
--    PlayerInfo:getInstance():setIsGameBackToHallSuc(false)
--    AudioManager.getInstance():stopAllSoundEffect()
--    AudioManager:getInstance():stopMusic(true)
--    RollMsg.getInstance():cleanupMessage()
    
    ResourceManager.getInstance():Clear()
    FishSceneMgr.releaseInstance()
    FishTraceMgr.releaseInstance()
    ResourceManager.releaseInstance()
end

-- 退出游戏释放缓存资源
function FishMainView:clear()

    -- 释放动画
    for i, name in pairs(FishRes.vecReleaseAnim) do
        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(name)
    end
    -- 释放整图
    for i, name in pairs(FishRes.vecReleasePlist) do
        display.removeSpriteFrames(name[1], name[2])
    end
    -- 释放背景图
    for i, name in pairs(FishRes.vecReleaseImg) do
        display.removeImage(strFileName)
    end
    -- 释放音频
    for i, name in pairs(FishRes.vecReleaseSound) do
       AudioEngine.unloadEffect(name)
    end
end

--进入断网
function FishMainView:onMsgEnterNetWorkFail()
end

--进入后台
function FishMainView:onMsgEnterBackGround()
end

--进入前台
function FishMainView:onMsgEnterForeGround()
end

--重登录成功
function FishMainView:onMsgReloginSuccess()
end

function FishMainView:update( dt)
    --self:checkSwitchSettingView( dt )
    self:onMsgCountDown(dt)

    --自动开炮
    if self.m_bIsPresssDown then 
        if self.m_pFishPaoView:myFire(self.m_nTargetPoint, false) then
            self.m_bIsPresssDown = true
        else
            self.m_bIsPresssDown = false
        end
    end 
end 

function FishMainView:onMsgNewScene(userdata)

    local nextScene = FishDataMgr:getInstance():getSwtichSceneData()
    local index = nextScene.next_scene

    --更换音乐
    local pathMusic= FishRes.SOUND_OF_BG[index % 3 + 1]
    ExternalFun.playGameBackgroundAudio(pathMusic)

    --更换背景
    --local pathBg = FishRes.PNG_OF_BG[index % 8 + 1]
    --self.m_pBG:loadTexture(pathBg, ccui.TextureResType.localType)

    --删除波浪
    self.m_pFishPaoView:deleteWave()

    -- 添加气泡
    self:playQipao()
end

function FishMainView:playBgMusic()

    local isMusicOn = GlobalUserItem.bVoiceAble     
    if isMusicOn then
        ExternalFun.playGameBackgroundAudio(FishRes.SOUND_OF_BG[1])
    end
end

function FishMainView:playQipao()

    local function getPosVec()
        math.newrandomseed()
        return {
            cc.p( math.random(50,  200),  math.random(50,  200) ),
            cc.p( math.random(100, 300),  math.random(500, 680) ),
            cc.p( math.random(550, 750),  math.random(250, 450) ),
            cc.p( math.random(900, 1250), math.random(50,  200) ),
            cc.p( math.random(900, 1250), math.random(400, 550) ),
        }
    end

    local function getScaleVec()
        math.newrandomseed()
        return {
            math.random(8, 10) / 10.0,
            math.random(8, 10) / 10.0,
            math.random(8, 10) / 10.0,
            math.random(8, 10) / 10.0,
            math.random(8, 10) / 10.0,
        }
    end

    local posVec = getPosVec()
    local scaleVec = getScaleVec()
    local openEffect = cc.UserDefault:getInstance():getIntegerForKey("fish_effect", 0)
    for i = 1, 5 do
        
        --生成气泡
        if self.m_pQiPaoArm[i] == nil then
            self.m_pQiPaoArm[i] = ccs.Armature:create("qipao_buyu")
            self.m_pQiPaoArm[i]:addTo(self.m_pFishPaoView, -1)
        end

        --随机位置/大小
        self.m_pQiPaoArm[i]:setVisible(false)
        self.m_pQiPaoArm[i]:setPosition(posVec[i])
        self.m_pQiPaoArm[i]:setScale(scaleVec[i])

        --随机延时
        local nDalay = math.random(1, 20) / 20.0
        local pAction = cc.Sequence:create(
            cc.DelayTime:create(nDalay),
            cc.CallFunc:create(function()
                self.m_pQiPaoArm[i]:getAnimation():play("Animation1")
                if openEffect == 1 then
                    self.m_pQiPaoArm[i]:setVisible(false)
                else
                    self.m_pQiPaoArm[i]:setVisible(true)
                end                
            end))
        self.m_pQiPaoArm[i]:runAction(pAction)
    end
end

function FishMainView:effectEnd(armature, ntype, name)

    if armature == nil then 
        return 
    end 
    ResourceManager.removeEffect(armature)
end 

function FishMainView:onMsgShake()
    self:shakeScreen()
end 

--震屏
function FishMainView:shakeScreen()
    self:stopShake()
    self:shake(self.m_pFishMainView, 1.5, 100)
end

--震动动画, target震动节点, 震动时长, 震动幅度
function FishMainView:shake(target, duration, strength)
    self.m_duration = duration
    self.m_strength_x = strength
    self.m_strength_y = strength
    self.m_initial_x = target:getPositionX()
    self.m_initial_y = target:getPositionY()
    self.m_duration = duration
    self.m_dt = 0
    self.m_shakeUpdata = scheduler:scheduleScriptFunc(handler(self, self.shakeUpdata), 0.05, false)
end

function FishMainView:shakeUpdata(dt)
    self.m_dt = self.m_dt + dt
    local randx = (math.floor(math.random() * (-self.m_strength_x - self.m_strength_x)) + self.m_strength_x) * dt
    local randy = (math.floor(math.random() * (-self.m_strength_y - self.m_strength_y)) + self.m_strength_y) * dt
    self.m_pFishMainView:setPosition(cc.p(self.m_initial_x + randx, self.m_initial_y + randy))
    if self.m_dt > self.m_duration then
        self:stopShake()
    end
end

function FishMainView:stopShake()
    if self.m_shakeUpdata then
        scheduler:unscheduleScriptEntry(self.m_shakeUpdata)
        self.m_shakeUpdata = nil
        self.m_pFishMainView:setPosition(cc.p(self.m_initial_x, self.m_initial_y))
    end
end

function FishMainView:onFunctionClicked()
    ExternalFun.playGameEffect(FishRes.SOUND_OF_BUTTON)

    if self.m_nIsShowFuncton then
        return
    else
        self.m_nIsShowFuncton = true
    end

    if self.m_pShowButton:isVisible() then 
        
        self.m_pShowButton:setVisible(false)
        self.m_pHideButton:setVisible(true)

        for i = 1, 3 do --展开
            local spawn = cc.Spawn:create(
                cc.EaseBackInOut:create(cc.MoveTo:create(0.2, self.m_posOpen[i])),
                cc.ScaleTo:create(0.2, 1))
            local seq = cc.Sequence:create(
                cc.DelayTime:create(0.1),
                cc.Show:create())
            local action = cc.Sequence:create(
                cc.DelayTime:create(0.1 * i),
                cc.Spawn:create(seq, spawn))
            self.m_vecButton[i]:runAction(action)
        end
        
        local delay = cc.DelayTime:create(0.5)
        local call = cc.CallFunc:create(function()
            for i = 1, 3 do
                self.m_vecButton[i]:setPosition(self.m_posOpen[i])
            end
            self.m_nIsShowFuncton = false
        end)
        local seq = cc.Sequence:create(delay, call)
        self.m_pNodeFunction:runAction(seq)

    else
        self.m_pShowButton:setVisible(true)
        self.m_pHideButton:setVisible(false)

        for i = 1, 3 do --收合
            local spawn = cc.Spawn:create(
                cc.EaseBackInOut:create(cc.MoveTo:create(0.2, self.m_posClose)),
                cc.ScaleTo:create(0.2, 1))
            local seq = cc.Sequence:create(
                cc.DelayTime:create(0.1),
                cc.Hide:create())
            local action = cc.Sequence:create(
                cc.DelayTime:create(0.1 * i),
                cc.Spawn:create(seq, spawn))
            self.m_vecButton[i]:runAction(action)
        end
        
        local delay = cc.DelayTime:create(0.5)
        local call = cc.CallFunc:create(function()
            for i = 1, 3 do
                self.m_vecButton[i]:setPosition(self.m_posClose)
            end
            self.m_nIsShowFuncton = false
        end)
        local seq = cc.Sequence:create(delay, call)
        self.m_pNodeFunction:runAction(seq)
    end
end 

function FishMainView:onLaBaClicked()
--    -- 捕鱼一个按纽控制 音效和音乐, 任一个开都开
--    local isMusicOn = AudioManager.getInstance():getMusicOn()   
--    local isSoundOn = AudioManager.getInstance():getSoundOn()
--    if isMusicOn or isSoundOn then
--        AudioManager.getInstance():stopAllSounds()
--        AudioManager.getInstance():stopMusic(false)

--        AudioManager.getInstance():setMusicOn(false)
--        AudioManager.getInstance():setSoundOn(false)
--    else
--        AudioManager.getInstance():setMusicOn(true)
--        AudioManager.getInstance():setSoundOn(true)
--    end

--    if isMusicOn or isSoundOn then
--        -- 打开
--        local sp1 = cc.Scale9Sprite:createWithSpriteFrameName("gui-fish-btn-sound-close.png")
--        self.m_pSoundButton:setBackgroundSpriteForState(sp1, cc.CONTROL_STATE_NORMAL)
--    else
--        local sp1 = cc.Scale9Sprite:createWithSpriteFrameName("gui-fish-guangbo-bt.png")
--        self.m_pSoundButton:setBackgroundSpriteForState(sp1, cc.CONTROL_STATE_NORMAL)
--        AudioManager:getInstance():playMusic(FishRes.SOUND_OF_BG[1])
--    end
end 

function FishMainView:onMsgClose(_event)
    -----------------------------
    -- add by JackyXu.
    -- 防连点
    local nCurTime = os.time();
    if self.m_nLastTouchTime and nCurTime - self.m_nLastTouchTime <= 0 then
        return
    end
    self.m_nLastTouchTime = nCurTime
    -----------------------------

    -- 停止监听/动作/更新
    if FishDataMgr:getInstance():getLock() then 
        self.m_pFishPaoView:onLockClicked()
    end 
    self:stop()
    self.m_pFishPaoView:onMsgClose()
    self.m_pFishPaoView:stopAllActions()
    self.m_pFishPaoView:stop()

    self._scene:onExitTable()
end

function FishMainView:onMsgNetworkFail()
--    if self.m_nIsOpenCloseBox then
--        return
--    else
--        self.m_nIsOpenCloseBox = true
--    end

--    FishDataMgr:getInstance():setIsNetworkFail(true)
    FloatMessage.getInstance():pushMessage("STRING_023")
    self:onMsgClose()
end

function FishMainView:onMsgResignActive()
    FloatMessage.getInstance():pushMessage("STRING_023")
    self:onMsgClose()
end

function FishMainView:onMsgShowFishEffect( event )
   if event == nil then
        return
   end   
   local _userdata = unpack(event._userdata)
   local bshow = _userdata.showEffect
   for i = 1, 5 do
        if self.m_pQiPaoArm[i] ~= nil then
            self.m_pQiPaoArm[i]:setVisible( bshow )
        end
    end
end

function FishMainView:begineCountDown(isAuto)

    self.m_bIsShowExitTips = false
    self.m_pLbExitGame:setVisible(false)
    self.m_bIsAutoFire = isAuto
    self.m_fCountDownTime = EXIT_GAME_TIME_FISH * 2
end 

function FishMainView:showCountDownExitTips( value)

    self.m_bIsShowExitTips = true
    self.m_fCountDownTime = EXIT_GAME_TIME_FISH
    self.m_pLbExitGame:setVisible(true)
end 

function FishMainView:onMsgCountDown(value)

    if self.m_nIsOpenCloseBox or self.m_bIsPresssDown
    --or FishDataMgr:getInstance():getLock()
    then
        return
    end

    self.m_fCountDownTime = self.m_fCountDownTime - value

    if not self.m_bIsShowExitTips then
        if self.m_fCountDownTime <= 0 then
            self:showCountDownExitTips(0)
        end
        return
    end

    local showTempTime = 0
    if self.m_fCountDownTime > 0 then
        showTempTime = self.m_fCountDownTime + 0.5
    else
        self.m_fCountDownTime = 0
        showTempTime = self.m_fCountDownTime
    end
    -- print("-----------onMsgCountDown------------%f--",math.ceil(showTempTime))
    local strCount = math.ceil(showTempTime)
    local strExitGame = string.format("由于您一分钟未发射子弹将在%.0f秒后离开游戏", strCount)
    self.m_pLbExitGame:setString(strExitGame)
    --self.m_pLbExitGame:setString("0000000000000000000000000000000000")
    if self.m_fCountDownTime <= 0 then
        self.m_pLbExitGame:setVisible(false)
        self:onMsgClose()
    end
end 

function FishMainView:onMsgShowMessageBox(_event)
    local pMessageBox = self:getChildByName("MessageBoxLayer")
    if pMessageBox then
        pMessageBox:setVisible(true)
        return
    end

    local _userdata = unpack(_event._userdata)
    if not _userdata then
        return
    end
    local eventID = _userdata.name
    local msg = _userdata.packet
    pMessageBox = MessageBox.create(tostring(msg))
    pMessageBox:setName("MessageBoxLayer")
    pMessageBox:setPosition(cc.p(0,(display.height-750)/2))
    self:addChild(pMessageBox, 1000)
end

function FishMainView:onTouchBegan(touch, event)
    self.m_nTargetPoint = cc.p(touch:getLocation().x, touch:getLocation().y - self.m_nDeltaHeight)
    if LuaUtils.IphoneXDesignResolution then
        self.m_nTargetPoint.x = self.m_nTargetPoint.x - LuaUtils.screenDiffX
    end
    if FishDataMgr:getInstance():getLock() then --锁定时

        --找鱼
        local nTempLockId = -1
        local fish_kind_temp = FishKind.FISH_WONIUYU
        for i, pFish in pairs(FishDataMgr:getInstance().m_vecFish) do
            -- 找不到鱼/路径没有创建完成/鱼死亡/OutScreen 都不能执行一下的逻辑
            if pFish and pFish:getTraceFinish() and not pFish:getDie() and not pFish:isOutScreen() then
                local fishPosX, fishPosY, realKind = pFish.lastposX, pFish.lastposY, pFish:getRealFishKind()
                local fishWidthRadius = FishDataMgr:getInstance():getFishBoxWidth(realKind)
                local fishHeightRadius = FishDataMgr:getInstance():getFishBoxheight(realKind)
                local rectFish = {
                    x      = fishPosX - fishWidthRadius * 1.1,
                    y      = fishPosY - fishHeightRadius * 1.1,
                    width  = fishWidthRadius * 2.2,
                    height = fishHeightRadius * 2.2 
                }
                local cacalKind = pFish:getFishKind()
                if cacalKind == FishKind.FISH_JINCHAN or cacalKind == FishKind.FISH_SHUANGTOUQIE then -- 调整BOSS显示到最高层级
                    cacalKind = cacalKind + FishKind.FISH_KIND_COUNT
                end

                if cc.rectContainsPoint(rectFish, self.m_nTargetPoint) and cacalKind >= fish_kind_temp then
                    nTempLockId = pFish:getID()
                    fish_kind_temp = cacalKind--找到kindID最大的鱼
                end
            end
        end

        --锁定状态下,切换锁定的鱼
        if nTempLockId > -1 then
            if self.m_pFishPaoView:getLockFish() ~= nTempLockId then
                self.m_pFishPaoView:_lockFish(nTempLockId)
            end
        end
    end

    --自动发炮
    self.m_pFishPaoView:myRotatePao(self.m_nTargetPoint)
    if self.m_pFishPaoView:myFire(self.m_nTargetPoint, false) then
        self.m_bIsPresssDown = true
    else
        self.m_bIsPresssDown = false
    end
    self:TouchHandler(1, touch)
    return true
end

function FishMainView:onTouchMoved(touch, event)
    self.m_nTargetPoint = cc.p(touch:getLocation().x, touch:getLocation().y)
    if LuaUtils.IphoneXDesignResolution then
        self.m_nTargetPoint.x = self.m_nTargetPoint.x - LuaUtils.screenDiffX
    end
    self.m_pFishPaoView:myRotatePao(self.m_nTargetPoint)
    self:TouchHandler(2, touch)
end

function FishMainView:onTouchEnded(touch, event)
    self.m_bIsPresssDown = false
    self:TouchHandler(4, touch)
end

function FishMainView:onTouchCancelled(touch, event)    
    self.m_bIsPresssDown = false
    self:TouchHandler(4, touch)
end

function FishMainView:TouchHandler(op,touch)
    CMsgFish.getInstance():FireContinuously(op, GlobalUserItem.tabAccountInfo.userid, self.m_nTargetPoint.x, self.m_nTargetPoint.y)
end

function FishMainView:onExitClicked()
    ExternalFun.playGameEffect(FishRes.SOUND_OF_BUTTON)

    self:onMsgClose()
end

function FishMainView:onHelpClicked()
    ExternalFun.playGameEffect(FishRes.SOUND_OF_BUTTON)

    FishRuleView.new():addTo(self.m_rootUI, 1000)
end

function FishMainView:onSettingClicked()
    ExternalFun.playGameEffect(FishRes.SOUND_OF_BUTTON)

    FishSettingView.new():addTo(self.m_rootUI, 1000)
end

--function FishMainView:checkSwitchSettingView( dt )
--    if self.m_bAlreadySwitchSetting then
--        return
--    end
--    self.m_lessFrameNumber = self.m_lessFrameNumber + 1
--    if FishDataMgr:getInstance().m_fUpdateFishTime > self.m_switchUpdateTime + self.MAX_SWITCH_TIME then
--        self.m_switchUpdateTime = FishDataMgr:getInstance().m_fUpdateFishTime
--        if self.m_lessFrameNumber < self.MAX_SWITCH_TIME * self.LESS_FRAME_NUM  then 
--            self.m_bAlreadySwitchSetting = true
--            self:onShowSwitchLayer()
--        end
--        self.m_lessFrameNumber = 0
--    end
--end

return FishMainView

-- endregion
