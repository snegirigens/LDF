function q14_libsvm
	close all; clear;
%	figure; hold on;
%	axis ([-2, 2, -2, 2]);

%	n = 100; 
	n = 5000; 
	m = 100;
	gamma = 1.5;
	C = 1;
	discarded = 0;

% C = 1:     Not separable = 0.94. SVM Count: 32. Ein: 0.029. Eout: 0.325
% C = 10:    Not separable = 0.73. SVM Count: 16. Ein: 0.012. Eout: 0.164
% C = 10:    Not separable = 0.71. SVM Count: 16. Ein: 0.012. Eout: 0.164 (biase)
% C = 100:   Not separable = 0.28. SVM Count: 9. Ein: 0.003. Eout: 0.097
% C = 100:   Not separable = 0.25. SVM Count: 9. Ein: 0.003. Eout: 0.098 (biase)
% C = 1000:  Not separable = 0.03. SVM Count: 8. Ein: 0.000. Eout: 0.086
% C = 1000:  Not separable = 0.03. SVM Count: 8. Ein: 0.000. Eout: 0.087 (biase)
% C = 10000: Not separable = 0.00. SVM Count: 8. Ein: 0.000. Eout: 0.086
% C = 10000: Not separable = 0.00. SVM Count: 8. Ein: 0.000. Eout: 0.086 (biased)
% C = 100000: Not separable = 0.00. SVM Count: 8. Ein: 0.000. Eout: 0.086 (biased)


	plaResults = zeros (n, 1);
	svmCounts  = zeros (n, 1);
	plaDiffs   = zeros (n, 1);
	svmEins    = zeros (n, 1);
	svmEouts   = zeros (n, 1);
	
	for i = 1 : n
		X = rand(m, 2) * 2 - 1;
		Y = target(X);
		X = [ones(m, 1), X];	% Add bias
		
%		plotData (X, Y);
%		dispThreashold ('-k');
	
		[model] = svmTrain (X, Y, gamma, C);		
		Ecv = svmTest (X, Y, model);
		
		if (Ecv > 0)
			discarded += 1;
		end;
		
		svmCounts(i) = model.totalSV;
		svmEins(i)   = Ecv;
		svmEouts(i)  = svmCounts(i) / m;
		
%		printf ('SVMs = %d. Ein = %.3f. Eout = %.3f\n', svmCounts(i), svmEins(i), svmEouts(i));
	end;
	
	printf ('C = %d: Not separable = %.2f. SVM Count: %d. Ein: %.3f. Eout: %.3f\n', C, (discarded/n), (sum (svmCounts)/n), (sum (svmEins)/n), (sum (svmEouts)/n));
	
%	printf ('Average convergense rate is %.2f. Pr[f(x) != g(x)] = %.3f\n', mean(plaResults), mean(plaDiffs));
%	printf ('Average SV-count is %.2f  E[Ein] = %.3f  E[Eout] = %.3f  Discarded = %d\n', mean(svmCounts), mean(svmEins), mean(svmEouts), discarded);
%	printf ('SVM is better than PLA in %d percent of cases\n', mean(double(svmDiffs < plaDiffs)) * 100);
end;

function [model] = svmTrain (X, Y, gamma, C)
	options = sprintf ('-s 0 -t 2 -g %f -c %f -q', gamma, C);
	model = svmtrain_mex (Y, X, options);
end;

function [Ecv] = svmTest (X, Y, model)
	[prediction, acc] = svmpredict_mex (Y, X, model);
%	printf ('SVM accurracy\n');
%	disp (acc);
	
	Ecv = sum(double(prediction != Y)) / length(Y);
end;

function [Y] = target (X)
	n = size (X, 1);
	Y = zeros (n, 1);
	for i = 1 : n
		x = X(i, :);
		Y(i) = sign (x(2) - x(1) + 0.25 * sin(pi*x(1)));
	end;
end;

function plotData (X, Y)
	pos = find (Y > 0);
	neg = find (Y < 0);
	plot(X(pos, 1), X(pos, 2), "r*", 'MarkerSize', 6);
	plot(X(neg, 1), X(neg, 2), "b+", 'MarkerSize', 6);
end;

function [x1, x2] = targetLine
	x1 = linspace (-1, 1, 100);
	x2 = x1 - 0.25 * sin(pi*x1);
end;

function dispThreashold (color)
	[x1, x2] = targetLine;
	plot ([x1], [x2], color);
end;
