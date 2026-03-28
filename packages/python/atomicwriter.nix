{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "atomicwriter";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6K0ebMTU6mfofJGf98kgUtlOOfua5zvAFT/a5p7sufY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-0X6/Dits4xdAsLdvi/JsjaRK5jqIVzAnABLutjaAUrw=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  build-system = [ ];

  dependencies = [ ];

  meta = {
    changelog = "https://github.com/Ravencentric/atomicwriter/releases/tag/${version}";
    homepage = "https://github.com/Ravencentric/atomicwriter/";
    description = "Cross-platform atomic file writer for all-or-nothing operations.";
    license = lib.licenses.mit;
  };
}
