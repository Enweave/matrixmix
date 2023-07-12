# Matrixmix

[Matrix mixer](https://en.wikipedia.org/wiki/Matrix_mixer) on a budgetm kinda

## tf is this?

The goal is to create an affordable and portable matrix mixer for in-ear monitors. The mixer will be powered by USB 5V, have three stereo inputs/outputs, and be controlled via a Flutter app through Wi-Fi.

Root of the repository is a flutter project. The firmware, schematics and STLs are in the [hardware folder](hardware).

### Flutter app
Controls mixer through wifi using http/websockets. The app is a work in progress.

### Hardware
Consists of thwo parts:
- [Control](hardware/control) - Firmware for the ESP32 - wi-fi AP, http server, websocket server, mixer logic.
- [dsp](hardware/dsp) - Firmware for the SigmaDSP - the mixer itself.

_to be continued..._