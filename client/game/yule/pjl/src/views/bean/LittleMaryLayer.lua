--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local module_pre = "game.yule.pjl.src.views"
local WaterMarginDataMgr    = appdf.req(module_pre..".manager.WaterMarginDataMgr")

local CMsgWaterMargin       =  appdf.req(module_pre..".proxy.CMsgWaterMargin")

--local AudioManager          = require("common.manager.AudioManager")

--local FloatMessage          = require("common.layer.FloatMessage")

local scheduler = cc.exports.scheduler

local PATH_UI_WATER_LITTLEMARY_HALL = "game/watermargin/WaterMarginUi_littlemary_hall.json"

local WaterMarginScene_Events = require("game.watermargin.scene.WaterMarginSceneEvent")

--退出游戏倒计时时间间隔
local EXIT_GAME_TIME_Mary = 3.0

local MARY_ICON_COL = 4
local MARY_MAX_LINE_ICON_NUM = 40

local WATER_MAX_LITTLE_MARY_ICON_NUM = 24   --小玛丽中外围滚动最大牌子数

local LittleMaryLayer = class("LittleMaryLayer", cc.Layer)      

local   BUY_FAIL = -1
local	BUY_SMALL = 0
local	BUY_TIE = 1
local	BUY_BIG = 2


local GI_FUTOU = 0     -- 斧头
local GI_YINGQIANG = 1     -- 银枪
local GI_DADAO = 2         -- 大刀
local GI_LU = 3            -- 鲁智深
local GI_LIN = 4           -- 林冲
local GI_SONG = 5          -- 宋江
local GI_TITIANXINGDAO = 6 -- 替天行道
local GI_ZHONGYITANG = 7   -- 忠义堂
local GI_SHUIHUZHUAN = 8   -- 水浒传
local GI_COUNT = 9

LittleMaryLayer.instance_ = nil
function LittleMaryLayer.create()
    LittleMaryLayer.instance_ = LittleMaryLayer.new()
    return LittleMaryLayer.instance_
end

function LittleMaryLayer:ctor()
    self:enableNodeEvents()
end

function LittleMaryLayer:getChildByUIName(root,name)
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

function LittleMaryLayer:onEnter()
    self:init()
    self:show()
end

function LittleMaryLayer:onExit()

    SLFacade:removeEventListener(self.m_onMsgNetWorkFailre)
    SLFacade:removeEventListener(self.m_onMsgGameResult)
    SLFacade:removeEventListener(self.m_onMsgStartGame)
    SLFacade:removeEventListener(self.m_onMsgExitMary)

    scheduler.unscheduleGlobal(self.m_pUpdateGlobal)

    AudioManager.getInstance():stopAllSounds()
    AudioManager.getInstance():playMusic("game/watermargin/sound/sound_water_bg.mp3")
    WaterMarginDataMgr.getInstance():clearLittleMaryData()

    SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_UPDATE_USER_SCORE_OTHER_VIEW)
    LittleMaryLayer.instance_ = nil
end

function LittleMaryLayer:show()
    self:stopAllActions()
    self:setScale(0.0)
    local show = cc.Show:create()
    local scaleTo = cc.ScaleTo:create(0.4, 1.0)
    local ease = cc.EaseBackOut:create(scaleTo)
    local seq = cc.Sequence:create(show,ease)
    self:runAction(seq)


    -- self:setPosition(-2000,0)
    -- local moveTo = cc.MoveTo:create(0.3,cc.p(0,0))
    -- self:runAction(moveTo)
end

function LittleMaryLayer:hide()
    --self:setPosition(0,1000)
    local moveTo = cc.MoveTo:create(0.2,cc.p(-2000,0))
    local callback = cc.CallFunc:create(function ()
            self:removeFromParent()
        end)
    self:runAction(cc.Sequence:create(moveTo, callback))
end

function LittleMaryLayer:closeSound()

    --AudioManager.getInstance():stopSound(self.m_nBgSoundId);
    --AudioManager.getInstance():stopSound(self.m_nWinSOundId);
