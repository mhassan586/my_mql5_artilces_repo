//+------------------------------------------------------------------+
//|                                Three inside pattern detector.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
void OnTick()
  {
   getthreeInside();
  }
int getthreeInside()
  {
   datetime time=iTime(_Symbol,PERIOD_CURRENT,1);
   double open=iOpen(_Symbol,PERIOD_CURRENT,1);
   double high=iHigh(_Symbol,PERIOD_CURRENT,1);
   double low=iLow(_Symbol,PERIOD_CURRENT,1);
   double close=iClose(_Symbol,PERIOD_CURRENT,1);
   double open2=iOpen(_Symbol,PERIOD_CURRENT,2);
   double high2=iHigh(_Symbol,PERIOD_CURRENT,2);
   double low2=iLow(_Symbol,PERIOD_CURRENT,2);
   double close2=iClose(_Symbol,PERIOD_CURRENT,2);
   double open3=iOpen(_Symbol,PERIOD_CURRENT,3);
   double high3=iHigh(_Symbol,PERIOD_CURRENT,3);
   double low3=iLow(_Symbol,PERIOD_CURRENT,3);
   double close3=iClose(_Symbol,PERIOD_CURRENT,3);
   if(open3>close3)
     {
      if(open2<close2)
        {
         if(open2>low3&&close2<high3)
           {
            if(open<close&&open>open2&&open<close2)
              {
               if(close>high3)
                 {
                  createObj(time,low,217, clrGreen,"3 Inside Up");
                    {
                     return 1;
                    }
                 }
              }
           }
        }
     }
   if(open3<close3)
     {
      if(open2>close2)
        {
         if(open2<high3&&close2>low3)
           {
            if(open>close&&open<open2&&open>close2)
              {
               if(close<low3)
                 {
                  createObj(time,high,218, clrRed,"3 Inside Down");
                    {
                     return -1;
                    }
                 }
              }
           }
        }
     }
   return 0;
  }
void createObj(datetime time, double price, int arrawCode, color clr, string txt)
  {
   string objName=" ";
   StringConcatenate(objName, "Signal@",time, "at",DoubleToString(price,_Digits),"(",arrawCode,")");
   if(ObjectCreate(0,objName,OBJ_ARROW,0,time,price))
     {
      ObjectSetInteger(0,objName,OBJPROP_ARROWCODE,arrawCode);
      ObjectSetInteger(0,objName,OBJPROP_COLOR,clr);
      if(clr==clrGreen)
         ObjectSetInteger(0,objName,OBJPROP_ANCHOR,ANCHOR_TOP);
      if(clr==clrRed)
         ObjectSetInteger(0,objName,OBJPROP_ANCHOR,ANCHOR_BOTTOM);
     }
   string candleName=objName+txt;
   if(ObjectCreate(0,candleName,OBJ_TEXT,0,time,price))
     {
      ObjectSetString(0,candleName,OBJPROP_TEXT," "+txt);
      ObjectSetInteger(0,candleName,OBJPROP_COLOR,clr);
     }
  }