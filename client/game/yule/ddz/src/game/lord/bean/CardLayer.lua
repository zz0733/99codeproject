--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local CardLayer = class("CardLayer", cc.Layer)

local LordPoker = appdf.req("game.yule.ddz.src.game.lord.bean.LordPoker")
local LordPokerSmall = appdf.req("game.yule.ddz.src.game.lord.bean.LordPokerSmall")

local LordGameLogic = appdf.req("game.yule.ddz.src.game.lord.bean.LordGameLogic")

function CardLayer:createNormal()
    local pCardLayer = CardLayer.new()
    pCardLayer:init(false)
    return pCardLayer
end

function CardLayer:createSmall()
    local pCardLayer = CardLayer.new()
    pCardLayer:init(true)
    return pCardLayer
end

function CardLayer:ctor()
    self:enableNodeEvents()

    self.m_nDistance = DEF_DISTANCE
    self.m_nMinDistance = DEF_DISTANCE
    self.m_nMaxDistance = DEF_DISTANCE
    
    self.m_bCanTouch = true
    self.m_nShootDistance = DEF_SHOOT_DISTANCE
    self.m_cbCardCount = 0
    self.m_ptOrigin = cc.p(0, 0)
    self.m_nStartIndex = 0xff
    self.m_nEndIndex = 0xff
    self.m_bGray = false
    self.m_vCardSp = {}
    self.m_bBanker = false
    self.m_CardItemArray = {}
    self.m_bPositively = true
    for i = 0, 19 do
        self.m_CardItemArray[i] = {}
        self.m_CardItemArray[i].bShoot = false
        self.m_CardItemArray[i].cbCardData = 0
    end

    self.m_iIndexPos = -1
    self.m_bSmall = false

    self.m_bStillInAction = false
end

function CardLayer:init(bSmall)

    self.m_bSmall = bSmall

    --牌大小/牌间最小距离/牌间最大距离
    self.m_sizeCard = self.m_bSmall and cc.size(99, 124) or cc.size(155, 198)
    self.m_nMinDistance = self.m_bSmall and self.m_sizeCard.width * 0.38 or self.m_sizeCard.width * 0.22
    self.m_nMaxDistance = self.m_bSmall and self.m_sizeCard.width * 0.48 or self.m_sizeCard.width * 0.33
end

function CardLayer:onEnter()
    --触摸层
    self.m_pEventListener = cc.EventListenerTouchOneByOne:create()
    self.m_pEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.m_pEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.m_pEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self.m_pEventListener:registerScriptHandler(handler(self, self.onTouchCancel),cc.Handler.EVENT_TOUCH_CANCELLED)
    self.m_pEventDispatcher = self:getEventDispatcher()
    self.m_pEventDispatcher:addEventListenerWithSceneGraphPriority(self.m_pEventListener, self)
end

function CardLayer:onExit()
    if self.m_pEventListener then
        self.m_pEventDispatcher:removeEventListener(self.m_pEventListener)
    end
end

function CardLayer:onTouchBegan(touch, event)
    if not self.m_bCanTouch then
        return false
    end
    local pt = touch:getLocation()
    local ptClick = self:convertToNodeSpace(pt)
    
    return self:TouchHandle(ptClick, EMOUSEHANDLE.EMOUSEHANDLE_PUSH)
end

function CardLayer:onTouchMoved(touch, event)

    local pt = touch:getLocation()
    local ptClick = self:convertToNodeSpace(pt)

    return self:TouchHandle(ptClick, EMOUSEHANDLE.EMOUSEHANDLE_MOVE)
end

function CardLayer:onTouchEnded(touch, event)

    local pt = touch:getLocation();
    local ptClick = self:convertToNodeSpace(pt)
    
    return self:TouchHandle(ptClick, EMOUSEHANDLE.EMOUSEHANDLE_RELEASE)
end

