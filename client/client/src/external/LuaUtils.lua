--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--LuaUtils = class("LuaUtils")

--function LuaUtils:ctor()
--    self.m_className = "LuaUtils"
--end

--local crypto = require("cocos.crypto")
--local cjson = require("cjson")

local LuaUtils = {}
LuaUtils.screeShot = nil

-- function LuaUtils.readJsonFileByFileName(fileName)
--    local filePath = fileName
--    local strPath   = cc.FileUtils:getInstance():fullPathForFilename(filePath)
--    local jsonStr = cc.FileUtils:getInstance():getStringFromFile(strPath)
--    if not jsonStr or jsonStr ~= "" then
--        return cjson.decode(jsonStr)
--    end
--end

--获得本地字符串
function LuaUtils.getLocalString(key)
   return cc.exports.Localization_cn[key]
end

-- 玩家金币格式化 保留2位小数
function LuaUtils.getFormatGoldAndNumber(n)
    local gold = tonumber(n) or 0
    local strFormatGold = gold
    if -100 < gold and gold < 0 then
        strFormatGold = "-" .. strFormatGold
    end
    return strFormatGold
end

-- 玩家金币格式化 带“万”、“亿”
function LuaUtils.getGoldNumber(n)
    local gold = tonumber(n) or 0
    if gold < 1000000 and gold > -1000000 then
         -- (-1000000, 1000000)
        return LuaUtils.getFormatGoldAndNumber(gold)

    elseif math.abs(gold) > 10000000000 then
        -- 亿
        local strFormatGold = string.format("%d.%01d", (gold/10000000000), (math.abs(gold)%10000000000)/1000000000)
        strFormatGold = strFormatGold .. "亿"
        return strFormatGold
    else
        -- 万
        local strFormatGold = string.format("%d.%01d", (gold/1000000), (math.abs(gold)%1000000)/100000)
        strFormatGold = strFormatGold .. "万"
        return strFormatGold
    end
end

--[[
    --用户昵称
    --nlen 需要显示的字符串长度 (以字母长度为准) 
    eg: nLen = 8 / 游客520000210 --> 游客5200.. 
        nLen = 8 / 520000210 --> 52000021..
--]]
function LuaUtils.getDisplayNickName( strNickName, nLen, isDianEnd)
    if not strNickName or strNickName == "" then return end
    local str, isWithDian = LuaUtils.utf8_sub(strNickName, 0, nLen)
    if (isDianEnd and isWithDian) then
	    str = str .. ".."
    end
    return str
end

--用户昵称
function LuaUtils.getDisplayNickName2( str, chartWidth, fontName, fontSize, placeStr)
    local tempSubStr = ""
    local tempString = str
    
    if tempString == "" then
        return tempSubStr
    end

    local showPixelVec = {}
    local realPixelLen, showPixelVec = LuaUtils.calculateShowPixelLength(str, showPixelVec, fontName, fontSize)
    local placeStrLen = 0
    local isJoint = false
    
    if realPixelLen > chartWidth then
        --大于容器的宽度
        local showPixeVec2 = {}
        placeStrLen, showPixeVec2 = LuaUtils.calculateShowPixelLength(placeStr, showPixeVec2, fontName, fontSize)
        local displayStrLen = chartWidth - placeStrLen
        displayStrLen = (displayStrLen > 0) and displayStrLen or 0
        
        for i = 1, #showPixelVec do
            local pixelInfo = showPixelVec[i]
            if pixelInfo.m_pixelWidth > displayStrLen then
                if i > 1 then
                    isJoint = true
                    pixelInfo = showPixelVec[i-1]
                    tempSubStr = string.sub(tempString, 1, pixelInfo.m_strCount)
                    break
                end
            end
        end
    else
        tempSubStr = tempString
    end

    if isJoint then
        tempSubStr = tempSubStr .. placeStr
    end
    return tempSubStr
end

function LuaUtils.getDisplayNickNameInGame(name, maxLen, showLen)
    
    return LuaUtils.GetShortName(name, maxLen or 6, showLen or 6)
end

