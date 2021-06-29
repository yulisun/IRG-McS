function [fx,fy] = CalculateChangeLevel(X_library,X,Y_library,Y,Kmat)
X = X';
Y = Y';
X_library = X_library';
Y_library = Y_library';
kmax = max(Kmat)+1;
[idx, distX] = knnsearch(X_library,X,'k',kmax);
[idy, distY] = knnsearch(Y_library,Y,'k',kmax);
[N,Dx] = size(X);
[~,Dy] = size(Y);
%% Calculate ChangeLevel
fx = zeros(N,1);
fy = fx;
for i = 1:N
    k = Kmat(i);
    di_x = distX(i,2:k).^2;
    id_x = idx(i,2:k);
    di_y = distY(i,2:k).^2;
    id_y = idy(i,2:k);
    di_x_y = pdist2(X_library(idy(i,2:k),:),X(i,:)).^2;
    di_y_x = pdist2(Y_library(idx(i,2:k),:),Y(i,:)).^2;
    fx(i) = abs(mean(di_x)-mean(di_x_y));
    fy(i) = abs(mean(di_y)-mean(di_y_x));
end
