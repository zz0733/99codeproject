-- region RoomChooseLayer.lua
-- Date 2018.01.18
-- Desc: 游戏等级场选择列表 （三级页面）
-- modified by JackyXu

local GameRoomLayer = class("GameRoomLayer", cc.Node)

local CommonGoldView = appdf.req(appdf.CLIENT_SRC .. "plaza.views.layer.plaza.CommonGoldView") --通用金币框
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local scheduler = appdf.req(appdf.EXTERNAL_SRC .. "scheduler")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame")
local DTClippingNode = appdf.req(appdf.EXTERNAL_SRC .. "DTClippingNode")
local FloatMessage = cc.exports.FloatMessage
local cell_bg = 1
local cell_title = 2
local cell_icon = 3
local cell_dTextbg = 4
local cell_bgtop = 5
function GameRoomLayer:ctor(scene, param, level)
    self:enableNodeEvents()

    self._scene = scene
    self.m_nGameKindID = 0
    self.m_vecRoomList = {}
    self.m_vecRoomBtn  = {}
    self.m_nLastTouchTime = nil
    self.m_nSchulerUpdate = nil
    self.m_pEnterAction = nil

    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)

    self.m_needCallBack = true

    self.m_roomCellRes ={}
    self:fillRoomCellRes()
    self.roomNum = 4
    self:initCSB()
    self:initLayer()
end

function GameRoomLayer:fillRoomCellRes()
   self.m_roomCellRes ={
        --低级场
        {[cell_bg]    = "hbyc.png",
        [cell_title] = "blackjack_xctitle_cjc.png",
        [cell_icon]  = "tbnn_035.png",
        [cell_dTextbg]  = "hbyc_bg1.png",
        [cell_bgtop]  = "hbyc_3.png",},
        --中级场
        {[cell_bg]    = "hjha.png",
        [cell_title] = "blackjack_xctitle_gjc.png",
        [cell_icon]  = "tbnn_034.png",
        [cell_dTextbg]  = "hjha_bg2.png",
        [cell_bgtop]  = "hjha_4.png",},
        --高级场
        {[cell_bg]    = "hdbz.png",
        [cell_title] = "blackjack_xctitle_zjc.png",
        [cell_icon]  = "tbnn_033.png",
        [cell_dTextbg]  = "hdbz_bg3.png",
        [cell_bgtop]  = "hjha_3.png",},

        --至尊场
        {[cell_bg]    = "zzc.png",
        [cell_title] = "zzctitle_zzc.png",
        [cell_icon]  = "zzc_icon.png",
        [cell_dTextbg]  = "zzc_bg1.png",
        [cell_bgtop]  = "hdbz_3.png",},
    }
    self.gameTitle = "tbnn_032.png"
end

function GameRoomLayer:onEnter()
    local logonCallBack = function (result,message)
        self:onLogonCallBack(result,message)
    end
    self._logonFrame = LogonFrame:getInstance()
    self._logonFrame:setCallBackDelegate(self, logonCallBack)
end

function GameRoomLayer:onExit()

    SLFacade:removeCustomEventListener(Hall_Events.MSG_GET_ROOM_LIST,self.__cname)
    
    if self.scheduler then
        scheduler.unscheduleGlobal(self.scheduler)
        self.scheduler = nil
    end 
end

