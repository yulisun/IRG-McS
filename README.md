# IRG-McS
MATLAB Code for Iterative Robust Graph for Unsupervised Change Detection of Heterogeneous Remote Sensing Images

## Introduction
MATLAB Code: IRG-McS - 2021
This is a test program for the Iterative Robust Graph and Markovian co-Segmentation method (IRG-McS) for heterogeneous change detection.

IRG-McS is an improved version of our previous work of NPSG (https://github.com/yulisun/NPSG) and INLPG (https://github.com/yulisun/INLPG).

NPSG： Sun, Yuli, et al."Nonlocal patch similarity based heterogeneous
remote sensing change detection. Pattern Recognition," 2021, 109, 107598.

INLPG： Sun, Yuli, et al. "Structure Consistency based Graph for Unsupervised
Change Detection with Homogeneous and Heterogeneous Remote Sensing Images."
IEEE Transactions on Geoscience and Remote Sensing, Early Access, 2021,
doi:10.1109/TGRS.2021.3053571.

In IRG-McS, a robust adaptive KNN graph of each image is constructed by adaptively selecting unchanged nearest neighbors with appropriate K
for each superpixel though an iterative framework combining the DI generation and CM calculation processes; and a superpixel-based MRF co-segmentation model is designed
to fuse the forward and backward DIs in the segmentation process to improve the CD accuracy, which is solved by the co-graph cut.

Please refer to the paper for details. You are more than welcome to use the code!

===================================================

## Available datasets

#2-Img7, #3-Img17, and #5-Img5 can be found at Professor Max Mignotte's webpage (http://www-labs.iro.umontreal.ca/~mignotte/) and they are associated with this paper https://doi.org/10.1109/TGRS.2020.2986239.

#6-California can be download from Dr. Luigi Tommaso Luppino's webpage (https://sites.google.com/view/luppino/data) and it is associated with this paper https://doi.org/10.1109/TGRS.2019.2930348.

===================================================

## Citation

If you use this code for your research, please cite our paper. Thank you!

@ARTICLE{9477152,
  author={Sun, Yuli and Lei, Lin and Guan, Dongdong and Kuang, Gangyao},  
  journal={IEEE Transactions on Image Processing},   
  title={Iterative Robust Graph for Unsupervised Change Detection of Heterogeneous Remote Sensing Images},   
  year={2021},  
  volume={30},  
  number={},  
  pages={6277-6291},  
  doi={10.1109/TIP.2021.3093766}}  

## Q & A

If you have any queries, please do not hesitate to contact me (sunyuli@mail.ustc.edu.cn ).
