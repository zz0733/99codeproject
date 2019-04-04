--
-- Author: zhong
-- Date: 2016-11-04 11:36:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local HeadSprite = require(appdf.EXTERNAL_SRC .. "HeadSprite")

local SELF_UID = GlobalUserItem.tabAccountInfo.userid

local GameRoleItem = class("GameRoleItem")
GameRoleItem.ONEVENT_KANPAI_CLICK = "onEventButtonClickKanpai"   --点击看牌
GameRoleItem.ONEVENT_BIPAI_CLICK = "onEventButtonClickBipai"   --点击看牌
local mapName = {
--	'03','13','23','33',
--	'04','14','24','34',
--	'05','15','25','35',
--	'06','16','26','36',
--	'07','17','27','37',
--	'08','18','28','38',
--	'09','19','29','39',
--	'010','110','210','310',
--	'011','111','211','311',
--	'012','112','212','312',
--	'013','113','213','313',
--	'014','114','214','314',
	'22', '23', '24', '25', '26', '27', '28', '29', '210', '211', '212', '213', '214',
    '32', '33', '34', '35', '36', '37', '38', '39', '310', '311', '312', '313', '314',
    '12', '13', '14', '15', '16', '17', '18', '19', '110', '111', '112', '113', '114',
    '02', '03', '04', '05', '06', '07', '08', '09', '010', '011', '012', '013', '014',
	'xiaowang', 'dawang',
}
local cardPath = "common/card/%s.png"
local myScale = {x = 0.615, y = 0.616}

function GameRoleItem:ctor( myPos_, playerInfo_, mPanelPlayer_, animationPanel_, midCenterNode_)

    self.centerPosition = myPos_
    self.playerInfo = playerInfo_
    self.playerPanel = mPanelPlayer_
    self.animationPanel = animationPanel_
    self.midCenterNode = midCenterNode_
    
    
    self:initVar()
    self:initPlayerNode()

    return self
end
function GameRoleItem:initVar()
    self.chairID = 0
    self.playerNode = nil
    self.m_cardsPos = {}
    self.uid = self.playerInfo.uid
    self.m_cardstype = -1   --牌的类型
    self.isKanPai = false   --是否看牌
    self.isQipai = false    --是否弃牌或比牌失败
    self.m_xiazhuMoney = 0  --下注的钱
    self.m_bagMoney = 0     --身上剩余的钱
    self.allHander = {}     --存放所有的定时器
