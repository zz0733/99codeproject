--region *.lua
--Date 2016-8-30
--Author xufei
--此文件由[BabeLua]插件自动生成

--[[
	全局的控制与协调类
	由于是全局的实例，所以在代码中直接使用SLFacade获取到的就是此类的实例

	1、框架的事件监听注册与移除，事件派发功能
	(此功能块的EventDispatcher与cocos引擎的EventDispatcher实例相互独立互不影响)
		<code>
			a.事件监听
				-- private
				SLFacade:addEventListener(eventListener)
				-- public
			 	SLFacade:addCustomEventListener(eventName, eventCallback, target)
			 	
			 b.事件移除
			 	-- public (目前项目中有用到)
			 	SLFacade:removeEventListener(eventListener, eventName)
			 	-- public
			 	SLFacade:removeCustomEventListener(eventName, target)

			 c.事件派发
			  	-- private
			 	SLFacade:dispatchEvent(event)
			 	-- public
			 	SLFacade:dispatchCustomEvent(eventName, param_list)

		</code>
	
	2、引擎范围内的事件监听注册与移除，事件派发功能
	(此模块使用cocos引擎的EventDispatcher实例进行操作)
		<code>
			a.事件监听
				SLFacade:addGlobalEventListener(eventListener)
			 	SLFacade:addGlobalCustomEventListener(eventName, eventCallback)
			 	
			 b.事件移除
			 	SLFacade:removeGlobalEventListener(eventListener)
			 	SLFacade:removeGlobalCustomEventListener(eventName)

			 c.事件派发
			 	SLFacade:dispatchGlobalEvent(event)
			 	SLFacade:dispatchGlobalCustomEvent(eventName, param_list)

		</code>

	TODO:是否有场景管理方面的需求统一放在此处进行管理的情况
--]]

local SLFacade = class("SLFacade")

function SLFacade:ctor()
	-- body
	self:init()
end

function SLFacade:init()
	-- body
	self._eventDispatcher = cc.EventDispatcher:new();
	assert(self._eventDispatcher)
	self._eventDispatcher:retain()
	self:setEventDispatcherEnabled(true)

	-- 初始化时，设置系统随机种子
	math.randomseed(os.time())

	------------------
	-- add by JackyXu.
	-- 记录监听列表
	self._eventListenners = {}
end

-- framework EventDispatcher
-- 获取framework事件派发器实例
function SLFacade:getEventDispatcher()
	-- body
	assert(self._eventDispatcher)
	return self._eventDispatcher;
end

-- 设置frameframework事件派发器是否可用
-- enabled[boolean] - true:可用；false:不可用
function SLFacade:setEventDispatcherEnabled(enabled)
	-- body
	assert(type(enabled) == "boolean")
	self:getEventDispatcher():setEnabled(enabled)
end

-- 添加事件监听器
function SLFacade:addEventListener(eventListener)
	-- body
--    local kind = 
--	if not iskindof(eventListener, "cc.EventListener") then
--		print("<SLFacade | addEventListener - argument(eventListener) is not kind of cc.EventListener")
--		return
--	end

	self:getEventDispatcher():addEventListenerWithFixedPriority(eventListener, 1)
end

-- 添加自定义的事件监听器
-- eventName - 事件名
-- eventCallback - 事件回调
-- target - layer tag
function SLFacade:addCustomEventListener(eventName, eventCallback, target)
	-- body
	assert(type(eventName) == "string" and type(eventCallback) == "function")
	if string.len(eventName) == 0 then
		print("<SLFacade | registerEvent -- eventName is empty.")
		return
	end

	---------------------
	-- add by JackyXu.
	local strTag = tostring(target)
	if type(target) == "string" and strTag and string.len(strTag) > 0 then
		self._eventListenners[eventName] = self._eventListenners[eventName] or {}
		local cached = self._eventListenners[eventName]
		for index, v in pairs(cached) do
			if v.tag == strTag then -- 同一 layer 只能注册一次
				local eventListener = v.listener
				if iskindof(eventListener, "cc.EventListener") then
					self:getEventDispatcher():removeEventListener(eventListener)
				end
				table.remove(cached, index)
				break
			end
		end
	end
	---------------------

	local listener = cc.EventListenerCustom:create(eventName, eventCallback)
	self:addEventListener(listener, 1)

	---------------------
	-- add by JackyXu.
	if type(target) == "string" and strTag and string.len(strTag) > 0 then
		local cached = self._eventListenners[eventName]
		table.insert(cached, {eventName = eventName; listener = listener; tag = strTag})
	end
	---------------------

	return listener
