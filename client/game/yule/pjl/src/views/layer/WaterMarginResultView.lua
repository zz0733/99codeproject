--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local ExternalFun               = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local module_pre = "game.yule.pjl.src.views"
local WaterMarginScene_Events   = appdf.req(module_pre..".scene.WaterMarginSceneEvent")
local WaterMarginDataMgr        = appdf.req(module_pre..".manager.WaterMarginDataMgr")
--local AudioManager              = appdf.req("common.manager.AudioManager")
local WaterMarginResultView     = class("WaterMarginResultView", cc.Layer)

local WIN_ALL_NOT = -1       --//没有全屏
local WIN_ALL_MIX_ROLE = 9   --//所有人物混合
local WIN_ALL_MIX_WEAPON  = 10    -- //所有武器混合

local PATH_UI_WATER_RESULT = "game/watermargin/WaterMarginUi_result.json"

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

local BgAction_Open = 1         --展开背景
local BgAction_Close = 2           --关闭背景

WaterMarginResultView.instance_ = nil
function WaterMarginResultView.create()
    WaterMarginResultView.instance_ = WaterMarginResultView.new()
    return WaterMarginResultView.instance_
end

function WaterMarginResultView:getChildByUIName(root,name)
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

function WaterMarginResultView:ctor()
    self:enableNodeEvents()
end    

function WaterMarginResultView:onEnter()
    self:init()
    --self:setVeilAlpha(100)
    self:show()
    self.m_pLoopMsgHandler  = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.updateLabelBMResult), 0.05, false)
end

function WaterMarginResultView:onExit()
    if self.m_pLoopMsgHandler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_pLoopMsgHandler)
        self.m_pLoopMsgHandler = nil
    end
    WaterMarginResultView.instance_ = nil
end

-- 弹出
function WaterMarginResultView:show()
    local pNode = self:getChildByUIName(self.m_pUI, "Panel")
    if (pNode ~= nil)then
        self.isAnimoEnd = false
        pNode:stopAllActions()
        pNode:setScale(0.0)
        local show = cc.Show:create()
        local scaleTo = cc.ScaleTo:create(0.4, 1.0)
        local ease = cc.EaseBackOut:create(scaleTo)
        local callback = cc.CallFunc:create(function ()
            self.isAnimoEnd = true
        end)
        local seq = cc.Sequence:create(show,ease,callback)
        pNode:runAction(seq)
    end
end

-- 弹出
function WaterMarginResultView:hide()
    self.isAnimoEnd = false
    local pNode = self:getChildByUIName(self.m_pUI, "Panel")
    pNode:stopAllActions()
    pNode:setScale(1.0)
    local scaleTo = cc.ScaleTo:create(0.4, 0.0)
    local ease = cc.EaseBackIn:create(scaleTo)
    local delay = cc.DelayTime:create(3)
    local callback = cc.CallFunc:create(function ()
        self.isAnimoEnd = true
        self:removeFromParent()
    end)
    local seq = cc.Sequence:create(ease, callback)
    pNode:runAction(seq)
end

