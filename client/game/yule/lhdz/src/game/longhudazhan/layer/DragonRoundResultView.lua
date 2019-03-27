-- DragonRoundResultView.lua
-- 龙虎斗开奖界面
-- 2019.3.22 han
local module_pre = "game.yule.lhdz.src."
local Lhdz_Res              = appdf.req(module_pre.."game.longhudazhan.scene.Lhdz_Res")
local DragonRoundResultView = class("DragonRoundResultView", function()
    return cc.CSLoader:createNode(Lhdz_Res.CSB_OF_DRAGONRESULT)
end)
local Card = class("Card")
local _ = {}

function DragonRoundResultView:ctor( callBack )
    self.callBack = callBack
    bindCCBNode(self, self)
    self:initUI(  )
end

-- 初始化UI
function DragonRoundResultView:initUI(  )

    -- self.close:addClickEventListener(handler(self, self.onClose))
    -- addNodeListener(self, "recvSignInRsp", handler(self, self.onEventHasToReload))
    local winSize = cc.Director:getInstance():getWinSize()

    -- 初始
    self.cardFront1:setVisible(false)
    self.cardFront2:setVisible(false)
    self.titleBg:setVisible(false)
    self.scoreNum:setVisible(false)
    print("xp",'牌从右飞进框内')
    -- 
    function cardsToBox()
        for i = 1, 2 do
            local cardSpr = self['cardFront'..i]
            local cardBackSpr = cardSpr:getChildByName('node_cardBack')
            local cardPos = cc.p(cardSpr:getPosition())
            cardSpr:setVisible(true)
            cardSpr:getChildByName('node_cardShade'):setVisible(false)
            cardSpr:getChildByName('node_cardHighlight'):setVisible(false)

            local flipCard = cc.Sequence:create(
                --下面就是旋转翻牌了
                cc.DelayTime:create(0.5+0.6*(i-1)),
                cc.ScaleTo:create(0.1, 0, 1),
                cc.CallFunc:create(function()
                    -- 切换正面
                    print("xp",'切换正面')
                    cardSpr:getChildByName('node_cardBack'):setVisible(false)
                    --todo
                    --cc.loaded_packages.KKMusicPlayer:playEffect('DragonTiger/sound/throw_card.mp3', false)
                end),
                cc.ScaleTo:create(0.1, 1, 1)
            )
            cardSpr:runAction(flipCard)
        end
    end


    -- 框从上往下出现
    self.root:setVisible(false)
    self.root:runAction(cc.Sequence:create(
        cc.CallFunc:create(function()
            self.root:setPosition(cc.p(winSize.width / 2, winSize.height + 400))
        end),
        cc.DelayTime:create(0.05),
        cc.Show:create(),
        cc.Spawn:create(
            cc.FadeIn:create(0.2),
            cc.MoveTo:create(0.2, cc.p(winSize.width / 2, winSize.height))
        ),
        cc.DelayTime:create(0.35),
        cc.CallFunc:create(cardsToBox)
    ))

    -- 彩带从上往下fadein, 然后显示xx赢
    local titlePos = cc.p(self.titleBg:getPosition())
    -- self.titleBg:setPositionY(titlePos.y + 180)
    self.resultTxt:setVisible(false)

    self.titleBg:runAction(cc.Sequence:create(
        cc.DelayTime:create(3),
        cc.Show:create(),
        cc.CallFunc:create(function()
            self.vs:hide()
            --todo
            --cc.loaded_packages.KKMusicPlayer:playEffect('DragonTiger/sound/opencard_result.mp3', false)
        end),         
        cc.EaseBackOut:create(cc.MoveTo:create(0.25, titlePos)),
        cc.CallFunc:create(function()
            self.resultTxt:setVisible(true)
            self.resultTxt:setScale(1.5)
            self.resultTxt:runAction(cc.ScaleTo:create(0.1, 1))
        end)
    ))

    -- 完了消失
    self.root:runAction(cc.Sequence:create(
        cc.DelayTime:create(6),
        cc.Spawn:create(
            cc.FadeOut:create(0.2),
            cc.MoveBy:create(0.2, cc.p(0, 220))
        ),
        cc.CallFunc:create(function()
            self.callBack()
            self:onClose()
        end)
    ))

