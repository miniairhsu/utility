clear

function plotVectors(vecs)
    for i = 1 : length(vecs) #length is num of rows
        x = cat(1, [0,0], vecs(i,:))
        quiver(x(1),  #start x
               x(3),  #start y
               x(2),  #x direction
               x(4)); #y direction
        hold on
    end
end 

x = linspace(-1, 1, 100000);
y = sqrt(1-(x.^2));
figure(1)
subplot(2,2,1)
plot(x, y);
hold on 
plot(x, -y);
title('Original circle');

x1 = linspace(-3, 3, 100000);
y1 = 2*sqrt(1-((x1./3).^2));
subplot(2,2,2);
plot(x1, y1);
hold on 
plot(x1, -y1);
title('Transformed circle');

u = [1 0]
v = [0 1]
figure(2)
plotVectors([u; v])