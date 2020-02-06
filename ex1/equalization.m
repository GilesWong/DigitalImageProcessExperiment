
for imgs = 0:5 %6��ͼƬ
    %��ȡͼ��
    img_name = [num2str(imgs),'.jpg'];
    RGB = imread(img_name);
    figure(imgs+1);
    subplot(3,4,1); %3x4��ͼ��չʾ
    imshow(RGB);
    title('ԭͼ');
    R = RGB(:,:,1);
    G = RGB(:,:,2);
    B = RGB(:,:,3);
    subplot(3,4,2);
    imhist(R);
    title('R');
    subplot(3,4,3);
    imhist(G);
    title('G');
    subplot(3,4,4);
    imhist(B);
    title('B');   
    res = delta(RGB);
    
    R2 = histogram(R,res); %��Rͨ�����⻯
    subplot(3,4,6);
    imhist(R2);
    title('R�����');
    G2 = histogram(G,res); %��Gͨ�����⻯
    subplot(3,4,7);
    imhist(G2);
    title('G�����');
    B2 = histogram(B,res); %��Bͨ�����⻯
    subplot(3,4,8);
    imhist(B2);
    title('B�����');
    img2=cat(3,R2,G2,B2); %cat�����γ���ά����
    subplot(3,4,5);
    imshow(img2);
    title('�����');
    
    HSI = rgb2hsi(RGB); %��RGB���HSI
    H = HSI(:,:,1);     %�ֱ�ȡH S Iͨ��
    S = HSI(:,:,2);
    I = HSI(:,:,3);
    
    %Iֱ��ͼ���⻯
    %RGBΪuint8��
    I2 = im2uint8(I);
    I2 = histogramI(I2);%histogram��Ҫʹ��uint8 ���ҷ���uint8 
    I2 = im2double(I2);%HSIΪdouble��
    
    HSI2 = cat(3,H,S,I2);   %Iͨ�����⻯����������HSIͼ��
    HSI2 = hsi2rgb(HSI2);
    subplot(3,4,9);
    imshow(HSI2);
    title('����2');

end

%�����ͨ��ƽ���ĸ��Ҷ�ֵ����
function res = delta(rgb)
    count = zeros(1,256);
    for i = 1:3
        I = rgb(:,:,i);
        [row, col] = size(I);
        for j = 1:row
            for k = 1:col
                count(1,I(j,k)+1) = count(1,I(j, k)+1)+1;
            end
        end
    end
    count = count/3; %���Ҷ�ֵ�ļ���ƽ��
    res = count;
end

%���⻯����
function imgE = histogram(img, res)
    [row,col] = size(img);  %ͼƬ�����С
    area = row*col;
    count = double(res);%����֮ǰͳ�ƵĻҶ�ֵ���о��⻯
    %ԭֱ��ͼ
    p = zeros(1,256);
    p = double(p);
    %����ֱ��ͼ
    p2 = zeros(1,256);
    p2 = double(p2);
    
    %ԭͼ����ֱ��ͼ
    for i = 1:256
        p(1,i) = count(1,i)/area;
    end

    %����ֱ��ͼ
    for i=1:256
        for j=1:i
            p2(1,i)=p2(1,i)+p(1,j);
        end
        p2(1,i)=p2(1,i)*255;
    end
    %�ü���õ������ݴ���ԭ����
    for i = 1:row
        for j = 1:col
            deep=img(i,j)+1;
            img(i,j)=p2(1,deep);
        end
    end
    
    imgE = img;
end


%HSIʹ�õľ��⻯����
function imgE = histogramI(img)
    [row,col] = size(img);  %ͼƬ�����С
    area = row*col;
    count = zeros(1,256);%0-255����
    for i = 1:row
        for j = 1:col
            count(1,img(i,j)+1) = count(1,img(i,j)+1)+1; %��ȡԭͼ�ĸ��Ҷ�ֵ����
        end
    end
    %ԭֱ��ͼ
    p = zeros(1,256);
    p = double(p);
    %����ֱ��ͼ
    p2 = zeros(1,256);
    p2 = double(p2);
    
    count = double(count);
    %ԭͼ����ֱ��ͼ
    for i = 1:256
        p(1,i) = count(1,i)/area;
    end

    %����ֱ��ͼ
    for i=1:256
        for j=1:i
            p2(1,i)=p2(1,i)+p(1,j);
        end
        p2(1,i)=p2(1,i)*255;
    end
    %�ü���õ������ݴ���ԭ����
    for i = 1:row
        for j = 1:col
            deep=img(i,j)+1;
            img(i,j)=p2(1,deep);
        end
    end
    
    imgE = img;
end

function hsi = rgb2hsi(rgb)
    rgb = im2double(rgb);
    r = rgb(:, :, 1);
    g = rgb(:, :, 2);
    b = rgb(:, :, 3);

    num = 0.5*((r - g) + (r - b));
    den = sqrt((r - g).^2 + (r - b).*(g - b));
    theta = acos(num./(den + eps));

    H = theta;
    H(b > g) = 2*pi - H(b > g);
    H = H/(2*pi);

    num = min(min(r, g), b);
    den = r + g + b;
    den(den == 0) = eps;
    S = 1 - 3.* num./den;

    H(S == 0) = 0;

    I = (r + g + b)/3;
    
    hsi = cat(3, H, S, I);
end

%HSIתRGB
function rgb = hsi2rgb(hsi)
    H = hsi(:, :, 1) * 2 * pi; 
    S = hsi(:, :, 2); 
    I = hsi(:, :, 3); 
    
    R = zeros(size(hsi, 1), size(hsi, 2)); 
    G = zeros(size(hsi, 1), size(hsi, 2)); 
    B = zeros(size(hsi, 1), size(hsi, 2)); 
    
    idx = find( (0 <= H) & (H < 2*pi/3)); 
    B(idx) = I(idx) .* (1 - S(idx)); 
    R(idx) = I(idx) .* (1 + S(idx) .* cos(H(idx)) ./ cos(pi/3 - H(idx))); 
    G(idx) = 3*I(idx) - (R(idx) + B(idx)); 
    
    idx = find( (2*pi/3 <= H) & (H < 4*pi/3) ); 
    R(idx) = I(idx) .* (1 - S(idx)); 
    G(idx) = I(idx) .* (1 + S(idx) .* cos(H(idx) - 2*pi/3) ./ cos(pi - H(idx))); 
    B(idx) = 3*I(idx) - (R(idx) + G(idx)); 
    
    idx = find( (4*pi/3 <= H) & (H <= 2*pi)); 
    G(idx) = I(idx) .* (1 - S(idx)); 
    B(idx) = I(idx) .* (1 + S(idx) .* cos(H(idx) - 4*pi/3) ./cos(5*pi/3 - H(idx))); 
    R(idx) = 3*I(idx) - (G(idx) + B(idx)); 
    
    rgb = cat(3, R, G, B); 
    rgb = max(min(rgb, 1), 0);
end