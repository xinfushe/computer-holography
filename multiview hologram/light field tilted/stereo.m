function stereogram=stereo(image,seg_m,seg_n,m,n)
b=1;
%modulation=ramspeckle(seg_m,seg_n,m,n);
%img_phi=1.5*pi*rand(seg_m,seg_n);
for i=1:m
    for j=1:n
% i=8;j=8;stereogram=zeros(m*seg_m,n*seg_n);
        sub_image=zeros(seg_m,seg_n);
        img_phi=1.5*pi*rand(size(sub_image));
        sub_image=image(1+(i-1)*seg_m:seg_m+(i-1)*seg_m,1+(j-1)*seg_n:seg_n+(j-1)*seg_n);
        sub_h=fftshift(ifft2(fftshift(sub_image.*exp(1i.*img_phi))));
        %sub_h=fftshift(fft2(fftshift(sub_image.*modulation(1+(i-1)*seg_m:seg_m+(i-1)*seg_m,1+(j-1)*seg_n:seg_n+(j-1)*seg_n))));
        stereogram(1+(i-1)*seg_m:seg_m+(i-1)*seg_m,1+(j-1)*seg_n:seg_n+(j-1)*seg_n)=sub_h;
        %imwrite(mat2gray(abs(sub_image)),['wallsub\' num2str((i-1)*n+j) '.jpg']);
    end
end