end

-- 结算数据
function DragonRoundResultView:setRoundResult(result)
    if not result or result == {} then
        self:onClose()
        return
    end
    -- 设置牌面值
    for i, cardVal in pairs(result.cards) do
        if type(cardVal) == "number" then
            local value =  bit.band(cardVal, 0x0F)
            local nColor = bit.band(cardVal, 0xF0)
            local color = bit.rshift(nColor, 4)
            color = 4 - 1 - color
            local cardType = color
            local cardVal = value
            if cardVal == 0 then -- 牌K
                cardVal = 13
            elseif cardVal == 1 then
                cardVal = 14 -- 在图集里面牌A为14
            end
            local imagePath = string.format('common/card/%s.png', ''..cardType..cardVal)
            local cardSpr = self['cardFront'..i]
            cardSpr:setTexture(imagePath)
            print("xp",'@@', imagePath)
        end
    end

    -- 输赢分
    local score = result.playercoinchange or 0
    -- local model = cc.loaded_packages.DragonTigerLogic:getModel()
    -- if model:isSelfDealer() then
    --     score = result.dealerwincoin
    -- end
    print('win coin:', result.playercoinchange, result.dealerwincoin)

    -- self.scoreNum:setString((score >= 0 and ':' or ';')..score)
    local strScore = formatNumber(score).."$"
    if score >= 0 then
        strScore = "+"..strScore
    end
    self.scoreNum:setString(strScore)
    self.scoreNum:setVisible(false)

    -- 输赢分放大
    local function scoreEff()
        self.scoreNum:setVisible(false)
        self.scoreNum:setScale(1.3)
        self.scoreNum:runAction(cc.ScaleTo:create(0.1, 1))
    end


    -- 设置彩带颜色（红/灰）
    -- self.titleBgFailed:setVisible(result.betstate == 2)
    -- self.titleBgWin:setVisible(not self.titleBgFailed:isVisible())

    -- 设置显示龙/虎/和
    local rstImg = string.format('game/longhudazhan/image/longfudou_winTxt%d.png', result.result)
    -- if self.titleBgFailed:isVisible() then
    --     rstImg = string.format('DragonTiger/image/longfudou_loseTxt%d.png', result.result)
    -- end
    self.resultTxt:setTexture(rstImg)
    print('@@@', rstImg)

    -- 赢的牌放大动画
    if result.result == 1 then -- 结果“和”
        performWithDelay(self.scoreNum, function()
            self.scoreNum:setVisible(false)
            -- scoreEff()
        end, 3.6)
        return
    end

    local winIndex = math.floor(result.result / 2) + 1
    local winCard = self['cardFront'..winIndex]
    winCard:runAction(cc.Sequence:create(
        cc.DelayTime:create(3.6),
        cc.CallFunc:create(function()
            winCard:getChildByName("node_cardHighlight"):setVisible(true)
        end),
        cc.ScaleTo:create(0.3, 1.1),
        cc.CallFunc:create(scoreEff)
    ))
end

function DragonRoundResultView:closeSelf()
    self:setVisible(false)
end

-- 关闭弹窗
function DragonRoundResultView:onClose(  )
    self:removeSelf()
end

-- 返回按键响应
function DragonRoundResultView:onBack(  )
    -- 不能退出
end

-- function DragonRoundResultView:onEnter( ... )
-- end

-- function DragonRoundResultView:onExit( ... )
-- end

--------------------------------------------------------------------------------


function Card:ctor(parentClass)

end



return DragonRoundResultView