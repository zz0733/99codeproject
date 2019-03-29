-- region Fish.lua
-- Date     2017.04.07
-- zhiyuan
-- Desc 创建鱼 node.
local module_pre = "game.yule.lkby.src"
local MathAide     = require(module_pre..".views.manager.MathAide")
local FishDataMgr  = require(module_pre..".views.manager.FishDataMgr")
local FishTraceMgr = require(module_pre..".views.manager.FishTraceMgr")
local DataCacheMgr = require(module_pre..".views.manager.DataCacheMgr")

local Fish = class("Fish", cc.Node)

--李逵捕鱼:大闹天宫+金玉满堂
--金蟾捕鱼:大闹天宫+一箭双雕+一时三鸟+金玉满堂
--大闹天宫:大闹天宫+一箭双雕+一时三鸟
--一箭双雕 5 x 2
Fish.m_cbMixFishDateType1 = 
{
    [0] = { [0] = FishKind.FISH_HUANGBIANYU, FishKind.FISH_LANYU,    },
    [1] = { [0] = FishKind.FISH_XIAOCHOUYU,  FishKind.FISH_XIAOCIYU, },
    [2] = { [0] = FishKind.FISH_HUANGBIANYU, FishKind.FISH_XIAOCIYU, },
    [3] = { [0] = FishKind.FISH_XIAOCHOUYU,  FishKind.FISH_LANYU,    },
    [4] = { [0] = FishKind.FISH_HUANGCAOYU,  FishKind.FISH_XIAOCIYU, },
}

--一时三鸟 6 x 3
Fish.m_cbMixFishDateType2 = 
{
    [0] = { [0] = FishKind.FISH_LVCAOYU, FishKind.FISH_XIAOCHOUYU,  FishKind.FISH_HUANGCAOYU,  },
    [1] = { [0] = FishKind.FISH_WONIUYU, FishKind.FISH_XIAOCHOUYU,  FishKind.FISH_DAYANYU,     },
    [2] = { [0] = FishKind.FISH_WONIUYU, FishKind.FISH_XIAOCHOUYU,  FishKind.FISH_XIAOCIYU,    },
    [3] = { [0] = FishKind.FISH_DAYANYU, FishKind.FISH_LANYU,       FishKind.FISH_HUANGBIANYU, },
    [4] = { [0] = FishKind.FISH_DAYANYU, FishKind.FISH_HAIGUI,      FishKind.FISH_HUANGBIANYU, },
    [5] = { [0] = FishKind.FISH_DAYANYU, FishKind.FISH_XIAOCHOUYU,  FishKind.FISH_XIAOCIYU,    },
}

--金玉满堂 2 x 5
Fish.m_cbMixFishDateType3 = 
{
    [0] = { [0] = FishKind.FISH_DENGLONGYU, FishKind.FISH_WONIUYU, FishKind.FISH_HAIGUI, FishKind.FISH_LVCAOYU, FishKind.FISH_XIAOCIYU, },
    [1] = { [0] = FishKind.FISH_DAYANYU, FishKind.FISH_HUANGCAOYU, FishKind.FISH_LANYU, FishKind.FISH_XIAOCHOUYU, FishKind.FISH_HUANGBIANYU, },
}

Fish._out_screen_left = 0 - 50
Fish._out_screen_right = display.width + 50
Fish._out_screen_down = 0 - 50
Fish._out_screen_up = display.height + 50

Fish._in_screen_left = 0 - 120
Fish._in_screen_right = display.width + 120
Fish._in_screen_down = 0 - 120
Fish._in_screen_up = display.height + 120

Fish.m_dequeArmatureSleep = {}
Fish._drawImpactBody = false

function Fish:ctor(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, fish_tag)

    self.m_bIsAccelerate = false --是否加速
    self.m_bIsSceneTraceFish = false --标志是不是属于鱼阵类型的鱼
    self.m_bIsSceneTraceFishShowFinish = false --标识鱼阵的鱼是否展示完毕
    self.m_nSceneTraceFishShowIndex = 0   --表示鱼阵的鱼展示的阶段 0代表出生还没有游进场景 1代表在场景内，2代表游出场景

    self.fish_kind_ = fish_kind
    self.fish_id_ = fish_id
    self.fish_multiple_ = fish_multiple
    self.fish_status_ = FISH_ALIVE
    self.bounding_box_width_ = bounding_box_width
    self.bounding_box_height_ = bounding_box_height
    self.hit_radius_ = hit_radius
    self.fish_Tag_ = fish_tag
    self.trace_index_ = 1
    self.trace_index_last_ = 1
    self.m_pFishArmture = nil
    self.m_pFishSleepArmture = nil
    self.m_pQuanquanArmture = nil
    self.m_fAliveTime = 0
    self.m_bTraceFinish = false
    self.m_bDie = false
    self.m_bStop = false
    self.m_bActive = true
    self.m_nCurrSimpleFishIndex = 0
    self.m_llFishScore = 0
    self.m_bHoShouTraceAgain = false
    self.m_bPlayEffect = true
    self.m_nTraceId = 0
    self.m_fSpeedValue = 30.0
    self.m_isAccelerate = false
    self.m_bChainStatus = false
    self.m_pBoneShadow = nil
    self.m_nMovePointSecond = fish_speed
    self.m_bRedStatus = false
    self.m_fRedTime = 0
    self.m_arrShanDianFish = {}

    --记录refresh里用到的局部变量(避免临时生成变量)
    self.nMeChairID = FishDataMgr:getInstance():getMeChairID()
    self.m_bSleep = false
    self.m_fSleepTime = 0

    self.PathStep = PathStepType.PST_NONE  --玩家所处的路径状态
    self.StateTotalTime = 0                --状态持续总时间
    self.StateBeginTime = 0                --状态开始时间

    --------------
    --计算当前帧用的数据
    self.curPathIndex = 0                  --当前位移路径索引
    self.curposx = 0                        --当前帧设置位置x
    self.curposy = 0                        --当前帧设置位置y
    self.nextposx = 0                       --下帧设置位置x
    self.nextposy = 0                       --下帧设置位置y
    self.curangle = 0                       --当前设置的角度
    --------------
     
    self.lastposX = 0                      --之前设置的位置X
    self.lastposY = 0                      --之前设置的位置Y
    self.lastAngle = 0                     --之前设置的旋转角度    

    self.PathData1 = {}                    --路径1数据
    self.PathData1.PathID = 0              --路径ID
    self.PathData1.PathBeginIndex = 0      --路径开始坐标索引
    self.PathData1.PathEndIndex = 0        --路径结束坐标索引
    self.PathData1.PathData = nil          --路径数据指针
    self.PathData1.OffsetX = 0             --路径偏移X
    self.PathData1.OffsetY = 0             --路径偏移Y 
    self.PathData1.StartX = 0              --路径的起点X
    self.PathData1.StartY = 0              --路径的起点Y
    self.PathData1.MoveLine = 0            --路径是否直线（只限x轴和y轴）移动的方式，0：非直线, 1:x轴, 2:y轴

    self.PathData2 = {}                    --路径2数据 
    self.PathData2.PathID = 0
    self.PathData2.PathBeginIndex = 0 
    self.PathData2.PathEndIndex = 0
    self.PathData2.PathData = nil
    self.PathData2.OffsetX = 0
    self.PathData2.OffsetY = 0
    self.PathData2.StartX = 0              --路径的起点X
    self.PathData2.StartY = 0              --路径的起点Y
    self.PathData2.MoveLine = 0            --路径是否直线（只限x轴和y轴）移动的方式，0：非直线, 1:x轴, 2:y轴
    self.m_bFilpY = false                  --是否翻转Y轴
end

function Fish.create(paoView, fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, fish_tag)
    --local pFish = Fish.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, fish_tag)
    local pFish = DataCacheMgr:getInstance():GetFishFromFreePool(fish_kind)
    local bRepeatUse = true  -- 是否重用对象资源
    if pFish == nil then
        pFish = Fish.new()     
        local zorderDeep = fish_kind / 5
        if fish_kind == FishKind.FISH_JINCHAN or fish_kind == FishKind.FISH_SHUANGTOUQIE then -- 调整BOSS显示到最高层级
            zorderDeep = 10
        elseif fish_kind == FishKind.FISH_HAIDAN then  -- 海胆显示到中鱼层级
            zorderDeep = (FishKind.FISH_BIANFUYU + 0.5) / 5
        end
         
        pFish:addTo(paoView.m_pathUI, 10 + zorderDeep)
        bRepeatUse = false

