#!/bin/bash
set -x

#!/bin/bash

# Update all packages

sudo yum update -y
sudo yum install -y ecs-init
sudo service docker start
sudo start ecs

#Adding cluster name in ecs config
echo ECS_CLUSTER=${ecs_cluster} >> /etc/ecs/ecs.config
cat /etc/ecs/ecs.config | grep "ECS_CLUSTER"

# Additional user data
${additional_user_data_script}
