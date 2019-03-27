--
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun       = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameChatLayer     = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local ClipText          = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr      = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

local module_pre        = "game.yule.pjl.src"
local cmd               = appdf.req(module_pre .. ".models.CMD_Game")
local Define            = appdf.req(module_pre .. ".models.Define")
local GameRoleItem      = appdf.req(module_pre .. ".views.layer.GameRoleItem")
local HeadSprite        = require(appdf.EXTERNAL_SRC .. "HeadSprite")
local CardSprite        = appdf.req(module_pre .. ".views.layer.gamecard.CardSprite")
local CardsNode         = appdf.req(module_pre .. ".views.layer.gamecard.CardsNode")
local GameLogic         = appdf.req(module_pre .. ".models.GameLogic")
local GameResultLayer   = appdf.req(module_pre .. ".views.layer.GameResultLayer")
local SettingLayer      = appdf.req(module_pre .. ".views.layer.SettingLayer")

local Poker             = appdf.req(module_pre .. ".views.layer.gamecard.Poker")

local TAG_ENUM = Define.TAG_ENUM
local TAG_ZORDER = Define.TAG_ZORDER

local GameViewLayer = class("GameViewLayer",function(scene)
        local gameViewLayer = display.newLayer()
    return gameViewLayer
end)

local module_pre = "game.yule.pjl.src.views"
local scheduler = cc.Director:getInstance():getScheduler()
local WaterMarginSceneRes       = appdf.req(module_pre..".scene.WaterMarginSceneRes")
local WaterMarginResultView     = appdf.req(module_pre..".layer.WaterMarginResultView")
local CommonRuleView            = appdf.req(module_pre..".bean.CommonRuleView")
local WaterMarginDataMgr        = appdf.req(module_pre..".manager.WaterMarginDataMgr")
----local CMsgWaterMargin           = appdf.req(module_pre..".proxy.CMsgWaterMargin")
local WaterMarginScene_Events   = appdf.req(module_pre..".scene.WaterMarginSceneEvent")
--local LittleMaryLayer           = appdf.req(module_pre..".bean.LittleMaryLayer")
--local LittleMaryWaitLayer       = appdf.req(module_pre..".bean.LittleMaryWaitLayer")
local WaterMarginCompareView    = appdf.req(module_pre..".layer.WaterMarginCompareView")
--local IngameBankView            = appdf.req("hall.bean.IngameBankView")
--local MsgBoxPreBiz              = appdf.req("common.public.MsgBoxPreBiz")
--local RechargeLayer             = appdf.req("hall.layer.RechargeLayer")
--local GameListConfig            = appdf.req("common.config.GameList")    --等级场配置

local WATER_ICON_ROW =3                    --行
local WATER_ICON_COL =5                    --列
local WATER_MAX_LINE_NUM =9                --连线最大条数
local WATER_LINE_CARD_COUNT =5				--单条线上牌子最大数
local WATER_MARGIN_ICON_NUM =9             --图标资源个数
local WATER_MAX_ROW_ICON_NUM =15           --滚动总图标行数
local WATER_MAX_LITTLE_MARY_ICON_NUM =24   --小玛丽中外围滚动最大牌子数
local SPEAKER  = 3
local USERLIST = 4
local PATH_UI_WATER_MAIN = "game/watermargin/WaterMarginUi_main.json"
local PATH_UI_WATER_EXIT_TIPS = "game/watermargin/WaterMarginUi_exitTips.json"
local WIN_ALL_NOT = -1       --没有全屏
local WIN_ALL_MIX_ROLE = 9   --所有人物混合
local WIN_ALL_MIX_WEAPON  = 10    --所有武器混合
local GI_FUTOU = 0         -- 斧头
local GI_YINGQIANG = 1     -- 银枪
local GI_DADAO = 2         -- 大刀
local GI_LU = 3            -- 鲁智深
local GI_LIN = 4           -- 林冲
local GI_SONG = 5          -- 宋江
local GI_TITIANXINGDAO = 6 -- 替天行道
local GI_ZHONGYITANG = 7   -- 忠义堂
local GI_SHUIHUZHUAN = 8   -- 水浒传
local GI_COUNT = 9

local commonStartX = 239
local differX = 213

local commonStartY = 560
local differY = 173

--自动次数
local AUTO_COUNT = { 25, 50, 100 }

local _isShowWinTouch = false


function GameViewLayer:ctor(scene)
print("on enter -----------===========----------    GameViewLayer")
    --注册node事件
    ExternalFun.registerNodeEvent(self)
    self._scene = scene

    cc.SpriteFrameCache:getInstance():addSpriteFrames(WaterMarginSceneRes.vecReleasePlist[1][1],WaterMarginSceneRes.vecReleasePlist[1][2])
    for key, var in ipairs(WaterMarginSceneRes.vecReleaseAnim) do
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(var)
    end
    

    self:enableNodeEvents()

end

function GameViewLayer:onEnter()
    ExternalFun.playBackgroudAudio("sound_water_bg.mp3")
    local diffY = (display.size.height - 750) / 2
    self:setDiffY(diffY);
    self:setPosition(cc.p(0, diffY))       

    self:init()

    --self:flyIn()
end
function GameViewLayer:setDiffY(diffY)
    self.m_diffY = diffY
end
function GameViewLayer:init()

    self:initVars()
    self:onAnimationInitFinish()
end

--入场动画
function GameViewLayer:flyIn()
    local by = self.m_node_bottom:getPositionY()
    local ty = self.m_node_top:getPositionY()
    self.m_node_bottom:setPositionY(by-200)
    self.m_node_top:setPositionY(ty+200)
    local function moveTopAndBottom()
        --下方筹码区域
        local bottomMove = cc.MoveTo:create(0.2, cc.p(self.m_node_bottom:getPositionX(),by))
        self.m_node_bottom:runAction(bottomMove)

        --上面按钮
        local topMove = cc.MoveTo:create(0.2, cc.p(self.m_node_top:getPositionX(),ty))
        self.m_node_top:runAction(topMove)
    end
    --中间
    local actionNode = self:getChildByUIName(self.m_pUI, "actionnode")
    actionNode:setScale(0.6)
    local scaleTo = cc.ScaleTo:create(0.3, 1)
    local callback = cc.CallFunc:create(function ()
        moveTopAndBottom()
    end)
    local seq = cc.Sequence:create(scaleTo, callback)
    actionNode:runAction(seq)

    local partical = cc.ParticleSystemQuad:create("game/watermargin/effect/lizitexiao/taohua_lizi.plist")
    partical:setPosition(94,700)
    self.m_pUI:addChild(partical,4)

    local partical = cc.ParticleSystemQuad:create("game/watermargin/effect/lizitexiao/anniu_lizi.plist")
    partical:setPosition(116,57)
    self.m_pBtnGameStart:addChild(partical)
end

-- 清除变量
function GameViewLayer:initVars()
    self.m_pClippingMenu = nil
    self.m_cliperArea = {}
    self.m_cliperNode = {}
    for i=1,tonumber(WATER_ICON_COL),1 do 
        self.m_cliperArea[i] = nil
        self.m_cliperNode[i] = nil
    end
    self.isShowAreaEffectEnd = {}

    self.m_pBtnBank = nil
    self.m_pBtnGameStart = nil
    --self.m_pBtnGameStopStart = nil
    self.m_pBtnAddChip = nil
    self.m_pBtnSubChip = nil
    self.m_pBtnAutoGame = nil
    self.m_pBtnStopAutoGame = nil
    self.m_pBtnSound = nil
    self.m_pBtnVoice = nil
    self.m_pBtnMenuPush = nil
    self.m_pBtnMenuPop = nil
    
    self.m_pLbUserName = nil
    self.m_pLbUsrGold = nil
    self.m_pLbTotalCostGold = nil
    self.m_pLbCurCostGold = nil
    
    self.m_pNodeLeft = nil
    self.m_pNodeChildMenu = nil
    self.m_pNodeCenter = nil
    self.m_pNodeEffect = nil
    self.m_pNodeEffectLow = nil
    self.m_pNodeEffectLine = nil
    self.m_pKuangEffectNode = nil
    
    self.m_pBMLevel = nil
    
    self.m_nFullScreenSoundId = 0;
    self.m_nStartGameBtSoundId = 0;
    
    self.pChatNoticeEffect = nil
    self.pShakeFlagEffect = nil

    self.m_nPerShowCellHeight = 164
    
    self.m_pSpLine = {}
    self.m_pNodeLineEffectPos = {}
    for i=1,tonumber(WATER_MAX_LINE_NUM),1 do 
        self.m_pSpLine[i] = nil
        self.m_pNodeLineEffectPos[i] = nil
    end

    self.m_enterIntoMoney = 0
    self.m_iShowWinIndex = 1
    self.isUpdateShowGold = true
    self.isEnterBank = false
    self.m_bLittleEndAuto = false

    self.m_vecPlayIconEffect = {}

    self.m_nCurrentAutoCount = -1
    self.m_onLongPressCallBack = nil
    self.m_bLongPress = false

    self.m_bEnterBackground = false
    self.m_bIsQuicklyJieSuan = false
    self.m_bSendStart = false
    self.m_bHaveEnterLittleMary = false
    self.m_winMoney = 0             --每轮转完，中奖金额
    self.m_DiceMoney = 0            --比倍结束飘的钱数
    self.isMusicOn = true
    self.isMusicEffictOn = true
    self.m_nautoBtnClickTimes = 0
    self.m_nLastTouchTime = 0
    self.isSettingPanelShowing = false
    WaterMarginDataMgr.getInstance():setGameHandleStatus(WaterMarginDataMgr.eGAME_HANDLE_IDLE)
end
function GameViewLayer:onAnimationInitFinish()
    
   -- 加载UI
   self.m_pUI = cc.CSLoader:createNode("shuihuzhuan/SHZ_Main.csb")
   self.m_pUI:addTo(self)
   self.m_pUI:setPosition((145 - (1624 - display.width) / 2), 0)
   self.panelBet = self:getChildByUIName(self.m_pUI, "panelBet"):setPositionX( display.width/2)
   self.panelFront = self:getChildByUIName(self.m_pUI, "panelFront"):setPositionX( display.width/2)  
   self.panelFront_0 = self:getChildByUIName(self.m_pUI, "panelFront_0"):setPositionX( display.width/2)  
   print("---加载UI成功")
   
   -- 初始化CCS
   self:initCCS()
   print("---初始化CCS成功")
--[[
   --有小玛丽进入小玛丽
   local littleCount = 0 --WaterMarginDataMgr.getInstance():getLittleMaryCount()
   print("---小玛丽次数："..littleCount)
   if littleCount > 0 then 
        self:enterLittleMaryGame()
   end
--]]
end
function GameViewLayer:initCCS()
   --初始化 UI 变量
   self:onAssignCCBMemberVariable()    
   --监听按钮
   self:onResolveCCBCCControlSelector()

   self:onNodeLoaded()

   self:initSpine()
   --加载其他onEnter
   self:initOther()
