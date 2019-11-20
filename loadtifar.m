clear

#convert array to image
# @param X      : input images
# @return im    : output image
# @return imflat: original array
function im, imflat = cnvtImage(X)
  R=X(1:1024);
  G=X(1025:2048);
  B=X(2049:3072);
  im = zeros(32,32,3);
  k = 1;
  for x=1:32
    for i=1:32
      im(x,i,1)=R(k);
      im(x,i,2)=G(k);
      im(x,i,3)=B(k);
      k=k+1;
      end
  end 
  imflat = X
  im=uint8(im)
  #image(im)
end

#caculate mean values of image 
# @param X   : input images
# @param num : no of images
# @return mean over num images 
function imMean = calMean(X, num) 
  imMean = mean(X(1:num,:));
end 

#caculate mean values of image 
# @param X   : input images
# @return normalize and mean substracted image
function normMean = calNormMean(X, num)
  normMean = double(X(1:num,:)) / 255;
  normMean = normMean - calMean(normMean, num);
end 



#loading tiny image dataset 
load('data_batch_1.mat')
im=zeros(32,32,3);
#for cpt=1:10 
#    R=data(cpt,1:1024);
#    G=data(cpt,1025:2048);
#    B=data(cpt,2049:3072);
#    k=1;
#    for x=1:32
#      for i=1:32
#        im(x,i,1)=R(k);
#        im(x,i,2)=G(k);
#        im(x,i,3)=B(k);
#        k=k+1;
#      end
#    end  
#    im=uint8(im);
#    imwrite(im,strcat('img',int2str(cpt),'.png'),'png'); 
#end
#im, imflat = cnvtImage(data(12,:))
#imNorm = double(im) / 255
#imflatNorm = double(imflat) / 255;
#imflatNorm = imflatNorm - mean(imflatNorm)
#imshow(im)
num = 2000;
imNormal = calNormMean(data,num);
imNormal = imNormal';
covImg = cov(imNormal, 1);
[U,S,V] = svd(covImg);
epsilon = 0.1;
S = diag(1.0 ./sqrt(diag(S) + epsilon));
X_ZCA = U*S*U'*imNormal';
#newX_ZCA = cnvtImage(X_ZCA(12,:)*255);
X_ZCA_rescaled = (X_ZCA - nanmin(X_ZCA));
X_ZCA_rescaled = X_ZCA_rescaled ./ (nanmax(X_ZCA) - nanmin(X_ZCA));
newX_ZCA_rescaled, X_ZCA_rescaled = cnvtImage(X_ZCA_rescaled(2,:)*255);
imshow(newX_ZCA_rescaled);





