function GameRoomLayer:initCSB()
    
    --init csb
    self.m_pathUI = cc.CSLoader:createNode("dt/HallListView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))
    self.m_pNodeRoot    = self.m_pathUI:getChildByName("HallListView")
    self.m_pNodeRootUI  = self.m_pNodeRoot:getChildByName("node_rootUI")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRootUI:setPositionX(diffX)

    self.m_pNodeTop          = self.m_pNodeRootUI:getChildByName("node_top")
    self.m_pBtnBack          = self.m_pNodeTop:getChildByName("BTN_back")
    self.m_pIMG_title        = self.m_pNodeTop:getChildByName("IMG_title")
    self.m_pNodeCommonGold   = self.m_pNodeTop:getChildByName("node_commonGold")
    self.m_pNodeTable        = self.m_pNodeRootUI:getChildByName("IMG_listBg")
    self.m_pBtnQuickStart    = self.m_pNodeRootUI:getChildByName("Button_quickStart")
    self.m_pBtnQuickStart:setPositionX(display.size.width/2)
    --self.m_pQuickStartArm    = self.m_pBtnQuickStart:getChildByName("Arm_quickStart")
    --self.m_pBtnRule          = self.m_pNodeTop:getChildByName("BTN_Rule")

    -- 返回按钮
    self.m_pBtnBack:addClickEventListener(handler(self, self.onCloseBtnClick))

    -- 规则按钮
    --self.m_pBtnRule:addClickEventListener(handler(self, self.onRuleClick))

    -- 快速开始
    self.m_pBtnQuickStart:addTouchEventListener(function(sender,eventType)
        if not self.m_pBtnQuickStart:isVisible() then return end
        if eventType==ccui.TouchEventType.began then
                ExternalFun.playClickEffect()
                local scale = cc.ScaleTo:create(1,1.3)
 		        local ease_elastic = cc.EaseElasticOut:create(scale)
 		        sender:runAction(ease_elastic) 
        elseif eventType==ccui.TouchEventType.canceled then
                local scale = cc.ScaleTo:create(1,1)
  		        local ease_elastic = cc.EaseElasticOut:create(scale)
  		        sender:runAction(ease_elastic)
        elseif eventType==ccui.TouchEventType.ended then 
                local scale = cc.ScaleTo:create(1,1)
  		        local ease_elastic = cc.EaseElasticOut:create(scale)
  		        sender:runAction(ease_elastic)
            -- 快速开始
            self:onQuickStartClicked()
        end
    end)

end

function GameRoomLayer:initLayer()
    
    --通用金币框
    local commonGold = CommonGoldView:create("GameRoomLayer")
    self.m_pNodeCommonGold:addChild(commonGold)
end

--显示时初始化
function GameRoomLayer:init(bNeedRoomList)

    local enterGameInfo = self._scene:getEnterGameInfo()
    local modulestr = string.gsub(enterGameInfo._KindName, "%.", "/")

    self.m_nGameKindID = enterGameInfo._KindID
    self.nClassify = enterGameInfo.nClassify

    --游戏title
    self.res_path =  device.writablePath.."game/" .. modulestr .. "/res/gui/roomlist/"

    local strTitlePath =  self.res_path..self.gameTitle
    self.m_pIMG_title:setTexture(strTitlePath)

    -- 进场上下工具条动画
    if self.m_pEnterAction then
        self.m_pathUI:stopAction(self.m_pEnterAction)
    end
    self.m_pEnterAction = cc.CSLoader:createTimeline("hall/csb/RoomChooseView.csb")
    self.m_pEnterAction:gotoFrameAndPlay(0, 50, false)
    self.m_pathUI:runAction(self.m_pEnterAction)
    self.m_startPos = cc.p(self.m_pBtnQuickStart:getPosition())
    --获取房间列表
    if not bNeedRoomList then
       self.m_needCallBack = true
       self:getRoomList()
    else
       self.m_needCallBack = false
    end
    
end

function GameRoomLayer:touchListView(sender, _type)
    if ccui.ListViewEventType.ONSELECTEDITEM_END == _type then
        local index = sender:getCurSelectedIndex() + 1
        if index > 1 and self.TouchListItem then
            self:TouchListItem(index-1)
        end
    end
end

function GameRoomLayer:TouchListItem(index)
    self:loginGame(index)
end

function GameRoomLayer:createScrollRoomList()
    if table.maxn(self.m_vecRoomList) == 0 then return end
    local nRoomCount = self.roomNum --#self.m_vecRoomList
    --[[
    local scrollViewSize = cc.size(0, 490) -- 滑动区域大小
    

    local maxWidth = scrollViewSize.width+(nRoomCount-3)*390
    if self.m_root_SV then
        self.m_root_SV:removeFromParent()
        self.m_root_SV = nil
    end

        self.m_InnerNode = cc.Node:create()
        self.m_InnerNode:setContentSize(cc.size(maxWidth, scrollViewSize.height))
    local STARTX = 33
    local nStartX, nStartY = STARTX, 220; -- 起始位置
    local nOffX = 393 -- 偏移
    --]]
    local centerX = (display.size.width)/2+145
    local commonY = display.size.height/2-170
    local nOffX = 160 -- 偏移
    local pos = {ccp(centerX-nOffX*3,commonY),ccp(centerX-nOffX,commonY),ccp(centerX+nOffX,commonY),ccp(centerX+nOffX*3,commonY)}
    local btnSize = cc.size(330, 448) -- 按纽大小
    self.jackPotText = {}
    self.m_vecRoomBtn = {}
   for index = 1, nRoomCount do

        local _btnNode = cc.Node:create()
        _btnNode:setContentSize(btnSize)
        _btnNode:setPosition(pos[index])
        self.m_pNodeTable:addChild(_btnNode, 1, index)
        self.m_vecRoomBtn[index] = _btnNode

        local roomInfo = self.m_vecRoomList[index]
        local nBaseScore = roomInfo.dwBaseScore

        --修改:使用游戏内的资源
        --local lv = math.mod(index,8) == 0 and 8 or math.mod(index,8) 
        local frameName = self.res_path..self.m_roomCellRes[index][cell_bg]
        local celNodeBg = cc.Sprite:create(frameName)
        local pBgBtn = ccui.Button:create(frameName,frameName)
        pBgBtn:setPosition(cc.p(0,0))
        pBgBtn:setTag(index)
        _btnNode:addChild(pBgBtn)

        pBgBtn:setSwallowTouches(false)   --不要吞噬事件
        pBgBtn:addClickEventListener(handler(self,self.onButtonClicked))
        

        local bgSize = celNodeBg:getContentSize()

        --上部下注数
        self:addTopsp(pBgBtn,index)

        local cellogoName = self.res_path..self.m_roomCellRes[index][cell_icon]
        local cellogo = cc.Sprite:create(cellogoName)
        cellogo:setAnchorPoint(cc.p(0.5, 0.5))
        cellogo:setPosition(cc.p(bgSize.width/2, bgSize.height/2+60))
        pBgBtn:addChild(cellogo)

        -- 等级场名称

        local titleName = self.res_path..self.m_roomCellRes[index][cell_title]
        local title = cc.Sprite:create(titleName)
        title:setAnchorPoint(cc.p(0.5, 0.5))
        title:setPosition(cc.p(bgSize.width/2, bgSize.height/2-65))
        pBgBtn:addChild(title)

        local diBgName = self.res_path..self.m_roomCellRes[index][cell_dTextbg]
        local diBg = cc.Sprite:create(diBgName)
        diBg:setAnchorPoint(cc.p(0.5, 0.5))
        diBg:setPosition(cc.p(bgSize.width/2, bgSize.height/2-115))
        pBgBtn:addChild(diBg)
                -- 等级场名称

        -- 最小注
        local lbLimitScore = cc.Label:createWithTTF("底注："..roomInfo.unit_money.."元", "fonts/round_body.ttf", 20);
        lbLimitScore:setAnchorPoint(cc.p(0.5, 0.5));
        lbLimitScore:setPosition(cc.p(120, 17));
        diBg:addChild(lbLimitScore)

        -- 入场分数
        local lbEnterScore = cc.Label:createWithTTF(roomInfo.min_money.."元准入", "fonts/round_body.ttf", 26);
        lbEnterScore:setAnchorPoint(cc.p(0.5, 0.5));
        lbEnterScore:setPosition(cc.p(bgSize.width/2, 60));
        pBgBtn:addChild(lbEnterScore)

        
    end
    --[[
    -- 创建滑动节点
    self.m_root_SV = cc.ScrollView:create(scrollViewSize, self.m_InnerNode)
    self.m_root_SV:setDirection(0) -- 0 水平， 1 垂直， 2 都是可以
    self.m_root_SV:setContentSize(cc.size(maxWidth, scrollViewSize.height))
    self.m_root_SV:setContentOffset(cc.p(0, 0))
    self.m_root_SV:setPosition(cc.p(0,0))
    self.m_root_SV:addTo(self.m_pNodeTable)

    self.m_root_SV:setDelegate()
    self.m_root_SV:setClippingToBounds(false)
    self.m_root_SV:setBounceable(true) 
    --]]
    self:showAnimation()
    self:setjackPotText()
end

-- 添加下注数字
function GameRoomLayer:addTopsp(pSender,Index)
    
    local framename = self.res_path..self.m_roomCellRes[Index][cell_bgtop]
    local textFramename = self.res_path.."title.png"
    local icoinsp = cc.Sprite:create(framename)
    local textsp = cc.Sprite:create(textFramename)
    icoinsp:setPosition(ccp(148,402))
    pSender:addChild(icoinsp)
    textsp:setPosition(ccp(129,80))
    textsp:setScale(0.38)
    
    -- 光点
    local aniPath = self.res_path.."light.csb"
    ExternalFun.playUnLoadCSBani(aniPath, "animation0",icoinsp, true,ccp(135,-117))
    -- 下注数背景
    local spriteTextbg = ccui.Scale9Sprite:create("dt/image/zcmdwc_common/zcmdwc_jb_bg.png")
    spriteTextbg:setContentSize(cc.size(230, 40))
    spriteTextbg:setPosition(ccp(135,50))
    icoinsp:addChild(spriteTextbg)
    icoinsp:addChild(textsp)
    -- 下注数
    local pLbRoomScore = cc.Label:createWithBMFont(self.res_path.."NUM_9line_01-export.fnt","")
    pLbRoomScore:setString("664,456")
    pLbRoomScore:setScale(0.64)
    pLbRoomScore:setPosition(ccp(133,54))
    icoinsp:addChild(pLbRoomScore)
    self.jackPotText[Index] = pLbRoomScore
end

--设置下注数
function GameRoomLayer:setjackPotText()
    math.randomseed(os.time())
    local mtable = {}
    local ptable = {math.random(35000,40000),math.random(85000,100000),math.random(400000,500000),math.random(600000,999999),}
    for i = 1,self.roomNum do
       local xx = ExternalFun.formatnumberthousands(ptable[i])
       mtable[i] = ptable[i]
       self.jackPotText[i]:setString(xx)
    end
    --下注数随机自增每两秒
    local function updatejackpot(args)
        local randtaget = math.random(1,4)
        local randaddnum = math.random(10,1000)

        mtable[randtaget] = mtable[randtaget]+randaddnum

        local finalnum = ExternalFun.formatnumberthousands(mtable[randtaget])
        self.jackPotText[randtaget]:setString(finalnum)
    end
    self.scheduler = scheduler.scheduleGlobal(updatejackpot, 2)
end

function GameRoomLayer:showAnimation()
    self.myItems = self.m_vecRoomBtn
    local nowIndex = 1
    self.lightAction = {}
    local function playAction( ... )
		-- body
		self:runAction(
	        cc.RepeatForever:create(
	            cc.Sequence:create(                
	                cc.CallFunc:create(
	                    function( ... )
	                        self.lightAction[nowIndex]:showAction()
	                        nowIndex = nowIndex + 1
	                        if nowIndex > self.roomNum then
	                        	nowIndex = 1
	                        end
	                    end
	                ),
	                cc.DelayTime:create(1),
	                 cc.CallFunc:create(
	                    function( ... )
	                        self.lightAction[nowIndex]:stop()
	                    end
	                )
	            )
	        )
	    )
	end
    
	local function clipNode(node, index)
        local clipLigth = DTClippingNode:create(node, self.res_path..self.m_roomCellRes[index][cell_icon])
        local size = node:getContentSize()
        clipLigth:setPosition(cc.p(0, 60))
        node:addChild(clipLigth)
        self.lightAction[index] = clipLigth
    end

    for i = 1, self.roomNum do
         clipNode(self.myItems[i], i)
    end
    playAction()
end

--设置按钮位置
function GameRoomLayer:showListLoadAction()
    local roomSize = table.maxn(self.m_vecRoomBtn)
    if table.maxn(self.m_vecRoomBtn) == 0 then return end

    local nRoomCount = #self.m_vecRoomList      --房间数量
    local nStartX = 0
    local nStep = nRoomCount   --每行房间个数
    local diffX = 45
    for i=1, nStep do
        if not self.m_vecRoomBtn[i] then break end
        print("showListLoadAction", i, #self.m_vecRoomBtn)
        local pos = cc.p(self.m_vecRoomBtn[i]:getPosition())
        self.m_vecRoomBtn[i]:setPosition(cc.p(pos.x-diffX,pos.y))          -- 先设置位置在列表显示区域右则

        if self.m_vecRoomBtn[i+nStep] then
            print("showListLoadAction", i+nStep, #self.m_vecRoomBtn)
            local pos = cc.p(self.m_vecRoomBtn[i+nStep]:getPosition())
            self.m_vecRoomBtn[i+nStep]:setPosition(cc.p(pos.x-diffX,pos.y))
        end
        diffX = diffX - 5
    end
end

-- 添加响应
function GameRoomLayer:onButtonClicked(pSender)
    ExternalFun.playClickEffect()
    pSender:runAction((cc.Sequence:create(
		cc.ScaleTo:create(0.1, 1.2),
		cc.ScaleTo:create(0.1, 1)
	)))
    local nIndex = pSender:getTag()
    self:TouchListItem(nIndex)
end

--快速开始
function GameRoomLayer:onQuickStartClicked()
    ExternalFun.playClickEffect()

    local roomSize = table.maxn(self.m_vecRoomList)
    if roomSize == 0 then return end
    self:loginGame(1)
end

--关闭按钮
function GameRoomLayer:onCloseBtnClick()
    ExternalFun.playClickEffect()

    --清理列表
    if self.m_root_SV then
        self.m_root_SV:removeFromParent()
        self.m_root_SV = nil
    end

    --隐藏界面
    self:setVisible(false)

    --返回1级界面，游戏分类
    local _event = {
        name = Hall_Events.MSG_GAME_QUIT_RECOMMEND,
        packet = {nKindId = self.m_nGameKindID,nClassify = self.nClassify}
    }
    SLFacade:dispatchCustomEvent(Hall_Events.ROOMLIST_BACK_TO_GAMELIST,_event)
end

function GameRoomLayer:loginGame(_index)
    --房间数据
    local tmp = self.m_vecRoomList[_index]
    -- 请求进入游戏
    self:sendLoginGameMessage(tmp)
end

function GameRoomLayer:sendLoginGameMessage(tmp)
    
    --放到hallSceneLayer 发送登录游戏请求
    local _event = {
        name = Hall_Events.MSG_HALL_CLICKED_GAME,
        packet = tmp,
    }
    SLFacade:dispatchCustomEvent(Hall_Events.GAMELIST_CLICKED_GAME, _event)
end

--选择房间弹窗
function GameRoomLayer:sendShowChooseRoomDlg(tmp)
    
    local _event = {
        name = Hall_Events.SHOW_CHOOSE_ROOM_DLG,
        packet = tmp,
   }
   SLFacade:dispatchCustomEvent(Hall_Events.SHOW_CHOOSE_ROOM_DLG,_event)
end

function GameRoomLayer:setRecommend(bRecommend)
    self.m_bRecommend = bRecommend
end

function GameRoomLayer:onRuleClick()
    ExternalFun.playClickEffect()
    local CommonRule = require(appdf.PLAZA_VIEW_SRC .."CommonRule")
    local pRule = CommonRule.new(self._scene, self.m_nGameKindID)
    pRule:addTo(self.m_rootUI, 999)
end


function GameRoomLayer:getRoomList()
    local entergame = self._scene:getEnterGameInfo()
    if entergame then
        local msgta = {}
        msgta["type"] = "AccountService"
        msgta["tag"] = "get_rooms"
        msgta["body"] = {}
        msgta["body"]["minv"] = 0
        msgta["body"]["agentid"] = 0
        msgta["body"]["maxv"] = 39999
        msgta["body"]["gt"] = entergame._KindID
        msgta["body"]["rt"] = entergame.GameTypeIDs

        self._logonFrame:sendGameData(msgta)
    end
end

--处理房间列表
function GameRoomLayer:handRoomList(data)
    -- 获取房间列表
    self.m_vecRoomList = {}
    for k,v in pairs(data) do
        if v.is_active == true then
            table.insert(self.m_vecRoomList, v)
        end
    end
    table.sort(self.m_vecRoomList, function (a, b)
          return a.min_money < b.min_money
      end)

    --创建等级场列表
    self:createScrollRoomList()
end

function GameRoomLayer:onLogonCallBack(result,message)
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
    if message.tag == "get_rooms" and not self.m_needCallBack then 
        if message.result == "ok" then
            self:handRoomList(message.body)
        else
            if type(message.result) == "string" then
               showToast(self,message.result,2,cc.c4b(250,0,0,255));
            end
        end  
    end
end

return GameRoomLayer
