<?php
include_once 'connection.php';
class Save
{
    public function saveClient()
    {
        if (isset($_POST)) {
            $msg = array();
            $msg["state"] = "";
            $msg["content"] = "";
            $uuid  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['uuid']));
            $nom  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['nom']));
            $postnom  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['postnom']));
            $prenom  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['prenom']));
            $phone = trim(mysqli_real_escape_string(Constants::connect(), $_POST['tel']));
            $address = trim(mysqli_real_escape_string(Constants::connect(), $_POST['adresse']));
            if (!isset($uuid)) {
                $uuid = rand(10000, 1000000) . date('YmdHis');
            }
            if ($nom == '' || $postnom == "" || $phone == "") {
                $msg["state"] = "error";
                $msg["content"] = "Donnees invalides";
            } else {
                try {
                    $req = "INSERT INTO `clients` (`nom`,`postnom`, `prenom`, `tel`,  `adresse`, `uuid` ) 
                    VALUES('$nom','$postnom','$prenom','$phone', '$address', '$uuid')";
                    $res = mysqli_query(Constants::connect(), $req);
                    if ($res) {
                        $msg["state"] = "success";
                        $msg["content"] = "Client enregistré avec succès";
                    } else {
                        $msg["state"] = "error";
                        $msg["content"] = 'Une erreur est survenue';
                    }
                } catch (Exception $e) {
                    $msg["state"] = "error";
                    $msg["content"] = "Erreur survenue lors de l'enregistrement";
                }
            }

            mysqli_close(Constants::connect());
        } else {
            $msg["state"] = "error";
            $msg["content"] = "Data not received";
        }
        echo json_encode($msg);
    }

    public function saveTracking()
    {
        if (isset($_POST)) {
            $msg = array();
            $msg["state"] = "";
            $msg["content"] = "";
            $uuid  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['uuid']));
            $mouv_uuid  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['mouv_uuid']));
            $source_depot_id  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['source_depot_id']));
            $dest_depot_id  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['dest_depot_id']));
            $label  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['label']));
            $senderID = trim(mysqli_real_escape_string(Constants::connect(), $_POST['user_id']));
            if (!isset($uuid) || empty($uuid)) {
                $uuid = rand(10000, 1000000) . date('YmdHis');
            }
            if (!isset($label) || empty($label)) {
                $label = empty($dest_depot_id) ? 'Reception' : 'Envoi';
            }
            if ($mouv_uuid == '' || $senderID == "" || $uuid == "" || $source_depot_id == ''  || $dest_depot_id == '') {
                $msg["state"] = "error";
                $msg["content"] = "Donnees invalides";
            } else {
                try {
                    $req = "INSERT INTO `mouvement_tracking` (`uuid`, `mouv_uuid`, `user_id`, `source_depot_id`, `dest_depot_id`, `label`) VALUES ('$uuid', '$mouv_uuid',  '$senderID','$source_depot_id', '$dest_depot_id', '$label') ";
                    $res = mysqli_query(Constants::connect(), $req);
                    if ($res) {
                        $msg["state"] = "success";
                        $msg["content"] = "Donnée enregistrée avec succès";
                    } else {
                        $msg["state"] = "error";
                        $msg["content"] = 'Une erreur est survenue';
                    }
                } catch (Exception $e) {
                    $msg["state"] = "error";
                    $msg["content"] = "Erreur survenue lors de l'enregistrement";
                }
            }

            mysqli_close(Constants::connect());
        } else {
            $msg["state"] = "error";
            $msg["content"] = "Data not received";
        }
        echo json_encode($msg);
    }

    public function saveMouvement()
    {
        if (isset($_POST)) {
            $msg = array();
            $msg["state"] = "";
            $msg["content"] = "";
            $uuid  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['uuid']));
            $type_mvt  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['type_mvt']));
            $senderID  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['senderID']));
            // $receiverID  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['receiverID']));
            $ref_depot  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['ref_depot']));
            $ref_user  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['ref_user']));
            $ref_mouv_entry  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['ref_mouv_entry']));
            $destination  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['destination']));
            $receiver_name  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['receiver_name']));
            $receiver_phone  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['receiver_phone'])) ?? '';
            $sender_name  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['senderName']));
            $sender_phone  = trim(mysqli_real_escape_string(Constants::connect(), $_POST['senderTel'])) ?? '';
            $ref_mouv_entry = !isset($ref_mouv_entry) ? null : $ref_mouv_entry;

            $detailsMvt = json_decode($_POST['detailsMouvement']); // trim(mysqli_real_escape_string(Constants::connect(), $_POST['surface_ch']));
            if (!isset($uuid)) {
                $uuid = rand(10000, 1000000) . date('YmdHis');
            }
            $trackUUID = rand(100000, 1000000) . date('YmdHis');
            if ($detailsMvt == '' || $sender_name == "" || $receiver_name == "") {
                $msg["state"] = "error";
                $msg["content"] = "Donnees invalides";
            } else {
                try {
                    // if (isset($image)) {
                    //     $realImage = base64_decode($image);
                    //     file_put_contents($uuid . '.png', $realImage);
                    // }
                    $req = "INSERT INTO `mouvement` (`uuid`, `type_mvt`,`senderID`, `ref_depot`, `ref_mouv_entry`, `ref_user`, `destination`,`receiver_name`,`receiver_phone`,`sender_name`,`sender_phone`) VALUES ('$uuid', '$type_mvt', '$senderID', '$ref_depot', '$ref_mouv_entry', '$ref_user', '$destination', '$receiver_name', '$receiver_phone', '$sender_name', '$sender_phone')";
                    $res = mysqli_query(Constants::connect(), $req);
                    $reqTrack = "INSERT INTO `mouvement_tracking` (`uuid`, `mouv_uuid`,`user_id`, `source_depot_id`,`dest_depot_id`,`label`) VALUES ('$trackUUID', '$uuid', '$ref_user', '$ref_depot', '$destination', 'Colis reçu')";
                    mysqli_query(Constants::connect(), $reqTrack);
                    if ($res) {
                        for ($i = 0; $i < count($detailsMvt); $i++) {
                            $product = $detailsMvt[$i]->product;
                            $weights = $detailsMvt[$i]->kg;
                            $priceID = $detailsMvt[$i]->prix_kg;
                            $storage = $detailsMvt[$i]->entreposage;
                            $totalPrice = $detailsMvt[$i]->total_kg;
                            $decoteHumidite = $detailsMvt[$i]->decote_humidite;
                            $kg_sac = $detailsMvt[$i]->kg_sac;
                            $prix_net = $detailsMvt[$i]->prix_net;
                            $total_kg_net = $detailsMvt[$i]->total_kg_net;
                            $detailsUUID = $detailsMvt[$i]->uuid ? $detailsMvt[$i]->uuid : rand(10000, 1000000) . date('YmdHis') . $i;
                            $detQuery = "INSERT INTO `detail_mvt` (`uuid`, `mouvement_uuid`, `product`, `kg`, `entreposage`, `prix_kg`, `total_kg`, `status_pay`, `decote_humidite`, `kg_sac`, `prix_net`, `total_kg_net`) VALUES ('$detailsUUID', '$uuid', '$product', '$weights', '$storage', '$priceID', '$totalPrice', 'Pending', '$decoteHumidite', '$kg_sac', '$prix_net', '$total_kg_net' )";
                            $detailsRes = mysqli_query(Constants::connect(), $detQuery);
                        }
                        $msg["state"] = "success";
                        $msg["content"] = "Donnée enregistrée avec succès";
                    } else {
                        $msg["state"] = "error";
                        $msg["content"] = 'Une erreur est survenue';
                    }
                } catch (Exception $e) {
                    $msg["state"] = "Error";
                    $msg["content"] = "Erreur survenue lors de l'enregistrement";
                }
            }

            mysqli_close(Constants::connect());
        } else {
            $msg["state"] = "error";
            $msg["content"] = "Data not received";
        }
        echo json_encode($msg);
    }
}
$saveInstance = new Save();
// var_dump($_POST);
if (strtolower($_POST['transaction']) == "cultivator") {
    $saveInstance->saveClient();
} else if (strtolower($_POST['transaction']) == "tracking") {
    $saveInstance->saveTracking();
} else if (strtolower($_POST['transaction']) == "mouvement") {
    $saveInstance->saveMouvement();
}
// echo (json_encode("received"));
