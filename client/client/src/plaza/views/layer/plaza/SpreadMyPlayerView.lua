--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local SpreadMyPlayerView = class("SpreadMyPlayerView",FixLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame") 
local ClientPopWait = appdf.req(appdf.EXTERNAL_SRC .. "ClientPopWait")
local G_SpreadMyPlayerView = nil
function SpreadMyPlayerView.create()
    G_SpreadMyPlayerView = SpreadMyPlayerView.new():init()
    return G_SpreadMyPlayerView
end

function SpreadMyPlayerView:ctor()
    self:enableNodeEvents()
    self.m_rootUI = display.newNode()
        :addTo(self)

    local  onUseMessageCallBack = function(result,message)
       self:onUserSpreadMyPlayerCallBack(result,message)
    end
    self._plazaFrame = LogonFrame:getInstance()
    self._plazaFrame:setCallBackDelegate(self, onUseMessageCallBack)
    self.LevelTable ={
    {"金众大使", "5000W以上", "270"},
    {"资深董事", "3000-5000W", "252"},
    {"高级董事", "1000-3000W", "234"},
    {"董事", "800-1000W", "216"},
    {"高级总监", "400-600W", "180"},
    {"资深总监", "600-800W", "196"}, 
    {"高级总监", "400-600W", "180"}, 
    {"总监", "200-400W", "162"}, 
    {"高级经理", "100-200W", "144"}, 
    {"经理", "50-100W", "126"},
    {"高级主任", "10-50W", "108"},
    {"主任", "1-10W", "90"}, 
    {"助理", "0-1W", "72"}
  }
    self.pageIndex = 1
    self.pageCount = 1
    self.m_bIsMenuOpen = false
    self.m_nSelectLevelIndex = nil
    self.m_nUserId = nil
    self.m_changeBtnIndex = nil
end

function SpreadMyPlayerView:init()

    self.m_pathUI = cc.CSLoader:createNode("hall/csb/SpreadMyPlayerView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    self.m_pNodeRoot    = self.m_pathUI:getChildByName("SpreadTutorial")

    self.m_pDialogAction = cc.CSLoader:createTimeline("hall/csb/SpreadMyPlayerView.csb")  
    self.m_pathUI:runAction(self.m_pDialogAction)

    self.pNodeTable     = self.m_pNodeRoot:getChildByName("Panel_node_tutorial")  

    self.pNode_pop      = self.pNodeTable:getChildByName("Node_pop") 
    self.pNode_pop:setVisible(false)

    --node pop

    self.m_pImgTypeBg           = self.pNode_pop:getChildByName("IMG_TypeBg")
    self.m_pBtnPull             = self.m_pImgTypeBg:getChildByName("BTN_pull")
    self.m_pBtnPush             = self.m_pImgTypeBg:getChildByName("BTN_push")
    self.m_pBtnSelect           = self.m_pImgTypeBg:getChildByName("BTN_select")

    self.m_pIDbg                = self.pNode_pop:getChildByName("input_bg1")
    self.m_pGetPercent          = self.pNode_pop:getChildByName("input_bg2")
    self.m_pProhibit            = self.pNode_pop:getChildByName("input_bg4")
    --获取每行数据节点
    self.m_pNode_item = {}
    self.m_pNode_item_text = {}
    self.pNode_changeBtn = {} 
    for i = 1, 8 do
        local nodeName = "node_item_"..i
        self.m_pNode_item[i] = self.pNodeTable:getChildByName(nodeName)
        self.pNode_changeBtn[i] = self.m_pNode_item[i]:getChildByName("Button_beAgent")
        self.pNode_changeBtn[i]:setVisible(false)
    end

    self.m_pNode_LevelItem = {}
    for i = 1, 12 do
        self.m_pNode_LevelItem[i] = self.pNode_pop:getChildByName("node_pop"):getChildByName("node_"..i):getChildByName("BTN_select")
    end


    --上一页
    self.BTN_lastpage = self.pNodeTable:getChildByName("Button_lastpage")
    --下一页 
    self.BTN_nextpage = self.pNodeTable:getChildByName("Button_nextpage")
    --保存 
    self.BTN_save = self.pNode_pop:getChildByName("Button_Save")
    --取消 
    self.BTN_cancel = self.pNode_pop:getChildByName("Button_Cancel")

    self:initBtnEvent()
    
    return self
end

function SpreadMyPlayerView:onEnter()
    self:initEditBox()
    self:requestData() 
end

function SpreadMyPlayerView:onExit()

    G_SpreadMyPlayerView = nil
end

function SpreadMyPlayerView:initEditBox()

    if self.m_pEditID == nil then
        self.m_pEditID = self:createEditBox(300,cc.KEYBOARD_RETURNTYPE_DONE, cc.EDITBOX_INPUT_MODE_NUMERIC, cc.EDITBOX_INPUT_FLAG_SENSITIVE, 1, cc.size(300, 52), "请输入玩家ID")
        self.m_pEditID:setPosition(10,15)
        self.m_pEditID:setTouchEnabled(false)
        self.m_pIDbg:addChild(self.m_pEditID)
    end

    if self.m_pEditLevel == nil then
        self.m_pEditLevel = self:createEditBox(300,cc.KEYBOARD_RETURNTYPE_DONE, cc.EDITBOX_INPUT_MODE_SINGLELINE, cc.EDITBOX_INPUT_FLAG_SENSITIVE, 2, cc.size(300, 52), "")
        self.m_pEditLevel:setPosition(10,15)
        self.m_pEditLevel:setTouchEnabled(false)
        self.m_pGetPercent:addChild(self.m_pEditLevel)
    end

    if self.m_pEditCanCreatdl == nil then
        self.m_pEditCanCreatdl = self:createEditBox(300,cc.KEYBOARD_RETURNTYPE_DONE, cc.EDITBOX_INPUT_MODE_SINGLELINE, cc.EDITBOX_INPUT_FLAG_SENSITIVE, 3, cc.size(300, 52), "")
        self.m_pEditCanCreatdl:setPosition(10,15)
        self.m_pEditCanCreatdl:setTouchEnabled(false)
        self.m_pEditCanCreatdl:setText("否")
        self.m_pProhibit:addChild(self.m_pEditCanCreatdl)
    end
end

function SpreadMyPlayerView:initBtnEvent()
    -- 上一页
    self.BTN_lastpage:addClickEventListener(handler(self, self.showlastpage))
    -- 下一页
    self.BTN_nextpage:addClickEventListener(handler(self, self.shownextpage))
    --保存 
    self.BTN_save:addClickEventListener(handler(self, self.sendAddAgent))
    --取消 
    self.BTN_cancel:addClickEventListener(handler(self, self.closePop))

    self.m_pBtnPush:addClickEventListener(handler(self, self.onMenuOpen))

    self.m_pBtnPull:addClickEventListener(handler(self, self.onMenuClose))

    self.m_pBtnSelect:addClickEventListener(handler(self, self.onMenuStutasChange))

    for i = 1,12 do
         self.m_pNode_LevelItem[i]:addClickEventListener(function()
                     self:onTypeClickedItem(i)
                end)
    end
    
end

-- 发送添加代理消息
function SpreadMyPlayerView:sendAddAgent()
     ExternalFun.playClickEffect()
    if self.m_nUserId ~= nil and  self.m_nSelectLevelIndex ~= nil then
          self:sendAddAgentmsg(self.m_nUserId,self.m_nSelectLevelIndex)
    end  
    self:setPoplayerVS(false)
end

-- 取消pop
function SpreadMyPlayerView:closePop()
     ExternalFun.playClickEffect()
     self:setPoplayerVS(false)
end


function SpreadMyPlayerView:setPoplayerVS(bvisible)
    self.pNode_pop:setVisible(bvisible)
end

-- 上一页
function SpreadMyPlayerView:showlastpage()
     ExternalFun.playClickEffect()
     self.pageIndex = self.pageIndex - 1
     if self.pageIndex < 1 then
        self.pageIndex = 1
     else
        self:requestMyspreadTextData()
     end 
end

-- 下一页
function SpreadMyPlayerView:shownextpage()
    ExternalFun.playClickEffect()
    self.pageIndex = self.pageIndex + 1
    if self.pageIndex > self.pageCount then
        self.pageIndex = self.pageCount
    else
        self:requestMyspreadTextData()
    end    
end

-- 如果本地有存 则不请求数据 避免多次请求
function SpreadMyPlayerView:requestData()

   if GlobalUserItem.tabAccountInfo.agent_userlist ~= nil then
       self:refreshLayertext(GlobalUserItem.tabAccountInfo.agent_userlist)
       self.pageCount = GlobalUserItem.tabAccountInfo.savePageData.myPlayerPageCount
       self.pageIndex = GlobalUserItem.tabAccountInfo.savePageData.myPlayerIndexCur
   else
       self:requestMyspreadTextData()
   end

end

function SpreadMyPlayerView:requestMyspreadTextData()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "agent_userlist"
    msgta["body"] = {}
    msgta["body"]["id"] = 0
    msgta["body"]["pageindex"] = self.pageIndex
    msgta["body"]["pagesize"] = 8     --每页最多8行
    self._plazaFrame:sendGameData(msgta)
    self:showPopWait()
    GlobalUserItem.tabAccountInfo.savePageData.myPlayerIndexCur = self.pageIndex
end

function SpreadMyPlayerView:sendAddAgentmsg(id,level)    
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "agent_add"
    msgta["body"] = {}
    msgta["body"]["user_id"] = id
    msgta["body"]["mobile"] = 0
    msgta["body"]["forbidden"] = 0
    msgta["body"]["level"] =  level
    msgta["body"]["cooperation"] =  0
    self._plazaFrame:sendGameData(msgta)

    self:showPopWait()

end

--消息请求回调
function SpreadMyPlayerView:onUserSpreadMyPlayerCallBack(result,message)

    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃

    if type(message) == "table" then
        if message.tag == "agent_userlist" then
            if message.result == "ok" then
                self:dealMsg(message.body)             
                GlobalUserItem.tabAccountInfo.agent_userlist = message.body
                GlobalUserItem.tabAccountInfo.savePageData.myPlayerPageCount = message.body.page.pagecount
            else

            end 
            self:dismissPopWait()
        elseif message.tag == "agent_add" then
            if message.result == "ok" then
                self.pNode_changeBtn[self.m_changeBtnIndex]:setVisible(false)
            else
                FloatMessage.getInstance():pushMessage(message.result)
            end 
            self:dismissPopWait()
        end
    end
end

function SpreadMyPlayerView:dealMsg(msg)
    self.pageCount = msg.page.pagecount
    self:cleanForm()   -- 先清除
    self:refreshLayertext(msg)
end

--刷新界面数据
function SpreadMyPlayerView:cleanForm()
   for i =1,8 do                                               
     self.pNode_changeBtn[i]:addClickEventListener(handler(self,function() end))
     self.m_pNode_item[i] = self.pNodeTable:getChildByName("node_item_"..i)                       
     for index=1,5 do
         self.m_pNode_item_text[index] = self.m_pNode_item[i]:getChildByName("Text_"..index)
         self.m_pNode_item_text[index]:setText("")
     end

     self.pNode_changeBtn[i]:setVisible(false) 
     self.m_pNode_item[i]:getChildByName("Text_"..6):setText("")  
   end
end

--刷新界面数据
function SpreadMyPlayerView:refreshLayertext(msg)
   local msgDateTable = {}
   for i =1,#msg.data do
       msgDateTable[i] = {
                          msg.data[i].id,
                          msg.data[i].nickname,
                          msg.data[i].date_joined,
                          msg.data[i].last_login,
                          msg.data[i].win_money
                          }
                                               
    self.pNode_changeBtn[i]:addClickEventListener(handler(self,function()  --绑定按钮事件
                self:showPoplayer(i,msgDateTable[i])
            end)) 

     self.m_pNode_item[i] = self.pNodeTable:getChildByName("node_item_"..i)                       
     for index=1,5 do
         self.m_pNode_item_text[index] = self.m_pNode_item[i]:getChildByName("Text_"..index)
         self.m_pNode_item_text[index]:setText(tostring(msgDateTable[i][index]))
     end
     if msg.data[i].aid == 0 then  --aid为0  是未开通  开通了显示已开通
         self.pNode_changeBtn[i]:setVisible(true) 
     else
         self.pNode_changeBtn[i]:setVisible(false)
         self.m_pNode_item[i]:getChildByName("Text_"..6):setText("已开通")  
     end
   end
end

--开通代理按钮事件
function SpreadMyPlayerView:showPoplayer(index,msgdata)
    self:setPoplayerVS(true)
    self.m_changeBtnIndex = index
    if self.m_pEditID ~= nil then
        self.m_pEditID:setText(msgdata[1])
    end
    self.m_nUserId = msgdata[1]
    self:onTypeClickedItem(1,true)
end

function SpreadMyPlayerView:createEditBox(maxLength, keyboardReturnType, inputMode, inputFlag, tag, size, placestr)
    local sprite1 = ccui.Scale9Sprite:createWithSpriteFrameName("gui-texture-null.png")
    local sprite2 = ccui.Scale9Sprite:createWithSpriteFrameName("gui-texture-null.png")
    local sprite3 = ccui.Scale9Sprite:createWithSpriteFrameName("gui-texture-null.png")
    size = cc.size(size.width, 35)
    local editBox = cc.EditBox:create(size, sprite1, sprite2, sprite3)
    editBox:setMaxLength(maxLength)
    editBox:setReturnType(keyboardReturnType)
    editBox:setInputMode(inputMode)
    editBox:setInputFlag(inputFlag)
    editBox:setTag(tag)
    editBox:setPlaceHolder(placestr)
    if device.platform ~= "ios" and device.platform ~= "mac" then
        editBox:setPlaceholderFontName("Microsoft Yahei")
        editBox:setPlaceholderFontSize(25)
        editBox:setPlaceholderFontColor(cc.c3b(171,120,70))
    end
    editBox:setFont("Microsoft Yahei", 25)
    editBox:setFontColor(cc.c3b(108,59,27))
    editBox:setAnchorPoint(cc.p(0, 0))
   
    return editBox
end

function SpreadMyPlayerView:onMenuClose()
    ExternalFun.playClickEffect()
    self.m_bIsMenuOpen = false
    self:onClickedWay()
end

function SpreadMyPlayerView:onMenuOpen()
    ExternalFun.playClickEffect()
    self.m_bIsMenuOpen = true
    self:onClickedWay()
end

function SpreadMyPlayerView:onMenuStutasChange()
    ExternalFun.playClickEffect()
    self.m_bIsMenuOpen = not self.m_bIsMenuOpen
    self:onClickedWay()
end

function SpreadMyPlayerView:onClickedWay()
    if self.m_bIsMenuOpen then --up to down
        self.pNode_pop:stopAllActions()
        self.m_pBtnPull:setVisible(true)
        self.m_pBtnPush:setVisible(false)
        self.m_pBtnSelect:setVisible(false)
        self.m_pDialogAction:play("AnimationSlecet",false)
    else 
        --down to up
        self.pNode_pop:stopAllActions()
        self.m_pBtnPull:setVisible(false)
        self.m_pBtnPush:setVisible(true)
        self.m_pBtnSelect:setVisible(true)
        self.m_pDialogAction:play("AnimationUnSlecet",false)
    end
end

function SpreadMyPlayerView:onTypeClickedItem(nIndex,unNeedAni)
    ExternalFun.playClickEffect()

    local _label1 = self.pNode_pop:getChildByName("node_pop"):getChildByName("node_"..nIndex):getChildByName("LB_type")
    local _label2 = self.m_pImgTypeBg:getChildByName("LB_selectType")
    _label2:setString(_label1:getString())
    

    self.m_nSelectLevelIndex = nIndex

    if self.m_pEditLevel then
       self.m_pEditLevel:setText(self.LevelTable[nIndex][3])
    end

    if unNeedAni then
       return
    end

    self.m_bIsMenuOpen = false
    self:onClickedWay()
end

--显示等待
function SpreadMyPlayerView:showPopWait(isTransparent)
   FloatPopWait.getInstance():show("请稍后")
end

--关闭等待
function SpreadMyPlayerView:dismissPopWait()
   FloatPopWait.getInstance():dismiss()
end

return SpreadMyPlayerView
--endregion
 