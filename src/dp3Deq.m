classdef dp3Deq < audioPlugin
    properties
        Bass   = 0;
        Treble = 0;
        Fq = 0.1;
        en = false;
        osc;
        eq
    end
    properties(Constant)
        PluginInterface = audioPluginInterface(...
                          audioPluginParameter('Bass','DisplayName','Bass','Label','dB','Mapping',{'lin',-12,12}),...
                          audioPluginParameter('Treble','DisplayName','Treble','Label','dB','Mapping',{'lin',-12,12}),...
                          audioPluginParameter('Fq','DisplayName','Mod','Mapping',{'log',0.1,3}),...
                          audioPluginParameter('en','DisplayName','3D effect','Mapping',{'enum','enable','disable'}),...
                          'PluginName','Danny gift to Johnny','VendorName','Daniel Chopra','UniqueId','3Deq');
    end
    methods
        function plugin = dp3Deq
            plugin.eq = multibandParametricEQ('NumEQBands',2,'Frequencies',[200,5000],...
                       'QualityFactors',[0.5,0.5],'SampleRate',getSampleRate(plugin));
%         end
%         function plugin = osc_t2
            plugin.osc = audioOscillator('SignalType','sine','Frequency',0.1,'SampleRate',getSampleRate(plugin));
        end
        function out = process(plugin,in)
            plugin.eq.PeakGains = [plugin.Bass,plugin.Treble];
            frmsize = size(in,1);
            plugin.osc.SamplesPerFrame = frmsize;
            plugin.osc.Frequency = plugin.Fq;
            osc1 = plugin.osc();
            if(plugin.en == true)
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
            else
            out = step(plugin.eq,in);
            end
        end
        function reset(plugin)
            plugin.eq.SampleRate = getSampleRate(plugin);
        end
        function set.Bass(plugin,val)
            plugin.Bass = val;
        end
        function set.Treble(plugin,val)
            plugin.Treble = val;
        end
        function set.Fq(plugin,val)
            plugin.Fq = val;
        end
        function set.en(plugin,val)
            plugin.en = val;
        end
    end
end