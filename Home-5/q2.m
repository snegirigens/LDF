function q2
%	close all;
	figure;
	hold on;
	
	n = 1000;
	X = [(ones (n, 1)), (rand (n, 1) * 2 -1), (rand (n, 1) * 2 -1)];
	Z = X.^2;
	w = [0; -1.5; 1.5];
	y = sign (Z * w);
	
%	disp ([X, y]);
	
	pos = find (y > 0);
	neg = find (y < 0);
	
	plot (X(pos,2), X(pos, 3), 'r+');
	plot (X(neg,2), X(neg, 3), 'bo');
	
end;

% Q2 = d;