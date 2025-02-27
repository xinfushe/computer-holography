% test for 3D angular spectrum
clear;clc;
%load letter16_256.mat;
%load dice.mat;
load earth256.mat;
%img0=letter16_256;
%img0=dice;
img0=earth;
%img0=ones(256,256,256);
img_phi=2*pi*rand(size(img0));
img0=img0.*exp(1i.*img_phi);
r=5.32e-7;
z=0.1;
dx=8e-6;
du=20e-6;
%dfx=1/dx/256;

phi_tx=-pi/2;
for phi_ty=0:pi/2:2*pi;  %��б��
tic
[obj]=angular_spectrum_3D2(img0,du,dx,r,-z,phi_tx,phi_ty);
%[obj]=angular_spectrum_3D(img0,dx,r,-z);
toc

%obj_phi=angle(obj);
%obj=exp(1i.*obj_phi);
%z=0.01
% for kk=1:16
     %[ du, img ] = angular_spectrum( dx, r, obj, z+dx*127 );
     %[img]=shifted_fresnel_conv(obj,dx,du,r,z,[0,0],[0,0]);  
     [duu,dvv, img ] = fresnel_cov(dx,dx, r, obj, z+dx*127);
     img=img/max(max(abs(img)));
figure; imshow(abs(img));
end
%     imwrite(abs(img),['pic\z=' num2str(kk) '.jpg']);
%     z=z+0.00024
% end