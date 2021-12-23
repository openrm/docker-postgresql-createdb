# docker-postgresql-createdb
A simple Docker container to perform a `createdb` command on an existing instance.

Sometimes you want to make sure a DB exists after postgresql is already up and running, or if you want multiple DB to be created along with the postgresql instance. 


## Kubernetes definition example
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: postgresql-createdb
spec:
  template:
    spec:
      containers:
      - name: postgresql-createdb
        image: openrm/postgresql-createdb:latest
        imagePullPolicy: IfNotPresent
        env:
        - name: PGDATABASE
          value: "postgresql_database"
        - name: PGHOST
          value: "postgresql_host"
        - name: PGPORT
          value: "postgresql_port"
        - name: PGUSER
          valueFrom:
            secretKeyRef:
              name: postgresql
              key: user
        - name: PGPASS
          valueFrom:
            secretKeyRef:
              name: postgresql
              key: password
      restartPolicy: Never
  backoffLimit: 4
```

## Terraform
```tf
resource "kubernetes_job" "postgresql_createdb" {
  metadata {
    name = "postgresql-createdb"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name            = "postgresql-createdb"
          image           = "openrm/postgresql-createdb:latest"
          env {
            name = "PGDATABASE"
            value = postgresql_database
          }
          env {
            name = "PGHOST"
            value = postgresql_host
          }
          env {
            name = "PGPORT"
            value = postgresql_port
          }
          env {
            name = "PGUSER"
            value_from {
              secret_key_ref {
                name = "postgresql"
                key  = "user"
              }
            }
          }
          env {
            name = "PGPASS"
            value_from {
              secret_key_ref {
                name = "postgresql"
                key  = "password"
              }
            }
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 4
  }
  wait_for_completion = false
}
```
