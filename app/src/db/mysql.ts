import mysql from 'mysql2/promise';

export default async function getMySQLConnection() {
    return await mysql.createConnection({
        host: process.env.MYSQL_DB_HOST,
        user: process.env.MYSQL_DB_USER,
        password: process.env.MYSQL_DB_PASSWORD,
        database: process.env.MYSQL_DB_NAME,
    });
} 