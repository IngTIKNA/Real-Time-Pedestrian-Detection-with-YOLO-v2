%____________________________  Image Resize ____________________________________________
%%
im_size  = [416,416];
srcFiles = dir(['*.png']);
%%
for i = 1 : length(srcFiles)
    filename = [srcFiles(i).name];
    im = imread(filename);
    k=imresize(im,im_size);
    newfilename=[srcFiles(i).name];
    imwrite(k,newfilename,'png');
end
%______________________________________________________________________________________
%______________________________________________________________________________________
%%

