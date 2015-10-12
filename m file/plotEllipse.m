function [X, Y] = plotEllipse(x, y, a, b, phi)
% x: X coordinate of the center
% y: Y coordinate of the center
% a: Semimajor axis
% b: Semiminor axis
% phi: Rotation angle of the ellipse (in radians)

alpha = linspace(0, 360, 360)' .* (pi / 180);

X = x + (a * cos(alpha) * cos(phi) - b * sin(alpha) * sin(phi));
Y = y + (a * cos(alpha) * sin(phi) + b * sin(alpha) * cos(phi));
