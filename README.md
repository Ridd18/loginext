Task 1:  Architecture design

1. The Architecture includes secure networking 
2. User access the web application, the traffic flow through a VPN client which is secure
3. The Architecture has 2 avaialblity zones, which have private and public subnets for the VPC
4. All the applications are deployed on a Nodegroup in private subnets
5. SQL & NoSQL DBs are deployed in private subnets too
6. There's a Jump Server to access the kubernetes commands for the infra
7. There will be a NAT Instance or NAT Gatewat depending on the ENV (i.e. UAT or PROD)
8. Argocd will be used for CD of applications
9. Grafana will be used for monitoring purposes
10. Redis can be used for Memory Caching Datastore 
11. Loadbalancer is there inbetween, so the connectivity will flow through LB


Task 2: Automation of EC2 instance creation for initial set-up

1. The Infra is created with terraform
2. The components have their seperate modules and those call the templates which are taken from terraform repos
3. Created VPC with 2 public subnets and 1 private subent
4. Security groups created which will be required by EC2 instances
5. EC2 instance created in private subnet and bootstrapped it with apache
6. I have launched an NAT instance to get the outbound internet access to private instances without exposing them to the internet.
7. Launched a LB in public subnet, which will hit the ec2 instance
8. The process was successfully completed and tested
9. Attaching screenshots for reference



Task 3: Recommendation for cost-saving and scaling

1. Give your recommendation on the idle period of the CPU for auto-stopping the servers

- We can add define a specific % of CPU util for a specific period.
- If the CPU is idle for that period, we can stop the instance 
- Scale down can also be done based on non impacting hours. 
- That is we can scale down, at night where there 0 to less usage 
- This will help us reduce cost 


2. Define the scale-in and scale-out metrics for auto-scaling the microservices 

- This can be scale out horizontally or vertically depending on the Load
- We can scale-in and scale-out bases of metrics such as CPU or MEM Util
- We can also scale out based on, if there's queue on our side for faster processing and then scale in after the queue is consumed
- We can scale out based on the response time too, if it's taking longer to process resquests and once it comes back to normal, we can scale in back

