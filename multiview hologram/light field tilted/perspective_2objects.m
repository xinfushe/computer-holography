% Fresnel holography using perspective

clear;clc;

D=60e-3;%ֱ��
F=180e-3;%����  f-num=4
lens_d=1e-3;%΢͸��ֱ��
lens_f=3e-3;%΢͸������
micr_N=16;%΢͸������
m=120;n=120;%��m,n��Ϊÿ��СEIͼ�������
M=m*micr_N; N=n*micr_N; %��EIͼ������ظ���
%dx=8e-6; dy=dx;

obj1=double(rgb2gray(imread('pic\teapot512.jpg')));
obj2=double(rgb2gray(imread('pic\wall512.jpg')));
depth1=double(rgb2gray(imread('pic\teapot_depth.jpg')));
depth2=double(rgb2gray(imread('pic\wall_depth.jpg')));
d1=0.05;
d2=0.08;
obj1=imresize(obj1,[m,n]); 
depth1=imresize(depth1,[m,n]); 
[m1,n1]=size(obj1);
obj2=enlarge_anysize(obj2,floor(m1*d2/d1),floor(n1*d2/d1));
depth2=enlarge_anysize(depth2,floor(m1*d2/d1),floor(n1*d2/d1));
obj2=imresize(obj2,[m,n]);
depth2=imresize(depth2,[m,n]);
dfx1=lens_d*d1/lens_f/n; dfy1=lens_d*d1/lens_f/m; 
dfx2=lens_d*d2/lens_f/n; dfy2=lens_d*d2/lens_f/m; 

EI_total=zeros(M,N);
for ii=1:micr_N
    for jj=1:micr_N
        se=translate(strel(1),[floor(-(ii-micr_N/2)*lens_d/dfy1) floor(-(jj-micr_N/2)*lens_d/dfx1)]);
        EI1=imdilate(obj1,se);
        EI1(EI1==-inf)=0;
        EI1_depth=imdilate(depth1,se);
        EI1_depth(EI1_depth==-inf)=0;
        
        se=translate(strel(1),[floor(-(ii-micr_N/2)*lens_d/dfy2) floor(-(jj-micr_N/2)*lens_d/dfx2)]);
        EI2=imdilate(obj2,se);
        EI2(EI2==-inf)=0;
        EI2_depth=imdilate(depth2,se);
        EI2_depth(EI2_depth==-inf)=0;
        
        mask=zeros(m,n);
        mask(EI1>10)=1;
        EI_total((1+(ii-1)*m):ii*m,(1+(jj-1)*n):jj*n)=EI2.*(~mask)+EI1.*mask;
    end
    ii
end