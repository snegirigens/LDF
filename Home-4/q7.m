function q7
	close all;
	figure;
	axis ([-1, 1, -1.2, 1.2]);
	hold on;
	
	n = 1000;
	X = zeros (n, 2);
	g = zeros (n, 2);
	
	plotSin();
	
	for i = 1 : n
		x = rand (2, 1) * 2 - 1;
		y = sin (pi * x);
		tx = transformE (x);
		w = pinv(tx'*tx) * tx'*y;
		X(i,:) = x';
		g(i,:) = w';
		
%		plot (x, y, 'ob');
%		line ([-1;1], [1,-1; 1,1]*w, 'LineWidth', 1);	% [x0=1, x1=+-1]
	end;
%	plotSin();
	
	w = mean (g, 1);
	line ([-1;1], [1,-1; 1,1]*w', 'Color', 'b', 'LineWidth', 3);		% 2x2 * 2x1
	
	bias = calcBias (w);
	variance = calcVariance (X, g, w);
	errOut = bias + variance;
	
	printf ('Mean g = [%.2f, %.2f]\n', w(1), w(2));
	printf ('Bias = %.2f\n', bias);
	printf ('Variance = %.2f\n', variance);
	printf ('Out of sample error = %.3f\n', errOut);
end;

function [x] = transformA (x)	% bias=0.51 var=0.25 err=0.763
	n = size(x, 1);
	x = [ones(n, 1), zeros(n, 1)];
end;

function [x] = transformB (x)	% bias=0.28 var=0.24 err=0.52 g = [0.00, 1.42]
	n = size(x, 1);
	x = [zeros(n, 1), x];
end;

function [x] = transformC (x)	% bias=0.21 var=1.88 err=2.09 g = [0.02, 0.74]
	n = size(x, 1);
	x = [ones(n, 1), x];
end;

function [x] = transformD (x)	% bias=0.52 var=8.77 err=9.28
	n = size(x, 1);
	x = [zeros(n, 1), x.^2];
end;

function [x] = transformE (x)	% bias=0.Lot var=0. err=0.Lot
	n = size(x, 1);
	x = [ones(n, 1), x.^2];
end;

function [bias] = calcBias (w)
	n = 1000;
	X = sort (rand (n, 1) * 2 - 1);
	Y = sin (pi * X);
	tx = transformE (X);
	h = tx * w';
	bias = mean ((h - Y).^2);
end;

function [variance] = calcVariance (X, g, w)
	n = 2;
	m = size(g, 1);
	vars = zeros(m, 1);
	
	for i = 1 : m
		x = rand (n, 1) * 2 - 1;
		tx = transformE (x);
		h = tx * g(i,:)';
		y = tx * w';
		vars(i) = mean ((h - y).^2);
%		plot (x, h, 'xr', 'LineWidth', 2);
%		plot (x, y, 'xb', 'LineWidth', 2);
	end;

	variance = mean (vars);
end;

function plotSin
	n = 1000;
	X = sort (rand (n, 1) * 2 - 1);
	Y = sin (pi * X);
	plot (X, Y, '-r', 'LineWidth', 2);
end;

function plotSquared
	n = 1000;
	X = sort (rand (n, 1) * 2 - 1);
	Y = X.^2;
	plot (X, Y, '-b', 'LineWidth', 2);
end;
