function q8_copy
	close all; clear;
%	figure; hold on;
%	axis ([-1, 1, -1, 1]);

	n = 1000; 
	m = 100;
	discarded = 0;
	
	plaResults = zeros (n, 1);
	svmCounts  = zeros (n, 1);
	plaDiffs   = zeros (n, 1);
	svmEins    = zeros (n, 1);
	svmEouts   = zeros (n, 1);
		
%		plotData (X, Y);
%		dispThreashold ('-k');
	
	for i = 1 : n
		X = rand(m, 2) * 2 - 1;
		Y = target(X);
	
		[alpha, SVs, T] = svm (X, Y);		
		Ein = test (X, Y, alpha, SVs, T);
		
		if (Ein > 0)
			discarded += 1;
			printf ('Discarded\n');
		end;
		
		svmCounts(i) = length(alpha);
		svmEins(i)   = Ein;
		svmEouts(i)  = size(SVs, 1) / m;
		
		printf ('#-SV = %d SVs. Ein = %.3f. Eout = %.3f\n', svmCounts(i), svmEins(i), svmEouts(i));
	end;
	
%	printf ('Average convergense rate is %.2f. Pr[f(x) != g(x)] = %.3f\n', mean(plaResults), mean(plaDiffs));
	printf ('Average SV-count is %.2f  E[Ein] = %.3f  E[Eout] = %.3f  Discarded = %d\n', mean(svmCounts), mean(svmEins), mean(svmEouts), discarded);
%	printf ('SVM is better than PLA in %d percent of cases\n', mean(double(svmDiffs < plaDiffs)) * 100);
end;

function [w, iterations] = pla (X, Y)
	n = size(X, 1);
	m = size(X, 2);
	X = [ones(n, 1), X];
	w = zeros(m + 1, 1);
	iterations = 0;
	
	while (1)
		iterations += 1;
		again = 0;
		
		for i = 1 : n
			x = X(i,:);
			y = Y(i);
			h = sign(x * w);
			
			if (h != y)
				w += y * x';
				again = 1;
				break;
			end;
		end;
		
		if (again == 0)
			return;
		end;
	end;
end;

function z = kernel (x1, x2)
	gamma = 1.5;
	z = exp (-gamma * (norm(x1 - x2))^2);
%	z = x1 * x2';
end;

function z = trans (x)
	gamma = 1.5;
	z = exp(-gamma * x * x');
end;

function [alpha, SVs, T] = svm (X, Y)
	n = length (X(:,1));	% How many points
	d = length (X(1,:));	% Dimensionality of X
	H = zeros (n,n);
	L = ones (n, 1) * -1;	% Linear term is tall vector of -1
	lb = zeros (n,1);		% Lower bound on alpha is tall vector of 0
%	ub = ones (n,1) * 1;	% Upper bound on alpha is tall vector of ...
	ub = [];				% Upper bound on alpha is tall vector of ...
	A = Y';					% Linear coefficient  (A)(alpha) + blin = 0
	blin = 0;				% 
	tolerance = 10^-10;

	for i = 1:n;
		for j = 1:n;
			H(i,j) = Y(i) * Y(j) * kernel (X(j,:)', X(i,:)');
		end;
	end;
	
	% This is a workaround (see discussion http://book.caltech.edu/bookforum/showthread.php?t=513&page=5)
	tempH = H;
	
	while (1)
		tempH += (eye(n) .* tolerance);
		[alpha0, obj, info, lambda] = qp ([], tempH, L, A, blin, lb, ub);
		[alphas, obj, info, lambda] = qp (alpha0, H, L, A, blin, lb, ub);
		
		if (info.info == 0)
			break;
		end;
		
		warning (sprintf ('Fail to converge. Reason: %d', info.info));
		break;
	end;
	
	svIDs = find (alphas > tolerance);
	svCount = length (svIDs);
	
	alpha = alphas(svIDs);
	SVs = X(svIDs,:);
	T = Y(svIDs);
	
%	for i = 1 : length (alpha)
%		if (T(i) > 0)
%			plot(SVs(i, 1), SVs(i, 2), "ro", 'MarkerSize', 3);
%		else
%			plot(SVs(i, 1), SVs(i, 2), "bo", 'MarkerSize', 3);
%		end;
%	end;
end;

function [Ein] = test (X, Y, alpha, SVs, T)
	n = size(X, 1);
	H = zeros(n, 1);
	
	for i = 1 : n
		H(i) = predict (X(i,:)', alpha, SVs, T);
	end;

	Ein = size (find (Y != H), 1) / n;
end;

function [g] = predict (x, alpha, SVs, Y)
	n = length (alpha);
	g = Y(1);
	for i = 1 : n
		g += alpha(i) * Y(i) * kernel(SVs(i,:)', x) - alpha(i) * Y(i) * kernel(SVs(i,:)', SVs(1,:)');
	end;
	g = sign (g);
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
	plot(X(pos, 1), X(pos, 2), "r*", 'MarkerSize', 2);
	plot(X(neg, 1), X(neg, 2), "b+", 'MarkerSize', 2);
end;

function [x1, x2] = targetLine
	x1 = linspace (-1, 1, 100);
	x2 = x1 - 0.25 * sin(pi*x1);
end;

function dispThreashold (color)
	[x1, x2] = targetLine;
	plot ([x1], [x2], color);
end;
