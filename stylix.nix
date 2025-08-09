{ pkgs, config, ... }:
{
  stylix.enable = true;

  # config here
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    image = ./wallpapers/bay.JPG;


    cursor = {
      package = pkgs.rose-pine-cursor;
      name = "rose pine cursor";
      size = 32;
    };
  };
}
