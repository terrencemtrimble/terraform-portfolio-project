# terraform-portfolio-project

Terraform Portfolio Project

A Next.js portfolio site, configured for static export and deployed to AWS using S3 and CloudFront, provisioned entirely with Terraform.

Live site: https://dbgig4q4p0ljl.cloudfront.net

Overview

This project takes a Next.js application from local development to a fully static, globally distributed deployment on AWS — no server to manage, no containers to run. All infrastructure is defined as code with Terraform, from the S3 bucket storing the site files to the CloudFront distribution serving them at the edge.

Built as part of a client deployment scenario: a freelance web designer needed a modern, responsive portfolio hosted on infrastructure that's scalable, cost-effective, and fast worldwide.

Tech Stack


Next.js — React framework, configured for static export (output: 'export')
AWS S3 — stores the static build output
AWS CloudFront — global CDN for fast, cached delivery to any region
Terraform — infrastructure as code for provisioning S3, CloudFront, and IAM permissions
AWS DynamoDB — Terraform state locking, to support safe concurrent state management


Architecture

User Request
     │
     ▼
CloudFront Distribution (global edge caching)
     │
     ▼
S3 Bucket (static site files: index.html, _next/static assets)

Terraform state is tracked remotely, with DynamoDB providing state locking to prevent conflicting concurrent changes.

Project Structure

This repo keeps Terraform configuration and the Next.js app in the same root directory:

nextjs-blog/
├── main.tf                # AWS provider, S3 bucket, CloudFront distribution
├── state.tf                # Remote state backend configuration
├── next.config.js          # Static export configuration
├── pages/                  # Next.js application source
├── public/                 # Static assets
├── package.json
└── .gitignore               # Excludes Terraform state, .terraform/, node_modules, build output

Getting Started

Clone the repo and install dependencies:

bashgit clone https://github.com/terrencemtrimble/terraform-portfolio-project.git
cd nextjs-blog
npm install
npm run dev

Visit http://localhost:3000 to view the app locally.

Deploying the Infrastructure

bashterraform init
terraform plan
terraform apply

Build and export the Next.js app, then sync the output to the S3 bucket:

bashnpm run build
aws s3 sync ./out s3://nextjs-portfolio-bucket-tt-2026

Progress


 Set up Next.js app from the Next.js Learn starter template
 Configured static export via next.config.js
 Wrote Terraform configuration for S3 bucket and CloudFront distribution
 Set up remote state with S3 + DynamoDB locking
 Resolved IAM permissions for CloudFront resource creation
 Deployed live and verified end-to-end via CloudFront URL
 Replace starter template content with actual portfolio content
 Automate build + deploy via CI/CD (GitHub Actions)


What This Project Demonstrates


Static site architecture using S3 + CloudFront, distinct from a traditional server-hosted deployment
Infrastructure as Code practices with Terraform, including remote state management
Real-world troubleshooting: resolving IAM permission gaps, S3 bucket naming collisions, Block Public Access conflicts, and CloudFront default root object configuration
End-to-end ownership of a deployment, from local development to live, globally distributed hosting


Why This Project

Built as part of the Cloud Engineer Academy curriculum to practice infrastructure as code, static site deployment patterns, and cloud architecture decision-making — skills directly applicable to cloud engineering and DevOps roles.