function CardLayer:onTouchCancel(touch, event)
    self:unSelectAllCard()
    return true
end

function CardLayer:SetCardData(cbCardData, cbCardCount, isAni)

    --扑克数目
    self.m_cbCardCount = cbCardCount
    --设置扑克
    for i = 0, cbCardCount-1 do
        self.m_CardItemArray[i].bShoot = false
        self.m_CardItemArray[i].cbCardData = cbCardData[i]

        if cbCardData[i] == nil then
            print("CardLayer:SetCardData error")
        elseif cbCardData[i] == 0 then
            print("CardLayer:SetCardData 0")
        end
    end
    if not isAni then
        isAni = false
    end
    self:resetCardSp(isAni)
    if (self.m_bGray) then
        if (self.m_cbCardCount > 0) then
            self:selectCard(0, self.m_cbCardCount-1)
        end
    end
    return true
end

function CardLayer:resetCardSp(isAni)

    --使所有牌不可见
    for i = 0, table.nums(self.m_vCardSp) do
        if(self.m_vCardSp[i]) then
           self.m_vCardSp[i]:setVisible(false)
        end
    end

    --添加新牌
    if table.nums(self.m_vCardSp) < self.m_cbCardCount then
        for i = table.nums(self.m_vCardSp), self.m_cbCardCount -1 do
            local Poker = self.m_bSmall and  LordPokerSmall or LordPoker
            self.m_vCardSp[i] = Poker:create()
            self.m_vCardSp[i]:setAnchorPoint(cc.p(0, 0))
            self.m_vCardSp[i]:setVisible(false)
            self.m_vCardSp[i]:addTo(self, i)
        end
    end

    --出牌或者展示
    if self.m_bSmall then
        self:setSmallCardOut()
    else
        self:setSelfCardShow()
    end

    --设置地主
    self:SetBanker(self.m_bBanker)
end

function CardLayer:setSelfCardShow()

    --设置起始点
    local size = self:getContentSize()
    --重新设置间隔
    self.m_nDistance = DEF_DISTANCE

    if self.m_cbCardCount > 1 then
        self.m_nDistance = (size.width-self.m_sizeCard.width)/(self.m_cbCardCount-1)
        if (self.m_nDistance < self.m_nMinDistance) then
            self.m_nDistance = self.m_nMinDistance
        elseif (self.m_nDistance > self.m_nMaxDistance) then
            self.m_nDistance = self.m_nMaxDistance
        end
    end

    --设置起始点
    local totalSize = cc.size(0, 0)
    totalSize.height = self.m_sizeCard.height + self.m_nShootDistance
    totalSize.width = 0
    if self.m_cbCardCount > 0 then
        totalSize.width = self.m_sizeCard.width+(self.m_cbCardCount-1)*self.m_nDistance
    end
    self.m_ptOrigin.x = (size.width - totalSize.width)/2
    self.m_ptOrigin.y = (size.height - totalSize.height)/2
    local posCards = {}
    for i = 0, self.m_cbCardCount - 1 do
        posCards[i] = self.m_ptOrigin.x + i * self.m_nDistance
    end

    --重新排列位置
    for i = 0, self.m_cbCardCount-1 do
        if self.m_vCardSp[i] then
            self:setCardSpData(self.m_vCardSp[i], self.m_CardItemArray[i].cbCardData)
            self.m_vCardSp[i]:setVisible(true)
            if self.m_CardItemArray[i].bShoot then
                self.m_vCardSp[i]:setPosition(posCards[i], self.m_nShootDistance)
            else
                self.m_vCardSp[i]:setPosition(posCards[i], 0)
            end
        end
    end

    --发牌动画
    --[[
    if isAni then
        for i = 0, self.m_cbCardCount-1 do
            if(self.m_vCardSp[i]) then
                self:setCardSpData(self.m_vCardSp[i], self.m_CardItemArray[i].cbCardData)
                self.m_vCardSp[i]:setPosition(cc.p(self.m_ptOrigin.x,0))
                self.m_vCardSp[i]:setVisible(false)
                self.m_vCardSp[i]:setBanker(false)
                local desPos = cc.p(self.m_ptOrigin.x + (i)*self.m_nDistance,0)

                local TIME_INTERVAL = 0.067
                local actionDelay = cc.DelayTime:create(TIME_INTERVAL * i)
                local actionCall = cc.CallFunc:create(function()
                    local pos = cc.p(self.m_ptOrigin.x - self.m_nDistance,0)
                    if (i > 1) then
                        pos = cc.p(self.m_ptOrigin.x+(i-1)*self.m_nDistance,0)
                    end
                    self.m_vCardSp[i]:setPosition(pos)
                    self.m_vCardSp[i]:setVisible(true)
                end)
                local actionMove = cc.MoveTo:create(TIME_INTERVAL, desPos)
                self.m_vCardSp[i]:runAction(cc.Sequence:create(actionDelay, actionCall, actionMove))
            end
        end
    end
    --]]
