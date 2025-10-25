#!/data/data/com.termux/files/usr/bin/bash
echo "🔍 NoaApp - Diagnostic Build GitHub Actions"
RID=$(gh run list --workflow build-android.yml --limit 1 --json databaseId,status,conclusion,displayTitle -q '.[0] | "\(.databaseId) | \(.status) | \(.conclusion) | \(.displayTitle)"')
[[ -z "$RID" ]] && echo "Aucun run" && exit 1
echo "$RID"
RUN_ID=$(echo "$RID" | cut -d'|' -f1 | xargs)
gh run view "$RUN_ID"
gh run view "$RUN_ID" --log > ~/noa-build-log.txt
grep -i "error\|fail\|exception" ~/noa-build-log.txt | head -20
gh run view "$RUN_ID" --json artifacts -q '.artifacts[] | "\(.name) | \(.sizeInBytes) bytes"'
cd ~/noa-cordova/NoaApp
ls -la platforms/android/app/build/outputs/apk/debug/ 2>/dev/null || true
