//+------------------------------------------------------------------+
//|                                                       danash.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <json.mqh>
#include <hashvalue.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {


// Define the URL of the API endpoint
string url = "https://t6t1yeuvil.execute-api.us-east-1.amazonaws.com/prod/FRED";

// Define the variables for storing the fetched data
datetime timestamp[];
double value[];

// Fetch the data from the API endpoint
string response = WebRequest("GET", url);
int json = JSONCreateObject();
JSONParse(json, response);
int json_data = JSONGetMember(json, "data");
int count = JSONSize(json_data);
ArrayResize(timestamp, count);
ArrayResize(value, count);

for (int i = 0; i < count; i++) {
    int json_item = JSONGetElement(json_data, i);
    timestamp[i] = JSONGetMember(json_item, "timestamp");
    value[i] = JSONGetMember(json_item, "value");
}

// Define the table parameters
int rows = count + 1;
int cols = 2;
int cell_width = 100;
int cell_height = 20;
int x = 50;
int y = 50;

// Draw the table header

for (int j = 0; j < cols; j++) {
    int header_x = x + j * cell_width;
    int header_y = y;
    string header_text = (j == 0) ? "Timestamp" : "Value";
    string header_name = "header_" + IntegerToString(j);
    ObjectCreate(0, header_name, OBJ_TEXT, 0, 0, 0);
    ObjectSetInteger(0, header_name, OBJPROP_CORNER, 0);
    ObjectSetInteger(0, header_name, OBJPROP_XDISTANCE, header_x);
    ObjectSetInteger(0, header_name, OBJPROP_YDISTANCE, header_y);
    ObjectSetText(header_name, header_text, 10, "Arial", clrWhite);
}

// Draw the table data
for (int i = 0; i < count; i++) {
    for (int j = 0; j < cols; j++) {
        int cell_x = x + j * cell_width;
        int cell_y = y + (i + 1) * cell_height;
        string cell_text = (j == 0) ? TimeToString(timestamp[i], TIME_DATE | TIME_MINUTES) : DoubleToString(value[i], 2);
        string cell_name = "cell_" + IntegerToString(i) + "_" + IntegerToString(j);
        ObjectCreate(0, cell_name, OBJ_TEXT, 0, 0, 0);
        ObjectSetInteger(0, cell_name, OBJPROP_CORNER, 0);
        ObjectSetInteger(0, cell_name, OBJPROP_XDISTANCE, cell_x);
        ObjectSetInteger(0, cell_name, OBJPROP_YDISTANCE, cell_y);
        ObjectSetText(cell_name, cell_text, 10, "Arial", clrBlack);
    }
}

   
  }
//+------------------------------------------------------------------+
