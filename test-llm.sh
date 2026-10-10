curl -k -sS -i \
  "${OPENAI_BASE_URL}/models" \
  -H "Authorization: Bearer ${OPENAI_API_KEY}"

curl -k -sS -i \
  "${OPENAI_BASE_URL}/responses" \
  -H "Authorization: Bearer ${OPENAI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-6.1-sol",
    "input": "Reply with exactly: API_OK"
  }'

curl -k -sS -i https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer ${OPENROUTER_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "openai/gpt-4o-mini",
    "messages": [
      {"role": "user", "content": "Reply with exactly: Hello OpenRouter"}
    ],
    "stream": false
  }'
