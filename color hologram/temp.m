
clc; clear;

img0=double((imread('pic\lena512.jpg')));
imgA=img0(:,:,1);imgA=double_img(imgA);
[mm,nn]=size(imgA);
rR=6.71e-7;
rG=5.32e-7;
rB=4.73e-7;
dx=8e-6;
dy=dx;
dfx=8e-6;
z=0.5;
originR1=[0,0];originR2=[0,512];
originG1=[0,0];originG2=[0,-512];
originB1=[0,0];originB2=[0,0];
for ii=1:mm
    for jj=1:nn
        phiRt(ii,jj)=pi*(jj/nn*0+ii/mm*100);
    end
end
%imgA=imgA.*exp(1i.*phiRt);
[objA]=shifted_fresnel_conv(imgA,dfx,dx,rR,-z,originB2,originB1);

obj=objA;
for ii=1:mm
    for jj=1:nn
        phiRt(ii,jj)=pi*(jj/nn*0+ii/mm*256);
    end
end
%obj=obj.*exp(1i.*phiRt);
[imgA]=shifted_fresnel_conv(obj,dx,dfx,rR,z,originB1,originB2);
imgA=imgA/max(max(abs(imgA)));
figure; imshow(abs(((imgA))));