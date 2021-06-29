function [adj_mat] = Boundary_neighborhood(sup_cog)
[h,w]   = size(sup_cog);
nbr_sp  = max(sup_cog(:));
adj_mat = zeros(nbr_sp);
for i=1:h-1
    for j=2:w-1       
        label = sup_cog(i,j);        
        if (label ~= sup_cog(i+1,j-1))
            adj_mat(label, sup_cog(i+1,j-1)) = 1;
        end
        if (label ~= sup_cog(i,j+1))
            adj_mat(label, sup_cog(i,j+1)) = 1;
        end
        if (label ~= sup_cog(i+1,j))
            adj_mat(label, sup_cog(i+1,j)) = 1;
        end
        if (label ~= sup_cog(i+1,j+1))
            adj_mat(label, sup_cog(i+1,j+1)) = 1;
        end      
    end
end

for i=h
    for j=2:w-1       
        label = sup_cog(i,j);        
        if (label ~= sup_cog(i-1,j-1))
            adj_mat(label, sup_cog(i-1,j-1)) = 1;
        end
        if (label ~= sup_cog(i,j+1))
            adj_mat(label, sup_cog(i,j+1)) = 1;
        end
        if (label ~= sup_cog(i-1,j))
            adj_mat(label, sup_cog(i-1,j)) = 1;
        end
        if (label ~= sup_cog(i-1,j+1))
            adj_mat(label, sup_cog(i-1,j+1)) = 1;
        end      
    end
end

for i=1:h-1
    for j=1       
        label = sup_cog(i,j);        
        if (label ~= sup_cog(i,j+1))
            adj_mat(label, sup_cog(i,j+1)) = 1;
        end
        if (label ~= sup_cog(i+1,j))
            adj_mat(label, sup_cog(i+1,j)) = 1;
        end
        if (label ~= sup_cog(i+1,j+1))
            adj_mat(label, sup_cog(i+1,j+1)) = 1;
        end      
    end
end   
for i=1:h-1
    for j= w       
        label = sup_cog(i,j);        
        if (label ~= sup_cog(i,j-1))
            adj_mat(label, sup_cog(i,j-1)) = 1;
        end
        if (label ~= sup_cog(i+1,j))
            adj_mat(label, sup_cog(i+1,j)) = 1;
        end
        if (label ~= sup_cog(i+1,j-1))
            adj_mat(label, sup_cog(i+1,j-1)) = 1;
        end      
    end
end
for i=h
    for j= w       
        label = sup_cog(i,j);        
        if (label ~= sup_cog(i,j-1))
            adj_mat(label, sup_cog(i,j-1)) = 1;
        end
        if (label ~= sup_cog(i-1,j))
            adj_mat(label, sup_cog(i-1,j)) = 1;
        end
        if (label ~= sup_cog(i-1,j-1))
            adj_mat(label, sup_cog(i-1,j-1)) = 1;
        end      
    end
end
adj_mat = double((adj_mat + adj_mat')>0);