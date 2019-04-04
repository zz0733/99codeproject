--region HallGameListView.lua
--Date 2017/04/05
--此文件由[BabeLua]插件自动生成

-- modified by JackyXu on 2017.04.21.
-- Desc: 游戏类型玩法场列表(二级页面)

local HallGameListView = class("HallGameListView", cc.Node)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local DownLoadResView = appdf.req(appdf.PLAZA_VIEW_SRC.."DownLoadResView")
local MultiUpdater = appdf.req(appdf.EXTERNAL_SRC.."MultiUpdater")
local MultiUpdaterZip = appdf.req(appdf.EXTERNAL_SRC.."MultiUpdaterZip")
local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
--local DownloadResMgr = require("common.manager.DownloadResMgr")

--local CGameClassifyDataMgr  = require("common.manager.CGameClassifyDataMgr")
local GameListManager       = appdf.req(appdf.PLAZA_VIEW_SRC.."bean.GameListManager")

function HallGameListView:ctor(parent,scene)
    self:enableNodeEvents()

    self._scene = scene

    self.m_pParent = parent

    self.m_root_lv = nil
    self.m_lv_items = {}
    self.room_list_data = {}
   
    self.m_listMaxWidth = 1334
    
    --游戏列表
    self.m_root_lv = ccui.ListView:create()
    self.m_root_lv:addTo(self)
    self.m_root_lv:setAnchorPoint(0, 0)
    self.m_root_lv:setPosition(0, 0)
end

function HallGameListView:init(nGameType, showClassify)
    if nGameType then
        self.room_list_data = self._scene:getApp()._gameList[nGameType]
    end
    local room_list_data = self.room_list_data
    local listnum = table.nums( self.m_lv_items )
    if listnum == 0 then
        self:initRoomList( true, showClassify )
    else 
        -- 如果之前有显示列表，先做该列表的渐隐效果
        for i in pairs(self.m_lv_items) do
            local itemNode = self.m_lv_items[i]
            if itemNode ~= nil then
                local actionTime = 0.2
                
                local downloadNode = itemNode:getChildByTag(101)
                if downloadNode then
                    downloadNode:runAction( cc.FadeTo:create(actionTime, 0) )
                    downloadNode.m_pImageTimer:runAction( cc.FadeTo:create(actionTime, 0) )
                    downloadNode.m_pProgressTimer:runAction( cc.FadeTo:create(actionTime, 0) )
                end

                local logoNode = itemNode:getChildByTag(102)
                if logoNode then
                    logoNode:runAction( cc.FadeOut:create(actionTime) )
                end

                local saoguangNode = itemNode:getChildByTag(103)
                if saoguangNode then
                    saoguangNode:runAction( cc.FadeOut:create(actionTime) )
                end
   
                local norsp = itemNode:getRendererNormal()
                if norsp then
                    norsp:runAction( cc.FadeOut:create(actionTime) )
                end
            end
        end
        local callback = cc.CallFunc:create(function ()
            self:initRoomList( true, showClassify )
        end)
        local seqNode = cc.Sequence:create(cc.DelayTime:create(0.22), callback)
        self:runAction( seqNode )
    end 
end

function HallGameListView:PlayAnimationBackToHall()
    local nStartX = self.m_listMaxWidth + 300 -- 先设置位置在列表显示区域右则
    local scrollPos = self.m_root_lv:getInnerContainerPosition()
    local scrollIndex = math.floor( math.abs(scrollPos.x) / 270 )
    for i in pairs(self.m_lv_items) do
        local posIndex = math.floor((i-1)/2)
        if posIndex >= scrollIndex then            --只有显示出来的列表项后面的，才有这个滑动效果，前面的不做动画只设置位置
            posIndex = posIndex - scrollIndex
            local fDelayTime = 0.1 + posIndex * 0.12
            local fMoveTime =  0.5 + posIndex * 0.2
            local diffX = 20 + posIndex * 3
            local itemNode = self.m_lv_items[i]
            if itemNode ~= nil then
                itemNode:setTouchEnabled(true)    --这里要注意，在渐隐效果里面有设置不可点击，所以这里强制设置可以点击
                local pos = self:GetItemPosByIndex( i )
                itemNode:stopAllActions()
                itemNode:setPositionX(nStartX)
                itemNode:runAction(cc.Sequence:create(
                    cc.DelayTime:create(fDelayTime),
                    cc.Show:create(),
                    cc.EaseIn:create(cc.MoveTo:create(0.2, cc.p(pos.x-diffX,pos.y)), 0.4),
                    cc.EaseBackOut:create(cc.MoveTo:create(fMoveTime, pos))    
                ))
            end
        else 
            local pos = self:GetItemPosByIndex( i )
            if self.m_lv_items[i] then
                self.m_lv_items[i]:setPosition(pos)
            end
        end
    end
