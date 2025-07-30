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
    style = builtins.readFile /home/uwu/.dotfiles/waybar/style.css;

    settings.main-bar = {
      layer = "top";
      position = "top";
      reload_style_on_change = true;

      modules-left = [
        "custom/notification"
        "clock"
        "tray"
      ];
      modules-center = [
        "wlr/workspaces"
      ];
      modules-right = [
        "group/expand"
        "bluetooth"
        "network"
        "battery"
      ];

      "wlr/workspaces" = {
        format = "{icon}";
        format-icons = {
          active = "";
          default = "";
          empty = "";
        };
      };

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
    };
  };

  programs.waybar.style = ''
    { config, pkgs, osConfig, ... }:
let
  colors = config.lib.stylix.colors;
  bat-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
  net-icons = [ "󰣾" "󰣴" "󰣶" "󰣸" "󰣺" ];
  audio-icons = ["" "" "" "" ];
  generic-percent-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
  temp-icons = [ "" "" "" ""];
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.main-bar = {
      layer = "top";
      
      modules-left = [
        "niri/workspaces"
        "custom/sep"
        "niri/window"
      
        # "hyprland/workspaces"
        # "hyprland/window"
      ];

      modules-center = [
        # "cava"
      ];

      modules-right = [
        "cpu"
        "temperature"
        "memory"
        "backlight"
        "pulseaudio"
        "battery"
        "clock"
        "custom/notification"
        "tray"
      ];

      "hyprland/window".icon = true;
      "niri/window".icon = true;

      "niri/workspaces" = {
        format = "{icon}";
        format-icons = {
          active = "";
          default = "";
        };
      };

      tray = {
        spacing = 5;
      };

      cava = {
        format-icons = generic-percent-icons;
        bars = 14;
        method = "pulse";
        framerate = 20;
        bar_delimiter = 0;
        stereo = false;
      };

      clock = {
        format = "{:%H:%M %F}";
      };

      battery = {
        format = "{icon} {capacity}%";
        format-icons = bat-icons;
        tooltip-format = "{time}, {cycles} cycles, {health}% health";
      };

      network = {
        format = "{icon}  {ipaddr}";
        format-icons = net-icons;
      };

      pulseaudio = {
        format = "{icon}  {volume}%";
        format-muted = "vol: muted";
        format-icons.default = audio-icons;
        on-click = "pavucontrol";
        scroll-step = 1;
      };

      backlight = {
        format = "󰖨 {icon}";
        format-icons = generic-percent-icons;
        tooltip-format = "{percent}%";
      };

      cpu = {
        interval = 1;
        format = " {icon}";
        format-icons = generic-percent-icons;
        tooltip-format = "usage: {usage}%\nload: {load}";
      };

      memory = {
        interval = 1;
        format = "  {icon}";
        format-icons = generic-percent-icons;
        tooltip-format = "{used} GiB / {total} GiB \n{percentage}%";
      };

      temperature = {
        interval = 1;
        critical-threshold = 80;
        format = "{temperatureC}°C";
        format-icons = temp-icons;
      } // (if osConfig.networking.hostName == "nixos-desktop" then {
        thermal-zone = 2;
      } else {});

      "custom/notification" = {
        tooltip = false;
        format = "{} {icon}";
        "format-icons" = {
          notification = "󱅫";
          none = "";
          "dnd-notification" = " ";
          "dnd-none" = "󰂛";
          "inhibited-notification" = " ";
          "inhibited-none" = "";
          "dnd-inhibited-notification" = " ";
          "dnd-inhibited-none" = " ";
        };
        "return-type" = "json";
        "exec-if" = "which swaync-client";
        exec = "swaync-client -swb";
        "on-click" = "sleep 0.1 && swaync-client -t -sw";
        "on-click-right" = "sleep 0.1 && swaync-client -d -sw";
        escape = true;
      };
    };
  };

  stylix.targets.waybar.enable = false;

  programs.waybar.style = ''
    * {
      border: none;
      font-family: "${config.stylix.fonts.monospace.name}";
      font-size: ${toString config.stylix.fonts.sizes.desktop}pt;
      color: #${colors.base04};
    }

    window#waybar {
      background: #${colors.base00};
    }

    .module {
      background: #${colors.base00};
      margin: 0px 5px 0px 5px;
      padding: 0px 0px 0px 5px;
    }

    #workspaces button {
      padding: 0px;
      border-bottom: 0px none transparent;
    }
  '';
}
