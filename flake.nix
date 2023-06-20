{
  description = "Tiddlywiki";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.05";
  };

  outputs = { self, nixpkgs }:

    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    in
      {
        packages = forAllSystems (system:
          let
            pkgs = nixpkgs.legacyPackages."${system}";
          in
            {
              tiddlywiki = pkgs.stdenv.mkDerivation rec {
                pname = "tiddlywiki";
                version = "5.2.7";

                #src = pkgs.fetchurl {
                #  url = "https://github.com/Jermolene/TiddlyWiki5/archive/refs/tags/v${version}.tar.gz";
                #  sha256 = "jbfgoZb2r+MRsMT1/XrjatVu8xMVSArlEfloaRw4cOw=";
                #};
                src = pkgs.fetchFromGitHub {
                  owner = "Jermolene";
                  repo = "TiddlyWiki5";
                  rev = "v${version}";
                  sha256 = "YIVsM83jeBmiReYGm9x4Br90j512XpMJ+WJM3Lb0q9U=";
                };

                highlightJs = ./highlight.min.js;

                phases = [ "unpackPhase" "patchPhase" "installPhase" ];

                patchPhase = ''
                  cp $highlightJs ./plugins/tiddlywiki/highlight/files/highlight.min.js
                '';

                installPhase = ''
                  mkdir -p $out
                  cp -r ./* $out
                '';

                meta = with pkgs.lib; {
                  description = "a non-linear personal web notebook";
                  license = licenses.bsd3;
                  homepage = "https://github.com/Jermolene/TiddlyWiki5#readme";
                };
              };
            }
        );
      };
}
