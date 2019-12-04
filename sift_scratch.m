clear all
 
function octaves = gen_Octave(img,s, sigma)
  k = 2^(1.0/s);
  kernel = fspecial('gaussian',[1,floor(6*sigma)], sigma); #laplacian of gaussian
  for i = 2: (s+2) 
    #kernel = fspecial('log',[5 5], (k*(2^(i-1)))*sigma); #laplacian of gaussian
    kernel = fspecial('log',[5 5], (k^(i-1))*sigma); #laplacian of gaussian
    octaves(:,:,i) = conv2(octaves(:,:,i-1), kernel, 'same');
  end 
end  

function octavesD = gen_DOG(octaves)
  n = size(octaves,3); #no of octaves
  for i = 2:n
    octavesD(:,:,i-1) = octaves(:,:,i-1) - octaves(:,:,i);
  end
end

function pyramid = gen_pyramid(img, octaves, scales, sigma0)
  pyramid = {};
  tempImg = img;
  k = 2^(1.0/scales);
  for i = 1:octaves
    L1 =tempImg;
    temp_D = zeros(size(L1,1), size(L1,2), scales);
    for j = 1:scales
      scale = sigma0*k^((i-1)*scales+j);
      kernel=fspecial('gaussian',[1,floor(6*scale)],scale);
      #scale = sigma0*(k^(j-1));
      #kernel = fspecial('log', [5 5], scale);
      L2=conv2(L1, kernel, 'same');
      L2=conv2(L2,kernel','same');
      temp_D(:,:,j) = L2 - L1;
      pyramid(i,j) = temp_D(:,:,j);
      if(j == scales)
        tempImg=tempImg(1:2:end,1:2:end);
        tempImg=padarray(tempImg,[1,1],'both','replicate');
        #tempImg = imresize(tempImg, 0.5^i);
        #figure(i);
        #imshow(uint8(255 * mat2gray(temp_D(:,:,j))));
      end 
     end
   end 
end 


function extrama = find_MinMax(pyramid) #w is kernel size / 2 
  extrama = {};
  for i = 1:size(pyramid,1) #number of scales
    local_extrama = zeros(size(cell2mat(pyramid(i,1)),1), size(cell2mat(pyramid(i,1)),2), size(pyramid,2));
    #local_extrama = zeros(size(cell2mat(pyramid(i,1)),1), size(cell2mat(pyramid(i,1)),2));
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
              #local_extrama(row, col) = 1;
            end 
          end 
          [M1,I1] = min(local_extramaC(:));
          if(I1 == 5)
            if(M1 < min(local_extramaP(:)) && M1 < min(local_extramaN(:)))
              local_extrama(row, col, j-1) = 1;
              #local_extrama(row, col) = 1;
            end 
          end 
         end 
       end 
       extrama(i,j-1) = local_extrama(:,:, j-1);
      end 
    end
end 

function keypoints = find_KeyPoint(pyramid, extrema, threshold)
  keypoints = {};
  for i = 1:size(extrema, 1) #octaves 
    for j = 1:size(extrema, 2)
      candidates = cell2mat(extrema(i, j));
      img = cell2mat(pyramid(i,j));
      contrast = (max(img(:)) - min(img(:)))/(max(img(:)) + min(img(:)))
      [y,x] = find(candidates);
      numtimes = size(find(candidates));
      for k=1:numtimes
        y1 = y(k);
        x1 = x(k);
        rx = x1 + 1;
        ry = y1 + 1;
        if(abs(img(y1,x1)) < abs(contrast))
          candidates(y1,x1) = 0;
        else 
          fxx = img(y1,x-1)+img(y1,x+1)-2*img(y1,x1);
          fyy = img(y1-1,x1)+img(y1+1,x1)-2*img(y1,x1);
          fxy = img(y1-1,x1-1)+img(y1+1,x1+1)-img(y1+1,x1-1)-img(y1-1,x1+1);
          trace = fxx+fyy;
          det = fxx.*fyy-fxy.*fxy;
          if(det != 0)
            curvature = trace.*trace/det;
            curvature_threshold = 15; #over threshold value is both eigenvalues are too different, this is edge 
            if(det < 0 || curvature > curvature_threshold)
              candidates(y1,x1) = 0;
            end
           end
          end  
       end
       keypoints(i,j) = candidates; 
      end 
   end 
end
#function keypoints = find_KeyPoint(extrema, threshold)
#  keypoints = {};
#  for i = 1:size(extrema,1) #scales
#    for j = 2:size(extrema,2) #octaves
#      minMaxP = cell2mat(extrema(i,j-1));
#      minMaxC = cell2mat(extrema(i,j));
#      minMaxN = cell2mat(extrema(i,j+1));
#      for y = 2:size(minMaxC,1)
#        for x = 2:size(minMaxC,2)
#          if(minMax(y,x) > 0)
#             dx = (minMaxC(y,x+1) - minMaxC(y,x-1)) * 0.5;
#             dy = (minMaxC(y+1,x) - minMaxC(y-1,x)) * 0.5;  
#             ds = minMaxN(y,x) - minMaxP(y,x);
#             dxx = minMaxC(y,x+1) + minMaxC(y,x-1) - 2*minMaxC(y,x);
#             dyy = minMaxC(y+1,x) + minMaxC(y-1,x) - 2*minMaxC(y,x);
#             dss = minMaxN(y,x) + minMaxP(y,x) - 2*minMaxC(y,x);
#             dxy = (minMaxC(y+1,x+1) - minMaxC(y+1,x-1) - minMaxC(y-1,x+1) + minMaxC(y-1,x-1)) * 0.25
#             dxs = (minMaxN(y,x+1) - minMaxN(y,x-1) - minMaxP(y,x+1) + minMaxP(y,x-1))*0.25;  
#             dys = (minMaxN(y+1,x) - minMaxN(y-1,x) - minMaxP(y+1,x) + minMaxP(y-1,x))*0.25;
#           end 
#         end 
#       end 
#      end   
#    end 
#end 


img=imread('building2.jpg');
imgGray=rgb2gray(img);
imgD = double(imgGray);
pyramid = gen_pyramid(imgD, 4, 7, 1.6); #4 scales, 5 octaves
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
extrema = find_MinMax(pyramid);
minMax = cell2mat(extrema(1,2));
keypoints = find_KeyPoint(pyramid, extrema,150);
keypoint = cell2mat(keypoints(1,3));
for i = 1:size(img,1)
  for j = 1:size(img, 2)
    if( keypoint(i,j) > 0)
      img(i,j,:) = [255 0 0];
    end 
  end 
end 


figure(1)
imshow(img);












