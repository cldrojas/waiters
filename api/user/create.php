<?php

include_once '../config/database.php';

$db = new Database();
$conn = $db -> getConnection();

// input variables
$correo = $_POST['correo'];
$clave = md5($_POST['clave']);
$cargo = $_POST['cargo'];
$nombre = $_POST['nombre'];

$sql = "INSERT INTO usuario (email,password) VALUES (:correo,:clave)";

$query = $conn -> prepare($sql);
$query -> bindParam(':correo', $correo, PDO::PARAM_STR);
$query -> bindParam(':clave', $clave, PDO::PARAM_STR);

$query -> execute();

$id = $conn -> lastInsertId();
var_dump($id);
var_dump($cargo);

$sql = "INSERT INTO trabajador (nombre,cargo,usuario,activo) VALUES (:nombre,:cargo,:id,1)";

$query = $conn -> prepare($sql);
$query -> bindParam(':nombre', $nombre, PDO::PARAM_STR);
$query -> bindParam(':cargo', $cargo, PDO::PARAM_INT);
$query -> bindParam(':id', $id, PDO::PARAM_INT);

$query -> execute();
