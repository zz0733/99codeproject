--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--首先声明常量
local AnimalScene_Define = require("game.yule.fqzs.src.scene.AnimalSceneDefine")
local AnimalScene_Events = require("game.yule.fqzs.src.scene.AnimalSceneEvent")

local CBetManager = require("game.yule.fqzs.src.manager.CBetManager")
local FloatMessage = require("game.yule.fqzs.src.manager.FloatMessage")

local JETTON_ITEM_COUNT = 6 -- 6个筹码
local CHIP_ITEM_COUNT = 11	--下注项数 （ 4飞禽项 4走兽项 鲨鱼项 2双倍项 ）
local CHIP_VALUES_COUNT = 8
local enumContinueChipRet_OK = 0
local enumContinueChipRet_CanNotChip = 1	--//不能投注
local enumContinueChipRet_NoEnoughScore = 2	--//没有足够的分数
local enumContinueChipRet_UnKnown = 0xff	--//未知错误
local enumClearChipRet_OK = 0
local enumClearChipRett_CanNotClearChip = 1	--不能清空

local CMsgAnimal = class("CMsgAnimal")  

CMsgAnimal.GAMESTATUS = {
    STATUS_BEGANCHIP = 1, --//开始下注
    STATUS_LOTTERY   = 2, --//开奖
    STATUS_IDLETIME  = 3, --//空闲时间
    STATUS_STOPCHIP  = 4, --//停止下注 仅作为业务操作 不作为业务状态
}

function CMsgAnimal.getInstance()
    if CMsgAnimal.instance == nil then  
        CMsgAnimal.instance = CMsgAnimal.new()
    end  
    return CMsgAnimal.instance  
end

function CMsgAnimal:ctor()
    self.super:init()
    self:init()
end

function CMsgAnimal:init()

    self.func_game_ =
    {
        [G_C_CMD.MDM_GF_FRAME] = {  --100
            --框架命令 
            [G_C_CMD.SUB_GF_GAME_SCENE]       = {func = self.process_100_101, log="游戏场景", debug = true, }
        },

        [G_C_CMD.MDM_GF_GAME] = {
            [G_C_CMD.CMD_ChipStart_S_P]       = {func = self.process_200_101, log="下注开始", debug = true, },
            [G_C_CMD.CMD_ChipStop_S_P]        = {func = self.process_200_102, log="下注结束", debug = true, },
            [G_C_CMD.CMD_GameStart_S_P]       = {func = self.process_200_103, log="游戏开始", debug = true, },
            [G_C_CMD.CMD_GameEnd_S_P]         = {func = self.process_200_104, log="游戏结束", debug = true, },
            [G_C_CMD.CMD_UpdataChip_S_P]      = {func = self.process_200_105, log="更新下注", debug = true, },
            [G_C_CMD.CMD_ChipSucc_S_P]        = {func = self.process_200_106, log="下注成功", debug = true, },
            [G_C_CMD.CMD_SysMessage_S_P]      = {func = self.process_200_107, log="系统消息", debug = true, },
            [G_C_CMD.CMD_GameInfo_S_P]        = {func = self.process_200_109, log="游戏信息", debug = true, },
            [G_C_CMD.CMD_GameResultInfo_S_P]  = {func = self.process_200_110, log="结算信息", debug = true, },
            [G_C_CMD.CMD_ContinueChip_S_P]    = {func = self.process_200_111, log="玩家续投", debug = true, },
            [G_C_CMD.CMD_GameOpenLog_C_P]     = {func = self.process_200_112, log="开奖纪录", debug = true, },
            [G_C_CMD.CMD_ClearChip_S_P]       = {func = self.process_200_113, log="清空投注", debug = true, },
            [G_C_CMD.CMD_BankerScoreNeed_S_P] = {func = self.process_200_122, log="上庄金币", debug = true, },

            --[G_C_CMD.CMD_UserChip_C_P]        = {func = self.process_200_151, log="玩家下注", debug = true, },
            --[G_C_CMD.CMD_ContinueChip_C_P]    = {func = self.process_200_152, log="续投回应", debug = true, },
            --[G_C_CMD.CMD_ClearChip_C_P]       = {func = self.process_200_153, log="清空投注", debug = true, },

            [G_C_CMD.BANKER_REQ_RESULT_SC]    = {func = self.process_200_8001, log="申请结果", debug = true, },
            [G_C_CMD.BANKER_SITUSERINFO_SC]   = {func = self.process_200_8002, log="坐庄信息", debug = true, },
            --[G_C_CMD.BANKER_REQUPBANKER_CS]   = {func = self.process_200_8051, log="申请上庄", debug = true, },
        },
    }

    self.m_pHandlerID = nil
