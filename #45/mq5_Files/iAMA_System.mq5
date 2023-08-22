//+------------------------------------------------------------------+
//|                                                  iAMA_System.mq5 |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
input double lotSize = 1;
input ENUM_TIMEFRAMES timeFrame = PERIOD_H1;
input int MAPeriod= 50;
input int fastMAPeriod= 5;
input int slowMAPeriod= 100;
int adaptiveMA;
int barsTotal;
CTrade trade;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   adaptiveMA = iAMA(_Symbol, timeFrame, MAPeriod,fastMAPeriod,slowMAPeriod, 0, PRICE_CLOSE);
   barsTotal=iBars(_Symbol,timeFrame);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   MqlRates priceArray[];
   double myAMAArray[];
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   ArraySetAsSeries(priceArray,true);
   ArraySetAsSeries(myAMAArray,true);
   int Data=CopyRates(_Symbol,timeFrame,0,3,priceArray);
   CopyBuffer(adaptiveMA,0,0,3,myAMAArray);
   double lastClose=(priceArray[1].close);
   double AMAVal = NormalizeDouble(myAMAArray[1],_Digits);
   double prevClose=(priceArray[2].close);
   double prevAMAVal = NormalizeDouble(myAMAArray[2],_Digits);
   int bars=iBars(_Symbol,timeFrame);
   if(barsTotal != bars)
     {
      barsTotal=bars;
      if(lastClose>AMAVal && prevClose<prevAMAVal)
        {
         trade.PositionClose(_Symbol);
         trade.Buy(lotSize,_Symbol,Ask,0,0,NULL);
        }
      if(lastClose<AMAVal && prevClose>prevAMAVal)
        {
         trade.PositionClose(_Symbol);
         trade.Sell(lotSize,_Symbol,Bid,0,0,NULL);
        }
     }
  }
//+------------------------------------------------------------------+
