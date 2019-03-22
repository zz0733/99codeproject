--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local ExternalFun       = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local module_pre        = "game.yule.pjl.src.views"
local WaterMarginDataMgr            = appdf.req(module_pre..".manager.WaterMarginDataMgr")
--local AudioManager                = require("common.manager.AudioManager")
--local FloatMessage                = require("common.layer.FloatMessage")
--local CMsgWaterMargin             = appdf.req(module_pre..".proxy.CMsgWaterMargin")
local WaterMarginCompareResultLayer = appdf.req(module_pre..".layer.WaterMarginCompareResultLayer")
local WaterMarginScene_Events       = appdf.req(module_pre..".scene.WaterMarginSceneEvent")

local scheduler             = cc.exports.scheduler
local PATH_UI_WATER_COMPARE_RESULT = "game/watermargin/WaterMarginUi_compare.json"

local BUY_FAIL  = -1
local BUY_SMALL = 0
local BUY_TIE   = 1
local BUY_BIG   = 2

local Dealer_Wait   = 1 --待机
local Dealer_Happy  = 2 --开心
local Dealer_Angry  = 3 --生气
local Dealer_Cry    = 4 --哭了
local Dealer_Shake  = 5 --摇色子
local Dealer_Open   = 6 --揭开盖子

--玩家不操作倒计时时间间隔
local GAME_COUNT_TIME_GAPS  = 10.0

local WaterMarginCompareView = class("WaterMarginCompareView", cc.Layer)      

WaterMarginCompareView.instance_ = nil
--function WaterMarginCompareView.create(scene_)
--    WaterMarginCompareView.instance_ = WaterMarginCompareView.new(scene_)
--    return WaterMarginCompareView.instance_
--end

function WaterMarginCompareView:getChildByUIName(root,name)
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

function WaterMarginCompareView:ctor(scene_)
    self._scene = scene_

    self:enableNodeEvents()
end    

function WaterMarginCompareView:onEnter()
    self:init()

    self.m_pUpdateGlobal = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.update),1,false)
end

function WaterMarginCompareView:update(tDelta)

    if(self.isSelectedCompare)then
        return;
    end
    
    self.m_fCountDownTime = self.m_fCountDownTime - tDelta;
    
    if(self.m_fCountDownTime <= 0.0)then
        self:playSystemSoundTips(0);
        self.m_fCountDownTime = GAME_COUNT_TIME_GAPS;
    end
end

function WaterMarginCompareView:playSystemSoundTips(value)
    
    local randVal = math.random(1,5)
    self.m_nWaitSoundId = ExternalFun.playSoundEffect(string.format("game/watermargin/sound/sound_water_compare_wait%d.mp3", randVal));
end

function WaterMarginCompareView:onExit()

    if self.m_pUpdateGlobal then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_pUpdateGlobal)
    end

    if self.m_shakeUpdate then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_shakeUpdate)
        self.m_shakeUpdate = nil
    end

    SLFacade:removeEventListener(self.m_onMsgCompareResult)
    SLFacade:removeEventListener(self.m_onMsgExitCompare)

    self:cleanViewEffectAction();
    
--    AudioManager.getInstance():stopSound(self.m_nWaitSoundId)
    SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_RESUME_SCENE1_MUSIC)
    WaterMarginCompareView.instance_ = nil
end

