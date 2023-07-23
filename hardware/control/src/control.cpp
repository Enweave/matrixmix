
#define FADERS_KEY "faders"
#define AP_KEY "wifi_ap"
#define CLIENT_KEY "wifi_client"
#define I2C_SPEED 400000L
#define MODE_SWITCH 4
#define STATUS_LED 13


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
#include <Wire.h>


void setup() {
    Wire.begin();
    Wire.setClock(I2C_SPEED);
    pinMode(STATUS_LED, OUTPUT);

    Serial.begin(115200);
    Serial.println();
    Serial.println("Starting services...");
    loadFaderValues();
    pinMode(MODE_SWITCH, INPUT_PULLUP);
    bool isOn = digitalRead(MODE_SWITCH);
    if (isOn) {
        Serial.println("AP mode");
        analogWrite(STATUS_LED, 50);
        startAp();
    } else {
        Serial.println("Client mode");
        digitalWrite(STATUS_LED, LOW);
        startClient();
    }
    setupWeb();
}

void loop() {
   ws.cleanupClients();
}
