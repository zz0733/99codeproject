--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local DataCacheMgr = class("DataCacheMgr")

DataCacheMgr.instance_ = nil 
function DataCacheMgr.getInstance()
	if DataCacheMgr.instance_ == nil then
		DataCacheMgr.instance_ = DataCacheMgr:new()
	end
	return DataCacheMgr.instance_
end

function DataCacheMgr.releaseInstance()
    DataCacheMgr.getInstance():Clear()
    DataCacheMgr.instance_ = nil
end

function DataCacheMgr:ctor()
   self.m_updateTime = 0
   self.m_FreeFishPool = {}     --空闲鱼缓存,根据鱼的kind_id来分类缓存
   self.m_FreeBulletPool = {}   --空闲子弹缓存，根据子弹的类型来分类缓存
   self.m_FreeNetPool = {}      --空闲渔网缓存，统一缓存
   self.m_FreeNumberPool = {}   --场景里面冒数字的缓存，分金币和银币两种类型缓存
   self.m_PlayRaiseSoundPool = {0, 0, 0}    --金币弹起声音管理，最多只同时播放3个金币声音
   self.m_PlaySoundPool = {0, 0, 0}    --金币落袋声音管理，最多只同时播放3个金币声音
end

function DataCacheMgr:Clear()
   for k, v in pairs(self.m_FreeBulletPool) do    
      if v ~= nil then
         for index, value in pairs(v) do
            if value ~= nil then
                value:removeFromParent()
            end
          end  
      end
   end

   for k, v in pairs(self.m_FreeFishPool) do    
      if v ~= nil then
         for index, value in pairs(v) do
            if value ~= nil then
                value:removeFromParent()
            end
          end  
      end
   end

    for index, value in pairs(self.m_FreeNetPool) do
        if value ~= nil then
            value:removeFromParent()
        end
    end  

   for k, v in pairs(self.m_FreeNumberPool) do    
      if v ~= nil then
         for index, value in pairs(v) do
            if value ~= nil then
                value:removeFromParent()
            end
          end  
      end
   end

   self.m_FreeFishPool = {}
   self.m_FreeBulletPool = {}
   self.m_FreeNetPool = {}
   self.m_FreeNumberPool = {}
   self.m_PlaySoundPool = {0,0,0}
   self.m_PlayRaiseSoundPool = {0, 0, 0}
end

