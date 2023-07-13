# Control board project

## Tf is this?
This is project for control board of a mixer. 
It is based on ESP32(with wi-fi) and serves as a bridge between mixer DSP hardware and flutter app:
- Provides AP/Client functionality.
- Provides REST API for controlling the mixer.
- Stores mixer settings in flash memory.
- Controls the mixer DSP via I2C.

To switch between AP and Client modes at a boot time add a switch between `GPIO4` and `GND`.

## How to build?
install [platform.io](https://docs.platformio.org/en/latest/integration/ide/vscode.html#installation) and run `pio run` in the project directory.

_to be continued..._