function WaterMarginResultView:cleanViewEffectAction()
    for i=1,tonumber(#self.m_vEffectPath),1 do 
        local manager = ccs.ArmatureDataManager:getInstance()
        manager:removeArmatureFileInfo(self.m_vEffectPath[i])
    end
    self.m_vEffectPath = {}
end

function WaterMarginResultView:init()
    self:initVars()

   -- 加载UI
   self.m_pUI = cc.CSLoader:createNode("game/watermargin/WaterResult.csb")
   self:addChild(self.m_pUI)
   self.m_pUI:setPosition((145 - (1624 - display.width) / 2), 0)

   self.m_rootUI = self:getChildByUIName(self.m_pUI, "Panel")
   --self.m_rootUI:setAnchorPoint(0.5, 0.5)
   --self.m_rootUI:setPosition(display.cx, display.cy)

   self.m_pResultList = self:getChildByUIName(self.m_pUI, "ScrollView_result")
   self.m_pResultList:setScrollBarEnabled(false)
   self.m_pResultList:addEventListener(handler(self, self.onScrollEvent))
   print("---加载UI成功")

   -- 初始化CCS
   self:initCCS()
   print("---初始化CCS成功")
end

function WaterMarginResultView:initVars()

    self.m_pLbResultScore = nil
    self.m_pBtnCompare = nil
    self.m_pBtnExit = nil
    self.m_pBtnReturnClicked = nil
    self.m_pJianTouLeftArmutre = nil
    self.m_pJianTouRightArmutre = nil
    self.m_bExiting = false
    self.m_bWinChangeScore = false
    self.m_llWinSubScore  = 0
    self.m_pArmBigPrize = nil
end

function WaterMarginResultView:initCCS()
   --初始化 UI 变量
   self:onAssignCCBMemberVariable()    
   --监听按钮
   self:onResolveCCBCCControlSelector()

   self:onNodeLoaded()
end

function WaterMarginResultView:setCannotCompare()
--    self.m_pBtnCompare:setTouchEnabled(false)
--    self.m_pBtnCompare:setColor(cc.c3b(125,125,125))
    self.m_pBtnCompare:setEnabled(false)
end

function WaterMarginResultView:onAssignCCBMemberVariable() 

    self.m_pLbResultScore = self:getChildByUIName(self.m_pUI, "m_pLbResultScore") 
    self.m_pBtnCompare = self:getChildByUIName(self.m_pUI, "m_pBtnCompare") 
    self.m_pBtnExit = self:getChildByUIName(self.m_pUI, "m_pBtnExit") 
    self.m_pBtnReturnClicked = self:getChildByUIName(self.m_pUI, "m_pBtnReturnClicked") 
    self.m_pNodeEffect = self:getChildByUIName(self.m_pUI, "m_pNodeEffect") 
    self.m_pBtnCompare2 = self:getChildByUIName(self.m_pUI, "m_pBtnCompare_0") 
    self.m_pBtnExit2 = self:getChildByUIName(self.m_pUI, "m_pBtnExit_0") 
    self.m_pListBg = self:getChildByUIName(self.m_pUI, "m_pListBg") 
    return true
end

function WaterMarginResultView:onResolveCCBCCControlSelector()

    -- onCompareClicked --
    local onCompareClicked = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end
       print("进入比倍——————————")
        ExternalFun.playSoundEffect("res/public/sound/sound-button.mp3")
        if not self.isAnimoEnd then return end
        --进入比倍
        SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_ENTER_COMPARE)
        self:clearEnd()
        self:hide()
    end    
    self.m_pBtnCompare:addTouchEventListener(onCompareClicked)

    local onCompareClicked2 = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end
       
        ExternalFun.playSoundEffect("res/public/sound/sound-button.mp3")
        --进入比倍
        SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_ENTER_COMPARE)
        self:clearEnd()
        self:hide()
    end    
    self.m_pBtnCompare2:addTouchEventListener(onCompareClicked2)
    -- onCompareClicked --

    -- onExitClicked --
    local onExitClicked = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end
       print("收分————————")
       ExternalFun.playSoundEffect("res/public/sound/sound-close.mp3")
       if not self.isAnimoEnd then return end
       self:instantEndGame()
    end    
    self.m_pBtnExit:addTouchEventListener(onExitClicked)

    local onExitClicked2 = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end

       ExternalFun.playSoundEffect("res/public/sound/sound-close.mp3")
       self:instantEndGame()
    end    
    self.m_pBtnExit2:addTouchEventListener(onExitClicked2)
    -- onExitClicked --
    
    -- onReturnClicked --
    local onInstantEndClicked = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end
       ExternalFun.playSoundEffect("res/public/sound/sound-close.mp3")
       if not self.isAnimoEnd then return end
       self:instantEndGame()
    end    
    self.m_pBtnReturnClicked:addTouchEventListener(onInstantEndClicked)
    -- onReturnClicked --       

end

function WaterMarginResultView:instantEndGame()

    if self.m_bExiting then 
        return
    end
    self.m_bExiting = true
    if WaterMarginDataMgr.getInstance():getLittleMaryCount() > 0 then
        --跳转小玛丽
        SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_ENTER_LITTLEMARY)
    end
    self:clearEnd()
    self:hide()
end

function WaterMarginResultView:clearEnd()

    SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_INSTANT_FINISH_SCENE1) --不可在onexit里调用
    self.m_pLbResultScore:setVisible(false)
    self.m_rootUI:stopAllActions()
end

