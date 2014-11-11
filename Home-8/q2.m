function q2
	close all; clear;
	figure; hold on;
%	axis ([-1, 1, -1, 1]);

	trainData = load ('features.train');	%Format: digit - symmetry - intensity
%	testData  = load ('features.test');
	
	X = trainData(:, 2:3);
	Y = trainData(:, 1);
	
	indxOfOnes = find (Y == 1);
	indxOfRest = find (Y != 1);
	disp ([X(indxOfOnes(1:20),:), Y(indxOfOnes(1:20),:)]);
	
	plot ([X(indxOfOnes, 1)], [X(indxOfOnes, 2)], 'bo');
	plot ([X(indxOfRest, 1)], [X(indxOfRest, 2)], 'rx');
	
%	return;
	
	n = 1000; 
	m = 100;
	plaResults = zeros (n, 1);
	svnResults = zeros (n, 1);
	plaDiffs   = zeros (n, 1);
	svmDiffs   = zeros (n, 1);
	
	for i = 1 : n
		while (1)
			T = [rand(1,1)-0.5; rand(2,1)*2-1];
			X = rand(m, 2) * 2 - 1;
			Y = resolve (T, X);
			
			if (sum (Y==1) > 0 && sum (Y==1) < m)
				break;
			end;
		end;
		
%		dispThreashold (T, '-k');
%		plotData (X, Y);
		
		[w, plaResults(i)] = pla (X, Y);
		plaDiffs(i) = test (T, w);
%		dispThreashold (w, '-g');
		
		[w, svnResults(i)] = svm (X, Y);
		svmDiffs(i) = test (T, w);
%		dispThreashold (w, '-r');
	end;
	
	printf ('Average convergense rate is %.2f. Pr[f(x) != g(x)] = %.3f\n', mean(plaResults), mean(plaDiffs));
	printf ('Average SV-count is %.2f. Pr[f(x) != g(x)] = %.3f\n', mean(svnResults), mean(svmDiffs));
	printf ('SVM is better than PLA in %d percent of cases\n', mean(double(svmDiffs < plaDiffs)) * 100);
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

function [w, svCount] = svm (X, Y)
	n = length (X(:,1));	% How many points
	d = length (X(1,:));	% Dimensionality of X
	H = zeros (n,n);
	L = ones (n, 1) * -1;	% Linear term is tall vector of -1
	lb = zeros (n,1);		% Lower bound on alpha is tall vector of 0
	A = Y';					% Linear coefficient  (A)(alpha) + blin = 0
	blin = 0;				% 
	tolerance = 10^-10;

	for i = 1:n;
		for j = 1:n;
			H(i,j) = Y(i)*Y(j)*X(j,:)*X(i,:)';
		end;
	end;
	
	% This is a workaround (see discussion http://book.caltech.edu/bookforum/showthread.php?t=513&page=5)
	tempH = H;
	
	while (1)
		tempH += (eye(n) .* tolerance);
		[alpha0, obj, info, lambda] = qp ([], tempH, L, A, blin, lb, []);
		[alpha, obj, info, lambda]  = qp (alpha0, H, L, A, blin, lb, []);
		
		if (info.info == 0)
			break;
		end;
		
		warning ('Fail to converge. Re-attempting...');
	end;
	
	svIDs = find (alpha > tolerance);
	svCount = length (svIDs);
	
	w = zeros (d, 1);
	for i = 1 : length (svIDs)
		id = svIDs(i);
		w += (alpha(id) * Y(id) * X(id,:))';
		
		if (Y(id) > 0)
%			plot(X(id, 1), X(id, 2), "ro", 'MarkerSize', 3);
		else
%			plot(X(id, 1), X(id, 2), "bo", 'MarkerSize', 3);
		end;
	end;
	
	b = 1/Y(svIDs(1)) - X(svIDs(1),:)*w;
	w = [b; w];
end;

function [dif] = test (T, W)
	m = 100000;
	X = rand(m, 2) * 2 - 1;
	Y = resolve (T, X);
	H = resolve (W, X);
	dif = size(find(Y != H), 1) / m;
end;

function plotData (X, Y)
	pos = find (Y > 0);
	neg = find (Y < 0);
	plot(X(pos, 1), X(pos, 2), "r*", 'MarkerSize', 2);
	plot(X(neg, 1), X(neg, 2), "b+", 'MarkerSize', 2);
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
