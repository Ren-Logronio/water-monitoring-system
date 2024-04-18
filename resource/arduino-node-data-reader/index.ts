import { ReadlineParser, SerialPort } from "serialport";
import { ReadingSchema, readingModel } from "./model/readings";
import fs from "fs";

function readArduino() {
  SerialPort.list().then((ports: any) => {
    	ports.forEach((port: any) => {console.log("COM Port:", port)});
	const arduinoPortInfo = ports.find((port: any) => port.manufacturer?.toLowerCase().startsWith("arduino"));
    if (arduinoPortInfo) {
      const arduinoPort = new SerialPort({ path: arduinoPortInfo.path, baudRate: 9600 });
      const parser = arduinoPort.pipe(new ReadlineParser({ delimiter: '\r\n' }));
      parser.on("data", (data: any) => {
        const parsedData = JSON.parse(data);
        console.log(typeOfEachObjectKeys(parsedData));
        console.log(data);
        // write to sensor.log file located at this directory
        fs.appendFile("sensor.log", `${data},\n`, (error) => {
          if (error) {
            console.error(error);
          }
        });
        // create new readings document
        const newReading = new readingModel({
          deviceId: parsedData.deviceId,
          temperature: parsedData.temperature,
          tds: parsedData.tds,
          ph: parsedData.ph,
          ammonia: parsedData.ammonia,
        });
        newReading.save().then((doc) => {
          console.log("saved to db");
        }).catch((error) => {
          console.error(error);
        });
      });
      parser.on("error", (error: any) => {
        console.error(error);
      });
    } else {
      console.error("Arduino not found");
    }
  });
}

function typeOfEachObjectKeys(obj: any) {
  return Object.keys(obj).map((key) => `${key}: ${typeof obj[key]}`);
}

readArduino();
