function [C] = infer_network_coincidence_scaled(t,d,detections)

    K = size(detections,2);
    C = NaN(K);
    for i=1:K                                           % For each electrode pair,
        di = detections(:,i);
        for j=i+1:K
            dj = detections(:,j);                       % ... get the detections,
            C(i,j)= sum(di.*dj)/sum(di)/sum(dj);        % ... and compute coincidence, scaled by detections.
        end
    end

end

