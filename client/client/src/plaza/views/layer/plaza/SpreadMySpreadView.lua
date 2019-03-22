--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local SpreadInfoView = class("SpreadInfoView",FixLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame") 
local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
local ClientPopWait = appdf.req(appdf.EXTERNAL_SRC .. "ClientPopWait")
local ShareWindowHelp  = appdf.req(appdf.PLAZA_VIEW_SRC .. "ShareWindowHelp")
local G_SpreadInfoView = nil
function SpreadInfoView.create()
    G_SpreadInfoView = SpreadInfoView.new():init()
    return G_SpreadInfoView
end

function SpreadInfoView:ctor()
    self.QRurl = ""
    self.rewardWeek = 0
    self.rewardDay = 0
    self:enableNodeEvents()
    self.m_rootUI = display.newNode()
        :addTo(self)

    local  onUseMessageCallBack = function(result,message)
       self:onUserSpreadInfoCallBack(result,message)
    end
    self._plazaFrame = LogonFrame:getInstance()
    self._plazaFrame:setCallBackDelegate(self, onUseMessageCallBack)
    
end

function SpreadInfoView:init()

    self.m_pathUI = cc.CSLoader:createNode("dt/SpreadMySpreadView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    self.m_pNodeRoot    = self.m_pathUI:getChildByName("SpreadInfoView")

    self.pNodeTable     = self.m_pNodeRoot:getChildByName("Panel_node_info")  

    self.pboard_left    = self.pNodeTable:getChildByName("board_left") 

    self.m_pLbSpreadInfo = {}
    for i = 1, 5 do
        local nodeName = "text_text"..i
        self.m_pLbSpreadInfo[i] = self.pboard_left:getChildByName(nodeName)
    end

    self.Node_link = self.pNodeTable:getChildByName("Node_link") 

    self.Node_qr = self.pNodeTable:getChildByName("Node_qr") 

    --分享二维码
    self.m_bShareQR = self.Node_qr:getChildByName("BTN_share")
        --二维码
    self.m_pNodeQR = self.Node_qr:getChildByName("Node_qr")
    --复制链接按钮
    self.m_bCopyLink = self.Node_link:getChildByName("BTN_copylink")
    self.m_plink_text = self.Node_link:getChildByName("Text_8")
    self.Image_qr =  self.Node_qr:getChildByName("Image_qr")

    self.m_helpBtn = self.pNodeTable:getChildByName("button_yybz")

    self.btn_extract = self.pNodeTable:getChildByName("button_tqjl")

    self.lingqu_week = self.pboard_left:getChildByName("button_lingqu_week")

    self.lingqu_day = self.pboard_left:getChildByName("button_lingqu_day")

    self.Text_reward_week = self.pboard_left:getChildByName("img_ktqjl_5"):getChildByName("text_text6")

    self.Text_reward_day = self.pboard_left:getChildByName("img_lszjl_6"):getChildByName("text_text7")

    self:initBtnEvent()
    return self
end

function SpreadInfoView:onEnter()
    self:requestData() 
end

function SpreadInfoView:onExit()
    G_SpreadInfoView = nil
end

function SpreadInfoView:initBtnEvent()
    -- 分享二维码
    self.m_bShareQR:addClickEventListener(handler(self, self.shareQRimage))
    -- 复制二维码
    self.m_bCopyLink:addClickEventListener(handler(self, self.copySpreadLink))

    self.btn_extract:addClickEventListener(handler(self, self.showExtractlayer))
    self.lingqu_week:setBright(true)
    self.lingqu_day:setBright(true)
    self.lingqu_week:setEnabled(true)
    self.lingqu_day:setEnabled(true)

    self.lingqu_week:addClickEventListener(handler(self, self.TxALLBtnClick))

    self.lingqu_day:addClickEventListener(handler(self, self.TxDAYBtnClick))

    self.m_helpBtn:addClickEventListener(handler(self, self.helpBtnClick))
end

function SpreadInfoView:onSaveCodeClicked()
    ExternalFun.playClickEffect()

    if self.m_bIsSaveing then
        return
    end
    self.m_bIsSaveing = true

    if self.QRurl == "" then
        return
    end

    local qr = QrNode:createQrNode(self.QRurl, 250, 5, 1)
    qr:setAnchorPoint(0,0)
    qr:setPosition(-5,8)
    qr:setName("sp_qr")

    local layer = cc.LayerColor:create(cc.c4b(255,255,255,255), 500, 500)
    layer:setAnchorPoint(cc.p(0, 0))
    layer:setPosition(cc.p(0,0))
    layer:addChild(qr)
    
    local renderTexture = cc.RenderTexture:create(240, 260, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
    renderTexture:beginWithClear(0, 0, 0, 0)
    layer:visit()
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

function SpreadInfoView:helpBtnClick()
    local pShareWindowHelp = ShareWindowHelp.create()
    pShareWindowHelp:setName("ShareWindowHelp")
    pShareWindowHelp:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
end

function SpreadInfoView:TxALLBtnClick()
    self:requestTiXian(0)
end

function SpreadInfoView:TxDAYBtnClick()
    self:requestTiXian(1)
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

-- 生成二维码
function SpreadInfoView:makeQRimage()

     if self.QRurl == "" or self.Image_qr == nil then
        return
     end
    --如果有的话先移除
    local spqr = self.Image_qr:getChildByName("sp_qr")
    if spqr then
        spqr:removeFromParent()
    end

     local qr = QrNode:createQrNode(self.QRurl, 230, 5, 1)
     qr:setAnchorPoint(0,0)
     qr:setPosition(-5,-5)
     qr:setName("sp_qr")
     self.Image_qr:addChild(qr)

    -- print("生成二维码")
end

-- 分享二维码
function SpreadInfoView:shareQRimage()
     ExternalFun.playClickEffect()
     self:onSaveCodeClicked()
    -- print("分享二维码")
end

-- 复制链接
function SpreadInfoView:copySpreadLink()
    ExternalFun.playClickEffect()
    if self.QRurl ~= ""  then
        local url = tostring(self.QRurl)
        MultiPlatform.getInstance():copyToClipboard(url)
        FloatMessage.getInstance():pushMessage("STRING_204")
    end
end

-- 跳转到详情
function SpreadInfoView:showExtractlayer()
    ExternalFun.playClickEffect()
    local _event = {
        name = Hall_Events.MSG_OPEN_SPREADRX_LAYER,
        packet = nil,
    }
    SLFacade:dispatchCustomEvent(Hall_Events.MSG_OPEN_SPREADRX_LAYER, _event)
end

--刷新界面数据
function SpreadInfoView:refreshLayertext(Data)

   local msgDateTable = {Data.top_id,Data.agent_id,Data.team_num,Data.under_id}
   for i=1,4 do
     if self.m_pLbSpreadInfo[i] ~= nil and msgDateTable[i] ~= nil then
         self.m_pLbSpreadInfo[i]:setText(tostring(msgDateTable[i]))
      end
   end

end

--刷新界面数据
function SpreadInfoView:refreshLinkText(Data)
    if self.m_plink_text ~= nil and Data then
         self.m_plink_text:setText(tostring(Data))
    end
    self.QRurl = Data
end

--刷新界面奖励数据
function SpreadInfoView:refreshRewardtext(Data)
    self.rewardWeek = Data.reward_money
    self.rewardDay = Data.reward_money_today
    self.Text_reward_week:setText(Data.reward_money.."元")   

    self.Text_reward_day:setText(Data.reward_money_today.."元")   
end

--退出代理界面弹框
function SpreadInfoView:exitSpreadLayer(Data)
    if self._queryDialog then
        return
    end
   self._queryDialog = QueryDialog:create(tostring(Data), function(ok)
        if ok == true then
            SLFacade:dispatchCustomEvent(Hall_Events.MSG_CLOSE_SPREAD_LAYER)
        end
        self._queryDialog = nil
    end,nil,QueryDialog.QUERY_SURE):setCanTouchOutside(false)
        :addTo(self)
end

-- 如果本地有存 则不请求数据 避免多次请求
function SpreadInfoView:requestData()

   if GlobalUserItem.tabAccountInfo.extension ~= nil then
       self:refreshLayertext(GlobalUserItem.tabAccountInfo.extension)
   else
       self:requestMyspreadTextData() 
   end
    if GlobalUserItem.tabAccountInfo.webLink ~= nil then
        self:refreshLinkText(GlobalUserItem.tabAccountInfo.webLink)
        self:makeQRimage()
    end

    if GlobalUserItem.tabAccountInfo.receveAchieveData ~= nil then
        self:refreshRewardtext(GlobalUserItem.tabAccountInfo.receveAchieveData)
    end
end
--获得我的二维码
function SpreadInfoView:getMyErweima()
    if GlobalUserItem.tabAccountInfo.webLink ~= nil then
        self:refreshLinkText(GlobalUserItem.tabAccountInfo.webLink)
        self:makeQRimage()
   else
        self:requestMyspreadData() 
   end
end

--获得奖励数据
function SpreadInfoView:getRewardData()
    if GlobalUserItem.tabAccountInfo.receveAchieveData ~= nil then
        self:refreshRewardtext(GlobalUserItem.tabAccountInfo.receveAchieveData)
    else
        self:requestRewardData() 
    end
end

function SpreadInfoView:requestRewardData()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "promotion_week"
    msgta["body"] = {}
    msgta["body"]["pageindex"] = tostring(self.pageIndex)
    msgta["body"]["pagesize"] = "5"
    self._plazaFrame:sendGameData(msgta)
end

-- 请求自己的代理数据
function SpreadInfoView:requestMyspreadData()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "get_wechat_web"
    msgta["body"] = {}
    msgta["body"]["agent_id"] = 0
    msgta["body"]["openid"] = 0
    self._plazaFrame:sendGameData(msgta)
end

-- 请求自己的代理数据
function SpreadInfoView:requestMyspreadTextData()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "my_extension"
    msgta["body"] = {}
    self._plazaFrame:sendGameData(msgta)
    self:showPopWait()
end

function SpreadInfoView:requestTiXian(isday)
    local Money = 0
    if isday == 1 then
        Money = self.rewardDay
    else
        Money = self.rewardWeek
    end

    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "agentreward"
    msgta["body"] = {}
    msgta["body"]["money"] = Money
    msgta["body"]["is_day"] = isday
    self._plazaFrame:sendGameData(msgta)
    self:showPopWait()
end

--消息请求回调
function SpreadInfoView:onUserSpreadInfoCallBack(result,message)
    
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃

    if type(message) == "table" then
        if message.tag == "my_extension" then
            if message.result == "ok" then
                self:refreshLayertext(message.body)
                GlobalUserItem.tabAccountInfo.extension = message.body
                --获得我的推广数据以后再获取二维码
                self:getMyErweima()
            else
               -- self:exitSpreadLayer(message.result)
            end 
            self:dismissPopWait()
        elseif message.tag == "get_wechat_web" then
            if message.result == "ok" then    
                self:refreshLinkText(message.body)
                self:makeQRimage()
                self:getRewardData()
                GlobalUserItem.tabAccountInfo.webLink = message.body
            else

            end
        elseif message.tag == "promotion_week" then
            if message.result == "ok" then
                local msg = message.body
                GlobalUserItem.tabAccountInfo.receveAchieveData = message.msg
                self:refreshRewardtext(msg)
            else

            end
        elseif message.tag == "agentreward" then
            if message.result == "ok" then
                FloatMessage.getInstance():pushMessage("提现请求发送成功")
            else
                FloatMessage.getInstance():pushMessage(message.result)
            end
            self:dismissPopWait()           
        end
    end
end

--显示等待
function SpreadInfoView:showPopWait(isTransparent)
   FloatPopWait.getInstance():show("请稍后")
end

--关闭等待
function SpreadInfoView:dismissPopWait()
   FloatPopWait.getInstance():dismiss()
end
return SpreadInfoView
--endregion
 