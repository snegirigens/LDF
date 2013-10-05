function transformData2 (digit1, digit2)
	handleData (digit1, digit2, 'train');
	handleData (digit1, digit2, 'test');
end;

function handleData (digit1, digit2, extention)
	fname = sprintf ('features.%s', extention);
	trainData = load (fname);
	
%	keep = (1:100);
	X = trainData (:, 2:3);
	Y = trainData (:, 1);
	
	tempX = [];
	tempY = [];
	
	for i = 1 : size (X, 1)
		if (Y(i) == digit1 || Y(i) == digit2)
			if (Y(i) == digit1)
				y = 1;
			else
				y = -1;
			end;
			tempX = [tempX; X(i,:)];
			tempY = [tempY; y];
		end;
	end;
	
	X = tempX;
	Y = tempY;
	
	fname = sprintf ('%d.%d.%s', digit1, digit2, extention);
	file = fopen (fname, 'w');
	for i = 1 : size(X, 1)
		fprintf (file, '%d %d:%f %d:%f\n', Y(i), 1, X(i,1), 2, X(i,2));
	end;	
	fclose (file);
end;
