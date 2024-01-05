<?php
$dateExp = date("Y-m-d H:i:s", strtotime("+1 years", strtotime(date("Y-m-d H:i:s"))));
$dateExpir = date("Y-m-d", strtotime(date("Y-m-d H:i:s")));
print_r($dateExpir);

$matriculeClient = rand(10000, 1000000) . date('YmdHis');
print_r('\n' . $matriculeClient);
?>
<html>

<head>
	<title></title>
</head>

<body>
	<form action="saveClass.php" method="POST">
		<input placeholder="userID" type="text" name="userID">
		<input placeholder="details" type="text" name="details[]">
		<input placeholder="details" type="text" name="details[]">
		<input placeholder="details" type="text" name="details[]">
		<input placeholder="newbillboard" value="newbillboard" type="text" name="transaction">
		<input type="submit" value="valider">
	</form>


	<br>
	GET DATA
	<form action="get_data.php" method="POST">
		<input placeholder="plaque" type="text" name="plaque">
		<input placeholder="Scan" value="getscan" type="text" name="transaction">
		<input type="submit" value="valider">
	</form>

	GET Transaction
	<form action="transactions.php" method="POST">
		<input placeholder="value" type="text" name="value">
		<input placeholder="transaction" value="stats" type="text" name="transaction">
		<input type="submit" value="valider">
	</form>

</body>

</html>