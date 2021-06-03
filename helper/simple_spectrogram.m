% This uses MATLAB's built-in function. It'd be better to use the multitaper
% method in Chronux, http://chronux.org/ .

function simple_spectrogram(d,t)

    Fs       = 1/(t(2)-t(1));       % Get sampling freq.
    interval = round(Fs);           % Specify the interval size.
    overlap  = round(Fs*0.95);      % Specify the overlap of intervals.
    nfft     = round(Fs);           % Specify the FFT length.
    x = d(:,1);                     % Compute the spectrogram,
    [~,F,T,P] = spectrogram(x-mean(x),interval,overlap,nfft,Fs);
    imagesc(T,F,10*log10(P), [-80, -20]) %... and plot it,
    colorbar                        %... with a colorbar,
    axis xy                         %... and origin in lower left,
    ylim([0 70])                    %... set the frequency range,
    xlabel('Time [s]');             %... and label axes.
    ylabel('Frequency [Hz]')
    set(gca, 'FontSize', 14)
    
end