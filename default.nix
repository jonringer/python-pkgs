let
  stdenvRepo = builtins.fetchGit {
    url = "https://github.com/jonringer/stdenv.git";
    rev = "415802fd971557fefc332d295527d61e304687e9";
  };

  lib = import (builtins.fetchGit {
    url = "https://github.com/jonringer/nix-lib.git";
    rev = "c19c816e39d14a60dd368d601aa9b389b09d0bbb";
  });

  pkgsOverlay = lib.mkAutoCalledPackageDir ./pkgs;
  pythonOverrides = import ./python-packges.nix;
  pythonOverlay = lib.composeManyExtensions [
    pkgsOverlay
    pythonOverrides
  ];

  toplevelOverlay = import ./top-level.nix;
in

# Continuation passing style of import
# Values we care to modify are modified, while all other
# arguments are "passed through" to the next scope
{ overlays ? [], config ? { }, ... }@args:

let
  filteredAttrs = lib.filterAttrs [ "overlays" "config" ] args;
in

import stdenvRepo ({
  overlays = [
    toplevelOverlay
  ] ++ overlays;

  config = config // {
    pythonOverlays = [ pythonOverlay ] ++ (config.pythonOverlays or [ ]);
  };
} // filteredAttrs)
