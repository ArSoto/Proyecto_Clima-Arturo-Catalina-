# -*- coding: utf-8 -*-

import rpy2.robjects as ro
import sys

class GenerateCurveR(object):
	
	def __init__(self, path, nameImage, nameFile, xLabel, yLabel, title):
		self.nameImageFull = path+"/"+nameImage+".png"
		self.nameImage = nameImage
		self.nameFile = nameFile
		self.ListMedida = []
		self.ListMes = []
    
    # get information of file...
		self.getValueofFile()

		# generate graphic temp		
		
		# generate the values
		self.createValueofR(self.ListMes, self.ListMedida)
		
		# create the function
		self.createCurve()
		
		# call the function
		self.CreateCurve(self.nameImageFull, xLabel, yLabel, title)

	def getValueofFile(self):
		lector = open(self.nameFile, 'r')
		lines = []
		
		line = lector.readline()
		while line:
			columnas = line.split(";")
			mes = columnas[0]
			medida = columnas[1]
			
			#mes = int (mes.split("-")[1])
			medida = medida.replace("\n", "")
			
			self.ListMes.append(mes)
			self.ListMedida.append(medida)
			line = lector.readline()
			
		lector.close()

	def createValueofR(self, ListParamx, ListParamY):
		ListParamXinR = ro.FloatVector(ListParamx)
		ListParamYinR = ro.FloatVector(ListParamY)

		ro.globalenv['ListParamXinR'] = ListParamXinR
		ro.globalenv['ListParamYinR'] = ListParamYinR

		lista = ro.globalenv['ListParamXinR']

		###print "Esta es la lista desde R ", lista

	def createCurve(self):

		codigo_r = """
		CreateCurve <- function(NameImage, xLabel, yLabel, title) {
			library(ggplot2)
		  	df = data.frame(ListParamXinR, ListParamYinR)
		  	result = ggplot(data = df, aes(ListParamXinR, ListParamYinR)) + geom_point() + geom_smooth(method = "lm", se = FALSE, formula = y ~ poly(x, nrow(df) - 1))
		  	result + xlab(xLabel) + ylab (yLabel) + ggtitle(title) + theme_bw()
		  	ggsave(file = NameImage)
		}
		"""

		ro.r(codigo_r)

		self.CreateCurve = ro.globalenv['CreateCurve']


def main ():

	generate = GenerateCurveR(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6])

if __name__ == '__main__':
	main()