end

function CardLayer:setSmallCardOut()
    
    if self.m_cbCardCount == 0 then
        return
    end

    local layerSize = self:getContentSize() --上下家420x240/自己900x120
    local cardSize = self.m_sizeCard --99x124
    local minDistance = self.m_nMinDistance --29
    local maxDistance = self.m_nMaxDistance --38

    --自己一行排列
    local posOfCards = {}
    if self.m_iIndexPos == 1 then 
        for i = 0, self.m_cbCardCount - 1 do
            posOfCards[i] = {}
            posOfCards[i][1] = (i - 1) * minDistance
            posOfCards[i][2] = 0
        end
    --上下家两行排列
    else 
        for i = 0, self.m_cbCardCount - 1 do
            posOfCards[i] = {}
            posOfCards[i][1] = (i % 10) * minDistance
            posOfCards[i][2] = (i < 10) and 90 or 0
        end
    end

    --自己牌，x居中显示
    if self.m_iIndexPos == 1 then
        local offsetX = 0
        if self.m_cbCardCount <= 10 then
            offsetX = (layerSize.width - (posOfCards[self.m_cbCardCount - 1][1] + cardSize.width)) / 2 + 33
        else
            offsetX = (layerSize.width - (posOfCards[self.m_cbCardCount - 1][1] + cardSize.width)) / 2 + 15
        end
        for i = 0, self.m_cbCardCount - 1 do
            if offsetX > 0 then
                posOfCards[i][1] = posOfCards[i][1] + offsetX
            end
        end
    end

    --上家，小于5张牌x靠左，小于10张牌x居中
    if self.m_iIndexPos == 0 then
        local offsetX = 0 
        if self.m_cbCardCount <= 5 then
            offsetX = 90
        elseif self.m_cbCardCount <= 10 then
            offsetX = (layerSize.width - (posOfCards[self.m_cbCardCount - 1][1] + cardSize.width)) / 2
        end
        for i = 0, self.m_cbCardCount - 1 do
            if offsetX > 0 then
                posOfCards[i][1] = posOfCards[i][1] + offsetX
            end
        end
    end
    --下家，小于5张牌x靠右，小于10张牌x居中
    if self.m_iIndexPos == 2 then
        local offsetX = 0
        if self.m_cbCardCount <= 5 then
            offsetX = (layerSize.width - (posOfCards[self.m_cbCardCount - 1][1] + cardSize.width)) - 65
        elseif self.m_cbCardCount <= 10 then
            offsetX = (layerSize.width - (posOfCards[self.m_cbCardCount - 1][1] + cardSize.width)) / 2
        end
        for i = 0,  self.m_cbCardCount - 1 do
            posOfCards[i][1] = posOfCards[i][1] + offsetX
        end
    end

    --上家/下家，小于10张牌时，未摊牌，y靠下
    if self.m_iIndexPos == 0 or self.m_iIndexPos == 2 then
        if self.m_cbCardCount <= 10 then
            for i = 0, self.m_cbCardCount - 1 do
                posOfCards[i][2] = 0
            end
        end
    end

    --下家牌，大于第10张牌，x靠右显示
    if self.m_iIndexPos == 2 and self.m_cbCardCount > 10 then
        local offsetX = (20 - self.m_cbCardCount) * minDistance
        for i = 10, self.m_cbCardCount - 1 do
            posOfCards[i][1] = posOfCards[i][1] + offsetX
        end
    end

    --最后设置牌位置
    for i = 0, self.m_cbCardCount - 1 do
        self:setCardSpData(self.m_vCardSp[i], self.m_CardItemArray[i].cbCardData)
        self.m_vCardSp[i]:setPosition(posOfCards[i][1], posOfCards[i][2])
        self.m_vCardSp[i]:setVisible(true)
    end
