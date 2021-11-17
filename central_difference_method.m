% central difference method 

f = @(x) cosh(x);
h = 0.01;
x = -4:h:4;   % this way, you define the desired step size, h, and use it to calculate the x vector
              % to change the resolution, simply change the value of h
% x = linspace(-4,4,9);
n = length(x);
y=f(x);
dy = zeros(n,1); % preallocate derivative vectors
ddy = zeros(n,1);
for i=2:n-1
    dy(i) = (y(i-1)+y(i+1))/2/h;
    ddy(i) = (y(i+1)-2*y(i)+y(i-1))/h^2;
end

% Now when you plot the derivatives, skip the first and the last point
figure;
plot(x,y,'r');
hold on;
plot(x(2:end-1), dy(2:end-1),'b');
plot(x(2:end-1), ddy(2:end-1), 'g');
grid on;
legend('y', 'dy', 'ddy');