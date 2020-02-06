for imgs = 0:4
    img_name = [num2str(imgs),'.png'];
    img = imread(img_name);
    figure(imgs+1);
    [row, col, z] = size(img);
    g = 0 + 0.1 * randn(row, col);

    img_gauss = double(img)/255;

    img_gauss = img_gauss + g;

    img_gauss = img_gauss * 255;
    img_gauss = uint8(img_gauss);

    subplot(5,3,1),imshow(img),title('原图');
    subplot(5,3,2),imshow(img_gauss),title('加入均值为0,标准差为0.1的高斯噪声后');

    img_salt = imnoise(img, 'gaussian', 0.1);
    subplot(5,3,3),imshow(img_salt),title('加入噪声密度为0.1的椒盐噪声后');

    R_gauss = img_gauss(:,:,1);
    G_gauss = img_gauss(:,:,2);
    B_gauss = img_gauss(:,:,3);

    R_gauss_s = spacelFilter(R_gauss, 3, 3);
    G_gauss_s = spacelFilter(G_gauss, 3, 3);
    B_gauss_s = spacelFilter(B_gauss, 3, 3);

    img_gauss_s = cat(3, R_gauss_s, G_gauss_s, B_gauss_s);
    subplot(5,3,4),imshow(img_gauss_s),title('k=3均值滤波对高斯噪声去噪');

    R_gauss_s = spacelFilter(R_gauss, 3, 5);
    G_gauss_s = spacelFilter(G_gauss, 3, 5);
    B_gauss_s = spacelFilter(B_gauss, 3, 5);

    img_gauss_s = cat(3, R_gauss_s, G_gauss_s, B_gauss_s);
    subplot(5,3,5),imshow(img_gauss_s),title('k=5均值滤波对高斯噪声去噪');

    R_gauss_s = spacelFilter(R_gauss, 3, 7);
    G_gauss_s = spacelFilter(G_gauss, 3, 7);
    B_gauss_s = spacelFilter(B_gauss, 3, 7);

    img_gauss_s = cat(3, R_gauss_s, G_gauss_s, B_gauss_s);
    subplot(5,3,6),imshow(img_gauss_s),title('k=7均值滤波对高斯噪声去噪');


    R_gauss_m = medianFilter(R_gauss, 3, 3);
    G_gauss_m = medianFilter(G_gauss, 3, 3);
    B_gauss_m = medianFilter(B_gauss, 3, 3);

    img_gauss_m = cat(3, R_gauss_m, G_gauss_m, B_gauss_m);
    subplot(5,3,7),imshow(img_gauss_m),title('k=3中值滤波对高斯噪声去噪');

    R_gauss_m = medianFilter(R_gauss, 3, 5);
    G_gauss_m = medianFilter(G_gauss, 3, 5);
    B_gauss_m = medianFilter(B_gauss, 3, 5);

    img_gauss_m = cat(3, R_gauss_m, G_gauss_m, B_gauss_m);
    subplot(5,3,8),imshow(img_gauss_m),title('k=5中值滤波对高斯噪声去噪');

    R_gauss_m = medianFilter(R_gauss, 3, 7);
    G_gauss_m = medianFilter(G_gauss, 3, 7);
    B_gauss_m = medianFilter(B_gauss, 3, 7);

    img_gauss_m = cat(3, R_gauss_m, G_gauss_m, B_gauss_m);
    subplot(5,3,9),imshow(img_gauss_m),title('k=7中值滤波对高斯噪声去噪');

    R_salt = img_salt(:,:,1);
    G_salt = img_salt(:,:,2);
    B_salt = img_salt(:,:,3);

    R_salt_s = spacelFilter(R_gauss, 3, 3);
    G_salt_s = spacelFilter(G_gauss, 3, 3);
    B_salt_s = spacelFilter(B_gauss, 3, 3);

    img_salt_s = cat(3, R_salt_s, G_salt_s, B_salt_s);
    subplot(5,3,10),imshow(img_salt_s),title('k=3均值滤波对椒盐噪声去噪');

    R_salt_s = spacelFilter(R_gauss, 3, 5);
    G_salt_s = spacelFilter(G_gauss, 3, 5);
    B_salt_s = spacelFilter(B_gauss, 3, 5);

    img_salt_s = cat(3, R_salt_s, G_salt_s, B_salt_s);
        subplot(5,3,11),imshow(img_salt_s),title('k=5均值滤波对椒盐噪声去噪');

    R_salt_s = spacelFilter(R_gauss, 3, 7);
    G_salt_s = spacelFilter(G_gauss, 3, 7);
    B_salt_s = spacelFilter(B_gauss, 3, 7);

    img_salt_s = cat(3, R_salt_s, G_salt_s, B_salt_s);
    subplot(5,3,12),imshow(img_salt_s),title('k=7均值滤波对椒盐噪声去噪');

    R_salt_m = medianFilter(R_salt, 3, 3);
    G_salt_m = medianFilter(G_salt, 3, 3);
    B_salt_m = medianFilter(B_salt, 3, 3);

    img_salt_m = cat(3, R_salt_m, G_salt_m, B_salt_m);
    subplot(5,3,13),imshow(img_salt_m),title('k=3中值滤波对椒盐噪声去噪');

    R_salt_m = medianFilter(R_salt, 3, 5);
    G_salt_m = medianFilter(G_salt, 3, 5);
    B_salt_m = medianFilter(B_salt, 3, 5);

    img_salt_m = cat(3, R_salt_m, G_salt_m, B_salt_m);
    subplot(5,3,14),imshow(img_salt_m),title('k=5中值滤波对椒盐噪声去噪');

    R_salt_m = medianFilter(R_salt, 3, 7);
    G_salt_m = medianFilter(G_salt, 3, 7);
    B_salt_m = medianFilter(B_salt, 3, 7);

    img_salt_m = cat(3, R_salt_m, G_salt_m, B_salt_m);
    subplot(5,3,15),imshow(img_salt_m),title('k=7中值滤波对椒盐噪声去噪');

