function q1
%	close all;
	in  = load ('in.data');
	out = load ('out.data');
	
	nTraining = 25;
	
%	Xtrain = in (1:nTraining,:);
%	Xval   = in (nTraining+1:end,:);
	Xval   = in (1:nTraining,:);
	Xtrain = in (nTraining+1:end,:);
	Xtest  = out;

	model = [3, 4, 5, 6, 7];
	m = length (model);
	trainErrs = zeros (m, 1);
	validErrs = zeros (m, 1);
	testErrs  = zeros (m, 1);
	
	for i = 1 : m
		[w, trainErrs(i)] = train (Xtrain, model(i));
		validErrs(i) = validate (Xval, w, model(i));
		testErrs(i)  = validate (Xtest, w, model(i));
%		printf('Press to continue');
%		pause();
	end;
	
	[minErr, modelID] = min (validErrs);
	printf ('Min validation error = %.2f (model = %d)\n', minErr, model(modelID));
	
	[minErr, modelID] = min (testErrs);
	printf ('Min test error = %.2f (model = %d)\n', minErr, model(modelID));
	
	plotCurves (model, trainErrs, validErrs, testErrs);
% 1. d
% 2. e
% 3. d
% 4. d
% 5. b
end;

function [w, classErr] = train (data, model)
	x = data (:,1:2);
	y = data (:,3);
%	plotData (x, y);
	z = transform (x, model);
	w = linReg (z, y);
	classErr = classError (z, y, w);
%	printf ('Training class error = %.3f\n', classErr);
end;

function [classErr] = validate (data, w, model)
	x = data (:,1:2);
	y = data (:,3);
%	plotData (x, y);
	z = transform (x, model);
	classErr = classError (z, y, w);
%	printf ('Validation class error = %.3f\n', classErr);
%	plotDecision (w, model);
end;

function [z] = transform (x, model)
	x1 = x(:,1);
	x2 = x(:,2);
	z = [ones(size(x,1),1), x1, x2, x1.^2, x2.^2, x1.*x2, abs(x1-x2), abs(x1+x2)](:,1:(model+1));
end;

function [w] = linReg (x, y)
	n = size (x, 2);
	k = -1000;
	lambda = 10^k;
	w = pinv (x'*x + lambda*eye(n)) * x'*y;
end;

function [err] = classError (x, y, w)
	err = mean (double (sign (x*w) != sign (y)));
end;

function plotDecision (w, model)
	x1 = linspace (-1.25, 1.25, 100);
	x2 = linspace (-1.25, 1.25, 100);
	h = zeros (length(x1), length(x2));
	
	for i = 1 : length(x1)
		for j = 1 : length(x2)
			h(i,j) = transform([x1(i), x2(j)], model) * w;
		end;
	end;
	
	contour (x1, x2, h', [0,0]);
end;

function plotCurves (model, trainErrs, validErrs, testErrs)
	figure; hold on;
	axis ([3, 7, 0, 0.6]);
	line (model, trainErrs, 'Color', 'b', 'LineWidth', 2);
	line (model, validErrs, 'Color', 'g', 'LineWidth', 2);
	line (model, testErrs,  'Color', 'r', 'LineWidth', 2);
	legend ('Train','Validation', 'Test');
end;

function plotData (X, Y)
	figure; hold on;
	axis ([-1.5; 1.5; -1.5; 1.5]); 
	pos = find (Y > 0);
	neg = find (Y < 0);
	plot(X(pos, 1), X(pos, 2), "rx", 'MarkerSize', 3);
	plot(X(neg, 1), X(neg, 2), "b+", 'MarkerSize', 3);
end;
