function q7 (digit1, digit2)
	close all;
	visualize = false;
	[X, Y] = loadData (digit1, digit2, 'train');
	
	if (visualize)
		plotData (X, Y);
	end;
	
	n = 100; 
	C = [0.0001; 0.001; 0.01; 0.1; 1];
	valErrors = zeros (n, length(C));
	
	for i = 1 : n
		[trainX, trainY, testX, testY] = shuffleData (X, Y);
		
		for j = 1 : length(C)
			model = train (trainX, trainY, C(j));
			valErrors(i,j) = test (testX, testY, model);
		end;
	end;

%	disp(valErrors);
	[valError, models] = min (valErrors, [], 2);
	
	model = findFreq (models);
	meanErr = sum(valErrors(:,model)) / n;
	
	printf ('\nBest model is %d [%f] (average error = %f)\n', model, C(model), meanErr);
end;

function [model] = findFreq (models)
	result = zeros (length(models), 1);
	
	for i = 1 : length(models)
		result(models(i))++;
	end;
	
	[count, model] = max(result);
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

function [X, Y, testX, testY] = shuffleData (X, Y)
	m = size (X, 1);
	v = floor (m / 10);
	
	indices = randperm (m);
	testX = X(indices(1:v), :);
	testY = Y(indices(1:v), :);
	
	X = X(indices(v+1:end), :);
	Y = Y(indices(v+1:end), :);
end;

function [model] = train (X, Y, C)
	options = sprintf ('-s 0 -t 1 -d 2 -g 1 -r 1 -c %f', C);
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
