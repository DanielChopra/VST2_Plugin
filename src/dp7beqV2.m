classdef dp7beqV2 < audioPlugin
    properties
        L1 = 0; fL1=40; qL1=0.8;
        L2 = 0; fL2=150; qL2=1;
        L3 = 0; fL3=300; qL3=1.6;
        mid = 0;fmid=1000; qmid=1.6;
        h1 = 0; fh1=3000; qh1=1.3;
        h2 = 0; fh2=5000; qh2=1;
        h3 = 0; fh3=12000; qh3=0.8;
        fq = 0.5;
        en = false;
        eq;
        osc;
    end
    properties(Constant)
        PluginInterface = audioPluginInterface(...
            audioPluginParameter('L1','DisplayName','SubBass-gain','Label','dB','Mapping',{'lin',-12,12}),...
            audioPluginParameter('L2','DisplayName','Bass-gain','Label','dB','Mapping',{'lin',-12,12}),...
            audioPluginParameter('L3','DisplayName','LowMid-gain','Label','dB','Mapping',{'lin',-12,12}),...
            audioPluginParameter('mid','DisplayName','Midrange-gain','Label','dB','Mapping',{'lin',-12,12}),...
            audioPluginParameter('h1','DisplayName','UpperMid-gain','Label','dB','Mapping',{'lin',-12,12}),...
            audioPluginParameter('h2','DisplayName','Presence-gain','Label','dB','Mapping',{'lin',-12,12}),...
            audioPluginParameter('h3','DisplayName','Brilliance-gain','Label','dB','Mapping',{'lin',-12,12}),...
            audioPluginParameter('fL1','DisplayName','SubBass-Fq','Label','Hz','Mapping',{'log',20,60}),...
            audioPluginParameter('fL2','DisplayName','Bass-Fq','Label','Hz','Mapping',{'log',60,250}),...
            audioPluginParameter('fL3','DisplayName','LowMid-Fq','Label','Hz','Mapping',{'log',250,500}),...
            audioPluginParameter('fmid','DisplayName','Midrange-Fq','Label','Hz','Mapping',{'log',500,2000}),...
            audioPluginParameter('fh1','DisplayName','UpperMid-Fq','Label','Hz','Mapping',{'log',2000,4000}),...
            audioPluginParameter('fh2','DisplayName','Presence-Fq','Label','Hz','Mapping',{'log',4000,6000}),...
            audioPluginParameter('fh3','DisplayName','Brilliance-Fq','Label','Hz','Mapping',{'log',6000,20000}),...
            audioPluginParameter('qL1','DisplayName','SubBass-Q','Label','','Mapping',{'lin',0.2,700}),...
            audioPluginParameter('qL2','DisplayName','Bass-Q','Label','','Mapping',{'lin',0.2,700}),...
            audioPluginParameter('qL3','DisplayName','LowMid-Q','Label','','Mapping',{'lin',0.2,700}),...
            audioPluginParameter('qmid','DisplayName','Midrange-Q','Label','','Mapping',{'lin',0.2,700}),...
            audioPluginParameter('qh1','DisplayName','UpperMid-Q','Label','','Mapping',{'lin',0.2,700}),...
            audioPluginParameter('qh2','DisplayName','Presence-Q','Label','','Mapping',{'lin',0.2,700}),...
            audioPluginParameter('qh3','DisplayName','Brillirance-Q','Label','','Mapping',{'lin',0.2,700}),...
            audioPluginParameter('fq','DisplayName','Mod','Label','Hz','Mapping',{'log',0.5,8}),...
            audioPluginParameter('en','DisplayName','3D effect','Mapping',{'enum','enable','disable'}),...
            'PluginName','Kennys EQ','VendorName','Daniel Chopra');
    end
    methods
        function plugin = dp7beqV2
            plugin.eq = multibandParametricEQ('NumEQBands',7,'Frequencies',[40,150,300,1000,3000,5000,12000],...
                       'QualityFactors',[0.8,1,1.6,1.6,1.3,1,0.8],'SampleRate',getSampleRate(plugin));
            plugin.osc = audioOscillator('SignalType','sine','Frequency',0.5,'SampleRate',getSampleRate(plugin));
        end
        function out = process(plugin,in)
              plugin.eq.PeakGains = [plugin.L1,plugin.L2,plugin.L3,plugin.mid,...
                                     plugin.h1,plugin.h2,plugin.h3,];
 
              plugin.eq.Frequencies = [plugin.fL1,plugin.fL2,plugin.fL3,plugin.fmid,...
                                       plugin.fh1,plugin.fh2,plugin.fh3,];
              
              plugin.eq.QualityFactors = [plugin.qL1,plugin.qL2,plugin.qL3,plugin.qmid,...
                                          plugin.qh1,plugin.qh2,plugin.qh3,];
              
              frmsize = size(in,1);
              plugin.osc.SamplesPerFrame = frmsize;
              plugin.osc.Frequency = plugin.fq;
              osc1 = plugin.osc();
