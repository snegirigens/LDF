function stam
	close all;
	figure;
	hold on;
	
	n = 10;
	x = sort (rand (n, 1) * 20 - 10);
	y1 = (1 ./ (1 + exp (-x)));
	y2 = (exp(x) ./ (1 + exp (x)));
	disp([x,y1, y2]);
	plot (x, y1, '-r', 'LineWidth', 2);
	plot (x, y2, '-b', 'LineWidth', 2);
%	line (x, y, 'LineWidth', 2);
	
end;

% Q2 = d;