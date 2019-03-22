--
-- Author: zhong
-- Date: 2017-08-03 14:59:42
--
-- 包含(GameListLayer 游戏列表层, GameUpdater 单游戏更新层)
local TransitionLayer = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local UIPageView = appdf.req(appdf.EXTERNAL_SRC .. "UIPageView")
local MultiUpdater = appdf.req(appdf.EXTERNAL_SRC.."MultiUpdater")
local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")

local GameListLayer = class("GameListLayer", ccui.ScrollView)

local TAG_START             = 100
local enumTable = 
{
    "BTN_CLOSE",            -- 关闭按钮
    "TAG_MASK",             -- 遮罩
}
local TAG_ENUM = ExternalFun.declarEnumWithTable(TAG_START, enumTable)

local ACTION_START          = 300
local actionEnum = 
{
    "ACTION_DEFAULT",       -- 默认
    "ACTION_PRIVATE",       -- 约战房间
    "ACTION_SCORELIST",     -- 金币房间
}
local ACTION_ENUM = ExternalFun.declarEnumWithTable(ACTION_START, actionEnum)
GameListLayer.ACTION_ENUM = ACTION_ENUM

function GameListLayer:ctor( scene,param,level )
    self._scene = scene
    self._param = param or {}
    -- 动作
    self.m_action = self._param.action or ACTION_ENUM.ACTION_DEFAULTd
    self.m_tabPageItem = {}
    -- 弹窗
    self._query = nil

    self:setDirection(ccui.ScrollViewDir.horizontal)
    self:setScrollBarEnabled(false)
    self:setBounceEnabled(true)

    self:setContentSize(970,470)
    self:setPosition(345, 130)

    self:updateGameList(self._param.list)
end

function GameListLayer:onButtonClickedEvent(tag, ref)
    if tag == TAG_ENUM.BTN_CLOSE then
        self:scaleTransitionOut(self.m_layMask)
    end
end

function GameListLayer:onGameIconClickEvent(tag, ref)
    local config = ref.config
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
        if nil ~= GlobalUserItem.tabUpdater[nKindID] then
            print("GameListLayer:onGameIconClickEvent 正在更新 ", config._GameName)
            return
        end

        -- parent=pageitem
        self:addDownloadInfo(ref, nKindID)

        self:updateGame(config)
    else
        self:onEnterGame(config)
    end
end

-- 增加下载信息
function GameListLayer:addDownloadInfo( ref, nKindID )
    -- 校验
    if nil == ref or nil == nKindID then
        return
    end
    ref:removeChildByName(nKindID .. "_sp_tipbg")

    -- 底图
    local tipbg = cc.Sprite:create("gameicon/gameicon_sp_tipbg.png")
    tipbg:setName(nKindID .. "_sp_tipbg")
    tipbg:setPosition(150,40)
    ref:addChild(tipbg)

    -- 进度
    local bar_tips = cc.Label:createWithTTF("0%", "fonts/round_body.ttf", 20)
    ref:addChild(bar_tips, 1)
    bar_tips:setName(nKindID .. "_bar_tips")
    bar_tips:setPosition(tipbg:getPosition())
end

-- 移除下载信息
function GameListLayer:removeDownloadInfo( nKindID )
    if nil == nKindID then
        return
    end
    -- 进度信息
    for k,v in pairs(self.m_tabPageItem) do
        -- icon
        local icon = v:getChildByName(nKindID .. "_icon")
        if nil ~= icon then
            -- 背景
            icon:removeChildByName(nKindID .. "_sp_tipbg")

            -- 提示
            icon:removeChildByName(nKindID .. "_bar_tips")

            break
        end
    end
end


