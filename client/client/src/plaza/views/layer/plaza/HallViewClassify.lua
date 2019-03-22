--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--region HallViewClassify.lua
--Date
--
--endregion
local ActivityRecommend = appdf.req(appdf.PLAZA_VIEW_SRC .. "ActivityRecommend")        --推荐活动
local HallGameListView  = appdf.req(appdf.PLAZA_VIEW_SRC .. "HallGameListViewNew")     --游戏列表
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
--大厅
local HallViewClassify = class("HallViewClassify", cc.Layer)

function HallViewClassify:ctor(scene)
    self:enableNodeEvents()
    self._scene = scene
    self.room_list_data = {}
    
    self.m_bClassifyShow = false
    self.m_iSelectIndex = 1
end

function HallViewClassify:onEnter()
    self:init()
end

function HallViewClassify:onExit()
    self:clear()
end

function HallViewClassify:init()
    self:initCSB()
    self:initBtnEvent()
end

function HallViewClassify:clear()

end

function HallViewClassify:initCSB()
    
    --self
    self:setPosition(0, 0)

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
   
    --init csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/HallViewMain.csb")
    self.m_rootUI:addChild(self.m_pathUI)

     self.m_pAction = cc.CSLoader:createTimeline("hall/csb/HallViewMain.csb")

    self.m_pNodeMain = self.m_pathUI:getChildByName("HallViewClassify"):getChildByName("node_main")
    --适配全面屏,全面屏有刘海要左移
    local diffX = 0
    if display.size.width == 1334 then
        diffX = 30
    else
        --为了刘海右移50个像素
        diffX = (1624-display.size.width)/2 + 50
    end
    self.m_pNodeMain:setPositionX(diffX)

    self.m_pNodeClasify = self.m_pNodeMain:getChildByName("node_classify")
    self.m_pImageMenu   = self.m_pNodeClasify:getChildByName("Image_Menu")
    self.m_pBtnAll      = self.m_pImageMenu:getChildByName("BTN_classify_all")
    self.m_pBtnArcade   = self.m_pImageMenu:getChildByName("BTN_classify_arcade")
    self.m_pBtnFish     = self.m_pImageMenu:getChildByName("BTN_classify_fish")
    self.m_pBtnTiger    = self.m_pImageMenu:getChildByName("BTN_classify_tiger")
    self.m_pBtnCard     = self.m_pImageMenu:getChildByName("BTN_classify_card")
    self.m_pAllBtns     = {self.m_pBtnAll, self.m_pBtnArcade, self.m_pBtnFish, self.m_pBtnTiger, self.m_pBtnCard}
    self.m_pBtnClassify = self.m_pNodeClasify:getChildByName("BTN_classify")
    self.m_pArmTouch    = self.m_pBtnClassify:getChildByName("Armature")

    self.m_pNodeGame = self.m_pNodeMain:getChildByName("node_game")
    self.m_pNodeRecommend = self.m_pNodeGame:getChildByName("node_activity") 
    self.m_pNodeGameList = self.m_pNodeGame:getChildByName("node_gamelist") 
    self.m_pBtnClassify:setVisible(false)
    self.m_pArmTouch:setVisible(false)
    self:showGameView()
end

--收到开关信息了现实游戏分类界面
function HallViewClassify:showGameView()
    self:showActivity()
    self:updateClassifyButton()
    self:createArrow()
    self:showGameList()
end

--显示推荐展示
function HallViewClassify:showActivity()
    local pageSize = self.m_pNodeRecommend:getContentSize()

    if self.m_pRecommend then
        self.m_pRecommend:removeFromParent()
        self.m_pRecommend = nil
    end

  --  self.m_pRecommend = ActivityRecommend:create(pageSize)
  --  self.m_pNodeRecommend:addChild(self.m_pRecommend)
end

