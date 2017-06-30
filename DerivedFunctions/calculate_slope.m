function slope = calculate_slope(x,y)





num_x = length(x);
num_y = length(y);
if num_x == num_y
    slope = zeros(num_x,1);
    for idx = 1:num_x
        switch idx
            case 1
                slope(idx) = (y(idx+1)-y(idx))/(x(idx+1)-x(idx));
            case num_x
                slope(idx) = (y(idx)-y(idx-1))/(x(idx)-x(idx-1));
            otherwise
                slope(idx) = (y(idx+1)-y(idx-1))/(x(idx+1)-x(idx-1));
        end
    end
    
else
    error('x and y must have same size');
end

end

