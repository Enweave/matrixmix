#ifndef BT2SERIAL_WEB_H
#define BT2SERIAL_WEB_H

#endif //BT2SERIAL_WEB_H

const uint8_t NUMBER_OF_FADERS = 36;
uint8_t faderValues[NUMBER_OF_FADERS];
WebServer server(80);

void hello() {
    DynamicJsonDocument doc(1024);
    doc["ver"] = "1";
    String output = "";
    serializeJson(doc, output);
    server.send(200, "application/json", output);
}

void getFaders() {
    DynamicJsonDocument doc(1024);
    JsonObject faders = doc.createNestedObject("faders");
    for (uint8_t faderId = 0; faderId < NUMBER_OF_FADERS; faderId++) {
        faders[String(faderId)] = 123;
    }
    String output = "";
    serializeJson(doc, output);
    server.send(200, "application/json", output);
}

void setupWeb() {
    server.on("/faders", HTTP_GET, getFaders);
    server.on("/", HTTP_GET, hello);
    server.begin();
    Serial.println("Server started");
}