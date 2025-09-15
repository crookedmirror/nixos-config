#!/usr/bin/env bash
# forked from https://github.com/oddlama/nix-config/blob/20477ecdc52165058d2b076adbdfb1ca4c37b1bb/nix/rage-decrypt-and-cache.sh
set -euo pipefail

file="$1"
shift
identities=("$@")

#file="$2"
#identities=("$1")

# Strip .age suffix, and store path prefix or ./ if applicable
basename="${file%".age"}"
[[ $file == "/nix/store/"* ]] && basename="${basename#*"-"}"
[[ $file == "./"* ]] && basename="${basename#"./"}"

# Calculate a unique content-based identifier (relocations of
# the source file in the nix store should not affect caching)
new_name="$(sha512sum "$file")"
new_name="${new_name:0:32}-${basename//"/"/"_"}"

# Derive the path where the decrypted file will be stored
out="/var/tmp/nix-import-encrypted/$UID/$new_name"
umask 077
mkdir -p "$(dirname "$out")"

# Decrypt only if necessary
if [[ ! -e $out ]]; then
  args=()
  for i in "${identities[@]}"; do
    args+=("--identity" "$i")
  done
  rage --decrypt "${args[@]}" --output "$out" "$file"
fi

# Print out decrypted content
echo "$out"
