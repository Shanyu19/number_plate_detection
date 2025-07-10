%clearing the workspace
clc
clear
%reads image 
plate = imread('car_image6.jpg');   
%resizes the image
plate = imresize(plate, [480 NaN]);
%displays original image
subplot(2,3,1)
imshow(plate)
title("Original Image");
%converts to grayscale
plategray = rgb2gray(plate);
subplot(2,3,2)
imshow(plategray),title("plate after gray scale");
%binarizes the image
platebin = imbinarize(plategray);
subplot(2,3,3)
imshow(platebin),title("plate after binarize");
%edge detection using Sobel Algorithm
plate = edge(plategray, 'sobel');
subplot(2,3,4)
imshow(plate),title("edge detection");
%dilates the image using diamond structure
plate = imdilate(plate, strel('diamond', 2));
%fills holes by making it full white color
plate = imfill(plate, 'holes');
%extract the solid filled parts
plate = imerode(plate, strel('diamond', 10));
%calculates Area,Bounding Box and Image size 
Iprops=regionprops(plate,'BoundingBox','Area', 'Image');
%stores the area of the first element
area = Iprops.Area;
%counts the number of elements
count = numel(Iprops);
%variable to store max area, initial value=first element's area
maxa= area;
%stores bounding box
boundingBox = Iprops.BoundingBox;
%loop to find the bounding box with the maximum area
for i=1:count
   if maxa<Iprops(i).Area
       maxa=Iprops(i).Area;
       boundingBox=Iprops(i).BoundingBox;
   end
end    
subplot(2,3,5)
imshow(plate),title("image used to crop the plate area");
%all above steps are to find location of the number plate

%Now crop the binarized image to get the number plate only
plate = imcrop(platebin, boundingBox);
subplot(2,3,6)
imshow(plate),title("final plate image used for ocr");

%resize number plate to 240 NaN
plate = imresize(plate, [240 NaN]);

%clear dust
plate = imopen(plate, strel('rectangle', [4 4]));

%selecting the plate region
plateRegion = plate;

% Using MATLAB's OCR function to recognize text from the plate region
ocrResults = ocr(plateRegion);

% Extracting the recognized text from the OCR results
plateNumber = ocrResults.Text;

% Printing the recognized plate number
fprintf('The car plate number is: %s\n', plateNumber);