function WaterMarginCompareView:cleanViewEffectAction()
    for i = 1, tonumber(#self.m_vEffectPath), 1 do 
        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(self.m_vEffectPath[i])
    end
    
    self.m_vEffectPath={}
end

function WaterMarginCompareView:init()
   self:initVars()
   -- 加载UI
   self.m_pUI = cc.CSLoader:createNode("game/watermargin/WaterCompare.csb")
   self.m_pUI:addTo(self)

   self.m_rootUI = self:getChildByUIName(self.m_pUI, "Panel")
   self.m_rootUI:setPosition((145 - (1624 - display.width) / 2), 0)

   print("---加载UI成功")

   -- 初始化CCS
   self:initCCS()
   print("---初始化CCS成功")
end

function WaterMarginCompareView:initVars()
    self.m_pBtnLittle = nil
    self.m_pBtnBig = nil
    self.m_pBtnEquipe = nil
    self.m_pBtnExitGame = nil
    
    self.m_pEffectNode = nil
    self.m_pDiceNode = nil
    self.m_pNodeTop = nil

    self.m_pUsrSelectNode = {}
    for i = 1, tonumber(3),1 do 
        self.m_pUsrSelectNode[i] = nil
    end
    
    self.m_pLbUsrTotalAwardGold = nil
    
    self.m_pSprRope = nil
    
    self.m_pSprResultsArea = {}
    for i = 1, tonumber(3),1 do 
        self.m_pSprResultsArea[i] = nil
    end
    
    self.m_nCurBetNum = 0
    self.m_nCurSelcetBuyType = BUY_FAIL
    
    self.m_vEffectPath = {}
    
    self.isSelectedCompare = true
    self.m_fCountDownTime = GAME_COUNT_TIME_GAPS
    
    self.m_nWaitSoundId = 0

    self:show()
end

function WaterMarginCompareView:initCCS()
   --初始化 UI 变量
   self:onAssignCCBMemberVariable()    
   --监听按钮
   self:onResolveCCBCCControlSelector()

   self:onNodeLoaded()

   --加载其他onEnter
   self:initOther();
end

function WaterMarginCompareView:initOther()


    self.m_onMsgCompareResult = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_UPDATE_WATER_SCENE2_RESULT, handler(self, self.onMsgCompareResult))--

    self.m_onMsgExitCompare = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_RETURN_GAME_SCENE1, handler(self, self.onMsgExitCompare))--
end

function WaterMarginCompareView:onMsgExitCompare()
    self:removeFromParent()
    print("------------------回到主场景1(子游戏中断网)")
end

function WaterMarginCompareView:onMsgCompareResult()--------------------

    local parserCompareResultInfo =  WaterMarginDataMgr.getInstance():getParserCompareResultInfo()
    if(parserCompareResultInfo.iType == BUY_FAIL)then
        return
    end
    
    self.m_pUsrSelectNode[self.m_nCurSelcetBuyType+1]:setVisible(true)
    self:updateButtonByStatus(false)
    self:resetPlayResultEffectInfo()
    self:showDealerEffect(Dealer_Shake)
    ExternalFun.playSoundEffect("game/watermargin/sound/sound_water_compare_rock.mp3")
end

function WaterMarginCompareView:resetPlayResultEffectInfo()

    self.m_pDiceNode:removeAllChildren()
    self.m_pEffectNode:removeAllChildren()
end

function WaterMarginCompareView:onAssignCCBMemberVariable()

    self.m_pBtnLittle = self:getChildByUIName(self.m_pUI, "m_pBtnLittle") 
    self.m_pBtnBig = self:getChildByUIName(self.m_pUI, "m_pBtnBig") 
    self.m_pBtnEquipe = self:getChildByUIName(self.m_pUI, "m_pBtnEquipe") 
    self.m_pBtnExitGame = self:getChildByUIName(self.m_pUI, "m_pBtnExitGame") 
    self.m_pBtnContinuGame = self:getChildByUIName(self.m_pUI, "m_pBtnContinuGame") 
    
    self.m_pEffectNode = self:getChildByUIName(self.m_pUI, "m_pNodeEffect") 
    self.m_pDiceNode = self:getChildByUIName(self.m_pUI, "m_pNodeDice") 
    self.m_pNodeTop = self:getChildByUIName(self.m_pUI, "m_pNodeTop") 
    

    for i = 1, tonumber(3),1 do 
        self.m_pUsrSelectNode[i] = self:getChildByUIName(self.m_pUI,string.format("m_pSprGoldIngot%d",i-1))
    end

    self.m_pLbUsrTotalAwardGold = self:getChildByUIName(self.m_pUI, "m_pLbUsrTotalAwardGold") 
    self.m_pLbUsrTotalBet = self:getChildByUIName(self.m_pUI, "m_pLbUsrTotalBet") 

    self.m_pSprRope = self:getChildByUIName(self.m_pUI, "m_pSprRope") 
    
    for i = 1, tonumber(3),1 do 
        self.m_pSprResultsArea[i] = self:getChildByUIName(self.m_pUI,string.format("m_pSprResult%d",i-1))
    end


    self.m_pTalkPanel = self:getChildByUIName(self.m_pUI, "m_pTalkPanel") 
    self.m_pTalkContent = self:getChildByUIName(self.m_pUI, "m_pTalkContent") 

    return true