--        local pDrawNode = cc.DrawNode:create();
--        pDrawNode:addTo(pFish, 1000)
--        local center = cc.p(0, 0)
--        local widthfish = bounding_box_width * 2
--        local heightfish = bounding_box_height * 2
--        local point1 = cc.p( center.x - widthfish / 2, center.y - heightfish / 2 )
--        local point2 = cc.p( center.x + widthfish / 2, center.y + heightfish / 2 )
--        pDrawNode:drawRect( point1, point2, cc.c4f(0, 255/255.0, 0, 1));
    end

    pFish:initData(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, fish_tag)

    if fish_kind == FishKind.FISH_DNTG or fish_kind == FishKind.FISH_PIECE then
        -- 一个盘和五个盘(同类鱼炸弹)
        pFish:initForSpecial()

    elseif fish_kind == FishKind.FISH_BGLU  then
        -- 水浒传(局部炸弹)
        pFish:initForSpecialBomb()
    else
        pFish:init(bRepeatUse)
    end
    pFish:setVisible(true)
    pFish:ShowShadow( FishDataMgr.getInstance().m_bShowShadow )
    return pFish
end  
function Fish:SetFishUnuse()
    self:setVisible(false)
    self:setPosition(cc.p(-250, -250))
    --清除击中状态
    if self.m_bRedStatus and self.m_pFishArmture ~= nil  then
        self.m_pFishArmture:setColor(cc.WHITE)
        self.m_bRedStatus = false
    end
    --清除锁定图标
    for i=1, 4 do
        local pArm = self:getChildByTag(575 + i)
        if pArm ~= nil then
            pArm:removeFromParent()
        end
    end

    self:setSleepStaus(false, 0)
    
    DataCacheMgr:getInstance():AddFishToFreePool( self, self.fish_kind_ )  
end

function Fish:initData(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, fish_tag)

    self.fish_kind_ = fish_kind
    self.fish_id_ = fish_id
    self.fish_multiple_ = fish_multiple
    self.m_nMovePointSecond = fish_speed    
    self.bounding_box_width_ = bounding_box_width
    self.bounding_box_height_ = bounding_box_height
    self.hit_radius_ = hit_radius
    self.fish_Tag_ = fish_tag

    if Fish._drawImpactBody == true then
        local color = cc.c4b(255,0,0,255)
        local layer  = cc.LayerColor:create(color, bounding_box_width * 2, bounding_box_height * 2)
        layer:setPosition(-bounding_box_width, -bounding_box_height)
        layer:addTo(self,10000)
    end

    self.m_bIsAccelerate = false --是否加速
    self.m_bIsSceneTraceFish = false --标志是不是属于鱼阵类型的鱼
    self.m_bIsSceneTraceFishShowFinish = false --标识鱼阵的鱼是否展示完毕
    self.m_nSceneTraceFishShowIndex = 0   --表示鱼阵的鱼展示的阶段 0代表出生还没有游进场景 1代表在场景内，2代表游出场景

    self.fish_status_ = FISH_ALIVE
    self.m_fAliveTime = 0
    self.m_bTraceFinish = false
    self.m_bDie = false
    self.m_bStop = false
    self.m_bActive = true
    self.m_nCurrSimpleFishIndex = 0
    self.m_llFishScore = 0
    self.m_bHoShouTraceAgain = false
    self.m_bPlayEffect = true
    self.m_nTraceId = 0
    self.m_fSpeedValue = 30.0
    self.m_isAccelerate = false
    self.m_bChainStatus = false
    self.m_bRedStatus = false
    self.m_fRedTime = 0
    self.m_arrShanDianFish = {}
    --记录refresh里用到的局部变量(避免临时生成变量)
    self.nMeChairID = FishDataMgr:getInstance():getMeChairID()
    self.m_bSleep = false
    self.m_fSleepTime = 0

    self.PathStep = PathStepType.PST_NONE  --玩家所处的路径状态
    self.StateTotalTime = 0                --状态持续总时间
    self.StateBeginTime = 0                --状态开始时间
    self.curPathIndex = 1
    self.m_bFilpY = false
    --清除击中状态
    if self.m_bRedStatus and self.m_pFishArmture ~= nil  then
        self.m_pFishArmture:setColor(cc.WHITE)
        self.m_bRedStatus = false
    end
    --清除锁定图标
    for i=1, 4 do
        local pArm = self:getChildByTag(575 + i)
        if pArm ~= nil then
            pArm:removeFromParent()
        end
    end
    self:setSleepStaus(false, 0)
end

function Fish:initForSpecialBomb()
    if self.m_pFishArmture ~= nil then
        self.m_pFishArmture:removeFromParent()
        self.m_pFishArmture = nil
    end

    local nFishTag = self:getFishTag()
    local strArmNames = {
        [0] = "bomb_zhongyitang", -- 定/忠义堂
        [1] = "bomb-shuihuzhuan", -- 局部炸弹/水浒传
    }
    local strAnimationLives = {
        [0] = "move",       -- 定/忠义堂
        [1] = "Animation1", -- 局部炸弹/水浒传
    }
    local strArmName = strArmNames[nFishTag]
    local strAnimation = strAnimationLives[nFishTag]
    if strArmName == nil or strAnimation == nil then
        return 
    end

    --炸弹动画
    self.m_pFishArmture = ccs.Armature:create(strArmName)
    self.m_pFishArmture:getAnimation():play(strAnimation)
    self.m_pFishArmture:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_pFishArmture:setPosition(cc.p(0, 0))
    self.m_pFishArmture:addTo(self, 20)

    --影子
    self.m_pBoneShadow = self.m_pFishArmture:getBone("shadow")
    if self.m_pBoneShadow then
        self.m_pBoneShadow:setOpacity(120)
    end

    return true
end

-- 特殊组合鱼
function Fish:initForSpecial()
    if self.m_pFishArmture ~= nil then
        self.m_pFishArmture:removeFromParent()
        self.m_pFishArmture = nil
    end

    --错误数据
    if self.fish_kind_ == FishKind.FISH_DNTG then
        if self.fish_Tag_ > 9 or self.fish_Tag_ < 0 then
            return false
        end
    elseif self.fish_kind_ == FishKind.FISH_PIECE then
        if self.fish_Tag_ > 9 or self.fish_Tag_ < 0 then
            return false
        end
    else
        return false
    end

    --盘盘动画
    local strPan = FishDataMgr.getInstance():getArmatureNameByFishKind(self.fish_kind_)
    local strLive = FishDataMgr.getInstance():getAnimationLiveNameByFishKind(self.fish_kind_)
    self.m_pFishArmture = ccs.Armature:create(strPan)
    self.m_pFishArmture:getAnimation():play(strLive)
    self.m_pFishArmture:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_pFishArmture:setPosition(cc.p(0, 0))
    self.m_pFishArmture:addTo(self, 20)

    --盘盘大小
    local fScale = FishDataMgr.getInstance():getFishScale(self.fish_kind_)
    self.m_pFishArmture:setScale(fScale)

    --鱼鱼动画
    local strArmName = {}        --动画名
    local strAnimationName = {}  --动作名
    local pArmScale = {}         --动画缩放
    local pArmOffset = {}        --动画偏移

    local tConfig = self:getSpecialConfig(self.fish_kind_, self.fish_Tag_)
    for i, nFishKind in ipairs(tConfig.TAG) do
        strArmName[i] = FishDataMgr:getInstance():getArmatureNameByFishKind(nFishKind)
        strAnimationName[i] = FishDataMgr:getInstance():getAnimationLiveNameByFishKind(nFishKind)
        pArmScale[i] = FishDataMgr:getInstance():getFishScale(nFishKind)

        local offset1 = FishDataMgr:getInstance():getFishOffset(nFishKind)
        local offset2 = tConfig.OFFSET[i]
        pArmOffset[i] = cc.pAdd(offset1, offset2)
    end

    for i = 1, #strArmName do
        local armature = ccs.Armature:create(strArmName[i])
        armature:getAnimation():play(strAnimationName[i])
        armature:setScale(pArmScale[i])
        armature:setPosition(pArmOffset[i])
        armature:setAnchorPoint(0.5, 0.5)
        armature:addTo(self.m_pFishArmture, 20 + 1)
    end

    self.m_pBoneShadow = self.m_pFishArmture:getBone("shadow")
    if self.m_pBoneShadow then
        self.m_pBoneShadow:setOpacity(120)
    end
    return true
