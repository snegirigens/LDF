function [res] = q1
	answers = [10; 25; 100; 500; 1000];
	results = [realmax; realmax; realmax; realmax];
	
	sigma = 0.1;
	d = 8;
	Ein = 0.008;
	
	for i = 1 : size(answers, 1)
		N = answers(i);
		results(i) = regError (sigma, d, N);
	end;
	
	printf ('%.4f\n', results');
	
	for i = 1 : size(results, 1)
		e = results(i);
		if (e > Ein)
			printf ('Answer = %d (Ein = %.3f)\n', i, e);
			return;
		end;
	end;

	printf ('None of the answers');
end;

function [Ein] = regError (sigma, d, N)
	Ein = sigma^2 * (1 - (d + 1) / N);
end;

% Q1 = 3 (0.009)
