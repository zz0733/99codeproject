--region *.lua
--Date 2017-2-25
--Author xufei
--此文件由[BabeLua]插件自动生成

local BaccaratEvent = { 

    --更新消息
    MSG_UPDATE_ROLL_MSG             = "baccarat_evt_roll_msg",     --系统消息
    MSG_UPDATE_BANK_INFO            = "baccarat_evt_bank_info",    --银行数据
    MSG_UPDATE_USER_SCORE           = "baccarat_evt_usr_score",    --玩家分数

    --游戏消息
    MSG_GAME_BACCARAT_STATE         = "baccarat_evt_game_state",   --游戏状态
    MSG_GAME_BACCARAT_CHIP_SUCCESS  = "baccarat_evt_chip_ok",      --投注成功
    MSG_GAME_BACCARAT_CHIP_CONTINUE = "baccarat_evt_chip_again",   --续投成功
    MSG_GAME_BACCARAT_CHIP_FAIL     = "baccarat_evt_chip_fail",    --投注失败
    MSG_GAME_BACCARAT_BANKER        = "baccarat_evt_banker_info",  --庄家信息
    MSG_GAME_BACCARAT_APPLYBANKER   = "baccarat_evt_banker_apply", --申请上庄成功信息
    MSG_GAME_BACCARAT_RECORD        = "baccarat_evt_game_record",  --历史数据
    MSG_GAME_CANCEL_BANKER          = "baccarat_evt_cancel_banker",--取消当庄
    MSG_GAME_BACCARAT_UPDATERECORD  = "baccarat_evt_update_record",--更新历史记录
}

return BaccaratEvent
--endregion
