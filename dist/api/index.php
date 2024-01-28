<?php
    require_once __DIR__ . "/App/router.php";

    $router = Router::getInstance();

    echo json_encode($router->getRoutes());

    echo "API CALLED";
?>