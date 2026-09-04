# Secrets Management (sops-nix)

Secrets in this repo are encrypted using `sops-nix` and `age`. `secrets/secrets.yaml` is a single
file, decryptable by any recipient listed in `.sops.yaml`.

Key location: `/persistent/etc/sops/age/keys.txt`

> Back up `/persistent/etc/sops/age/keys.txt` to an external USB drive. Losing this key makes encrypted secrets unrecoverable.

## Changing User Password

Passwords are not stored in plaintext:

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
3. Replace `user_password_laptop` with the new hash.
4. Rebuild the system:
   ```bash
   sudo nixos-rebuild switch --flake .#laptop
   ```

`root` has no password (`hashedPassword = "!"` in `modules/system/core/user.nix`). Use `sudo` via
the `wheel` group instead.

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

## Troubleshooting

**`sops: error while loading directory: no age key found`**: `SOPS_AGE_KEY_FILE` isn't set, or
points at the wrong path. Export it in the current shell before running `sops`, it's not read from
`.sops.yaml`.

**A rebuild fails to decrypt a secret after adding a new host's key**: you edited `.sops.yaml` but
forgot to run `sops updatekeys secrets/secrets.yaml`, the data key is still wrapped only for the
old recipient set.

**Locked out because `keys.txt` is gone**: without it, the secrets in `secrets.yaml` are
unrecoverable. This is why the backup copy on a USB drive matters.
