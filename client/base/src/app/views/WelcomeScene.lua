--[[
	欢迎界面
			2015_12_03 C.P
	功能：本地版本记录读取，如无记录，则解压原始大厅及附带游戏
--]]

local WelcomeScene = class("WelcomeScene", cc.load("mvc").ViewBase)


function WelcomeScene:onEnterTransitionFinish()
    local nResversion = tonumber(self:getApp()._version:getResVersion())
	if nil == nResversion then
	 	self:onUnZipBase()
    else
        self:EnterClient()
    end
end

function WelcomeScene:onCreate()

	self:registerScriptHandler(function(eventType)
		if eventType == "enterTransitionFinish" then	-- 进入场景而且过渡动画结束时候触发。
			self:onEnterTransitionFinish()
		end
	end)

	--背景
	local sp = cc.Sprite:create("background.jpg")
	if nil ~= sp then
		sp:setPosition(appdf.WIDTH/2,appdf.HEIGHT/2)
		self:addChild(sp)
	end

    --提示文本
	self._txtTips = cc.LabelTTF:create("", "Arial", 24)
	self._txtTips:setAnchorPoint(cc.p(1,0))
	self._txtTips:move(appdf.WIDTH,0)
	self._txtTips:addTo(self)
end


--解压自带ZIP
function WelcomeScene:onUnZipBase()
	local this = self

	if self._unZip == nil then --大厅解压
		-- 状态提示
		self._txtTips:setString("解压文件，请稍候...")
		self._unZip = 0
		--解压
		local dst = device.writablePath
		unZipAsync(cc.FileUtils:getInstance():fullPathForFilename("client.zip"),dst,function(result)
				this:onUnZipBase()
			end)
	elseif self._unZip == 0 then --默认游戏解压
		self._unZip = 1
		--解压
		local dst = device.writablePath
		unZipAsync(cc.FileUtils:getInstance():fullPathForFilename("game.zip"),dst,function(result)
				this:onUnZipBase()
			end)
	else 			-- 解压完成
		self._unZip = nil
		--更新本地版本号
		self:getApp()._version:setResVersion(appdf.BASE_C_RESVERSION)
		for k ,v in pairs(appdf.BASE_GAME) do
			self:getApp()._version:setResVersion(v.version,v.kind)
		end
		self._txtTips:setString("解压完成！")
        self:EnterClient()
		return	
	end

end

--进入检查界面
function  WelcomeScene:EnterClient()
	--场景切换
	self:getApp():enterSceneEx(appdf.CLIENT_SRC.."plaza.views.ControlScene","FADE", 0)
end

return WelcomeScene