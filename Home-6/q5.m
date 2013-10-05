function q5
	close all;
	in  = load ('in.data');
	out = load ('out.data');
	
	k = [3; 2; 1; 0; -1; -2; -3];
	classErrs = zeros (7, 1);
	
	for i = 1 : 7
		w = train (in, k(i));
		classErrs(i) = test (out, w);
	end;
	
	[minErr, kIndex] = min (classErrs);
	printf ('Minimum outErr = %.3f (regularization k = %d)\n', minErr, k(kIndex));
end;

function [w] = train (data, k)
	x = data (:,1:2);
	y = data (:,3);
%	plotData (x, y);
	z = transform (x);
	w = linReg (z, y, k);
	classErr = classError (z, y, w);
	printf ('Training class error = %.2f\n', classErr);
end;

function [classErr] = test (data, w)
	x = data (:,1:2);
	y = data (:,3);
%	plotData (x, y);
	z = transform (x);
	classErr = classError (z, y, w);
	printf ('Testing class error = %.2f\n', classErr);
end;

function [z] = transform (x)
	x1 = x(:,1);
	x2 = x(:,2);
	z = [ones(size(x,1),1), x1, x2, x1.^2, x2.^2, x1.*x2, abs(x1-x2), abs(x1+x2)];
end;

function [w] = linReg (x, y, k)
	n = size (x, 2);
	lambda = 10^k;
	printf ('Regularization lambda = %f\n', lambda);
	w = pinv (x'*x + lambda*eye(n)) * x'*y;
end;

function [err] = classError (x, y, w)
	err = mean (double (sign (x*w) != sign (y)));
end;

function plotData (X, Y)
	figure; hold on;
	pos = find (Y > 0);
	neg = find (Y < 0);
	plot(X(pos, 1), X(pos, 2), "rx", 'MarkerSize', 3);
	plot(X(neg, 1), X(neg, 2), "b+", 'MarkerSize', 3);
end;
