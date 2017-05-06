# dotnet-aws-dynamodb

Docker image based on microsoft/dotnet but with added zip and aws commands. I use it for creating AWS Lambda functions in C# and uploading them to S3 ready for CloudFormation to use. It also includes a local instance of DynamoDB for testing the Lambda functions against.

Uploading to S3 will require the environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to be set, this is not done for you. The AWS account you use will (obviously) need to have permission to write to the S3 bucket.

Unfortunately this is a pretty large image, I'm not sure there's much that can be done about that. The base image (microsoft/dotnet) starts out large and then DynamoDB need a Java runtime, which adds about 230 Mb.
