#!/bin/sh

TELEGRAM_BOT_TOKEN="$TELEGRAM_BOT_TOKEN"
TELEGRAM_CHAT_ID="$TELEGRAM_CHAT_ID"
BOT_NAME="schuttph DO6 CI/CD"
CI_JOB_NAME="$CI_JOB_NAME"
CI_JOB_STATUS="$CI_JOB_STATUS"

if [ "$CI_JOB_STATUS" = "success" ]; then
    EMOJI="✅"
    STATUS="УСПЕШНО"
else
    EMOJI="❌"
    STATUS="ПРОВАЛЕНО"
fi

COMMIT_MSG=$(echo "$CI_COMMIT_MESSAGE" | cut -c 1-50)

MESSAGE="🔔 *$BOT_NAME*

*Этап:* $CI_JOB_NAME
*Статус:* $STATUS $EMOJI
*Ветка:* \`$CI_COMMIT_REF_NAME\`
*Коммит:* $COMMIT_MSG

[Открыть в GitLab]($CI_PIPELINE_URL)"

curl -s -X POST \
    -H "Content-Type: application/json" \
    -d "{
        \"chat_id\": \"$TELEGRAM_CHAT_ID\",
        \"text\": \"$MESSAGE\",
        \"parse_mode\": \"Markdown\",
        \"disable_web_page_preview\": true
    }" \
    "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
