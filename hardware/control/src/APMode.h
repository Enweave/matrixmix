#ifndef CONTROL_APMODE_H
#define CONTROL_APMODE_H

#endif //CONTROL_APMODE_H

// Set these to your desired credentials.

void startAp() {
    const char *ssid = "MatrixMixAP";
    const char *password = "12345678";
    WiFi.softAP(ssid, password);
    IPAddress myIP = WiFi.softAPIP();
    Serial.print("AP IP address: ");
    Serial.println(myIP);
};