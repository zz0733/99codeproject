
--app store 成功or失败 通知lua刷新银行界面
function cc.exports.RechargeAppStoreStatus(status)
    if status == "success" then
        print("appstore recharge success")
        SLFacade:dispatchCustomEvent(Public_Events.MSG_APPSTORE_STATUS, "success")
    end  

    if status == "failed" then
        print("appstore recharge failed")
        SLFacade:dispatchCustomEvent(Public_Events.MSG_APPSTORE_STATUS, "failed")
    end    
end

cc.exports.reloadLua = function(filename)
    package.loaded[filename] = nil
    require(filename)
end

function ActionLoading(_delegate, call, time)
    
    local delay = cc.DelayTime:create(time or 0.3)
    local callback = cc.CallFunc:create(handler(_delegate, call))
    local seq = cc.Sequence:create(delay, callback)
    _delegate:runAction(seq)
end

function ActionDelay(_delegate, call, time)
    
    local delay = cc.DelayTime:create(time or 0.3)
    local callback = cc.CallFunc:create(handler(_delegate, call))
    local seq = cc.Sequence:create(delay, callback)
    _delegate:runAction(seq)
end

--是否竖屏
function isPortraitView()
    
    local pGLView = cc.Director:getInstance():getOpenGLView()
    local fSize = pGLView:getFrameSize()
    return fSize.width < fSize.height
end

function table.copy(src, dst)
  if src == nil then
    print("!!! try copy nil table")
    return nil
  end
  if dst == nil then
    dst = {}
  end

  for k,v in pairs(src) do
    dst[k] = v
  end
  return dst
end

local DEEP_COPY_REF_TABLE = {}
local function deepcopy(orig, depth)
    if depth == nil then
        depth = ""
    end

    if DEEP_COPY_REF_TABLE[orig] ~= nil then
        return DEEP_COPY_REF_TABLE[orig]
    end

    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        if orig.NON_DEEP_COPY == true then
            return orig
        end
        
        DEEP_COPY_REF_TABLE[orig] = copy
        for orig_key, orig_value in next, orig, nil do
            if orig_key == "class" then
                copy[orig_key] = orig_value
            else
                local copy_val = deepcopy(orig_value, depth.."    ")
                copy[deepcopy(orig_key)] = copy_val
            end
        end
        setmetatable(copy, getmetatable(orig))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function table.deepcopy( orig )
    local ret = deepcopy(orig)
    DEEP_COPY_REF_TABLE = {}
    return ret
end

function setDefault(tb, defaultValue)
    local mt = {__index = function () 
        return defaultValue
    end, }
    setmetatable(tb, mt)
end

function setReadOnly(tb)

    local mt = {__newindex = function(t, k, v)
        error("attempt to update a read-only table!")
        return nil
    end, }
    setmetatable(tb, mt)
end

--导入.csv文件
function loadCSV(filePath)   

    local function split(str, reps)  
        local resultStrsList = {} 
        string.gsub(str, '[^' .. reps ..']+', function(w) table.insert(resultStrsList, w) end ) 
        return resultStrsList 
    end  
    -- 读取文件  
    local data = cc.FileUtils:getInstance():getStringFromFile(filePath) 
    -- 按行划分  
    local lineStr = split(data, '\n\r') 
    --[[  
        从第3行开始保存（第一行是标题，第二行是注释，后面的行才是内容）   
        用二维数组保存：arr[ID][属性标题字符串]  
    --]]
    local titles = split(lineStr[1], ",") 
    local ID = 1 
    local arrs = {} 
    for i = 3, #lineStr, 1 do

        -- 一行中，每一列的内容  
        local content = split(lineStr[i], ",") 
  
        -- 以标题作为索引，保存每一列的内容，取值的时候这样取：arrs[1].Title  
        arrs[ID] = {} 
        for j = 1, #titles, 1 do  
            arrs[ID][titles[j]] = content[j] 
        end  
  
        ID = ID + 1 
    end  
  
    return arrs 
end
--local nick = loadCSV("config/test.csv")

function sz_T2S(_t) --table转string
    local szRet = "{"  
    table.foreach(_t, function(_i, _v)  
        if "number" == type(_i) then  
            szRet = szRet .. "[" .. _i .. "] = "  
            if "number" == type(_v) then  
                szRet = szRet .. _v .. ","  
            elseif "string" == type(_v) then  
                szRet = szRet .. '"' .. _v .. '"' .. ","  
            elseif "table" == type(_v) then  
                szRet = szRet .. sz_T2S(_v) .. ","  
            else  
                szRet = szRet .. "nil,"  
            end  
        elseif "string" == type(_i) then  
            szRet = szRet .. '["' .. _i .. '"] = '  
            if "number" == type(_v) then  
                szRet = szRet .. _v .. ","  
            elseif "string" == type(_v) then  
                szRet = szRet .. '"' .. _v .. '"' .. ","  
            elseif "table" == type(_v) then  
                szRet = szRet .. sz_T2S(_v) .. ","  
            else  
                szRet = szRet .. "nil,"  
            end  
        end  
    end )  
    szRet = szRet .. "}"  
    return szRet  
