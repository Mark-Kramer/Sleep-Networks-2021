function eeg_plot(t,d,color)

  for k=1:size(d,2)
    plot(t,d(:,k)+1*k,color)
    hold on
  end
  hold off
  axis tight
  
  set(gca, 'YTick', (1:size(d,2)))
  xlabel('Time [s]')
  
end