--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local MessageDialog     = appdf.req(appdf.EXTERNAL_SRC .. "MessageDialog")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ActivityNoticeView = class("ActivityNoticeView", FixLayer)

HUODONGBTN_IMAGESCLECE = 5
GONGGAOBTN_IMAGESCLECE = 4

local BTN_Num = {
      [1] = "btn_chongzhihuikui.png",
      [2] = "btn_jinbaoyouxi.png",
      [3] = "btn_quanmindaiyi.png",
      [4] = "btn_xingyunduobao.png",
      [5] = "btn_nvshenhuifang.png",

      [6] = "btn_zhengzhongshengming.png",
      [7] = "btn_xinyubaozhang.png",
      [8] = "btn_xinwanjiabiduo.png",
      [9] = "btn_fanzuobigonggao.png",
}
local BTN_Num_1 = {
      [1] = "btn_chongzhihuikui_1.png",
      [2] = "btn_jinbaoyouxi_1.png",
      [3] = "btn_quanmindaiyi_1.png",
      [4] = "btn_xingyunduobao_1.png",
      [5] = "btn_nvshenhuifang_1.png",

      [6] = "btn_zhengzhongshengming_1.png",
      [7] = "btn_xinyubaozhang_1.png",
      [8] = "btn_xinwanjiabiduo_1.png",
      [9] = "btn_fanzuobigonggao_1.png",
}
local Image_Num = {
      [1] = "img_chongzhihuikui.png",
      [2] = "img_jinbaoyouxi.jpg",
      [3] = "img_quanmindaiyi.jpg",
      [4] = "img_xingyunduobao.png",
      [5] = "img_nvshenhuifang.jpg",
      [6] = "img_xinyubaozhang.png",
}

function ActivityNoticeView:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()
    self.m_itemLight = {[1] = nil,[2] = nil,[3] = nil,[4] = nil,[5] = nil,[6] = nil,}
    self.m_itemLight2 = {[1] = nil,[2] = nil,[3] = nil,[4] = nil,}

    self:init()
end

function ActivityNoticeView:onEnter()
    self.super:onEnter()
    --弹窗
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)
    
    self:showWithStyle()
--    for i = 1, #Image_Num do --大图
--        display.loadImage(self:getrealname(Image_Num[i]))
--    end
end

function ActivityNoticeView:onExit()
    --清理
--    self:clean()
--    for i = 1, #Image_Num do --大图
--        display.removeImage(self:getrealname(Image_Num[i]))
--    end
    
    self.super:onExit()
end

function ActivityNoticeView:init()
    self:initCSB()
    self:initBtnEvent()
