#!/data/data/com.termux/files/usr/bin/bash
echo "🔍 NoaApp - Diagnostic Build GitHub Actions"
RID=$(gh run list --workflow build-android.yml --limit 1 --json databaseId,status,conclusion,displayTitle -q '.[0] | "\(.databaseId) | \(.status) | \(.conclusion) | \(.displayTitle)"')
[[ -z "$RID" ]] && echo "❌ Aucun run trouvé" && exit 1
echo "$RID"
RUN_ID=$(echo "$RID" | cut -d'|' -f1 | xargs)
echo ""; echo "🔍 Détails:"
gh run view "$RUN_ID"
echo ""; echo "📝 Logs complets -> ~/noa-build-log.txt"
gh run view "$RUN_ID" --log > ~/noa-build-log.txt
echo ""; echo "🔍 Erreurs:"
grep -i "error\|fail\|exception" ~/noa-build-log.txt | head -20 || true
echo ""; echo "📦 Artefacts:"
gh api repos/:owner/:repo/actions/runs/$RUN_ID/artifacts --jq '.artifacts[] | "\(.name) | \(.size_in_bytes) bytes"' || true
echo ""; echo "🗂️  Sorties locales (si présentes):"
cd ~/noa-cordova/NoaApp
ls -la platforms/android/app/build/outputs/apk/debug/ 2>/dev/null || true