end
function GameViewLayer:onAssignCCBMemberVariable()
    self.CCSpriteMainBg = self:getChildByUIName(self.m_pUI, "bg")           --BG
    --[[
    self.m_pBtnBank = self:getChildByUIName(self.m_pUI, "m_pBtnBank")                   --上边保险箱
    --self.m_pBtnBank1 = self:getChildByUIName(self.m_pUI, "m_pBtnBank1")                 --下边的+ 保险箱
    self.m_pBtnBank:setTouchEnabled(false)
    self.m_pBtnBank:setColor(cc.c4b(100,100,100,100))
    self.m_pBtnBank1:setTouchEnabled(false)
    self.m_pBtnBank1:setColor(cc.c4b(100,100,100,100))
    --]]
    self.m_pBtnAddChip = self:getChildByUIName(self.m_pUI, "button_btnIncrease")             --押注“+”
    self.m_pBtnSubChip = self:getChildByUIName(self.m_pUI, "button_btnDecrease")             --押注“-”
    --self.m_pBtnStopAutoGame = self:getChildByUIName(self.m_pUI, " button_btnStart") 
      --关闭自动托管
    --[[
    self.m_pBtnSound = self:getChildByUIName(self.m_pUI, "m_pBtnSound")                 --音效
    self.m_pBtnVoice = self:getChildByUIName(self.m_pUI, "m_pBtnVoice")                 --音乐
    self.m_btn_close = self:getChildByUIName(self.m_pUI, "m_btn_close")                 --退出房间按钮
       self.m_pBtnMenuPop = self:getChildByUIName(self.m_pUI, "m_pBtnMenuPop")             --菜单 正上角
    --]]
   --  self.m_pBtnMenuPush = self:getChildByUIName(self.m_pUI, "button_back")           --菜单 倒三角
    --self.m_pLbUserName = self:getChildByUIName(self.m_pUI, "m_pLbNickName")             --玩家昵称
    self.m_pLbUsrGold = self:getChildByUIName(self.m_pUI, "bmfont_myGold")               --玩家金币
    self.m_pLbTotalCostGold = self:getChildByUIName(self.m_pUI, "text_zongyafen")        --总押注
    self.m_pLbCurCostGold = self:getChildByUIName(self.m_pUI, "text_yafen")              --单线押注
    self.m_pLbyaxian = self:getChildByUIName(self.m_pUI, "text_yaxian")               --压线数
    self.m_pLbyyingfen = self:getChildByUIName(self.m_pUI, "text_yingfen")               --赢分
    self.back = self:getChildByUIName(self.m_pUI, "button_back")            --菜单 节点
    self.m_pNodeCenter = self:getChildByUIName(self.m_pUI, "m_pNodeCenter") 
    self.m_pNodeEffect = self:getChildByUIName(self.m_pUI, "m_pNodeEffect") 
    self.m_pNodeEffectLow = self:getChildByUIName(self.m_pUI, "m_pNodeEffectLow") 
    self.m_pNodeEffectLine = self:getChildByUIName(self.m_pUI, "m_pLineEffectNode") 
    self.m_pKuangEffectNode = self:getChildByUIName(self.m_pUI, "m_pKuangEffectNode")
    self.m_pHeadImg = self:getChildByUIName(self.m_pUI, "norFrame")   --头像节点
    self.settingPanel = self:getChildByUIName(self.m_pUI, "image_settingPanel")
    self.backMenu = self:getChildByUIName(self.m_pUI, "panel_backMenu")  
    self.backMenu:setVisible(false)
    self.m_btn_close = self:getChildByUIName(self.m_pUI, "button_exit")
    self.setting = self:getChildByUIName(self.m_pUI, "button_setting")       
    --[[
    self.m_node_bottom = self:getChildByUIName(self.m_pUI, "node_bottom")
    self.m_node_top = self:getChildByUIName(self.m_pUI, "node_top")
    --]]
    self.m_pNodeCenter:setPositionY(-5)

    for i=1,tonumber(WATER_MAX_LINE_NUM),1 do 
        local str = "line"..i
        self.m_pSpLine[i] = self:getChildByUIName(self.m_pUI, str)                      --9条线

       -- local str2 = "m_pNodeLineEffect"..(i-1)
       -- self.m_pNodeLineEffectPos[i] = self:getChildByUIName(self.m_pUI, str2) 

    end

    self.m_pBtnGameStart = self:getChildByUIName(self.m_pUI, "button_btnStart")             --开始转动
    self.m_pBtnAutoGame = self:getChildByUIName(self.m_pUI, "button_btnAuto")               --开始自动按钮
    self.m_pBtnGSTextimg = self:getChildByUIName(self.m_pUI, "image_btnStartText")
    self.m_pAutoLight = self:getChildByUIName(self.m_pUI, "image_imgAutoLight") 
    --self.m_pLbCurrentAuto = self:getChildByUIName(self.m_pUI, "m_pLbCurrentAuto")
    --self.m_pNodeChooseAuto = self:getChildByUIName(self.m_pUI, "node_chooseAuto") 
    --self.m_pNodeBtnCount = self:getChildByUIName(self.m_pUI, "nod_btncount")
    --self.m_pBtnChooseAutoClose = self:getChildByUIName(self.m_pUI, "button_btnAuto")
    
    --ccs之外增加
    self.m_pRuleButton = self:getChildByUIName(self.m_pUI, "button_helpX")  
    --[[               --规则按钮
    self.m_pPushClicked = self:getChildByUIName(self.m_pUI, "m_pPushClicked")               --菜单 空白可触摸
    self.m_pPushClicked:setVisible(false)
    --]]
    --[[
    if (GlobalUserItem.bVoiceAble)then
        GlobalUserItem.setVoiceAble(true)
        self.m_pBtnVoice:loadTextureNormal("game/watermargin/images/gui-water-button-yingyue-1.png",ccui.TextureResType.plistType)
    else
        GlobalUserItem.setVoiceAble(false)
        self.m_pBtnVoice:loadTextureNormal("game/watermargin/images/gui-water-button-yingyue-2.png",ccui.TextureResType.plistType)    
    end
    if (GlobalUserItem.bSoundAble)then
        GlobalUserItem.setSoundAble(true)
        self.m_pBtnSound:loadTextureNormal("game/watermargin/images/gui-water-button-shengyin-1.png",ccui.TextureResType.plistType)
    else
        GlobalUserItem.setSoundAble(false)
        self.m_pBtnSound:loadTextureNormal("game/watermargin/images/gui-water-button-shengyin-2.png",ccui.TextureResType.plistType)    
    end
    --]]
--    --房间号
--    local strName = ""
--    local nBaseScore = PlayerInfo.getInstance():getBaseScore()
--    local GameConfig = GameListConfig[PlayerInfo.getInstance():getKindID()]
--    if GameConfig[nBaseScore] and GameConfig[nBaseScore].RoomName then
--        strName = GameConfig[nBaseScore].RoomName
--    end

--    local strRoomNo = string.format(self:getLocalString("STRING_187"), PlayerInfo.getInstance():getCurrentRoomNo())
--    local m_pLbRoomFiled = cc.Label:createWithBMFont(WaterMarginSceneRes.FONT_ROOM, strName)
--    m_pLbRoomFiled:setAnchorPoint(cc.p(0.5, 0.5))
--    m_pLbRoomFiled:setScale(0.6)
--    m_pLbRoomFiled:setPosition(cc.p(120, self.m_btn_close:getContentSize().height/2+15))
--    self.m_btn_close:addChild(m_pLbRoomFiled)
--    local m_pLbRoomNo = cc.Label:createWithBMFont(WaterMarginSceneRes.FONT_ROOM, strRoomNo)
--    m_pLbRoomNo:setAnchorPoint(cc.p(0.5, 0.5))
--    m_pLbRoomNo:setScale(0.6)
--    m_pLbRoomNo:setPosition(cc.p(120, self.m_btn_close:getContentSize().height/2 - 10))
--    self.m_btn_close:addChild(m_pLbRoomNo)

--    --滚动消息
--    RollMsg.getInstance():setShowPosition(display.width / 2, display.height-95.0)
--    --GameRollMsg.getInstance():setShowPosition(display.cx,display.height-35)
end

function GameViewLayer:getChildByUIName(root,name)
    if nil == root then
        return nil
    end
    if root:getName() == name then
        return root
    end
    local arrayRootChildren = root:getChildren()
    for i,v in ipairs(arrayRootChildren) do
        if nil~=v then
            local res = self:getChildByUIName(v,name)
            if res ~= nil then
                return res
            end
        end
    end
end

function GameViewLayer:onResolveCCBCCControlSelector()

    -- onRuleClicked --
    local onOpenRuleCallBack = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end

        ExternalFun.playSoundEffect("sound-button.mp3")

        self.m_CommonRuleView = CommonRuleView:create()
        self.m_CommonRuleView:addTo(self, WaterMarginDataMgr.Order_Result+100)
        self.onPushClicked()
    end    
    self.m_pRuleButton:addTouchEventListener(onOpenRuleCallBack)
    -- onRuleClicked --

    -- onStartClicked --
    local onStartGameCallBack = function (sender,eventType)
        if eventType == ccui.TouchEventType.began then
            if WaterMarginDataMgr.getInstance():getGameHandleStatus() ~= WaterMarginDataMgr.eGAME_HANDLE_IDLE then 
                return
            end
            --[[
            if self.m_onLongPressCallBack ~= nil then 
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_onLongPressCallBack)
            end
            self.m_onLongPressCallBack = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onLongPressCallBack),1.0,false)
            --]]
        elseif eventType == ccui.TouchEventType.moved then
         --[[
            local offsetX = 145 - (1624 - display.width) / 2
            local touchPos = cc.p(sender:getTouchMovePosition())
            local point = cc.p(touchPos.x - offsetX, touchPos.y -(display.height - 750) / 2)
            local startBtnPos = cc.p(sender:getPosition())
            local curPos = cc.p(startBtnPos.x-145,startBtnPos.y)
            local btnSize = sender:getContentSize()
            local rect = cc.rect(curPos.x - btnSize.width / 2, curPos.y-btnSize.height/2, btnSize.width, btnSize.height)
            if not cc.rectContainsPoint(rect, point) then -- 移出按纽区域
                if self.m_onLongPressCallBack ~= nil then 
                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_onLongPressCallBack)
                end
            end
            --]]
        elseif eventType == ccui.TouchEventType.ended then
            


            if eventType ~= ccui.TouchEventType.ended then
                return
            end
            ExternalFun.playSoundEffect("sound-water-bt-click.mp3")

            if WaterMarginDataMgr.getInstance():getGameHandleStatus() == WaterMarginDataMgr.eGAME_HANDLE_IDLE then 
                if not self.m_bSendStart then 
                    self:begineGame()
                end
            elseif WaterMarginDataMgr.getInstance():getGameHandleStatus() == WaterMarginDataMgr.eGAME_HANDLE_OPEN then 
                self:instantPlayResultEffect()
                self:showStartBtnStyle("normal")
            end
        else
        --[[
            if self.m_onLongPressCallBack ~= nil then 
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_onLongPressCallBack)
            end
            --]]
        end
