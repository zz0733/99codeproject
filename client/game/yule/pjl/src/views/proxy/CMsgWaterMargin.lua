--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local module_pre = "game.yule.pjl.src.views"
local WaterMarginScene_Events   = appdf.req(module_pre..".scene.WaterMarginSceneEvent")
local WaterMarginDataMgr        = appdf.req(module_pre..".manager.WaterMarginDataMgr")
--local FloatMessage              = require("common.layer.FloatMessage")
--local CBetManager               = require("common.manager.CBetManager")
local Water_Define              = appdf.req(module_pre..".proxy.Water_Define")

local WATER_ICON_ROW = 3
local WATER_ICON_COL = 5;

local DT_HALF = 0
local DT_DOUBLE = 1
local DT_NORMAL = 2

local GI_FUTOU = 0         -- 斧头
local GI_YINGQIANG = 1     -- 银枪
local GI_DADAO = 2         -- 大刀
local GI_LU = 3            -- 鲁智深
local GI_LIN = 4           -- 林冲
local GI_SONG = 5          -- 宋江
local GI_TITIANXINGDAO = 6 -- 替天行道
local GI_ZHONGYITANG = 7   -- 忠义堂
local GI_SHUIHUZHUAN = 8   -- 水浒传
local GI_COUNT = 9

local CMsgWaterMargin = class("CMsgWaterMargin", require("common.app.CMsgGame"))  

CMsgWaterMargin.instance = nil
function CMsgWaterMargin.getInstance()
    if CMsgWaterMargin.instance == nil then  
        CMsgWaterMargin.instance = CMsgWaterMargin.new()
    end  
    return CMsgWaterMargin.instance  
end

function CMsgWaterMargin:ctor()

    --水浒传 发送给服务器的消息
    --[[
    SUB_C_ADD_CREDIT_SCORE              =1,               -- 加注
    SUB_C_REDUCE_CREDIT_SCORE           =2,               -- 减注
    SUB_C_SCENE1_START                  =3,               -- 场景1开始
    SUB_C_SCENE2_BUY_TYPE               =4,               -- 买大小
    SUB_C_SCORE                         =5,               -- 得分
    SUB_C_SCENE3_START                  =6,               -- 场景3开始
    SUB_C_GLOBAL_MESSAGE                =7,               --
    --SUB_C_STOCK_OPERATE                 =8               --
    SUB_C_PRO_INQUIRY                   =9,               -- 概率查询
    SUB_C_SAVE_PRO                      =10,
    SUB_C_PERSON_CONTROL                =11,              -- 个人控制
    SUB_C_GameEnd_WATER                 =12,              -- 游戏结束(水浒传游戏结束)
    ]]

    --水浒传 收到服务器的消息
    self.func_game_ =
    {
        [G_C_CMD.MDM_GF_FRAME] = { --100-场景信息（覆盖）
            [G_C_CMD.SUB_GF_GAME_SCENE]         = { func = self.process_100_101, log="场景信息", debug = true, },  --101
        },
        
        [G_C_CMD.MDM_GF_GAME] = { --200-游戏信息
            [G_C_CMD.SUB_S_SCENE1_START]        = { func = self.process_200_100, log="滚动结果", debug = true, },
            [G_C_CMD.SUB_S_SCENE2_RESULT]       = { func = self.process_200_101, log="骰子结果", debug = true, },
            [G_C_CMD.SUB_S_SCENE3_RESULT]       = { func = self.process_200_102, log="玛丽结果", debug = true, },
--            [G_C_CMD.SUB_S_STOCK_RESULT]        = { func = self.process_200_103, log="库存操作", debug = true, },
--            [G_C_CMD.SUB_S_PRO_INQUIRY_RESULT]  = { func = self.process_200_104, log="概率查询", debug = true, },
--            [G_C_CMD.SUB_S_PERSON_RESULT]       = { func = self.process_200_105, log="个人结果", debug = true, },
--            [G_C_CMD.SUB_S_DOUBLE_RECORD]       = { func = self.process_200_106, log="比倍记录", debug = true, },
--            [G_C_CMD.SUB_S_CREDIT_SCORE_UPDATE] = { func = self.process_200_107, log="分数控制", debug = true, },
            [G_C_CMD.SUB_S_GAME_END]            = { func = self.process_200_109, log="游戏结束", debug = true, },
            [G_C_CMD.SUB_S_SERVER_MESSAGE]      = { func = self.process_200_111, log="跑马  灯", debug = true, },
            [G_C_CMD.SUB_S_RETURN_SCENE1]       = { func = self.process_200_112, log="回主场景", debug = true, },
            [G_C_CMD.SUP_S_TP_MESSAGE_INFO]     = { func = self.process_200_113, log="大奖消息", debug = true, },
        },
    }
