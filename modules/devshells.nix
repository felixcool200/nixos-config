{
  perSystem = { pkgs, ... }: {
    devShells = {
      minecraft = pkgs.mkShell {
        buildInputs = [ pkgs.prismlauncher ];
      };
      backgrounds = pkgs.mkShell {
        buildInputs = [ pkgs.inkscape ];
        shellHook = ''
          echo "Inkscape available for SVG to PNG conversion"
          echo "Usage: inkscape --export-type=png --export-filename=output.png input.svg"
          echo ""
          echo "To convert gnome-map-d.svg:"
          echo "inkscape --export-type=png --export-filename=gnome-map-d.png gnome-map-d.svg"
        '';
      };
    };
  };
}
