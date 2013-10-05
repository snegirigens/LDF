function q15_libsvm
	close all; clear;
%	figure; hold on;
%	axis ([-1, 1, -1, 1]);

	n = 1000; 
	m = 100;
	gamma = 1.5;
	C = 1000;
	discarded = 0;
	K = 9;

%	K = 9 (Gamma = 1.5):
%		SVM got non-separable data 29 times
%		RBF E-in = 0.033  -->  E-out = 0.057
%		RBF E-out better than SVM E-out in 26.600 percent of cases
%		SVM E-out better than RBF E-out in 62.900 percent of cases
%
%		SVM got non-separable data 36 times
%		RBF got zero E-in 32 times
%		RBF E-in = 0.033  -->  E-out = 0.058
%		RBF E-out better than SVM E-out in 27.000 percent of cases
%		SVM E-out better than RBF E-out in 62.100 percent of cases

%	K = 12 Gamma = 1.5):
%		SVM got non-separable data 25 times
%		RBF E-in = 0.021  -->  E-out = 0.048
%		RBF E-out better than SVM E-out in 36.300 percent of cases
%		SVM E-out better than RBF E-out in 50.000 percent of cases
%
%	K = 9 (Gamma = 2.0):
%		SVM got non-separable data 17 times
%		RBF E-in = 0.037  -->  E-out = 0.062
%		RBF E-out better than SVM E-out in 18.900 percent of cases
%		SVM E-out better than RBF E-out in 71.100 percent of cases
		
	rbfEout = zeros (n, 1);
	rbfEin  = zeros (n, 1);
	svmEout = zeros (n, 1);
	rbfzeroEin  = 0;
	
	for i = 1 : n
		while (true)
			X = rand(m, 2) * 2 - 1;
			Y = target(X);

			centroids = kMeans (X, K);
			W = rbf (X, Y, centroids, gamma);
			
			[Asv, Xsv, Ein] = svm (X, Y, gamma, C);
			
			if (Ein > 0)
				warning ('SVM got Ein = %f', Ein);
				discarded += 1;
				continue;
			end;
			
			break;
		end;
		
		testX = rand (100, 2) * 2 - 1;
		testY = target (testX);
		
		rbfEin(i)  = testRBF (X, Y, W, centroids, gamma);
		rbfEout(i) = testRBF (testX, testY, W, centroids, gamma);
		svmEout(i) = testSVM (testX, testY, Asv, Xsv, gamma);
		
		if (rbfEin(i) == 0)
			rbfzeroEin += 1;
		end;
		
		printf ('RBF E-in = %f : RBF E-out = %f : SVM E-out = %f\n', rbfEin(i), rbfEout(i), svmEout(i));
	end;
	
	printf ('\n');
	printf ('SVM got non-separable data %d times\n', discarded);
	printf ('RBF got zero E-in %d times\n', rbfzeroEin);
	printf ('RBF E-in = %.3f  -->  E-out = %.3f\n', (sum (rbfEin) / n), (sum (rbfEout) / n));
	printf ('RBF E-out better than SVM E-out in %.3f percent of cases\n', (sum (double (rbfEout < svmEout)) / n * 100));
	printf ('SVM E-out better than RBF E-out in %.3f percent of cases\n', (sum (double (rbfEout > svmEout)) / n * 100));
end;

