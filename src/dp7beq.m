classdef dp7beq < audioPlugin
    properties
        L1 = 0;
        L2 = 0;
        L3 = 0;
        mid = 0;
        h1 = 0;
        h2 = 0;
        h3 = 0;
        fq = 0.5;
        en = false;
        eq;
        osc;
    end
    properties(Constant)
        PluginInterface = audioPluginInterface(...
            audioPluginParameter('L1','DisplayName','joseph','Label','dB','Mapping',{'lin',-12,12}),...
            audioPluginParameter('L2','DisplayName','vijay','Label','dB','Mapping',{'lin',-12,12}),...
            audioPluginParameter('L3','DisplayName','Thejo','Label','dB','Mapping',{'lin',-12,12}),...
            audioPluginParameter('mid','DisplayName','Siril','Label','dB','Mapping',{'lin',-12,12}),...
            audioPluginParameter('h1','DisplayName','PaulChai','Label','dB','Mapping',{'lin',-12,12}),...
            audioPluginParameter('h2','DisplayName','Rajesh','Label','dB','Mapping',{'lin',-12,12}),...
            audioPluginParameter('h3','DisplayName','kenneth','Label','dB','Mapping',{'lin',-12,12}),...
            audioPluginParameter('fq','DisplayName','Mod','Label','Hz','Mapping',{'log',0.5,8}),...
            audioPluginParameter('en','DisplayName','3D effect','Mapping',{'enum','enable','disable'}),...
            'PluginName','Karunya Gang','VendorName','Daniel Chopra');
    end
    methods
        function plugin = dp7beq
            plugin.eq = multibandParametricEQ('NumEQBands',7,'Frequencies',[40,150,300,1000,3000,5000,12000],...
                       'QualityFactors',[0.8,1,1.6,1.6,1.3,1,0.8],'SampleRate',getSampleRate(plugin));
            plugin.osc = audioOscillator('SignalType','sine','Frequency',0,'SampleRate',getSampleRate(plugin));
        end
        function out = process(plugin,in)
              plugin.eq.PeakGains = [plugin.L1,plugin.L2,plugin.L3,plugin.mid,...
                                     plugin.h1,plugin.h2,plugin.h3,];
 
              
              frmsize = size(in,1);
              plugin.osc.SamplesPerFrame = frmsize;
              plugin.osc.Frequency = plugin.fq;
              osc1 = plugin.osc();
              visualize(plugin.eq);
% % % %     ---------------------------------------------------------------           
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
        function set.fq(plugin,val)
            plugin.fq = val;
        end
        function set.en(plugin,val)
            plugin.en = val;
        end
    end
end