{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nerd-fonts,
  nerd-font-patcher,
  fontforge,
  python3,
  writeText,
  # Enlarge the Star Wars glyphs within their cell. 1.3 keeps them inside the
  # line height (no vertical clipping against adjacent lines); 1.0 = untouched.
  glyphScale ? 1.3,
}:
let
  base = nerd-fonts.jetbrains-mono;

  swSrc = fetchFromGitHub {
    owner = "maxgreb";
    repo = "StarWars-Glyph-Icons";
    rev = "9c63c533679670a2a389ad9fb552e8c1c38d059a";
    hash = "sha256-nbqXZQl/0+z96gy47ehvC8jo0eD2ilUs1AZ74GgyM6A=";
  };

  # The webfont carries a full FontAwesome base; only U+F000-F09D are the 158
  # Star Wars icons. That range is exactly where the Nerd Font keeps FontAwesome,
  # so slim to those glyphs and shift them into free Supplementary PUA space.
  remapScript = writeText "remap.py" ''
    import fontforge, sys
    src, out = sys.argv[1], sys.argv[2]
    f = fontforge.open(src)
    BASE_OLD, BASE_NEW, N = 0xF000, 0xF1B00, 0x9E
    keep = {}
    for cp in range(BASE_OLD, BASE_OLD + N):
        try:
            g = f[cp]
        except TypeError:
            continue
        keep[g.glyphname] = BASE_NEW + (cp - BASE_OLD)
    for name, newcp in keep.items():
        f[name].unicode = newcp
    for g in list(f.glyphs()):
        if g.glyphname not in keep:
            f.removeGlyph(g)
    f.familyname = "StarWars GlyphIcons Symbols"
    f.fontname = "StarWarsGlyphIconsSymbols"
    f.fullname = "StarWars GlyphIcons Symbols"
    f.generate(out)
  '';

  # font-patcher scales custom glyphs to fit the cell; scale just the Star Wars
  # glyphs up about their own centre afterwards, preserving advance width.
  scaleScript = writeText "scale.py" ''
    import fontforge, psMat, sys
    f = fontforge.open(sys.argv[1])
    S = float(sys.argv[3])
    for cp in range(0xF1B00, 0xF1B9E):
        try:
            g = f[cp]
        except TypeError:
            continue
        if g.isWorthOutputting():
            bb = g.boundingBox()
            cx, cy = (bb[0] + bb[2]) / 2, (bb[1] + bb[3]) / 2
            m = psMat.compose(
                psMat.translate(-cx, -cy),
                psMat.compose(psMat.scale(S), psMat.translate(cx, cy)),
            )
            w = g.width
            g.transform(m)
            g.width = w
    f.generate(sys.argv[2])
  '';

  # font-patcher rewrites the name table; copy the originals back so the patched
  # font stays a drop-in ("JetBrainsMono Nerd Font" keeps resolving unchanged).
  renameScript = writeText "restore-names.py" ''
    import sys
    from fontTools.ttLib import TTFont
    patched, orig, out = sys.argv[1], sys.argv[2], sys.argv[3]
    p = TTFont(patched)
    o = TTFont(orig)
    p["name"] = o["name"]
    p.save(out)
  '';

  python = python3.withPackages (ps: [ ps.fonttools ]);
in
stdenvNoCC.mkDerivation {
  pname = "starwars-jetbrains-mono";
  inherit (base) version;

  dontUnpack = true;

  nativeBuildInputs = [
    nerd-font-patcher
    fontforge
    python
  ];

  buildPhase = ''
    runHook preBuild

    fontforge -lang=py -script ${remapScript} \
      ${swSrc}/fonts/starwars-glyphicons-webfont.ttf sw-remapped.ttf

    mkdir -p patched final
    for ttf in ${base}/share/fonts/truetype/NerdFonts/JetBrainsMono/*.ttf; do
      nerd-font-patcher --custom "$PWD/sw-remapped.ttf" --careful -out patched "$ttf"
      patchedttf=$(ls patched/*.ttf)
      fontforge -lang=py -script ${scaleScript} "$patchedttf" patched/scaled.ttf ${toString glyphScale}
      python3 ${renameScript} patched/scaled.ttf "$ttf" "final/$(basename "$ttf")"
      rm -f patched/*.ttf
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm444 -t $out/share/fonts/truetype/NerdFonts/JetBrainsMono final/*.ttf
    runHook postInstall
  '';

  meta = {
    description = "JetBrainsMono Nerd Font patched with Star Wars glyph icons at U+F1B00";
    inherit (base.meta) platforms;
  };
}