--        if eventType ~= ccui.TouchEventType.ended then
--            return
--       end
--       self:begineGame()
--       self._scene:sendStart()
    end
    self.m_pBtnGameStart:addTouchEventListener(onStartGameCallBack)
    -- onStartClicked --

    -- onAddChipClicked --
    local onAddChipCallBack = function (sender,eventType)-----------------------------------------押注add按钮回调
        if eventType ~= ccui.TouchEventType.ended then
            return
        end
        ExternalFun.playSoundEffect("sound-water-bt-click.mp3");
    
        if WaterMarginDataMgr.getInstance():getGameHandleStatus() ~= WaterMarginDataMgr.eGAME_HANDLE_IDLE then
            return
        end
        local currentMulti = WaterMarginDataMgr.getInstance():getBaseBetChangeMul()
        currentMulti = currentMulti+1 > 5 and 1 or currentMulti+1
        WaterMarginDataMgr.getInstance():setBaseBetChangeMul(currentMulti)
        self:onMsgUpdateBetData() 
        
    end   
    self.m_pBtnAddChip:addTouchEventListener(onAddChipCallBack)  
    -- onAddChipClicked --

    -- onSubChipClicked --
    local onSubChipCallBack = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end
        ExternalFun.playSoundEffect("sound-water-bt-click.mp3");
    
        if WaterMarginDataMgr.getInstance():getGameHandleStatus() ~= WaterMarginDataMgr.eGAME_HANDLE_IDLE then
            return
        end
        local currentMulti = WaterMarginDataMgr.getInstance():getBaseBetChangeMul()
        currentMulti = currentMulti-1 < 1 and 5 or currentMulti-1
        WaterMarginDataMgr.getInstance():setBaseBetChangeMul(currentMulti)
        self:onMsgUpdateBetData()       --减注****
    end   
    self.m_pBtnSubChip:addTouchEventListener(onSubChipCallBack)       
    -- onSubChipClicked --

    -- onBankClicked --
    local onOpenBankCallBack = function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end
        self.isEnterBank = true
        ExternalFun.playSoundEffect("sound-button.mp3")
        -- 投注状态不能操作保险箱
        if WaterMarginDataMgr.getInstance():getGameHandleStatus() == WaterMarginDataMgr.eGAME_HANDLE_OPEN then
            FloatMessage.getInstance():pushMessage("BANK_30")
            return
        end
        if PlayerInfo.getInstance():getIsInsurePass() == 0 then
            FloatMessage.getInstance():pushMessage("STRING_033")
            return
        end
        --弹出银行界面
        local ingameBankView = IngameBankView:create()
        ingameBankView:setName("IngameBankView")
        ingameBankView:setCloseAfterRecharge(false)
        ingameBankView:setTag(2147483647)
        self:addChild(ingameBankView, 500)
    end
    --self.m_pBtnBank:addTouchEventListener(onOpenBankCallBack)
    --self.m_pBtnBank1:addTouchEventListener(onOpenBankCallBack)
    -- onBankClicked --

    -- onAutoGameClicked --
    local onBegineAutoGameCallBack = function (sender)
        ExternalFun.playSoundEffect("sound-water-bt-click.mp3")
        self.m_nautoBtnClickTimes = self.m_nautoBtnClickTimes + 1
        local nCurTime = os.time()
        if self.m_nautoBtnClickTimes > 2 and self.m_nLastTouchTime and nCurTime - self.m_nLastTouchTime <= 2 then
            FloatMessage.getInstance():pushMessage("点击频繁，请稍后再试")
            return  
        end

        if self.m_nautoBtnClickTimes ~= 2 then
            self.m_nLastTouchTime = nCurTime
        end 
        
        if WaterMarginDataMgr.getInstance():getIsAuto() then
            self:stopAuto()
        else
            if self:begineGame() then
                self:startAuto()
            end
        end

    end
    self.m_pBtnAutoGame:addClickEventListener(onBegineAutoGameCallBack)       
    -- onAutoGameClicked --
    
    -- onStopAutoGameClicked --
    local onStopAutoGameCallBack = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end
        ExternalFun.playSoundEffect("sound-button.mp3")
        if WaterMarginDataMgr.getInstance():getGameHandleStatus() == WaterMarginDataMgr.eGAME_HANDLE_IDLE then 
            return
        end
        self:stopAuto()
    end
    --self.m_pBtnStopAutoGame:addTouchEventListener(onStopAutoGameCallBack)       
    -- onStopAutoGameClicked --


    -- onPopClicked --
    local onPopClicked = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end
        ExternalFun.playSoundEffect("sound-button.mp3")

        self.m_pNodeChildMenu:setVisible(true)
        self.m_pNodeChildMenu:stopAllActions()
        --self.m_pNodeChildMenu:setPositionY(400)
        local moveTo = cc.MoveTo:create(0.2, cc.p(0, 0))
        local callBack = cc.CallFunc:create(function()
            self.m_pBtnMenuPop:setVisible(false)
            self.m_pBtnMenuPush:setVisible(true)
            self.m_pPushClicked:setVisible(true)
        end)
        local seq = cc.Sequence:create(moveTo, callBack)
        self.m_pNodeChildMenu:runAction(seq)
    end
    --self.m_pBtnMenuPop:addTouchEventListener(onPopClicked)        
    -- onPopClicked --
   
    -- onPushClicked --
    self.onPushClicked = function (sender)

       local IPHONE_X = LuaUtils.isIphoneXDesignResolution()
        ExternalFun.playSoundEffect("sound-button.mp3") 
        if self.isSettingPanelShowing then
            self.settingPanel:stopAllActions()
            if IPHONE_X then
                self.settingPanel:runAction(cc.MoveTo:create(0.2, cc.p(-140, self.settingPanel:getPositionY())))
            else
                self.settingPanel:runAction(cc.MoveTo:create(0.2, cc.p(-100, self.settingPanel:getPositionY())))
            end
            self.back:getChildByName("Image_5"):runAction(cc.Sequence:create(cc.RotateTo:create(0.2, 90),cc.CallFunc:create(function()
                        self.backMenu:setVisible(not self.backMenu:isVisible())
                        self.isSettingPanelShowing = not self.isSettingPanelShowing
                    end)
                ))
        else
            self.backMenu:setVisible(not self.backMenu:isVisible())
            self.isSettingPanelShowing = not self.isSettingPanelShowing
            self.settingPanel:stopAllActions()
            if IPHONE_X then
                self.settingPanel:runAction(cc.MoveTo:create(0.2, cc.p(20, self.settingPanel:getPositionY())))
            else
                self.settingPanel:runAction(cc.MoveTo:create(0.2, cc.p(100, self.settingPanel:getPositionY())))
            end
            self.back:getChildByName("Image_5"):runAction(cc.RotateTo:create(0.2, -180))

        end
    end    
    self.back:addClickEventListener(handler(self, self.onPushClicked))
    self.backMenu:setTouchEnabled(true)
    self.backMenu:addClickEventListener(handler(self, self.onPushClicked))    
    --self.m_pPushClicked:addTouchEventListener(onPushClicked)    
    -- onPushClicked --

    -- onReturnClicked --
    local onReturnClicked = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end
        ExternalFun.playSoundEffect("sound-close.mp3")
        
--        if WaterMarginDataMgr.getInstance():getGameHandleStatus() == WaterMarginDataMgr.eGAME_HANDLE_IDLE then
--            self._scene:onQueryExitGame()
--        else
--            --有投注纪录，则需要提示
--            self:showMessageBox(self:getLocalString("MESSAGE_10"), MsgBoxPreBiz.PreDefineCallBack.CB_EXITROOM)
--        end
        self._scene:onQueryExitGame()
    end
    self.m_btn_close:addTouchEventListener(onReturnClicked)       
    -- onReturnClicked --

    -- onSoundClicked --
    local onSoundClicked = function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end

        if (GlobalUserItem.bSoundAble)then -- 音效开着
            self.isMusicEffictOn = false
            ExternalFun.playSoundEffect("sound-button.mp3")
            GlobalUserItem.setSoundAble(false)
            self.m_pBtnSound:loadTextureNormal("game/watermargin/images/gui-water-button-shengyin-2.png",ccui.TextureResType.plistType)
        else
            self.isMusicEffictOn = true
            GlobalUserItem.setSoundAble(true)
            ExternalFun.playSoundEffect("sound-button.mp3")
            self.m_pBtnSound:loadTextureNormal("game/watermargin/images/gui-water-button-shengyin-1.png",ccui.TextureResType.plistType)
        end
    end
    

    --self.m_pBtnSound:addTouchEventListener(onSoundClicked)
    -- onSoundClicked --
    local onSettingClicked = function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end
        ExternalFun.playSoundEffect("sound-button.mp3")
        self.SettingLayer = SettingLayer:create()
        self.SettingLayer:addTo(self, WaterMarginDataMgr.Order_Result+100)
--self:addChild(self.SettingLayer)
--	    self:onBtnMenu() 
        self.onPushClicked() 
    end
    self.setting:addTouchEventListener(onSettingClicked)
    -- onMusicClicked --
    local onMusicClicked = function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end

        if (GlobalUserItem.bVoiceAble)then -- 音乐开着 
            ExternalFun.playSoundEffect("sound-button.mp3")
            self.isMusicOn = false
            GlobalUserItem.setVoiceAble(false)
            self.m_pBtnVoice:loadTextureNormal("game/watermargin/images/gui-water-button-yingyue-2.png",ccui.TextureResType.plistType)
        else
            GlobalUserItem.setVoiceAble(true)
            self.isMusicOn = true
            ExternalFun.playBackgroudAudio("sound_water_bg.mp3")
            self.m_pBtnVoice:loadTextureNormal("game/watermargin/images/gui-water-button-yingyue-1.png",ccui.TextureResType.plistType)
        end
    end
   -- self.m_pBtnVoice:addTouchEventListener(onMusicClicked)        
    -- onMusicClicked --

    -- onChooseAutoCountClicked --
    for i=1,3 do
        local onChooseAutoCountClicked = function (sender,eventType)
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
            ExternalFun.playSoundEffect("sound-water-bt-click.mp3")
            local tag = sender:getTag()
            print("tag:"..tag)
            self.m_nCurrentAutoCount = AUTO_COUNT[tag]
            self.m_bLongPress = false
            self.m_pNodeChooseAuto:setVisible(false)
            if self:begineGame() then
                self:startAuto()
            end
        end
        --self.m_pBtnAutoCount[i]:addTouchEventListener(onChooseAutoCountClicked) 
    end
    -- onChooseAutoCountClicked --

    -- onChooseAutoCloseClicked --
    local onChooseAutoCloseClicked = function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end
        self.m_bLongPress = false
        self.m_pNodeChooseAuto:setVisible(false)  
    end
    --self.m_pBtnChooseAutoClose:addTouchEventListener(onChooseAutoCloseClicked) 
    -- onChooseAutoCountClicked --

    --------------------------------------
    ---测试小玛丽秘籍
    self.m_pTestMary = self:getChildByUIName(self.m_pUI, "m_pTestMary") 
    --self.m_pTestMary:setVisible(false)

    local onTestMary = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end
           WaterMarginDataMgr.getInstance():setTestEnableLittleMary(true)
           self:testMaryFunc()
           self.m_pTestMary:setVisible(false)
    end
    --self.m_pTestMary:addTouchEventListener(onTestMary)    
    --------------------------------------
end
function GameViewLayer:onNodeLoaded()

    --self.m_pBtnMenuPush:setVisible(false)
    --self.m_pNodeChildMenu:setVisible(true)
    --self.m_pBtnStopAutoGame:setVisible(false)

    --self:initClippingMenu()
    self:initPlayerInfo()
    self:createClipersArea()
    self:initIconAtCliperNode()
    self:setAllLinesVisible(false)

    self:playClickDrumEffect()
    self:playShakeFlagEffect(false)

    self:tryFixIphoneX()
end
function GameViewLayer:onLongPressCallBack()
    self.m_bLongPress = true
    if self.m_onLongPressCallBack ~= nil then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_onLongPressCallBack)
    end
    ExternalFun.playSoundEffect("sound-water-bt-click.mp3")
    if WaterMarginDataMgr.getInstance():getGameHandleStatus() ~= WaterMarginDataMgr.eGAME_HANDLE_IDLE then
        return
    end
    self.m_bLongPress = false
    if self.m_onLongPressCallBack ~= nil then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_onLongPressCallBack)
    end
    self.m_nCurrentAutoCount = -1
    if self:begineGame(true) then
        self:startAuto()
    end
end

function GameViewLayer:initClippingMenu()------------------------------1
--[[
    local shap = cc.DrawNode:create()
    local point = {cc.p(1045,300), cc.p(1290, 300), cc.p(1290, 660), cc.p(1045, 660)}
    shap:drawPolygon(point, 4, cc.c4b(255, 255, 255, 255), 2, cc.c4b(255, 255, 255, 255))
    self.m_pClippingMenu = cc.ClippingNode:create(shap)
    self.m_pClippingMenu:setPosition(cc.p(0,0))
    self.m_pUI:addChild(self.m_pClippingMenu)
    self.m_pNodeChildMenu:removeFromParent()
    self.m_pClippingMenu:addChild(self.m_pNodeChildMenu)
    --]]
end
--初始化自己信息
function GameViewLayer:initPlayerInfo()-------------------------------2
--[[
    if (self.m_pLbUserName) then
        local str_name = GlobalUserItem.tabAccountInfo.nickname
        self.m_pLbUserName:setString(str_name)
    end
    --]]
--    self:onMsgGoldChange()
    self:onMsgUpdateBetData(nil)
--    self:initSubMenuBtState()
end
function GameViewLayer:createClipersArea()----------------------------------3

    for i=1,tonumber(WATER_ICON_COL),1 do 
    
        --绘制裁剪区域
        local shap = cc.DrawNode:create()
        local point = {cc.p(0,0), cc.p(200, 0), cc.p(200, 480), cc.p(0, 480)}
        shap:drawPolygon(point, 4, cc.c4b(255, 255, 255, 255), 2, cc.c4b(255, 255, 255, 255))
        local posx = { 144, 347+12, 566+4, 781, 1004-9}
        self.m_cliperArea[i] = cc.ClippingNode:create()
        self.m_cliperArea[i]:setStencil(shap)
        self.m_cliperArea[i]:setAnchorPoint(cc.p(0,0))
        self.m_cliperArea[i]:setPosition(cc.p(posx[i], 145.0+7))
        self.m_pNodeCenter:addChild(self.m_cliperArea[i],80)
        
        self.m_cliperNode[i] = cc.Node:create()
        self.m_cliperNode[i]:setAnchorPoint(cc.p(0,0))
        self.m_cliperNode[i]:setPosition(cc.p(0.0, 0.0))
        self.m_cliperNode[i]:setTag(i-1)
        self.m_cliperArea[i]:addChild(self.m_cliperNode[i])
    end

    --构建遮罩，利用滑动裁剪区域的方式来制造线条动画效果
    local nodeLine = self:getChildByUIName(self.m_pUI, "panel_panelLine")
    self.m_pAniShap = cc.DrawNode:create()
    --local vecPoint = {cc.p(85, 120), cc.p(1250, 130), cc.p(1250, 620), cc.p(85, 620)}
    local vecPoint = {cc.p(85, 10), cc.p(1250, 10), cc.p(1250, 620), cc.p(85, 620)}
    self.m_pAniShap:drawPolygon(vecPoint, 4, cc.c4f(255, 255, 255, 255), 2, cc.c4f(255, 255, 255, 255))
    self.m_pCliper = cc.ClippingNode:create(self.m_pAniShap)
    self.m_pCliper:setAnchorPoint(cc.p(0,0))
    self.m_pCliper:setPosition(cc.p(0, 0))
    --self.m_pNodeEffect:addChild(self.m_pCliper, G_CONSTANTS.Z_ORDER_COMMON)
    nodeLine:addChild(self.m_pCliper, 50)

    --移动9条中奖线至剪切区域
    for i = 1, WATER_MAX_LINE_NUM do
        self.m_pSpLine[i]:removeFromParent()
        self.m_pSpLine[i]:addTo(self.m_pCliper)
    end
