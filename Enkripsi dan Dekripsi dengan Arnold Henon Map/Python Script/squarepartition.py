from PIL import Image
import os
cwd = os.getcwd()
def square_part(width, height):
    slice_list = []
    curr_width = width
    curr_height = height

    curr_x=0
    curr_y=0
    #print("Curr_x:{} - Curr_y:{} - Curr_w:{} - Curr_h:{}".format(curr_x, curr_y, curr_width, curr_height))
    while curr_width>0 and curr_height>0:
        if curr_height<curr_width:
            #print('a: x+{}'.format(curr_height))
            slice_list.append((
                curr_x,
                curr_y,
                curr_x+curr_height if curr_x+curr_height-1<width-1 else width,
                curr_y+curr_height if curr_y+curr_height-1<height-1 else height,
                curr_height
                ))
            curr_x+=curr_height
            curr_width-=curr_height
        else:
            #print('b: y+{}'.format(curr_width))
            slice_list.append((
                curr_x,
                curr_y,
                curr_x+curr_width if curr_x+curr_width-1<width else width,
                curr_y+curr_width if curr_y+curr_width-1<height else height,
                curr_width
                ))
            curr_y+=curr_width
            curr_height-=curr_width
        #print("\nCurr_x:{} - Curr_y:{} - Curr_w:{} - Curr_h:{}".format(curr_x, curr_y, curr_width, curr_height))

    a=1
    for i in slice_list:
        # print(str(a)+": ", end='')
        # print(i)
        a+=1
    return slice_list

def partitor(a, SP):
    parted=[]
    for idx in SP:
        part = []
        for i in a[idx[1]:idx[3]]:
            row = []
            for j in i[idx[0]:idx[2]]:
                row.append(j)
            part.append(row)
        parted.append(part)
    return parted

def part_saver(res, filename="aaaa"):
    if not os.path.exists('result/cat/'):
        os.makedirs('result/cat/')
    no=1
    for s in res:
        width  = len(s)
        height = len(s[0])
        im = Image.new("L", (width, height))
        pix = im.load()
        for x in range(width):
            for y in range(height):
                pix[x, y] = s[x][y]
        savepath = os.path.join(cwd, "result","cat", filename+str(no)+".bmp")
        im.save(savepath, "BMP")
        no+=1
        # print(savepath)

def dummy_gen(width, height):
    a=[]
    x=1
    for i in range(1,height+1):
        row=[]
        for j in range(1,width+1):
            row.append(x)
            x+=1
        a.append(row)
    return a

def disp(res):
    for q in res:
        for w in q:
            print(w)
        print('---')

def disp1(res):
    for w in res:
        print(w)
    print()

def part_joiner(res, sp):
    for i in range(len(sp)):
        # print(i)
        if i == 0:
            tmp = res[i]
        else:
            if sp[i][1]<len(tmp):
                # print('a')
                e = iter(res[i])
                for j in range(sp[i][1], len(tmp)):
                    try:
                        tmp[j]+=next(e)
                    except:
                        pass
            else:
                # print('o')
                tmp+=res[i]
        # for asw in tmp:
        #     print(asw)
        # print()
    return tmp