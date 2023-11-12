
class Sensor {
    constructor(type) {
        this.sensordata = [];
        this.type = type;
    }

    addData(data) {
        var data;
        var sensordata = new SensorData();
        this.sensordata.push(sensordata.generateSensorData(this, data)).then(
            (d) => { 
                console.log(data);
                data = d;
            }
        );
        return data;
    }
}

class SensorData {
    constructor(sensor, datetime, value) {
        this.sensor = sensor;
        this.datetime = datetime;
        this.value = value;
    }

    generateSensorData(sensor, value) {
        return new SensorData(sensor, (new Date()).toISOString, value);
    }

    generateSensorData(sensor, value, precision) {
        return new SensorData(sensor, (new Date()).toISOString, value.toFixed(precision));
    }

    generateSensorData(sensor, datetime, value) {
        return new SensorData(sensor, datetime.toISOString, value);
    }

    generateSensorData(sensor, datetime, value, precision) {
        return new SensorData(sensor, datetime.toISOString, value.toFixed(precision));
    }
}