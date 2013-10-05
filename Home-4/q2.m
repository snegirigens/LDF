function q2
	Dvc = 50;
	e = 0.05;
	delta = 0.05;
	figure;
	hold on;
	
%	N = [1:1:10];
	N = [5000:500:80000];
%	N = [100:500:4000];
%	N = [5];
	b = [realmax; realmax; realmax; realmax];
	
%	[bound] = vc (N, Dvc, e, delta);
%	b(1) = bound(1);
%	plot (N, bound, '-r', 'LineWidth', 2);
	
	[bound] = rademacher (N, Dvc, e, delta);
%	b(2) = bound(1);
	plot (N, bound, '-g', 'LineWidth', 2);
	
	[bound] = parrondo (N, Dvc, e, delta);
%	b(3) = bound(1);
	plot (N, bound, '-b', 'LineWidth', 2);
	
	[bound] = devroye (N, Dvc, e, delta);
%	b(4) = bound(1);
	plot (N, bound, '-k', 'LineWidth', 2);
	
	disp (b);
%	[k,v] = min(b);
%	printf ('%f -> %f\n', k, v);

end;

function [bound] = vc (N, Dvc, e, delta)
	n = size (N, 2);
	bound = zeros (n, 1);
	for i = 1 : n
		if (N(i) > Dvc)
			grow = (2*N(i))^Dvc;
		else
			grow = 2^(2*N(i));
		end;
		bound(i) = sqrt(8/N(i) * log(4*grow) / delta);
	end;
end;

function [bound] = rademacher (N, Dvc, e, delta)
	n = size (N, 2);
	bound = zeros (n, 1);
	for i = 1 : n
		if (N(i) > Dvc)
			grow = (N(i))^Dvc;
		else
			grow = 2^N(i);
		end;
		bound(i) = sqrt(2*log(2*N(i)*grow) / N(i)) + sqrt(2/N(i) * log(1/delta)) + 1/N(i);
	end;
end;

function [bound] = parrondo (N, Dvc, e, delta)
	n = size (N, 2);
	bound = zeros (n, 1);
	for i = 1 : n
		if (N(i) > Dvc)
			grow = (2*N(i))^Dvc;
		else
			grow = 2^(2*N(i));
		end;
		bound(i) = sqrt(1/N(i) * (2*e + log(6*grow/delta)));
	end;
end;

function [bound] = devroye (N, Dvc, e, delta)
	n = size (N, 2);
	bound = zeros (n, 1);
	for i = 1 : n
		if (N(i) > Dvc)
			logGrow = 2*log((N(i))^Dvc);
		else
			logGrow = log(2^(N(i)^2));
		end;
		bound(i) = sqrt(1/(2*N(i)) * (4*e * (1 + e) + log(4/delta) + logGrow));
	end;
end;
