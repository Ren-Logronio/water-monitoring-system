const mysql = require('mysql2/promise');

const runTest = async () => {
    const connection = await mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: "0ri0nMC10!",
        database: "water-monitoring-system-db",
    });

    const [results, fields] = await connection.query('SELECT * FROM `users`');

    console.log({results, fields});
}

runTest();