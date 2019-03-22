--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local LordPokerSmall = class("LordPokerSmall", cc.Layer)

local GUI_PREFIX = "game/lord/gui-card/"

function LordPokerSmall:ctor()
    self:enableNodeEvents()
    self:init()
end

function LordPokerSmall:init()
    
    --csb
    self.m_pathUI = cc.CSLoader:createNode("game/lord/LordPokerSmall.csb")
    self.m_pathUI:addTo(self)

    --root
    self.m_rootUI = self.m_pathUI:getChildByName("NodeRoot")

    --牌/值/色/王/地主/影/底
    self.m_pSpPoker = self.m_rootUI:getChildByName("ImagePoker")
    self.m_pSpValue = self.m_rootUI:getChildByName("ImageValue")
    self.m_pSpColor = self.m_rootUI:getChildByName("ImageColor")
    self.m_pSpKing = self.m_rootUI:getChildByName("ImageKing")
    self.m_pSpBanker = self.m_rootUI:getChildByName("ImageBanker")
    self.m_pSpShadow = self.m_rootUI:getChildByName("ImageShadow")
    self.m_pSpBack = self.m_rootUI:getChildByName("ImageBack")

    self.m_pSpBanker:setVisible(false)
    self.m_pSpBack:setVisible(false)
    self.m_pSpShadow:setVisible(false)
    --self.m_rootUI:setVisible(false)
end

--设置牌
function LordPokerSmall:setCardData(color, value)

    if value == nil then
        value = GetCardValue(tonumber(color))
        color = bit.rshift(GetCardColor(tonumber(color)), 4)
    end

    if color < 0 or 4 < color or value < 1 or 15 < value then
        return
    end

    if color == 4 and value == 14 then --小王
        self.m_pSpKing:loadTexture(GUI_PREFIX .. "value-53.png", ccui.TextureResType.plistType)

        self.m_pSpKing:setVisible(true)
        self.m_pSpValue:setVisible(false)
        self.m_pSpColor:setVisible(false)
        self.m_pSpShadow:setVisible(false)
        self.m_pSpBack:setVisible(false)
    end

    if color == 4 and value == 15 then --大王
        self.m_pSpKing:loadTexture(GUI_PREFIX .. "value-54.png", ccui.TextureResType.plistType)

        self.m_pSpKing:setVisible(true)
        self.m_pSpValue:setVisible(false)
        self.m_pSpColor:setVisible(false)
        self.m_pSpShadow:setVisible(false)
        self.m_pSpBack:setVisible(false)
    end

    if 0 <= color and color <= 3 and 1 <= value and value <= 13 then --普通牌
        
        local pathValue = string.format("value-%d-%d.png", value, color % 2)
        local pathColor = string.format("color-%d.png", color)
        self.m_pSpValue:loadTexture(GUI_PREFIX .. pathValue, ccui.TextureResType.plistType)
        self.m_pSpColor:loadTexture(GUI_PREFIX .. pathColor, ccui.TextureResType.plistType)

        self.m_pSpValue:setVisible(true)
        self.m_pSpColor:setVisible(true)
        self.m_pSpKing:setVisible(false)
        self.m_pSpShadow:setVisible(false)
        self.m_pSpBack:setVisible(false)

        if 10 <= value and value <= 13 then
            self.m_pSpValue:setScale(0.85)
        else
            self.m_pSpValue:setScale(0.90)
        end
    end
end

--设置阴影
function LordPokerSmall:setGray(isGary)
    self.m_pSpShadow:setVisible(isGary)
end

--设置为地主
function LordPokerSmall:setBanker(isBanker)
    self.m_pSpBanker:setVisible(isBanker)
end

--设置为牌背面
function LordPokerSmall:setBack(isBack)
    self.m_pSpBack:setVisible(isBack)
end

return LordPokerSmall
--endregion
