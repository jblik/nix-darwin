# Work directory classes.
typeset -g POWERLEVEL9K_DIR_CLASSES=(
  '~/nix-darwin(|/*)'  NIX      ''
  '~(|/*)corellia'     CORELLIA ''
  '~(|/*)c3po'         C3PO     ''
  '~(|/*)r-series-nix' RNIX     ''
  '~(|/*)kamino'       KAMINO   ''
  '~/work(|/*)'        WORK     ''
  '~(|/*)'             HOME     ''
  '*'                  DEFAULT  '')

typeset -g POWERLEVEL9K_DIR_CORELLIA_VISUAL_IDENTIFIER_EXPANSION='󱭐 '
typeset -g POWERLEVEL9K_DIR_C3PO_VISUAL_IDENTIFIER_EXPANSION='󱬣'
typeset -g POWERLEVEL9K_DIR_RNIX_VISUAL_IDENTIFIER_EXPANSION='󱬞'
typeset -g POWERLEVEL9K_DIR_KAMINO_VISUAL_IDENTIFIER_EXPANSION='󱭲'
typeset -g POWERLEVEL9K_DIR_WORK_VISUAL_IDENTIFIER_EXPANSION='󰳐'

# Work Kubernetes context classes.
typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
  '*solar*|*ops*|*master*'  PROD
  '*arcadia*'                TEST
  '*'                        DEFAULT)

typeset -g POWERLEVEL9K_KUBECONTEXT_TEST_FOREGROUND=208
typeset -g POWERLEVEL9K_KUBECONTEXT_TEST_VISUAL_IDENTIFIER_EXPANSION='⚠️'
typeset -g POWERLEVEL9K_KUBECONTEXT_PROD_FOREGROUND=9
typeset -g POWERLEVEL9K_KUBECONTEXT_PROD_VISUAL_IDENTIFIER_EXPANSION='🚨'
typeset -g POWERLEVEL9K_KUBECONTEXT_PROD_CONTENT_EXPANSION='${P9K_KUBECONTEXT_NAME}'