%               visualize(plugin.eq);
% % % %     --------------------------------------------------------------          
              if((plugin.fq > 0.51)&&(plugin.en == true))
                  if(osc1 > 0)
                      ch1 = osc1.*in(:,1);
                      ch2 = 0.*in(:,2);
                      outp = [ch1,ch2];
                      out = step(plugin.eq,outp);
                  else
                      ch1 = 0.*in(:,1);
                      ch2 = osc1.*in(:,2);
                      outp = [ch1,ch2];
                      out = step(plugin.eq,outp);
                  end
              elseif(plugin.fq < 0.51)
                  out = step(plugin.eq,in);
              else
                  ch1 = osc1.*in(:,1);
                  ch2 = osc1.*in(:,2);
                  outp = [ch1,ch2];
                  out = step(plugin.eq,outp);
              end
% % ---------------------------------------------------------------      
        end
        function reset(plugin)
            plugin.eq.SampleRate = getSampleRate(plugin);
        end
% % % ---------------------------- GAINS -------------------------%%        
        function set.L1(plugin,val)
            plugin.L1 = val;
        end
        function set.L2(plugin,val)
            plugin.L2 = val;
        end
        function set.L3(plugin,val)
            plugin.L3 = val;
        end
        function set.mid(plugin,val)
            plugin.mid = val;
        end
        function set.h1(plugin,val)
            plugin.h1 = val;
        end
        function set.h2(plugin,val)
            plugin.h2 = val;
        end
        function set.h3(plugin,val)
            plugin.h3 = val;
        end
% % % % % ----------------------------------FREQUENCY------------------------  %%%%%%      
        function set.fL1(plugin,val)
            plugin.fL1 = val;
        end
        function set.fL2(plugin,val)
            plugin.fL2 = val;
        end
        function set.fL3(plugin,val)
            plugin.fL3 = val;
        end
        function set.fmid(plugin,val)
            plugin.fmid = val;
        end
        function set.fh1(plugin,val)
            plugin.fh1 = val;
        end
        function set.fh2(plugin,val)
            plugin.fh2 = val;
        end
        function set.fh3(plugin,val)
            plugin.fh3 = val;
        end
% % % % % % % ----------------------------------------- Q factors--------------------        
        function set.qL1(plugin,val)
            plugin.qL1 = val;
        end
        function set.qL2(plugin,val)
            plugin.qL2 = val;
        end
        function set.qL3(plugin,val)
            plugin.qL3 = val;
        end
        function set.qmid(plugin,val)
            plugin.qmid = val;
        end
        function set.qh1(plugin,val)
            plugin.qh1 = val;
        end
        function set.qh2(plugin,val)
            plugin.qh2 = val;
        end
        function set.qh3(plugin,val)
            plugin.qh3 = val;
        end
 %%%%---------------------------------------------------------------       
        function set.fq(plugin,val)
            plugin.fq = val;
        end
        function set.en(plugin,val)
            plugin.en = val;
        end
    end
end