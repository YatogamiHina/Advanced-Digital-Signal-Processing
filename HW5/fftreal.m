function [Fx, Fy] = fftreal(x,y)
    %% Step 1: f₃[n] = f₁[n] + jf₂[n]
    z = x + y * i;

    %% Step 2: F₃[m] = DFT{f₃[n]}
    N = length(x);
    Fz = zeros(size(x));
    for m = 1:N
        for n = 1:N
            Fz(m) = Fz(m) + z(n) * exp(-i*2*pi/N*(m-1)*(n-1));
        end
    end
    Fz_star = conj(circshift(fliplr(Fz),[0 1])); % F [m] = F*[N−m] 左右翻轉後取共軛複數

    %% Step 3: F₁[m] = (F₃[m] + F₃*[N-m]) / 2, F₂[m] = (F₃[m] - F₃*[N-m]) / 2j

    Fx = (Fz + Fz_star) / 2;
    Fy = (Fz - Fz_star) / 2i;

    