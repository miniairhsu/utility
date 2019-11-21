clear

#plot vector from origin 
function plotVectors(vecs)
    for i = 1 : length(vecs) #length is num of rows
        x = cat(1, [0,0], vecs(i,:))
        quiver(x(1),  #start x
               x(3),  #start y
               x(2),  #x direction
               x(4),'Linewidth',6); #y direction
        grid on 
        hold on
    end
end 

#transform a unit vector by applying a matrix
function matrixToPlot(matrix)
    # Unit circle
    x = linspace(-1, 1, 100000);
    y = sqrt(1-(x.^2));

    # Modified unit circle (separate negative and positive parts)
    x1 = matrix(1,1).*x + matrix(1,2).*y;
    y1 = matrix(2,1).*x + matrix(2,2).*y;
    x1_neg = matrix(1,1).*x - matrix(1,2).*y;
    y1_neg = matrix(2,1).*x - matrix(2,2).*y;

    # Vectors
    u1 = [matrix(1,1),matrix(2,1)];
    v1 = [matrix(1,2),matrix(2,2)];

    plotVectors([u1; v1]);

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

u = [1 0]
v = [0 1]
figure(2)
plotVectors([u; v])

u1 = [3 7];
v1 = [5 2];
A = [u1; v1];
figure(3)
matrixToPlot(A);




