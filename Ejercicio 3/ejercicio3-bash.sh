#!/bin/bash

function help(){
	echo "TP N°3 - Bash"
	echo " "
	echo "Nombre: ejercicio3-bash.sh"
	echo ""
	echo "Re entrega N°1"
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
	echo "	source ejercicio3-bash.sh -h"
	echo " "
	echo "Ejecución:"
	echo "Para una correcta ejecución se deben enviar"
	echo "las rutas de ambos archivos (primero de la"
	echo "carta modelo y segundo la base de datos de"
	echo "clientes."
	echo "	source ejercicio3-bash.sh \"[ruta]/[archCartaModelo]\" \"[ruta]/[archBDClientes]\""
	echo " "
	echo "Autores:"
	echo "Arias Pablo Alejandro       - DNI 32.340.341"
	echo "Feito Gustavo Sebastian     - DNI 27.027.190"
	echo "Magliano, Agustin           - DNI 39.744.938"
	echo "Rosmirez Juan Ignacio       - DNI 40.010.264"
	echo "Zambianchi Nicolas Ezequiel - DNI 39.770.752"
}

#Si se indican alguno de los parametros de ayuda.
	if [  "$1" == "-h"  ] || [ "$1" == "-help" ] || [ "$1" == "-?" ]; then
		echo " "
		help
		echo " "
		exit 1
	fi

#Si los parametros son incorrectos.
	if [ $# -ne 2 ]; then
		echo " "
		echo "La cantidad de parametros ingresados es incorrecta."
		echo " "
		exit 1
	fi

#Si los archivos no existen.
	if [ ! -f "$1" ]; then
		echo " "
		echo "El archivo \"$1\" no existe."
		echo " "
		exit 1
	fi

	if [ ! -f "$2" ]; then
		echo " "
		echo "El archivo \"$2\" no existe."
		echo " "
		exit 1
	fi

#Si los archivos estan vacios o no son del formato correcto.
	file -i "$1" | grep text/plain >> /dev/null
	if [ $? != 0 ]; then
		echo " "
		echo "El archivo \"$1\" no es un archivo de texto o esta vacio."
		echo " "
		exit 1
	fi

	file -i "$2" | grep text/plain >> /dev/null
	if [ $? != 0 ]; then
		echo " "
		echo "El archivo \"$2\" no es un archivo de texto o esta vacio."
		echo " "
		read -p "Ingrese cualquier tecla para continuar..."
		exit 1
	fi

#Se valida que la cantidad de etiquetas coincida con las etiqutas del archivo de clientes.
#Además se valida que la cantidad minima de etiquetas sea 2 (Nombre y Apellido obligatorios).

etiquetas=$(grep -o '@.' "$1" | wc -l)

if [ $etiquetas -lt 2 ]; then
	echo 'El Nombre y Apellido del cliente son necesarios para el buen funcionamiento del script.'
	exit 1
fi

campos=$(awk -F";" '{ nw+=NF } NR==1 {print nw-1}' "$2")

#Se obtienen la cantidad de registros para generar las cartas correspondientes.

registros=$(awk -F";" '{ nr=NR } END{print nr-1}' "$2")

if [ $etiquetas != $campos ]; then
	echo 'Los datos entre el archivo "$1" y "$2" son inconsistentes, verifique etiquetas'
	exit 1
fi

#Se crea una variable con la fecha actual con el formato correcto YYYYMMDDHHMM.

fecha=$(date +"%Y%m%d%H%M") #"%Y-%m-%d-%H-%M")

#Se crea el directorio para las cartas.

nombre_dir="Cartas_$fecha"
mkdir -p "./$nombre_dir"

clientes=$(( $registros+1 ))

#Se generan las cartas personalizadas para cada cliente.

#Se almacenan las etiquetas de la carta modelo para poder compararse luego.
etiquetas_objetivo=( $(grep -E -o -w -i "@[a-z0-9]*" "$1") )


for (( i=2; i <= $clientes ; i++ )) 
do
	#Creo el archivo con el nombre y apellido del cliente.	
	
	nomCli=$(awk -F";" -v row=$i 'NR==row { print $1 }' "$2")
	apeCli=$(awk -F";" -v row=$i 'NR==row { print $2 }' "$2")
	touch "./$nombre_dir/aviso_$apeCli _ $nomCli _ $fecha"
	cat "$1" > "./$nombre_dir/aviso_$apeCli _ $nomCli _ $fecha"

	for (( j=1; j <= $etiquetas; j++ ))
	do
		etiqueta=$(awk -F";" -v field=$j  'NR==1 { print $field }' "$2")
		dato_etiqueta=$(awk -F";" -v row=$i -v field=$j 'NR==row { print $field }' "$2")

		etiquetaLocal=$(echo $etiqueta | tr [a-z] [A-Z] )
		if [[ ${etiquetas_objetivo[$j-1]} != "@$etiquetaLocal" ]]; then
			echo " La etiqueta ${etiquetas_objetivo[$j-1]} no concuerda con la etiqueta @$etiquetaLocal. Corrija los modelos."
			rm -r "./$nombre_dir"
			exit 1
		fi

		sed -i -e "s|@$etiquetaLocal\b|$dato_etiqueta|g" "./$nombre_dir/aviso_$apeCli _ $nomCli _ $fecha"
	done
done

exit 0