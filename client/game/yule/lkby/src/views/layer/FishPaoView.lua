-- region FishPaoView.lua
-- Date     2017.04.07
-- zhiyuan
-- Desc 四个玩家炮台、玩家信息、子弹、鱼组及刷新等。 layer.

local module_pre = "game.yule.lkby.src"
local cmd = appdf.req(module_pre .. ".models.CMD_Game")
local GameOpCodeEnum      = appdf.req(module_pre .. ".models.GameOpCodeEnum")
local BombItem            =   appdf.req(module_pre ..".views.bean.BombItem")
local BombManager         =   appdf.req(module_pre ..".views.bean.BombManager")
local Fish                =   appdf.req(module_pre ..".views.bean.Fish")     
local FishBullet          =   appdf.req(module_pre ..".views.bean.FishBullet")
local FishGold            =   appdf.req(module_pre ..".views.bean.FishGold")
local FishGoldManager     =   appdf.req(module_pre ..".views.bean.FishGoldManager")
local FishNet             =   appdf.req(module_pre ..".views.bean.FishNet")
local FishNumber          =   appdf.req(module_pre ..".views.bean.FishNumber")
local FishPao             =   appdf.req(module_pre ..".views.bean.FishPao")
local FishShanDian        =   appdf.req(module_pre ..".views.bean.FishShanDian")
local JiShaDaYuItem       =   appdf.req(module_pre ..".views.bean.JiShaDaYuItem")
local JiShaBombEffect     =   appdf.req(module_pre ..".views.bean.JiShaBombEffect")
local LightningItem       =   appdf.req(module_pre ..".views.bean.LightningItem")
local LightningManager    =   appdf.req(module_pre ..".views.bean.LightningManager")
local SimpleFish          =   appdf.req(module_pre ..".views.bean.SimpleFish")
local FishDataMgr         =   appdf.req(module_pre ..".views.manager.FishDataMgr")
local FishSceneMgr        =   appdf.req(module_pre ..".views.manager.FishSceneMgr")
local FishTraceMgr        =   appdf.req(module_pre ..".views.manager.FishTraceMgr")
local FishLockMgr         =   appdf.req(module_pre ..".views.manager.FishLockMgr")
local MathAide            =   appdf.req(module_pre ..".views.manager.MathAide")
local ResourceManager     =   appdf.req(module_pre ..".views.manager.ResourceManager")
local CMsgFish            =   appdf.req(module_pre ..".views.proxy.CMsgFish")
local FishEvent           =   appdf.req(module_pre ..".views.scene.FishEvent")
local FishRes             =   appdf.req(module_pre ..".views.scene.FishSceneRes")
local DataCacheMgr        =   appdf.req(module_pre ..".views.manager.DataCacheMgr")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
--local MessageBoxNew       =   appdf.req("common.layer.MessageBoxNew")
--local MsgBoxPreBiz        =   appdf.req("common.public.MsgBoxPreBiz")
local scheduler = cc.Director:getInstance():getScheduler()

local ePositionType = {
    ETYPE_MEFLAG = 0,       --我的标志
    ETYPE_PAO = 1,          --炮的位置
    ETYPE_PAO_BTN = 2,      --炮按钮的位置
    ETYPE_BUFF = 3,         --炮buff标志的位置
    ETYPE_FREEBTN = 4,      --自动按钮
    ETYPE_PAO_INFO = 5,
}

local BOOM_TYPE = {
    BOOM_TYPE_BIG = 0,      -- 大鱼
    BOOM_TYPE_SMALL = 1,    -- 小鱼
    BOOM_TYPE_BOSS = 2,     -- BOSS
}

local FishPaoView = class("FishPaoView", cc.Layer)

FishPaoView.instance_ = nil
function FishPaoView:create()
    FishPaoView.instance_ = FishPaoView.new()
    return FishPaoView.instance_
end

function FishPaoView:ctor()
    self:enableNodeEvents()

    self.m_nPointDisatnce = 50
    self.m_nPointCount = 30
    self.m_nPointOffest = 15 --初始化偏移
    self.m_seatOffPos = { cc.p(210, 30), cc.p(210, 30), cc.p(-60, 10), cc.p(-60, 10), }

    self.m_pNewBG = nil
    self.m_pPaoButtonNode = nil
    self.m_pAIButton = nil
    self.m_pLockButton = nil
    self.m_pActionHailang = nil
    
    self.m_pPaoNode = {}
    self.m_pPaoTai = {}
    self.m_arrPaoPos = {}
    self.m_pGoldNode = {}
    self.m_arrTimeGoldNodeReFresh = {}
    self.m_pUsrGold = {}
    self.m_pUsrGoldBg = {}
    self.m_arrNodeLockLine = {}
    self.m_arrPaoArmature = {}
    self.m_arrArmatureBuffFlag = {}
    self.m_arrArmatureLock = {}
    self.m_deqGoldNode = {}
    self.m_arrLockPointNum = {}

    for i = 1, GAME_PLAYER_FISH do

        self.m_pPaoNode[i] = nil
        self.m_pPaoTai[i] = nil
        self.m_arrPaoArmature[i] = nil
        self.m_arrPaoPos[i] = cc.p(0, 0)
        self.m_arrArmatureBuffFlag[i] = nil
        self.m_arrArmatureLock[i] = nil
        self.m_arrNodeLockLine[i] = nil
        self.m_arrLockPointNum[i] = 0
        self.m_pGoldNode[i] = nil
        self.m_arrTimeGoldNodeReFresh[i] = os.time()
        self.m_pUsrGold[i] = nil
        self.m_pUsrGoldBg[i] = nil 
        self.m_deqGoldNode[i] = {} 
    end
    self.m_vecFishBullet = {}
    self.m_vecMyTempFishBullet = {}
    self.m_vecFishArray = {}
    self.m_nAutoFire = false
    self.m_nArrayTypeIndex = 0
    self.m_nlocalFire = 0
    self.m_lastTarget = cc.p(0, 0)      --需要设置的我的炮的转向目标点
    self.m_alreadyMyPoPos = cc.p(0, 0)  --已经设置的我的炮的转向目标点
    self.m_nLockFish = 0

    self.m_fDistance = 0
    self.m_bIsFMessageSence = false
    self.m_bIsFMessageBulletMax = false
    self.m_nBulletTempId = 0
    self.m_nCreateIndex = 0
    self.m_bLoadSceneFish = false
    self.m_bHasShowTipMyPosition = false 
    self.m_pFishGoldManage = nil
    self.m_nReturnlocal = false
    self.m_ptrSwitchScene = nil
    self.m_pBGTexture2D = nil

    self.m_nChairID = FishDataMgr:getInstance():getMeChairID()
    
    self.updateHandler = nil 
    self.m_pUpdateAutoFire = nil 
    self.m_pUpdateFishHandler = nil 

    self.m_nFireTime = 0
    self.m_nFireTimeLast = 0
    self:init()
end

function FishPaoView:init()
    
    --处理路径
    local temp = {}
    for k, v in pairs(FishTraceMgr:getInstance().m_mapAllFishTrace) do
        table.insert(temp, v)
    end
    FishTraceMgr:getInstance().m_mapAllFishTrace = temp
    self:initCCB()
end

function FishPaoView:initCCB()
    
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self, 100)

    self.m_actionUI = display.newNode()
    self.m_actionUI:addTo(self, 101)

    --炮台界面
    self.m_pathUI = cc.CSLoader:createNode("game/lkfish/csb/gui-fish-pao.csb")

    --炮台边界
    local shap = cc.DrawNode:create()
    if LuaUtils.IphoneXDesignResolution then
        point = {cc.p(-LuaUtils.screenDiffX,0), cc.p(display.size.width-LuaUtils.screenDiffX, 0), cc.p(display.size.width-LuaUtils.screenDiffX, 750), cc.p(-LuaUtils.screenDiffX, 750)}
    else
        point = {cc.p(0,0), cc.p(1334, 0), cc.p(1334, 750), cc.p(0, 750)}
    end
        
    shap:drawPolygon(point, 4, cc.c4b(255, 255, 255, 255), 2, cc.c4b(255, 255, 255, 255))
    self.m_pClippingMenu = cc.ClippingNode:create(shap)
    self.m_pClippingMenu:setPosition(cc.p(0, 0))
    self.m_pClippingMenu:addChild(self.m_pathUI)
    self.m_pClippingMenu:addTo(self.m_rootUI)

    self.m_paoViewPanel = self.m_pathUI

    self.m_pAIButton = self.m_pathUI:getChildByName("m_pAIButton")
    self.m_pLockButton = self.m_pathUI:getChildByName("m_pLockButton")
    self.m_pPaoButtonNode = self.m_pathUI:getChildByName("m_pPaoButton")
    self.m_pAddButton = self.m_pPaoButtonNode:getChildByName("Button_4")
    self.m_pSubButton = self.m_pPaoButtonNode:getChildByName("Button_3")
    
    for i = 1, GAME_PLAYER_FISH do
        self.m_pPaoTai[i] = self.m_pathUI:getChildByName("m_pPaoTai" .. (i - 1))
        self.m_pPaoNode[i] = self.m_pathUI:getChildByName("m_pPaoNode" .. (i - 1)) 
        self.m_pUsrGoldBg[i] = self.m_pPaoNode[i]:getChildByName("Text")
        self.m_pUsrGold[i] = self.m_pPaoNode[i]:getChildByName("Bitmap")
        self.m_pUsrGold[i]:setString("0")
    end

    self.m_pAIButton:addClickEventListener(handler(self, self.onAIClicked))
    self.m_pLockButton:addClickEventListener(handler(self, self.onLockClicked))
    self.m_pAddButton:addClickEventListener(handler(self, self.onPaoAddClicked))
    self.m_pSubButton:addClickEventListener(handler(self, self.onPaoMinusClicked))

    if LuaUtils.isIphoneXDesignResolution() then
        self.m_pAIButton:setPositionX(self.m_pAIButton:getPositionX() + 110)
        self.m_pLockButton:setPositionX(self.m_pLockButton:getPositionX() + 110)
    end
end

function FishPaoView:onEnter()

    --加载睡眠动画
    Fish:initSleepArmatures()
    --清空在加载阶段接收的鱼
    FishDataMgr.getInstance():delAllFish()
    --清空在加载阶段接收的子弹
    FishDataMgr.getInstance():ClearBullet()

    self.updateHandler = scheduler:scheduleScriptFunc(handler(self, self.update), 0.01, false)       
    self.m_pUpdateAutoFire = scheduler:scheduleScriptFunc(handler(self, self.updateAutoFire), 0.01, false)
    self.updateFishAndCollisionHandler = scheduler:scheduleScriptFunc( handler(self, self.updateFishAndCollision),0.03, false)
    self.m_pUpdateFishHandler = scheduler:scheduleScriptFunc(handler(self, self.updateFish), 0.03, false)

    self.m_pMsg_fish_paorefresh = SLFacade:addCustomEventListener(FishEvent.MSG_FISH_PAOREFRESH, handler(self, self.onMsgPaoFresh), self.__cname)
    self.m_pMsg_fish_add_buff = SLFacade:addCustomEventListener(FishEvent.MSG_FISH_ADD_BUFF, handler(self, self.onMsgAddBuff), self.__cname)
    self.m_pMsg_fish_del_buff = SLFacade:addCustomEventListener(FishEvent.MSG_FISH_DEL_BUFF, handler(self, self.onMsgDelBuff), self.__cname)
    self.m_pMsg_fish_fire = SLFacade:addCustomEventListener(FishEvent.MSG_FISH_FIRE, handler(self, self.onMsgNewFire), self.__cname)
    self.m_pMsg_fish_score = SLFacade:addCustomEventListener(FishEvent.MSG_FISH_SCORE, handler(self, self.onMsgScoreFresh), self.__cname)
    self.m_pMsg_fish_score_plus = SLFacade:addCustomEventListener(FishEvent.MSG_FISH_SCORE_PLUS, handler(self, self.onMsgScoreFresh2), self.__cname)
    self.m_pMsg_fish_catch_suc = SLFacade:addCustomEventListener(FishEvent.MSG_FISH_CATCH_SUC, handler(self, self.onMsgCatchFish), self.__cname)
    self.m_pMsg_fish_switch_scene = SLFacade:addCustomEventListener(FishEvent.MSG_FISH_SWITCH_SCENE, handler(self, self.onMsgSwitchScene), self.__cname)
    self.m_pMsg_fish_add_player = SLFacade:addCustomEventListener(FishEvent.MSG_FISH_ADD_PLAYER, handler(self, self.onMsgUpdatePao), self.__cname)
    self.m_pMsg_fish_distribute_fish_team = SLFacade:addCustomEventListener(FishEvent.MSG_FISH_DISTRIBUTE_FISH_TEAM, handler(self, self.onMsgMewFishTeam), self.__cname)
    self.m_pMsg_touch_event = SLFacade:addCustomEventListener(FishEvent.MSG_FISH_TOUNCH_EVENT, handler(self, self.onMsgTounchEvent), self.__cname)
    self.m_pMsg_touch_event = SLFacade:addCustomEventListener(FishEvent.MSG_FISH_SWITCH_CANNON, handler(self, self.switch_cannon), self.__cname)

    self.m_pMsg_fish_del_player = SLFacade:addCustomEventListener(FishEvent.MSG_USER_FREE, handler(self, self.onMsgUpdatePao), self.__cname)
    self.m_pMsg_fish_del_player2 = SLFacade:addCustomEventListener(FishEvent.MSG_USER_LEAVE, handler(self, self.onMsgUpdatePao), self.__cname)

    self.m_pMsg_score_sync = SLFacade:addCustomEventListener(FishEvent.MSG_FISH_SCORE_SYNC, handler(self, self.onMsgScoreSync), self.__cname)
    self.m_pMsg_bomb_effect = SLFacade:addCustomEventListener(FishEvent.MSG_FISH_BOMB_EFFECT, handler(self, self.onMsgBombEffect), self.__cname)

--    if FishDataMgr.getInstance():getCreateDeskScene() then
--        self:initCreateScene()
--        self:createFishArraycallback(0)
--    else
--        --发送鱼的同步请求
--        CMsgFish.getInstance():sendFishSync()
--    end

    local playerKey =  GlobalUserItem.tabAccountInfo.userid
    local meInfor = FishDataMgr.getInstance():getMeUserInfor()
    CMsgFish.getInstance():FireContinuously(101,playerKey,meInfor.score)
    CMsgFish.getInstance():FireContinuously(200,playerKey,cmd.lockInEnum.big)
	CMsgFish.getInstance():FireContinuously(201,playerKey,-1)
	CMsgFish.getInstance():FireContinuously(202,playerKey,false)
	CMsgFish.getInstance():FireContinuously(203,playerKey,cmd.firingIntervalEnum.normal)
	CMsgFish.getInstance():FireContinuously(204,playerKey,false) 

    self:onNodeLoaded()
    self:onMsgPaoFresh()
end

function FishPaoView:onMsgClose()
    for i, bullet in pairs(self.m_vecFishBullet) do
        self.m_vecFishBullet[i]:stopAllActions()
        --self.m_vecFishBullet[i]:removeFromParent()
        bullet:SetUnuse()
        self.m_vecFishBullet[i] = nil
    end
    self.m_vecFishBullet = {}
    self.m_vecMyTempFishBullet = {}
end

function FishPaoView:onExit()

    self:stop()

    Fish:freeSleepArmature()
    self.m_pFishGoldManage:releaseFishGolds()

    FishDataMgr:getInstance():ClearAllData()    
    FishDataMgr.releaseInstance()
    DataCacheMgr.releaseInstance()

    FishPaoView.instance_ = nil
end

function FishPaoView:stop()

    if self.updateHandler then
        scheduler:unscheduleScriptEntry(self.updateHandler)        
        self.updateHandler = nil
    end
    if self.m_pUpdateAutoFire then
        scheduler:unscheduleScriptEntry(self.m_pUpdateAutoFire)
        self.m_pUpdateAutoFire = nil
    end
    if self.updateFishAndCollisionHandler then
        scheduler:unscheduleScriptEntry(self.updateFishAndCollisionHandler)
        self.updateFishAndCollisionHandler = nil
    end
    if self.m_pUpdateFishHandler then
         scheduler:unscheduleScriptEntry(self.m_pUpdateFishHandler)
        self.m_pUpdateFishHandler = nil
    end
    if self.handler_change then
         scheduler:unscheduleScriptEntry(self.handler_change)
        self.handler_change = nil
    end

    SLFacade:removeCustomEventListener(FishEvent.MSG_FISH_PAOREFRESH, self.__cname)
    SLFacade:removeCustomEventListener(FishEvent.MSG_FISH_ADD_BUFF, self.__cname)
    SLFacade:removeCustomEventListener(FishEvent.MSG_FISH_DEL_BUFF, self.__cname)
    SLFacade:removeCustomEventListener(FishEvent.MSG_FISH_FIRE, self.__cname)
    SLFacade:removeCustomEventListener(FishEvent.MSG_FISH_SCORE, self.__cname)
    SLFacade:removeCustomEventListener(FishEvent.MSG_FISH_SCORE_PLUS, self.__cname)
    SLFacade:removeCustomEventListener(FishEvent.MSG_FISH_CATCH_SUC, self.__cname)
    SLFacade:removeCustomEventListener(FishEvent.MSG_FISH_SWITCH_SCENE, self.__cname)
    SLFacade:removeCustomEventListener(FishEvent.MSG_FISH_ADD_PLAYER, self.__cname)
    SLFacade:removeCustomEventListener(FishEvent.MSG_FISH_DISTRIBUTE_FISH_TEAM, self.__cname)
    SLFacade:removeCustomEventListener(FishEvent.MSG_FISH_TOUNCH_EVENT, self.__cname)
    SLFacade:removeCustomEventListener(FishEvent.MSG_USER_FREE, self.__cname)
    SLFacade:removeCustomEventListener(FishEvent.MSG_USER_LEAVE, self.__cname)
