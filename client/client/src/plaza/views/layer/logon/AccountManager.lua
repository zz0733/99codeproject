--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--region *.lua
--Date
--
--endregion

AccountManager = class("AccountManager")


AccountManager.g_instance = nil
local INFO_COUNT = 11

function AccountManager.getInstance()
    if not AccountManager.g_instance then
        AccountManager.g_instance = AccountManager:new()
    end
    return AccountManager.g_instance
end

function AccountManager.releaseInstance()
    AccountManager.g_instance = nil
end

function AccountManager:ctor()
    self.m_pAccountInfo = {}
end

function AccountManager:getLocalAccount()
    return self.m_pAccountInfo 
end

function AccountManager:clearLocalAccount()
    self.m_pAccountInfo = {}
end

function AccountManager:initLocalAccount()
    self:clearLocalAccount()
    -- 和策划确认过，最多20个
    for i = 1, 20 do
        local ac_key = "ac" .. i
--        local ac_str = cc.UserDefault:getInstance():getStringForKey(ac_key, "") or ""
        local str = {}

        --读取本配置
	    local tmpInfo = readByDecrypt("user_gameconfig.plist",ac_key)
        
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
		    str =  json.decode(tmpInfo) or ""
        else
            str = ""
        end
        if str ~= "" then
            local info = {}
            local ac_split = string.split(str, ";")

            info[1] = tonumber(ac_split[1])
            info[2] = tonumber(ac_split[2])
            info[3] = tostring(ac_split[3])
            info[4] = tostring(ac_split[4])
            info[5] = tostring(ac_split[5])
            info[6] = tostring(ac_split[6])
            info[7] = tonumber(ac_split[7])
            info[8] = tonumber(ac_split[8])
            info[9] = tonumber(ac_split[9])
            info[10] = tostring(ac_split[10])
            info[11] = tonumber(ac_split[11])

            table.insert(self.m_pAccountInfo, info)
            local a = 0
        end
    end
end

--保存账号信息在本地
-- account: 
-- [1] = gameID;   [2] = headID;   [3] = nickName;
-- [4] = phone;    [5] = password; [6] = guest;
-- [7] = viplevel; [8] = frameID;  [9] = loginTime;
function AccountManager:saveLocalAccount()
    for index = 1, 20 do
        local info = self.m_pAccountInfo[index]
        local key = "ac" .. index
        local str = ""
        if info ~= nil then
            str = tostring(info[1])
            for i = 2, INFO_COUNT do
                str = str .. ";" .. tostring(info[i])
            end
        end
        if str == "" then
        
        else
            local msg = json.encode(str)
	        local szSaveInfo = md5(msg)..msg
	        saveByEncrypt("user_gameconfig.plist",key,szSaveInfo)
        end

--        cc.UserDefault:getInstance():setStringForKey(key, str)
    end

end


--在[1]登录成功,[2]修改头像成功,[3]修改密码成功,[4]修改名字成功,[5]升级账号成功,[6]vip等级变化都需要重新保存账号信息
function AccountManager:updateAccountInfo()
    local curAccount = self:getCurrentAccount()
    --如果是新账号，加入到table里面，旧账号更新账号内容
    local accountNew = true
    for k ,v in pairs(self.m_pAccountInfo) do
        if v[1] == curAccount[1] and curAccount[1] ~= nil then
            for i = 1, INFO_COUNT do
                v[i] = curAccount[i]
            end
            accountNew = false
            break
        end
    end

    if accountNew then
        table.insert(self.m_pAccountInfo, curAccount)
    end

    --排序一下
    table.sort(self.m_pAccountInfo, function(a, b)
        return tonumber(a[9]) > tonumber(b[9])
    end)

    --保存到本地
    self:saveLocalAccount()
end

function AccountManager:getCurrentAccount()
 
    local tableSave = 
    {
        [1] = GlobalUserItem.tabAccountInfo.userid,
        [2] = GlobalUserItem.tabAccountInfo.avatar_no-1,
        [3] = GlobalUserItem.tabAccountInfo.nickname,
        [4] = GlobalUserItem.tabUserLogonInfor.account,
        [5] = GlobalUserItem.tabUserLogonInfor.password,
        [6] = tostring(GlobalUserItem.tabUserLogonInfor.spreadid),
        [7] = GlobalUserItem.tabAccountInfo.vip_level,
        [8] = GlobalUserItem.tabUserLogonInfor.logontype,
        [9] = os.time(),
        [10] = GlobalUserItem.tabUserLogonInfor.openid,
        [11] = GlobalUserItem.tabUserLogonInfor.nGender,
    }
    return tableSave
end

function AccountManager:getCurrentVistorInfor()
    for k, v in pairs(self.m_pAccountInfo) do
        if v[8] == yl.LOGON_TYPE.VISTOR then
            return v
        end
    end
    return nil
end

function AccountManager:getCurrentAccountInfor()
    for k, v in pairs(self.m_pAccountInfo) do
        if v[8] == yl.LOGON_TYPE.ACCOUNT then
            return v
        end
    end
    return nil
end

return AccountManager

--endregion