end

function WaterMarginCompareView:onResolveCCBCCControlSelector() ----押大押小 买定离手

    -- onSelecttLittleCallBack -- 选择押小 --
    local onSelecttLittleCallBack = function (sender,eventType)

       if eventType ~= ccui.TouchEventType.ended then
            return
       end

       --清除箭头指示动画
       for i=1, 3 do
            if self.m_pArmArrowTip[i] then 
                self.m_pArmArrowTip[i]:removeFromParent()
                self.m_pArmArrowTip[i] = nil
            end
       end

       --解决bug 1524
       self.m_pBtnExitGame:setEnabled(false)

        if(self.isSelectedCompare)then
            return;
        end

        ExternalFun.playSoundEffect("game/watermargin/sound/sound_water_compare_bt.mp3")
    
        self.m_nCurSelcetBuyType = BUY_SMALL
        self:begineCountDown(true)
        
        self._scene:sendDice(2)
--        CMsgWaterMargin.getInstance():sendMsgCompareBet(BUY_SMALL,self.m_nCurBetNum);      

    end    
    self.m_pBtnLittle:addTouchEventListener(onSelecttLittleCallBack)
    -- onSelecttLittleCallBack -- 选择押小 结束--

    -- onSelectBigCallBack -- 选择押大 --
    local onSelectBigCallBack = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end
       
       --清除箭头指示动画
       for i=1, 3 do
            if self.m_pArmArrowTip[i] then 
                self.m_pArmArrowTip[i]:removeFromParent()
                self.m_pArmArrowTip[i] = nil
            end
       end

       --解决bug 1524
       self.m_pBtnExitGame:setEnabled(false)

        if(self.isSelectedCompare)then
            return;
        end

        ExternalFun.playSoundEffect("game/watermargin/sound/sound_water_compare_bt.mp3")
    
        self.m_nCurSelcetBuyType = BUY_BIG
        self:begineCountDown(true)

        self._scene:sendDice(1)
--        CMsgWaterMargin.getInstance():sendMsgCompareBet(BUY_BIG,self.m_nCurBetNum);  
    end    
    self.m_pBtnBig:addTouchEventListener(onSelectBigCallBack)
    -- onSelectBigCallBack -- 选择押大 结束--

    -- onSelectEquipCallBack -- 选择押和 --
    local onSelectEquipCallBack = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end

       --清除箭头指示动画
       for i=1, 3 do
            if self.m_pArmArrowTip[i] then 
                self.m_pArmArrowTip[i]:removeFromParent()
                self.m_pArmArrowTip[i] = nil
            end
       end

       --解决bug 1524
       self.m_pBtnExitGame:setEnabled(false)

        if(self.isSelectedCompare)then
            return;
        end

        ExternalFun.playSoundEffect("game/watermargin/sound/sound_water_compare_bt.mp3")
    
        self.m_nCurSelcetBuyType = BUY_TIE
        self:begineCountDown(true)
        
        self._scene:sendDice(3)
--        CMsgWaterMargin.getInstance():sendMsgCompareBet(BUY_TIE,self.m_nCurBetNum)     
    end    
    self.m_pBtnEquipe:addTouchEventListener(onSelectEquipCallBack)
    -- onSelectEquipCallBack -- 选择押和 结束--

    -- onExitGameCallBack --
    local onExitGameCallBack = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end
       self:onExitGameCallBack()
       ExternalFun.playSoundEffect("res/public/sound/sound-close.mp3")
    end    
    self.m_pBtnExitGame:addTouchEventListener(onExitGameCallBack)
    -- onExitGameCallBack --

end