end

function FishPaoView:onNodeLoaded()

    self.m_pAIButton:setLocalZOrder(50)
    self.m_pLockButton:setLocalZOrder(50)
    self.m_pPaoButtonNode:setLocalZOrder(2000)
    for i = 1, GAME_PLAYER_FISH do
        --self.m_pPaoNode[i]:setLocalZOrder(40)
        self.m_pPaoNode[i]:setVisible(false)
        self.m_pPaoNode[i]:setLocalZOrder(20 + 7)
        self.m_pPaoTai[i]:setLocalZOrder(20 + 5)
        self.m_pPaoTai[i]:setVisible(false)

        local gold_lb = self.m_pPaoNode[i]:getChildByTag(1)
        if gold_lb ~= nil then

            gold_lb:setVisible(false)
        end
    end
    self.m_pPaoButtonNode:setVisible(false)
    --self.m_pAIButton:setVisible(false)
    --self.m_pLockButton:setVisible(FishTraceMgr.getInstance():getIsNewTrace())

    self.m_pFishGoldManage = FishGoldManager:create()
    self.m_pFishGoldManage:addTo(self.m_pathUI, 100 + 10)
    self.m_pFishGoldManage:initFishGolds()

    --self.m_pNewBG = display.newSprite(FishRes.PNG_OF_BG[1])
    --self.m_pNewBG:setVisible(false)
    --self.m_pNewBG:addTo(self.m_pathUI)
    --self:loadNewBG()

    for i = 1, GAME_PLAYER_FISH  do

        local pos = self:getDefinePostion(ePositionType.ETYPE_PAO, i-1)
        if i > GAME_PLAYER_FISH / 2 then
            pos.y = pos.y - 43
        else
            pos.y = pos.y + 42
        end
        self.m_arrPaoPos[i] = cc.p(pos.x, pos.y)
    end

    self:showPao()
end 

function FishPaoView:initCreateScene()
    local switch_scene = FishDataMgr:getInstance():getSwtichSceneData()
    if switch_scene == nil then 
          return 
    end 

    self.m_ptrSwitchScene = FishSceneMgr:getInstance():getFishScene(switch_scene.next_scene)
    if self.m_ptrSwitchScene == nil then
        print("鱼阵加载失败，因为没有数据")
        return
    end

    -------------------------------
    --测试鱼阵代码
    --if cc.exports.g_sceneIndex == nil or cc.exports.g_sceneIndex == 7 then
    --    cc.exports.g_sceneIndex = 0
    --else
    --    cc.exports.g_sceneIndex = cc.exports.g_sceneIndex + 1
    --end
    --self.m_ptrSwitchScene = FishSceneMgr:getInstance():getFishScene(cc.exports.g_sceneIndex)
    --self.m_ptrSwitchScene = FishSceneMgr:getInstance():getFishScene(5)
    -------------------------------

    self.m_bLoadSceneFish = true
    self.m_nCreateIndex = 0

    for k, v in pairs(self.m_ptrSwitchScene.fishDataMap) do
        self.m_nCreateIndex = self.m_nCreateIndex + 1
        self:CreateSceneFish(v)
    end
    self.m_nArrayTypeIndex = -1
    self.m_nCreateIndex = 0
    self.m_bLoadSceneFish = false
end

function FishPaoView:LoadSceneFishWhenUpdate()
--进入游戏房间后，刷新的鱼阵，分批加载鱼，而第一次进入房间创建的鱼阵是一次性全部加载的
    if not self.m_bLoadSceneFish then
        return
    end

    if self.m_ptrSwitchScene == nil then
        return
    end

    local i = 0
    while (i < 2 and self.m_nCreateIndex < self.m_ptrSwitchScene.fish_count) do
        --这里注意，fishDataMap的键值其实不是index,而是fishID,只不过fishID刚好和index相同
        local fishData = self.m_ptrSwitchScene.fishDataMap[self.m_nCreateIndex] 
        
        self.m_nCreateIndex = self.m_nCreateIndex + 1
        -- 客服端不需要显示的鱼不创建
        if fishData~=nil and FishDataMgr:getInstance():checkIsShowFishByKind(fishData.fish_kind) then
            self:CreateSceneFish(fishData)
        end
        i = i + 1
    end     

    if self.m_nCreateIndex == self.m_ptrSwitchScene.fish_count then
        self.m_nArrayTypeIndex = -1
        self.m_nCreateIndex = 0
        self.m_bLoadSceneFish = false
        print("鱼阵加载完成 －－－－－－－－－－－－－－%ld")
    end
end

function FishPaoView:CreateSceneFish(fishData)
    if fishData == nil then
        return nil
    end

    local fish_kind = fishData.fish_kind
    local fish_id = fishData.fish_id
    local fish_tag = fishData.fish_tag

    local width = FishDataMgr:getInstance():getFishBoxWidth(fish_kind)
    local hegith = FishDataMgr:getInstance():getFishBoxheight(fish_kind)
    local radius = FishDataMgr:getInstance():getFishRadius(fish_kind)
    local mul = FishDataMgr:getInstance():getFishMultiple(fish_kind)
    local pFish = Fish.create(self, fish_kind, fish_id, mul, 30, width, hegith, radius, fish_tag)
    if pFish ~= nil then 
        pFish:setSceneTraceFish(true)
        self:InitPathData( pFish, fishData )
        pFish:setTraceFinish(true)
        pFish:setDelay(6)
        table.insert(self.m_vecFishArray, pFish)
        pFish:setVisible(false)
        --pFish:addTo(self.m_pathUI, 10 + fish_kind / 5)
    end
    return pFish
end

function FishPaoView:InitPathData( pFish, fishData )
    if pFish == nil or fishData == nil then
        return
    end
    --构建路经1
    pFish.PathData1.PathData = FishSceneMgr:getInstance().map_Path[fishData.path_id1]
    pFish.PathData1.PathID = fishData.path_id1
    pFish.PathData1.PathBeginIndex = fishData.begin_step1
    pFish.PathData1.PathEndIndex = fishData.end_step1
    pFish.PathData1.OffsetX = fishData.offset_x1
    pFish.PathData1.OffsetY = fishData.offset_y1
    if fishData.path_id1 == 1 or fishData.path_id1 == 2 then
        pFish.PathData1.MoveLine = 1  --沿着x轴直线移动
    elseif fishData.path_id1 == 12 or fishData.path_id1 == 13 then
        pFish.PathData1.MoveLine = 2  --沿着y轴直线移动
    else 
        pFish.PathData1.MoveLine = 0
    end

    --构建路经2
    if fishData.path_id2~=nil and fishData.path_id2~=0 then
        if fishData.path_id2 == 1 or fishData.path_id2 == 2 then
            pFish.PathData2.MoveLine = 1  --沿着x轴直线移动
        elseif fishData.path_id2 == 12 or fishData.path_id2 == 13 then
            pFish.PathData2.MoveLine = 2  --沿着y轴直线移动
        else 
            pFish.PathData2.MoveLine = 0
        end
        -- 如果路径为999，则需要将这段路径需要进入执行（需要前面一段路径已经存在，否则没有方向）
        if fishData.path_id2 == MOVE_FORWARD_PATH and #pFish.PathData1.PathData[1] > 2 then
            --记录最后两个点（构造第二条路径起点和位移）
            local tmpPath = 
            {
                cc.p(pFish.PathData1.PathData[1][pFish.PathData1.PathEndIndex-1] + pFish.PathData1.OffsetX, pFish.PathData1.PathData[2][pFish.PathData1.PathEndIndex-1] + pFish.PathData1.OffsetY),
                cc.p(pFish.PathData1.PathData[1][pFish.PathData1.PathEndIndex] + pFish.PathData1.OffsetX,   pFish.PathData1.PathData[2][pFish.PathData1.PathEndIndex] + pFish.PathData1.OffsetY),
            }

            --起点
            local next_x = tmpPath[2].x
            local next_y = tmpPath[2].y
            --位移
            local distance_x = tmpPath[2].x - tmpPath[1].x
            local distance_y = tmpPath[2].y - tmpPath[1].y
            --偏移值存储的是每过一个单位时间的偏移值
            pFish.PathData2.OffsetX = distance_x
            pFish.PathData2.OffsetY = distance_y
            pFish.PathData2.StartX = next_x
            pFish.PathData2.StartY = next_y

            pFish.PathData2.PathData = nil
            pFish.PathData2.PathID = fishData.path_id2
            pFish.PathData2.PathBeginIndex = fishData.begin_step2
            pFish.PathData2.PathEndIndex = fishData.end_step2
        else
            pFish.PathData2.PathData = FishSceneMgr:getInstance().map_Path[fishData.path_id2]
            pFish.PathData2.PathID = fishData.path_id2
            pFish.PathData2.PathBeginIndex = fishData.begin_step2
            pFish.PathData2.PathEndIndex = fishData.end_step2
            pFish.PathData2.OffsetX = fishData.offset_x2
            pFish.PathData2.OffsetY = fishData.offset_y2
        end
    end
end

function FishPaoView:update(fvalue)
    
    --修改：锁定时，鱼不在了，锁定到下一鱼，每帧检查
    if FishDataMgr:getInstance():getLock() then
        if not FishDataMgr:getInstance():checkFishLock(self.m_nLockFish) then
        
            local nChaidId = FishDataMgr:getInstance():getMeChairID()
            local myViewChairID = FishDataMgr:getInstance():SwitchViewChairID(nChaidId)
            self:deleteLockEffect(myViewChairID+1, self.m_nLockFish)
            self.m_nLockFish = FishDataMgr:getInstance():getLockFish2()
            self:createLockEffect(myViewChairID+1, self.m_nLockFish)
            FishDataMgr:getInstance():setLockFish(nChaidId, self.m_nLockFish)
            CMsgFish.getInstance():FireContinuously(201, GlobalUserItem.tabAccountInfo.userid,self.m_nLockFish)
        end
    end

    --机器人锁定鱼
    for k,v in pairs(FishDataMgr:getInstance():getUserList()) do
        if v.is_dummy and FishDataMgr:getInstance().isMaster and v.isLockfish then
           local chairid = FishDataMgr:getInstance():getChairIDByGuid(v.uid)
           local lockfish = FishDataMgr:getInstance():getLockFish(chairid)
           if not FishDataMgr:getInstance():checkFishLock(lockfish) then
                local myViewChairID = FishDataMgr:getInstance():SwitchViewChairID(chairid)
                self:deleteLockEffect(myViewChairID+1, lockfish)
                lockfish = FishDataMgr:getInstance():getLockFish2()
                self:createLockEffect(myViewChairID+1, lockfish)
                FishDataMgr:getInstance():setLockFish(chairid, lockfish)
                CMsgFish.getInstance():FireContinuously(201, v.uid,lockfish)
            end
        end
    end

    self:udpateLockEffect()
    self:onMsgMewFish(nil)
    self:onMsgMewFishTeam(nil)
    DataCacheMgr:getInstance():updateDataCacheMgr()
    --不再更新金币动作
    --self:refreshGoldIcon()

    self:LoadSceneFishWhenUpdate()
    self:Net_Update(fvalue)
end

function FishPaoView:Net_Update(dt) 
    for k,v in pairs(FishDataMgr:getInstance():getUserList()) do
        local BulletCount = self:_getBulletCount(v.position)
        if BulletCount < BULLET_NUM_MAX then
            if v.TouchPhase or v.AutomaticFiring then
                if v.is_shoot_stop == false then
                    v.firingInterval  =  v.firingInterval or cmd.lockInEnum.normal
                    if v.lastAttackTime + v.firingInterval < cc.exports.gettime() then
                        v.lastAttackTime = cc.exports.gettime()
                        local chairID = v.position
                        local viewChairID = chairID < 2 and  chairID or (chairID + 2) % GAME_PLAYER_FISH
                        local position = self.m_arrPaoPos[viewChairID+1]
                        local angle =  v.is_dummy and math.angle2radian(v.lock_angle-90+360) or MathAide:CalcAngle(v.lastFirePos.x, 750 - v.lastFirePos.y, position.x, 750 - position.y)
                        local nMul = FishDataMgr:getInstance():getMulripleByIndex(chairID)
                        local fish_id = FishDataMgr:getInstance():getLockFish(chairID)
                        self:OtherFire(angle, nMul, chairID, fish_id)
                    end
                end
            end
        end
    end
end

function FishPaoView:testangle(angle)

end

function FishPaoView:updateAutoFire(dt)
    
    self.m_nFireTime = cc.exports.gettime()
--    if FishDataMgr:getInstance().m_bCheckDistributeFish then 
--       if self.m_nFireTime - FishDataMgr:getInstance().m_fCheckDistributeTime > 13 then --如果13秒没有收到创建鱼的包，就判断为网络极差，断网退出
--             SLFacade:dispatchCustomEvent(Public_Events.MSG_NETWORK_FAILURE)
--             return
--       end
--    end

    self:_autoFire(0)

    if FishDataMgr:getInstance().m_fUpdateFPSTime == 0 then
        FishDataMgr:getInstance().m_fUpdateFPSTime = self.m_nFireTime
    else 
        local passFPS = 1 / (self.m_nFireTime - FishDataMgr:getInstance().m_fUpdateFPSTime)
        FishDataMgr:getInstance().m_fFPSNumber = ( FishDataMgr:getInstance().m_fFPSNumber + passFPS ) / 2
        FishDataMgr:getInstance().m_fUpdateFPSTime = self.m_nFireTime
    end
--    if FishDataMgr:getInstance().m_fFPSNumber >= 55 then
--    print("----------------------fps:   " .. FishDataMgr:getInstance().m_fFPSNumber)
--    end
--    local fFpsNum = FishDataMgr:getInstance().m_fFPSNumber 
    for k, v in pairs(self.m_vecFishBullet) do
        if v ~= nil and v.m_nBulletId ~= nil then
            v:refresh(self.m_nFireTime)
        else
            --print("updateBullet error id: " .. k )
            self.m_vecFishBullet[k] = nil 
        end        
    end    
end

function FishPaoView:onAIClicked() --自动按钮
    ExternalFun.playGameEffect(FishRes.SOUND_OF_BUTTON)
    print("FishPaoView:onAIClicked")

    if self.m_nAutoFire == false then --自动发炮开启
        self.m_nAutoFire = true
        self.m_pAIButton:loadTextureNormal("gui-fish-btn-mul.png", ccui.TextureResType.plistType)
        CMsgFish.getInstance():FireContinuously(202, GlobalUserItem.tabAccountInfo.userid, true)
    elseif self.m_nAutoFire == true then --自动发炮关闭
        self.m_nAutoFire = false
        self.m_pAIButton:loadTextureNormal("gui-fish-btn-auto.png", ccui.TextureResType.plistType)
        CMsgFish.getInstance():FireContinuously(202, GlobalUserItem.tabAccountInfo.userid, false)
    end
end 

function FishPaoView:onLockClicked() --锁定按钮
    ExternalFun.playGameEffect(FishRes.SOUND_OF_BUTTON)
    print("FishPaoView:onLockClicked")

    if FishDataMgr:getInstance():getLock() then --锁定关闭
        FishDataMgr:getInstance():setLock(false)
        self.m_pLockButton:loadTextureNormal("gui-fish-btn-lock.png", ccui.TextureResType.plistType)

        --取消锁定鱼
        local nChaidId = FishDataMgr:getInstance():getMeChairID()
        local myViewChairID = FishDataMgr:getInstance():SwitchViewChairID(nChaidId)
        self:deleteLockEffect(myViewChairID+1, self.m_nLockFish)
        FishDataMgr:getInstance():setLockFish(nChaidId, -1)

        self.m_nLockFish = -1
    else --锁定开启
        FishDataMgr:getInstance():setLock(true)
        self.m_pLockButton:loadTextureNormal("gui-fish-btn-cancel-lock.png", ccui.TextureResType.plistType)

        --开启锁定鱼
        local nChaidId = FishDataMgr:getInstance():getMeChairID()
        local myViewChairID = FishDataMgr:getInstance():SwitchViewChairID(nChaidId)
        self:deleteLockEffect(myViewChairID+1, self.m_nLockFish)
        self.m_nLockFish = FishDataMgr:getInstance():getLockFish2()
        self:createLockEffect(myViewChairID+1, self.m_nLockFish)
        FishDataMgr:getInstance():setLockFish(nChaidId, self.m_nLockFish)

        if self.m_nLockFish < 0 then
            print("玩家没有找到锁定的鱼")
        else
            print("玩家找到锁定的鱼")
        end
    end

     CMsgFish.getInstance():FireContinuously(201, GlobalUserItem.tabAccountInfo.userid,self.m_nLockFish)
end

