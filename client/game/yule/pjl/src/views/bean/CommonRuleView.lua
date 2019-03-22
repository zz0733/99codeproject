--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local module_pre = "game.yule.pjl.src.views"
local WaterMarginDataMgr = appdf.req(module_pre..".manager.WaterMarginDataMgr")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local PATH_UI_WATER_COMMONRULE = "game/watermargin/WaterMarginUi_common_rule.json"


local CommonRuleView = class("CommonRuleView", cc.Layer)      

CommonRuleView.m_isMoveing = false

function CommonRuleView:ctor()
    self:enableNodeEvents()
end

function CommonRuleView:getChildByUIName(root,name)
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

function CommonRuleView:onEnter()
    self:init()
    self:show()
end

function CommonRuleView:onExit()

end

-- 弹出
function CommonRuleView:show()
    local pNode = self:getChildByUIName(self.m_pUI, "Panel")
    if (pNode ~= nil)then
        pNode:stopAllActions()
        pNode:setScale(0.0)
        local show = cc.Show:create()
        local scaleTo = cc.ScaleTo:create(0.4, 1.0)
        local ease = cc.EaseBackOut:create(scaleTo)
        local callback = cc.CallFunc:create(function ()
            --self:callbackMove()
        end)
        local seq = cc.Sequence:create(show,ease,callback)
        pNode:runAction(seq)
    end
end

-- 弹出
function CommonRuleView:hide()
    local pNode = self:getChildByUIName(self.m_pUI, "Panel")
    pNode:stopAllActions()
    pNode:setScale(1.0)
    local scaleTo = cc.ScaleTo:create(0.4, 0.0)
    local ease = cc.EaseBackIn:create(scaleTo)
    local callback = cc.CallFunc:create(function ()
        self:removeFromParent()
    end)
    local seq = cc.Sequence:create(ease, callback)
    pNode:runAction(seq)
end

function CommonRuleView:init()
   self:initVars()

   -- 加载UI
   self.m_pUI = cc.CSLoader:createNode("game/watermargin/WaterCommon_rule.csb")
   self.m_pUI:addTo(self)

   self.m_rootUI = self:getChildByUIName(self.m_pUI, "Panel")
   --self.m_rootUI:setPosition((145 - (1624 - display.width) / 2 ), 0)
   self.m_rootUI:setPositionX(self.m_rootUI:getPositionX()+(145 - (1624 - display.width) / 2 ))
   print("---加载UI成功");

   self:initCCS()
   print("---初始化CCS成功");
end


function CommonRuleView:initVars()

end

function CommonRuleView:initCCS()
   --初始化 UI 变量
   self:onAssignCCBMemberVariable()    
   --监听按钮
   self:onResolveCCBCCControlSelector()

   self:onNodeLoaded()
end

function CommonRuleView:onAssignCCBMemberVariable()

    self.m_pBtnYouxiguize = self:getChildByUIName(self.m_pUI, "m_pBtnYouxiguize") 
    self.m_pBtnWanfashuoming = self:getChildByUIName(self.m_pUI, "m_pBtnWanfashuoming") 
    self.m_pBtnCloseRule = self:getChildByUIName(self.m_pUI, "m_pBtnCloseRule") 
    self.m_pImgYouxijieshao = self:getChildByUIName(self.m_pUI, "Image_youxijieshao") 
    self.m_pSvYouxiguize = self:getChildByUIName(self.m_pUI, "ScrollView_youxiguize") 


    self.mpImage_BG = self:getChildByUIName(self.m_pUI, "Image_BG") 
end

function CommonRuleView:onResolveCCBCCControlSelector()

    self.m_pSvYouxiguize:setScrollBarEnabled(false)

    -- m_pBtnYouxiguize --
    local onBtnYouxiguize = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end
        ExternalFun.playSoundEffect("res/public/sound/sound-button.mp3")
        self.m_pImgYouxijieshao:setVisible(false)
        self.m_pSvYouxiguize:setVisible(true)        

        self.m_pBtnYouxiguize:setEnabled(false)
        self.m_pBtnWanfashuoming:setEnabled(true)
    end    
    self.m_pBtnYouxiguize:addTouchEventListener(onBtnYouxiguize);
    -- m_pBtnYouxiguize --    

    -- m_pBtnWanfashuoming --
    local onBtnWanfashuoming = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end
        ExternalFun.playSoundEffect("res/public/sound/sound-button.mp3")
        self.m_pImgYouxijieshao:setVisible(true)
        self.m_pSvYouxiguize:setVisible(false)        

        self.m_pBtnYouxiguize:setEnabled(true)
        self.m_pBtnWanfashuoming:setEnabled(false)
    end    
    self.m_pBtnWanfashuoming:addTouchEventListener(onBtnWanfashuoming);
    -- m_pBtnWanfashuoming --    

    -- m_pBtnCloseRule --
    local onBtnCloseRule = function (sender,eventType)
       if eventType ~= ccui.TouchEventType.ended then
            return
       end
        ExternalFun.playSoundEffect("res/public/sound/sound-close.mp3")
        self:hide()
    end    
    self.m_pBtnCloseRule:addTouchEventListener(onBtnCloseRule);
    -- m_pBtnCloseRule --  
end

function CommonRuleView:onNodeLoaded()
    

    self.m_pImgYouxijieshao:setVisible(true)
    self.m_pSvYouxiguize:setVisible(false)


    self.m_pBtnYouxiguize:setEnabled(true)
    self.m_pBtnWanfashuoming:setEnabled(false)
end

return CommonRuleView

--endregion
