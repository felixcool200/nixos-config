{
  # Waybar configuration
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = builtins.fromJSON (builtins.readFile ./config.json);
    };
    style = builtins.readFile ./style.css;
  };

  # Install the wittr.sh script
  home.file.".config/waybar/wittr.sh" = {
    source = ./wittr.sh;
    executable = true;
  };
}
