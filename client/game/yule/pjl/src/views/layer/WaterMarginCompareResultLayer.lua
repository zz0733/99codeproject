--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local module_pre        = "game.yule.pjl.src.views"
local WaterMarginDataMgr            = appdf.req(module_pre..".manager.WaterMarginDataMgr")

local PATH_UI_WATER_COMPARE_RESULT = "game/watermargin/WaterMarginUi_compare_result.json"


local WaterMarginCompareResultLayer = class("WaterMarginCompareResultLayer", cc.Layer)      

local   BUY_FAIL = -1
local	BUY_SMALL = 0
local	BUY_TIE = 1
local	BUY_BIG = 2

function WaterMarginCompareResultLayer:getChildByUIName(root,name)
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

function WaterMarginCompareResultLayer:ctor()
    self:enableNodeEvents()
end    

function WaterMarginCompareResultLayer:onEnter()
    self:init()
end

function WaterMarginCompareResultLayer:onExit()

end

function WaterMarginCompareResultLayer:init()
   self:initVars()

   -- 加载UI
   self.m_pUI = cc.CSLoader:createNode("game/watermargin/WaterCompare_result.csb")
   self.m_pUI:addTo(self)
   print("---加载UI成功");

   self:initCCS()
   print("---初始化CCS成功");
end


function WaterMarginCompareResultLayer:initVars()
    self.m_pSprResult = nil;
    self.m_pSprNew = nil;
end

function WaterMarginCompareResultLayer:initCCS()
   --初始化 UI 变量
   self:onAssignCCBMemberVariable()    
   --监听按钮
   self:onResolveCCBCCControlSelector()

   self:onNodeLoaded()
end

function WaterMarginCompareResultLayer:onAssignCCBMemberVariable()

    self.m_pSprResult = self:getChildByUIName(self.m_pUI, "m_pSprResult") 
    self.m_pSprNew = self:getChildByUIName(self.m_pUI, "m_pSprNew") 


end

function WaterMarginCompareResultLayer:onResolveCCBCCControlSelector()

end

function WaterMarginCompareResultLayer:onNodeLoaded()

end



function WaterMarginCompareResultLayer:setShowResultIcon(iType)

    if(self.m_pSprResult == nil)then
        return;
    end
    
    local strFrameName = "";
    if iType == BUY_SMALL then
        strFrameName = "game/watermargin/images/gui-water-compare-little.png";
    elseif iType == BUY_TIE then
        strFrameName = "game/watermargin/images/gui-water-compare-equip.png";
    elseif iType == BUY_BIG then
        strFrameName = "game/watermargin/images/gui-water-compare-big.png";
    end


    if(strFrameName~= "")then
        --self.m_pSprResult:loadTexture(strFrameName, ccui.TextureResType.plistType)
        self.m_pSprResult:setSpriteFrame(strFrameName);
    end
end

function WaterMarginCompareResultLayer:setShowNewIconVisible(isShow)

    if(self.m_pSprNew == nil)then
        return;
    end
    
    self.m_pSprNew:setVisible(isShow);
end

return WaterMarginCompareResultLayer

--endregion