end
--初始化小格
function GameViewLayer:initIconAtCliperNode()---------------------------------------------4

    local gameResultLast = WaterMarginDataMgr.getInstance():getGameResultLast()
    for i=1,tonumber(WATER_ICON_ROW),1 do 
        for j=1,tonumber(WATER_ICON_COL),1 do
            local iconIdex = gameResultLast.result_icons[i][j]
            local strIconFile = string.format("game/watermargin/images/gui-water-icon-%d.png", iconIdex)
            local icon = cc.Sprite:createWithSpriteFrameName(strIconFile)
            icon:setAnchorPoint(cc.p(0,0))
            icon:setPosition(cc.p(0, (WATER_ICON_ROW - 1 - (i-1) ) * self.m_nPerShowCellHeight))
            self.m_cliperNode[j]:addChild(icon)
            --[[
            local dikuang = cc.Sprite:createWithSpriteFrameName("game/watermargin/images/icondakuang.png")
            dikuang:setAnchorPoint(cc.p(0,0))
            dikuang:setPosition(cc.p(-2, (WATER_ICON_ROW - 1 - (i-1) ) * self.m_nPerShowCellHeight-4))
            self.m_cliperNode[j]:addChild(dikuang)
            --]]
        end
    end
end
function GameViewLayer:setAllLinesVisible(bVisble)--------------------------------------5

    for i=1,tonumber(WATER_MAX_LINE_NUM),1 do 
        self.m_pSpLine[i]:setVisible(bVisble)
    end
    
    if(bVisble==false)then
        self.m_pNodeEffectLine:stopAllActions()
        self.m_pNodeEffectLine:removeAllChildren()
    end
end
function GameViewLayer:playClickDrumEffect()------------------------------------------------6

    if(self.m_pNodeEffectLow == nil)then
        return
    end
    
    local winSize = cc.Director:getInstance():getWinSize()
    local showPos = cc.p(1097,668)
    Effect.getInstance():creatEffectWithDelegate2(self.m_pNodeEffectLow, "dagu_shuihuzhuan", "Animation1", true, showPos)
end
function GameViewLayer:playShakeFlagEffect(isRoll)-----------------------------------------2--------------------------上边---7

    if(self.m_pNodeEffectLow == nil)then
        return
    end
    
    if(self.pShakeFlagEffect)then
        self.pShakeFlagEffect:removeFromParentAndCleanup(true)
        self.pShakeFlagEffect = nil
    end
    
    if(self.pShakeFlagEffect == nil)then
        local winSize = cc.Director:getInstance():getWinSize()
        local showPos = cc.p(241,662)
        local strArmName = "";
        if isRoll then
             strArmName = "Animation2"
        else
             strArmName = "Animation1"
        end

        self.pShakeFlagEffect = Effect.getInstance():creatEffectWithDelegate2(self.m_pNodeEffectLow, "yaoqizi_shuihuzhuang",strArmName, true, showPos);
    end
end
function GameViewLayer:tryFixIphoneX()------------------------------------------------8
    if LuaUtils.isIphoneXDesignResolution() then
    --[[
        self.m_pBtnMenuPop:setPositionX(self.m_pBtnMenuPop:getPositionX() + 80)
        self.m_pBtnMenuPush:setPositionX(self.m_pBtnMenuPush:getPositionX() + 80)
        self.m_pClippingMenu:setPositionX(self.m_pClippingMenu:getPositionX() + 80)
        self.m_btn_close:setPositionX(self.m_btn_close:getPositionX() - 80)
        --]]
          self.panelBet:setPositionX( display.width/2-145)
   self.panelFront:setPositionX( display.width/2-145)  
   self.panelFront_0:setPositionX( display.width/2-145)
    end
end
function GameViewLayer:initSpine()----------------骨骼动画 放开会崩
    --[[
    local armature1 = sp.SkeletonAnimation:create("game/watermargin/effect/shuihuzhuan4_beijing/shuihuzhuan4_beijing.json", 
        "game/watermargin/effect/shuihuzhuan4_beijing/shuihuzhuan4_beijing.atlas",1)
    armature1:setPosition(812,375)
    armature1:setAnimation(0, "animation1", true)
    self.CCSpriteMainBg:addChild(armature1)


    local armature2 = sp.SkeletonAnimation:create("game/watermargin/effect/shuihuzhuan4_beijing/shuihuzhuan4_beijing.json", 
        "game/watermargin/effect/shuihuzhuan4_beijing/shuihuzhuan4_beijing.atlas",1)
    armature2:setPosition(812,375)
    armature2:setAnimation(0, "animation2", true)
    self.CCSpriteMainBg:addChild(armature2)
    --]]
--     local armature2 = sp.SkeletonAnimation:create("game/watermargin/effect/shuihuzhuan4_dashasifang/shuihuzhuan4_dashasifang.json", 
--         "game/watermargin/effect/shuihuzhuan4_dashasifang/shuihuzhuan4_dashasifang.atlas",1)
--     armature2:setPosition(667,375)
--     armature2:setAnimation(0, "animation", true)
--     self.m_pNodeEffect:addChild(armature2)
end
function GameViewLayer:initOther()

----    ExternalFun.playSoundEffect:stopMusic()
----    ExternalFun.playSoundEffect:playMusic("sound_water_bg.mp3")
--游戏结果
    self.m_onMsgGetGameResult = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_UPDATE_WATER_SCENE1_RESULT, handler(self, self.onMsgGetGameResult), self.__cname)--

--    self.m_onMsgUpdateBetData = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_WATER_MARGIN_UPDATE_BET_INFO, handler(self, self.onMsgUpdateBetData), self.__cname)--

    self.m_onMsgGameEnd = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_UPDATE_WATER_GAME_END, handler(self, self.onMsgGameEnd), self.__cname)--

--    self.m_onMsgGoldChangePublic = SLFacade:addCustomEventListener(Public_Events.MSG_UPDATE_USER_SCORE, handler(self, self.onMsgGoldChange), self.__cname)--

--    self.m_onMsgEnterBg         = SLFacade:addCustomEventListener(Public_Events.MSG_GAME_ENTER_BACKGROUND, handler(self, self.event_EnterBackGroud))    --退到后台 


    self.m_onMsgStopAutoInCompareView = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_STOP_WATER_SCENE1_AUTO, handler(self, self.onMsgStopAutoInCompareView), self.__cname)--

    self.m_onMsgGoldChangeOfOtherView = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_UPDATE_USER_SCORE_OTHER_VIEW, handler(self, self.onMsgGoldChangeOfOtherView), self.__cname)--

    self.m_onMsgInstantFinish = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_INSTANT_FINISH_SCENE1, handler(self, self.onMsgInstantFinish), self.__cname)--

    self.m_onMsgPauseBgMusic = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_PAUSE_SCENE1_MUSIC, handler(self, self.onMsgPauseBgMusic), self.__cname)--

    self.m_onMsgResumeBgMusic = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_RESUME_SCENE1_MUSIC, handler(self, self.onMsgResumeBgMusic), self.__cname)--

    self.m_onMsgInitGame = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_WATER_INIT_GAME, handler(self, self.onMsgInitGame), self.__cname)--

    self.m_onMsgEnterCompare = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_ENTER_COMPARE, handler(self, self.enterCompareGame), self.__cname)
    --监听小玛丽事件
--    self.m_onMsgEnterLittleMary = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_ENTER_LITTLEMARY, handler(self, self.enterLittleMaryGame), self.__cname)

--    self.m_onMsgShowChargeLayer = SLFacade:addCustomEventListener(Public_Events.MSG_SHOW_SHOP, handler(self, self.showChargeLayer), self.__cname) --"弹出充值"

--    SLFacade:addCustomEventListener(Public_Events.MSG_GAME_EXIT, handler(self, self.event_ExitGame), self.__cname)    --退出
--    SLFacade:addCustomEventListener(Public_Events.MSG_NETWORK_FAILURE, handler(self, self.event_NetFailure), self.__cname)    --返回大厅
end
function GameViewLayer:onMsgGameEnd()

    if WaterMarginDataMgr.getInstance():getIsAuto() and WaterMarginDataMgr.getInstance():getGameHandleStatus() == WaterMarginDataMgr.eGAME_HANDLE_IDLE then
        self:begineGame()
    end
end
function GameViewLayer:begineGame(islongPress)

    print("begineGame")
    --刷新自己金币
    local curScore = WaterMarginDataMgr.getInstance():getUserIntoMoney() --PlayerInfo.getInstance():getUserScore()
    self.m_pLbUsrGold:stopAllActions()
    print("_________我剩的钱是____________3____________"..curScore)
    self.m_pLbUsrGold:setString(self:getFormatGold(curScore))
    _isShowWinTouch = false
    local isSendSuc = true
    local nCurrentBetMoney = WaterMarginDataMgr.getInstance():getCurTotalBetNum()
    if curScore < nCurrentBetMoney then
        isSendSuc = false
        --金钱不够
--        if not islongPress then
--            self:showMessageBox(LuaUtils.getLocalString("STRING_050"), MsgBoxPreBiz.PreDefineCallBack.CB_RECHARGE)
--        end
        FloatMessage:getInstance():pushMessage("金币不足")
        self:stopAuto()
        self:updateButtonByStatus()
        self:updateStartBtState()
    else
        if not self.m_bSendStart then
--            local currentMulti = WaterMarginDataMgr.getInstance():getBaseBetChangeMul()
--            CMsgWaterMargin.getInstance():sendMsgGameStart(currentMulti)
            self._scene:sendStart()
            self.m_bSendStart = true
        end
    end
    return isSendSuc
end
function GameViewLayer:stopAuto()
    print("取消自动")
    WaterMarginDataMgr.getInstance():setIsAuto(false)
    self.m_pAutoLight:setVisible(false)
    --self.m_pBtnStopAutoGame:setVisible(false)
end
function GameViewLayer:startAuto()
    print("自动模式")
    WaterMarginDataMgr.getInstance():setIsAuto(true)
    self.m_pAutoLight:setVisible(true)
    --self.m_pBtnStopAutoGame:setVisible(true)
end
function GameViewLayer:instantPlayResultEffect()

    for i=1,tonumber(WATER_ICON_COL),1 do 
        self.m_cliperNode[i]:stopAllActions()
        self.m_cliperNode[i]:setPosition(cc.p(0.0, -self.m_nPerShowCellHeight*(WATER_MAX_ROW_ICON_NUM-3)))
    end
    self.m_bIsQuicklyJieSuan = true
    self:showALlLineOfWin()
end
function GameViewLayer:onMsgStopAutoInCompareView()
    self:stopAuto()
end
function GameViewLayer:onMsgGoldChangeOfOtherView()

    self.m_pUI:setVisible(true)
    if(self.m_bLittleEndAuto)then
    
        self.m_bLittleEndAuto = false
        self:startAuto()
    end
    print("..........................................................1")
    self.isIntoCompare = true
    self:playUpdateGoldEffect()
    --设置中奖喇叭显示位置
    --GameRollMsg.getInstance():setShowPosition(display.cx,display.height-35)
end

