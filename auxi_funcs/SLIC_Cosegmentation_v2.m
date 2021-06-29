function [sup_pixel,N] = SLIC_Cosegmentation_v2(image_t1,image_t2,seg_scal,Compactness)
[h, w, b1]=size(image_t1);
[~, ~, b2]=size(image_t2);

if (b1+b2)==2
    for i = 1:b1
        new_image(:,:,i) = image_t1(:,:,i);
    end
    for i = 1:b2
        new_image(:,:,b1+i) = image_t2(:,:,i);
    end
    new_image(:,:,b1+b2+1) = zeros(h,w);
    [sup_pixel,N] = superpixels(new_image,seg_scal,'IsInputLab',1,'Compactness',Compactness);
end

if (b1+b2)==3
    for i = 1:b1
        new_image(:,:,i) = image_t1(:,:,i);
    end
    for i = 1:b2
        new_image(:,:,b1+i) = image_t2(:,:,i);
    end
    [sup_pixel,N] = superpixels(new_image,seg_scal,'IsInputLab',1,'Compactness',Compactness);
end

if (b1+b2)>3 && abs(b1-b2)<=2
    for i = 1:b1
        temp = image_t1(:,:,i);
        temp_image(:,i) = temp(:);
    end
    for i = 1:b2
        temp = image_t2(:,:,i);
        temp_image(:,i+b1) = temp(:);
    end
    [pc,score,latent,tsquare] = pca(temp_image,'NumComponents',3);
    for i = 1:3
        tmep = score(:,i);
        new_image(:,:,i) = reshape(tmep,[h w]);
    end
    [sup_pixel,N] = superpixels(new_image,seg_scal,'IsInputLab',1,'Compactness',Compactness);
end

if (b1+b2)>3 && abs(b1-b2)>2 && min(b1,b2)~=1
    if b1<b2
        for i = 1:b2
            temp = image_t2(:,:,i);
            temp_image_t2(:,i) = temp(:);
        end
        [pc,score,latent,tsquare] = pca(temp_image_t2,'NumComponents',b1);
        for i = 1:b1
            tmep = score(:,i);
            new_image_t2(:,:,i) = reshape(tmep,[h w]);
        end
        for i = 1:b1
            temp = image_t1(:,:,i);
            temp_image(:,i) = temp(:);
        end
        for i = 1:b1
            temp = new_image_t2(:,:,i);
            temp_image(:,i+b1) = temp(:);
        end
        [pc,score,latent,tsquare] = pca(temp_image,'NumComponents',3);
        for i = 1:3
            tmep = score(:,i);
            new_image(:,:,i) = reshape(tmep,[h w]);
        end
        [sup_pixel,N] = superpixels(new_image,seg_scal,'IsInputLab',1,'Compactness',Compactness);
    end
    if b1>b2
        for i = 1:b1
            temp = image_t1(:,:,i);
            temp_image_t1(:,i) = temp(:);
        end
        [pc,score,latent,tsquare] = pca(temp_image_t1,'NumComponents',b2);
        for i = 1:b2
            tmep = score(:,i);
            new_image_t1(:,:,i) = reshape(tmep,[h w]);
        end
        for i = 1:b2
            temp = new_image_t1(:,:,i);
            temp_image(:,i) = temp(:);
        end
        for i = 1:b2
            temp = image_t2(:,:,i);
            temp_image(:,i+b2) = temp(:);
        end
        [pc,score,latent,tsquare] = pca(temp_image,'NumComponents',3);
        for i = 1:3
            tmep = score(:,i);
            new_image(:,:,i) = reshape(tmep,[h w]);
        end
        [sup_pixel,N] = superpixels(new_image,seg_scal,'IsInputLab',1,'Compactness',Compactness);
    end
end
if (b1+b2)>3 && abs(b1-b2)>2 && min(b1,b2)==1
    if b1<b2
        for i = 1:b2
            temp = image_t2(:,:,i);
            temp_image_t2(:,i) = temp(:);
        end
        [pc,score,latent,tsquare] = pca(temp_image_t2,'NumComponents',2);
        for i = 1:2
            tmep = score(:,i);
            new_image_t2(:,:,i) = reshape(tmep,[h w]);
        end
        for i = 1:b1
            new_image(:,:,i) = image_t1(:,:,i);
        end
        for i = 1:2
            new_image(:,:,i+b1) = new_image_t2(:,:,i);
        end
        [sup_pixel,N] = superpixels(new_image,seg_scal,'IsInputLab',1,'Compactness',Compactness);
    end
    if b1>b2
        for i = 1:b1
            temp = image_t1(:,:,i);
            temp_image_t1(:,i) = temp(:);
        end
        [pc,score,latent,tsquare] = pca(temp_image_t1,'NumComponents',2);
        for i = 1:2
            tmep = score(:,i);
            new_image_t1(:,:,i) = reshape(tmep,[h w]);
        end
        for i = 1:2
            new_image(:,:,i) = new_image_t1(:,:,i);
        end
        for i = 1:b2
            new_image(:,:,i+2) = image_t2(:,:,i);
        end
        [sup_pixel,N] = superpixels(new_image,seg_scal,'IsInputLab',1,'Compactness',Compactness);
    end
end