import { ReadlineParser, SerialPort } from "serialport";

function readArduino() {
  SerialPort.list().then((ports) => {
    const arduinoPortInfo = ports.find((port) => port.manufacturer?.toLowerCase().startsWith("arduino"));
    if (arduinoPortInfo) {
        const arduinoPort = new SerialPort({ path: arduinoPortInfo.path, baudRate: 9600 });
        const parser = arduinoPort.pipe(new ReadlineParser({ delimiter: '\r\n' }));
        parser.on("data", (data) => {
            const parsedData = JSON.parse(data);
            console.log(typeOfEachObjectKeys(parsedData));
            console.log(data);
        });
        parser.on("error", (error) => {
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
