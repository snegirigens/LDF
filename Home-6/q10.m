function q10
	results = zeros(35, 1);
	
	for i = 2 : 34
		j = 36 - i;
		results(i-1) = 10*(i-1) + i*(j-1) + j;
		printf ('%2d x %2d = %d\n', i, j, results(i-1));
	end;
end;
