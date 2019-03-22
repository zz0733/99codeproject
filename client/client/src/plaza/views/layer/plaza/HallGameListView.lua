--region HallGameListView.lua
--Date 2017/04/05
--此文件由[BabeLua]插件自动生成

-- modified by JackyXu on 2017.04.21.
-- Desc: 游戏类型玩法场列表(二级页面)

local HallGameListView = class("HallGameListView", cc.Node)
local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")

local CommonGoldView = appdf.req(appdf.CLIENT_SRC .. "plaza.views.layer.plaza.CommonGoldView") --通用金币框
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local MultiUpdater = appdf.req(appdf.EXTERNAL_SRC.."MultiUpdater")
local MultiUpdaterZip = appdf.req(appdf.EXTERNAL_SRC.."MultiUpdaterZip")

local G_StrTitleImagePath = {
    [yl.GameClassifyType.GAME_CLASSIFY_FISH]   = "gui-room-title1.png",   -- 捕鱼合集
    [yl.GameClassifyType.GAME_CLASSIFY_CARD]   = "gui-room-title2.png",   -- 对战
    [yl.GameClassifyType.GAME_CLASSIFY_ARCADE] = "gui-room-title3.png",   -- 多人
    [yl.GameClassifyType.GAME_CLASSIFY_TIGER]  = "gui-room-title4.png",   -- 单机(没有图)
}


local SIZE_VIEW = 4.5              --1屏4.5个
local TABLE_OFFEST = 135             --左偏移
local SHOW_WIDTH = 1334 - 230

function HallGameListView:ctor(scene)
    self:enableNodeEvents()
    self._scene = scene
    --var
    self.m_rootUI = nil
    self.m_pBtnLeftArrow = nil
    self.m_pBtnRightArrow = nil
    self.m_pNodeGameList = nil

    self.m_root_lv = nil
    self.m_lv_items = {}
    self.room_list_data = {}
    self.m_pEnterAction = nil

    self.m_pBtnLeftArrow = nil
    self.m_pBtnRightArrow = nil
    
    self.m_pDownloadItem = {}

    self.m_bIsShowArrow = false
    self.m_listHeight = 0
    self.m_listWidth = 0
    self.m_listMaxWidth = 0
    self.m_ItemWidth = 0
    
    self.m_listMaxWidth = 1334
    
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)

    --init csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/HallListView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    self.m_pathUI:setPositionY((display.height - 750) / 2)

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("HallListView")
    self.m_pNodeRootUI  = self.m_pNodeRoot:getChildByName("node_rootUI")
    self.m_pNodeRootUI:setPositionX((display.width - 1334) / 2)

    self.m_pNodeTop          = self.m_pNodeRootUI:getChildByName("node_top")
    self.m_pImgListBg        = self.m_pNodeRootUI:getChildByName("IMG_listBg")
    self.m_pBtnBack          = self.m_pNodeTop:getChildByName("BTN_back")
    self.m_pIMG_title        = self.m_pNodeTop:getChildByName("IMG_title")
    self.m_pNodeCommonGold   = self.m_pNodeTop:getChildByName("node_commonGold")

    local commonGold = CommonGoldView:create("HallGameListView")
    self.m_pNodeCommonGold:addChild(commonGold)
    self.m_pBtnBack:addClickEventListener(handler(self, self.onCloseBtnClick))

    --游戏列表
    self.m_root_lv = ccui.ListView:create()
    self.m_root_lv:addTo(self.m_pNodeRootUI)
    self.m_root_lv:setAnchorPoint(0.5, 0.5)
    self.m_root_lv:setPosition(667, 360)
    self:createArrow()
end

function HallGameListView:init(nGameType)

    --游戏title
    if G_StrTitleImagePath[nGameType] then
        self.m_pIMG_title:setSpriteFrame(G_StrTitleImagePath[nGameType])
    end

    self.room_list_data = self._scene:getApp()._gameList[nGameType]
    self:initRoomList()
end

function HallGameListView:showTopBar()
    if self.m_pEnterAction then
        self.m_pathUI:stopAction(self.m_pEnterAction)
    end
    self.m_pEnterAction = cc.CSLoader:createTimeline("hall/csb/HallListView.csb")
    self.m_pathUI:runAction(self.m_pEnterAction)
    self.m_pEnterAction:gotoFrameAndPlay(0, 50, false)
    self.m_pEnterAction = nil
