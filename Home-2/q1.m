function q1 (N)						% repeat the experiment N times
	results = zeros(N, 3);
	coins = 1000;
	
	for i = 1 : N
		results(i,:) = coin (coins);
	end;
	
	av1 = sum(results(:,1))/N
	avr = sum(results(:,2))/N
	avm = sum(results(:,3))/N
end;

function [result] = coin (m)		% toss m coins n times each
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
	
	result = [av1, avr, avm];
end;

function [result] = flip (n)
	result = zeros(n, 1);
	result(find(rand(n, 1) > 0.5)) = 1;
end;
