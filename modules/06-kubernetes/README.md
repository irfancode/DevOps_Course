# Module 6: Kubernetes

## Learning Objectives

By the end of this module, you will:
- ✅ Understand Kubernetes architecture
- ✅ Deploy applications to K8s
- ✅ Manage pods, services, and deployments
- ✅ Scale applications
- ✅ Use ConfigMaps and Secrets

## What is Kubernetes?

Kubernetes (K8s) is an **orchestration platform** that automates deployment, scaling, and management of containerized applications.

### Kubernetes vs Docker Compose

| Aspect | Docker Compose | Kubernetes |
|--------|---------------|------------|
| Scale | Manual | Automatic |
| Self-healing | No | Yes |
| Load balancing | Manual | Built-in |
| Rolling updates | Manual | Automatic |
| Service discovery | Limited | Built-in |
| Nodes | Single host | Multiple |

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      Kubernetes Cluster                          │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                     Control Plane                        │   │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐      │   │
│  │  │ kube-   │ │ kube-   │ │ kube-   │ │ etcd   │      │   │
│  │  │ api-    │ │ sched-  │ │ cont-   │ │        │      │   │
│  │  │ server  │ │ uler   │ │ roller  │ │        │      │   │
│  │  └─────────┘ └─────────┘ └─────────┘ └─────────┘      │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌───────────────┐ ┌───────────────┐ ┌───────────────┐        │
│  │  Worker Node  │ │  Worker Node  │ │  Worker Node  │        │
│  │  ┌─────────┐  │ │  ┌─────────┐  │ │  ┌─────────┐  │        │
│  │  │  kubelet │  │ │  │  kubelet │  │ │  │  kubelet │  │        │
│  │  ├─────────┤  │ │  ├─────────┤  │ │  ├─────────┤  │        │
│  │  │ kube-   │  │ │  │ kube-   │  │ │  │ kube-   │  │        │
│  │  │ proxy   │  │ │  │ proxy   │  │ │  │ proxy   │  │        │
│  │  ├─────────┤  │ │  ├─────────┤  │ │  ├─────────┤  │        │
│  │  │  Pods   │  │ │  │  Pods   │  │ │  │  Pods   │  │        │
│  │  │ ┌────┐  │  │ │  │ ┌────┐  │  │ │  │ ┌────┐  │  │        │
│  │  │ │app│  │  │ │  │ │app│  │  │ │  │ │app│  │  │        │
│  │  │ └────┘  │  │ │  │ └────┘  │  │ │  │ └────┘  │  │        │
│  │  └─────────┘  │ │  └─────────┘  │ │  └─────────┘  │        │
│  └───────────────┘ └───────────────┘ └───────────────┘        │
└─────────────────────────────────────────────────────────────────┘
```

## Key Concepts

| Concept | Description |
|---------|-------------|
| **Pod** | Smallest deployable unit (1+ containers) |
| **Node** | Worker machine (VM or physical) |
| **Cluster** | Collection of nodes |
| **Deployment** | Manages pod replicas |
| **Service** | Network access to pods |
| **ConfigMap** | Configuration data |
| **Secret** | Sensitive data |
| **Namespace** | Virtual cluster separation |

## kubectl Basics

```bash
kubectl get pods                    # List pods
kubectl get nodes                  # List nodes
kubectl get deployments           # List deployments
kubectl get services              # List services
kubectl get all                   # List everything
kubectl get namespaces            # List namespaces

kubectl create deployment myapp --image=nginx --replicas=3
kubectl scale deployment myapp --replicas=5
kubectl delete pod myapp-pod
kubectl describe pod myapp-pod
kubectl logs myapp-pod
kubectl exec -it myapp-pod -- bash
kubectl port-forward pod/myapp-pod 8080:80

kubectl apply -f deployment.yaml   # Apply config
kubectl delete -f deployment.yaml  # Delete from config
kubectl edit deployment myapp      # Edit in place
```

## Creating a Deployment

### deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    app: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: nginx:alpine
        ports:
        - containerPort: 80
        resources:
          limits:
            memory: "128Mi"
            cpu: "500m"
          requests:
            memory: "64Mi"
            cpu: "250m"
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 3
          periodSeconds: 10
```

### Apply and Manage

```bash
kubectl apply -f deployment.yaml
kubectl get deployments
kubectl get pods
kubectl describe deployment my-app
kubectl rollout status deployment/my-app
```

## Creating a Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
spec:
  type: ClusterIP          # ClusterIP, NodePort, LoadBalancer
  selector:
    app: my-app
  ports:
  - protocol: TCP
    port: 80               # Service port
    targetPort: 80         # Container port
```

```bash
kubectl apply -f service.yaml
kubectl get services
```

### Service Types

| Type | Description | Use Case |
|------|-------------|----------|
| ClusterIP | Internal only | Internal apps |
| NodePort | Expose via node port | Development |
| LoadBalancer | Cloud LB | Production |
| ExternalName | CNAME alias | DNS aliases |

## ConfigMaps & Secrets

### ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
data:
  DATABASE_HOST: "db.example.com"
  LOG_LEVEL: "info"
```

### Secret

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  # echo -n "password" | base64
  DB_PASSWORD: cGFzc3dvcmQ=
```

### Using in Pod

```yaml
env:
- name: DB_HOST
  valueFrom:
    configMapKeyRef:
      name: my-config
      key: DATABASE_HOST
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: my-secret
      key: DB_PASSWORD
```

## Scaling & Updates

```bash
# Scale deployment
kubectl scale deployment my-app --replicas=5

# Update image
kubectl set image deployment/my-app my-app=nginx:1.21

# Check rollout
kubectl rollout status deployment/my-app

# Rollback
kubectl rollout undo deployment/my-app

# View history
kubectl rollout history deployment/my-app
```

## Namespaces

```bash
kubectl get namespaces
kubectl create namespace my-namespace
kubectl config set-context --current --namespace=my-namespace
kubectl delete namespace my-namespace
```

### Resource Quotas

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: my-quota
spec:
  hard:
    pods: "10"
    services: "5"
    requests.cpu: "4"
    requests.memory: "8Gi"
```

## Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app-service
            port:
              number: 80
```

## Persistent Volumes

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

```yaml
volumes:
- name: data
  persistentVolumeClaim:
    claimName: my-pvc
```

## Useful Commands Reference

```bash
# Cluster info
kubectl cluster-info
kubectl version
kubectl get nodes -o wide

# Debugging
kubectl get events
kubectl logs my-pod
kubectl exec -it my-pod -- /bin/sh
kubectl port-forward my-pod 8080:80

# Health checks
kubectl get pod my-pod -o yaml | grep -A 5 status
kubectl describe pod my-pod

# Resources
kubectl top nodes
kubectl top pods
```

## Minikube for Local Development

```bash
# Install
brew install minikube

# Start cluster
minikube start

# Dashboard
minikube dashboard

# Stop/delete
minikube stop
minikube delete

# Addons
minikube addons enable ingress
minikube addons list
```

---

**← [Back to Module 5](../05-cloud-aws/README.md)** | **[Lab: K8s Deployment →](./labs/lab-06-kubernetes.md)**