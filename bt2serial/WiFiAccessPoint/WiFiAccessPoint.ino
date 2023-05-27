/*
  WiFiAccessPoint.ino creates a WiFi access point and provides a web server on it.

  Steps:
  1. Connect to the access point "yourAp"
  2. Point your web browser to http://192.168.4.1/H to turn the LED on or http://192.168.4.1/L to turn it off
     OR
     Run raw TCP "GET /H" and "GET /L" on PuTTY terminal with 192.168.4.1 as IP address and 80 as port

  Created for arduino-esp32 on 04 July, 2018
  by Elochukwu Ifediora (fedy0)
*/

#include <WiFi.h>
#include <WiFiClient.h>
#include <WiFiAP.h>
#include <ArduinoJson.h>
#include <WebServer.h>

// #define LED_BUILTIN 2   // Set the GPIO pin where you connected your test LED or comment this line out if your dev board has a built-in LED

// Set these to your desired credentials.
const char *ssid = "yourAP";
const char *password = "12345678";



const uint8_t NUMBER_OF_FADERS = 36;
uint8_t faderValues[NUMBER_OF_FADERS];

WebServer server(80);

void hello () {
  DynamicJsonDocument doc(1024);
  doc["ver"] = "1";
  String output = "";
  serializeJson(doc, output);
  server.send(200, "application/json", output);
}

void getFaders () {
  DynamicJsonDocument doc(1024);
  JsonObject faders = doc.createNestedObject("faders");
  for (uint8_t faderId=0; faderId < NUMBER_OF_FADERS; faderId++) {
    faders[String(faderId)] = 123;
  }
  String output = "";
  serializeJson(doc, output);
  server.send(200, "application/json", output);
}


void setup() {
  pinMode(LED_BUILTIN, OUTPUT);

  Serial.begin(115200);
  Serial.println();
  Serial.println("Configuring access point...");

  // You can remove the password parameter if you want the AP to be open.
  WiFi.softAP(ssid, password);
  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);
  server.on("/faders", HTTP_GET, getFaders);
  server.on("/", HTTP_GET, hello);
  server.begin();
  Serial.println("Server started");
}

void loop() {
  server.handleClient();
  delay(2);
}
