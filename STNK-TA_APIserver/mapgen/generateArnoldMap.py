from PIL import Image
import numpy as np
import sys
import os
import json
cwd = os.getcwd()

def multiplyMatrix(A,B,res):
    if len(A[0]) == len(B):
        for i in range(len(A)):
            for j in range(len(B[0])):
                for k in range(len(A[0])):
                    res[i][j] =  res[i][j] + A[i][k]*B[k][j]
    return res

def matrixModulo(inputMatrix,n):
    newMatrix = []
    for row in inputMatrix:
        newRow= []
        for el in row:
            newEl = el%n
            try:
                newRow.append(newEl)
            except:
                newRow = [newEl]
        try:
            newMatrix.append(newRow)
        except:
            newMatrix = [newRow]
    return newMatrix

def genArnoldMap(res,inputMatrix,numberOfIterations,modN):
    map = {}
    res1 = np.zeros(shape = (2,1))
    res1 = matrixModulo(multiplyMatrix(res,inputMatrix,res1),modN)
    count = 0
    while (res1 != inputMatrix) and (count < numberOfIterations):
        res2 = np.zeros(shape = (2,1))
        res1 = matrixModulo(multiplyMatrix(res,res1,res2),modN)
        count += 1
    newtuple = (res1[0][0],res1[1][0])
    actualtuple = (inputMatrix[0][0],inputMatrix[1][0])
    map[actualtuple] = newtuple
    #print(map)
    return map

def driverProgram(width,height,numberOfIterations,modN):
    n = 2
    mapList = []
    UTM  = np.triu(np.ones((n,n),dtype = int),0)
    LTM =  np.tril(np.ones((n,n),dtype = int),0)
    RM = np.zeros(shape = (n,n))
    res = multiplyMatrix(LTM,UTM,RM)
    #print(res)
    for i in range(width):
        for j in range(height):
            inputMatrix = [[i],[j]]
            map = genArnoldMap(res,inputMatrix,numberOfIterations,modN)
            try:
                mapList.append(map)
            except:
                mapList = [map]
    a = str(mapList)
    with open('out.txt', 'w') as f:
        f.write(a)
    return mapList

if __name__ == "__main__":
    try:
        driverProgram(
            width = int(sys.argv[1]),
            height = int(sys.argv[1]),
            numberOfIterations = int(sys.argv[2]),
            modN = int(sys.argv[1])
        )
    except Exception as e:
        print("Error: ", e)