function GameViewLayer:playUpdateGoldEffect()-----------------------------------------有问题

    self.isUpdateShowGold = true
    local lastUserScore = WaterMarginDataMgr.getInstance():getGameResultLast().llResultMoney
    local curUserScore = WaterMarginDataMgr.getInstance():getGameResult().llResultMoney
    if(lastUserScore == curUserScore) then
        return
    end
    local result = WaterMarginDataMgr.getInstance():getGameResult()
    local subScore = WaterMarginDataMgr.getInstance():getGameResult().llResultScore      --这个实际是本轮赢得的钱数
    --比倍的分数
    local compareScene2Gold = self.m_DiceMoney--WaterMarginDataMgr.getInstance():getGameCompareAwardGold() - (curUserScore - WaterMarginDataMgr.getInstance():getCurTotalBetNum())    --获得比倍结算后的钱(增加的钱)
    if self.isIntoCompare ~= nil and self.isIntoCompare == true then
        self.isIntoCompare = false
        subScore = 0
    end
    if compareScene2Gold and compareScene2Gold > 0 then
--        PlayerInfo.getInstance():setUserScore(curUserScore)
        subScore = compareScene2Gold
    end
    
    --是否进过小玛丽
    local littleMarrySceneGold = WaterMarginDataMgr.getInstance():getTotalAwardGold()
    if littleMarrySceneGold > 0 then
        lastUserScore = curUserScore - littleMarrySceneGold
        PlayerInfo.getInstance():setUserScore(curUserScore)
        subScore = littleMarrySceneGold
    end
    
    --飘数字
    if subScore > 0 and not WaterMarginDataMgr.getInstance():getIsAuto() then
--        self:showScoreChangeEffect2(self.m_pLbUsrGold, lastUserScore, subScore, curUserScore)


        local filePath = "game/watermargin/font/shz_sz4.fnt"
        self:flyNumOfGoldChange2(filePath, self:getFormatGold(subScore),cc.p(160, 50))

        local partical =  cc.ParticleSystemQuad:create("game/watermargin/particle/jinbijindai.plist")
        partical:setPosition(cc.p(156.0, 20.0))
        partical:addTo(self.m_pUI)
    else
--        PlayerInfo.getInstance():setUserScore(curUserScore)
--        local curScore = PlayerInfo.getInstance():getUserScore()
--        local strUsrBanlance = self:getFormatGold(curScore)
--        self.m_pLbUsrGold:setString(strUsrBanlance)
    end

    
    local mMoney_ = WaterMarginDataMgr.getInstance():getUserIntoMoney()
    print("_________我剩的钱是____________1____________"..mMoney_)
    self.m_pLbUsrGold:setString( mMoney_ )
end

function GameViewLayer:flyNumOfGoldChange2( filepath, iOffset, benginePos)
    
    local pSprResult = cc.LabelBMFont:create("+"..iOffset,filepath)
    pSprResult:setPosition(benginePos)
    pSprResult:setScale(0.5)
    pSprResult:addTo(self.m_pUI, 1)
    
    local move = cc.MoveBy:create(0.2, cc.p(0.0,50.0))
    local pFadein = cc.FadeIn:create(0.2)
    local pDelay = cc.DelayTime:create(2)
    local pFadeout = cc.FadeOut:create(0.8)

    local callBack = cc.CallFunc:create(function ()
        pSprResult:removeFromParent()
    end)

    local pSeq = cc.Sequence:create(cc.Spawn:create(pFadein,move),pDelay,pFadeout,callBack)
    pSprResult:runAction(pSeq)   
end

function GameViewLayer:onMsgInstantFinish()

    self.m_pNodeEffect:stopAllActions()
    self:stopGame()
end
function GameViewLayer:onMsgResumeBgMusic()
    --待定
--    AudioManager.getInstance():resumeMusic()
end
function GameViewLayer:onMsgInitGame()
    self:onMsgUpdateBetData(nil)
end
--加注
function GameViewLayer:onMsgUpdateBetData(userdata)

    local nBaseBetGlod = WaterMarginDataMgr.getInstance():getBaseBetNum()       --基础押注
    local nChangeBetMoney =  WaterMarginDataMgr.getInstance():getBaseBetChangeMul()     --倍数
    local nCurrentBetMoney = WaterMarginDataMgr.getInstance():getCurTotalBetNum()       --总押注
    
    self.m_pLbTotalCostGold:setString(self:getFormatGold(nCurrentBetMoney))             --总的押注
    self.m_pLbCurCostGold:setString(self:getFormatGold(nBaseBetGlod * nChangeBetMoney)) --单注
    self.m_pLbyaxian:setString("9")                                                     --写死九条线
    -- 创建头像
    local head = HeadSprite:createClipHead(GlobalUserItem.tabAccountInfo, 76)
    if nil ~= head then
        --head:setPosition(ccp(self.m_pSpHeadImage:getPositionX()-1,self.m_pSpHeadImage:getPositionY()-1))
        head:setAnchorPoint(cc.p(0,0))
        self.m_pHeadImg:addChild(head)
    end
--    self.m_pBtnAddChip:setEnabled(nChangeBetMoney~=5)
--    self.m_pBtnSubChip:setEnabled(nChangeBetMoney~=1)
end
--进入比倍界面
function GameViewLayer:enterCompareGame()
    
    if self:getChildByName("WaterMarginCompareView") then 
        self:getChildByName("WaterMarginCompareView"):removeFromParent()
    end
    local m_WaterMarginCompareView = WaterMarginCompareView:create(self._scene,self.m_winMoney)
    m_WaterMarginCompareView:setName("WaterMarginCompareView")
    self:addChild(m_WaterMarginCompareView, WaterMarginDataMgr.Order_Compare)
    self.m_pUI:setVisible(false)
    --设置中奖喇叭显示位置
    --GameRollMsg.getInstance():setShowPosition(display.cx,display.height-35)
end
function GameViewLayer:onMsgPauseBgMusic()
    --待定
--    AudioManager.getInstance():pauseMusic()
end
--进入小玛丽
function GameViewLayer:enterLittleMaryGame()

    self.m_bHaveEnterLittleMary = true
    self.m_bLittleEndAuto = WaterMarginDataMgr.getInstance():getIsAuto()
    --跳转小玛丽
    if self:getChildByName("LittleMaryLayer") then 
        self:getChildByName("LittleMaryLayer"):removeFromParent()
    end
    local m_LittleMaryLayer = LittleMaryLayer:create()
    m_LittleMaryLayer:setName("LittleMaryLayer")
    m_LittleMaryLayer:addTo(self, WaterMarginDataMgr.Order_LittleMary)

    self:enterLittleMaryWait()
    self.m_pUI:setVisible(false)
end
--小玛丽等待界面
function GameViewLayer:enterLittleMaryWait()

    if self:getChildByName("LittleMaryWaitLayer") then 
        self:getChildByName("LittleMaryWaitLayer"):removeFromParent()
    end
    local m_LittleMaryWaitLayer = LittleMaryWaitLayer:create()
    m_LittleMaryWaitLayer:setName("LittleMaryWaitLayer")
    self:addChild(m_LittleMaryWaitLayer, WaterMarginDataMgr.Order_LittleMaryWait)
end
function GameViewLayer:onEventStart(bufferData)
    self.m_winMoney = bufferData[5]     --赢得金额
    WaterMarginDataMgr.getInstance():setGameCompareBet( bufferData[5] )
    self:updateWinScore("onEventStart")
end
function GameViewLayer:onEventEnter(bufferData)
    self.m_enterIntoMoney = bufferData.members[1][6]
    WaterMarginDataMgr.getInstance():setBaseBetNum(bufferData.unit_money)
    WaterMarginDataMgr.getInstance():setUserIntoMoney( bufferData.members[1][6] )
    self.m_pLbUsrGold:setString(bufferData.members[1][6])
    self:onMsgUpdateBetData(nil)

end
function GameViewLayer:onEventDice(bufferData)
    self.m_DiceMoney = bufferData
end
function GameViewLayer:onMsgGetGameResult()
    print("开始开奖")
    WaterMarginDataMgr.getInstance():setGameHandleStatus(WaterMarginDataMgr.eGAME_HANDLE_OPEN)--进入开奖状态
    self.m_bSendStart = false
    self.m_bIsQuicklyJieSuan = false
    self.m_bHaveEnterLittleMary = false
    self.m_bIsShowLineViewAnimo = true
    --取消长按自动效果
    if self.m_onLongPressCallBack ~= nil then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_onLongPressCallBack)
    end
    --隐藏在播放的动画
    for k,v in pairs(self.m_vecPlayIconEffect) do
        if v ~= nil then 
            v:removeFromParent()
        end
    end
    self.m_vecPlayIconEffect ={}
    self.m_pKuangEffectNode:removeAllChildren()
    self.isShowAreaEffectEnd = {}
    self:resetCliperNodeIcon()--------------------------1
    self:playShakeFlagEffect(true)-----------------------------------------2
    self:playCellMoveEffect()--------------------------------------3
    self:updateButtonByStatus()--------------------------4
    self:updateStartBtState()-----------------------------5

    --开始成功扣除消耗金币
    self.isUpdateShowGold = true;
    local nCurrentBetMoney = WaterMarginDataMgr.getInstance():getCurTotalBetNum()

    local lastUserScore = WaterMarginDataMgr.getInstance():getGameResultLast().llResultMoney
    if lastUserScore <= 0 then
        lastUserScore = self.m_enterIntoMoney
    end
    local curScore = lastUserScore - nCurrentBetMoney
--    PlayerInfo.getInstance():setUserScore(curScore)
    self.m_pLbUsrGold:stopAllActions()
    print("_________我剩的钱是____________2____________"..curScore)
    self.m_pLbUsrGold:setString(self:getFormatGold(curScore))

    --自动次数刷新
    if self.m_nCurrentAutoCount > 0 then 
        self.m_nCurrentAutoCount = self.m_nCurrentAutoCount -1
        self.m_pLbCurrentAuto:setString(tostring(self.m_nCurrentAutoCount))
    end

--    self.m_nStartGameBtSoundId = ExternalFun.playSoundEffect("sound_water_bt_start.mp3")
end
--格式化金钱显示
function GameViewLayer:getFormatGold(goldNo)
    local gold = tonumber(goldNo) or 0
    local strFormatGold = string.format("%d.%02d", (gold/100), (math.abs(gold)%100))
    if -100 < gold and gold < 0 then
        strFormatGold = "-" .. strFormatGold
    end
    return goldNo--strFormatGold