--更新游戏列表
function GameListLayer:updateGameList(gamelist)

    print("更新游戏列表")
    
    --保存游戏列表
    self._gameList = gamelist

    --清空子视图
    self:removeAllChildren()

    if #gamelist == 0 then
        return
    end

   local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            local beginPos = ref:getTouchBeganPosition()
            local endPos = ref:getTouchEndPosition()
            if math.abs(endPos.x - beginPos.x) > 30 
                or math.abs(endPos.y - beginPos.y) > 30 then
                print("GameListLayer:onButtonClickedEvent ==> MoveTouch Filter")
                return
            end
            self:onGameIconClickEvent(ref:getTag(), ref)            
        end
    end
    
    --设置内容高度
    local contentSize = self:getContentSize()
    local Scale             =   0.75
    local iconCX            =   167
    local iconCY            =   214
    local spacing           =   33
    local columns           =   2
    local lines             =   math.ceil( #gamelist / columns )
    local containerWidth    =   lines * iconCX + (lines - 1) * spacing
    local containerHeight   =   contentSize.height

    --判断容器高度是否小于最小高度
    if containerWidth < contentSize.width then
        containerWidth = contentSize.width
    end
    self:setInnerContainerSize(cc.size(containerWidth, containerHeight))
    local app = self._scene:getApp()
    for i = 1, #gamelist do
        local row       =   math.floor( (i - 1) / columns )
        local col       =   (i - 1) % columns
        local x         =   row * spacing + (row + 0.5) * iconCX * Scale + 30
        local y         =  containerHeight - (col + (col + 0.5) * iconCY * Scale + col*spacing)-80

        local config = gamelist[i]
        local file = string.format("gameicon/Game%d.png", config._KindID)
        local notexit = false
        if not cc.FileUtils:getInstance():isFileExist(file) then
            file = "gameicon/gameicon_default.png"
            notexit = true
        end
        local btn = ccui.Button:create(file, file, file)
        btn.config = config
        btn:addTouchEventListener( touchFunC )
        btn:setPressedActionEnabled(true)
        btn:setSwallowTouches(false)
        btn:setPosition(cc.p(x,y))
        btn:setScale(0)
        btn:setName(config._KindID .. "_icon")
        self:addChild(btn)

        local timer = col==0 and 0.1 or 0
        local delay = cc.DelayTime:create(timer)
        local scaleTo = cc.ScaleTo:create(0.08, 0.2);  
        local scaleTo1 = cc.ScaleTo:create(0.08, 1); 
        local scaleTo2 = cc.ScaleTo:create(0.08, 0.6);
        local scaleTo3 = cc.ScaleTo:create(0.08, 0.8);
        local scaleTo4 = cc.ScaleTo:create(0.08, 0.7);  
        local scaleTo5 = cc.ScaleTo:create(0.08, Scale); 
        btn:runAction(cc.Sequence:create(delay, scaleTo, scaleTo1, scaleTo2, scaleTo3, scaleTo4, scaleTo5))
        if notexit then
            local kindname = cc.Label:createWithTTF(config._GameName, "fonts/round_body.ttf", 30)
            btn:addChild(kindname)
            kindname:setPosition(140, 60)
        end

        -- 检查下载/更新
        local nKindID = tonumber(config._KindID)
        local version = tonumber(app:getVersionMgr():getResVersion(nKindID))
        if not version then
            -- 下载
            local tipbg = cc.Sprite:create("gameicon/gameicon_sp_tipbg.png")
            tipbg:setPosition(150,40)
            tipbg:setName(config._KindID .. "_sp_tipbg")
            btn:addChild(tipbg)
            -- 下载标识
            local downloadtip = cc.Sprite:create("gameicon/gameicon_sp_downloadtip.png")
            downloadtip:setPosition(tipbg:getContentSize().width * 0.5, tipbg:getContentSize().height * 0.5)
            tipbg:addChild(downloadtip)
        elseif config._ServerResVersion > version then
            -- 更新
            local tipbg = cc.Sprite:create("gameicon/gameicon_sp_updatetip.png")
            tipbg:setPosition(150,40)
            tipbg:setName(config._KindID .. "_sp_tipbg")
            btn:addChild(tipbg)
        end
    end

    -- 判断是否有下载
    for k,v in pairs(GlobalUserItem.tabUpdater) do
        local ref = v:getChildByName(k .. "_icon")
        if nil ~= ref then
            self:addDownloadInfo(ref, k)
        end
        v._listener = self
    end

    --滚动的到前面
    self:jumpToTop()
end

function GameListLayer:onEnterGame( gameinfo )
    if self.m_action == ACTION_ENUM.ACTION_SCORELIST then
        if nil ~= self._scene._scenePopLayer:getChildByName(yl.PLAZA_ROOMLIST_LAYER) then
            return
        end
        local nKindID = tonumber(gameinfo._KindID)
        GlobalUserItem.nCurGameKind = nil
        GlobalUserItem.nCurGameKind = nKindID
        self._scene:updateEnterGameInfo(gameinfo)
        self._scene:enterRoomList()
    end
end

function GameListLayer:updateGame( gameinfo )
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
function GameListLayer:onGameUpdate(gameinfo)
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

    --更新参数
    local newfileurl = self._scene:getApp()._updateUrl.."/game/" .. gameinfo._Module .. "/res/filemd5List.json"
    local dst = device.writablePath .. "game/" .. gameinfo._Type .. "/"
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_WINDOWS == targetPlatform then
        dst = device.writablePath .. "download/game/" .. gameinfo._Type .. "/"
    end
    
    local src = device.writablePath.."game/" .. gameinfo._Module .. "/res/filemd5List.json"
    local downurl = self._scene:getApp()._updateUrl .. "/game/" .. gameinfo._Type .. "/"

    --创建更新
    update = MultiUpdater:create(newfileurl,dst,src,downurl)
    update:upDateClient(self._scene:getApp(), self, gameinfo)
    GlobalUserItem.tabUpdater[gameinfo._KindID] = update
end

function GameListLayer:onUpdataNotify()
    showToast(self,"游戏版本信息错误！",1)
end

--更新进度
function GameListLayer:updateProgress(updateinfo, sub, msg, mainpersent)
    if type(updateinfo) ~= "table" or nil == updateinfo._KindID then
        return
    end
    -- 进度信息
    for k,v in pairs(self.m_tabPageItem) do
        local icon = v:getChildByName(updateinfo._KindID .. "_icon")
        if nil ~= icon then
            -- 进度文字
            local tips = icon:getChildByName(updateinfo._KindID .. "_bar_tips")
            if nil ~= tips then
                tips:setString(string.format("%d%%", mainpersent))
                break
            end
        end
    end
end

--更新结果
function GameListLayer:updateResult(updateinfo, result, msg)
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
        -- 更新版本号
        for k,v in pairs(app._gameList) do
            if v._KindID == updateinfo._KindID then
                app:getVersionMgr():setResVersion(v._ServerResVersion, v._KindID)
                v._Active = true
                break
            end
        end
        self:onEnterGame(updateinfo)
        
    else
        local runScene = cc.Director:getInstance():getRunningScene()
        if nil ~= runScene then
            self._query = QueryDialog:create(msg.."\n是否重试？",function(bReTry)
                if bReTry == true then
                    for k1,v1 in pairs(self.m_tabPageItem) do
                        local ref = v1:getChildByName(updateinfo._KindID .. "_icon")
                        if nil ~= ref then
                            self:addDownloadInfo(ref, updateinfo._KindID)
                        end
                    end
                    self:onGameUpdate(updateinfo)
                end
                self._query = nil
            end)
            :addTo(runScene)
        end     
    end
end

return GameListLayer