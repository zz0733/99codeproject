-- region *.lua
-- Date
-- Desc loading 过渡页面 layer.

local module_pre = "game.yule.frogfish.src.views."
local FishRes         = require(module_pre .."scene.FishSceneRes")
local FishTraceMgr    = require(module_pre .."manager.FishTraceMgr")
local FishSceneMgr    = require(module_pre .."manager.FishSceneMgr")    
local ResourceManager = require(module_pre .."manager.ResourceManager")
local CMsgFish        = appdf.req(module_pre .."proxy.CMsgFish")
local scheduler = cc.Director:getInstance():getScheduler()

local FishLoadingView = class("FishLoadingView", cc.Layer)

function FishLoadingView.loading()
    return FishLoadingView.new(true)
end

function FishLoadingView.reload()
    return FishLoadingView.new(false)
end

function FishLoadingView:ctor(bBool)
    --FloatMessage.getInstance():setPositionX((display.width - 1334) / 2)
    self:enableNodeEvents()
    self.bLoad = bBool

    --界面
    self.m_pathUI = nil
    self.m_pTextLabel = nil 
    self.m_pProgressTimer = nil
    self.m_pProgressBarNode = nil
    self.p_Armature = nil

    --计数
    self.m_nTraceCount = 0
    self.m_nTraceIndex = 0
    self.m_nSceneCount = 0
    self.m_nSceneIndex = 0
    self.m_nEffectCount = 0
    self.m_nEffectIndex = 0

    --文字
    self.m_strTipText = yl.getLocalString("LKFish_Loading_Tip")

    self:init()
end

function FishLoadingView:init()

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(FishRes.EFFECT_OF_LOADING)
    --ccb
    self.m_pathUI = cc.CSLoader:createNode("game/frogfish/csb/gui-fish-loading.csb")
    self.m_pathUI:setPositionX((display.width - 1334) / 2)
    self.m_pathUI:addTo(self.m_rootUI)

    --进度文字
    self.m_pTextLabel = self.m_pathUI:getChildByName("TextLoad")
    self.m_pTextLabel:setString("")

    --进度条
    self.m_pProgressTimer = self.m_pathUI:getChildByName("LoadingBar")
    self.m_pProgressTimer:setPercent(0)

    --提示文字(在游戏设置中自定义设置选项，会让您获得更佳的游戏体验。)
    self.m_pTextHelp = self.m_pathUI:getChildByName("TextHelp")

    --重设文字
--    local kind = 362
--    local word = Localization_cn["Loading_" .. kind]
--    local index = math.random(1, #word)
--    local text = word[index]
--    self.m_pTextHelp:setString(text)
--    self.m_pTextHelp:setTextColor(cc.WHITE)
--    self.m_pTextHelp:enableShadow(cc.BLACK, cc.size(2, -3), 0)
end

function FishLoadingView:onEnter()

    if self.bLoad then
        self:startLoad()
    end
end

function FishLoadingView:onExit()

    if cc.exports.g_SchulerOfLoading then
        scheduler:unscheduleScriptEntry(cc.exports.g_SchulerOfLoading)
        cc.exports.g_SchulerOfLoading = nil
    end

    display.removeSpriteFrames(FishRes.PLIST_OF_LOADING, FishRes.PLIST_OF_LOADING_PNG)
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(FishRes.EFFECT_OF_LOADING)
end

function FishLoadingView:updatePercent(percent)

    self.m_pProgressTimer:setPercent(percent)
    self.m_pTextLabel:setString(string.format(self.m_strTipText, percent))
end

--新的加载方式
function FishLoadingView:startLoad()
    
    local func = {}

    -------------------------------------------------------
    --音效/音乐
    local paths_mp3 = FishRes.vecReleaseSound
    local paths_bg = FishRes.vecReleaseMusic
    for i = 1, #paths_mp3 do --音效
        table.insert(func, function()
            AudioEngine.preloadEffect(paths_mp3[i])
            return i, "音效"
        end)
    end
    for i = 1, #paths_bg do --音乐
        table.insert(func, function()
            AudioEngine.preloadMusic(paths_bg[i])
            return i, "音乐"
        end)
    end
    -------------------------------------------------------
    --基础鱼阵
    for i = 1, 16 do
        table.insert(func, function()
            FishSceneMgr.getInstance():prepare_path2(i)
            return i , "基础鱼阵"
        end)
    end
    --配置鱼阵
    for i = 0, 7 do
        table.insert(func, function()
            FishSceneMgr.getInstance():loadOneSceneFileByIndex(i)
            return i , "配置鱼阵"
        end)
    end
    --0号路径
    table.insert(func, function()
        FishTraceMgr:getInstance():loadNumZeroTrace()
        return 1, "0 号路径"
    end)
    --401号路径
    table.insert(func, function()
        FishTraceMgr:getInstance():createSpecailTrace()
        return 1, "401号路径"
    end)
    --基础路径
    for i = 1, 12 do
        table.insert(func, function()
            FishTraceMgr:getInstance():loadAllPathFile(i)
            return i, "基础路径"
        end)
    end
    -------------------------------------------------------
    --碎图/大图/动画
    local paths_plist = FishRes.vecReleasePlist
    local paths_png = FishRes.vecReleaseImg
    local paths_json = FishRes.vecReleaseAnim
    -------------------------------------------------------
    --记录执行
    for i = 1, #paths_plist do --碎图
        table.insert(func, function()
            display.loadSpriteFrames(paths_plist[i][1], paths_plist[i][2])
            return i, "碎图"
        end)
    end
    for i = 1, #paths_png do --大图
        table.insert(func, function()
            display.loadImage(paths_png[i])
            return i, "大图"
        end)
    end
    for i = 1, #paths_json do --动画
        table.insert(func, function()
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(paths_json[i])
            return i, "动画"
        end)
    end
    -------------------------------------------------------
    --打乱次序
    --function RandSort(t)
    --    math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)))
    --    table.sort(t, function(a,b)
    --        return math.random(1,10) < 5
    --    end)
    --end
    --RandSort(func)
    -------------------------------------------------------
    --开始加载
    local time_load = cc.exports.gettime()
    local time_start = 0
    local time_stop = 0
    local time_frame = cc.Director:getInstance():getAnimationInterval()
    local len = #func
    local index = 0
    local count = 0
    cc.exports.g_SchulerOfLoading = scheduler:scheduleScriptFunc(function()
        if index < len then
            --一帧开始时间
            time_start = cc.exports.gettime()
            --一帧结束时间
            time_stop = time_start
            --一帧加载数量
            count = 0
            --一帧时间未完,继续加载
            while time_stop - time_start < time_frame and index < len do
                --加载一个动作
                count = count + 1
                index = index + 1
                self:updatePercent(index / len * 100)
                local start = cc.exports.gettime()
                local i, ret = func[index]()
                local time = cc.exports.gettime() - start
                local strTime = string.format("%0.5f", time)
                print("-- load", index, "一帧第"..count.."个", "第"..i.."个", ret, "耗时", strTime)
                --重新计时
                time_stop = cc.exports.gettime()
            end
        else
            self:updatePercent(100)
            print("----- load over ------", cc.exports.gettime() - time_load)
            --发送准备
            CMsgFish.getInstance():sendUserReady()
            scheduler:unscheduleScriptEntry(cc.exports.g_SchulerOfLoading)
            performWithDelay(self,function()  
                 SLFacade:dispatchCustomEvent(Hall_Events.MSG_GAME_LOAD_SUCCESS)
            end,1)
        end
    end, 0.01, false)
    -------------------------------------------------------
end

return FishLoadingView

-- endregion