end

function LittleMaryLayer:init()
   self:initVars()

   -- 加载UI
   self.m_pUI = cc.CSLoader:createNode("game/watermargin/WaterLittlemary_hall.csb")
   self.m_pUI:addTo(self)

   self.m_rootUI = self:getChildByUIName(self.m_pUI, "Panel")
   self.m_rootUI:setPosition((145 - (1624 - display.width) / 2), 0)

   print("---加载UI成功");

   self:initCCS()
   print("---初始化CCS成功");
end


function LittleMaryLayer:initVars()
    self.m_pNodeTurn = nil;
    self.m_pNodeIcons = nil;
    self.m_pEffectNode = nil;
    self.m_pLbExitGameTipsNode = nil;
    
    self.m_pLbUsrGold = nil;
    self.m_pLbCount = nil;
    self.m_pLbWin = nil;
    self.m_pLbWinAmount = nil;
    self.m_pExitGameTips = nil;
    
    self.m_pSpSelect = nil;

    self.m_cliper = {}
    self.m_cliperNode = {}
    for i=1,tonumber(MARY_ICON_COL),1 do 
        self.m_cliper[i] = nil;
        self.m_cliperNode[i] = nil;
    end

    
    self.m_iShowAmount = 0;
    self.m_iShowIndex = 0;
    self.m_fOpenAniTime = 0.0
    self.m_bIsNotCount = false;
    self.m_fCountDownTime = 0.0
    
    self.m_nBgSoundId = 0;
    self.m_nWinSOundId = 0;
    self.m_bIsPlaying = true;

    self.m_bOpening = false
    
end

function LittleMaryLayer:initCCS()
   --初始化 UI 变量
   self:onAssignCCBMemberVariable()    
   --监听按钮
   self:onResolveCCBCCControlSelector()

   self:onNodeLoaded()

   --加载其他onEnter
   self:initOther();
end

function LittleMaryLayer:initOther()

    self.m_pUpdateGlobal = scheduler.scheduleUpdateGlobal(handler(self, self.update))
    --self.m_onMsgGoldChangePublic = SLFacade:addCustomEventListener(Public_Events.MSG_UPDATE_USER_SCORE, handler(self, self.onMsgGoldChange))--
    --self.m_onMsgGoldChange = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_UPDATE_USER_SCORE, handler(self, self.onMsgGoldChange))--
    self.m_onMsgNetWorkFailre = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_NETWORK_FAILURE, handler(self, self.onMsgNetWorkFailre))--
    self.m_onMsgGameResult = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_LITTLE_MARY_RESULT, handler(self, self.onMsgGameResult))--
    self.m_onMsgStartGame = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_START_GAME_LITTLE_MARY, handler(self, self.onMsgStartGame))--
    self.m_onMsgExitMary = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_RETURN_GAME_SCENE1, handler(self, self.onMsgExitMary))--

end

function LittleMaryLayer:onMsgExitMary()

--    FloatMessage.getInstance():pushMessage("WATER_30")
    self:removeFromParent()
end

function LittleMaryLayer:onMsgStartGame()
    self:startGame()
end

function LittleMaryLayer:onMsgGameResult()

    self.m_pEffectNode:removeAllChildren()
    self:refreshIcons()
    self:playTurnEffect()
    self:startRoundEffect()
end

function LittleMaryLayer:startRoundEffect()

    local nBeginIndex = WaterMarginDataMgr.getInstance():getLastIndex();
    local nEndIndex = WaterMarginDataMgr.getInstance():getDstIndex();
    local subIndex = nEndIndex - nBeginIndex;
    if (nBeginIndex > nEndIndex) then
        subIndex = WATER_MAX_LITTLE_MARY_ICON_NUM - nBeginIndex + nEndIndex
    end

    self.m_iShowAmount = (WATER_MAX_LITTLE_MARY_ICON_NUM*2 + nBeginIndex) + subIndex;
    self.m_iShowIndex =  WATER_MAX_LITTLE_MARY_ICON_NUM - 1;
    if nBeginIndex - 1 >= 0 then
        self.m_iShowIndex =  nBeginIndex - 1
    end

    self.m_fOpenAniTime = 0.3
    
    self.m_pSpSelect:setVisible(true);
    self:playRoundEffect();