--计算字符串显示宽度
function LuaUtils.calculateShowPixelLength( str, showPixelVec, fontName, fontSize)
    local tempString = str
    local computeCount = string.utf8len(tempString)
    local strArr = LuaUtils.utf8SubArray(str)
    local sizeWidth = 0

    for i = 1, #strArr do
        local tempLabel = nil 
        local substring = strArr[i].str
        if (cc.FileUtils:getInstance():isFileExist(fontName)) then
            tempLabel =  cc.Label:createWithTTF(substring, fontName, fontSize)
        else
            tempLabel =  cc.Label:createWithSystemFont(substring, fontName, fontSize)
        end
        tempLabel:setAnchorPoint(cc.p(0, 0.5))
--        tempLabel:setHorizontalAlignment(cocos2d::TextHAlignment::LEFT)
        local tmpLsize = tempLabel:getContentSize()
        sizeWidth = sizeWidth + tmpLsize.width
        
        local pixelInfo = {}
        pixelInfo.m_pixelWidth = sizeWidth
        pixelInfo.m_strCount = strArr[i].index - 1
        table.insert(showPixelVec, pixelInfo)
    end
    return sizeWidth, showPixelVec
end

--u_start：截取字符串开始位置
--u_end：截取字符串结束位置
function LuaUtils.utf8_sub(str, u_start, u_end)
    local temp = ""
    local n = string.len(str)
    local tempLen = 0
    local offset = 0
    local i = 1
    local asi
    local b, e
    while i <= n do
        if not b and offset >= u_start then
            b = i
        end

        asi = string.byte(str, i)
        local dis = 1
        local diffI = 1
        if asi >= 0xF0 then 
            diffI =  4
            dis = 2
        elseif asi >= 0xE0 then 
            diffI =  3
            dis = 2
        elseif asi >= 0xC0 then 
            diffI =  2
            dis = 2
--        elseif (asi >= 0x30 and asi <= 0x39) then
--            i = i + 1
        else

        end

        offset = offset + dis
        if not e and offset > u_end then
            e = i - 1
            break
        end
        i = i + diffI
    end

    if not b then 
        return str,false
    end

    if not e then 
        e = n
    end
    temp = string.sub(str, b, e)
    return temp, (n - string.len(temp)) > 0
end

function LuaUtils.utf8SubArray(str)
    if not str or str == "" then return {} end
    local temp = str
    local tempStr = ""
    local tempArr = {}
    local n = string.len(str)
    local offset = 1
    local i = 1
    local asi
    while i <= n do
        asi = string.byte(str, i)
        if asi >= 0xF0 then 
            i = i + 4
        elseif asi >= 0xE0 then 
            i = i + 3
        elseif asi >= 0xC0 then 
            i = i + 2
        else
            i = i + 1
        end
        local arr = {}
        arr.str = string.sub(temp, offset, i-1)
        arr.index = i
        table.insert(tempArr, arr)
        offset = i
        temp = str
    end
    return tempArr
end

--格式化倒计时
function LuaUtils.formatTimeDisplay(_lessTime)
    
--    if _lessTime < 60 then
--        return _lessTime
--    end

    local _fen = math.floor(_lessTime / 60)
    local _miao = math.floor(_lessTime % 60)

    if _fen < 10 then 
        _fen = "0".._fen
    end

    if _miao < 10 then 
        _miao = "0".._miao
    end

    return _fen .. ":" .. _miao
end

--读取设备的openUDID
function LuaUtils.getDeviceOpenUDID()
    local strDeviceOpenUDID = cc.UserDefault:getInstance():getStringForKey("deviceOpenUDID", "")
    if strDeviceOpenUDID == "" then  
        strDeviceOpenUDID = device.getOpenUDID()
        cc.UserDefault:getInstance():setStringForKey("deviceOpenUDID",strDeviceOpenUDID)
    end
    --md5之后md5码长度一致
    strDeviceOpenUDID = SLUtils:MD5(strDeviceOpenUDID)
    return strDeviceOpenUDID 
end

