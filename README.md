Step 5: Initialize Terraform
Run the following command to initialize Terraform. This will download the necessary provider plugins:

sh
Copy code
terraform init
Step 6: Apply the Terraform Configuration
Run the following command to create the AWS resources defined in your configuration:

sh
Copy code
terraform apply
You will be prompted to confirm the action. Type yes to proceed.

Step 7: Verify the MongoDB Replica Set
After the instances are created, you can SSH into the primary instance (the first one) and verify that the replica set is properly configured:

sh
Copy code
ssh -i path/to/your-key-pair.pem ec2-user@<primary-instance-public-ip>
mongo --eval 'rs.status()'
