--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local SpreadInfoView = class("SpreadInfoView", cc.Layer)

--lzg 先注释掉
    --[[
    local UsrMsgManager = require("common.manager.UsrMsgManager")
    local RegisterView = require("hall.bean.RegisterView")
    ]]--
local HeadSprite = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
local SpreadMoldView = require(appdf.PLAZA_VIEW_SRC.."SpreadMoldView")
local cjson = require("cjson")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
--lzg
--[[
    local crypto = require("cocos.crypto")
]]--
local G_SpreadInfoView = nil
function SpreadInfoView.create()
    G_SpreadInfoView = SpreadInfoView.new():init()
    return G_SpreadInfoView
end

function SpreadInfoView:ctor()
    self:enableNodeEvents()
    self.m_rootUI = display.newNode()
        :addTo(self)
end

function SpreadInfoView:init()

    self.m_pathUI = cc.CSLoader:createNode("hall/csb/SpreadInfoView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    self.m_pNodeRoot    = self.m_pathUI:getChildByName("SpreadInfoView")

    self.pNodeTable     = self.m_pNodeRoot:getChildByName("Panel_node_info")  
    self.m_pLbNickName  = self.pNodeTable:getChildByName("Label_name")
    self.spHeadIcon     = self.pNodeTable:getChildByName("Image_icon_frame"):getChildByName("Image_head_icon")

    self.m_pLbSpreadInfo = {}
    for i = 1, 3 do
        local nodeName = "TXT_spreadInfo"..i
        self.m_pLbSpreadInfo[i] = self.pNodeTable:getChildByName(nodeName)
    end

    --等级
    self.m_pSpCurrentLv  = self.pNodeTable:getChildByName("Image_lv_now")
    self.m_pNodeNextLv = self.pNodeTable:getChildByName("Node_lv_next")
    self.m_pSpNextLv = self.m_pNodeNextLv:getChildByName("Image_lv_next")
    self.m_pSpProgressBg = self.pNodeTable:getChildByName("Image_progress_bg")

    --二维码
    self.m_pNodeQR = self.pNodeTable:getChildByName("Node_qr")
    self.m_pSpMold = self.m_pNodeQR:getChildByName("Image_mold")
    self.m_pSpQR = self.m_pNodeQR:getChildByName("Image_qr")
    self.m_pBtnSaveCode = self.m_pNodeQR:getChildByName("BTN_save")  
    self.m_pBtnSaveCode:addClickEventListener(handler(self, self.onSaveCodeClicked))
    self.m_pBtnPreLook = self.m_pNodeQR:getChildByName("BTN_prelook")  
    self.m_pBtnPreLook:addClickEventListener(handler(self, self.onLookMoldClicked))

    --游客
    self.m_pNodeGuestTip = self.m_pNodeRoot:getChildByName("Panel_node_guest")  
    self.m_pBtnBind = self.m_pNodeGuestTip:getChildByName("BTN_bind")  
    self.m_pBtnBind:addClickEventListener(handler(self, self.onInstantRegisterClicked))

    --update info
    self:UpdateHeadImageAndNickName()
    self.m_pNodeQR:setVisible(true)

    --lzg
    local gameID = 3-- PlayerInfo.getInstance():getGameID()
    self.m_QRFilePath = cc.FileUtils:getInstance():getWritablePath() .. gameID .. "qr.jpg"

    local moldIndex = cc.UserDefault:getInstance():getIntegerForKey("SpreadMoldIndex",1)
    --lzg
    GlobalUserItem.m_nSpreadMoldIndex = moldIndex
    --[[
    if PlayerInfo.getInstance():getIsGuest() then
        self.m_pNodeGuestTip:setVisible(true)
        self.pNodeTable:setVisible(false)
    else
        self.m_pNodeGuestTip:setVisible(false)
        self.pNodeTable:setVisible(true)
        self:onMsgSpreadInfo()
    end
    --]]
    return self
end

function SpreadInfoView:UpdateHeadImageAndNickName()
    -- 创建头像
    local head = HeadSprite:createNormal(GlobalUserItem.tabAccountInfo, 124)
    if nil ~= head then
         head:setPosition(ccp(self.spHeadIcon:getPositionX()-28,self.spHeadIcon:getPositionY()-15))
         self.spHeadIcon:addChild(head)
    end
    -- 创建昵称
    local strNickName = GlobalUserItem.tabAccountInfo.nickname
    if nil ~= strNickName then
         self.m_pLbNickName:setString(strNickName)
    end
    
end

function SpreadInfoView:onEnter()
    self.UpdataSpreadInfo = SLFacade:addCustomEventListener(Hall_Events.MSG_UPDATE_USR_SPREAD_INFO, handler(self, self.onMsgSpreadInfo))
    self.UpdataSpreadMold = SLFacade:addCustomEventListener(Hall_Events.MSG_UPDATE_SPREAD_MOLD, handler(self, self.onMsgSpreadMode))
    --[[
    if not PlayerInfo.getInstance():getIsGuest() then
        CMsgHall:sendGetSpreadLevel()
        if not UsrMsgManager.getInstance():getHaveSpreadQR() then
            self:requestQRCode()
        else
            self:showSpreadQR()
        end
    end
    ]]--
end

function SpreadInfoView:onExit()
    SLFacade:removeEventListener(self.UpdataSpreadInfo)
    SLFacade:removeEventListener(self.UpdataSpreadMold)

    G_SpreadInfoView = nil
end

function SpreadInfoView:requestQRCode()

    local url = ClientConfig:getInstance():getSpreadQRCodeUrl()
    --lzg
    --[[
    local userID = PlayerInfo.getInstance():getUserID()
    local strPostData = string.format("UserID=%d", userID)
    print("strPostData =", strPostData)
    --]]
    -- 加密处理x
    local strDataEncrypt = SLUtils:aes256Encrypt(strPostData)
    print("strDataEncrypt:"..strDataEncrypt)
    local strPostDataEncrypt = "data="..strDataEncrypt
    print("strPostDataEncrypt = ", strPostDataEncrypt)
    local strUrl = string.format("%s?%s", url, strPostDataEncrypt)
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON 
    --xhr.timeout = 5
    xhr:open("GET", strUrl)
    local function onReadyStateChange()
        print("Http Status Code:"..xhr.status)
        if(xhr.status == 200) then
            local response = xhr.response
            print("Http Response:"..response)
            if(response ~= nil) then
                local httpStartPos,httpEndPos = string.find(response, "{\"")
                if httpStartPos == 1 then  --兼容老版本,需要简单判断一下是不是json格式
                    -- 解析json数据
                    --response = "{\"status\":1,\"msg\":\"ok\",\"data\":{\"UserID\":\"1\",\"image\":\"iVBORw0KGgoAAAANSUhEUgAAAG8AAABvAQMAAADYCwwjAAAABlBMVEX///8AAABVwtN+AAABZElEQVQ4jbXUsa3DIBAG4LMo3NkLILEGHSslC8T2ArASHWsgsQDuKCzf+/F7T6kCboJS8Fm66A7uIPraEsxx8ckampnXHleKA6dMNNV9h64gVpJR1qQbTC6oPNJ0j9aojY87RFYvEqd5J9kgc7K6/txf+Q3W9dA0oIr/9Zkij8fL4HB4NX3uHvko9pz10SMNIe2lFruz7FFsXjikpI9niT3SEtKJj0WwV2uHwrHAsbsiX9QlzYEtih1pKDXJJhErJ01zUau+7rdJiws1fGKva2ybrgg7Ci5yCVeSLdKk+TRyCOrUossHkvfYyNnXk2xScDhmr3bP+1Vvm1vASR6L5437tGMktNYYn3eIqzHC6ogvXWaNKLUXxVdsk3SFo1US/mHtsE4ZArPGy3BQjyul2rF1cH6HvUW8Oc+rV7kQ3SAZ3lllE+8Qr9lcMPLvx+0TkdWJWfBxCJF6RL0ZraUx7LLHr60fSjJomQ8GZ98AAAAASUVORK5CYII=\"}}"
                    local jsonConf = cjson.decode(response)
                    if jsonConf ~= nil then 
                        local dicStatus = jsonConf.status
                        if dicStatus == 1 then 
                            local dicData =  jsonConf.data
                            if G_SpreadInfoView then
                                G_SpreadInfoView:onDownloadQRSuccess(dicData.image)
                            end
                        else 
                            local dicMsg = jsonConf.msg
                            FloatMessage.getInstance():pushMessage(dicMsg)
                        end 
                    end
                end
            end
        end
        xhr:unregisterScriptHandler()
    end
    xhr:registerScriptHandler(onReadyStateChange) -- 注册脚本方法回调
    xhr:send()-- 发送
end

function SpreadInfoView:onDownloadQRSuccess(dicImage)
    local fileData = crypto.decodeBase64(dicImage)
    print("fileData:",fileData)
    local file = io.open(self.m_QRFilePath,"wb")
    if file ~= nil then
        file:write(fileData)
        file:close()
        UsrMsgManager.getInstance():setHaveSpreadQR(true)
        self:showSpreadQR()
    else
        file:close()
    end
end

function SpreadInfoView:showSpreadQR()

    local texture2d = cc.Director:getInstance():getTextureCache():addImage(self.m_QRFilePath)
    if texture2d == nil then
        self:requestQRCode()
        return
    end
    self.m_pNodeQR:setVisible(true)
--    self.m_pSpQR:setTexture(texture2d)

    local spqr =self.m_pSpQR:getChildByName("sp_qr")
    if spqr then
        spqr:removeFromParent()
    end
    local sp = cc.Sprite:createWithTexture(texture2d)
    sp:setAnchorPoint(cc.p(0,0))
    sp:setScale(1.05)
    sp:setPosition(cc.p(0,0))
    sp:setName("sp_qr")
    self.m_pSpQR:addChild(sp)

    local strMold = string.format("hall/image/file/image-spread-mold-%d.jpg",UsrMsgManager.getInstance():getSpreadMoldIndex())
    self.m_pSpMold:setTexture(strMold)
end

function SpreadInfoView:saveToAlbum(dt)
    --图片保存到相册
    self.m_bIsSaveing = false
    local imageName = "qr.png" 
    local fullpath = cc.FileUtils:getInstance():fullPathForFilename(imageName)
    if true ==  MultiPlatform:getInstance():saveImgToSystemGallery(fullpath,imageName) then
       FloatMessage.getInstance():pushMessage("二维码已经保存到相册")
    end
end

function SpreadInfoView:onMsgSpreadInfo(_event)
    -- 刷新推广信息
    local strData = {}
    strData[1] = string.format("%d",UsrMsgManager.getInstance():getSpreadTotalCount());
    strData[2] = LuaUtils.getFormatGoldAndNumber(UsrMsgManager.getInstance():getAllRevenue());
    strData[3] = LuaUtils.getFormatGoldAndNumber(UsrMsgManager.getInstance():getGainRevenue());

    for i = 1, 3 do
        self.m_pLbSpreadInfo[i]:setString(strData[i]);
    end

    local currentLevel = UsrMsgManager.getInstance():getSpreadCurrentLevel()
    local str1 = string.format("gui-spread-lv%d.png",currentLevel)
    self.m_pSpCurrentLv:setSpriteFrame(str1)
    if currentLevel >= UsrMsgManager.getInstance():getSpreadAwardLevelCount() then
        --达到最大等级
        self.m_pNodeNextLv:setVisible(false)
    else
        self.m_pNodeNextLv:setVisible(true)
        local str2 = string.format("gui-spread-lv%d.png",currentLevel+1)
        self.m_pSpNextLv:setSpriteFrame(str2)
    end

    local percent = 0
    local spreadLevel = UsrMsgManager.getInstance():getSpreadAwardLevelData(currentLevel+1)
    if spreadLevel and spreadLevel.llMinAward > 0 then 
        percent = UsrMsgManager.getInstance():getSpreadTotalAward() / spreadLevel.llMinAward * 100
    end
    --进度条
    self.m_pProgressForward = ccui.LoadingBar:create()
    self.m_pProgressForward:loadTexture("gui-spread-lv-progress.png", ccui.TextureResType.plistType)
    self.m_pProgressForward:setDirection(ccui.LoadingBarDirection.LEFT)
    self.m_pProgressForward:setAnchorPoint(cc.p(0,0.5))
    self.m_pProgressForward:setPosition(cc.p(0,13))
    self.m_pProgressForward:setPercent(percent)
    self.m_pProgressForward:addTo(self.m_pSpProgressBg)
end

function SpreadInfoView:onMsgSpreadMode(_event)
    local strMold = string.format("hall/image/file/image-spread-mold-%d.jpg",GlobalUserItem.m_nSpreadMoldIndex)
    self.m_pSpMold:setTexture(strMold)
end

function SpreadInfoView:onSaveCodeClicked()
    ExternalFun.playClickEffect()

    if self.m_bIsSaveing then
        return
    end
    self.m_bIsSaveing = true

    local strMold = string.format("hall/image/file/image-spread-mold-%d.jpg",tonumber(GlobalUserItem.m_nSpreadMoldIndex))
    local spMold = cc.Sprite:create(strMold)
    spMold:setAnchorPoint(cc.p(0, 0));
    spMold:setPosition(cc.p(0,0));

    local lSize =  spMold:getContentSize()

    local layer = cc.LayerColor:create(cc.c4b(255,255,255,255), lSize.width, lSize.height);
    layer:setAnchorPoint(cc.p(0, 0));
    layer:setPosition(cc.p(0,0));
    layer:addChild(spMold)
    
    --lzg先去掉二维码
--    local texture2d = cc.Director:getInstance():getTextureCache():addImage(self.m_QRFilePath)
--    local sp = cc.Sprite:createWithTexture(texture2d)
--    sp:setAnchorPoint(cc.p(0.5,0));
--    sp:setScale(2.2)
--    sp:setPosition(cc.p(lSize.width*0.5,10));
--    layer:addChild(sp);

    
    local renderTexture = cc.RenderTexture:create(lSize.width, lSize.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888);
    renderTexture:beginWithClear(0, 0, 0, 0);
    layer:visit();
    renderTexture:endToLua()
    renderTexture:saveToFile("qr.png" , cc.IMAGE_FORMAT_PNG)
    self:ActionDelay(self, function()
        self:saveToAlbum()
    end, 0.8)
end

function SpreadInfoView:ActionDelay(_delegate, call, time)
    
    local delay = cc.DelayTime:create(time or 0.3)
    local callback = cc.CallFunc:create(handler(_delegate, call))
    local seq = cc.Sequence:create(delay, callback)
    _delegate:runAction(seq)
end

-- 升级成正式帐号
function SpreadInfoView:onInstantRegisterClicked(pSender)
    ExternalFun.playClickEffect()

    self:getParent():getParent():getParent():getParent():addChild(RegisterView.create(2), G_CONSTANTS.Z_ORDER_TOP)
end

-- 选择模板
function SpreadInfoView:onLookMoldClicked(pSender)
     ExternalFun.playClickEffect()

     self:getParent():getParent():getParent():getParent():addChild(SpreadMoldView:create(), 100)
end

return SpreadInfoView
--endregion
 