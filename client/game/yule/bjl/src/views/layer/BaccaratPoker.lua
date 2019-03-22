--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--endregion
local module_pre = "game.yule.bjl.src"
local BaccaratRes    = appdf.req(module_pre .. ".game.baccarat.scene.BaccaratRes")

local BaccaratPoker = class("BaccaratPoker", cc.Node)

function BaccaratPoker:create()
    local pPoker = BaccaratPoker.new()
    pPoker:init()
    return pPoker
end

function BaccaratPoker:ctor()
    --self:enableNodeEvents()
    self.m_rootWidget = cc.CSLoader:createNode(BaccaratRes.CSB_GAME_POKER):addTo(self)
end

function BaccaratPoker:init()
    self.m_cardColor = 1
    self.m_cardValue = 1
    self.m_pSpBack = self.m_rootWidget:getChildByName("Image_poker_back")
    self.m_pSpPoker = self.m_rootWidget:getChildByName("Image_poker")
    --大小王
    self.m_pSpKing = self.m_pSpPoker:getChildByName("Image_king")
    self.m_pSpValue = {}
    self.m_pSpColor = {}
    for i = 0, 1 do
        self.m_pSpValue[i] = self.m_pSpPoker:getChildByName(string.format("Image_value_%d",i))
        self.m_pSpColor[i] = self.m_pSpPoker:getChildByName(string.format("Image_color_%d",i))
    end
    self.m_pSpGary = self.m_pSpPoker:getChildByName("Image_gary")
    self.m_pSpGary:setVisible(false)
end

function BaccaratPoker:onEnter()
end

function BaccaratPoker:onExit()
end

--只设置牌数据
function BaccaratPoker:setData(CardData)
    self.m_cardColor = CommonUtils.getInstance():getCardColor(CardData)
    self.m_cardValue = CommonUtils.getInstance():getCardValue(CardData)+1
end

function BaccaratPoker:setData(color, value)
    self.m_cardColor = color
    self.m_cardValue = value
end

--根据当前牌数据翻牌
function BaccaratPoker:showCard()
    self:setCardData(self.m_cardColor,self.m_cardValue)
end

function BaccaratPoker:setCardData(color, value)
    if not value then
        local cbvalue = color
        local cbColor = color
        value = self:GetCardValue(cbvalue)
        color = bit.rshift(self:GetCardColor(cbColor), 4)
    end

    if color < 0 or color > 4 or value < 1 or value > 15 then
        return
    end

    self.m_pSpPoker:setVisible(true)
    self.m_pSpBack:setVisible(false)

    if color == 4 then
        if value == 1 then --14
            value = 53
        elseif value == 2 then
            value = 54
        end

        local tempValue = value
        --print(color, value, tempValue, string.format("value-%d.png", tempValue))
        self.m_pSpKing:loadTexture(string.format("value-%d.png", tempValue) , ccui.TextureResType.plistType)
        
        self.m_pSpKing:setVisible(true)
        self.m_pSpValue[0]:setVisible(false)
        self.m_pSpValue[1]:setVisible(false)
        self.m_pSpColor[0]:setVisible(false)
        self.m_pSpColor[1]:setVisible(false)
        return
    end

    self.m_pSpKing:setVisible(false)
    for i = 0, 1 do
        self.m_pSpColor[i]:setVisible(true)
        self.m_pSpColor[i]:loadTexture(string.format("color-%d.png", color), ccui.TextureResType.plistType)
        self.m_pSpValue[i]:setVisible(true)
        --print("value", value, "color", color)
        self.m_pSpValue[i]:loadTexture(string.format("value-%d-%d.png", value, color%2), ccui.TextureResType.plistType)
    end
end

function BaccaratPoker:setGary(isGary)
    self.m_pSpGary:setVisible(isGary)
end

--设置为牌背面
function BaccaratPoker:setBack()
    self.m_pSpBack:setVisible(true)
end

--获取数值
function BaccaratPoker:GetCardValue(cbCardData)
    return bit.band(cbCardData, 0x0F)
end

--获取花色
function BaccaratPoker:GetCardColor(cbCardData)
    return bit.band(cbCardData, 0xF0)
end

return BaccaratPoker