------鱼缓存相关-----------
-- @desc: 添加一个鱼对象到缓存池，添加到表尾部
-- @param objdata：对象数据 
-- @param objtype：对象类型
function DataCacheMgr:AddFishToFreePool( objdata, objtype )
    if objdata == nil then
        return
    end
    
    if  self.m_FreeFishPool[ objtype ] == nil then
        self.m_FreeFishPool[ objtype ] = {}
    end 


    for k, v in pairs( self.m_FreeFishPool[ objtype ] ) do 
       if v == objdata then
            print("---------------freefish error: " .. objtype )
            return
       end
    end
    if #self.m_FreeFishPool[ objtype ] >= 20 then -- 最多每个类型的数量20
        objdata:removeFromParent()
        return
    end

    table.insert( self.m_FreeFishPool[ objtype ], objdata )  
    --print("%%%%%%%%%%%%%%%%% addfish:  num: " .. #self.m_FreeFishPool[ objtype ] .. "  type: " .. objtype )
end

-- @desc: 从缓存池取出一个空闲鱼对象，从表尾部取出
-- @param objtype： 对象类型
-- @return：对象 
function DataCacheMgr:GetFishFromFreePool( objtype )
   if  self.m_FreeFishPool[ objtype ] == nil then
       self.m_FreeFishPool[ objtype ] = {}
   end 
   local obj = nil
   local poolLen = #self.m_FreeFishPool[ objtype ]
   if poolLen > 0 then
        obj = table.remove( self.m_FreeFishPool[ objtype ] )
        --print("%%%%%%%%%%%%%%%%% removefish: " .. #self.m_FreeFishPool[ objtype ] .. "  type: " .. objtype  )
   end   
   return obj
end

------子弹缓存相关-----------
-- @desc: 添加一个子弹对象到缓存池，添加到表尾部
-- @param objdata：对象数据 
-- @param objtype：对象类型
function DataCacheMgr:AddBulletToFreePool( objdata, objtype )
    if objdata == nil then
        return
    end
    
    if  self.m_FreeBulletPool[ objtype ] == nil then
        self.m_FreeBulletPool[ objtype ] = {}
    end 

    for k, v in pairs( self.m_FreeBulletPool[ objtype ] ) do 
       if v == objdata then
            print("---------------AddBulletToFreePool error:: m_nBulletId:" .. objdata.m_nBulletId .. "  m_nBulletTempId: " .. objdata.m_nBulletTempId )
            return
       end
    end

    if #self.m_FreeBulletPool[ objtype ] >= 40 then -- 最多每个类型的数量40
        objdata:removeFromParent()
        return
    end
    table.insert( self.m_FreeBulletPool[ objtype ], objdata )  
    --print("%%%%%%%%%%%%%%%%% addBullet:  num: " .. #self.m_FreeBulletPool[ objtype ] .. "  type: " .. objtype )
end

-- @desc: 从缓存池取出一个空闲子弹对象，从表尾部取出
-- @param objtype： 对象类型
-- @return：子弹对象 
function DataCacheMgr:GetBulletFromFreePool( objtype )
   if  self.m_FreeBulletPool[ objtype ] == nil then
       self.m_FreeBulletPool[ objtype ] = {}
   end 
   local Obj = nil
   local poolLen = #self.m_FreeBulletPool[ objtype ]
   if poolLen > 0 then
        Obj = table.remove( self.m_FreeBulletPool[ objtype ] )
        --print("%%%%%%%%%%%%%%%%% removeBullet: " .. #self.m_FreeBulletPool[ objtype ] .. "  type: " .. objtype  )
   end   
   return Obj
end
--------------------------------

------渔网缓存相关-----------
-- @desc: 添加一个渔网对象到缓存池，添加到表尾部
-- @param obj：渔网对象 
function DataCacheMgr:AddNetToFreePool( objdata )
    if objdata == nil then
        return
    end
    
    if  self.m_FreeNetPool == nil then
        self.m_FreeNetPool = {}
    end 
    
    if #self.m_FreeNetPool >= 40 then -- 最多每个类型的数量40
        objdata:removeFromParent()
        return
    end
    table.insert( self.m_FreeNetPool, objdata )  
    --print("%%%%%%%%%%%%%%%%% addNet:  num: " .. #self.m_FreeNetPool )
end

-- @desc: 从缓存池取出一个空闲渔网对象，从表尾部取出
-- @return：渔网对象 
function DataCacheMgr:GetNetFromFreePool( )
   if  self.m_FreeNetPool == nil then
       self.m_FreeNetPool = {}
   end 
   local obj = nil
   local poolLen = #self.m_FreeNetPool
   if poolLen > 0 then
        obj = table.remove( self.m_FreeNetPool )
        --print("%%%%%%%%%%%%%%%%% removeNet:  num: " .. #self.m_FreeNetPool )
   end   
   return obj
end
--------------------------------

------场景冒数字缓存相关-----------
-- @desc: 添加一个数字对象到缓存池，添加到表尾部
-- @param objdata：对象数据 
-- @param objtype：对象类型,1表示金币，2表示银币
function DataCacheMgr:AddNumberToFreePool( objdata, objtype )
    if objdata == nil then
        return
    end
    if objtype == 1 or objtype == 2 then 
        if  self.m_FreeNumberPool[ objtype ] == nil then
            self.m_FreeNumberPool[ objtype ] = {}
        end 
        table.insert( self.m_FreeNumberPool[ objtype ], objdata )  
        --print("%%%%%%%%%%%%%%%%% addNumber:  num: " .. #self.m_FreeNumberPool[ objtype ] .. "  type: " .. objtype )
    end
end

-- @desc: 从缓存池取出一个空闲数字对象，从表尾部取出
-- @param objtype：对象类型,1表示金币，2表示银币
-- @return：对象 
function DataCacheMgr:GetNumberFromFreePool( objtype )
   if  self.m_FreeNumberPool[ objtype ] == nil then
       self.m_FreeNumberPool[ objtype ] = {}
   end 
   local Obj = nil
   local poolLen = #self.m_FreeNumberPool[ objtype ]
   if poolLen > 0 then
        Obj = table.remove( self.m_FreeNumberPool[ objtype ] )
        --print("%%%%%%%%%%%%%%%%% removeNumber: " .. #self.m_FreeNumberPool[ objtype ] .. "  type: " .. objtype  )
   end   
   return Obj
end
--------------------------------
--判断是否播放弹起金币的音效
function DataCacheMgr:PlayGoldRaiseSound( )
    for i=1, #self.m_PlayRaiseSoundPool do
        if self.m_PlayRaiseSoundPool[i] == 0 then 
            self.m_PlayRaiseSoundPool[i] = self.m_updateTime
            return true
        end
    end
    return false
end

--判断是否播放获得金币的音效
function DataCacheMgr:PlayGoldGetSound( )
    for i=1, #self.m_PlaySoundPool do
        if self.m_PlaySoundPool[i] == 0 then 
            self.m_PlaySoundPool[i] = self.m_updateTime
            return true
        end
    end
    return false
end

--更新管理池
function DataCacheMgr:updateDataCacheMgr( )
   self.m_updateTime = cc.exports.gettime()
   for i=1, #self.m_PlayRaiseSoundPool do
       if self.m_PlayRaiseSoundPool[i] > 0 then
            if self.m_updateTime  > self.m_PlayRaiseSoundPool[i] + 2.1 then --2.1秒后消失
                self.m_PlayRaiseSoundPool[i] = 0
            end
       end
   end

   for i=1, #self.m_PlaySoundPool do
       if self.m_PlaySoundPool[i] > 0 then
            if self.m_updateTime  > self.m_PlaySoundPool[i] + 1.1 then --1.1秒后消失
                self.m_PlaySoundPool[i] = 0
            end
       end
   end
end

function DataCacheMgr:PrintData()
    local num = 0
    for k, v in pairs(self.m_FreeBulletPool) do    
      if v ~= nil then
        num = num + table.nums(v) 
      end
   end
   print("DataCacheMgr:m_FreeBulletPool:" .. num )
   num = 0
   for k, v in pairs(self.m_FreeFishPool) do    
      if v ~= nil then
      num = num + table.nums(v) 
      end
   end
   print("DataCacheMgr:m_FreeFishPool:" .. num )
   num = table.nums(self.m_FreeNetPool)
   print("DataCacheMgr:m_FreeNetPool:" .. num )
   num = 0
   for k, v in pairs(self.m_FreeNumberPool) do    
      if v ~= nil then
        num = num + table.nums(v)  
      end
   end
   print("DataCacheMgr:m_FreeNumberPool:" .. num )
   num = 0
end

return DataCacheMgr
--endregion
