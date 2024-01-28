<?php
    require_once __DIR__ . "/router.php";

    $router = Router::getInstance();

    $router->addRoute(array(
        "method" => "GET",
        "path" => "/api/test",
        "callback" => "test"
    ));

    $router->addRoute(array(
        "method" => "GET",
        "path" => "/api/test2",
        "callback" => "test2"
    ));

    echo json_encode($router->getRoutes());

    echo "API CALLED";
?>