end
function GameRoleItem:initPlayerNode()
    if self.playerInfo.position < self.centerPosition then
        self.chairID = self.playerInfo.position+2
    elseif self.playerInfo.position > self.centerPosition then
        self.chairID = self.playerInfo.position+1
    else 
        self.chairID = 1
    end
    self.playerNode = self.playerPanel:getChildByName("fileNode_player_"..self.chairID)
    self.m_pPanelBg = self.playerNode:getChildByName("panel_playerInfoBg")              --玩家panel BG
    self.m_pNodeSelfInfomation = self.m_pPanelBg:getChildByName("Node_selfInfomation")  --个人信息
    self.m_pImageIcon = self.m_pNodeSelfInfomation:getChildByName("image_selfAvatar")   --头像
    self.m_pTextName = self.m_pNodeSelfInfomation:getChildByName("Image_5"):getChildByName("text_selfName") --昵称
    self.m_pTextMoney = self.m_pNodeSelfInfomation:getChildByName("Image_5"):getChildByName("text_selfMoneyNum")    --身上的钱
    self.m_pTextXiazhu = self.m_pNodeSelfInfomation:getChildByName("image_xiazhuBg"):getChildByName("text_xiazhu")  --下注的钱
    self.m_pPanelBg:getChildByName("image_zhuangImg"):setVisible(false)                 --庄家的标志
    self.m_pPanelCards = self.m_pPanelBg:getChildByName("node_cards")                   --扑克层
    self.headPos = cc.p(self.m_pImageIcon:getPosition())
    local nnPos = self.m_pPanelBg:convertToWorldSpace(self.headPos)
    self.worldHeadPos = self.animationPanel:convertToNodeSpace(cc.p(nnPos))

    self.m_pPanelShowResult = self.m_pPanelCards:getChildByName("panel_showResultPanel")
    self.m_pImageKanpai = self.m_pPanelCards:getChildByName("image_yikan")              --是否看牌的标志
    self.m_pPanelZhuangtai = self.m_pPanelCards:getChildByName("image_zhuangtai")       --比牌结果背景
    self.m_pTextZhuangtai = self.m_pPanelZhuangtai:getChildByName("text_cardResultText")--比牌结果状态
    self.m_pBtnKanpai = self.m_pPanelBg:getChildByName("button_kanpai")                 --按钮 看牌    
    self.p_imageZhuangtai = self.m_pPanelBg:getChildByName("image_zhuangtaiImg")        --跟注或者加注状态
    self.m_pNodeWintype = self.m_pPanelBg:getChildByName("node_wintypeNode")            --获胜节点
    self.m_pNodeAnimation = self.m_pPanelBg:getChildByName("node_showAnimationNode")    --动画节点
    
    if self.chairID ~= 1 then
        self.m_pBtnKanpai:setVisible(false)
        self.m_pPanelBg:getChildByName("image_reConnectBg"):setVisible(false)   --断线
    end
    self.m_pPanelBg:addClickEventListener(handler(self,self.onBipaiClick))
    self.m_pBtnKanpai:addClickEventListener(handler(self,self.onKanpaiClick))
    --------------------初始化隐藏
    self.m_pImageKanpai:setVisible(false)       --是否看牌的标志
    self.m_pPanelZhuangtai:setVisible(false)     --比牌结果状态
    self.m_pBtnKanpai:setVisible(false)         --按钮 看牌
    self.p_imageZhuangtai:setVisible(false)     --跟注或者加注状态
    self.m_pNodeWintype:setVisible(false)       --获胜节点
    --------------------加载数据
    self.playerNode:setVisible(true)
    self.m_pTextName:setString(self.playerInfo.nickname)
    self.m_pTextMoney:setString(self.playerInfo.into_money)
    self.m_xiazhuMoney = 0  --下注的钱
    self.m_bagMoney = self.playerInfo.into_money     --身上剩余的钱
    self.m_pTextXiazhu:setString(0)
    local head = HeadSprite:createNormal(self.playerInfo, 97)
    head:setPosition(cc.p(0,0))
    head:setAnchorPoint(cc.p(0,0))
    self.m_pImageIcon:addChild(head)
    for i = 1, 3 do
        self.m_cardsPos[i] = self.m_pPanelCards:convertToWorldSpace(cc.p(self.m_pPanelCards:getChildByName("image_card_"..i):getPosition()))
        self.m_cardsPos[i] = self.animationPanel:convertToNodeSpace(self.m_cardsPos[i])
    end
end
function GameRoleItem:onKanpaiClick()
    SLFacade:dispatchCustomEvent(GameRoleItem.ONEVENT_KANPAI_CLICK)
end
--比牌事件
function GameRoleItem:onBipaiClick()
    SLFacade:dispatchCustomEvent(GameRoleItem.ONEVENT_BIPAI_CLICK,{uid = self.uid})
end
--当玩家离开
function GameRoleItem:onEventPlayerLeave()
    self.playerNode:setVisible(false)
    self.m_pImageKanpai:setVisible(false)       --是否看牌的标志
    self.m_pPanelZhuangtai:setVisible(false)     --比牌结果状态
    self.m_pBtnKanpai:setVisible(false)         --按钮 看牌
    self.p_imageZhuangtai:setVisible(false)     --跟注或者加注状态
    self.m_pNodeWintype:setVisible(false)       --获胜节点
end
--当玩家准备
function GameRoleItem:onEventPlayerReady()

end
--当玩家比牌失败
function GameRoleItem:onPlayerVSLose()
    self.p_imageZhuangtai:loadTexture("zhajinhua/image/zjh_033.png")
end
--当玩家弃牌
function GameRoleItem:onEventPlayerDrop()
    self.isQipai = true
    self.p_imageZhuangtai:setVisible(true)
    self.p_imageZhuangtai:loadTexture("zhajinhua/image/zjh_035.png")
    self:showResultCard(2)
    if self.chairID == 1 then
        self:showDoActionResult("弃牌")
    end
