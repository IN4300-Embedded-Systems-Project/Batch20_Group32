// ESP 32 code for Portable Weather Station
#include <WiFi.h>
#include <FirebaseESP32.h>


const char* ssid = "";
const char* password = "";


#define FIREBASE_HOST ""  // no trailing "/"
#define FIREBASE_AUTH ""

// Create Firebase objects
FirebaseData firebaseData;
FirebaseConfig firebaseConfig;
FirebaseAuth firebaseAuth;

void setup() {
  // Start Serial Monitor
  Serial.begin(115200);

  // Initialize Serial2 for communication with Arduino Mega
  Serial2.begin(115200, SERIAL_8N1, 16, 17); // RX2 = GPIO 16, TX2 = GPIO 17

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  // Configure Firebase
  firebaseConfig.host = FIREBASE_HOST;
  firebaseConfig.signer.tokens.legacy_token = FIREBASE_AUTH;

  // Initialize Firebase
  Firebase.begin(&firebaseConfig, &firebaseAuth);
  Firebase.reconnectWiFi(true);

  //  Set database read/write timeout (in milliseconds)
  Firebase.setReadTimeout(firebaseData, 1000 * 60); // 1 minute
  Firebase.setwriteSizeLimit(firebaseData, "tiny");  // Payload size limit
}

void loop() {
  // Check if data is available from Arduino Mega
  if (Serial2.available()) {
    // Read the incoming string
    String receivedString = Serial2.readStringUntil('\n');
    receivedString.trim(); // Remove any extra whitespace

    // Split the received string into individual sensor values
    int commaIndex1 = receivedString.indexOf(',');
    int commaIndex2 = receivedString.indexOf(',', commaIndex1 + 1);
    int commaIndex3 = receivedString.indexOf(',', commaIndex2 + 1);
    int commaIndex4 = receivedString.indexOf(',', commaIndex3 + 1);

    float temperature = receivedString.substring(0, commaIndex1).toFloat();
    float humidity = receivedString.substring(commaIndex1 + 1, commaIndex2).toFloat();
    int rainDigital = receivedString.substring(commaIndex2 + 1, commaIndex3).toInt();
    int rainAnalog = receivedString.substring(commaIndex3 + 1, commaIndex4).toInt();
    float illuminance = receivedString.substring(commaIndex4 + 1).toFloat();

    // Send sensor data to Firebase
    if (Firebase.setFloat(firebaseData, "/sensor/temperature", temperature) &&
        Firebase.setFloat(firebaseData, "/sensor/humidity", humidity) &&
        Firebase.setInt(firebaseData, "/sensor/rain_digital", rainDigital) &&
        Firebase.setInt(firebaseData, "/sensor/rain_analog", rainAnalog) &&
        Firebase.setFloat(firebaseData, "/sensor/illuminance", illuminance)) {
      Serial.println("Sensor data sent to Firebase successfully!");
    } else {
      Serial.println("Error: " + firebaseData.errorReason());
    }
  }
}