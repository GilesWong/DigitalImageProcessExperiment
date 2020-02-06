diagram_rows = 2;
diagram_cols = 5;
dctParam = 8;
n = 3;

for img=1:5
    img_name = [num2str(img),'.jpg'];
    RGB = imread(img_name);
    RGB = im2double(RGB);
    R = RGB(:,:,1);
    G = RGB(:,:,2);
    B = RGB(:,:,3);
    R_blkdctd = blockDCT(R, dctParam);
    G_blkdctd = blockDCT(G, dctParam);
    B_blkdctd = blockDCT(B, dctParam);
    figure(img);
    subplot(diagram_rows, diagram_cols, 1),imshow(RGB),title('原始图像');
    subplot(diagram_rows, diagram_cols, 2),imshow(abs(R_blkdctd)),title('R通道处理结果');
    subplot(diagram_rows, diagram_cols, 3),imshow(abs(G_blkdctd)),title('G通道处理结果');
    subplot(diagram_rows, diagram_cols, 4),imshow(abs(B_blkdctd)),title('B通道处理结果');
    
    R_iblkdctd = blockiDCT(R_blkdctd, dctParam);
    G_iblkdctd = blockiDCT(G_blkdctd, dctParam);
    B_iblkdctd = blockiDCT(B_blkdctd, dctParam);
    
    iblkdctd = cat(3, R_iblkdctd, G_iblkdctd, B_iblkdctd);
    subplot(diagram_rows, diagram_cols, 5),imshow(iblkdctd),title('反dct后图像');
    
    R_blkdctd_modified = modifyDCTImg(R_blkdctd, n);
    G_blkdctd_modified = modifyDCTImg(G_blkdctd, n);
    B_blkdctd_modified = modifyDCTImg(B_blkdctd, n);
    subplot(diagram_rows, diagram_cols, 6),imshow(abs(R_blkdctd_modified)),title('修改后R通道处理结果');
    subplot(diagram_rows, diagram_cols, 7),imshow(abs(G_blkdctd_modified)),title('修改后G通道处理结果');
    subplot(diagram_rows, diagram_cols, 8),imshow(abs(B_blkdctd_modified)),title('修改后B通道处理结果');
    
    R_iblkdctd_modified = blockiDCT(R_blkdctd_modified, dctParam);
    G_iblkdctd_modified = blockiDCT(G_blkdctd_modified, dctParam);
    B_iblkdctd_modified = blockiDCT(B_blkdctd_modified, dctParam);
    
    iblkdctd_modified = cat(3,R_iblkdctd_modified,G_iblkdctd_modified,B_iblkdctd_modified);
    subplot(diagram_rows, diagram_cols, 9),imshow(iblkdctd_modified),title('修改后反dct后图像')
    
    

end



function result = blockDCT(data, n)
    [row, col] = size(data);
    processedImg = zeros(row, col);
    step = n - 1;
    i = 1;
    while i <= row
        j = 1;
        if i + step <= row
            down = i + step;
        else
            down = row;
        end
        while j<= col
            if j + step <= col
                right = j + step;
            else
                right = col;
            end
            processedImg(i:down,j:right) = dct2(data(i:down, j:right));
            j = j + n;
        end
        i = i + n;
    end
    result = processedImg;
end

function result = modifyDCTImg(data, n)
    [row, col] = size(data);
    processed = zeros(row,col);
    for i = 1:row
        for j = 1:col
%             if data(i,j) < n
%                 processed(i,j) = 0;
%             else
%                 processed(i,j) = data(i,j);
%             end
             processed(i,j) = round(data(i,j) / n) * n;
             
        end
    end
    result = processed;
end

function result = blockiDCT(data, n)
    [row, col] = size(data);
    processedImg = zeros(row, col);
    step = n - 1;
    i = 1;
    while i <= row
        j = 1;
        if i + step <= row
            down = i + step;
        else
            down = row;
        end
        while j<= col
            if j + step <= col
                right = j + step;
            else
                right = col;
            end
            processedImg(i:down,j:right) = idct2(data(i:down, j:right));
            j = j + n;
        end
        i = i + n;
    end
    result = processedImg;
end