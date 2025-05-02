New-ADOrganizationalUnit -Name "IESELCAMINAS" -Path "DC=RECUSANTI,DC=LOCAL" -Description "Ejercicio 3.2" -ProtectedFromAccidentalDeletion $false

$alumnos = Import-Csv -Path "C:\Users\Administrador\Desktop\alumnos.csv"
$grupos = Import-Csv -Path "C:\Users\Administrador\Desktop\grupos.csv"

$ou = "OU=IESELCAMINAS,DC=RECUSANTI,DC=LOCAL"



foreach ($grupo in $grupos) {

    New-ADOrganizationalUnit -Name $($grupo.nombre) -Path "$ou" -Description $($grupo.descripcion)
}

foreach ($grupo in $grupos) {   
    
    New-ADGroup -Name $($grupo.nombre) -GroupCategory "Security" -GroupScope "Global" -Path "OU=$($grupo.nombre),OU=IESELCAMINAS,DC=RECUSANTI,DC=LOCAL"
}

foreach ($alumno in $alumnos) {

    New-ADUser -Name "$($alumno.nombre) $($alumno.apellidos)" `
               -Path "OU=$($alumno.grupo),OU=IESELCAMINAS,DC=RECUSANTI,DC=LOCAL" `
               -SamAccountName "$($alumno.nombre).$($alumno.apellidos)" `
               -AccountPassword (ConvertTo-SecureString "hola01?" -AsPlainText -Force) `
               -GivenName $($alumnno.nombre) `
               -Surname $($alumnno.nombre) `
               -ChangePasswordAtLogon $true `
               -Enabled $true
}

foreach ($alumno in $alumnos) {
    Add-ADGroupMember -Identity $($alumno.grupo) `
                      -Members "$($alumno.nombre).$($alumno.apellidos)"
}