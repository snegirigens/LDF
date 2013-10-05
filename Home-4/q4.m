function q4
%	close all;
%	figure;
%	hold on;
	
	n = 10000;
	X = zeros (n, 2);
	g = zeros (n, 1);
	
%	plotSin();
	
	for i = 1 : n
		x = rand (2, 1) * 2 - 1;
		y = sin (pi * x);
		w = pinv(x'*x) * x'*y;
		X(i,:) = x';
		g(i) = w;
		
%		plot (x, y, 'ob');
%		line ([-1;1], [-1;1]*w, 'LineWidth', 1);
%		line (x, y, 'LineWidth', 3);
	end;
	
	w = mean (g);
%	line ([-1;1], [-1;1]*w, 'LineWidth', 3);
	printf ('Mean g = %.2f\n', w);
	printf ('Bias = %.2f\n', calcBias (w));
	printf ('Variance = %.2f\n', calcVariance (X, g, w));
end;

function [bias] = calcBias (w)
	n = 1000;
	X = sort (rand (n, 1) * 2 - 1);
	Y = sin (pi * X);
	H = w * X;
	bias = mean ((H - Y).^2);
end;

function [variance] = calcVariance (X, g, w)
	variance = mean (mean ((X .* repmat(g, 1, 2) - X .* repmat (w, size (X, 1), 2)).^2));
end;

function plotSin
	n = 1000;
	X = sort (rand (n, 1) * 2 - 1);
	Y = sin (pi * X);
	plot (X, Y, '-r', 'LineWidth', 2);
end;
