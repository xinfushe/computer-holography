clc;clear;
% EI=double(rgb2gray(imread('E:\研究僧\课题\集成成像\傅里叶全息图\EI7200.bmp')));
% [M1,N1]=size(EI);
% OI=EI(ceil(M1/3)+1:ceil(M1*2/3),ceil(N1/3)+1:ceil(N1*2/3));
% figure;imshow(OI);
% img_all_amp=0;
% k=0;
% for i=1:1
%     k=k+1;
OI=double((imread('pic\EI1920teapot(xia).jpg')));
r=5.32e-7;     %波长
z=0.2;      %重建距离
%dx=8e-6;
dx=3.65e-6;
%dx=4e-6;
dfx=30e-6;
dy=dx;
[M,N]=size(OI);
seg_m=120;seg_n=120;
%seg_m=40;seg_n=40;
m=ceil(M/seg_m);n=ceil(N/seg_n);
% i=8;j=8;
% sub_image=zeros(seg_m,seg_n);
% img_phi=2*pi*rand(size(sub_image));
% sub_image=OI(1+(i-1)*seg_m:seg_m+(i-1)*seg_m,1+(j-1)*seg_n:seg_n+(j-1)*seg_n);
%modulation=ramspeckle(seg_m,seg_n,m,n);
%H=stereo_downsample(OI,seg_m,seg_n,m,n);
%H=stereo_GS(OI,seg_m,seg_n,m,n);
%H=stereo_GS_frft(OI,seg_m,seg_n,m,n,a,dx,r,fe);
%H=stereo_GS_sepcon(OI,seg_m,seg_n,m,n);
%H=stereo_GS2(OI,seg_m,seg_n,m,n,dx,dy,r,z);
H=stereo(OI,seg_m,seg_n,m,n);
%H=H.*modulation;
%H=stero_unidir_EDHOP(OI,seg_m,seg_n,m,n);
%H_zero=zeropading(seg_m,seg_n,m,n,10,10,H);
% h=H/max(max(abs(H))); 
% figure; imshow(abs(h));
%  H_amp=abs(H);
%  H_phi=angle(H);

 %for z=0.01:0.002:0.03
   [dfx,img]=fresnel_cov(dx,r,H,z);
    figure; imshow(abs(img/max(max(abs(img)))));
% end
% [dfx,img]=fresnel_cov(dx,r,H_zero,z);