function FishPaoView:_lockFish(fishID)

    --开启锁定鱼
    local nChaidId = FishDataMgr:getInstance():getMeChairID()
    local myViewChairID = FishDataMgr:getInstance():SwitchViewChairID(nChaidId)
    self:deleteLockEffect(myViewChairID+1, self.m_nLockFish)
    self.m_nLockFish = fishID
    self:createLockEffect(myViewChairID+1, self.m_nLockFish)
    FishDataMgr:getInstance():setLockFish(nChaidId, self.m_nLockFish)
end

function FishPaoView:_autoFire(value)

    if self.m_nAutoFire == true then

        -- modified by JackyXu.
        if not self:myFire(self.m_lastTarget, true) then
            self.m_nAutoFire = false
        end
        -- modified by JackyXu.
    end

    -- 修改：无论是否自动发炮，都校正方向
    -- 校正炮的朝向
    local bLockFish = FishDataMgr:getInstance():getLock()
    local fish_id = bLockFish and self.m_nLockFish or -1
    local pFish = nil
    if fish_id ~= -1 then
        pFish = FishDataMgr:getInstance():getFishByID(fish_id)
    end

    if pFish ~= nil then
        self:myRotatePao(cc.p(pFish.lastposX, pFish.lastposY))
    else
        self:myRotatePao(self.m_lastTarget)
    end
end 

function FishPaoView:onPaoAddClicked()
    ExternalFun.playGameEffect(FishRes.SOUND_OF_BUTTON)
    print("FishPaoView:onPaoAddClicked")

    local myChairID = FishDataMgr:getInstance():getMeChairID()
    local myViewChairID = FishDataMgr:getInstance():SwitchViewChairID(myChairID)
    local bulletType = FishDataMgr:getInstance():getbulletKindByIndex(myChairID)
    local mulripleBase = FishDataMgr:getInstance():getMinBulletMultiple()
    local mulripleMax = FishDataMgr:getInstance():getMaxBulletMultiple()

    local bulletTypeNew = BulletKind.BULLET_KIND_1_NORMAL
    local mulriple = FishDataMgr:getInstance():getMulripleByIndex(myChairID)
    mulriple = mulriple + mulripleBase

    if mulriple > mulripleMax then
        mulriple = mulripleBase
    end

    local nBase = FishDataMgr.getInstance():getBaseScore()

    if mulriple < FISH_PAO_SCORE_1 * nBase then
        if bulletType > BulletKind.BULLET_KIND_3_NORMAL then
            bulletTypeNew = BulletKind.BULLET_KIND_1_ION
        else
            bulletTypeNew = BulletKind.BULLET_KIND_1_NORMAL
        end
    else
        if bulletType > BulletKind.BULLET_KIND_3_NORMAL then
            bulletTypeNew = BulletKind.BULLET_KIND_2_ION
        else
            bulletTypeNew = BulletKind.BULLET_KIND_2_NORMAL
        end
    end

    FishDataMgr:getInstance():setMulripleByIndex(myChairID, mulriple)
    FishDataMgr:getInstance():setBulletKindByIndex(myChairID, bulletTypeNew)
    local eType = FishDataMgr:getInstance():getBulletTypeByMulriple(mulriple, self.m_arrPaoArmature[myViewChairID+1]:isPaoBuff())
    CMsgFish.getInstance():SwitchCannon(eType, mulriple)
    self:_showPao(myChairID)
end 

function FishPaoView:onPaoMinusClicked()
    ExternalFun.playGameEffect(FishRes.SOUND_OF_BUTTON)
    print("FishPaoView:onPaoMinusClicked")

    local myChairID =  FishDataMgr:getInstance():getMeChairID()
    local myViewChairID = FishDataMgr:getInstance():SwitchViewChairID(myChairID)
    local bulletType = FishDataMgr:getInstance():getbulletKindByIndex(myChairID)
    local mulripleBase = FishDataMgr:getInstance():getMinBulletMultiple()
    local mulripleMax = FishDataMgr:getInstance():getMaxBulletMultiple()

    local bulletTypeNew = BulletKind.BULLET_KIND_1_NORMAL
    local mulriple = FishDataMgr:getInstance():getMulripleByIndex(myChairID)
    mulriple = mulriple - mulripleBase

    if mulriple < mulripleBase then
        mulriple = mulripleMax
    end

    local nBase = FishDataMgr.getInstance():getBaseScore()

    if mulriple < FISH_PAO_SCORE_1 * nBase then
        if bulletType > BulletKind.BULLET_KIND_3_NORMAL then
            bulletTypeNew = BulletKind.BULLET_KIND_1_ION
        else
            bulletTypeNew = BulletKind.BULLET_KIND_1_NORMAL
        end
    else
        if bulletType > BulletKind.BULLET_KIND_3_NORMAL then
            bulletTypeNew = BulletKind.BULLET_KIND_2_ION
        else
            bulletTypeNew = BulletKind.BULLET_KIND_2_NORMAL
        end
    end

    FishDataMgr:getInstance():setMulripleByIndex(myChairID, mulriple)
    FishDataMgr:getInstance():setBulletKindByIndex(myChairID, bulletTypeNew)
    local eType = FishDataMgr:getInstance():getBulletTypeByMulriple(mulriple, self.m_arrPaoArmature[myViewChairID+1]:isPaoBuff())
    CMsgFish.getInstance():SwitchCannon(eType, mulriple)
    self:_showPao(myChairID)
end 

-- 次函数只能再初始化炮和切换炮的时候调用
function FishPaoView:showPao()
    print("FishPaoView:showPao")

    for i = 0, GAME_PLAYER_FISH - 1 do
        self:_showPao(i)
    end
end 

function FishPaoView:showTipMyPosition(paoPosition)
    if self.m_bHasShowTipMyPosition then 
          return 
    end 
    self.m_bHasShowTipMyPosition = true 

    local pTipMyPositionAnimation = ccs.Armature:create("ruchangtixing_likpiyu")
    pTipMyPositionAnimation:getAnimation():play("Animation2")
    self:addChild(pTipMyPositionAnimation,1000)
    pTipMyPositionAnimation:setPosition(cc.p(paoPosition.x, paoPosition.y + 80))
    local callFunc = cc.CallFunc:create( function()
        pTipMyPositionAnimation:removeFromParent()
    end )
    self:runAction(cc.Sequence:create(cc.DelayTime:create(5), callFunc))
end

function FishPaoView:_showPao(usChairID)
    print("FishPaoView:usChairID")

    if usChairID >= 4 then
        return
    end

    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(usChairID)
    if not FishDataMgr:getInstance():getIsExistByIndex(usChairID) then
        self:delPao(viewChairID)
        self.m_pPaoNode[viewChairID+1]:setVisible(false)
        self.m_pPaoTai[viewChairID+1]:setVisible(false)
        return
    else
        self.m_pPaoNode[viewChairID+1]:setVisible(true)
        self.m_pPaoTai[viewChairID+1]:setVisible(true)
    end
    if usChairID == FishDataMgr:getInstance():getMeChairID() then

        -- 炮的按钮
        self.m_pPaoButtonNode:setVisible(true)
        self.m_pPaoButtonNode:setPosition(self:getDefinePostion(ePositionType.ETYPE_PAO_BTN, viewChairID))
        -- 自动按钮
        self.m_pAIButton:setVisible(true)
        -- 需要初始化设置子弹目标
        if self.m_lastTarget.x == 0 and self.m_lastTarget.y == 0 then

            local pos = self:getDefinePostion(ePositionType.ETYPE_PAO, viewChairID)
            self.m_lastTarget = cc.p(pos.x, pos.y + 300)
            if viewChairID >= GAME_PLAYER_FISH / 2 then
                self.m_lastTarget = cc.p(pos.x, pos.y - 300)
            end
        end
        self:showTipMyPosition(self:getDefinePostion(ePositionType.ETYPE_PAO, viewChairID))
    end
    -- 设置炮信息的位置
    self.m_pPaoNode[viewChairID+1]:setPosition(self:getDefinePostion(ePositionType.ETYPE_PAO_INFO, viewChairID))

    local nickName = FishDataMgr:getInstance():getFishNameByIndex(usChairID)
    local fishScore = FishDataMgr:getInstance():getFishScoreByIndex(usChairID)
    local bulletType = FishDataMgr:getInstance():getbulletKindByIndex(usChairID)
    if usChairID == FishDataMgr:getInstance():getMeChairID() then
        nickName = yl.getDisplayNickNameInGame(nickName, 13, 13)
    else
        nickName = yl.getDisplayNickNameInGame(nickName)
    end
    -- 玩家名字
    local pName = self.m_pPaoNode[viewChairID+1]:getChildByTag(2)
    if pName ~= nil then
        --local showWidth = pName:getContentSize().width
        pName:setString(nickName)
    end

    if self.m_pUsrGold[viewChairID+1] ~= nil then
        local strFormatGold = string.format("%0.2f", fishScore)
        self.m_pUsrGold[viewChairID+1]:setString( (strFormatGold))      
        -- game option 游戏配置返回的分数全部为0 此处针对李逵劈鱼 初始化的时候 从playerinfo中读取金币数量
        if usChairID == FishDataMgr:getInstance():getMeChairID() then 
            local score = FishDataMgr:getInstance():getUserScore()
            local strFormatGold = string.format("%0.2f", score)
            self.m_pUsrGold[viewChairID+1]:setString( strFormatGold)
        end
    end
    -- 玩家炮的倍数
    self:changeMulriple(usChairID)
    -- 创建炮
    self:createPao(bulletType, usChairID)
end 

function FishPaoView:myRotatePao(target)
    if target.x == self.m_alreadyMyPoPos.x and target.y == self.m_alreadyMyPoPos.y then
        return
    end
    -- 根据2个坐标，计算炮的旋转角度
    local nChaidId = FishDataMgr:getInstance():getMeChairID()
    if nChaidId < 0 or nChaidId >= GAME_PLAYER_FISH then
        return
    end
    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(nChaidId)
    if self.m_arrPaoArmature[viewChairID+1] ~= nil then
        local paoPosX, paoPosY = self.m_arrPaoArmature[viewChairID+1]:getPosition()
        local vec = cc.pSub(cc.p(target.x, target.y), cc.p(paoPosX, paoPosY))
        local angle = math.radian2angle(cc.pGetAngle(vec, cc.p(0, 1)))
        self.m_arrPaoArmature[viewChairID+1]:rotatePao(angle)
        self.m_alreadyMyPoPos = target
        self.m_lastTarget = target
    end
end 

function FishPaoView:createPao(eType, chairID)

    local nSeatIndex = FishDataMgr:getInstance():SwitchViewChairID(chairID)
    if self.m_arrPaoArmature[nSeatIndex+1] ~= nil then
        -- 炮存在了,切换
        local oldTag = self.m_arrPaoArmature[nSeatIndex+1]:paoTag()
        self.m_arrPaoArmature[nSeatIndex+1] = self.m_arrPaoArmature[nSeatIndex+1]:changePao(eType)
        local newTag = self.m_arrPaoArmature[nSeatIndex+1]:getPaoSpriteIndex()
        if oldTag ~= newTag then
            local pPaoArmtureLight = ccs.Armature:create("paotaiqiehuan_buyu")
            pPaoArmtureLight:getAnimation():play("Animation1")
            pPaoArmtureLight:setAnchorPoint(cc.p(0.5, 0.5))
            local pos = self:getDefinePostion(ePositionType.ETYPE_PAO, nSeatIndex)
            if nSeatIndex > 1 then
                pos.y = pos.y - 50
            else
                pos.y = pos.y + 50
            end
            pPaoArmtureLight:setPosition(cc.p(pos.x + 10, pos.y))
            self.m_pathUI:addChild(pPaoArmtureLight, 50)
            local function animationEvent(armature,moveMentType,moveMentId)
                if moveMentType == ccs.MovementEventType.complete
                or moveMentType == ccs.MovementEventType.loopComplete
                then 
                    if moveMentId == "Animation1" then 
                        self:effectEnd(pPaoArmtureLight)
                    end 
                end 
            end
            pPaoArmtureLight:getAnimation():setMovementEventCallFunc(animationEvent)
        end
    else
        -- 创建一个炮
        local pFishPao = FishPao:create(eType, chairID)
        local position = self.m_arrPaoPos[nSeatIndex+1] 
        pFishPao:setPosition(position)
        pFishPao:setContentSize(cc.size(100, 100))
        pFishPao:setAnchorPoint(cc.p(0.5, 0.2))
        self.m_paoViewPanel:addChild(pFishPao, 20 + 6)
        self.m_arrPaoArmature[nSeatIndex+1] = pFishPao
    end
    if self.m_arrPaoArmature[nSeatIndex+1]:isPaoBuff() then
        self:createBuffFlag(nSeatIndex)
    else
        self:delBuffFlag(nSeatIndex)
    end
end 

function FishPaoView:delPao(nSeatIndex)
    --nSeatIndex 是 viewChairId
    if nSeatIndex < 0 or nSeatIndex >= GAME_PLAYER_FISH then
        return
    end
    if self.m_arrPaoArmature[nSeatIndex + 1] ~= nil then
        self.m_arrPaoArmature[nSeatIndex + 1]:removeFromParent()
        self.m_arrPaoArmature[nSeatIndex + 1] = nil
    end
    -- 清除一摞一摞的金币
    if self.m_pGoldNode[nSeatIndex+1] ~= nil then
        self.m_pGoldNode[nSeatIndex+1]:removeAllChildren()
    end
    self.m_deqGoldNode[nSeatIndex+1] = {}

    -- 有buff，删除buff
    self:delBuffFlag(nSeatIndex)

    --清除击杀大鱼播放的转盘动画
    local jiShaDaYuItem = self.m_pathUI:getChildByTag(TAG_JI_SHA_DA_YU_ZHUAN_PAN)
    if jiShaDaYuItem ~= nil and jiShaDaYuItem:getChairId() == nSeatIndex then 
          jiShaDaYuItem:stopAllActions()
          jiShaDaYuItem:removeFromParent()
    end 
    --清除击杀炸弹的动画
    local jiShaBomb = self.m_pathUI:getChildByTag(TAG_JI_SHA_DA_YU_BOMB)
    if jiShaBomb ~= nil and jiShaBomb:getChairId() == nSeatIndex then 
          jiShaBomb:stopAllActions()
          jiShaBomb:removeFromParent()
    end 
    --清理闪电连锁的
    local shanDianWenZi = self.m_pathUI:getChildByTag(TAG_SHAN_DIAN)
    if shanDianWenZi ~= nil and shanDianWenZi:getChairId() == nSeatIndex then 
         shanDianWenZi:setWenZiVisibleFalse()
    end 
    --清理屏幕中该chairID的飞的金币
    if self.m_pFishGoldManage then
        self.m_pFishGoldManage:setFishGoldEndByChairId(nSeatIndex)    
    end 
end 

function FishPaoView:changeMulriple(chairID)
     
    -- 玩家炮的倍数
    local nChairId = FishDataMgr:getInstance():getMeChairID()
    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(chairID)
    local pMulripleBg = self.m_pPaoNode[viewChairID+1]:getChildByTag(6)
    if pMulripleBg == nil then 
        pMulripleBg = display.newSprite("#gui-fish-fh-bt.png")
        self.m_pPaoNode[viewChairID+1]:addChild(pMulripleBg)
        pMulripleBg:setTag(6)
        local x = 80
        if nChairId == chairID then
           x = 20
        end
        local y = 30
        if viewChairID >= GAME_PLAYER_FISH / 2 then
            x = 295
            y = 45
        end
        pMulripleBg:setPosition(cc.p(x,y))
    end 
    local pMulriple = pMulripleBg:getChildByTag(2)
    local nMulriple = FishDataMgr:getInstance():getMulripleByIndex(chairID)
    local strMulriple = (nMulriple) --string.format("%d.%02d", (nMulriple/100), math.abs((nMulriple)%100))
    if pMulriple ~= nil then
        pMulriple:setString(strMulriple)

    else
        pMulriple = cc.Label:createWithBMFont(FishRes.FONT_OF_SUZI_PAO, "0")
        pMulriple:setString(strMulriple)
        pMulriple:setAnchorPoint(cc.p(0.5, 0.5))
        pMulriple:setPosition(cc.p(pMulripleBg:getContentSize().width/2, pMulripleBg:getContentSize().height/2))
        pMulriple:setTag(2)
        pMulripleBg:addChild(pMulriple,10)
    end     
end 

function FishPaoView:createBuffFlag(nSeatIndex)

    if nSeatIndex < 0 or nSeatIndex >= GAME_PLAYER_FISH then
        return
    end
    if self.m_arrArmatureBuffFlag[nSeatIndex+1] ~= nil then
        self.m_arrArmatureBuffFlag[nSeatIndex+1] = ccs.Armature:create("buff_buyu")
        self.m_arrArmatureBuffFlag[nSeatIndex+1]:getAnimation():play("Animation1")
        self.m_arrArmatureBuffFlag[nSeatIndex+1]:setAnchorPoint(cc.p(0.5, 0.5))
        self.m_arrArmatureBuffFlag[nSeatIndex+1]:setPosition(self:getDefinePostion(ETYPE_BUFF, nSeatIndex))
        local function animationEvent(armature,moveMentType,moveMentId)
            if moveMentType == ccs.MovementEventType.complete  then 
                if moveMentId == "Animation1" then 
                    self:effectEnd(self.m_arrArmatureBuffFlag[nSeatIndex+1])
                end 
            end 
        end
        self.m_arrArmatureBuffFlag[nSeatIndex+1]:getAnimation():setMovementEventCallFunc(animationEvent)
        self.m_pathUI:addChild(self.m_arrArmatureBuffFlag[nSeatIndex+1], 90 + 1)
    end
