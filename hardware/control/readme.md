# Control board project

## Tf is this?
This is project for control board of a mixer. 
It is based on ESP32(with wi-fi) and serves as a bridge between mixer DSP hardware and flutter app:
- Provides AP/Client functionality.
- Provides REST API for controlling the mixer.
- Stores mixer settings in flash memory.
- Controls the mixer DSP via I2C.

## How to build, (kinda)
- install [esp32](https://github.com/espressif/arduino-esp32)  toolchain in [Arduino IDE](https://www.arduino.cc/en/software)
- Open `hardware/control/control.ino` in Arduino IDE
- Select `MH ET LIVE ESP32DevKIT` for board and your port
- Build and upload

To switch between AP and Client modes at a boot time add a switch between `GPIO4` and `GND`.


_to be continued..._