end

--游戏场景
function CMsgWaterMargin:process_100_101(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.llJetton = _buffer:readUInt() --下注基础值
    msg.cbLineCount = _buffer:readUChar() -- 下线数
    msg.cbJettonMulti = _buffer:readUChar() --倍数值
    msg.bonus_game_times = _buffer:readInt() --（新加）小玛丽次数
    msg.llMarryWinTotalScore = _buffer:readLongLong() --（新加）小玛丽累计奖励分数
    print ("--------------------------------+++++++++++++++++++++++++-----------------------------------")
    dump(msg)
    --保存
    WaterMarginDataMgr.getInstance():setLineNum(msg.cbLineCount);
    WaterMarginDataMgr.getInstance():setBaseBetNum(msg.llJetton);
    if WaterMarginDataMgr.getInstance():getBaseBetChangeMul() == 1 then --退到后台保持之前的压注倍数。
        WaterMarginDataMgr.getInstance():setBaseBetChangeMul(msg.cbJettonMulti)
    end
    WaterMarginDataMgr.getInstance():setLittleMaryCount(msg.bonus_game_times)
    WaterMarginDataMgr.getInstance():setTotalAwardGold(msg.llMarryWinTotalScore)

    self:enterGameScene()

    return ""
end

---------------------以下为200的消息

--滚动结果
function CMsgWaterMargin:process_200_100(__data)
	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.llResultScore = _buffer:readLongLong()
    print("--------------------------------------------------------------------------")
    print("llResultScore = "..msg.llResultScore)
    msg.result_icons = {}

    for i=1,tonumber(WATER_ICON_ROW),1 do 
        local array = {}   
        for j=1,tonumber(WATER_ICON_COL),1 do    
             array[j] = _buffer:readInt()
             --print("array[j] = "..array[j])
        end
        msg.result_icons[i] = array
    end
print("--------------------------------------------------------------------------")

    --保存
    WaterMarginDataMgr.getInstance():setTotalAwardGold(0)
    if WaterMarginDataMgr.getInstance():getTestEnableLittleMary() then
        local xiaomali = WaterMarginDataMgr.getInstance():setGameResult(msg);
        if xiaomali then
            WaterMarginDataMgr.getInstance():setTestEnableLittleMary(false)
            print("有小玛丽次数 .."..xiaomali)
            --FloatMessage.getInstance():pushMessage("有小玛丽次数 .."..xiaomali)
        else
            return
        end
    else
        local littleCount = WaterMarginDataMgr.getInstance():setGameResult(msg);
        --FloatMessage.getInstance():pushMessageDebug("有小玛丽次数 .."..littleCount)
    end


    --通知
    SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_UPDATE_WATER_SCENE1_RESULT)   
    
    --重置比倍结果
    local msg2 = {}
    msg2.llResultScore = 0
    msg2.dice_points = 0
    msg2.llResultScore = 0
    WaterMarginDataMgr.getInstance():setGameCompareResult(msg2)

    return ""
end

--骰子结果(比大小)
function CMsgWaterMargin:process_200_101(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg1 = {}
    msg1.llResultScore = _buffer:readLongLong()
    msg1.dice_points = _buffer:readShort()

    --保存
    WaterMarginDataMgr.getInstance():setGameCompareResult(msg1);
    WaterMarginDataMgr.getInstance():addGameCompareResult(msg1.llResultScore)

    --通知
    SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_UPDATE_WATER_SCENE2_RESULT)   

    return ""
end

--玛丽结果
function CMsgWaterMargin:process_200_102(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.rolling_result_icons = {}
    for i=1,tonumber(4),1 do    
        msg.rolling_result_icons[i] = _buffer:readInt()
    end
    msg.rotate_result = _buffer:readInt()
    msg.llResultScore = _buffer:readLongLong() --//当前局奖励分数

    --保存
    WaterMarginDataMgr.getInstance():setLittleMaryResult(msg);
    if(msg.rotate_result == GI_SHUIHUZHUAN)then
        --结果是exit 小玛丽可玩次数减1
        local count = WaterMarginDataMgr.getInstance():getLittleMaryCount();
        count = count-1
        if  count < 0 then
            WaterMarginDataMgr.getInstance():setLittleMaryCount(0);
        else
            WaterMarginDataMgr.getInstance():setLittleMaryCount(count);
        end
    end
    
    --通知
    SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_LITTLE_MARY_RESULT)   

    return ""