end 

function FishPaoView:delBuffFlag(nSeatIndex)

    if nSeatIndex < 0 or nSeatIndex >= GAME_PLAYER_FISH then
        return
    end
    if self.m_arrArmatureBuffFlag[nSeatIndex+1] ~= nil then
        self.m_arrArmatureBuffFlag[nSeatIndex+1]:removeFromParent()
        self.m_arrArmatureBuffFlag[nSeatIndex+1] = nil
    end
end 

function FishPaoView:showLabelAction(pLabel)
    
    local pAction = cc.Sequence:create(
        cc.EaseBackOut:create(cc.ScaleTo:create(0.09, 1.5)),
        cc.EaseSineOut:create(cc.ScaleTo:create(0.18, 1.0)))
    pLabel:stopAllActions()
    pLabel:setScale(1.0)
    pLabel:runAction(pAction)
end

FishPaoView.vecGoldPos = {
    cc.p(450, 92 - 10), 
    cc.p(1105, 92 - 10), 
    cc.p(780, 663 + 5), 
    cc.p(120, 663 + 5),
}

function FishPaoView:showGoldIcon2(chairid, iScore)

    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(chairid)
    local beginPosion = FishPaoView.vecGoldPos[viewChairID+1]

    --金币node
    if self.m_pGoldNode[viewChairID+1] == nil then
        local pGoldNode = display.newNode()
        pGoldNode:setPosition(beginPosion)
        pGoldNode:addTo(self.m_pathUI, 100+100)
        self.m_pGoldNode[viewChairID+1] = pGoldNode
        --下方位置偏移
        if 0 <= viewChairID and viewChairID <= 1 then
            if chairid ~= self.m_nChairID then
                pGoldNode:setPositionX(pGoldNode:getPositionX() - 60)
            end
        end
    end

    --动作node
    local pActionNode = display.newNode()
    pActionNode:setPosition(50, 0)

    local winScore = iScore
    local strwinScore = "+" .. (winScore) --string.format("+%d.%02d", winScore / 100, winScore % 100)
    local strFontPath = (chairid == self.m_nChairID) and FishRes.FONT_OF_SUZI_NUMBER or FishRes.FONT_OF_SUZI_NUMBER_SILVER
    local pScoreText = cc.Label:createWithBMFont(strFontPath, strwinScore)
    pScoreText:setAnchorPoint(0.5, 0.5)
    pScoreText:setPosition(0, 0)
    pScoreText:setScale(0.5)
    pScoreText:addTo(pActionNode)

    local vecMove1 = { cc.p(0, 20), cc.p(0, 20), cc.p(0, -20), cc.p(0, -20), }
    local vecMove2 = { cc.p(0, 50), cc.p(0, 50), cc.p(0, -50), cc.p(0, -50), }
    local move1 = vecMove1[viewChairID+1]
    local move2 = vecMove2[viewChairID+1]
    local pAction = cc.Sequence:create(    
        cc.Spawn:create(
            cc.FadeIn:create(0.3),
            cc.MoveBy:create(0.3, move1)),
        cc.DelayTime:create(0.8),
        cc.Spawn:create(
            cc.FadeOut:create(0.2),
            cc.MoveBy:create(0.2, move2)),
        cc.CallFunc:create(function()
            pScoreText:getParent():removeFromParent()
        end))
    pScoreText:runAction(pAction)

    self.m_pGoldNode[viewChairID+1]:addChild(pActionNode)
end

function FishPaoView:switch_cannon(event)
    local _userdata = unpack(event._userdata)
    local body = _userdata.body
    local guid = body[1]
    local bullet_mulriple = body[2]
    local eType = body[3]
    local chairID = FishDataMgr:getInstance():getChairIDByGuid(guid)
    if chairID == INVALID_CHAIR or guid == GlobalUserItem.tabAccountInfo.userid then return end
    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(chairID)
    FishDataMgr:getInstance():setMulripleByIndex(chairID, bullet_mulriple)
    -- 玩家炮的倍数
    self:changeMulriple(chairID)
    -- 判断是否切换了炮了
    local eType = FishDataMgr:getInstance():getBulletTypeByMulriple(bullet_mulriple, false)
    FishDataMgr:getInstance():setBulletKindByIndex(chairID, eType)

    local oldTag = self.m_arrPaoArmature[viewChairID+1]:paoTag()
    self.m_arrPaoArmature[viewChairID+1]:changePao(eType)
    local newTag = self.m_arrPaoArmature[viewChairID+1]:getPaoSpriteIndex()
    if oldTag ~= newTag then

        local pPaoArmtureLight = ccs.Armature:create("paotaiqiehuan_buyu")
        pPaoArmtureLight:getAnimation():play("Animation1")
        pPaoArmtureLight:setAnchorPoint(cc.p(0.5, 0.5))
        local pos = self:getDefinePostion(ePositionType.ETYPE_PAO, viewChairID)

        if viewChairID > 1 then
            pos.y = pos.y - 50
        else
            pos.y = pos.y + 50
        end
        pPaoArmtureLight:setPosition(cc.p(pos.x + 10, pos.y))
        self.m_pathUI:addChild(pPaoArmtureLight, 50)
        local function animationEvent(armature,moveMentType,moveMentId)
            if moveMentType == ccs.MovementEventType.complete  then 
                if moveMentId == "Animation1" then 
                    self:effectEnd(pPaoArmtureLight)
                end 
            end 
        end
        pPaoArmtureLight:getAnimation():setMovementEventCallFunc(animationEvent)
    end
end

function FishPaoView:lock_fish(guid, lock_fish_id)
    -- 检查鱼是否可以绑定
    local chairID = FishDataMgr:getInstance():getChairIDByGuid(guid)
    if chairID == INVALID_CHAIR then
        return
    end
    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(chairID)
    if not FishTraceMgr:getInstance():getIsNewTrace() then
        lock_fish_id = -1
    end
    -- print("---------------------------客户端锁定的鱼：%d", lock_fish_id)
    local pLockFish = nil 
    if lock_fish_id >= 0 then
        pLockFish = FishDataMgr:getInstance():getFishByID(lock_fish_id)
    end
    -- 原来有没有绑定的鱼
    local old_lock_fish = FishDataMgr:getInstance():getLockFish(chairID)
    if lock_fish_id < 0 then
        FishDataMgr:getInstance():cancelLock(chairID)
        self:deleteLockEffect(viewChairID+1, old_lock_fish)
        -- print("＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋清除锁定")
    elseif old_lock_fish ~= lock_fish_id then
        -- 设置新的锁定鱼ID
        self:deleteLockEffect(viewChairID+1, old_lock_fish)
        self:createLockEffect(viewChairID+1, lock_fish_id)
        -- print("－－－－－－－－－－－－－－－－－－创建锁定 :old %d  new:%d", old_lock_fish, lock_fish_id)
        if pLockFish ~= nil then  -- 如果刚进入游戏，就收到其他玩家锁定打鱼，但此时可能客户端还没有创建鱼，导致看不到玩家锁定，所以这里只有该锁定鱼存在时才设置
            FishDataMgr:getInstance():setLockFish(chairID, lock_fish_id)
        end
    end

    self:updatePaoAngel(viewChairID+1, lock_fish_id, chairID)
end

function FishPaoView:createBullet(bulletId, bulletTempId, bullet_mulriple, bullet_double, angle, chairID, lock_fish_id)

    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(chairID)
    local begin = self.m_arrPaoPos[viewChairID+1]

    -- 检查鱼是否可以绑定
    if not FishTraceMgr:getInstance():getIsNewTrace() then
        lock_fish_id = -1
    end
    -- print("---------------------------客户端锁定的鱼：%d", lock_fish_id)
    local pLockFish = nil 
    if lock_fish_id >= 0 then

        pLockFish = FishDataMgr:getInstance():getFishByID(lock_fish_id)
        if pLockFish ~= nil then
            local positionX,positionY = pLockFish.lastposX, pLockFish.lastposY
            angle = MathAide:CalcAngle(positionX, 750 - positionY, begin.x, 750 - begin.y)
        end
    end
    -- 原来有没有绑定的鱼
    local old_lock_fish = FishDataMgr:getInstance():getLockFish(chairID)
    if lock_fish_id < 0 then
        FishDataMgr:getInstance():cancelLock(chairID)
        self:deleteLockEffect(viewChairID+1, old_lock_fish)
        -- print("＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋清除锁定")
    elseif old_lock_fish ~= lock_fish_id then
        -- 设置新的锁定鱼ID
        self:deleteLockEffect(viewChairID+1, old_lock_fish)
        self:createLockEffect(viewChairID+1, lock_fish_id)
        -- print("－－－－－－－－－－－－－－－－－－创建锁定 :old %d  new:%d", old_lock_fish, lock_fish_id)
        if pLockFish ~= nil then  -- 如果刚进入游戏，就收到其他玩家锁定打鱼，但此时可能客户端还没有创建鱼，导致看不到玩家锁定，所以这里只有该锁定鱼存在时才设置
            FishDataMgr:getInstance():setLockFish(chairID, lock_fish_id)
        end
    end

    -- 创建子弹
    if self.m_arrPaoArmature[viewChairID+1] == nil then

        -- 这里测试用。
        FloatMessage.getInstance():pushMessage("STRING_123")
        return nil
    end
    -- 或者要根据bullet_double来判断是否为buu状态

    local eType = FishDataMgr:getInstance():getBulletTypeByMulriple(bullet_mulriple, bullet_double)
    if chairID ~= FishDataMgr:getInstance():getMeChairID() then
        self.m_arrPaoArmature[viewChairID+1]:rotatePao(math.radian2angle(angle))
    end
    -- 开火动画
    local playSound = false
    if chairID == FishDataMgr:getInstance():getMeChairID() then
        playSound = true
    end
    self.m_arrPaoArmature[viewChairID+1]:fireAnimation(playSound)

    -- 获得目标点
    local x = 0
    local y = 0

    local bRotate = false
    local meChairID = FishDataMgr:getInstance():getMeChairID()
    local rBegin = {
        x = begin.x,
        y = begin.y,
    } 
    --    rBegin.x = beginX
    --    rBegin.y = beginY
    if chairID ~= meChairID and lock_fish_id < 0 then

        if meChairID <= 1 and chairID > 1 then

            bRotate = true
            local position = self.m_arrPaoPos[chairID % 2+1]
            rBegin.x = position.x 
            rBegin.y = position.y
            -- 玩家真正发炮的位置

        elseif meChairID > 1 and chairID <= 1 then

            bRotate = true
            local position = self.m_arrPaoPos[chairID+1]
            rBegin.x = position.x 
            rBegin.y = position.y
        end
    end

    x,y = FishDataMgr:getInstance():GetTargetPoint(rBegin.x, 750 - rBegin.y, angle, x, y)
    local target = cc.p(x, 750 - y)
    if bRotate then

        target.x = 1334 - target.x
        target.y = 750 - target.y
        angle = angle + math.pi
        self.m_arrPaoArmature[viewChairID+1]:rotatePao(math.radian2angle(angle))
    end

    local pBullet = FishBullet:create(bulletId, bulletTempId, eType, chairID, bullet_mulriple, lock_fish_id, self)
    -- 设置子弹的偏移量
    local diff = cc.pNormalize(cc.pSub(target,begin)) 
    diff.x = diff.x*70
    diff.y = diff.y*70
    --begin = cc.pAdd(cc.p(begin.x,begin.y) , cc.p(diff.x,diff.y))
    begin = cc.pAdd(begin, diff)
    --pBullet:setAnchorPoint(cc.p(0.5, 0.5))
    pBullet:setPosition(begin)
    pBullet.m_curposition.x = begin.x
    pBullet.m_curposition.y = begin.y
    --self.m_pathUI:addChild(pBullet, 20 + 5)
    table.insert(self.m_vecFishBullet,pBullet)
    local speed = FishDataMgr:getInstance():getBulletSpeed(eType)
    if speed == nil or speed <= 0 then
        speed = 800
    end
    -- 原始子弹数度太慢，设置一个速度倍数偏移量.测试用
    pBullet:flyTo(begin, target, angle, speed)
    -- * BULLET_SPEED_DIFF

    return pBullet
end 

function FishPaoView:createOtherBullet(bullet_mulriple,angle, chairID, lock_fish_id)

    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(chairID)
    local begin = self.m_arrPaoPos[viewChairID+1]

    -- 检查鱼是否可以绑定
    if not FishTraceMgr:getInstance():getIsNewTrace() then
        lock_fish_id = -1
    end
    -- print("---------------------------客户端锁定的鱼：%d", lock_fish_id)
    local pLockFish = nil 
    if lock_fish_id >= 0 then

        pLockFish = FishDataMgr:getInstance():getFishByID(lock_fish_id)
        if pLockFish ~= nil then
            local positionX,positionY = pLockFish.lastposX, pLockFish.lastposY
            angle = MathAide:CalcAngle(positionX, 750 - positionY, begin.x, 750 - begin.y)
        end
    end
    -- 原来有没有绑定的鱼
    local old_lock_fish = FishDataMgr:getInstance():getLockFish(chairID)
    if lock_fish_id < 0 then
        FishDataMgr:getInstance():cancelLock(chairID)
        self:deleteLockEffect(viewChairID+1, old_lock_fish)
        -- print("＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋清除锁定")
    elseif old_lock_fish ~= lock_fish_id then
        -- 设置新的锁定鱼ID
        self:deleteLockEffect(viewChairID+1, old_lock_fish)
        self:createLockEffect(viewChairID+1, lock_fish_id)
        -- print("－－－－－－－－－－－－－－－－－－创建锁定 :old %d  new:%d", old_lock_fish, lock_fish_id)
        if pLockFish ~= nil then  -- 如果刚进入游戏，就收到其他玩家锁定打鱼，但此时可能客户端还没有创建鱼，导致看不到玩家锁定，所以这里只有该锁定鱼存在时才设置
            FishDataMgr:getInstance():setLockFish(chairID, lock_fish_id)
        end
    end

    -- 创建子弹
    if self.m_arrPaoArmature[viewChairID+1] == nil then

        -- 这里测试用。
        FloatMessage.getInstance():pushMessage("STRING_123")
        return nil
    end
    -- 或者要根据bullet_double来判断是否为buu状态
    local eType = FishDataMgr:getInstance():getBulletTypeByMulriple(bullet_mulriple, false)
    if chairID ~= FishDataMgr:getInstance():getMeChairID() then
        self.m_arrPaoArmature[viewChairID+1]:rotatePao(math.radian2angle(angle))
    end

    -- 开火动画
    local playSound = false
    self.m_arrPaoArmature[viewChairID+1]:fireAnimation(playSound)

    -- 获得目标点
    local x = 0
    local y = 0

    local bRotate = false
    local meChairID = FishDataMgr:getInstance():getMeChairID()
    local rBegin = {
        x = begin.x,
        y = begin.y,
    } 

    if chairID ~= meChairID  and lock_fish_id < 0 then

        if meChairID <= 1 and chairID > 1 then

            bRotate = true
            local position = self.m_arrPaoPos[chairID % 2+1]
            rBegin.x = position.x 
            rBegin.y = position.y
            -- 玩家真正发炮的位置

        elseif meChairID > 1 and chairID <= 1 then

            bRotate = true
            local position = self.m_arrPaoPos[chairID+1]
            rBegin.x = position.x 
            rBegin.y = position.y
        end
    end

    x,y = FishDataMgr:getInstance():GetTargetPoint(rBegin.x, 750 - rBegin.y, angle, x, y)
    local target = cc.p(x, 750 - y)
    if bRotate then
        target.x = 1334 - target.x
        target.y = 750 - target.y
        angle = angle + math.pi
        self.m_arrPaoArmature[viewChairID+1]:rotatePao(math.radian2angle(angle))
    end

    local pBullet = FishBullet:create(0, 0, eType, chairID, bullet_mulriple, -1, self)
    -- 设置子弹的偏移量
    local diff = cc.pNormalize(cc.pSub(target,begin)) 
    diff.x = diff.x*70
    diff.y = diff.y*70
    --begin = cc.pAdd(cc.p(begin.x,begin.y) , cc.p(diff.x,diff.y))
    begin = cc.pAdd(begin, diff)
    --pBullet:setAnchorPoint(cc.p(0.5, 0.5))
    pBullet:setPosition(begin)
    pBullet.m_curposition.x = begin.x
    pBullet.m_curposition.y = begin.y
    --self.m_pathUI:addChild(pBullet, 20 + 5)
    table.insert(self.m_vecFishBullet,pBullet)
    local speed = FishDataMgr:getInstance():getBulletSpeed(eType)
    if speed == nil or speed <= 0 then
        speed = 800
    end
    -- 原始子弹数度太慢，设置一个速度倍数偏移量.测试用
    pBullet:flyTo(begin, target, angle, speed)
    -- * BULLET_SPEED_DIFF

    return pBullet
end 

function FishPaoView:updateFish(dt)
    FishDataMgr:getInstance():updateFish(dt)
end

function FishPaoView:updateFishAndCollision(dt)
    
    --FishDataMgr:getInstance():updateFish(dt)

    if FishDataMgr:getInstance():getIsNetworkFail() == false then
        self:checkOutCollisionFishesAndBullet()
    end

    --去掉帧更新金币移动
    --if self.m_pFishGoldManage then
    --    self.m_pFishGoldManage:updateFishGold(dt)
    --end
