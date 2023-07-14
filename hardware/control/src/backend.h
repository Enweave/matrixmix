#ifndef BACKEND_H
#define BACKEND_H
#endif // BACKEND_H

const uint8_t NUMBER_OF_FADERS = 36;
uint8_t faderValues[NUMBER_OF_FADERS];
const char *stateFileName = "/state.json";

const char *client_ssid = "your_kungfu_iz_good";
const char *client_password = "plsl0gIN";

const char *ap_ssid = "MatrixMixAP";
const char *ap_password = "12345678";

void loadFaderValues()
{
    StaticJsonDocument<2048> stateDocument;
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
        JsonObject faders = stateDocument["faders"];
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

    
}

void sendTODSP()
{
    for (uint8_t faderId = 0; faderId < NUMBER_OF_FADERS; faderId++)
    {
        Serial.print("Fader ");
        Serial.print(faderId);
        Serial.print(": ");
        Serial.println(faderValues[faderId]);
    }
}