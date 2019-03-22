local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
GlobalUserItem = GlobalUserItem or {}

-- 下载管理
GlobalUserItem.tabUpdater = {}

--用户登录信息
GlobalUserItem.tabUserLogonInfor = {}

-- 系统配置		
GlobalUserItem.tabSystemConfig =
{
	IsOpenMall = 0, -- 是否开启商城
  	IsPayBindSpread = 0, -- 充值是否需要绑定推广人
  	BindSpreadPresent = 0, -- 绑定推广人后钻石奖励
  	RankingListType = 0, -- 排行榜类型(0 无  1 财富排行榜  2消耗排行榜  3财富和消耗 4 战绩  5 财富和战绩  6 消耗和战绩  7 全部)
  	PayChannel = 0, -- 充值渠道( 0-无，1-微信官方，2-支付宝官方，3-微信和支付宝官方)
  	DiamondBuyPropCount = 10, -- 钻石兑换道具比例
  	RealNameAuthentPresent = 0, -- 实名认证奖励
  	EnjoinInsure = 1, -- 0表示开启银行服务,1表示关闭
}

--重置数据
function GlobalUserItem.reSetData()
    -- 账户信息
	GlobalUserItem.tabAccountInfo 							=  				-- 账号信息
	{

	}	

    --房间信息
	GlobalUserItem.tabRoomInfo 							=  				-- 房间信息
	{

	}

    --登陆状态
    GlobalUserItem.bFinishLogon = false
end

--读取配置
function GlobalUserItem.LoadData()
	--声音设置
	GlobalUserItem.bVoiceAble = cc.UserDefault:getInstance():getBoolForKey("vocieable",true)
	GlobalUserItem.bSoundAble = cc.UserDefault:getInstance():getBoolForKey("soundable", true)
	--音量设置
	GlobalUserItem.nSound = cc.UserDefault:getInstance():getIntegerForKey("soundvalue",50)
	GlobalUserItem.nMusic = cc.UserDefault:getInstance():getIntegerForKey("musicvalue",50)

	if GlobalUserItem.bVoiceAble then
		AudioEngine.setMusicVolume(GlobalUserItem.nMusic/100.0)
	else
		AudioEngine.setMusicVolume(0)
	end
	
	if GlobalUserItem.bSoundAble then
		AudioEngine.setEffectsVolume(GlobalUserItem.nSound/100.00) 
	else
		AudioEngine.setEffectsVolume(0) 
	end	

    --登陆状态
    GlobalUserItem.bFinishLogon = false

    --银行密码
    GlobalUserItem.szBankPassWord = ""
    tmpInfo = readByDecrypt("user_gameconfig.plist","bankinfor")
    --检验
	if tmpInfo ~= nil and #tmpInfo >32 then
		local md5Test = string.sub(tmpInfo,1,32)
		tmpInfo = string.sub(tmpInfo,33,#tmpInfo)
		if md5Test ~= md5(tmpInfo) then
			print("test:"..md5Test.."#"..tmpInfo)
			tmpInfo = nil
		end
	else
		tmpInfo = nil
	end
    if tmpInfo ~= nil then
        GlobalUserItem.szBankPassWord = tmpInfo
    end

end
GlobalUserItem.reSetData()

--保存银行密码
function GlobalUserItem.onSaveBankPassword()
    if GlobalUserItem.szBankPassWord and GlobalUserItem.szBankPassWord ~= "" then
	    local szSaveInfo = md5(GlobalUserItem.szBankPassWord)..GlobalUserItem.szBankPassWord
	    saveByEncrypt("user_gameconfig.plist","bankinfor",szSaveInfo)
    end
end

function GlobalUserItem.setSoundAble(able)
	GlobalUserItem.bSoundAble = able
	if true == able then
		GlobalUserItem.setEffectsVolume(50)
		AudioEngine.setEffectsVolume(GlobalUserItem.nSound/100.00)
	else
		GlobalUserItem.setEffectsVolume(0)
		AudioEngine.setEffectsVolume(0)
	end
	cc.UserDefault:getInstance():setBoolForKey("soundable",GlobalUserItem.bSoundAble)
end

function GlobalUserItem.setVoiceAble(able)
	GlobalUserItem.bVoiceAble = able
	if GlobalUserItem.bVoiceAble == true then
		GlobalUserItem.setMusicVolume(50)
		AudioEngine.setMusicVolume(GlobalUserItem.nMusic/100.0)
	else		
		GlobalUserItem.setMusicVolume(0)
		AudioEngine.setMusicVolume(0)
	end
	cc.UserDefault:getInstance():setBoolForKey("vocieable",GlobalUserItem.bVoiceAble)
end

function GlobalUserItem.setMusicVolume(music) 
	local tmp = music 
	if tmp >100 then
		tmp = 100
	elseif tmp < 0 then
		tmp = 0
	end
	AudioEngine.setMusicVolume(tmp/100.0) 
	GlobalUserItem.nMusic = tmp
	cc.UserDefault:getInstance():setIntegerForKey("musicvalue",GlobalUserItem.nMusic)
end

function GlobalUserItem.setEffectsVolume(sound) 
	local tmp = sound 
	if tmp >100 then
		tmp = 100
	elseif tmp < 0 then
		tmp = 0
	end
	AudioEngine.setEffectsVolume(tmp/100.00) 
	GlobalUserItem.nSound = tmp
	cc.UserDefault:getInstance():setIntegerForKey("soundvalue",GlobalUserItem.nSound)
end