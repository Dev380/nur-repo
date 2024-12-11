{
  pkgs,
  fetchFromGitHub,
  rustPlatform,
}:
  rustPlatform.buildRustPackage rec {
    pname = "ez-uploader";
    version = "0.3.0";
    src = fetchFromGitHub {
      owner = "theMackabu";
      repo = pname;
      rev = "227c3741fe3a968273176a68cdb1884ef4b1d93c";
      hash = "sha256-J/Pwh7Qy0JEvCcpKYwnoDOXCCAczUR3t6jAQObesWVY=";
    };
    buildInputs = with pkgs; [openssl];
    nativeBuildInputs = with pkgs; [pkg-config];
    cargoHash = "sha256-H71TjKWVZgqF/KRrXm/7lgUYlxcLMfa59amH17UhSr8=";
  }