end 

function Fish:init(bRepeatUse)    
    if bRepeatUse and self.fish_kind_ ~= FishKind.FISH_CHAIN  then
        return true
    end

    if self.m_pFishArmture ~= nil then
        self.m_pFishArmture:removeFromParent()
        self.m_pFishArmture = nil
    end
    if self.m_pQuanquanArmture ~= nil then
        self.m_pQuanquanArmture:removeFromParent()
        self.m_pQuanquanArmture = nil
    end

    local kindId = self:getRealFishKind()
    local strArmName = FishDataMgr:getInstance():getArmatureNameByFishKind(kindId)
    local strAnimationLive = FishDataMgr:getInstance():getAnimationLiveNameByFishKind(kindId)
    if #strArmName == 0 or #strAnimationLive == 0 then
        return false
    end
    
    --鱼动画
    self.m_pFishArmture = ccs.Armature:create(strArmName)
    self.m_pFishArmture:getAnimation():play(strAnimationLive)
    self.m_pFishArmture:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_pFishArmture:setPosition(cc.p(0,0))
    self.m_pFishArmture:addTo(self, 20)

    --鱼大小
    local fScale = FishDataMgr.getInstance():getFishScale(kindId)
    self.m_pFishArmture:setScale(fScale)

    --鱼偏移(修正动画)
    local fOffset = FishDataMgr.getInstance():getFishOffset(kindId)
    self.m_pFishArmture:setPosition(fOffset)

    --圈圈鱼
    if self.fish_kind_ == FishKind.FISH_CHAIN then
        self.m_pQuanquanArmture = ccs.Armature:create("teshuyuzhong_buyu")
        self.m_pQuanquanArmture:getAnimation():play("Animation2")
        self.m_pQuanquanArmture:setAnchorPoint(cc.p(0.5, 0.5))
        self.m_pQuanquanArmture:setPosition(cc.p(0, 0))
        self.m_pQuanquanArmture:addTo(self, 20 + 5)

        --圈圈大小
        local fScale = FishDataMgr:getInstance():getQuanQuanScale(kindId)
        self.m_pQuanquanArmture:setScale(fScale)
    end

    --影子
    self.m_pBoneShadow = self.m_pFishArmture:getBone("shadow")
    if self.m_pBoneShadow then
        self.m_pBoneShadow:setOpacity(120)
    end
    return true
end 

function Fish:initPosition( pathstep, pathIdx )
    if pathstep==PathStepType.PST_ONE and self.PathData1~=nil and self.PathData1.PathData~=nil then
        local path1 = self.PathData1
        self.curPathIndex = path1.PathBeginIndex + pathIdx
        if self.curPathIndex > path1.PathEndIndex then
            self.curPathIndex = path1.PathEndIndex
        end
        if path1.PathData[1][self.curPathIndex] == nil then
            return  -- 这个地方在bugly上报错，加个判断，具体报错原因不详
        end
        self.curposx = path1.PathData[1][self.curPathIndex] + path1.OffsetX
        self.curposy = path1.PathData[2][self.curPathIndex] + path1.OffsetY
        if self.curPathIndex < path1.PathEndIndex then
            self.nextposx = path1.PathData[1][self.curPathIndex+1] + path1.OffsetX
            self.nextposy = path1.PathData[2][self.curPathIndex+1] + path1.OffsetY
        else
            self.nextposx = self.curposx
            self.nextposy = self.curposy
        end
        self.curangle = path1.PathData[3][self.curPathIndex]
        --对鱼阵中，路径1为静止不动，路径2为移动的情况，把朝向修正路径2的朝向
        if self.m_bIsSceneTraceFish and self.PathData1.PathID == 3 and self.PathData2~=nil and self.PathData2.PathID~=0 and self.PathData2.PathData ~= nil  then
             if self.PathData2.PathData[3][1] ~= nil then
                self.curangle = self.PathData2.PathData[3][1]
             end
        end
    elseif self.PathData2~=nil then
        local path2 = self.PathData2 
        if pathstep == PathStepType.PST_TWO and path2.PathData~=nil then            
            self.curPathIndex = path2.PathBeginIndex + pathIdx
            if self.curPathIndex > path2.PathEndIndex then
                self.curPathIndex = path2.PathEndIndex
            end
            self.curposx = path2.PathData[1][self.curPathIndex] + path2.OffsetX
            self.curposy = path2.PathData[2][self.curPathIndex] + path2.OffsetY
            if self.curPathIndex < path2.PathEndIndex then
                self.nextposx = path2.PathData[1][self.curPathIndex+1] + path2.OffsetX
                self.nextposy = path2.PathData[2][self.curPathIndex+1] + path2.OffsetY
            else
                self.nextposx = self.curposx
                self.nextposy = self.curposy
            end
            self.curangle = path2.PathData[3][self.curPathIndex]
        elseif pathstep == PathStepType.PST_FREE then
            local vec = cc.pSub(cc.p(path2.StartX + path2.OffsetX, path2.StartY + path2.OffsetY), cc.p(path2.StartX, path2.StartY))
            self.curangle = math.radian2angle(cc.pGetAngle(vec, cc.p(0, 1))) + 270
            if FishDataMgr:getInstance():getMeChairID() > 1 then         --判断是否需要反转坐标
                self.curangle = self.curangle + 180
            end

            self.lastAngle = self.curangle
            self:setRotation(self.lastAngle)
            self:updateShadow(self.lastAngle)
            return
        end
    end

    local initAngle = self.curangle
    local nChairId = FishDataMgr:getInstance():getMeChairID()
    local  posx, posy = self.curposx, self.curposy
    if nChairId > 1 then         --判断是否需要反转坐标
        posx = 1334 - posx
        posy= 750 - posy
        initAngle = initAngle + 180
    end
        
    if LuaUtils.IphoneXDesignResolution then
        posx = posx / 1334 * display.width - LuaUtils.screenDiffX 
    end
                
    self:setPosition(posx, posy)
    self:setRotation(initAngle)
    self:updateShadow(initAngle)
                
    self.lastposX = posx
    self.lastposY = posy
    self.lastAngle = initAngle

    self:setFilpY()
end

function Fish:setFilpY()
    --翻转Y轴
    if self.fish_kind_ == FishKind.FISH_JINCHAN or self.fish_kind_ == FishKind.FISH_SHUANGTOUQIE then 
        local fScale = FishDataMgr.getInstance():getFishScale(self.fish_kind_)
        self.m_pFishArmture:setScaleY(fScale) 
        local startx = nil
        local endx = nil
        if self.PathData1 ~= nil and self.PathData1.PathData ~= nil then
            startx = self.PathData1.PathData[1][1]
            endx = self.PathData1.PathData[1][self.PathData1.PathEndIndex]
        end      
        -- 如果路径1的位置相同，就取路径2的位置
        if startx == endx and self.PathData2 ~= nil and self.PathData2.PathData ~= nil then
            endx = self.PathData2.PathData[1][self.PathData2.PathEndIndex]
        end
        if startx~=nil and endx~=nil and startx~=endx then
            local nChairId = FishDataMgr:getInstance():getMeChairID()
            if nChairId > 1 then         --判断是否需要反转坐标
                startx = 1334 - startx
                endx = 1334 - endx
            end
            if startx > endx then                
                self.m_pFishArmture:setScaleY(-fScale)
                self.m_bFilpY = true
            end
        end
    end
end
function Fish:setSceneTraceFish(bIsSceneTraceFish)
    self.m_bIsSceneTraceFish = bIsSceneTraceFish
end

