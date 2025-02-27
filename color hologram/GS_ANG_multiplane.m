function [b,obj_phi] = GS_ANG_multiplane(r,dx,zA,zB,zC);

img0=double((imread('pic\lena512.jpg')));
%img0=double((imread('pic\colorSEU512.jpg')));
imgA=img0(:,:,1); %figure;imshow(uint8(imgA));
imgB=img0(:,:,2); %figure;imshow(uint8(imgB));
imgC=img0(:,:,3); %figure;imshow(uint8(imgC));

%imgA=double(rgb2gray(imread('pic\lena1024.jpg')));
%imgB=double(rgb2gray(imread('pic\lena1024.jpg')));
%imgC=double(rgb2gray(imread('pic\lena1024.jpg')));

imgA=double_img(imgA);
imgB=double_img(imgB);
imgC=double_img(imgC);
%imgA=abs(imgA)/max(max(imgA));
%imgB=abs(imgB)/max(max(imgB));
%imgC=abs(imgC)/max(max(imgC));


[mm,nn] = size(imgA);                %取分辨率

%for ii=1:mm;
%    for jj=1:nn;
%        if imgA(ii,jj)<20;
%            imgA(ii,jj)=20;
%        end
%        if imgB(ii,jj)<20;
%            imgB(ii,jj)=20;
%        end
%        if imgC(ii,jj)<20;
%            imgC(ii,jj)=20;
%        end
%    end
%end

obj_phi=2*pi*rand(size(imgA));

b=1;
p=0;
t=[];
k=[];
for ii = 0:16                                         %迭代次数
    obj = b.*exp(1i.*obj_phi);
    [ du, img_C ] = angular_spectrum( dx, r, obj, zC );
    errorC(ii+1)=RMS(imgC,img_C);
    img_phi_C=angle(img_C);      
    img_C = imgC.*exp(1i.*img_phi_C);
    
    [ du, img_B ] = angular_spectrum( dx, r, img_C, (zB-zC) );
    errorB(ii+1)=RMS(imgB,img_B);
    img_phi_B=angle(img_B);      
    img_B = imgB.*exp(1i.*img_phi_B);
    
    %[ du, img_C ] = angular_spectrum( dx, r, img_B, (zC-zB) );
    %errorC(ii+1)=RMS(imgC,img_C);
    %img_phi_C=angle(img_C);   
    %img_C=imgC.*exp(1i.*img_phi_C); 
    
    [ du, img_A ] = angular_spectrum( dx, r, img_B, (zA-zB) );
    errorA(ii+1)=RMS(imgA,img_A);
    img_phi_A=angle(img_A);   
    img_A=imgA.*exp(1i.*img_phi_A); 
    
    %[ du, img_B ] = angular_spectrum( dx, r, img_A, (zB-zA) );
    %errorB(ii+1)=RMS(imgB,img_B);
    %img_phi_B=angle(img_B);      
    %img_B = imgB.*exp(1i.*img_phi_B);
    
    %[ du, img_A ] = angular_spectrum( dx, r, obj, zA );
    %img_phi_A=angle(img_A);      
    %img_A = imgA.*exp(1i.*img_phi_A);
    
    %[ du, img_B ] = angular_spectrum( dx, r, img_A, (zB-zA) );
    %img_phi_B=angle(img_B);      
    %img_B = imgB.*exp(1i.*img_phi_B);
    
    [ du, obj ] = angular_spectrum( dx, r, img_A, -zA );
    obj_phi=angle(obj); 
    b=avesqrt(abs(obj)); 
    k(ii+1)=ii;
    ii

end

%errorA(1)=errorB(1);
save errorA.mat;
save errorB.mat;
save errorC.mat;
figure; plot(k,errorA,'b-',k,errorB,'o-',k,errorC,'x-');

obj=b.*exp(1i.*obj_phi);

[ du, img_A ] = angular_spectrum( dx, r, obj, zA );
[ du, img_B ] = angular_spectrum( dx, r, obj, zB );
[ du, img_C ] = angular_spectrum( dx, r, obj, zC );

img_A=abs(img_A)/max(max(abs(img_A)));
figure; imshow((abs(img_A)));
img_B=abs(img_B)/max(max(abs(img_B)));
figure; imshow((abs(img_B)));
img_C=abs(img_C)/max(max(abs(img_C)));
figure; imshow((abs(img_C)));

%imwrite(uint8(abs(img_A)),'pic\A512_rec(a=1.25).jpg');
%imwrite(uint8(abs(img_B)),'pic\B512_rec(a=1.27).jpg');
%imwrite(uint8(abs(img_C)),'pic\C512_rec(a=1.30).jpg');

img_rec(:,:,1)=abs(img_A);
img_rec(:,:,2)=abs(img_B);
img_rec(:,:,3)=abs(img_C);
figure; imshow((img_rec));
%imwrite((img_rec),'pic\lena512_rec2.jpg');
