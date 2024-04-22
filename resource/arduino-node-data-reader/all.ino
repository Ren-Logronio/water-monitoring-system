
// Define pin numbers for sensors
#define deviceId "6342b0b7-2448-4951-b5d3-70027891f467"

const int ammoniaSensorPin = A3; // Analog pin for ammonia sensor
const int temperatureSensorPin = A0; // Analog pin for temperature sensor
const int tdsSensorPin = A1; // Analog pin for TDS sensor
const int pHsensorPin = A2; // Analog pin for pH sensor

void setup() {
  Serial.begin(9600); // Initialize serial communication
}

void loop() {
  // Read sensor data
  float ammoniaLevel = analogRead(ammoniaSensorPin);
  float temperature = analogRead(temperatureSensorPin);
  float tdsValue = analogRead(tdsSensorPin);
  float pHVoltage = analogRead(pHsensorPin) * (5.0 / 1023.0/4); // Convert to voltage

  // Convert sensor readings to appropriate units
  // Assuming linear conversion, adjust according to sensor specifications
  ammoniaLevel = map(ammoniaLevel, 0, 1023, 5, 50); // Convert to ppm
  temperature = map(temperature, 0, 1023, 0, 150); // Convert to Celsius
  tdsValue = map(tdsValue, 0, 1023, 0, 1000); // Convert to ppm
  float pHValue = convertToPH(pHVoltage); // Convert analog voltage to pH

  // Print sensor readings to serial monitor
  Serial.print("{");
  Serial.print('\"');
  Serial.print("device_id");
  Serial.print('\"');
  Serial.print(": ");
  Serial.print('\"');
  Serial.print(deviceId);
  Serial.print('\"');

  Serial.print(", ");
  Serial.print('\"');
  Serial.print("AMN");
  Serial.print('\"');
  Serial.print(": ");
  Serial.print(ammoniaLevel);

  Serial.print(", ");
  Serial.print('\"');
  Serial.print("TMP");
  Serial.print('\"');
  Serial.print(": ");
  Serial.print(temperature);

  
  Serial.print(", ");
  Serial.print('\"');
  Serial.print("TDS");
  Serial.print('\"');
  Serial.print(": ");
  Serial.print(tdsValue);

  Serial.print(", ");
  Serial.print('\"');
  Serial.print("PH");
  Serial.print('\"');
  Serial.print(": ");
  Serial.print(pHValue);
  Serial.println("}");

  // Add delays if needed to prevent spamming the serial monitor
  delay(10000); // Adjust delay according to your requirements
}

float convertToPH(float voltage) {
  // Example conversion formula, replace with actual formula from datasheet
  return voltage * 7.0; // Hypothetical formula, replace with actual formula
}
