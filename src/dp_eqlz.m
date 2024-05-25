%   af = dsp.AudioFileReader('RockGuitar-16-44p1-stereo-72secs.wav','PlayCount',1);
  af = dsp.AudioFileReader('speech_dft.mp3','PlayCount',1);
 
 deviceWriter = audioDeviceWriter('SampleRate',af.SampleRate);
% devices = getAudioDevices(deviceWriter);

% setup(af);
% setup(deviceWriter,ones(256 ,2));

cnt = 0;
cf = 100/af.SampleRate;
bw = 22025/af.SampleRate;

[b,a] = designParamEQ(2,12,cf,bw);
 bq   = dsp.BiquadFilter('SOSMatrix',[b.',[1,a.']]);
 hfvt = fvtool(bq,'Fs',af.SampleRate,'Color','white');

 sigfilt = dsp.BiquadFilter('SOSMatrixSource','Input Port');   
%  ,'ScaleValues',3,'ScaleValuesInputPort',true);

 while cnt < 200
     muc = af();
     sp = sigfilt(muc,b,a,[1 2]);
     deviceWriter(sp);
     cnt = cnt+1;
 end
 release(af);
 release(deviceWriter);