--    self:stopCD()
--    self:clearReconnect()
    self:showPlayerState(5)
    self.m_pImageKanpai:setVisible(false)
end
--当玩家看牌
function GameRoleItem:onEventPlayerShow(bufferData)
    local cpyvalue = bufferData.cards
    self.m_cardstype = bufferData.card_type
    self.isKanpai = true
    if bufferData.uid ~= SELF_UID then
        self.m_pImageKanpai:setVisible(true)
    else
        local function moveEnd(node,value)
            if value.index == 3 then
                for i = 1, 3 do
                    local pngName = mapName[cpyvalue[i]+1]--通过牌数据得到对应资源名字
                    self.m_pPanelCards:getChildByName("image_card_"..i):loadTexture(string.format( cardPath,pngName))
                end                
                self:showCardType()
                self.isCanLiangPai = true
            end
        end
        local endPos = cc.p(self.m_pPanelCards:getChildByName("image_card_1"):getPosition())
        local moveEndPos = {}
        for i = 1,3 do
            local card = self.m_pPanelCards:getChildByName("image_card_"..i)
            moveEndPos[i] = cc.p(card:getPosition())
        end
        for i = 1, 3 do 
            if i ~= 1 then
                local card = self.m_pPanelCards:getChildByName("image_card_"..i)
                local moveto = cc.MoveTo:create(0.15, endPos)
                local moveback = cc.MoveTo:create(0.15, moveEndPos[i])
                local _lastFun = cc.CallFunc:create(moveEnd,{index = i})
                if card:getActionByTag(i) then
                    return 
                end
                local ac = cc.Sequence:create(moveto,_lastFun,moveback)
                ac:setTag(i)
                card:runAction(ac)
            end
            self.m_pPanelCards:getChildByName("image_card_"..i):setVisible(true)
        end
    end
end
--当玩家跟注 #isGenzhu  true跟注 false加注
function GameRoleItem:onEventPlayerAdd(bufferData , isGenzhu)
    self.p_imageZhuangtai:setVisible(true)
    if isGenzhu == true then
        self.p_imageZhuangtai:loadTexture("zhajinhua/image/zjh_034.png")
    else
        self.p_imageZhuangtai:loadTexture("zhajinhua/image/zjh_032.png")
    end
end
--飞牌动作完成，展示原来固定的牌
function GameRoleItem:showCard()
    self.m_pPanelCards:setVisible(true)
    for i = 1, 3 do
        self.m_pPanelCards:getChildByName("image_card_"..i):show()
        if self.chairID == 1 then
            self.m_pPanelCards:getChildByName("image_card_"..i):setColor(cc.c3b(255, 255, 255))
        end
    end
end
--结算时展示牌面
function GameRoleItem:setCardValue( data_,type_ )
    if #data_ == 0 then
        return
    end
    self:showCard()
    local cpyvalue = data_
    self.m_cardstype = type_
    for i = 1, 3 do
        local pngName = mapName[cpyvalue[i]+1]--通过牌数据得到对应资源名字
        self.m_pPanelCards:getChildByName("image_card_"..i):loadTexture(string.format( cardPath,pngName))
    end                
    self:showCardType()
end
function GameRoleItem:centerCoinToHead()
    local allCoin = self.animationPanel:getChildren()
--    cc.loaded_packages.KKMusicPlayer:playEffect("zhajinhua/sound/GET_GOLD.mp3",false)
    ExternalFun.playSoundEffect("GET_GOLD.mp3")
    for k,v in pairs(allCoin) do
        v:runAction(cc.Sequence:create(cc.MoveTo:create(0.5,cc.p(self.worldHeadPos)),cc.RemoveSelf:create()))
    end
end
function GameRoleItem:delayCenterCoinToHead()--cc.Director:getInstance():getScheduler():unscheduleScriptEntry
    self.allHander[4] = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ()
       self:centerCoinToHead()
       cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.allHander[4])
       self.allHander[4] = nil
    end,2,false)
