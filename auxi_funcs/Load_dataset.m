if strcmp(dataset,'#1-Italy') == 1 % Heterogeneous CD of multispectral VS. multispectral
    image_t1 = imread('Italy_1.bmp');
    image_t2 = imread('Italy_2.bmp');
    gt = imread('Italy_gt.bmp');
    Ref_gt = gt(:,:,1);
    opt.type_t1 = 'optical';
    opt.type_t2 = 'optical';
    figure;
    subplot(131);imshow(image_t1,[]);title('imaget1')
    subplot(132);imshow(image_t2,[]);title('imaget2')
    subplot(133);imshow(Ref_gt,[]);title('Refgt')
elseif strcmp(dataset,'#2-Img7') == 1 % Heterogeneous CD of multispectral VS. multispectral
    image_t1 = imread('Img7-Ac.tif');
    image_t2 = imread('Img7-Bc.tif');
    gt = imread('Img7-C.tif');
    Ref_gt = gt(:,:,1);
    opt.type_t1 = 'optical';
    opt.type_t2 = 'optical';
    figure;
    subplot(131);imshow(image_t1,[]);title('imaget1')
    subplot(132);imshow(image_t2,[]);title('imaget2')
    subplot(133);imshow(Ref_gt,[]);title('Refgt')
elseif strcmp(dataset,'#3-Img17') == 1 % Heterogeneous CD of multispectral VS. multispectral
    image_t1 = imread('Img17-A.tif');
    image_t2 = imread('Img17-Bc.tif');
    gt = imread('Img17-C.tif');
    Ref_gt = gt(:,:,1);
    opt.type_t1 = 'optical';
    opt.type_t2 = 'optical';
    figure;
    subplot(131);imshow(image_t1,[]);title('imaget1')
    subplot(132);imshow(image_t2,[]);title('imaget2')
    subplot(133);imshow(Ref_gt,[]);title('Refgt')
elseif strcmp(dataset,'#4-Shuguang') == 1 % Heterogeneous CD of SAR VS. Optical
    image_t1 = imread('shuguang_1.bmp');
    image_t2 = imread('shuguang_2.bmp');
    gt = imread('shuguang_gt.bmp');
    Ref_gt = gt(:,:,1);
    opt.type_t1 = 'optical';
    opt.type_t2 = 'optical';
    figure;
    subplot(131);imshow(image_t1,[]);title('imaget1')
    subplot(132);imshow(image_t2,[]);title('imaget2')
    subplot(133);imshow(Ref_gt,[]);title('Refgt')
elseif strcmp(dataset,'#5-Img5') == 1 % Heterogeneous CD of SAR VS. Optical
    image_t1 = (imread('Img5-A.tif'));
    image_t2 = (imread('Img5-Bc.tif'));
    gt = imread('Img5-C.tif');
    Ref_gt = gt(:,:,1);
    image_t1 = image_t1(1:4:end,1:4:end,:);
    image_t2 = image_t2(1:4:end,1:4:end,:);
    Ref_gt = Ref_gt(1:4:end,1:4:end);
    opt.type_t1 = 'sar';
    opt.type_t2 = 'optical';
    figure;
    subplot(131);imshow(image_t1,[]);title('imaget1')
    subplot(132);imshow(image_t2,[]);title('imaget2')
    subplot(133);imshow(Ref_gt,[]);title('Refgt')
elseif strcmp(dataset,'#6-California') == 1 % Heterogeneous CD of SAR VS. Optical
    load('California.mat')
    Ref_gt = gt(:,:,1);
    opt.type_t1 = 'optical';% the SAR image have been Log transformed
    opt.type_t2 = 'optical';
    figure;
    subplot(131);imshow(image_t1,[-1 1]);title('imaget1')
    subplot(132);imshow(image_t2(:,:,[4 3 2])+1,[]);title('imaget2')
    subplot(133);imshow(Ref_gt,[]);title('Refgt')
end
image_t1 = image_normlized(image_t1,opt.type_t1);
image_t2 = image_normlized(image_t2,opt.type_t2);