end


function LittleMaryLayer:playRoundEffect()

    if (self.m_iShowIndex >=  self.m_iShowAmount)then
    -- 转圈结束
        self.m_iShowIndex = 0;
        self:openEffectEnd();
        return;
    end

    if(self.m_bIsPlaying)then
    
        self.m_bIsPlaying = false;

        local callback = cc.CallFunc:create(function ()
            self.m_bIsPlaying = true;
        end)
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.16), callback));    
        AudioManager.getInstance():playSound("game/watermargin/sound/sound_water_mary_roll_out.mp3");
    end
    
    if ((self.m_fOpenAniTime - 0.05) <= 0.01) then
        self.m_fOpenAniTime  =   0.01 
    else
        self.m_fOpenAniTime  =  self.m_fOpenAniTime - 0.05;
    end

    self.m_iShowIndex = 1 + self.m_iShowIndex   
    local index = self.m_iShowIndex  % WATER_MAX_LITTLE_MARY_ICON_NUM;

    local subIndex = self.m_iShowAmount - self.m_iShowIndex;
    
    if (subIndex >= 0 and subIndex <= 5)then
        self.m_fOpenAniTime = (6 - subIndex) * 0.1
    end
    
    local nIndex = index;
    if index < 0 then
        nIndex = WATER_MAX_LITTLE_MARY_ICON_NUM - 1
    end
    local name = "Panel_"..tostring(23-nIndex)
    local posX,poxY = self.m_pNodeIcons:getChildByName(name):getPosition()
    self.m_pSpSelect:setPosition(cc.p(posX-2,poxY+2));
    local callback = cc.CallFunc:create(function ()
        self:playRoundEffect()
    end)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(self.m_fOpenAniTime), callback));    


end

--开奖动画结束
function LittleMaryLayer:openEffectEnd()
    self.m_bOpening = false
    self:updateUserInfo();
    self:playInnerRollIconEffect();
    
    local curAwardGold = WaterMarginDataMgr.getInstance():getLittleMaryAwardGold();
    if(curAwardGold > 0)then
        AudioManager.getInstance():playSound("game/watermargin/sound/sound_water_mary_roll_inner.mp3")
        self.m_pLbAward:setString("+"..self:getFormatGold(curAwardGold))
        self:showAwardGold()
    end
    
    local count = WaterMarginDataMgr.getInstance():getLittleMaryCount();

    if(count <= 0)then
    
        FloatMessage.getInstance():pushMessageForString(LuaUtils.getLocalString("WATER_12"));
        local callback = cc.CallFunc:create(function ()
            self:beginCountDown()
        end)
        self:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), callback));    
    else
    
        local callback = cc.CallFunc:create(function ()
            self:startGame()
        end)
        self:runAction(cc.Sequence:create(cc.DelayTime:create(2.0), callback));    

    end
end

function LittleMaryLayer:startGame()
    if self.m_bOpening then 
        return
    end
    self.m_bOpening = true
    local count = WaterMarginDataMgr.getInstance():getLittleMaryCount();
    local usrGold = WaterMarginDataMgr.getInstance():getPerLineTotalBetNum();
    
    CMsgWaterMargin.getInstance():sendMsgLittleMaryGameStart(count,usrGold);
end

