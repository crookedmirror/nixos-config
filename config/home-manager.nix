{
  inputs,
  globals,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    sharedModules = [
      inputs.chaotic.homeManagerModules.default
      inputs.spicetify.homeManagerModules.default
      inputs.nur.modules.homeManager.default
    ];

    extraSpecialArgs = { inherit inputs globals; };
    backupFileExtension = "backup";
    verbose = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };

  environment.pathsToLink = [ "/share/zsh" ];
}
