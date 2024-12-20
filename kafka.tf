resource "helm_release" "kafka" {
  name             = "kafka"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "kafka"
  namespace        = "default"
  create_namespace = true
  force_update     = true
  wait             = true
  timeout          = 300
  

  values = [
    <<EOT
extraConfig: |
  log.retention.hours=12
  log.retention.bytes=85899345920
  log.cleaner.delete.retention.ms=43200000
  log.roll.hours=4
  offsets.topic.replication.factor=3


extraEnvVars:
  - name: KAFKA_CFG_AUTO_CREATE_TOPICS_ENABLE
    value: "true"

controller:
  automountServiceAccountToken: true
  replicaCount: 3
  resources:
    limits:
      cpu: 4
      memory: "4Gi"
    requests:
      memory: "1Gi"
      cpu: 1

broker:
  automountServiceAccountToken: true
  persistence:
    size: 10Gi

sasl:
  client:
    users:
      - user1
    passwords: "lVuZO3pXVw"

service:
  type: LoadBalancer

externalAccess:
  enabled: true
  autoDiscovery:
    enabled: true
  controller:
    service:
      type: NodePort
  broker:
    service:
      type: NodePort

rbac:
  create: true

metrics:
  kafka:
    enabled: true
  serviceMonitor:
    enabled: false
  jmx:
    enabled: true

EOT
  ]
}

resource "null_resource" "wait_for_kafka" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    #environment = {
    #  PATH       = var.system_path
    #  KUBECONFIG = "k3s.yaml"
    #}
    command = <<EOF
      printf "\nWaiting for the kafka pods to start...\n"
      sleep 5
      until kubectl wait -n ${helm_release.kafka.namespace} --for=condition=Ready pods --all; do
        sleep 2
      done  2>/dev/null
    EOF
  }

  depends_on = [helm_release.kafka]
}
