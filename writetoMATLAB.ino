
#include <ThingSpeak.h>
#include <ESP8266WiFi.h>

// Network parameters
const char* ssid     = "VodafoneMobileWiFi-3D4310";
const char* password = "5946544077";

// ThingSpeak information
char thingSpeakAddress[] = "api.thingspeak.com";
unsigned long channelID = 1701579;
char* readAPIKey = "S9C30E0VKKUQ4PX7";
char* writeAPIKey = "HE67OYX84MK1LIXV";
const unsigned long postingInterval = 120L * 1000L;
unsigned int dataFieldOne = 1;                            // Field to write ecg data
unsigned int dataFieldTwo = 2;                     // Field to write elapsed time data

unsigned long lastConnectionTime = 0;
long lastUpdateTime = 0; 

WiFiClient client;

void setup() {
  // put your setup code here, to run once:
Serial.begin(9600);
Serial.println("Start");
  connectWiFi();
}

void loop() {
  // put your main code here, to run repeatedly:
 //Update only if the posting time is exceeded
        
        
        //lastUpdateTime = millis();
      
        float ecgsignal = analogRead(A0);
        write2TSData( channelID , dataFieldOne , ecgsignal , dataFieldTwo , millis() ); 
        Serial.println(ecgsignal);

//}
}
void connectWiFi(){
    Serial.println("Connecting to WiFi...");
    WiFi.begin( ssid, password );
    while (WiFi.status() != WL_CONNECTED) {
         delay(100);
         Serial.print(".");
       // WiFi.begin( ssid, password );    
    }
    
    Serial.println( "Connected" );
    ThingSpeak.begin( client );
}

// Use this function if you want to write multiple fields simultaneously.
int write2TSData( long TSChannel, unsigned int TSField1, float field1Data, unsigned int TSField2, long field2Data){

  ThingSpeak.setField( TSField1, field1Data );
  ThingSpeak.setField( TSField2, field2Data );
 
  int writeSuccess = ThingSpeak.writeFields( TSChannel, writeAPIKey );
  return writeSuccess;
}