end

function CMsgAnimal:process(__nMainId,__nSubId,__data)

    local processer = {}
    if self.func_game_[__nMainId] and self.func_game_[__nMainId][__nSubId] then
        processer = self.func_game_[__nMainId][__nSubId]
    elseif self.func_base_[__nMainId] and self.func_base_[__nMainId][__nSubId] then
        processer = self.func_base_[__nMainId][__nSubId]
    end

    if processer.func and not processer.debug then
        processer.func(self, __data)
    elseif processer.func and processer.debug then
        --MSG_PRINT("- fly - [%d][%d][%s] - %s", __nMainId, __nSubId, processer.log, processer.func(self, __data))
    elseif not processer.func then
        --MSG_PRINT("- fly - [%d][%d] didn't process \n\n", __nMainId, __nSubId)
    end
end

--游戏场景
function CMsgAnimal:process_100_101(__data)
 
 --[[
 struct CMD_Sence_Free
{
	WORD			wGameStatus;
	LONGLONG		llUserScore;							//玩家分数
	UserChip_ST		llUserChip;								//玩家下注信息
	LONGLONG		llChipsValues[CHIPS_VALUES_COUNT];		//筹码数值
	DWORD			dwRevenueRatio;							//明税税率（按照万分之计算，如值为500，表示万分之五百）
};
 ]]--

    local len = __data:getReadableSize()
	local _buffer = __data:readData(len)

    --add by nick
    --清除续投记录 等变量
    CBetManager.getInstance():clearVar()

    --数据
    local msg = {}
    msg.wGameStatus = _buffer:readShort()
    msg.llUserScore = _buffer:readLongLong() --//玩家分数
    msg.llUserChip = {}
    for i=1,tonumber(CHIP_ITEM_COUNT),1 do
        msg.llUserChip[i] = _buffer:readLongLong() --//玩家下注信息
        --print(msg.llUserChip[i])
    end
    msg.llChipsValues = {}
    for i=1,tonumber(CHIP_VALUES_COUNT),1 do 
        msg.llChipsValues[i] = _buffer:readLongLong() -- //筹码数值
    end
    
    msg.wGameTax = _buffer:readInt()

    --设置明税税率
    CBetManager.getInstance():setGameTax(msg.wGameTax/10000)

    --处理
    PlayerInfo.getInstance():setUserScore(msg.llUserScore)
    for i=1,tonumber(CHIP_ITEM_COUNT),1 do
        local ship = {}
        ship.llChipValue = msg.llUserChip[i]
        ship.wChipIndex = i - 1
        if ship.llChipValue > 0 then
            CBetManager.getInstance():addUserShip(ship)
        end
    end

    for i=1,tonumber(CHIP_VALUES_COUNT),1 do
        if msg.llChipsValues[i] == 0 then
            break
        end
        CBetManager.getInstance():setJettonScore(i, msg.llChipsValues[i])
    end
        
    --通知
    --SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_SUB_GF_GAME_SCENE)
    self:enterGameScene()

    local ret = string.format("%s", "游戏开始")
    return ret
end

function CMsgAnimal:process_200_101(__data)

    --清空数据
    CBetManager.getInstance():setContinue(false)
    CBetManager.getInstance():refreshLast()
    CBetManager.getInstance():setWinScore(0)
    CBetManager.getInstance():setShipScore(0)
    CBetManager.getInstance():setGameResult(0)
    --self:startCountDownShedule(20)
    --游戏状态->开始下注
    CBetManager.getInstance():setStatus(self.GAMESTATUS.STATUS_BEGANCHIP)
       
    --通知
    SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_CMD_ChipStart_S_P)

    local ret = string.format("%s", "投递开始下注事件~~~~~~~~~~~~~~~~~~~~~~~~~~")
    --local ret = ""
    return ret
end

--下注结束
function CMsgAnimal:process_200_102(__data)

    --保存
    CBetManager.getInstance():setStatus(self.GAMESTATUS.STATUS_STOPCHIP)
    -- 停止下注事件包含了(停止下注[2]，开奖[10]，空闲时间[7] 1秒缓冲)
    --self:startCountDownShedule(20)
    --通知
    SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_CMD_ChipStop_S_P)

    local ret = string.format("%s", "投递停止下注事件~~~~~~~~~~~~~~~~~~~~~~~~~~")
    --local ret = ""
    return ret
