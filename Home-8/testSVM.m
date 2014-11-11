function testSVM (digit1, digit2)
	[X, Y] = loadData (digit1, digit2, 'train');
	
%	C = [0.001; 0.01; 0.1; 1];
	C = [0.0001; 0.001; 0.01; 0.1; 1];
%	C = [1000000];
	m = length(C);
	n = 1;
	models = zeros (m, 1);
	errors = zeros (m, 1);
	
	for i = 1 : n
		valAccur = zeros (m, 1);
		for j = 1 : m
			valAccur(j) = validate (X, Y, C(j));
		end;
		
		disp(valAccur);
		
		[accuracy, model] = max(valAccur)
		
		pause();
		models(model) += 1;
		errors(model) += 100 - accuracy;
	end;
	
	disp([models, errors]);
	
	[count, model] = max(models);
	meanErr = errors(model) / (count * 100);
	
	printf ('Best model is %d (average error = %f)\n', model, meanErr);
%	handleData (digit1, digit2, 'test');
end;

function [Ecv] = validate (X, Y, C)
	options = sprintf ('-s 0 -t 1 -d 2 -g 1 -r 1 -c %f', C)
	Ecv = svmtrain_mex (Y, X, options)
%	printf ('\nValidation accuracy for C = %f is %f\n', C, Ecv);
end;

function [X, Y] = loadData (digit1, digit2, extention)
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
end;
