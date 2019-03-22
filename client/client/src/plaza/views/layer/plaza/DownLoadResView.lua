--region DownLoadResView.lua
--Date 2017.05.02.
--Auther JackyXu.
--Desc: 大厅热更下载进度 view

local DownLoadResView = class("DownLoadResView", cc.Node)

--local DownloadResMgr = require("common.manager.DownloadResMgr")

function DownLoadResView:ctor(nKindId, fileName, posInBtn)

    --位置
    local pos = cc.p(posInBtn.x / 2, posInBtn.y / 2 + 10)
    --游戏序号
    self.m_nKindId = nKindId

    --背景节点---------------------------------
    self.m_pImageNode = cc.Node:create()
    self.m_pImageNode:setCascadeOpacityEnabled(true)
    self.m_pImageNode:addTo(self)

    --图片进度
    local progressImg = cc.Sprite:createWithSpriteFrameName(fileName)
    self.m_pImageTimer = cc.ProgressTimer:create(progressImg)
    self.m_pImageTimer:setAnchorPoint(cc.p(0, 0))
    self.m_pImageTimer:setPosition(cc.p(0, 0));
    self.m_pImageTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR) -- 设置为条
    self.m_pImageTimer:setMidpoint(cc.p(0, 0))             -- 设置起点为条形左下方
    self.m_pImageTimer:setBarChangeRate(cc.p(0, 1))        -- 设置为竖直方向
    self.m_pImageTimer:setOpacity(120)
    self.m_pImageTimer:setColor(cc.c3b(0, 0, 0))
    self.m_pImageTimer:setPercentage(100)
    self.m_pImageTimer:setCascadeOpacityEnabled(true)
    self.m_pImageTimer:addTo(self.m_pImageNode)
    ------------------------------------------

    --下载节点 --------------------------------
    self.m_pDownNode = cc.Node:create()
    self.m_pDownNode:setPosition(pos)
    self.m_pDownNode:setCascadeOpacityEnabled(true)
    self.m_pDownNode:addTo(self)

    --下载图标背景
    self.m_pProcessBg = cc.Sprite:createWithSpriteFrameName("hall/plist/hall/image-download-res-bg.png")
    self.m_pProcessBg:setPosition(pos)
    self.m_pProcessBg:setCascadeOpacityEnabled(true)
    self.m_pProcessBg:addTo(self.m_pDownNode)

    --下载图标扇形
    local progressImg = cc.Sprite:createWithSpriteFrameName("hall/plist/hall/image-download-res-pro.png")
    self.m_pProgressTimer = cc.ProgressTimer:create(progressImg)
    self.m_pProgressTimer:setPosition(pos)
    self.m_pProgressTimer:setMidpoint(cc.p(0.5, 0.5))
    self.m_pProgressTimer:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    self.m_pProgressTimer:setCascadeOpacityEnabled(true)
    self.m_pProgressTimer:addTo(self.m_pDownNode)

    --下载图标百分比
    self.m_pPercent = cc.Label:createWithSystemFont("0", "", 20)
    self.m_pPercent:setCascadeOpacityEnabled(true)
    self.m_pPercent:setPosition(pos)
    self.m_pPercent:addTo(self.m_pDownNode)
    -------------------------------------------

    --提示节点----------------------------------
    self.m_pLogoNode = cc.Node:create()
    self.m_pLogoNode:setCascadeOpacityEnabled(true)
    self.m_pLogoNode:setPosition(pos)
    self.m_pLogoNode:addTo(self)

    --提示
    local path = self:getDownLoadLogo(nKindId)
    self.m_pDownLoad = cc.Sprite:createWithSpriteFrameName(path)
    self.m_pDownLoad:setPosition(pos)
    self.m_pDownLoad:setCascadeOpacityEnabled(true)
    self.m_pDownLoad:addTo(self.m_pLogoNode)
    -------------------------------------------

    self.m_pDownNode:setVisible(false)
    self.m_pLogoNode:setVisible(true)
    self.m_pImageNode:setVisible(true)
    self:setCascadeOpacityEnabled(true)
end

