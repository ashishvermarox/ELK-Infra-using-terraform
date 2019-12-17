elkserver=$1
cat > /tmp/filebeat.yml<<EOF1
output:
  logstash:
    enabled: true
    hosts:
      - $elkserver:5044
    timeout: 15
    ssl:
      certificate_authorities:
      - /etc/pki/tls/certs/logstash-beats.crt

filebeat.inputs:
- paths:
  - /tmp/sample_logs/*.json
  fields:
    service: log_json
  fields_under_root: true
  document_type: log_json
  multiline.pattern: ^\{
  multiline.negate: true
  multiline.match: after
EOF1