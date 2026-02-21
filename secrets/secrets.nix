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
}
