<?php

include_once '../config/database.php';

$db = new Database();
$conn = $db -> getConnection();

// input variables
$usuario = $_POST['usuario'];
$clave = md5($_POST['clave']);
$cargo = $_POST['cargo'];
$nombre = $_POST['nombre'];

$sql = "INSERT INTO USUARIO VALUES (:cargo, :nombre, :usuario, :clave, 1)";

$query = $conn -> prepare($sql);
$query -> bindParam(':cargo', $cargo, PDO::PARAM_INT);
$query -> bindParam(':nombre', $nombre, PDO::PARAM_STR);
$query -> bindParam(':usuario', $usuario, PDO::PARAM_STR);
$query -> bindParam(':clave', $clave, PDO::PARAM_STR);

$query -> execute();