function WaterMarginResultView:onNodeLoaded()
    --得分
    local result = WaterMarginDataMgr.getInstance():getGameResult()
    local strWinGold = "+"..result.llResultScore--LuaUtils.getFormatGoldAndNumber(result.llResultScore)
    self.m_pLbResultScore:setString(strWinGold)

    local bBigWin = false

    --有小玛丽隐藏比倍按钮
    local lmCount = WaterMarginDataMgr.getInstance():getLittleMaryCount()
    print("结算  有小玛丽次数：".. lmCount)
    --FloatMessage.getInstance():pushMessageDebug("结算  有小玛丽次数：".. lmCount)
    --动画
    local WinMulti = WaterMarginDataMgr.getInstance():getWinMulti()
    local checkRuslt = WaterMarginDataMgr.getInstance():getWinAllType()
    if WinMulti >= 100 or checkRuslt ~= WIN_ALL_NOT then --大于100或者全屏奖
        ExternalFun.playSoundEffect("game/watermargin/sound/sound_water_bigwin_shuihu.mp3")
        bBigWin = true
        self.m_pLbResultScore:setPositionY(-100)
        self.m_pLbResultScore:setVisible(false)
        self.m_pLbResultScore:setString("+0")
        self.m_pBtnCompare:setVisible(false)
        self.m_pBtnExit:setVisible(false)
        self.m_pBtnExit2:setVisible(false)
        self.m_pBtnCompare2:setVisible(false)
        self.m_pListBg:setVisible(false)
        self.m_pBtnReturnClicked:setEnabled(false)

        self.m_pArmBigPrize = sp.SkeletonAnimation:create("game/watermargin/effect/shuihuzhuan4_dashasifang/shuihuzhuan4_dashasifang.json", 
            "game/watermargin/effect/shuihuzhuan4_dashasifang/shuihuzhuan4_dashasifang.atlas",1)
        self.m_pArmBigPrize:setPosition(667,440)
        self.m_pArmBigPrize:setAnimation(0, "animation1", false)
        self.m_pNodeEffect:addChild(self.m_pArmBigPrize)
        self.m_pArmBigPrize:registerSpineEventHandler(function ( ... )
            self.m_pArmBigPrize:setAnimation(0, "animation2", true)
            self.m_pBtnReturnClicked:setEnabled(true)
        end, sp.EventType.ANIMATION_COMPLETE)
        --结算图标展示
        self:showResultIcon()
    else
        --普通奖
        self.m_pBtnCompare2:setVisible(false)
        self.m_pBtnExit2:setVisible(false)
        self.m_pBtnExit:setVisible(true)
        if lmCount == 0 then
            self.m_pBtnCompare:setVisible(true)
        else
            self.m_pBtnCompare:setVisible(false)
            self.m_pBtnExit:setPosition(cc.p(0, self.m_pBtnExit:getPositionY()))
        end
        self.m_bWinChangeScore = true
        --结算图标展示
        self:showResultIcon()
    end

    --自动关闭
    local callback = cc.CallFunc:create(function ()
        if self.m_bExiting then 
            return
        end
        if WaterMarginDataMgr.getInstance():getIsAuto() then
            self.m_bExiting = true
            self:clearEnd()
            self:hide()
        end
        
--        if WaterMarginDataMgr.getInstance():getLittleMaryCount() > 0 then 
--            if not WaterMarginDataMgr.getInstance():getIsAuto() then
--                self.m_pBtnExit:setVisible(false)
--                --self.m_pBtnExit2:setVisible(false)
--                if self.m_pArmBigPrize ~= nil then
--                    self.m_pArmBigPrize:setVisible(false)
--                end
--                self:clearEnd()
--            end
--            --跳转小玛丽
--            SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_ENTER_LITTLEMARY)
--            self:removeFromParent()
--        end
    end)

    if bBigWin then --开大奖
        local callback2 = cc.CallFunc:create(function ()
            self:bigWinCallBack()
        end)
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), callback2, cc.DelayTime:create(2), callback))
    else
        self:runAction(cc.Sequence:create(cc.DelayTime:create(2.0), callback))
    end

end

function WaterMarginResultView:bigWinCallBack()

    self.m_bWinChangeScore = true
    self.m_pBtnReturnClicked:setEnabled(true)
    self.m_pLbResultScore:setVisible(true)
    self.m_pBtnExit2:setVisible(true)
    local lmCount = WaterMarginDataMgr.getInstance():getLittleMaryCount()
    if lmCount == 0 then
        self.m_pBtnCompare2:setVisible(true)
    else
        self.m_pBtnCompare2:setVisible(false)
        self.m_pBtnExit2:setPosition(cc.p(0, self.m_pBtnExit2:getPositionY()))
    end
    --结算图标展示
    --self:showResultIcon()
