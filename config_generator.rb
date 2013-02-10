#encoding: UTF-8
require 'json'
config = {  :host=>'lighting.core.bckspc.de',
            :frontends => [:socketio],
            :"priority pass" => "changeme"
        }
devices = []
startchannel = 34
ledbars = [ "Tür rechts", "Tür links",
            "Fenster rechts", "Fenster mitte", "Fenster rechts",
            "Bar", "Logo", "Regal"]

ledbars.each_index do |i|
    devices << {    :type => :rgb,
                    :name => ledbars[i] + " (links)",
                    :channel => startchannel+11*i,
                    :modechannel => 0,
                    :mode => 41,
                    :r => 2,
                    :g => 3,
                    :b => 4
                }
    others = ["mitte", "rechts"]
    others.each_index do |j|
        devices << {    :type => :rgb,
                        :name => ledbars[i] + " (" + others[j] + ")",
                        :channel => startchannel+11*i+5+j*3,
                        :modechannel => -1,
                        :mode => 41,
                        :r => 0,
                        :g => 1,
                        :b => 2
                    }
    end
end
ledstripes = [  "Regalbrett 1 (unten)", "Regalbrett 2", "Regalbrett 3", "Regalbrett 4(oben)",
                "Brett Tür kurz", "Brett Tür lang", "Ampel"]

stripestart = 200
ledstripes.each_index do |i|
    devices << {    :type => :rgb,
                    :name => ledstripes[i],
                    :channel => stripestart + i*3,
                    :modechannel => -1,
                    :mode => 41,
                    :r => 0,
                    :g => 1,
                    :b => 2
                }
end

puts JSON.pretty_generate({:config => config, :rooms=>{:Lounge=>devices} })