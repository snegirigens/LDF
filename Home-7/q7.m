function q7
%	close all;
	figure; hold on;
	axis ([-1, 5, -3, 3], "square", "on");
	plot ([-1, 3], [0, 0], 'k');
	plot ([-1, 3], [1, 1], 'k');
	plot ([0, 0], [-2, 2], 'k');
	err1 = plot1();
	err2 = plot2();
	
	printf ('Target eror is %.3f\n', (0.5^2 + 0.5^2));
	printf ('Error is %.3f (%.3f + %.3f)\n', err1+err2, err1, err2);
end;

function analytic
	w = [1; -1; 3.3357];	% x = 4.3357
%	c1 = calc2(w, -1)^2;
	c1 = (-(w(1) + w(2)*(-1)) / w(3))^2;

	w = [1; 1; -5.3357];	% x = 4.3357
%	c2 = calc2(w, 1)^2;
	c2 = (-(w(1) + w(2)*(1)) / w(3))^2;
	
	c1 + c2 == 0.5;
end;

function [err] = plot1
%	w = [1; -1; 2];		% x = 3
%	w = [1; -1; 3];		% x = 4
%	w = [1; -1; 3.5];	% x = 4.5
	w = [1; -1; 3.3357];	% x = 4.3357
%	w = [1; -1; 4];		% x = 5
	
	x1 = [-1; calc2(w, -1)];
	x2 = [calc1(w, 1); 1];
	plot ([1], [0], 'rx');	
	plot ([x1(1), x2(1)], [x1(2), x2(2)], 'b');
	t1 = [-1; 0];
	t2 = [-1; calc2(w, -1)];
	line ([t1(1), t2(1)], [t1(2), t2(2)], 'Color', 'r', "LineWidth", 3);	
	err = (t2(2) - t1(2))^2;
end;

function [err] = plot2
%	w = [1; 1; -4];	% x = 3
%	w = [1; 1; -5];	% x = 4
%	w = [1; 1; -5.5];	% x = 4.5
	w = [1; 1; -5.3357];	% x = 4.3357
%	w = [1; 1; -6];	% x = 5
	
	x1 = [-1; calc2(w, -1)];
	x2 = [calc1(w, 1); 1];
	plot ([-1], [0], 'rx');
	plot ([x1(1), x2(1)], [x1(2), x2(2)], 'g');
	t1 = [1; 0];
	t2 = [1; calc2(w, 1)];
	line ([t1(1), t2(1)], [t1(2), t2(2)], 'Color', 'r', "LineWidth", 3);
	err = (t2(2) - t1(2))^2;
end;

function [x1] = calc1 (w, x2)
	x1 = -(w(1) + w(3)*x2) / w(2)
end;

function [x2] = calc2 (w, x1)
	x2 = -(w(1) + w(2)*x1) / w(3)
end;

