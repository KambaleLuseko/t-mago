<?php
	include_once 'connection.php';
	if ($_POST['transaction'] == 'history_transact') {
	    $userID=trim(htmlspecialchars($_POST['userID']));
	    echo $userID;
	    $sql = "SELECT tbCommande.id as cmdID, dateCmd, statut, addr.nom addrNom, addr.prenom addrPrenom, addr.paysResidence addrPays, addr.villeResidence addrVille, addr.email addrEmail, addr.telephone addrPhone FROM tbCommande left JOIN tbCmdAddress addr on addr.id_cmd=tbCommande.id WHERE tbCommande.refClient='$userID' order by tbCommande.dateCmd desc";
	    if(Constants::connect() != null){
	    	$result = Constants::connect()->query($sql);
	    	if (!empty($result) && $result->num_rows > 0) {
                $data=array();
                $tracking=array();
                $array = array();
	    		while ($row=$result->fetch_assoc()) {
                    $cmdID=$row['cmdID'];
                    echo $cmdID;
                    $sql = "SELECT tbDetailCommande.id dtlCmdId, tbProduit.id,tbAgence.smartpayID, tbProduit.designation productName, tbProduit.description detailArticle, tbProduit.longueur, tbProduit.longueurEmba, tbProduit.largeur, tbProduit.largeurEmba, tbProduit.hauteur, tbProduit.hauteurEmba,tbProduit.poids, tbImage.image img, tbCategorie.nomCategorie, tbAgence.nom, tbAgence.contact, tbAgence.email, tbAgence.logoAgence, (SELECt count(*) FROM tbDetailCommande where refProduit=tbProduit.id) cmdes, montant, tbDetailCommande.quantite FROM tbDetailCommande inner join tbProduit on tbProduit.id=tbDetailCommande.refProduit inner join tbCategorie on tbCategorie.id=tbProduit.refCategorie inner join tbAgence on tbAgence.id=tbProduit.refAgence INNER JOIN tbImage on tbImage.codeProduit=tbProduit.id WHERE tbDetailCommande.refCommande='$cmdID' group by dtlCmdId";
                    $result = Constants::connect()->query($sql);
                    while ($rowDtlCmd=$result->fetch_assoc()) {
                        array_push($data, $rowDtlCmd);
                    }
                    $sql="SELECT * from `tracking` WHERE orderID='$cmdID'";
                    $result = Constants::connect()->query($sql);
                    while ($rowTrack=$result->fetch_assoc()) {
                        array_push($tracking, $rowTrack);
                    }
                   array_push($array, [
                    'cmdID'=>$row['cmdID'],
                    'smartpayID'=>$row['smartpayID'],
                    'dateCmd'=>$row['dateCmd'],
                    'statut'=>$row['statut'],
                    'addrNom'=>$row['addrNom'],
                    'addrPrenom'=>$row['addrPrenom'],
                    'addrPhone'=>$row['addrPhone'],
                    'addrEmail'=>$row['addrEmail'],
                    'addrPays'=>$row['addrPays'],
                    'addrVille'=>$row['addrVille'],
                    'detailCmd'=>$data,
                    'tracking'=>$tracking,
                   ]);
                }
                echo(json_encode($array));
	    	}
	    }
	}
?>