--显示游戏列表
function HallViewClassify:showGameList()
 --游戏种类
    local classify = 
    {
       yl.GameClassifyType.GAME_CLASSIFY_ALL,         --全部游戏
       yl.GameClassifyType.GAME_CLASSIFY_ARCADE,      --多人游戏
       yl.GameClassifyType.GAME_CLASSIFY_FISH,        --捕鱼游戏
       yl.GameClassifyType.GAME_CLASSIFY_TIGER,      --街机游戏
       yl.GameClassifyType.GAME_CLASSIFY_CARD         --对战游戏

    }

    if self.m_pGameListView == nil then
        self.m_pGameListView = HallGameListView:create(self,self._scene)
        self.m_pGameListView:setVisible(true)
        self.m_pGameListView:addTo(self.m_pNodeGameList)
    end
    self.m_pGameListView:init(classify[self.m_iSelectIndex], self.m_bClassifyShow )
end

function HallViewClassify:getGameListView()
    return self.m_pGameListView
end

function HallViewClassify:initBtnEvent()
    -- 绑定按钮
    for i = 1, 5 do
        self.m_pAllBtns[i]:addClickEventListener(function()
            self:onItemClicked(i)
        end)
    end
     
    self.m_pBtnClassify:addClickEventListener(handler(self,self.onClassifyClicked)) 
end

function HallViewClassify:createArrow()
    local pBkgImg = cc.Sprite:createWithSpriteFrameName("hall/plist/hall/gui-hall-arrow-left.png")
    local pNormalSprite = cc.Scale9Sprite:createWithSpriteFrame(pBkgImg:getSpriteFrame())
    local pClickSprite = cc.Scale9Sprite:createWithSpriteFrame(pBkgImg:getSpriteFrame())
    self.m_pBtnLeftArrow = cc.ControlButton:create(pNormalSprite)
    self.m_pBtnLeftArrow:setBackgroundSpriteForState(pClickSprite,cc.CONTROL_STATE_HIGH_LIGHTED)
    self.m_pBtnLeftArrow:addTo(self.m_pNodeMain)
    self.m_pBtnLeftArrow:setAnchorPoint(cc.p(1,0.5))
    self.m_pLeftArrowX = 430
    self.m_pBtnLeftArrow:setPosition(cc.p(self.m_pLeftArrowX,360))
    local seq = cc.Sequence:create(cc.MoveBy:create(0.4, cc.p(-8,0)),cc.MoveBy:create(0.4, cc.p(8,0)))
    self.m_pBtnLeftArrow:runAction(cc.RepeatForever:create(seq))
    self.m_pBtnLeftArrow:registerControlEventHandler(handler(self, self.onLeftArrowClicked), cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE);
  
    local pBkgImg2 = cc.Sprite:createWithSpriteFrameName("hall/plist/hall/gui-hall-arrow-right.png")
    local pNormalSprite2 = cc.Scale9Sprite:createWithSpriteFrame(pBkgImg2:getSpriteFrame())
    local pClickSprite2 = cc.Scale9Sprite:createWithSpriteFrame(pBkgImg2:getSpriteFrame())
    self.m_pBtnRightArrow = cc.ControlButton:create(pNormalSprite2)
    self.m_pBtnRightArrow:setBackgroundSpriteForState(pClickSprite2,cc.CONTROL_STATE_HIGH_LIGHTED)
    self.m_pBtnRightArrow:addTo(self.m_pNodeMain)
    self.m_pBtnRightArrow:setAnchorPoint(cc.p(1,0.5))
    --适配全面屏,分类界面变大了,移动箭头
    local posX = display.size.width
    if display.size.width ~= 1334 then
        --全面屏增宽度,减去刘海不移动的距离
        posX  = display.size.width - 50
    end
    self.m_pBtnRightArrow:setPosition(cc.p(posX, 360))
    local seq2 = cc.Sequence:create(cc.MoveBy:create(0.4, cc.p(8,0)),cc.MoveBy:create(0.4, cc.p(-8,0)))
    self.m_pBtnRightArrow:runAction(cc.RepeatForever:create(seq2))
    self.m_pBtnRightArrow:registerControlEventHandler(handler(self, self.onRightArrowClicked), cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)

    self.m_pBtnLeftArrow:setVisible(false)
    self.m_pBtnRightArrow:setVisible(false)
