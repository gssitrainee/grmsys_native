<?php
	require_once('libs/dbconnect.php');
	require_once('libs/verify_session.php');
	require_once('libs/common_functions.php');

	$log_date = mysqli_real_escape_string($conn, $_GET['log_date']);
	$dateLog = convertStringToDate($log_date);

	$sqlQuery = " SELECT * FROM vw_dailysales_total ";
	if('null' != $dateLog)
		$sqlQuery .= " WHERE transaction_date = $dateLog";
	else
		$sqlQuery .= " WHERE transaction_date = DATE(NOW()) ";

	//echo $sqlQuery;

	$result = mysqli_query($conn, $sqlQuery) or die("Query fail: " . $sqlQuery);

	include('pages/printGeneralSalesPage.html');	

	exit(0);
?>