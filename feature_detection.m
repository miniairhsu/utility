clear all
function Ix = gradient_x(imgD)
  kernel_x = [1 0 -1; 2 0 -2; 1 0 -1];
  Ix = conv2(imgD, kernel_x, 'same');
end   

function Iy = gradient_y(imgD)
  kernel_y = [1 2 1; 0 0 0; -1 -2 -1];
  Iy = conv2(imgD, kernel_y, 'same');
end   

function [img, Ix, Iy] = sobel(imgD)
  for i=1:size(imgD,1)-2 #Y
    for j=1:size(imgD,2)-2 #X
        %Sobel mask for x-direction:
        Gx=((2*imgD(i+2,j+1)+imgD(i+2,j)+imgD(i+2,j+2))-(2*imgD(i,j+1)+imgD(i,j)+imgD(i,j+2)));
        %Sobel mask for y-direction:
        Gy=((2*imgD(i+1,j+2)+imgD(i,j+2)+imgD(i+2,j+2))-(2*imgD(i+1,j)+imgD(i,j)+imgD(i+2,j)));
        Ix(i,j) = Gx;
        Iy(i,j) = Gy;
        %The gradient of the image
        %B(i,j)=abs(Gx)+abs(Gy);
        img(i,j)=sqrt(Gx.^2+Gy.^2);
      
    end
  end
end

function [H,Ix,Iy] = harris(imgD)
  Ix = gradient_x(imgD);
  Iy = gradient_y(imgD);
  #harris operation
  Ixx = Ix.*Ix;
  Iyy = Iy.*Iy;
  Ixy = Ix.*Iy;
  #gaussian
  sigma=1.6;
  g = fspecial('gaussian',max(1,fix(6*sigma)), sigma); %%%%%% Gaussien Filter 
  Ix2 = conv2(Ixx, g, 'same');  
  Iy2 = conv2(Iyy, g, 'same');
  Ixy2 = conv2(Ixy, g,'same');
  k = 0.06;
  # determinant
  detA = Ix2.*Iy2 - Ixy2.*Ixy2;
  # trace
  traceA = Ix2 + Iy2;
  H = detA - k.*traceA.*2;
end

img=imread('operahouse.jpg');
imgGray=rgb2gray(img);
imgD=double(imgGray);
[H,Ix,Iy] = harris(imgD);
for j=1:size(imgD,1)-2
  for i=1:size(imgD,2)-2
    if H(j,i) > 50000000
      img(j,i,:) = [255 0 0];
    #elseif H(j,i) > 0
    #  img(j,i,:) = [0 255 0];
    end
  end  
end 

figure(1)
imshow(img);
title('Sobel gradient');
