function [res] = q1 (M, e, P)
	answers = [500; 1000; 1500; 2000];
	results = [realmax; realmax; realmax; realmax];
	
	for i = 1 : size(answers, 1)
		N = answers(i);
		results(i) = hoeffding (M, e, N);
	end;
	
	printf ('%.3f\n', results');
	
	for i = 1 : size(results, 1)
		p = results(i);
		if (p <= P)
			printf ('Answer = %d (P = %.3f)\n', i, p);
			return;
		end;
	end;

	printf ('None of the answers');
end;

function [p] = hoeffding (M, e, N)
	p = 2 * M * exp(-2*N*e^2);
end;

% Q1 = 2 (0.013)
% Q2 = 3 (0.011)
% Q3 = 4 (0.009)
