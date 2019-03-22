--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local SpreadMyAchieveView = class("SpreadMyAchieveView",FixLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame")
local ClientPopWait = appdf.req(appdf.EXTERNAL_SRC .. "ClientPopWait")
local G_SpreadMyAchieveView = nil
function SpreadMyAchieveView.create()
    G_SpreadMyAchieveView = SpreadMyAchieveView.new():init()
    return G_SpreadMyAchieveView
end

function SpreadMyAchieveView:ctor()
    self:enableNodeEvents()
    self.m_rootUI = display.newNode()
        :addTo(self)

    local  onUseMessageCallBack = function(result,message)
       self:onUserSpreadMyAchieveCallBack(result,message)
    end
    self._plazaFrame = LogonFrame:getInstance()
    self._plazaFrame:setCallBackDelegate(self, onUseMessageCallBack)
    self.pageIndex = 1
    self.pageCount = 1
end

function SpreadMyAchieveView:init()

    self.m_pathUI = cc.CSLoader:createNode("hall/csb/SpreadMyAchieveView.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    self.m_pNodeRoot    = self.m_pathUI:getChildByName("SpreadTutorial")

    self.pNodeTable     = self.m_pNodeRoot:getChildByName("Panel_node_tutorial")  
    self.node_item_week      = self.pNodeTable:getChildByName("node_item_week") 

    self.m_pLbWeekInfo = {}
    self.pNode_item = {}
    for i = 1, 3 do
        local nodeName = "Text_"..i
        self.m_pLbWeekInfo[i] = self.node_item_week:getChildByName(nodeName)
    end

    for i = 1, 5 do
        local nodeName = "node_item_"..i
        self.pNode_item[i] = self.pNodeTable:getChildByName(nodeName)
    end

    --上一页
    self.BTN_lastpage = self.pNodeTable:getChildByName("Button_lastpage")
    --下一页 
    self.BTN_nextpage = self.pNodeTable:getChildByName("Button_nextpage")

    self:initBtnEvent()

    return self
end

function SpreadMyAchieveView:onEnter()
    self:requestData()
end

function SpreadMyAchieveView:onExit()


    G_SpreadMyAchieveView = nil
end

function SpreadMyAchieveView:initBtnEvent()
    -- 上一页
    self.BTN_lastpage:addClickEventListener(handler(self, self.showlastpage))
    -- 下一页
    self.BTN_nextpage:addClickEventListener(handler(self, self.shownextpage))
end

-- 上一页
function SpreadMyAchieveView:showlastpage()
     ExternalFun.playClickEffect()
     self.pageIndex = self.pageIndex - 1
     if self.pageIndex < 1 then
        self.pageIndex = 1
     else
        self:requestTextData()
     end 
end

-- 下一页
function SpreadMyAchieveView:shownextpage()
    ExternalFun.playClickEffect()
    self.pageIndex = self.pageIndex + 1
    if self.pageIndex > self.pageCount then
        self.pageIndex = self.pageCount
    else
        self:requestTextData()
    end
end

-- 请求数据
function SpreadMyAchieveView:requestData()
   if GlobalUserItem.tabAccountInfo.AchieveData ~= nil then
       self:refreshText(GlobalUserItem.tabAccountInfo.AchieveData)
       self.pageCount = GlobalUserItem.tabAccountInfo.savePageData.myAchievePageCount
       self.pageIndex = GlobalUserItem.tabAccountInfo.savePageData.myAchieveIndexCur
   else 
       self:requestTextData()
   end 
end

function SpreadMyAchieveView:requestTextData()

    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "get_promotion"
    msgta["body"] = {}
    msgta["body"]["pageindex"] = tostring(self.pageIndex)
    msgta["body"]["pagesize"] = 5
    self._plazaFrame:sendGameData(msgta)
    GlobalUserItem.tabAccountInfo.savePageData.myAchieveIndexCur = self.pageIndex
    self:showPopWait()
end

--消息请求回调
function SpreadMyAchieveView:onUserSpreadMyAchieveCallBack(result,message)
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
    if type(message) == "table" then
        if message.tag == "get_promotion" then
            if message.result == "ok" then
                self:refreshText(message.body)
                GlobalUserItem.tabAccountInfo.AchieveData = message.body
                self.pageCount = message.body.page.pagecount
                GlobalUserItem.tabAccountInfo.savePageData.myAchievePageCount = message.body.page.pagecount

            else

            end 
            self:dismissPopWait()
        end
    end
end

function SpreadMyAchieveView:refreshText(Data)

    if Data == nil then
       return
    end

    local msgdata = {Data.week_total,Data.week_group,Data.week_self}

    for i=1,3 do
       if self.m_pLbWeekInfo[i] and msgdata[i] then
          if type(msgdata[i]) == "userdata" then
             self.m_pLbWeekInfo[i]:setText(0)
          else
             self.m_pLbWeekInfo[i]:setText(msgdata[i])
          end
       end
    end
    --[[
    Data.data = {
    {dir_agent_lineper = 1000,lineper = 2000,seper = 3000,create_time = "2019/01/28 11:33:88"},
    {dir_agent_lineper = 1000,lineper = 2000,seper = 3000,create_time = "2019/01/28 11:33:88"},
    {dir_agent_lineper = 1000,lineper = 2000,seper = 3000,create_time = "2019/01/28 11:33:88"},
    {dir_agent_lineper = 1000,lineper = 2000,seper = 3000,create_time = "2019/01/28 11:33:88"},
    {dir_agent_lineper = 1000,lineper = 2000,seper = 3000,create_time = "2019/01/28 11:33:88"}
    }
    --]]
    if  table.nums(Data.data) > 0 then
       self:refreshDownFormText(Data.data)
    end

end

function SpreadMyAchieveView:refreshDownFormText(msg)
local msgDateTable = {}
   self.m_pNode_item_text = {}
   for i =1,#msg do
       msgDateTable[i] = {
                          msg[i].lineper,
                          msg[i].seper,
                          msg[i].dir_agent_lineper,
                          msg[i].create_time,
                          }                         
      for index=1,4 do
           self.m_pNode_item_text[index] = self.pNode_item[i]:getChildByName("Text_"..index)
           self.m_pNode_item_text[index]:setText(tostring(msgDateTable[i][index]))
      end
   end
end

--显示等待
function SpreadMyAchieveView:showPopWait(isTransparent)
   FloatPopWait.getInstance():show("请稍后")
end

--关闭等待
function SpreadMyAchieveView:dismissPopWait()
   FloatPopWait.getInstance():dismiss()
end

return SpreadMyAchieveView
--endregion
 