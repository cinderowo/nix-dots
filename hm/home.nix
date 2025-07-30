{ config, pkgs, inputs, ... }:
let
  mod = "Super";
  menu = "fuzzel";
  terminal = "foot";

in {
  imports = [
    ../stylix.nix

    ../waybar/waybar.nix

    inputs.stylix.homeModules.stylix
    inputs.niri.homeModules.niri
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  
  home = {
    stateVersion = "25.05";

    packages  = with pkgs; [
      hyprpaper
      
      obsidian
      libreoffice-fresh
      gimp
      
      p7zip
      unzip
      pavucontrol
      element-desktop
      nautilus
      tidal-hifi
      qbittorrent
      firefox
      brightnessctl
      dconf
      git
      zathura

      dust
      usbutils pciutils
      toybox

      xwayland-satellite

      ardour

      corefonts

      inputs.zen-browser.packages."${system}".default
    ];
  };


  services = {
    hyprpaper = {
      enable = true;
    };
    swaync = {
      enable = true;
    };
    # kanshi = {
    #   enable = true;
    #   systemdTarget = "niri-session.target";

    #   profiles = {
    #     docked.outputs = [
    #       {
    #         criteria = "eDP-1";
    #         mode = "1920x1080";
    #         position = "0,0";
    #         status = "enable";
    #       }
    #       {
    #         criteria = "DP-4";
    #         mode = "1920x1080";
    #         position = "1920,0";
    #         status = "enable";
    #       }
    #       {
    #         criteria = "DP-7";
    #         mode = "1680x1050";
    #         position = "3840,0";
    #         status = "enable";
    #         transform = "90";
    #       }
    #     ];
    #   };
    # };
  };
  
  programs = {
    helix = {
      enable = true;
    };
    foot = {
      enable = true;
    };
    zsh = {
      enable = true;
    };
    fuzzel = {
      enable = true;
    };
    fish = {
      enable = true;
    };
    waybar = {
      enable = true;
      
    };
    niri = {
      enable = true;
      settings.outputs = {
        # left laptop monitor
        "eDP-1" = {
          scale = 1.0;
          mode = {
            width = 1920;
            height = 1080;
          };
        };
        # middle horizontal
        "DP-4" = {
          scale = 1.0;
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.0;
          };
          position = {
            x = 1920;
            y = 0;
          };
        };
        # rightmost vertical
        "DP-7" = {
          scale = 1.0;
          transform.rotation = 90;
          mode = {
            width = 1680;
            height = 1050;
          };
          position = {
            x = 3840;
            y = 0;
          };
        };
      };
    

      settings.environment = {
        QT_QPA_PLATFORM = "wayland";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        DISPLAY = ":0";
        _JAVA_AWT_WM_NONREPARENTING="1";
      };
      
      settings.binds = with config.lib.niri.actions;
      let
        fish = spawn "fish" "-c";
      in {
        "${mod}+T".action.spawn = "${terminal}";
        "${mod}+D".action.spawn = "${menu}";

        "${mod}+Shift+M".action = quit;

        "${mod}+Q".action = close-window;
        "${mod}+F".action = maximize-column;
        "${mod}+Shift+F".action = fullscreen-window;
        "${mod}+Space".action = toggle-window-floating;
        "${mod}+W".action = toggle-column-tabbed-display;

        "${mod}+S".action = screenshot;

        "${mod}+K".action = focus-window-or-workspace-up;
        "${mod}+J".action = focus-window-or-workspace-down;
        "${mod}+H".action = focus-column-or-monitor-left;
        "${mod}+L".action = focus-column-or-monitor-right;

        "${mod}+Shift+K".action = move-window-up-or-to-workspace-up;
        "${mod}+Shift+J".action = move-window-down-or-to-workspace-down;
        "${mod}+Shift+H".action = move-column-left-or-to-monitor-left;
        "${mod}+Shift+L".action = move-column-right-or-to-monitor-right;

        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Shift+1".action = set-column-width "50%";
        "Mod+Shift+Equal".action = set-window-height "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";

        "${mod}+Shift+O".action = fish "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
        "${mod}+Shift+P".action = fish "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
        
        "${mod}+Shift+U".action = fish "brightnessctl set +10%";
        "${mod}+Shift+I".action = fish "brightnessctl set 10%-";
      };

      settings.spawn-at-startup = [
        { command = [ "hyprpaper" ]; }
        { command = [ "xwayland-satellite" ]; }
        { command = [ "waybar" ]; }
      ];
    };
  };
}

