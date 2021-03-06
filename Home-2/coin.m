function q1 (n)
	av1, avr, avm] = coin (1000)
end;

function [av1, avr, avm] = coin (m)		% toss m coins n times each
	n = 10;
	tosses = zeros(m, n);
	
	for i = 1 : m
		tosses(i,:) = flip(n);
	end;
	
	results = sum(tosses, 2);		% number of 1-s for each coin
	
	ra = max (2, int32(rand(1,1) * m));
	[stam, mi] = min(results);
	
	c1 = tosses(1,  :);
	cr = tosses(ra, :);
	cm = tosses(mi, :);
	
	av1 = sum(c1)/size(c1,2);
	avr = sum(cr)/size(cr,2);
	avm = sum(cm)/size(cm,2);
	
end;

function [result] = flip (n)
	result = zeros(n, 1);
	result(find(rand(n, 1) > 0.5)) = 1;
end;
