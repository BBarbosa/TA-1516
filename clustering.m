% clear all variables
clear;

% load image
img = imread('fotos_resized\pe1.jpg');

% convert image from RGB to LAB
cform = makecform('srgb2lab');
lab = applycform(img,cform);

% classify colors
ab = double(lab(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

% repeats 3 times the clustering process for better results 
ncolors = 3;
%[cluster_idx, cluster_center] = kmeans(ab,ncolors,'distance','sqEuclidean','Replicates',3);
%[cluster_idx, cluster_center] = kmeans(ab,ncolors,'distance','cityblock','Replicates',3);
[cluster_idx, cluster_center] = kmeans(ab,ncolors,'distance','cosine','Replicates',3);

% label every pixel by k-means
pixel_labels = reshape(cluster_idx,nrows,ncols);
%imshow(pixel_labels,[]); title('Image Labeled by Cluster Index');

% separate image by color
segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:ncolors
    color = img;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

% plot all clusters' results
figure;
subplot(221);
imshow(img);
title('Original');

subplot(222);
imshow(segmented_images{1});
title('Cluster 1');

subplot(223);
imshow(segmented_images{2});
title('Cluster 2');

subplot(224);
imshow(segmented_images{3});
title('Cluster 3');



