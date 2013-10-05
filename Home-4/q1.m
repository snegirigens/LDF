function q1 (Dvc, e, P)
	for N = 420000:1000:460000
		delta = 4 * (2*N)^Dvc * exp(-1/8*N*e^2);
		printf ('%d: %.3f\n', N, delta);
		if (delta <= P)
			printf ('Answer: %d = %.3f\n', N, delta);
			return;
		end;
	end;
	
	printf ('None of the answers');

%	exp(-1/8*N*e^2) = e / (4 * N^Dvc);
%	N = 8 / e^2 * log(4 * N^Dvc)) - 8 / e^2 * log(e);	
end;
