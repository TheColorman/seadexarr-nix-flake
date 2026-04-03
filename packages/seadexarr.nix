{
  python3Packages,
  lib,
  extraPackages,
  installShellFiles,
  stdenv,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "seadexarr";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bbtufty";
    repo = "seadexarr";
    rev = "f64a270dace9bceac8b2105a3ecaf3c8b2193a26";
    hash = "sha256-6DXordytNy6XEzyFT9bRFlEuHCRa+/yF2ZBDkEU5Wmc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools == 80.9.0" "setuptools" \
      --replace-fail "setuptools_scm == 9.2.2" "setuptools_scm" \
      --replace-fail "wheel == 0.45.1" "wheel" \
      --replace-fail "arrapi == 1.4.14" "arrapi" \
      --replace-fail "beautifulsoup4 == 4.14.3" "beautifulsoup4" \
      --replace-fail "colorlog == 6.10.1" "colorlog" \
      --replace-fail "PyYAML == 6.0.3" "PyYAML" \
      --replace-fail "qbittorrent-api == 2025.11.1" "qbittorrent-api" \
      --replace-fail "ruamel.yaml == 0.19.1" "ruamel.yaml" \
      --replace-fail "typer == 0.21.1" "typer"
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