function Fish:setAccelerate()

    local accelerate_speed = 200
    --local accelerate_time = accelerate_speed / self.m_nMovePointSecond
    self.m_nMovePointSecond = accelerate_speed
    --self.m_fAliveTime = self.m_fAliveTime / accelerate_time
    self.m_bIsAccelerate = true 

    local passTime = self.curPathIndex / self.m_nMovePointSecond
    self.StateBeginTime = cc.exports.gettime() - passTime
end 

function Fish:refreshStatus(time)

    self.m_fRedTime = self.m_fRedTime + time
    if  self.m_fRedTime > 0.05 then
        self.m_pFishArmture:setColor(cc.WHITE)
        self.m_bRedStatus = false
        self.m_fRedTime = 0
    end
end 

function Fish:refresh(curTime)    
    if self.m_bSleep or self.m_bStop or self.m_bDie then
        -- 路径还没有计算完成，先不要去去坐标数据。
        return true
    end

    if self.PathStep == PathStepType.PST_NONE then  --进入停滞状态
        if curTime > self.StateBeginTime + self.StateTotalTime then
           self.StateTotalTime = 0
           self.StateBeginTime = curTime
           self.PathStep = PathStepType.PST_ONE   
           self.curPathIndex = self.PathData1.PathBeginIndex                     
        end
        return true
    end

    --正在加速游走的鱼 只要游出屏幕就不再更新了 返回false 删除
    if self.m_bIsAccelerate and self:outScreenByPosition() then
        return false
    end
        
    local path1 = self.PathData1
    local path2 = self.PathData2

    local target = nil
    local bChangeIndex = false

    if self.PathStep == PathStepType.PST_ONE then -- 位移路径1
         local lastIndex = self.curPathIndex
         local passIndexFloat = (curTime - self.StateBeginTime) * self.m_nMovePointSecond
         local passIndexInt = math.floor(passIndexFloat)
         self.curPathIndex = passIndexInt + path1.PathBeginIndex
         
         if self.curPathIndex > path1.PathEndIndex then
            if path2.PathID==nil or path2.PathID == 0 then
                self.PathStep = PathStepType.PST_OVER --没有路径2.说明走完了
                return false
            elseif path2.PathID == MOVE_FORWARD_PATH then
                self.StateTotalTime = 0
                self.StateBeginTime = curTime
                self.curPathIndex = 0
                self.PathStep = PathStepType.PST_FREE
                local vec = cc.pSub(cc.p(path2.StartX + path2.OffsetX, path2.StartY + path2.OffsetY), cc.p(path2.StartX, path2.StartY))
                self.curangle = math.radian2angle(cc.pGetAngle(vec, cc.p(0, 1))) + 270
                self.lastAngle = self.curangle
                return true
            else 
                self.StateTotalTime = 0
                self.StateBeginTime = curTime
                self.curPathIndex = path2.PathBeginIndex
                self.PathStep = PathStepType.PST_TWO

                self:initPosition( PathStepType.PST_TWO, 0) 
--                self.curposx = path2.PathData[1][self.curPathIndex] + path2.OffsetX
--                self.curposy = path2.PathData[2][self.curPathIndex] + path2.OffsetY
--                if self.curPathIndex < path2.PathEndIndex then
--                    self.nextposx = path2.PathData[1][self.curPathIndex+1] + path2.OffsetX
--                    self.nextposy = path2.PathData[2][self.curPathIndex+1] + path2.OffsetY
--                else
--                    self.nextposx = self.curposx
--                    self.nextposy = self.curposy
--                end
--                self.curangle = path2.PathData[3][self.curPathIndex]

--                -- 切换到第2条路劲时，先把坐标和方向修正
--                local initAngle = self.curangle
--                local nChairId = FishDataMgr:getInstance():getMeChairID()
--                local  posx, posy = self.curposx, self.curposy
--                if nChairId > 1 then         --判断是否需要反转坐标
--                    posx = 1334 - posx
--                    posy= 750 - posy
--                    initAngle = initAngle + 180
--                end

--                self:setPosition(posx, posy)
--                self:setRotation(initAngle)
--                self:updateShadow(initAngle)                
--                self.lastposX = posx
--                self.lastposY = posy
--                self.lastAngle = initAngle
                return true
            end            
        end

        --路径3原地不动，可以不更新坐标和方向
        if self.m_bIsSceneTraceFish and path1.PathID == 3 and self.curPathIndex>path1.PathBeginIndex+1 then
            return true 
        end
       
        if path1.MoveLine == 0 then
            if self.curPathIndex == lastIndex then
                --把当前坐标和下个坐标做一次插值
                local indexper = passIndexFloat-passIndexInt
                target = cc.p( self.curposx * (1.0-indexper) + self.nextposx * indexper, self.curposy * (1.0-indexper) + self.nextposy * indexper )         
            else
                bChangeIndex = true
                local pathPosx = path1.PathData[1][self.curPathIndex]
                local pathPosy = path1.PathData[2][self.curPathIndex]
                if pathPosx == nil or pathPosy == nil then
                    return false  -- 这个地方在bugly上报错，加个判断，具体报错原因不详
                end
                self.curposx = pathPosx + path1.OffsetX
                self.curposy = pathPosy + path1.OffsetY
                if self.curPathIndex < path1.PathEndIndex then
                    self.nextposx = path1.PathData[1][self.curPathIndex+1] + path1.OffsetX
                    self.nextposy = path1.PathData[2][self.curPathIndex+1] + path1.OffsetY
                else
                    self.nextposx = self.curposx
                    self.nextposy = self.curposy
                end
                if self.m_bIsSceneTraceFish and path1.PathID == 3 then
                   self.curangle = self.curangle -- 鱼阵里面静止不动的鱼，朝向在初始化位置的时候已经设定，不需要重设，否则朝向可能不对
                else 
                    self.curangle = path1.PathData[3][self.curPathIndex]
                end
                if not self.m_bIsSceneTraceFish and self.m_nMovePointSecond > 30 then
                    --做1次插值计算
                    local indexper = passIndexFloat-passIndexInt
                    target = cc.p( self.curposx * (1.0-indexper) + self.nextposx * indexper, self.curposy * (1.0-indexper) + self.nextposy * indexper )
                else --速度小于30的计算
                    if self.curPathIndex - lastIndex == 1 then
                        local indexper = (passIndexFloat - passIndexInt) * 0.8
                        target = cc.p( self.curposx * (1.0-indexper) + self.nextposx * indexper, self.curposy * (1.0-indexper) + self.nextposy * indexper )
                    elseif self.curPathIndex - lastIndex == 2 then
                        target = cc.p(self.curposx, self.curposy)
                    else
                        --print("--------upfps: " .. " last: " .. lastIndex .. "  cur: " .. self.curPathIndex .. "    dis: " .. self.curPathIndex-lastIndex )
                        if self.curPathIndex > 2 then
                            self.curposx = path1.PathData[1][self.curPathIndex-1] + path1.OffsetX
                            self.curposy = path1.PathData[2][self.curPathIndex-1] + path1.OffsetY    
                        end            
                        target = cc.p(self.curposx, self.curposy)
                    end
                end
            end
       else -- 直线移动
          target = cc.p(0, 0)
          bChangeIndex, target.x, target.y = self:MoveLineRefresh(lastIndex, passIndexFloat-passIndexInt, path1)
       end
    elseif self.PathStep == PathStepType.PST_TWO then  -- 位移路径2

        local lastIndex = self.curPathIndex
        local passIndexFloat = (curTime - self.StateBeginTime) * self.m_nMovePointSecond
        local passIndexInt = math.floor(passIndexFloat)
        self.curPathIndex = passIndexInt + path2.PathBeginIndex
        if self.curPathIndex > path2.PathEndIndex then
            self.PathStep = PathStepType.PST_OVER
            return false
        end
        if path2.MoveLine == 0 then
            if self.curPathIndex == lastIndex then
                --把当前坐标和下个坐标做一次插值
                local indexper = passIndexFloat-passIndexInt
                target = cc.p( self.curposx * (1.0-indexper) + self.nextposx * indexper, self.curposy * (1.0-indexper) + self.nextposy * indexper )
            else
                bChangeIndex = true
                self.curposx = path2.PathData[1][self.curPathIndex] + path2.OffsetX
                self.curposy = path2.PathData[2][self.curPathIndex] + path2.OffsetY
                if self.curPathIndex < path2.PathEndIndex then
                    self.nextposx = path2.PathData[1][self.curPathIndex+1] + path2.OffsetX
                    self.nextposy = path2.PathData[2][self.curPathIndex+1] + path2.OffsetY
                else
                    self.nextposx = self.curposx
                    self.nextposy = self.curposy
                end
                self.curangle = path2.PathData[3][self.curPathIndex]

                if self.curPathIndex - lastIndex == 1 then
                    local indexper = ( passIndexFloat - passIndexInt ) * 0.8
                    target = cc.p( self.curposx * (1.0-indexper) + self.nextposx * indexper, self.curposy * (1.0-indexper) + self.nextposy * indexper )
                elseif self.curPathIndex - lastIndex == 2 then
                    target = cc.p(self.curposx, self.curposy)
                else
                    if self.curPathIndex > 2 then
                        self.curposx = path2.PathData[1][self.curPathIndex-1] + path2.OffsetX
                        self.curposy = path2.PathData[2][self.curPathIndex-1] + path2.OffsetY    
                    end            
                    target = cc.p(self.curposx, self.curposy)
                end
            end
       else -- 直线移动
          target = cc.p(0, 0)
          bChangeIndex, target.x, target.y = self:MoveLineRefresh(lastIndex, passIndexFloat-passIndexInt, path2)
       end
    elseif self.PathStep == PathStepType.PST_FREE then   -- 位移发散路径
        local lastIndex = self.curPathIndex
        local passTime = curTime - self.StateBeginTime
        local passIndexFloat = passTime * self.m_nMovePointSecond
        self.curPathIndex = math.floor(passIndexFloat)
        target = cc.p( path2.StartX + path2.OffsetX * passIndexFloat, path2.StartY + path2.OffsetY * passIndexFloat)
        if lastIndex ~= self.curPathIndex then
            bChangeIndex = true
        end
        self.curangle =  self.lastAngle
    end

    if target == nil then
        return true
    end
        --判断是否是鱼阵的鱼 
    if self.m_bIsSceneTraceFish and bChangeIndex then 
        if self.m_nSceneTraceFishShowIndex == 2 then 
            return false 
        end 
        if self:inScreenByPosition() then 
            self.m_nSceneTraceFishShowIndex = 1
        elseif self.m_nSceneTraceFishShowIndex == 1 then 
            self.m_nSceneTraceFishShowIndex = 2
        end 
    end

    local angle =  self.curangle
    if self.nMeChairID > 1 then         --判断是否需要反转坐标
        target.x = 1334 - target.x
        target.y = 750 - target.y
        if self.PathStep ~= PathStepType.PST_FREE then
            angle = angle + 180
        end
    end
        
    -- 适配代码
    if LuaUtils.IphoneXDesignResolution then
        target.x = target.x / 1334 * display.width - LuaUtils.screenDiffX 
    end

    if self.m_bIsSceneTraceFish then
        if self.m_nSceneTraceFishShowIndex == 0 then
            self.lastposX = target.x
            self.lastposY = target.y
            self.lastAngle = angle
            return true --不在屏幕范围内不需要设置坐标和方向
        end
    else 
        if self.m_nMovePointSecond > 30 then
            --做第2次插值计算
            local indexper = 0.7
            target = cc.p( self.lastposX * (1.0-indexper) + target.x * indexper, self.lastposY * (1.0-indexper) + target.y * indexper )
        end
    end

    self:setPosition(target)
    self.lastposX = target.x
    self.lastposY = target.y
    if bChangeIndex then
        --设置方向
        local changeAngle = self.m_bIsSceneTraceFish and 0.8 or 0.1
        if angle > self.lastAngle + changeAngle or angle < self.lastAngle - changeAngle  then        
            self:setRotation(angle)
            self.lastAngle = angle
            self:updateShadow(angle)
        end
    end

    return true