end


--游戏结束
function CMsgWaterMargin:process_200_109(__data)
    --local strTime = os.date("%X")
    --print("------ recv ", strTime)
    --FloatMessage.getInstance():pushMessageDebug("收到游戏结束")
    SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_UPDATE_WATER_GAME_END)   

    return ""
end

--跑马灯
function CMsgWaterMargin:process_200_111(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    local msg = {}
    msg.wSysType = _buffer:readUShort()--消息类型 （ 0-普通消息 ）
    msg.szSysMessage = _buffer:readString(256*2) --消息内容

    --日志
    --print("系统消息："..msg.szSysMessage)

    if msg.wSysType == G_CONSTANTS.UPRUN_MSG then
        cc.exports.FloatMessage:getInstance():pushMessage(tostring(msg.szSysMessage))
    end

    return ""
end

--回到主场景1(子游戏中断网)
function CMsgWaterMargin:process_200_112(__data)
    SLFacade:dispatchCustomEvent(WaterMarginScene_Events.MSG_RETURN_GAME_SCENE1)   

    return ""
end

--大奖消息
function CMsgWaterMargin:process_200_113(__data)
--    //大奖消息
--    struct CMD_S_TopPrizeMessageInfo
--    {
--     TCHAR szNickName[32];//中奖玩家昵称
--     BYTE cbType;//0普通，1超级，2终极，3全屏，4小玛丽
--     int  iTimes;//倍数，小玛丽类型此字段为0
--     long long llScore;//获得金币
--    };
    local _buffer = __data:readData(__data:getReadableSize())

    -- 数据
    local msg = {}
    msg.szNickName = _buffer:readString(32*2)
    msg.cbType = _buffer:readChar()
    msg.iTimes = _buffer:readInt()
    msg.llScore = _buffer:readLongLong()

    local strMsg = ""
    local strLocal = LuaUtils.getLocalString(string.format("WATER_TOP_PRIZE_%d",msg.cbType))
    local strGold = LuaUtils.getFormatGoldAndNumber(msg.llScore)
    if msg.cbType <= 3 then
        strMsg = string.format(strLocal,msg.szNickName,msg.iTimes,strGold)
    elseif msg.cbType == 4 then 
        strMsg = string.format(strLocal,msg.szNickName,strGold)
    end
    --GameRollMsg.getInstance():addMessage(strMsg)
end
----------------------------------------------------------------------
--发送开始游戏
function CMsgWaterMargin:sendMsgGameStart(jettonMul)
    print ("send gamestart")
    local wb = WWBuffer:create()
    wb:writeChar(jettonMul)
    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_SCENE1_START_NEW, wb)
end

--function CMsgWaterMargin:sendMsgAddChip()
--    self:sendNullData(G_C_CMD.MDM_GF_GAME,G_C_CMD.SUB_C_ADD_CREDIT_SCORE)	
--end

--function CMsgWaterMargin:sendMsgSubChip()
--    self:sendNullData(G_C_CMD.MDM_GF_GAME,G_C_CMD.SUB_C_REDUCE_CREDIT_SCORE)	
--end

function CMsgWaterMargin:sendMsgGameStop()

    --FloatMessage.getInstance():pushMessageDebug("发送游戏结束")
    self:sendNullData(G_C_CMD.MDM_GF_GAME,G_C_CMD.SUB_C_GameEnd_WATER)	
end

function CMsgWaterMargin:sendMsgCompareBet(iType,iCostGold)

    local BuyInfo = {}
    BuyInfo.bet_score = iCostGold
    BuyInfo.buy_type = iType
    BuyInfo.double_type = DT_NORMAL

    local wb = WWBuffer:create()
    wb:writeInt(BuyInfo.double_type)
    wb:writeInt(BuyInfo.buy_type)
    wb:writeLongLong(BuyInfo.bet_score)

    self:sendData(G_C_CMD.MDM_GF_GAME,G_C_CMD.SUB_C_SCENE2_BUY_TYPE,wb)		
end

function CMsgWaterMargin:sendMsgLittleMaryGameStart(iTimes,iCostGold)

	--int bonus_game_times;   //次数
    --long long bet_score;    //当前下注分数

    local wb = WWBuffer:create()
    wb:writeInt(iTimes)
    wb:writeLongLong(iCostGold)

    self:sendData(G_C_CMD.MDM_GF_GAME, G_C_CMD.SUB_C_SCENE3_START, wb)	
end

return CMsgWaterMargin


--endregion
