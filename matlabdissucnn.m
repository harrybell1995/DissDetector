Input = imread('ISIC_0000490.jpg');
SegmentedInput = imread('ISIC_0000490_Segmentation.png');
imwrite(Input,'Images\I.jpg');

Red = Input(:,:,1);
histo = figure;
imhist(Red);
saveas(histo, 'Images\redhistogram.jpg')

Igray = rgb2gray(Input);
Igray = padarray(Igray,[4,4]);

[rows, columns] = size(Igray);

J = zeros(rows,columns,'uint8');

%median filter
for row = 1:rows
    for col = 1:columns
        if (row <= 2) || (col <= 2) || col >= columns - 2 || row >= rows -2
            J(row, col) = 0;
        else
            mask = zeros(5, 5);
            for x = 1:5
                for y = 1:5
                    newx = x - 3;
                    newy = y - 3;
                    mask (x, y) = Igray(row - newx, col - newy);
                end
            end
            
            S = mask(mask ~= 0);
            S = sort(S, 'descend');
            A = S(ceil(end/2), :);
            J(row, col) = A;
        end
    end
end

J = J(4+1:end-4,4+1:end-4); % unpad

figure
imshowpair(Input, J, 'montage')
title('Original Image')

mask = zeros(size(J));
mask(300:end-300,300:end-300) = 1;

%figure
%imshow(mask)
%title('Initial Contour Location')

bw = activecontour(J,mask,1000);

figure
imshow(bw)
title('Segmented Image')

se = strel('square',5);

bw2 = imdilate(bw, se);

Y = imbinarize(SegmentedInput);
Y = imfill(Y, 'holes');
imwrite(Y,'Images\Y.jpg');

yolo = imfuse(bw2, Y);
%title(['Jaccard Index = ' num2str(similarity)])
imwrite(yolo,'Images\Jaccard.jpg');

similarity = jaccard(bw2, Y);

fid=fopen('Images\jaccard.txt', 'w+');
fprintf(fid, 'Jaccard index -  %f \n', similarity);
fclose(fid);

border = imdilate(bw, se);
border = border - bw;
border2 = imdilate(Y, se);
border2 = border2 - Y;

B = imoverlay(Input,border);
B2 = imoverlay(Input,border2);

figure
imshow(B)
title('Border overlaid on initial image')
imwrite(B,'Images\B.jpg');
imwrite(B2,'Images\B2.jpg');

bw = bwareafilt(bw,1);

stats = regionprops(bw,'Eccentricity', 'Extent', 'Centroid','Orientation', 'BoundingBox');
angle = -stats.Orientation;
rotatedImage = imrotate(bw, angle, 'crop');

imshow(rotatedImage);

val1 = stats.BoundingBox(1);
val2 = stats.BoundingBox(2);
val3 = stats.BoundingBox(3);
val4 = stats.BoundingBox(4);

box = [val1, val2, val3, val4];    
cropped = imcrop(Input,box);
figure, imshow(cropped), title('Lesion area');
imwrite(cropped,'Images\cropped.jpg');

croppedgray = rgb2gray(cropped);

bw2 = imbinarize(croppedgray);
bw2 = imcomplement(bw2);
%imshow(bw2);
bw2 = bwareafilt(bw2,1);

stats = regionprops(bw2,'Eccentricity', 'Extent', 'Centroid','Orientation', 'BoundingBox', 'Area');

[rows, columns, numberOfColorChannels] = size(cropped);

middlex = columns/2;
middley = rows/2;

xCentroid = stats.Centroid(1);
yCentroid = stats.Centroid(2);

deltax = middlex - xCentroid;
deltay = middley - yCentroid;

distancex = xCentroid + deltax; 
distancey = yCentroid + deltay; 

croppedmiddle = insertMarker(cropped,[xCentroid yCentroid], 'color', 'magenta' ,'size', 10);
croppedmiddle = insertMarker(croppedmiddle,[middlex middley], 'color', 'white','size', 10);
imwrite(croppedmiddle,'Images\Irregular.png');

ir = imresize(cropped,[32 32]);

load disscnn;
net = disscnn;
newoutput = classify(net, ir);

h = cellstr(newoutput);
h = string(h);

fid=fopen('Images/classified.txt', 'w+');
fprintf(fid, 'CNN Prediction - %s', h);
fclose(fid);

finishmessage = 'Program finished - Open \ProjectCode\Images\DisplayMela.html to view results';
msgbox(finishmessage);