end
function GameRoleItem:playGetCoinAnimation()
	if self.m_pImageIcon:getChildByName("GetCoinAnimation")  then
		return 
	end
    local anim = cc.CSLoader:createNode("common/game_common/efftct_win/effect_win.csb")
	anim:setPosition(cc.p(self.m_pImageIcon:getContentSize().width/2,self.m_pImageIcon:getContentSize().height/2))--(winPlayerPos.x ,winPlayerPos.y - 7))
	anim:setName("GetCoinAnimation")
	self.m_pImageIcon:addChild(anim)
    local action = cc.CSLoader:createTimeline("common/game_common/efftct_win/effect_win.csb")
    anim:runAction(action)
    action:gotoFrameAndPlay(0,34, true)  --true循环播放，false 播放一次

    self.allHander[2] = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        if self.m_pImageIcon then
            local node = self.m_pImageIcon:getChildByName("GetCoinAnimation")
            if node then
                node:stopAllActions()
                self.m_pImageIcon:removeChildByName("GetCoinAnimation")
             end
        end
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.allHander[2])
        self.allHander[2] = nil
    end,1.8,false)
end
function GameRoleItem:showWinMoney(winMoney,label)
    local winLable = label:clone()
    winLable:setPosition(cc.p(0,0))
    self.m_pImageIcon:addChild(winLable)
    winLable:setString(string.format('+%d$', winMoney))--('+%.2f$', winMoney))
    winLable:runAction(cc.Sequence:create(
        cc.MoveBy:create(1, cc.p(0, 50)),
        cc.CallFunc:create(function ()
--            if self.uid == SELF_UID then
--                if self.m_pNodeAnimation:getChildByName("waiting") then
--                else
--                    dispatchEvent("zjh_ShowNextRoundTime",4)
--                end
--            else
--                dispatchEvent("zjh_ShowNextRoundTime",5)
--            end
--            dispatchEvent("zjh_CheckingEnoughMoney")
        end),
        cc.DelayTime:create(0.5),
        cc.RemoveSelf:create()
    ))
end
function GameRoleItem:showWinCardType()

    if self._seatInfo and self._seatInfo.cardstype and self._seatInfo.cardstype >= 0 then
        self:clearWinType()
        local cardstype = self._seatInfo.cardstype + 1
        local pathStr = "zhajinhua/image/%s.png"
        local pathName = {"text_dly","text_gpy","text_dzy","text_szy","text_jhy","text_sjy","text_bzy"}
        local sp = display.newSprite(string.format( pathStr,pathName[cardstype]))
        sp:setAnchorPoint(cc.p(0.5,0.5))
        if self.index == 1 then
            -- sp:setScale(132/98)
            sp:setPosition(cc.p(-195,60))
        elseif self.index == 4 or self.index == 5  then
            sp:setPosition(cc.p(-170,60))
        else
            sp:setPosition(cc.p(170,60))
        end

        self.m_pNodeWintype:addChild(sp)
        self.p_imageZhuangtai:setVisible(false)
    else
        dump(self._seatInfo,"但前数据")
        print("有错误显示不出来------------------------------")
        dump(self._seatInfo,"self._seatInfo==")
    end
end
function GameRoleItem:clearSelfWinAnimation()
    self.animationPanel:removeChildByName("niyingle")
end 
function GameRoleItem:delayShowWinMoney(value, parent)
    self.allHander[3] = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ()
        self:playGetCoinAnimation()
        self:showWinMoney(value, parent) --改为净胜
--        self:showWinCardType()          --豹子赢/对子赢等等
--        self:freshMoneyNo()           --刷新钱包
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.allHander[3])
        self.allHander[3] = nil
        if self.uid == SELF_UID then
            self:clearSelfWinAnimation()
        end
    end,2,false)
end
function GameRoleItem:showSelfWinAnimation()

    local callF = function()
--        cc.loaded_packages.KKMusicPlayer:playEffect("zhajinhua/sound/GAME_WIN.mp3",false)
        ExternalFun.playSoundEffect("GAME_WIN.mp3")
        local niyingle = cc.CSLoader:createNode("zhajinhua/niyingle.csb")
        niyingle:setName("niyingle")
        niyingle:setPosition(cc.p(display.cx,display.cy+80))
        if LuaUtils.isIphoneXDesignResolution() then
            niyingle:setPosition(cc.p(display.cx-129,display.cy+80))
        end
        self.animationPanel:addChild(niyingle,1000)
        local action = cc.CSLoader:createTimeline("zhajinhua/niyingle.csb")
        niyingle:runAction(action)
        action:gotoFrameAndPlay(0,40, false)  --true循环播放，false 播放一次
    end
    self.m_pPanelBg:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(callF)))
