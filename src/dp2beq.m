classdef dp2beq < audioPlugin
    properties
        Bass   = 0;
        Treble = 0;
        eq
    end
    properties(Constant)
        PluginInterface = audioPluginInterface(...
                          audioPluginParameter('Bass','DisplayName','Bass','Label','dB','Mapping',{'lin',-12,12}),...
                          audioPluginParameter('Treble','DisplayName','Treble','Label','dB','Mapping',{'lin',-12,12}),...
                          'PluginName','Danny gift to Johnny','VendorName','Daniel Chopra','UniqueId','Eqlz');
    end
    methods
        function plugin = dp2beq
            plugin.eq = multibandParametricEQ('NumEQBands',2,'Frequencies',[200,5000],...
                       'QualityFactors',[0.5,0.5],'SampleRate',getSampleRate(plugin));
        end
        function out = process(plugin,in)
              plugin.eq.PeakGains = [plugin.Bass,plugin.Treble];
             % visualize(plugin.eq);
              out = step(plugin.eq,in);
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
    end
end