function WaterMarginCompareView:onNodeLoaded()

    if(WaterMarginDataMgr.getInstance():getIsAuto())then
        --进入子游戏界面停止主界面自动
        SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_STOP_WATER_SCENE1_AUTO)
    end
    --//暂停主游戏背景音乐
    SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_PAUSE_SCENE1_MUSIC)

    self.m_pArmArrowTip = {}
    local m_pArmPos = { cc.p(300, 255),cc.p(667, 255),cc.p(990, 255) }
    --箭头指示动画
    for i=1, 3 do
--        self.m_pArmArrowTip[i] = Effect.getInstance():creatEffectWithDelegate2(self.m_rootUI,
--                                                   "jiantoulv",
--                                                   "Animation1",
--                                                   false,m_pArmPos[i],G_CONSTANTS.Z_ORDER_COMMON)
        self.m_pArmArrowTip[i] = ccs.Armature:create("jiantoulv")
        self.m_pArmArrowTip[i]:setPosition(m_pArmPos[i])
	    self.m_pArmArrowTip[i]:addTo(self.m_rootUI,50)
	    self.m_pArmArrowTip[i]:getAnimation():play("Animation1")
    end
    
    
    self:addEffectData()
    self:initPlayerInfo()
    self:updateButtonByStatus(true)
    self:showDealerEffect(Dealer_Wait)
    self:begineCountDown(false)

    self:initRope()
end

function WaterMarginCompareView:begineCountDown(isSelect)
    self.isSelectedCompare = isSelect;
    self.m_fCountDownTime = GAME_COUNT_TIME_GAPS;
end

function WaterMarginCompareView:showDealerEffect(iState)

    self.m_pEffectNode:removeAllChildren()
    
    local winSize = cc.Director:getInstance():getWinSize()
    local vecActionPos = cc.p(667, 375 + 155)

    local strMovementId = string.format("Animation%d",iState)
    print("播放动画 "..strMovementId)
--    local pArmature = Effect.getInstance():creatEffectWithDelegate2(self.m_pEffectNode,
--                                                   "heguandonghua_shuihuzhuan",
--                                                   strMovementId,
--                                                   true,vecActionPos,G_CONSTANTS.Z_ORDER_COMMON)
    local pArmature = ccs.Armature:create("heguandonghua_shuihuzhuan")      --这里有个true？？？？？？？？？？？？？？？
    pArmature:setPosition(vecActionPos)
	pArmature:addTo(self.m_pEffectNode,50)
	pArmature:getAnimation():play(strMovementId)

    if(pArmature==nil)then
        return;
    end


    pArmature:setTag(iState)
    if(Dealer_Wait ~= iState)then

        local animationEvent = function (armatureBack,movementType,movementID)
            if movementType == ccs.MovementEventType.complete then
                self:playEffectEnd(armatureBack)
            end
        end
        pArmature:setName("heguandonghua_shuihuzhuan")
        pArmature:getAnimation():setMovementEventCallFunc(animationEvent)    
        
        --pArmature->getAnimation()->setMovementEventCallFunc(std::bind(&WaterMarginCompareView::playEffectEnd, this, pArmature, cocostudio::MovementEventType::COMPLETE, "heguandonghua_shuihuzhuan"));
        
        if(Dealer_Open == iState)then
        --揭开盖子显示骰子回调

            local callback = cc.CallFunc:create(function ()
                self:onShowDiceInfo()
            end)
            local seq = cc.Sequence:create(cc.DelayTime:create(0.6), callback)
            self:runAction(seq)
        end
    end
end