end
function GameRoleItem:getCardsPos()
    return self.m_cardsPos
end
function GameRoleItem:getUserid()
    return self.uid
end
function GameRoleItem:getChairId()
    return self.chairID
end
function GameRoleItem:getIsKanPai()
    return self.isKanpai
end
function GameRoleItem:getIsQiPai()
    return self.isQipai
end
function GameRoleItem:isCanPai(can) --看牌标志    
    self.m_pImageKanpai:setVisible(can)
end
function GameRoleItem:showKanpaiButton( isShow )    --看牌按钮
    if self.isKanpai == true then
        self.m_pBtnKanpai:setVisible(false)
        return
    end
    self.m_pBtnKanpai:setVisible(isShow)
end
function GameRoleItem:showCardType(  )
    print("cardType___________________"..self.m_cardstype)
    self.m_pNodeWintype:setVisible(true)
    if self.m_cardstype and self.m_cardstype >= 0 then
        local cardstype = self.m_cardstype +1
        local pathStr = "zhajinhua/image/%s.png"
        local pathName = {"zjh_053","zjh_054","zjh_055","zjh_057","zjh_056","zjh_058","zjh_052"}

        local back = cc.Sprite:create("zhajinhua/image/zjh_059.png")
        if cardstype == 1 then
            back = cc.Sprite:create("zhajinhua/image/zjh_060.png")
        end
        if self.chairID == 1 then
            back:setScale(132/98)
        end

        self.m_pNodeWintype:addChild(back)--self.m_pPanelShowResult:addChild(back)--self.wintypeNode:addChild(back)
        local sp = cc.Sprite:create(string.format( pathStr,pathName[cardstype]))
        sp:setPosition(cc.p(83.5,16))
        back:addChild(sp)
    end
end
function GameRoleItem:showResultCard( resultType )
    print("显示是否为比牌失败或者弃牌")
    dump(self._seatInfo, "显示结算时的值")
--    if self._seatInfo  == nil then
--        return
--    end
--    if self._seatInfo.cardslist and #self._seatInfo.cardslist > 0 then
--        return 
--    end
    if self.chairID == 1 then
        return
    end
    for i = 1, 3 do
        self.m_pPanelCards:getChildByName("image_card_"..i):setVisible(false)
    end
    self.m_pPanelShowResult:setVisible(true)
    local size = self.m_pPanelShowResult:getContentSize()
    local function cmpfail()
        print("顯示失敗的得圖片")
        for i = 1, 3 do
            local sp
            if i == 3 then
                sp = cc.Sprite:create('zhajinhua/image/poker_1.png')
            else
                sp = cc.Sprite:create('zhajinhua/image/poker_2.png')
            end
            if self.index == 1 then
                sp:setScaleX(myScale.x)
                sp:setScaleY(myScale.y)
                sp:setPosition(
                    cc.p(sp:getContentSize().width / 2 * myScale.x - 2 + sp:getContentSize().width * (i - 1) * 0.41 , size.height / 2)
                 )
            else
                sp:setScaleX(0.49)
                sp:setScaleY(0.48)
                sp:setPosition(
                    cc.p(sp:getContentSize().width / 2 * 0.4-2 + sp:getContentSize().width * (i - 1) * 0.32, size.height / 2)
                )
            end
            self.m_pPanelShowResult:addChild(sp)
        end
    end

    local function givecard()
        for i = 1, 3 do
            local sp = cc.Sprite:create('zhajinhua/image/poker_2.png')
            self.m_pPanelShowResult:addChild(sp, i)
            if self.index == 1 then
                sp:setScaleX(myScale.x)
                sp:setScaleY(myScale.y)
                sp:setPosition(
                    cc.p(sp:getContentSize().width / 2 * myScale.x - 2 + sp:getContentSize().width * (i - 1) * 0.41 , size.height / 2)
                 )
            else
                sp:setScaleX(0.49)
                sp:setScaleY(0.48)
                sp:setPosition(
                    cc.p(sp:getContentSize().width / 2 * 0.4-2 + sp:getContentSize().width * (i - 1) * 0.32, size.height / 2)
            )
            end            
        end
    end
    if resultType == 1 then
        cmpfail()
    elseif resultType == 2 then
        givecard()
    end
