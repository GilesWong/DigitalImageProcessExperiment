diagram_row = 5;
diagram_col = 6;

for imgs = 1:5
    img_name = [num2str(imgs),'.jpg'];
    img = imread(img_name);
    figure(imgs);
    img = rgb2gray(img);
    newPlot(diagram_row,diagram_col,img,1,"原图");
    
    DrawHist(diagram_row, diagram_col, img, 2, '灰度直方图');
    img_divided = HistThreshold(img);
    newPlot(diagram_row, diagram_col, img_divided, 3, '2值图像');
    
end


function DrawHist(out_row, out_col, img, pos, tit)
    [height,width] = size(img);
    count = zeros(1,256);
    for i = 1:height
        for j = 1:width
            count(1,img(i,j)+1) = count(1,img(i,j)+1)+1;
        end
    end
    subplot(out_row,out_col,pos);
    bar(count);
    title(tit);
end

function result = HistThreshold(data)
    [height,width] = size(data);
    temp_img = data;
    count = zeros(1,256);
    for i = 1:height
        for j = 1:width
            count(1,data(i,j)+1) = count(1,data(i,j)+1)+1;
        end
    end

    max1 = 1;
    max2 = 1;

    for i=2:256
        temp = count(1,i);
        if temp > count(1,max1)
            max2 = max1;
            max1 = i;
        elseif temp > count(1,max2)
            max2 = i;
        end
    end
    
    mid = round((max1+max2)/2);   
    threshold = mid;
    
    for i = 1:height
        for j = 1:width
            if temp_img(i,j) < threshold
                temp_img(i,j) = 0;
            else
                temp_img(i,j) = 255;
            end
        end
    end
    result = temp_img;
end

function newPlot(row,col,data,count,plotTitle)
    subplot(row,col,count);
    imshow(data);
    title(plotTitle);
end