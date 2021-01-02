# if release is not set, import packages from subdirectories if they exist
{ release ? false
, nixpkgs ? <nixpkgs>
, srcs ? import ./srcs.nix release nixpkgs
}:

rec {
  rm1Pkgs = import ./rM { inherit srcs hostPkgs; rmVersion = 1; };
  rm2Pkgs = import ./rM { inherit srcs hostPkgs; rmVersion = 2; };
  rmPkgs = builtins.mapAttrs (n: v: rm1Pkgs.runCommand "rm-merged-${n}" {
    outputs = v.outputs;
    passthru = {
      rm1 = rm1Pkgs.${n};
      rm2 = rm2Pkgs.${n};
    };
  } (builtins.map (o: ''
    mkdir -p ''$${o}/
    ln -s ${rm1Pkgs.${n}.${o}} ''$${o}/rm1
    ln -s ${rm2Pkgs.${n}.${o}} ''$${o}/rm2
  '') v.outputs)) rm1Pkgs;
  hostPkgs = import ./host { inherit srcs rmPkgs rm1Pkgs rm2Pkgs; };
}
