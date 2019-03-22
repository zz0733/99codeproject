--[[
	欢迎界面
			2015_12_03 C.P
	功能：本地版本记录读取，如无记录，则解压原始大厅及附带游戏
--]]

local ControlScene = class("ControlScene", cc.load("mvc").ViewBase)
if not yl then
	appdf.req(appdf.CLIENT_SRC.."plaza.models.yl")
end

local ClientUpdate = appdf.req("base.src.app.controllers.ClientUpdate")
local QueryDialog = appdf.req("base.src.app.views.layer.other.QueryDialog")
local ClientConfig = appdf.req(appdf.BASE_SRC .."app.models.ClientConfig")
local LOCAL_CONFIG = "local_config"
--全局toast函数(ios/android端调用)
cc.exports.g_NativeToast = function (msg)
	local runScene = cc.Director:getInstance():getRunningScene()
	if nil ~= runScene then
		showToast(runScene, msg, 2)
	end
end

-- 全局截屏通知
cc.exports.g_takeScreenShot = function( msg )
	print("onGetTakeShootEvent")
	local event = cc.EventCustom:new(appdf.CLIENT_NOTIFY)
	event.msg = msg
	event.what = appdf.CLIENT_MSG_TAKE_SCREENSHOT
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end

function ControlScene:onCreate()
	local this = self
	self:setTag(1)

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
    
    --csb
    self.m_pathUI = cc.CSLoader:createNode("login/LoginScene.csb")--("hall/csb/LoginView.csb")
    self.m_pathUI:setPositionY((display.height - 750) / 2)
    self.m_pathUI:addTo(self.m_rootUI)
    self.m_pNodeRootUI = self.m_pathUI:getChildByName("node_rootUI")
    self.m_pNodeRootUI:setPositionX((display.width - 1334) / 2)

    --init
    self.m_pImgBg       = self.m_pNodeRootUI:getChildByName("IMG_login_bg") --背景图
    self.m_pImgLogo     = self.m_pNodeRootUI:getChildByName("Image_logo")   --游戏LOGO
    self.m_lb_version   = self.m_pNodeRootUI:getChildByName("Node_Tips"):getChildByName("TXT_version")  --版本label
    self.m_serviceBtn   = self.m_pNodeRootUI:getChildByName("BTN_service")  --客服button

    self.m_node_btn         = self.m_pNodeRootUI:getChildByName("IMG_toolBg")   --按钮node
    self.m_visitorBtn       = self.m_node_btn:getChildByName("BTN_guestLogin")  --游客登录button
    self.m_loginBtn         = self.m_node_btn:getChildByName("BTN_login")       --账号登录button
    self.m_registerBtn      = self.m_node_btn:getChildByName("BTN_register")    --账号注册button

    self.m_node_load        = self.m_pNodeRootUI:getChildByName("IMG_loadBg")   --加载Node    
    self._txtTips           = self.m_node_load:getChildByName("Text_Up")        --文字bar
    self.m_loadingBar       = self.m_node_load:getChildByName("Progress_bar")   --进度条bar
    self.m_ptheader         = self.m_loadingBar:getChildByName("pt_header")