function [W] = rbf (X, Y, centroids, gamma)
	k = size (centroids, 1);
	n = size (X, 1);
	Z = zeros (n, k);
	
	for i = 1 : n
		for j = 1 : k
			Z(i,j) = transform (X(i,:), centroids(j,:), gamma);
		end;
	end;
	
	Z = [ones(n, 1), Z];
	W = pinv(Z'*Z) * Z'*Y;
end;

function [Erbf] = testRBF (X, Y, W, centroids, gamma)
	n = size (X, 1);
	k = size (centroids, 1);
	H = zeros (n, 1);
	Z = zeros (n, k);
	
	for i = 1 : n
		for j = 1 : k
			Z(i,j) = transform (X(i,:), centroids(j,:), gamma);
		end;
	end;

	Z = [ones(n, 1), Z];	% z(n,k) * w(k,1)
	H = sign (Z * W);

	Erbf = size (find (Y != H), 1) / n;
end;

function [z] = transform (x, mu, gamma)
	z = exp (-gamma * (norm (x - mu))^2);
end;

function [centroids] = kMeans (X, K)
	while (true)
		precentroids = zeros (K, 2);
		centroids = rand(K, 2) * 2 - 1;
		iterations = 0;

		while (sum(sum (centroids - precentroids).^2) > 0)
			iterations += 1;
			precentroids = centroids;
			idx = assignToCentroids (X, centroids);
			
			centroids = recalcCentroids (X, idx, K);
		end;

		for i = 1 : K
			if (sum (idx == i) == 0)
				printf ('Discarding empty cluster\n');
				break;
			end;
		end;
		if (i == K)		% wrong if K-th centroid was empty!
			break;
		end;
	end;
	
%	figure; hold on;
%	axis ([-1, 1, -1, 1]);
%	plotDataPoints (X, idx, K);
%	plotCent (centroids);
end;

function idx = assignToCentroids (X, centroids)
	K = size(centroids, 1);
	idx = zeros(size(X,1), 1);

	for i = 1 : length(idx)
		x = X(i,:);
		dis = zeros(K, 1);
		
		for j = 1 : K
			c = centroids(j,:);
			dis(j) = sum((x - c) .^ 2);
		end;
		
		[stam, idx(i)] = min(dis);
	end;
end

function centroids = recalcCentroids (X, idx, K)
	[m n] = size(X);
	centroids = zeros(K, n);

	for i = 1:K
		pos = find(idx==i);
		det = max (1, length(pos));
		centroids(i,:) = sum(X(pos,:)) / det;
		% mean(X(find(idx==i),:))
	end;
end

function [Asv, Xsv, Ein] = svm (X, Y, gamma, C)
	n = size (X, 1);
	X = [ones(n, 1), X];	% Add bias
	
	options = sprintf ('-s 0 -t 2 -g %f -c %f -q', gamma, C);
	model = svmtrain_mex (Y, X, options);

	[prediction, acc] = svmpredict_mex (Y, X, model);
%	Ein = sum (double (prediction != Y)) / length(Y);
	Ein = size (find (prediction != Y), 1) / n;
	
	Asv = model.sv_coef * model.Label(1);
	Xsv = full (model.SVs);
	label1 = repmat (model.Label(1), model.nSV(1), 1);
	label2 = repmat (model.Label(2), model.nSV(2), 1);
	Ysv = [label1; label2];
end;

function Esvm = testSVM (X, Y, Asv, Xsv, gamma)
	n = size (X, 1);
	k = size (Xsv, 1);
	H = zeros (n, 1);
	Z = zeros (n, k);

	X = [ones(n, 1), X];	% Add bias
	
	for i = 1 : n
		for j = 1 : k
			Z(i,j) = transform (X(i,:), Xsv(j,:), gamma);
		end;
	end;
	
	H = sign (Z * Asv);
	Esvm = size (find (Y != H), 1) / n;

%	for i = 1 : n
%		printf ('H(%d) = %d. Y(%d) = %d\n', i, H(i), i, Y(i));
%	end;
end;

function [Y] = target (X)
	n = size (X, 1);
	Y = zeros (n, 1);
	for i = 1 : n
		x = X(i, :);
		Y(i) = sign (x(2) - x(1) + 0.25 * sin(pi*x(1)));
	end;
end;

function plotCent (C)
	plot(C(:,1), C(:, 2), "kx", 'MarkerSize', 4);
end;

function plotDataPoints(X, idx, K)
	palette = hsv(K + 1);
	colors = palette(idx, :);
	scatter(X(:,1), X(:,2), 5, colors, '*');
end

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