end

function Fish:MoveLineRefresh( lastIndex, indexper, path )
    local bChangeIndex = false
    local posx, posy = 0, 0
    if self.curPathIndex == lastIndex then
        if path.MoveLine == 1 then
        --把当前坐标和下个坐标做一次插值
            posx = self.curposx * (1.0-indexper) + self.nextposx * indexper
            posy = self.curposy
        else
            posx = self.curposx
            posy = self.curposy * (1.0-indexper) + self.nextposy * indexper
        end       
    else
        bChangeIndex = true
        if path.MoveLine == 1 then
            self.curposx = path.PathData[1][self.curPathIndex] + path.OffsetX
            if self.curPathIndex < path.PathEndIndex then
               self.nextposx = path.PathData[1][self.curPathIndex+1] + path.OffsetX
            else
                self.nextposx = self.curposx
            end
            --self.curangle = path.PathData[3][self.curPathIndex]
            if self.curPathIndex - lastIndex == 1 then
                indexper = indexper * 0.8
                posx = self.curposx * (1.0-indexper) + self.nextposx * indexper
                posy = self.curposy
            elseif self.curPathIndex - lastIndex == 2 then
                posx = self.curposx
                posy = self.curposy
            else
                if self.curPathIndex > 2 then
                    self.curposx = path.PathData[1][self.curPathIndex-1] + path.OffsetX  
                end            
                posx = self.curposx
                posy = self.curposy
            end
        else
            self.curposy = path.PathData[2][self.curPathIndex] + path.OffsetY
            if self.curPathIndex < path.PathEndIndex then
                self.nextposy = path.PathData[2][self.curPathIndex+1] + path.OffsetY
            else
                self.nextposy = self.curposy
            end

            if self.curPathIndex - lastIndex == 1 then
                indexper = indexper * 0.8
                posx = self.curposx 
                posy = self.curposy * (1.0-indexper) + self.nextposy * indexper
            elseif self.curPathIndex - lastIndex == 2 then
                posx = self.curposx
                posy = self.curposy
            else
                if self.curPathIndex > 2 then
                    self.curposy = path.PathData[2][self.curPathIndex-1] + path.OffsetY    
                end            
                posx = self.curposx
                posy = self.curposy
            end
        end
    end
    return bChangeIndex, posx, posy
end

function Fish:SimpleRefresh(curTime)    
    if self.m_bSleep or self.m_bStop or self.m_bDie then
        -- 路径还没有计算完成，先不要去去坐标数据。
        return true
    end

    if self.PathStep == PathStepType.PST_NONE then  --进入停滞状态
        if curTime > self.StateBeginTime + self.StateTotalTime then
           self.StateTotalTime = 0
           self.StateBeginTime = curTime
           self.PathStep = PathStepType.PST_ONE  
           self.curPathIndex = self.PathData1.PathBeginIndex                       
        end
        return true
    end
    --正在加速游走的鱼 只要游出屏幕就不再更新了 返回false 删除
    if self.m_bIsAccelerate and self:outScreenByPosition() then
        return false
    end
        
   local path1 = self.PathData1
   local path2 = self.PathData2

   local target = nil
   local bChangeIndex = false

    if self.PathStep == PathStepType.PST_ONE then -- 位移路径1
         local lastIndex = self.curPathIndex
         local passIndexFloat = (curTime - self.StateBeginTime) * self.m_nMovePointSecond
         local passIndexInt = math.floor(passIndexFloat)
         self.curPathIndex = passIndexInt + path1.PathBeginIndex
         if self.curPathIndex > path1.PathEndIndex then
            if path2.PathID==nil or path2.PathID == 0 then
                self.PathStep = PathStepType.PST_OVER --没有路径2.说明走完了
                return false
            elseif path2.PathID == MOVE_FORWARD_PATH then
                self.StateTotalTime = 0
                self.StateBeginTime = curTime
                self.curPathIndex = 0
                self.PathStep = PathStepType.PST_FREE
                local vec = cc.pSub(cc.p(path2.StartX + path2.OffsetX, path2.StartY + path2.OffsetY), cc.p(path2.StartX, path2.StartY))
                self.curangle = math.radian2angle(cc.pGetAngle(vec, cc.p(0, 1))) + 270
                self.lastAngle = self.curangle
                return true
            else 
                self.StateTotalTime = 0
                self.StateBeginTime = curTime
                self.curPathIndex = path2.PathBeginIndex
                self.PathStep = PathStepType.PST_TWO

                self:initPosition( PathStepType.PST_TWO, 0) 
