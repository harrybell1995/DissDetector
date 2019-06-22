%myFolder = 'C:\Users\Harry\Desktop\Images\Train\Melanoma';
%myFolder = 'C:\Users\Harry\Desktop\Images\Train\BenignKeratosis';
myFolder = 'C:\Users\Harry\Desktop\Images\Train\nevus 2';
%myFolder = 'C:\Users\Harry\Desktop\ProjectCode\testing';

filePattern = fullfile(myFolder, '*.jpg');
jpegFiles = dir(filePattern);
for k = 1:length(jpegFiles)
    baseFileName = jpegFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    imageArray = imread(fullFileName);
    imshow(imageArray);
    newImage = imresize(imageArray,[32 32]);
    %newImage = imcrop(imageArray, [1,1,columns, 600]);
    newFileName = strrep(fullFileName, '.jpg', '_resized.jpg');
    imwrite(newImage, newFileName );
end
