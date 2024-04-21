import { ReadlineParser, SerialPort } from "serialport";
import { ReadingSchema, readingModel } from "./model/readings";
import fs from "fs";
import mongoose from "mongoose";

mongoose.connect("mongodb+srv://Ren-logronio:QJcy2TU1Udi9z9oN@cluster0.46h8obk.mongodb.net/water-monitoring-system-db");

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
        fs.appendFile("sensor.log", `${data},\n`, (error: any) => {
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
        newReading.save().then((doc: any) => {
          console.log("saved to db");
        }).catch((error: any) => {
          console.error(error);
        });
      });
      parser.on("error", (error: any) => {
        console.error(error);
      });
    } else {
      console.error("Arduino not found");
      if (ports.length > 0) {
        console.log("Opting for the first found port...");
        const arduinoPort = new SerialPort({ path: ports[0].path, baudRate: 9600 });
        const parser = arduinoPort.pipe(new ReadlineParser({ delimiter: '\r\n' }));
      parser.on("data", (data: any) => {
        const parsedData = JSON.parse(data);
        console.log(typeOfEachObjectKeys(parsedData));
        console.log(data);
        // write to sensor.log file located at this directory
        fs.appendFile("sensor.log", `${data},\n`, (error: any) => {
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
        newReading.save().then((doc: any) => {
          console.log("saved to db");
        }).catch((error: any) => {
          console.error(error);
        });
      });
      parser.on("error", (error: any) => {
        console.error(error);
      });
      } else {
        console.error("No ports found");
      }
    }
  });
};

function typeOfEachObjectKeys(obj: any) {
  return Object.keys(obj).map((key) => `${key}: ${typeof obj[key]}`);
};

readArduino();
