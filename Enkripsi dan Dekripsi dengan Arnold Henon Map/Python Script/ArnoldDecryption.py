from PIL import Image
import os

def decryptArnoldImage(imageMatrix,mapList,size,filename="aaa",save=False):
    width = size
    height = size
    henonDecryptedImage = imageMatrix
    arnoldDecryptedImage = []
    for i in range(width):
        row = []
        for j in range(height):
            try:
                row.append((0))
            except:
                row = [(0)]
        try:
            arnoldDecryptedImage.append(row)
        except:
            arnoldDecryptedImage = [row]
    for map in mapList:
        for key,value in map.items():
            arnoldDecryptedImage[key[0]][key[1]] = (henonDecryptedImage[int(value[0])][int(value[1])])
    if save:
        im = Image.new("L", (width, height))
        pix = im.load()
        for x in range(width):
            for y in range(height):
                pix[x, y] = arnoldDecryptedImage[x][y]
        im.save("ArnoldDecryptedImage.bmp", "BMP")
        return os.path.abspath("ArnoldDecryptedImage.bmp")
    else:
        return arnoldDecryptedImage