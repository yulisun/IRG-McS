function [sup_pixel,N] = SLIC_multispectral(image,seg_scal,Compactness)
[h w b]=size(image);
if b==1 || b==3
   [sup_pixel,N] = superpixels(image,seg_scal,'Compactness',Compactness);
end
if b==2
    for i = 1:b
        new_image(:,:,i) = image(:,:,i);
    end
    new_image(:,:,3) = zeros(h,w);
    [sup_pixel,N] = superpixels(new_image,seg_scal,'IsInputLab',1,'Compactness',Compactness);
end
if b>3
    for i = 1:b
        temp = image(:,:,i);
        new_image(:,i) = temp(:);
    end
    [pc,score,latent,tsquare] = pca(new_image,'NumComponents',3);
    for i = 1:3
        tmep = score(:,i);
        result_image(:,:,i) = reshape(tmep,[h w]);
    end
    [sup_pixel,N] = superpixels(result_image,seg_scal,'IsInputLab',1,'Compactness',Compactness); 
end
    
        
 
   