end



function [image_out] = spacelFilter(image_in, p, K)
% （线性）均值滤波函数
% 输入为需要进行空间滤波的灰度图像，线性方形滤波器
% 输出为经过滤波之后的图像
% 图像边缘的填充为最近的像素值，目的是消除填充0时会出现的黑框
% 滤波器的大小为 n * n, n = 2 * k + 1, k为整数
% 输入图像大小为 m * n, 灰度图像，像素值范围为0-255，L = 256

[m, n] = size(image_in);
filter = zeros(p, p, 'uint8');
for i = 1 : p
    for j = 1 : p
        filter(i, j) = 1;
    end
end
[mf, nf] = size(filter);
k = (mf - 1) / 2;
image2 = zeros(m+2*k, n+2*k, 'double');
image_out = zeros(m, n, 'uint8');
% 填充部分
% 内部直接复制
for i = 1+k : m+k
    for j = 1+k : n+k
        image2(i, j) = image_in(i-k, j-k);
    end
end
% 填充上下边缘
for i = 1 : k
    for j = 1 : n
        image2(i, j+k) = image_in(1, j);
        image2(m+k+i, j+k) = image_in(m, j);
    end
end
% 填充左右边缘
for i = 1 : m
    for j = 1 : k
        image2(i+k, j) = image_in(i, 1);
        image2(i+k, n+k+j) = image_in(i, n);
    end
end
% 填充四个角
for i = 1 : k
    for j = 1 : k
        image2(i, j) = image_in(1, 1); %填充左上角
        image2(i, j+n+k) = image_in(1, n); %填充右上角
        image2(i+n+k, j) = image_in(m, 1); %填充左下角
        image2(i+n+k, j+n+k) = image_in(m, n); %填充右下角
    end
end
 
% 滤波部分
for i = 1+k : m+k
    for j = 1+k : n+k
        sub_image = image2(i-k:i+k, j-k:j+k);
        sub_image_array = reshape(sub_image, 1, []);
        [val, id] = sort(abs(sub_image_array-image2(i, j)));
            for Ki=2:1+K
                t = Ki-1;
                C(t,1)=sub_image_array(1, id(1,Ki));
            end
        %temp2 = sum(temp1(:)) / coeff;
        image_out(i, j) = round(mean(C));
    end
end
 
end


function [image_out] = medianFilter(image_in, p, K)
% （线性）均值滤波函数
% 输入为需要进行空间滤波的灰度图像，线性方形滤波器
% 输出为经过滤波之后的图像
% 图像边缘的填充为最近的像素值，目的是消除填充0时会出现的黑框
% 滤波器的大小为 n * n, n = 2 * k + 1, k为整数
% 输入图像大小为 m * n, 灰度图像，像素值范围为0-255，L = 256

[m, n] = size(image_in);
filter = zeros(p, p, 'uint8');
for i = 1 : p
    for j = 1 : p
        filter(i, j) = 1;
    end
end
[mf, nf] = size(filter);
k = (mf - 1) / 2;
image2 = zeros(m+2*k, n+2*k, 'double');
image_out = zeros(m, n, 'uint8');
% 填充部分
% 内部直接复制
for i = 1+k : m+k
    for j = 1+k : n+k
        image2(i, j) = image_in(i-k, j-k);
    end
end
% 填充上下边缘
for i = 1 : k
    for j = 1 : n
        image2(i, j+k) = image_in(1, j);
        image2(m+k+i, j+k) = image_in(m, j);
    end
end
% 填充左右边缘
for i = 1 : m
    for j = 1 : k
        image2(i+k, j) = image_in(i, 1);
        image2(i+k, n+k+j) = image_in(i, n);
    end
end
% 填充四个角
for i = 1 : k
    for j = 1 : k
        image2(i, j) = image_in(1, 1); %填充左上角
        image2(i, j+n+k) = image_in(1, n); %填充右上角
        image2(i+n+k, j) = image_in(m, 1); %填充左下角
        image2(i+n+k, j+n+k) = image_in(m, n); %填充右下角
    end
end
 
% 滤波部分
for i = 1+k : m+k
    for j = 1+k : n+k
        sub_image = image2(i-k:i+k, j-k:j+k);
        sub_image_array = reshape(sub_image, 1, []);
        [val, id] = sort(abs(sub_image_array-image2(i, j)));
            for Ki=2:1+K
                t = Ki-1;
                C(t,1)=sub_image_array(1, id(1,Ki));
            end
        image_out(i, j) = median(C);
    end
end
 
end