end 
      
function FishPaoView:checkOutCollisionFishesAndBullet()

--    self.m_iUpdateInex = self.m_iUpdateInex + 1
--    if self.m_iUpdateInex > 10000000 then
--       self.m_iUpdateInex = 0
--    end
--    local nFishBulletNum = #self.m_vecFishBullet
    for k, v in pairs(self.m_vecFishBullet) do
        local pBullet = v
        if pBullet ~= nil then
            local bulletPosX, bulletPosY = pBullet.m_curposition.x, pBullet.m_curposition.y
            local nBulletLockFishId = pBullet:getFishID()

            if nBulletLockFishId >= 0 then
                -- 锁定鱼的子弹
                -- 判断锁定的鱼是否还活着
                local pFish, isAlive = FishDataMgr:getInstance():checkFishLock(nBulletLockFishId)
                if isAlive then
                    if self:isBulletLockFishConflict(pFish, pBullet, bulletPosX, bulletPosY) then
                        self:dealBulletFish(pFish, pBullet, pFish.lastposX, pFish.lastposY, i)
                        pBullet:SetUnuse()
                        self.m_vecFishBullet[k] = nil
                        --return true
                    end
                else
                    pBullet:setFishID(-1)
                end
            else
                -- 没有锁定鱼的子弹
                local targetFish = self:getMostCloseFishByBullet(bulletPosX, bulletPosY)
                if targetFish ~= nil and self:isBulletFishConflict(targetFish, pBullet, bulletPosX, bulletPosY) then
                    self:dealBulletFish(targetFish, pBullet, bulletPosX, bulletPosY, i)
                    pBullet:SetUnuse()
                    self.m_vecFishBullet[k] = nil
                    --return true
                end
            end
        end
    end
end 

-- 获取一个距离该子弹最近的一条活着的可以比较的鱼
function FishPaoView:getMostCloseFishByBullet(bulletPosX,bulletPosY)
    local targetFish = nil
    local mixDistance = 100000
    for k, v in pairs(FishDataMgr:getInstance().m_vecFish) do      
        local deltaX = v.lastposX-bulletPosX
        local deltaY = v.lastposY-bulletPosY 
        if deltaX > -320 and deltaX < 320 and deltaY > -320 and deltaY < 320 then    -- 这个是对100000这个值做的一个简单过滤  
            if not v:outScreenByPosition() and v.m_bDie == false then
                local distance2 = deltaX*deltaX+deltaY*deltaY
                if distance2 < mixDistance then
                    mixDistance = distance2
                    targetFish = v
                    if distance2 < 400 then -- 在这个范围内直接命中
                        return v
                    end
                end
            end
        end
    end
    return targetFish
end
-- 锁定鱼的判定
function FishPaoView:isBulletLockFishConflict(pFish, pBullet,bulletPosX,bulletPosY)
    if pFish == nil or pBullet == nil then
        return false
    end
    local deltaX = pFish.lastposX - bulletPosX
    local deltaY = pFish.lastposY - bulletPosY 
    local distance = deltaX*deltaX + deltaY*deltaY
    if distance < 900 then
        return true
    end
    return false
end
function FishPaoView:isBulletFishConflict(pFish, pBullet,bulletPosX,bulletPosY)
    local fishPosX, fishPosY = pFish.lastposX, pFish.lastposY

--    local fishAngle = pFish.lastAngle
--    if fishAngle ~= 0 then  --旋转矩形框的判断
--        local tempBulletPosx = fishPosX + (bulletPosX - fishPosX) * math.cos( (-fishAngle) * (3.14159/180)) - (bulletPosY - fishPosY) * math.sin( (-fishAngle) * (3.14159/180) )
--        local tempBulletPosy = fishPosY + (bulletPosX - fishPosX) * math.sin( (-fishAngle) * (3.14159/180)) + (bulletPosY - fishPosY) * math.cos( (-fishAngle) * (3.14159/180) )
--        print ("-----bulletPos:" .. bulletPosX .. "," .. bulletPosY .. "=>" .. tempBulletPosx .. "," .. tempBulletPosy )
--        bulletPosX,bulletPosY = tempBulletPosx, tempBulletPosy
--    end    

    local bulletRadius = FishDataMgr:getInstance():getBulletBoundingRadius(pBullet:getBulletType())
--    local rectBullet = {
--        x = bulletPosX - bulletRadius,
--        y = bulletPosY - bulletRadius,
--        width = bulletRadius * 2,
--        height = bulletRadius * 2
--    }

--    local realFishKind = pFish:getRealFishKind()

--    local fishWidthRadius = FishDataMgr:getInstance():getFishBoxWidth(realFishKind)
--    local fishHeightRadius = FishDataMgr:getInstance():getFishBoxheight(realFishKind)

--    local rectFish = {
--        x = fishPosX - fishWidthRadius,
--        y = fishPosY - fishHeightRadius,
--        width = fishWidthRadius * 2,
--        height = fishWidthRadius * 2
--    }

--    if cc.rectIntersectsRect(rectBullet, rectFish)  then
--        return true 
--    end
--    return false 

    local bulletMaxX = bulletPosX + bulletRadius
    local fishMinX = fishPosX - pFish.bounding_box_width_
    if bulletMaxX < fishMinX then 
          return false 
    end 
    local bulletMinx = bulletPosX - bulletRadius
    local fishMaxX = fishPosX + pFish.bounding_box_width_
    if bulletMinx > fishMaxX then 
          return false 
    end 
    local bulletMaxY = bulletPosY +  bulletRadius
    local fishMinY = fishPosY - pFish.bounding_box_height_
    if bulletMaxY < fishMinY then 
          return false 
    end 
    local bulletMinY = bulletPosY -  bulletRadius
    local fishMaxY = fishPosY + pFish.bounding_box_height_ 
    if bulletMinY > fishMaxY then 
          return false
    end 
    return true 
end

--处理子弹和目标鱼碰撞 发送服务器 展示子弹和鱼应有效果
function FishPaoView:dealBulletFish(pFish, pBullet,bulletPosX, bulletPosY, nBulletIndex)
    local nMyChairId = FishDataMgr:getInstance():getMeChairID()
    local userinfor = FishDataMgr:getInstance():getUserInforByChairID(pBullet:getBulletChaiId())
    if not userinfor then return end
       if pBullet:getBulletChaiId() == nMyChairId or (userinfor.is_dummy and FishDataMgr:getInstance().isMaster) then

        --告知服务器碰撞成功
        local pFishID = pFish:getID()
        local bulletScore = pBullet:getBulletScore()
        local bulletTempId = pBullet:getBulletTempId()
        if pFishID ~= nil then
            local hitfishes = {}
            hitfishes[1] = pFishID
            CMsgFish.getInstance():HitContinuously(userinfor.uid, bulletScore, hitfishes)
        end

        -- 碰撞状态
        pFish:setCollisionStatus()
    end

    -- 添加鱼网
    self:addFishNet(cc.p(bulletPosX, bulletPosY), pBullet:getBulletTypeIndex())

    -- 删除子弹
    -- table.removebyvalue(self.m_vecFishBullet, pBullet)
    -- table.remove(self.m_vecFishBullet, nBulletIndex)

    --pBullet:removeFromParent()
end

-- 清除 掉 场景中不移动的子弹
--function FishPaoView:deleteNotMoveBullet(pBullet)
--    if pBullet == nil then 
--           return 
--    end
--    --local bulletPosX, bulletPosY = pBullet:getPosition()
--    -- 添加鱼网
--    self:addFishNet(pBullet.m_curposition, pBullet:getBulletTypeIndex())
--    pBullet:SetUnuse()
--    -- 删除子弹
--    --table.removebyvalue(self.m_vecFishBullet, pBullet)
--    for k, v in pairs( self.m_vecFishBullet ) do
--        if v == pBullet then
--            self.m_vecFishBullet[k] = nil
--        end
--    end

--    --pBullet:removeFromParent()
--end

function FishPaoView:addFishNet(pos, nType)

    local pFishNet = FishNet:create(self, nType)
    pFishNet:setPosition(pos)
    --self.m_pathUI:addChild(pFishNet, 20 + 4)
end 
   
function FishPaoView:getDefinePostion(eType, nSeatIndex)

    local nChaidId = FishDataMgr:getInstance():getMeChairID()
    local myViewChairID = FishDataMgr:getInstance():SwitchViewChairID(nChaidId)
    local x = 0
    local y = 0

    if eType == ePositionType.ETYPE_PAO then

        if nSeatIndex < GAME_PLAYER_FISH / 2 then
            x = 233 + 655 * nSeatIndex
            y = 0
        else
            x = 456 + (3 - nSeatIndex) * 645
            y = 750
        end

    elseif eType == ePositionType.ETYPE_PAO_BTN then

        if nSeatIndex < GAME_PLAYER_FISH / 2 then
            x = 655 * nSeatIndex
            y = 0
        end                                                        

    elseif eType == ePositionType.ETYPE_BUFF then

        if nSeatIndex < GAME_PLAYER_FISH / 2 then
            x = 360 + 640 * nSeatIndex
            y = 100
        else
            x = 340 +(3 - nSeatIndex) * 660
            y = 620
        end

    elseif eType == ePositionType.ETYPE_PAO_INFO then

        if nSeatIndex < GAME_PLAYER_FISH / 2 then
            if nSeatIndex == myViewChairID then
                x = 210 + 653 * nSeatIndex
                y = -10
            else
                x = 150 + 653 * nSeatIndex
                y = -10
            end
        else
            x = 155 +(3 - nSeatIndex) * 653
            y = 685
        end
    end

    return cc.p(x, y)
end 

function FishPaoView:onMsgMewFishTeam(userdata)

    if FishDataMgr:getInstance():getSizeofQueueFishTeam() > 0
    and FishDataMgr:getInstance():getAllStop() == false
    then

        local ret = FishDataMgr:getInstance():popQueueFishTeam()

        -- 客服端不需要显示的鱼不创建
        if not FishDataMgr:getInstance():checkIsShowFishByKind(ret.fish_kind) then
            return
        end

        ----------------------------
        -- add by JackyXu
        -- 场景中已经存在相同 fishId 的鱼则不创建
        if FishDataMgr:getInstance():getFishByID(ret.fish_id) then
            return
        end
        ----------------------------
        local pathObj = FishTraceMgr:getInstance().m_mapAllFishTrace[ret.path_index]
        if pathObj == nil then
           return -- 没有路径
        end

        local width = FishDataMgr:getInstance():getFishBoxWidth(ret.fish_kind)
        local hegith = FishDataMgr:getInstance():getFishBoxheight(ret.fish_kind)
        local radius = FishDataMgr:getInstance():getFishRadius(ret.fish_kind)
        local speed = FishDataMgr:getInstance():getFishSpeed(ret.fish_kind)
        local mul = FishDataMgr:getInstance():getFishMultiple(ret.fish_kind)

         print("***********************************************")
        local pFish = Fish.create(self,ret.fish_kind, ret.fish_id, mul, speed, width, hegith, radius, ret.tag)
        if pFish ~= nil then 
            --pFish:setTraceId(ret.path_index)
            pFish:setAnchorPoint(cc.p(0.5, 0.5))
            pFish:setAliveTime(0)
            if ret.fish_team_type == 1 then
                --和李逵捕鱼数据结构不一样(参考c++代码)
                pFish:setTrace( ret.path_index, 0, 0 )
                if ret.xOffset ~= nil and ret.xOffset > 0 then
                    pFish:setDelay(ret.xOffset / pFish.m_nMovePointSecond)
                else 
                    pFish:startMove(ret.createTime)
                end
            elseif ret.fish_team_type == 2 then
                pFish:setTrace(ret.path_index, ret.xOffset, ret.yOffset)
                pFish:startMove(ret.createTime)
            end
            --self.m_pathUI:addChild(pFish, 10)
            FishDataMgr:getInstance():addFish(pFish)
        end 
    end
end 

function FishPaoView:onMsgMewFish(userdata)

    local i = 0
    while (i < 2 ) do

        local ret = FishDataMgr:getInstance():popQueueFish()
        if ret == nil then 
              break
        end 
        
        -- 鱼已经死了不创建           --客服端不需要显示的鱼不创建
        if ret.isAlive == true and FishDataMgr:getInstance():checkIsShowFishByKind(ret.fish_kind) then
            ----------------------------
            -- add by JackyXu
            -- 场景中已经存在相同 fishId 的鱼则不创建
            if not FishDataMgr:getInstance():getFishByID(ret.fish_id) then
                if ret.bSyncFish then
                 -- 处理同步的鱼数据
                   self:CreateSyncFish(ret) 
                else 
                -- 处理非同步的鱼，新产生的鱼
                    local pathObj = FishTraceMgr:getInstance().m_mapAllFishTrace[ret.path_index]
                    if pathObj == nil then
                       break -- 没有路径
                    end
                    local width = FishDataMgr:getInstance():getFishBoxWidth(ret.fish_kind)
                    local hegith = FishDataMgr:getInstance():getFishBoxheight(ret.fish_kind)
                    local radius = FishDataMgr:getInstance():getFishRadius(ret.fish_kind)
                    local speed = FishDataMgr:getInstance():getFishSpeed(ret.fish_kind)

                    local pFish = Fish.create(self, ret.fish_kind, ret.fish_id, ret.fish_mulriple, speed, width, hegith, radius, ret.tag)
                    if pFish ~= nil then 
                        --pFish:setTraceId(ret.path_index)
                        pFish:setTrace(ret.path_index, ret.xOffset, ret.yOffset)
                        pFish:setAnchorPoint(cc.p(0.5, 0.5))
                        pFish:setAliveTime(ret.elapsed)
                        if ret.delay ~= nil and ret.delay > 0 then
                           local passCreateTime = cc.exports.gettime() - ret.createTime
                           if passCreateTime >= ret.delay then  -- 如果接收到创建鱼的时间已经超出延时时间，就不延时，直接移动
                                pFish:startMove(ret.createTime + ret.delay)
                           else
                                pFish:setDelay(ret.delay - passCreateTime) 
                           end
                        else
                            pFish:startMove(ret.createTime) 
                        end

                        --self.m_pathUI:addChild(pFish, 10 + ret.fish_kind / 5)
                        FishDataMgr:getInstance():addFish(pFish)
                    end
                end
            end
        end
        if not ret.bSyncFish then --同步的鱼一次性加载
            i = i + 1
        end
    end
end 

-- 处理同步的鱼数据
function FishPaoView:CreateSyncFish( newfish ) 
    if newfish == nil then
        return
    end

    local width = FishDataMgr:getInstance():getFishBoxWidth(newfish.fish_kind)
    local hegith = FishDataMgr:getInstance():getFishBoxheight(newfish.fish_kind)
    local radius = FishDataMgr:getInstance():getFishRadius(newfish.fish_kind)
    local speed = FishDataMgr:getInstance():getFishSpeed(newfish.fish_kind)

    local curTime = cc.exports.gettime()
    local passTime = ( curTime - newfish.createTime ) + newfish.passTime / 1000 

    if newfish.path_index < 10000 then 
    -- 普通鱼的同步
        local pathobj = FishTraceMgr:getInstance().m_mapAllFishTrace[newfish.path_index]
        if pathobj == nil then
            return
        end
        local pFish = Fish.create(self, newfish.fish_kind, newfish.fish_id, newfish.fish_mulriple, speed, width, hegith, radius, newfish.tag)
        if pFish == nil then 
            return
        end
        pFish:setAnchorPoint(cc.p(0.5, 0.5))
        pFish:setAliveTime(newfish.elapsed)

--        pFish.PathData1.PathData = pathobj
--        pFish.PathData1.PathID = newfish.path_index
--        pFish.PathData1.PathEndIndex = #pFish.PathData1.PathData[1]
--        pFish.PathData1.OffsetX = newfish.xOffset
--        pFish.PathData1.OffsetY = newfish.yOffset
--        pFish.PathData1.MoveLine = 0
--        pFish.PathData2.PathID = 0

