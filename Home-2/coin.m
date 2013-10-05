function [results] = coin (m)		% toss m coins n times each
	n = 10;
	tosses = zeros(m, n);
	
	for i = 1 : m
		tosses(i,:) = flip(n);
	end;
	
	results = sum(tosses, 2);		% number of 1-s for each coin
	
	ra = max (2, int32(rand(1,1) * m));
	[stam, mi] = min(results);
	
	c1 = tosses(1,  :)
	cr = tosses(ra, :)
	cm = tosses(mi, :)
	
end;

function [result] = flip (n)
	result = zeros(n, 1);
	result(find(rand(n, 1) > 0.5)) = 1;
end;
