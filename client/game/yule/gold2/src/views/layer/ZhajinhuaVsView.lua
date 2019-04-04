--ZhajinhuaVsView.lua
local mapName = {
	'22', '23', '24', '25', '26', '27', '28', '29', '210', '211', '212', '213', '214',
    '32', '33', '34', '35', '36', '37', '38', '39', '310', '311', '312', '313', '314',
    '12', '13', '14', '15', '16', '17', '18', '19', '110', '111', '112', '113', '114',
    '02', '03', '04', '05', '06', '07', '08', '09', '010', '011', '012', '013', '014',
	'xiaowang', 'dawang',
}

local cardPath = "common/card/%s.png"

local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local HeadSprite = require(appdf.EXTERNAL_SRC .. "HeadSprite")

local ZhajinhuaVsView = class("ZhajinhuaVsView", cc.Layer)

local SELF_UID = GlobalUserItem.tabAccountInfo.userid

function ZhajinhuaVsView.create()
    return ZhajinhuaVsView:new()
end

function ZhajinhuaVsView:ctor( )
    
    self.m_pathUI = cc.CSLoader:createNode("zhajinhua/VsCardView.csb")
    self.m_pathUI:addTo(self)
    if LuaUtils.isIphoneXDesignResolution() then
        self.m_pathUI:setPositionX(145)
    end

    self:initUI()

end

function ZhajinhuaVsView:initUI( ... )
    SLFacade:addCustomEventListener("animation_showInfo", handler(self, self.showInfo), self.__cname)
    SLFacade:addCustomEventListener("animation_startEnd", handler(self, self.showEnd), self.__cname)        -------------00

    SLFacade:dispatchCustomEvent("bipai_state",{ing = true})

    self.m_pBlack = self.m_pathUI:getChildByName("panel_black")
    self.m_vsFileNode = self.m_pathUI:getChildByName("fileNode_vsFileNode")
    self.m_nLeftHead = self.m_pathUI:getChildByName("node_leftHead")
    self.m_nRightHead = self.m_pathUI:getChildByName("node_rightHead")
    self.m_nLeftCard = self.m_pathUI:getChildByName("node_leftCardNode")
    self.m_nRightCard = self.m_pathUI:getChildByName("node_rightCardNode")
    self.m_nLeftLose = self.m_nLeftCard:getChildByName("node_leftlose")
    self.m_nRightLose = self.m_nRightCard:getChildByName("node_rightlose")

    self.m_nLeftHead:setVisible(false)
    self.m_nRightHead:setVisible(false)
    self.m_nLeftCard:setVisible(false)
    self.m_nRightCard:setVisible(false)

    self.winner_id = 0
end



function ZhajinhuaVsView:showEnd(event)                     ----------11
    local value = event._userdata
    local node = value == 2 and self.m_nLeftLose or self.m_nRightLose   
    self:showLoseAnimation(node)
    if node == self.m_nLeftLose then
        self:showWinAnimation(self.m_nRightLose)
    else
        self:showWinAnimation(self.m_nLeftLose)
    end
    node:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.FadeOut:create(0.1)))
    performWithDelay(node, function ()
--        if self.isHaveMe == true then
--            if self.winner_id ~= SELF_UID then
--    			cc.loaded_packages.KKMusicPlayer:playEffect("zhajinhua/sound/BIPAI_LOSE.mp3",false)
--    		else
--    			cc.loaded_packages.KKMusicPlayer:playEffect("zhajinhua/sound/BIPAI_WIN.mp3",false)
--    		end
--        else
--            cc.loaded_packages.KKMusicPlayer:playEffect("zhajinhua/sound/bipainome.mp3",false)
--        end

        self.m_nLeftHead:runAction(cc.Spawn:create(cc.MoveBy:create(0.3,cc.p(-100,0)),cc.FadeOut:create(0.3)))
        self.m_nLeftCard:runAction(cc.Spawn:create(cc.MoveBy:create(0.3,cc.p(-100,0)),cc.FadeOut:create(0.3)))

        self.m_nRightHead:runAction(cc.Spawn:create(cc.MoveBy:create(0.3,cc.p(100,0)),cc.FadeOut:create(0.3)))
        self.m_nRightCard:runAction(cc.Spawn:create(cc.MoveBy:create(0.3,cc.p(100,0)),cc.FadeOut:create(0.3)))
        
        --播放完end动画 结束
--        CommonHelper.playActionFunc("zhajinhua/vs.csb", "pk_end", self.m_vsFileNode, false,function ( ... )
--            self:onClose()
--        end ,"animation_endEnd")
        local action_end = cc.CSLoader:createTimeline("zhajinhua/vs.csb")
        self.m_vsFileNode:runAction(action_end)
        action_end:gotoFrameAndPlay(50,80, false)  --true循环播放，false 播放一次
        action_end:setLastFrameCallFunc(function()
            self:onClose()
        end)
   end,1.2)