end

--游戏开始 
function CMsgAnimal:process_200_103(__data)

	local _buffer = __data:readData(__data:getReadableSize())
        
    --数据
    local msg = {}
    msg.wDstType = _buffer:readUShort() --//目标类型
    msg.wDstIndex = _buffer:readUShort() -- //中的目标
    msg.wLastPos = _buffer:readUShort() -- //上次位置
    msg.wDstPos = _buffer:readUShort() --//中的位置

    --保存
    CBetManager.getInstance():setHitDstType(msg.wDstType)
    CBetManager.getInstance():setDstIndex(msg.wDstIndex)
    CBetManager.getInstance():setLastPos(msg.wLastPos)
    CBetManager.getInstance():setDstPos(msg.wDstPos)
    CBetManager.getInstance():setStatus(self.GAMESTATUS.STATUS_LOTTERY)
    CBetManager.getInstance():setIsBetting(false)
    CBetManager.getInstance():setPlayerResultGold(0)
    CBetManager.getInstance():setBankerResultGold(0)

    --通知
    SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_CMD_GameStart_S_P)    

    local ret = string.format("开奖中~~~~~~~~~~~~~~~~~~~~", msg.wDstIndex)
    --local ret = ""
    return ret
end

--游戏结束
function CMsgAnimal:process_200_104(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.dwBankerUserID = _buffer:readInt() --庄家
    msg.szBankerName = _buffer:readString(64) --庄家 
    msg.llBankerWin = _buffer:readLongLong() --庄家赢取分数
    msg.wUserCount = _buffer:readUShort() --赢取数量
    msg.szNickName = {}
    for i=1,tonumber(5),1 do
        msg.szNickName[i] = _buffer:readString(64)
    end
    msg.llUserWin = {}
    for i=1,tonumber(5),1 do
        msg.llUserWin[i] = _buffer:readLongLong() --玩家赢取
    end

    --开奖结束数据
    CBetManager.getInstance():setBankerUserName(msg.szBankerName)
    CBetManager.getInstance():setDealerId(msg.dwBankerUserID)
    CBetManager.getInstance():setBankerResultGold(msg.llBankerWin)
    CBetManager.getInstance():clearAllServerAllStatic()
    CBetManager.getInstance():clearPlayerWin()
    for i=1,tonumber(5),1 do
        if (msg.llUserWin[i] ~= 0)then
            CBetManager.getInstance():addPlayerWin(i, msg.szNickName[i], msg.llUserWin[i])
        end
    end
    --游戏状态->开奖结束,等待下注
    CBetManager.getInstance():setStatus(self.GAMESTATUS.STATUS_IDLETIME)

    --local ret = string.format("%s", "开奖结束~~~~~~~~~~~~~~~~")
    local ret = string.format("%s", "投递空闲时间事件~~~~~~~~~~~~~~~~")
    --local ret = ""
    return ret
end

--更新下注
function CMsgAnimal:process_200_105(__data)

	local _buffer = __data:readData(__data:getReadableSize())
    
    --数据
    local msg = {}
    msg.llUserChip = {}
    for i = 1, tonumber(CHIP_ITEM_COUNT) do
        msg.llUserChip[i] = _buffer:readLongLong()
    end

    --保存
    for i = 1, tonumber(CHIP_ITEM_COUNT) do
        local lastMoney = CBetManager.getInstance():getAllServerAllStatic(i)--上次所有下注
        local lastUser = CBetManager.getInstance():getUserChipLastSecond(i)--上次玩家下注
        CBetManager.getInstance():setAllServerAllStatic(i, msg.llUserChip[i])--//所有下注
        CBetManager.getInstance():setAllServerStatic(i, msg.llUserChip[i] - lastMoney)--//这次下注
        CBetManager.getInstance():setAllServerEveryAmount(i, msg.llUserChip[i] - lastMoney - lastUser)--非玩家下注
    end
    CBetManager.getInstance():resetRemaingBettingValue()--重设剩余可下注数量
    CBetManager.getInstance():clearUserChipLastSecond()--清空玩家上次下注
        
    --通知
    --SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_CMD_UpdataChip_S_P)
    --一秒内随机投递事件 最后一秒直接投递
    if self.GAMESTATUS.STATUS_BEGANCHIP == CBetManager.getInstance():getStatus()
        and CBetManager.getInstance():getTimeCount() > 1 then
        local randomts = math.random(0,8)/10
        cc.exports.scheduler.performWithDelayGlobal(function()
            SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_CMD_UpdataChip_S_P)
        end, randomts)
    else
        SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_CMD_UpdataChip_S_P)
    end