end

function CardLayer:setCardSpData(pLordPoker, data)
    if pLordPoker then
        pLordPoker:setCardData(data)
    end
end

function CardLayer:TouchHandle(pt, eHandle)
    if eHandle == EMOUSEHANDLE.EMOUSEHANDLE_PUSH then
        if (not self.m_bPositively) then
            return false
        end
        
        self.m_nStartIndex = 0xff
        self.m_nEndIndex = 0xff;
        
        self.m_nStartIndex = self:getTouchHitIndex(pt)
        self.m_nEndIndex = self.m_nStartIndex
        
        self:unSelectAllCard()
        self:selectCard(self.m_nStartIndex, self.m_nEndIndex)

        if self.m_nStartIndex == 0xff then --可以收牌
            --FloatMessage.getInstance():pushMessageDebug("可以收牌")
            self:setAllNotShoot()
        end

        return self.m_nStartIndex ~= 0xff
    elseif eHandle == EMOUSEHANDLE.EMOUSEHANDLE_MOVE then
        local Index = self:getTouchHitIndex(pt)
        if (Index ~= 0xff) then
            if (Index == self.m_nEndIndex) then
                return false
            end
            self:unSelectAllCard()
            self.m_nEndIndex = Index;
            self:selectCard(self.m_nStartIndex, self.m_nEndIndex)
        end
    elseif eHandle == EMOUSEHANDLE.EMOUSEHANDLE_RELEASE then
        self:unSelectAllCard()
        local Index = self:getTouchHitIndex(pt)
        if (Index ~= 0xff) then
            self.m_nEndIndex = Index
            self:SetShootArea(self.m_nStartIndex, self.m_nEndIndex)
            if self.m_pEvent then
                self.m_pEvent:LayerEventCallBack(1)
            end
        end
    end
end

function CardLayer:SetPositively(bPositively)
    self.m_bPositively = bPositively
end

function CardLayer:getTouchHitIndex(pt)
    local totalSize = cc.size(0,0)
    
    totalSize.height = self.m_sizeCard.height + self.m_nShootDistance
    totalSize.width = 0
    if (self.m_cbCardCount > 0) then
        totalSize.width = self.m_sizeCard.width+(self.m_cbCardCount-1)*self.m_nDistance
    end
    --基准位置
    local nXPos = pt.x- self.m_ptOrigin.x
    local nYPos = pt.y - self.m_ptOrigin.y
    --越界判断
    if ((nXPos < 0) or (nXPos > totalSize.width)) then
        return 0xff
    end
    if ((nYPos < -40) or (nYPos > totalSize.height)) then
        return 0xff
    end
    
    --计算索引
    local cbCardIndex= math.floor(nXPos/self.m_nDistance)
    if (cbCardIndex >= self.m_cbCardCount) then
        cbCardIndex = self.m_cbCardCount-1
    end
    --扑克搜索
    for  i=0, cbCardIndex do
        local cbCurrentIndex = cbCardIndex - i
        
        --显示判断
        if (cbCurrentIndex < self.m_cbCardCount) then
            --横向测试
            if (nXPos > math.floor((cbCurrentIndex*self.m_nDistance + self.m_sizeCard.width))) then
                break
            end
        
            -- 竖向测试
            local bShoot = self.m_CardItemArray[cbCurrentIndex].bShoot

            if ((bShoot==false) and (nYPos <= self.m_sizeCard.height)) then
                return cbCurrentIndex
            end
            if ((bShoot==true) and (nYPos >= math.floor(self.m_nShootDistance)-40)) then
                return cbCurrentIndex
            end
        end
    end
    
    return 0xff
