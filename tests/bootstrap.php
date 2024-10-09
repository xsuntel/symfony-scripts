<?php

use Symfony\Component\Dotenv\Dotenv;

require dirname(__DIR__).'/app/vendor/autoload.php';

if (file_exists(dirname(__DIR__).'/app/config/bootstrap.php')) {
    require dirname(__DIR__).'/app/config/bootstrap.php';
} elseif (method_exists(Dotenv::class, 'bootEnv')) {
    (new Dotenv())->bootEnv(dirname(__DIR__).'/app/.env');
}
