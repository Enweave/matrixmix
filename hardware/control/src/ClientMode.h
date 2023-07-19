#ifndef CONTROL_CLIENTMODE_H
#define CONTROL_CLIENTMODE_H


void startClient() {

    WiFi.begin(client_ssid, client_password);
    Serial.print("Connecting");
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println();
    Serial.print("Connected, IP address: ");
    Serial.println(WiFi.localIP());

    // blink led to indicate connection
    for (int i = 0; i < 3; i++) {
        digitalWrite(LED_BUILTIN, HIGH);
        delay(100);
        digitalWrite(LED_BUILTIN, LOW);
        delay(100);
    }
}

#endif //CONTROL_CLIENTMODE_H