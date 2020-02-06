diagram_row = 1;
diagram_col = 4; 
block_size = 8;
quality_factors = [20,60,80];

for imgs = 1:5
    img_name = [num2str(imgs),'.jpg'];
    img = imread(img_name);
    figure(imgs);
    newPlot(diagram_row,diagram_col,img,1,'原图');
    
    imgYUV = rgb2ycbcr(img);
    Y = imgYUV(:,:,1);
    U = imgYUV(:,:,2);
    V = imgYUV(:,:,3);
    
    Y_dct = blockDCT(Y, block_size);
    U_dct = blockDCT(U, block_size);
    V_dct = blockDCT(V, block_size);
    
    for i=1:length(quality_factors)
        factor = quality_factors(1,i);
        
        Y_dct_quanti = quantization(Y_dct, factor);
        U_dct_quanti = quantization(U_dct, factor);
        V_dct_quanti = quantization(V_dct, factor);
        Y_enco = enco(Y_dct_quanti, block_size);
        U_enco = enco(U_dct_quanti, block_size);
        V_enco = enco(V_dct_quanti, block_size);
        Y_deco = deco(Y_enco);
        U_deco = deco(U_enco);
        V_deco = deco(V_enco);
        Y_deco_iquan = iquantization(Y_deco, factor);
        U_deco_iquan = iquantization(U_deco, factor);
        V_deco_iquan = iquantization(V_deco, factor);
        Y_deco_idct = blockiDCT(Y_deco_iquan, block_size);
        U_deco_idct = blockiDCT(U_deco_iquan, block_size);
        V_deco_idct = blockiDCT(V_deco_iquan, block_size);
        Info_Y = getCompressInfo(Y, Y_enco, factor);
        Info_U = getCompressInfo(U, U_enco, factor);
        Info_V = getCompressInfo(V, V_enco, factor);
        Y_error = getErrorInfo(Y, Y_deco_idct);
        U_error = getErrorInfo(U, U_deco_idct);
        V_error = getErrorInfo(V, V_deco_idct);
        
        sizeofcompressed = Info_Y(1, 1) + Info_U(1, 1) + Info_V(1, 1);
        ratio = (Info_Y(1,2) + Info_U(1,2) + Info_V(1,2)) / 3;
        error_info = (Y_error + U_error + V_error) / 3;
        YUV_deco = cat(3, Y_deco_idct, U_deco_idct,V_deco_idct);
        img_deco = ycbcr2rgb(YUV_deco);
        newPlot(diagram_row,diagram_col,img_deco,1 + i,['因子为:', num2str(factor), '大小为:', num2str(sizeofcompressed), '压缩率为:',num2str(ratio),'误差为:',num2str(error_info)]);
    end
        
end


function newPlot(row,col,data,count,plotTitle)
    subplot(row,col,count);
    imshow(data);
    title(plotTitle);
end

%dct变换
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

%量化
function result = quantization(data, factor)
    [row,col] = size(data);
    temp = zeros(row,col);
    for i=1:row
        for j=1:col
            temp(i,j) = round(data(i,j)/factor);
        end
    end
    result = temp;
end

%反dct变换
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
    result = uint8(processedImg);
end

function result = enco(data, n)
    [height,width] = size(data);
    step = n-1;
    flag = 1;
    RLE_length = 1;
	RLE(RLE_length,1:2) = [0,flag];
    i=1;
    while i <= height        
        if i+step<=height
        	goal1 = i+step;
        else
            goal1 = height;
        end
        j=1;
        while j <= width
            if j+step<=width
                goal2 = j+step;
            else
                goal2 = width;
            end
            
            if j==1
                flag = 1;
            else
                flag = 0;
            end
            
            temp_flag = [0,flag];
            temp_dct = data(i:goal1,j:goal2);
            temp_RLEZ = RLE_Z(temp_dct);
            if i==1 && j==1
                RLE = [RLE; temp_RLEZ];
            else
                RLE = [RLE; temp_flag; temp_RLEZ];
            end
            
            j = j+n;
        end
        i = i+n;
    end
    
    result = RLE;
end

