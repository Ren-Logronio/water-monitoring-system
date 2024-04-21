// Define pin numbers for sensors
#define deviceId "6342b0b7-2448-4951-b5d3-70027891f467"

const int ammoniaSensorPin = A0; // Analog pin for ammonia sensor
const int temperatureSensorPin = A1; // Analog pin for temperature sensor
const int tdsSensorPin = A2; // Analog pin for TDS sensor
const int pHsensorPin = A3; // Analog pin for pH sensor

// Define variables to store sensor readings
float ammoniaLevel = 0.0;
float temperature = 0.0;
float tdsValue = 0.0;
float pHValue = 0.0;

void setup() {
  Serial.begin(9600); // Initialize serial communication
}

void loop() {
  // Read sensor data
  ammoniaLevel = analogRead(ammoniaSensorPin);
  temperature = analogRead(temperatureSensorPin);
  tdsValue = analogRead(tdsSensorPin);
  pHValue = analogRead(pHsensorPin);

  // Convert sensor readings to appropriate units
  // Assuming linear conversion, adjust according to sensor specifications
  ammoniaLevel = map(ammoniaLevel, 0, 1023, 0, 10000); // Convert to ppm
  temperature = map(temperature, 0, 1023, -50, 150); // Convert to Celsius
  tdsValue = map(tdsValue, 0, 1023, 0, 5000); // Convert to ppm
  pHValue = map(pHValue, 0, 1023, 0, 14); // Convert to pH scale

  // Print sensor readings to serial monitor
  Serial.print("{");
  Serial.print('\"');
  Serial.print("deviceId");
  Serial.print('\"');
  Serial.print(": ");
  Serial.print('\"');
  Serial.print(deviceId);
  Serial.print('\"');

  Serial.print(", ");
  Serial.print('\"');
  Serial.print("ammonia");
  Serial.print('\"');
  Serial.print(": ");
  Serial.print(ammoniaLevel);

  Serial.print(", ");
  Serial.print('\"');
  Serial.print("temperature");
  Serial.print('\"');
  Serial.print(": ");
  Serial.print(temperature);

  
  Serial.print(", ");
  Serial.print('\"');
  Serial.print("tds");
  Serial.print('\"');
  Serial.print(": ");
  Serial.print(tdsValue);

  Serial.print(", ");
  Serial.print('\"');
  Serial.print("pH");
  Serial.print('\"');
  Serial.print(": ");
  Serial.print(pHValue);
  Serial.println("}");

  // Add delays if needed to prevent spamming the serial monitor
  delay(60000); // Adjust delay according to your requirements
}
