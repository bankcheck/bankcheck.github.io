#Re-submit using different alogrithm
import os
import glob
import shutil

#Function md() to create a single folder by the given parameter. 
#Return true if successful.
#Return false if failed
def md(path):
    try:
        os.mkdir(path)
    
    #Considered as successful if the destination folder exists
    except (FileExistsError):
        return True
    
    #Print debug message and return false for other exceptions
    except Exception as e:
        print("Error: " + type(e).__name__ + " at line " + str(e.__traceback__.tb_lineno))  
        print("Failed to create folder: " + path )
        return False
    
    #Return true if successful
    else:
        return True

#Define spath, mpath, lpath for small, medium, and large files
spath = "C:/photos/small/"
mpath = "C:/photos/medium/"
lpath = "C:/photos/large/"

#Create folder by calling function md.
#Proceed only when folders are created successfully.
if md(spath) and md(mpath) and md(lpath):

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