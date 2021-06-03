function [C] = infer_network_coherence(t,d,detections)

    any_events = sum(detections,2)>=10;                     % When 10 or more electrodes detect a spindle,
    spindle_group_onset = find(diff(any_events)==1);        % ... define as the start of a "spindle trial".
    n_spindles = length(spindle_group_onset);
    K = size(d,2);
    Fs = 1/(t(2)-t(1));

    d_at_spindles = cell(K,1);                              % For each electrode,
    for k=1:K
        d0 = zeros(2*Fs, n_spindles);                       % For each spindle, 
        for i=1:n_spindles                                  % ... get the data at the start of the spindle event + 2 s.
            d0(:,i) = d(spindle_group_onset(i):spindle_group_onset(i)+2*Fs-1,k);
        end
        d_at_spindles{k} = d0;
    end
    
    C = NaN(K);                                             % Compute the coherence,
    for i=1:K
        di = d_at_spindles{i}';
        for j=i+1:K                                         % For each electrode pair,
            dj = d_at_spindles{j}';                         % ... get the spindle trials,
            [f,C0] = compute_coherence(di,dj,(1:2*Fs)/Fs);  % ... compute coherence,
            i0 = find((f>=9) & (f<=16));                    % ... between 9-16 Hz.
            C(i,j) = mean(C0(i0));
        end
    end

end


%% Functions.

function [f,C] = compute_coherence(E1,E2,t)

    K = size(E1,1);			%Define the number of trials.
    N = size(E1,2);			%Define the number of indices per trial.
    dt = t(2)-t(1);			%Define the sampling interval.
    T  = t(end); 			%Define the duration of data.
    
    Sxx = zeros(K,N);		%Create variables to save the spectra,
    Syy = zeros(K,N);
    Sxy = zeros(K,N);
    for k=1:K				%... and compute spectra for each trial.
        x=E1(k,:)-mean(E1(k,:));
        y=E2(k,:)-mean(E2(k,:));
        Sxx(k,:) = 2*dt^2/T * (fft(x) .* conj(fft(x)));
        Syy(k,:) = 2*dt^2/T * (fft(y) .* conj(fft(y)));
        Sxy(k,:) = 2*dt^2/T * (fft(x) .* conj(fft(y)));
    end

    Sxx = Sxx(:,1:N/2+1);	%Ignore negative frequencies.
    Syy = Syy(:,1:N/2+1);
    Sxy = Sxy(:,1:N/2+1);
    
    Sxx = mean(Sxx,1);		%Average the spectra across trials.
    Syy = mean(Syy,1);
    Sxy = mean(Sxy,1);		%... and compute the coherence.
    C   = abs(Sxy) ./ (sqrt(Sxx) .* sqrt(Syy));

    df  = 1/max(T);			%Determine the frequency resolution.
    fNQ = 1/dt/2;			%Determine the Nyquist frequency,
    f   = (0:df:fNQ);		%... and construct frequency axis.
    
end

