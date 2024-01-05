<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header("Access-Control-Allow-Headers: X-Requested-With");
include './config.php';
class Constants
{
    static $DB_HOST = DB_HOST;
    static $DB_USER = DB_USER;
    static $DB_PASS = DB_PASS;
    static $DB_NAME = DB_NAME;
    static $DB_PORT = DB_PORT;

    public static function connect()
    {
        // echo (Constants::$DB_HOST.",".Constants::$DB_USER.",".Constants::$DB_PASS.",".Constants::$DB_NAME);
        // $con = new mysqli(Constants::$DB_HOST,Constants::$DB_USER,Constants::$DB_PASS,Constants::$DB_NAME, 8889) or die("Unable to connect to the database");
        $con = new mysqli('127.0.0.1', 'root', '', 'entrepot', 3306);
        // echo $con;
        if ($con->connect_error) {
            // echo $con->connect_error;
            return null;
        } else {
            // echo "connected";
            return $con;
        }
    }
}