function WaterMarginCompareView:onShowDiceInfo()

    local dicePoint = WaterMarginDataMgr.getInstance():getParserCompareResult()
    local diceInfo = WaterMarginDataMgr.getInstance():getParserCompareResultInfo()
    
    local sumVal = dicePoint.height+dicePoint.low
    ExternalFun.playSoundEffect(string.format("game/watermargin/sound/sound_water_compare_point%d.mp3",sumVal))
    
    --/create  small dice
    local winSize = cc.Director:getInstance():getWinSize()
    local pDice1 = cc.Sprite:createWithSpriteFrameName(string.format("game/watermargin/images/gui-water-dice-%d.png",dicePoint.height))
    local pDice2 = cc.Sprite:createWithSpriteFrameName(string.format("game/watermargin/images/gui-water-dice-%d.png",dicePoint.low))
    pDice1:setPosition(cc.p(667 - 22, 375 - 55))
    pDice2:setPosition(cc.p(667 + 13.5, 375 - 60))
    
    self.m_pDiceNode:addChild(pDice1,51,10000)
    self.m_pDiceNode:addChild(pDice2,51,10001)
   
    --create  big dice
    pDice1 = cc.Sprite:createWithSpriteFrameName(string.format("game/watermargin/images/gui-water-big-dice%d.png",dicePoint.height))
    pDice2 = cc.Sprite:createWithSpriteFrameName(string.format("game/watermargin/images/gui-water-big-dice%d.png",dicePoint.low))
    pDice1:setPosition(cc.p(245.0-pDice1:getContentSize().width*0.5+390*diceInfo.iType, 200))
    pDice2:setPosition(cc.p(245.0+pDice2:getContentSize().width*0.5+390*diceInfo.iType, 200))
    
    self.m_pDiceNode:addChild(pDice1,51,10002)
    self.m_pDiceNode:addChild(pDice2,51,10003)
    
    --当揭盖动画结束关盖隐藏蛊中骰子
    local dttinme = 1.4
    if self.m_nCurSelcetBuyType == diceInfo.iType then
        dttinme = 1.9
    end

    local callback = cc.CallFunc:create(function ()
        self:onHideDiceInfo()
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(dttinme), callback)
    self:runAction(seq)

end

function WaterMarginCompareView:onHideDiceInfo()

    if(self.m_pDiceNode== nil or (0 == self.m_pDiceNode:getChildrenCount()))then
        return
    end
    
    for i = 1, tonumber(2),1 do 
        local pSmallDice = self.m_pDiceNode:getChildByTag(10000+(i-1))
        if(pSmallDice)then
            pSmallDice:setVisible(false)
        end
    end


end


function WaterMarginCompareView:playEffectEnd(armature)

    if(armature == nil)then
        return;
    end
    
    local strEffecName = armature:getName()
    local armatureTagId = armature:getTag()
    
    if(strEffecName == "heguandonghua_shuihuzhuan")then
    
        if((armatureTagId == Dealer_Shake) or (armatureTagId == Dealer_Open))then
            armature:removeFromParent()
        end
        
        if armatureTagId == Dealer_Shake then --//摇骰子结束
            self:showDealerEffect(Dealer_Open)
            self:showTableShakeEffect()

            local pAction = cc.JumpBy:create(0.2, cc.p(0, 0), 40, 1)
            self.m_pUsrSelectNode[self.m_nCurSelcetBuyType+1]:runAction(pAction) --震动一下

        elseif armatureTagId == Dealer_Open then --//打开蛊(盖子)结束
            self:updateShowServerReulst()
            self:showOpenBoxEffect()
            self:updateAwardGoldChange()

            self.m_pBtnExitGame:setEnabled(true) --打开盖子可以退出

        elseif armatureTagId == Dealer_Cry or  armatureTagId == Dealer_Angry or  armatureTagId == Dealer_Happy  then
            --print("笑 生气 哭 "..armatureTagId)
            local callback = cc.CallFunc:create(function ()
                self:isResumeWaitState()
            end)
            local seq = cc.Sequence:create(cc.DelayTime:create(1.0), callback) --等待1秒进行下一局
            self.m_pEffectNode:runAction(seq)
        end

    elseif(strEffecName == "zhuozidoudong_shuihuzhuan")then
        armature:removeFromParent();
    end
end

function WaterMarginCompareView:isResumeWaitState(time)

    local parserCompareResultInfo =  WaterMarginDataMgr.getInstance():getParserCompareResultInfo()
    print("押注 = "..self.m_nCurSelcetBuyType.." 服务器开奖 = "..parserCompareResultInfo.iType)    

    self.m_pEffectNode:stopAllActions()
    if(self.m_nCurSelcetBuyType == parserCompareResultInfo.iType)then
        self.m_pDiceNode:removeAllChildren()
        self:updateButtonByStatus(true)
        self:showDealerEffect(Dealer_Wait)
        self:begineCountDown(false)
        
        for i = 1, tonumber(3),1 do
            self.m_pSprResultsArea[i]:setVisible(false)
            self.m_pUsrSelectNode[i]:setVisible(false)
        end

    else
        self:onExitGameCallBack()
    end
