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

function pyramid = gen_pyramid(img, level, s, sigma)
  pyramid = {};
  for i = 1:level #number of scales
    octaves = gen_Octave(imresize(img, 0.5^(i)),s, sigma);
    octavesD = gen_DOG(octaves);
    for j = 1:size(octavesD,3)
      pyramid(i,j) = octavesD(:,:,j);
    end
    octaves = [];
    octavesD = []; 
  end
end

function extrama = find_MinMax(pyramid, w) #w is kernel size / 2 
  
  for i = 1:size(pyramid,1) #number of scales
    for j = 2:size(pyramid,2)-1 #number of octaves 
      previous = cell2mat(pyramid(i,j-1);
      current = cell2mat(pyramid(i,j);
      next = cell2mat(pyramid(i,j+1);
      for row = 3 : size(current,1) - 3 
        for col = 3 : size(current,2) - 3
        end 
      end 
  end 
end


img=imread('operahouse.jpg');
imgGray=rgb2gray(img);
imgD = double(imgGray);
pyramid = gen_pyramid(imgD, 4, 5, 1.6); #4 scales, 5 octaves
#octaves = gen_Octave(imgD,6,3);
#octavesD = gen_DOG(octaves);
#pry1 = octavesD;

#octaves2  = gen_Octave(imresize(imgD,0.5), 5, 0.6);
#octavesD2 = gen_DOG(octaves2);
#pry2 = octavesD2;

#octaves3  = gen_Octave(imresize(imgD,0.25), 5, 0.6);
#octavesD3 = gen_DOG(octaves3);
#pry3 = octavesD3;

#octaves4  = gen_Octave(imresize(imgD,0.125), 5, 0.6);
#octavesD4 = gen_DOG(octaves4);
#pry4 = octavesD4;
[local_maxima, local_minima] = find_MinMax(pyramid);
  
figure(1)
pry1 = cell2mat(pyramid(2,1));
imshow(uint8(pry1));
figure(2)
pry1 = cell2mat(pyramid(2,2));
imshow(uint8(pry1));
figure(3)
pry2 = cell2mat(pyramid(2,3));
imshow(uint8(pry2));
figure(4)
pry3 = cell2mat(pyramid(2,4));
imshow(uint8(pry3));