--        pFish.PathStep = PathStepType.PST_ONE
--        pFish.StateTotalTime = 0
--        pFish.StateBeginTime = curTime - passTime        
--        pFish.m_bTraceFinish = true
--        if pFish.m_nTraceId >= 400 and pFish.m_nTraceId < 500 then
--           pFish:setSceneTraceFish(true) -- 发散鱼阵的鱼归为鱼阵类型
--        end
--        local passIndexInt = math.floor( (curTime - pFish.StateBeginTime) * pFish.m_nMovePointSecond )
--        pFish:initPosition(PathStepType.PST_ONE, passIndexInt )    
        
        pFish:setTrace(newfish.path_index, newfish.xOffset, newfish.yOffset)
        pFish:startMove( newfish.createTime - newfish.passTime / 1000 )            

        FishDataMgr:getInstance():addFish(pFish)
    else
    -- 鱼阵的鱼同步
        local sceneID = math.floor( newfish.path_index / 10000 ) - 1
        local pScene = FishSceneMgr:getInstance():getFishScene(sceneID)
        if pScene == nil then
            return
        end
        local fishData = pScene.fishDataMap[newfish.fish_id] 
        if fishData == nil then
            return
        end
        local pathobj = FishSceneMgr:getInstance().map_Path[fishData.path_id1]
        if pathobj == nil then
            return
        end
        local pFish = Fish.create(self, newfish.fish_kind, newfish.fish_id, newfish.fish_mulriple, 30, width, hegith, radius, newfish.tag)
        if pFish ~= nil then 
           pFish:setSceneTraceFish(true)
           self:InitPathData( pFish, fishData)
           local pathTimeTotal = (fishData.end_step1 - fishData.begin_step1) / 30 -- 路径1需要的总时间
           pFish.StateTotalTime = 0
           if pathTimeTotal > passTime then
           --走路径1                       
                pFish.StateBeginTime = curTime - passTime 
                pFish.PathStep = PathStepType.PST_ONE 
           elseif fishData.path_id2 ~= 0 then
           --走路径2
                pFish.StateBeginTime = curTime - passTime + pathTimeTotal
                if fishData.path_id2 == MOVE_FORWARD_PATH then
                    pFish.PathStep = PathStepType.PST_FREE
                else
                    pFish.PathStep = PathStepType.PST_TWO
                end
           else 
                pFish:SetFishUnuse()
                pFish = nil
                return
           end
           local pathIdx = math.floor( (curTime - pFish.StateBeginTime) * 30 )
           pFish:initPosition(pFish.PathStep, pathIdx )
           pFish.m_bTraceFinish = true
           FishDataMgr:getInstance():addFish(pFish)
        end
    end
    
end

function FishPaoView:onMsgPaoFresh(userdata)
    self:showPao()
end 

function FishPaoView:onMsgAddBuff(event)

    local _userdata = unpack(event._userdata)

    local nIndex = tonumber(_userdata.chairId)
    if nIndex < 0 and nIndex >= GAME_PLAYER_FISH then
        return
    end
    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(nIndex)
    if self.m_arrPaoArmature[viewChairID+1] and not self.m_arrPaoArmature[viewChairID+1]:isPaoBuff() then

        -- 创建buff标志
        self:createBuffFlag(viewChairID)
        self.m_arrPaoArmature[viewChairID+1]:addPaoBuff()
    end
end 

function FishPaoView:onMsgDelBuff(event)
    local _userdata = unpack(event._userdata)
    local nIndex = tonumber(_userdata.chairId)
    if nIndex < 0 and nIndex >= GAME_PLAYER_FISH then
        return
    end
    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(nIndex)
    if self.m_arrPaoArmature[viewChairID+1] then

        -- 删除buff标志
        self:delBuffFlag(viewChairID)
        self.m_arrPaoArmature[viewChairID+1]:delPaoBuff()
    end
end 

function FishPaoView:onMsgCatchFish(event)

    local _userdata = unpack(event._userdata)

    local chairId = tonumber(_userdata.chairId)        

    if chairId >= GAME_PLAYER_FISH then
        return
    end

    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(chairId)
    local fishId = tonumber(_userdata.fishId)
    local score = tonumber(_userdata.score)
    local deadIndex = tonumber(_userdata.deadIndex)
    local fish = FishDataMgr:getInstance():getFishByID(fishId)
    if fish ~= nil then

        fish:setFishScore(score)
        fish:setChainStatus(true)

        if fish:getFishKind() == FishKind.FISH_CHAIN then
            if fish:getPlayEffect() then
                ExternalFun.playGameEffect(FishRes.SOUND_OF_QIPAO)
                local item = FishShanDian.create(self, fish, chairId, self.m_actionUI)
                item:setTag(TAG_SHAN_DIAN)
                self.m_pathUI:addChild(item, 90)
            else
                self:showFishCatchGoldEffect(fish:getFishKind(), cc.p(fish.lastposX, fish.lastposY), chairId, score, deadIndex)
                fish:setCatchStatus()
            end
        else
            if score > 0 then
                self:showFishCatchGoldEffect(fish:getFishKind(), cc.p(fish.lastposX, fish.lastposY), chairId, score, deadIndex)
            end
            if fish:getPlayEffect() then
                self:showFishCatchSpecialEffect(fish:getFishKind(), fish:getFishTag(), viewChairID, score, cc.p(fish.lastposX, fish.lastposY))
                --玩家打死的鱼才播音效
                if chairId == FishDataMgr:getInstance():getMeChairID() then
                    self:playFishSound(fish:getFishKind())
                else--其他玩家打死的鱼
                    --FloatMessage.getInstance():pushMessageDebug("其他玩家打死的鱼,不播放音效"..",fishID:"..fishId)
                end
            end
            fish:setCatchStatus()
        end
    end
    --金币动作结束才加金币
    --self:showGoldIcon(chairId)
end 
  
function FishPaoView:effectEnd(armature)

    if armature == nil then
        return
    end
    local strEffecName = armature:getName()
    if strEffecName == "buff_buyu" and armature:getTag() == 0 then
        -- 该动作死循环，防止死循环调用，添加一个tag来判断
        armature:setTag(1)
        armature:getAnimation():play("Animation2")

    elseif strEffecName == "paotaiqiehuan_buyu" then
        armature:removeFromParent()
    end
end 

function FishPaoView:playChangeBackgroundArraycallback(dt)

    print("FishPaoView:playChangeBackgroundArraycallback ======")
    FishDataMgr:getInstance():delAllFish()
    self:_playChangeScene()
end

--function FishPaoView:loadNewBG()
--    print("FishPaoView:loadNewBG")

--    local nIndex = FishDataMgr.getInstance():getSceneBGIndex()
--    local nNewIndex =((nIndex + 1) % 3 + 1)
--    FishDataMgr.getInstance():setSceneBGIndex(nNewIndex)

--    local asyncHandler = function(texture)
--        if FishPaoView.instance_ ~= nil then 
--            FishPaoView.instance_:imageAsyncCallBack(texture)
--        end
--    end

--    local strName = FishRes.PNG_OF_BG[nNewIndex]
--    local sharedTextureCache = cc.Director:getInstance():getTextureCache()
--    sharedTextureCache:addImageAsync(strName, asyncHandler)
--end 

function FishPaoView:createFishArraycallback(dt)
    local sceneData = FishDataMgr:getInstance():getSwtichSceneData()
    if sceneData == nil then return end
    FishDataMgr:getInstance().m_bCheckDistributeFish = false -- 这里等到鱼阵的鱼创建完成，对判断普通鱼的生成时间更保险
    print("createFishArraycallback--------鱼阵加载完成 －－－－－－－－－－－－－")
    local createTime = 0 -- 对于第一个鱼阵，由于loading的时间，导致客户端会比服务器时间慢
    if dt == 0 then  
          createTime = sceneData.create_time
    end

    -- local curTime = cc.exports.gettime()
    for i = 1, #self.m_vecFishArray do

        local pFish = self.m_vecFishArray[i]
        ----------------------------
        -- modify by JackyXu
        -- 场景中已经存在相同 fishId 的鱼则不添加到 FishDataMgr
        local nFishId = pFish:getID()
        if FishDataMgr:getInstance():getFishByID(nFishId) then
            --pFish:removeFromParent()
            pFish:SetFishUnuse()
            pFish = nil
        else
            if dt == 0 then
               pFish:startMove(createTime)
            else 
                pFish:setDelay(0)   --先进入停止状态，避免画面抖动
            end

            pFish:setVisible(true)
            FishDataMgr:getInstance():addFish(pFish)
        end
        ----------------------------
    end
    self.m_vecFishArray =  {}
    --self:loadNewBG()
end 

--function FishPaoView:imageAsyncCallBack(texture)                                                                

--    if self.m_pNewBG == nil then 
--          return 
--    end 
--    self.m_pNewBG:setTexture(texture)
--    self.m_pBGTexture2D = texture
--end 

function FishPaoView:onMsgSwitchScene(userdata)

    FishDataMgr:getInstance():getAllFishLastScene()
    FishDataMgr:getInstance():ClearFishQuene()
    local switch_scene = FishDataMgr:getInstance():getSwtichSceneData()
    print("所有的鱼开始加速--------------------------------")
    if switch_scene.tick_count == 0 then
        self:effectSceneEnd(0)

    else
        FishDataMgr:getInstance():setFishAllAccelerate()
        FishDataMgr:getInstance():setAllowFire(false)
        print("go run callback======playChangeBackgroundArraycallback======= ")

        local actionDelay = cc.DelayTime:create(2)
        local actionCall = cc.CallFunc:create( function()
            self:playChangeBackgroundArraycallback(2)
        end )
        local actionAll = cc.Sequence:create(actionDelay, actionCall)
        self:runAction(actionAll)

        print("创建鱼阵 －－－－－－－")
        local switch_scene = FishDataMgr:getInstance():getSwtichSceneData()
        self.m_ptrSwitchScene = FishSceneMgr:getInstance():getFishScene(switch_scene.next_scene)
        for  i = 1, #self.m_ptrSwitchScene.fishDataMap do
            local fish = self.m_ptrSwitchScene.fishDataMap[i]
            fish.fish_id = switch_scene.fishids[i] or 0
        end
        self.m_bLoadSceneFish = true
        self.m_nCreateIndex = 0
    end

    local actionDelay = cc.DelayTime:create(6)
    local actionCall = cc.CallFunc:create(function()
        self:createFishArraycallback(6)
    end)
    local actionAll = cc.Sequence:create(actionDelay, actionCall)
    self:runAction(actionAll)

    print("切换场景 －－－－－－－ %ld", os.time())
end 

function FishPaoView:onMsgScoreFresh(event)

    local _userdata = unpack(event._userdata)
    local i = tonumber(_userdata.chairId)
    if i < 0 or i >= GAME_PLAYER_FISH then
        return
    end

    local fishScore = FishDataMgr:getInstance():getFishScoreByIndex(i)
    -- local strFormatGold = string.format("%d.%02d", (fishScore/100), math.abs((fishScore)%100))
    local strFormatGold = string.format("%0.2f", fishScore)
    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(i)
    if self.m_pUsrGold[viewChairID+1] then
        self.m_pUsrGold[viewChairID+1]:setString(strFormatGold)
    end

--    self.m_pUsrGold[viewChairID+1]:runAction(cc.Sequence:create(cc.ScaleTo:create(0.3, 1.3), cc.DelayTime:create(0.2), 
--            cc.CallFunc:create(function()
--                self.m_pUsrGold[viewChairID+1]:setString(strFormatGold)
--            end), cc.ScaleTo:create(0.3, 1)))
--        self.m_pUsrGoldBg[viewChairID+1]:runAction(cc.Sequence:create(cc.Show:create(),cc.DelayTime:create(1.0),cc.Hide:create()))
end

function FishPaoView:onMsgTounchEvent(event)
    local _userdata = unpack(event._userdata)
       -- {game.setting.msgId,op,uid,{...}}
    local body = _userdata.msg
    local uid = body[3]
    if uid == GlobalUserItem.tabAccountInfo.userid then
        return
    end
    local opCode = body[2]

    local msgId = body[1]
    local msg = body[4]
  
    local op =  GameOpCodeEnum[opCode]
    if op ~= nil then
        local handler = "On_".. op
        if self[handler] ~= nil then
            self[handler](self,uid,msg)
        end
    end
end

function FishPaoView:On_TouchPhase_Began(uid, body)
    local x = body[1]
    local y = body[2]
    FishDataMgr:getInstance():setlastFirePos(uid, cc.p(x, y))
    FishDataMgr:getInstance():setTouchPhase(uid, true)
 end

function FishPaoView:On_TouchPhase_Moved(uid, body)
    local x = body[1]
    local y = body[2]
    FishDataMgr:getInstance():setlastFirePos(uid, cc.p(x, y))
end

function FishPaoView:On_TouchPhase_Ended(uid, body)
    FishDataMgr:getInstance():setTouchPhase(uid, false)
end

function FishPaoView:On_Firing_Interval(uid, body)
    local firingInterval = body[1]
    FishDataMgr:getInstance():setfiringInterval(uid,firingInterval)
end

function FishPaoView:On_Firing_Stop(uid, body)
    local isStop = body[1]
    FishDataMgr:getInstance():setstopAttack(uid,isStop)
end

function FishPaoView:On_Automatic_Firing(uid, body)
    local isAutomaticFiring = body[1] 
    FishDataMgr:getInstance():setAutomaticFiring(uid,isAutomaticFiring)
    FishDataMgr:getInstance():setstopAttack(uid,not isAutomaticFiring)
end

function FishPaoView:On_Lock_In(uid, body)
    local lockInEnum = body[1]
--    self.lockIn = lockInEnum
--    if lockInEnum == game.setting.lockInEnum.normal then
--      self:SetSight(false)
--      self.targetFish = nil
--      self.targetId = 0
--    end 
end

function FishPaoView:On_Lock_Fish(uid, body)
    local targetId = body[1]
    self:lock_fish(uid, targetId)
end

function FishPaoView:On_Npc_Lock_Fish(uid, body)
    local lockIn = body[1]
    local angel = body[2]
    FishDataMgr:getInstance():setfireAngel(uid, angel)
    if lockIn ~= cmd.lockInEnum.normal then
         FishDataMgr:getInstance():setUserLockFish(uid, true)
    else
        FishDataMgr:getInstance():setUserLockFish(uid, false)
    end

    local angle =  math.angle2radian(angel-90+360)
    local chairID = FishDataMgr:getInstance():getChairIDByGuid(uid)
    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(chairID)
    local begin = self.m_arrPaoPos[viewChairID+1]
    self.m_arrPaoArmature[viewChairID+1]:rotatePao(math.radian2angle(angle))
  -- 获得目标点
    local x = 0
    local y = 0

    local bRotate = false
    local meChairID = FishDataMgr:getInstance():getMeChairID()
    local rBegin = {
        x = begin.x,
        y = begin.y,
    } 

    if chairID ~= meChairID then

        if meChairID <= 1 and chairID > 1 then

            bRotate = true
            local position = self.m_arrPaoPos[chairID % 2+1]
            rBegin.x = position.x 
            rBegin.y = position.y
            -- 玩家真正发炮的位置

        elseif meChairID > 1 and chairID <= 1 then

            bRotate = true
            local position = self.m_arrPaoPos[chairID+1]
            rBegin.x = position.x 
            rBegin.y = position.y
        end
    end

    x,y = FishDataMgr:getInstance():GetTargetPoint(rBegin.x, 750 - rBegin.y, angle, x, y)
    local target = cc.p(x, 750 - y)
    if bRotate then
        target.x = 1334 - target.x
        target.y = 750 - target.y
        angle = angle + math.pi
        self.m_arrPaoArmature[viewChairID+1]:rotatePao(math.radian2angle(angle))
    end
end

function FishPaoView:onMsgScoreFresh2(event)

    local _userdata = unpack(event._userdata)
    local i = tonumber(_userdata.chairId)
    if i < 0 or i >= GAME_PLAYER_FISH then
        return
    end

    local fishScore = FishDataMgr:getInstance():getFishScoreByIndex(i)
    local strFormatGold = string.format("%0.2f", fishScore)
    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(i)
    if self.m_pUsrGold[viewChairID+1] then
        self.m_pUsrGold[viewChairID+1]:setString(strFormatGold)
        --self:showLabelAction(self.m_pUsrGold[viewChairID+1])
    end

    --浮动文字
    self:showGoldIcon2(i, _userdata.nScore)
end

function FishPaoView:onMsgUpdatePao(event)

    local _userdata = unpack(event._userdata)
    local nChaiId = _userdata
    self:_showPao(nChaiId)
end 

function FishPaoView:openNoticeMaxBullet(dt)

    self.m_bIsFMessageBulletMax = false
end 
  
function FishPaoView:openNoticeExchangeScene(dt)

    self.m_bIsFMessageSence = false
end 