end
function GameViewLayer:resetCliperNodeIcon()--------------------------1

    for i=1,tonumber(WATER_ICON_COL),1 do --    WATER_ICON_COL = 5 列
        self.m_cliperNode[i]:removeAllChildren()
        self.m_cliperNode[i]:setPosition(0.0, 0.0)
    end

    --old icon
    local gameResultLast = WaterMarginDataMgr.getInstance():getGameResultLast()
    for i=1,tonumber(WATER_ICON_ROW),1 do   -- WATER_ICON_ROW = 3  行
        for j=1,tonumber(WATER_ICON_COL),1 do 
            local tempCardIndex = gameResultLast.result_icons[i][j]

            local iconIndex = 0
            if tempCardIndex >= 0 then
                iconIndex = tempCardIndex
            else
                iconIndex = WaterMarginDataMgr.getInstance():getRandomIconIndex()
            end

            -- local bg = cc.Sprite:createWithSpriteFrameName("game/watermargin/images/gui-water-icon-solid-bg.png")
            -- bg:setAnchorPoint(cc.p(0,0))
            -- bg:setPosition(cc.p(0.0, (WATER_ICON_ROW-1-(i-1))*self.m_nPerShowCellHeight-13.0))
            -- self.m_cliperNode[j]:addChild(bg)
            
            local strIconFile = string.format("game/watermargin/images/gui-water-icon-%d.png", iconIndex)
            local icon = cc.Sprite:createWithSpriteFrameName(strIconFile)
            icon:setScale(0.945)
            icon:setAnchorPoint(cc.p(0,0))
            icon:setPosition(cc.p(0.0, (WATER_ICON_ROW-1-(i-1))*self.m_nPerShowCellHeight))
            self.m_cliperNode[j]:addChild(icon)
            --[[
            local dikuang = cc.Sprite:createWithSpriteFrameName("game/watermargin/images/icondakuang.png")
            dikuang:setAnchorPoint(cc.p(0,0))
            dikuang:setPosition(cc.p(-2, (WATER_ICON_ROW-1-(i-1))*self.m_nPerShowCellHeight-4))
            self.m_cliperNode[j]:addChild(dikuang)
            --]]
        end
    end


    --temp icon
    for i=WATER_ICON_ROW,tonumber(WATER_MAX_ROW_ICON_NUM - WATER_ICON_ROW),1 do 
         for j=1,tonumber(WATER_ICON_COL),1 do 
            -- local bg = cc.Sprite:createWithSpriteFrameName("game/watermargin/images/gui-water-icon-solid-bg.png")
            -- bg:setAnchorPoint(cc.p(0,0))
            -- bg:setPosition(cc.p(0.0, (i-1)*self.m_nPerShowCellHeight-33.0))
            -- self.m_cliperNode[j]:addChild(bg)
            
            local strIconFile = string.format("game/watermargin/images/gui-water-icon-mix-%d.png",WaterMarginDataMgr.getInstance():getRandomIconIndex())
            local icon = cc.Sprite:createWithSpriteFrameName(strIconFile)
            icon:setAnchorPoint(cc.p(0,0))
            icon:setScale(0.945)
            icon:setPosition(cc.p(0.0, (i-1)*self.m_nPerShowCellHeight))
            self.m_cliperNode[j]:addChild(icon)
         end
    end

    --new icon
    local gameResult = WaterMarginDataMgr.getInstance():getGameResult()
    for i=1,tonumber(WATER_ICON_ROW),1 do 
        for j=1,tonumber(WATER_ICON_COL),1 do 
            --local bg = cc.Sprite:createWithSpriteFrameName("game/watermargin/images/gui-water-icon-solid-bg.png")
            --bg:setAnchorPoint(cc.p(0,0))
            --bg:setPosition(cc.p(0.0, (WATER_MAX_ROW_ICON_NUM-1-(i-1))*self.m_nPerShowCellHeight-13.0))
            --self.m_cliperNode[j]:addChild(bg)
            
            local iconIdex = gameResult.result_icons[i][j]
            local strIconFile = string.format("game/watermargin/images/gui-water-icon-%d.png", iconIdex)
            local icon = cc.Sprite:createWithSpriteFrameName(strIconFile)
            icon:setScale(0.945)
            icon:setAnchorPoint(cc.p(0,0))
            --"WATER_MAX_ROW_ICON_NUM-1-i"实际为:"(WATER_ICON_ROW-1)-i+(WATER_MAX_ROW_ICON_NUM-WATER_ICON_ROW)"
            icon:setPosition(cc.p(0.0, (WATER_MAX_ROW_ICON_NUM-1-(i-1))*self.m_nPerShowCellHeight))
            icon:setTag(i+1+j+1)
            self.m_cliperNode[j]:addChild(icon)
            --[[
            local dikuang = cc.Sprite:createWithSpriteFrameName("game/watermargin/images/icondakuang.png")
            dikuang:setAnchorPoint(cc.p(0,0))
            dikuang:setPosition(cc.p(-2, (WATER_MAX_ROW_ICON_NUM-1-(i-1))*self.m_nPerShowCellHeight-4))
            self.m_cliperNode[j]:addChild(dikuang)
            --]]
        end
    end

end
function GameViewLayer:playCellMoveEffect()----------------------------3
    print("轮盘转动")
    local sectionTimeFirst = {0.2, 0.2, 0.2, 0.2 , 0.2}
    local sectionTimeSecond = {0.5, 0.5, 0.5, 0.5, 0.5}
    local sectionTimeEnd = {0.5, 0.6, 0.7, 0.8 , 0.9}

    for i=1,tonumber(WATER_ICON_COL),1 do 
        self.m_cliperNode[i]:stopAllActions()
        self.m_cliperNode[i]:setPosition(0.0, 0.0)
        --local moveAct1 = cc.MoveTo:create(sectionTimeFirst[i], cc.p(0.0, -200.0));
        --local easeExpon  = cc.EaseExponentialIn:create(moveAct1);
        local moveAct2 = cc.MoveTo:create(sectionTimeSecond[i], cc.p(0.0, -self.m_nPerShowCellHeight*(WATER_MAX_ROW_ICON_NUM-3)+502))
        local moveAct3 = cc.MoveTo:create(sectionTimeEnd[i], cc.p(0.0, -self.m_nPerShowCellHeight*(WATER_MAX_ROW_ICON_NUM-3)))
        local easeAct = cc.EaseBackOut:create(moveAct3)
        if (WATER_ICON_COL-1 == (i-1))then
            local callback = cc.CallFunc:create(function ()
                self:showALlLineOfWin()
            end)
            local seq = cc.Sequence:create( moveAct2, easeAct, callback)
            self.m_cliperNode[i]:runAction(seq)
        else
            local seq = cc.Sequence:create( moveAct2, easeAct)
            self.m_cliperNode[i]:runAction(seq)
        end
    end
end

function GameViewLayer:updateButtonByStatus()-------------------------------4

    local bEnble = WaterMarginDataMgr.getInstance():getGameHandleStatus() == WaterMarginDataMgr.eGAME_HANDLE_IDLE
    if WaterMarginDataMgr.getInstance():getIsAuto() then 
        bEnble = false
    end
    --self.m_pBtnAutoGame:setEnabled(bEnble)
    self.m_pBtnAddChip:setEnabled(bEnble)
    self.m_pBtnSubChip:setEnabled(bEnble)
end


function GameViewLayer:updateStartBtState()-----------------------------------------5

    if WaterMarginDataMgr.getInstance():getIsAuto() then
        self.m_pBtnGameStart:setEnabled(false)
        self.m_pAutoLight:setVisible(true)
    else 
        self.m_pBtnGameStart:setEnabled(true)
        self.m_pAutoLight:setVisible(false)
    end

    local bEnble = WaterMarginDataMgr.getInstance():getGameHandleStatus() == WaterMarginDataMgr.eGAME_HANDLE_IDLE
    if bEnble then
        self:showStartBtnStyle("normal")
    else
        self:showStartBtnStyle("press")
    end

end

function GameViewLayer:showStartBtnStyle(v)
    local pressbgStrPath = "shuihuzhuan/image/shuihuzhuan_zhuye_tingzhi0.png"
    local normalbglStrPath = "shuihuzhuan/image/shuihuzhuan_zhuye_kaishi0.png"
    local pressTextStrPath = "shuihuzhuan/image/shuihuzhuan_zhuye_tingzhi.png"
    local normalTextlStrPath = "shuihuzhuan/image/shuihuzhuan_zhuye_kaishi.png"
    if v == "normal" then
       self.m_pBtnGSTextimg:loadTexture(normalTextlStrPath)
       self.m_pBtnGameStart:loadTextureNormal(normalbglStrPath)
    elseif v == "press" then
       self.m_pBtnGSTextimg:loadTexture(pressTextStrPath)
       self.m_pBtnGameStart:loadTextureNormal(pressbgStrPath)
    end   
end

function GameViewLayer:showALlLineOfWin()

    if _isShowWinTouch then
        return
    end
    _isShowWinTouch = true

    local gameResult = WaterMarginDataMgr.getInstance():getGameResult()
    if gameResult.llResultScore <= 0 then
        self:showResultEffect()
    else
        self:playAllWinLineEffect()
        local callback = cc.CallFunc:create(function ()
            self:hideAllLineOfWin()
        end)
        local seq = cc.Sequence:create(cc.DelayTime:create(0.35), callback)
        self:runAction(seq)
    end
    --self.m_pBtnGameStopStart:setEnabled(false)
end
function GameViewLayer:playAllWinLineEffect()

    if(self.m_pNodeEffectLine == false)then
        return
    end
    
    self:setAllLinesVisible(false)
    
    local winLineNum = WaterMarginDataMgr.getInstance():getWinResultNum()
    for i=1,tonumber(winLineNum),1 do 
        local resultInfo = WaterMarginDataMgr.getInstance():getWinResultAtIndex(i)
        self.m_pSpLine[resultInfo.nLineIndex]:setVisible(true)
        self:playPerWinLineEffect(resultInfo.nLineIndex,false)
    end
    self:showLineViewEffect()
end
function GameViewLayer:showLineViewEffect()
    --滑动裁剪区域，制造射线效果
    if not self.m_bIsShowLineViewAnimo then
        return
    end
    self.m_bIsShowLineViewAnimo = false
    local time = 0.11
    self.m_pAniShap:setPosition(-1100, 0)
    self.m_pAniShap:runAction(cc.MoveBy:create(time, cc.p(1100, 0)))
end 
function GameViewLayer:hideAllLineOfWin()

    local callback = cc.CallFunc:create(function ()
        self:showResultEffect()
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(0.2), callback)
    self:runAction(seq)

end

function GameViewLayer:showResultEffect()

    self:playShakeFlagEffect(false)
    self.m_iShowWinIndex = 1
    local gameResult = WaterMarginDataMgr.getInstance():getGameResult()
    if(gameResult.llResultScore > 0)then
        WaterMarginDataMgr.getInstance():setGameHandleStatus(WaterMarginDataMgr.eGAME_HANDLE_RESULT)
        local checkRuslt = WaterMarginDataMgr.getInstance():getWinAllType()
        if checkRuslt ~= WIN_ALL_NOT then
            -- 全屏奖
            self:showWinAllEffect(checkRuslt)
        else
            self:updateGrayLayerState(true)
            self:showWinEffect()
        end
    else
        --未中奖 
--        AudioManager.getInstance():stopSound(self.m_nStartGameBtSoundId)
--        ExternalFun.playSoundEffect("sound_water_line0.mp3")
        self:updateGrayLayerState(true)
        self:stopGame()
    end
end
--全中效果
function GameViewLayer:showWinAllEffect(iType)

    local strSoundPath = "sound_water_all_other.mp3"
    if iType == WIN_ALL_MIX_ROLE then --全屏人物
        strSoundPath = "sound_water_all_shuihu.mp3"
    end
    self.m_nFullScreenSoundId = ExternalFun.playSoundEffect(strSoundPath)
    
    local gameResult = WaterMarginDataMgr.getInstance():getGameResult()
    for i=1,tonumber(WATER_ICON_ROW),1 do 
        for j=1,tonumber(WATER_ICON_COL),1 do 
            local iconType = gameResult.result_icons[i][j]
            local pos = cc.p(commonStartX + (j-1) * differX, commonStartY - (i-1) * differY)
            if i-1 == 0 then
                pos.y  = pos.y - 10
            elseif i-1 == 2 then
                pos.y  = pos.y + 10
            end
            self:showPerIconEffect(iconType,pos,true,0)
            local tab = {row = i,col = j}
            self:showPerKuangEffect(pos,tab)
        end
    end

    local callback = cc.CallFunc:create(function ()
        self:updateGrayLayerState(false)
        self:playAllWinLineEffect()
        self:enterJieSuan()
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(2.5), callback)
    self.m_pNodeEffect:runAction(seq)
end
function GameViewLayer:updateGrayLayerState(isShow)

    local gameResult = WaterMarginDataMgr.getInstance():getGameResult()
    for i=1,tonumber(WATER_ICON_ROW),1 do 
        for j=1,tonumber(WATER_ICON_COL),1 do 
            local iconIdex = gameResult.result_icons[i][j]

            local str = ""
            if isShow then
                str = "game/watermargin/images/gui-water-icon-gray-%d.png"
            else
                str = "game/watermargin/images/gui-water-icon-%d.png"
            end
            local strIconFile = string.format(str, iconIdex)
            local pIcon = self.m_cliperNode[j]:getChildByTag(i+1+j+1)
            if(pIcon)then
                 pIcon:setSpriteFrame(strIconFile)     
            end
        end
    end

end
function GameViewLayer:showWinEffect()

    local gameResult = WaterMarginDataMgr.getInstance():getGameResult()
    if gameResult.llResultScore <= 0 then
        self:stopGame()
        return
    end
    if self.m_iShowWinIndex > WaterMarginDataMgr.getInstance():getWinResultNum() then --中奖线每条显示完成
        --再次播放所有动画
        local callback = cc.CallFunc:create(function ()
             self:repeatPlayAllLineWinEffect()
        end)
        local seq = cc.Sequence:create(cc.DelayTime:create(0.15), callback)
        self.m_pNodeEffect:runAction(seq)
        return
    end
    local resultInfo = WaterMarginDataMgr.getInstance():getWinResultAtIndex(self.m_iShowWinIndex)
    self:setPerLinesVisible(true,resultInfo.nLineIndex)
    
    --每条中奖线依次显示
    self:showWinEffectOfLineIndex()
