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
    assert assertMsg (builtins.isPath nixFile)
      "The file to decrypt must be given as a path to prevent impurity.";
    exec (
      [
        "sh"
        ./rageImportEncrypted.sh
        nixFile
      ]
      ++ identities
    );
}
