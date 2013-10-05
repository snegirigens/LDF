function q13
	close all; clear;
%	figure; hold on;
%	axis ([-2, 2, -2, 2]);

	X = [1, 0; 0, 1; 0, -1; -1, 0; 0, 2; 0, -2; -2, 0];
	Y = [-1; -1; -1; 1; 1; 1; 1];
	C = 1;
	m = size (X, 1);
	
%	plotData (X, Y);
	
	[model] = svmTrain (X, Y, C);		
	Ecv = svmTest (X, Y, model);
	
	printf ('SVMs = %d. Ein = %.3f. Eout = %.3f\n', model.totalSV, Ecv, model.totalSV/m);
end;

function [model] = svmTrain (X, Y, C)
	options = sprintf ('-s 0 -t 1 -d 2 -g 1 -r 1 -c %f', C);
	model = svmtrain_mex (Y, X, options);
end;

function [Ecv] = svmTest (X, Y, model)
	[prediction, acc] = svmpredict_mex (Y, X, model);
%	printf ('SVM accurracy\n');
%	disp (acc);
	
	Ecv = sum(double(prediction != Y)) / length(Y);
end;

function plotData (X, Y)
	pos = find (Y > 0);
	neg = find (Y < 0);
	plot(X(pos, 1), X(pos, 2), "r*", 'MarkerSize', 6);
	plot(X(neg, 1), X(neg, 2), "b+", 'MarkerSize', 6);
end;

function [z2, z3] = targetLine (w)
	m = 20;
	z3 = linspace (-4, 4, m);
	if (w(2) != 0)
		z2 = - (w(1) + w(3)*z3) / w(2);
	else
		z2 = 0;
	end;
end;

function dispThreashold (w, color)
	[x1, x2] = targetLine (w);
	plot ([x1], [x2], color);
end;
