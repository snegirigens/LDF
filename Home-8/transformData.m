function transformData (targetDigit)
	handleData (targetDigit, 'train');
	handleData (targetDigit, 'test');
end;

function handleData (targetDigit, extention)
	fname = sprintf ('features.%s', extention)
	trainData = load (fname);
	
%	keep = randperm (size(trainData, 1))(1:250);
%	keep = (1:25);
	X = trainData (:, 2:3);
	Y = trainData (:, 1);
	
	indxOfDigit = find (Y == targetDigit);
	Y(:) = -1;
	Y(indxOfDigit) = 1;	
	
	fname = sprintf ('%d.all.%s', targetDigit, extention)
	file = fopen (fname, 'w');
	for i = 1 : size(X, 1)
		fprintf (file, '%d %d:%f %d:%f\n', Y(i), 1, X(i,1), 2, X(i,2));
	end;	
	fclose (file);
end;