--    self.skeletonNode = sp.SkeletonAnimation:create("hall/effect/login-animation/animation.json", "hall/effect/login-animation/animation.atlas", 1)
--    self.skeletonNode:setPosition(cc.p(812 ,375))
--    self.skeletonNode:setAnimation(0, "animation", true)
--    self.skeletonNode:update(0)
--    self.skeletonNode:addTo(self.m_pImgBg)
    --visible
    self.m_node_btn:setVisible(false)   --隐藏登录node
    self.m_node_load:setVisible(true)  --隐藏进度node
    self.m_lb_version:setVisible(false) --隐藏版本label
    self.m_serviceBtn:setVisible(false) --隐藏客服button
    self.m_node_load:setVisible(false)


    self.m_progressLayer = display.newLayer(cc.c4b(0, 0, 0, 0))
	self:addChild(self.m_progressLayer)
	self.m_progressLayer:setVisible(false)

	--总进度
	local total_bg = cc.Sprite:create("wait_frame_0.png")
	self.m_spTotalBg = total_bg
	self.m_progressLayer:addChild(total_bg)
	total_bg:setPosition(display.width/2, 80)
	self.m_totalBar = ccui.LoadingBar:create()
	self.m_totalBar:loadTexture("wait_frame_3.png")	
	self.m_progressLayer:addChild(self.m_totalBar)
	self.m_totalBar:setPosition(display.width/2, 80)
	self._totalTips = cc.Label:createWithTTF("", "fonts/round_body.ttf", 20)
		--:setTextColor(cc.c4b(0,250,0,255))
		:setName("text_tip")
		:enableOutline(cc.c4b(0,0,0,255), 1)
		:move(self.m_totalBar:getContentSize().width * 0.5, self.m_totalBar:getContentSize().height * 0.5)
		:addTo(self.m_totalBar)
	self.m_totalThumb = cc.Sprite:create("thumb_1.png")
	self.m_totalBar:addChild(self.m_totalThumb)
	self.m_totalThumb:setPosition(0, self.m_totalBar:getContentSize().height * 0.5)
	self:updateBar(self.m_totalBar, self.m_totalThumb, 0)

	--单文件进度
	local file_bg = cc.Sprite:create("wait_frame_0.png")
	self.m_spFileBg = file_bg
	self.m_progressLayer:addChild(file_bg)
	file_bg:setPosition(display.width/2, 120)
	self.m_fileBar = ccui.LoadingBar:create()
	self.m_fileBar:loadTexture("wait_frame_2.png")
	self.m_fileBar:setPercent(0)
	self.m_progressLayer:addChild(self.m_fileBar)
	self.m_fileBar:setPosition(display.width/2, 120)
	self._fileTips = cc.Label:createWithTTF("", "fonts/round_body.ttf", 20)
		--:setTextColor(cc.c4b(0,250,0,255))
		:setName("text_tip")
		:enableOutline(cc.c4b(0,0,0,255), 1)
		:move(self.m_fileBar:getContentSize().width * 0.5, self.m_fileBar:getContentSize().height * 0.5)
		:addTo(self.m_fileBar)
	self.m_fileThumb = cc.Sprite:create("thumb_0.png")
	self.m_fileBar:addChild(self.m_fileThumb)
	self.m_fileThumb:setPosition(0, self.m_fileBar:getContentSize().height * 0.5)
	self:updateBar(self.m_fileBar, self.m_fileThumb, 0)

    --读取本配置
	local tmpInfo = readByDecrypt("user_gameconfig.plist","lastuserinfor")
	--检验
	if tmpInfo ~= nil and #tmpInfo >32 then
		local md5Test = string.sub(tmpInfo,1,32)
		tmpInfo = string.sub(tmpInfo,33,#tmpInfo)
		if md5Test ~= md5(tmpInfo) then
			tmpInfo = nil
		end
	else
		tmpInfo = nil
	end
    if tmpInfo ~= nil then
        self.lastuserinfor =  cjson.decode(tmpInfo) 
    end
	-- 资源同步队列
	self.m_tabUpdateQueue = {}
    --版本同步
    self:downloadConfigFile()
end

function ControlScene:downloadConfigFile()
    local function updateWork(datatable,response)
        if yl.isObject(self) == false then return end
        local filePath = device.writablePath..yl.CLIENTFILE
        if type(datatable) == "table" then
           self._txtTips:setString("检测版本更新...")
           if self.finishConfig == false then
                self.finishConfig = true
                cc.FileUtils:getInstance():writeStringToFile(response,filePath)
            end

            self:httpNewVersion(datatable)
        end
        self.finishCount = self.finishCount+1
        --失败本地读取
        if self.finishCount ==#yl.update_url and not self.finishConfig then
            if cc.FileUtils:getInstance():isFileExist(filePath) then
                local data = cc.FileUtils:getInstance():getStringFromFile(filePath);
                data = json.decode(data)
                if type(data) == "table" then
                    self:httpNewVersion(data)
                end
            end
        end
    end

    self.finishConfig = false
    self.finishCount = 0
    self._txtTips:setString("获取游戏配置...")
    for i = 1, #yl.update_url do
        appdf.onHttpJsionTable(yl.update_url[i],"get",nil,updateWork)
    end
end

function ControlScene:startGetServerInfor(try)
    self.Config_Infor = {}
    if self.lastuserinfor and self.lastuserinfor.gfname1 ~= "" and self.lastuserinfor.wfname1 ~= "" then
            local item = {}
            item.game_hosts = self.lastuserinfor.gfname1
            item.web_hosts = self.lastuserinfor.wfname1
            table.insert(self.Config_Infor, item)
    end
    appdf.Hall_Address = {}
    appdf.Game_Address = {}

    self:updateBar(self.m_loadingBar, self.m_ptheader, 0)

    self:getGameConfig()
end

--获取网址
function ControlScene:getGameConfig()
    local configcallback = function (datatable,response)
         if yl.isObject(self) == false then return end

         if type(datatable) == "table" and datatable.result == "ok"then
             table.insert(self.Config_Infor, datatable.body)
         end

         self.finishConfigCount = self.finishConfigCount+1
         local percenter = self.finishConfigCount/#yl.BASE_CONFIG * 40
         self:updateBar(self.m_loadingBar, self.m_ptheader, percenter)
         if self.finishConfigCount == #yl.BASE_CONFIG  then
            self:parseConfigUrl()
         end
    end

   self._txtTips:setString("获取配置...")
   self.finishConfigCount = 0
   
   for i = 1, #yl.BASE_CONFIG do
       appdf.onHttpJsionTable(yl.BASE_CONFIG[i],"get",nil,configcallback)
    end

end

function ControlScene:parseConfigUrl()
    if yl.isObject(self) == false then return end

    --解析登录地址
    local getLogonUrl = function (ret, url)
       if yl.isObject(self) == false then return end
       if ret then
            local urls  = appdf.split(url, "|")
            for k,v in pairs(urls) do
                if v ~= "" then
                     table.insert(appdf.Hall_Address, v)
                end
            end
       end

        self.currentconfig =  self.currentconfig + 1
        local percenter = self.currentconfig/self.totolconfig * 40
        self:updateBar(self.m_loadingBar, self.m_ptheader, 40+percenter)
        if self.currentconfig == self.totolconfig then
             self:checkEnterLogon()
        end
    end

    local getGameUrl = function (ret, url)
       if yl.isObject(self) == false then return end
       if ret then
             local urls  = appdf.split(url, "|")
             for k,v in pairs(urls) do
                if v ~= "" then
                     table.insert(appdf.Game_Address, v)
                end
             end
       end

        self.currentconfig =  self.currentconfig + 1
        local percenter = self.currentconfig/self.totolconfig * 40
        self:updateBar(self.m_loadingBar, self.m_ptheader, 40+percenter)
        if self.currentconfig == self.totolconfig then
             self:checkEnterLogon()
        end
    end

    self.totolconfig = 0
    for i = 1, #self.Config_Infor do
        local item = self.Config_Infor[i]
        if type(item.web_hosts) == "string" then
            decodeUrl(item.web_hosts, getLogonUrl)
            self.totolconfig = self.totolconfig+1
        else
            for k,v in pairs(item.web_hosts) do
                decodeUrl(v, getLogonUrl)
                self.totolconfig = self.totolconfig+1
            end
        end

        if type(item.game_hosts) == "string" then
            decodeUrl(item.game_hosts, getGameUrl)
            self.totolconfig = self.totolconfig+1
        else
            for k,v in pairs(item.game_hosts) do
                decodeUrl(v, getGameUrl)
                self.totolconfig = self.totolconfig+1
            end
        end
    end
    self._txtTips:setString("检测线路...")
    self.currentconfig  = 0
end

function ControlScene:checkEnterLogon()
    if yl.isObject(self) == false then return end
    if #appdf.Game_Address > 0 and #appdf.Hall_Address > 0 then
        self._txtTips:setString("正在登录...")
        self:updateBar(self.m_loadingBar, self.m_ptheader, 100)
        self:EnterClient()
    else
       QueryDialog:create("网络错误是否重试？",function(bReTry)
			if bReTry == true then
                self:startGetServerInfor(true)
			else
				os.exit(0)
			end
		end)
	    :setCanTouchOutside(false)
		:addTo(self)
    end
end

--进入登录界面
function  ControlScene:EnterClient()
	--重置大厅与游戏
	for k ,v in pairs(package.loaded) do
		if k ~= nil then 
			if type(k) == "string" then
				if string.find(k,"plaza%.") ~= nil or string.find(k,"game%.") ~= nil then
					print("package kill:"..k) 
					package.loaded[k] = nil
				end
			end
		end
	end	
	--场景切换
	self:getApp():enterSceneEx(appdf.CLIENT_SRC.."plaza.views.LogonScene","FADE", 1)
end

--同步版本
function ControlScene:httpNewVersion(databuffer)	
	self._txtTips:setString("获取版本信息...")
	local this = self

	--数据解析
	if type(databuffer) == "table" then	 		
	 	this:getApp()._serverConfig = databuffer		     
 		--下载地址
 		this:getApp()._updateUrl = databuffer["downloadurl"]								
 		if true == ClientConfig.APPSTORE_VERSION then
 			this:getApp()._updateUrl = this:getApp()._updateUrl .. "/appstore/"
 		end
 		--大厅版本
 		this._newVersion = tonumber(databuffer["clientversion"])          						
 		--大厅资源版本
 		this._newResVersion = tonumber(databuffer["resversion"])
 		--苹果大厅更新地址
 		this._iosUpdateUrl = databuffer["ios_url"]
 		if true == ClientConfig.APPSTORE_VERSION then
 			this._iosUpdateUrl = nil
 		end

 		local nNewV = self._newResVersion
		local nCurV = tonumber(self:getApp()._version:getResVersion())
		if nNewV and nCurV then
			if nNewV > nCurV then
				-- 更新配置
		 		local updateConfig = {}
				updateConfig.isClient = true
				updateConfig.newfileurl = this:getApp()._updateUrl.."/client/res/filemd5List.json"
				updateConfig.downurl = this:getApp()._updateUrl .. "/"
				updateConfig.dst = device.writablePath
				local targetPlatform = cc.Application:getInstance():getTargetPlatform()
				if cc.PLATFORM_OS_WINDOWS == targetPlatform then
					updateConfig.dst = device.writablePath .. "download/client/"
				end					
				updateConfig.src = device.writablePath.."client/res/filemd5List.json"
				table.insert(self.m_tabUpdateQueue, updateConfig)
			end
		end		 
        
        local gametype = databuffer["gametype"]
 		--游戏列表
 		local rows = databuffer["gamelist"]
 		this:getApp()._gameList = {}
 		if type(rows) == "table" then
 			for k,v in pairs(rows) do
	 			local gameinfo = {}
	 			gameinfo._KindID = v["KindID"]
	 			gameinfo._KindName = string.lower(v["ModuleName"]) .. "."
	 			gameinfo._Module = string.gsub(gameinfo._KindName, "[.]", "/")
	 			gameinfo._KindVersion = v["ClientVersion"]
	 			gameinfo._ServerResVersion = tonumber(v["ResVersion"])
	 			gameinfo._Type = gameinfo._Module
	 			gameinfo._GameName = v["KindName"] or ""
                gameinfo.dwStatus = v["Status"] or 0
                gameinfo.fixseat = v["fixseat"] or false
                gameinfo.GameTypeIDs = v["GameTypeIDs"] or -1
                gameinfo.strAnimationPath = v["AnimationPath"]
                gameinfo.strAnimationName = v["AnimationName"]
	 			--检查本地文件是否存在
	 			local path = device.writablePath .. "game/" .. gameinfo._Module
	 			gameinfo._Active = cc.FileUtils:getInstance():isDirectoryExist(path)
	 			local e = string.find(gameinfo._KindName, "[.]")
	 			if e then
	 				gameinfo._Type = string.sub(gameinfo._KindName,1,e - 1)
	 			end
	 			-- 排序
	 			gameinfo._SortId = tonumber(v["SortID"]) or 0

                for k,v in pairs(gametype) do
                    for i = 1, #v do
                        if tonumber(gameinfo._KindID) == v[i] then
                            gameinfo.nClassify = k
                            if self:getApp()._gameList[k] == nil then
                                self:getApp()._gameList[k] = {}
                            end
                            table.insert(self:getApp()._gameList[k], gameinfo)
                        end
                    end
                end
	 		end
 		end
    end
	self._txtTips:setString("检测版本更新...")
	self:httpNewVersionCallBack(true,msg)	 	
end

--服务器版本返回
function ControlScene:httpNewVersionCallBack(result,msg)
    local this = self
    
    --获取失败
    if not result then
	    self._txtTips:setString("")
	    QueryDialog:create(msg.."\n是否重试？",function(bReTry)
			    if bReTry == true then
				    this:httpNewVersion()
			    else
				    os.exit(0)
			    end
		    end)
	    	:setCanTouchOutside(false)
		    :addTo(self)
    else
	    --升级判断
	    local bUpdate = false
	    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
		--if cc.PLATFORM_OS_WINDOWS ~= targetPlatform then
        if true then
			bUpdate = self:updateClient()
		else
			self:getApp()._version:setResVersion(self._newResVersion)
		end
		
	    if not bUpdate then
             self.m_progressLayer:setVisible(false)
             self.m_node_load:setVisible(true)
            --获取服务信息
            self:startGetServerInfor()
	    end
    end
end


--升级大厅
function ControlScene:updateClient()
	local newV = self._newVersion
	local curV = appdf.BASE_C_VERSION
	if newV and curV then		
		--更新APP
		if newV > curV then
			if device.platform == "ios" and (type(self._iosUpdateUrl) ~= "string" or self._iosUpdateUrl == "") then
				print("ios update fail, url is nil or empty")
			else
				self._txtTips:setString("")
				QueryDialog:create("有新的版本，是否现在下载升级？",function(bConfirm)
	                    if bConfirm == true then                    	
							self:upDateBaseApp()				    
						else
							os.exit(0)
	                    end					
					end)
					:setCanTouchOutside(false)
					:addTo(self)	
				return true
			end				
		end
	end
	if 0 ~= #self.m_tabUpdateQueue then
		self:goUpdate()
		return true
	end
	print("version did not need to update")
end

function ControlScene:upDateBaseApp()
	self.m_progressLayer:setVisible(true)
    self.m_node_load:setVisible(false)
	self.m_totalBar:setVisible(false)
	self.m_spTotalBg:setVisible(false)
	self.m_fileBar:setVisible(true)
	self.m_spFileBg:setVisible(true)

	if device.platform == "android" then
		local this = self
		local argsJson 
		local url = ""
		print("debug .. => " .. DEBUG)
		if isDebug() then
			url = self:getApp()._updateUrl.."/NewGloryPlaza-debug.apk"	
		else			
			url = self:getApp()._updateUrl.."/NewGloryPlaza.apk"		 
		end

	    --调用C++下载
	    local luaj = require "cocos.cocos2d.luaj"
		local className = "org/cocos2dx/lua/AppActivity"

	    local sigs = "()Ljava/lang/String;"
   		local ok,ret = luaj.callStaticMethod(className,"getSDCardDocPath",{},sigs)
   		if ok then
   			local dstpath = ret .. "/update/"
   			local filepath = dstpath .. "NewGloryPlaza.apk"
		    if cc.FileUtils:getInstance():isFileExist(filepath) then
		    	cc.FileUtils:getInstance():removeFile(filepath)
		    end
		    if false == cc.FileUtils:getInstance():isDirectoryExist(dstpath) then
		    	cc.FileUtils:getInstance():createDirectory(dstpath)
		    end
		    self:updateBar(self.m_fileBar, self.m_fileThumb, 0)
			downFileAsync(url,"NewGloryPlaza.apk",dstpath,function(main,sub)
					--下载回调
					if main == appdf.DOWN_PRO_INFO then --进度信息
						self:updateBar(self.m_fileBar, self.m_fileThumb, sub)
					elseif main == appdf.DOWN_COMPELETED then --下载完毕
						self._txtTips:setString("下载完成")
						self.m_progressLayer:setVisible(false)

						--安装apk						
						local args = {filepath}
						sigs = "(Ljava/lang/String;)V"
		   				ok,ret = luaj.callStaticMethod(className, "installClient",args, sigs)
		   				if ok then
		   					os.exit(0)
		   				end
					else
						QueryDialog:create("下载失败,code:".. main .."\n是否重试？",function(bReTry)
							if bReTry == true then
								this:upDateBaseApp()
							else
								os.exit(0)
							end
						end)
						:setCanTouchOutside(false)
						:addTo(self)
					end
				end)
		else
			os.exit(0)
   		end	    
	elseif device.platform == "ios" then
		local luaoc = require "cocos.cocos2d.luaoc"
		local ok,ret  = luaoc.callStaticMethod("AppController","updateBaseClient",{url = self._iosUpdateUrl})
	    if not ok then
	        print("luaoc error:" .. ret)        
	    end
	end
end

--开始下载
function ControlScene:goUpdate( )
	self.m_progressLayer:setVisible(true)
    self.m_node_load:setVisible(false)

	local config = self.m_tabUpdateQueue[1]
	if nil == config then
		self.m_progressLayer:setVisible(false)
        self.m_node_load:setVisible(true)
        --获取服务信息
        self:startGetServerInfor()
	else
		ClientUpdate:create(config.newfileurl, config.dst, config.src, config.downurl)
			:upDateClient(self)
	end	
end

--下载进度
function ControlScene:updateProgress(sub, msg, mainpersent)
	self:updateBar(self.m_fileBar, self.m_fileThumb, sub)
	self:updateBar(self.m_totalBar, self.m_totalThumb, mainpersent)
end

--下载结果
function ControlScene:updateResult(result,msg)
	local this = self
	if result == true then
		self:updateBar(self.m_fileBar, self.m_fileThumb, 0)
		self:updateBar(self.m_totalBar, self.m_totalThumb, 0)

		local config = self.m_tabUpdateQueue[1]
		if nil ~= config then
			if true == config.isClient then
				--更新本地大厅版本
				self:getApp()._version:setResVersion(self._newResVersion)
			else
				self:getApp()._version:setResVersion(config._ServerResVersion, config._KindID)
				for k,v in pairs(self:getApp()._gameList) do
					if v._KindID == config._KindID then
						v._Active = true
					end
				end
			end
			table.remove(self.m_tabUpdateQueue, 1)
			self:goUpdate()
		else
              self.m_progressLayer:setVisible(false)
              self.m_node_load:setVisible(true)
               --获取服务信息
              self:startGetServerInfor()
		end
	else
		self.m_progressLayer:setVisible(false)
        self.m_node_load:setVisible(false)
		self:updateBar(self.m_fileBar, self.m_fileThumb, 0)
		self:updateBar(self.m_totalBar, self.m_totalThumb, 0)

		--重试询问
		self._txtTips:setString("")
		QueryDialog:create(msg.."\n是否重试？",function(bReTry)
				if bReTry == true then
					this:goUpdate()
				else
					os.exit(0)
				end
			end, 20)
			:setCanTouchOutside(false)
			:addTo(self)
	end
end

function ControlScene:updateBar(bar, thumb, percent)
	if nil == bar or nil == thumb then
		return
	end
	local text_tip = bar:getChildByName("text_tip")
	if nil ~= text_tip then
		local str = string.format("%d%%", percent)
		text_tip:setString(str)
	end

	bar:setPercent(percent)
	local size = bar:getVirtualRendererSize()
	thumb:setPositionX(size.width * percent / 100)
end


return ControlScene