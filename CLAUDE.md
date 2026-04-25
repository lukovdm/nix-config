# NixOS Configuration

Luko's personal NixOS flake for two machines.

## Machines

| Hostname | Role | Config entry point |
|----------|------|--------------------|
| `barium` | Desktop (KDE Plasma 6) | `system/desktop-configuration.nix` |
| `krypton` | Home server | `system/server-configuration.nix` |

Both use `system/modules/common.nix` for shared settings (locale, user, SSH, nix GC, etc.).

## Repository structure

```
flake.nix                        # inputs + outputs wiring
outputs/
  system-conf.nix                # nixosConfigurations for barium & krypton
  home-conf.nix                  # home-manager configs
system/
  desktop-configuration.nix      # barium: display, audio, steam, 1password …
  server-configuration.nix       # krypton: media, borg server, VPN …
  modules/
    common.nix                   # shared: user luko, locale, openssh, nix settings
    backup.nix                   # barium: borgbackup client (backs up to krypton)
    borg-server.nix              # krypton: borgbackup repo server
    networking.nix
    mediarr.nix                  # Sonarr/Radarr/etc.
    jellyfin.nix
    photos.nix                   # Photoprism
    homepage.nix
    vpn.nix
    aimc.nix
    assist.nix
    ...
  hardware-configurations/
    barium.nix
    krypton.nix
home/                            # home-manager: dotfiles, programs, services
secrets/
  secrets.nix                    # agenix key declarations
  *.age                          # encrypted secrets
```

## Deploying

On the machine itself:
```bash
sudo nixos-rebuild switch --flake .#barium     # on barium
sudo nixos-rebuild switch --flake .#krypton    # on krypton
```

Build and deploy to krypton from barium:
```bash
nixos-rebuild switch --flake .#krypton --target-host krypton --use-remote-sudo
```

## Secrets (agenix)

Secrets are in `secrets/` as age-encrypted files. `secrets/secrets.nix` maps each file to the public keys that can decrypt it (host keys + luko's personal key).

Edit a secret:
```bash
nix run github:ryantm/agenix -- -e secrets/<name>.age
```

Add a new secret: add an entry in `secrets/secrets.nix`, then create the file with the command above.

## Borg backup

- **Client** (`barium`): `system/modules/backup.nix` — daily job backing up `/home/luko` to krypton, runs as user `luko` using SSH key `/home/luko/.ssh/id_rsa`
- **Server** (`krypton`): `system/modules/borg-server.nix` — repo at `/media/backup/barium`, accessed via `borg@krypton`
- SSH connection: `borg@krypton:/media/backup/barium`; barium's RSA public key is hardcoded in `borg-server.nix` under `authorizedKeys`

## Key SSH keys

| Key | Value |
|-----|-------|
| barium host (ed25519) | `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHdKyNAn7ZvlDxcnAw9nBhjGAKzkNL5WllvjnJ7w2GfJ` |
| krypton host (ed25519) | `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBzRcGZDlGRceEt3NwXdtfEpiXWWocC3t6U3XSx8ToKz` |
| luko user (rsa, for borg) | `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAB...` (see `~/.ssh/id_rsa.pub` on barium) |
