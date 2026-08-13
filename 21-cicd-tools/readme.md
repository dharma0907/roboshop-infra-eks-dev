

### Jenkins master
* Access: `http://jenkins.<your-domain>:8080`
* Initial admin password:
  ```
  sudo cat /var/lib/jenkins/secrets/initialAdminPassword
  ```
* Create the admin user, then install plugins (Manage Jenkins → Plugins):
  * Pipeline Stage View
  * Pipeline Utility Steps
  * AWS Credentials
  * AWS Steps
  * SonarQube Scanner

### Jenkins agent node
* Manage Jenkins → Nodes → New Node → Permanent Agent
  * Remote root directory: `/home/ec2-user/jenkins-agent`
  * Launch method: **Launch agents via SSH**
  * Host: `jenkins-agent.<your-domain>` (private DNS — master and agent sit in
    the same VPC)
  * Credentials: `ssh-creds` (below)
  * Host key verification: Non-verifying (lab setup only)

### SonarQube server
* SSH in:
  ```
  ssh -i <private-key> ubuntu@sonar.ip
  ```
* Default credentials:
  ```
  /opt/default-sonar-login.txt
  ```
* Generate a token for Jenkins: **My Account → Security → Generate Token**
* Configure the webhook so SonarQube reports the quality-gate result back to
  the pipeline: **Administration → Configuration → Webhooks → Create**
  * Name: `Jenkins`
  * URL: `http://jenkins.<your-domain>:8080/sonarqube-webhook/`
* In Jenkins: **Manage Jenkins → Tools** — add the SonarQube Scanner
  installation. **Manage Jenkins → System** — add the SonarQube server (URL +
  the token as a secret-text credential).

### Credentials (Manage Jenkins → Credentials)
| id | type | used for |
|---|---|---|
| `ssh-creds` | Username with password | SSH into the Jenkins agent — user `ec2-user`, password `DevOps321` (the course AMI's default login) |
| `aws-creds` | AWS Credentials | pipeline steps that call AWS (ECR push, EKS deploy, etc.) — access key / secret key |
| sonar-creds | Secret text | SonarQube Scanner authentication, generated above |

## Quick reference
| what | where |
|---|---|
| Jenkins UI | `http://jenkins.<your-domain>:8080` |
| SonarQube UI | `http://sonar.<your-domain>:9000` |
| Jenkins agent | `jenkins-agent.<your-domain>` (private, SSH only) |
| Jenkins admin password | `sudo cat /var/lib/jenkins/secrets/initialAdminPassword` |
| SonarQube default login | `/opt/default-sonar-login.txt` on the sonar box |