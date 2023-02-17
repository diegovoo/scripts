#!/bin/bash

if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "--h" ] || [ "$1" = "h" ]
 then
    echo "Usage: ./horario.sh <desired_weekday>"
 else
    case ${1^} in
      Lunes | Monday )
	echo -e "10 -> Ingeniería del Software\n12 -> Sistemas orientados a servicios\n17 -> FGTIE"
	;;
      Martes | Tuesday)
	echo -e "10 -> Sistemas Distribuidos \n12 -> Progamación Declarativa \n15 -> Arquitectura"
	;;
      Miercoles | Wednesday)
	echo -e "12 -> Ingeniería del Software"
	;;
      Jueves | Thursday)
	echo -e "10 -> Sistemas orientados a Servicios \n12 -> Sistemas Distribuidos \n17 -> Arquitectura"
	;;
      Viernes | Friday)
	echo -e "10 -> Proyecto de Instalación Informática"
	;;
      *)
	echo -e "That's not a day of the week! \nDo ./horario.sh --h for help"
	exit -1
	;;
    esac
fi

exit 0