end

function HallGameListView:hideTopBar()
    if not self.m_pNodeTop then return end
    self.m_pNodeTop:setVisible(false)
end

function HallGameListView:createArrow()

    local pBkgImg = cc.Sprite:createWithSpriteFrameName("gui-room-arrow.png")
    local pNormalSprite = cc.Scale9Sprite:createWithSpriteFrame(pBkgImg:getSpriteFrame())
    local pClickSprite = cc.Scale9Sprite:createWithSpriteFrame(pBkgImg:getSpriteFrame())
    self.m_pBtnLeftArrow = cc.ControlButton:create(pNormalSprite)
    self.m_pBtnLeftArrow:setBackgroundSpriteForState(pClickSprite,cc.CONTROL_STATE_HIGH_LIGHTED)
    self.m_pBtnLeftArrow:addTo(self.m_pNodeRootUI)
    self.m_pBtnLeftArrow:setAnchorPoint(cc.p(0,0.5))
    self.m_pBtnLeftArrow:setPosition(cc.p(70,375))
    self.m_pBtnLeftArrow:setRotation(180)
    local seq = cc.Sequence:create(cc.MoveBy:create(0.4, cc.p(-8,0)),cc.MoveBy:create(0.4, cc.p(8,0)))
    self.m_pBtnLeftArrow:runAction(cc.RepeatForever:create(seq))
    self.m_pBtnLeftArrow:registerControlEventHandler(handler(self, self.onLeftArrowClicked), cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE);
  
    local pNormalSprite2 = cc.Scale9Sprite:createWithSpriteFrame(pBkgImg:getSpriteFrame())
    local pClickSprite2 = cc.Scale9Sprite:createWithSpriteFrame(pBkgImg:getSpriteFrame())
    self.m_pBtnRightArrow = cc.ControlButton:create(pNormalSprite2)
    self.m_pBtnRightArrow:setBackgroundSpriteForState(pClickSprite2,cc.CONTROL_STATE_HIGH_LIGHTED)
    self.m_pBtnRightArrow:addTo(self.m_pNodeRootUI)
    self.m_pBtnRightArrow:setAnchorPoint(cc.p(0,0.5))
    self.m_pBtnRightArrow:setPosition(cc.p(1270,375))
    local seq2 = cc.Sequence:create(cc.MoveBy:create(0.4, cc.p(8,0)),cc.MoveBy:create(0.4, cc.p(-8,0)))
    self.m_pBtnRightArrow:runAction(cc.RepeatForever:create(seq2))
    self.m_pBtnRightArrow:registerControlEventHandler(handler(self, self.onRightArrowClicked), cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
   
    self.m_pBtnLeftArrow:setVisible(false)
    self.m_pBtnRightArrow:setVisible(false)
end

function HallGameListView:onLeftArrowClicked(pSender)
    ExternalFun.playClickEffect()
    self.m_root_lv:scrollToPercentHorizontal(0, 0.5, true)
end

function HallGameListView:onRightArrowClicked(pSender)
    ExternalFun.playClickEffect()
    self.m_root_lv:scrollToPercentHorizontal(100, 0.5, true)
end

function HallGameListView:onScrollEvent(sender, _event)
    -- print("_event:", _event)
    if not self.m_bIsShowArrow then
        return
    end
    if not self.m_pBtnLeftArrow or not self.m_pBtnRightArrow then
        return
    end

    -- 设置箭头显示
    local pos = sender:getInnerContainerPosition()
    if pos.x <= self.m_root_lv:getContentSize().width - self.m_listMaxWidth then
        self.m_pBtnLeftArrow:setVisible(true)
        self.m_pBtnRightArrow:setVisible(false)
    elseif pos.x == 0 then
        self.m_pBtnLeftArrow:setVisible(false)
        self.m_pBtnRightArrow:setVisible(true)
    end
end

function HallGameListView:initRoomList()
    
    for i in pairs(self.m_lv_items) do
        self.m_lv_items[i]:removeFromParent()
        self.m_lv_items[i] = nil
    end
    self.m_root_lv:removeAllItems()
    self.m_lv_items = {}
    self:reload()
end

function HallGameListView:reload()
    
    self.m_bIsShowArrow = false     -- 默认没有箭头
    self.m_pBtnLeftArrow:setVisible(false)
    self.m_pBtnRightArrow:setVisible(false)

    -- 滑动区域大小
    local scrollViewSize = cc.size(display.width, 450) 
    local btnSize = cc.size(1334/4, 450) -- 按纽大小 
    local maxWidth = 0

    -- 各游戏入口按纽
    for index = 1, #self.room_list_data do
        
        local _btnNode = ccui.Layout:create()
        local size, pos = self:initBtnSize()

        if size then
            _btnNode:setContentSize(size)
            maxWidth = maxWidth + size.width
        else
            _btnNode:setContentSize(btnSize)
            maxWidth = maxWidth + btnSize.width
        end
        self.m_lv_items[index] = _btnNode
        self.m_root_lv:pushBackCustomItem(_btnNode)

        --逐个显示
        local hide = cc.Hide:create()
        local delay = cc.DelayTime:create((index - 1) * 0.09)
        local call = cc.CallFunc:create(function()
            self:initBtnView(_btnNode, index, size, pos)
            -- add by JackyXu on 2018.01.18.
            if index == #self.room_list_data then -- 列表加载完成
                if self.m_bIsShowArrow then
                    self.m_pBtnLeftArrow:setVisible(false)
                    self.m_pBtnRightArrow:setVisible(true)
                else
                    self.m_pBtnLeftArrow:setVisible(false)
                    self.m_pBtnRightArrow:setVisible(false)
                end
            end
        end)
        local show = cc.Show:create()
        local scale1 = cc.EaseIn:create(cc.ScaleTo:create(0.18, 1.1), 0.4)
        local scale2 = cc.EaseBackOut:create(cc.ScaleTo:create(0.09, 1.0))
        local seq = cc.Sequence:create(hide, delay, call, show, scale1, scale2)
        _btnNode:setScale(0.5)
        _btnNode:runAction(seq)
    end

    if maxWidth < scrollViewSize.width then
        maxWidth = scrollViewSize.width
    end

    if maxWidth > display.width then
        self.m_listMaxWidth = maxWidth
    end

    self.m_root_lv:addScrollViewEventListener(handler(self, self.onScrollEvent))
    self.m_root_lv:setContentSize(scrollViewSize)
    self.m_root_lv:setInertiaScrollEnabled(true)
    self.m_root_lv:jumpToPercentHorizontal(0)
    self.m_root_lv:setGravity(0)
    self.m_root_lv:setBounceEnabled(true)--回弹
    self.m_root_lv:setDirection(ccui.ScrollViewDir.horizontal)--水平方向
    self.m_root_lv:setScrollBarEnabled(false)-- 隐藏滚动条
    self.m_root_lv:setItemsMargin(0.0)
end

function HallGameListView:initBtnSize()

    local size = cc.size(0, 0)
    local pos = cc.p(0, 0)

    size = cc.size(1334/4, 370)
    pos = cc.p(size.width/2, 0)

    return size, pos
end

function HallGameListView:initBtnView(_btnNode, index, size, pos)

    --动画
    local gameinfor = self.room_list_data[index]
    local animName = gameinfor.strAnimationName
    local jsonName = gameinfor.strAnimationPath

    --入口动画
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(jsonName)
    local pArmature = ccs.Armature:create(animName)
    if pArmature then
        pArmature:getAnimation():play("Animation1", -1, 1)
        pArmature:setAnchorPoint(cc.p(0.5, 0))
        pArmature:setPosition(pos)
        pArmature:addTo(_btnNode, 1)
    end

    -- 检查下载/更新
    local nKindID = tonumber(gameinfor._KindID)
    local version = tonumber(self._scene:getApp():getVersionMgr():getResVersion(nKindID))
    local pDownloadPos = cc.pAdd(pos, cc.p(0, 10))
    if not version then
        -- 下载
        local tipbg = cc.Sprite:createWithSpriteFrameName("image-download-logo-install.png")
        tipbg:setPosition(pDownloadPos)
        tipbg:setName(gameinfor._KindID .. "_sp_tipbg")
        tipbg:setZOrder(10000)
        _btnNode:addChild(tipbg)
    elseif gameinfor._ServerResVersion > version then
        -- 更新
        local tipbg = cc.Sprite:createWithSpriteFrameName("image-download-logo-update.png")
        tipbg:setPosition(pDownloadPos)
        tipbg:setName(gameinfor._KindID .. "_sp_tipbg")
        tipbg:setZOrder(10000)
        _btnNode:addChild(tipbg)
    end

    --点击响应
    _btnNode:setVisible(false)
    _btnNode:setName(gameinfor._KindID .. "_icon")
    _btnNode:setTouchEnabled(true)
    _btnNode:addClickEventListener(function()
        self:TouchListItem(_btnNode, gameinfor)
    end)

    --游戏logo
    local pLogo = self:getGameLogo(gameinfor)
    if pLogo then
        pLogo:setPosition(80, size.height - 100)
        pLogo:addTo(_btnNode, 3)
    end

     -- 判断是否有下载
    for k,v in pairs(GlobalUserItem.tabUpdater) do
        if gameinfor._KindID == k then
            self:addDownloadInfo(_btnNode, k)
        end
        v._listener = self
    end
end

function HallGameListView:getGameLogo(gameinfor)
    
    local info = gameinfor
    if info.dwStatus > 0 then

        local pNode = cc.Node:create()
        
        local pLogo = nil
        if info.dwStatus == 1 then
            pLogo = cc.Sprite:createWithSpriteFrameName("gui-logo-new.png")
        elseif info.dwStatus == 2 then
            pLogo = cc.Sprite:createWithSpriteFrameName("gui-logo-hot.png")
        else
            pLogo = cc.Sprite:createWithSpriteFrameName("gui-logo-new.png")
        end
    
        if pLogo then
            pLogo:setAnchorPoint(0.5, 0.5)
            pLogo:setPosition(0, 0)
            pLogo:addTo(pNode)
        end

        if pLogo then
            local manager = ccs.ArmatureDataManager:getInstance()
            manager:addArmatureFileInfo("hall/effect/shaoguangAnimation/shaoguangAnimation.ExportJson")    
            local pArmature = ccs.Armature:create("shaoguangAnimation")
            if pArmature then
                pArmature:getAnimation():play("Animation1", -1, 1)
                pArmature:setAnchorPoint(0.5, 0.5)
                pArmature:setPosition(0, 0)
                pArmature:setScale(2.1)
                pArmature:addTo(pNode)
            end
        end
        return pNode
    end
    return nil
end

function HallGameListView:TouchListItem(ref, gameinfor)
    ExternalFun.playClickEffect()

    local config = gameinfor
    if type(config) ~= "table" then
        print("参数非法")
        return
    end
    --下载/更新资源 clientscene:getApp
    local app = self._scene:getApp()
    local nKindID = tonumber(config._KindID)
    local version = tonumber(app:getVersionMgr():getResVersion(nKindID))
    if not version or config._ServerResVersion > version then
        -- 判断是否更新
        if nil ~= GlobalUserItem.tabUpdater[config._KindID] then
            print("GameListLayer:onGameIconClickEvent 正在更新 ", config._GameName)
            return
        end
        self:addDownloadInfo(ref, nKindID)
        self:updateGame(config)
    else
        self:onEnterGame(config)
    end
end

-- 游戏动画
function HallGameListView:getGameAnimation()

end

-- 返回按钮
function HallGameListView:onCloseBtnClick()
    ExternalFun.playClickEffect()

    --返回1级界面，游戏分类
    local _event = {
        name = Hall_Events.MSG_GAME_QUIT_RECOMMEND,
        packet = {},
    }
    SLFacade:dispatchCustomEvent(Hall_Events.ROOMLIST_BACK_TO_GAMELIST,_event)

end

function HallGameListView:onEnterGame( gameinfo )
    local nKindID = tonumber(gameinfo._KindID)
    GlobalUserItem.nCurGameKind = nKindID
    self._scene:updateEnterGameInfo(gameinfo)
    -- 统一处理:进入游戏房间
    local _event = {
        name = Hall_Events.GAMELIST_CLICKED_GAME,
        packet = {nKindId = nKindID},
    }
    SLFacade:dispatchCustomEvent(Hall_Events.GAMELIST_CLICKED_GAME,_event)
end

-- 增加下载信息
function HallGameListView:addDownloadInfo( ref, nKindID )
    -- 校验
    if nil == ref or nil == nKindID then
        return
    end
    ref:removeChildByName(nKindID .. "_sp_tipbg")

    -- 底图
    local tipbg = cc.Sprite:createWithSpriteFrameName("image-download-res-bg.png")
    tipbg:setName(nKindID .. "_sp_tipbg")
    tipbg:setPosition(166.75,10)
    tipbg:setZOrder(10000)
    ref:addChild(tipbg)

    -- 进度
    local bar_tips = cc.Label:createWithTTF("0%", "fonts/round_body.ttf", 20)
    ref:addChild(bar_tips, 1)
    bar_tips:setName(nKindID .. "_bar_tips")
    bar_tips:setZOrder(10000)
    bar_tips:setPosition(tipbg:getPosition())
end


-- 增加下载信息
function HallGameListView:addOutDownloadInfo( ref, nKindID )
    -- 校验
    if nil == ref or nil == nKindID then
        return
    end

    self.m_pDownloadItem[tostring(nKindID)] = ref

    ref:removeChildByName(nKindID .. "_sp_tipbg")

    -- 底图
    local tipbg = cc.Sprite:createWithSpriteFrameName("image-download-res-bg.png")
    tipbg:setName(nKindID .. "_sp_tipbg")
    tipbg:setPosition(166.75,10)
    tipbg:setZOrder(10000)
    ref:addChild(tipbg)

    -- 进度
    local bar_tips = cc.Label:createWithTTF("0%", "fonts/round_body.ttf", 20)
    ref:addChild(bar_tips, 1)
    bar_tips:setName(nKindID .. "_bar_tips")
    bar_tips:setZOrder(10000)
    bar_tips:setPosition(tipbg:getPosition())
end

-- 移除下载信息
function HallGameListView:removeDownloadInfo( nKindID )
    if nil == nKindID then
        return
    end
    -- 进度信息
    -- icon
    local icon = self.m_root_lv:getChildByName(nKindID .. "_icon") or self.m_pDownloadItem[tostring(nKindID)]
    if nil ~= icon then
        -- 背景
        icon:removeChildByName(nKindID .. "_sp_tipbg")
        -- 提示
        icon:removeChildByName(nKindID .. "_bar_tips")
    end
end

function HallGameListView:updateGame( gameinfo )
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_WINDOWS == targetPlatform and yl.DISABLE_WIN_UPDATE then
        print("GameListLayer win32 跳过更新")
        -- 移除信息
        self:removeDownloadInfo(gameinfo._KindID)

        local app = self._scene:getApp()
        --更新版本号
        app:getVersionMgr():setResVersion(gameinfo._ServerResVersion, gameinfo._KindID)
        self:onEnterGame(gameinfo)
    else
        self:onGameUpdate(gameinfo)
    end
end

--更新游戏
function HallGameListView:onGameUpdate(gameinfo)
    if not gameinfo then
        showToast(self,"游戏版本信息错误！",1)
        return
    end
    local update = GlobalUserItem.tabUpdater[gameinfo._KindID]
    --失败重试
    if update ~= nil then
        update:UpdateFile()
        return 
    end

    --下载/更新资源 clientscene:getApp
    local app = self._scene:getApp()
    local nKindID = tonumber(gameinfo._KindID)
    local version = tonumber(app:getVersionMgr():getResVersion(nKindID))

    if  not version then
        --更新参数
        local fileurl = self._scene:getApp()._updateUrl .. "/game/" .. string.sub(gameinfo._Module, 1, -2) .. ".zip"
        --文件名
        local pos = string.find(gameinfo._Module, "/")
        local savename = string.sub(gameinfo._Module, pos + 1, -2) .. ".zip"
        --保存路径
        local savepath = nil
        local unzippath = nil
	    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	    if cc.PLATFORM_OS_WINDOWS == targetPlatform then
		    savepath = device.writablePath .. "download/game/" .. gameinfo._Type .. "/"
            unzippath = device.writablePath .. "download/game/" .. gameinfo._Type .. "/"
        else
            savepath = device.writablePath .. "game/" .. gameinfo._Type .. "/"
            unzippath = device.writablePath .. "game/" .. gameinfo._Type .. "/"
	    end

        --创建更新
        updateZip = MultiUpdaterZip:create(fileurl,savename,savepath,unzippath)
        updateZip:upDateClient(self._scene:getApp(), self, gameinfo)
        GlobalUserItem.tabUpdater[gameinfo._KindID] = updateZip
    else 
         --更新参数
        local newfileurl = self._scene:getApp()._updateUrl.."/game/" .. gameinfo._Module .. "res/filemd5List.json"
        local dst = device.writablePath .. "game/" .. gameinfo._Type .. "/"
        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
        if cc.PLATFORM_OS_WINDOWS == targetPlatform then
            dst = device.writablePath .. "download/game/" .. gameinfo._Type .. "/"
        end
    
        local src = device.writablePath.."game/" .. gameinfo._Module .. "res/filemd5List.json"
        local downurl = self._scene:getApp()._updateUrl .. "/game/" .. gameinfo._Type .. "/"

        --创建更新
        update = MultiUpdater:create(newfileurl,dst,src,downurl)
        update:upDateClient(self._scene:getApp(), self, gameinfo)
        GlobalUserItem.tabUpdater[gameinfo._KindID] = update
    end
end

function HallGameListView:onUpdataNotify()
    showToast(self,"游戏版本信息错误！",1)
end

--更新进度
function HallGameListView:updateProgress(updateinfo, sub, msg, mainpersent)
    if type(updateinfo) ~= "table" or nil == updateinfo._KindID then
        return
    end
    -- 进度信息
    local icon = self.m_root_lv:getChildByName(updateinfo._KindID .. "_icon")  or self.m_pDownloadItem[tostring(updateinfo._KindID)]
    if nil ~= icon then
        -- 进度文字
        local tips = icon:getChildByName(updateinfo._KindID .. "_bar_tips")
        if nil ~= tips then
            tips:setString(string.format("%d%%", mainpersent))
        end
    end
end

--更新结果
function HallGameListView:ZipResult(updateinfo, result, msg)
    if type(updateinfo) ~= "table" or nil == updateinfo._KindID then
        return
    end
     -- 进度信息
    local icon = self.m_root_lv:getChildByName(updateinfo._KindID .. "_icon")  or self.m_pDownloadItem[tostring(updateinfo._KindID)]
    local tips = icon:getChildByName(updateinfo._KindID .. "_bar_tips")
    if nil ~= icon then
        -- 进度文字
        local tips = icon:getChildByName(updateinfo._KindID .. "_bar_tips")
        if nil ~= tips then
            tips:setString(msg)
        end
    end

    if result == 0 then     --解压失败
        local runScene = cc.Director:getInstance():getRunningScene()
        if nil ~= runScene then
            self._query = QueryDialog:create(msg.."\n是否重试？",function(bReTry)
                if bReTry == true then
                    local ref = self.m_root_lv:getChildByName(updateinfo._KindID .. "_icon") or self.m_pDownloadItem[tostring(updateinfo._KindID)]
                    if nil ~= ref then
                        self:addDownloadInfo(ref, updateinfo._KindID)
                    end
                    self:onGameUpdate(updateinfo)
                end
                self._query = nil
            end)
            :addTo(runScene)
        end 
    end
end
--更新结果
function HallGameListView:updateResult(updateinfo, result, msg)
    if type(updateinfo) ~= "table" or nil == updateinfo._KindID then
        return
    end
    if nil ~= self._query then
        self._query:removeFromParent() 
    end
    -- 移除信息
    self:removeDownloadInfo(updateinfo._KindID)
    -- 清理下载管理
    GlobalUserItem.tabUpdater[updateinfo._KindID] = nil

    if result == true then
        local app = self._scene:getApp()

        for i = 1, #self._scene:getApp()._gameList do
            local itemdatas = self._scene:getApp()._gameList[i]
            -- 更新版本号
            for k,v in pairs(itemdatas) do
                if v._KindID == updateinfo._KindID then
                    app:getVersionMgr():setResVersion(v._ServerResVersion, v._KindID)
                    v._Active = true
                    self.m_pDownloadItem[tostring(updateinfo._KindID)] = nil
                    break
                end
            end
        end
        --self:onEnterGame(updateinfo)  --下载完毕暂不进入房间
        
    else
        local runScene = cc.Director:getInstance():getRunningScene()
        if nil ~= runScene then
            self._query = QueryDialog:create(msg.."\n是否重试？",function(bReTry)
                if bReTry == true then
                    local ref = self.m_root_lv:getChildByName(updateinfo._KindID .. "_icon") or self.m_pDownloadItem[tostring(updateinfo._KindID)]
                    if nil ~= ref then
                        self:addDownloadInfo(ref, updateinfo._KindID)
                    end
                    self:onGameUpdate(updateinfo)
                end
                self._query = nil
            end)
            :addTo(runScene)
        end     
    end
end

return HallGameListView
