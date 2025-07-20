{ config, pkgs, inputs, ... }:
let
  mod = "Super";
  menu = "fuzzel";
  terminal = "foot";

in {
  imports = [
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
      firefox
      brightnessctl
    ];

  };
  programs = {
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
        };
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

        "XF86AudioRaiseVolume".action.spawn = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
        "XF86AudioLowerVolume".action.spawn = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
        "XF86AudioMute".action.spawn = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86MonBrightnessUp".action.spawn = [ "brightnessctl set +10%" ];
        "XF86MonBrightnessDown".action.spawn = [ "brightnessctl set 10%-" ];
      };
    };
  };
}