--    local ret = ""
--    for i = 1, CHIP_ITEM_COUNT do
--        ret = ret .. msg.llUserChip[i]..","
--    end
--    return ret
end

--下注成功
function CMsgAnimal:process_200_106(__data)

	local _buffer = __data:readData(__data:getReadableSize())
    
    --数据
    local msg = {}
    msg.bContinueChip = _buffer:readChar() --//续投模式
    msg.wChipIndex = _buffer:readUShort() -- //下注索引
    msg.llChipValue = _buffer:readLongLong() -- //下注值
    msg.llShowScore = _buffer:readLongLong() -- //玩家拥有的分数

    --保存
    if msg.bContinueChip == 0 then --下注成功
        local ship = {}
        ship.llChipValue = msg.llChipValue
        ship.wChipIndex = msg.wChipIndex
        CBetManager.getInstance():addUserShip(ship)
        local nSize = CBetManager.getInstance():getUserShipCount()

    else --续投下注成功
    	--结算前,都不设置          
        --PlayerInfo.getInstance():setUserScore(msg.llShowScore)
    end

    --通知
    SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_CMD_ChipSucc_S_P, msg)

    --local ret = string.format("下注[%d]筹码[%d]", msg.wChipIndex, msg.llChipValue)
    --return ret
end

--续投
function CMsgAnimal:process_200_111(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.wResult = _buffer:readShort() --//0为成，非0 为失败

    --保存
    if (msg.wResult == enumContinueChipRet_OK)then
        CBetManager.getInstance():setContinue(true)
    elseif (msg.wResult == enumContinueChipRet_CanNotChip)then--//不能投注
    elseif (msg.wResult == enumContinueChipRet_NoEnoughScore)then--//没有足够的分数
    elseif (msg.wResult == enumContinueChipRet_UnKnown)then--//未知错误√
    end

    --通知
    SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_CMD_ContinueChip_S_P,msg)

    local ret = string.format("%s", msg.wResult == 0 and "成功" or "失败")
    return ret
end

--清空投注回应
function CMsgAnimal:process_200_113(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.wResult = _buffer:readShort() --//0为成功，1失败
    msg.llChipValue = _buffer:readLongLong() --//清理的下注值

    --保存
    if (msg.wResult == enumClearChipRet_OK)then --//清空成功
        --重设下注数据
        CBetManager.getInstance():clearUserChip()
        CBetManager.getInstance():setContinue(false)
        PlayerInfo.getInstance():setUserScore(PlayerInfo.getInstance():getUserScore() + msg.llChipValue)
                    
        --成功提示
        FloatMessage.getInstance():pushMessage("STRING_011")
    else
        --清空失败提示
        FloatMessage.getInstance():pushMessage("STRING_010")
    end

    --通知
    SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_CMD_ClearChip_S_P,msg)
    SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_SUB_GR_USER_SCORE)

    local ret = string.format("%s", msg.wResult == 0 and "成功" or "失败")
    return ret
end

--游戏开奖纪录
function CMsgAnimal:process_200_112(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.wArrCount = _buffer:readShort()
    msg.wArrOpenLog = {}
    for i=1,tonumber(msg.wArrCount),1 do
        msg.wArrOpenLog[i] = _buffer:readShort()
    end

    --保存
    CBetManager.getInstance():clearGameOpenLog() --重设开奖记录
    for i = 1, msg.wArrCount do
        --print("开奖记录:" .. msg.wArrOpenLog[i])
        CBetManager.getInstance():addGameOpenLog(msg.wArrOpenLog[i])
    end

    --通知
    SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_CMD_GameOpenLog_C_P)

    return ""
end

