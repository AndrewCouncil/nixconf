{
  lib,
  pkgs,
  ...
}:
{
  projectRootFile = "flake.nix";
  programs.nixfmt.enable = true;
  programs.prettier.enable = true;
  programs.shellcheck.enable = true;

  # buggy as of right now
  # programs.nufmt.enable = true;
  # settings.formatter.nufmt.includes = lib.mkAfter [ "pre-commit" ];
}
