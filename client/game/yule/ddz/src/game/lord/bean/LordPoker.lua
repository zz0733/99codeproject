--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local LordPoker = class("LordPoker", cc.Layer)

local GUI_PREFIX = "game/lord/gui-card/"


function LordPoker:ctor()
    self:enableNodeEvents()
    self:init()
end

function LordPoker:init()
      --csb
    self.m_pathUI = cc.CSLoader:createNode("game/lord/LordPokerUI.csb")
    self.m_pathUI:addTo(self)

    --root
    self.m_rootUI = self.m_pathUI:getChildByName("NodeRoot")

    --牌/值/色/王/地主/影/底
    self.m_pSpPoker = self.m_rootUI:getChildByName("ImagePoker")
    self.m_pSpValue1 = self.m_rootUI:getChildByName("ImageValue1")
    self.m_pSpValue2 = self.m_rootUI:getChildByName("ImageValue2")
    self.m_pSpColor1 = self.m_rootUI:getChildByName("ImageColor1")
    self.m_pSpColor2 = self.m_rootUI:getChildByName("ImageColor2")
    self.m_pSpKing = self.m_rootUI:getChildByName("ImageKing")
    self.m_pSpBanker = self.m_rootUI:getChildByName("ImageBanker")
    self.m_pSpShadow = self.m_rootUI:getChildByName("ImageShadow")
    self.m_pSpBack = self.m_rootUI:getChildByName("ImageBack")
   
    self.m_pSpShadow:setVisible(false)
    self.m_pSpBanker:setVisible(false)
    self.m_pSpBack:setVisible(false)
    --self.m_rootUI:setVisible(false)

end

function LordPoker:setCardData(color, value)
--    if value == nil then
--        if color < 13 then
--            value = color % 13 +3
--            if value >13 then
--                value = value -13
--            end
--            color = 0          
--        elseif color >=13 and color<=25 then
--            value = color %13 + 3  ; 
--            if value >13 then
--                value = value -13
--            end
--            color = 1         
--        elseif color >= 26 and color <= 38 then
--            value = color %13 + 3  ; 
--            if value >13 then
--                value = value -13
--            end
--            color = 2
--        elseif color >= 39 and color <= 51 then
--            value = color %13 + 3  ; 
--            if value >13 then
--                value = value -13
--            end
--            color = 3        
--        elseif color == 52 then 
--            color = 4 ; 
--            value = 14   
--        elseif color == 53 then 
--            color = 4 ; 
--            value = 15    
--        end  
--    end
    if value == nil then
        value = GetCardValue(tonumber(color))
        color = bit.rshift(GetCardColor(tonumber(color)), 4)
    end
    if color < 0 or 4 < color or value < 1 or 15 < value then
        return
    end

    if color == 4 and value == 14 then --小王
        self.m_pSpKing:loadTexture(GUI_PREFIX .. "value-53.png", ccui.TextureResType.plistType)

        self.m_pSpValue1:setVisible(false)
        self.m_pSpValue2:setVisible(false)
        self.m_pSpColor1:setVisible(false)
        self.m_pSpColor2:setVisible(false)
        self.m_pSpKing:setVisible(true)
        self.m_pSpShadow:setVisible(false)
        self.m_pSpBack:setVisible(false)
    end

    if color == 4 and value == 15 then --大王
        self.m_pSpKing:loadTexture(GUI_PREFIX .. "value-54.png", ccui.TextureResType.plistType)

        self.m_pSpValue1:setVisible(false)
        self.m_pSpValue2:setVisible(false)
        self.m_pSpColor1:setVisible(false)
        self.m_pSpColor2:setVisible(false)
        self.m_pSpKing:setVisible(true)
        self.m_pSpShadow:setVisible(false)
        self.m_pSpBack:setVisible(false)
    end

    if 0 <= color and color <= 3 and 1 <= value and value <= 13 then --普通牌
        local pathValue = string.format("value-%d-%d.png", value, color % 2)
        local pathColor = string.format("color-%d.png", color)
        self.m_pSpValue1:loadTexture(GUI_PREFIX .. pathValue, ccui.TextureResType.plistType)
        self.m_pSpValue2:loadTexture(GUI_PREFIX .. pathValue, ccui.TextureResType.plistType)
        self.m_pSpColor1:loadTexture(GUI_PREFIX .. pathColor, ccui.TextureResType.plistType)
        self.m_pSpColor2:loadTexture(GUI_PREFIX .. pathColor, ccui.TextureResType.plistType)

        self.m_pSpValue1:setVisible(true)
        self.m_pSpValue2:setVisible(true)
        self.m_pSpColor1:setVisible(true)
        self.m_pSpColor2:setVisible(true)
        self.m_pSpKing:setVisible(false)
        self.m_pSpShadow:setVisible(false)
        self.m_pSpBack:setVisible(false)

        if 10 <= value and value <= 13 then
            self.m_pSpValue1:setScale(0.95)
            self.m_pSpValue2:setScale(0.95)
        else
            self.m_pSpValue1:setScale(1.00)
            self.m_pSpValue2:setScale(1.00)
        end
    end
end

--设置阴影
function LordPoker:setGray(isGray)
    self.m_pSpShadow:setVisible(isGray)
end

--设置为地主
function LordPoker:setBanker(isBanker)
    self.m_pSpBanker:setVisible(isBanker)
end

--设置为牌背面
function LordPoker:setBack(isBack)
    self.m_pSpBack:setVisible(isBack)
end

return LordPoker
--endregion
