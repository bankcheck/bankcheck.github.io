import datetime
import glob
import shutil

nowday = datetime.datetime.now()

yyyy = str(nowday.year)
mm = ("0" + str(nowday.month))[-2:]
dd = ("0" + str(nowday.day))[-2:]

for filename in glob.glob("*.txt"):
    shutil.copyfile(filename, yyyy+mm+dd+".txt")