end

function HallGameListView:scrollToPercent(percent)
    self.m_root_lv:scrollToPercentHorizontal(percent, 0.5, true)
end

function HallGameListView:onScrollEvent(sender, _event)
    -- 设置箭头显示
    local pos = sender:getInnerContainerPosition()
    if self.m_root_lv:getContentSize().width >= self.m_listMaxWidth - 50 then
        self.m_pParent:refreshArrow(false, false)
    elseif math.floor( pos.x ) <=  math.floor( self.m_root_lv:getContentSize().width - self.m_listMaxWidth ) then
        self.m_pParent:refreshArrow(true, false)
    elseif pos.x >= 0 then
        self.m_pParent:refreshArrow(false, true)
    end
end

function HallGameListView:initRoomList(bAnimation, showClassify)
    
    for i in pairs(self.m_lv_items) do
        self.m_lv_items[i]:removeFromParent()
        self.m_lv_items[i] = nil
    end
    self.m_root_lv:removeAllItems()
    self.m_lv_items = {}
    self:reload(bAnimation, showClassify)
end

-- 根据索引获取对象坐标
function HallGameListView:GetItemPosByIndex( index )
    local startx = 155   -- x轴起始坐标
    local starty = 108   -- y轴起始坐标
    local offx =  math.floor((index-1)/2)*270
    local offy =  0
    if index%2 ~= 0 then
        offy = 230
    end
    return cc.p( startx + offx, starty + offy )
end

-- 获取滑动框的size
function HallGameListView:GetScrollSize(showClassify)
    local scrool_height = 480 
    local sizeX = 340
    if LuaUtils.isIphoneXDesignResolution() then
         sizeX = 430
    end                                              --高度    
    local scrollViewSize = cc.size(display.width-sizeX, scrool_height)        --滑动框范围       
    if showClassify then  -- 减去列表栏的宽度
        scrollViewSize.width = scrollViewSize.width - 110
    end
    return scrollViewSize
end

-- 重置滑动区域大小
function HallGameListView:ReSizeScrollView( showClassify )
    if self.m_root_lv == nil then return end

    local prePosition = self.m_root_lv:getInnerContainerPosition()
    if prePosition.x > 0 then
        prePosition.x = 0  -- 如果切换的时候，向左拖动的位置要及时重置0点，否则左边有空隙
    end
    self.m_root_lv:setContentSize( self:GetScrollSize(showClassify) )
    self.m_root_lv:setInertiaScrollEnabled(true)
    self.m_root_lv:jumpToPercentHorizontal(0)
    self.m_root_lv:setGravity(0)
    self.m_root_lv:setBounceEnabled(true)--回弹
    self.m_root_lv:setDirection(ccui.ScrollViewDir.horizontal)--水平方向
    self.m_root_lv:setScrollBarEnabled(false)-- 隐藏滚动条
    self.m_root_lv:setItemsMargin(0.0)
    self.m_root_lv:setInnerContainerPosition( prePosition )
end

