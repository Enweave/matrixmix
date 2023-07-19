#ifndef CONTROL_APMODE_H
#define CONTROL_APMODE_H

void startAp() {

    WiFi.softAP(ap_ssid, ap_password);
    IPAddress myIP = WiFi.softAPIP();
    Serial.print("AP IP address: ");
    Serial.println(myIP);
};

#endif //CONTROL_APMODE_H