function LittleMaryLayer:showAwardGold()

    self.m_pLbAward:setPosition(cc.p(0,0))
    local move = cc.EaseBackOut:create(cc.MoveBy:create(0.2, cc.p(0.0,50.0))) 
    local pFadein = cc.FadeIn:create(0.2)
    local pDelay = cc.DelayTime:create(3)
    local pFadeout = cc.FadeOut:create(0.5)
    local pSeq = cc.Sequence:create(cc.Spawn:create(pFadein,move),pDelay,pFadeout)
    self.m_pLbAward:runAction(pSeq)

    self.m_pSpAwardBg:setOpacity(0)
    self.m_pSpAwardBg:setPosition(cc.p(0,7))
    local move2 = cc.EaseBackOut:create(cc.MoveBy:create(0.2, cc.p(0.0,50.0))) 
    local pFadein2 = cc.FadeIn:create(0.2)
    local pDelay2 = cc.DelayTime:create(3)
    local pFadeout2 = cc.FadeOut:create(0.5)
    local pSeq2 = cc.Sequence:create(cc.Spawn:create(pFadein2,move2),pDelay2,pFadeout2)
    self.m_pSpAwardBg:runAction(pSeq2)
end

function LittleMaryLayer:beginCountDown()

    self.m_bIsNotCount = true;
    self.m_fCountDownTime = EXIT_GAME_TIME_Mary;
    self.m_pLbExitGameTipsNode:setVisible(true);

end

function LittleMaryLayer:playInnerRollIconEffect()

    local resultInfo = WaterMarginDataMgr.getInstance():getLittleMaryResult();
    for i=1,tonumber(4),1 do 
    
        if( resultInfo.rotate_result == resultInfo.rolling_result_icons[i])then
        
            local pos = { cc.p(340.0, 309.0), cc.p(560.5, 309.0), cc.p(780.0, 309.0) , cc.p(1000.5, 309.0) }
            --local pos = cc.p(340.0 + (i-1) * 220.5, 305.0)
            self:showPerIconEffect(resultInfo.rotate_result,pos[i])
        end
    end
end


function LittleMaryLayer:showPerIconEffect( iconType,  pos)

    local strArmName = "";

    if iconType == GI_FUTOU then -- 斧头
        strArmName = "hutou_shuihuzhuan";
    elseif iconType == GI_YINGQIANG then-- 银枪
        strArmName = "yingqiang_shuihuzhuan";
    elseif iconType == GI_DADAO then-- 大刀
        strArmName = "dadao_shuihuzhuan";
    elseif iconType == GI_LU then-- 鲁智深
        strArmName = "lu_shuihuzhuan";
    elseif iconType == GI_LIN then-- 林冲
        strArmName = "lin_shuihuzhuan";
    elseif iconType == GI_SONG then-- 宋江
        strArmName = "songjiang_shuihuzhuan";
    elseif iconType == GI_TITIANXINGDAO then-- 替天行道
        strArmName = "titianxingdao_shuihuzhuan";
    elseif iconType == GI_ZHONGYITANG then-- 忠义堂
        strArmName = "zhongyitang_shuihuzhuan";
    elseif iconType == GI_SHUIHUZHUAN then-- 水浒传
        strArmName = "shuihuzhuan_shuihuzhuan";

    end

    if (strArmName ~= "")then
        local armature = Effect.getInstance():creatEffectWithDelegate(self.m_pEffectNode, strArmName, 0, true, pos)
        if(armature)then
            armature:setScale(1.25)
            local dikuang = cc.Sprite:createWithSpriteFrameName("game/watermargin/images/icondakuang.png")
            dikuang:setPosition(pos)
            self.m_pEffectNode:addChild(dikuang,99)

            local animationEvent = function (armatureBack,movementType,movementID)
                if movementType == ccs.MovementEventType.complete then
                    self:playPerIconNextEffect(armatureBack)
                end
            end
            armature:setName(strArmName)
            armature:getAnimation():setMovementEventCallFunc(animationEvent)         

        end
    end
end