--根据当前时间生成设备ID
function LuaUtils.getDeviceOpenUDIDNew()
    local strDeviceOpenUDID = cc.UserDefault:getInstance():getStringForKey("deviceOpenUDID")
    if strDeviceOpenUDID == "" then  
        strDeviceOpenUDID = LuaNativeBridge.getInstance():getDeviceUDID()
        cc.UserDefault:getInstance():setStringForKey("deviceOpenUDID",strDeviceOpenUDID)
    end
    strDeviceOpenUDID = SLUtils:MD5(strDeviceOpenUDID)
    return  strDeviceOpenUDID
end

function LuaUtils:getDeviceType()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform) then 
        return 3 --ios
    elseif (cc.PLATFORM_OS_ANDROID == targetPlatform) then 
        return 4 --android
    elseif (cc.PLATFORM_OS_WINDOWS == targetPlatform) then
        return 2 --PC
    else 
        return 1 -- 网页
    end 
end

------------------------------------
-- 纯数字组成
function LuaUtils.string_number(str)
    for index=1, #str do
        local num = string.sub(str, index, index)
        if (num ~= '0' and num ~= '1' and
            num ~= '2' and num ~= '3' and
            num ~= '4' and num ~= '5' and
            num ~= '6' and num ~= '7' and
            num ~= '8' and num ~= '9' and 
            num ~= '.') then
            return false
        end
    end
    return true
end

-- 纯数字组成
function LuaUtils.string_number2(str)
    for index=1, #str do
        local num = string.sub(str, index, index)
        if (num ~= '0' and num ~= '1' and
            num ~= '2' and num ~= '3' and
            num ~= '4' and num ~= '5' and
            num ~= '6' and num ~= '7' and
            num ~= '8' and num ~= '9') then
            return false
        end
    end
    return true
end

-- 纯字母组成
function LuaUtils.string_word(str)
    local result = false
    for i=1, #str do
        local ch = string.byte(str, i)
        if (ch >= 97 and ch <= 122) or (ch >= 65 and ch <= 90) then
        --if((*str>='a'&&*str<='z') || (*str>='A'&&*str<='Z'))
            result = true
        else
            result = false
            break
        end
    end
    return result
end

