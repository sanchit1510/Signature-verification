clc;
clear all;
close all;
warning('off','all');

% Read the input images from the dataset
[f1, d1] = uigetfile('*.jpg');
image1 = imread([d1 f1]);
[f2, d2] = uigetfile('*.jpg');
image2 = imread([d2 f2]);

% Convert the images to grayscale
gray1 = rgb2gray(image1);
gray2 = rgb2gray(image2);

% Increase the contrast of the images
thresh1 = graythresh(gray1);
thresh2 = graythresh(gray2);
binary1 = im2bw(gray1, thresh1);
binary2 = im2bw(gray2, thresh2);

% Take the complement of the images
com1 = imcomplement(binary1);
com2 = imcomplement(binary2);

% Crop the images
[minrow1, mincol1, maxrow1, maxcol1] = imcrop(com1, [1 1 size(com1,2) size(com1,1)]);
cropped1 = com1(minrow1:maxrow1, mincol1:maxcol1);
[minrow2, mincol2, maxrow2, maxcol2] = imcrop(com2, [1 1 size(com2,2) size(com2,1)]);
cropped2 = com2(minrow2:maxrow2, mincol2:maxcol2);

% Extract the LBP features
features1 = extractLBPFeatures(cropped1);
features2 = extractLBPFeatures(cropped2);

% Create a model to classify the signatures
model = fitcecoc(features1, ones(size(features1,1),1));

% Predict the class of the second signature
S = predict(model, features2);

% Display the results
if S == 1
    disp('The signatures match.');
else
    disp('The signatures do not match.');
end