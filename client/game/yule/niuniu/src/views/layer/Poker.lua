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
    cc.SpriteFrameCache:getInstance():addSpriteFrames("niuniu/plist/gui-poker-1.plist","niuniu/plist/gui-poker-1.png")
    self:enableNodeEvents()
    self.m_pathUI = cc.CSLoader:createNode("niuniu/PokerNode.csb")
    self:addChild(self.m_pathUI)
end

function Poker:init()
    self.m_rootWidget = self.m_pathUI:getChildByName("Panel_root")
    self.m_pSpBack = self.m_rootWidget:getChildByName("Image_pokerBack")
    self.m_pSpValue, self.m_pSpColor = {}, {}
    for i = 1, 2 do
        self.m_pSpValue[i] = self.m_rootWidget:getChildByName("Image_value"..i)
        self.m_pSpColor[i] = self.m_rootWidget:getChildByName("Image_color"..i)
    end
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
    if not value then
        local cbvalue = color
        local cbColor = color
        value = self:GetCardValue(cbvalue)
        color = bit.rshift(self:GetCardColor(cbColor), 4)
    end

    if color < 0 or color > 4 or value < 1 or value > 15 then
        return
    end
    self.m_pSpBack:setSpriteFrame("game/twoniuniu/poker/tniuniu-poker-bg.png")

    if color == 4 then
        if value == 1 then
            self.m_pSpValue[1]:setSpriteFrame(string.format("value-53.png"))
            self.m_pSpValue[2]:setVisible(false)
            self.m_pSpColor[1]:setVisible(false)
            self.m_pSpColor[2]:setVisible(false)
            self.m_pSpValue[1]:setPosition(cc.p(70,90))
        elseif value == 2 then
            self.m_pSpValue[1]:setSpriteFrame(string.format("value-54.png"))
            self.m_pSpValue[2]:setVisible(false)
            self.m_pSpColor[1]:setVisible(false)
            self.m_pSpColor[2]:setVisible(false)
            self.m_pSpValue[1]:setPosition(cc.p(70,90))
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

--设置为地主
function Poker:setBanker(isBanker)
    -- self.m_pSpBanker:setVisible(isBanker)
end

--设置为牌背面
function Poker:setBack()
    self.m_pSpBack:setSpriteFrame("game/twoniuniu/poker/tniuniu-poker-back.png")
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