--                self.curposx = path2.PathData[1][self.curPathIndex] + path2.OffsetX
--                self.curposy = path2.PathData[2][self.curPathIndex] + path2.OffsetY
--                if self.curPathIndex < path2.PathEndIndex then
--                    self.nextposx = path2.PathData[1][self.curPathIndex+1] + path2.OffsetX
--                    self.nextposy = path2.PathData[2][self.curPathIndex+1] + path2.OffsetY
--                else
--                    self.nextposx = self.curposx
--                    self.nextposy = self.curposy
--                end
--                self.curangle = path2.PathData[3][self.curPathIndex]

--                -- 切换到第2条路劲时，先把坐标和方向修正
--                local initAngle = self.curangle

--                   local nChairId = FishDataMgr:getInstance():getMeChairID()
--                local  posx, posy = self.curposx, self.curposy
--                if nChairId > 1 then         --判断是否需要反转坐标
--                    posx = 1334 - posx
--                    posy= 750 - posy
--                    initAngle = initAngle + 180
--                end

--                self:setPosition(posx, posy)
--                self:setRotation(initAngle)
--                self:updateShadow(initAngle)                
--                self.lastposX = posx
--                self.lastposY = posy
--                self.lastAngle = initAngle
                return true
            end            
        end
        
        --路径3原地不动，可以不更新坐标和方向
        if self.m_bIsSceneTraceFish and path1.PathID == 3 and self.curPathIndex>path1.PathBeginIndex+1 then
            return true 
        end

        if self.curPathIndex == lastIndex then
           return true
        else
            bChangeIndex = true
            local pathPosx = path1.PathData[1][self.curPathIndex]
            local pathPosy = path1.PathData[2][self.curPathIndex]
            if pathPosx == nil or pathPosy == nil then
                return false  -- 这个地方在bugly上报错，加个判断，具体报错原因不详
            end
            self.curposx = pathPosx + path1.OffsetX
            self.curposy = pathPosy + path1.OffsetY
            if self.m_bIsSceneTraceFish and path1.PathID == 3 then
                self.curangle = self.curangle -- 鱼阵里面静止不动的鱼，朝向在初始化位置的时候已经设定，不需要重设，否则朝向可能不对
            else 
                self.curangle = path1.PathData[3][self.curPathIndex]
            end
            target = cc.p(self.curposx, self.curposy)
        end
    elseif self.PathStep == PathStepType.PST_TWO then  -- 位移路径2

        local lastIndex = self.curPathIndex
        local passIndexFloat = (curTime - self.StateBeginTime) * self.m_nMovePointSecond
        local passIndexInt = math.floor(passIndexFloat)
        self.curPathIndex = passIndexInt + path2.PathBeginIndex
        if self.curPathIndex > path2.PathEndIndex then
            self.PathStep = PathStepType.PST_OVER
            return false
        end
        if self.curPathIndex == lastIndex then
           return true
        else
            bChangeIndex = true
            self.curposx = path2.PathData[1][self.curPathIndex] + path2.OffsetX
            self.curposy = path2.PathData[2][self.curPathIndex] + path2.OffsetY
            self.curangle = path2.PathData[3][self.curPathIndex]
            target = cc.p(self.curposx, self.curposy)
        end
    elseif self.PathStep == PathStepType.PST_FREE then   -- 位移发散路径
        local lastIndex = self.curPathIndex
        local passTime = curTime - self.StateBeginTime
        local passIndexFloat = passTime * self.m_nMovePointSecond
        self.curPathIndex = math.floor(passIndexFloat)
        target = cc.p( path2.StartX + path2.OffsetX * passIndexFloat, path2.StartY + path2.OffsetY * passIndexFloat)
        if lastIndex ~= self.curPathIndex then
           bChangeIndex = true
        end
        self.curangle =  self.lastAngle
    end

    if target == nil then
        return true
    end
        --判断是否是鱼阵的鱼 
    if self.m_bIsSceneTraceFish and bChangeIndex then 
        if self.m_nSceneTraceFishShowIndex == 2 then 
            return false 
        end 
        if self:inScreenByPosition() then 
            self.m_nSceneTraceFishShowIndex = 1
        elseif self.m_nSceneTraceFishShowIndex == 1 then 
            self.m_nSceneTraceFishShowIndex = 2
        end 
    end

    local angle =  self.curangle
    if self.nMeChairID > 1 then         --判断是否需要反转坐标
        target.x = 1334 - target.x
        target.y = 750 - target.y
        if self.PathStep ~= PathStepType.PST_FREE then
            angle = angle + 180
        end
    end
    
    -- 适配代码
    if LuaUtils.IphoneXDesignResolution then
        target.x = target.x / 1334 * display.width - LuaUtils.screenDiffX 
    end

    if self.m_bIsSceneTraceFish then
        if self.m_nSceneTraceFishShowIndex == 0 then
            self.lastposX = target.x
            self.lastposY = target.y
            self.lastAngle = angle
            return true --不在屏幕范围内不需要设置坐标和方向
        end
    end

    self:setPosition(target)
    self.lastlastPosX = self.lastposX
    self.lastlastPosY = self.lastposY
    self.lastposX = target.x
    self.lastposY = target.y
    if bChangeIndex then
        --设置方向
        if angle > self.lastAngle + 1 or angle < self.lastAngle - 1  then        
            self:setRotation(angle)
            self.lastAngle = angle
            --self:updateShadow(angle)
        end
    end

    return true
end

function Fish:setTrace(pathID, xOffset, yOffset)
    if xOffset == nil then
        xOffset = 0
    end
    if yOffset == nil then
        yOffset = 0
    end
        
    --设置路径数据,这里只有路径1，路径2为空
    self.PathData1.PathData = FishTraceMgr:getInstance().m_mapAllFishTrace[pathID]
    if self.PathData1.PathData == nil then
        return 
    end
    self.m_nTraceId = pathID

    self.PathData1.PathID = self.m_nTraceId
    self.PathData1.PathEndIndex = #self.PathData1.PathData[1]
    self.curPathIndex = 1
    self.PathData1.PathBeginIndex = 1
    self.PathData1.OffsetX = xOffset
    self.PathData1.OffsetY = yOffset
    self.PathData1.MoveLine = 0

    self.PathData2.PathID = 0
    self.m_bTraceFinish = true
    if self.m_nTraceId >= 400 and self.m_nTraceId < 500 then
        self:setSceneTraceFish(true)  -- 发散鱼阵的鱼归为鱼阵类型
    end

    --self:initPosition( PathStepType.PST_ONE, 1 )
    return 
end 

function Fish:setCatchStatus()

    -- recycle the sleep effect infunction create again.
    self:setSleepStaus(false, cc.exports.gettime())
    self.m_bDie = true
    self:stopAllActions()
    FishDataMgr:getInstance():delFish(self.fish_id_, false)

end

function Fish:playCatchEnd()
    self:stopAllActions()
    FishDataMgr:getInstance():delFish(self.fish_id_, false)
end 

function Fish:setSleepStaus(_bSleep, _nTime)
    if _bSleep then
        if #self.m_dequeArmatureSleep > 0 and self.m_pFishSleepArmture == nil then
            self.m_pFishSleepArmture = self.m_dequeArmatureSleep[#self.m_dequeArmatureSleep]
            table.remove(self.m_dequeArmatureSleep, #self.m_dequeArmatureSleep)
            self:addChild(self.m_pFishSleepArmture, 40)
        end
    else
        if self.m_pFishSleepArmture ~= nil then
            self.m_pFishSleepArmture:removeFromParent()
            table.insert(self.m_dequeArmatureSleep, self.m_pFishSleepArmture)
            self.m_pFishSleepArmture = nil
        end
    end

    --处理睡眠时间
    if _bSleep == true and self.m_bSleep == false and _nTime then
        self:setSleepMode(true)
        self:setSleepTime(_nTime)
    elseif _bSleep == false and self.m_bSleep == true and _nTime then
        self:setSleepMode(false)
        self.StateBeginTime = self.StateBeginTime + (_nTime - self.m_fSleepTime)
    end
end 

function Fish:setStopDie()

    self.m_bDie = true
    local callFunc = cc.CallFunc:create(function()
        self:setCatchStatus()
    end)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), callFunc))
