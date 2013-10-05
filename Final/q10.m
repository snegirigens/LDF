function q10 (lambda)
	close all;
%	figure; hold on;
%	axis ([-1, 1, -1, 1]);

	digit1 = 1;
	digit2 = 5;
	
	[trainX, trainY] = loadData (digit1, digit2, 'train');	%Format: digit - symmetry - intensity
	[W, Ein] = train (trainX, trainY, lambda);

	[testX, testY] = loadData (digit1, digit2, 'test');	
	[Eout] = test (testX, testY, W);
	
	printf ('Ein = %.4f  Eout = %.4f\n', Ein, Eout);
end;

function [X, Y] = loadData (digit1, digit2, extention)
	fname = sprintf ('features.%s', extention);
	trainData = load (fname);
	
%	keep = (1:200);
	X = trainData (:, 2:3);
	Y = trainData (:, 1);
	
	tempX = [];
	tempY = [];
	
	for i = 1 : size (X, 1)
		if (Y(i) == digit1 || Y(i) == digit2)
			if (Y(i) == digit1)
				y = 1;
			else
				y = -1;
			end;
			tempX = [tempX; X(i,:)];
			tempY = [tempY; y];
		end;
	end;
	
	X = tempX;
	Y = tempY;
end;

function [w, classErr] = train (x, y, lambda)
	z = transform (x);
	w = linReg (z, y, lambda);
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
	z = [ones(size(x,1),1), x1, x2, x1.*x2, x1.^2, x2.^2];
end;

function [w] = linReg (x, y, lambda)
	n = size (x, 2);
	printf ('Regularization lambda = %f\n', lambda);
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