function result = RLE_Z(data)
    [height,width] = size(data);
    RLE(1, 1:2) = [height, width];
    i = 1;
    j = 1;
    count = 1;
    color = data(1,1);
    t = 2;
    code_depth = 1+1;
    max_depth = height+width;
    dir = 0; 
    if height>1 && width>1
        while code_depth<=max_depth && dir~=-1
            if ~(i == 1 && j == 1) 
                if data(i,j) == color
                    count = count+1;
                else
                    RLE(t, 1:2) = [count,color];
                    count = 1;
                    color = data(i,j);
                    t = t+1;
                end
            end
            if i==1 
                if dir == 0 
                    if j+1 > width 
                        if i+1 > height 
                            dir = -1;
                        else 
                            if i+1>height
                                dir = -1;
                            else
                                i = i+1;
                                dir = 1;
                            end
                        end
                    else 
                        j = j+1;
                        dir = 1;
                    end
                    code_depth = i+j;
                else 
                    i = i+1;
                    j = j-1;
                end
            elseif j == 1
                if dir == 1 
                    if i + 1 > height 
                        if j + 1 > width 
                            dir = -1;
                        else
                            j = j + 1;
                            dir = 0;
                        end
                    else 
                        i = i + 1;
                        dir = 0;
                    end
                    code_depth = i + j;
                else
                    i = i - 1;
                    j = j + 1;
                end
            else 
                if i == height
                    if dir == 1 
                        if j + 1 > width 
                            dir = -1;
                        else 
                            j = j + 1;
                            dir = 0;
                        end
                        code_depth = code_depth + 1;
                    else 
                        if j + 1 > width
                            dir = -1;
                        else
                            i = i-1;
                            j = j+1;
                        end
                    end
                elseif j == width 
                    if dir == 0 
                        if i + 1 > height 
                            dir = -1;
                        else
                            i = i + 1;
                            dir = 1;
                        end
                        code_depth = code_depth + 1;
                    else 
                        if i + 1 > height
                            dir = -1;
                        else
                            i = i + 1;
                            j = j - 1;
                        end
                    end
                else
                    if dir == 0 
                        i = i - 1;
                        j = j + 1;
                    elseif dir == 1 
                        i = i + 1;
                        j = j - 1;
                    end 
                end

            end
        end
    else
        if height == 1
            i=1;
            for j=1:width
                if ~(i == 1 && j == 1) 
                    if data(i,j) == color
                        count = count + 1;
                    else
                        RLE(t, 1:2) = [count,color];
                        count = 1;
                        color = data(i,j);
                        t = t + 1;
                    end
                end
            end
        elseif width == 1
            j=1;
            for i=1:height
                if ~(i == 1 && j == 1) 
                    if data(i,j) == color
                        count = count + 1;
                    else
                        RLE(t, 1:2) = [count,color];
                        count = 1;
                        color = data(i,j);
                        t = t + 1;
                    end
                end                
            end
        end
    end
    
    RLE(t, 1:2) = [count,color];
    result = RLE;
end

%反编排
function result =  deco(data)    
    dataLength = length(data);
    row_img = [];
    all_img = [];
    
    i = 1;
    while i <= dataLength
        br_RLE = data(i,:);
        if br_RLE(1,1) == 0 && br_RLE(1,2) == 1 
            all_img = [all_img;row_img];
            row_img = [];
            %dct块的RLE第一位为标志位
            i = i+1;
            k = i;
            while k<=dataLength && data(k,1)~=0
                k = k+1;
            end
            k = k-1;
            dct_RLE = data(i:k,:);
            iRLE_Z_img = iRLE_Z(dct_RLE);
            row_img = [row_img,iRLE_Z_img];
            i = k;
        elseif br_RLE(1,1) == 0 && br_RLE(1,2) == 0
            i = i+1;
            k = i;
            while k <= dataLength && data(k,1) ~= 0
                k = k + 1;
            end
            k = k-1;
            dct_RLE = data(i:k,:);
            iRLE_Z_img = iRLE_Z(dct_RLE);
            row_img = [row_img,iRLE_Z_img];
            i = k;
        else 
            i = i + 1;
        end
    end
    result = all_img;
end