--    ExternalFun.playSoundEffect("sound_water_line.mp3")
end
function GameViewLayer:showWinEffectOfLineIndex()

    local vecActions = {}
 
    local resultInfo = WaterMarginDataMgr.getInstance():getWinResultAtIndex(self.m_iShowWinIndex)
    for i=1,tonumber(2),1 do --//未播放单独水浒传特效
        if(#resultInfo.vecIconsIndexData[i] < 3)then
        else
            --相同行左右都中时间间隔
            local fTime = 0.5
            if #vecActions == 0 then
                fTime = 0.01
            end

            local delayTime = cc.DelayTime:create(fTime)
            table.insert(vecActions,delayTime)

            local callback = nil;
            if i == 1 then
                callback = cc.CallFunc:create(function ()
                        local temp = WaterMarginDataMgr.getInstance():getWinResultAtIndex(self.m_iShowWinIndex)
                        self:showWinLineIcons(temp.nLineIndex,temp.vecIconsIndexData[1])
                end)

            elseif i == 2 then
                callback = cc.CallFunc:create(function ()
                        local temp = WaterMarginDataMgr.getInstance():getWinResultAtIndex(self.m_iShowWinIndex)
                        self:showWinLineIcons(temp.nLineIndex,temp.vecIconsIndexData[2])
                end)

            elseif i == 3 then
                callback = cc.CallFunc:create(function ()
                        local temp = WaterMarginDataMgr.getInstance():getWinResultAtIndex(self.m_iShowWinIndex)
                        self:showWinLineIcons(temp.nLineIndex,temp.vecIconsIndexData[3])
                end)
            end


            if(callback ~= nil)then
                table.insert(vecActions,callback)
            end
        end

    end
    
    if (#vecActions <= 0)then
        return;
    end

    local delayTime = 0.45 
    if self.m_bIsQuicklyJieSuan and self.m_iShowWinIndex == WaterMarginDataMgr.getInstance():getWinResultNum() then 
        delayTime = 0.05
    end
    local delay = cc.DelayTime:create(delayTime)
    local callback = cc.CallFunc:create(function ()
        self.m_iShowWinIndex = self.m_iShowWinIndex +1
        self:showWinEffect()
    end)
    table.insert(vecActions,delay)
    table.insert(vecActions,callback)
    local seq = cc.Sequence:create(vecActions)
    self.m_pNodeEffect:runAction(seq)
end
function GameViewLayer:showWinLineIcons( nLineIndex,  vecIcons)
    for i=1,tonumber(#vecIcons),1 do 
        local info = vecIcons[i]
        local pos = cc.p(commonStartX + info.pos.y * differX, commonStartY - info.pos.x * differY-1)
        if info.pos.x == 0 then
            pos.y  = pos.y - 10
        elseif info.pos.x == 2 then
            pos.y  = pos.y + 10
        end
        --self:showPerIconEffect(info.giType,pos,false,0)
        local tab = {row = info.pos.x,col = info.pos.y}
        self:showPerKuangEffect(pos,tab)
    end
end
function GameViewLayer:showPerIconEffect( iconType,  pos,  isQueue,  animationIdx)
    local strArmName = ""
    if GI_FUTOU == iconType then --// 斧头
        strArmName = "hutou_shuihuzhuan"
    elseif GI_YINGQIANG == iconType then --// 银枪
        strArmName = "yingqiang_shuihuzhuan"
    elseif GI_DADAO == iconType then --//  大刀
        strArmName = "dadao_shuihuzhuan"
    elseif GI_LU == iconType then --//  鲁智深
        strArmName = "lu_shuihuzhuan"
    elseif GI_LIN == iconType then --//   林冲
        strArmName = "lin_shuihuzhuan"
    elseif GI_SONG == iconType then --//    宋江
        strArmName = "songjiang_shuihuzhuan"
    elseif GI_TITIANXINGDAO == iconType then --//   替天行道
        strArmName = "titianxingdao_shuihuzhuan"
    elseif GI_ZHONGYITANG == iconType then --//  忠义堂
        strArmName = "zhongyitang_shuihuzhuan"
    elseif GI_SHUIHUZHUAN == iconType then --//  水浒传
        strArmName = "shuihuzhuan_shuihuzhuan"
    end

    if (strArmName ~= "")then
        local armature = ccs.Armature:create(strArmName)--= Effect.getInstance():creatEffectWithDelegate(self.m_pNodeEffect, strArmName, animationIdx, true, pos)
        armature:setPosition(pos)
	    armature:addTo(self.m_pNodeEffect)
	    armature:getAnimation():playWithIndex(animationIdx)
        if(armature)then
            armature:setScale(1.15)
            armature:setName(strArmName)
            table.insert(self.m_vecPlayIconEffect,armature)
            if(isQueue)then

               local animationEvent = function (armatureBack,movementType,movementID)
                    if movementType == ccs.MovementEventType.complete then

                        self:playPerIconNextEffect(armatureBack,movementType,armatureBack:getName(),pos)
                        if animationIdx == 0 then
                            armature:setVisible(false)
                        end
                    end
               end
               armature:getAnimation():setMovementEventCallFunc(animationEvent)
            else
                local animationEvent = function (armatureBack,movementType,movementID)
                    if animationIdx == 0 then
                        armature:setVisible(false)
                    end
                end
               armature:getAnimation():setMovementEventCallFunc(animationEvent)
            end
        end
    end
end
function GameViewLayer:playPerIconNextEffect(armature , _type ,  name , pos)

    local strName = armature:getName()
    armature:removeFromParent()
--    local m_pArmature = Effect.getInstance():creatEffectWithDelegate(self.m_pNodeEffect, strName, 1, true, pos)
    local m_pArmature = ccs.Armature:create(strName)
    m_pArmature:setPosition(pos)
	m_pArmature:addTo(self.m_pNodeEffect)
	m_pArmature:getAnimation():playWithIndex(0)
    if(m_pArmature)then
        m_pArmature:setScale(1.25)
        table.insert(self.m_vecPlayIconEffect,m_pArmature) 
    end
end
function GameViewLayer:showPerKuangEffect(pos,rc)
    pos.y = pos.y - 5
    pos.x = pos.x - 2
    local r = rc.row
    local c = rc.col
    if self.isShowAreaEffectEnd[r] and self.isShowAreaEffectEnd[r][c] then return end
    if self.isShowAreaEffectEnd[r] then
        self.isShowAreaEffectEnd[r][c] = true
    else
        self.isShowAreaEffectEnd[r] = {}
        self.isShowAreaEffectEnd[r][c] = true
    end
    local armature = sp.SkeletonAnimation:create("game/watermargin/effect/shuihuzhuan4_liankuai/shuihuzhuan4_liankuai.json", 
        "game/watermargin/effect/shuihuzhuan4_liankuai/shuihuzhuan4_liankuai.atlas",1)
    armature:registerSpineEventHandler(function ()
        --armature:setVisible(false)
    end , sp.EventType.ANIMATION_COMPLETE)
    armature:setScale(1.00)
    armature:setPosition(pos)
    armature:setAnimation(0, "animation", true)
 
--[[
     local sp = cc.Sprite:create("shuihuzhuan/image/shuihuzhuan_zhuye_zidong1.png")
	 sp:setPosition(pos)
     local sequence = cc.Sequence:create(cc.DelayTime:create(0.3),cc.Hide:create(),cc.DelayTime:create(0.5),cc.Show:create(),NULL)
     local repeatForever = CCRepeatForever:create(sequence)
             sp:runAction(repeatForever)
    --]]
    self.m_pKuangEffectNode:addChild(armature)
end
function GameViewLayer:stopGame()

    print("开奖结束")
    WaterMarginDataMgr.getInstance():setGameHandleStatus(WaterMarginDataMgr.eGAME_HANDLE_IDLE)
    self:playShakeFlagEffect(false)
    self.m_bIsQuicklyJieSuan = false
--    AudioManager.getInstance():stopSound(self.m_nFullScreenSoundId)
    if self.m_nCurrentAutoCount == 0 then 
        self:stopAuto()
    end
    self:setAllLinesVisible(false)
    self:updateButtonByStatus()
    self:updateStartBtState()
    if self.m_bHaveEnterLittleMary then 
        print("..........................................................2")
        self:playUpdateGoldEffect()
    else
        self:playFlyScoreEffect()
    end
    
--    CMsgWaterMargin.getInstance():sendMsgGameStop() -----?
    SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_UPDATE_WATER_GAME_END)   
end
--更新赢分
function GameViewLayer:updateWinScore(name)
    if nil == self.m_pLbyyingfen then
       return
    end
    local result = WaterMarginDataMgr.getInstance():getGameResult()
    if result.llResultScore <= 0 then 
        return
    end
    if name == "stopGame" then
        local var = self:getFormatGold(result.llResultScore)
        self.m_pLbyyingfen:setString(var)
    else
        self.m_pLbyyingfen:setString(0)
    end

end

function GameViewLayer:playFlyScoreEffect()

    local result = WaterMarginDataMgr.getInstance():getGameResult()
    if result.llResultScore <= 0 then 
        return
    end
    --飞数字

    local diffX = 145 - (1624-display.size.width)/2
    local pSpResult = cc.LabelBMFont:create("+"..self:getFormatGold(result.llResultScore),"game/watermargin/font/shz_sz4.fnt")
    local WinMulti = WaterMarginDataMgr.getInstance():getWinMulti()
    local checkRuslt = WaterMarginDataMgr.getInstance():getWinAllType()
    if WinMulti>= 100 or checkRuslt ~= WIN_ALL_NOT then --大于等于500或者全屏
        pSpResult:setPosition(cc.p(667+(display.size.width-1334)/2,292))
    else
        pSpResult:setPosition(cc.p(667+(display.size.width-1334)/2,235))
    end
    
    pSpResult:addTo(self, 8)
    local delay = cc.DelayTime:create(0.2)
    local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(170+(display.size.width-1334)/2,45)))
    local scale = cc.ScaleTo:create(0.3, 0.7)
    local scale2 = cc.ScaleTo:create(0.1, 0.2)
    local callBack = cc.CallFunc:create(function ()
        pSpResult:removeFromParent()
        print("..........................................................3")
        self:playUpdateGoldEffect()
    end)
    local pSeq = cc.Sequence:create(delay,cc.Spawn:create(move,scale),scale2,callBack)
    pSpResult:runAction(pSeq)
