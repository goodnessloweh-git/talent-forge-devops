# Talent Forge DevOps Project

A complete beginner-to-intermediate DevOps project that demonstrates how to build, containerize, automate, deploy, and monitor a web application using modern DevOps tools.



## Live Demo

https://talent-forge-app.onrender.com


## Project Overview

This project walks through a real-world DevOps workflow:

* Build a simple HTML app
* Containerize it using Docker
* Automate builds with CI/CD
* Deploy to the cloud
* Monitor uptime and reliability


## ⚙️ Tech Stack

* Git & GitHub — Version control
* Docker — Containerization
* GitHub Actions — CI/CD pipeline
* Render — Cloud hosting
* UptimeRobot — Monitoring & alerts


##  How It Works

```text
Code → GitHub → CI/CD → Docker Hub → Render → Live App → Monitoring
```


## 🛠️ Project Structure


talent-forge-devops/
│
├── index.html
├── Dockerfile
└── .github/
    └── workflows/
        └── deploy.yml


##  Docker Setup

Build the image locally:

```bash
docker build -t myapp .


Run the container:

```bash
docker run -p 8080:80 myapp


Then visit:


https://talent-forge-app.onrender.com



## 🔁 CI/CD Pipeline

Every push to `main` automatically:

* Builds a new Docker image
* Pushes it to Docker Hub
* Makes it ready for deployment

Powered by GitHub Actions.


## ☁️ Deployment

The app is deployed on Render using:

```
goodness21/myapp:latest
```

Any new image can be redeployed to update the live app.


Monitoring

Using UptimeRobot:

* Checks app every 5 minutes
* Tracks uptime %
* Sends alerts if the app goes down



 What I Learned

* How CI/CD pipelines actually work
* How Docker images are built and deployed
* How to connect multiple DevOps tools together
* How to monitor and respond to failures


 Future Improvements

* Add custom domain
* Add HTTPS/SSL configuration
* Add logging (Grafana / Prometheus)
* Move to Kubernetes


 ☸️ Kubernetes Deployment (Local)

In addition to the Render deployment above, this project also demonstrates deploying the containerized app to Kubernetes locally, as part of the "Deploy Your Containerized App to Kubernetes" project track.

Cluster: minikube (Docker driver)

What's included in `k8s/`:
k8s/
├── deployment.yaml # 2 replicas, resource limits, liveness/readiness probes
├── service.yaml # ClusterIP service exposing port 80
├── ingress.yaml # nginx Ingress routing talent-forge.local → service
├── configmap.yaml # ENVIRONMENT, APP_VERSION
└── secret.yaml # API_KEY (demo value)


**Milestones completed:**

✅ M1 — Deployment + Service running on minikube, verified via port-forward
✅ M2— nginx Ingress configured, app reachable via `talent-forge.local`
✅ M3 — Config and secrets externalized via ConfigMap/Secret, verified a config change propagates on rollout restart
 ✅ M4 — Production hygiene: `replicas: 2`, resource requests/limits, liveness/readiness probes. Verified self-healing (pod deletion auto-replaced) and zero-downtime rolling updates (continuous curl loop stayed at `200` throughout a rollout)
 ✅ M5 — CI/CD pipeline extended with a `deploy` job (`.github/workflows/deploy.yml`) that runs `kubectl set image` + `kubectl rollout status` on a self-hosted runner, so pushes to `main` can deploy straight to the cluster

**Running it locally:**
```bash
minikube start --profile talent-forge
docker build -t talent-forge:v1 .
minikube image load talent-forge:v1 --profile talent-forge

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml

kubectl port-forward svc/talent-forge 8081:80
```
Then visit `http://localhost:8081`.

PROBLEMS FACED AND FIX

1. Ingress controller stuck "creating" for 10+ minutes
The nginx ingress controller pod sat in ContainerCreating and never finished. Turned out its image had frozen mid-download.
Fix: Ran docker pull on your Mac to download the image directly, then minikube image load to hand it straight to minikube instead of letting minikube fetch it itself.

2. Browser said "This site can't be reached" (ERR_CONNECTION_REFUSED)
Even though DNS resolved talent-forge.local correctly, nothing answered on port 80.
Fix: Discovered minikube tunnel had stopped running (it only works while actively open). Switched to kubectl port-forward against the ingress-nginx controller service instead — more reliable for testing.

3. Git said "nothing to commit" despite new files sitting right there
git add k8s/ failed, and git status looked broken.
Fix: Found an accidental nested .git folder inside k8s/ from an earlier stray git init. Deleted it (rm -rf .git inside that folder), which let the real project repo track the files normally.

4. GitHub rejected password authentication
git push failed: "Password authentication is not supported for Git operations."
Fix: Generated a Personal Access Token on GitHub and used it in place of the password.

5. GitHub rejected the push specifically on the workflow file
Everything else pushed fine, but .github/workflows/deploy.yml was blocked: token missing workflow scope.
Fix: Generated a new token with both repo and workflow scopes checked.

6. Self-hosted runner download kept failing (~125MB file)
Multiple attempts died mid-download with "Operation timed out" and "Could not resolve host."
Fix: Identified it as a home internet issue, not a setup mistake. Left the CI/CD deploy job fully written and committed, with runner registration deferred until a more stable connection.



Author

Built by Goodness — learning DevOps by doing real projects 
