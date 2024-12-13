Redpanda Console – A UI for Data Streaming
Redpanda Console (previously known as Kowl) is a web application that helps you manage and debug your Kafka/Redpanda workloads effortlessly
![image](https://private-user-images.githubusercontent.com/23424570/220130537-7b0b8596-0a06-4132-90a5-1be3c169e4f4.mp4?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MzQxMDk4MjMsIm5iZiI6MTczNDEwOTUyMywicGF0aCI6Ii8yMzQyNDU3MC8yMjAxMzA1MzctN2IwYjg1OTYtMGEwNi00MTMyLTkwYTUtMWJlM2MxNjllNGY0Lm1wND9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDEyMTMlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQxMjEzVDE3MDUyM1omWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWJjYmViY2YwMTBmZDk5MzFjNTQ4NmMwZmNlZWEyY2I3YzBhNmVjMmVkMzE0MGRiNzM1MTRiODI2Y2M1N2NiNjMmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.jmMLb4MD1fTMbuwPMAUP436GWtUcEYZFrmNY76UKYBM)

 
🎯 Features

✅ Message viewer: Explore your topics' messages in our message viewer through ad-hoc queries and dynamic filters. Find any message you want using JavaScript functions to filter messages. Supported encodings are: JSON, Avro, Protobuf, CBOR, XML, MessagePack, Text and Binary (hex view). The used encoding (except Protobuf and CBOR) is recognized automatically.

✅ Consumer groups: List all your active consumer groups along with their active group offsets, edit group offsets (by group, topic or partition) or delete a consumer group.

✅ Topic overview: Browse through the list of your Kafka topics, check their configuration, space usage, list all consumers who consume a single topic or watch partition details (such as low and high water marks, message count, ...), embed topic documentation from a git repository and more.

✅ Cluster overview: List vailable brokers, their space usage, rack id, health, configuration and other information to get a high level overview of your brokers in your cluster.

✅ Security: Create, list or edit Kafka ACLs and SASL-SCRAM users.

✅ Schema Registry: List and manage all aspects of your Avro, Protobuf or JSON schemas within your schema registry.
✅ Kafka connect: Manage connectors from multiple connect clusters, patch configs, view their current state or restart tasks.
✅ Redpanda Transforms: Manage and monitor data transforms deployed in your Redpanda cluster.

🚀 Technologies

The following tools were used in this project:

    Terraform   

✅ Requirements

Before starting 🏁, you need to have Git, Kubernetes, Terraform

