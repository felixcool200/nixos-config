{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "dracula";
      editor = {
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
  };
}