--游戏结算信息
function CMsgAnimal:process_200_110(__data)

	local _buffer = __data:readData(__data:getReadableSize())
    
    --数据
    local msg = {}
    msg.llWinScoreChange = _buffer:readLongLong() --//中得分数
    msg.llllChipValue = _buffer:readLongLong() --//下注值
    msg.llNewScore = _buffer:readLongLong() --//现有分数

    --设置结算数据
    PlayerInfo.getInstance():setLastUserScore(PlayerInfo.getInstance():getUserScore())
    PlayerInfo.getInstance():setUserScore(msg.llNewScore)
    CBetManager.getInstance():setShipScore(msg.llllChipValue)     
    CBetManager.getInstance():setWinScore(msg.llWinScoreChange)    
    if CBetManager.getInstance():getUserShipCount() == 0 then
        CBetManager.getInstance():setIsBetting(false) 
    else
        CBetManager.getInstance():setIsBetting(true) 
    end   
    CBetManager.getInstance():setPlayerResultGold(msg.llWinScoreChange)    
    
    --保存                 
    SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_CMD_GameResultInfo_S_P)       

    --local ret = string.format("得分[%d]金币[%d]", msg.llWinScoreChange, msg.llNewScore)
    --return ret
    return ""
end

--游戏信息
function CMsgAnimal:process_200_109(__data)

	local _buffer = __data:readData(__data:getReadableSize())
    
    --数据
    local msg = {}
    msg.wGmaeStatus = _buffer:readShort() --游戏状态
    msg.wTimerValue = _buffer:readShort() --timer的值
    msg.llNewScore = _buffer:readLongLong() --奖池

    print(string.format( "服务器通知状态[%d]，时间[%d]", msg.wGmaeStatus, msg.wTimerValue))

    --保存 
    if msg.wGmaeStatus == self.GAMESTATUS.STATUS_BEGANCHIP then -- //开始下注[20秒]
        CBetManager.getInstance():setContinue(false)
        CBetManager.getInstance():setStatus(self.GAMESTATUS.STATUS_BEGANCHIP)
    elseif msg.wGmaeStatus == self.GAMESTATUS.STATUS_LOTTERY then -- //停止下注
        CBetManager.getInstance():setStatus(self.GAMESTATUS.STATUS_LOTTERY)
        --msg.wTimerValue = msg.wTimerValue + 5
    elseif msg.wGmaeStatus == self.GAMESTATUS.STATUS_IDLETIME then -- //开奖中 正常游戏只有这里有通知 首次进入游戏，会根据业务状态通知所有
        if CBetManager.getInstance():getTimeCount() > 0 then
            msg.wTimerValue = -1
--        else
--            msg.wTimerValue = msg.wTimerValue + 5
        end
        CBetManager.getInstance():setStatus(self.GAMESTATUS.STATUS_IDLETIME)
    end

    --print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~游戏状态切换通知:" .. msg.wGmaeStatus .. "倒计时时间：" .. msg.wTimerValue)
    if msg.wTimerValue > 0 then
        self:startCountDownShedule(msg.wTimerValue)
    end
    --通知
    SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_CMD_GameInfo_S_P, msg)

    --local ret = string.format("闹钟[%d]", msg.wTimerValue)
    --return ret
    return ""
end

--系统消息
function CMsgAnimal:process_200_107(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.wSysType = _buffer:readShort() --//消息类型 （ 0-普通消息 ）
    msg.szSysMessage = _buffer:readString(256*2) --//消息内容

    --处理
    FloatMessage.getInstance():pushMessageForString(msg.szSysMessage)

    --通知
    SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_CMD_SysMessage_S_P)

    local ret = string.format("%s", msg.szSysMessage)
    return ret
end


--玩家上庄最低金币要求
function CMsgAnimal:process_200_122(__data)

	local _buffer = __data:readData(__data:getReadableSize())
    
    --数据
    local msg = {}
    msg.llBankerScoreNeed = _buffer:readLongLong()

    --保存
    CBetManager.getInstance():setBankerScoreNeed(msg.llBankerScoreNeed)
 
    --通知
    SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_CMD_BankerScoreNeed_S_P)

    --local ret = string.format("上庄所需金币[%d]", msg.llBankerScoreNeed)
    --return ret
    return ""
end

--申请结果
function CMsgAnimal:process_200_8001(__data)

	local _buffer = __data:readData(__data:getReadableSize())
    
    --数据
    local msg = {}
    msg.resultStr = _buffer:readString(128*2) --//结果文字

    -- 由于老的数据包兼容性问题，服务端无法添加新的附加业务字段，使用字符串匹配方式来判断业务状态
    -- **申请下庄** 申请下庄成功
    -- **取消上庄** 取消申请成功
    -- **还没有申请坐庄** 已经申请下庄成功，二次申请下庄结果

    local newmsg = ""
    if string.find(msg.resultStr, "还没有申请坐庄") then
        newmsg = "您已成功申请下庄，系统将在下局开始时取消你的庄家！"
    else
        newmsg = msg.resultStr
    end

    --处理
    FloatMessage.getInstance():pushMessageForString(newmsg)

    local ret = string.format("%s", msg.resultStr)
    return ret
