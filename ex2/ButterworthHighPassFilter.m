filterParameters = [0.1, 1, 5, 10, 20];
diagram_rows = 5;
diagram_cols = 5;

for img=1:5 
    img_name = [num2str(img),'.jpg'];
    RGB = imread(img_name);
    RGB = im2double(RGB);
    figure(img);
    subplot(diagram_rows,diagram_cols,1);
    imshow(RGB);
    title('原始图像');
    R = RGB(:,:,1);
    G = RGB(:,:,2);
	B = RGB(:,:,3);
    
    R_fft = img2fft(R);
    G_fft = img2fft(G);
    B_fft = img2fft(B);
    R_fft_enhaced = fft_enhance(R_fft);
    G_fft_enhaced = fft_enhance(G_fft);
    B_fft_enhaced = fft_enhance(B_fft);
    
    subplot(diagram_rows,diagram_cols,2),imshow(R_fft_enhaced, []),title('R通道频域原始图像');
    
    subplot(diagram_rows,diagram_cols,3),imshow(G_fft_enhaced, []),title('G通道频域原始图像');

    subplot(diagram_rows,diagram_cols,4),imshow(B_fft_enhaced, []),title('B通道频域原始图像');
    
    for i = 1:5
        R_fft_filtered = getButterworthFiltedImg(R_fft,filterParameters(1,i));
        G_fft_filtered = getButterworthFiltedImg(G_fft,filterParameters(1,i));
        B_fft_filtered = getButterworthFiltedImg(B_fft,filterParameters(1,i));
        R_fft_filtered_enhanced = fft_enhance(R_fft_filtered);
        G_fft_filtered_enhanced = fft_enhance(G_fft_filtered);
        B_fft_filtered_enhanced = fft_enhance(B_fft_filtered);
        subplot(diagram_rows,diagram_cols,1*diagram_cols+i),imshow(R_fft_filtered_enhanced, []),title(['R通道频域高通处理后，参数为：',num2str(filterParameters(1,i))]);
        
        subplot(diagram_rows,diagram_cols,2*diagram_cols+i),imshow(G_fft_filtered_enhanced, []),title(['G通道频域高通处理后，参数为：',num2str(filterParameters(1,i))]);

        subplot(diagram_rows,diagram_cols,3*diagram_cols+i),imshow(B_fft_filtered_enhanced, []),title(['B通道频域高通处理后，参数为：',num2str(filterParameters(1,i))]);
        
        R_final = im2uint8(mat2gray(fft2img(R_fft_filtered)));
        G_final = im2uint8(mat2gray(fft2img(G_fft_filtered)));
        B_final = im2uint8(mat2gray(fft2img(B_fft_filtered)));
        RGB_final = cat(3, R_final, G_final, B_final);
        subplot(diagram_rows,diagram_cols,4*diagram_cols+i),imshow(RGB_final, []),title(['高通处理后得到的最终图像，参数为：',num2str(filterParameters(1,i))]);
        
    end
end


%Butterworth高通滤波
function result = getButterworthFiltedImg(data, sigma)
    [m,n] = size(data);
    mid_m = m/2;
    mid_n = n/2;
    x = 2;
    H = zeros(m,n);
    G = zeros(m,n);
    for i = 1:m
       for j = 1:n
           D = (i - mid_m) ^ 2 + ( j - mid_n) ^ 2;
           D = sqrt(D);
           H(i,j) = 1 / (1 + (sigma / D) ^ (2 * n));
           G(i,j) = H(i,j) * data(i,j);
        end
    end
    result = G;
end

function result = img2fft(img)
    temp = fft2(img);
    temp = fftshift(temp);
    result = temp;
end

function result = fft2img(fft)
    temp = ifftshift(fft);
    temp = ifft2(temp);
    temp = real(temp);
    result = temp;
end

function result = fft_enhance(img)
    %频域视觉增强
    temp = log(1+abs(img));
    result = temp;
end