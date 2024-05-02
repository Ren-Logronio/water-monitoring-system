// import json file
const sensorData = require('./sensor-data.json');

// import mysql module
const mysql = require('mysql');

async function runMigrate() {
    const pond_id = 1;
    const connection = await mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "0ri0nMC10!",
        database: "water-monitoring-system-db",
    }); 

    const [parameters] = await connection.query("SELECT * FROM `parameters` WHERE `pond_id` = ?", [pond_id]);
    console.log("SENSOR DATA LENGTH:", sensorData.length);
    console.log("PARAMETERS:", parameters);
};

// create connection