end

function WaterMarginCompareView:onExitGameCallBack()

--    CMsgWaterMargin.getInstance():sendMsgGameStop()
    SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_UPDATE_WATER_GAME_END) 
    
    --水浒传中其他界面提示主界面更新金币
    SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_UPDATE_USER_SCORE_OTHER_VIEW)
    self:hide()
end

function WaterMarginCompareView:show()
    self:stopAllActions()
    self:setScale(0.0)
    local show = cc.Show:create()
    local scaleTo = cc.ScaleTo:create(0.4, 1.0)
    local ease = cc.EaseBackOut:create(scaleTo)
    local seq = cc.Sequence:create(show,ease)
    self:runAction(seq)
end

function WaterMarginCompareView:hide()
    local moveTo = cc.MoveTo:create(0.2,cc.p(-2000,0))
    local callback = cc.CallFunc:create(function ()
            self:removeFromParent()
        end)
    self:runAction(cc.Sequence:create(moveTo, callback))
end

function WaterMarginCompareView:updateAwardGoldChange()

    if(self.m_pLbUsrTotalAwardGold == nil)then
        return
    end

    local compareScene2Gold = WaterMarginDataMgr.getInstance():getGameCompareAwardGold()    --比倍结束身上的钱
    local lastUserScore = WaterMarginDataMgr.getInstance():getGameResultLast().llResultMoney    --上局游戏的钱
    local nCurrentBetMoney = WaterMarginDataMgr.getInstance():getCurTotalBetNum()  --单局总押注
    local gameWinScene2Gold = compareScene2Gold - (lastUserScore - nCurrentBetMoney)     --中奖金额
    
    if(gameWinScene2Gold == 0)then
        self.m_nCurBetNum = WaterMarginDataMgr.getInstance():getGameCompareBet() * -1    --比倍以后
    else
        self.m_nCurBetNum = gameWinScene2Gold
    end
    
    local displayNum = self.m_nCurBetNum
    if self.m_nCurBetNum < 0 then
         displayNum = 0
    end
    WaterMarginDataMgr.getInstance():setGameCompareBet( displayNum )

    self.m_pLbUsrTotalAwardGold:setString(self:getFormatGold(displayNum))   --中奖金额
    self.m_pLbUsrTotalBet:setString(self:getFormatGold(displayNum))         --押注

end


function WaterMarginCompareView:showOpenBoxEffect()

    local parserCompareResultInfo =  WaterMarginDataMgr.getInstance():getParserCompareResultInfo()
    print("押注 = "..self.m_nCurSelcetBuyType.." 服务器开奖 = "..parserCompareResultInfo.iType)    
    if(self.m_nCurSelcetBuyType == parserCompareResultInfo.iType)then
        self:showResultGoldChangeEffect(true)
        local randVal = math.random(1,2)-1

        if (randVal == 0)then
            self:showDealerEffect(Dealer_Cry)
        else
            self:showDealerEffect(Dealer_Angry)
        end

        ExternalFun.playSoundEffect("game/watermargin/sound/sound_water_compare_win.mp3")
    else
        self:showResultGoldChangeEffect(false);
        self:showDealerEffect(Dealer_Happy);
        ExternalFun.playSoundEffect("game/watermargin/sound/sound_water_compare_lose.mp3")
    end
    
    self:setShowCompareResultList()
    self:playFlyWordsTips()
end



