%test

clear;clc;
img0=double(rgb2gray(imread('pic\lena512.jpg'))); 
[mm,nn]=size(img0);
z=0.1;
dx=8e-6;
lamda=5.32e-7;
x=linspace(-dx*nn/2,dx*nn/2,nn);
y=linspace(-dx*mm/2,dx*mm/2,mm);
[x,y]=meshgrid(x,y);
%A=ones(mm,nn);

p=zeros(mm,nn);
b=(1-img0/max(max(abs(img0))))/z;
for kk=1:nn
    b1=b(:,kk);
    p1 = qmr(@afun,b1);
    p(:,kk)=p1;
    kk
end

% obj=exp(1i.*p);
% [ du, img ] = angular_spectrum( dx, lamda, obj, z );
% figure; imshow(mat2gray(abs(img)));