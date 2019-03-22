--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



local ProgressNode = class("ProgressNode", cc.Node)

local g_instance = nil
local scheduler = cc.Director:getInstance():getScheduler()
function ProgressNode.create()
    g_instance = ProgressNode:new():init()
    return g_instance
end

function ProgressNode:ctor()
    self.progress_timer_texture  = cc.Director:getInstance():getTextureCache():addImage("goold2zjh/zjh/timer.png")   
    self:enableNodeEvents()
    
    self.node = display.newNode()
    self:addChild(self.node)
    self.startGreen = 255
    self.startRed = 0
    self.startBlue = 0 
    self.m_percent = 100
    self.tag = 0
    self.m_countTime = 0
    self.m_addPercentage = 0.5
end

function ProgressNode:init()
    self.progress_image = cc.Sprite:createWithTexture(self.progress_timer_texture)
    self.progress_image:setColor(cc.c3b(self.startRed, self.startGreen, self.startBlue))
    self.progress_image:setAnchorPoint(cc.p(0.5,0.5))
    self.progress_image:setTag(self.tag)
--    self.node:addChild(self.progress_image)

    self.m_pProgressTimer = cc.ProgressTimer:create(self.progress_image)
    self.m_pProgressTimer:setType( cc.PROGRESS_TIMER_TYPE_RADIAL )
    self.m_pProgressTimer:setPosition(cc.p(0,0))
    self.m_pProgressTimer:setReverseDirection(true)
    self.m_pProgressTimer:setPercentage(self.m_percent)
    self.node:addChild(self.m_pProgressTimer)

    return self
end

--[[
    countTime（int）:计时时间
    c3b[r,g,b] :初始颜色
    imgUrl（string）: 图片位置
--]]
function ProgressNode:setParameters(countTime,table,imgUrl)
    if imgUrl then
        --self.progress_image:loadTexture(imgUrl, ccui.TextureResType.localType)
    end
    self.m_countTime = countTime
    self.m_red = table.r
    self.m_green = table.g
    self.m_blue = table.b
    self.m_pProgressTimer:setColor(table)
end

function ProgressNode:startCount()
    self.m_percent = 100
    self.m_updateTime = self.m_countTime / self.m_percent * self.m_addPercentage
    if self.count_down_handle then
        scheduler:unscheduleScriptEntry(self.count_down_handle)
    end

    local updateCountDown = function ()
        if self.m_countTime <= 0 then 
            self:stopCount()
            return 
        end
        if self.m_pProgressTimer then
            self.m_countTime = self.m_countTime - self.m_updateTime
        end
        self.m_percent = self.m_percent - self.m_addPercentage
        --self:updateColor()
        self.m_pProgressTimer:setPercentage(self.m_percent)
        self.m_pProgressTimer:setColor(cc.c3b(self.m_red, self.m_green, self.m_blue))
    end

    self.count_down_handle = scheduler:scheduleScriptFunc(function()
                updateCountDown()
            end, self.m_updateTime, false)
end

function ProgressNode:stopCount()
    self:cleanHandle()
    self:setVisible(false)
end

function ProgressNode:onExit()    
    self:cleanHandle()
end

function ProgressNode:cleanHandle()
    if self.count_down_handle then        
        scheduler:unscheduleScriptEntry(self.count_down_handle)
    end
    self.count_down_handle = nil
--    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("niuniu/plist/twoniuniu.plist")
--    cc.Director:getInstance():getTextureCache():removeTextureForKey("niuniu/plist/twoniuniu.png")
end



function ProgressNode:getGreen()
    self.m_green = self.startGreen - (100 - self.m_percent) * (self.startGreen) / 100
end

function ProgressNode:getRed()
    self.m_red = self.startRed + (100 - self.m_percent) * (255 - self.startRed) / 100
end

function ProgressNode:getBlue()

end

function ProgressNode:updateColor()
    self:getRed()
    self:getGreen()
    self:getBlue()
end

function ProgressNode:clean()
    self:cleanHandle()
    self:removeFromParent()
end



return ProgressNode


--endregion