function WaterMarginCompareView:playFlyWordsTips()

    local parserCompareResultInfo =  WaterMarginDataMgr.getInstance():getParserCompareResultInfo()
    local dicePoint = WaterMarginDataMgr.getInstance():getParserCompareResult()
    
    local iType = parserCompareResultInfo.iType
    local iTotalPoint = dicePoint.height + dicePoint.low

    local isWin = (self.m_nCurSelcetBuyType == iType)
    
    local strType = ""

    if iType == BUY_BIG then
        strType = "敢再来一次吗？"--LuaUtils.getLocalString("WATER_3")
    elseif iType == BUY_SMALL then
        strType = "敢再来一次吗"--LuaUtils.getLocalString("WATER_4")
    elseif iType == BUY_TIE then
        strType = "你赢了"--LuaUtils.getLocalString("WATER_5")
    end

    local strResult = ""

    if isWin then
        strResult = "\n你赢了，\n敢再来一次吗？"--LuaUtils.getLocalString("WATER_6")
    else
        strResult = "\n你输了，\n下次再来试手气吧！"--LuaUtils.getLocalString("WATER_7")
    end
    

    local strFormat = ""--LuaUtils.getLocalString("WATER_2")
    
    self.m_pTalkPanel:setVisible(true)
    self.m_pTalkContent:setVisible(true)
    self.m_pTalkPanel:setOpacity(255)
    self.m_pTalkContent:setOpacity(255)

    self.m_pTalkContent:setString(iTotalPoint..strResult)--string.format(strFormat,iTotalPoint,strType,strResult))



    local pDelay = cc.DelayTime:create(1.3)
    local pFadeout = cc.FadeOut:create(0.8)
    local callBack = cc.CallFunc:create(function ()
        
        self.m_pTalkPanel:setVisible(false)

        
        self.m_pTalkContent:setVisible(false)
    end)
    local squ = cc.Sequence:create(pDelay,pFadeout,callBack)
    self.m_pTalkPanel:runAction(squ:clone())
    self.m_pTalkContent:runAction(squ:clone())
end


function WaterMarginCompareView:showResultGoldChangeEffect(isWin)

    local pNodeGoldChange = cc.Node:create()
    local winSize = cc.Director:getInstance():getWinSize()
    pNodeGoldChange:setPosition(cc.p(winSize.width*0.5,300.0))
    self:addChild(pNodeGoldChange,100)
    
    --number
    local filePath = ""
    if isWin then
        filePath = "game/watermargin/font/wintext.fnt"
    else
        filePath = "game/watermargin/font/losetext.fnt"
    end

    local compareScene2Gold = WaterMarginDataMgr.getInstance():getGameCompareAwardGold()    --比倍结束身上的钱
    local lastUserScore = WaterMarginDataMgr.getInstance():getGameResultLast().llResultMoney    --上局游戏的钱
    local nCurrentBetMoney = WaterMarginDataMgr.getInstance():getCurTotalBetNum()  --单局总押注
    local piaoMoney = compareScene2Gold - (lastUserScore - nCurrentBetMoney)
    local strGold = self:getFormatGold(piaoMoney)       --飘的分数
    if isWin then
        strGold = "胜 +"..strGold
    else
        strGold = "败 "..WaterMarginDataMgr.getInstance():getGameCompareBet()
    end

    local m_pBMLevel = cc.LabelBMFont:create(strGold,filePath)
    m_pBMLevel:setAnchorPoint(cc.p(0.5,0.5))
    pNodeGoldChange:addChild(m_pBMLevel)
    
    --move action
    local move = cc.MoveBy:create(0.2, cc.p(0.0,100.0))
    local pFadein = cc.FadeIn:create(0.2)
    local pDelay = cc.DelayTime:create(3.0)
    local pFadeout = cc.FadeOut:create(0.8)
    local callBack = cc.CallFunc:create(function ()
        pNodeGoldChange:removeFromParent()
    end)

    local pSeq = cc.Sequence:create(cc.Spawn:create(pFadein,move),pDelay,pFadeout,callBack)
    pNodeGoldChange:runAction(pSeq)
end

function WaterMarginCompareView:setShowCompareResultList()

    self:initRope()
end


