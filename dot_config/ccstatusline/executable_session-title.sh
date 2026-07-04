#!/bin/sh
# ccstatusline custom-command : affiche le titre IA de la session Claude
# (le résumé « Améliorer la mise en surbrillance… » visible dans /resume et
# dans le titre d'onglet). Reçoit sur stdin le JSON de la statusLine, dont
# .transcript_path. C'est ccstatusline qui tronque la ligne à la largeur du pane.
tp=$(jq -r '.transcript_path // empty')
[ -n "$tp" ] && [ -f "$tp" ] || exit 0
grep '"type":"ai-title"' "$tp" 2>/dev/null | tail -1 | jq -r '.aiTitle // empty'