-- 将数据转化为百分比值
function LuaUtils.DataConvertToPercent(nBaseVal,nCurData)

    local percent = 0.0
    local vecSit = {}
    
    local intergerVal = nCurData/nBaseVal
    local remainderVal = nCurData%nBaseVal
    
    local val = remainderVal
    local sum = remainderVal
    while val ~= 0 do
        val = sum/10
        remainderVal = sum%10
        vecSit[#vecSit + 1] = remainderVal
        sum = val
    end
    
    percent = intergerVal*100.0
    for i=1,#vecSit do
        local percentRate = 0.1
        for j=1, i-1 do
            percentRate = percentRate * 10.0
        end
        percent = percent + vecSit[i]*percentRate
    end
    
    return percent
end


-- 按长度截取字符串
-- isDianEnd 末尾是否加 “..”
-- nLen 为显示实际长度，一个汉字两个字节,字母数字一个字节
function LuaUtils.getDisplayString(str, fontWidth, allWidth, strDian)

    local strArr = LuaUtils.utf8SubArray(str)
    local nCount = 1
    local cw = 0

    local allCount = table.nums(strArr)
    local strLength = 0
    --fix 先计算自己的长度是否超过最大值，没超过就return
    for i = 1, allCount do
        local s = strArr[i].str
        if string.byte(s, 1) > 127 then 
            strLength = strLength + fontWidth
        else
            strLength = strLength + fontWidth/2
        end
    end
    if strLength <= allWidth then
        return str
    end

    --加上点的长度
    for i=1, string.len(strDian) do
        cw = cw + fontWidth/2
    end
    local isOut = false
    while nCount < allCount do
        local s = strArr[nCount].str
        if string.byte(s, 1) > 127 then 
            cw = cw + fontWidth
        else
            cw = cw + fontWidth/2
        end 
        if cw > allWidth then 
            isOut = true
            --为了字符长度始终不大于显示长度,-1
            nCount = nCount - 1
            break
        end
        nCount = nCount +1 
    end 

    local temp = str
    if isOut then
        temp = ""
        for i=1, nCount  do
            temp = temp..strArr[i].str
        end
        if string.len(strDian) > 0 then
            temp = temp..strDian
        end
    end
    return temp
end


-- 去掉字符串前后空格
function LuaUtils.trim(str)
    -- 去掉前空格
    while #str > 0 and string.byte(str, 1) == 32 do
        if #str == 1 then
            str = ""
        else
            str = string.sub(str, 2, #str)
        end
    end

    -- 去掉后空格
    local len = #str
    while len > 0 and string.byte(str, len) == 32 do
        if len-1 < 1 then
            str = ""
        else
            str = string.sub(str, 1, len-1)
        end
        len = #str
    end

    return str
end

function LuaUtils.check_paypassword(strPassWord)
    -- 为纯数字或纯字母
    if LuaUtils.string_number(strPassWord) or LuaUtils.string_word(strPassWord) then
        return false
    end
    
    local r1 = false
    -- 检查必须同时包含数字和字母
    for i=1,#strPassWord do
        local ch = string.byte(strPassWord, i)
        if (ch >= 97 and ch <= 122) or (ch >= 65 and ch <= 90) then
        -- if((*str1>='a'&&*str1<='z') || (*str1>='A'&&*str1<='Z'))
            r1 = true
            break
        end
    end
    local r2 = false
    for i=1,#strPassWord do
        local ch = string.byte(strPassWord, i)
        if (ch >= 48 and ch <= 57) then
        --if(((*str2)>='0' && (*str2)<='9'))
            r2 = true
            break
        end
    end
    
    local result = r1 and r2
    return result
end

--检查是否包含中文
function LuaUtils.check_include_chinese(str)
    for i=1, string.len(str) do
        local ch = string.byte(str, i)
        if ch > 127 then
            return true
        end
    end
    return false
end

-- 检查是否都是中文
function LuaUtils.check_string_chinese(str)
    for i=1, string.len(str) do
        local ch = string.byte(str, i)
        if not (ch == 46) then
            if ch <= 127 then
                return false
            end
        end

        --[[if(stru16Str[i] == u'·') then
            continue;
        end
        if(!StringUtils::isCJKUnicode(stru16Str[i]))
            return false;
        end]]
    end
    return true;
end

-- 邮箱格式验证
function LuaUtils.check_email(strEmail)
    local nLen = string.len(strEmail)
    if nLen < 5 then
        return false;
    end

    local ch = string.byte(strEmail, 1)
    if not ((ch >= 97 and ch <= 122) or (ch >= 65 and ch <= 90) or (ch >= 48 and ch <= 57))  then
    -- if !((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9')) then
        return false;
    end

    local atCount, atPos, dotCount = 0, 0, 0;
    for i=2, nLen do
        ch = string.byte(strEmail, i)
        if not ((ch >= 97 and ch <= 122) or (ch >= 65 and ch <= 90) or (ch >= 48 and ch <= 57) or
           (ch == 95) or (ch == 45) or (ch == 46) or (ch == 64) )  then
        -- if (!((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9') || (ch == '_') || (ch == '-') || (ch == '.') || (ch == '@')))
            return false;
        end
        if ch == 64 then
        -- if (ch == '@')
            atCount = atCount+1;
            atPos = i;
        elseif (atCount>0) and (ch == 46) then
        -- else if ( (atCount>0) && (ch == '.') )
            dotCount = dotCount+1;
        end
    end
    if (ch == 46 or ch == 64) then
    -- if (ch == '.' || ch == '@') then
        return false;
    end
    
    if (atCount ~= 1) or (dotCount < 1) or (dotCount > 3)  then
        return false;
    end

    -- 查找 "@." / ".@"
    for i=2, nLen do
        ch = string.byte(strEmail, i)
        if ch == 64 then -- '@'
            if i+1 < nLen then
                local tempCh = string.byte(strEmail, i+1)
                if tempCh == 46 then
                    return false
                end
            end
        elseif ch == 46 then -- '.'
            if i+1 < nLen then
                local tempCh = string.byte(strEmail, i+1)
                if tempCh == 64 then
                    return false
                end
            end
        end
    end

    --[[if ((str.find("@.") ~= str.npos) or (str.find(".@") ~= str.npos)) then
        return false;
    end]]

    return true;
end

-- 获取注册和修改昵称，保证昵称合法性
function LuaUtils.isNickVaild(str)
    for i=1, string.len(str) do
        local ch = string.byte(str, i)
        if not LuaUtils.isUnicodeValid(ch) then
            return false;
        end
    end
    --iOS 检测中文空格 连续的226 128 134
    if device.platform == "ios" then
        local index = 0
        for i=1, string.len(str) do
            local ch = string.byte(str, i)
            if ch == 226 or ch == 128 or ch == 134 then
                if ch == 226 then
                    index = 1
                end
                if index == 1 and ch == 128 then
                    index = 2
                end
                if index == 2 and ch == 134 then
                    return false
                end
            else
                index = 0
            end
        end
    end

    return true;
end

function LuaUtils.isUnicodeValid(ch)
    --print("------ch:"..ch)
    if (ch >= 48 and ch <= 57) or (ch >= 97 and ch <= 122) or (ch >= 65 and ch <= 90) or (ch == 95) then
    -- if ( (ch >= u'0' && ch <= u'9') || (ch >= u'a' && ch <= u'z') || (ch >= u'A' && ch <= u'Z') || ch == u'_' )
        return true;
    end
    
     --空格
    if ch == 32 then
        return false
    end 

    if ch == 46 then
    -- if (ch == u'.')
        return true;
    end
    
    return ch > 127;
end

------------------------------------



--// 格式化数字
function LuaUtils.FormatNumber(n)

--[[
    local strFormatGold = string.format("%lld.%02d", (n/100), int(math.abs(n)%100));
    
    if( n < 0 && n > -100 )
    {
        strFormatGold ="-" + strFormatGold;
    }
--]]

--[[
   n = n / 100
   n = string.format("%.2f",n)
   return n
--]]

   return string.format("%0.2f", n / 100)
end

function LuaUtils.isPhoneNumber(strTelNum)
	
	strTelNum = strTelNum or "";

	if #strTelNum ~= 11 then
		return false;
	end

	local tmpStr = string.sub(strTelNum, 1, 1);
	if (tonumber(tmpStr) ~= 1) then
		return false;
	end

	local strList = "0123456789";

	for index=1,11 do
		tmpStr = string.sub(strTelNum, index, index);
		if not string.find(strList, tmpStr) then
			return false;
		end
	end

	return true;
end


--中国电信号段:133、149、153、173、177、180、181、189、199
--中国联通号段:130、131、132、145、155、156、166、175、176、185、186
--中国移动号段:134(0-8)、135、136、137、138、139、147、150、151、152、157、158、159、178、182、183、184、187、188、198
--其他号段
--  电信：1700、1701、1702
--  移动：1703、1705、1706
--  联通：1704、1707、1708、1709、171
--检查是否是手机号格式
function LuaUtils.CheckIsMobile(str)
    local s = string.match(str,"[1][3,4,5,6,7,8,9]%d%d%d%d%d%d%d%d%d")
    return s == str
end

function LuaUtils.getCharLength(str)
    str = str or ""
    local strLength = 0
    local len = string.len(str)
    while str do
        local fontUTF = string.byte(str,1)

        if fontUTF == nil then
            break
        end
        --lua中字符占1byte,中文占3byte
        if fontUTF > 127 then 
            local tmp = string.sub(str,1,3)
            strLength = strLength+2
            str = string.sub(str,4,len)
        else
            local tmp = string.sub(str,1,1)
            strLength = strLength+1
            str = string.sub(str,2,len)
        end
    end
    return strLength
end

--function LuaUtils.getGenderByFaceID( id )

--    if 0 <= id and id <= 4 then --女
--        return 0
--    end
--    if 5 <= id and id <= 9 then --男
--        return 1
--    end
--    return 1
--end

function LuaUtils.makeScreenBlur( node )
--    local fileName = "printScreen.png"
--    cc.Director:getInstance():getTextureCache():removeTextureForKey(fileName)
--    cc.utils:captureScreen(function(succeed, outputFile)
--        if succeed then
--            local winSize = cc.Director:getInstance():getWinSize()
--            local sprite_photo = cc.Sprite:create(outputFile)
--            sprite_photo:setScale(1.5)
--            sprite_photo:setName("blurSprite")
--            node:addChild(sprite_photo,49)
--            sprite_photo:setPosition(cc.p(display.width /2, display.height /2))
--            sprite_photo:visit()
--            local size = sprite_photo:getTexture():getContentSizeInPixels()
--            local program = cc.GLProgram:createWithFilenames("res/public/shader/2d_default.vsh", "res/public/shader/example_Blur.fsh")
--            local gl_program_state = cc.GLProgramState:getOrCreateWithGLProgram(program)
--            sprite_photo:setGLProgramState(gl_program_state)
--            sprite_photo:getGLProgramState():setUniformVec2("resolution", cc.p(size.width, size.height))
--            sprite_photo:getGLProgramState():setUniformFloat("blurRadius", 16)
--            sprite_photo:getGLProgramState():setUniformFloat("sampleNum", 8)
--            --再次截屏
--            local render_texture1 = cc.RenderTexture:create(win_size.width, win_size.height)
--            render_texture1:begin()
--            sprite_photo:visit()
--            render_texture1:endToLua()
--            local photo_texture1 = render_texture1:getSprite():getTexture()
--            local sprite_photo1 = cc.Sprite:createWithTexture(photo_texture1)
--            sprite_photo1:setPosition(cc.p(size.width /2, size.height /2))
--            node:removeChild(sprite_photo)
--            return sprite_photo1
--        else
--            return nil
--        end
--    end, fileName)

--    local win_size = cc.Director:getInstance():getWinSize()
--    --截屏
--    local render_texture = cc.RenderTexture:create(win_size.width, win_size.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, 0x88F0)
--    render_texture:begin()
--    node:visit()
--    render_texture:endToLua()
--    local photo_texture = render_texture:getSprite():getTexture()
--    local sprite_photo = cc.Sprite:createWithTexture(photo_texture)
--    node:addChild(sprite_photo,100)
--    sprite_photo:setPosition(cc.p(display.width /2, display.height /2))
--    sprite_photo:visit()
--    local size = sprite_photo:getTexture():getContentSizeInPixels()
--    local program = cc.GLProgram:createWithFilenames("res/public/shader/2d_default.vsh", "res/public/shader/example_Blur.fsh")
--    local gl_program_state = cc.GLProgramState:getOrCreateWithGLProgram(program)
--    sprite_photo:setGLProgramState(gl_program_state)
--    sprite_photo:getGLProgramState():setUniformVec2("resolution", cc.p(size.width, size.height))
--    sprite_photo:getGLProgramState():setUniformFloat("blurRadius", 16)
--    sprite_photo:getGLProgramState():setUniformFloat("sampleNum", 8)
--    --再次截屏
--    local render_texture1 = cc.RenderTexture:create(win_size.width, win_size.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, 0x88F0)
--    render_texture1:begin()
--    sprite_photo:visit()
--    render_texture1:endToLua()
--    local photo_texture1 = render_texture1:getSprite():getTexture()
--    local sprite_photo1 = cc.Sprite:createWithTexture(photo_texture1)
--    sprite_photo1:setPosition(cc.p(size.width /2, size.height /2))
--    node:removeChild(sprite_photo)

     local winSize = cc.Director:getInstance():getWinSize()
     local layout = ccui.Layout:create()
     layout:setContentSize(winSize)
     layout:setTouchEnabled(false)
     layout:setBackGroundColor(cc.c3b(0, 0, 0))
     layout:setBackGroundColorType(1)
     layout:setBackGroundColorOpacity(255*0.4)

    return layout
end

----------------------
-- 目前只有登录和大厅是适配了 iPhoneX
LuaUtils.screenDiffX = 145  -- 宽屏原点相对窄屏原点在X轴左边多出的距离
LuaUtils.IphoneXDesignResolution = false -- 是否适配宽屏
-- 设置 iPhoneX 适配设计分辨率 1624 * 750
function LuaUtils.setIphoneXDesignResolution()
    if LuaUtils.isIphoneXDesignResolution() then
        display.setAutoScale({width = 1624, height = 750, autoscale = "FIXED_HEIGHT"})
        LuaUtils.screenDiffX = (display.width - 1334)/2
        LuaUtils.IphoneXDesignResolution = true
    else
        display.setAutoScale({width = 1334, height = 750, autoscale = "EXACT_FIT"})
        LuaUtils.IphoneXDesignResolution = false
    end
end

-- 还原设计分辨率 1334 * 750
function LuaUtils.resetDesignResolution()
    display.setAutoScale({width = 1334, height = 750, autoscale = "SHOW_ALL"})
end

--识别全面屏
function LuaUtils.isIphoneXDesignResolution()
    local director = cc.Director:getInstance()
    local view = director:getOpenGLView()
    local frameSize = view:getFrameSize()

    --iphoneX适配
    if cc.PLATFORM_OS_IPHONE == cc.Application:getInstance():getTargetPlatform() then
        if frameSize.width == 2436 and frameSize.height == 1125 then
            return true
        end
    end

   if cc.PLATFORM_OS_WINDOWS == cc.Application:getInstance():getTargetPlatform() then
        if frameSize.width / frameSize.height >= 1.8 then
            return true
        end
    end

    --android > 16:9 的也可以类似iPhoneX来适配
--    if cc.PLATFORM_OS_ANDROID == cc.Application:getInstance():getTargetPlatform() 
--    or cc.PLATFORM_OS_WINDOWS == cc.Application:getInstance():getTargetPlatform()
--    then
--        if frameSize.width / frameSize.height >= 1.8 then
--            return true
--        end
--    end

    return false
end

--识别IphoneX
function LuaUtils.isMobileIphoneX()
    local director = cc.Director:getInstance()
    local view = director:getOpenGLView()
    local frameSize = view:getFrameSize()

    if cc.PLATFORM_OS_IPHONE == cc.Application:getInstance():getTargetPlatform()
    and (frameSize.width == 2436 and frameSize.height == 1125)
    then
        return true
    end

    return false
end

LuaUtils.setIphoneXDesignResolution()
----------------------


--输出运行时间（多次调用 分段获取）
local lasttime = 0
function LuaUtils.runtime(info)
    local info = info or ""
    local curtime = cc.exports.gettime()
    lasttime = lasttime>0 and lasttime or curtime
    local deltatime = curtime - lasttime
    lasttime = curtime
    printf("[runtime] %f %s", deltatime, info)
end

--@brief 切割字符串，并用“...”替换尾部
--@param sName:要切割的字符串
--@return nMaxCount，字符串上限,中文字为2的倍数
--@param nShowCount：显示英文字个数，中文字为2的倍数,可为空
--@note 函数实现：截取字符串一部分，剩余用“...”替换
function LuaUtils.GetShortName(sName, nMaxCount, nShowCount)
    if sName == nil or nMaxCount == nil then
        return
    end
    local sStr = sName
    local tCode = {}
    local tName = {}
    local nLenInByte = #sStr
    local nWidth = 0
    if nShowCount == nil then
       nShowCount = nMaxCount - 3
    end
    for i=1,nLenInByte do
        local curByte = string.byte(sStr, i)
        local byteCount = 0;
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        local char = nil
        if byteCount > 0 then
            char = string.sub(sStr, i, i+byteCount-1)
            i = i + byteCount -1
        end
        if byteCount == 1 then
            nWidth = nWidth + 1
            table.insert(tName,char)
            table.insert(tCode,1)
            
        elseif byteCount > 1 then
            nWidth = nWidth + 2
            table.insert(tName,char)
            table.insert(tCode,2)
        end
    end
    
    if nWidth > nMaxCount then
        local _sN = ""
        local _len = 0
        for i=1,#tName do
            _sN = _sN .. tName[i]
            _len = _len + tCode[i]
            if _len >= nShowCount then
                break
            end
        end
        sName = _sN .. "..."
    end
    return sName
end

--- 获取utf8编码字符串正确长度的方法
-- @param str
-- @return number
function LuaUtils.utfstrlen(str)
    local len = #str
    local left = len
    local cnt = 0
    local arr = { 0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc, }
    while left ~= 0 do
        local tmp = string.byte(str, -left)
        local i = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i=i-1
        end
        cnt = cnt + 1
    end
    return cnt
end

cc.exports.LuaUtils = LuaUtils
return cc.exports.LuaUtils
--endregion