end
function ActivityNoticeView:initCSB()
        --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    --csb
    self.m_pathUI = cc.CSLoader:createNode("dt/ActivityNoticeView.csb")
    self.m_pathUI:setPositionY((display.height - 750) / 2)
    self.m_pathUI:addTo(self.m_rootUI)

    --offset
    self.m_pNodeRoot = self.m_pathUI:getChildByName("center")
    self.m_pNodeRoot:setPositionX((display.width ) / 2)
    --bg
    self.m_pImageBg = self.m_pNodeRoot:getChildByName("Image_bgbg")
    --btn
    self.m_pBtnClose = self.m_pImageBg:getChildByName("button_closeBtn")

    self.m_ptabPanel_1 = self.m_pImageBg:getChildByName("panel_tabPanel_1")  -- 热门活动，layout
    self.m_panel_1_image1 = self.m_ptabPanel_1:getChildByName("image_font1")
    self.m_panel_1_image2 = self.m_ptabPanel_1:getChildByName("image_font2")
    self.m_panel_1_bg = self.m_ptabPanel_1:getChildByName("bg")
    self.m_ptabPanel_1:setTouchEnabled(false)
    local function panelbtn1()
        self:OnBtnPanelChick()
    end
    local bGButton = cc.Scale9Sprite:create("dt/image/newActivity/hdgg_005_2.png")
    bGButton:setRotation(180)
    local pBgBtn = cc.ControlButton:create(bGButton)
    pBgBtn:setAnchorPoint(cc.p(0,0))
    pBgBtn:setPosition(cc.p(0,0))
    pBgBtn:setPreferredSize(self.m_ptabPanel_1:getContentSize())
    pBgBtn:registerControlEventHandler(panelbtn1, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
    self.m_ptabPanel_1:addChild(pBgBtn,-1)

    self.m_ptabPanel_2 = self.m_pImageBg:getChildByName("panel_tabPanel_2")  -- 游戏公告，layout
    self.m_panel_2_image1 = self.m_ptabPanel_2:getChildByName("image_font1")
    self.m_panel_2_image2 = self.m_ptabPanel_2:getChildByName("image_font2")
    self.m_panel_2_bg = self.m_ptabPanel_2:getChildByName("bg")
    self.m_ptabPanel_2:setTouchEnabled(false)
    local function panelbtn2()
        self:OnBtnPanel2Chick()
    end
    local bGButton = cc.Scale9Sprite:create("dt/image/newActivity/hdgg_005_2.png")
    local pBgBtn = cc.ControlButton:create(bGButton)
    pBgBtn:setAnchorPoint(cc.p(0,0))
    pBgBtn:setPosition(cc.p(0,0))
    pBgBtn:setPreferredSize(self.m_ptabPanel_2:getContentSize())
    pBgBtn:registerControlEventHandler(panelbtn2, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
    self.m_ptabPanel_2:addChild(pBgBtn,-1)

    self:createtabPanel(false)

    self.m_ptabItem = self.m_pImageBg:getChildByName("panel_tabItem"):setVisible(false)
    self.m_ptabItem:getChildByName("redimage"):setVisible(false)
    self.m_plistview = self.m_pImageBg:getChildByName("listView_tabBtnList")
    self.m_plistview:setScrollBarEnabled(false)

    self:initImageview()
    self.m_itemLight[1]:setVisible(true)
    self.imagepanel = self.m_pImageBg:getChildByName("panel_imagePanel")
    self.loadingView = self.m_pImageBg:getChildByName("image_loadingView")
    self.ScrollView = self.imagepanel:getChildByName("scrollView_bigScrollView")
    self.ScrollView:setScrollBarEnabled(false)

    self.m_pNodeimage = self.imagepanel:getChildByName("node_imgNode")
    self.ImageSp = ccui.ImageView:create(self:getrealname(Image_Num[1]), ccui.TextureResType.localType)
    self.ImageSp:setContentSize(self.imagepanel:getContentSize())
    self.ImageSp:setAnchorPoint(cc.p(0,0))
    self.ImageSp:setPosition(cc.p(0,10))
    self.ScrollView:addChild(self.ImageSp)

    self.imagepanel:setVisible(true) 
    self.loadingView:setVisible(false)

    self.worldpanel = self.m_pImageBg:getChildByName("panel_wordPanel"):setVisible(false)
    self.contentScroll = self.worldpanel:getChildByName("scrollView_contentScroll")
    self.contentScroll:setScrollBarEnabled(false)
    self.Text_1 = self.contentScroll:getChildByName("Text_1"):setVisible(false)
    self.Text_2 = self.contentScroll:getChildByName("Text_2"):setVisible(false)
    self.titleWord = self.worldpanel:getChildByName("Image_19"):getChildByName("text_titleWord")

end
function ActivityNoticeView:initImageview()
    self.m_plistview:removeAllChildren()
    self.HotActivity = {}
    for i = 1 ,HUODONGBTN_IMAGESCLECE do      
        local item = self.m_ptabItem:clone();
        item:setVisible(true)
        self.m_itemLight[i] = item:getChildByName("light"):setVisible(false)
        self.HotActivity[i] = ccui.Button:create(self:getrealname(BTN_Num_1[i]));
        if i == 1 then
            self.HotActivity[i]:loadTextures(self:getrealname(BTN_Num[1]),self:getrealname(BTN_Num[1]),0)
        end
        
        self.HotActivity[i]:setAnchorPoint(cc.p(0,0))
        self.HotActivity[i]:setPosition(cc.p(10,-5))
        self.HotActivity[i]:setTag(i)
        self.HotActivity[i]:addTo(item)
        self.HotActivity[i]:addClickEventListener(handler(self,self.OnBtnImageChick))
        self.m_plistview:addChild(item)
    end
    
end
function ActivityNoticeView:initWorldview()
    self.m_plistview:removeAllChildren()
    self.Btn_worldview = {}
    for i = 1 ,GONGGAOBTN_IMAGESCLECE do      
        local item = self.m_ptabItem:clone();
        item:setVisible(true)
        self.m_itemLight2[i] = item:getChildByName("light"):setVisible(false)
        self.Btn_worldview[i] = ccui.Button:create(self:getrealname(BTN_Num_1[i+HUODONGBTN_IMAGESCLECE]));
        if i == 1 then
            self.Btn_worldview[i]:loadTextures(self:getrealname(BTN_Num[HUODONGBTN_IMAGESCLECE + 1]),self:getrealname(BTN_Num[HUODONGBTN_IMAGESCLECE + 1]),0)
        end
        self.Btn_worldview[i]:setPosition(cc.p(10,-5))
        self.Btn_worldview[i]:setAnchorPoint(cc.p(0,0))
        self.Btn_worldview[i]:setTag(i)
        self.Btn_worldview[i]:addTo(item)
        self.Btn_worldview[i]:addClickEventListener(handler(self,self.OnBtnWorldChick))
        self.m_plistview:addChild(item)
    end

end
function ActivityNoticeView:initBtnEvent()
    self.m_pBtnClose:addClickEventListener(handler(self,self.OnBtnCloseChick))

end
--热门活动点击
function ActivityNoticeView:OnBtnImageChick(sender)
    local a = sender:getTag()
    for i = 1, HUODONGBTN_IMAGESCLECE do
        self.m_itemLight[i]:setVisible(false)
        self.HotActivity[i]:loadTextures(self:getrealname(BTN_Num_1[i]),self:getrealname(BTN_Num_1[i]),0)
        if i == a then
        self.m_itemLight[i]:setVisible(true)
        sender:loadTextures(self:getrealname(BTN_Num[a]),self:getrealname(BTN_Num[a]),0)
        end
    end
    
    if self.ImageSp ~= nil then
        self.ScrollView:removeAllChildren()
        self.ImageSp = nil
        self.ImageSp = ccui.ImageView:create(self:getrealname(Image_Num[a]), ccui.TextureResType.localType)
        self.ImageSp:setContentSize(self.imagepanel:getContentSize())
        self.ImageSp:setAnchorPoint(cc.p(0,0))
        self.ImageSp:setPosition(cc.p(0,10))
        self.ScrollView:addChild(self.ImageSp)
    end
end
--公告点击
function ActivityNoticeView:OnBtnWorldChick(sender)
    local a = sender:getTag()
    for i = 1, GONGGAOBTN_IMAGESCLECE do
        self.m_itemLight2[i]:setVisible(false)
        self.Btn_worldview[i]:loadTextures(self:getrealname(BTN_Num_1[i+HUODONGBTN_IMAGESCLECE]),self:getrealname(BTN_Num_1[i+HUODONGBTN_IMAGESCLECE]),0)
        if i == a then
        self.m_itemLight2[i]:setVisible(true)
        sender:loadTextures(self:getrealname(BTN_Num[a+HUODONGBTN_IMAGESCLECE]),self:getrealname(BTN_Num[a+HUODONGBTN_IMAGESCLECE]),0)
        end
    end
    self.Text_1:setVisible(false)
    self.Text_2:setVisible(false)
    if a == 1 then
        self.imagepanel:setVisible(false) 
        self.worldpanel:setVisible(true)
        self.titleWord:setString("郑重声明")

    elseif a == 2 then
        self.imagepanel:setVisible(true) 
        self.worldpanel:setVisible(false)
        self.ScrollView:removeAllChildren()
        self.ImageSp = nil
        self.ImageSp = ccui.ImageView:create(self:getrealname(Image_Num[6]), ccui.TextureResType.localType)
        self.ImageSp:setContentSize(self.imagepanel:getContentSize())
        self.ImageSp:setAnchorPoint(cc.p(0,0))
        self.ImageSp:setPosition(cc.p(0,10))
        self.ScrollView:addChild(self.ImageSp)
    elseif a == 3 then
        self.imagepanel:setVisible(false) 
        self.worldpanel:setVisible(true)
        self.titleWord:setString("新玩家必读")
        self.Text_1:setVisible(true)
    elseif a == 4 then
        self.imagepanel:setVisible(false) 
        self.worldpanel:setVisible(true)
        self.titleWord:setString("反作弊公告")
        self.Text_2:setVisible(true)
    end
end
--活动界面点击
function ActivityNoticeView:OnBtnPanelChick()
    print("ok")
    self:createtabPanel(false)
    self:initImageview()
    self.imagepanel:setVisible(true) 
    self.worldpanel:setVisible(false)
    self.m_itemLight[1]:setVisible(true)
    if self.ImageSp ~= nil then
        self.ScrollView:removeAllChildren()
        self.ImageSp = nil
        self.ImageSp = ccui.ImageView:create(self:getrealname(Image_Num[1]), ccui.TextureResType.localType)
        self.ImageSp:setContentSize(self.imagepanel:getContentSize())
        self.ImageSp:setAnchorPoint(cc.p(0,0))
        self.ImageSp:setPosition(cc.p(0,10))
        self.ScrollView:addChild(self.ImageSp)
    end
end
--公告界面点击
function ActivityNoticeView:OnBtnPanel2Chick()
    print("ok")
    self:createtabPanel(true)
    self:initWorldview()
    self.imagepanel:setVisible(false)
    self.worldpanel:setVisible(true)
    self.m_itemLight2[1]:setVisible(true)
    self.titleWord:setString("郑重声明")
end
function ActivityNoticeView:OnBtnCloseChick()
    ExternalFun.playClickEffect()
    self:onMoveExitView()
end
function ActivityNoticeView:createtabPanel(visible)
    self.m_panel_1_image2:setVisible(visible)
    self.m_panel_1_image1:setVisible(not visible)
    self.m_panel_1_bg:setVisible(not visible)

    self.m_panel_2_image2:setVisible(not visible)
    self.m_panel_2_image1:setVisible(visible)
    self.m_panel_2_bg:setVisible(visible)
end
function ActivityNoticeView:getrealname(name)
    return "dt/image/newActivity/"..name
end

function ActivityNoticeView:setImage(name)
    local strHeadIcon = string.format("dt/image/newActivity/%s", name)
    self.ImageSp:loadTexture(strHeadIcon, ccui.TextureResType.localType)
end
return ActivityNoticeView
--endregion
