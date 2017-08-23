function [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y)
%   Function to calculate slope of y w.r.t. x.  
%         Determines also minimum value of dydx and corresponding x.
%         Determines also maximum value of dydx and corresponding x.   
%
% SYNOPSIS: 
%   x        = an array (X-dimension)
%   y        = another array (Y-dimension) of same length as x
%   dydx     = slope of y w.r.t. x
%   dydxmin  = minimum value of dydx
%   xmin     = x location of minimum value of dydx
%   dydxmax  = maximum value of dydx
%   xmax     = x location of maximum value of dydx
%
% DESCRIPTION:
%   Function to calculate slope of y w.r.t. x.  
%         Determines also minimum value of dydx and corresponding index & x
%         Determines also maximum value of dydx and corresponding index & x
%   
% PARAMETERS:
%   x        - an array (X-dimension)
%   y        - another array (Y-dimension) of same length as x
%
% RETURNS:
%   dydx     - slope of y w.r.t. x
%   dydxmin  - minimum value of dydx
%   idydxmin - index location of minimum value of dydx 
%   xmin     - x location of minimum value of dydx
%   dydxmax  - maximum value of dydx
%   idydxmax - index location of maximum value of dydx 
%   xmax     - x location of maximum value of dydx
%
%---------------------------------------------------------------------

dx = mean(diff(x));
dydx = gradient(y,dx);

%[dydxmin, idydxmin] = min(dydx);
[dydxmin, idydxmin] = min(dydx(isfinite(dydx))); % Avoid -Inf, Inf and NaN values
xmin = x(idydxmin);

%[dydxmax, idydxmax] = max(dydx);
[dydxmax, idydxmax] = max(dydx(isfinite(dydx))); % Avoid -Inf, Inf and NaN values
xmax = x(idydxmax);

end

