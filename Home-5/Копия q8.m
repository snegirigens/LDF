function q8
	close all;
	figure;
	hold on;
	axis ([-1, 1, -1, 1]);
	xlabel ('X1'); ylabel ('X2');

	n = 1;
	m = 100;
	results = zeros(n, 1);
	diffs = zeros(n, 1);
	
	for i = 1 : n
		F = rand (2,1) * 2 - 1;		% Our target f(x)
		dispThreashold (F, '-r');
%		pause();
		
		X = rand(m, 2) * 2 - 1;
		Y = resolve (F, X);
		disp ([X, Y]);
		
		plotData (X, Y);
		
		w = [0; 0];
		[w, costHist] = SGD (X, Y, w);
		
		w
		disp (costHist);
		
		plotCurve (costHist);
		
%		diffs(i) = test (T, W);
%		dispThreashold (W, '-r');
	end;
	
%	printf ('Average convergense rate is %f. Pr[f(x) != g(x)] = %f\n', mean(results), mean(diffs));
end;

function plotCurve (curve)
	figure;
	plot (curve, 'Color', 'r');
end;

function [w, costHist] = gradDescent (X, Y, w)
	alpha = 0.01;
	costHist = [];
	
	for i = 1 : 10
		[cost, grad] = costFunc (X, Y, w);
		costHist = [costHist; cost];
		w -= alpha * grad;
	end;
end;

function [w, costHist] = SGD (X, Y, w)
	n = size(X, 1);
	alpha = 0.01;
	precision = 0.01;
	costHist = [];
	prevW = w;
	
	for epoch = 1 : 1000
		for i = 1 : n
			[cost, grad] = costFunc (X(i,:), Y(i), w);
			w -= alpha * grad;
		end;

		costHist = [costHist; cost];
		
		if (sqrt(sum((prevW - w).^2)) < precision)
			printf ('Converged after %d epochs\n', epoch);
			break;
		else
			prevW = w;
		end;
	end;
end;

function [cost, grad] = costFunc (X, Y, w)
	cost = mean (log (1 + exp(-Y.*(X*w))));
	W = repmat (w', size(X, 1), 1);
	grad = mean (X.*repmat(-Y,1,2) ./ (1 + exp(X.*W.*repmat(Y,1,2))))';
end;

function [g] = sigmoid (z)
	g = 1 ./ (1 + exp(-z));
end;

function plotData (X, Y)
	pos = find (Y > 0);
	neg = find (Y < 0);
	
	plot(X(pos, 1), X(pos, 2), "rx", 'MarkerSize', 3);
	plot(X(neg, 1), X(neg, 2), "b+", 'MarkerSize', 3);
end;

function [Y] = resolve (F, X)
	Y = sign(X * F);
end;

function dispThreashold (F, color)
	plot ([-1;1], [F(1)/F(2); -F(1)/F(2)], color);
end;

function [W] = regression (X, Y)
	X = [ones(n, 1), X];
	W = pinv(X' * X) * X' * Y;
end;

function [dif] = test (T, W)
	m = 10000;
	X = rand(m, 2) * 2 - 1;
	Y = resolve (T, X);
	H = resolve (W, X);
	dif = size(find(Y != H), 1) / m;
end;

