# Lab 6: Kubernetes Deployment ☸️

Time: 90 minutes | Difficulty: Intermediate

## Prerequisites

- Docker installed
- kubectl installed
- Minikube or Docker Desktop K8s enabled

## Part 1: Setup Minikube

```bash
# Start Minikube cluster
minikube start --driver=docker

# Check status
minikube status

# Verify kubectl
kubectl get nodes
```

---

## Part 2: Deploy Your First Application

### Create App Directory

```bash
mkdir ~/k8s-lab
cd ~/k8s-lab
```

### Create Deployment

```bash
cat > deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web-app
        image: nginx:alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 3
          periodSeconds: 10
EOF

kubectl apply -f deployment.yaml
kubectl get deployments
kubectl get pods
```

### Create Service

```bash
cat > service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: web-app-service
spec:
  type: NodePort
  selector:
    app: web-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30080
EOF

kubectl apply -f service.yaml
kubectl get services
```

### Access the App

```bash
minikube service web-app-service --url
# Open the URL in browser
```

---

## Part 3: Scale and Update

### Scale Up

```bash
kubectl scale deployment web-app --replicas=5
kubectl get pods -w
# Watch pods being created (Ctrl+C to exit)
```

### Update Image

```bash
# Update nginx version
kubectl set image deployment/web-app web-app=nginx:1.21

# Check rollout
kubectl rollout status deployment/web-app

# View history
kubectl rollout history deployment/web-app
```

### Rollback

```bash
kubectl rollout undo deployment/web-app
kubectl rollout history deployment/web-app
```

---

## Part 4: Use ConfigMaps and Secrets

### Create ConfigMap

```bash
cat > configmap.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: web-config
data:
  APP_ENV: "production"
  LOG_LEVEL: "info"
EOF

kubectl apply -f configmap.yaml
kubectl get configmap
kubectl describe configmap web-config
```

### Create Secret

```bash
cat > secret.yaml << 'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: web-secret
type: Opaque
data:
  # Base64 encoded: echo -n "mypassword" | base64
  DB_PASSWORD: bXlwYXNzd29yZA==
EOF

kubectl apply -f secret.yaml
kubectl get secret
kubectl describe secret web-secret
```

### Update Deployment to Use Them

```bash
cat > deployment-with-config.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web-app
        image: nginx:alpine
        ports:
        - containerPort: 80
        env:
        - name: APP_ENV
          valueFrom:
            configMapKeyRef:
              name: web-config
              key: APP_ENV
        - name: LOG_LEVEL
          valueFrom:
            configMapKeyRef:
              name: web-config
              key: LOG_LEVEL
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: web-secret
              key: DB_PASSWORD
EOF

kubectl apply -f deployment-with-config.yaml
```

---

## Part 5: Create a Complete Application Stack

### Deploy with Ingress

```bash
cat > full-stack.yaml << 'EOF'
---
apiVersion: v1
kind: Namespace
metadata:
  name: webapp
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: webapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web-app
        image: nginx:alpine
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web-app-service
  namespace: webapp
spec:
  type: ClusterIP
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-app-ingress
  namespace: webapp
spec:
  rules:
  - host: webapp.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-app-service
            port:
              number: 80
EOF

kubectl apply -f full-stack.yaml
kubectl get all -n webapp
```

---

## Part 6: Debug and Troubleshoot

```bash
# Check pod logs
kubectl logs -n webapp -l app=web-app

# Describe deployment
kubectl describe deployment -n webapp web-app

# Get detailed pod info
kubectl get pod -n webapp -o wide
kubectl describe pod -n webapp -l app=web-app

# Exec into pod
kubectl exec -it -n webapp $(kubectl get pod -n webapp -l app=web-app -o jsonpath='{.items[0].metadata.name}') -- /bin/sh

# Check events
kubectl get events -n webapp --sort-by='.lastTimestamp'

# Port forward for debugging
kubectl port-forward -n webapp svc/web-app-service 8080:80
```

---

## Part 7: Clean Up

```bash
# Delete all resources
kubectl delete -f full-stack.yaml
kubectl delete -f configmap.yaml
kubectl delete -f secret.yaml

# Or delete namespace
kubectl delete namespace webapp

# Stop Minikube
minikube stop

# Delete cluster (optional)
minikube delete
```

---

## Part 8: Challenge (Optional)

Deploy the Node.js application from Lab 3 to Kubernetes:

1. Build and push image to Docker Hub
2. Create Deployment using your image
3. Add health checks
4. Set up HPA (Horizontal Pod Autoscaler)
5. Configure Ingress

---

## What You Learned

- ✅ Creating Kubernetes deployments
- ✅ Exposing applications with Services
- ✅ Using ConfigMaps and Secrets
- ✅ Scaling applications
- ✅ Rolling updates and rollbacks
- ✅ Debugging in Kubernetes

---

**Lab Complete! 🎉**

## Course Complete!

You've finished all 6 modules. Continue practicing and exploring:

- [ ] Explore more AWS services
- [ ] Try Terraform for infrastructure
- [ ] Learn monitoring with Prometheus/Grafana
- [ ] Practice with real cloud projects