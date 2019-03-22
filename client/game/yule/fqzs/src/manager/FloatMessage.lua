--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


local FloatMessage = class("FloatMessage", cc.Node)  

local MAX_FLOAT_MSG_NUM = 3 --最大数量
local SPACE_OF_FLOATMESSAGE = 52 --每条间隔
local scale_x  = 1.0
local scale_y = 1.0
local PATH_FLOAT_MSG = "hall/image/file/gui-gm-fudtis.png"

FloatMessage.inst_ = nil
function FloatMessage.getInstance()
    if FloatMessage.inst_ == nil then
        FloatMessage.inst_ = FloatMessage.new()
    end
    return FloatMessage.inst_
end

function FloatMessage.releaseInstance()
    if FloatMessage.inst_ then
        FloatMessage.inst_:removeFromParent()
        FloatMessage.inst_ = nil
    end
end

function FloatMessage:ctor()    
    self:enableNodeEvents()
end

function FloatMessage:onEnter()
    self:initAll()
end

function FloatMessage:onExit()
    self:uninitUI()
end

function FloatMessage:initAll()

    self.msgNodes = {}
    self.vecNodes = {}
    self.vecPoint = {}
    self.m_queue  = {}
    self.m_pHead  = nil
    self.m_pTop   = nil

    self:initUI() --初始化UI
 
    self.m_onUpdateTicker = scheduler.scheduleGlobal(handler(self, self.updateTicker), 0.18)
end

function FloatMessage:updateTicker(dt)
    self:updateMessage()
end

function FloatMessage:initUI()
    
    local width = display.width
    local height = display.height
    local size = cc.size((width - 287) * scale_x, 66.0 * scale_y)
    local nTop =  height - 170
    
    for i = 1, MAX_FLOAT_MSG_NUM do
    
        self.vecPoint[i] = cc.p(0.0 * scale_x, (nTop - SPACE_OF_FLOATMESSAGE * i) * scale_y)

        --浮动条节点
        self.msgNodes[i] = cc.Node:create()
        self.msgNodes[i]:setContentSize(size)
--        self.msgNodes[i]:setIgnoreAnchorPointForPosition(false)
        self.msgNodes[i]:setAnchorPoint(cc.p(0,0))
        self.msgNodes[i]:setPosition(self.vecPoint[i])
        self.msgNodes[i]:setCascadeOpacityEnabled(true)
        self.msgNodes[i]:setVisible(false)
        self.msgNodes[i]:addTo(self)

        --浮动条box
        local sp = cc.Sprite:create(PATH_FLOAT_MSG)
--        sp:setIgnoreAnchorPointForPosition(false)
        sp:setCascadeOpacityEnabled(true)
        sp:setAnchorPoint(cc.p(0.5,0.5))
        sp:setPosition(cc.p(width/2 * scale_x, height/2 * scale_y))
        sp:setTag(1)
        sp:addTo(self.msgNodes[i])
        
        --浮动条label
        local lb = nil

        local node = {}
        node.m_pMsgNode = self.msgNodes[i]
        node.m_pLbText = lb
        node.m_pSpImage = sp
        node.m_pNextNode = nil
        node.m_pPreNode = nil
        node.m_iShow = SHOW_WAIT
        node.m_iIndex = i
        self.vecNodes[i] = node
    end
    
    -- 构建循环链表
    for i = 1, MAX_FLOAT_MSG_NUM do
        if i == 1 then
            self.vecNodes[i].m_pNextNode = self.vecNodes[i+1]
            self.vecNodes[i].m_pPreNode = self.vecNodes[MAX_FLOAT_MSG_NUM]
        elseif i == MAX_FLOAT_MSG_NUM then
            self.vecNodes[i].m_pNextNode = self.vecNodes[1]
            self.vecNodes[i].m_pPreNode = self.vecNodes[i-1]
        else
            self.vecNodes[i].m_pNextNode = self.vecNodes[i+1]
            self.vecNodes[i].m_pPreNode = self.vecNodes[i-1]
        end
    end
    self.m_pHead = self.vecNodes[1]
    self.m_pTop = self.m_pHead
end

function FloatMessage:uninitUI()

    scheduler.unscheduleGlobal(self.m_onUpdateTicker)

    self:removeAllChildren()
end

function FloatMessage:createColorText(text, node)

    if node.m_pLbText then
        node.m_pLbText:removeFromParent()
        node.m_pLbText = nil
    end

    local posX, posY = node.m_pSpImage:getPosition()

    --描边属性在text里

    --浮动条label
    local lb = ccui.RichText:create()
--    lb:setIgnoreAnchorPointForPosition(false)
    lb:setCascadeOpacityEnabled(true)
    lb:setAnchorPoint(0.5, 0.5)
    lb:setPosition(posX, posY)
    lb:initWithXML(text, {})
    lb:formatText()
    lb:addTo(node.m_pMsgNode)

    return lb
end