end

-- 赢取分数显示
function WaterMarginResultView:updateLabelBMResult()
    if self.m_bWinChangeScore == false then
        return
    end

    local winSocre = WaterMarginDataMgr.getInstance():getGameResult().llResultScore
    if self.m_llWinSubScore >= winSocre then 
        local nResult = winSocre--LuaUtils.getFormatGoldAndNumber(winSocre)
        local strResult = string.format("+ %s", nResult)
        self.m_pLbResultScore:setString(strResult)
        self.m_bWinChangeScore = false
        return
    end
    local subScore =  math.floor(winSocre/20) <= 1 and 1 or math.floor(winSocre/20)
    self.m_llWinSubScore = self.m_llWinSubScore + subScore
    local nResult = self.m_llWinSubScore--LuaUtils.getFormatGoldAndNumber(self.m_llWinSubScore)
    local strResult = string.format("+ %s", nResult)
    self.m_pLbResultScore:setString(strResult)
end

--结算图标x倍数
function WaterMarginResultView:showResultIcon()
    
    self.m_pListBg:setVisible(true)
    local checkRuslt = WaterMarginDataMgr.getInstance():getWinAllType()
    print ("checkRuslt = ",checkRuslt,checkRuslt ~= WIN_ALL_NOT)
    if checkRuslt ~= WIN_ALL_NOT then --全屏奖
       self:showAllWinResultIcon()
    else
       self:showNormalWinResultIcon()
    end
end

--全屏奖
function WaterMarginResultView:showAllWinResultIcon()
    print ("进了全屏-----------------------------")
    self.m_pListBg:setScaleX(1.5)
    if self.m_pResultList ~= nil then
        self.m_pResultList:removeAllChildren()
    end
    local checkRuslt = WaterMarginDataMgr.getInstance():getWinAllType()
    local nCount = 1
    local nType = {}
    local nMuliti = 0
    if checkRuslt == WIN_ALL_MIX_ROLE then
        nCount = 3
        nType[1] = 5
        nType[2] = 4
        nType[3] = 3
        nMuliti = WaterMarginDataMgr.m_cbMixCardBei[1]
    elseif checkRuslt == WIN_ALL_MIX_WEAPON then 
        nCount = 3
        nType[1] = 2
        nType[2] = 1
        nType[3] = 0
        nMuliti = WaterMarginDataMgr.m_cbMixCardBei[2]
    else 
        nCount = 1
        nType[1] = checkRuslt
        nMuliti = WaterMarginDataMgr.m_cbCardBei[checkRuslt+1][4]
    end
    --界面
    local allWidth = 0
    local _Node = ccui.Layout:create()
    local iconWidth = 0
    for i=1, nCount do
        local strIconFile = string.format("game/watermargin/images/gui-water-icon-small-%d.png", nType[i])
        local icon = cc.Sprite:createWithSpriteFrameName(strIconFile)
        icon:setScale(0.5)
        icon:setAnchorPoint(cc.p(0,0))
        iconWidth = icon:getContentSize().width*0.5
        icon:setPosition(cc.p(allWidth,0))
        _Node:addChild(icon)
        local offx = nCount > 1 and 8 or 0
        allWidth = allWidth +iconWidth + offx
    end
    allWidth = allWidth+10
    local lb_All = cc.Label:createWithBMFont("game/watermargin/font/shz_sz2.fnt", "ALL")
    lb_All:setAnchorPoint(cc.p(0, 0))
    lb_All:setPosition(cc.p(allWidth,0))
    _Node:addChild(lb_All)
    allWidth = allWidth+lb_All:getContentSize().width+15
    local strBei = string.format("x%d",nMuliti)
    local lb_count = cc.Label:createWithBMFont("game/watermargin/font/shz_sz2.fnt", strBei)
    lb_count:setAnchorPoint(cc.p(0, 0))
    lb_count:setPosition(cc.p(allWidth,0))
    _Node:addChild(lb_count)
    self.m_pResultList:addChild(_Node)
    allWidth = allWidth+lb_count:getContentSize().width
    local listWidth = self.m_pResultList:getContentSize().width
    _Node:setPosition(cc.p(listWidth/2-allWidth/2,0))
    self.m_pResultList:setPositionX(self.m_pResultList:getPositionX()+8+listWidth/2-allWidth/2)
end