function WaterMarginCompareView:initRope()

    self.m_pNodeTop:removeAllChildren()

    local result = WaterMarginDataMgr.getInstance().vecCompareResult
    local count = #result
    local showMaxNum = 10
    local startIndex = count - showMaxNum + 1
    local endIndex = count
    
    for i = startIndex, endIndex do
        local m_pCelllayer = WaterMarginCompareResultLayer:create()
        m_pCelllayer:setTag(i)
        m_pCelllayer:addTo(self.m_pNodeTop)
        
        local posX = 40 + 60 * (i - startIndex) 
        local posY = 710

        m_pCelllayer:setAnchorPoint(cc.p(0,0))
        m_pCelllayer:setPosition(posX, posY)
        m_pCelllayer:setShowResultIcon(result[i])
        m_pCelllayer:setShowNewIconVisible((i == count))  
    end
end

function WaterMarginCompareView:updateShowServerReulst()

    local parserCompareResultInfo =  WaterMarginDataMgr.getInstance():getParserCompareResultInfo()
    
    if(parserCompareResultInfo.iType >= BUY_SMALL and parserCompareResultInfo.iType <= BUY_BIG)then
        self.m_pSprResultsArea[parserCompareResultInfo.iType+1]:setVisible(true)
    end
end

function WaterMarginCompareView:showTableShakeEffect()

    local winSize = cc.Director:getInstance():getWinSize()
    local vecActionPos = cc.p(667, 252)
--    local pArmature = Effect.getInstance():creatEffectWithDelegate2(self.m_pEffectNode,
--                                                                         "zhuozidoudong_shuihuzhuan",
--                                                                         "Animation1",
--                                                                         true,vecActionPos,G_CONSTANTS.Z_ORDER_COMMON-1);
    local pArmature = ccs.Armature:create("zhuozidoudong_shuihuzhuan")      --这里有个true？？？？？？？？？？？？？？？
    pArmature:setPosition(vecActionPos)
	pArmature:addTo(self.m_pEffectNode,49)
	pArmature:getAnimation():play("Animation1")
    if(pArmature == nil)then
        return
    end


    local animationEvent = function (armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            self:playEffectEnd(armatureBack)
        end
    end
    pArmature:setName("zhuozidoudong_shuihuzhuan")
    pArmature:getAnimation():setMovementEventCallFunc(animationEvent)   

end

function WaterMarginCompareView:updateButtonByStatus(isEnable)

    self.m_pBtnLittle:setEnabled(isEnable)
    self.m_pBtnBig:setEnabled(isEnable)
    self.m_pBtnEquipe:setEnabled(isEnable)
    self.m_pBtnExitGame:setEnabled(isEnable)
    
    if(isEnable) then
        self.m_nCurSelcetBuyType = BUY_FAIL;
    end
end

function WaterMarginCompareView:addEffectData()

    local paths = {};
    table.insert(paths,"game/watermargin/effect/heguandonghua_shuihuzhuan/heguandonghua_shuihuzhuan.ExportJson")
    table.insert(paths,"game/watermargin/effect/zhuozidoudong_shuihuzhuan/zhuozidoudong_shuihuzhuan.ExportJson")

    self.m_vEffectPath = paths;
    for i = 1, tonumber(#paths),1 do 
        local manager = ccs.ArmatureDataManager:getInstance()
        manager:addArmatureFileInfo(paths[i])
    end

end


function WaterMarginCompareView:initPlayerInfo()

    --self.m_pSprRope:setVisible(false)
    for i = 1, tonumber(3),1 do 
        self.m_pSprResultsArea[i]:setVisible(false)
        self.m_pUsrSelectNode[i]:setVisible(false)
    end

    local gameWinResult = WaterMarginDataMgr.getInstance():getGameResult()
    self.m_nCurBetNum = gameWinResult.llResultScore         --押注的钱（转动得的钱）
    self.m_pLbUsrTotalAwardGold:setString("0")              --中奖金额
    self.m_pLbUsrTotalBet:setString(self:getFormatGold(self.m_nCurBetNum))
end


--格式化金钱显示
function WaterMarginCompareView:getFormatGold(goldNo)
    local gold = tonumber(goldNo) or 0
    local strFormatGold = string.format("%d.%02d", (gold/100), (math.abs(gold)%100))
    if -100 < gold and gold < 0 then
        strFormatGold = "-" .. strFormatGold
    end
    return goldNo--strFormatGold
end

return WaterMarginCompareView

--endregion
