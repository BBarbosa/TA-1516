% clear all variables, command window and all figures
clear;
clc;
close all;

% file browser to search the
[filename,path] = uigetfile('*.*','Select Input Image'); 

% load image and set number of regions
img = imread(strcat(path,filename)); 
backup = img;

% convert pixel values to double
img = im2double(img);

% image properties
dim = size(img);
rows = dim(1);
cols = dim(2);

% convert RGB to HSV 
hsv_img = rgb2hsv(img);

% variables to calculate percentage
black=0;
yellow=0;
red=0;
blue=0;
area=0;
flag=0;

% show original image
imshow(img);
title(filename);

% ask for the number of regions
npols = inputdlg('Number of Regions','Select Regions',1,{'1'});
npols = str2num(npols{1});

% add multiple bw's
bw = roipoly(img);
for i = 1 : (npols-1)
    nbw = roipoly(img);
    bw = bw + nbw;
end

% imshow(bw);

% repaint image
for i = 1 : rows
    for j = 1 : cols
        if ( bw(i,j) == 1)
            flag=0;
            area = area+1;
            % fibrine OK
            if( hsv_img(i,j,1) >= 0.055 && hsv_img(i,j,1) <= .17 && ...
                hsv_img(i,j,2) >= 0 && hsv_img(i,j,2) <= 1 && ...
                hsv_img(i,j,3) >= 0 && hsv_img(i,j,3) <= 1 )
            
                img(i,j,1) = 255;
                img(i,j,2) = 255;
                img(i,j,3) = 0;
                
                yellow = yellow+1;
                flag=1;
            end
    
            % necrosis OK
            if( hsv_img(i,j,1) >= 0.00 && hsv_img(i,j,1) <= 1 && ...
                hsv_img(i,j,2) >= 0.00 && hsv_img(i,j,2) <= 1 && ... 
                hsv_img(i,j,3) >= 0.00 && hsv_img(i,j,3) <= .25)
            
                img(i,j,1) = 0;
                img(i,j,2) = 0;
                img(i,j,3) = 0;
                
                black = black+1;
                flag=1;
            end
        
            % granulation OK
            if( ( (hsv_img(i,j,1) >= 0 && hsv_img(i,j,1) <= 0.05) || ...
                  (hsv_img(i,j,1) >= 0.95 && hsv_img(i,j,1) <= 1) ) &&  ...
                   hsv_img(i,j,2) >= 0 && hsv_img(i,j,2) <= 1 && ...
                   hsv_img(i,j,3) >= 0 && hsv_img(i,j,3) <= 1)
            
                img(i,j,1) = 255;
                img(i,j,2) = 0;
                img(i,j,3) = 0;
                
                red = red+1;
                flag=1;
            end
            
            % unkown
            if(flag == 0) 
                img(i,j,1) = 0;
                img(i,j,2) = 0;
                img(i,j,3) = 255;
                
                blue = blue+1;
            end
        end
    end
end

% calculates the percentage of each type
gran = sprintf('Granulation: %.2f %c',(red/area)*100,'%');
fib = sprintf('Fibrin: %.2f %c',(yellow/area)*100,'%');
nec = sprintf('Necrosis: %.2f %c',(black/area)*100,'%');
unk = sprintf('Unknown: %.2f %c',(blue/area)*100,'%');

% display percentage
clc;
disp(strcat('-----',filename,'-----'));
disp(gran);
disp(fib);
disp(nec);
disp(unk);

% adds a legend to the figure and plot both images
subplot(121);
imshow(backup);
title('Original');

subplot(122);
imshow(img);
title('Segmented');
