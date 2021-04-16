import ImageTransformation as iT
import HenonDecryption as hD
import generateArnoldMap as gam
import ArnoldDecryption as aD
import createImageMatrix as cim

from PIL import ImageTk, Image
import argparse, sys, time, os, shutil
from squarepartition import *

cwd = os.getcwd()
def eH(filePath):
    start_time = time.time()
    print("\nEn Henon")
    print(filePath)
    fileName = os.path.split(filePath)[-1]
    fileName = fileName.split(".")[0]
    # path reader
    imageMatrix = cim.getImageMatrix(filePath)    
    # process
    resImage = iT.pixelManipulation(imageMatrix, x, y)
    # saver
    savepath = IMSaver(resImage, fileName+"_eH")
    print('Henon ended {}\n'.format(time.time()-start_time))
    return savepath

def dH(filePath):
    start_time = time.time()
    print("\nDe Henon")
    print(filePath)
    fileName = os.path.split(filePath)[-1]
    fileName = fileName.split(".")[0]
    # path reader
    imageMatrix = cim.getImageMatrix(filePath)
    # process
    resImage = hD.decryptHenonImage(imageMatrix, x, y)
    # saver
    savepath = IMSaver(resImage, fileName+"_dH")
    print('Henon ended {}\n'.format(time.time()-start_time))
    return savepath

def aH(filePath):
    start_time = time.time()
    print("\nEn Henon")
    print(filePath)
    fileName = os.path.split(filePath)[-1]
    fileName = fileName.split(".")[0]
    # path reader
    imageMatrix = cim.getImageMatrix(filePath)    
    # process
    resImageen = iT.pixelManipulation(imageMatrix)
    resImagede = hD.decryptHenonImage(resImageen)
    # saver
    savepath = IMSaver(resImagede, fileName+"_aH")
    print('Henon ended {}\n'.format(time.time()-start_time))
    return savepath

def eA(filePath):
    print("\nEn Arnold")
    start_time= time.time()
    fileName = os.path.split(filePath)[-1]
    fileName = fileName.split(".")[0]
    # path reader
    imageMatrix = cim.getImageMatrix(filePath)
    # process
    width = len(imageMatrix)
    height = len(imageMatrix[0])
    sp = square_part(height, width)
    parted = partitor(imageMatrix, sp)
    # part_saver(parted, fileName)    
    arnoldList = arnoldEnBuilder(parted)    
    tmp = part_joiner(arnoldList, sp)
    # saver
    savepath = IMSaver(tmp, fileName+"_eA")
    print('\nArnold ended {}'.format(time.time()-start_time))
    return savepath

def dA(filePath):
    print("\nEn Arnold")
    fileName = os.path.split(filePath)[-1]
    fileName = fileName.split(".")[0]
    # path reader
    imageMatrix = cim.getImageMatrix(filePath)
    # process
    width = len(imageMatrix)
    height = len(imageMatrix[0])
    sp = square_part(height, width)
    parted = partitor(imageMatrix, sp)
    # part_saver(parted, fileName)    
    arnoldList = arnoldDeBuilder(parted)    
    tmp = part_joiner(arnoldList, sp)
    # saver
    savepath = IMSaver(tmp, fileName+"_dA")
    print('\nArnold ended')
    return savepath

def aA(filePath):
    print("\nEn Arnold")
    start_time= time.time()
    fileName = os.path.split(filePath)[-1]
    fileName = fileName.split(".")[0]
    # path reader
    imageMatrix = cim.getImageMatrix(filePath)
    # process
    width = len(imageMatrix)
    height = len(imageMatrix[0])
    sp = square_part(height, width)
    parted = partitor(imageMatrix, sp)
    # part_saver(parted, fileName)    
    arnoldList = arnoldEnBuilder(parted)    
    tmp = part_joiner(arnoldList, sp)
    arnoldList = arnoldDeBuilder(tmp)    
    tmp = part_joiner(arnoldList, sp)
    # saver
    savepath = IMSaver(tmp, fileName+"_aA")
    print('\nArnold ended {}'.format(time.time()-start_time))
    return savepath

def eHA(filePath):
    start_time = time.time()
    print("\nEn Henon-Arnold")
    print(filePath)
    fileName = os.path.split(filePath)[-1]
    fileName = fileName.split(".")[0]
    # path reader
    imageMatrix = cim.getImageMatrix(filePath)    
    # process: Henon
    resImage = iT.pixelManipulation(imageMatrix, x, y)
    # process: Arnold
    width = len(resImage)
    height = len(resImage[0])
    sp = square_part(height, width)
    parted = partitor(resImage, sp)
    # part_saver(parted, fileName)    
    arnoldList = arnoldEnBuilder(parted)    
    tmp = part_joiner(arnoldList, sp)
    # saver
    savepath = IMSaver(tmp, fileName+"_eHA")
    print('Henon-Arnold ended {}\n'.format(time.time()-start_time))
    return savepath

