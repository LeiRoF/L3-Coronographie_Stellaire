function PSF = Shift_im2(pupille, N)

[x, y]=meshgrid(1:N);

HalfPixelTilt = exp(-1i*pi*(x+y)/N);

PSF = fftshift(fft2(fftshift(pupille.*HalfPixelTilt)));
