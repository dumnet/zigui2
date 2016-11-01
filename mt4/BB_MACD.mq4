//+------------------------------------------------------------------+
//|                                               Custom BB_MACD.mq4 |
//|                                     Copyright © 2005, adoleh2000 |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+

#property  copyright "Copyright © 2005, adoleh2000"
#property  link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 4
#property  indicator_color1  Lime    //bbMacd up
#property  indicator_color2  Magenta //bbMacd up
#property  indicator_color3  Blue    //Upperband
#property  indicator_color4  Red     //Lowerband
//---- indicator parameters
extern int FastLen = 12;
extern int SlowLen = 26;
extern int Length = 10;
extern int barsCount = 400;
extern double StDv = 2.5;
//----
int loopbegin;
int shift;
double zeroline;
//---- indicator buffers
double ExtMapBuffer1[];  // bbMacd
double ExtMapBuffer2[];  // bbMacd
double ExtMapBuffer3[];  // Upperband Line
double ExtMapBuffer4[];  // Lowerband Line
//---- buffers
double bbMacd[];
double Upperband[];
double Lowerband[];
double avg[];
double bbMacdline;
double sDev;
double mean;
double sumSqr;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
//---- 6 additional buffers are used for counting.
   IndicatorBuffers(8);   
//---- drawing settings     
   SetIndexBuffer(0, ExtMapBuffer1); // bbMacd line
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 108);
   IndicatorDigits(Digits + 1);
//----
   SetIndexBuffer(1, ExtMapBuffer2); // bbMacd line
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 108);
   IndicatorDigits(Digits + 1);
//----   
   SetIndexBuffer(2, ExtMapBuffer3); // Upperband line
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID, 1);
   IndicatorDigits(Digits + 1);
//----   
   SetIndexBuffer(3, ExtMapBuffer4); // Lowerband line
   SetIndexStyle(3, DRAW_LINE, STYLE_SOLID, 1);
   IndicatorDigits(Digits + 1);
//----
   SetIndexBuffer(4, bbMacd);
   SetIndexBuffer(5, Upperband);        
   SetIndexBuffer(6, Lowerband);
   SetIndexBuffer(7, avg);    
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("BB MACD(" + FastLen + "," + SlowLen + "," + Length+")");
   SetIndexLabel(0, "bbMacd");
   SetIndexLabel(1, "Upperband");
   SetIndexLabel(2, "Lowerband");  
//---- initialization done
   return(0);
}

//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() {
//----
   return(0);
}

//+------------------------------------------------------------------+
//| Custom BB_MACD                                                   |
//+------------------------------------------------------------------+
int start() {
   int limit;
   int counted_bars = IndicatorCounted();
   if (counted_bars < 0) return(-1);
   if (counted_bars > 0) counted_bars--;

   if (barsCount > 0)
         limit = MathMin(Bars - counted_bars, barsCount);
   else  limit = Bars - counted_bars;

//----
   for (int i = 0; i < limit; i++)
       bbMacd[i] = iMA(NULL, 0, FastLen, 0, MODE_EMA, PRICE_CLOSE, i) - 
                   iMA(NULL, 0, SlowLen, 0, MODE_EMA, PRICE_CLOSE, i);
//----
   for (i = 0; i < limit; i++) {
       avg[i] = iMAOnArray(bbMacd, 0, Length, 0, MODE_EMA, i);
       sDev   = iStdDevOnArray(bbMacd, 0, Length, MODE_EMA, 0, i);  
       Upperband[i] = avg[i] + (StDv * sDev);
       Lowerband[i] = avg[i] - (StDv * sDev);
       ExtMapBuffer1[i]=bbMacd[i];     // Uptrend bbMacd
       ExtMapBuffer2[i]=bbMacd[i];     // downtrend bbMacd
       ExtMapBuffer3[i]=Upperband[i];  // Upperband
       ExtMapBuffer4[i]=Lowerband[i];  // Lowerband
       //----
       if (bbMacd[i] > bbMacd[i+1])
           ExtMapBuffer2[i] = EMPTY_VALUE;
       //----
       if (bbMacd[i] < bbMacd[i+1])
           ExtMapBuffer1[i] = EMPTY_VALUE;
   }
//---- done
   return(0);
}
//+------------------------------------------------------------------+
