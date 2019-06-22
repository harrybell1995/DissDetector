%load disscnn;
%net = disscnn;

%fid=fopen('C:\Users\Harry\Desktop\Images\results.txt');
%fprintf(fid, '1 = Benign Keratosis, 2 = Melanoma, 3 = Nevus');
%fclose(fid);

%rootFolder = 'C:\Users\Harry\Desktop\ProjectCode\testing';
%imds_test = imageDatastore(fullfile(rootFolder));

%labels = classify(net, imds_test);

%fid=fopen('C:\Users\Harry\Desktop\Images\results.txt', 'wt');
%fprintf(fid, 'Diagnosis -  %f\n', labels);
%fclose(fid);

%disscnn = net;
%save disscnn;
