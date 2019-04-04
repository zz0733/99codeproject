--region *.lua
--Date
--
--endregion

--local ResoultLayer = class("ResoultLayer", cc.Node)
local ResoultLayer = class("ResoultLayer", cc.Layer)
local BaccaratDataMgr           = appdf.req( "game.yule.bjl.src.game.baccarat.manager.BaccaratDataMgr")
function ResoultLayer.create()
    return ResoultLayer:new()
end

function ResoultLayer:ctor()
    self:enableNodeEvents()
    self:init()
end

function ResoultLayer:init()
    self.data = {}
    self.m_pathUI = cc.CSLoader:createNode("Baccarat/BaccaratRoundResult.csb")
    self.m_pathUI:addTo(self)
    self.btn_mask = self.m_pathUI:getChildByName("button_blocktouch")
    self.btn_mask:addClickEventListener(handler(self, self.onReturnClicked))
    self.m_pBg = self.m_pathUI:getChildByName("image_bg")

    self.m_pNodexianNor   = self.m_pBg:getChildByName("node_xianNor")
    self.m_pNodexianSel   = self.m_pBg:getChildByName("node_xianSel"):setVisible(false)
    self.m_pNodezhuangNor = self.m_pBg:getChildByName("node_zhuangNor")
    self.m_pNodezhuangSel = self.m_pBg:getChildByName("node_zhuangSel"):setVisible(false)

    self.m_pDianxian      = self.m_pBg:getChildByName("dian_49"):getChildByName("atlas_xianPoints")
    self.m_pDianzhuang    = self.m_pBg:getChildByName("dian_49_0"):getChildByName("atlas_zhuangPoints")

    self.m_pxianduizi     = self.m_pBg:getChildByName("Text_1"):getChildByName("text_num1")
    self.m_pzhuangduizi   = self.m_pBg:getChildByName("Text_1_4"):getChildByName("text_num2")
    self.m_pxian          = self.m_pBg:getChildByName("Text_1_0"):getChildByName("text_num3")
    self.m_pzhuang        = self.m_pBg:getChildByName("Text_1_5"):getChildByName("text_num5")
    self.m_phe            = self.m_pBg:getChildByName("Text_1_2"):getChildByName("text_num4")
    self.m_pall           = self.m_pBg:getChildByName("Text_1_3"):getChildByName("text_sum")

    self:setData(BaccaratDataMgr.getInstance():getData())
    self:doSomethingLater(function ()
        self:removeFromParent()
    end,4)
end 

function ResoultLayer:onEnter()
end

function ResoultLayer:onExit()
end
function ResoultLayer:doSomethingLater( call, delay )
    self.m_pathUI:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(call)))
end
function ResoultLayer:onReturnClicked()
    self:removeFromParent()
end

function ResoultLayer:setData(data)
    print("666")
    local win_result,zhuangduizi,xianduizi = self:getResult(data)
    if     win_result == 1 then
        self.m_pNodexianSel:setVisible(true)
    elseif win_result == 2 then
        self.m_pNodezhuangSel:setVisible(true)
    elseif win_result == 3 then
        self.m_pNodexianSel:setVisible(false)
        self.m_pNodezhuangSel:setVisible(false)
    end

    self:changeNum(data)

    self.m_pxianduizi:setString(0)
    self.m_pzhuangduizi:setString(0)
    self.m_pxian:setString(0) 
    self.m_pzhuang:setString(0)        
    self.m_phe:setString(0)            
    self.m_pall:setString(0)   

    local ischange = false;
    for k,v in ipairs(BaccaratDataMgr.getInstance():getPlayScore()) do
        if v ~= 0 then
            ischange = true;
        end
    end
    if ischange == true then
        self:initTxtnum(win_result,zhuangduizi,xianduizi)
    end
    
end 

function ResoultLayer:initTxtnum(win_result,zhuangduizi,xianduizi)
    local m_pxianduizi = 0;
    local m_pzhuangduizi = 0;
    local m_pxian = 0;
    local m_pzhuang = 0;
    local m_phe = 0;
    local m_pall = 0;

    local MyBetscore = BaccaratDataMgr.getInstance():getPlayScore()
    if zhuangduizi == true then
        m_pzhuangduizi = MyBetscore[2] * 12
    end
    if xianduizi == true then
        m_pxianduizi = MyBetscore[1] * 12
    end
    if     win_result == 1 then
        m_pxian = MyBetscore[3]
    elseif win_result == 2 then
        m_pzhuang = MyBetscore[5]
    elseif win_result == 3 then
        m_phe = MyBetscore[4] * 9
    end
    m_pall = m_pxianduizi + m_pzhuangduizi + m_pxian + m_pzhuang + m_phe
    self.m_pxianduizi:setString(m_pxianduizi)
    self.m_pzhuangduizi:setString(m_pzhuangduizi)
    self.m_pxian:setString(m_pxian) 
    self.m_pzhuang:setString(m_pzhuang)        
    self.m_phe:setString(m_phe)            
    self.m_pall:setString(m_pall)           
     
end

function ResoultLayer:changeNum(data)
    local b = {[1] = 0 ,[2] = 0};

    for i = 1, 2 do
        for j = 1,#data[i] do
            local a = self:getCardNum(data[i][j]);
            b[i] = b[i] + a
        end
        b[i] = b[i] % 10
    end

    self.m_pDianxian:setString(b[1])
    self.m_pDianzhuang:setString(b[2])
end

function ResoultLayer:getCardNum(args)
    local card = args
    local num =  0;
    if                     card <= 8  then num = card + 1
    elseif  card >= 9  and card <= 12 then num = 0
    elseif  card >= 13 and card <= 21 then num = card - 12
    elseif  card >= 22 and card <= 25 then num = 0
    elseif  card >= 26 and card <= 34 then num = card - 25
    elseif  card >= 35 and card <= 38 then num = 0
    elseif  card >= 39 and card <= 47 then num = card - 38
    elseif  card >= 48 and card <= 51 then num = 0
    else    print("´íÎó£¡£¡£¡")
    end
    return num
end
function ResoultLayer:getResult(item)
    local win_result  = 0
    local zhuangduizi = false
    local xianduizi   = false
    local num = {
            [1] = 0,
            [2] = 0,
    };
    for i = 1 , 2 do
        for j = 1 , #item[i] do
            num[i] = num[i] + self:getCardNum(item[i][j])
            if math.abs(item[i][1] - item[i][2]) % 13 == 0  then
                if i == 1 then
                    xianduizi = true
                else 
                    zhuangduizi = true
                end
            end
        end 
    end
    num[1] = num[1] % 10
    num[2] = num[2] % 10
    win_result = num[1] > num[2] and 1 or num[1] == num[2] and 3 or 2 
    return win_result,zhuangduizi,xianduizi
end
return ResoultLayer