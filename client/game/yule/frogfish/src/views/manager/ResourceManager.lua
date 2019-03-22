--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local ResourceManager = class("ResourceManager")

ResourceManager.instance_ = nil
function ResourceManager.getInstance()
    if ResourceManager.instance_ == nil then
        ResourceManager.instance_ = ResourceManager:new()
    end
    return ResourceManager.instance_
end 

function ResourceManager.releaseInstance()
    ResourceManager.getInstance().m_vecPaths = {}
    ResourceManager.getInstance().m_vecAllArmature = {}
    ResourceManager.instance_ = nil
end

function ResourceManager:ctor()
    self.m_vecPaths = {}
    self.m_vecAllArmature = {}
end

-- 通过第一张图片创建动画序列帧
-- 传入 fish17/d_1.png
function ResourceManager.getAnimationByFirstName(_frameFirstName)
    -- "fish17/d_1.png"
    -- 计算出长度动画长度
    local _fileNameAndExtName = string.split(_frameFirstName,".")
    local _fileName = _fileNameAndExtName[1] -- fish17/d_1
    local _extName = _fileNameAndExtName[2] -- png
    local _fileNameFirstAndVar = string.split(_fileNameAndExtName[1],"_")
    local _fileNameFirst = _fileNameFirstAndVar[1] -- fish17/d
    local _framesCount = 1; --图片计数器

    while true do
        local _newFileName = _fileNameFirst .. "_" .. _framesCount .. "." .. _extName
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(_newFileName)
        if not frame then
            _framesCount = _framesCount - 1
            break
        end
        _framesCount = _framesCount + 1
    end

    local _newVarFileName = _fileNameFirst .. "_" .. "%d" .. "." .. _extName
    local frameAnimation = display.getAnimationCache(_frameFirstName)
    if not frameAnimation then  
        local frames = display.newFrames(_newVarFileName,1,_framesCount)
        local animation = display.newAnimation(frames,0.5/5)
        display.setAnimationCache(_frameFirstName,animation)
    end

   return display.getAnimationCache(_frameFirstName)
end

-- 取得骨骼动画 播放后在N秒后删除  
-- 动画 时间内删除
-- 动画 0 循环播放
function ResourceManager.getArmatureWithPlayEndAutoRemove(_armature,_time)

    local armature = ccs.Armature:create(_armature)

    if _time <= 0 then
        armature:getAnimation():playWithIndex(0, 0, 1) --循环
    else
        armature:getAnimation():playWithIndex(0, -1, 0) --不循环
        armature:runAction(cc.Sequence:create(cc.DelayTime:create(_time),cc.CallFunc:create(function ()
            armature:removeFromParent()
        end)))
    end

    return armature
end

function ResourceManager.getArmatureWithPlayEndAutoRemoveUseName(_armature,_name,_time)

    local armature = ccs.Armature:create(_armature)

    if _time <= 0 then
        armature:getAnimation():play(_name, 0, 1) --循环
    else
        armature:getAnimation():play(_name, -1, 0) --不循环
        armature:runAction(cc.Sequence:create(cc.DelayTime:create(_time),cc.CallFunc:create(function ()
          armature:removeFromParent()
        end)))
    end
    return armature
end

-- armaturePaths 存放骨骼动画路径的数组
-- bAdd 是否需要添加到全局控制里面
function ResourceManager:loadFileData(armaturePaths, bAdd)

    for i = 1, #armaturePaths do

        local path = armaturePaths[i]
        table.insert(self.m_vecPaths, path)
        if bAdd then
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
        end
    end
    return true
end 

function ResourceManager:getPathCount()

    return table.nums(self.m_vecPaths)
end 

function ResourceManager:getPathAtIndex(index)

    return self.m_vecPaths[index]
end 

function ResourceManager:Clear()

    self:cleanFileData()
end 

function ResourceManager:cleanFileData()

    for i = 1,#self.m_vecPaths do 

        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(self.m_vecPaths[i])
    end 
    self.m_vecPaths = {}
    self.m_vecAllArmature = {}
end 

-- _name 骨骼动画名字
-- _pos 骨骼动画位置
-- bControl 是否接受全局控制
function ResourceManager:creatEffect(armatureName ,  armaturePos,  bControl)

    local armature = ccs.Armature:create(armatureName)
    armature:setPosition(armaturePos)
    if bControl then 
        table.insert(self.m_vecAllArmature, armature)
    end 
    return armature
end 

function ResourceManager:removeEffect(pArmature)

    if pArmature ~= nil then 
        pArmature:stopAllActions()
        pArmature:removeFromParent()
        pArmature = nil 
        return true
    end 
    return false
end 

function ResourceManager:creatEffectWithDelegate(parent,  armatureName , playAnimationName,  bControl,  armaturePos,  zorder)

    if parent == nil or string.len(armatureName) <= 0 or string.len(playAnimationName) <= 0 then 

        print("creat effect error.")
        return nil 
    end 
    --[[
    auto armData = ArmatureDataManager::getInstance()->getAnimationData(_name);
    if(armData == nullptr)
        return nullptr;
    ]]
    local armature = self:creatEffect(armatureName, armaturePos, bControl)
    armature:getAnimation():play(playAnimationName)
    parent:addChild(armature,zorder)
    
    return armature
end 

return ResourceManager
--endregion
