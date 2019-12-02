clear all
 
function octaves = gen_Octave(img,s, sigma)
  k = 2^(1.0/s);
  octaves(:,:,1) = img;
  for i = 1: (s+2)
    kernel = fspecial('log',[5 5], (k*(2^(i-1)))*sigma); #laplacian of gaussian
    octaves(:,:,i+1) = conv2(octaves(:,:,i), kernel, 'same');
  end 
end  

function octavesD = gen_DOG(octaves)
  n = size(octaves,3); #no of octaves
  for i = 2:n
    octavesD(:,:,i-1) = octaves(:,:,i-1) - octaves(:,:,i);
  end
end

function pyramid = gen_pyramid(img, level, s, sigma)
  pyramid = {};
  for i = 1:level #number of scales
    octaves = gen_Octave(imresize(img, 0.5^(i-1)),s, sigma);
    octavesD = gen_DOG(octaves);
    for j = 1:size(octavesD,3)
      pyramid(i,j) = octavesD(:,:,j);
    end
    octaves = [];
    octavesD = []; 
  end
end

function extrama = find_MinMax(pyramid) #w is kernel size / 2 
  extrama = {};
  for i = 1:size(pyramid,1) #number of scales
    local_extrama = zeros(size(cell2mat(pyramid(i,1)),1), size(cell2mat(pyramid(i,1)),2), size(pyramid,2)-2);
    for j = 2:size(pyramid,2)-1 #number of octaves 
      previous = cell2mat(pyramid(i,j-1));
      current = cell2mat(pyramid(i,j));
      next = cell2mat(pyramid(i,j+1));
      for row = 2 : size(current,1) - 2 
        for col = 2 : size(current,2) - 2
          local_extramaP = previous(row-1:row+1, col-1:col+1);
          local_extramaC = current(row-1:row+1, col-1:col+1);
          local_extramaN = next(row-1:row+1, col-1:col+1);
          [M2,I2] = max(local_extramaC(:));
          if(I2 == 5)
            if(M2 > max(local_extramaP(:)) && M2 > max(local_extramaN(:)))
              local_extrama(row, col, j-1) = 1;
            end 
          end 
          [M1,I1] = min(local_extramaC(:));
          if(I1 == 5)
            if(M1 < min(local_extramaP(:)) && M1 < min(local_extramaN(:)))
              local_extrama(row, col, j-1) = 1;
            end 
           end 
        end 
       end 
       extrama(i,j-1) = local_extrama(:,:, j-1);
      end 
    end
end 


img=imread('operahouse.jpg');
imgGray=rgb2gray(img);
imgD = double(imgGray);
pyramid = gen_pyramid(imgD, 4, 5, 0.707); #4 scales, 5 octaves
#octaves = gen_Octave(imgD,5,0.707);
#octavesD = gen_DOG(octaves);
#pry1 = octavesD;
#octave1 = octavesD(:,:,1);
#octave2 = octavesD(:,:,2);
#octave3 = octavesD(:,:,3);
#octaves2  = gen_Octave(imresize(imgD,0.5), 5, 0.6);
#octavesD2 = gen_DOG(octaves2);
#pry2 = octavesD2;

#octaves3  = gen_Octave(imresize(imgD,0.25), 5, 0.6);
#octavesD3 = gen_DOG(octaves3);
#pry3 = octavesD3;

#octaves4  = gen_Octave(imresize(imgD,0.125), 5, 0.6);
#octavesD4 = gen_DOG(octaves4);
#pry4 = octavesD4;
local_maxima = find_MinMax(pyramid);
minMax = cell2mat(local_maxima(1,4));
  
figure(1)
pry1 = cell2mat(pyramid(1,1));
imshow(uint8(minMax)*255);
figure(2)
imshow(uint8(pry1));
#figure(3)
#pry2 = cell2mat(pyramid(2,3));
#imshow(uint8(pry2));
#figure(4)
#pry3 = cell2mat(pyramid(2,4));
#imshow(uint8(pry3));