end

function HallViewClassify:refreshArrow(leftVisible, rightVisible)
    self.m_pBtnLeftArrow:setVisible(leftVisible)
    self.m_pBtnRightArrow:setVisible(rightVisible)
end

function HallViewClassify:playArrowAction(isShowClassify)
    if not isShowClassify then 
        self.m_pBtnLeftArrow:runAction( cc.EaseBackIn:create(cc.MoveBy:create(0.25, cc.p(-110, 0))) )
    else
        self.m_pBtnLeftArrow:runAction( cc.EaseBackOut:create(cc.MoveBy:create(0.25, cc.p(110, 0))) )
    end
end
----------------------
---按钮事件响应
----------------------
function HallViewClassify:onItemClicked(index)
    ExternalFun.playClickEffect()
    self.m_iSelectIndex = index
    self:updateClassifyButton()
    self:showGameList()
end

function HallViewClassify:onClassifyClicked() -- 游戏分类
    ExternalFun.playClickEffect()
    self.m_pArmTouch:setVisible(true)
    self.m_pArmTouch:getAnimation():play("Animation1")
    self.m_pArmTouch:getAnimation():setMovementEventCallFunc( function(armature, eventType, data)
        if eventType == ccs.MovementEventType.complete then
              self.m_pArmTouch:setVisible(false)
        end
	end )

    local actionName = "showClassify"
    if self.m_bClassifyShow then 
        actionName = "hideClassify"
    end
    self.m_bClassifyShow = not self.m_bClassifyShow
    --self:playArrowAction(self.m_bClassifyShow)

    self.m_pBtnClassify:setTouchEnabled(false)
    self.m_pAction = cc.CSLoader:createTimeline("hall/csb/HallViewMain.csb")
    self.m_pathUI:runAction(self.m_pAction)

    self.m_pAction:play(actionName, false)
    if self.m_pGameListView then
        self.m_pGameListView:ReSizeScrollView( self.m_bClassifyShow )
    end
    local eventFrameCall = function(frame)  
       self.m_pAction:clearLastFrameCallFunc()
        self.m_pAction = nil
        self.m_pBtnClassify:setTouchEnabled(true)
    end
    self.m_pAction:setLastFrameCallFunc(eventFrameCall)
end

function HallViewClassify:onLeftArrowClicked(pSender)
    ExternalFun.playClickEffect()
    self.m_pGameListView:scrollToPercent(0)
end

function HallViewClassify:onRightArrowClicked(pSender)
    ExternalFun.playClickEffect()
    self.m_pGameListView:scrollToPercent(100)
end

----------------------
---界面更新
----------------------
function HallViewClassify:updateClassifyButton() -- 更新分类按钮
    for i = 1, 5 do
        self.m_pAllBtns[i]:setEnabled(true)
        if i == self.m_iSelectIndex then
            self.m_pAllBtns[i]:setEnabled(false)
        end
    end
end

function HallViewClassify:PlayAnimationBackToHall()
    self.m_pGameListView:PlayAnimationBackToHall()

    --推荐pageView
    local nodeX, nodeY = self.m_pNodeRecommend:getPosition()
    self.m_pNodeRecommend:setPosition(cc.p(nodeX - 500, nodeY))
    self.m_pNodeRecommend:runAction( cc.EaseBackOut:create(cc.MoveTo:create(0.5, cc.p(nodeX, nodeY))) )

    --self.m_pBtnClassify
    if not self.m_bClassifyShow  then
        local btnX, btnY = self.m_pBtnClassify:getPosition()
        self.m_pBtnClassify:setPosition(cc.p(btnX, btnY - 160))
        self.m_pBtnClassify:runAction( cc.EaseBackOut:create(cc.MoveTo:create(0.33, cc.p(btnX, btnY))) )
    end
end

return HallViewClassify


--endregion
