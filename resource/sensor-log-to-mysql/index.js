// import json file
const sensorData = require('./water-monitoring-system-db.sensor-logs.json');

// import mysql module
const mysql = require('mysql2/promise');

// import moment module
const moment = require('moment-timezone');

async function runMigrate() {
    const pond_id = 36;
    const connection = await mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "0ri0nMC10!",
        database: "water-monitoring-system-db",
    });

    const [parameters] = await connection.query("SELECT * FROM `parameters` WHERE `pond_id` = ?", [pond_id]);

    sensorData.forEach((data, index) => {
        //if (index > 0) return;
        ["PH", "AMN", "TDS", "TMP"].forEach(async (param) => {
            const parameter_id = parameters.find(p => p.parameter === param).parameter_id;
            await connection.query(
                "INSERT INTO `readings` (`parameter_id`, `value`, `recorded_at`) VALUES (?, ?, ?)",
                [parameter_id, data[param], moment.tz(data.recordedAt.$date, "Asia/Manila").toDate()]
            );
        })
        console.log("Data Keys:", Object.keys(data));
        console.log("Recorded at:", moment.tz(data.recordedAt.$date, "Asia/Manila").toDate());
    });
    console.log("SENSOR DATA LENGTH:", sensorData.length);
    console.log("PARAMETERS:", parameters);
};

runMigrate();

// create connection
