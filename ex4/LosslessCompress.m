diagram_row = 1;
diagram_col = 3;

for imgs = 1:5
    img_name = [num2str(imgs),'.jpg'];
    img = imread(img_name);
    figure(imgs);
    
    newPlot(diagram_row,diagram_col,img,1,'原图');
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);
    
    [height, width] = size(R);
    
    %RLE压缩
    R_RLE = RLEProc(R);
    G_RLE = RLEProc(G);
    B_RLE = RLEProc(B);
     
    R_RLE_de = uint8(RLEDecode(R_RLE));
    G_RLE_de = uint8(RLEDecode(G_RLE));
    B_RLE_de = uint8(RLEDecode(B_RLE));
 
    R_ratio = RLECompRatio(R,R_RLE);
    G_ratio = RLECompRatio(G,G_RLE);
    B_ratio = RLECompRatio(B,B_RLE);
     
    img_de = cat(3,R_RLE_de,G_RLE_de,B_RLE_de);
    RLE_Compress_Ratio = (R_ratio + R_ratio + B_ratio) / 3;
    newPlot(diagram_row,diagram_col,img_de,2,['RLE,压缩比为',num2str(RLE_Compress_Ratio)]);
     
    %Huffman压缩
    R_dict = getHuffmanDict(R);
    G_dict = getHuffmanDict(G);
    B_dict = getHuffmanDict(B);
    
    R_huff = Huffenco(R, R_dict);
    G_huff = Huffenco(G, G_dict);
    B_huff = Huffenco(B, B_dict);
    
    R_huff_de = uint8(huffdeco(R_huff, R_dict));
    G_huff_de = uint8(huffdeco(G_huff, G_dict));
    B_huff_de = uint8(huffdeco(B_huff, B_dict));
    
    R_huff_ratio = HuffmanCompRatio(R, R_huff, R_dict);
    G_huff_ratio = HuffmanCompRatio(G, G_huff, G_dict);
    B_huff_ratio = HuffmanCompRatio(B, B_huff, B_dict);
    
    huff_ratio = (R_huff_ratio+G_huff_ratio+B_huff_ratio)/3;
    img_dehuff = cat(3,R_huff_de,G_huff_de,B_huff_de);
    newPlot(diagram_row,diagram_col,img_dehuff,3,['huffman,压缩比为:',num2str(huff_ratio)]);
end

function newPlot(row,col,data,count,plotTitle)
    subplot(row,col,count);
    imshow(data);
    title(plotTitle);
end

%行程编码
function result = RLEProc(data)
    [row, col] = size(data);
    RLE(1, 1:2) = [row, col];
    t = 2;
    count = 1;
    color = data(1,1);
    for i=1:row
        for j=1:col
            if ~(i == 1 && j == 1) %data(i,j)
                if data(i,j) == color
                    count = count+1;
                else
                    RLE(t, 1:2) = [count, color];
                    count = 1;
                    color = data(i,j);
                    t = t+1;
                end
            end
        end
    end
    RLE(t, 1:2) = [count, color];
    result = RLE;
end

%行程解码
function result = RLEDecode(data)
    row = data(1,1);
    col = data(1,2);
    temp_img = zeros(row,col);
    length_data = length(data);
    i = 1;%行
    j = 1;%列
    for t=2:length_data
        count = data(t,1);
        color = data(t,2);
        for k=1:count
            if j<=col
                temp_img(i,j) = color;
                j=j+1;
            else
                j = 1;
                i = i+1;
                temp_img(i,j) = color;
                j=j+1;
            end
        end
    end
    result = temp_img;
end
 
%行程压缩比
function result = RLECompRatio(data, compressed_data)
    [height,width] = size(data);
    [height_comp, width_comp] = size(compressed_data);
    
    comp_deep = 1;
    for i=1:height_comp
        if comp_deep < compressed_data(i,1)
            comp_deep = compressed_data(i,1);
        end
    end

    comp_depth = 1;
    while 2^comp_depth<comp_deep
        comp_depth = comp_depth+1;
    end
    
    sizeofdata = height * width * 8;
    sizeofcomp = height_comp * 8 + height_comp * comp_depth;

    result = sizeofcomp / sizeofdata;
end

