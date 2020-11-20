<?php

include_once '../config/database.php';

$db = new Database();
$conn = $db -> getConnection();

// input variables
$usuario = $_POST['usuario'];
$clave = md5($_POST['clave']);

$temp_user = array();

$sql = "SELECT USU_ID as id, USU_NOMBRE as nombre, car_nombre as cargo
		FROM usuario		
		JOIN cargo
		On cargo.car_id = usuario.car_id
		WHERE usuario.usu_usuario = :usuario
		AND usuario.usu_clave = :clave
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