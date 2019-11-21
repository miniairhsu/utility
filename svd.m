clear

#plot vector from origin 
function plotVectors(vecs, color)
    v = vecs'
    for i = 1 : length(v) #length is num of rows
        x = cat(1, [0,0], v(i,:));
        quiver(x(1),  #start x
               x(3),  #start y
               x(2),  #x direction
               x(4),'Linewidth',4, color); #y direction
        grid on 
        hold on
    end
end 

#transform a unit vector by applying a matrix
function matrixToPlot(matrix, color)
    # Unit circle
    x = linspace(-1, 1, 100000);
    y = sqrt(1-(x.^2));

    # Modified unit circle (separate negative and positive parts)
    x1 = matrix(1,1).*x + matrix(1,2).*y;
    y1 = matrix(2,1)*x + matrix(2,2).*y;
    x1_neg = matrix(1,1).*x - matrix(1,2).*y;
    y1_neg = matrix(2,1).*x - matrix(2,2).*y;

    # Vectors
    u = [matrix(1,1),matrix(1,2)];
    v = [matrix(2,1),matrix(2,2)];

    plotVectors([u; v], color);

    plot(x1, y1, 'b','Linewidth',6 ,x1_neg, y1_neg, 'b','Linewidth',6);
    grid on 
end 

x = linspace(-1, 1, 100000);
y = sqrt(1-(x.^2));
figure(1)
subplot(2,2,1)
plot(x, y, 'b');
hold on 
plot(x, -y, 'b');
grid on
title('Original circle');

x1 = linspace(-3, 3, 100000);
y1 = 2*sqrt(1-((x1./3).^2));
subplot(2,2,2);
plot(x1, y1, 'b');
hold on 
plot(x1, -y1, 'b');
grid on 
title('Transformed circle');

#plot vectors
v = [1 0];
u = [0 2];
figure(2)
plotVectors([v; u], 'b')

#apply matrix transform to vector 
v1 = [3 7];
u1 = [5 2];
A = [v1; u1];
figure(3)
matrixToPlot(A, 'g');

#apply SVD decomposition
[U,S,V] = svd(A); #vector is columns of matrix
figure(4) 
matrixToPlot(V', 'g'); #apply rotation compoenent to unit vector

figure(5)
matrixToPlot(S*(V'), 'g'); #apply scaling to unit vector 

figure(6)
matrixToPlot((U')*S*(V'), 'g'); #apply rotation to unit vector 

u1 = [S(1)*U(1,1), S(4)*U(2,1)]; 
v1 = [S(1)*U(1,2), S(4)*U(2,2)];
plotVectors([u1; v1], 'r');

A1 = [7 2;3 4;5 3];
[U1,S1,V1] = svd(A1);

[VA,DA] = eig((A1')*A1); #right sigular vector V1 = eigen vector 
                         # of A'A 
[VA1,DA1] = eig(A1*(A1')); #VA = V1  
#singular values are sqrt of eigenvalues of A'A
sqrtDA = sqrt(DA) 

