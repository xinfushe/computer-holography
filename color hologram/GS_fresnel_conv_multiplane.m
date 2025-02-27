function [b,obj_phi] = GS_fresnel_conv_multiplane(r,dx,dfx,zA,zB,zC);

%img0=double((imread('pic\lena1024.jpg')));
img0=double((imread('pic\colorSEU512.jpg')));
imgA=img0(:,:,1);%imgA=abs(imgA)/max(max(imgA)); figure;imshow((imgA));
imgB=img0(:,:,2);%imgB=abs(imgB)/max(max(imgB)); figure;imshow((imgB));
imgC=img0(:,:,3);%imgC=abs(imgC)/max(max(imgC)); figure;imshow((imgC));

%imgA=double((imread('pic\A512.jpg')));
%imgA=double_img(imgA);
%imgA=double_img(imgA);
%imgB=double((imread('pic\B512.jpg')));
%imgB=double_img(imgB);
%imgB=double_img(imgB);
%imgC=double((imread('pic\C512.jpg')));
%imgC=double_img(imgC);
%imgC=double_img(imgC);

dy=dx;
[mm,nn] = size(imgA);                %取分辨率

%{
for ii=1:mm;
    for jj=1:nn;
        if imgA(ii,jj)<50;
            imgA(ii,jj)=50;
        end
        if imgB(ii,jj)<50;
            imgB(ii,jj)=50;
        end
        if imgC(ii,jj)<50;
            imgC(ii,jj)=50;
        end
    end
end
%}

fienup=0;
obj_phi=rand(size(imgA));

b=1;
p=0;
t=[];
k=[];
for ii = 0:5                                         %迭代次数
    obj=b.*exp(1i.*obj_phi);     
    [img_A]=Fresnel_conv(obj,dx,dfx,r,zA);
    errorA(ii+1)=RMS(imgA,img_A);
    img_phi_A=angle(img_A);  
    img_A = imgA.*exp(1i.*img_phi_A);
    
    [obj_mid]=Fresnel_conv(img_A,dfx,dx,r,-zA);
    [img_B]=Fresnel_conv(obj_mid,dx,dfx,r,zB);
    errorB(ii+1)=RMS(imgB,img_B);
    img_phi_B=angle(img_B);      
    img_B = imgB.*exp(1i.*img_phi_B);
    
    [obj_mid]=Fresnel_conv(img_B,dfx,dx,r,-zB);
    [img_C]=Fresnel_conv(obj_mid,dx,dfx,r,zC);
    errorC(ii+1)=RMS(imgC,img_C);
    img_phi_C=angle(img_C);  
    img_C = imgC.*exp(1i.*img_phi_C);
    
    %[obj_mid]=Fresnel_conv(img_C,dfx,dx,r,-zC);
    %[img_B]=Fresnel_conv(obj_mid,dx,dfx,r,zB);
    %img_phi_B=angle(img_B);      
    %img_B = imgB.*exp(1i.*img_phi_B);
    
    %[obj_mid]=Fresnel_conv(img_B,dfx,dx,r,-zB);
    %[img_A]=Fresnel_conv(obj_mid,dx,dfx,r,zA);
    %img_phi_A=angle(img_A);      
    %img_A = imgA.*exp(1i.*img_phi_A);
    
    [obj]=Fresnel_conv(img_C,dfx,dx,r,-zC);
    obj_phi=angle(obj);
    b=avesqrt(abs(obj));
    k(ii+1)=ii;
    ii

end

errorA(1)=errorB(1);
save errorA.mat;
save errorB.mat;
save errorC.mat;
figure; plot(k,errorA,'b-',k,errorB,'o-',k,errorC,'x-');


obj=b.*exp(1i.*obj_phi);

[img_A]=Fresnel_conv(obj,dx,dfx,r,zA);
errorAa=RMS(imgA,abs(img_A))
[img_B]=Fresnel_conv(obj,dx,dfx,r,zB);
errorBb=RMS(imgB,abs(img_B))
[img_C]=Fresnel_conv(obj,dx,dfx,r,zC);
errorCc=RMS(imgC,abs(img_C))

img_A=abs(img_A).^2;
img_A=img_A/max(max(img_A));
figure; imshow((abs(img_A)));
img_B=abs(img_B).^2;
img_B=img_B/max(max(img_B));
figure; imshow((abs(img_B)));
img_C=abs(img_C).^2;
img_C=img_C/max(max(img_C));
figure; imshow((abs(img_C)));

img_rec(:,:,1)=img_A;
img_rec(:,:,2)=img_B;
img_rec(:,:,3)=img_C;
figure; imshow(abs(img_rec));

%{
%imwrite(uint8(abs(img_A)),'pic\A512_rec(a=1.25).jpg');
%imwrite(uint8(abs(img_B)),'pic\B512_rec(a=1.27).jpg');
%imwrite(uint8(abs(img_C)),'pic\C512_rec(a=1.30).jpg');

img_rec(:,:,1)=img_A;
img_rec(:,:,2)=img_B;
img_rec(:,:,3)=img_C;
figure; imshow(uint8(img_rec));
%imwrite(uint8(img_rec),'pic\colorABC512_rec2.jpg');
%}