end

function CardLayer:selectCard(indexStart, indexEnd)
    if (indexStart == 0xff or indexEnd == 0xff) then
        return
    end
    if (indexEnd < indexStart) then
        local temp = indexEnd
        indexEnd = indexStart
        indexStart = temp;
    end
    for Index = indexStart, indexEnd do
        local sp = self.m_vCardSp[Index]
        sp:setGray(true)
    end
end

function CardLayer:unSelectAllCard()
    if (self.m_nStartIndex==0xff or self.m_nEndIndex==0xff) then
        return
    end

    local indexStart = 0
    local indexEnd = self.m_cbCardCount
    if (indexEnd < indexStart) then
        local temp = indexEnd
        indexEnd = indexStart
        indexStart = temp
    end
    
    for Index = indexStart, indexEnd-1 do
        self.m_vCardSp[Index]:setGray(false)
    end
end

function CardLayer:SetShootArea(indexStart, indexEnd)
    if (indexStart==0xff or indexEnd==0xff) then
        return
    end
    if (indexEnd<indexStart) then
        indexStart, indexEnd = indexEnd, indexStart
    end

    -- 优化：在牌里找出顺子和连对 -------------------------
    local cbCardData = {}
    local cbCardCount = 0
    local cbCardResult = {}
    for i = indexStart, indexEnd do
        cbCardData[cbCardCount] = self.m_CardItemArray[i].cbCardData
        cbCardCount = cbCardCount + 1
    end

    --调试信息
    local stringCard = ""
    for k, v in pairs(cbCardData) do
        stringCard = stringCard .. getCardString(v) .. ","
    end
    print("点击的牌：", stringCard)
    
    local cbCount = 0
    if cbCount == 0 then --优先找顺子
        cbCount = LordGameLogic:getInstance():SearchLineCardType(cbCardData, cbCardCount, 0, 1, 0, cbCardResult)
    end
    if cbCount == 0 then --再次找连对
        cbCount = LordGameLogic:getInstance():SearchLineCardType(cbCardData, cbCardCount, 0, 2, 0, cbCardResult)
    end
    if cbCount == 0 then --没有连对和顺子,设置牌
        for Index = indexStart, indexEnd do
            self.m_CardItemArray[Index].bShoot = not self.m_CardItemArray[Index].bShoot
        end

    else --有连对/顺子,设置牌

        --调试信息
        local index = 0
        local count = cbCardResult.cbCardCount[index]
        local card = cbCardResult.cbResultCard[index]
        local stringCard = ""
        for i = 0, count - 1 do
            stringCard = stringCard .. getCardString(card[i]) .. ","
        end
        print("找到的牌：", stringCard)

        --所有牌
        indexStart = 0
        indexEnd = self.m_cbCardCount - 1

        --是否已经选中
        local cbResultCard = cbCardResult.cbResultCard[0]
        local nAllShoot = 0
        for i = indexStart, indexEnd do
            local cbCard = self.m_CardItemArray[i].cbCardData
            local bShoot = self.m_CardItemArray[i].bShoot
            if table.keyof(cbResultCard, cbCard) and bShoot then
                nAllShoot = nAllShoot + 1
            end
        end

        if nAllShoot == count then --如果牌已经被标记，清除
            for i = indexStart, indexEnd do
                local cbCard = self.m_CardItemArray[i].cbCardData
                if table.keyof(cbResultCard, cbCard) then
                    self.m_CardItemArray[i].bShoot = false
                end
            end
        else --如果牌没标记，标记牌号
            local cbResultCard = cbCardResult.cbResultCard[0]
            for i = indexStart, indexEnd do
                local cbCard = self.m_CardItemArray[i].cbCardData
                if table.keyof(cbResultCard, cbCard) then
                    self.m_CardItemArray[i].bShoot = true
                else
                    self.m_CardItemArray[i].bShoot = false
                end
            end
        end
    end
    ----------------------------------------------------
    
    --设置牌位移
    for Index = indexStart, indexEnd do
        local sp = self.m_vCardSp[Index]
        if (self.m_CardItemArray[Index].bShoot) then
            sp:setPositionY(self.m_nShootDistance)
        else
            sp:setPositionY(0)
        end
    end