function HallGameListView:reload( bAnimation, showClassify )    
    self.m_pParent:refreshArrow(false, false)

    do --fix 初始化一些删掉的图片资源
        local manager = ccs.ArmatureDataManager:getInstance()
        manager:addArmatureFileInfo("hall/effect/gamekind_effect/gamekind_effect.ExportJson")
        manager:addArmatureFileInfo("hall/effect/shaoguangAnimation/shaoguangAnimation.ExportJson") 
    end     

    local scroll_width = math.ceil((#self.room_list_data) / 2 ) * 270 + 50 --填充内容范围宽度
    local _Node = ccui.Layout:create()  
    _Node:setContentSize(cc.size(scroll_width, 480))
    _Node:setAnchorPoint(0, 0)
    _Node:setPosition(cc.p(0, 0))
    _Node:setName("_Node_layer")    
    self.m_root_lv:pushBackCustomItem(_Node)

    local btnSize = cc.size(260, 214) -- 按纽大小 
    --local maxWidth = scroll_width
    -- 各游戏入口按纽
    for index = 1, #self.room_list_data do
        local stranimation = self:animationTransform(self.room_list_data[index])
        local pos = self:GetItemPosByIndex( index )
        ExternalFun.playUnLoadCSBani(stranimation, "Animation0",_Node, true,pos)
        local _btnNode = ccui.Button:create()
        _btnNode:loadTextureNormal("dt/image/zcmdwc_zjm/gameBtnbg.png", ccui.TextureResType.localType)
        _btnNode:setZoomScale(0)
        _btnNode:setAnchorPoint(0.5, 0.5)
        _btnNode:setPosition( pos )
        _btnNode:addTo(_Node)
        _btnNode:setCascadeOpacityEnabled(true)
        self.m_lv_items[index] = _btnNode 
        self:initBtnView(_btnNode, index, btnSize, cc.p(0,0), fileName, bAnimation)
    end

    local scrollViewSize = self:GetScrollSize(showClassify)
    self.m_listMaxWidth = scroll_width
    self.m_root_lv:addScrollViewEventListener(handler(self, self.onScrollEvent))
    self.m_root_lv:setContentSize(scrollViewSize)
    self.m_root_lv:setInertiaScrollEnabled(true)
    self.m_root_lv:jumpToPercentHorizontal(0)
    self.m_root_lv:setGravity(0)
    self.m_root_lv:setBounceEnabled(true)--回弹
    self.m_root_lv:setDirection(ccui.ScrollViewDir.horizontal)--水平方向
    self.m_root_lv:setScrollBarEnabled(false)-- 隐藏滚动条
    self.m_root_lv:setItemsMargin(0.0)
    
    if self.m_root_lv:getContentSize().width >= self.m_listMaxWidth - 50 then
        self.m_pParent:refreshArrow(false, false)
    else
        self.m_pParent:refreshArrow(false, true)
    end
end

function HallGameListView:animationTransform(Data)
    if Data == nil then
        return
    end

    local str = Data.strAnimationPath

    return Data.strAnimationPath
end

function HallGameListView:initBtnView(_btnNode, index, size, pos, fileName, bAnimation )
    --动画
    local gameinfor = self.room_list_data[index]    
    --local posIndex = math.floor((index-1)/2)
    --posIndex = 0.3 + posIndex * 0.2

    local actionTime = 0.4

    --按钮图片
    local norsp = _btnNode:getRendererNormal()
    if norsp ~= nil and bAnimation then
        norsp:setOpacity(0)
        norsp:runAction( cc.FadeIn:create(actionTime) )
    end
    --[[
    -- 检查下载/更新
    local nKindID = tonumber(gameinfor._KindID)
    local version = tonumber(self._scene:getApp():getVersionMgr():getResVersion(nKindID))
    local pDownloadPos = cc.p(size.width / 2, 100)
    if not version then
        -- 下载
        local tipbg = cc.Sprite:createWithSpriteFrameName("hall/plist/hall/image-download-logo-install.png")
        tipbg:setPosition(pDownloadPos)
        tipbg:setName(gameinfor._KindID .. "_sp_tipbg")
        tipbg:setZOrder(10000)
        tipbg:setOpacity(0)
        tipbg:runAction( cc.FadeIn:create(actionTime) )
        _btnNode:addChild(tipbg)
    elseif gameinfor._ServerResVersion > version then
        -- 更新
        local tipbg = cc.Sprite:createWithSpriteFrameName("hall/plist/hall/image-download-logo-update.png")
        tipbg:setPosition(pDownloadPos)
        tipbg:setName(gameinfor._KindID .. "_sp_tipbg")
        tipbg:setZOrder(10000)
        tipbg:setOpacity(0)
        tipbg:runAction( cc.FadeIn:create(actionTime) )
        _btnNode:addChild(tipbg)
    end
    --]]
    --点击响应
    _btnNode:setName(gameinfor._KindID .. "_icon")
    _btnNode:setTouchEnabled(true)
    _btnNode:addTouchEventListener(function(sender, eventType)
        if eventType==ccui.TouchEventType.began then
            _btnNode:setScale(1.1)
        elseif eventType == ccui.TouchEventType.canceled then
            _btnNode:setScale(1.0)
        elseif eventType == ccui.TouchEventType.ended then
            _btnNode:setScale(1.0)
            self:TouchListItem(_btnNode, gameinfor)
        end
    end)
    --[[
    --游戏logo
    local pLogo = self:getGameLogo(gameinfor)
    if pLogo then
        pLogo:setTag(102)
        pLogo:addTo(_btnNode)
        pLogo:setOpacity(0)
        pLogo:runAction( cc.FadeIn:create(actionTime) )
    end
  
    --按钮扫光
    local saoguang = ccs.Armature:create("gamekind_effect")
    local animation = string.format("Animation%d", math.random(1,3))
    saoguang:setPosition(cc.p(129, 121))
    saoguang:setTag(103)
    saoguang:setVisible(false)
    saoguang:addTo(_btnNode)
    
    --动作完
    _btnNode:setTouchEnabled(false)
    local action1 = cc.Sequence:create(
        cc.DelayTime:create(actionTime), 
        cc.CallFunc:create(function()
            --按钮可点
            _btnNode:setTouchEnabled(true)
        end),
        cc.DelayTime:create(math.random(0, 1)),
        cc.CallFunc:create(function()
            --显示扫光
            saoguang:setVisible(true)
            saoguang:getAnimation():play(animation)
        end))
    _btnNode:runAction(action1)
    --]]
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
    if info and info.dwStatus > 0 then

        --右上角节点
        local pNode = cc.Node:create()
        pNode:setAnchorPoint(1.0, 1.0)
        pNode:setPosition(214, 145)
        pNode:setCascadeOpacityEnabled(true)

        --右上角图标
        local pLogo = nil
        if info.dwStatus == 1 then
            pLogo = cc.Sprite:createWithSpriteFrameName("hall/plist/hall/gui-logo-new.png")
        elseif info.dwStatus == 2 then
            pLogo = cc.Sprite:createWithSpriteFrameName("hall/plist/hall/gui-logo-hot.png")
        else
            pLogo = cc.Sprite:createWithSpriteFrameName("hall/plist/hall/gui-logo-new.png")
        end
        pLogo:setCascadeOpacityEnabled(true)
        pLogo:addTo(pNode)

        --右上角图标扫光
        local pArmature = ccs.Armature:create("shaoguangAnimation")
        pArmature:getAnimation():play("Animation1", -1, 1)
        pArmature:setAnchorPoint(0.5, 0.5)
        pArmature:setPosition(0, -1)
        pArmature:setCascadeOpacityEnabled(true)
        pArmature:addTo(pNode)

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

    local pDownloadPos = cc.p(ref:getContentSize().width / 2, 137)
    -- 底图
    local tipbg = cc.Sprite:create("dt/image/hall/zcm_gx3.png")
    tipbg:setName(nKindID .. "_sp_tipbg")
    tipbg:setPosition(pDownloadPos)
    tipbg:setZOrder(10000)
    ref:addChild(tipbg)

    -- 进度
    local bar_tips = cc.Label:createWithTTF("0%", "fonts/round_body.ttf", 20)
    ref:addChild(bar_tips, 1)
    bar_tips:setName(nKindID .. "_bar_tips")
    bar_tips:setZOrder(10002)
    bar_tips:setPosition(pDownloadPos)

    --下载图标扇形
    local progressImg = cc.Sprite:create("dt/image/hall/zcm_gx2.png")
    local pProgressTimer = cc.ProgressTimer:create(progressImg)
    pProgressTimer:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    pProgressTimer:setName(nKindID .. "_progress_timer")
    pProgressTimer:setCascadeOpacityEnabled(true)
    pProgressTimer:setZOrder(10001)
    pProgressTimer:setPosition(pDownloadPos)
    ref:addChild(pProgressTimer)
end


-- 移除下载信息
function HallGameListView:removeDownloadInfo( nKindID )
    if nil == nKindID then
        return
    end
    -- 进度信息
    -- icon
    local icon = ExternalFun.seekNodeByName(self.m_root_lv, nKindID .. "_icon")
    if nil ~= icon then
        -- 背景
        icon:removeChildByName(nKindID .. "_sp_tipbg")
        -- 提示
        icon:removeChildByName(nKindID .. "_bar_tips")
        --扇形
        icon:removeChildByName(nKindID .. "_progress_timer")
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

--更新进度
function HallGameListView:updateProgress(updateinfo, sub, msg, mainpersent)
    if type(updateinfo) ~= "table" or nil == updateinfo._KindID then
        return
    end
    -- 进度信息
    local icon = ExternalFun.seekNodeByName(self.m_root_lv, updateinfo._KindID .. "_icon")
    if icon then
        -- 进度文字
        local tips = icon:getChildByName(updateinfo._KindID .. "_bar_tips")
        if nil ~= tips then
            tips:setString(string.format("%d%%", mainpersent))
        end

        -- 扇形
        local timer = icon:getChildByName(updateinfo._KindID .. "_progress_timer")
        if nil ~= timer then
            timer:setPercentage(mainpersent)
        end
    end
end

--更新结果
function HallGameListView:ZipResult(updateinfo, result, msg)
    if type(updateinfo) ~= "table" or nil == updateinfo._KindID then
        return
    end
     -- 进度信息
    local icon = ExternalFun.seekNodeByName(self.m_root_lv, updateinfo._KindID .. "_icon")
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
                    local ref = ExternalFun.seekNodeByName(self.m_root_lv, updateinfo._KindID .. "_icon")
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
                    break
                end
            end
        end
        --self:onEnterGame(updateinfo)  --下载完毕暂不进入房间
        
    else
        local runScene = cc.Director:getInstance():getRunningScene()
        if nil ~= runScene then
            QueryDialog:create(msg.."\n是否重试？",function(bReTry)
                if bReTry == true then
                    local ref = ExternalFun.seekNodeByName(self.m_root_lv, updateinfo._KindID .. "_icon")
                    if nil ~= ref then
                        self:addDownloadInfo(ref, updateinfo._KindID)
                    end
                    self:onGameUpdate(updateinfo)
                end
            end)
            :addTo(runScene)
        end     
    end
end

function HallGameListView:enterRecommendGame(_event)
    local _userdata = unpack(_event._userdata);
    if not _userdata then
        return
    end
    local msg = _userdata.packet
    local BTN_taget = self.m_root_lv:getChildByName("_Node_layer"):getChildByName(msg.gamekind.. "_icon")
    local gameinfo = {}
    local allGamelist = self._scene:getApp()._gameList[1]

    for k,v in pairs(allGamelist) do
        if v._KindID == msg.gamekind then
            gameinfo = allGamelist[k]
        end
    end

    self:TouchListItem(BTN_taget, gameinfo)
end

function HallGameListView:onEnter()
    self.HallGameListView =  SLFacade:addCustomEventListener(Hall_Events.ENTER_RECOMMEND_GAME, handler(self, self.enterRecommendGame))
end

function HallGameListView:onExit()
    SLFacade:removeEventListener(self.HallGameListView)
end

return HallGameListView
