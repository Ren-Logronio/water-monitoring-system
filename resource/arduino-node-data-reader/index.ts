import { ReadlineParser, SerialPort } from "serialport";
import { ReadingSchema, readingModel as ReadingModel } from "./model/readings";
import { connection } from "./lib/mongodb";
import fs from "fs";
import mongoose from "mongoose";
import axios from "axios";

mongoose.connect("mongodb://localhost:27017/water-monitoring-system-db");

function readArduino() {
  SerialPort.list().then((ports) => {
    const arduinoPortInfo = ports.find((port) => port.manufacturer?.toLowerCase().startsWith("arduino"));
    if (arduinoPortInfo) {
      const arduinoPort = new SerialPort({ path: arduinoPortInfo.path, baudRate: 9600 });
      const parser = arduinoPort.pipe(new ReadlineParser({ delimiter: '\r\n' }));
      parser.on("data", (data: any) => {
        const parsedData = JSON.parse(data);
        console.log(typeOfEachObjectKeys(parsedData));
        console.log(data);
        // axios.post("localhost:3000/api/device/reading", parsedData);
        // write to sensor.log file located at this directory
        fs.appendFile("sensor.log", `${data},\n`, (error: any) => {
          if (error) {
            console.error(error);
          }
        });
        // create new readings document
        const newReading = new ReadingModel(parsedData);
        newReading.save().then((doc: any) => {
        }).catch((error) => {
          console.error(error);
        });
      });
      parser.on("error", (error: any) => {
        console.error(error);
      });
    } else {
      console.error("Arduino not found");
      if (ports.length > 0) {
        console.log("opting for the first found port");
        const arduinoPort = new SerialPort({ path: ports[0].path, baudRate: 9600 });
        const parser = arduinoPort.pipe(new ReadlineParser({ delimiter: '\r\n' }));
        parser.on("data", (data: any) => {
          const parsedData = JSON.parse(data);
          console.log(typeOfEachObjectKeys(parsedData));
          console.log(data);
          // axios.post("localhost:3000/api/device/reading", parsedData);
          // write to sensor.log file located at this directory
          fs.appendFile("sensor.log", `${data},\n`, (error: any) => {
            if (error) {
              console.error(error);
            }
          });
          // create new readings document
          const newReading = new ReadingModel(parsedData);
          newReading.save().then((doc: any) => {
          }).catch((error) => {
            console.error(error);
          });
        });
        parser.on("error", (error: any) => {
          console.error(error);
        });
      } else {
        console.error("No other ports found...")
      }
    }
  });
}

function typeOfEachObjectKeys(obj: any) {
  return Object.keys(obj).map((key) => `${key}: ${typeof obj[key]}`);
}

readArduino();
