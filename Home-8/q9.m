function q9 (digit1, digit2)
	close all;
	visualize = true;
	[X, Y] = loadData (digit1, digit2, 'train');
	[testX, testY] = loadData (digit1, digit2, 'test');
	
	if (visualize)
		plotData (X, Y);
	end;
	
%	C = [0.01; 1; 100; 10^4; 10^6];
	C = [100];
	n = length (C);
	Ein  = zeros (n, 1);
	Eout = zeros (n, 1);
	
	for i = 1 : n
		model = train (X, Y, C(i))
		Ein(i)  = test (X, Y, model);
		Eout(i) = test (testX, testY, model);
	end;

	printf ('  --- Ein ---  --- Eout ---\n');
	disp([Ein, Eout]);
	[inError,  inModel]  = min (Ein);
	[outError, outModel] = min (Eout);
	
	printf ('\nBest Ein is %f (model = %d [%f])\n', inError, inModel, C(inModel));
	printf ('Best Eout is %f (model = %d [%f])\n', outError, outModel, C(outModel));
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

function [model] = train (X, Y, C)
	options = sprintf ('-s 0 -t 2 -g 1 -c %f', C)
	model = svmtrain_mex (Y, X, options);
end;

function [Ecv] = test (X, Y, model)
	[prediction, acc] = svmpredict_mex (Y, X, model);
	Ecv = sum(double(prediction != Y)) / length(Y);
end;

function plotData (X, Y)
	figure; hold on;
	axis ([0, 0.8, -8, 0]);
	pos = find (Y > 0);
	neg = find (Y < 0);
	plot(X(neg, 1), X(neg, 2), "b+", 'MarkerSize', 2);
	plot(X(pos, 1), X(pos, 2), "r*", 'MarkerSize', 2);
end;

function dispThreashold (T, color)
	x1 = 0; x2 = 1;
	y1 = -(T(1) + T(2) * x1) / T(3);
	y2 = -(T(1) + T(2) * x2) / T(3);
	plot ([x1, x2], [y1, y2], color);
end;

function dispSVMs (model)
	n = size (model.alpha, 1);
	for i = 1 : n
		if (model.Y(i) > 0)
			plot(model.X(i, 1), model.X(i, 2), "ro", 'MarkerSize', 3);
		else
			plot(model.X(i, 1), model.X(i, 2), "bo", 'MarkerSize', 3);
		end;
	end;
end;

function plotDecision (model)
	x1 = linspace (0, 0.8, 100);
	x2 = linspace (-8, 0, 100);
	h = zeros (length(x1), length(x2));
	
	for i = 1 : length(x1)
		for j = 1 : length(x2)
			h(i,j) = calcHypo (model, [x1(i), x2(j)]);
		end;
	end;
	
	contour (x1, x2, h'); %, [0,0]);
end;
