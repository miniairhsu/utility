clear 
A = [1 3 5; 5 4 1; 3 8 6] ;
covA = cov(A,1)

#function covariance = calculateCovariance(X)
#    meanX = mean(X);
#    [rows, cols] = size(X)
#    X = X - meanX
#    for c = 1:cols
#      for c2 = 1:cols
#        covariance(ros, cols) = dot(X(:,1), X(:,1))/rows
#      end 
#    end
#end

#function to center values by removing mean
function cntr =  center(X)
    cntr = X - mean(X); #mean calcuates mean value for each column
end 

#function to normalize all values 
function stdX = standardize(X)
    stdX = center(X)./std(X); #std calculates std for each column
end

#function to rotate covariance matrix
function decorrelated = decorrelate(X)
    newX = center(X);
    covX = cov(X,1);
    # Calculate the eigenvalues and eigenvectors of the covariance matrix
    #eigVals, eigVecs = np.linalg.eig(cov)
    # Apply the eigenvectors to X
    #decorrelated = X.dot(eigVecs)
    #return decorrelated
end
    
#uncorelated data 
sd = 1; #standard deviation
mean1 = 1; #mean
mean2 = 2; #mean
a1 = sd.*randn(300,1) + mean1;
a2 = sd.*randn(300,1) + mean2;
A1 = ([a1, a2]);
[rows, cols] = size(A1);

covA1 = cov(A1, 1);


#correlated 
b1 =  sd.*randn(300,1) + mean1;
b2 = b1 + sd.*randn(300,1) + mean2;
B = ([b1, b2])
covB = cov(B, 1);

BCentered = center(B)
figure(1)
subplot(2,2,1);
plot(BCentered(:,1));
title('BCentered 1');

subplot(2,2,2);
plot(BCentered(:,2));
title('BCentered 2');

subplot(2,2,3);
plot(B(:,1));
title('B 1');

subplot(2,2,4);
plot(B(:,2));
title('B 2');

#Guissian normalization random number
c1 = normrnd(3, 1, [300,1]) #normrnd(mean, sd, array)
c2 = (c1 + normrnd(7, 5, [300,1]))/2
C = [c1, c2]
figure(2)
subplot(2,1,1);
plot(C(:,1));
title('Nomrlized C1');

subplot(2,1,2);
plot(C(:,2));
title('Nomrlized C2');
covC = cov(C, 1);

#standardization, this pull all values to same scales
Cstd = standardize(C)
figure(3)
subplot(2,2,1);
plot(Cstd(:,1));
title('Nomrlized Cstd1');
subplot(2,2,2);
plot(Cstd(:,2));
title('Nomrlized Cstd2');
covCstd = cov(Cstd, 1);
subplot(2,2,3)
scatter(Cstd(:,1), Cstd(:,2))

#Whitening
Ccnt= center(C)
figure(4)
subplot(2,1,1);
plot(Ccnt(:,1));
title('Nomrlized Ccnt1');
subplot(2,1,2);
plot(Ccnt(:,2));
title('Nomrlized Ccnt2');
covCcnt = cov(Ccnt, 1);

























