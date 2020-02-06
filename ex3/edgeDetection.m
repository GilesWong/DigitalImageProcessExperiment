diagram_row = 5;
diagram_col = 6;
sobelParam = 0.2;
prewittParam = 0.2;
robertsParam = 0.2;
laplacianParam = 0.2;
houghParams = [10, 20, 30];


for imgs = 1:5
    img_name = [num2str(imgs),'.jpg'];
    img = imread(img_name);
    figure(imgs);
    img = rgb2gray(img);
    newPlot(diagram_row,diagram_col,img,1,"原图");
    
    img_sobel = sobelDetection(img, sobelParam);
    newPlot(diagram_row,diagram_col,img_sobel,2,"Sobel算子");
    drawHough(diagram_row, diagram_col, img_sobel, 2, houghParams, "Sobel");
    
    img_prewitt = prewittDetection(img, prewittParam);
    newPlot(diagram_row,diagram_col,img_prewitt,3,"Prewitt算子");
    drawHough(diagram_row, diagram_col, img_prewitt, 3, houghParams, "Prewitt");
    
    img_robert = robertsDetection(img, robertsParam);
    newPlot(diagram_row,diagram_col,img_robert,4,"Robert算子");
    drawHough(diagram_row, diagram_col, img_robert, 4, houghParams, "Robert");
    
    img_laplacian = laplacianDetection(img, laplacianParam);
    newPlot(diagram_row,diagram_col,img_laplacian,5,"Laplacian算子");
    drawHough(diagram_row, diagram_col, img_laplacian, 5, houghParams, "Laplacian");
    
    
    
end

function newPlot(row,col,data,count,plotTitle)
    subplot(row,col,count);
    imshow(data);
    title(plotTitle);
end

function result = sobelDetection(data, threshold)
    [height, width] = size(data);
    data = im2double(data);
    S = data;
    for i = 2:height - 1
        for j = 2:width - 1
            Sx = data(i-1, j+1) + 2*data(i, j+1) + data(i+1, j+1) - data(i-1, j-1) - 2*data(i, j-1) - data(i+1, j-1);
            Sy = data(i-1, j-1) + 2*data(i-1, j) + data(i-1, j+1) - data(i+1, j-1) - 2*data(i+1, j) - data(i+1, j+1);
            S(i, j) = abs(Sx) + abs(Sy);
            if S(i, j) < threshold
                S(i, j) = 0;
            else
                S(i, j) = 255;
            end
        end
    end
    result = S;
%     F2 = im2double(data);
%     U = im2double(data);
%     uSobel = data;
%     for i = 2:height - 1
%         for j = 2:width - 1
%            Gx = (U(i+1,j-1) + 2*U(i+1,j) + F2(i+1,j+1)) - (U(i-1,j-1) + 2*U(i-1,j) + F2(i-1,j+1));
%            Gy = (U(i-1,j+1) + 2*U(i,j+1) + F2(i+1,j+1)) - (U(i-1,j-1) + 2*U(i,j-1) + F2(i+1,j-1));
%            uSobel(i,j) = sqrt(Gx^2 + Gy^2); 
%            if uSobel(i,j) < threshold
%                uSobel(i,j) = 0;
%            end
%         end    
%     end
%     result = uSobel;
end

function result = prewittDetection(data, threshold)
    [height, width] = size(data);
    data = im2double(data);
    P = data;
    for i = 2:height - 1
        for j = 2:width - 1
            Dx = (data(i+1, j-1) - data(i-1, j-1)) + (data(i+1, j) - data(i-1 ,j)) + (data(i+1, j+1) - data(i-1, j+1));
            Dy = (data(i-1, j+1) - data(i-1, j-1)) + (data(i, j+1) - data(i, j-1)) + (data(i+1, j+1) - data(i+1, j-1));
            P(i, j) = sqrt(Dx^2 + Dy^2);
            if P(i, j) < threshold
                P(i, j) = 0;
            else
                P(i, j) = 255;
            end
        end
    end
    result = P;
end

function result = robertsDetection(data, threshold)
    [height, width] = size(data);
    data = im2double(data);
    R = data;
    for i = 2:height - 1
        for j = 2:width - 1
            Rx = data(i, j) - data(i+1, j+1);
            Ry = data(i+1, j) - data(i, j+1);
            R(i, j) = abs(Rx) + abs(Ry);
            if R(i, j) < threshold
                R(i, j) = 0;
            else
                R(i, j) = 255;
            end
        end
    end
    result = R;
end

function result = laplacianDetection(data, threshold)
    [height, width] = size(data);
    data = im2double(data);
    L = data;
    for i = 2:height - 1
        for j = 2:width - 1
            L(i, j) = abs(4*data(i, j) - data(i-1, j)- data(i+1, j) - data(i,j+1) - data(i,j-1));
            if L(i, j) < threshold
                L(i, j) = 0;
            else
                L(i, j) = 255;
            end
        end
    end
    result = L;
end

function drawHough(row, col, data, index, peaks, typeTitle)
    for i = 1:length(peaks)
        drawHoughDetection(row, col, data, index + i * col, peaks(1,i), [typeTitle, '进行提取后,参数为:', num2str(peaks(1,i))]);
    end
end

function drawHoughDetection(row, col, data, diagram_index, peak, plotTitle)
    subplot(row, col, diagram_index);
    imshow(abs(data));
    hold on;
    [H, T, R] = hough(data);
    peaks = houghpeaks(H, peak);
    lines = houghlines(data, T, R, peaks);
    numberOfLines = length(lines);
    for i = 1:numberOfLines
        line = [lines(i).point1; lines(i).point2];
        plot(line(:,1), line(:,2), 'Color', 'red');
    end
    hold off;
    title(plotTitle);
end