end  

function splitLuaString(str, delimiter) --table_string转lua_string
    if (delimiter=='') then return false end  
    local pos,arr = 0, {}  
    -- for each divider found  
    for st,sp in function() return string.find(str, delimiter, pos, true) end do  
        table.insert(arr, string.sub(str, pos, st - 1))  
        pos = sp + 1  
    end  
    table.insert(arr, string.sub(str, pos))  
    return arr  
end  

function writeLuaFile(str, file) --string写入file
    os.remove(file);  
    local file=io.open(file,"ab");  
  
    local len = string.len(str);  
    local tbl = splitLuaString(str, "\n");  
    for i = 1, #tbl do  
        file:write(tbl[i].."\n");  
    end  
    file:close();  
end

function saveTableToLua(table, file)
    
    if type(table) ~= "table" then
        return
    end
    if type(file) ~= "string" then
        return
    end

    local strTable = sz_T2S(table)
    writeLuaFile(strTable, file)
end

 --迭代器(升序)
function pairsByKeys(t)      
    local a = {}      
    for n in pairs(t) do          
        a[#a+1] = n      
    end      
    table.sort(a)      
    local i = 0      
    return function()          
    i = i + 1          
    return a[i], t[a[i]]      
    end  
end

--迭代器(降序)
function pairsByKeys2(t)      
    local a = {}      
    for n in pairs(t) do          
        a[#a+1] = n      
    end
    table.sort(a, function(var1, var2)
        return var1 > var2
    end)
    local i = 0      
    return function()          
    i = i + 1          
    return a[i], t[a[i]]      
    end  
end

--游戏内菜单节点
--menu:活动菜单node
function createClipMenu(menu)
    local pos = cc.p(menu:getPosition())
    local size = menu:getContentSize()
    local shap = cc.DrawNode:create()
    local pointArr = { 
        cc.p(pos.x, pos.y), 
        cc.p(pos.x + size.width, pos.y), 
        cc.p(pos.x + size.width, pos.y + size.height), 
        cc.p(pos.x, pos.y + size.height),
    }
    shap:drawPolygon(pointArr, 4, cc.c4f(255, 255, 255, 255), 2, cc.c4f(255, 255, 255, 255))
    local node = cc.ClippingNode:create(shap)
    return node
end

function getPositionWithPopRect(size1, size2, dir, posAdd)--1-up;2-down;3-left;4-right
    
    local pos = { --up/down/left/right
        cc.p(0, size1.height/2 + size2.height/2),
        cc.p(0, 0 - size1.height/2 - size2.height/2),
        cc.p(0 - size1.width/2 - size2.width/2, 0),
        cc.p(size1.width/2 + size2.width/2, 0),
    }
    local offset_add = posAdd
    local offset_sub = cc.p(size2.width/2, size2.height/2)
    local ret = cc.pAdd(offset_add, cc.pSub(pos[dir], offset_sub))
    return ret
end

function getReleaseResource(str)

    --local subStr = {}
    --local retStr = ""
    local memStr = ""
    local i = 0
    while true do
        i = string.find(str, "\n", i+1)
        if i == nil then 
            local str1 = string.find(str, " for ", 1, false)
            local str2 = string.find(str, " KB ", 1, false)
            local str3 = string.sub(str, str1 + 5, str2)
            local str4 = string.format("%0.4f MB", str3 / 1024)
            memStr = str4
            break
        end
        --subStr[#subStr+1] = i
    end
    --i = 1
    --for k, v in pairs(subStr) do
    --    local str1 = string.sub(str, i, v)
    --    local start = string.find(str1, "res/")
    --    local stop = string.find(str1, ".png")
    --    if start and stop then
    --        local str3 = string.sub(str1, start + 4, stop + 3)
    --        table.insert(retStr, str3)
    --        local str4 = string.format("%d : %s\n", k, str3)
    --        retStr = retStr..str4
    --    end
    --    i = v
    --end
    return memStr
end

function getCardStrings(cbCardData)
    
    local strCard = ""
    for k, v in pairs(cbCardData) do
        if v > 0 then
            strCard = strCard .. getCardString(v) .. ","
        else
            break
        end
    end
    return strCard
end

function getCardString(cbCardData)
    local STRING_COLOR = { [0] = "♦", [16] = "♣", [32] = "♥", [48] = "♠", }
    local STRING_COLOR = { [0] = "[方块]", [16] = "[梅花]", [32] = "[红桃]", [48] = "[黑桃]", [64] = "", }
    local STRING_VALUE = { "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "小王", "大王", }

    local color = bit.band(cbCardData, 0xF0)
    local value = bit.band(cbCardData, 0x0F)

    local card = string.format("%s%s", STRING_COLOR[color], STRING_VALUE[value])
    return card
end

function onOpenLayer(layer, shadow, root)
    if layer then
        local scale1 = 0.75
        local scale2 = 1.0
        local time = 0.3
        local scaleto = cc.EaseBackOut:create(cc.ScaleTo:create(time, scale2))
        layer:setScale(scale1)
        layer:runAction(scaleto)
    end

    if shadow then
        local opacity1 = 100
        local opacity2 = 255
        local time = 0.3
        local fadeto = cc.FadeTo:create(time, opacity2)
        shadow:setOpacity(opacity1)
        shadow:runAction(fadeto)
    end
end

function onCloseLayer(layer, shadow, root)
    
    if layer and root then
        local scale1 = 1.0
        local scale2 = 0.5
        local time = 0.3
        local scaleto = cc.EaseBackIn:create(cc.ScaleTo:create(time, scale2))
        local close = cc.CallFunc:create(function() root:removeFromParent() end)
        local seq = cc.Sequence:create(scaleto, close)
        layer:setScale(1.0)
        layer:runAction(seq)
    end

    if shadow then
        local opacity1 = 255
        local opacity2 = 50
        local time = 0.3
        local fadeto = cc.FadeTo:create(time, opacity2)
        shadow:setOpacity(opacity1)
        shadow:runAction(fadeto)
    end
end

function createSpark(imagePath)
    
    --创建裁剪节点
    local clip = cc.ClippingNode:create()

    --创建底图
    local gameTitle = cc.Sprite:create(imagePath)
    gameTitle:addTo(clip, 1)

    --创建扫光
    local spark = cc.Sprite:create("hall/login/login-spark.png")
    spark:setScale(1.0, 1.0)
    spark:addTo(clip, 2)

    --设置裁剪
    local size = gameTitle:getContentSize()
    clip:setStencil(gameTitle) --设置裁剪模板
    clip:setContentSize(size)  --设置裁剪节点大小  
    clip:setAlphaThreshold(0)  --设置透明度阈值

    --扫光动作
    local moveBegin = cc.Place:create(cc.p(-size.width / 2, 0))
    local moveAction = cc.MoveTo:create(2.5, cc.p(size.width, 0))
    local moveBack = cc.MoveTo:create(2.5, cc.p(-size.width, 0))
    local seq = cc.Sequence:create(moveAction, moveBack)
    local repeatAction = cc.RepeatForever:create(seq)
    spark:runAction(repeatAction)

    return clip
end

function loadHeadMiddleImg(sprite, sex, index)

    if sprite == nil then
        return
    end

    local faceid = index%11 == 0 and 1 or index%11
    local str = ""
    if sex == 0 then
        str = string.format("head_mman_%02d.png", faceid)
    else
        str = string.format("head_mwoman_%02d.png", faceid)
    end
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
    if nil ~= frame then
        ------self.m_spRender = cc.Sprite:createWithSpriteFrame(frame)
        sprite:setSpriteFrame(frame)
        sprite:setScale(0.7)
        ------self:setContentSize(self.m_spRender:getContentSize())
    end
    ------self.m_fScale = self.m_headSize / SYS_HEADSIZE
    ------self:setScale(self.m_fScale)
end

function createStencilAvatar(spritAvatar)

    if spritAvatar == nil then
        return
    end

    local size = spritAvatar:getContentSize()
    local tx = cc.Sprite:create('game/handredcattle/image/tx_2.png')
    if tx ~= nil then
        tx:addTo(spritAvatar,-1)
        tx:setScale(size.width/tx:getContentSize().width)
        tx:setAnchorPoint(cc.p(0,0))
    end

    local mark = cc.Sprite:create('game/handredcattle/image/tx_mask.png')
    if mark ~= nil then
        mark:addTo(spritAvatar,-2)
        mark:setScale(size.width/mark:getContentSize().width)
        mark:setAnchorPoint(cc.p(0,0))
    end
end