function LittleMaryLayer:playPerIconNextEffect(armature)

    local strName = armature:getName();
    local posX,posY = armature:getPosition();
    armature:setVisible(false)

    local m_pArmature = Effect.getInstance():creatEffectWithDelegate(self.m_pEffectNode, strName, 1, true, cc.p(posX,posY));
    if(m_pArmature)then
        m_pArmature:setScale(1.25)
        local animationEvent = function (armatureBack,movementType,movementID)
            if movementType == ccs.MovementEventType.complete then
                armatureBack:setVisible(false)
            end
        end
        m_pArmature:getAnimation():setMovementEventCallFunc(animationEvent)    
    end
end

function LittleMaryLayer:playTurnEffect()

    local sectionTimeFirst = {0.2, 0.2, 0.2,0.2 };
    local sectionTimeSecond = {2.0, 2.1, 2.2, 2.3};
    local sectionTimeEnd = {0.5, 0.6, 0.7, 0.8 };
    
    for i=1,tonumber(MARY_ICON_COL),1 do 
    
        self.m_cliperNode[i]:stopAllActions();
        self.m_cliperNode[i]:setPosition(0.0, 0.0);
        local moveAct1 = cc.MoveTo:create(sectionTimeFirst[i], cc.p(0, -300));
        local easeExpon  = cc.EaseExponentialIn:create(moveAct1);
        local moveAct2 = cc.MoveTo:create(sectionTimeSecond[i], cc.p(0, -148*(MARY_MAX_LINE_ICON_NUM-1)+502));
        local moveAct3 = cc.MoveTo:create(sectionTimeEnd[i], cc.p(0, -148*(MARY_MAX_LINE_ICON_NUM-1)));
        local easeAct = cc.EaseBackOut:create(moveAct3);          

        local seq = cc.Sequence:create(easeExpon, moveAct2, easeAct);
        self.m_cliperNode[i]:runAction(seq);
        
    end
    
    --AudioManager.getInstance():playSound("game/watermargin/sound/sound_water_mary_roll_inner.mp3");
end


function LittleMaryLayer:refreshIcons()

    --先清除原来的结果
    for i=1,tonumber(MARY_ICON_COL),1 do 
        self.m_cliperNode[i]:removeAllChildren();
    end
    
    local lastResult = WaterMarginDataMgr.getInstance():getLastLittleMaryResult();
    --添加上一轮的开奖图标的图标
    for i=1,tonumber(MARY_ICON_COL),1 do 
        local iconIndex = lastResult.rolling_result_icons[i];
        local strIconFile = string.format("game/watermargin/images/gui-water-icon-%d.png", iconIndex);
        local icon = cc.Sprite:createWithSpriteFrameName(strIconFile);
        icon:setAnchorPoint(cc.p(0,0));
        icon:setPosition(cc.p(0, 0));
        self.m_cliperNode[i]:addChild(icon);

        local dikuang = cc.Sprite:createWithSpriteFrameName("game/watermargin/images/icondakuang.png")
        dikuang:setAnchorPoint(cc.p(0,0))
        dikuang:setPosition(cc.p(0,0))
        self.m_cliperNode[i]:addChild(dikuang)
    end
    
    --添加中间的图标
    for i=1,tonumber(MARY_ICON_COL),1 do 
        for j=1,tonumber(MARY_MAX_LINE_ICON_NUM-1),1 do 
            local strIconFile = string.format("game/watermargin/images/gui-water-icon-mix-%d.png", math.random(1,8)-1);
            local icon = cc.Sprite:createWithSpriteFrameName(strIconFile);
            icon:setAnchorPoint(cc.p(0,0));
            icon:setPosition(cc.p(0, (j-1)*148));
            self.m_cliperNode[i]:addChild(icon);

            local dikuang = cc.Sprite:createWithSpriteFrameName("game/watermargin/images/icondakuang.png")
            dikuang:setAnchorPoint(cc.p(0,0))
            dikuang:setPosition(cc.p(0, (j-1)*148));
            self.m_cliperNode[i]:addChild(dikuang)
        end
    end
    
    
    local result = WaterMarginDataMgr.getInstance():getLittleMaryResult();
    --添加新的中奖的
    for i=1,tonumber(MARY_ICON_COL),1 do 
        local iconIndex = result.rolling_result_icons[i];
        local strIconFile = string.format("game/watermargin/images/gui-water-icon-%d.png", iconIndex);
        local icon = cc.Sprite:createWithSpriteFrameName(strIconFile);
        icon:setAnchorPoint(cc.p(0,0));
        icon:setPosition(cc.p(0, (MARY_MAX_LINE_ICON_NUM-1)*148));
        self.m_cliperNode[i]:addChild(icon);

        local dikuang = cc.Sprite:createWithSpriteFrameName("game/watermargin/images/icondakuang.png")
        dikuang:setAnchorPoint(cc.p(0,0))
        dikuang:setPosition(cc.p(-3,(MARY_MAX_LINE_ICON_NUM-1)*148-8))
        self.m_cliperNode[i]:addChild(dikuang)
    end
    