--普通中奖
function WaterMarginResultView:showNormalWinResultIcon()

    if self.m_pResultList ~= nil then
        self.m_pResultList:removeAllChildren()
    end

    local winLineIndexIcon = {} --单线中奖图标索引
    local nWinLineNum = WaterMarginDataMgr.getInstance():getWinResultNum()
    for i = 1, nWinLineNum do 
        local resultInfo = WaterMarginDataMgr.getInstance():getWinResultAtIndex(i)
        for j=1, 2 do --//计算左右
            if(#resultInfo.vecIconsIndexData[j] >= 3)then
                if j == 1 then
                    table.insert(winLineIndexIcon, resultInfo.vecIconsIndexData[1])
                else 
                    table.insert(winLineIndexIcon,resultInfo.vecIconsIndexData[2])
                end
            end
        end
    end
    local nWinCount = table.nums(winLineIndexIcon)
    if nWinCount == 0 then
        return
    end
    local scalex = 1+(nWinCount-1)*0.25 > 3.0 and 3.0 or 1+(nWinCount-1)*0.25
    self.m_pListBg:setScaleX(scalex)
    local allWidth = 0
    local _Node = ccui.Layout:create()
    for i=1, nWinCount do
        local nType = winLineIndexIcon[i][1].giType
        local nCount = table.nums(winLineIndexIcon[i])
        for j =1, table.nums(winLineIndexIcon[i]) do 
            if winLineIndexIcon[i][j].giType ~= 8 then --水浒传不能做当前线的类型
                nType = winLineIndexIcon[i][j].giType
                break
            end
        end
        local strIconFile = string.format("game/watermargin/images/gui-water-icon-small-%d.png", nType)
        local icon = cc.Sprite:createWithSpriteFrameName(strIconFile)
        icon:setScale(0.5)
        icon:setAnchorPoint(cc.p(0,0))
        local iconWidth = icon:getContentSize().width*0.5
        icon:setPosition(cc.p(allWidth,0))
        _Node:addChild(icon)

        local multi = WaterMarginDataMgr.m_cbCardBei[nType+1][nCount-2]
        local strBei = string.format("x%d",multi)
        local lb_count = cc.Label:createWithBMFont("game/watermargin/font/shz_sz2.fnt", strBei)
        lb_count:setAnchorPoint(cc.p(0, 0))
        lb_count:setString(strBei)
        lb_count:setPosition(cc.p(allWidth+iconWidth, 0))
        _Node:addChild(lb_count)
        local lbWidth = lb_count:getContentSize().width
        local offx = nWinCount > 1 and 12 or 0
        allWidth = allWidth + iconWidth + lbWidth + offx
    end
    self.m_pResultList:setInnerContainerSize(cc.size(allWidth,50))
    self.m_pResultList:addChild(_Node)

    local listWidth = self.m_pResultList:getContentSize().width
    if allWidth > listWidth then 
        self.m_pJianTouLeftArmutre = ccs.Armature:create("jiantoudonghua")
        self.m_pJianTouLeftArmutre:setPosition(cc.p(155,155))
        self.m_rootUI:addChild(self.m_pJianTouLeftArmutre)
        self.m_pJianTouLeftArmutre:getAnimation():play("Animation1")
        self.m_pJianTouLeftArmutre:setVisible(false)

        self.m_pJianTouRightArmutre = ccs.Armature:create("jiantoudonghua")
        self.m_pJianTouRightArmutre:setPosition(cc.p(1180,155))
        self.m_rootUI:addChild(self.m_pJianTouRightArmutre)
        self.m_pJianTouRightArmutre:getAnimation():play("Animation2")
    else
        self.m_pResultList:setPositionX(self.m_pResultList:getPositionX()+8+listWidth/2-allWidth/2)
    end
end

function WaterMarginResultView:onScrollEvent(sender, _event)

    -- 设置箭头显示
    local pos = sender:getInnerContainerPosition()
    --print("x:"..pos.x)
    local bShowLeft = pos.x < 0
    local bShowRight = pos.x > self.m_pResultList:getContentSize().width - self.m_pResultList:getInnerContainerSize().width
    if self.m_pJianTouLeftArmutre then 
        self.m_pJianTouLeftArmutre:setVisible(bShowLeft)
    end
    if self.m_pJianTouRightArmutre then 
        self.m_pJianTouRightArmutre:setVisible(bShowRight)
    end
end

return WaterMarginResultView

--endregion