end

-- 移除事件监听器
function SLFacade:removeEventListener(eventListener, eventName)
	-- body
	if not iskindof(eventListener, "cc.EventListener") then
		print("<SLFacade | addEventListener - argument(eventListener) is not kind of cc.EventListener")
		return
	end

	---------------------
	-- add by JackyXu.
	if type(eventName) == "string" and string.len(eventName) > 0 then
		local cached = self._eventListenners[eventName] or {}
		local nIndex = -1
		for index, v in pairs(cached) do
			if v.listener == eventListener then
				nIndex = index
				break
			end
		end
		if nIndex ~= -1 then
			table.remove(cached, nIndex)
		end
	end
	---------------------

	self:getEventDispatcher():removeEventListener(eventListener)
end

-- 通过 eventName 和 target 移除事件监听器
function SLFacade:removeCustomEventListener(eventName, target)
	-- body
	if type(eventName) ~= "string" and string.len(eventName) == 0 then
		print("<SLFacade | removeEvent -- eventName is empty.")
		return
	end
	if type(target) ~= "string" and string.len(target) == 0 then
		print("<SLFacade | removeEvent -- target is empty.")
		return
	end

	local cached = self._eventListenners[eventName] or {}
	local nIndex = -1
	for index, v in pairs(cached) do
		if v.tag == target then
			nIndex = index
			break
		end
	end
	if nIndex ~= -1 then
		local eventListener = cached[nIndex].listener
		self:getEventDispatcher():removeEventListener(eventListener)
		table.remove(cached, nIndex)
	else
		-- print("<SLFacade | removeEvent -- can not find event listenner name:", eventName)
	end
end

-- 派发事件
function SLFacade:dispatchEvent(event)
	-- body
	--assert(iskindof(event, "cc.Event"))
	self:getEventDispatcher():dispatchEvent(event)
end

-- 派发自定义事件
function SLFacade:dispatchCustomEvent(eventName, ...)
	-- body
	assert(type(eventName) == "string")
	local event = cc.EventCustom:new(eventName)
	event._userdata = {...}

   	self:dispatchEvent(event)
end

-- cocos EventDispatcher 
-- 获取cocos事件派发器实例
function SLFacade:getGlobalEventDispatcher()
	-- body
	return cc.Director:getInstance():getEventDispatcher()
end

-- 设置cocos事件派发器是否可用
-- enabled[boolean] - true:可用；false:不可用
function SLFacade:setGlobalEventDispatcherEnabled(enabled)
	-- body
	assert(type(enabled) == "boolean")
	self:getGlobalEventDispatcher():setEnabled(enabled)
end

-- 添加事件监听器
function SLFacade:addGlobalEventListener(eventListener)
	-- body
	if not iskindof(eventListener, "cc.EventListener") then
		print("<SLFacade | addEventListener - argument(eventListener) is not kind of cc.EventListener")
		return
	end

	self:getGlobalEventDispatcher():addEventListenerWithFixedPriority(eventListener, 1)
end

-- 添加自定义的事件监听器
-- eventName - 事件名
-- eventCallback - 事件回调
function SLFacade:addGlobalCustomEventListener(eventName, eventCallback)
	-- body
	assert(type(eventName) == "string" and type(eventCallback) == "function")
	if string.len(eventName) == 0 then
		cclog("<SLFacade | registerEvent -- eventName is empty.")
		return
	end

	local listener = cc.EventListenerCustom:create(eventName, eventCallback)
	self:addGlobalEventListener(listener, 1)
	return listener
end

-- 移除事件监听器
function SLFacade:removeGlobalEventListener(eventListener)
	-- body
	if not iskindof(eventListener, "cc.EventListener") then
		print("<SLFacade | addEventListener - argument(eventListener) is not kind of cc.EventListener")
		return
	end

	self:getGlobalEventDispatcher():removeEventListener(eventListener)
end

-- 派发事件
function SLFacade:dispatchGlobalEvent(event)
	-- body
	assert(iskindof(event, "cc.Event"))
	self:getGlobalEventDispatcher():dispatchEvent(event)
end

-- 派发自定义事件
function SLFacade:dispatchGlobalCustomEvent(eventName, ...)
	-- body
	assert(type(eventName) == "string")
	local event = cc.EventCustom:new(eventName)
	event._userdata = {...}

   	self:dispatchGlobalEvent(event)
end

-- 伪构造函数
function SLFacade:finalizer()
	self._eventDispatcher:release()
end

cc.exports.SLFacade = cc.exports.SLFacade or SLFacade:new()
return cc.exports.SLFacade



--endregion
