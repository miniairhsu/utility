clear all 

function octave = gen_octave(img, s, sigma)
  k = 2^(1/s);
  for i = 1:(s+2) 
    next_level = convolve(octave[-1], kernel) 
    octave.append(next_level) 
  end 
endfunction
