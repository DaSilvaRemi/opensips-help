INSERT INTO load_balancer (
    group_id,
    dst_uri,
    resources
)
SELECT
    1 AS group_id,
    'sip:${SIP_INTERNAL_ADRESS}' AS dst_uri,
    'channel=10' AS resources
WHERE NOT EXISTS (
    SELECT 1 FROM load_balancer WHERE dst_uri = 'sip:${SIP_INTERNAL_ADRESS}'
);