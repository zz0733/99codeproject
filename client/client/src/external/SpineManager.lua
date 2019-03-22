--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local SpineManager = class("SpineManager")

SpineManager.g_instance = nil
function SpineManager.getInstance()
    if SpineManager.g_instance == nil then
        SpineManager.g_instance = SpineManager:new()
    end
    return SpineManager.g_instance
end

function SpineManager.releaseInstance()
    SpineManager.g_instance = nil
end

function SpineManager:ctor()
    self.m_pSkeleData = {}

    self.m_bSupportPreLoad = self:supportPreload()
end

function SpineManager:Clear()
    self.m_pSkeleData = {}
end

function SpineManager:preloadSpine(spineName)
   --如果是2.0.0以上的版本,可以预加载,先把sipne预加载到内存
   if self.m_bSupportPreLoad then
        if self.m_pSkeleData[spineName]  == nil then
            local strJson = string.format("%s.json", spineName)
            local strAtlas = string.format("%s.atlas", spineName)
            self.m_pSkeleData[spineName] = sp.SkeletonAnimation:create(strJson, strAtlas)
        end
   else
        --如果只是2.0.0以下的版本，可以预加载一下动画图片
        display.loadImage(string.format("%s.png", spineName))
   end
end

function SpineManager:getSpine(spineName)
   local armature = nil 
   if self.m_bSupportPreLoad then
       local skeleData = self.m_pSkeleData[spineName]
       if skeleData == nil then
            self:preloadSpine(spineName)
       end
       if not self.m_pSkeleData[spineName] then return nil end
       armature = sp.SkeletonAnimation:create(self.m_pSkeleData[spineName])
   else
       armature = sp.SkeletonAnimation:create(spineName..".json", spineName..".atlas", 1)
   end
   return armature
end

function SpineManager:supportPreload()
--    if CommonUtils.getInstance():formatAppVersion() >= 20000 then
--        return true
--    end
    return false
end

function SpineManager:isSupportPreload()
    
    return self.m_bSupportPreLoad
end

return SpineManager

--endregion
