img = imread('operahouse.jpg'); 
imgGrey = rgb2gray(img);
imgD = double(imgGrey);
[U2,S2,V2] = svd(imgD); #vector is columns of matrix

#reconstruct image from only 200 singular values
S2(200:size(S2,1),:) = 0; 
reconstimg = U2(:,1:200) * S2(1:200,:) * V2'; 

#color image
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
Rimg = cat(3, R, zeros(size(R)), zeros(size(R)));
Gimg = cat(3, zeros(size(G)), G, zeros(size(G)));
Bimg = cat(3, zeros(size(B)), zeros(size(B)), B);
figure(1)
subplot(2,2,1)
imshow(Rimg);
subplot(2,2,2)
imshow(Gimg);
subplot(2,2,3)
imshow(Bimg);

Red = double(R);
Green = double(G);
Blue = double(B);
N = 400;
#red reconstruction 
[Ur,Sr,Vr] = svd(Red);
Sr(N:size(Sr,1), :) = 0;
Dr = Ur(:,1:N) * Sr(1:N,:) * Vr';
reconstRed = cat(3, Dr, zeros(size(Dr)), zeros(size(Dr))); 
#green reconstruction
[Ug,Sg,Vg] = svd(Green);
Sg(N:size(Sg,1), :) = 0;
Dg = Ug(:,1:N) * Sg(1:N,:) * Vg';
reconstGreen = cat(3, zeros(size(Dg)), Dg, zeros(size(Dg)));
#blue reconstruction 
[Ub,Sb,Vb] = svd(Blue);
Sb(N:size(Sb,1), :) = 0;
Db = Ub(:,1:N) * Sb(1:N,:) * Vb';
reconstBlue = cat(3,zeros(size(Db)), zeros(size(Db)), Db);  

reconstImg = cat(3, Dr, Dg, Db);

figure(2)
subplot(2,2,1)
imshow(uint8(reconstRed));
subplot(2,2,2)
imshow(uint8(reconstGreen));
subplot(2,2,3)
imshow(uint8(reconstBlue));
subplot(2,2,4)
imshow(uint8(reconstImg));








