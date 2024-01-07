<?php
include_once 'connection.php';
if ($_POST['transaction'] == 'fields') {
    $sql = "SELECT * FROM champ";

    if (Constants::connect() != null) {
        $result = Constants::connect()->query($sql);
        // var_dump($result);

        if (!empty($result) && $result->num_rows > 0) {
            $array = array();
            while ($row = $result->fetch_assoc()) {
                $ownerID = $row['senderID'];
                $getOwner = "SELECT * FROM clients WHERE id='$ownerID' OR uuid='$ownerID'";
                $ownerResult = Constants::connect()->query($getOwner);
                while ($rowOwner = $ownerResult->fetch_assoc()) {
                    array_push($array, [
                        ...$row,
                        "owner" => $rowOwner
                    ]);
                }
            }
            echo (json_encode($array));
        } else {
            echo (json_encode("No data found"));
        }
    } else {
        echo (json_encode("Cannot connect to Database Server"));
    }
}

if ($_POST['transaction'] == 'getmouvement') {
    $mainData = array();

    if (Constants::connect() != null) {
        $userID  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['userID']));
        $query = "SELECT mouvement.*, depot.designation storeName FROM `mouvement` LEFT JOIN depot ON depot.id=mouvement.ref_depot WHERE mouvement.ref_user='$userID'";
        // print_r($query);
        $result = Constants::connect()->query($query);
        while ($row = $result->fetch_assoc()) {
            $details = array();
            $sender = array();
            $outStockData = array();
            $tracking = array();
            $id = $row['uuid'];
            $senderID = $row['senderID'];
            // $receiverID = $row['receiverID'];
            $outStockUUID = $row['ref_mouv_entry'];
            $detQuery = "SELECT * from `detail_mvt` where mouvement_uuid='$id'";
            $detResult = Constants::connect()->query($detQuery);
            while ($detailRow = $detResult->fetch_assoc()) {
                array_push($details, $detailRow);
            }

            // Getting sender data
            $senderQuery = "SELECT * from `clients` where uuid='$senderID'";
            $senderResult = Constants::connect()->query($senderQuery);
            while ($detailRow = $senderResult->fetch_assoc()) {
                array_push($sender, $detailRow);
            }

            // Getting receiver data
            $trackQuery = "SELECT * from `mouvement_tracking` where mouv_uuid='$id'";
            $trackResult = Constants::connect()->query($trackQuery);
            while ($detailRow = $trackResult->fetch_assoc()) {
                array_push($tracking, $detailRow);
            }

            // $outStock = "SELECT mouvement.*, depot.designation storeName FROM `mouvement` LEFT JOIN depot ON depot.id=mouvement.ref_depot WHERE mouvement.uuid='$outStockUUID'";
            // $outResult = Constants::connect()->query($outStock);
            // // print_r(json_encode($subQuery));
            // while ($outRow = $outResult->fetch_assoc()) {
            //     // print_r(json_encode($subRow));
            //     array_push($outStockData, $outRow);
            // }
            array_push($mainData, [
                ...$row,
                'senderName' => $row['sender_name'],
                'senderTel' => $row['sender_phone'],

                'sender' => $sender[0] ?? null,
                'outStock' => $outStockData,
                'detailsMouvement' => $details,
                'tracking' => $tracking,
            ]);
        }
        echo (json_encode($mainData));
    } else {
        echo (json_encode("Cannot connect to Database Server"));
    }
}

if ($_POST['transaction'] == 'searchmouvement') {
    $mainData = array();

    if (Constants::connect() != null) {
        $colisID  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['colisID']));
        $query = "SELECT mouvement.*, depot.designation storeName FROM `mouvement` LEFT JOIN depot ON depot.id=mouvement.ref_depot WHERE mouvement.uuid='$colisID'";
        // print_r($query);
        $result = Constants::connect()->query($query);
        while ($row = $result->fetch_assoc()) {
            $details = array();
            $sender = array();
            $outStockData = array();
            $tracking = array();
            $id = $row['uuid'];
            $senderID = $row['senderID'];
            $receiverID = $row['receiverID'];
            $outStockUUID = $row['ref_mouv_entry'];
            $detQuery = "SELECT * from `detail_mvt` where mouvement_uuid='$id'";
            $detResult = Constants::connect()->query($detQuery);
            while ($detailRow = $detResult->fetch_assoc()) {
                array_push($details, $detailRow);
            }

            // Getting sender data
            $senderQuery = "SELECT * from `clients` where uuid='$senderID'";
            $senderResult = Constants::connect()->query($senderQuery);
            while ($detailRow = $senderResult->fetch_assoc()) {
                array_push($sender, $detailRow);
            }

            // Getting receiver data
            $trackQuery = "SELECT mouvement_tracking.*, depot.designation storeName, depot.adresse_depot storeAddress, destStore.designation destStoreName, destStore.adresse_depot destStoreAddress  from `mouvement_tracking` LEFT JOIN depot ON depot.id=mouvement_tracking.source_depot_id  LEFT JOIN depot destStore ON destStore.id=mouvement_tracking.dest_depot_id where mouv_uuid='$id'";
            $trackResult = Constants::connect()->query($trackQuery);
            while ($detailRow = $trackResult->fetch_assoc()) {
                array_push($tracking, $detailRow);
            }
            array_push($mainData, [
                ...$row,
                'senderName' => $row['sender_name'],
                'senderTel' => $row['sender_phone'],

                'sender' => $sender[0] ?? null,
                'outStock' => $outStockData,
                'detailsMouvement' => $details,
                'tracking' => $tracking,
            ]);
        }
        echo (json_encode($mainData));
    } else {
        echo (json_encode("Cannot connect to Database Server"));
    }
}
