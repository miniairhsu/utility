fruit   = rgb2gray(imread('fruit.jpg'));
feature = rgb2gray(imread('feature2.jpg'));
c = normxcorr2(feature, fruit);
figure, surf(c), shading flat
[ypeak, xpeak] = find(c==max(c(:)));
yoffSet = ypeak-size(feature,1);
xoffSet = xpeak-size(feature,2);
figure
result = fruit(yoffSet:yoffSet + 100, xoffSet:xoffSet + 100);
imshow(result);
# function not in octave
#imrect(gca, [xoffSet+1, yoffSet+1, size(feature,2), size(feature,1)]);