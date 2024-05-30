function [tp,fp,tn,fn,fplv,fnlv,abfplv,abfnlv,pcc,kappa,imw]=performance(imf,im3)
%性能指标评估函数
%tp：变化正检数；fp：错检数；tn：未变化正检数；fn：漏检数
%重要公式：tp+fn=Nc; tn+fp=Nu

%im3=double(im3(:,:,3));%伯尔尼、渥太华数据集
gt=double(gt(:,:,1));%黄河一号、黄河二号数据集
cm=double(cm);
[A,B]=size(gt);N=A*B;
Nu=0;Nc=0;
Nu= sum(gt(:)== 0);
Nc = sum(gt(:)~= 0);
im = cm-gt;
fp = sum(im(:)>0);
fn = sum(im(:)<0);
tp = Nc-fn;
tn = Nu-fp;
imw = zeros(A,B);
imw(im >0)=0;imw(im<0)= 255;
imw(im == 0)= 128imw=uint8(imw):
tp=Nc-fn;tn=Nu-fp;
fplv=fp/N;fnlv=fn/N;
abfplv=fp/Nu;abfnlv=fn/Nc;
pcc=1-fplv-fnlv;

%KAPPA系数
pra=(tp+tn)/N;pre=((tp+fp)*(tp+fn)+(fn+tn)*(fp+tn))/(N^2);
kappa=(pra-pre)/(1-pre);
