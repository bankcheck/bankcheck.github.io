import glob
for filename in glob.glob("C:/**/Downloads/test.txt", recursive = True):
    print(filename)
