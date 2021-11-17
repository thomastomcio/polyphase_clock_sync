clear; close all; clc;

rolloff = 0.2;
symbols = 6;
N1 = 2;
N2 = 32;
sps = N1*N2;

B = rcosdesign(rolloff, symbols, sps, 'sqrt');

figure(1);
plot(B, 'LineWidth',2,...
    'MarkerSize',2,...
    'MarkerEdgeColor','k');
hold on;
for n=1:5:15
   x = [n : N2 : length(B)];
   plot(x, B(n : N2 :end), 'o--', 'LineWidth', 2, 'MarkerSize', 8); 
   hold on;
end
legend(["h -> interpoloacja 32-krotnie", "h1 -> m = 1", "h5 -> m = 5", "h15 -> m=15"]);
title("Banków filtrów dopasowuj¹cych(koreluj¹cych)");

figure(2);
yref = diff(B);
plot(yref,... 
    'LineWidth',2,...
    'MarkerSize',2,...
    'MarkerEdgeColor','k');
hold on;
for n=1:5:15
   x = [n : N2 : length(B)];
   y = yref(n : N2 : end);
   plot(x(1:length(y)), y, 'o--', 'LineWidth', 2, 'MarkerSize', 8); 
   hold on;
end
legend(["h -> interpoloacja 32-krotnie", "h1 -> m = 1", "h5 -> m = 5", "h15 -> m=15"]);
title("Banków filtrów pochodnych");

