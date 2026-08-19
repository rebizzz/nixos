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

# Update a single flake input, e.g. just upp nixpkgs
upp input:
    nix flake update {{input}}

# Pin nixpkgs to a specific commit for ad hoc testing
override-pkgs hash:
    nix flake update nixpkgs --override-input nixpkgs github:NixOS/nixpkgs/{{hash}}

# Verify the nix store for corrupted entries
verify-store:
    nix store verify --all

# Repair specific corrupted store paths
repair-store *paths:
    nix store repair {{paths}}

# --- Laptop ---

# Build and switch the laptop
switch:
    sudo nixos-rebuild switch --flake .#laptop

# Build without switching, sanity check
build:
    sudo nixos-rebuild build --flake .#laptop

# Set as next-boot generation without switching now
boot:
    sudo nixos-rebuild boot --flake .#laptop

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

# List failed systemd units, useful on nixos-server
list-failed:
    systemctl list-units --all --state=failed

# Remove all reflog entries and prune unreachable git objects
ggc:
    git reflog expire --expire-unreachable=now --all
    git gc --prune=now
