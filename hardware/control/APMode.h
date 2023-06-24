#ifndef BT2SERIAL_APMODE_H
#define BT2SERIAL_APMODE_H

#endif //BT2SERIAL_APMODE_H

// Set these to your desired credentials.

void startAp() {
    const char *ssid = "MatrixMixAP";
    const char *password = "12345678";
    WiFi.softAP(ssid, password);
    IPAddress myIP = WiFi.softAPIP();
    Serial.print("AP IP address: ");
    Serial.println(myIP);
};