--
-- Author: zhong
-- Date: 2016-11-02 17:28:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local module_pre = "game.yule.frogfish.src"
local cmd = appdf.req(module_pre .. ".models.CMD_Game")
local HeadSprite = require(appdf.EXTERNAL_SRC .. "HeadSprite")
local FishLoadingView = appdf.req(module_pre .. ".views.layer.FishLoadingView")
local FishMainView = appdf.req(module_pre .. ".views.layer.FishMainView")
local GameViewLayer = class("GameViewLayer",function(scene)
        local gameViewLayer = display.newLayer()
    return gameViewLayer
end)

function GameViewLayer:ctor(scene)
    --注册node事件
    ExternalFun.registerNodeEvent(self)
    self._scene = scene
    
    self.m_pGameLoadView = FishLoadingView.loading():addTo(self, 4)

    self:initEvent()
end


function GameViewLayer:reSetForNewGame()

end

function GameViewLayer:initEvent()
    self.__event = 
    {
        --游戏加载
        [Hall_Events.MSG_GAME_LOAD_SUCCESS]   = { func = self.event_game_load_ok,         log = "游戏加载完成", },
    }

    local function onMsgEvent(event)
        local name = event:getEventName()
        local msg = unpack(event._userdata)
        self.__event[name].func(self, msg)
    end

    for key, var in pairs(self.__event) do
        SLFacade:addCustomEventListener(key, onMsgEvent, self.__cname)
    end
end


function GameViewLayer:cleanEvent()
    
    for key in pairs(self.__event) do
        SLFacade:removeCustomEventListener(key, self.__cname)
    end
    self.__event = {}
end


function GameViewLayer:event_game_load_ok() --b.加载完成
     self.m_pGameMainView = FishMainView:create(self._scene):addTo(self, 7)
end


return GameViewLayer