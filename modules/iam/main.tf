resource "aws_iam_role" "default" {
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_instance_profile" "default" {
  name = "${var.label}-iam-instance-profile"
  role = aws_iam_role.default.name
}

resource "aws_iam_policy" "default" {
  name        = "${var.label}-iam-policy"
  description = "A default policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "events:*",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "default" {
  name       = "${var.label}-iam-policy-attachment"
  roles      = [aws_iam_role.default.name]
  policy_arn = aws_iam_policy.default.arn
}
