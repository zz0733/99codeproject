-- region RoomChooseLayer.lua
-- Date 2018.01.18
-- Desc: 游戏等级场选择列表 （三级页面）
-- modified by JackyXu

local GameRoomLayer = class("GameRoomLayer", cc.Node)

local CommonGoldView = appdf.req(appdf.CLIENT_SRC .. "plaza.views.layer.plaza.CommonGoldView") --通用金币框
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame")
local FloatMessage = cc.exports.FloatMessage

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

    self:initCSB()
    self:initLayer()
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
    
    if self.m_nSchulerUpdate then
        scheduler.unscheduleGlobal(self.m_nSchulerUpdate)
        self.m_nSchulerUpdate = nil
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
            if self.m_pQuickStartArm then
                self.m_pQuickStartArm:stopAllActions()
                local pZoomTitleAction = cc.ScaleTo:create(0.05, 1.05, 1.05)
                self.m_pQuickStartArm:runAction(pZoomTitleAction)
            end
        elseif eventType==ccui.TouchEventType.canceled then
            if self.m_pQuickStartArm then
                self.m_pQuickStartArm:stopAllActions()
                self.m_pQuickStartArm:setScale(1.0)
            end
        elseif eventType==ccui.TouchEventType.ended then 
            if self.m_pQuickStartArm then
                self.m_pQuickStartArm:stopAllActions()
                self.m_pQuickStartArm:setScale(1.0)
            end
            -- 快速开始
            self:onQuickStartClicked()
        end
    end)

end

function GameRoomLayer:initLayer()
    
    --通用金币框
    local commonGold = CommonGoldView:create("GameRoomLayer")
    commonGold:setPositionX(50)
    self.m_pNodeCommonGold:addChild(commonGold)
end

--显示时初始化
function GameRoomLayer:init(bNeedRoomList)

    local enterGameInfo = self._scene:getEnterGameInfo()
    local modulestr = string.gsub(enterGameInfo._KindName, "%.", "/")

    self.m_nGameKindID = enterGameInfo._KindID
    self.nClassify = enterGameInfo.nClassify

    --游戏title
    local strTitlePath =  device.writablePath.."game/" .. modulestr .. "/res/gui/title.png"
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
    local scrollViewSize = cc.size(1334, 490) -- 滑动区域大小
    local nRoomCount = #self.m_vecRoomList

    local maxWidth = scrollViewSize.width+(nRoomCount-3)*390
    if self.m_root_SV then
        self.m_root_SV:removeFromParent()
        self.m_root_SV = nil
    end

    self.m_InnerNode = cc.Node:create()
    self.m_InnerNode:setContentSize(cc.size(maxWidth, scrollViewSize.height))

    local STARTX = 0
    local nStartX, nStartY = STARTX, 245; -- 起始位置
    local nOffX = 370 -- 偏移
    local btnSize = cc.size(330, 448) -- 按纽大小

    self.m_vecRoomBtn = {}
   for index = 1, nRoomCount do

        local _btnNode = cc.Node:create()
        _btnNode:setContentSize(btnSize)
        _btnNode:setPosition(nStartX+index*nOffX, nStartY)
        self.m_InnerNode:addChild(_btnNode, 1, index)
        self.m_vecRoomBtn[index] = _btnNode

        local roomInfo = self.m_vecRoomList[index]
        local nBaseScore = roomInfo.dwBaseScore

        --修改:使用游戏内的资源
        local lv = math.mod(index,8) == 0 and 8 or math.mod(index,8) 
        local frameName = "common/game_common/roomlist/hbyc.png"--string.format("hall/image/file/gui-room-%d.png", lv)
        local celNodeBg = cc.Sprite:create(frameName)
        local pBgBtn = ccui.Button:create(frameName,frameName)
        pBgBtn:setPosition(cc.p(0,0))
        pBgBtn:setTag(index)
        _btnNode:addChild(pBgBtn)

        pBgBtn:setSwallowTouches(false)   --不要吞噬事件
        pBgBtn:addClickEventListener(handler(self,self.onButtonClicked))

        local bgSize = celNodeBg:getContentSize()

        local cellogo = cc.Sprite:create("common/game_common/roomlist/jbc_icon.png")
        cellogo:setAnchorPoint(cc.p(0.5, 0.5))
        cellogo:setPosition(cc.p(bgSize.width/2, bgSize.height/2+60))
        pBgBtn:addChild(cellogo)
        -- 等级场名称
        local pLbRoomName =cc.Label:createWithTTF("", "fonts/round_body.ttf", 28)
        local strName = string.format("场次 %d",index)
        pLbRoomName:setString(roomInfo.title)
        pLbRoomName:setAnchorPoint(cc.p(0.5, 0.5))
        pLbRoomName:setPosition(cc.p(bgSize.width/2, bgSize.height/2 - 40))
        pBgBtn:addChild(pLbRoomName)

        -- 中央显示入场分数
        local pLbRoomScore = cc.Label:createWithBMFont("hall/font/sz_jbdtzt5.fnt","")
        pLbRoomScore:setString(roomInfo.unit_money.."底分")
        pLbRoomScore:setAnchorPoint(cc.p(0.5, 0.5))
        pLbRoomScore:setPosition(cc.p(bgSize.width/2, bgSize.height/2 -100))
        pBgBtn:addChild(pLbRoomScore)

        -- 最小注
        local lbLimitScore = cc.Label:createWithSystemFont(roomInfo.unit_money.."底分", "Helvetica", 20);
        lbLimitScore:setAnchorPoint(cc.p(0, 0.5));
        lbLimitScore:setPosition(cc.p(50, 33+33));
        pBgBtn:addChild(lbLimitScore)

        -- 入场分数
        local lbEnterScore = cc.Label:createWithSystemFont(roomInfo.min_money.."入场", "Helvetica", 20);
        lbEnterScore:setAnchorPoint(cc.p(0, 0.5));
        lbEnterScore:setPosition(cc.p(245-45, 33+33));
        pBgBtn:addChild(lbEnterScore)
    end

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
