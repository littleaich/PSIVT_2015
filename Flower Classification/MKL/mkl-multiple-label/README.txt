This package contains the source code for multiple kernel learning with multiple labels. 

Please refer to the following paper for algorithm details:
@INPROCEEDINGS{Tang-etal09-IJCAI,
  author = {Lei Tang and Jianhui Chen and Jieping Ye},
  title = {On Multiple Kernel Learning with Multiple Labels},
  booktitle = {Proceedings of the 21st International Joint Conference on Artificial
	Intelligence},
  year = {2009},
}


For convenient comprehension of the source code, we provide a toy
example (USPS.mat) and a driver file (maindriver.m) to call different functions. 


In order to run the code, two packages must be installed and add to the matlab path:

1. libsvm matlab inferface(http://www.csie.ntu.edu.tw/~cjlin/libsvm/). After
compilation, the runnable "svmtrain" is required. 

2. mosek (http://www.mosek.com/). We use mosek to solve the LP problem
involved. Mosek provides student trial license. Please refer to the
corresponding documents for installation. 

Please  add the runnable path of both packages to the matlab path,
otherwise the code provided here is not runnable. 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Here are some descriptions of the code:
 - SILP_1norm_independent.m:  The INDEPENDENT Model, each label selects
                              kernel independently;

 - SILP_1norm_partial.m: The PARTIAL model, allowing partial kernel
                         sharing among different labels;

 - SILP_1norm_same.m: The SAME model, all labels selets the same kernel;

All these functions take the input of candidate kernels and class label
information, and output the kernel weights as well as the SVM
classifier (within the structure "model")

model.mu is the kernel weights for shared part;
model.gamma are the kernel weights specific for each label. 

model.alpha and model.bias are the parameters of the SVM classifier
with the following desicion function:
 	  y = sign( \sum_i alpha_i * y_i * k(x_i, x) + bias)


Some common mistakes when using the code:
- The class labels should be represented as +1/-1, instead of 1/0;
- The kernel matrix for prediction should be index_te X index_tr, not
  index_tr X index_te. 

Hope this helps :)

If you encounter any problem, please feel free to contact Lei Tang
(L.Tang@asu.edu).


Updated on July 29th, 2009.