function FishPaoView:myFire(target, islocal)
    if self.m_nFireTime - self.m_nFireTimeLast < FishDataMgr:getInstance():getfiringInterval(GlobalUserItem.tabAccountInfo.userid) then
        return true
    else
        self.m_nFireTimeLast = self.m_nFireTime
    end

    if FishDataMgr:getInstance():getIsNetworkFail() == true then
        return true
    end

    -- 检查玩家是否可以发炮弹
    if not FishDataMgr:getInstance():getAllowFire() then

        if self.m_bIsFMessageSence then
            return true
        end
        self.m_bIsFMessageSence = true

        local callFunc = cc.CallFunc:create( function()
            self:openNoticeExchangeScene(10)
        end )
        self:runAction(cc.Sequence:create(cc.DelayTime:create(10), callFunc))

        if self.m_nlocalFire ~= 1 then
            FloatMessage.getInstance():pushMessage("STRING_122")
        end
        return true
    end

    if self:isMyMaxBullet() then
        if self.m_bIsFMessageBulletMax then
            return true
        end
        self.m_bIsFMessageBulletMax = true
        local callFunc = cc.CallFunc:create( function()
            self:openNoticeMaxBullet(10)
        end )
        self:runAction(cc.Sequence:create(cc.DelayTime:create(10), callFunc))
        if self.m_nlocalFire ~= 1 then
            FloatMessage.getInstance():pushMessage("STRING_121")
        end
        return true
    end

    local myChairID = FishDataMgr:getInstance():getMeChairID()
    local myViewChairID = FishDataMgr:getInstance():SwitchViewChairID(myChairID)
    if myChairID == INVALID_CHAIR then
        -- print("error ....... mySeatIndex is invalid values.")
        return true
    end
    local curFishScore = FishDataMgr:getInstance():getFishScoreByIndex(myChairID)
    local mulriple = FishDataMgr:getInstance():getMulripleByIndex(myChairID)
    if curFishScore < mulriple then
        if islocal then
            -- 取消自动开炮
            self:onAIClicked(nil, cc.CONTROL_EVENTTYPE_TOUCH_DOWN)
        end

        CMsgFish.getInstance():FireContinuously(204, GlobalUserItem.tabAccountInfo.userid, true)
        self._queryDialog = QueryDialog:create(yl.getLocalString("STRING_059"), function(ok)
            self._queryDialog = nil
        end, nil, QueryDialog.QUERY_SURE):setCanTouchOutside(false)
            :addTo(self)
        return false
    end

    if mulriple <= 0 then
        FloatMessage.getInstance():pushMessage("STRING_123")
        return true
    end

    if self.m_arrPaoArmature[myViewChairID+1] then

        self.m_nBulletTempId = self.m_nBulletTempId + 1
        local paoPosX,paoPosY = self.m_arrPaoArmature[myViewChairID+1]:getPosition()
        local angle = MathAide:CalcAngle(target.x, 750 - target.y, paoPosX, 750 - paoPosY)
        local bkKindID = FishDataMgr:getInstance():getbulletKindByIndex(myChairID)
        -- 开炮
        local fish_id = -1
        if FishDataMgr:getInstance():getLock() then

            fish_id = self.m_nLockFish
            if not FishDataMgr:getInstance():checkFishLock(fish_id) then
                fish_id = FishDataMgr:getInstance():getLockFish2()
                self.m_nLockFish = fish_id
            end
        end

        local pTempBullet = self:createBullet(-1, self.m_nBulletTempId, mulriple, self.m_arrPaoArmature[myViewChairID+1]:isPaoBuff(), angle, myChairID, fish_id)
        if pTempBullet ~= nil then
            if fish_id~=-1 then
                CMsgFish.getInstance():FireContinuously(200, GlobalUserItem.tabAccountInfo.userid, cmd.lockInEnum.normal)
                CMsgFish.getInstance():FireContinuously(201, GlobalUserItem.tabAccountInfo.userid, fish_id)
            end
            CMsgFish.getInstance():FireContinuously(204, GlobalUserItem.tabAccountInfo.userid, false)

            -- 扣钱
            FishDataMgr:getInstance():exchangeFishScore(myChairID, curFishScore - mulriple)
            local fishScore = FishDataMgr:getInstance():getFishScoreByIndex(myChairID)
            CMsgFish.getInstance():sendCheckUserInfo( myChairID, fishScore )

            if self.m_nlocalFire == 1 then
                self:getParent():getParent():getParent():begineCountDown(true)
            else
                self:getParent():getParent():getParent():begineCountDown(false)
            end

            local tempBullet = {}
            tempBullet.tempID = self.m_nBulletTempId
            tempBullet.tempScore = mulriple
            table.insert(self.m_vecMyTempFishBullet, tempBullet)
            self.m_lastTarget = target
        end
    end

    return true
end 

function FishPaoView:onMsgNewFire(userdata)

    local nMyChirId = FishDataMgr:getInstance():getMeChairID()
    while (FishDataMgr:getInstance():getSizeOfQueueFire() > 0) do

        local ret = FishDataMgr:getInstance():popQueueFire()
        local nChairId = ret.chair_id
        local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(nChairId)
        if nChairId < GAME_PLAYER_FISH and self.m_arrPaoArmature[viewChairID+1] ~= nil then
            if nMyChirId ~= nChairId then
--                local fishScore = FishDataMgr:getInstance():getFishScoreByIndex(nChairId)
--                FishDataMgr:getInstance():exchangeFishScore(nChairId, fishScore - ret.bullet_mulriple)
                self:OtherFire(ret.angle, ret.bullet_id, ret.bullet_mulriple, ret.bullet_double, nChairId, ret.lock_fishid)
            else
                local bulletObj = self:GetBulletObject(nMyChirId, ret.bullet_temp_id )
                if bulletObj ~= nil then --设置服务器的子弹ID
                   --print( "------set bullet id: " .. bulletObj.m_nBulletId .. "  ===> " .. ret.bullet_id  )
                   bulletObj:setBulletId( ret.bullet_id )
                end

                for k, v in pairs(self.m_vecMyTempFishBullet) do
                    if v~=nil and v.tempID == ret.bullet_temp_id then
                        self.m_vecMyTempFishBullet[k] = nil
                        break
                    end
                end
            end
        else
            return
        end
    end
end 

function FishPaoView:OtherFire(angle, bullet_mulriple, firer_chair_id, lock_fish_id)
    self:createOtherBullet(bullet_mulriple,angle, firer_chair_id, lock_fish_id)
    return bullet_id
end 

function FishPaoView:_playChangeScene()
    print("FishPaoView:_playChangeScene")

    --新场景图
    local scene = FishDataMgr:getInstance():getSwtichSceneData()
    local index = scene.next_scene
    local image = FishRes.PNG_OF_BG[index % 8 + 1]
    self.m_pNewBG:setTexture(image)

    if self.m_pActionHailang == nil then
        --海浪动画
        self.m_pActionHailang = ccs.Armature:create("hailang_buyu")
        self.m_pActionHailang:getAnimation():play("Animation1")
        self.m_pActionHailang:setAnchorPoint(cc.p(0, 0))
        self.m_pActionHailang:setPosition(cc.p(display.width + 200, 0))
        self.m_pActionHailang:addTo(self.m_pBg:getParent(), 20)
        --海浪粒子
        local partical = cc.ParticleSystemQuad:create(FishRes.PARTICLE_OF_HAILANG)
        partical:setPosition(cc.p(-250, 0))
        partical:addTo(self.m_pActionHailang, 20)
    end

    --海浪移动
    local size = self.m_pBg:getContentSize()
    local offsetX = (display.width - 1334) / 2
    local startRect = cc.rect(size.width, 0, 0, 750)
    local stopRect  = cc.rect(0, 0, size.width, 750)
    local time_now, time_stop = 0, 2.5
    local speed = 1624 / time_stop
    local _move, _posX, _width = 0, 0, 0
    
    self.handler_change = scheduler:scheduleScriptFunc(function(dt)
        if time_now < time_stop and _width < size.width then
            time_now = time_now + dt
            _move = math.floor(time_now * speed)
            _posX = math.max(size.width - offsetX - _move, 0)
            _width = math.min(_move + offsetX, size.width)
            self.m_pNewBG:setVisible(true)
            self.m_pNewBG:setTextureRect(cc.rect(_posX, 0, _width, display.height))
            self.m_pActionHailang:setVisible(true)
            self.m_pActionHailang:setPosition(_posX - 250, 0)
            --print(time_now, "posX:".. _posX, "width:" .. _width)
        else
            if self.handler_change then
                scheduler:unscheduleScriptEntry(self.handler_change)
                self.handler_change = nil
            end

            --最后移动到界面外
            local outsize = 300
            local time = outsize / speed
            local offset = self.m_pActionHailang:getPositionX() - outsize
            local move = cc.MoveBy:create(time, cc.p(offset, 0))
            local hide = cc.Hide:create()
            local call = cc.CallFunc:create(handler(self, self.effectSceneEnd))
            local seq = cc.Sequence:create(move, hide, call)
            self.m_pActionHailang:runAction(seq)

            --更换背景
            local nextScene = FishDataMgr:getInstance():getSwtichSceneData()
            local index = nextScene.next_scene
            local pathBg = FishRes.PNG_OF_BG[index % 8 + 1]
            self.m_pBg:setTexture(pathBg)
            self.m_pBg:setVisible(true)
            self.m_pNewBG:setVisible(false)
        end
    end, 0.01, false)
end 

function FishPaoView:effectSceneEnd(dt)
    print("FishPaoView:effectSceneEnd")
    if self.m_pNewBG then
        print("FishPaoView:effectSceneEnd====== go postMsg MSG_FISH_CHANGE_BG")
        SLFacade:dispatchCustomEvent(FishEvent.MSG_FISH_CHANGE_BG, nil)
    end
end 

--function FishPaoView:getTextureBG()
--     return  self.m_pBGTexture2D
--end

function FishPaoView:deleteWave()

    if self.m_pActionHailang and self.m_pActionHailang:isVisible() then
        self.m_pActionHailang:setVisible(false)
    end
    if self.m_pNewBG and self.m_pNewBG:isVisible() then
        self.m_pNewBG:setVisible(false)
    end

    FishDataMgr:getInstance():delAllFishLastScene()
    FishDataMgr:getInstance():ClearFishQuene()
    print("------------------------------------设置可以开炮")
    FishDataMgr:getInstance():setAllowFire(true)
end 

function FishPaoView:showFishCatchGoldEffect(_fishKind, _pos, nChairId, iScore, deadIndex)
    -- gold
    if self.m_pFishGoldManage == nil then
        return
    end
    if not FishDataMgr:getInstance():getIsExistByIndex(nChairId) then 
          return 
    end 
    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(nChairId)
    local desPos = self:getDefinePostion(ePositionType.ETYPE_PAO_INFO, viewChairID)
    desPos = cc.pAdd(desPos, self.m_seatOffPos[viewChairID+1])
    local node = {
        kind = _fishKind,
        startPos = _pos,
        desPos = desPos,
        score = iScore,
        chairID = nChairId,
        deadIdx = deadIndex
    }
    self.m_pFishGoldManage:pushDeadNode(node)

    -- score
    local item = FishNumber.create(self, iScore, nChairId)
    local contentSize = item:getLabelContentSize()
    if _pos.x < contentSize.width then 
        _pos.x = contentSize.width
    end 
    if _pos.x > 1334-contentSize.width then 
        _pos.x = 1334-contentSize.width
    end 
    if _pos.y < contentSize.height then 
        _pos.y = contentSize.height
    end                                                                 
    if _pos.y > 740- contentSize.height then              
        _pos.y = 740- contentSize.height
    end 
    item:setPosition(_pos)
    --item:addTo(self.m_pathUI, 90)
end 

--每个捕鱼特效不同
function FishPaoView:showFishCatchSpecialEffect(_fishKind, tag, _nSeatIndex, _llScore, _pos)
    --print("FishPaoView:showFishCatchSpecialEffect")

    --动画
    if _fishKind == FishKind.FISH_YINSHA        --15-银鲨
    or _fishKind == FishKind.FISH_JINSHA        --16-金鲨
    or _fishKind == FishKind.FISH_BAWANGJING    --17-霸王鲸
    or _fishKind == FishKind.FISH_XIAOYINLONG   --22-小银龙
    or _fishKind == FishKind.FISH_XIAOJINLONG   --23-小金龙
    or _fishKind == FishKind.FISH_SHUANGTOUQIE  --24-双头企鹅
    then
        self:showJiShaDaYuAnimation(_fishKind, _nSeatIndex, _llScore)
        self:showJiShaAinamation(_fishKind, BOOM_TYPE.BOOM_TYPE_BIG, _pos)

    elseif _fishKind == FishKind.FISH_JINCHAN --18-李逵
    then
        self:showJiShaDaYuAnimation(_fishKind, _nSeatIndex, _llScore)
        self:showJiShaAinamation(_fishKind, BOOM_TYPE.BOOM_TYPE_BOSS, _pos)

    elseif _fishKind == FishKind.FISH_FOSHOU --26-七星剑
    then
        self:showWanFoChaoZhongEffect(_pos)

    elseif _fishKind == FishKind.FISH_BGLU --27-炼丹炉
    then
        self:showLianDanLuEffect(_pos, tag)

    elseif _fishKind == FishKind.FISH_DNTG --28-大闹天宫
    or _fishKind == FishKind.FISH_PIECE    --31-金玉满堂
    then
        self:showShanDianEffect(_fishKind, _pos, tag)
    end

    --震屏
    if _fishKind == FishKind.FISH_BAWANGJING    --17-霸王鲸
    or _fishKind == FishKind.FISH_JINCHAN       --18-李逵
    or _fishKind == FishKind.FISH_XIAOYINLONG   --22-小银龙
    or _fishKind == FishKind.FISH_XIAOJINLONG   --23-小金龙
    or _fishKind == FishKind.FISH_FOSHOU        --26-七星剑
    or _fishKind == FishKind.FISH_BGLU          --27-忠义堂
    then
        SLFacade:dispatchCustomEvent(FishEvent.MSG_SHAKE_SCREEN)
    end

    if DataCacheMgr:getInstance():PlayGoldRaiseSound() then
        --声音
        if FishKind.FISH_WONIUYU <= _fishKind and _fishKind <= FishKind.FISH_BIANFUYU then
            ExternalFun.playGameEffect(FishRes.SOUND_OF_KILL_SMALL) --0-14-小鱼
        elseif _fishKind == FishKind.FISH_HAIDAN then --21-海胆
            ExternalFun.playGameEffect(FishRes.SOUND_OF_KILL_SMALL)
        elseif _fishKind == FishKind.FISH_FOSHOU then --26-七星剑
            ExternalFun.playGameEffect(FishRes.SOUND_OF_BIG_BOMB)
        elseif FishKind.FISH_DNTG <= _fishKind and _fishKind <= FishKind.FISH_PIECE then --28-31
            ExternalFun.playGameEffect(FishRes.SOUND_OF_SHANDIAN)
        end
    end
end 
               
-- 击杀动画
function FishPaoView:showJiShaAinamation(_fishKind, ntype, _pos)

    local armature = nil
    if ntype == BOOM_TYPE.BOOM_TYPE_BIG then
        armature = ccs.Armature:create("fish_effect_bomb_big_03")
    elseif ntype == BOOM_TYPE.BOOM_TYPE_BOSS then
        armature = ccs.Armature:create("fish_effect_bomb_big_02")
    end
    armature:setPosition(_pos)
    armature:getAnimation():play("Animation1")
    local function animationEvent(armature,moveMentType,moveMentId)
        if moveMentType == ccs.MovementEventType.complete  then 
            if moveMentId == "Animation1" then 
                self:removeArmature(armature)
            end 
        end 
    end
    armature:getAnimation():setMovementEventCallFunc(animationEvent)
    
    self.m_pathUI:addChild(armature, 100)
end
         
-- 击杀大鱼动画
function FishPaoView:showJiShaDaYuAnimation(_fishKind, _nSeatIndex, _llScore)

    local pos = self:getDefinePostion(ePositionType.ETYPE_PAO, _nSeatIndex)

    if _nSeatIndex >= GAME_PLAYER_FISH / 2 then
        pos = cc.p(pos.x - 175, pos.y - 190)
    else
        pos = cc.p(pos.x + 175, pos.y + 190)
    end
    local item = JiShaDaYuItem.create(_fishKind, _llScore, _nSeatIndex)    
    item:setTag(TAG_JI_SHA_DA_YU_ZHUAN_PAN)
    item:setPosition(pos)
    if _fishKind == FishKind.FISH_JINCHAN then
        self.m_pathUI:addChild(item, 100)
    else
        self.m_pathUI:addChild(item, 90 + 1)
    end
end
           
-- 万佛朝中效果
function FishPaoView:showWanFoChaoZhongEffect(_pos)

    local armature = ccs.Armature:create("allscreenbomb")
    armature:getAnimation():play("bomb")
    armature:setPosition(cc.p(667, 375))
    local function animationEvent(armature,moveMentType,moveMentId)
        if moveMentType == ccs.MovementEventType.complete then 
            if moveMentId == "bomb" then 
                self:removeArmature(armature)
            end 
        end 
    end
    armature:getAnimation():setMovementEventCallFunc(animationEvent)
    self.m_pathUI:addChild(armature, 100)

    print("----------------------------万佛朝中 ")
end

-- 闪电炮
function FishPaoView:showShanDianEffect(_fishKind, _pos, tag)
    print("FishPaoView:showShanDianEffect")
    LightningManager.getInstance():createLighting(self, _pos, _fishKind, tag)
end 
          
--打爆炼丹炉效果
function FishPaoView:showLianDanLuEffect(_pos, tag)
    print("FishPaoView:showLianDanLuEffect")
    if tag == 0 then
        -- 镇妖塔
        ExternalFun.playGameEffect(FishRes.SOUND_OF_ZHONGYITANG)
        self:showZhenYaoTaEffect(_pos)
        print("---------------------------------------------镇妖塔")

    elseif tag == 1 then
        -- 无敌风火轮
        ExternalFun.playGameEffect(FishRes.SOUND_OF_JUBUZHADAN)
        self:showFengHuoLunEffect(_pos)
        print("---------------------------------------------无敌风火轮")
    end
end                

-- 镇妖塔
function FishPaoView:showZhenYaoTaEffect(_pos)
    print("FishPaoView:showZhenYaoTaEffect")

    --粒子
    local partical = cc.ParticleSystemQuad:create(FishRes.PARTICLE_OF_BAOZHA_1)
    partical:setPosition(_pos)
    self.m_pathUI:addChild(partical, 90 + 2)
    local partical2 = cc.ParticleSystemQuad:create(FishRes.PARTICLE_OF_BAOZHA_2)
    partical2:setPosition(_pos)
    self.m_pathUI:addChild(partical2, 90 + 1)

    FishDataMgr.getInstance():setAllSleepStatus(true)
    print("=====setAllSleepStatus to true============== ")

    --回调
    local callFunc = cc.CallFunc:create( function()
        self:showZhenYaoTaEffectEnd(6, partical, partical2)
    end )
    self:runAction(cc.Sequence:create(cc.DelayTime:create(6), callFunc))

    --定
    local armature2 = ccs.Armature:create("bomb_zhongyitang")
    armature2:getAnimation():play("bomb")
    armature2:setPosition(cc.p(667, 375))
    local function animation2Event(armature,moveMentType,moveMentId)
        if moveMentType == ccs.MovementEventType.complete
        or moveMentType == ccs.MovementEventType.loopComplete
        then
            if moveMentId == "bomb" then 
                self:removeArmature(armature)
            end 
        end 
    end
    armature2:getAnimation():setMovementEventCallFunc(animation2Event)
    armature2:addTo(self.m_pathUI, 90)