%Huffman词典
function result = getHuffmanDict(data)
    % 统计像素值
    [row,col]=size(data);
    count = zeros(1,256);
    for i=1:row
        for j=1:col
            if data(i,j)==255
                count(1, 256) = count(1, 256)+1;
            else
                count(1, data(i,j)+1) = count(1, data(i,j)+1)+1;
            end
        end
    end
    
    t = 1;
    for i=1:256
        if count(1,i)~=0
            amount = count(1,i);
            color = i-1;
            leftPos = 0;
            rightPos = 0;
            code = 0;
            leaf_nodes(t,1:5) = [amount,color,leftPos,rightPos,code];
            t = t+1;
        end
    end
    
    leaf_nodes = sortrows(leaf_nodes, 1, 'descend');
    numofnodes = length(leaf_nodes);
    
    sizeoftree = 2*length(leaf_nodes) - 1;
    tree = zeros(sizeoftree, 5);
    
    tree(1,1:5) = [0,0,2,3,0]
    for i=1:numofnodes - 2
        tree(2*i,1:5) = [0,0,2*i+2,2*i+3,0];
        tree(2*i+1, 1:5) = leaf_nodes(i,1:5);
    end
    tree(sizeoftree - 1,1:5) = leaf_nodes(numofnodes-1,1:5);
    tree(sizeoftree,1:5) = leaf_nodes(numofnodes,1:5);
    
    nodePos = 4;
    nodeCode = strvcat('0','0','1');
    
    while(nodePos <= sizeoftree)
        leftPos = tree(nodePos,3);
        rightPos = tree(nodePos,4);
        if (leftPos == 0 || rightPos == 0) %有值节点
            lastCode = strip(nodeCode(nodePos-3,:));
            codeofcurrentnode = strcat(lastCode,'1');
            nodeCode = strvcat(nodeCode, codeofcurrentnode);
        else %无值节点
            parentCode = strip(nodeCode(nodePos-2,:));
            codeofcurrentnode = strcat(parentCode, '0');
            nodeCode = strvcat(nodeCode, codeofcurrentnode);
        end
        nodePos = nodePos + 1;
    end
    
    for i=1:numofnodes - 2
        colorVal = tree(2*i+1,2);
        colorCode = strip(nodeCode(2*i+1,:));
        leaf_code(1:2, i) = [num2str(colorVal);convertCharsToStrings(colorCode)];
    end
    colorVal = tree(sizeoftree - 1, 2);
    colorCode = strip(nodeCode(sizeoftree - 1,:));
    leaf_code(1:2,numofnodes - 1) = [num2str(colorVal);convertCharsToStrings(colorCode)];
    colorVal = tree(sizeoftree, 2);
    colorCode = strip(nodeCode(sizeoftree,:));
    leaf_code(1:2,numofnodes) = [num2str(colorVal);convertCharsToStrings(colorCode)];
    
    result = leaf_code;
end

%Huffman编码
function result = Huffenco(img, dict)
    [row,col] = size(img);
    huffman = zeros(row,1);
    huffman = num2str(huffman);
    huffman = string(huffman);
    
    for i=1:row
        for j=1:col
            color = num2str(img(i,j));
            pos = dict(1,:) == color;
            huffman(i,j) = dict(2,pos);
        end
    end
    
    result = huffman;
end

%Huffman解码
function result = huffdeco(huffman, dict)
    [row,col] = size(huffman);
    img = zeros(row,col);
    for i=1:row
        for j=1:col
            str_code = huffman(i,j);
            pos = dict(2,:)==str_code;
            img(i,j) = dict(1,pos);
        end
    end
    result = img;
end

function result = HuffmanCompRatio(data,compressed,dict)
    [height,width] = size(data);
    [compressed_height,compressed_width] = size(compressed);
    [dict_row,dict_col] = size(dict);
    
    comp_size = 0;
    dict_depth = 0;
    for i=1:compressed_height
        for j=1:compressed_width
            code_depth = strlength(compressed(i,j));
            if code_depth>dict_depth
                dict_depth = code_depth;
            end
            comp_size = comp_size+code_depth;
        end
    end
    %2^8=256
    data = height*width*8;
    dict_size = dict_col*(8+dict_depth);
    result = (comp_size+dict_size)/data;

end




