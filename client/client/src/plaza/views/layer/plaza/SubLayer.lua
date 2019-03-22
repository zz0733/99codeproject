--region
--Date
--此文件由[BabeLua]插件自动生成
--
--Desc: 1.初始化公共界面；2.监听和界面有关的事件

local SubLayer = class("SubLayer", cc.Node)


function SubLayer:ctor()
    self:enableNodeEvents()
end

function SubLayer:onEnter()
    self:initLayer()  --子界面
end

function SubLayer:onExit()
    self:clearLayer()   --移除界面
end

-- layer -----------------------
function SubLayer:initLayer()

    -- 浮动消息 ------------------
    local FloatMessage =  cc.exports.FloatMessage 
    FloatMessage.releaseInstance()
    local f = FloatMessage.getInstance()
    f:setPosition(0, -330)
    f:addTo(self, 10)
 
    -- 浮动消息 ------------------
    local FloatPopWait = cc.exports.FloatPopWait 
    FloatPopWait.releaseInstance()
    local m = FloatPopWait.getInstance()
    m:addTo(self, 20)

end

function SubLayer:clearLayer()
    FloatMessage.releaseInstance()
    FloatPopWait.releaseInstance()
end


return SubLayer

--endregion
