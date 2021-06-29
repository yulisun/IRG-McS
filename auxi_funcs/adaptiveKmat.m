function [Kmat] = adaptiveKmat(X_library,X,Y_library,Y,kmax,kmin)
X = X';
Y = Y';
X_library = X_library';
Y_library = Y_library';
kmax = kmax+1;
[idx, distX] = knnsearch(X_library,X,'k',kmax);
[idy, distY] = knnsearch(Y_library,Y,'k',kmax);
[N,Dx] = size(X);
[~,Dy] = size(Y);
degree_x = tabulate(idx(:));
degree_y = tabulate(idy(:));
Kmat_x = degree_x(:,2);
Kmat_x(Kmat_x>=kmax)=kmax;
Kmat_x(Kmat_x<=kmin)=kmin;
if length(Kmat_x)<N
    Kmat_x(length(Kmat_x)+1:N) = kmin;
end
Kmat_y = degree_y(:,2);
Kmat_y(Kmat_y>=kmax)=kmax;
Kmat_y(Kmat_y<=kmin)=kmin;
if length(Kmat_y)<N
    Kmat_y(length(Kmat_y)+1:N) = kmin;
end
Kmat = min(Kmat_x,Kmat_y);