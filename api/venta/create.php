<?php

include_once '../config/database.php';

$db = new Database();
$conn = $db -> getConnection();

// input variables
$fecha = $_POST['fecha'];
$trabajador = $_POST['trabajador'];
$local = $_POST['local'];
$valor = $_POST['valor'];

$sql = "INSERT INTO venta (trabajador,local,valor) VALUES (:trabajador,:local,:valor)";

$query = $conn -> prepare($sql);
//$query -> bindParam(':fecha', $fecha, PDO::PARAM_STR);
$query -> bindParam(':trabajador', $trabajador, PDO::PARAM_INT);
$query -> bindParam(':local', $local, PDO::PARAM_INT);
$query -> bindParam(':valor', $valor, PDO::PARAM_INT);

$query -> execute();
