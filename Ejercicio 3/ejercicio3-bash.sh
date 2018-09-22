#!/bin/bash

function help(){
	echo "TP N°2 - Bash"
	echo " "
	echo "Nombre: Ejercicio2.sh"
	echo ""
	echo "Entrega N°1"
	echo "Fecha de entrega: 11-10-2018"
	echo " "
	echo "Descripción:"
	echo "Script que genera cartas personalizadas en base"
	echo "a una carta modelo, tiene en cuenta etiquetas,"
	echo "indicadas de la forma @[TAG] para reemplazarla"
	echo "con información en un archivo de BD de clientes."
	echo "Tiene 2 parámetros, 1 por cada archivo(carta_modelo"
	echo "y bd_clientes)."
	echo " "
	echo "Modos:"
	echo "Se puede acceder a la ayuda enviando [-h]"
	echo "como único parámetro."
	echo "	source Ejercicio2.sh -h"
	echo " "
	echo "Ejecución:"
	echo "Para una correcta ejecución se deben enviar"
	echo "las rutas de ambos archivos (primero de la"
	echo "carta modelo y segundo la base de datos de"
	echo "clientes."
	echo "	source Ejercicio2sh \"[ruta]/[archCartaModelo]\" \"[ruta]/[archBDClientes]\""
	echo " "
	echo "Autores:"
	echo "Arias Pablo Alejandro"
	echo "Feito Gustavo Sebastian"
	echo "Magliano, Agustin       - DNI 39.744.938"
	echo "Rosmirez Juan Ignacio"
	echo "Zambianchi Nicolas Ezequiel"
}

#Si se indican alguno de los parametros de ayuda
	if [  "$1" == "-h"  ] || [ "$1" == "-help" ] || [ "$1" == "-?" ]; then
		echo " "
		help
		echo " "
		return -1;
	fi

#Si los parametros son incorrectos
	if [ $# -ne 2 ]; then
		echo " "
		echo "La cantidad de parametros ingresados es incorrecta."
		echo " "
		return -1;
	fi

#Si los archivos no existen
	if [ ! -f "$1" ]; then
		echo " "
		echo "El archivo \"$1\" no existe."
		echo " "
		return -1;
	fi

	if [ ! -f "$2" ]; then
		echo " "
		echo "El archivo \"$2\" no existe."
		echo " "
		return -1;
	fi

#Si los archivos estan vacios o no son del formato correcto
	file -i "$1" | grep text/plain >> /dev/null
	if [ $? != 0 ]; then
		echo " "
		echo "El archivo \"$1\" no es un archivo de texto o esta vacio."
		echo " "
		return -1;
	fi

	file -i "$2" | grep text/plain >> /dev/null
	if [ $? != 0 ]; then
		echo " "
		echo "El archivo \"$2\" no es un archivo de texto o esta vacio."
		echo " "
		return -1;
	fi

#Se recolecta la informacion del archivo de base de datos de cada cliente.

i=0;
cat "$2" | while read line
do
cliente[$i]=`echo $line | awk -F ":" '{print $1}'`
done

#Se identifican las etiquetas de la carta modelo

#Se verifica que los clientes cumplan con todas las etiquetas de la carta modelo

#Se generan las cartas personalizadas para cada cliente


