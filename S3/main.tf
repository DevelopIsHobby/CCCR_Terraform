# IAM 인스턴스 프로필 생성
resource "aws_iam_instance_profile" "mini-iam-instance-profile" {
  name = "mini-iam-instance-profile"
  role = aws_iam_role.mini-iam-role.name
}

# S3 생성
resource "aws_s3_bucket" "mini-upload-bucket" {
  bucket = "mini-upload-bucket-ms"
}

# 역활 생성
resource "aws_iam_role" "mini-iam-role" {
  name = "mini-iam-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },       
      "Action": "sts:AssumeRole"
      }
    ]
  }
EOF
}

# 정책 생성 
resource "aws_iam_policy" "mini-s3-full-access-policy"{
  name = "mini-s3-full-access-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "${aws_s3_bucket.mini-upload-bucket.arn}",
        "${aws_s3_bucket.mini-upload-bucket.arn}/*"
      ]
    }
  ]
}
EOF
}

# 역활과 정책 묶어주기(보통 권한=정책, 권한+인스턴스(사용자)=역활)
resource "aws_iam_role_policy_attachment" "mini-iam-role-policy-attachment" {
  role = aws_iam_role.mini-iam-role.name
  policy_arn = aws_iam_policy.mini-s3-full-access-policy.arn
}


