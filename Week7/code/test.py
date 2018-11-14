import scipy as sc

a = sc.array(range(5))

print(type(a))
print(type(a[0]))

a = sc.array(range(5), float)
a.dtype

x = sc.arange(5.)

b = sc.array([i for i in range(10) if i % 2 == 1])
c = b.tolist()

mat = sc.array([[0, 1], [2, 3]])
mat.shape
mat[1]
mat[:, 1]
mat[0, 0]
mat[1, 0]
mat[0, -1]
mat[0, -2]
mat[0, 0] = -1
mat[:, 0] = [12, 12]
sc.append(mat, [[12, 12]], axis=0)
mat = sc.append(mat, [[12], [12]], axis=1)
sc.delete(mat, 2, 1)

mat = sc.array([[0, 1], [2, 3]])
mat0 = sc.array([[0, 10], [-1, 3]])
sc.concatenate((mat, mat0), axis=0)
mat.ravel()
mat.reshape((1, 4))

sc.ones((4, 2))
sc.zeros((4, 2))
m = sc.identity(4)

m.fill(16)

mm = sc.arange(16)
mm = mm.reshape(4, 4)
mm.transpose()
mm + mm.transpose()

mm - mm.transpose()
mm * mm.transpose()

mm // mm.transpose()
mm // (mm+1).transpose()
mm.dot(mm)
mm = sc.matrix(mm)
mm * mm

import scipy.stats
scipy.stats.norm.rvs(size = 10)

scipy.stats.randint.rvs(0,10,size=7)