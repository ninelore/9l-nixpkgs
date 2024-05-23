{ pkgs }:
pkgs.stdenv.mkDerivation { #rec

  name = "eshare-bin";
  version = "7.5.0220";

  src = pkgs.fetchurl {
    # url = "https://cdn.sharemax.cn/rel/linux/EShareClient_v${version}_amd64.deb";
    # sha256 = "b276effb6d5ffa6d54c5f9cbffa037e92926e8a413205f5b2d07eaae3632f5b1";

    url = "https://update.digitale-tafel.com/sharing/ubuntu-app/ubuntu.zip";
    sha256 = "e715fd6aa9642a47f0b925f03da15f15ceb456f5950f0576a1d38710bdc20f60";
  };

  buildInputs = with pkgs; [
    alsa-lib
    e2fsprogs # for libcom_err.so.2
    elfutils # for libdw.so.1
    libdrm
    libunwind
    libglvnd
    libgpg-error
    libxkbcommon
    pango
    xorg.libICE
    xorg.libSM
    flac
    libvorbis
  ];

  dontBuild = true;
  dontConfigure = true;
  dontStrip = true;
  dontUnpack = true;

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    dpkg
    unzip
  ];



  installPhase = ''
    runHook preInstall
    
    unzip $src

    dpkg-deb -x EShareClient_AMD64.deb .


    mkdir -p $out
    mv opt $out/

    mkdir -p $out/share/applications
      
    # fix the path in the desktop file
    #substituteInPlace \
    #  $out/opt/EShare/EShare.desktop \
    #  --replace-fail /opt/ $out/opt/
      
    # cp $out/opt/EShare/EShare.desktop $out/share/applications


    mkdir -p $out/bin 
      
    # symlink the binary to bin/
    ln -s $out/opt/EShare/EShare $out/bin/Eshare

    runHook postInstall
  '';

  

}
