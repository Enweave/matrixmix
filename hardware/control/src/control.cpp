
#include <Arduino.h>
#include <WiFi.h>
#include <WiFiClient.h>
#include <WiFiAP.h>
#include <ArduinoJson.h>
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>
#include "SPIFFS.h"
#include "backend.h"
#include "APMode.h"
#include "ClientMode.h"
#include "frontend.h"

#define MODE_SWITCH 4

void setup() {
    pinMode(LED_BUILTIN, OUTPUT);

    Serial.begin(115200);
    Serial.println();
    Serial.println("Starting services...");

    pinMode(MODE_SWITCH, INPUT_PULLUP);
    bool isOn = digitalRead(MODE_SWITCH);
    if (isOn) {
        Serial.println("AP mode");
        digitalWrite(LED_BUILTIN, HIGH);
        startAp();
    } else {
        Serial.println("Client mode");
        digitalWrite(LED_BUILTIN, LOW);
        startClient();
    }
    setupWeb();
}

void loop() {
   ws.cleanupClients();
}
