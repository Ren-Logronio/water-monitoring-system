<?php

class Database {
    private static ?Database $instance = null;
    private static ?PDO $connection = null;

    public static function getInstance(): Database {
        if (self::$instance === null) {
            self::$instance = new self();
        }

        return self::$instance;
    }

    public static function getConnection(): PDO {
        if (self::$connection === null) {
            throw new Exception("Connection not set");
        }

        return self::$connection;
    }

    public static function setConnection($host, $database, $password): PDO {
        if (self::$connection === null) {
            self::$connection = new PDO($host, $database, $password);
        }

        return self::$connection;
    }

    /**
     * is not allowed to call from outside to prevent from creating multiple instances,
     * to use the singleton, you have to obtain the instance from Singleton::getInstance() instead
     */
    private function __construct() { }

    /**
     * prevent the instance from being cloned (which would create a second instance of it)
     */
    private function __clone() { }

    /**
     * prevent from being unserialized (which would create a second instance of it)
     */
    public function __wakeup() { throw new Exception("Cannot unserialize singleton"); }
}

?>