end 

function Fish:setCollisionStatus()

    if self.m_bRedStatus then
        return
    end

    if self.m_pFishArmture == nil then
        return
    end

    self.m_pFishArmture:setColor(cc.RED)
    self.m_bRedStatus = true
    self.m_fRedTime = 0
end 

function Fish:setShanDianQuanDie()

    if self.m_pQuanquanArmture ~= nil  then 
        self.m_pQuanquanArmture:getAnimation():play("Animation1")
    end 
end 

function Fish:addCurrSimpleFishIndex()
    self.m_nCurrSimpleFishIndex = self.m_nCurrSimpleFishIndex + 1
end 

Fish.FishKind = {
    [0] = FishKind.FISH_WONIUYU,
    [1] = FishKind.FISH_LVCAOYU,
    [2] = FishKind.FISH_HUANGCAOYU,
    [3] = FishKind.FISH_DAYANYU,
    [4] = FishKind.FISH_HUANGBIANYU,
    [5] = FishKind.FISH_XIAOCHOUYU,
    [6] = FishKind.FISH_XIAOCIYU,
    [7] = FishKind.FISH_LANYU,
    [8] = FishKind.FISH_DENGLONGYU,
}
yl.setDefault(Fish.FishKind, FishKind.FISH_WONIUYU) --缺省蜗牛鱼

function Fish:getRealFishKind()
    
    if self.fish_kind_ == FishKind.FISH_CHAIN then
        return Fish.FishKind[self.fish_Tag_]
    end
    return self.fish_kind_
end 

function Fish:isOutScreen()
    if LuaUtils.IphoneXDesignResolution then
        if self.lastposX < - LuaUtils.screenDiffX or self.lastposX > display.width - LuaUtils.screenDiffX
        or self.lastposY < 0 or self.lastposY > display.height
        then 
            return true 
        end 
    else
        if self.lastposX < 0 or self.lastposX > display.width 
        or self.lastposY < 0 or self.lastposY > display.height
        then 
            return true 
        end 
    end
    return false
end 

function Fish:outScreenByPosition()
    if LuaUtils.IphoneXDesignResolution then
        if self.lastposX < Fish._out_screen_left - LuaUtils.screenDiffX or Fish._out_screen_right - LuaUtils.screenDiffX < self.lastposX
        or self.lastposY < Fish._out_screen_down or Fish._out_screen_up < self.lastposY
        then
            return true
        end
    else
        if self.lastposX < Fish._out_screen_left or Fish._out_screen_right < self.lastposX
        or self.lastposY < Fish._out_screen_down or Fish._out_screen_up < self.lastposY
        then
            return true
        end
    end
    return false
end

function Fish:inScreenByPosition()
    if LuaUtils.IphoneXDesignResolution then 
        if  Fish._in_screen_left - LuaUtils.screenDiffX < self.lastposX and self.lastposX < Fish._in_screen_right - LuaUtils.screenDiffX
        and Fish._in_screen_down < self.lastposY and self.lastposY < Fish._in_screen_up
        then 
            return true
        end
    else
        if  Fish._in_screen_left < self.lastposX and self.lastposX < Fish._in_screen_right
        and Fish._in_screen_down < self.lastposY and self.lastposY < Fish._in_screen_up
        then 
            return true
        end
    end
    return false
end
-- 设置鱼的影子是否可见
function Fish:ShowShadow( bShadow )
  if self.m_pBoneShadow ~= nil and tolua.isnull(self.m_pBoneShadow)==false then
        if bShadow then
            self.m_pBoneShadow:setOpacity(120)
        else
            self.m_pBoneShadow:setOpacity(0)
        end
--        self.m_pBoneShadow:getDisplayManager():setVisible(bShadow)
--        if bShadow then
--            self:updateShadow(self.lastAngle)
--        end
    end
end

function Fish:updateShadow(angle)

    if yl.isObject(self) == false or  self.m_pBoneShadow == nil then
        return
    end

    if not FishDataMgr.getInstance().m_bShowShadow then
        return
    end

    if tolua.isnull(self.m_pBoneShadow)  then
        return
    end

    if angle == nil then
        angle = self:getRotation()
    end

    local rotation = angle % 360
    if self.m_bFilpY then -- 翻转y轴的影子要与没有翻转的保持一个方向
        rotation = (angle + 180) % 360
    end
    if rotation <= 90 then
        self.m_pBoneShadow:setPosition(rotation / 2, -(90 - rotation) / 2)
    elseif rotation > 90 and rotation <= 180 then
        self.m_pBoneShadow:setPosition((180 - rotation) / 2,(rotation - 90) / 2)
    elseif rotation > 180 and rotation <= 270 then
        self.m_pBoneShadow:setPosition(-(rotation - 180) / 2,(270 - rotation) / 2)
    elseif rotation > 270 then
        self.m_pBoneShadow:setPosition(-(360 - rotation) / 2, -(rotation - 270) / 2)
    else
        self.m_pBoneShadow:setPosition(0, 0)
    end
end 

function Fish:initSleepArmatures()
    Fish.m_dequeArmatureSleep = {}
    for i = 1, 140 do
        local sleepArmature = ccs.Armature:create("zzz-dingpao_buyu")
        sleepArmature:getAnimation():play("Animation1")
        sleepArmature:setAnchorPoint(cc.p(0.5,0.5))
        sleepArmature:setPosition(cc.p(0, 0))
        sleepArmature:retain()
        Fish.m_dequeArmatureSleep[i] = sleepArmature
    end 
end

function Fish:freeSleepArmature()
    for i = 140, 1, -1 do
        if Fish.m_dequeArmatureSleep[i] then
            Fish.m_dequeArmatureSleep[i]:release()
            Fish.m_dequeArmatureSleep[i] = nil
        end
    end
    Fish.m_dequeArmatureSleep = {}
end 

function Fish:setDelay(fDelay)
    fDelay = fDelay or 0
    local passTime = fDelay
    self.PathStep = PathStepType.PST_NONE
    self.StateTotalTime = 0
    self.StateBeginTime = cc.exports.gettime() + passTime
    self:initPosition(PathStepType.PST_ONE, 1 ) 
     
    --非鱼阵的鱼，在初始化路径时，会停留在屏幕边缘，这里做位置修正
    local dissx = 0
    local dissy = 0
    if not self.m_bIsSceneTraceFish then
        if self.lastposX < 0 then 
            dissx = -50
        elseif self.lastposX > 1334 then
            dissx = 50
        end
        
        if self.lastposY < 0 then
            dissy = -50
        elseif self.lastposY > 750 then
            dissy = 50
        end
    end  
    if dissx ~= 0 or dissy ~= 0 then
        self:setPosition(self.lastposX + dissx, self.lastposY + dissy)
    end
end

function Fish:startMove( fCreateTime )
    if fCreateTime == nil then
        fCreateTime = cc.exports.gettime()
    end
    self.PathStep = PathStepType.PST_ONE
    self.StateTotalTime = 0
    self.StateBeginTime = fCreateTime
    self.curPathIndex = 1 
    
    local curTime = cc.exports.gettime()
    local passIndexInt = math.floor( (curTime - fCreateTime) * self.m_nMovePointSecond ) -- 计算经过的时间
    self:initPosition(self.PathStep, passIndexInt )   
end

function Fish:trace_index()
    return self.trace_index_
end

function Fish:setActive(Active)
    self.m_bActive = Active
end

function Fish:getActive()
    return self.m_bActive
end

function Fish:setFishKind(fishKind)
    self.fish_kind_ = fishKind
end

function Fish:getFishKind()
    return self.fish_kind_
end

function Fish:setFishStatus(FishStatus)
    self.fish_status_ = FishStatus
end

function Fish:getFishStatus()
    return self.fish_status_
end

function Fish:setID(ID)
    self.fish_id_ = ID
end

function Fish:getID()
    return self.fish_id_
end

function Fish:setMultiple(Multiple)
    self.fish_multiple_ = Multiple
end

function Fish:getMultiple()
    return self.fish_multiple_
end

function Fish:setTraceFinish(TraceFinish)
   self.m_bTraceFinish = TraceFinish
end

function Fish:getTraceFinish()
    return self.m_bTraceFinish
