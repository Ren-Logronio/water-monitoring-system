<?php

session_start();

require_once('includes/database.init.php');

if(parse_url($_SERVER['REQUEST_URI'], PHP_URL_QUERY) == 'logout'){
    if(isset($_SESSION['userid']) && isset($_SESSION['datetimelogged']) && $_SESSION['loggedin'] == true){
        session_destroy();
        header('Location: ./index.php');
        die();
    } else {
        header('Location: ./index.php');
    }
}

if(isset($_POST)){
    $username_email = $_POST['username-email'];
    $password = $_POST['password'];

    $sql = "SELECT * FROM users WHERE username = '$username_email' OR email = '$username_email'";
    $result = mysqli_query($conn, $sql);
    if(mysqli_num_rows($result) == 0){
        header("Location: ./index.php?loginerror");
    } else {
        $row = mysqli_fetch_assoc($result);
        $_SESSION['userid'] = $row['userid'];
        $_SESSION['loggedin'] = true;
        $_SESSION['datetimelogged'] = new DateTime();
        header('Location: ./dashboard.php');
    }
}

?>