function FloatMessage:createNormalText(text, node)

    if node.m_pLbText then
        node.m_pLbText:removeFromParent()
        node.m_pLbText = nil
    end

    local posX, posY = node.m_pSpImage:getPosition()

    --普通字属性
    local fontSize = 32 --像素
    local fontColor = cc.c3b(0x1e, 0xff, 0x00) --绿色
    local outlineSize = 2 --像素
    local outlineColor = cc.c4b(0, 0, 0, 255) --黑色

    --浮动条label
    local lb = cc.Label:createWithSystemFont(text, "Helvetica", 32) 
--    lb:setIgnoreAnchorPointForPosition(false)
    lb:setCascadeOpacityEnabled(true)
    lb:setAlignment(cc.TEXT_ALIGNMENT_CENTER, cc.TEXT_ALIGNMENT_CENTER)
    lb:setAnchorPoint(0.5, 0.5)
    lb:setPosition(posX, posY)
    lb:setColor(fontColor)
    lb:enableOutline(outlineColor, outlineSize)
    lb:addTo(node.m_pMsgNode)

    return lb
end

function FloatMessage:updateMessage()
    
    --无消息
    if table.maxn(self.m_queue) <= 0 then
        return
    end

    --有消息
    local text = table.remove(self.m_queue, 1)

    self.m_pHead = self.m_pTop.m_pNextNode
    self.m_pTop = self.m_pHead
    local node = self.m_pHead
    local width = display.width
    local height = 750

    if node.m_pLbText then
        node.m_pLbText:stopAllActions()
        node.m_pLbText:setPosition(cc.p(width/2, node.m_pLbText:getPositionY()))
    end
    if node.m_pSpImageBg then
        node.m_pSpImageBg:stopAllActions()
    end
    if node.m_pSpImage then
        node.m_pSpImage:stopAllActions()
        node.m_pSpImage:setPosition(cc.p(width/2, node.m_pSpImage:getPositionY()))
    end
    
    if string.find(text, "</font>") then
        node.m_pLbText = self:createColorText(text, node)
    else
        node.m_pLbText = self:createNormalText(text, node)
    end

    local FIX_WIDTH = 1.20
    local MIN_WIDTH = 0.35
    local lb_width = node.m_pLbText:getContentSize().width
    local bg_width = node.m_pSpImage:getContentSize().width
    local scale_x = math.max(lb_width / bg_width * FIX_WIDTH, MIN_WIDTH)
    node.m_pSpImage:setScaleX(scale_x)
    
    local offY = SPACE_OF_FLOATMESSAGE
    local nY =  height - 170 - offY
    local pos = cc.p(0.0 * scale_x, nY * scale_y)
    
    node.m_pMsgNode:setVisible(true)
    node.m_pSpImage:setOpacity(1)
    node.m_pLbText:setOpacity(1)

    local nIn = 0.13
    local nDelay = 1.0
    local nOut = 0.13

    local nMove = 0.15
    
    local fadein = cc.FadeIn:create(nIn)
    local delay = cc.DelayTime:create(nDelay)
    local fadeout = cc.FadeOut:create(nOut)
    node.m_pSpImage:runAction(cc.Sequence:create(fadein,delay,fadeout))
    
    local fadein2 = cc.FadeIn:create(nIn)
    local delay2 = cc.DelayTime:create(nDelay)
    local fadeout2 = cc.FadeOut:create(nOut)
    node.m_pLbText:runAction(cc.Sequence:create(fadein2,delay2,fadeout2))

    node.m_pMsgNode:setPosition(cc.p(0.0 * scale_x, nY * scale_y - SPACE_OF_FLOATMESSAGE))
    
    if (node.m_pPreNode.m_pMsgNode:isVisible())then
        for j = 1, MAX_FLOAT_MSG_NUM do
            if node.m_pMsgNode:isVisible() then
                local xxx,yyy =  node.m_pMsgNode:getPosition()
                local pos = cc.p(xxx, nY + offY * (j - 1))
                local move = cc.EaseSineOut:create(cc.MoveTo:create(nMove, pos))
                local seq = cc.Sequence:create(move)
                node.m_pMsgNode:runAction(seq)
                node = node.m_pPreNode
            end
        end
    else
        local move = cc.EaseSineOut:create(cc.MoveTo:create(nMove, pos))
        local seq = cc.Sequence:create(move)
        node.m_pMsgNode:runAction(seq)
    end
end

function FloatMessage:pushMessage(text)

    if text == nil then
        return
    end

    if text == "" then
        return
    end

    if self:getParent() == nil then
        return
    end

    text = cc.exports.Localization_cn[text] or text

    table.insert(self.m_queue,text)
end

function FloatMessage:pushMessageWarning(text)
    
    if text == nil then
        return
    end

    if text == "" then
        return
    end

    if self:getParent() == nil then
        return
    end

    text = cc.exports.Localization_cn[text] or text

    local format = cc.exports.Localization_cn["WARNING_FORMAT"]

    local strText = string.format(format, text)

    table.insert(self.m_queue, strText)
end

function FloatMessage:pushMessageForString(text)

    self:pushMessage(text)
end

function FloatMessage:pushMessageDebug(text)
    
    if device.platform == "windows" then
        self:pushMessage(text)
    end
end

function FloatMessage:clearMessageQueue()
     self.m_queue = {}

     self:uninitUI()
     self:initAll()
end 

return FloatMessage

--endregion
