function [tp,fp,tn,fn,fplv,fnlv,abfplv,abfnlv,pcc,kappa,imw]=performance(imf,im3)
%性能指标评估函数
%tp：变化正检数；fp：错检数；tn：未变化正检数；fn：漏检数
%重要公式：tp+fn=Nc; tn+fp=Nu

%im3=double(im3(:,:,3));%伯尔尼、渥太华数据集
im3=double(im3(:,:,1));%黄河一号、黄河二号数据集
imf=double(imf);
[A,B]=size(im3);N=A*B;
Nu=0;Nc=0;
imw=zeros(A,B);%错误观察图
for i=1:A
    for j=1:B
        if im3(i,j)==0
            Nu=Nu+1;
        else
            Nc=Nc+1;
        end
    end
end
im=imf-im3;
fp=0;fn=0;
for i=1:A
    for j=1:B
        if im(i,j)>0
            fp=fp+1;
            imw(i,j)=0;%黑色代表错检
        elseif im(i,j)<0
            fn=fn+1;
            imw(i,j)=255;%白色代表漏检
        else
            imw(i,j)=128;%灰色代表无错误
        end
    end
end
imw=uint8(imw);
tp=Nc-fn;tn=Nu-fp;
fplv=fp/N;fnlv=fn/N;
abfplv=fp/Nu;abfnlv=fn/Nc;
pcc=1-fplv-fnlv;

%KAPPA系数
pra=(tp+tn)/N;pre=((tp+fp)*(tp+fn)+(fn+tn)*(fp+tn))/(N^2);
kappa=(pra-pre)/(1-pre);