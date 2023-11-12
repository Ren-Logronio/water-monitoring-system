#include <OneWire.h>
#include <DallasTemperature.h>

OneWire oneWire(2);
DallasTemperature sensors(&oneWire);

const int mq137SensorPin = A0; // Analog pin for the MQ-137 sensor
const int pHSensorPin = A1;  // Analog pin for the pH sensor
const int ds18b20Pin = 2;   // Digital pin for the DS18B20 sensor
const String deviceID = "3b26008c-ac0b-576d-9d0c-2cda7dc0fb3d"; // Device ID for the sensor
const String deviceName = "TestingDevice"; 

void setup() {
  Serial.begin(9600);
  pinMode(mq137SensorPin, INPUT);
  pinMode(pHSensorPin, INPUT);

  sensors.begin(); // Initialize the temperature sensor
}

void loop() {
  // Read MQ-137 sensor
  int mq137Value = analogRead(mq137SensorPin);

  // Convert the analog value to a voltage
  float voltage = (mq137Value / 1024.0) * 3.0;
  // Convert the voltage to a relative gas concentration
  // This conversion may vary depending on the calibration of your specific sensor
  float gasConcentration = map(mq137Value, 0, 1023, 0, 100); // Adjust the mapping based on your sensor's characteristics
  // Read pH sensor
  int pHValue = analogRead(pHSensorPin);
  // Read temperature
  sensors.requestTemperatures();
  float temperatureC = sensors.getTempCByIndex(0);
  // pH compensation based on temperature
  float temperatureCompensationCoefficient = 0.012; // Adjust this coefficient based on your sensor's specifications
  float compensationFactor = 1.0 + temperatureCompensationCoefficient * (temperatureC - 25.0);
  float compensatedpH = map(pHValue, 0, 1023, 4, 10) * compensationFactor; // Map the pH value to the pH scale (0-14)

  /*
  // Print the relative gas concentration
  Serial.print("Gas Concentration: ");
  Serial.print(gasConcentration);
  Serial.println(" ppm");
  // Print the pH and temperature values
  Serial.print("pH Level: ");
  Serial.println(compensatedpH, 2); // Print pH with 2 decimal places
  Serial.print("Temperature (C): ");
  Serial.println(temperatureC, 2); // Print temperature with 2 decimal places
  */

  // Serial.print to format {'deviceid': 'deviceId', 'name': 'deviceName', 'ammonia': 'gasConcentration', 'ph': 'compensatedpH', 'temperature': 'temperatureC'}
  Serial.print("{'deviceid': '");
  Serial.print(deviceID);
  Serial.print("', 'name': '");
  Serial.print(deviceName);
  Serial.print("', 'ammonia': '");
  Serial.print(gasConcentration);
  Serial.print("', 'ph': '");
  Serial.print(compensatedpH, 2);
  Serial.print("', 'temperature': '");
  Serial.print(temperatureC, 2);
  Serial.print("'}\n");


  delay(1000); // Delay for 1 second between readings
}
