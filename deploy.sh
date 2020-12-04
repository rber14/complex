# deployment script
docker build -t rcamposs/multi-client:latest -t rcamposs/multi-client:$SHA -f ./client/Dockerfile ./client # we tag two images one latest one with SHA to track
docker build -t rcamposs/multi-server:latest -t rcamposs/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t rcamposs/multi-worker:latest -t rcamposs/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push rcamposs/multi-client:latest
docker push rcamposs/multi-server:latest
docker push rcamposs/multi-worker:latest

docker push rcamposs/multi-client:$SHA
docker push rcamposs/multi-server:$SHA
docker push rcamposs/mulit-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=rcamposs/multi-server:$SHA
kubectl set image deployments/client-deployment client-rcamposs/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=rcamposs/multi-worker:$SHA
