--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local WaterMarginDataMgr = require("game.watermargin.manager.WaterMarginDataMgr")

local PATH_UI_WATER_LITTLEMARY_WAIT = "game/watermargin/WaterMarginUi_littlemary_wait.json"

local AudioManager = require("common.manager.AudioManager")

local WaterMarginScene_Events = require("game.watermargin.scene.WaterMarginSceneEvent")

local LittleMaryWaitLayer = class("LittleMaryWaitLayer", cc.Layer)      

local   BUY_FAIL = -1
local	BUY_SMALL = 0
local	BUY_TIE = 1
local	BUY_BIG = 2

LittleMaryWaitLayer.instance_ = nil
function LittleMaryWaitLayer.create()
    LittleMaryWaitLayer.instance_ = LittleMaryWaitLayer.new()
    return LittleMaryWaitLayer.instance_
end

function LittleMaryWaitLayer:getChildByUIName(root,name)
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

function LittleMaryWaitLayer:ctor()
    self:enableNodeEvents()
end    

function LittleMaryWaitLayer:onEnter()
    self:init()
end

function LittleMaryWaitLayer:onExit()
    self:cleanViewEffectAction()

    SLFacade:removeEventListener(self.m_onMsgStartSuc)

    scheduler.unscheduleGlobal(self.m_pUpdateGlobal)
    LittleMaryWaitLayer.instance_ = nil
end

function LittleMaryWaitLayer:cleanViewEffectAction()

    for i=1,tonumber(#self.m_vEffectPath),1 do 
        local manager = ccs.ArmatureDataManager:getInstance()
        manager:removeArmatureFileInfo(self.m_vEffectPath[i]);
    end
    self.m_vEffectPath = {}
end

function LittleMaryWaitLayer:init()
   self:initVars()

  -- 加载UI
   self.m_pUI = cc.CSLoader:createNode("game/watermargin/Waterlittlemary_wait.csb")
   self.m_pUI:addTo(self)

   self.m_rootUI = self:getChildByUIName(self.m_pUI, "Panel")
   self.m_rootUI:setPosition((145 - (1624 - display.width) / 2), 0)

   print("---加载UI成功");

   self:initCCS()
   print("---初始化CCS成功");
end


function LittleMaryWaitLayer:initVars()
    self.m_pNodeEffect = nil;
    self.m_pLbRemainderTime = nil;
    self.m_pBtnStartLittleMaryGame = nil;
    
    self.m_nCountTime = 5.0;--5秒
    self.m_vEffectPath = {}
end

function LittleMaryWaitLayer:initCCS()
   --初始化 UI 变量
   self:onAssignCCBMemberVariable()    
   --监听按钮
   self:onResolveCCBCCControlSelector()

   self:onNodeLoaded()

   --加载其他onEnter
   self:initOther();
end


function LittleMaryWaitLayer:initOther()

    self.m_onMsgStartSuc = SLFacade:addCustomEventListener(WaterMarginScene_Events.MSG_LITTLE_MARY_RESULT, handler(self, self.onMsgStartSuc))--
    
    self.m_pUpdateGlobal = scheduler.scheduleUpdateGlobal(handler(self, self.update))

    self:playDragonEffect(0);    
end

function LittleMaryWaitLayer:playDragonEffect(time)

    self.m_pNodeEffect:removeAllChildren();
    
    local armatureFilePath = "game/watermargin/effect/zhongjiangfeilongchuhua_shuihuzhuan/zhongjiangfeilongchuhua_shuihuzhuan.ExportJson";
    local armatureActionName = "zhongjiangfeilongchuhua_shuihuzhuan";
    local armaturePlayIndex = "Animation1";
    
    table.insert(self.m_vEffectPath,armatureFilePath)

    local manager = ccs.ArmatureDataManager:getInstance()
    manager:addArmatureFileInfo(armatureFilePath)

    
    local winSize = cc.Director:getInstance():getWinSize();
    local vecActionPos = cc.p(667, 375 + 100);
    Effect.getInstance():creatEffectWithDelegate2(self.m_pNodeEffect,armatureActionName,armaturePlayIndex,true,vecActionPos);
end

function LittleMaryWaitLayer:update(tDelta)
    if(self.m_pLbRemainderTime ==nil)then
        return;
    end
    
    self.m_nCountTime = self.m_nCountTime - tDelta;
    
    if (self.m_nCountTime >= 0.0)then
    
        local strTime = string.format(LuaUtils.getLocalString("WATER_8"),math.ceil(self.m_nCountTime));
        self.m_pLbRemainderTime:setString(strTime);
    end
    
    if(self.m_nCountTime <= 0)then
        scheduler.unscheduleGlobal(self.m_pUpdateGlobal)
        --倒计时结束自动开始游戏
        SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_START_GAME_LITTLE_MARY)
    end    
end

function LittleMaryWaitLayer:onAssignCCBMemberVariable()

    self.m_pNodeEffect = self:getChildByUIName(self.m_pUI, "m_pNodeEffect") 
    self.m_pLbRemainderTime = self:getChildByUIName(self.m_pUI, "m_pLbRemainTime") 
    self.m_pBtnStartLittleMaryGame = self:getChildByUIName(self.m_pUI, "m_pBtnStartLittleMaryGame")

end

function LittleMaryWaitLayer:onResolveCCBCCControlSelector()

    -- onEnterLittleMaryClicked --
    local onEnterLittleMaryClicked = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end
        self:onInstantStartMaryCallBack()
        AudioManager.getInstance():playSound("res/public/sound/sound-button.mp3")

    end    
    self.m_pBtnStartLittleMaryGame:addTouchEventListener(onEnterLittleMaryClicked);
    -- onEnterLittleMaryClicked --

end

function LittleMaryWaitLayer:onInstantStartMaryCallBack()

    scheduler.unscheduleGlobal(self.m_pUpdateGlobal)
    
    SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_START_GAME_LITTLE_MARY)
end

function LittleMaryWaitLayer:onNodeLoaded()

end


function LittleMaryWaitLayer:onMsgStartSuc()
    self:removeFromParent()
end


return LittleMaryWaitLayer

--endregion
