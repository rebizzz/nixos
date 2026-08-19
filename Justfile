# just is a command runner, run `just` to list all recipes.
# https://github.com/casey/just

default:
    @just --list

# --- Nix ---

# Format all nix files
fmt:
    nix run nixpkgs#alejandra -- .

# Find dead code
deadnix:
    nix run nixpkgs#deadnix -- .

# Lint for anti-patterns
statix:
    nix run nixpkgs#statix -- check .

# Run lint + flake check
lint: deadnix statix
    nix flake check --no-build

# Update all flake inputs
update:
    nix flake update

# --- Laptop ---

# Build and switch the laptop
switch:
    sudo nixos-rebuild switch --flake .#laptop

# Build without switching, sanity check
build:
    sudo nixos-rebuild build --flake .#laptop

# --- Server (colmena) ---

# Build the server config without deploying
server-build:
    colmena build --on nixos-server

# Build and deploy to the server over SSH
server-apply:
    colmena apply --on nixos-server

# --- Housekeeping ---

# Garbage collect old generations, system and user
gc:
    sudo nix-collect-garbage --delete-older-than 7d
    nix-collect-garbage --delete-older-than 7d
