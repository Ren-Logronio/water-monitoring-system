<?php

function log($var) {
    error_log(print_r($var, TRUE)); 
}

?>