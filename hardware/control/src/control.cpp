
#include <Arduino.h>
#include <WiFi.h>
#include <WiFiClient.h>
#include <WiFiAP.h>
#include <ArduinoJson.h>
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>
#include "SPIFFS.h"

#define FADERS_KEY "faders"
#define AP_KEY "wifi_ap"
#define CLIENT_KEY "wifi_client"

#include "backend.h"
#include "APMode.h"
#include "ClientMode.h"
#include "frontend.h"
#include <Wire.h>
#define I2C_SPEED 400000L      // ограничиваем скорость шины, а то успеет
#define MODE_SWITCH 4



void setup() {
    Wire.begin(); // пины можно не указывать, у esp32 один апаратный i2с и ножки развел на дефолтные пины а не на альтернативные
    Wire.setClock(I2C_SPEED);
    pinMode(LED_BUILTIN, OUTPUT);

    Serial.begin(115200);
    Serial.println();
    Serial.println("Starting services...");
    loadFaderValues();
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
