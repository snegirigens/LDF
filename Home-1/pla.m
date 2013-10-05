function pla (n)
%	close all; clear;
%	figure;
%	hold on;
%	axis ([-1, 1, -1, 1]);

	m = 100;
	results = zeros(n, 1);
	diffs = zeros(n, 1);
	
	for i = 1 : n
		T = [rand(1,1)-0.5; rand(2,1)*2-1];
%		dispThreashold (T, '-k');
%		pause();
		
		X = rand(m, 2) * 2 - 1;
		Y = resolve (T, X);
		
%		plotData (X, Y);
		
		[W, results(i)] = perceptron (X, Y);
%		printf ('Perceptron converged after %d iterations\n', results(i));
		
		diffs(i) = test (T, W);
%		dispThreashold (W, '-r');
	end;
	
	printf ('Average convergense rate is %f. Pr[f(x) != g(x)] = %f\n', mean(results), mean(diffs));
end;

function [dif] = test (T, W)
	m = 10000;
	X = rand(m, 2) * 2 - 1;
	Y = resolve (T, X);
	H = resolve (W, X);
	dif = size(find(Y != H), 1) / m;
end;

function [W, iterations] = perceptron (X, Y)
	n = size(X, 1);
	m = size(X, 2);
	X = [ones(n, 1), X];
	W = zeros(m + 1, 1);
	iterations = 0;
	
	while (1)
		iterations += 1;
		again = 0;
		
		for i = 1 : n
			x = X(i,:);
			y = Y(i);
			h = sign(x * W);
			
			if (h != y)
				W += y * x';
				again = 1;
				break;
			end;
		end;
		
		if (again == 0)
			return;
		end;
	end;
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
	Y = sign(X * T);
end;

function dispThreashold (T, color)
	x1 = -1;
	y1 = -(T(1) + T(2) * x1) / T(3);
	x2 = 1;
	y2 = -(T(1) + T(2) * x2) / T(3);
	
	plot ([x1, x2], [y1, y2], color);
end;
