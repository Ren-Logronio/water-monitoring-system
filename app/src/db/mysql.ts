import mysql from "mysql2/promise";

let connection: any; 

export default async function getMySQLConnection(): Promise<mysql.Connection> {
  if(!connection) { 
    connection = await mysql.createConnection({
      host: process.env.MYSQL_DB_HOST,
      user: process.env.MYSQL_DB_USER,
      password: process.env.MYSQL_DB_PASSWORD,
      database: process.env.MYSQL_DB_NAME,
    }); 
  }
  return connection;
}