end

function CardLayer:SetGray(bGray)
    self.m_bGray = bGray
    
    if (bGray) then
        if (self.m_cbCardCount > 0) then
            self:selectCard(0, self.m_cbCardCount-1)
        end
    else
        self.m_nStartIndex = 0
        self.m_nEndIndex = self.m_cbCardCount-1
        self:unSelectAllCard()
    end
end

function CardLayer:SetBanker(bBanker)
    self.m_bBanker = bBanker

    for i = 0, self.m_cbCardCount-1 do
        if i == self.m_cbCardCount-1 then
            self.m_vCardSp[i]:setBanker(bBanker)
        else
            self.m_vCardSp[i]:setBanker(false)
        end
    end
end

function CardLayer:setAllNotShoot()
    for Index = 0, self.m_cbCardCount - 1 do
        local sp = self.m_vCardSp[Index]
        sp:stopAllActions();
        local px = sp:getPositionX()
        if (self.m_CardItemArray[Index].bShoot) then
            self.m_CardItemArray[Index].bShoot = false
            self.m_vCardSp[Index]:setPosition(cc.p(px, 0))
        end
    end
    
    if self.m_pEvent then
        self.m_pEvent:LayerEventCallBack(1)
    end
end

function CardLayer:RemoveShootItem()
    --保存扑克
    local CardItemArray = {}
    for i = 0, self.m_cbCardCount - 1 do
        CardItemArray[i] = {}
        CardItemArray[i].bShoot = self.m_CardItemArray[i].bShoot
        CardItemArray[i].cbCardData = self.m_CardItemArray[i].cbCardData
    end
    
    --删除扑克
    local wRemoveCount = 0
    for  i = 0, self.m_cbCardCount-1 do
        if (CardItemArray[i].bShoot == true) then
            wRemoveCount = wRemoveCount + 1
            CardItemArray[i].cbCardData = 0x00
        end
    end
    
    --设置扑克
    if (wRemoveCount > 0) then
        local cbInsertCount = 0
        for i = 0, self.m_cbCardCount - 1 do
            if (CardItemArray[i].cbCardData ~= 0x00) then
                self.m_CardItemArray[cbInsertCount]=CardItemArray[i]
                cbInsertCount = cbInsertCount + 1
            end
        end
        
        --设置变量
        self.m_cbCardCount = self.m_cbCardCount-wRemoveCount;
    end
    
    --重拍卡牌精灵
    self:resetCardSp(false)
    return true
end

