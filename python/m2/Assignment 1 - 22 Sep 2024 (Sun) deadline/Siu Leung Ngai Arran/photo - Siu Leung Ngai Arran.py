import os
import glob
import shutil

#Define spath, mpath, lpath for global use
spath = "C:/photos/small/"
mpath = "C:/photos/medium/"
lpath = "C:/photos/large/"

#Function for move photos and print the summary at the end
def movePhotos():
    #Define number of bytes for a megabytes
    megabytes = 1048576

    #fcount is used to count total number of files
    #scount is used to count number of small files
    #mcount is used to count number of medium files
    #lcount is used to count number of large files
    #Initialize all counter to 0
    fcount = scount = mcount = lcount = 0
    
    #Get number of jpg files in C:\photos
    fcount = len(glob.glob("C:/photos/*.jpg"))

    #For each file in C:\photos, move files to correspoding folders and increment the correspoding counters
    for filename in glob.glob("C:/photos/*.jpg"):

        out = os.path.getsize(filename)
        if out < 3 * megabytes:
            shutil.move(filename, spath + os.path.basename(filename))
            scount += 1
        elif out < 7 * megabytes:
            shutil.move(filename, mpath + os.path.basename(filename))
            mcount += 1
        else:
            shutil.move(filename, lpath + os.path.basename(filename))             
            lcount += 1

    #Print the summary at the end
    print("Categorized " + str(fcount) + " photos:")
    print("- " + str(scount) + " photos moved to 'small' folder")
    print("- " + str(mcount) + " photos moved to 'medium' folder")
    print("- " + str(lcount) + " photos moved to 'large' folder")

#Main program
try:

    #Create the 3 destination folders
    os.mkdir(spath)
    os.mkdir(mpath)
    os.mkdir(lpath)

#If the destination folders exists, ignore the exception and continue to call movePhotos()
except (FileExistsError):
    movePhotos()

#Halt the program and print debug message for other exceptions
except Exception as e:
    print("Error: " + type(e).__name__ + " at line " + str(e.__traceback__.tb_lineno))    

#Call movePhotos if no exceptions
else:
    movePhotos()