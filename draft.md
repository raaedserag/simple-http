

cloud_user-at-079560432659
PSxOSTCAYe04gJLp0lDy8ZxUXvZHE6TlKNZfY1J9vXo=
git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/simple-http-repo

kubectl set image deployment/simplehttp-staging-deployment simplehttp-staging-api=httpd:2.4-alpine 
kubectl rollout status deployment/simplehttp-staging-deployment --timeout=10s