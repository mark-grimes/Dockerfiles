#dotnet-zip-s3cmd

Docker image based on microsoft/dotnet but with added zip and s3cmd commands. I use it for creating AWS Lambda functions in C# and uploading them to S3 ready for CloudFormation to use.

I've found the official AWS CLI tools add about 150 Mb to the image, so I'm going with s3cmd since all I want to do is upload to S3. The s3cmd is **not** taken from apt-get because that's too old (it can't handle S3 buckets with dots in the name). It's downloaded and extracted directly from github releases.

Uploading to S3 will require the environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to be set, this is not done for you. See [this stackoverflow post](http://stackoverflow.com/questions/11603583/necessary-s3cmd-s3-permissions-for-put-sync) for the required IAM permissions you need to have.
