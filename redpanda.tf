resource "helm_release" "kafka-console" {
  name             = "console"
  repository       = "https://charts.redpanda.com"
  chart            = "console"
  namespace        = "default"
  create_namespace = true
  timeout          = 300
  depends_on = [helm_release.kafka-connect]

  values = [
    <<EOT
console:
  config:
    kafka:
      clientId: redpanda-console
      brokers:
      - kafka:9092
      sasl:
        enabled: true
        mechanism: PLAIN
        username: user1
        password: lVuZO3pXVw
      tls:
        enabled: false
        insecureSkipTlsVerify: true
      schemaRegistry:
        enabled: true
        urls: ["http://schema-registry:8081"]
      protobuf:
        enabled: true
        schemaRegistry:
          enabled: true
          refreshInterval: 5m
    connect:
      enabled: true
      clusters:
      - name: staging
        url: http://kafka-connect:8083
        tls:
          enabled: true # Trusted certs are still allowed by default
      connectTimeout: 15s
      readTimeout: 60s
      requestTimeout: 6s
EOT
  ]
}

resource "null_resource" "wait_for_console" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    
    command = <<EOF
      printf "\nWaiting for the rconsole pods to start...\n"
      sleep 5
      until kubectl wait -n ${helm_release.kafka-console.namespace} --for=condition=Ready pods --all; do
        sleep 2
      done  2>/dev/null
    EOF
  }

  depends_on = [helm_release.kafka-console]
}
