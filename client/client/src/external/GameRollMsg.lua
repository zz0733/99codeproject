--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local GameRollMsg = class("GameRollMsg", cc.Node)

local scheduler = cc.exports.scheduler

local MOVE_GameRollMsg = 2.0 --每帧文字移动距离
local RECT_GameRollMsg = cc.rect(0, 0, 640, 60) --剪切框大小
local STATE_IDLE = 0 --无消息状态
local STATE_PLAY = 1 --播放状态

local ARMATURE_BG = "public/effect/guangquan_Animation/guangquan_Animation.ExportJson"

function GameRollMsg:ctor()
    self:enableNodeEvents()
    
    self.m_root = nil
    self.m_pLbString = nil
    self.m_nState = nil 
    self.handle = nil
    self.m_bStartShow = false
    self.m_vText = {}
    self.m_rollRect = RECT_GameRollMsg
    self.m_fUpdateTime = cc.exports.gettime()
end

function GameRollMsg:onEnter()
    
    self:init()
end

function GameRollMsg:onExit()
    self:uninitUI()
end

function GameRollMsg:init()

    --节点
    self.m_root = display.newNode()
    self.m_root:addTo(self)

    --构造界面
    self:initWithSize(RECT_GameRollMsg)
    
    --初始化
    self.m_nState = STATE_IDLE
    self:setShowPosition()
    self.m_root:setVisible(false)
end

function GameRollMsg:initWithSize(rect)

    self.m_rollRect = rect or  RECT_GameRollMsg

    self.m_root:removeAllChildren()
    --背景
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(ARMATURE_BG)	
    self.m_pArmBg = ccs.Armature:create("guangquan_Animation")
    self.m_pArmBg:setPosition(cc.p(0,0))
    self.m_root:addChild(self.m_pArmBg)
    self.m_pArmBg:getAnimation():play("Animation1")

    --剪切窗口
    local stencil = display.newSprite()
    stencil:setTextureRect(self.m_rollRect)

    --剪切节点
    self.clipNode = cc.ClippingNode:create(stencil)
    self.clipNode:setInverted(false)
    self.clipNode:setPosition(cc.p(0, 0))
    self.clipNode:addTo(self.m_root)

    --滚动字
    self.m_pLbString = nil
end

function GameRollMsg:setStartShow(bShow)
    self.m_bStartShow = bShow
end

function GameRollMsg:setShowPosition(x, y)
    local pos_x = x or display.cx
    local pos_y = y or display.height - 30.0
    self.m_root:setPosition(pos_x, pos_y)
end

function GameRollMsg:addMessage(text) --添加显示
    
    if text == nil then return end
    if not self.m_bStartShow then return end

    --text =  "<font face='fonts/arial.ttf' size='26' color='#ff9ebe'>出大事了！<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>恭喜玩家<font face='fonts/arial.ttff' size='25' color='#08fd70'>东南亚小王子<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>斩获金宝箱超级大奖，获得<img src='public/image/gui-coin.png' height='35' width='35'></img><font face='fonts/arial.ttf' size='26' color='#f0d676'>999999999<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>奖池彩金，一秒变土豪!"
    if self.m_nState == STATE_IDLE then
        self:showMsg(text)
        self:startRoll()
    elseif self.m_nState == STATE_PLAY then
        if bFirst == true then
            table.insert(self.m_vText, 1, text)
        else
            table.insert(self.m_vText, text)
        end
    end
    self.m_posX, self.m_posY = self.m_root:getPosition()
end

function GameRollMsg:showMsg(msg) --显示文字
    
    self.m_root:setVisible(true)
    if self.m_pLbString then 
        self.m_pLbString:removeFromParent()
    end
    self.m_pLbString = ccui.RichText:create()
    self.m_pLbString:initWithXML(msg , {} )
    self.m_pLbString:setPosition(cc.p(self.m_rollRect.width / 2, 1))
    self.m_pLbString:setAnchorPoint(cc.p(0, 0.5)) 
    self.m_pLbString:addTo(self.clipNode)
    self.m_pLbString:formatText()

    --move 
    local moveTime = (self.m_rollRect.width+self.m_pLbString:getContentSize().width)/160
    local endPosX = -(self.m_rollRect.width/2+self.m_pLbString:getContentSize().width)
    local moveTo = cc.MoveTo:create(moveTime, cc.p(endPosX,1))
    local callBack = cc.CallFunc:create(function()
        if table.nums(self.m_vText) == 0 then
            self:stopRoll()
            self.m_root:setVisible(false)
        else
            self:showMsg(self.m_vText[1])
            table.remove(self.m_vText, 1)
        end
    end)
    local seq = cc.Sequence:create(moveTo, callBack)
    self.m_pLbString:runAction(seq)
end

function GameRollMsg:startRoll() --滚动文字
    self.m_nState = STATE_PLAY
end

function GameRollMsg:stopRoll() --停止滚动
    self.m_nState = STATE_IDLE
    if self.handle then
        scheduler.unscheduleGlobal(self.handle)
        self.handle = nil
    end
end

function GameRollMsg:cleanMessage()
    self:cleanupMessage()
end

function GameRollMsg:cleanupMessage() --清理
    self:stopRoll()
    
    --清理数据
    self.m_vText = {}
    --停止滚动
    self.m_root:stopAllActions()
    --隐藏滚动条
    self.m_root:setVisible(false)
    self.m_bStartShow = false
end

function GameRollMsg:uninitUI()
    
    if self.handle then
        scheduler.unscheduleGlobal(self.handle)
        self.handle = nil
    end
end

cc.exports.GameRollMsg = GameRollMsg
return GameRollMsg
    
--endregion
    
