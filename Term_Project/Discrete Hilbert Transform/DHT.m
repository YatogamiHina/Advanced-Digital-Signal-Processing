function output_signal = DHT(signal)

N = length(signal);

signal_fft = fft(signal);

h_fft = zeros(1,N);

for n = 1:N
    if n < N/2 && n > 1
        h_fft(1,n) = -1i;
    elseif n > N/2 + 1 
        h_fft(1,n) = 1i;
    end
end

output_signal_fft = signal_fft.*h_fft;
output_signal = real(ifft(output_signal_fft));

