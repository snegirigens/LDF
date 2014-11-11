function q7
	close all; clear;
%	figure; hold on;
%	axis ([-1, 1, -1, 1]);

	Eins  = zeros (5, 1);
	Eouts = zeros (5, 1);

	for i = 1 : 5
		targetDigit = i + 4;
		[trainX, trainY] = loadData ('features.train', targetDigit);	%Format: digit - symmetry - intensity
		[W, Ein] = train (trainX, trainY);
		printf ('%2d. Training class error = %.3f\n', targetDigit, Ein);
		Eins(i) = Ein;

%		[testX, testY] = loadData ('features.test', targetDigit);	
%		[Eout] = test (testX, testY, W);
%		printf ('%2d. Testing class error = %.3f\n', targetDigit, Eout);
%		Eouts(i) = Eout;
	end;
	
	printf ('Min Ein  = %.3f\n', min(Eins));
%	printf ('Min Eout = %.3f\n', min(Eouts));
	
end;

function [X, Y] = loadData (file, targetDigit)
	data = load (file);
	
	X = data(:, 2:3);
	Y = data(:, 1);
	
	indxOfDigit = find (Y == targetDigit);
	indxOfRest  = find (Y != targetDigit);
	
%	disp ([X(indxOfDigit(1:20),:), Y(indxOfDigit(1:20),:)]);
	
%	figure; hold on;
%	plot ([X(indxOfRest, 1)], [X(indxOfRest, 2)], 'rx');
%	plot ([X(indxOfDigit, 1)], [X(indxOfDigit, 2)], 'bo');
	
	Y(indxOfDigit) = 1;
	Y(indxOfRest)  = -1;
end;

function [w, classErr] = train (x, y)
	z = transform (x);
	w = linReg (z, y);
	classErr = classError (z, y, w);
%	printf ('Training class error = %.3f\n', classErr);
%	dispThreashold (w, 'k');
end;

function [classErr] = test (x, y, w)
	z = transform (x);
	classErr = classError (z, y, w);
%	printf ('Testing class error = %.3f\n', classErr);
%	dispThreashold (w, 'k');
end;

function [z] = transform (x)
	x1 = x(:,1);
	x2 = x(:,2);
	z = [ones(size(x,1),1), x1, x2]; % [ones(size(x,1),1), x1, x2, x1.*x2, x1.^2, x2.^2];
end;

function [w] = linReg (x, y)
	n = size (x, 2);
	k = 0;
	lambda = 10^k;
%	printf ('Regularization lambda = %f\n', lambda);
	w = pinv (x'*x + lambda*eye(n)) * x'*y;
end;

function [err] = classError (x, y, w)
	err = mean (double (sign (x*w) != sign (y)));
end;

function plotData (X, Y)
	pos = find (Y > 0);
	neg = find (Y < 0);
	plot(X(pos, 1), X(pos, 2), "r*", 'MarkerSize', 2);
	plot(X(neg, 1), X(neg, 2), "b+", 'MarkerSize', 2);
end;

function dispThreashold (T, color)
	x1 = 0;
	y1 = -(T(1) + T(2) * x1) / T(3);
	x2 = 1;
	y2 = -(T(1) + T(2) * x2) / T(3);
	plot ([x1, x2], [y1, y2], color);
end;
