%temp
clear;clc;
%%
img0=double(rgb2gray(imread('pic\lena512.jpg'))); 
[nx,ny]=size(img0);
lamda=5.32e-7;
%Specifying parameters
%nx=80;                           %Number of steps in space(x)
%ny=80;                           %Number of steps in space(y)       
niter=1000;                      %Number of iterations 
%dx=2/(nx-1);                     %Width of space step(x)
%dy=2/(ny-1);                     %Width of space step(y)
%x=-1:dx:1;                        %Range of x(0,2) and specifying the grid points
%y=-1:dy:1;                        %Range of y(0,2) and specifying the grid points
dx=16e-6; dy=dx;
x=linspace(-nx*dx/2,nx*dx/2,nx);
y=linspace(-ny*dy/2,ny*dy/2,ny);
b=zeros(nx,ny);                  %Preallocating b
pn=zeros(nx,ny);                 %Preallocating pn

%%
% Initial Conditions
p=zeros(nx,ny);                  %Preallocating p

%%
%Boundary conditions
p(:,1)=0;
p(:,ny)=0;
p(1,:)=0;                  
p(nx,:)=0;

%%
%Source term
% b(round(ny/4),round(nx/4))=3000;
% b(round(ny*3/4),round(nx*3/4))=-3000;
%b=img0/max(max(abs(img0)));
%b=b-mean(mean(b));
b=(1-img0/max(max(abs(img0))))/0.1;
b=b-mean(mean(b));

%%
i=2:nx-1;
j=2:ny-1;
%Explicit iterative scheme with C.D in space (5-point difference)
for it=1:niter
    pn=p;
    p(i,j)=((dy^2*(pn(i+1,j)+pn(i-1,j)))+(dx^2*(pn(i,j+1)+pn(i,j-1)))-(b(i,j)*dx^2*dy*2))/(2*(dx^2+dy^2));
    %Boundary conditions 
    p(:,1)=0;
    p(:,ny)=0;
    p(1,:)=0;                  
    p(nx,:)=0;
end

%%
[C] = Lap2_gra(p);
figure; imshow(mat2gray(abs(C)));
obj=exp(1i.*p);
[ du, img ] = angular_spectrum( dx, lamda, obj, 0.01 );
figure; imshow(mat2gray(abs(img)));
%Plotting the solution
% h=surf(x,y,p','EdgeColor','none');       
% shading interp
% axis([-2 2.5 -2 2.5 -100 100])
% title({'2-D Poisson equation';['{\itNumber of iterations} = ',num2str(it)]})
% xlabel('Spatial co-ordinate (x) \rightarrow')
% ylabel('{\leftarrow} Spatial co-ordinate (y)')
% zlabel('Solution profile (P) \rightarrow')