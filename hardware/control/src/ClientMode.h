#ifndef CONTROL_CLIENTMODE_H
#define CONTROL_CLIENTMODE_H


void startClient() {

    WiFi.begin(client_ssid, client_password);
    Serial.printf("Connecting to %s with %s", client_ssid, client_password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println();
    Serial.print("Connected, IP address: ");
    Serial.println(WiFi.localIP());

    // blink led to indicate connection
    for (int i = 0; i < 3; i++) {
        digitalWrite(STATUS_LED, HIGH);
        delay(100);
        digitalWrite(STATUS_LED, LOW);
        delay(100);
    }
}

#endif //CONTROL_CLIENTMODE_H