end
function GameRoleItem:showDoActionResult(content)

    self.m_pPanelZhuangtai:setVisible(true)--比牌结果背景
    self.m_pTextZhuangtai:setString(content)--比牌结果状态

    if self.chairID == 1  then
        self.m_pNodeWintype:removeAllChildren()
        self.m_pNodeWintype:setVisible(false)
    end
end

function GameRoleItem:showPlayerState(state)
    -- 1全压 2加注 3淘汰 4跟住 5弃牌
    self.p_imageZhuangtai:setVisible(true)
    local path = 'zhajinhua/image/%s.png'
    local name = ''
    if state == 1 then
        name = 'zjh_031'
    elseif state == 2 then
        name = 'zjh_032'
    elseif state == 3 then
        name = 'zjh_033'
    elseif state == 4 then
        name = 'zjh_034'
    elseif state == 5 then
        name = 'zjh_035'
--        self:stopCD()
    end
    self.p_imageZhuangtai:loadTexture(string.format(path, name))

    if  self.chairID == 1 then
        if state == 3 or state == 5  then
            for i = 1, 3 do
                self.m_pPanelCards:getChildByName("image_card_"..i):setColor(cc.c3b(0x99, 0x96, 0x96))
            end
        end
    end
end
--展示动画 可以被比牌
function GameRoleItem:showSelectAnimation()
    if self.chairID == 1 then
        return 
    end

    if self.m_pPanelBg:getChildByName("jiantou") and self.m_pPanelBg:getChildByName("bink") then
        return
    end

    self.m_pPanelBg:setTouchEnabled(true)
    local size = self.m_pPanelBg:getContentSize()
    local jiantou = cc.CSLoader:createNode("zhajinhua/jiantou.csb")
    local ansize = jiantou:getContentSize()
    if self.chairID >= 4 then
        jiantou:setPosition(cc.p(size.width*1.4, size.height * 0.32))
    elseif self.chairID>= 2 then
        jiantou:setPosition(cc.p(-size.width*0.4, size.height  * 0.6))
        jiantou:setRotation(180)
    end 
    jiantou:setName("jiantou")
    self.m_pPanelBg:addChild(jiantou)
    local action = cc.CSLoader:createTimeline("zhajinhua/jiantou.csb")
    jiantou:runAction(action)
    action:gotoFrameAndPlay(0,50, true)  --true循环播放，false 播放一次

    local bink = display.newSprite("zhajinhua/image/binklight.png")
    bink:setPosition(cc.p(size.width/2,size.height/2))
    bink:setName("bink")
    self.m_pPanelBg:addChild(bink)
end
--清除选择比牌动画
function GameRoleItem:clearSelectAnimation()
    local jiantou = self.m_pPanelBg:getChildByName("jiantou")
    if jiantou then
        jiantou:stopAllActions()
        jiantou:removeSelf()
    end
    local bink = self.m_pPanelBg:getChildByName("bink")
    if bink then
        bink:removeSelf()
    end
end
function GameRoleItem:getHeadPox()
    
    local nnPos = self.m_pPanelBg:convertToWorldSpace(self.headPos)
    return nnPos
end
function GameRoleItem:setIsQipai( isqipai)
    self.isQipai = isqipai
end
function GameRoleItem:getPlayerName()   
    return self.playerInfo.nickname
end
function GameRoleItem:getPlayerInfo()   
    return self.playerInfo
end
function GameRoleItem:flytoCenterCoin(value)

    local array = {}
    local rotate = math.random(-75, 75)
    local kanpai = self.isKanpai
    if kanpai == true then
        array[1] = value/2
        array[2] = value/2
    else    
        array[1] = value
    end
    local chipPath = "common/game_common/chip/cm_gloden_1.png"
    for i = 1, #array do
        local endPos = self:getEndCoinPos()
        print("下注的筹码是____________________________"..array[i])
        local sprite = cc.Sprite:create(string.format(chipPath))--, array[i]))
        sprite:setPosition(self.worldHeadPos)
        local p = math.random(10) > 5 and -1 or 1
        local roto = cc.Sequence:create( cc.RotateBy:create(0.25+ (i -1)*0.1, rotate * p))
