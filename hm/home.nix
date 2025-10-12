{ config, pkgs, inputs, ... }:
let
  mod = "Super";
  menu = "fuzzel";
  terminal = "foot";

in {
  imports = [
    ../stylix.nix
    ../waybar.nix

    inputs.stylix.homeModules.stylix
    inputs.niri.homeModules.niri
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;

      permittedInsecurePackages = [
        "dotnet-runtime-7.0.20"
      ];
    };
  };
  
  home = {
    stateVersion = "25.05";

    packages = with pkgs; [
      # sys utils
      parted
      vscode-langservers-extracted
      fastfetch
      p7zip
      unzip
      nautilus
      brightnessctl
      dconf
      swaynotificationcenter
      btop
      dust
      usbutils 
      pciutils
      git
      zsh-autosuggestions
      zsh-syntax-highlighting
      xwayland-satellite
      hyprpaper

      # other tools
      vivaldi
      inputs.zen-browser.packages."${system}".default
      libreoffice-fresh
      obsidian
      anki
      (blender.override {cudaSupport = true;})
      gimp
      vscode
      element-desktop
      tidal-hifi
      qbittorrent
      zathura

      # pro audio
      ardour
      alsa-utils
      jack2
      qjackctl
      jack_capture
      guitarix
      kapitonov-plugins-pack
      metersLv2
      vital
      decent-sampler
      sfizz
      lmms
      tuxguitar

      # game stuff
      lutris
      heroic
      protonup
      gamemode
      gamescope
      pavucontrol
    ];
  };

  services = {
    flatpak = {
      enable = true;
      packages = [
        "org.vinegarhq.Sober"
      ];
    };
    hyprpaper = {
      enable = true;
    };
    swaync = {
      enable = true;
    };
  };
  
  programs = {
    helix = {
      enable = true;
    };
    foot = {
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
    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      initContent = ''
        alias prime-run="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only"
      
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        # source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      '';
    };
    bash.enable = false;
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
          position = {
            x = 0;
            y = 0;
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
            x = 1919;
            y = 0;
          };
        };
        # rightmost vertical
        "DP-5" = {
          scale = 1.0;
          transform.rotation = 90;
          mode = {
            width = 1680;
            height = 1050;
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
        # { command = [ "waybar" ]; }
        { command = [ "swaync" ]; }
        { command = [ "../scripts/mntext" ]; }
      ];
    };
  };
}

