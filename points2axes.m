function [xppt, yppt, zppt] = points2axes(varargin)
%POINTS2AXES Conversion factors between points and axis units.
%   [XPPT, YPPT, ZPPT] = POINTS2AXES calculates the conversion factors
%   between points, where 1 point = 1/72 of an inch, and axis units along
%   the three Cartesian axes for the current axes. XPPT is the number of x
%   axis units that corresponds to a length of 1 point on the screen.
%   Similarly, YPPT and ZPPT are the number of y and z axis units per
%   point, respectively.
%
%   [XPPT, YPPT, ZPPT] = POINTS2AXES(AX) calculates the conversion factors
%   for the axes specified by AX instead of the current axes.
%
%   The conversion factors are useful for drawing objects whose dimensions
%   such as width, length, height, diameter, etc. are best expressed in
%   points. Note that changing the size of the figure window or the limits,
%   orientation, or aspect ratio of the axes directly affects the
%   conversion factors. It is therefore recommended to freeze the axis
%   limits before calling POINTS2AXES to prevent them from changing when
%   new objects are added.
%
%   Conversion factors can only be calculated if the (default)
%   “stretch-to-fill” behavior is disabled, which can be done by setting
%   DASPECT, for example.
%
%   Logarithmic plots of any kind are not supported.
%
%   The conversion factors for perspective projections are position-
%   dependent and therefore do not have unique values. In this case, a
%   warning is issued and the conversion factors for the corresponding
%   orthographic projection are returned, which gives sensible results in
%   most cases.
%
%Example:
%
%   xlim([-1 1]); ylim([-2 2]); zlim([-3 3]);
%   view(3); daspect([2 3 5]);
%   [xppt,yppt,zppt] = points2axes;
%   line([-20*xppt 20*xppt], [0 0], [0 0]);
%   line([0 0], [-20*yppt 20*yppt], [0 0]);
%   line([0 0], [0 0], [-20*zppt 20*zppt]);
%
%This creates three 40 point long lines in the center of a 3D plot.
%
% Created 2021-04-04 by Jorg C. Woehl
% 2021-04-20 (JCW): Replaced viewmtx to speed up code (v1.1).
% 2021-04-21 (JCW): Fixed issue with multiple input arguments (v1.2).

ax = gca;
if (nargin>0)
    ax = varargin{1};
    if ~isa(ax, 'matlab.graphics.axis.Axes')
        error('points2axes:IncorrectInputType',...
            ['Input 1 must be an axis handle, not "' class(ax) '".']);
    end
end

if (nargin>1)
    warning('points2axes:TooManyInputs',...
        'This function accepts only one input; other inputs are ignored.');
end

% projection
if strcmp(ax.Projection, 'perspective')
    % perspective projection
    warning('points2axes:Projection',...
        'Perspective projection; will return orthographic projection conversion factors.');
end

% logarithmic plots
if strcmp(ax.XScale, 'log') || strcmp(ax.XScale, 'log') || strcmp(ax.XScale, 'log')
    error('points2axes:LogPlotsUnsupported',...
        'Log plots are not supported.');
end

% coordinate ranges
xRange = diff(ax.XLim);
yRange = diff(ax.YLim);
zRange = diff(ax.ZLim);
% data aspect ratio and camera-up vector
d = ax.DataAspectRatio;
camUp = ax.CameraUpVector;
% edges of the axes box plus camera-up vector, expressed in equal length units
x = [0 xRange xRange 0      0      xRange xRange 0      camUp(1)] / d(1);
y = [0 0      yRange yRange 0      0      yRange yRange camUp(2)] / d(2);
z = [0 0      0      0      zRange zRange zRange zRange camUp(3)] / d(3);
% indices corresponding to pure axis vectors
xIdx = 2;   % x axis
yIdx = 4;   % y axis
zIdx = 5;   % z axis

% create column vectors (x,y,z)
v = [x; y; z];

% projection matrix for orthographic projection
az = ax.View(1);
el = ax.View(2);
A = [cosd(az), sind(az), 0; ...
    -sind(az)*sind(el), cosd(az)*sind(el), cosd(el)];

% project vectors onto viewing surface (x'y')
v2d = A * v;

% x' and y' coordinates of camera-up vector
upXPrime = v2d(1, end);
upYPrime = v2d(2, end);
% strip out camera-up vector
v2d = v2d(1:2, 1:end-1);

% rotate axes box so that camera-up vector points upward
upAngle = atan2(upYPrime, upXPrime);
rotAngle = pi/2 - upAngle;          % rotation angle
sine = sin(rotAngle);
cose = cos(rotAngle);
rotM = [cose, -sine; sine, cose];   % rotation matrix
v2d = rotM * v2d;
% separate rotated axes box into x' and y' coordinates
xPrime = v2d(1, :);
yPrime = v2d(2, :);

% conversion from points to data units
axU = ax.Units;         % restore point for axes units
ax.Units = 'points';    % express Position in points
pointsPerXPrime = ax.Position(3) / (max(xPrime)-min(xPrime));
pointsPerYPrime = ax.Position(4) / (max(yPrime)-min(yPrime));
pointsPerPrime = min(pointsPerXPrime, pointsPerYPrime);
xppt = xRange / (pointsPerPrime * sqrt(xPrime(xIdx)^2 + yPrime(xIdx)^2));
yppt = yRange / (pointsPerPrime * sqrt(xPrime(yIdx)^2 + yPrime(yIdx)^2));
zppt = zRange / (pointsPerPrime * sqrt(xPrime(zIdx)^2 + yPrime(zIdx)^2));
ax.Units = axU;         % restore axes units
end