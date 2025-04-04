#!/bin/bash

#Parametros/variables 
nombre=$1
grupo=$2
ruta=$3
echo "$nombre"
echo "$grupo"
echo "$ruta"

#chequeando si archivo existe
if [ -f $ruta ]
then
    echo "el archivo existe"
else
    echo "el archivo no exise, se procede a crearlo"
    touch /home/$nombre/text.txt

fi
#chequeando existencia de grupo
#el puntero ayuda para que la informacion no se imprima en pantalla   >/dev/null]

if getent group "$grupo" >/dev/null ; then
  echo "El grupo $grupo si existe"
else
    echo "nel"
    addgroup $grupo
fi


#Verificar si es root 
if [[ "$(whoami)" != 'root' ]]
then
echo "Error: No eres el root"
exit
fi

