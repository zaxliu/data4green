data4green
==========
This project contains codes for the big data challenge Data for Development (D4D) Senegal written by Niulabers.

For security reasons, the dataset files are stored in another folder. Users should install the dataset on his/her own computer before using codes. The dataset includes D4D dataset and OpenCellID dataset.

Code List =====================================
---Matlab Code---
extractBS.m-----------------Extract the cells of a particular contry from OpenCellID dataset, and store them separately in                             another file.
recoverCell.m---------------Recover the true geographical location of cells in D4D dataset with the help of OpenCellID                                 dataset. (Still not working properly, to be refined.)

Change Log =====================================
--2014-10-12--
+ Modified the I/O methods in extractBS.m from high-level (csvwrite) to low-level methods (fprintf). This way the code can still be used if we want to extract non-numerical columns. (Currently all columns are numbers)
+ Added commentation for recoverCell.m.
+ Modified the algorithm in recoverCell.m, each OCI cell can only be assigned to one D4D cell. But have problems, only a few D4D cells found corresponding OCI cell. 

--2014-10-11--
+ Added commentation for extractBS.m

--2014-10-09--
+ Uploaded extractBS.m and recoverCell.m
