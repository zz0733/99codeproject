local BaseFrame = class("BaseFrame")

local errorMsg = {}
errorMsg[1] = "创建失败"
errorMsg[2] = "验证失败"
errorMsg[3] = "连接失败"
errorMsg[4] = "发送失败"
errorMsg[5] = "接收失败"
errorMsg[6] = "网络超时"
errorMsg[7] = "服务器关闭"
local error_mt = {__index = function() return "网络超时" end }
setmetatable(errorMsg,error_mt)

function BaseFrame:ctor(view,callback)
	self._viewFrame = view
	self._threadid  = nil
	self._socket    = nil
	self._callBack = callback
	-- 游戏长连接
	self._gameFrame = nil
	self.m_tabCacheMsg = {}
end

function BaseFrame:setCallBack(callback)
	self._callBack = callback
end

function BaseFrame:setViewFrame(viewFrame)
	self._viewFrame = viewFrame
end

function BaseFrame:setSocketEvent(socketEvent)
	self._socketEvent = socketEvent	
end

function BaseFrame:getViewFrame()
	return self._viewFrame
end

function BaseFrame:isSocketServer()
	return self._socket ~= nil and self._threadid ~=nil
end

function BaseFrame:sethearttime(time)
   if self._socket then
        self._socket:sethearttime(time)
   end
end

function BaseFrame:setwaittime(time)
  if self._socket then 
    self._socket:setwaittime(time)
  end
end

function BaseFrame:setdelaytime(time)
   if self._socket then 
    self._socket:setdelaytime(time)
   end
end

local targetPlatform = cc.Application:getInstance():getTargetPlatform()

--启动网络
function  BaseFrame:onCreateSocket()
    local ipinfor = appdf.getLogonIP()
    ipinfor = appdf.split(ipinfor, ":")
	--已存在连接
	if self._socket ~= nil then
		return false
	end
	--创建连接
	local this = self
	self._szServerUrl = ipinfor[1] 
	self._nServerPort = tonumber(ipinfor[2])
	self._SocketFun = function(pData)
			this:onSocketCallBack(pData)
		end
	self._socket = CClientSocket:createSocket(self._SocketFun)
	self._socket:setwaittime(0)
	if self._socket:connectSocket(self._szServerUrl,self._nServerPort,"") == true then
		self._threadid = 0
		return true
	else --创建失败
		self:onCloseSocket() 
		return false
	end
end

--启动网络
function  BaseFrame:onCreateGameSocket()
    local ipinfor = appdf.getGameIP()
    ipinfor = appdf.split(ipinfor, ":")
	--已存在连接
	if self._socket ~= nil then
		return false
	end
	--创建连接
	local this = self
	self._szServerUrl = ipinfor[1] 
	self._nServerPort = tonumber(ipinfor[2])
	self._SocketFun = function(pData)
			this:onSocketCallBack(pData)
		end
	self._socket = CClientSocket:createSocket(self._SocketFun)
	self._socket:setwaittime(0)
    self._socket:sethearttime(5000)
    self._socket:setdelaytime(14000)
	if self._socket:connectSocket(self._szServerUrl,self._nServerPort,"") == true then
		self._threadid = 0
		return true
	else --创建失败
		self:onCloseSocket() 
		return false
	end
end

--网络消息回调
function BaseFrame:onSocketCallBack(pData)
	--无效数据
	if  pData == nil then 
		return
	end
	if not self._callBack then
		print("base frame no callback")
		self:onCloseSocket()
		return
	end
	
	-- 连接命令
	local main = pData:getmain()
	local sub =pData:getsub()
	--print("onSocketCallBack main:"..main.."#sub:"..sub)	
	if main == yl.MAIN_SOCKET_INFO then 		--网络状态
		if sub == yl.SUB_SOCKET_CONNECT then
			self._threadid = 1	
			self:onConnectCompeleted()
		elseif sub == yl.SUB_SOCKET_ERROR then	--网络错误
			if self._threadid then
				self:onSocketError(pData)
			else
				self:onCloseSocket()
			end			
		else
			self:onCloseSocket()
		end
	else
		if 1 == self._threadid then--网络数据
			self:onSocketEvent(main,sub,pData)
		end
	end
end

--关闭网络
function BaseFrame:onCloseSocket()
	if self._socket then
		self._socket:relaseSocket()
		self._socket = nil
	end
	if self._threadid then
		self._threadid = nil
	end
	self._SocketFun = nil
end

--发送数据
function BaseFrame:sendSocketData(pData)
	local cmddata = CCmd_Data:create()
	cmddata:setcmdinfo(0,0)
    cmddata:pushvalue(pData)
	if self:isSocketServer() == false then
		return false
	end
	if not self._socket:sendData(cmddata) then
		return false
	end
	return true
end

--连接OK
function BaseFrame:onConnectCompeleted()
	print("warn BaseFrame-onConnectResult-"..result)
end

--网络信息(短连接)
function BaseFrame:onSocketEvent(main,sub,pData)
	print("warn BaseFrame-onSocketData-"..main.."-"..sub)
end

--网络消息(长连接)
function BaseFrame:onGameSocketEvent(main,sub,pData)
	print("warn BaseFrame-onGameSocketEvent-"..main.."-"..sub)
end

return BaseFrame