function q6(n)
%	close all; clear;
%	figure;
%	hold on;
%	axis ([-1, 1, -1, 1]);

%	n = 1;
	m = 100;
	inErrors  = zeros(n, 1);
	outErrors = zeros(n, 1);
	
	for i = 1 : n
		T = [rand(1,1)-0.5; rand(2,1)*2-1];
%		dispThreashold (T, '-k');
		
		X = rand(m, 2) * 2 - 1;
		Y = resolve (T, X);		
%		plotData (X, Y);
		
		[W] = regression (X, Y);
		
		inErrors(i)  = inError  (X, Y, W);
		outErrors(i) = outError (T, W);
		
%		printf ('Ein = %.3f\n', inErrors(i));		
%		dispThreashold (W, '-r');
	end;
	
	meanInErr  = mean(inErrors);
	meanOutErr = mean(outErrors);
	
	printf ('Average Ein is %.3f\n', meanInErr);
	printf ('Average Eout is %.3f\n', meanOutErr);
	
	answers = [0; 0.001; 0.01; 0.1; 0.5];
	[stam, answer] = min(abs(answers - meanOutErr));
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

function [dif] = outError (T, W)
	m = 1000;
	X = rand(m, 2) * 2 - 1;
	Y = resolve (T, X);
	H = resolve (W, X);
	dif = size (find (sign(Y) != sign(H)), 1) / m;
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