function DownLoadResView:getDownLoadLogo(nKindId)
    local isError = DownloadResMgr.getInstance():checkIsError(nKindId)
    local isWait = DownloadResMgr.getInstance():checkInQueue(nKindId)
    local isDown = DownloadResMgr.getInstance():getIsShowDownloadDone(nKindId)
    if isError then
        return "hall/plist/hall/image-download-logo-error.png"
    elseif isWait then
        return "hall/plist/hall/image-download-logo-wait.png"
    elseif isDown then
        return "hall/plist/hall/image-download-logo-update.png"
    end
    return "hall/plist/hall/image-download-logo-install.png"
end

function DownLoadResView:setDownLoadLogo()
    local path = self:getDownLoadLogo(self.m_nKindId)
    self.m_pDownLoad:setSpriteFrame(path)
end

function DownLoadResView:setNeedDownLoadState()
    
    self:setVisible(true)
    self:setDownLoadLogo(true)
    self.m_pLogoNode:setVisible(true)
    self.m_pDownNode:setVisible(false)
    self.m_pImageNode:setVisible(true)

    self.m_pPercent:setString("")
    self.m_pImageTimer:setPercentage(100)
    self.m_pProgressTimer:setPercentage(100)
end

function DownLoadResView:setDownLoadPercent(per)

    self:setVisible(true)
    self.m_pLogoNode:setVisible(false)
    self.m_pDownNode:setVisible(true)
    self.m_pImageNode:setVisible(true)

    -- 设置背景进度
    self.m_pImageTimer:setPercentage(100 - per)

    -- 设置扇形大小
    self.m_pProgressTimer:setPercentage(per)

    -- 设置百分比显示
    local strPercent = string.format("%d%%", per)
    self.m_pPercent:setString(strPercent)
end

function DownLoadResView:setDownLoadDoneState()
    
    self:setVisible(false)
    self.m_pLogoNode:setVisible(false)
    self.m_pDownNode:setVisible(false)
    self.m_pImageNode:setVisible(false)
end

function DownLoadResView:setStateInstall()
    
    self:setVisible(true)
    self.m_pLogoNode:setVisible(false)
    self.m_pDownNode:setVisible(true)
    self.m_pImageNode:setVisible(true)
    self.m_pPercent:setString("安装中")
    self.m_pImageTimer:setPercentage(100)
    self.m_pProgressTimer:setPercentage(100)
end

function DownLoadResView:setStateInstallDone()

    self:setDownLoadLogo()

    self:setVisible(true)
    self.m_pLogoNode:setVisible(true)
    self.m_pDownNode:setVisible(false)
    self.m_pImageNode:setVisible(true)
    self.m_pPercent:setString("安装完")
    self.m_pImageTimer:setPercentage(100)
    self.m_pProgressTimer:setPercentage(100)
end

function DownLoadResView:updatePercent(per)

    per = per or 0
    if     per <  100 then self:setDownLoadPercent(per) --下载中
    elseif per == 100 then self:setDownLoadDoneState()  --下载完
    elseif per == 101 then self:setStateInstall()       --安装中
    elseif per == 102 then self:setStateInstallDone()   --安装完
    end
end

function DownLoadResView:updateDownload(_nGameKindID, nPercent)
    if nPercent == 100 then
        if DownloadResMgr.getInstance():getIsShowDownloadDone(_nGameKindID) then
            self:setDownLoadDoneState()
        else
            self:setVisible(false)
        end
    else
        self:setVisible(true)
        self:updatePercent(nPercent)
    end
end

--获取一个下载图标
function DownLoadResView.getGameDownRes(nKindId, fileName, pos)

    -- 下载进度
    local pDownloadRes = DownLoadResView:create(nKindId, fileName, pos)

    if DownloadResMgr.getInstance():getIsInCheck(nKindId) then
        -- 检测中
        pDownloadRes:setNeedDownLoadState()

    elseif DownloadResMgr.getInstance():checkIsDownloadResoure(nKindId) then
        -- 需要下载资源
        local per = DownloadResMgr.getInstance():getDownLoadProgressPer(nKindId)
        if per and per > 0 then
            pDownloadRes:updatePercent(per)
        else
            pDownloadRes:setNeedDownLoadState()
        end

    elseif DownloadResMgr.getInstance():getIsShowDownloadDone(nKindId) then
        -- 已完成下载
        pDownloadRes:setDownLoadDoneState()

    else
        pDownloadRes:setVisible(false)
    end

    return pDownloadRes
end

return DownLoadResView