def dAH(filePath):
    start_time = time.time()
    print("\nDe Arnold-Henon")
    print(filePath)
    fileName = os.path.split(filePath)[-1]
    fileName = fileName.split(".")[0]
    # path reader
    imageMatrix = cim.getImageMatrix(filePath)    
    # process: Arnold
    width = len(imageMatrix)
    height = len(imageMatrix[0])
    sp = square_part(height, width)
    parted = partitor(imageMatrix, sp)
    # part_saver(parted, fileName)    
    arnoldList = arnoldDeBuilder(parted)    
    tmp = part_joiner(arnoldList, sp)
    # process: Henon
    resImage = hD.decryptHenonImage(tmp, x, y)
    # saver
    savepath = IMSaver(resImage, fileName+"_dAH")
    print('Arnold-Henon ended {}\n'.format(time.time()-start_time))
    return savepath

def arnoldEnBuilder(parted, fileName="aaa"):
    arnoldList = []
    ss=1
    for part in parted:
        a_time = time.time()
        width  = len(part)
        height = len(part[0])
        print("{}/{}: {}x{}".format(ss, len(parted), width, height))
        modN = width
        numberOfIterations = args.numberOfIterations
        mapList = gam.driverProgram(width,height,numberOfIterations,modN)
        resImage = gam.createArnoldCatImage(part,mapList,width,fileName+"-a"+str(ss))
        arnoldList.append(resImage)
        ss+=1
        print('  {}'.format(time.time()-a_time))
    return arnoldList

def arnoldDeBuilder(parted, fileName="aaa"):
    arnoldList = []
    ss=1
    for part in parted:
        width  = len(part)
        height = len(part[0])
        if width == 1:
            arnoldList.append(part)
        print("{}/{}: {}x{}".format(ss, len(parted), width, height))
        modN = width
        numberOfIterations = args.numberOfIterations
        mapList = gam.driverProgram(width,height,numberOfIterations,modN)
        resImage = aD.decryptArnoldImage(part,mapList,width,fileName+"-a"+str(ss))
        arnoldList.append(resImage)
        ss+=1
    return arnoldList

def IMSaver(imageMatrix, fileName):
    width = len(imageMatrix)
    height = len(imageMatrix[0])
    im = Image.new("L", (width, height))
    pix = im.load()
    for x in range(width):
        for y in range(height):
            pix[x, y] = imageMatrix[x][y]
    savepath = os.path.join(cwd, "result", fileName+".bmp")
    im.save(savepath, "BMP")
    return savepath

parser=argparse.ArgumentParser(description="CLI-based Henon-Arnold encryption and decryption",  formatter_class=argparse.RawTextHelpFormatter)
parser.add_argument('path',help='Absolute path of the picture', type=str)
parser.add_argument('mode', help=
'''"eH": Encrypt using Henon Map
"eA": Encrypt using Arnold Cat Map
"eHA": Encrypt using Henon map then Arnold Cat Map
"dH": Decrypt Henon-encrypted picture
"dA": Decrypt Arnold-encrypted picture
"dAH": Decrypt Arnold-Henon-encrypted picture
''', type=str)
parser.add_argument('numberOfIterations', default=1, const=1, nargs='?', help='''Number of Arnold shuffle iteration, not required for Henon.
Passed as 1 when no argument is passed''',
type=int)
parser.add_argument('x', default=0.1, const=1, nargs='?', help='''Initial value for Henon map, not required for Arnold.
Passed as 0.1 when no argument is passed''',
type=float)
parser.add_argument('y', default=0.1, const=1, nargs='?', help='''Initial value for Henon map, not required for Arnold.
Passed as 0.1 when no argument is passed''',
type=float)
args=parser.parse_args()

filename=os.path.split(args.path)[-1]
targetpath=os.path.join(cwd, "result", filename)
if not os.path.exists('result'):
    os.makedirs('result')
if not os.path.exists(targetpath):
    print('copy')
    print(args.path)
    print(targetpath)
    shutil.copyfile(args.path, targetpath)

x=args.x
y=args.y
if (args.mode =='eH'):
    print(eH(args.path))
elif (args.mode =='dH'):
    print(dH(args.path))
elif (args.mode =='aH'):
    print(aH(args.path))
elif (args.mode =='eA'):
    print(eA(args.path))
elif (args.mode =='dA'):
    print(dA(args.path))
elif (args.mode =='aA'):
    print(aA(args.path))
elif (args.mode =='eHA'):
    print(eHA(args.path))
elif (args.mode =='dAH'):
    print(dAH(args.path))    
else:
    print("...")