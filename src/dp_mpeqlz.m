
af = dsp.AudioFileReader('Filename','RockDrums-48-stereo-11secs.mp3','PlayCount',1);
dw = audioDeviceWriter('SampleRate',af.SampleRate);
 
mpEQ = multibandParametricEQ('NumEQBands',2,'Frequencies',[200,5000],...
        'QualityFactors',[0.5,0.5],'PeakGains',[0 0]);

while ~isDone(af)
    sp = mpEQ(af());
    dw(sp);
end
release(af);
release(dw);
release(mpEQ);