{ config, pkgs, osConfig, ... }:
let
  colors = config.lib.stylix.colors;
  bat-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
  net-icons = [ "󰣾" "󰣴" "󰣶" "󰣸" "󰣺" ];
  audio-icons = ["" "" "" "" ];
  generic-percent-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
  temp-icons = [ "" "" "" ""];
  
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    # style = builtins.readFile /home/uwu/.dotfiles/waybar/style.css;

    settings.main-bar = {
      layer = "top";
      position = "top";
      reload_style_on_change = true;

      modules-left = [
        "custom/notification"
        "clock"
        "tray"
      ];
      
      modules-right = [
        "bluetooth"
        "network"
        "battery"
      ];

      "custom/notification" = {
        tooltip = false;
        format = "";
        on-click = "swaync-client -t -sw";
        escape = true;
      };

      clock = {
        format = "{:%I:%M:%S %p} ";
        interval = 1;
        tooltip-format = "<tt>{calendar}</tt>";
        calendar = {
          format = {
            today = "<span color='#fAfBfC'><b>{}</b></span>";
          };
        };
      };

      network = {
        format-wifi = "";
        format-ethernet = "";
        format-disconnected = "";
        tooltip-format-disconnected = "Error";
        tooltoplformat-wifi = "{essid} ({signalStrength}%) ";
        on-click = "foot nmtui";
      };

      bluetooth = {
        format-on = "󰂯";
        format-off = "BT-off";
        format-disabled = "󰂲";
        format-connected-battery = "{device_battery_percentage}% 󰂯";
        format-alt = "{device_alias} 󰂯";
        on-click-right = "blueman-manager";
      };

      battery = {
        interval = 30;
        states = {
          good = 95;
          warning = 30;
          critical = 5;
        };
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% 󰂄";
        format-icons = bat-icons;
      };

      tray = {
        icon-size = 14;
        spacing = 10;
      };
    };
  };
  
  programs.waybar.style = ''
    * {
      border: none;
      font-family: "${config.stylix.fonts.monospace.name}";
      font-size: ${toString config.stylix.fonts.sizes.desktop}pt;
    }

    window#waybar {
      all:unset;
    }

    .modules-left {
      background: alpha(#${colors.base00}, .6);
      margin: 10 0 5 10;
      padding: 2px;
      border-radius: 10px;
    }

    .modules-right {
      background: alpha(#${colors.base00}, .6);
      margin: 10 10 5 0;
      padding: 2px;
      border-radius: 10px;
    }

    tooltip {
      background: #${colors.base00};
      color: #${colors.base0D}
    }

    #clock {
      margin: 1px 1px 1px 1px;
      padding: 2px;
      color: #${colors.base0D};
    }
        
    #custom-notification {
      margin: 1px 1px 1px 1px;
      padding: 0px 9px;
      transition: all .3s ease;
      color: #${colors.base0D};
    }

    #bluetooth {
      margin: 1px 1px 1px 1px;
      padding: 0px 5px;
      transition: all .3s ease;
      color: #${colors.base0D};
    }

    #network {
      margin: 1px 1px 1px 1px;
      padding: 0px 9px;
      transition: all .3s ease;
      color: #${colors.base0D};
    }

    
    #battery {
      margin: 1px 1px 1px 1px;
      padding: 0px 5px;
      transition: all .3s ease;
      color: #${colors.base0D};
    }
    '';
}
