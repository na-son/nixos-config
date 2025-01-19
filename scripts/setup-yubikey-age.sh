#!/usr/bin/env bash
set -euo pipefail

# Create necessary directories
mkdir -p ~/.config/sops/age

# Check if age-plugin-yubikey is installed
if ! command -v age-plugin-yubikey &> /dev/null; then
    echo "Installing age-plugin-yubikey..."
    nix-env -iA nixpkgs.age-plugin-yubikey
fi

# Generate age recipient identity from YubiKey
if [ ! -f ~/.config/sops/age/keys.txt ]; then
    echo "Generating age identity from YubiKey..."
    echo "Please insert your YubiKey and touch it when prompted..."
    age-plugin-yubikey --identity > ~/.config/sops/age/keys.txt
    chmod 600 ~/.config/sops/age/keys.txt
fi

# Get the public key
AGE_PUBLIC_KEY=$(age-plugin-yubikey --identity 2>/dev/null | age-plugin-yubikey -y)

echo "Your age public key is: $AGE_PUBLIC_KEY"
echo "This key has been saved to ~/.config/sops/age/keys.txt"
echo ""
echo "Now creating .sops.yaml configuration..."

# Create .sops.yaml with the public key
cat > .sops.yaml << EOF
creation_rules:
  - path_regex: secrets/.*
    age: >-
      ${AGE_PUBLIC_KEY}
EOF

echo "Setup complete! Your YubiKey is now configured for use with sops-nix."
echo "You can now encrypt your secrets using: sops secrets/secrets.yaml"
