#ifndef BT2SERIAL_CLIENTMODE_H
#define BT2SERIAL_CLIENTMODE_H

#endif //BT2SERIAL_CLIENTMODE_H


void startClient() {
    const char *ssid = "5G";
    const char *password = "ololo111222333";
    WiFi.begin(ssid, password);
    Serial.print("Connecting");
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println();
    Serial.print("Connected, IP address: ");
    Serial.println(WiFi.localIP());
}