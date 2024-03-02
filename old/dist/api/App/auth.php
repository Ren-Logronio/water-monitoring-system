<?php

session_start();

require_once __DIR__ . "/database.php";

class phpAuth {

    private static $instance = null;

    public static function getInstance(): phpAuth {
        if (self::$instance === null) {
            self::$instance = new self();
        }

        return self::$instance;
    }

    public function login($email, $password) {
        $connection = Database::getConnection();

        $query = $connection->prepare("SELECT * FROM users WHERE email = :email");
        $query->bindParam(":email", $email);
        $query->execute();

        $result = $query->fetch(PDO::FETCH_ASSOC);

        if ($result === false) {
            return false;
        }

        if (password_verify($password, $result["password"])) {
            $_SESSION["userid"] = $result["userid"];
            $_SESSION["time_logged_in"] = date("Y-m-d h:i:sa");
            return true;
        }

        return false;
    }
}

?>
