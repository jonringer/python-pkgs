# Python Pkgs for poly-repo Nixpkgs

This is meant to be the central location to curate python packages for a
poly-repo nixpkgs fork.

## Structure

```
default.nix         # Entry point, return pkgs + our changes in this repo
python-packages.nix # Python overlay, applied after the auto called entries in `pkgs/`
top-level.nix       # top-level overlay
pkgs/               # mkAutoCalledDirectory containing all python expressions, these get auto called based on directory name
```
