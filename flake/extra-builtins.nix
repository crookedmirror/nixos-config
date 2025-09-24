{ exec, ... }:
let
  assertMsg = pred: msg: pred || builtins.throw msg;
in
{
  # Instead of calling rage directly here, we call a wrapper script that will cache the output
  # in a predictable path in /tmp, which allows us to only require the password for each encrypted
  # file once.
  rageImportEncrypted =
    identities: nixFile:
    let
      # Extract identity paths from the new structure
      # Handles both old format (plain paths) and new format (objects with identity field)
      identityPaths = map (
        identity: if builtins.isAttrs identity then identity.identity else identity
      ) identities;
    in
    assert assertMsg (builtins.isPath nixFile)
      "The file to decrypt must be given as a path to prevent impurity.";
    exec (
      [
        "sh"
        ./rageImportEncrypted.sh
        nixFile
      ]
      ++ identityPaths
    );
}
