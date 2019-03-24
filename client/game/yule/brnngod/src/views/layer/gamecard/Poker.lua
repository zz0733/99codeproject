--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local Poker = class("Poker", cc.Node)

function Poker:create()
    local pPoker = Poker.new()
    pPoker:init()
    return pPoker
end

function Poker:ctor()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("game/handredcattle/image/plist/gui-poker-1.plist","game/handredcattle/image/plist/gui-poker-1.png")
    self:enableNodeEvents()
    self.m_pathUI = cc.CSLoader:createNode("game/handredcattle/PokerNode.csb")
    self.m_pathUI:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.m_pathUI)
end

function Poker:init()
    self.m_cardData = 1
    self.m_rootWidget = self.m_pathUI:getChildByName("Panel_root")
    self.m_pSpBack = self.m_rootWidget:getChildByName("Image_pokerBack")
    self.m_pSpBack:setScale(1.13)
    self.m_pSpValue, self.m_pSpColor = {}, {}
    for i = 1, 2 do
        self.m_pSpValue[i] = self.m_rootWidget:getChildByName("Image_value"..i)
        self.m_pSpColor[i] = self.m_rootWidget:getChildByName("Image_color"..i)
    end
    self.m_pSpGui = self.m_rootWidget:getChildByName("Image_gui")
    -- self.m_pSpBanker = ccui.Helper:seekWidgetByName(self.m_pathUI, "Image_banker")
    self.m_pSpGary = self.m_rootWidget:getChildByName("Image_gary")
    self.m_pSpGary:setVisible(false)
end

function Poker:onEnter()
    
end

function Poker:onExit()
--    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("niuniu/plist/gui-poker-1.plist")
--    cc.Director:getInstance():getTextureCache():removeTextureForKey("niuniu/plist/gui-poker-1.png")
    print("~Poker......................................................")
end

function Poker:setCardData(color, value)
    self.m_pSpGui:setVisible(false)
    if not value then
        local cbvalue = color
        local cbColor = color
        local ttt;
--        value = self:GetCardValue(cbvalue)
--        color = bit.rshift(self:GetCardColor(cbColor), 4)
        value = cbvalue%13+1
        color,ttt = math.modf(cbColor/13)
    end

    if color < 0 or color > 4 or value < 1 or value > 15 then
        return
    end
    self.m_pSpBack:setSpriteFrame("poker-bg.png")

    if color == 4 then
        if value == 1 then
            self.m_pSpGui:setVisible(true)
            self.m_pSpGui:setSpriteFrame("value-53.png")
            self.m_pSpValue[1]:setVisible(false)
            self.m_pSpValue[2]:setVisible(false)
            self.m_pSpColor[1]:setVisible(false)
            self.m_pSpColor[2]:setVisible(false)
        elseif value == 2 then
            self.m_pSpGui:setVisible(true)
            self.m_pSpGui:setSpriteFrame("value-54.png")
            self.m_pSpValue[1]:setVisible(false)
            self.m_pSpValue[2]:setVisible(false)
            self.m_pSpColor[1]:setVisible(false)
            self.m_pSpColor[2]:setVisible(false)
        end
        return
    end
    for i = 1, 2 do
        self.m_pSpColor[i]:setVisible(true)
        self.m_pSpColor[i]:setSpriteFrame(string.format("color-%d.png", color))
        self.m_pSpValue[i]:setVisible(true)
        self.m_pSpValue[i]:setSpriteFrame(string.format("value-%d-%d.png", value, color%2))
    end
end

function Poker:setGary(isGary)
    local bIsGary = (isGary and true or false)
    self.m_pSpGary:setVisible(bIsGary)
end
--只设置牌数据
function Poker:setData(CardData)
    self.m_cardData = CardData;
end
--根据当前牌数据翻牌
function Poker:showCard()
    local color,ttt = math.modf(self.m_cardData/13)
    local value = (self.m_cardData%13)+1
    self:setCardData(color,value)
end
--设置为地主
function Poker:setBanker(isBanker)
    -- self.m_pSpBanker:setVisible(isBanker)
end

--设置为牌背面
function Poker:setBack()
    self.m_pSpGui:setVisible(false)
    self.m_pSpBack:setSpriteFrame("poker-back.png")
    for i = 1, 2 do
        self.m_pSpColor[i]:setVisible(false)
        self.m_pSpValue[i]:setVisible(false)
    end
end

--获取数值
function Poker:GetCardValue(cbCardData)
    return bit.band(cbCardData, 0x0F)
end

--获取花色
function Poker:GetCardColor(cbCardData)
    return bit.band(cbCardData, 0xF0)
end

return Poker
--endregion


--endregion
