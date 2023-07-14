#ifndef BACKEND_H
#define BACKEND_H
#endif // BACKEND_H

const uint8_t NUMBER_OF_FADERS = 36;
const char *stateFileName = "/state.json";
StaticJsonDocument<2048> stateDocument;

uint8_t faderValues[NUMBER_OF_FADERS];

char *client_ssid = "your_kungfu_iz_good";
char *client_password = "plsl0gIN";

char *ap_ssid = "MatrixMixAP";
char *ap_password = "12345678";

bool SPIFFS_is_mounted = false;


void sendTODSP()
{
    Serial.println("sending to DSP: ");
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
        JsonObject faders = stateDocument["faders"];
        Serial.println(faders["0"].as<uint8_t>());

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


