function oneVall (targetDigit)
%	close all;
	visualize = true;
	[X, Y] = loadData (targetDigit, visualize);
%	saveData (X, Y);
%	return;
	
	if (visualize)
		plotData (X, Y);
	end;
	
	n = 1; 
	C = 0.01;		% SVM regularization parameter
%	svmResults = zeros (n, 1);
%	svmDiffs   = zeros (n, 1);
	
	for i = 1 : n
		model = svm (X, Y, C);
%		svmDiffs(i) = test (T, w);

		if (visualize)
			dispSVMs (model);
			plotDecision (model);
		end;
	end;
	
%	printf ('Average SV-count is %.2f. Pr[f(x) != g(x)] = %.3f\n', mean(svmResults), mean(svmDiffs));
end;

function [model] = svm (X, Y, C, visualize)
	n = length (X(:,1));	% How many points
	d = length (X(1,:));	% Dimensionality of X
	H = zeros (n,n);
	L = ones (n, 1) * -1;	% Linear term is tall vector of -1
	lb = zeros (n,1);		% Lower bound on alpha is tall vector of 0
	ub = ones (n,1) * C;	% Upper bound on alpha is tall vector of C's
	A = Y';					% Linear coefficient  (A)(alpha) + blin = 0
	blin = 0;				% 
	tolerance = 10^-10;

	printf ('Calculating matrix H...');
	fflush (stdout);
	
	for i = 1:n;
		for j = 1:n;
			H(i,j) = Y(i)*Y(j) * kernel(X(j,:), X(i,:));
		end;
	end;
	printf ('Done\n');
	
	% This is a workaround (see discussion http://book.caltech.edu/bookforum/showthread.php?t=513&page=5)
	tempH = H;
	attempts = 3;
	
	while (attempts-- > 0)
		tempH += (eye(n) .* tolerance);
		printf ('Running preliminary SVM...');		
		fflush (stdout);
		[alpha0, obj, info, lambda] = qp ([], tempH, L, A, blin, lb, ub);
		printf ('Done\n');
		
		printf ('Running final SVM...');
		fflush (stdout);
		[alpha, obj, info, lambda]  = qp (alpha0, H, L, A, blin, lb, ub);
		printf ('Done\n');
		fflush (stdout);
		
		if (info.info != 0)
			if (attempts > 0)
				warning ('Fail to converge. Trying once more.');
			else
				warning ('Fail to converge. Proceding with %d SVs\n', sum(alpha > tolerance));
			end;
		else
			attempts = 0;
			printf ('Converged with %d SVs\n', sum(alpha > tolerance));
		end;
	end;
	
	ids = find (alpha > tolerance);
	model.alpha = alpha(ids);
	model.X = X(ids,:);
	model.Y = Y(ids);
	model.b = Y(ids(1)) - calcInner (model, X(ids(1),:));
end;

function [r] = calcInner (model, x)
	r = 0;
	for i = 1 : size (model.alpha, 1)
		r += model.alpha(i) * model.Y(i) * kernel (model.X(i,:), x);
	end;
end;

function [g] = calcHypo (model, x)
	g = sign (calcInner (model, x) + model.b);
end;

function [x] = kernel (x1, x2)
	q = 2;
	x = (1 + x1*x2')^q;
end;

function [X, Y] = loadData (targetDigit)
	trainData = load ('features.train');	%Format: digit - symmetry - intensity
%	testData  = load ('features.test');
	
%	keep = randperm (size(trainData, 1))(1:250);
	keep = (1:1000);
	X = trainData (keep, 2:3);
	Y = trainData (keep, 1);
	
	indxOfDigit = find (Y == targetDigit);
	Y(:) = -1;
	Y(indxOfDigit) = 1;	
end;

function saveData (X, Y)
	file = fopen ('train-sneg.data', 'w');
	for i = 1 : size(X, 1)
		fprintf (file, '%d %d:%f %d:%f\n', Y(i), 1, X(i,1), 2, X(i,2));
	end;	
	fclose (file);
end;	

function [dif] = test (T, W)
	m = 100000;
	X = rand(m, 2) * 2 - 1;
	Y = resolve (T, X);
	H = resolve (W, X);
	dif = size(find(Y != H), 1) / m;
end;

function plotData (X, Y)
	figure; hold on;
	axis ([0, 0.8, -8, 0]);
	pos = find (Y > 0);
	neg = find (Y < 0);
	plot(X(neg, 1), X(neg, 2), "b+", 'MarkerSize', 2);
	plot(X(pos, 1), X(pos, 2), "r*", 'MarkerSize', 2);
end;

function [Y] = resolve (T, X)
	n = size(X, 1);
	X = [ones(n, 1), X];
	Y = sign(X * T);
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
