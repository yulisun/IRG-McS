# IRG-McS
Iterative Robust Graph for Unsupervised Change Detection of Heterogeneous Remote Sensing Images

Code: IRG-McS - 2021
This is a test program for the Iterative Robust Graph and Markovian co-Segmentation method (IRG-McS) for heterogeneous change detection.

IRG-McS is an improved version of our previous work of NPSG (https://github.com/yulisun/NPSG) and INLPG (https://github.com/yulisun/INLPG).

*NPSG： Sun, Yuli, et al."Nonlocal patch similarity based heterogeneous
remote sensing change detection. Pattern Recognition," 2021, 109, 107598.

INLPG： Sun, Yuli, et al. "Structure Consistency based Graph for Unsupervised
Change Detection with Homogeneous and Heterogeneous Remote Sensing Images."
IEEE Transactions on Geoscience and Remote Sensing, Early Access, 2021,
doi:10.1109/TGRS.2021.3053571.

In IRG-McS, a robust adaptive KNN graph of each image is constructed by adaptively selecting unchanged nearest neighbors with appropriate K
for each superpixel though an iterative framework combining the DI generation and CM calculation processes; and a superpixel-based MRF co-segmentation model is designed
to fuse the forward and backward DIs in the segmentation process to improve the CD accuracy, which is solved by the co-graph cut.

===================================================

If you use this code for your research, please cite our paper. Thank you!

Sun, Yuli, et al. "Iterative Robust Graph for Unsupervised Change Detection of Heterogeneous Remote Sensing Images."
IEEE Transactions on Image Processing, Accepted, 2021,
doi:10.1109/TIP.2021.3093766.