end
function GameViewLayer:repeatPlayAllLineWinEffect()

    self:setAllLinesVisible(false)

    local isPlayingSound = false
    local vecShowList = {}
    table.insert(vecShowList,cc.p(-1,-1))
    local playEffectType = GI_COUNT
    
    for i=1,tonumber(WaterMarginDataMgr.getInstance():getWinResultNum()),1 do 
        local resultInfo = WaterMarginDataMgr.getInstance():getWinResultAtIndex(i)
        for j=1,tonumber(2),1 do 
            if(#resultInfo.vecIconsIndexData[j] < 3)then
            else
                local vecIcons = resultInfo.vecIconsIndexData[j];
                for k=1,tonumber(#vecIcons),1 do 
                    local isAddAction = true
                    local info = vecIcons[k]
                    for d=1,tonumber(#vecShowList),1 do 
                    
                        if(info.pos.x == vecShowList[d].x and info.pos.y == vecShowList[d].y)then
                            isAddAction = false
                            break;
                        end
                    end
                
                    if(isAddAction)then
                        table.insert(vecShowList,info.pos)
                        local pos = cc.p(commonStartX + info.pos.y * differX-1, commonStartY - info.pos.x * differY-4)
                        if info.pos.x == 0 then
                            pos.y  = pos.y - 10
                        elseif info.pos.x == 2 then
                            pos.y  = pos.y + 10
                        end
                        self:showPerIconEffect(info.giType,pos,false,1)
                        local tab = {row = info.pos.x,col = info.pos.y}
                        self:showPerKuangEffect(pos,tab)
                    end
                
                    if(info.giType ~= GI_SHUIHUZHUAN)then
                        playEffectType = info.giType
                    end
                end
            
                if isPlayingSound == false and not self.m_bIsQuicklyJieSuan then
                --//播放索引值最小连线中奖 icon 音效
                    local winsound = 0
                    if (playEffectType == GI_COUNT) then
                        winsound = GI_SHUIHUZHUAN
                    else
                        winsound = playEffectType
                    end

                    self:playPerLineWinSound(winsound)
                    isPlayingSound = true
                end
            end
        end
    end
   
    if self.m_bIsQuicklyJieSuan then 
        self:enterJieSuan()
    end
    --//播放结束进入结算界面
    local callback = cc.CallFunc:create(function ()
        self:playAllWinLineEffect()
        if not self.m_bIsQuicklyJieSuan then 
            self:enterJieSuan()
        end
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(1.5), callback)
    self.m_pNodeEffect:runAction(seq)
end
function GameViewLayer:playPerLineWinSound(iconType)

    local strSoundName = ""

    if iconType == GI_FUTOU then
        strSoundName = "sound_water_futou.mp3"
    elseif iconType == GI_YINGQIANG then
        strSoundName = "sound_water_yingqiang.mp3"
    elseif iconType == GI_DADAO then
        strSoundName = "sound_water_dadao.mp3"
    elseif iconType == GI_LU then
        strSoundName = "sound_water_lu.mp3"
    elseif iconType == GI_LIN then
        strSoundName = "sound_water_lin.mp3"
    elseif iconType == GI_SONG then
        strSoundName = "sound_water_song.mp3"
    elseif iconType == GI_TITIANXINGDAO then
        strSoundName = "sound_water_titianxingdao.mp3"
    elseif iconType == GI_ZHONGYITANG then
        strSoundName = "sound_water_zhongyitiang.mp3"
    elseif iconType == GI_SHUIHUZHUAN then
        strSoundName = "sound_water_shuihuzhuan.mp3"
    end

    if(strSoundName ~= "")then
        ExternalFun.playSoundEffect(strSoundName);
    end
end

function GameViewLayer:enterJieSuan()
    local bGoLittle = true
    --全屏水浒传 直接进入小玛丽
    for i=1,3 do 
        for n=1,5 do 
            local gameResult = WaterMarginDataMgr.getInstance():getGameResult()
            if gameResult.result_icons[i][n] ~= 8 then 
                bGoLittle = false
            end
        end   
    end
    bGoLittle = false   --先不进小玛丽
    if bGoLittle == true then
        self:stopGame()
        self:enterLittleMaryGame()
    else
        self:enterResultView()
    end
    self.m_pNodeEffect:stopAllActions()
    self:updateWinScore("stopGame")
end
--结算界面
function GameViewLayer:enterResultView()

    if self:getChildByName("WaterMarginResultView") then 
        self:getChildByName("WaterMarginResultView"):removeFromParent()
    end
    local m_WaterMarginResultView = WaterMarginResultView:create()
    m_WaterMarginResultView:setName("WaterMarginResultView")
    m_WaterMarginResultView:addTo(self, WaterMarginDataMgr.Order_Result)
    local winBeiShu = self.m_winMoney/WaterMarginDataMgr.getInstance():getBaseBetNum()
    if winBeiShu < 5 then
        m_WaterMarginResultView:setCannotCompare()
    end
end
--画线
function GameViewLayer:setPerLinesVisible( bVisble, index)

    if((index >= 1) and (index < WATER_MAX_LINE_NUM+1))then
        for i=1,tonumber(WATER_MAX_LINE_NUM),1 do 
            self.m_pSpLine[i]:setVisible(false)
        end
        self.m_pSpLine[index]:setVisible(bVisble)
        self:playPerWinLineEffect(index)
    end
end
function GameViewLayer:playPerWinLineEffect( lineIndex, isClean)
--[[
    if(self.m_pNodeEffectLine == nil or (lineIndex > WATER_MAX_LINE_NUM) or (lineIndex < 0))then
        return
    end
    
    if(isClean)then
        self.m_pNodeEffectLine:stopAllActions()
        self.m_pNodeEffectLine:removeAllChildren()
    end

    local posX,posY = self.m_pSpLine[lineIndex]:getPosition()
    local pos = cc.p(posX,posY)
    local size = self.m_pSpLine[lineIndex]:getContentSize()

    local RightPos = cc.p(pos.x + size.width + 18 + 3,pos.y+1)
    local LeftPos = cc.p(pos.x+5 - 3  ,pos.y+1)
    
--    Effect.getInstance():creatEffectWithDelegate2(self.m_pNodeEffectLine,"xuanzhongkuangkuang_shuihuzhuan","Animation1",true,LeftPos)
--    Effect.getInstance():creatEffectWithDelegate2(self.m_pNodeEffectLine,"xuanzhongkuangkuang_shuihuzhuan","Animation1",true,RightPos)
    local kuangkuang_1 = ccs.Armature:create("xuanzhongkuangkuang_shuihuzhuan")
--    kuangkuang_1:setAnchorPoint(cc.p(0,0))
    kuangkuang_1:setPosition(LeftPos)
	kuangkuang_1:addTo(self.m_pNodeEffectLine)
	kuangkuang_1:getAnimation():play(Animation1)
    local kuangkuang_2 = ccs.Armature:create("xuanzhongkuangkuang_shuihuzhuan")
--    kuangkuang_1:setAnchorPoint(cc.p(0,0))
    kuangkuang_2:setPosition(RightPos)
	kuangkuang_2:addTo(self.m_pNodeEffectLine)
	kuangkuang_2:getAnimation():play(Animation1)
    --]]
end

----------------------
function GameViewLayer:showScoreChangeEffect2(_label, _lastScore, _subScore, _dstScore, _index, _changeCount)
    local index = _index or 1
    local changeCount = _changeCount or 10
    if not _label or index < 1 or index >= SCORE_LABEL_NUM then
        return
    end
    self.m_nChangeCount = changeCount
    if _subScore == 0 or self.m_iShowCount[index] ~=0  then
        local strSocre = LuaUtils.getFormatGoldAndNumber(_dstScore)
        if index == 2 then
            local strSocre = LuaUtils.getFormatGoldAndNumber(_dstScore)
            _label:setString(strSocre)
            return
        end
    end
    self.m_lDesScore[index] = _dstScore
    self.m_lSubScore[index] = _subScore
    self.m_lShowScore[index] = _lastScore
    self.m_pLbScore[index] = _label
    self.m_iShowCount[index] = 0    

    if index == 1 then
        self:updateScoreChangeOne2()
    elseif index == 2 then
        self:updateScoreChangeTwo2()
    elseif index == 3 then
        self:updateScoreChangeThree2()
    elseif index == 4 then
        self:updateScoreChangeFour2()
    end
end

function GameViewLayer:updateScoreChangeOne2()
    local index = 1
    if self:checkScoreChangeDone2(index, true, true) then
        return
    end
    local strScore = LuaUtils.getFormatGoldAndNumber(self.m_lShowScore[index])
    self.m_pLbScore[index]:setString(strScore)
    
    local callback = cc.CallFunc:create(function()
        self:updateScoreChangeOne2()
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(0.10), callback)
    self.m_pLbScore[index]:runAction(seq)
    local tmp = self.m_iShowCount[index]
    self.m_iShowCount[index] = tmp + 1
end

function GameViewLayer:updateScoreChangeTwo2()
    local index = 2
    if self:checkScoreChangeDone2(index, false, false) then
        return
    end
    local strScore = LuaUtils.getFormatGoldAndNumber(self.m_lShowScore[index])
    self.m_pLbScore[index]:setString(strScore)
    
    local callback = cc.CallFunc:create(function()
        self:updateScoreChangeTwo2()
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(0.07), callback)
    self.m_pLbScore[index]:runAction(seq)
    local tmp = self.m_iShowCount[index]
    self.m_iShowCount[index] = tmp + 1
end

function GameViewLayer:updateScoreChangeThree2()
    local index = 3
    if self:checkScoreChangeDone2(index, true, false) then
        return
    end
    local strScore = LuaUtils.getFormatGoldAndNumber(self.m_lShowScore[index])
    self.m_pLbScore[index]:setString(strScore)
    
    local callback = cc.CallFunc:create(function()
        self:updateScoreChangeThree2()
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(0.1), callback)
    self.m_pLbScore[index]:runAction(seq)
    local tmp = self.m_iShowCount[index]
    self.m_iShowCount[index] = tmp + 1
end

function GameViewLayer:updateScoreChangeFour2()
    local index = 4
    if self:checkScoreChangeDone2(index, true, true) then
        return
    end
    local strScore = LuaUtils.getFormatGoldAndNumber(self.m_lShowScore[index])
    self.m_pLbScore[index]:setString(strScore)
    
    local scale = cc.EaseBackOut:create(cc.ScaleTo:create(0.05, 1.1/2))
    local back = cc.ScaleTo:create(0.05, 1.0/2)
    local callback = cc.CallFunc:create(function()
        self:updateScoreChangeFour2()
    end)
    local seq = cc.Sequence:create(scale, back, callback)
    self.m_pLbScore[index]:runAction(seq)
    local tmp = self.m_iShowCount[index]
    self.m_iShowCount[index] = tmp + 1
end

function GameViewLayer:checkScoreChangeDone2( index, format, sound)
    if not self.m_pLbScore[index] then return true end
    local tmp = self.m_lShowScore[index]
    self.m_lShowScore[index] = tmp + (self.m_lSubScore[index]/self.m_nChangeCount)
    if self.m_lSubScore[index] < 0 and (self.m_lShowScore[index] <= self.m_lDesScore[index] or self.m_iShowCount[index] >= self.m_nChangeCount) then
        -- ¼õÉÙ
        self:socreChangeDone2(index, format, sound)
        return true
    end
    if self.m_lSubScore[index] >= 0  and (self.m_lShowScore[index] >= self.m_lDesScore[index] or self.m_iShowCount[index] >= self.m_nChangeCount) then
        -- Ôö¼Ó
        self:socreChangeDone2(index, format, sound)
        return true
    end
    return false
end

function GameViewLayer:socreChangeDone2(index, format, sound)
    local strScore = ""
    if (format) then
        strScore = self:getFormatGoldAndNumber(self.m_lDesScore[index])
    else
        strScore = self:getFormatGoldAndNumber(self.m_lDesScore[index])
    end
    self.m_pLbScore[index]:setString(strScore)
    self.m_iShowCount[index] = 0
--    if (sound) then
--         ExternalFun.playSoundEffect("public/sound/sound-gold.wav")
--    end

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
    print("WaterMarginMainLayer:onExit")
    SLFacade:removeEventListener(self.m_onMsgGetGameResult)
--    SLFacade:removeEventListener(self.m_onMsgUpdateBetData)
    SLFacade:removeEventListener(self.m_onMsgGameEnd)
    SLFacade:removeEventListener(self.m_onMsgGoldChange)
    SLFacade:removeEventListener(self.m_onMsgGoldChangePublic)
    SLFacade:removeEventListener(self.m_onMsgStopAutoInCompareView)
    SLFacade:removeEventListener(self.m_onMsgGoldChangeOfOtherView)
    SLFacade:removeEventListener(self.m_onMsgInstantFinish)
    SLFacade:removeEventListener(self.m_onMsgPauseBgMusic)
    SLFacade:removeEventListener(self.m_onMsgResumeBgMusic)
    SLFacade:removeEventListener(self.m_onMsgInitGame)
    SLFacade:removeEventListener(self.m_onMsgEnterCompare)
--    SLFacade:removeEventListener(self.m_onMsgEnterLittleMary)
    SLFacade:removeEventListener(self.m_onMsgShowChargeLayer)
    SLFacade:removeEventListener(self.m_onMsgEnterBg)

--    SLFacade:removeCustomEventListener(Public_Events.MSG_GAME_EXIT, self.__cname)
--    SLFacade:removeCustomEventListener(Public_Events.MSG_NETWORK_FAILURE, self.__cname)

--    PlayerInfo.getInstance():setIsGameBackToHall(true)
--    PlayerInfo:getInstance():setIsGameBackToHallSuc(false)
--    PlayerInfo:getInstance():setSitSuc(false)

    --GameRollMsg.getInstance():cleanMessage()

    --停掉音乐
--    AudioManager.getInstance():stopAllSounds()
--    AudioManager.getInstance():stopAllSoundEffect()

    if self.m_onLongPressCallBack ~= nil then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_onLongPressCallBack)
    end

    --删除
    self:stopAllActions()
    self:removeAllChildren()

    WaterMarginDataMgr.getInstance():setIsAuto(false)
    if self.m_bEnterBackground  then 
        return
    end
    --释放资源
    if WaterMarginDataMgr then
        WaterMarginDataMgr.releaseInstance()
    end
    -- 释放UI资源

    -- 释放动画
    for i, name in pairs(WaterMarginSceneRes.vecReleaseAnim) do
        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(name)
    end

    -- 释放整图
    for i, name in pairs(WaterMarginSceneRes.vecReleasePlist) do
        display.removeSpriteFrames(name[1], name[2])
    end
    -- 释放背景图
    for i, name in pairs(WaterMarginSceneRes.vecReleaseImg) do
        display.removeImage(name)
    end

    -- 释放音频
--    for _, strFileName in pairs(WaterMarginSceneRes.vecReleaseSound) do
--        AudioManager.getInstance():unloadEffect(strFileName)
--    end
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