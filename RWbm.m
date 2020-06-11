close all; clear; clc; clearvars;
ones = [-1,1];
n = 1.99e6;
%n = 1199;                      %different size n for presentation
%n = 119;
for l = 1:4
    for j = 1:n
        x(j) = 0;
    end
    for i = 1:n
        m = randi([1,2],1);
        Z = ones(m);            %chooses positive or negative one
        dx(i)=(Z/2);
        x(i+1) = x(i) + dx(i);
    end
    plot(x)
    hold on
end
grid on;
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0.05, 1, 0.95]);
