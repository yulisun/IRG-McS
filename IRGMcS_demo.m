%%  Iterative Robust Graph for Unsupervised Change Detection of Heterogeneous Remote Sensing Images
%{
Code: IRG-McS - 2021
This is a test program for the Iterative Robust Graph and Markovian co-Segmentation method (IRG-McS) for heterogeneous change detection.

IRG-McS is an improved version of our previous work of NPSG (https://github.com/yulisun/NPSG) and INLPG (https://github.com/yulisun/INLPG).

NPSG£º Sun, Yuli, et al."Nonlocal patch similarity based heterogeneous
remote sensing change detection. Pattern Recognition," 2021, 109, 107598.

INLPG£º Sun, Yuli, et al. "Structure Consistency based Graph for Unsupervised
Change Detection with Homogeneous and Heterogeneous Remote Sensing Images."
IEEE Transactions on Geoscience and Remote Sensing, Early Access, 2021,
doi:10.1109/TGRS.2021.3053571.

===================================================

If you use this code for your research, please cite our paper. Thank you!

Sun, Yuli, et al. "Iterative Robust Graph for Unsupervised Change Detection of Heterogeneous Remote Sensing Images."
IEEE Transactions on Image Processing, Accepted, 2021,
doi:10.1109/TIP.2021.3093766.

===================================================
%}

clc
clear;
close all
addpath('auxi_funcs')
%% load dataset
addpath('datasets')
% #2-Img7, #3-Img17, and #5-Img5 can be found at Professor Max Mignotte's webpage (http://www-labs.iro.umontreal.ca/~mignotte/) and they are associated with this paper https://doi.org/10.1109/TGRS.2020.2986239.
% #6-California is download from Dr. Luigi Tommaso Luppino's webpage (https://sites.google.com/view/luppino/data) and it was downsampled to 875*500 as shown in our paper.
% For other datasets, we recommend a similar pre-processing as in "Load_dataset"
dataset = '#1-Italy';% #1-Italy, #2-Img7, #3-Img17, #4-Shuguang, #5-Img5, #6-California
Load_dataset
fprintf(['\n Data loading is completed...... ' '\n'])
%% Parameter setting

% With different parameter settings, the results will be a little different
% Ns: the number of superpxiels,  A larger Ns will improve the detection granularity, but also increase the running time. 5000 <= Ns <= 10000 is recommended.
% Niter: the maximum number of iterations, 2 <= Niter <=6 is recommended.
% lambda: balance parameter. The smaller the lambda, the smoother the CM. 0.025<= lambda <=0.1 is recommended.
opt.Ns = 5000;
opt.SupSseg = 'v2'; % The 'v2' is recommended because it is faster than 'v1'.
opt.Niter = 6;
if strcmp(dataset,'#2-Img7')
    opt.lambda = 0.1;
else
    opt.lambda = 0.05;
end
%% IRG-McS
t_o = clock;
fprintf(['\n IRG-McS is running...... ' '\n'])
%------------- Preprocessing: Superpixel segmentation and feature extraction---------------%
t_sf = clock;
Compactness = 1;
if strcmp(opt.SupSseg,'v1') % v1 for intersection based Cosegmentation.
    Segiter = 2;
    [Cosup, ~] = SLIC_Cosegmentation_v1(image_t1,image_t2,round(opt.Ns/2),Compactness,opt.Ns,Segiter);
elseif strcmp(opt.SupSseg,'v2') % v2 for Cosegmentation based on directly merging images.
    [Cosup,~] = SLIC_Cosegmentation_v2(image_t1,image_t2,opt.Ns,Compactness);
end
CoNs = max(Cosup(:));
[t1_feature,t2_feature] = MSMfeature_extraction(Cosup,image_t1,image_t2); %feature extraction
fprintf('\n');fprintf('The computational time of Preprocessing (t_sf) is %i \n', etime(clock, t_sf));
fprintf(['\n' '====================================================================== ' '\n'])
%% Iterative framework of IRG-McS.dist
iter = 1;
Kmax =round(size(t1_feature,2).^0.5);
Kmin = round(Kmax/10);
[Kmat] = adaptiveKmat(t1_feature,t1_feature,t2_feature,t2_feature,Kmax,Kmin);
labels = zeros(size(t1_feature,2),1);
while iter<=(opt.Niter)
    idex_unchange = labels==0;
    t1_feature_lib = t1_feature(:,idex_unchange);
    t2_feature_lib = t2_feature(:,idex_unchange);
    %--------------------- CalculateChangeLevel----------------------%
    t_di = clock;
    [fx,fy] = CalculateChangeLevel(t1_feature_lib,t1_feature,t2_feature_lib,t2_feature,Kmat);% dist
    fx_result(:,iter) = remove_outlier(fx);
    fy_result(:,iter) = remove_outlier(fy);
    fprintf('\n');fprintf('The computational time of DI generation (t_di) is %i \n', etime(clock, t_di));
    %--------------------- MRF co-segmentation----------------------%
    t_cs = clock;
    [CM_map,labels] = MRF_CoSegmentation(Cosup,opt.lambda,t1_feature,t2_feature,fx_result(:,iter),fy_result(:,iter));
    CM_map_result(:,:,iter) = CM_map;
    fprintf('\n');fprintf('The computational time of MRF CoSegmentation (t_cs) is %i \n', etime(clock, t_cs));
    iter = iter+1;
end
fprintf(['\n' '====================================================================== ' '\n'])
fprintf('\n');fprintf('The total computational time of IRG-McS (t_total) is %i \n', etime(clock, t_o));

%% Displaying results
fprintf(['\n' '====================================================================== ' '\n'])
fprintf(['\n Displaying the results...... ' '\n'])
%--------------------- DI----------------------%
n=500;
Ref_gt = Ref_gt/max(Ref_gt(:));
for iter = 1:opt.Niter
    [DI_fw] = suplabel2DI(Cosup,fx_result(:,iter));
    [DI_bw] = suplabel2DI(Cosup,fy_result(:,iter));
    DI_final = DI_fw/mean(DI_fw(:))+DI_bw/mean(DI_bw(:));
    [TPR_fw, FPR_fw]= Roc_plot(DI_fw,Ref_gt,n);
    [TPR_bw, FPR_bw]= Roc_plot(DI_bw,Ref_gt,n);
    [TPR_final, FPR_final]= Roc_plot(DI_final,Ref_gt,n);
    [AUC_fw, Ddist_fw] = AUC_Diagdistance(TPR_fw, FPR_fw);
    [AUC_bw, Ddist_bw] = AUC_Diagdistance(TPR_bw, FPR_bw);
    [AUC_final, Ddist_final] = AUC_Diagdistance(TPR_final, FPR_final);
    AUC_diagdist_ALL(iter,:) = [AUC_fw, AUC_bw, AUC_final, Ddist_fw, Ddist_bw, Ddist_final];
end
AUC_diagdist_ALL
figure;
subplot(221);imshow(DI_fw,[]);title('DI-fw');colormap('Parula')
subplot(222);imshow(DI_bw,[]);title('DI-bw');colormap('Parula')
subplot(223);imshow(DI_final,[]);title('DI-final');colormap('Parula')
subplot(224);imshow(Ref_gt,[]);title('Refgt');colormap('Parula')
figure;
plot(FPR_fw,TPR_fw);
hold on ; plot(FPR_bw,TPR_bw);
hold on ; plot(FPR_final,TPR_final);
xlabel('Probability of false alarm');
ylabel('Probability of detection');
title('ROC curves of IRG-McS.dist generated DIs');
legend('DI-fw','DI-bw','DI-final')
%--------------------- CM----------------------%
for iter = 1:opt.Niter
    [tp,fp,tn,fn,fplv,fnlv,~,~,pcc(iter),kappa(iter),imw]=performance(CM_map_result(:,:,iter),Ref_gt);
    F1(iter) = 2*tp/(2*tp+fp+fn);
end
Pcc_kappa_F1 = [pcc;kappa;F1]
figure;
for iter = 1:opt.Niter
    subplot(2,floor(opt.Niter/2),iter);imshow(CM_map_result(:,:,iter),[]),title(['CM of the' num2str(iter) '-th iteration'])
end