% central difference method 

function [dy, ddy] = central_diff_1_2(y, dt)

n = length(y);
dy = zeros(1, n); % preallocate derivative vectors
ddy = zeros(1, n);
for i=2:n-1
    dy(i) = (y(i-1)+y(i+1))/2/dt;
    ddy(i) = (y(i+1)-2*y(i)+y(i-1))/dt^2;
end

end