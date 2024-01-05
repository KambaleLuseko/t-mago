<?php
include_once 'connection.php';
class SelectAll
{

    public function select($query)
    {
        if (Constants::connect() != null) {
            $result = Constants::connect()->query($query);
            if (!empty($result) && $result->num_rows > 0) {
                $array = array();
                while ($row = $result->fetch_assoc()) {
                    array_push($array, $row);
                }
                print(json_encode($array));
            } else {
                print(json_encode("No data found"));
            }
        } else {
            print(json_encode("Cannot connect to Database Server"));
        }
    }
}
$sql = '';
// print_r($_POST);
if (!isset($_POST['transaction'])) {
    return print(json_encode("No route found"));
}
if (strtolower($_POST['transaction']) == 'cultivator') {
    // $plaque = trim(htmlspecialchars($_POST['plaque']));
    $sql = "SELECT * from clients";
    // print($sql);
} else if (strtolower($_POST['transaction']) == 'field') {
    // $plaque = trim(htmlspecialchars($_POST['plaque']));
    $sql = "SELECT * from champ";
    // print($sql);
} else if (strtolower($_POST['transaction']) == 'stores') {
    // $plaque = trim(htmlspecialchars($_POST['plaque']));
    $sql = "SELECT * from depot";
    // print($sql);
} else if (strtolower($_POST['transaction']) == 'prices') {
    // $plaque = trim(htmlspecialchars($_POST['plaque']));
    $sql = "SELECT * from prices";
    // print($sql);
} else if (strtolower($_POST['transaction']) == 'stats') {
    $date = trim(htmlspecialchars($_POST['value']));
    $month = date("Y-m-d", strtotime("-30 days", strtotime(date("Y-m-d"))));
    // $week=date("Y-m-d", strtotime("-30 days", strtotime(date("Y-m-d"))));
    $sql = "SELECT (SELECT COUNT(*) FROM clients) as total, DATE(created_at) created_at, COUNT(*) as stats FROM clients WHERE DATE(created_at)  <= '$date' AND DATE(created_at)>='$month' GROUP BY DATE(created_at)";
    // $sql = "SELECT (SELECT COUNT(*) FROM clients WHERE created_at  LIKE '$date%') as today";
    // print($sql);
} else if (strtolower($_POST['transaction']) == 'humidite') {
    $sql = "SELECT * FROM humidites_table";
} else if (strtolower($_POST['transaction']) == 'login') {
    $username = trim(htmlspecialchars($_POST['username']));
    $password = trim(htmlspecialchars($_POST['password']));
    $sql = "SELECT * FROM pos WHERE (`username`='$username' OR `tel_user`='$username') AND `password`='$password'";
} else {
    return print(json_encode("No route found"));
}
$zakuuza = new SelectAll();
$zakuuza->select($sql);
