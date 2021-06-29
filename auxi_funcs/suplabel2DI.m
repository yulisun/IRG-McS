function [DI] = suplabel2DI(sup_cog,suplabel)
[h,w]   = size(sup_cog);
nbr_sp  = max(sup_cog(:));
idx_t1 = label2idx(sup_cog);
for i = 1:nbr_sp
    index_vector = idx_t1{i};
    DI_temp(index_vector) = suplabel(i);
end
DI =reshape(DI_temp,[h w]);