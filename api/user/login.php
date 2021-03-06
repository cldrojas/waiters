<?php

include_once '../config/database.php';

$db = new Database();
$conn = $db -> getConnection();

// input variables
$usuario = $_POST['usuario'];
$clave = md5($_POST['clave']);

$temp_user = array();

$sql = "SELECT USU_ID as id, USU_NOMBRE as nombre, CAR_NOMBRE as cargo
		FROM USUARIO		
		JOIN CARGO
		On CARGO.CAR_ID = USUARIO.CAR_ID
		WHERE USUARIO.USU_USUARIO = :usuario
		AND USUARIO.USU_CLAVE = :clave
        AND USU_ACTIVO = 1";

$query = $conn -> prepare($sql);
$query -> bindParam(':usuario', $usuario, PDO::PARAM_STR);
$query -> bindParam(':clave', $clave, PDO::PARAM_STR);

$query -> execute();
$res = $query -> fetch(PDO::FETCH_ASSOC);
	if($res != null){					
			array_push($temp_user, $res);				
	}		
echo json_encode($temp_user);