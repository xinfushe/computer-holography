
% color_LCOS

clear; clc;
img0=double(rgb2gray(imread('pic\ABC256.jpg')));
img0=enlarge_anysize(img0,960,2400);

[mm,nn]=size(img0);
lamda=5.32e-7;
dx=8e-6;
dy=8e-6;
%dfx=120e-6;
%dfy=dfx;
z=0.1;
obj_phi=2*pi*rand(size(img0));
[mm,nn]=size(img0);

%% double phase
%%
for a=2.5386           %12um,1.693;   8um,2.5386;   6um,3.3830
obj=fftshift(ifft2(fftshift(img0)));    
%[ du, obj ] = angular_spectrum( dx, lamda, img0, -z );
%[ du,dv, obj ] = angular_spectrum_mn( dx,dy, lamda, img0, -z );
thetadp=a*pi/180;
phi_dp=zeros(mm,nn);
for ii=1:mm
    for jj=1:nn
        phi_dp(ii,jj)=(jj)*dx*tan(thetadp)*2*pi/lamda+(ii)*dy*tan(0)*2*pi/lamda;
    end
end
obj=obj.*exp(-1i.*phi_dp);
phi=angle(obj);
M1=(checkerboard(1,mm/2,nn/2)>0.5);
M2=~M1;
Amax=max(max(abs(obj)));
theta1=phi+acos(abs(obj)/Amax);
theta2=phi-acos(abs(obj)/Amax);
phi_syn1=M1.*theta1+M2.*theta2;
end
%%  down sampling
%phi_syn1=angle(exp(1i.*phi_syn1));
phi_syn1=mod(phi_syn1,2*pi);
phi_syn=zeros(960,1200);
for ii=1:2:959
    for jj=1:1200
        phi_syn(ii,jj)=phi_syn1(ii,2*jj);
        phi_syn(ii+1,jj)=phi_syn1(ii+1,2*jj-1);
    end
end

%% LCOS像素合成

%phi_syn=(phi_syn)*255/2/pi;
% phi_syn=enlarge_anysize(phi_syn,600,800);
%phi_syn(phi_syn>=0&phi_syn<=pi/2)=90; phi_syn(phi_syn>pi/2&phi_syn<=3*pi/2)=250; phi_syn(phi_syn>3*pi/2&phi_syn<=2*pi)=90;
phi_syn=(255-90)*(phi_syn)/(2*pi*200/360)+90;   %归一化到[90-255]
phi_syn(phi_syn>255&phi_syn<=321)=255;  phi_syn(phi_syn>321)=90; 
phi_synR=zeros(480,800); phi_synG=zeros(480,800); phi_synB=zeros(480,800);
for ii=1:480
    for jj=1:2:799
        phi_synG(ii,jj)=phi_syn(2*ii-1,1+(jj-1)/2*3);
        phi_synG(ii,jj+1)=phi_syn(2*ii,3+(jj-1)/2*3);
        phi_synR(ii,jj)=phi_syn(2*ii,2+(jj-1)/2*3);
        phi_synR(ii,jj+1)=phi_syn(2*ii-1,3+(jj-1)/2*3);
        phi_synB(ii,jj)=phi_syn(2*ii,1+(jj-1)/2*3);
        phi_synB(ii,jj+1)=phi_syn(2*ii-1,2+(jj-1)/2*3);
    end
end
phi_synR2=enlarge_anysize(phi_synR,600,800); %phi_synR2=(phi_synR2+pi)*255/2/pi;
phi_synG2=enlarge_anysize(phi_synG,600,800); %phi_synG2=(phi_synG2+pi)*255/2/pi;
phi_synB2=enlarge_anysize(phi_synB,600,800); %phi_synB2=(phi_synB2+pi)*255/2/pi;
phi_syn2(:,:,1)=phi_synR2;
phi_syn2(:,:,2)=phi_synG2;
phi_syn2(:,:,3)=phi_synB2;

imwrite(uint8(phi_syn2),['pic\color LCOS\ABC1200960_DP_FFT(binary).bmp']);
%imwrite(uint8(phi_syn2),['pic\color LCOS\ABCD_GS_FFT(90_255).bmp']);

%% 仿真重建
%% 仿真重建
obj2=exp(1i.*phi_syn1).*exp(1i.*phi_dp);
obj_fft=fftshift(fft2(fftshift(obj2)));
figure; imshow(mat2gray(abs(obj_fft)));
mask=zeros(mm,nn);
mask(179:334,179:334)=1;
obj2=fftshift(ifft2(fftshift(obj_fft.*mask)));
[ du, img ] = angular_spectrum( dx, lamda, obj2, z );
%[ du,dv, img ] = angular_spectrum_mn( dx,dy, lamda, obj2, z );
figure; imshow(mat2gray(abs(img)));
figure; imshow((angle(img)+pi)/2/pi);
