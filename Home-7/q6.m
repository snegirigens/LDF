function q6
	for i = 1 : 10
		runTest;
	end;
% Expected e1 = 0.50, e2 = 0.50, e(min) = 0.33
end;

function runTest
	N = 10000;
	e1 = zeros (N, 1);
	e2 = zeros (N, 1);
	em = zeros (N, 1);
	
	for i = 1 : N
		e1(i) = rand (1);
		e2(i) = rand (1);
		em(i) = min (e1(i), e2(i));
	end;
	
	printf ('Expected e1 = %.2f, e2 = %.2f, e(min) = %.2f\n', mean(e1), mean(e2), mean(em));
end;
