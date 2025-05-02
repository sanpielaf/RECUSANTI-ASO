$alumnos = Import-Csv -Path "C:\Users\Administrador\Desktop\alumnos.csv"
$grupos = Import-Csv -Path "C:\Users\Administrador\Desktop\grupos.csv"

###-----CARPETA IESELCAMINAS---------------------------------------------------------------

#creamos la carpeta raiz IESELCAMINAS con su estructura
New-Item -Path C:\IESELCAMINAS -ItemType directory -Force

foreach ($grupo in $grupos) {
    New-Item -Path C:\IESELCAMINAS\"$($grupo.nombre)" -ItemType directory -Force
}

#compartimos la carpeta raíz (IESELCAMINAS)
New-SmbShare -Name "IESELCAMINAS" -Path C:\IESELCAMINAS -ChangeAccess 'Usuarios del Dominio' -FullAccess "Administradores"

#definimos los permisos NTFS de la carpeta principal
$acl = Get-Acl -Path C:\IESELCAMINAS

#Deshabilitamos la herencia y eliminamos todas las reglas de acceso
$acl.SetAccessRuleProtection($true,$false)

#Añadir al grupo "Administradores" control total.
$permisoS = 'Administradores', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow'
$ace = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permisoS
$acl.SetAccessRule($ace)

#Añadir al grupo "usuarios del dominio" permisos de lectura.
$permisoP = 'Usuarios del dominio', 'Read', 'ContainerInherit,ObjectInherit', 'None', 'Allow'
$ace = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permisoP
$acl.SetAccessRule($ace)

#establecemos los permisos
$acl | Set-Acl -Path C:\IESELCAMINAS
$ace | Format-Table 

#----------SUBCARPETAS DE IESELCAMINAS-------------------------------------------------------------------

#bucle para definir permisos de las subcarpetas (grupos) dentro de la carpeta raíz IESELCAMINAS
foreach ($grupo in $grupos) {

    #definimos los permisos NTFS de cada subcarpeta (grupo) de la carpeta raiz IESELCAMINAS
    $acl = Get-Acl -Path C:\IESELCAMINAS\"$($grupo.nombre)"

    #Deshabilitamos la herencia y eliminamos todas las reglas de acceso
    $acl.SetAccessRuleProtection($true,$false)
    
    #Añadir al grupo "Administradores" control total.
    $permisoD = 'Administradores', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow'
    $ace = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permisoD
    $acl.SetAccessRule($ace)

    #Cada grupo de alumnos podrá entrar en su grupo con permisos de control total y no podrá acceder a las carpetas del resto de grupos.
    $permisoA = "$($grupo.nombre)",'FullControl','ContainerInherit,ObjectInherit','None','Allow'
    $ace2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permisoA
    $acl.SetAccessRule($ace2)

    #establecemos los permisos
    $acl | Set-Acl -Path C:\IESELCAMINAS\"$($grupo.nombre)"
    $ace | Format-Table
}
###------------------CARPETA IESELCAMINAS_USERS------------------------------------------------------

#creamos la carpeta raiz IESELCAMINAS_USERS con su estructura
New-Item -Path C:\IESELCAMINAS_USERS -ItemType directory -Force 

foreach($alumno in $alumnos){
    New-Item -Path C:\IESELCAMINAS_USERS\"$($alumno.nombre).$($alumno.apellidos)" -ItemType directory -Force   
}

#compartimos la carpeta raíz (IESELCAMINAS_USERS)                                                           
New-SmbShare -Name "IESELCAMINAS_USERS$" -Path C:\IESELCAMINAS_USERS -ChangeAccess 'Usuarios del Dominio' -FullAccess "Administradores"

#definimos los permisos NTFS de la carpeta principal
$acl = Get-Acl -Path C:\IESELCAMINAS_USERS

#Deshabilitamos la herencia y eliminamos todas las reglas de acceso
$acl.SetAccessRuleProtection($true,$false)

#Añadir al grupo "Administradores" control total.
$permisoT = 'Administradores', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow'
$ace3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permisoT
$acl.SetAccessRule($ace3)

#establecemos los permisos
$acl | Set-Acl -Path C:\IESELCAMINAS_USERS
$ace | Format-Table 

###---------------SUBCARPETAS DE IESELCAMINAS_USERS--------------------------------------------------------------------

#bucle para definir permisos de las carpetas (alumno) dentro de la carpeta raíz IESELCAMINAS_USERS
foreach ($alumno in $alumnos) {

    #definimos los permisos NTFS de cada subcarpeta (alumno) de la carpeta raiz IESELCAMINAS_USERS
    $acl = Get-Acl -Path C:\IESELCAMINAS_USERS\"$($alumno.nombre).$($alumno.apellidos)"

    #Deshabilitamos la herencia y eliminamos todas las reglas de acceso
    $acl.SetAccessRuleProtection($true,$false)
    
    #Añadir al grupo "Administradores" control total.
    $permisoK = 'Administradores', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow'
    $ace4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permisoK
    $acl.SetAccessRule($ace4)

    #Cada alumno podrá entrar en su  carpeta con permisos de control total y no podrá acceder a las carpetas del resto de alumnos.
    $permisoX = "$($alumno.nombre).$($alumno.apellidos)",'FullControl','ContainerInherit,ObjectInherit','None','Allow'
    $ace5 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permisoX
    $acl.SetAccessRule($ace5)

    #establecemos los permisos
    $acl | Set-Acl -Path C:\IESELCAMINAS_USERS\"$($alumno.nombre).$($alumno.apellidos)"
    $ace | Format-Table
}