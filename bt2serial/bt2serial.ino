#include <BluetoothSerial.h>
BluetoothSerial SerialBT;

void setup() {
  SerialBT.begin("ESP32_BT");
  Serial.begin(9600);
  Serial.println("begin");
}

void loop() {
  if (SerialBT.available()) {
    Serial.write(SerialBT.read());
  }
}
