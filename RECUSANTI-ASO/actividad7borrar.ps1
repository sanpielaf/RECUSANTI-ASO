#ESTE SCRIPT ELIMINA los ficheros dentro de la carpeta "temp"---------------

# Lista todas las subcarpetas dentro de IESELCAMINAS
$subcarpetas = Get-ChildItem -Path "C:\IESELCAMINAS" -Directory

# Elimina los archivos en las carpetas "temp"
foreach ($carpeta in $subcarpetas) {
        Get-ChildItem -Path "$($carpeta.FullName)\temp" -File | Remove-Item -Force
}