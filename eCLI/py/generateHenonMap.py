from PIL import Image

def dec(bitSequence):
    decimal = 0
    for bit in bitSequence:
        decimal = decimal * 2 + int(bit)
    return decimal


#Takes size of the image as an input
def genTransformationMatrix(width, height, x=0.1, y=0.1):
    #Replace Hardcoded Pixel Values
    #Serves as the initial Parameter and also the symmetric secret key
    # x = 0.1
    # y = 0.1
    sequenceSize = width * height * 8 #Total Number of bitSequence produced
    bitSequence = []    #Each bitSequence contains 8 bits
    byteArray = []      #Each byteArray contains m( i.e 512 in this case) bitSequence
    TImageMatrix = []   #Each TImageMatrix contains m*n byteArray( i.e 512 byteArray in this case)
    for i in range(sequenceSize):
        #Henon Map formula
        xN = y + 1 - 1.4 * x**2
        yN = 0.3 * x

        # New x = xN and y = yN
        x = xN
        y = yN

        # Each Value of xN is converted into 0 or 1 based on the threshold value
        if xN <= 0.3992:
            bit = 0
        else:
            bit = 1
        #bits are inserted into bitSequence
        try:
            bitSequence.append(bit)
        except:
            bitSequence = [bit]
        #Each bitSequence is converted into a decimal number
        #This decimal number is inserted into byteArray
        if i % 8 == 7:
            decimal = dec(bitSequence)
            try:
                byteArray.append(decimal)
            except:
                byteArray = [decimal]
            bitSequence = []
        #ByteArray is inserted into TImageMatrix
        byteArraySize = height*8
        if i % byteArraySize == byteArraySize-1:
            try:
                TImageMatrix.append(byteArray)
            except:
                TImageMatrix = [byteArray]
            byteArray = []
    return TImageMatrix