end

--坐庄信息
function CMsgAnimal:process_200_8002(__data)

	local _buffer = __data:readData(__data:getReadableSize())

    --数据
    local msg = {}
    msg.dwBankerUserID = _buffer:readInt() --//庄家ID
    msg.szBankerName = _buffer:readString(64) --//庄家昵称
    msg.wSitGameNum = _buffer:readInt() --//坐庄局数
    msg.llBankerScore = _buffer:readLongLong() --//庄家分数
    msg.wSelfSlot = _buffer:readShort() --//本人排位
    msg.wReqUserCount = _buffer:readShort() --//申请数量
    msg.dwReqArrUserID={}
    for i=1,tonumber(msg.wReqUserCount),1 do
        msg.dwReqArrUserID[i]=_buffer:readInt() --//申请玩家
    end

    --//重设庄家信息
    CBetManager.getInstance():setBankerUserIdByID(msg.dwBankerUserID)
    CBetManager.getInstance():setBankerName(msg.szBankerName)
    CBetManager.getInstance():setBankerGold(msg.llBankerScore)
    CBetManager.getInstance():setBankerTimes(msg.wSitGameNum)
    CBetManager.getInstance():setSelfSlot(msg.wSelfSlot)
    CBetManager.getInstance():cleanBankerList()
    for i=1,tonumber(msg.wReqUserCount),1 do
        if(msg.dwReqArrUserID[i] ~= 0) then
            CBetManager.getInstance():addBankerListByUserId(msg.dwReqArrUserID[i])
        end
    end     

    --通知
    SLFacade:dispatchCustomEvent(AnimalScene_Events.EVENT_BANKER_SITUSERINFO_SC)

    --local ret = string.format("id[%d]name[%s]", msg.dwBankerUserID, msg.szBankerName)
    --return ret
    return ""
end

--下注
function CMsgAnimal:sendMsgChip(iChipIndex,iJettonIndex)
    local wb = WWBuffer:create()
    wb:writeUShort(iChipIndex-1) --//下注索引
    wb:writeLongLong(iJettonIndex) --//下注值

    self:sendData(G_C_CMD.MDM_GF_GAME,G_C_CMD.CMD_UserChip_C_P,wb)
end

--续投
function CMsgAnimal:sendMsgContinueChip(listChip)
    local wb = WWBuffer:create()
    for i=1,tonumber(CHIP_ITEM_COUNT),1 do
        wb:writeLongLong(listChip[i])
    end

    self:sendData(G_C_CMD.MDM_GF_GAME,G_C_CMD.CMD_ContinueChip_C_P,wb)
end

-- 上下庄
function CMsgAnimal:sendMsgBanker(banker)
    local wb = WWBuffer:create()
    wb:writeChar(banker)

    self:sendData(G_C_CMD.MDM_GF_GAME,G_C_CMD.BANKER_REQUPBANKER_CS,wb)
end

function CMsgAnimal:sendMsgClearChip()
    self:sendNullData(G_C_CMD.MDM_GF_GAME, G_C_CMD.CMD_ClearChip_C_P)
end

function CMsgAnimal:startCountDownShedule(countDown)
    --self:destroyCountDownShedule()
    CBetManager.getInstance():setTimeCount(countDown)
    --SLFacade:dispatchCustomEvent(AnimalScene_Events.MSG_ANIMAL_COUNT_DOWN)
    if not self.m_pHandlerID then
        self.m_pHandlerID = scheduler.scheduleGlobal(function(dt)
            local timeCount = CBetManager.getInstance():getTimeCount() - dt
            if timeCount < 0 then timeCount = 0 end
            CBetManager.getInstance():setTimeCount(timeCount)
            SLFacade:dispatchCustomEvent(AnimalScene_Events.MSG_ANIMAL_COUNT_DOWN)   
        end, 1)
    end
end

function CMsgAnimal:destroyCountDownShedule( )
    if self.m_pHandlerID then
        scheduler.unscheduleGlobal(self.m_pHandlerID)
        self.m_pHandlerID = nil
    end
end

return CMsgAnimal

--endregion
