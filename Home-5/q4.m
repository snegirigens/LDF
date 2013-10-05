function q4
	close all;
	plotSurf;
	
	u = 1;
	v = 1;
	alpha = 0.1;
	precision = 10^-14;
	epoch = 0;
	cost = getCost (u, v);
	history = [u, v, cost];
	
	while (cost > precision && size(history, 1) < 30)
		printf ('Cost = %g\n', cost);
		[du, dv] = gradient (u, v);
		u -= alpha * du;
		v -= alpha * dv;
		cost = getCost (u, v);
		history = [history; [u, v, cost]];
	end;
	
	disp (history);
	printf ('Converged on iteration %d: (%g, %g) = %g\n', size(history, 1) - 1, u, v, cost);	% Don't count initial iteration
	plotDescend (history(:,1), history(:,2));
end;

% (alpha = 0.05) Converged on iteration 16: (0.4234170, 0.5739970) = 1.10358e-015
% (alpha =  0.1) Converged on iteration 11: (0.0447363, 0.0239587) = 1.20868e-015

function [du, dv] = gradient (u, v)
	du = 2 * (exp(v) + 2*v*exp(-u)) * (u*exp(v) - 2*v*exp(-u));
	dv = 2*u^2*exp(2*v) - 4*u*exp(v-u)*(1 + v) + 8*v*exp(-2*u);
end;

function [cost] = getCost (u, v)
	cost = (u*exp(v) - 2*v*exp(-u))^2;
end;

function plotDescend (U, V)
	figure (1);
	plot (U, V, 'rx', 'MarkerSize', 3);
	line (U, V, 'Color', 'r', 'LineWidth', 2);
	figure (2);
	line (U, V, 'Color', 'r', 'LineWidth', 2);
%	plot (U, V, 'rx', 'MarkerSize', 3);
end;

function plotSurf
	n = 50;
	r = 1;
	u = linspace (-r, r, n);
	v = linspace (-r, r, n);
	e = zeros (n, n);
	
	for i = 1 : size(u, 2)
		for j = 1 : size(v, 2)
			e(j, i) = (u(i)*exp(v(j)) - 2*v(j)*exp(-u(i)))^2;
		end;
	end;
	
	figure (1); 
	hold on;
	axis ([-r, r, -r, r, 0, 2]);
	surf (u, v, e);
	xlabel ('U'); ylabel ('V'); zlabel ('E');
	
	figure (2);
	hold on;
	axis ([-r, r], [-r, r]);
	xlabel ('U'); ylabel ('V');
	contour (u, v, e, logspace(-4, 2, 20));
end;

% Q2 = d;