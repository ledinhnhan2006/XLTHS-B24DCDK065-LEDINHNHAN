clc; clear; close all;

%% ===== 1. TẠO ÂM THANH =====
Fs = 8000;
t = 0:1/Fs:2;

x = sin(2*pi*440*t); % âm gốc

%% ===== 1. ĐỌC FILE ÂM THANH =====
[file, path] = uigetfile({'*.mp3'}, 'Chon file am thanh');
if isequal(file,0), return; end

[x, Fs] = audioread(fullfile(path, file));

% Nếu stereo → lấy 1 kênh
if size(x,2) == 2
    x = x(:,1);
end

t = (0:length(x)-1)/Fs;
%% ===== 2. THÊM NHIỄU =====
noise = 0.3 * randn(size(x));
x_noisy = x + noise;

%% ===== 3. LỌC IIR BUTTERWORTH =====
Fc = 1000;
Wn = Fc/(Fs/2);

[b, a] = butter(4, Wn, 'low');
y = filter(b, a, x_noisy);

%% ===== 4. PHÁT RIÊNG TỪNG ÂM =====

disp('Dang phat am goc...');
sound(x, Fs);
pause(length(x)/Fs + 1);   

disp('Dang phat am co nhieu...');
sound(x_noisy, Fs);
pause(length(x_noisy)/Fs + 1);

disp('Dang phat am sau khi loc...');
sound(y, Fs);
%% ===== 5. VẼ ĐỒ THỊ =====
figure;

subplot(3,1,1);
plot(t, x);
title('Tin hieu goc');

subplot(3,1,2);
plot(t, x_noisy);
title('Tin hieu co nhieu');

subplot(3,1,3);
plot(t, y);
title('Sau khi loc IIR Butterworth');