end


function LittleMaryLayer:onMsgNetWorkFailre()

    --self:onMoveExitView(FixLayer.HIDE_NO_STYLE)
    self:removeFromParent()
end

function LittleMaryLayer:update(dt)

    if(self.m_bIsNotCount == false or self.m_pLbExitGameTipsNode == nil)then
        return;
    end
    
    self.m_fCountDownTime = self.m_fCountDownTime - dt;
    
    if (self.m_fCountDownTime < 0.0) then
         self.m_fCountDownTime = 0.0
    else
         self.m_fCountDownTime = self.m_fCountDownTime;
    end
    
    self.m_pExitGameTips:setString(string.format(LuaUtils.getLocalString("WATER_28"),math.ceil(self.m_fCountDownTime)));
    
    if(self.m_fCountDownTime <= 0.0)then
        self.m_bIsNotCount = false;
        self.m_pLbExitGameTipsNode:setVisible(false);
        self:exitGame(0);
    end

end

function LittleMaryLayer:exitGame(time)

    CMsgWaterMargin.getInstance():sendMsgGameStop();
    
    --水浒传中其他界面提示主界面更新金币
    SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_UPDATE_USER_SCORE_OTHER_VIEW)
    self:hide()
end

function LittleMaryLayer:onAssignCCBMemberVariable()


    self.m_pNodeTurn = self:getChildByUIName(self.m_pUI, "m_pNodeTurn")
    self.m_pNodeIcons = self:getChildByUIName(self.m_pUI, "m_pNodeIcons")  
    self.m_pEffectNode = self:getChildByUIName(self.m_pUI, "m_pEffectNode")  
    self.m_pLbExitGameTipsNode = self:getChildByUIName(self.m_pUI, "m_pExitGameTipsNode")  

    self.m_pLbUsrGold = self:getChildByUIName(self.m_pUI, "m_pLbUsrGold")  
    self.m_pLbCount = self:getChildByUIName(self.m_pUI, "m_pLbCount")  
    self.m_pLbWin = self:getChildByUIName(self.m_pUI, "m_pLbWin")  
    self.m_pLbWinAmount = self:getChildByUIName(self.m_pUI, "m_pLbWinAmount")  
    self.m_pExitGameTips = self:getChildByUIName(self.m_pUI, "m_pExitGameTips")  

    self.m_pSpSelect = self:getChildByUIName(self.m_pUI, "m_pSpSelect") 
    self.m_pSpAwardBg = self:getChildByUIName(self.m_pUI, "award_bg")  
    self.m_pLbAward = self:getChildByUIName(self.m_pUI, "m_pLbAward")  

    self.m_pLbAward:setString("")
    self.m_pSpAwardBg:setOpacity(0)
end

function LittleMaryLayer:onResolveCCBCCControlSelector()

end

function LittleMaryLayer:onNodeLoaded()
    if(WaterMarginDataMgr.getInstance():getIsAuto())then
        SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_STOP_WATER_SCENE1_AUTO)
    end
    --SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_PAUSE_SCENE1_MUSIC)
    AudioManager.getInstance():playMusic("game/watermargin/sound/sound_water_mary_bg.mp3")

    self.m_pLbExitGameTipsNode:setVisible(false);
    self.m_pSpSelect:setVisible(false);
    
    self:addClipers();
    self:createIcons();
    self:updateUserInfo();
