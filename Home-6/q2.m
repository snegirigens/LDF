function q2
	close all;
	in  = load ('in.data');
	out = load ('out.data');
	
	w = train (in);
	test (out, w);
%	disp(w);
end;

function [w] = train (data)
	x = data (:,1:2);
	y = data (:,3);
%	plotData (x, y);
	z = transform (x);
	w = linReg (z, y);
	classErr = classError (z, y, w);
	printf ('Training class error = %.1f\n', classErr);
end;

function test (data, w)
	x = data (:,1:2);
	y = data (:,3);
	plotData (x, y);
	z = transform (x);
	classErr = classError (z, y, w);
	printf ('Testing class error = %.1f\n', classErr);
	plotDecision (w);
end;

function [z] = transform (x)
	x1 = x(:,1);
	x2 = x(:,2);
	z = [ones(size(x,1),1), x1, x2, x1.^2, x2.^2, x1.*x2, abs(x1-x2), abs(x1+x2)];
end;

function [w] = linReg (x, y)
	n = size (x, 2);
	k = 10;
	lambda = 10^k;
	printf ('Regularization lambda = %f\n', lambda);
	w = pinv (x'*x + lambda*eye(n)) * x'*y;
end;

function [err] = classError (x, y, w)
	err = mean (double (sign (x*w) != sign (y)));
end;

function plotDecision (w)
	x1 = linspace (-1.25, 1.25, 100);
	x2 = linspace (-1.25, 1.25, 100);
	h = zeros (length(x1), length(x2));
	
	for i = 1 : length(x1)
		for j = 1 : length(x2)
			h(i,j) = transform([x1(i), x2(j)]) * w;
		end;
	end;
	
	contour (x1, x2, h');
end;

function plotData (X, Y)
	figure; hold on;
	axis ([-1.5; 1.5; -1.5; 1.5]); 
	pos = find (Y > 0);
	neg = find (Y < 0);
	plot(X(pos, 1), X(pos, 2), "rx", 'MarkerSize', 3);
	plot(X(neg, 1), X(neg, 2), "b+", 'MarkerSize', 3);
end;
