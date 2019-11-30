clear all
 
function octaves = gen_Octave(img,s, sigma)
  k = 2^(1.0/s);
  kernel = fspecial('gaussian',max(1,fix(6*sigma)), k*sigma);
  octaves(:,:,1) = img;
  for i = 1: (s+2)
    octaves(:,:,i+1) = conv2(octaves(:,:,i), kernel, 'same');
  end 
end  
function octavesD = gen_DOG(octaves)
  n = size(octaves,3); #no of octaves
  for i = 2:n
    octavesD(:,:,i-1) = octaves(:,:,i) - octaves(:,:,i-1);
  end
end

img=imread('operahouse.jpg');
imgGray=rgb2gray(img);
imgD = double(imgGray);
octaves = gen_Octave(imgD,6,3);
octavesD = gen_DOG(octaves);
pry1 = octavesD;

octaves2  = gen_Octave(imresize(imgD,0.5), 5, 0.6);
octavesD2 = gen_DOG(octaves2);
pry2 = octavesD2;

octaves3  = gen_Octave(imresize(imgD,0.25), 5, 0.6);
octavesD3 = gen_DOG(octaves3);
pry3 = octavesD3;

octaves4  = gen_Octave(imresize(imgD,0.125), 5, 0.6);
octavesD4 = gen_DOG(octaves4);
pry4 = octavesD4;

  
figure(1)
imshow(pry4(:,:,1));
figure(2)
imshow(pry4(:,:,2));
figure(3)
imshow(pry4(:,:,3));