end

function ZhajinhuaVsView:showInfo(event)        ------------------111
    self.m_nLeftHead:setVisible(true)
    self.m_nRightHead:setVisible(true)
    self.m_nLeftCard:setVisible(true)
    self.m_nRightCard:setVisible(true)
end

function ZhajinhuaVsView:showLoseAnimation(node)            ------------22
    local lose = cc.CSLoader:createNode("zhajinhua/animation/lose.csb")
    lose:setName("lose")
    node:addChild(lose)
--    CommonHelper.playActionLoop("zhajinhua/animation/lose.csb", "lose", lose, false)
    local action = cc.CSLoader:createTimeline("zhajinhua/animation/lose.csb")
    lose:runAction(action)
    action:gotoFrameAndPlay(0,5, false)  --true循环播放，false 播放一次
end
function ZhajinhuaVsView:showWinAnimation(node)             -------------22
    local win = cc.CSLoader:createNode("zhajinhua/animation/win.csb")
    win:setName("win")
    node:addChild(win)
--    CommonHelper.playActionLoop("zhajinhua/animation/win.csb", "win", win, false)
    local action = cc.CSLoader:createTimeline("zhajinhua/animation/win.csb")
    win:runAction(action)
    action:gotoFrameAndPlay(0,5, false)  --true循环播放，false 播放一次
end
                      --发起比牌的玩家  被比牌的玩家   获胜玩家  GameViewLayer
