import generateHenonMap as ghm
from PIL import Image
import os

def decryptHenonImage(imageMatrix, x, y):
    width = len(imageMatrix)
    height = len(imageMatrix[0])
    transformationMatrix = ghm.genTransformationMatrix(width, height, x, y)
    print("ImageMatrix Rows : %d Cols : %d " % (width, height))
    print("Transformation Matrix Rows : %d Cols : %d" %(width,height))
    #Performing Ex-Or Operation between the ImageMatrix and transformation Matrix
    #Storing the result in henonDecryptedImage matrix
    henonDecryptedImage = []
    for i in range(width):
        row = []
        for j in range(height):
            try:
                row.append(imageMatrix[i][j] ^ transformationMatrix[i][j])
            except:
                row = [imageMatrix[i][j] ^ transformationMatrix[i][j]]
        try:
            henonDecryptedImage.append(row)
        except:
            henonDecryptedImage = [row]
    return henonDecryptedImage