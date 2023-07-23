#ifndef BACKEND_H
#define BACKEND_H
// #define DSP_I2C_ADDR 0b0110100
#define DSP_I2C_ADDR (0x68 >> 1) & 0xFE
#include <Wire.h>
#include <Arduino.h>
#include <pgmspace.h>
#include "VolTables.h"

#define safeload_addr_addr 0x0815 
#define safeload_addr_data 0x0810 
#define dsp_core_control 0x081C 

const uint8_t NUMBER_OF_FADERS = 36;
const char *stateFileName = "/state.json";
StaticJsonDocument<2048> stateDocument;

uint8_t faderValues[NUMBER_OF_FADERS];

const char *client_ssid = "MatrixMixAP";
const char *client_password = "12345678";

const char *ap_ssid = "MatrixMixAP";
const char *ap_password = "12345678";

bool SPIFFS_is_mounted = false;


void dspWrite2b(uint16_t address, uint16_t data)
{
    Wire.beginTransmission(DSP_I2C_ADDR);
    Wire.write(address >> 8);  
    Wire.write(address & 0xff);
    Wire.write(data >> 8);
    Wire.write(data & 0xff);
    Wire.endTransmission();
}

void dspWrite4b(uint16_t address, uint32_t data)
{
    Wire.beginTransmission(DSP_I2C_ADDR);
    Wire.write(address >> 8);
    Wire.write(address & 0xff);
    Wire.write((data >> 24) & 0xFF);
    Wire.write((data >> 16) & 0xFF);
    Wire.write((data >> 8) & 0xFF);
    Wire.write(data & 0xFF);

    Wire.endTransmission();
}

void send_volume_to_dsp_safeload(uint32_t paramAddress, uint8_t volumeIndex) {
    dspWrite2b(safeload_addr_addr, paramAddress);
    uint32_t num;

    for(byte i = 0; i < 4; i++) {
        num<<=8;
        num |= pgm_read_byte(&Volume[i+(volumeIndex<<2)]);
    }
    
    dspWrite4b(safeload_addr_data, num);
    dspWrite2b(dsp_core_control, 0x0020);
}

void send_volume_to_dsp(uint8_t paramAddress, uint8_t volumeIndex) {
    uint32_t num;

    for(byte i = 0; i < 4; i++) {
        num<<=8;
        num |= pgm_read_byte(&Volume[i+(volumeIndex<<2)]);
    }
    
    dspWrite4b(paramAddress, num);
}

void sendTODSP()
{
    Serial.println(faderValues[0]);
    for (uint8_t faderId = 0; faderId < NUMBER_OF_FADERS; faderId++)
    {
        send_volume_to_dsp(faderId, faderValues[faderId]);
    }
}

void loadFaderValues()
{
    File stateFile;
    DeserializationError error;
    bool loadDefault = true;

    if (!SPIFFS.begin(true))
    {
        Serial.println("An Error has occurred while mounting SPIFFS");
    }
    else
    {
        stateFile = SPIFFS.open(stateFileName);
        error = deserializeJson(stateDocument, stateFile);
        if (!error)
        {
            loadDefault = false;
            SPIFFS_is_mounted = true;
        }

        stateFile.close();
    }

    if (loadDefault)
    {
        Serial.println("Failed to read file, using default configuration");

        for (uint8_t faderId = 0; faderId < NUMBER_OF_FADERS; faderId++)
        {
            faderValues[faderId] = 127;
        }
    }
    else
    {
        Serial.println("Loaded state from file");
        // read values from the document
        JsonObject faders = stateDocument[FADERS_KEY];

        JsonObject json_ap = stateDocument[AP_KEY];
        JsonObject json_client = stateDocument[CLIENT_KEY];

        
        client_ssid = json_client["ssid"].as<const char*>();
        client_password = json_client["password"].as<const char*>();
        ap_ssid = json_ap["ssid"].as<const char*>();
        ap_password = json_ap["password"].as<const char*>();

        // get number of elements in faders
        uint8_t numberOfFaders = faders.size();
        // iterate over key/value pairs in faders
        for (JsonPair fader : faders)
        {
            // get key
            String faderId = fader.key().c_str();
            // get value
            uint8_t faderValue = fader.value().as<uint8_t>();
            // set fader value
            faderValues[faderId.toInt()] = faderValue;
        }
    }

    sendTODSP();
}

bool storeFaderValues() {
    String output = "";
    size_t bytesWritten = 0;
    if (SPIFFS_is_mounted) {
        File stateFile;
        DeserializationError error;

        stateFile = SPIFFS.open(stateFileName, FILE_WRITE);
        if (!stateFile) {
            Serial.println("Failed to open file for writing");
            return false;
        }

        // serialize the document
        serializeJson(stateDocument, output);
        // write the data to the file
        bytesWritten = stateFile.print(output);
        // check if the print operation was successful
        stateFile.close();
        if (bytesWritten == 0) {
            Serial.println("Failed to write to file");
            return false;
        }
        Serial.println("state saved");
        return true;
    } else {
        return false;
    }
}

#endif // BACKEND_H
