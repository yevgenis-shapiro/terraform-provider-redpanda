resource "helm_release" "kafka-schema-registry" {
  name             = "schema-registry"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "schema-registry"
  namespace        = "default"
  create_namespace = true
  timeout          = 300
  depends_on = [helm_release.kafka]

  values = [
    <<EOT
auth:
  kafka:
    tlsEndpointIdentificationAlgorithm: ""
    saslMechanism: SCRAM-SHA-256

kafka:
  enabled: false

externalKafka:
  ## @param externalKafka.brokers Array of Kafka brokers to connect to. Format: protocol://broker_hostname:port
  ##
  brokers:
    - SASL_PLAINTEXT://kafka-controller-0.kafka-controller-headless.default.svc.cluster.local:9092
    - SASL_PLAINTEXT://kafka-controller-1.kafka-controller-headless.default.svc.cluster.local:9092
    - SASL_PLAINTEXT://kafka-controller-2.kafka-controller-headless.default.svc.cluster.local:9092
  ## @param externalKafka.listener.protocol Kafka listener protocol. Allowed protocols: PLAINTEXT, SASL_PLAINTEXT, SASL_SSL and SSL
  ##
  listener:
    protocol: SASL_PLAINTEXT
  ## Authentication parameters
  ## @param externalKafka.sasl.user User for SASL authentication
  ## @param externalKafka.sasl.password Password for SASL authentication
  ## @param externalKafka.sasl.existingSecret Name of the existing secret containing a password for SASL authentication (under the key named "client-passwords")
  ##
  sasl:
    user: user1
    password: lVuZO3pXVw

EOT
  ]
}

resource "null_resource" "wait_for_schema-registry" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {

    command = <<EOF
      printf "\nWaiting for the schema-registry pods to start...\n"
      sleep 5
      until kubectl wait -n ${helm_release.kafka-schema-registry.namespace} --for=condition=Ready pods --all; do
        sleep 2
      done  2>/dev/null
    EOF
  }

  depends_on = [helm_release.kafka-schema-registry]
}


resource "helm_release" "kafka-connect" {
  name             = "kafka-connect"
  repository       = "https://licenseware.github.io/charts/"
  chart            = "kafka-connect"
  namespace        = "default"
  create_namespace = true
  timeout          = 600
  depends_on = [helm_release.kafka-schema-registry]

  values = [
    <<EOT
configMapPairs:
  CONNECT_BOOTSTRAP_SERVERS: kafka:9092
  CONNECT_REST_PORT: "28082"
  CONNECT_GROUP_ID: kafka-connect
  CONNECT_CONFIG_STORAGE_TOPIC: kafka-connect-config
  CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR: "1"
  CONNECT_OFFSET_STORAGE_TOPIC: kafka-connect-offset
  CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR: "1"
  CONNECT_OFFSET_STORAGE_PARTITIONS: "-1"
  CONNECT_OFFSET_PARTITION_NAME: kafka-connect.1
  CONNECT_STATUS_STORAGE_TOPIC: kafka-connect-status
  CONNECT_STATUS_STORAGE_REPLICATION_FACTOR: "1"
  CONNECT_STATUS_STORAGE_PARTITIONS: "-1"
  CONNECT_KEY_CONVERTER: org.apache.kafka.connect.storage.StringConverter
  CONNECT_VALUE_CONVERTER: io.confluent.connect.avro.AvroConverter
  CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL: http://schema-registry:8081
  CONNECT_INTERNAL_KEY_CONVERTER: org.apache.kafka.connect.storage.StringConverter
  CONNECT_INTERNAL_VALUE_CONVERTER: io.confluent.connect.avro.AvroConverter
  CONNECT_PRODUCER_INTERCEPTOR_CLASSES: io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor
  CONNECT_CONSUMER_INTERCEPTOR_CLASSES: io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor
  CONNECT_REST_ADVERTISED_HOST_NAME: connect
  CONNECT_PLUGIN_PATH: /usr/share/java,/usr/share/confluent-hub-components
  CONNECT_LOG4J_LOGGERS: org.apache.zookeeper=ERROR,org.I0Itec.zkclient=ERROR,org.reflections=ERROR
  CONNECT_SECURITY_PROTOCOL: SASL_PLAINTEXT
  CONNECT_SASL_MECHANISM: SCRAM-SHA-256
  CONNECT_SASL_JAAS_CONFIG: org.apache.kafka.common.security.scram.ScramLoginModule required username="user1" password="lVuZO3pXVw";

kafka:
  create: false
schema-registry:
  create: false

EOT
  ]
}

resource "null_resource" "wait_for_kafka-connect" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    
    command = <<EOF
      printf "\nWaiting for the kafka-connect pods to start...\n"
      sleep 5
      until kubectl wait -n ${helm_release.kafka-connect.namespace} --for=condition=Ready pods --all; do
        sleep 2
      done  2>/dev/null
    EOF
  }

  depends_on = [helm_release.kafka-connect]
}


