--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local SpreadReceiveAwardsView = class("SpreadReceiveAwardsView",FixLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame")
local ClientPopWait = appdf.req(appdf.EXTERNAL_SRC .. "ClientPopWait")
local G_SpreadReceiveAwardsView = nil
function SpreadReceiveAwardsView.create()
    G_SpreadReceiveAwardsView = SpreadReceiveAwardsView.new():init()
    return G_SpreadReceiveAwardsView
end

function SpreadReceiveAwardsView:ctor()
    self:enableNodeEvents()
    self.m_rootUI = display.newNode()
        :addTo(self)

    local  onUseMessageCallBack = function(result,message)
       self:onUserSpreadMyReceiveAwardsCallBack(result,message)
    end
    self._plazaFrame = LogonFrame:getInstance()
    self._plazaFrame:setCallBackDelegate(self, onUseMessageCallBack)

    self.pageIndex = 1
    self.pageCount = 1
    self.reward_money = 0
    self.reward_money_today = 0
    self.exchangeStatus =
    {
        [0] = "等待提现中",
        [1] = "已经提取",
        [2] = "提现失败",
    }

end

function SpreadReceiveAwardsView:init()

    self.m_pathUI = cc.CSLoader:createNode("hall/csb/SpreadReceiveAwardsView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    self.m_pNodeRoot    = self.m_pathUI:getChildByName("SpreadTutorial")

    self.pNodeTable     = self.m_pNodeRoot:getChildByName("Panel_node_tutorial")  

    self.pNode_self_item      = self.pNodeTable:getChildByName("node_self") 

    self.pNode_item = {}
    for i = 1, 5 do
        local nodeName = "node_item_"..i
        self.pNode_item[i] = self.pNodeTable:getChildByName(nodeName)
    end

    --上一页
    self.BTN_lastpage = self.pNodeTable:getChildByName("Button_lastpage")
    --下一页 
    self.BTN_nextpage = self.pNodeTable:getChildByName("Button_nextpage")

    --每日提现
    self.BTN_tfday = self.pNodeTable:getChildByName("Button_getmoneyday")
    --每周提现
    self.BTN_tfweek = self.pNodeTable:getChildByName("Button_getmoneyweek")

    self:initBtnEvent()

    return self
end

function SpreadReceiveAwardsView:onEnter()
    self:requestData()
end

function SpreadReceiveAwardsView:onExit()

    G_SpreadReceiveAwardsView = nil
end

function SpreadReceiveAwardsView:initBtnEvent()
    -- 上一页
    self.BTN_lastpage:addClickEventListener(handler(self, self.showlastpage))
    -- 下一页
    self.BTN_nextpage:addClickEventListener(handler(self, self.shownextpage))
    --每日提现
    self.BTN_tfday:addClickEventListener(handler(self, self.TiXianDay))
    --每周提现
    self.BTN_tfweek:addClickEventListener(handler(self, self.TiXianWeek))

end

-- 上一页
function SpreadReceiveAwardsView:showlastpage()
     ExternalFun.playClickEffect()
     self.pageIndex = self.pageIndex - 1
     if self.pageIndex < 1 then
        self.pageIndex = 1
     else
        self:requestTextData()
     end 
end

-- 下一页
function SpreadReceiveAwardsView:shownextpage()
    ExternalFun.playClickEffect()
    self.pageIndex = self.pageIndex + 1
    if self.pageIndex > self.pageCount then
        self.pageIndex = self.pageCount
    else
        self:requestTextData()
    end    
end

-- 充值提现
function SpreadReceiveAwardsView:TiXianDay()
     ExternalFun.playClickEffect()
     self:requestTiXian(1)
end

-- 充值提现
function SpreadReceiveAwardsView:TiXianWeek()
     ExternalFun.playClickEffect()
     self:requestTiXian(0)
end

function SpreadReceiveAwardsView:requestTiXian(isday)
    local Money = 0
    if isday == 1 then
        Money = self.reward_money_today
    else
        Money = self.reward_money
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

-- 请求数据
function SpreadReceiveAwardsView:requestData()
   if GlobalUserItem.tabAccountInfo.receveAchieveData ~= nil then
       self:refreshText(GlobalUserItem.tabAccountInfo.receveAchieveData)
       self.pageCount = GlobalUserItem.tabAccountInfo.savePageData.ReceiveAwardsPageCount
       self.pageIndex = GlobalUserItem.tabAccountInfo.savePageData.ReceiveAwardsIndexCur
   else 
       self:requestTextData()
   end 
end

function SpreadReceiveAwardsView:requestTextData()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "promotion_week"
    msgta["body"] = {}
    msgta["body"]["pageindex"] = tostring(self.pageIndex)
    msgta["body"]["pagesize"] = "5"
    self._plazaFrame:sendGameData(msgta)
    GlobalUserItem.tabAccountInfo.savePageData.ReceiveAwardsIndexCur = self.pageIndex
    self:showPopWait()
end

--消息请求回调
function SpreadReceiveAwardsView:onUserSpreadMyReceiveAwardsCallBack(result,message)
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃

    if type(message) == "table" then
        if message.tag == "promotion_week" then 
            if message.result == "ok" then
                local msg = message.body
                self:refreshText(msg)
                self.pageCount = msg.page.pagecount
                GlobalUserItem.tabAccountInfo.savePageData.ReceiveAwardsPageCount = msg.page.pagecount
                GlobalUserItem.tabAccountInfo.receveAchieveData = message.body
            else

            end
            self:dismissPopWait()
        elseif message.tag == "agentreward" then
            if message.result == "ok" then
                FloatMessage.getInstance():pushMessage("提现请求发送成功")
                self:requestTextData()
            else
                FloatMessage.getInstance():pushMessage(message.result)
            end
            self:dismissPopWait() 
        end
    end
end

function SpreadReceiveAwardsView:refreshText(Data)
   self:refreshSelfText(Data)
end

function SpreadReceiveAwardsView:refreshSelfText(Data)

    if Data and self.pNode_self_item then
        --总奖励金额
        self.pNode_self_item:getChildByName("Text_1"):setText(Data.reward_money)   
        --可提现金额    
        self.pNode_self_item:getChildByName("Text_2"):setText(Data.reward_money_today)   
    end

    self.reward_money = Data.reward_money
    self.reward_money_today = Data.reward_money_today

    --模拟数据
    --[[
    Data.data = {
    {create_time = "2019/01/28 11:33:88",lineper_week = 2000,seper = 3000,group_week = 10,bonus_money = 000,status = 1},
    }
    --]]
   if  table.nums(Data.data) > 0 then
       self:refreshDownFormText(Data.data)
   end
end

function SpreadReceiveAwardsView:refreshDownFormText(msg)
   local msgDateTable = {}
   local statusString = nil
   self.m_pNode_item_text = {}
   for i =1,#msg do
       statusString = self:getStatusString(msg[i].status)
       msgDateTable[i] = {
                          msg[i].create_time,
                          msg[i].lineper_week,
                          msg[i].group_week,
                          msg[i].seper_week,
                          msg[i].bonus_money,
                          statusString,
                          }                         
      for index=1,6 do
           self.m_pNode_item_text[index] = self.pNode_item[i]:getChildByName("Text_"..index)
           self.m_pNode_item_text[index]:setText(tostring(msgDateTable[i][index]))
      end
   end
end

function SpreadReceiveAwardsView:getStatusString(status)
    local StatusString = ""
    for k,v in pairs (self.exchangeStatus) do
        if k == status then
            StatusString =  v 
        end
    end
    --提现失败
    if string.len(StatusString) == 0 then
       StatusString = self.exchangeStatus[2]
    end
    return StatusString
end

--显示等待
function SpreadReceiveAwardsView:showPopWait(isTransparent)
   FloatPopWait.getInstance():show("请稍后")
end

--关闭等待
function SpreadReceiveAwardsView:dismissPopWait()
   FloatPopWait.getInstance():dismiss()
end

return SpreadReceiveAwardsView
--endregion
 