function q8 (n)
%	close all; clear;
%	figure;
%	hold on;
%	axis ([-1, 1, -1, 1]);

%	n = 1;
	m = 1000;
	errors = zeros(n, 1);
	
	for i = 1 : n
		X = rand(m, 2) * 2 - 1;
		Y = resolve (X);
		Y = addNoise (Y);
%		plotData (X, Y);
		
		[W] = regression (X, Y);
		errors(i) = inError (X, Y, W);
	end;
	
	meanErr = mean(errors);
	printf ('Average Ein is %.3f\n', meanErr);
	
	answers = [0; 0.1; 0.3; 0.5; 0.8];
	[stam, answer] = min(abs(answers - meanErr));
	printf ('Final answer = %d\n', answer);
end;

function [W] = regression (X, Y)
	X = [ones(size(X, 1), 1), X];
	W = pinv(X' * X) * X' * Y;
end;

function [err] = inError (X, Y, W)
	m = size(X, 1);
	X = [ones(m, 1), X];
	H = X * W;
	err = size (find (sign(Y) != sign(H)), 1) / m;
end;

function [Y] = resolve (X)
	n = size(X, 1);
	W = [-0.6; 1; 1];
	X = X .^ 2;
	X = [ones(n, 1), X];
	Y = sign(X * W);
end;

function [Y] = addNoise (Y)
	n = size(Y, 1);
	Y(randperm(n)(1:n/10)) *= -1;
end;

function plotData (X, Y)
	pos = find (Y > 0);
	neg = find (Y < 0);
	zer = find (Y == 0);
	
	plot(X(pos, 1), X(pos, 2), "rx", 'MarkerSize', 3);
	plot(X(neg, 1), X(neg, 2), "b+", 'MarkerSize', 3);
	plot(X(zer, 1), X(zer, 2), "ko", 'MarkerSize', 3);
	
end;

function dispThreashold (T, color)
	x1 = -1;
	y1 = -(T(1) + T(2) * x1) / T(3);
	x2 = 1;
	y2 = -(T(1) + T(2) * x2) / T(3);
	
	plot ([x1, x2], [y1, y2], color);
end;