--        if array[i] < 100 then
--			sprite:setScale(0.65)
--		end
        sprite:setScale(0.65)
        self.animationPanel:addChild(sprite)
        local move = cc.EaseSineOut:create(cc.MoveTo:create(0.25+ (i -1)*0.1, cc.p(endPos.x, endPos.y)))
        local accc = cc.Spawn:create(roto,move,
        cc.CallFunc:create(function ()
--            cc.loaded_packages.KKMusicPlayer:playEffect("zhajinhua/sound/ADD_GOLD.mp3",false)
            ExternalFun.playSoundEffect("ADD_GOLD.mp3")
        end))
        sprite:runAction(accc)
    end   
end
function GameRoleItem:getEndCoinPos()
    local centerPos = cc.p(self.midCenterNode:getPosition())
    local rOrL = math.random() > 0.5 and 1 or -1
    local yRandom = math.random(50, 260)
    local y = centerPos.y - yRandom
    local xx = math.sqrt((260 - yRandom) * 2 * 120)
    local x = centerPos.x - math.random(0, xx) * (rOrL) 
    return cc.p(x, y)
end
function GameRoleItem:updateMoney( bagMoney,xiazhuMoney )    
    self.m_bagMoney = bagMoney     --身上剩余的钱
    self.m_pTextMoney:setString(self.m_bagMoney)
    self.m_xiazhuMoney = xiazhuMoney  --下注的钱
    self.m_pTextXiazhu:setString(self.m_xiazhuMoney)
end
function GameRoleItem:showthrowMoney()
    self.m_pTextXiazhu:setString(self.m_xiazhuMoney)
end
function GameRoleItem:clearLoseAnimation()
    local node = self.m_pPanelBg:getChildByName("loseAnimation")
    if node then
        node:stopAllActions()
    end
    self.m_pNodeAnimation:removeChildByName("loseAnimation")
end
function GameRoleItem:clearAllLight()
    local node = self.m_pPanelBg:getChildByName("alllight")
    if node then
        node:stopAllActions()
    end
    self.m_pPanelBg:removeChildByName("alllight")
end
function GameRoleItem:stopCD()
    self.didi = false
    self.m_pPanelBg:stopActionByTag(self.chairID)
    for i=1,4 do
        local view = self.m_pPanelBg:getChildByName('progressNode' ..self.chairID..i)
        if view then
            view:stopAllActions()
            view:removeFromParent()
        else
            -- print('--------------stopCD error-----------------------')
        end
        local sprite = self.m_pPanelBg:getChildByName('progressSprite' .. self.chairID..i)
        if sprite then
            sprite:stopAllActions()
            sprite:removeFromParent()
        end
    end
end
function GameRoleItem:startCD(time,doInfotime)
    self:stopCD()
    self.didi = true
--    self.cards:stopAllActions()
    if self.m_pPanelBg:getChildByName('progressNode' .. self.chairID..1) then
        return
    end