function ZhajinhuaVsView:setData(finfo, cinfo, win_uid,jinhuascene)    ---------------1

    self.isHaveMe = true
    if finfo:getUserid() ~= SELF_UID and cinfo:getUserid() ~= SELF_UID then
        self.isHaveMe = false
    else-- 有我，要把我的固定在左边
        if finfo:getUserid() == SELF_UID then --我的如果在右边，则交换下
            local temp = cinfo
            cinfo = finfo
            finfo = temp
        end
    end


    self:createHead(self.m_nRightHead:getChildByName("selfAvatar"), finfo, self.m_nRightHead:getChildByName("bg"),jinhuascene)
    self:createHead(self.m_nLeftHead:getChildByName("selfAvatar"), cinfo, self.m_nLeftHead:getChildByName("bg"),jinhuascene)



    self.m_nLeftHead:setVisible(true)
    self.m_nRightHead:setVisible(true)

    local function showFadeIn(obj)
        obj:setOpacity(0)
        obj:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.FadeIn:create(0.2)))
    end

    local function showFadeIn2(obj) --背景使用这个，直接渐入，不然头像的放大和移动不怎么明显
        obj:setOpacity(0)
        obj:runAction(cc.Sequence:create(cc.FadeIn:create(0.2)))
    end
    showFadeIn(self.m_nLeftHead:getChildByName("bg"))
    showFadeIn(self.m_nLeftHead:getChildByName("selfAvatar"))--norFrame
    showFadeIn(self.m_nRightHead:getChildByName("bg"))
    showFadeIn(self.m_nRightHead:getChildByName("selfAvatar"))--norFrame 
    showFadeIn2(self.m_pBlack)         
    showFadeIn(self.m_vsFileNode)     

    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ()
        if (not self) or (not self.m_vsFileNode) then
            print("清除数据消除了")
            if self.schedulerID then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            end            
            return
        end
        local win_id = win_uid-- cc.loaded_packages.ZhajinhuaModel:changeSeat(win_uid)
        self.winner_id = win_id--self.winner_id = winClientIndex
        local rOrL = finfo:getUserid() == win_uid and 2 or 1
        local ac2 = cc.CSLoader:createTimeline("zhajinhua/vs.csb")
        ac2:setFrameEventCallFunc(function (frame)
            -- body
            if frame:getEvent() == "animation_showInfo" then
                SLFacade:dispatchCustomEvent("animation_showInfo",rOrL)--dispatchEvent("animation_showInfo",rOrL) --
--                cc.loaded_packages.KKMusicPlayer:playEffect("zhajinhua/sound/bipaiyin.mp3",false)
                ExternalFun.playSoundEffect("bipaiyin.mp3")
            elseif frame:getEvent() == "animation_startEnd" then
                SLFacade:dispatchCustomEvent("animation_startEnd",rOrL)--dispatchEvent("animation_startEnd",rOrL)    --
            end
        end)
        if ac2:IsAnimationInfoExists("pk_start") == true then
            self.m_pathUI:runAction(ac2)
            ac2:gotoFrameAndPlay(0,45, false)  --true循环播放，false 播放一次
        end
       
        if self.m_vsFileNode then
            self.m_vsFileNode:runAction(ac2)
        end
    end,1.2,false)

end

function ZhajinhuaVsView:showCard(info,node)
    local clientindex = cc.loaded_packages.ZhajinhuaModel:changeSeat(info.seatindex)
    if info.cardslist and #info.cardslist > 0 and clientindex == 1 then
        for i = 1, 3 do
            local pngName = mapName[info.cardslist[i]]
            node:getChildByName("card_"..i):loadTexture(string.format(cardPath, pngName))
        end
    end
end
                             --头像节点  player  名字金币背景  
function ZhajinhuaVsView:createHead(node,info,bg,jinhuascene)   --------2
    
    local pox = info:getHeadPox()--jinhuascene:getHeadPoxByIndex(info.clientIndex)
    local _pox = node:getParent():convertToNodeSpace(pox)
    local oldPos =cc.p(node:getPosition())

    local head = HeadSprite:createNormal(info:getPlayerInfo(), 97)
    head:setPosition(cc.p(0,0))
    head:setAnchorPoint(cc.p(0,0))
    node:addChild(head)

    local name = bg:getChildByName("selfName")
    name:setString(info:getPlayerName())
    local money = bg:getChildByName("selfMoneyNum"):setVisible(false)

    head:getParent():setPosition(_pox)

    local moveto = cc.MoveTo:create(0.3, oldPos)
    local scaleTo = cc.ScaleTo:create(0.6, 1.2)
    local back = cc.ScaleTo:create(0.3, 1)
    head:getParent():runAction(cc.Sequence:create(scaleTo,back,moveto))

end

function ZhajinhuaVsView:createVSHead()
    
end

function ZhajinhuaVsView:onClose()
    SLFacade:dispatchCustomEvent("bipai_state",{ing = false})
	self:removeFromParent()
end

function ZhajinhuaVsView:onBack(  )
	self:onClose()
end

function ZhajinhuaVsView:onExit()
    SLFacade:removeCustomEventListener("animation_showInfo", self.__cname)
    SLFacade:removeCustomEventListener("animation_startEnd", self.__cname)
    if self.schedulerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)    
    end
end
return ZhajinhuaVsView