%%
clear;clc;
%%
%trainingData = pedestrianDS;
trainingData = gTruth;
%%
trainingData.imageFilename = fullfile(trainingData.imageFilename);
%%
rng(0);
shuffledIdx = randperm(height(trainingData));
trainingData = trainingData(shuffledIdx,:);

%%
imds = imageDatastore(trainingData.imageFilename);
%imdsTrain = imageDatastore(trainingDataTbl{:,'imageFilename'});
%bldsTrain = boxLabelDatastore(trainingDataTbl(:,'vehicle'));
%%
blds = boxLabelDatastore(trainingData(:,2:end));

%%
ds = combine(imds, blds);

%%
net = load('yolov2VehicleDetector.mat');
lgraph = net.lgraph

%%
plot(lgraph);

%%
options = trainingOptions('sgdm',...
          'InitialLearnRate',0.001,...
          'Verbose',true,...
          'MiniBatchSize',16,...
          'MaxEpochs',20,...
          'Shuffle','never',...
          'VerboseFrequency',30,...
          'CheckpointPath',tempdir);
%%
[detector,info] = trainYOLOv2ObjectDetector(ds,lgraph,options);

%%
figure
plot(info.TrainingLoss)
grid on
xlabel('Number of Iterations')
ylabel('Training Loss for Each Iteration')

%%
im = imread("YOLO_CROSS_WALK_0139.png");
imshow(im);
%%
k= im;
%%
imresize(k,[128, 128]);
imshow(k);
%%
[bboxes,scores] = detect(detector,k);
%%
if(~isempty(bboxes))
    imgq = insertObjectAnnotation(k,'rectangle',bboxes,scores);
end
    
figure(2)
imshow(imgq)
%%
vid = VideoReader("YOLO_CROSS_WALK_.avi"); %Video performs better when moved outside for loop.
numFrames = vid.NumberOfFrames;
n=numFrames;
%%
for i = 1:1:n
  frames = read(vid,i);
  [bboxes,scores] = detect(detector,frames);
  pause_duration = 0
  if(~isempty(bboxes))
    frames = insertObjectAnnotation(frames,'rectangle',bboxes,scores);
    pause_duration = 0.1
  end
  image(frames);
  drawnow; % Force immediate repainting of screen.
  pause(pause_duration);
end 



