function q8
	close all; clear;
%	figure;
%	hold on;
%	axis ([-1, 1, -1, 1]);

	n = 50;
	m = 100;
	epoch = zeros(n, 1);
	Eouts = zeros(n, 1);
	
	for i = 1 : n
		T = [rand(1,1)-0.5; rand(2,1)*2-1];
%		dispThreashold (T, '-k');
		
		X = rand(m, 2) * 2 - 1;
		Y = resolve (T, X);
%		plotData (X, Y);
		
		[w, epoch(i)] = SGD (X, Y);

		Eouts(i) = outError (T, w);
		printf ('Eout = %.3f\n', Eouts(i));
	end;
	
	meanErr = mean (Eouts);
	printf ('Average convergense rate is %d epoch. mean(Eout) = %.3f\n', mean (epoch), mean (Eouts));

	answers = [0.025; 0.050; 0.075; 0.100; 0.125];
	[stam, answer] = min(abs(answers - meanErr));
	printf ('Final answer = %d\n', answer);
end;

function [w, epoch] = SGD (X, Y)
	n = size(X, 1);
	alpha = 0.01;
	precision = 0.01;
%	costHist = [];
	
	X = [ones(n, 1), X];
	w = zeros (size(X, 2), 1);
	prevW = w;

	for epoch = 1 : 2000
		cost = zeros (n, 1);

		for i = 1 : n
			[cost(i), grad] = costFunc (X(i,:), Y(i), w);
			w -= alpha * grad';
		end;

%		meanCost = mean (cost);
%		costHist = [costHist; [meanCost]];
		
		if (sqrt(sum((prevW - w).^2)) < precision)
%			printf ('Converged after %d epochs\n', epoch);
			break;
		else
			prevW = w;
		end;
	end;
end;

function [cost, grad] = costFunc (X, Y, w)
	n = size(X, 2);
	cost = mean (log (1 + exp(-Y.*(X*w))));
	grad = -mean (X.*repmat(Y,1,n) / (1 + exp(Y.*(X*w))), 1);
end;

function plotData (X, Y)
	pos = find (Y > 0);
	neg = find (Y < 0);
	zer = find (Y == 0);
	
	plot(X(pos, 1), X(pos, 2), "rx", 'MarkerSize', 3);
	plot(X(neg, 1), X(neg, 2), "b+", 'MarkerSize', 3);
	plot(X(zer, 1), X(zer, 2), "ko", 'MarkerSize', 3);
	
end;

function [Y] = resolve (T, X)
	n = size(X, 1);
	X = [ones(n, 1), X];
	Y = sign (sigmoid (X * T) - 0.5);
end;

function [g] = sigmoid (z)
	g = 1 ./ (1 + exp(-z));
end;

function dispThreashold (T, color)
	x1 = -1;
	y1 = -(T(1) + T(2) * x1) / T(3);
	x2 = 1;
	y2 = -(T(1) + T(2) * x2) / T(3);
	plot ([x1, x2], [y1, y2], color);
end;

function plotCurve (curve)
	figure;
	plot (curve, 'Color', 'r');
end;

function [cost] = outError (T, W)
	m = 100;
	X = rand(m, 2) * 2 - 1;
	Y = resolve (T, X);
	X = [ones(size(X, 1), 1), X];
	cost = mean (log (1 + exp(-Y.*(X*W))));
%	H = resolve (W, X);
%	cost = size(find(Y != H), 1) / m;
end;
