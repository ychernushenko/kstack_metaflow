# Push batch docker image
    - docker build -t kstack_metaflow -f Dockerfile_batch .  
    - docker tag kstack_metaflow:latest 742491319596.dkr.ecr.eu-central-1.amazonaws.com/kstack_metaflow:latest  
    - aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 742491319596.dkr.ecr.eu-central-1.amazonaws.com  
    - docker push 742491319596.dkr.ecr.eu-central-1.amazonaws.com/kstack_metaflow:latest  


ENV METAFLOW_BATCH_CONTAINER_IMAGE="742491319596.dkr.ecr.eu-central-1.amazonaws.com/kstack_metaflow:latest"  

# Run flow
python ./src/flow.py run --with batch