function CardLayer:SetShootCard(cbCardData, cbCardCount)
    if (cbCardCount > self.m_cbCardCount) then
        return false
    end
    local bChangeStatus = false
    
    --收起扑克
    for i=0, self.m_cbCardCount-1 do
        if (self.m_CardItemArray[i].bShoot == true) then
            bChangeStatus = true
            self.m_CardItemArray[i].bShoot = false
            
            if self.m_vCardSp[i] then
                self.m_vCardSp[i]:setPositionY(0)
            end
        end
    end
    --弹起扑克
    for i = 0, cbCardCount-1 do
        for j = 0, self.m_cbCardCount-1 do
            if self.m_CardItemArray[j].cbCardData == cbCardData[i] then
                if self.m_CardItemArray[j].bShoot == false then
                    bChangeStatus = true
                    self.m_CardItemArray[j].bShoot = true
                    self.m_vCardSp[j]:setPositionY(self.m_nShootDistance)
                    break
                end
            end
        end
    end
    
    if self.m_pEvent then
        self.m_pEvent:LayerEventCallBack(1)
    end
    
    return bChangeStatus
end

function CardLayer:GetShootCard()
    local cbCardData = {}
    local cbCardCount = 0

    for i=0, self.m_cbCardCount-1 do
        if (self.m_CardItemArray[i].bShoot) then
            cbCardData[cbCardCount] = self.m_CardItemArray[i].cbCardData
            cbCardCount = cbCardCount + 1
        end
    end
    
    return cbCardData, cbCardCount
end

function CardLayer:setEventCallBack(pEvent)
    self.m_pEvent = pEvent
end

function CardLayer:ClearGray()
    for i = 0, table.nums(self.m_vCardSp)-1 do
        self.m_vCardSp[i]:setGray(false)
    end
end

function CardLayer:downShoot(cbCardData, cbCardCount)
    self.m_bStillInAction = true
    --弹起扑克
    for i = 0, cbCardCount-1 do
        for j = 0, self.m_cbCardCount-1 do
            if self.m_CardItemArray[j].cbCardData == cbCardData[i] then
                local posX = self.m_vCardSp[j]:getPositionX()
                local pAction = cc.Sequence:create(
                    cc.Place:create(cc.p(posX, self.m_nShootDistance * 2)),
                    cc.DelayTime:create(0.75),
                    cc.EaseBackIn:create(cc.MoveTo:create(0.25, cc.p(posX, 0))),
                    cc.CallFunc:create(function()
                        self.m_bStillInAction = false
                    end))
                self.m_vCardSp[j]:runAction(pAction)
                break
            end
        end
    end
end

function CardLayer:getIsInAction()
    return self.m_bStillInAction
end

function CardLayer:checkOutCard(cbCardData, cbCardCount)
    --保存扑克
    local CardItemArray = {}
    for i = 0, self.m_cbCardCount-1 do
        CardItemArray[i] = {}
        CardItemArray[i].bShoot = self.m_CardItemArray[i].bShoot
        CardItemArray[i].cbCardData = self.m_CardItemArray[i].cbCardData
    end

    --删除扑克
    local wRemoveCount=0
    for i=0, self.m_cbCardCount-1 do
        for n = 0, cbCardCount-1 do
            if (CardItemArray[i].cbCardData == cbCardData[n]) then
                wRemoveCount = wRemoveCount + 1
                CardItemArray[i].cbCardData=0x00
            end
        end
    end
    
    --设置扑克
    if (wRemoveCount > 0) then
        local cbInsertCount = 0
        for  i=0, self.m_cbCardCount-1 do
            if (CardItemArray[i].cbCardData ~= 0x00) then
                self.m_CardItemArray[cbInsertCount]=CardItemArray[i]
                cbInsertCount = cbInsertCount + 1
            end
        end
        
        --设置变量
        self.m_cbCardCount = self.m_cbCardCount - wRemoveCount
        
        --重排卡牌精灵
        self:resetCardSp(false)
    end
end

function CardLayer:setCanTouch(CanTouch)
    self.m_bCanTouch = CanTouch
end

function CardLayer:getCanTouch()
    return self.m_bCanTouch
end

function CardLayer:setIndexPos(nIndex)
    self.m_iIndexPos = nIndex
end

return CardLayer
--endregion