end

function Fish:setFishTag(FishTag)
    self.fish_Tag_ = FishTag
end

function Fish:getFishTag()
    return self.fish_Tag_
end

function Fish:setFishScore(FishScore)
    self.m_llFishScore = FishScore
end

function Fish:getFishScore()
    return self.m_llFishScore
end

function Fish:setPlayEffect(PlayEffect)
    self.m_bPlayEffect = PlayEffect
end

function Fish:getPlayEffect()
    return self.m_bPlayEffect
end

function Fish:setTraceId(TraceId)
    self.m_nTraceId = TraceId
end

function Fish:getTraceId()
    return self.m_nTraceId
end

function Fish:setAliveTime(AliveTime)
    
    if AliveTime == nil or AliveTime < 0 then 
        self.m_fAliveTime = 0
    else
        self.m_fAliveTime = AliveTime
    end 
end

function Fish:getAliveTime()
    return self.m_fAliveTime
end

function Fish:setSpeedValue(SpeedValue)
    self.m_fSpeedValue = SpeedValue
end

function Fish:getSpeedValue()
    return self.m_fSpeedValue
end

function Fish:setChainStatus(ChainStatus)
    self.m_bChainStatus = ChainStatus
end

function Fish:getChainStatus()
    return self.m_bChainStatus
end

function Fish:setRedStatus(RedStatus)
    self.m_bRedStatus = RedStatus
end

function Fish:getRedStatus()
    return self.m_bRedStatus
end

function Fish:setRedTime(RedTime)
    self.m_fRedTime = RedTime
end

function Fish:getRedTime()
    return self.m_fRedTime
end

function Fish:setMovePointSecond(MovePointSecond)
    self.m_nMovePointSecond = MovePointSecond
end

function Fish:getMovePointSecond()
    return self.m_nMovePointSecond
end

function Fish:getDie()
    return self.m_bDie            
end

function Fish:setDie(bStaus)
    self.m_bDie = bStaus
end 

function Fish:setSleepMode(bSleep)
    self.m_bSleep = bSleep
end

function Fish:setSleepTime(nTime)
    self.m_fSleepTime = nTime
end

--大闹天宫佛手路径
function Fish:MoveNextPath(curTime, bfirst)
    self.StateTotalTime = 0
    self.StateBeginTime = curTime
    self.curPathIndex = 1
    self.PathStep = PathStepType.PST_FREE

    if bfirst then
        self.curposx = self.PathData1.PathData[1][self.PathData1.PathEndIndex-1]
        self.curposy = self.PathData1.PathData[2][self.PathData1.PathEndIndex-1]
        self.nextposx = self.PathData1.PathData[1][self.PathData1.PathEndIndex]
        self.nextposy = self.PathData1.PathData[2][self.PathData1.PathEndIndex]
    end

    local vec1 = cc.p(self.curposx, self.curposy)
    local vec2 = cc.p(self.nextposx, self.nextposy)
    local vec = cc.pSub(vec2, vec1)
    local angle = math.radian2angle(cc.pGetAngle(vec, cc.p(0, 1)))

    --计算转角
    local nextangle = FishDataMgr.getInstance():getTanSheAngle(cc.p(self.nextposx, self.nextposy), math.angle2radian(angle))
    --计算佛手路径
    local trace_vertor = MathAide:BuildLinearHoShou(self.nextposx, self.nextposy, nextangle, 108 / 30)
    -- 获得目标点
    local nIndex = #trace_vertor[1]
    local x, y = trace_vertor[1][nIndex], trace_vertor[2][nIndex]
    local distance = math.abs(cc.pGetDistance(cc.p(self.nextposx, self.nextposy), cc.p(x, y)))
    
    --起点
    self.PathData2.StartX = self.nextposx
    self.PathData2.StartY = self.nextposy
    --点数
    self.PathData2.PathEndIndex = distance / (108 / 30)
    --偏移值
    self.PathData2.OffsetX = (x - self.PathData2.StartX) / self.PathData2.PathEndIndex
    self.PathData2.OffsetY = (y - self.PathData2.StartY) / self.PathData2.PathEndIndex

    --设置
    nextangle = math.radian2angle(nextangle) + 270
    self:setRotation(nextangle)
    self.lastAngle = nextangle
    self:updateShadow(nextangle)
    self.curposx = self.nextposx
    self.curposy = self.nextposy
    self.nextposx = x
    self.nextposy = y
end

function Fish:GetNextPoint(init_x, init_y, angle, distance)
    local visbleSize = display.size

--    if init_x < 0 then
--        init_x = 0
--    end
--    if init_x > visbleSize.width then
--        init_x = visbleSize.width
--    end
--    if init_y < 0 then
--        init_y = 0
--    end
--    if init_y > visbleSize.height then
--        init_y = visbleSize.height
--    end

    local pointAngle = { }
    if angle >= 0 and angle <= M_PI / 2 then

        pointAngle.x = init_x + math.sin(angle) * distance
        pointAngle.y = init_y + math.cos(angle) * distance

    elseif angle > M_PI_2 and angle <= M_PI then

        local anglel = angle - M_PI_2
        pointAngle.x = init_x + math.cos(anglel) * distance
        pointAngle.y = init_y - math.sin(anglel) * distance

    elseif angle > M_PI and angle <= (M_PI_2 * 3) then

        local anglel = angle - M_PI
        pointAngle.x = init_x - math.sin(anglel) * distance 
        pointAngle.y = init_y - math.cos(anglel) * distance

    elseif angle >(M_PI_2 * 3) and angle <=(M_PI * 2) then

        local anglel =(M_PI * 2) - angle
        pointAngle.x = init_x - math.sin(anglel) * distance
        pointAngle.y = init_y + math.cos(anglel) * distance
    end
--    if pointAngle.x <= 0 or pointAngle.x >= visbleSize.width or pointAngle.y <= 0 or pointAngle.y >= visbleSize.height then

--        if pointAngle.x < 0 then
--            pointAngle.x = 0
--        end
--        if pointAngle.x > visbleSize.width then
--            pointAngle.x = visbleSize.width
--        end
--        if pointAngle.y < 0 then
--            pointAngle.y = 0
--        end
--        if pointAngle.y > visbleSize.height then
--            pointAngle.y = visbleSize.height
--        end
--    end
    return pointAngle.x, pointAngle.y
end

function Fish:getSpecialConfig(kind, tag) -- 盘盘鱼配置
    local tConfig = {}
    if kind == FishKind.FISH_DNTG then --大闹天宫
        tConfig = { 
            ["TAG"] = {
                tag,
            },
            ["OFFSET"] = {
                cc.p(0, 0),
            },
        }
    elseif kind == FishKind.FISH_YJSD then --一箭双雕(李逵捕鱼里没有)
        tConfig = {
            ["TAG"] = {
                Fish.m_cbMixFishDateType1[tag][0],
                Fish.m_cbMixFishDateType1[tag][1],
            },
            ["OFFSET"] = {
                cc.p(0, -30),
                cc.p(0, 30),
            },
        }
    elseif kind == FishKind.FISH_YSSN then --一石三鸟(李逵捕鱼里没有)
        tConfig = {
            ["TAG"] = {
                Fish.m_cbMixFishDateType2[tag][0],
                Fish.m_cbMixFishDateType2[tag][1],
                Fish.m_cbMixFishDateType2[tag][2],
            },
            ["OFFSET"] = {
                cc.p(0, -50),
                cc.p(0, 0),
                cc.p(0, 50),
            },
        }
    elseif kind == FishKind.FISH_PIECE then --金玉满堂(大闹天宫里没有)
        tConfig = {
            ["TAG"] = {
                Fish.m_cbMixFishDateType3[tag][0],
                Fish.m_cbMixFishDateType3[tag][1],
                Fish.m_cbMixFishDateType3[tag][2],
                Fish.m_cbMixFishDateType3[tag][3],
                Fish.m_cbMixFishDateType3[tag][4],
            },
            ["OFFSET"] = {
                cc.p(-75, -85), 
                cc.p(75, -85), 
                cc.p(0, 0), 
                cc.p(-75, 85), 
                cc.p(75, 85),
            },
        }
    end
    return tConfig
end

return Fish

-- endregion
