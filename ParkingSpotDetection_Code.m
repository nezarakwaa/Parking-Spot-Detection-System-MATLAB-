clc;
close all;
clear all;
%request user entry and convert entry to number and disply in dialog box
Num_Spots_Lot = inputdlg('Entr The Total Parking Spots number?')
Save_entered_value = str2num(Num_Spots_Lot{1})
%retrive image for cars parked and resize image 
Image = imread('FiveCarsParked.jpg');
Image = imresize(Image,[400 NaN]); % image loading unit
figure(20), imshow(Image);
%original image histogram 
HistOrigImg=histogram(Image)
%image empty parking lot and resizing it 
Image_2 =imread('NoCarParked.jpg');
Image_2 = imresize(Image_2,[400 NaN]); % image loading unit
figure(2), imshow(Image_2);
%subtracting Empty and occupied lot
sub = imsubtract(Image,Image_2);
figure(3), imshow(sub);
%convert the truecolor RGB to the grayscale image 
Igray = rgb2gray(sub);
figure(4), imshow(Igray);
%gray image histogram 
HistGrayImg=histogram(Igray)
%Convert grayscale to binary image with level specified
level=0.02;
Imgthresh = im2bw(Igray,level);
%arranges the images so that they roughly form a square
figure(5),imshowpair(Image,Imgthresh, 'montage'); 
%fill background pixels of the input binary image 
Imgfilled = imfill(Imgthresh,'holes');
figure(6), imshow(Imgfilled);
%structuring element: morphological disk-shaped element
structDisk = strel ('disk',5);
%morphological opening on the grayscale or binary image 
Imgopen = imopen(Imgfilled,structDisk);
figure(7), imshow(Imgopen);
%remove small objects from binary image
RmvSml=bwareaopen(Imgopen,4,4); 
figure(8), imshow(RmvSml)
%bounding box for detected cars measuring image regions
Iprops=regionprops(RmvSml,'BoundingBox','Image');
hold on
text(8,785,strcat('\color{green}Cars Detected:',num2str(length(Iprops))))
hold on
for n=1:size(Iprops,1)
rectangle('Position',Iprops(n).BoundingBox,'EdgeColor','r','LineWidth',2);
end
%count number of occupied cars
result = sprintf('%d',n-0);
disp(result);
%convert the results from string to number
ConvToNumb= str2num(result)
%count available spots
AvaSpots = minus(Save_entered_value, ConvToNumb);
disp(AvaSpots)
%convert from number array to charactor array
CovFinalToStr= num2str(AvaSpots)
disp(CovFinalToStr)
%create dialog box to disply the final results
f = msgbox(['The current availabe spots in this lot is: ',CovFinalToStr]);
hold off
