<?php

include_once '../config/database.php';

$db = new Database();
$conn = $db -> getConnection();

// input variables
$correo = $_POST['correo'];
$clave = md5($_POST['clave']);

$usuario = array();

$sql = "SELECT trabajador.id, trabajador.nombre, cargo.nombre as cargo
		FROM trabajador
		JOIN usuario
		ON usuario.id = trabajador.usuario
		JOIN cargo
		On cargo.id = trabajador.cargo
		WHERE usuario.email = :correo
		AND usuario.password = :clave";

$query = $conn -> prepare($sql);
$query -> bindParam(':correo', $correo, PDO::PARAM_STR);
$query -> bindParam(':clave', $clave, PDO::PARAM_STR);

$query -> execute();
$res = $query -> fetch();
	if($res != null){					
			array_push($usuario, $res['id'], $res['nombre'], $res['cargo']);				
	}		
var_dump($usuario);
echo json_encode($usuario);