end

function LittleMaryLayer:addClipers()

    local point = {cc.p(0,0), cc.p(214, 0), cc.p(214, 144), cc.p(0, 144)};
    for i=1,tonumber(MARY_ICON_COL),1 do 
        --绘制裁剪区域
        local shap = cc.DrawNode:create();
        shap:drawPolygon(point, 4, cc.c4b(255, 255, 255, 255), 2, cc.c4b(255, 255, 255, 255));
        self.m_cliper[i] = cc.ClippingNode:create();
        self.m_cliper[i]:setStencil(shap);
        self.m_cliper[i]:setAnchorPoint(cc.p(0,0));
        self.m_cliper[i]:setPosition(cc.p((i-1)*220, 0));
        self.m_pNodeTurn:addChild(self.m_cliper[i],G_CONSTANTS.Z_ORDER_OVERRIDE);
        
        self.m_cliperNode[i] = cc.Node:create();
        self.m_cliperNode[i]:setAnchorPoint(cc.p(0,0));
        self.m_cliperNode[i]:setPosition(cc.p(0, 0));
        self.m_cliperNode[i]:setTag(i-1);
        self.m_cliper[i]:addChild(self.m_cliperNode[i]);
    end
end

function LittleMaryLayer:createIcons()

    for i=1,tonumber(MARY_ICON_COL),1 do 
        local iconIndex = math.random(1,8)-1
        local strIconFile = string.format("game/watermargin/images/gui-water-icon-%d.png", iconIndex);
        local icon = cc.Sprite:createWithSpriteFrameName(strIconFile);
        icon:setAnchorPoint(cc.p(0,0));
        icon:setPosition(cc.p(0, 0));
        self.m_cliperNode[i]:addChild(icon);

        local dikuang = cc.Sprite:createWithSpriteFrameName("game/watermargin/images/icondakuang.png")
        dikuang:setAnchorPoint(cc.p(0,0))
        dikuang:setPosition(cc.p(0,0))
        self.m_cliperNode[i]:addChild(dikuang)
    end
end


-- 更新玩家信息
function LittleMaryLayer:updateUserInfo()

    if (self.m_pLbUsrGold)then
        local nCurrentBetMoney = WaterMarginDataMgr.getInstance():getCurTotalBetNum()
        self.m_pLbUsrGold:setString(self:getFormatGold(nCurrentBetMoney))
    --print("----------------- updateUserInfo")
    end

    if (self.m_pLbCount)then
        local count = WaterMarginDataMgr.getInstance():getLittleMaryCount();
        self.m_pLbCount:setString(string.format(LuaUtils.getLocalString("WATER_9"),count));
    end
    if (self.m_pLbWin)then
    
        local curAwardGold = WaterMarginDataMgr.getInstance():getLittleMaryAwardGold();
        local strGold = self:getFormatGold(curAwardGold)
        --local strWin = string.format("中奖:%s", strGold)
        self.m_pLbWin:setString(strGold)
    end
    if (self.m_pLbWinAmount)then
    
        local curAwardGold = WaterMarginDataMgr.getInstance():getTotalAwardGold();
        local strGold = self:getFormatGold(curAwardGold)
        --local strWin = string.format("总中奖:%s", strGold)
        self.m_pLbWinAmount:setString(strGold)
    end
end


function LittleMaryLayer:getFormatComma(goldNo)
    return self:getFormatGold(goldNo)
end

--格式化金钱显示
function LittleMaryLayer:getFormatGold(goldNo)
--   goldNo = goldNo / 100
--   goldNo = string.format("%.2f",goldNo)
--   return goldNo
    return LuaUtils.getFormatGoldAndNumber(goldNo)
end

return LittleMaryLayer

--endregion
