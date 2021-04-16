import generateHenonMap as ghm
from PIL import Image
import os

def pixelManipulation(imageMatrix, x, y):
    width = len(imageMatrix)
    height = len(imageMatrix[0])
    transformationMatrix = ghm.genTransformationMatrix(width, height, x, y)
    print("ImageMatrix Rows : %d Cols : %d " % (width, height))
    print("Transformation Matrix Rows : %d Cols : %d" %(width, height))
    #Performing Ex-Or Operation between the transformation Matrix and ImageMatrix
    #Storing the result in resultant Matrix
    resultantMatrix = []
    for i in range(width):
        row = []
        for j in range(height):
            try:
                row.append(transformationMatrix[i][j] ^ imageMatrix[i][j])
            except:
                row = [transformationMatrix[i][j] ^ imageMatrix[i][j]]
        try:
            resultantMatrix.append(row)
        except:
            resultantMatrix = [row]
    return resultantMatrix