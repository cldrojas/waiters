<form action="user/login.php" method="post">
	<label>Correo <input type="text" name="correo"></label>
	<label>Clave <input type="text" name="clave"></label>	
	<input type="submit" value="Verificar usuario">
</form>

<form action="user/create.php" method="post">
	<label> Nombre <input type="text" name="nombre"></label>
	<label> Correo <input type="text" name="correo"></label>
	<label> Clave <input type="text" name="clave"></label>
	<label>Cargo <select name="cargo" id="cargo">
		<option value="1">cocinero</option>
		<option value="2">cajero</option>
		<option value="3">mesero</option>
		<option value="4">admin</option>
	</select></label>
	<input type="submit" value="Crear usuario">
</form>

<form action="venta/create.php" method="post">
	<label> Fecha <input type="date" name="fecha"></label>
	<label>Trabajador <select name="trabajador" id="trabajador">
		<option value="1"> admin </option>
		<option value="2"> gallina </option>
		<option value="8"> DonWaloh </option>		
	</select></label>
	<label>Local <select name="local" id="local">
		<option value="1">lincoyan</option>
		<option value="2">bilbao</option>		
	</select></label>
	<label> Valor <input type="number" name="valor"></label>
	<input type="submit" value="Registrar venta">
</form>