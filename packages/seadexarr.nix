{
  python3Packages,
  lib,
  extraPackages,
  fetchPypi,
  installShellFiles,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "seadexarr";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FZj0LULc3BbrlqMvOPdkNGXxDPHd/2T37OsYvnZeAdI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools == 80.9.0" "setuptools" \
      --replace-fail "setuptools_scm == 9.2.0" "setuptools_scm" \
      --replace-fail "wheel == 0.45.1" "wheel" \
      --replace-fail "arrapi == 1.4.14" "arrapi" \
      --replace-fail "beautifulsoup4 == 4.13.5" "beautifulsoup4" \
      --replace-fail "colorlog == 6.9.0" "colorlog" \
      --replace-fail "PyYAML == 6.0.2" "PyYAML" \
      --replace-fail "qbittorrent-api == 2025.7.0" "qbittorrent-api" \
      --replace-fail "ruamel.yaml == 0.18.15" "ruamel.yaml" \
      --replace-fail "typer == 0.17.4" "typer"
  '';

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies =
    (with python3Packages; [
      beautifulsoup4
      colorlog
      httpx
      pyyaml
      qbittorrent-api
      requests
      ruamel-yaml
      typer
    ])
    ++ (with extraPackages; [
      arrapi
      discordwebhook
      pynyaa
      seadex
    ]);

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export _TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION=1

    installShellCompletion --cmd seadexarr \
      --bash <($out/bin/seadexarr --show-completion=bash) \
      --zsh <($out/bin/seadexarr --show-completion=zsh) \
      --fish <($out/bin/seadexarr --show-completion=fish)
  '';

  meta = {
    description = "Sync Anime on Sonarr and Radarr with SeaDex";
    homepage = "https://github.com/bbtufty/seadexarr";
    license = lib.licenses.gpl3;
    platforms = lib.systems.flakeExposed;
  };
}