%反RLE Z
function result = iRLE_Z(data)
    img_height = data(1,1);
    img_width = data(1,2);
    dataLength = length(data);
    
    code_depth = 1+1;
    max_depth = img_height+img_width;
    dir = 0;
    
    area = img_height*img_width; 
    img_i = 1;
    img_j = 1;
    for k = 2:dataLength
        count = data(k,1); 
        color = data(k,2); 
        for deeps = 1:count
            if img_height > 1 && img_width > 1
                while code_depth <= max_depth && dir ~= -1 && deeps<=count
                    temp_img(img_i,img_j) = color;
                    deeps = deeps+1;
                    
                    if img_i == 1 
                        if dir == 0 
                            if img_j+1>img_width 
                                if img_i+1>img_height 
                                    dir = -1;
                                else % ↓ i>1
                                    if img_i + 1 > img_height 
                                        dir = -1;
                                    else
                                        img_i = img_i+1;
                                        dir = 1;
                                    end
                                end
                            else 
                                img_j = img_j+1;
                                dir = 1;
                            end
                            code_depth = img_i+img_j;
                        else 
                            img_i = img_i+1;
                            img_j = img_j-1;
                        end
                    elseif img_j==1 
                        if dir == 1 
                            if img_i+1>img_height 
                                if img_j+1>img_width 
                                    dir = -1;
                                else
                                    img_j = img_j+1;
                                    dir = 0;
                                end
                            else
                                img_i = img_i+1;
                                dir = 0;
                            end
                            code_depth = img_i+img_j;
                        else
                            img_i = img_i-1;
                            img_j = img_j+1;
                        end
                    else 
                        if img_i == img_height
                            if dir == 1
                                if img_j + 1 > img_width 
                                    dir = -1;
                                else
                                    img_j = img_j+1;
                                    dir = 0;
                                end
                                code_depth = code_depth+1;
                            else
                                if img_j + 1 > img_width 
                                    dir = -1;
                                else
                                    img_i = img_i-1;
                                    img_j = img_j+1;
                                end
                            end
                        elseif img_j == img_width 
                            if dir == 0 
                                if img_i + 1 > img_height 
                                    dir = -1;
                                else
                                    img_i = img_i+1;
                                    dir = 1;
                                end
                                code_depth = code_depth+1;
                            else 
                                if img_i + 1 > img_height
                                    dir = -1;
                                else
                                    img_i = img_i+1;
                                    img_j = img_j-1;
                                end
                            end
                        else
                            if dir == 0 
                                img_i = img_i-1;
                                img_j = img_j+1;
                            elseif dir == 1 
                                img_i = img_i+1;
                                img_j = img_j-1;
                            end 
                        end

                    end
                    
                end
            else 
                if img_height == 1
                    fix_i = 1;
                    while img_j <= img_width && deeps <= count
                        temp_img(fix_i,img_j) = color;
                        img_j = img_j+1;
                        deeps = deeps+1;
                    end
                elseif img_width == 1
                    fix_j = 1;
                    while img_i<=img_height && deeps<=count
                        temp_img(img_i,fix_j) = color;
                        img_i = img_i+1;
                        deeps = deeps+1;               
                    end
                end 
            end            
        end
        
    end
    result = temp_img;
end

%反量化
function result = iquantization(data,factor)
    [height,width] = size(data);
    temp = zeros(height,width);
    for i = 1:height
        for j = 1:width
            temp(i,j) = round(data(i,j)*factor);
        end
    end
    result = temp;   
end

function result = getCompressInfo(data,compressed,factor)

    [height,width] = size(data);
    [compressedHeight,compressedWidth] = size(compressed);

    comp_deep = 1;
    for i=1:compressedHeight
        if comp_deep < compressed(i,1)
            comp_deep = compressed(i,1);
        end
    end

    comp_depth = 1;
    while 2^comp_depth<comp_deep
        comp_depth = comp_depth+1;
    end

    quality_depth = 1;
    while 2^quality_depth<factor
        quality_depth = quality_depth+1;
    end
    
    data_size = height*width*8;
    comressed_size = compressedHeight*8+compressedHeight*comp_depth+quality_depth;

    ratio = comressed_size/data_size;    
    result = [comressed_size,ratio];
end

function result = getErrorInfo(data,compressed)
    [height,width] = size(compressed);
    temp_errors = data(1:height,1:width)-compressed;
    temp_mean = mean2(temp_errors);
    temp_errors = (temp_errors-temp_mean).^2;
    errors = sum(sum(temp_errors));
    errors = errors/(height*width);
    errors = sqrt(errors);
    result = errors;
end
