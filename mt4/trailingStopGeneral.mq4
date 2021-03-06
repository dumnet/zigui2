//+------------------------------------------------------------------+
//|【功能】行情跟随式止损的通常算法                                  |
//|                                                                  |
//|【参数】 IN OUT  参数名             说明                          |
//|        --------------------------------------------------------- |
//|         ○      aMagic             魔法数                        |
//|         ○      aTS_StartPips      跟随步进幅值（pips）          |
//|         ○      aTS_StopPips       止损幅值（pips）              |
//|                                                                  |
//|【返值】无                                                        |
//|                                                                  |
//|【备注】从原平仓价格处以 aTS_StartPips 幅度跟随步进，在新设定     |
//|        的平仓价格处按 aTS_StopPips 幅度设定止损位价格            |
//|        a - arguments, g - global variables, o - order            |
//+------------------------------------------------------------------+
void trailingStopGeneral(int aMagic, double aTS_StartPips, double aTS_StopPips)
{
  for (int i = 0; i < OrdersTotal(); i++) {
    // 任意当前订单（仓）若不存在，则结束当前及后续所有订单处理
    if (OrderSelect(i, SELECT_BY_POS) == false) {
      break;
    }

    // 取得订单币种
    string oSymbol = OrderSymbol();

    // 若订单币种同当前交易币种不一致 或 订单魔法数不匹配
    // 判断属于其他 EA 订单，忽略当前订单处理
    if (oSymbol != Symbol() || OrderMagicNumber() != aMagic) {
      continue;
    }

    // 取得订单（仓）类型
    int oType = OrderType();

    // 非多订单（仓） 及 非空订单（仓），忽略当前订单处理
    if (oType != OP_BUY && oType != OP_SELL) {
      continue;
    }

    // 当前币种的汇率行情的点位调整
    double digits = MarketInfo(oSymbol, MODE_DIGITS);

    // 按点位调整当前订单（仓）的开仓价格
    double oPrice    = NormalizeDouble(OrderOpenPrice(), digits);
    // 按点位调整当前订单（仓）的止损价格
    double oStopLoss = NormalizeDouble(OrderStopLoss(), digits);
    // 订单（仓）号
    int    oTicket   = OrderTicket();

    // 按点位调整跟随步进幅值
    double start = aTS_StartPips * gPipsPoint;
    // 按点位调整止损幅值
    double stop  = aTS_StopPips  * gPipsPoint;

    if (oType == OP_BUY) { // 若为【多】订单(仓)
      double price = MarketInfo(oSymbol, MODE_BID);  // 当前币种汇率行情的 BID 价格
      double modifyStopLoss = price - stop;          // 按止损幅值设定【新止损位价格】

      // 当前币种汇率行情的 BID 价格已经 【不低于】 开仓价格加上跟随步进幅值（低价（止损）平仓不划算）
      if (price >= oPrice + start) {
        if (modifyStopLoss > oStopLoss) { // 当前【多】订单（仓）的止损位价格低于【新止损位价格】
          // 修改（提高）当前【多】订单（仓）的止损位价格为【新止损位价格】
          orderModifyReliable(oTicket, 0.0, modifyStopLoss, 0.0, 0, gArrowColor[oType]);
        }
      }
    } else if (oType == OP_SELL) {  // 若为【空】订单(仓)
      price = MarketInfo(oSymbol, MODE_ASK);    // 当前币种汇率行情的 ASK 价格
      modifyStopLoss = price + stop;            // 按止损幅值设定【新止损位价格】

      // 当前币种汇率行情的 ASK 价格已经 【不高于】 开仓价格减去跟随步进幅值（高价（止损）平仓不划算）
      if (price <= oPrice - start) {
        // 【空】仓的情况下，条件必须判断 oStopLoss == 0.0 （即当前订单（仓）的止损价格若为 0.0，默认情况）
        // 在 oStopLoss为 0 时 认为未指定止损位价格，将会导致 modifyStopLoss < oStopLoss 的条件永远无法成立
        // ※ 因「modifyStopLoss < 0」不会发生，即「modifyStopLoss 该价格常为正数 （price + stop）」
        if (modifyStopLoss < oStopLoss || oStopLoss == 0.0) { // 当前【空】订单（仓）的止损位价格高于【新止损位价格】
          // 修改（下调）当前【空】订单（仓）的止损位价格为【新止损位价格】
          orderModifyReliable(oTicket, 0.0, modifyStopLoss, 0.0, 0, gArrowColor[oType]);
        }
        // 示例：usd/jpy， start = 5，stop = 3
        // 在汇率 120（oPrice） 开仓做【卖空】，假定此时止损位价格指定为 127（oStopLoss = 120 + 7（任意））
        // 当汇率变动至 110（price（ASK）），按止损幅值应设定【新止损位价格】113（modifyStopLoss = 110 + 3（stop））
        // 因 110（price（ASK）） <= 115 【120（oPrice）- start (5)】并且 113（modifyStopLoss）< 127（oStopLoss）
        // 即可下调 当前【空】订单（仓）的止损位价格为【新止损位价格】113（modifyStopLoss = 110 + 3）
      }
    }
  }
}
