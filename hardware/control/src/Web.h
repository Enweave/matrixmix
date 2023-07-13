#ifndef CONTROL_WEB_H
#define CONTROL_WEB_H

#endif //CONTROL_WEB_H

AsyncWebServer server(80);
AsyncWebSocket ws("/ws");

const uint8_t NUMBER_OF_FADERS = 36;
uint8_t faderValues[NUMBER_OF_FADERS];

// TODO: reply with version
// void hello() {
//     DynamicJsonDocument doc(1024);
//     doc["ver"] = "1";
//     String output = "";
//     serializeJson(doc, output);
//     server.send(200, "application/json", output);
// }

void loadFaderValues() {
    for (uint8_t faderId = 0; faderId < NUMBER_OF_FADERS; faderId++) {
        faderValues[faderId] = 123;
    }
}

String getFaders() {
    DynamicJsonDocument doc(1024);
    JsonObject faders = doc.createNestedObject("faders");
    for (uint8_t faderId = 0; faderId < NUMBER_OF_FADERS; faderId++) {
        faders[String(faderId)] = faderValues[faderId];
    }
    String output = "";
    serializeJson(doc, output);
    return output;
}

void setFaders(String message) {
    // deserialize message to json
    // get 'faders' object
    

    DynamicJsonDocument doc(1024);
    deserializeJson(doc, message);
    JsonObject faders = doc["faders"];
    // get number of elements in faders
    uint8_t numberOfFaders = faders.size();
    // iterate over key/value pairs in faders
    for (JsonPair fader : faders) {
        // get key
        String faderId = fader.key().c_str();
        // get value
        uint8_t faderValue = fader.value().as<uint8_t>();
        // set fader value
        faderValues[faderId.toInt()] = faderValue;
    }

}

void notifyClients(uint32_t client_id_excluded) {
    Serial.printf("%s\n client_id_excluded", client_id_excluded);
//    for (uint8_t i = 0; i < ws.count(); i++) {
//        if (ws.client(i)->id() != client_id_excluded) {
//            ws.client(i)->text(getFaders());
//        }
//    }
}

void handleWebSocketMessage(AsyncWebSocket *server, AsyncWebSocketClient *client, AwsEventType type,
                            void *arg, uint8_t *data, size_t len) {
    AwsFrameInfo *info = (AwsFrameInfo *) arg;
    String msg = "";
    if (info->final && info->index == 0 && info->len == len) {
        //the whole message is in a single frame and we got all of it's data
        Serial.printf("1 ws[%s][%u] %s-message[%llu]: ", server->url(), client->id(),
                      (info->opcode == WS_TEXT) ? "text" : "binary", info->len);

        if (info->opcode == WS_TEXT) {
            for (size_t i = 0; i < info->len; i++) {
                msg += (char) data[i];
            }
        } else {
            char buff[3];
            for (size_t i = 0; i < info->len; i++) {
                sprintf(buff, "%02x ", (uint8_t) data[i]);
                msg += buff;
            }
        }
        Serial.printf("2 mmesg %s\n", msg.c_str());
//        if (info->opcode == WS_TEXT) {
//            notifyClients(client->id());
//        }
    } else {
        //message is comprised of multiple frames or the frame is split into multiple packets
        if (info->index == 0) {
            if (info->num == 0)
                Serial.printf("3 ws[%s][%u] %s-message start\n", server->url(), client->id(),
                              (info->message_opcode == WS_TEXT) ? "text" : "binary");
            Serial.printf("4 ws[%s][%u] frame[%u] start[%llu]\n", server->url(), client->id(), info->num, info->len);
        }

        Serial.printf("5 ws[%s][%u] frame[%u] %s[%llu - %llu]: ", server->url(), client->id(), info->num,
                      (info->message_opcode == WS_TEXT) ? "text" : "binary", info->index, info->index + len);

        if (info->opcode == WS_TEXT) {
            for (size_t i = 0; i < len; i++) {
                msg += (char) data[i];
            }
        } else {
            char buff[3];
            for (size_t i = 0; i < len; i++) {
                sprintf(buff, "%02x ", (uint8_t) data[i]);
                msg += buff;
            }
        }
        Serial.printf("6 mmesg %s\n", msg.c_str());

        if ((info->index + len) == info->len) {
            Serial.printf("7 ws[%s][%u] frame[%u] end[%llu]\n", server->url(), client->id(), info->num, info->len);
            if (info->final) {
                Serial.printf("8 ws[%s][%u] %s-message end\n", server->url(), client->id(),
                              (info->message_opcode == WS_TEXT) ? "text" : "binary");
//                if (info->message_opcode == WS_TEXT) {
//                    notifyClients(client->id());
//                }
            }
        }
    }
    setFaders(msg);
}

void onEvent(AsyncWebSocket *server, AsyncWebSocketClient *client, AwsEventType type,
             void *arg, uint8_t *data, size_t len) {
    switch (type) {
        case WS_EVT_CONNECT:
            Serial.printf("WebSocket client #%u connected from %s\n", client->id(),
                          client->remoteIP().toString().c_str());
            break;
        case WS_EVT_DISCONNECT:
            Serial.printf("WebSocket client #%u disconnected\n", client->id());
            break;
        case WS_EVT_DATA:
            handleWebSocketMessage(server, client, type, arg, data, len);
            break;
        case WS_EVT_PONG:
        case WS_EVT_ERROR:
            break;
    }
}

void initWebSocket() {
    ws.onEvent(onEvent);
    server.addHandler(&ws);
}

void setupWeb() {
    loadFaderValues();
    initWebSocket();
    server.on("/faders", HTTP_GET, [](AsyncWebServerRequest *request) {
        request->send(200, "application/json", getFaders());
    });
    // server.on("/", HTTP_GET, hello);
    server.begin();
    Serial.println("Server started");
}