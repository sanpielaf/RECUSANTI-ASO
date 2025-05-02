#---------------------USAR ESTE SCRIPT EN LA MV DE MI PORTÁTIL PERSONAL--------------------------------------

$alumnos = Import-Csv -Path "C:\Users\Administrador\Desktop\alumnos.csv"

foreach($alumno in $alumnos){

    ##Cuando un alumno inicie sesión, conectará de forma automática la carpeta personal en la unidad X:
    Set-ADUser -Identity "$($alumno.nombre).$($alumno.apellidos)" -ScriptPath "carpetas.bat" -HomeDrive "X:" -HomeDirectory "\\WINDOWS-SERVER\IESELCAMINAS_USERS$\$($alumno.nombre).$($alumno.apellidos)"
    
    ###y la carpeta del grupo en la unidad Y (Asignar script de inicio de sesión para mapear Y:)
    Set-ADUser -Identity "$($alumno.nombre).$($alumno.apellidos)" -ScriptPath "carpetas.bat"
}