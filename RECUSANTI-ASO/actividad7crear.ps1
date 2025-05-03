#ESTE SCRIPT CREA UNA CARPETA llamada "temp" en cada subcarpeta de IESELCAMINAS

# Lista todas las subcarpetas dentro de IESELCAMINAS
$subcarpetas = Get-ChildItem -Path "C:\IESELCAMINAS" -Directory

# Crea una carpeta llamada "temp" dentro de cada subcarpeta
foreach ($carpeta in $subcarpetas) {
        New-Item -Path $carpeta.FullName -Name "temp" -ItemType Directory
}