<?php

require 'database.class.php';

$DATABASE_USERNAME = 'root';
$DATABASE_PASSWORD = 'pass123';
$DATABASE_HOST = 'localhost';
$DATABASE_NAME = 'water-monitoring-system-db';
$DATABASE_CHARSET = 'utf8';

$database = new db($DATABASE_HOST, $DATABASE_USERNAME, $DATABASE_PASSWORD, $DATABASE_NAME, $DATABASE_CHARSET);

?>