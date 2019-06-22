%myFolder = 'C:\Users\Harry\Desktop\Images\Train\Melanoma';
%myFolder = 'C:\Users\Harry\Desktop\Images\Train\BenignKeratosis';
myFolder = 'C:\Users\Harry\Documents\Sports Interactive\Football Manager 2019\graphics\ethiopian logos';
%myFolder = 'C:\Users\Harry\Desktop\ProjectCode\testing';

filePattern = fullfile(myFolder, '*.png');
jpegFiles = dir(filePattern);
for k = 1:length(jpegFiles)
    baseFileName = jpegFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    imageArray = imread(fullFileName);
    imshow(imageArray);
    newImage = imresize(imageArray,[25 18]);
    %newImage = imcrop(imageArray, [1,1,columns, 600]);
    newFileName = strrep(fullFileName, '.png', '_resized.png');
    imwrite(newImage, newFileName );
end
