# Deployments & Services

## Deployment YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
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
        readinessProbe:
          httpGet:
            path: /ready
            port: 80
          initialDelaySeconds: 2
          periodSeconds: 5
```

## Service Types

| Type | Description |
|------|-------------|
| ClusterIP | Internal cluster IP |
| NodePort | Expose on node port |
| LoadBalancer | External load balancer |
| ExternalName | DNS CNAME |

## Service Examples

### ClusterIP
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app
spec:
  type: ClusterIP
  selector:
    app: my-app
  ports:
  - port: 80
    targetPort: 80
```

### NodePort
```yaml
spec:
  type: NodePort
  selector:
    app: my-app
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
```

### LoadBalancer
```yaml
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
  - port: 80
    targetPort: 80
```

## Scaling

```bash
kubectl scale deployment my-app --replicas=5
kubectl autoscale deployment my-app --min=2 --max=10 --cpu-percent=80
```

## Update & Rollback

```bash
kubectl set image deployment/my-app my-app=nginx:1.21
kubectl rollout status deployment/my-app
kubectl rollout undo deployment/my-app
kubectl rollout history deployment/my-app
```

---

**Next: [Lab Exercises](./labs/lab-06-kubernetes.md)**