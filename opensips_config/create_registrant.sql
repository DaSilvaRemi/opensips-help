INSERT INTO registrant (
  registrar,
  proxy,
  aor,
  username,
  password,
  binding_URI,
  expiry
)
SELECT
  'sip:${SIP_DISTANT_SERVER_URI}' AS registrar,
  'sip:${SIP_DISTANT_SERVER_URI}' AS proxy,
  'sip:${KEYYO_PHONE_NUMBER}@${SIP_DISTANT_SERVER_URI}' AS aor,
  '${KEYYO_PHONE_NUMBER}' AS username,
  '${KEYYO_SIP_PASSWORD}' AS password,
  'sip:${KEYYO_PHONE_NUMBER}@${OPENSIPS_PUBLIC_IP}:5060' AS binding_URI,
  3600 AS expiry
WHERE NOT EXISTS (
  SELECT 1 FROM registrant WHERE aor = 'sip:${KEYYO_PHONE_NUMBER}@${SIP_DISTANT_SERVER_URI}'
);
