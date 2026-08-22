# just is a command runner, run `just` to list all recipes.
# https://github.com/casey/just

default:
    @just --list

fmt:
    nix run nixpkgs#alejandra -- .

deadnix:
    nix run nixpkgs#deadnix -- .

statix:
    nix run nixpkgs#statix -- check .

lint: deadnix statix
    nix flake check --no-build

update:
    nix flake update

upp input:
    nix flake update {{input}}

override-pkgs hash:
    nix flake update nixpkgs --override-input nixpkgs github:NixOS/nixpkgs/{{hash}}

verify-store:
    nix store verify --all

repair-store *paths:
    nix store repair {{paths}}

switch:
    nh os switch

build:
    nh os build

boot:
    nh os boot

server-build:
    nix build .#nixosConfigurations.nixos-server.config.system.build.toplevel

server-apply:
    deploy .#nixos-server

gc:
    sudo nix-collect-garbage --delete-older-than 7d
    nix-collect-garbage --delete-older-than 7d

list-failed:
    systemctl list-units --all --state=failed

ggc:
    git reflog expire --expire-unreachable=now --all
    git gc --prune=now
