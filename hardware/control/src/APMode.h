#ifndef CONTROL_APMODE_H
#define CONTROL_APMODE_H

#endif //CONTROL_APMODE_H

// Set these to your desired credentials.

void startAp() {

    WiFi.softAP(ap_ssid, ap_password);
    IPAddress myIP = WiFi.softAPIP();
    Serial.print("AP IP address: ");
    Serial.println(myIP);
};