function q12
	close all; clear;
%	figure; hold on;
%	axis ([-2, 2, -2, 2]);

	n = 1;
	W(1,:) = [-0.5, -1, 1];
	W(2,:) = [-0.5, 1, -1];
	W(3,:) = [-0.5, 1, 0];
	W(4,:) = [-0.5, 0, 1];
	
	color = ["b", "g", "r", "r"];

	X = [1, 0; 0, 1; 0, -1; -1, 0; 0, 2; 0, -2; -2, 0];
	Y = [-1; -1; -1; 1; 1; 1; 1];
	Z = transform (X);
	
%	plotData (X, Y);
	
	for i = 1 : size(W, 1)
		figure; hold on;
		axis ([-5, 5, -5, 5]);
		plotData (Z, Y);
		dispThreashold (W(i,:), color(i));
	end;
end;

function [Z] = transform (X)
	Z = [X(:,2).^2 - 2*X(:,1) - 1, X(:,1).^2 - 2*X(:,2) + 1]
end;

function plotData (X, Y)
	pos = find (Y > 0);
	neg = find (Y < 0);
	plot(X(pos, 1), X(pos, 2), "r*", 'MarkerSize', 6);
	plot(X(neg, 1), X(neg, 2), "b+", 'MarkerSize', 6);
end;

function [z2, z3] = targetLine (w)
	m = 20;
	z3 = linspace (-4, 4, m);
	if (w(2) != 0)
		z2 = - (w(1) + w(3)*z3) / w(2);
	else
		z2 = 0;
	end;
end;

function dispThreashold (w, color)
	[x1, x2] = targetLine (w);
	plot ([x1], [x2], color);
end;
