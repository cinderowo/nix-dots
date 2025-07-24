{ config, pkgs, inputs, ... }:
let
  mod = "Super";
  menu = "fuzzel";
  terminal = "foot";

in {
  imports = [
    ../stylix.nix

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
      pavucontrol
      element-desktop
      nautilus
      tidal-hifi
      qbittorrent
      firefox
      brightnessctl
      dconf
      git

      ardour

      inputs.zen-browser.packages."${system}".default
    ];
  };


  services = {
    hyprpaper = {
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
    niri = {
      enable = true;
      settings.outputs = {
        "eDP-1" = {
          scale = 1.0;
          mode = {
            width = 1920;
            height = 1080;
          };
        };
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
      
      settings.binds = with config.lib.niri.actions; {
        "${mod}+T".action.spawn = "${terminal}";
        "${mod}+D".action.spawn = "${menu}";

        "${mod}+Shift+M".action = quit;

        "${mod}+Q".action = close-window;
        "${mod}+F".action = maximize-column;
        "${mod}+Shift+F".action = fullscreen-window;
        "${mod}+Space".action = toggle-window-floating;
        "${mod}+W".action = toggle-column-tabbed-display;

        "${mod}+S".action = screenshot;

        "${mod}+bracketright".action.spawn = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
        "${mod}+bracketleft".action.spawn = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
        "${mod}+KP_7".action.spawn = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "${mod}+apostrophe".action.spawn = [ "brightnessctl set +10%" ];
        "${mod}+semicolon".action.spawn = [ "brightnessctl set 10%-" ];
      };

      settings.spawn-at-startup = [
        { command = [ "hyprpaper" ]; }
      ];
    };
  };
}

