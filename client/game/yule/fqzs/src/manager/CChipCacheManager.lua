--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--投注筹码缓存池管理，用于重用投注和飞行的筹码
--endregion

local CChipCacheManager = class("CChipCacheManager")

CChipCacheManager.instance_ = nil 

function CChipCacheManager.getInstance()
	if CChipCacheManager.instance_ == nil then
		CChipCacheManager.instance_ = CChipCacheManager:new()
	end
	return CChipCacheManager.instance_
end

function CChipCacheManager:ctor()
    self.m_chipPool = {} -- 筹码对象缓存池
    self.m_createChipFun = nil -- 委托构造筹码对象方法
    self.m_chipZOrder = 0 -- 筹码的层级
end

--[Comment]
-- 释放CChipCacheManager
-- removeChip: 是否调用removeFromParent释放管理的对象而不仅仅是清空缓存池引用
--            默认false
function CChipCacheManager.releaseInstance(removeChip)
    CChipCacheManager.getInstance():Clear(removeChip)
    CChipCacheManager.instance_ = nil
end

--[Comment]
-- 清空缓存池
-- removeChip: 是否调用removeFromParent释放管理的对象而不仅仅是清空缓存池引用
--             调用removeFromParent会造成缓存池中所有对象通过lua层调用一遍c++的remove
--             尽量使用父节点的removeAllChildren
--             默认false
function CChipCacheManager:Clear(removeChip)
    if removeChip then
        for k, v in pairs(self.m_chipPool) do    
           if v ~= nil then
              for index, value in pairs(v) do
                 if value ~= nil then
                     value:removeFromParent()
                 end
               end  
           end
        end
    end
    self.m_chipPool = {}
end

--[Comment]
-- 隐藏所有的筹码
function CChipCacheManager:HideAll()
    for k, v in pairs(self.m_chipPool) do    
       if v ~= nil then
          for index, value in pairs(v) do
             if value ~= nil then
                 value:setVisible(false)
             end
           end  
       end
    end
end

--[Comment]
-- 获取一个筹码对象
-- nIndex: 筹码类型索引
function CChipCacheManager:getChip(nIndex)
    self.m_chipZOrder = self.m_chipZOrder + 1
    if nil == self.m_chipPool[nIndex] then
        self.m_chipPool[nIndex] = {}
    end

    local sp = nil
    if 0 == #self.m_chipPool[nIndex] then
        assert(self.m_createChipFun, "CChipCacheManager cachepool is empty, create new object need setCreateChipDelegate...")
        sp = self.m_createChipFun(nIndex)
        assert(sp, "CChipCacheManager create new object fail, plese check setCreateChipDelegate...")
    else
        sp = table.remove(self.m_chipPool[nIndex])
    end

    sp:setLocalZOrder(self.m_chipZOrder)

    return sp
end

--[Comment]
-- 放入一个筹码对象
-- nIndex: 筹码类型索引
function CChipCacheManager:putChip(sp, nIndex)
    if nil == self.m_chipPool[nIndex] then
        self.m_chipPool[nIndex] = {}
    end
    table.insert(self.m_chipPool[nIndex], sp)
end

--[Comment]
-- 设置委托构造筹码方法
-- func: function(nIndex) return sprite end
function CChipCacheManager:setCreateChipDelegate(func)
    self.m_createChipFun = func
end

--[Comment]
-- 重置筹码层级
function CChipCacheManager:resetChipZOrder()
    self.m_chipZOrder = 0
end

function CChipCacheManager:getCacheNum()
    local num = 0
    for k, v in pairs(self.m_chipPool) do    
       if v then
          for index, value in pairs(v) do
             if value then
                 num = num + 1
             end
           end  
       end
    end
    return num
end

return CChipCacheManager