--    local function calcLeftSec()
--        local now = cc.loaded_packages.DTCommonModel:getCurSvrTime() or os.time()
--        local left = doInfotime - now
--        return left
--    end
--    local function countdown()
--        if self.didi then
--            if self.index == 1 then
--                local sec = calcLeftSec()
--                if sec <= 5 and sec > 0 then
--                    cc.loaded_packages.KKMusicPlayer:playEffect("zhajinhua/sound/countdown.mp3",false)
--                else
--                    return 
--                end
--            end
--        end
--    end 
--    -- 倒计时
--    self.cards:runAction(cc.RepeatForever:create(cc.Sequence:create(
--        cc.CallFunc:create(countdown),
--        cc.DelayTime:create(1)
--    )))
    local function cdstart()
        if not self.m_pPanelBg:getChildByName('progressNode' .. self.chairID..1) then

            local showtime = {0,4,8,12}
            local hidetime = {4,4,4,3}
            local pngList = {"65","68","66","67"}
            local pngOnIcon = {"018","018_4","018_2","018_3"}

            self.p_imageZhuangtai:setLocalZOrder(101)   --加注/跟注
            self.m_pImageIcon:setLocalZOrder(102)       --头像
            for  i=1,4 do

                local showdelay = cc.DelayTime:create(showtime[i])
                local hidedelay = cc.DelayTime:create(hidetime[i])
                    -- self.cd:setLocalZOrder(101)
                    --大背景框
                local sprite = ccui.ImageView:create('zhajinhua/image/zjh_0'..pngList[i]..'.png')
                sprite:setContentSize(cc.size(338,180))
                sprite:setScale9Enabled(true)
                sprite:setCapInsets(cc.rect(15, 15, 15,15))
                sprite:setContentSize(cc.size(338,180))

                if self.chairID == 1 then
                    sprite:setContentSize(cc.size(408,180))
                end
                sprite:setOpacity(0)
                local size = self.m_pPanelBg:getContentSize()
                sprite:setPosition(cc.p(size.width/2.0,size.height/2.0))
                sprite:setName('progressSprite' .. self.chairID..i)
                self.m_pPanelBg:addChild(sprite)
                sprite:runAction(cc.Sequence:create(showdelay,cc.FadeIn:create(0.5),hidedelay,cc.FadeOut:create(0.5)))


                local progressSprite = cc.Sprite:create('zhajinhua/image/zjh_'..pngOnIcon[i]..'.png')
                local progressNode = cc.ProgressTimer:create(progressSprite)
                progressNode:setReverseDirection(true)
                progressNode:setPercentage(100)
                if self.chairID == 4 or self.chairID == 5 then
                    progressNode:setPosition(cc.p(self.headPos.x+ 5, self.headPos.y))
                else
                    progressNode:setPosition(self.headPos)
                end
                self.m_pPanelBg:addChild(progressNode, 100)
                progressNode:setName('progressNode' .. self.chairID..i)
                local to = cc.ProgressTo:create(time,0)
                progressNode:setOpacity(0)

                local showA = cc.Sequence:create(showdelay,cc.FadeIn:create(0.5),hidedelay,cc.FadeOut:create(0.5))
                progressNode:runAction(cc.Spawn:create(to,showA))
            end
        else
            -- print("出错的位置", self. = nil.clientIndex)
        end
    end
    local action = cc.Sequence:create(cc.CallFunc:create(cdstart))
    action:setTag(self.chairID)
    self.m_pPanelBg:runAction(action)
end
function GameRoleItem:synSeatInfo(info)
    dump(info,"同步金幣時的數據")
    self._seatInfo = info
end
function GameRoleItem:reSetPlayer()
    for i = 1, 3 do
        self.m_pPanelCards:getChildByName("image_card_"..i):loadTexture("common/card/cardBack.png")
        if self.chairID == 1 then

        end
    end
    self.m_cardstype = -1   --牌的类型
    self.isKanPai = false   --是否看牌
    self.isQipai = false    --是否弃牌或比牌失败
    self:clearWinType()
    self.m_pPanelCards:setVisible(false)
    self.p_imageZhuangtai:setVisible(false)
--    self.xiazhuBg:hide()
    self.m_pBtnKanpai:setVisible(false)--self.kanpai:hide()
--    self.nowThrowCoin = 0
    self:clearPanelResultCard()
    self.m_pPanelZhuangtai:setVisible(false)--self.zhuangtai:hide()
--    self.m_pTextZhuangtai:setVisible(false)--self.cardResultText:hide()
    self.m_pTextZhuangtai:setString("")
    self:isCanPai(false)
--    self:isVisibleBoss(false)
    self.isCanLiangPai = false
--    self._seatInfo = nil
--    self:clearReconnect()
end

function GameRoleItem:clearPanelResultCard()
    self.m_pPanelShowResult:setVisible(false)
    self.m_pPanelShowResult:removeAllChildren()
end
function GameRoleItem:clearWinType()
    self.m_pNodeWintype:removeAllChildren()
end
function GameRoleItem:onExit()

end


return GameRoleItem