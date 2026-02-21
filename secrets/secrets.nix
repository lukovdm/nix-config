# This file declares which age public keys can decrypt each secret.
#
# HOW TO GET YOUR HOST KEYS:
#   Run on each machine:
#     ssh-keyscan -t ed25519 <hostname-or-ip>
#   Or read directly from the host:
#     cat /etc/ssh/ssh_host_ed25519_key.pub
#
# HOW TO ADD A NEW SECRET:
#   1. Add an entry below mapping the secret file to the list of keys that can decrypt it.
#   2. Run: nix run github:ryantm/agenix -- -e secrets/<your-secret>.age
#      (from the root of this repo, with secrets.nix in the same directory as the .age files)
#
# RECIPIENT KEY TYPES:
#   agenix supports age-native keys (age1...) and SSH keys (ssh-ed25519, ssh-rsa).
#   Using SSH host keys means each machine can decrypt its own secrets automatically.
#   Adding your personal SSH public key lets you edit secrets from your workstation.

let
  # --- Machine SSH host public keys ---
  # Replace these placeholders with the real keys from each machine.
  # Run: ssh-keyscan -t ed25519 <machine>  or  cat /etc/ssh/ssh_host_ed25519_key.pub
  barium  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHdKyNAn7ZvlDxcnAw9nBhjGAKzkNL5WllvjnJ7w2GfJ barium@luko.dev";
  krypton = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBzRcGZDlGRceEt3NwXdtfEpiXWWocC3t6U3XSx8ToKz";

  # --- Your personal SSH public key (for editing secrets) ---
  # Run: cat ~/.ssh/id_ed25519.pub   (or whichever key you use)
  luko = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHdKyNAn7ZvlDxcnAw9nBhjGAKzkNL5WllvjnJ7w2GfJ barium@luko.dev";

  # Convenience groups
  allSystems = [ barium krypton ];
  allKeys    = allSystems ++ [ luko ];
in
{
  # Transmission RPC credentials (krypton media server)
  # The secret file must be a JSON file with the format:
  #   { "rpc-username": "youruser", "rpc-password": "yourpassword" }
  # Create it with: nix run github:ryantm/agenix -- -e secrets/transmission-credentials.age
  "transmission-credentials.age".publicKeys = [ krypton luko ];

  # Photoprism admin password (krypton media server)
  # The secret file must contain just the plain password, e.g.:
  #   mysecretpassword
  # Create it with: nix run github:ryantm/agenix -- -e secrets/photoprism-admin-password.age
  "photoprism-admin-password.age".publicKeys = [ krypton luko ];

  # Restreamer webcam credentials (krypton media server)
  # The secret file must contain two lines in env format:
  #   RS_USERNAME=youruser
  #   RS_PASSWORD=yourpassword
  # Create it with: nix run github:ryantm/agenix -- -e secrets/restreamer-credentials.age
  "restreamer-credentials.age".publicKeys = [ krypton luko ];

  # BGG-MM config (krypton)
  # The secret file must be a JSON file, e.g.:
  #   {
  #     "bgg": { "username": "yourbgguser" },
  #     "shop": { "base_url": "http://www.moenen-en-mariken.nl" },
  #     "ntfy": { "topic": "yourtopic", "token": "yourtoken" },
  #     "state_file": "/var/lib/bgg-mm/availability.json"
  #   }
  # Create it with: nix run github:ryantm/agenix -- -e secrets/bbg-mm-config.age
  "bbg-mm-config.age".publicKeys = [ krypton luko ];

  # BGG-MM API token (krypton)
  # The secret file must contain one line in env format:
  #   BGG_API_TOKEN=yourtoken
  # Create it with: nix run github:ryantm/agenix -- -e secrets/bbg-mm-token.age
  "bbg-mm-token.age".publicKeys = [ krypton luko ];

  # Homepage dashboard environment variables (krypton)
  # Contains API keys for service widgets, one per line:
  #   HOMEPAGE_VAR_JELLYFIN_KEY=...
  #   HOMEPAGE_VAR_RADARR_KEY=...
  #   HOMEPAGE_VAR_SONARR_KEY=...
  #   HOMEPAGE_VAR_PROWLARR_KEY=...
  #   HOMEPAGE_VAR_BAZARR_KEY=...
  #   HOMEPAGE_VAR_TRANSMISSION_USER=...
  #   HOMEPAGE_VAR_TRANSMISSION_PASS=...
  #   HOMEPAGE_VAR_PHOTOPRISM_USER=...
  #   HOMEPAGE_VAR_PHOTOPRISM_PASS=...
  # Create it with: nix run github:ryantm/agenix -- -e secrets/homepage-env.age
  "homepage-env.age".publicKeys = [ krypton luko ];
}
