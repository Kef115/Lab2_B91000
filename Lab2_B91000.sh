#!/bin/bash

#Parametros/variables 
nombre=$1
grupo=$2
ruta=$3
echo "$nombre"
echo "$grupo"
echo "$ruta"

#--------------------------------------------------------------------------
#Verificar si es root 
if [[ "$(whoami)" != 'root' ]]
then
echo "Error: No eres el root"
exit
fi



#-------------------------------------------------------------------------------
#chequeando si el archivo existe
if [ -f $ruta ]
then
    echo "el archivo existe"
else
    echo "el archivo no exise, se procede a crearlo"
    touch /home/$nombre/text.txt

fi
#-----------------------------------------------------------------------------------
#chequeando existencia de grupo
#el puntero ayuda para que la informacion no se imprima en pantalla   >/dev/null]

if getent group "$grupo" >/dev/null ; then
  echo "El grupo $grupo si existe" 
else
    echo "  El grupo no existe, por lo tanto se procede a crearlo"
    sudo addgroup $grupo
fi
#----------------------------------------------------------------------
# Existencia del usuario
if id "$nombre" &>/dev/null; then
    echo "El usuario '$nombre' si existe." 
else
    # Crea  usuario pero no agregarlo
    sudo useradd -m "$nombre"
    echo "El Usuario '$nombre' ha sido creado."
fi

# Agregar usuario al grupo si ya existía
sudo usermod -aG "$grupo" "$nombre"
echo "Se esta agregando al Usuario '$nombre' al grupo '$grupo'." 

#--------------------------------------------------------------------------
#cambiando pertenencia del archivo

sudo chown "$nombre":"$grupo" "$ruta"

#--------------------------------------------------------------------------
#Dando full permisos al Usuarion, al grupo solo lectura y al resto nningun permiso
sudo chmod 740 "$ruta"
echo "Modificando los permisos que se tienen sobre el archivo que se encuentra en '$ruta' ." 




