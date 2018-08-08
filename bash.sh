#!/bin/bash

anho="2010"
mkdir Resultados

wget -i lista.txt

	while [ `ls  | grep "$anho" | head -n 1` ]; do
	
	
	if [ ! -d "$anio" ]; then
		
		cd Resultados	
		mkdir $anho
		cd ..
		general=$(ls | grep "$anho")

		cat $general |grep "$anho" >> Resultados/$anho/general.txt
		cat Resultados/$anho/general.txt | awk -F ';' '{print $1 "-" $6 }' >>Resultados/$anho/humedad1.txt
		cat Resultados/$anho/humedad1.txt | awk -F '-' '{print $2":" $4 }' >>Resultados/$anho/humedad2.txt
		cat Resultados/$anho/general.txt | awk -F ';' '{print $1 "-" $7 }' >>Resultados/$anho/temperatura1.txt
		cat Resultados/$anho/temperatura1.txt | awk -F '-' '{print $2":" $4 }' >>Resultados/$anho/temperatura2.txt
		
		for i in 01 02 03 04 05 06 07 08 09 10 11 12
		do
		
			cat Resultados/$anho/humedad2.txt |awk -v num=$i -F ":"  '$1 == num { total+= $2; sum+=1 } END {print num ";" total/sum }' >>Resultados/$anho/humedad3.txt
			cat Resultados/$anho/temperatura2.txt |awk -v num=$i -F ":"  '$1 == num { total+= $2; sum+=1 } END {print num ";" total/sum }' >>Resultados/$anho/temperatura3.txt
			
		done
		cat Resultados/$anho/temperatura3.txt |awk -F ";"  '$2 != "-nan" {print $1";"$2  }' >> Resultados/$anho/temperatura.csv
		cat Resultados/$anho/humedad3.txt |awk -F ";"  '$2 != "-nan" {print $1";"$2  }' >> Resultados/$anho/humedad.csv
		
		python generateGraphic.py Resultados/$anho grafico_humedad Resultados/$anho/humedad.csv meses humedad Grafico_Anual
		python generateGraphic.py Resultados/$anho Grafico_temperatura Resultados/$anho/temperatura.csv meses temperatura Grafico_Anual
		rm Resultados/$anho/temperatura1.txt Resultados/$anho/temperatura2.txt Resultados/$anho/temperatura3.txt 
		rm Resultados/$anho/humedad1.txt Resultados/$anho/humedad2.txt Resultados/$anho/humedad3.txt
		
			
	fi
	
	anho=$(($anho+1))	
	done
	
	ls | grep ".csv" | rm
