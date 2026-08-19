# Secrets Management (sops-nix)

Secrets in this repo are encrypted using `sops-nix` and `age`, and shared between both hosts.
`secrets/secrets.yaml` is a single file, decryptable by any recipient listed in `.sops.yaml`.

Key location: `/persistent/etc/sops/age/keys.txt`

`nixos-server` additionally decrypts via its own SSH host key (`age.sshKeyPaths` in
`modules/system/core/secrets.nix`), so it doesn't need a separate `keys.txt` copied onto it before
first boot. Its `ssh_host_ed25519_key` (persisted at `/persistent/etc/ssh/`) doubles as its sops
identity.

> Back up `/persistent/etc/sops/age/keys.txt` to an external USB drive. Losing this key makes encrypted secrets unrecoverable.

## Changing User Password

Each host has its own password secret, `user_password_laptop` and `user_password_server`, so you
can change one without touching the other. Passwords are not stored in plaintext:

1. Generate a SHA-512 hash:
   ```bash
   nix-shell -p mkpasswd --run 'mkpasswd -m sha-512'
   ```
2. Open `secrets/secrets.yaml`:
   ```bash
   export SOPS_AGE_KEY_FILE=/etc/sops/age/keys.txt
   cd ~/opt/nixos-config
   sops secrets/secrets.yaml
   ```
3. Replace `user_password_laptop` and/or `user_password_server` with the new hash.
4. Rebuild the system:
   ```bash
   sudo nixos-rebuild switch --flake .#laptop
   # or, for the server:
   deploy .#nixos-server
   ```

`root` has no password on either host (`hashedPassword = "!"` in
`modules/system/core/user.nix`). Use `sudo` via the `wheel` group instead.

## Editing Secrets

1. Export the key path and open `secrets.yaml`:
   ```bash
   export SOPS_AGE_KEY_FILE=/etc/sops/age/keys.txt
   sops secrets/secrets.yaml
   ```
2. Save and exit. If you changed recipient public keys in `.sops.yaml`, run:
   ```bash
   sops updatekeys secrets/secrets.yaml
   ```

## Setting Up a New Key (Fresh Machine)

1. Generate a key file:
   ```bash
   nix-shell -p age sops
   age-keygen -o /tmp/keys.txt
   ```
2. Copy the printed public key (`age1...`) into `.sops.yaml`.
3. Save key to persistent storage:
   ```bash
   sudo mkdir -p /persistent/etc/sops/age
   sudo cp /tmp/keys.txt /persistent/etc/sops/age/keys.txt
   sudo chmod 600 /persistent/etc/sops/age/keys.txt
   ```
