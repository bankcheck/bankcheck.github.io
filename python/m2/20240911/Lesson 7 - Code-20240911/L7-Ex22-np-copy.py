import numpy as np

arr = np.array([1, 2, 3, 4, 5, 6, 7, 8])
new_arr = arr.copy()
arr[0] = 99

print(arr)
print(new_arr)


