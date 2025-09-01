import numpy as np

arr = np.array([1, 2, 3, 4, 5, 6, 7, 8])
new_arr = arr.view()
<<<<<<< HEAD
arr[0] = 99
=======
new_arr[0] = 99
>>>>>>> 9ed9ec85ef2d9633be713f86cf6fb59a1ed40854

print(arr)
print(new_arr)

