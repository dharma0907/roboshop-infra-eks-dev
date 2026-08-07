AWS Load Balancer Controller — Setup on EKS
Prerequisite: EKS cluster roboshop is running and kubectl / eksctl are pointed at it (region us-east-1). This is the shared foundation — it's identical whether you expose apps with Ingress or Gateway API.

https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/ --REFER THIS DOCUMENTATION FOR SETUP

1. Associate the OIDC provider
Lets the controller's ServiceAccount assume an IAM role (IRSA).

eksctl utils associate-iam-oidc-provider \
  --region us-east-1 \
  --cluster roboshop-dev \
  --approve
Verify: aws eks describe-cluster --name roboshop --query "cluster.identity.oidc.issuer" --output text

2. Download the IAM policy
The permissions the controller needs to manage ELB resources. Pin the version to the controller you'll install.

curl -o iam-policy.json \
  https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v3.4.2/docs/install/iam_policy.json

3. Create the IAM policy
aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam-policy.json
Verify: note the returned Arn — it feeds step 4.

4. Create the ServiceAccount (IRSA)
Binds the aws-load-balancer-controller SA to the IAM policy above.

eksctl create iamserviceaccount \
  --cluster=roboshop-dev \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::565139240657:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --region us-east-1 \
  --approve
Verify: kubectl -n kube-system get sa aws-load-balancer-controller -o yaml | grep eks.amazonaws.com/role-arn

5. Install the AWS Load Balancer Controller (Helm)
helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=roboshop-dev \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
Verify: kubectl -n kube-system get deploy aws-load-balancer-controller → 2/2 Ready.