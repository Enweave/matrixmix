#ifndef FRONTEND_H
#define FRONTEND_H

#endif // FRONTEND_H

AsyncWebServer server(80);
AsyncWebSocket ws("/ws");


String getHome()
{
    String output = "<!DOCTYPE html><html><head><base href=\"/\"><meta charset=\"UTF-8\"><meta content=\"IE=Edge\" http-equiv=\"X-UA-Compatible\"><meta name=\"description\" content=\"A new Flutter project.\"><meta name=\"apple-mobile-web-app-capable\" content=\"yes\"><meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\"><meta name=\"apple-mobile-web-app-title\" content=\"matrixmix\"><link rel=\"apple-touch-icon\" href=\"icons/Icon-192.png\"><link rel=\"icon\" type=\"image/png\" href=\"favicon.png\"><title>matrixmix</title><link rel=\"manifest\" href=\"manifest.json\"><script>var serviceWorkerVersion=\"2774205243\"</script><script src=\"https://enweave.github.io/matrixmix/flutter.js\" defer=\"defer\"></script></head><body><script>window.addEventListener(\"load\",function(n){_flutter.loader.loadEntrypoint({serviceWorker:{serviceWorkerVersion:serviceWorkerVersion},onEntrypointLoaded:function(n){n.initializeEngine().then(function(n){n.runApp()})}})})</script></body></html>";
    return output;
}


String getFaders()
{
    DynamicJsonDocument doc(1024);
    JsonObject faders = doc.createNestedObject("faders");
    for (uint8_t faderId = 0; faderId < NUMBER_OF_FADERS; faderId++)
    {
        faders[String(faderId)] = faderValues[faderId];
    }
    String output = "";
    serializeJson(doc, output);
    return output;
}

void setFaders(String message)
{
    // deserialize message to json
    // get 'faders' object

    DynamicJsonDocument doc(1024);
    deserializeJson(doc, message);
    JsonObject faders = doc["faders"];
    // get number of elements in faders
    uint8_t numberOfFaders = faders.size();
    // iterate over key/value pairs in faders
    for (JsonPair fader : faders)
    {
        // get key
        String faderId = fader.key().c_str();
        // get value
        uint8_t faderValue = fader.value().as<uint8_t>();
        // set fader value
        faderValues[faderId.toInt()] = faderValue;
        stateDocument["faders"][faderId] = faderValue;
    }
    sendTODSP();
}

void notifyClients(uint32_t client_id_excluded)
{
    // get clients list
    for (AsyncWebSocketClient *client : ws.getClients())
    {
        // get client id
        uint32_t client_id = client->id();
        // check if client id is not the excluded id
        if (client_id != client_id_excluded)
        {
            // send message to client
            client->text(getFaders());
        }
    }
}

void handleWebSocketMessage(AsyncWebSocket *server, AsyncWebSocketClient *client, AwsEventType type,
                            void *arg, uint8_t *data, size_t len)
{
    AwsFrameInfo *info = (AwsFrameInfo *)arg;
    String msg = "";
    if (info->final && info->index == 0 && info->len == len)
    {
        // the whole message is in a single frame and we got all of it's data
        Serial.printf("1 ws[%s][%u] %s-message[%llu]: ", server->url(), client->id(),
                      (info->opcode == WS_TEXT) ? "text" : "binary", info->len);

        if (info->opcode == WS_TEXT)
        {
            for (size_t i = 0; i < info->len; i++)
            {
                msg += (char)data[i];
            }
        }
        else
        {
            char buff[3];
            for (size_t i = 0; i < info->len; i++)
            {
                sprintf(buff, "%02x ", (uint8_t)data[i]);
                msg += buff;
            }
        }
        Serial.printf("2 mmesg %s\n", msg.c_str());
    }
    else
    {
        // message is comprised of multiple frames or the frame is split into multiple packets
        if (info->index == 0)
        {
            if (info->num == 0)
                Serial.printf("3 ws[%s][%u] %s-message start\n", server->url(), client->id(),
                              (info->message_opcode == WS_TEXT) ? "text" : "binary");
            Serial.printf("4 ws[%s][%u] frame[%u] start[%llu]\n", server->url(), client->id(), info->num, info->len);
        }

        Serial.printf("5 ws[%s][%u] frame[%u] %s[%llu - %llu]: ", server->url(), client->id(), info->num,
                      (info->message_opcode == WS_TEXT) ? "text" : "binary", info->index, info->index + len);

        if (info->opcode == WS_TEXT)
        {
            for (size_t i = 0; i < len; i++)
            {
                msg += (char)data[i];
            }
        }
        else
        {
            char buff[3];
            for (size_t i = 0; i < len; i++)
            {
                sprintf(buff, "%02x ", (uint8_t)data[i]);
                msg += buff;
            }
        }
        Serial.printf("6 mmesg %s\n", msg.c_str());

        if ((info->index + len) == info->len)
        {
            Serial.printf("7 ws[%s][%u] frame[%u] end[%llu]\n", server->url(), client->id(), info->num, info->len);
        }
    }
    setFaders(msg);
    notifyClients(client->id());
}

void onEvent(AsyncWebSocket *server, AsyncWebSocketClient *client, AwsEventType type,
             void *arg, uint8_t *data, size_t len)
{
    switch (type)
    {
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

void initWebSocket()
{
    ws.onEvent(onEvent);
    server.addHandler(&ws);
}


String onSave()
{
    bool success = storeFaderValues();
    if (!success)
    {
        return "{\"status\":\"error\"}";
    }
    return "{\"status\":\"ok\"}";
}

void setupWeb()
{
    loadFaderValues();
    initWebSocket();
    server.on("/faders", HTTP_GET, [](AsyncWebServerRequest *request)
              { request->send(200, "application/json", getFaders()); });
    server.on("/", HTTP_GET, [](AsyncWebServerRequest *request)
              { request->send(200, "text/html", getHome()); });

    server.on("/save", HTTP_POST, [](AsyncWebServerRequest *request)
              { request->send(200, "application/json", onSave()); });

    // redirect all not found requests to another domain and append path
    server.onNotFound([](AsyncWebServerRequest *request)
                      { request->redirect("https://enweave.github.io/matrixmix/" + request->url()); });

    server.begin();
    Serial.println("Server started");
}