end 
                                                     
function FishPaoView:showZhenYaoTaEffectEnd(dt, p1, p2)

    print("=====callback setAllSleepStatus to false============== ")
    FishDataMgr:getInstance():setAllSleepStatus(false)
    p1:removeFromParent()
    p2:removeFromParent()
end 

-- 无敌风火轮
function FishPaoView:showFengHuoLunEffect(_pos)

    local armature = ccs.Armature:create("localbombfire")
    armature:getAnimation():play("bomb")
    armature:setPosition(_pos)
    local function animationEvent(armature,moveMentType,moveMentId)
        if moveMentType == ccs.MovementEventType.complete
        or moveMentType == ccs.MovementEventType.loopComplete
        then
            if moveMentId == "bomb" then 
                self:removeArmature(armature)
            end 
        end 
    end
    armature:getAnimation():setMovementEventCallFunc(animationEvent)
    self.m_pathUI:addChild(armature, 90)
end

function FishPaoView:removeArmature(armature)

    if armature ~= nil then
        armature:removeFromParent()
        armature = nil
    end
end 

function FishPaoView:_getMyBulletCount()

    local fishBulletCount = 0
    local nMeChairId = FishDataMgr:getInstance():getMeChairID()
    for k, v in pairs(self.m_vecFishBullet) do
        if v and v:getBulletChaiId() == nMeChairId then
            fishBulletCount = fishBulletCount + 1
        end
    end
    return fishBulletCount
end 


function FishPaoView:_getBulletCount(chairid)

    local fishBulletCount = 0
    for k, v in pairs(self.m_vecFishBullet) do
        if v and v:getBulletChaiId() == chairid then
            fishBulletCount = fishBulletCount + 1
        end
    end
    return fishBulletCount
end 

--查找指定椅子ID和tempID的子弹
function FishPaoView:GetBulletObject( chairID, tempID)
    for k, v in pairs(self.m_vecFishBullet) do
        if v~=nil and v.m_nBulletChaiId == chairID and v.m_nBulletTempId == tempID then
            return v
        end
    end
    return nil 
end 

--获得同步子弹分数时，已经开炮出去的子弹分数
function FishPaoView:GetSubScoreBulletObject( chairID, bulletTempID )
    local SubScore = 0
    for k, v in pairs(self.m_vecMyTempFishBullet) do
        if v~=nil then 
            if v.tempID > bulletTempID then -- 这里查找的是，没有经过服务器同步的子弹，后发的子弹tempID肯定比服务器同步ID的大
                SubScore = SubScore + v.tempScore
            end
        end
    end
    return SubScore 
end
 
-- 同步金币消息处理
function FishPaoView:onMsgScoreSync(event)
    local _userdata = unpack(event._userdata)
    local chairId = tonumber(_userdata.chairId)   
    local syncType = tonumber(_userdata.syncType)  
    local Data1 = tonumber(_userdata.Data1)  
    local Data2 = tonumber(_userdata.Data2)  
    local CurScore = tonumber(_userdata.CurScore)       
    local resScore = CurScore
    if chairId >= GAME_PLAYER_FISH then
        return
    end
    local nMeChairId = FishDataMgr:getInstance():getMeChairID()
    if syncType == 1  then  -- 子弹分数同步类型
       if chairId == nMeChairId then -- 自己的同步需要减去开炮的子弹金币，其他玩家则直接同步
           local bulletScore = self:GetSubScoreBulletObject( chairId, Data2 ) -- 需要减去的子弹金币
           resScore = CurScore - bulletScore
           if resScore < 0 then 
                resScore = 0
           end
       else
          resScore = CurScore
       end
       FishDataMgr:getInstance():exchangeFishScore(chairId, resScore) 
    end
end
function FishPaoView:onMsgBombEffect(event)
    local _userdata = unpack(event._userdata)  
    local ChairId = tonumber(_userdata.ChairId)       
    local BombFishID = tonumber(_userdata.BombFishID)   
    local BombKindID = tonumber(_userdata.BombKindID)  
    local TotalScore = tonumber(_userdata.TotalScore)  
    if ChairId >= GAME_PLAYER_FISH then
        return
    end
    if ChairId ~=  FishDataMgr:getInstance():getMeChairID() then
        return
    end
    
    local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(ChairId)
    local item = JiShaBombEffect.create(BombKindID, TotalScore, viewChairID)  
    if item == nil then
        return
    end  
    item:setTag(TAG_JI_SHA_DA_YU_BOMB) 
    if item.bombType == 1 then
        local pos = cc.p( display.width / 2, display.height / 2 )
        if LuaUtils.IphoneXDesignResolution then
            pos.x = pos.x - LuaUtils.screenDiffX
        end
        item:setPosition(pos)
    else 
        local pos = self:getDefinePostion(ePositionType.ETYPE_PAO, viewChairID)
        if viewChairID >= GAME_PLAYER_FISH / 2 then
            pos = cc.p(pos.x - 175, pos.y - 190)
        else
            pos = cc.p(pos.x + 175, pos.y + 190)
        end
        item:setPosition(pos)
    end

    if self.m_arrPaoArmature[viewChairID+1] ~= nil then
        local paoPosX, paoPosY = self.m_arrPaoArmature[viewChairID+1]:getPosition()
        item.m_PaoPos = cc.p( paoPosX, paoPosY )
    end
    self.m_pathUI:addChild(item, 100 + 20)
end

function FishPaoView:isMyMaxBullet()
    return self:_getMyBulletCount() >= BULLET_NUM_MAX
end 

FishPaoView.SOUND_OF_FISH = {
    [FishKind.FISH_XIAOCIYU]      = true, --6-小刺鱼
    [FishKind.FISH_HAIGUI]        = true, --9-海龟
    [FishKind.FISH_KONGQUEYU]     = true, --12-孔雀鱼
    [FishKind.FISH_BIANFUYU]      = true, --14-蝙蝠鱼
    [FishKind.FISH_YINSHA]        = true, --15-银鲨
    [FishKind.FISH_JINSHA]        = true, --16-金鲨
    [FishKind.FISH_JINCHAN]       = true, --18-李逵
    [FishKind.FISH_XIAOYINLONG]   = true, --22-小银龙
    [FishKind.FISH_XIAOJINLONG]   = true, --23-小金龙
    [FishKind.FISH_SHUANGTOUQIE]  = true, --24-双头企鹅
    [FishKind.FISH_DNTG]          = true, --28-大闹天宫
    [FishKind.FISH_PIECE]         = true, --31-金玉满堂
}
yl.setDefault(FishPaoView.SOUND_OF_FISH, false)

function FishPaoView:playFishSound(_fishKind)
    if FishPaoView.SOUND_OF_FISH[_fishKind] then
        local strPath = FishRes.SOUND_OF_FISH[_fishKind]
        ExternalFun.playGameEffect(strPath)
    end
end 

function FishPaoView:createLockEffect(nSeatIndex, lock_fish_id)
    if lock_fish_id == -1 then
        return
    end
    local fish = FishDataMgr:getInstance():getFishByID(lock_fish_id)
    if fish == nil then
        return
    end

    -- 创建呗锁定鱼的鱼身上的锁定动画
    local pArm = fish:getChildByTag( 575 + nSeatIndex )
    if pArm ~= nil then
        pArm:removeFromParent()
    end
    local armature = ccs.Armature:create("suoding_buyu")
    armature:getAnimation():play("Animation1")
    armature:setTag(575 + nSeatIndex)
    fish:addChild(armature, 20 + 8)

    local pNode = self.m_arrNodeLockLine[nSeatIndex]
    if pNode == nil then
        -- 创建连线  
        pNode = display.newNode()
        for i = 1, self.m_nPointCount do
            local point = display.newSprite("#fish-lock-dian.png")
            point:setPosition(cc.p(self.m_nPointOffest + i * self.m_nPointDisatnce, 0))
            point:setVisible(false)
            point:setScale(0.55)
            point:setTag(i)
            pNode:addChild(point)
        end
        pNode:setAnchorPoint(cc.p(0, 0))
        self.m_pathUI:addChild(pNode, 20 + 5)
        self.m_arrNodeLockLine[nSeatIndex] = pNode        
    end
    if pNode ~= nil then
        pNode:setVisible( true )
        local targetX,targetY = fish.lastposX, fish.lastposY   
        local begin = self.m_arrPaoPos[nSeatIndex]     
        local angle = MathAide:CalcAngle(targetX, 750 - targetY, begin.x, 750 - begin.y)
        local distance = math.abs(cc.pGetDistance(begin, cc.p(targetX,targetY))) - self.m_nPointOffest

        local point_count = math.floor(distance / self.m_nPointDisatnce)
        for i = 1, self.m_nPointCount do
            local show = i < point_count
            local point = pNode:getChildByTag(i)
            if point then
                point:setVisible(show)
            end
        end
        self.m_arrLockPointNum[nSeatIndex] = point_count

        pNode:setPosition(begin)        
        pNode:setRotation(math.radian2angle(angle) + 270)
    end
    -- 锁定图标
    self:updateLockIcon(nSeatIndex, lock_fish_id)
end 

function FishPaoView:deleteLockEffect(nSeatIndex, old_lock_fish)
    if self.m_arrNodeLockLine[nSeatIndex] ~= nil then    
        self.m_arrNodeLockLine[nSeatIndex]:setVisible( false )
    end
    self.m_arrLockPointNum[nSeatIndex] = 0
    -- del arm
    local pFish = FishDataMgr:getInstance():getFishByID(old_lock_fish)
    if pFish ~= nil then
        local pArm = pFish:getChildByTag(575+nSeatIndex)
        if pArm ~= nil then
            pArm:removeFromParent()
        end
    end

    if self.m_pPaoNode[nSeatIndex] ~= nil then
        if self.m_pPaoNode[nSeatIndex]:getChildByTag(10000) ~= nil then
            self.m_pPaoNode[nSeatIndex]:removeChildByTag(10000)
        end
    end
end 

function FishPaoView:udpateLockEffect()

    for i = 0, GAME_PLAYER_FISH-1 do
        local fish_id = FishDataMgr:getInstance():getLockFish(i)
        local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(i)
        self:udpateLockEffectParam(viewChairID+1, fish_id, i)
        self:updatePaoAngel(viewChairID+1, fish_id, i)
        --self:updateLockIcon(viewChairID, fish_id)
    end
end 

function FishPaoView:updatePaoAngel(nSeatIndex, lock_fish_id, nChairID)
    if nChairID == FishDataMgr:getInstance():getMeChairID() then return end
    -- 校正炮的朝向
    local begin = self.m_arrPaoPos[nSeatIndex]
    local pFish = nil
    if lock_fish_id ~= -1 then
        pFish = FishDataMgr:getInstance():getFishByID(lock_fish_id)
        local angle = 0
        if pFish ~= nil then
            local positionX,positionY = pFish.lastposX, pFish.lastposY
            angle = MathAide:CalcAngle(positionX, 750 - positionY, begin.x, 750 - begin.y)
        end

        if self.m_arrPaoArmature[nSeatIndex] then
            self.m_arrPaoArmature[nSeatIndex]:rotatePao(math.radian2angle(angle))
        end
    end
end

function FishPaoView:updateLockIcon(nSeatIndex, lock_fish_id)

    if self.m_pPaoNode[nSeatIndex] == nil then
        return
    end

--    if self.m_pPaoNode[nSeatIndex]:getChildByTag(10000) ~= nil then
--        self.m_pPaoNode[nSeatIndex]:removeChildByTag(10000)
--    end

    local fish = FishDataMgr:getInstance():getFishByID(lock_fish_id)
    if fish then

        local strIcon = ""
        if fish:getFishKind() == FishKind.FISH_BGLU then
            strIcon = string.format("skill-lock-%d-%d.png", fish:getFishKind(), fish:getFishTag())
        else
            strIcon = string.format("skill-lock-%d.png", fish:getFishKind())
        end
        if #strIcon == 0 then
            return
        end
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(strIcon)
        if frame then
            local pIcon = display.newSprite("#" .. strIcon)
            if pIcon ~= nil then
                local myViewChairID = FishDataMgr:getInstance():SwitchViewChairID(FishDataMgr:getInstance():getMeChairID())
                local isPlayer = (myViewChairID+1 == nSeatIndex)
                local isSeatUp = nSeatIndex > 2 --1/2下-3/4上
                local x = isSeatUp and 365 or (isPlayer and -100 or -20)
                local y = isSeatUp and -70 or 130
                pIcon:setPosition(cc.p(x, y))
                pIcon:setTag(10000)
                pIcon:addTo(self.m_pPaoNode[nSeatIndex])
            end
        end
    end
end 

function FishPaoView:udpateLockEffectParam(nSeatIndex, lock_fish_id, nChairID)

    local fish = FishDataMgr:getInstance():getFishByID(lock_fish_id)
    if fish ~= nil and FishDataMgr:getInstance():checkFishLock(lock_fish_id) then

        local pNode = self.m_arrNodeLockLine[nSeatIndex]
        if pNode == nil then

            return
        end

        if self.m_arrPaoArmature[nSeatIndex] == nil then

            -- 如果有原来的资源。
            self:deleteLockEffect(nSeatIndex, lock_fish_id)
            FishDataMgr:getInstance():setLockFish(nChairID, -1)
            print("－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－被删除")
            return
        end

        local targetX,targetY = fish.lastposX, fish.lastposY
        local begin = self.m_arrPaoPos[nSeatIndex]
        local angle = MathAide:CalcAngle(targetX, 750 - targetY, begin.x, 750 - begin.y)
        local distance = math.abs(cc.pGetDistance(begin, cc.p(targetX,targetY))) - self.m_nPointOffest
        pNode:setRotation(math.radian2angle(angle) + 270)
        local point_count = math.ceil( distance / self.m_nPointDisatnce )
        
        if point_count ~= self.m_arrLockPointNum[nSeatIndex] then
            self.m_arrLockPointNum[nSeatIndex] = point_count
            for i = 1, self.m_nPointCount do
                local show = i < point_count
                local point = pNode:getChildByTag(i)
                if point then
                    point:setVisible(show)
                end
            end
        end
    else
        -- 如果有原来的资源。
        if lock_fish_id ~= -1 then
            if self.m_arrNodeLockLine[nSeatIndex] ~= nil then
                self.m_arrNodeLockLine[nSeatIndex]:setVisible( false )
            end
            self.m_arrLockPointNum[nSeatIndex] = 0

            if self.m_pPaoNode[nSeatIndex] ~= nil then
                if self.m_pPaoNode[nSeatIndex]:getChildByTag(10000) ~= nil then
                    self.m_pPaoNode[nSeatIndex]:removeChildByTag(10000)
                end
            end

            FishDataMgr:getInstance():setLockFish(nChairID, -1)
        end
    end
end 

function FishPaoView:setAutoFire(nAutoFire)
    self.m_nAutoFire = nAutoFire
end
    
function FishPaoView:getAutoFire()
    return self.m_nAutoFire
end  


function FishPaoView:setLockFish(nLockFish)
    self.m_nLockFish = nLockFish
end
    
function FishPaoView:getLockFish()
    return self.m_nLockFish
end 

function FishPaoView:setReturnAuto(nReturnAuto)
    self.m_nReturnAuto = nReturnAuto
end
    
function FishPaoView:getReturnAuto()
    return self.m_nReturnAuto
end 

function FishPaoView:PrintData()
   DataCacheMgr:getInstance():PrintData()
   print("FishDataMgr:m_vecFish:" .. table.nums(FishDataMgr:getInstance().m_vecFish) )
    print("FishPaoView:m_vecFishBullet:" .. table.nums( self.m_vecFishBullet) )
    print("FishPaoView:m_vecMyTempFishBullet:" .. table.nums( self.m_vecMyTempFishBullet) )
    print("FishPaoView:m_vecFishArray:" .. table.nums( self.m_vecFishArray) )
    

    local vecNodes = self.m_pathUI:getChildren()
    print("self.m_pathUI:getChildren: " .. table.nums(vecNodes) )
end

function FishPaoView:setBg(bg, bgUp)
    self.m_pBg = bg
    self.m_pNewBG = bgUp
end

--function FishPaoView:otherPaoMove(guid, pos)
--    local chairid = FishDataMgr:getInstance():getChairIDByGuid(guid)
--    if chairid~=INVALID_CHAIR then
--       local viewChairID = FishDataMgr:getInstance():SwitchViewChairID(chairid)
--       local paoPosX,paoPosY = self.m_arrPaoArmature[viewChairID+1]:getPosition()
--       local angle = MathAide:CalcAngle(pos.x, 750 - pos.y, paoPosX, 750 - paoPosY)
--       FishDataMgr:getInstance():setlastangle(guid,angle)
--    end
--end

return FishPaoView

-- endregion
