resource "aws_iam_role" "application" {
  name = "app-runner-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : [
            "build.apprunner.amazonaws.com",
            "tasks.apprunner.amazonaws.com"
          ]
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "application" {
  role       = aws_iam_role.application.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}


resource "aws_apprunner_vpc_connector" "application" {
  vpc_connector_name = "application"
  subnets            = [aws_subnet.vpc_connector_1.id, aws_subnet.vpc_connector_2.id]
  security_groups    = [aws_security_group.vpc_connector.id]
}

resource "aws_apprunner_service" "application" {
  service_name = "application"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.application.arn
    }
    image_repository {
      image_configuration {
        runtime_environment_variables = {
          PORT         = "8080",
          DATABASE_DSN = "${local.database_username}:${local.database_password}@tcp(${aws_db_instance.database.endpoint})/${local.database_name}"
        }
      }
      image_identifier      = "${aws_ecr_repository.application.repository_url}:latest"
      image_repository_type = "ECR"
    }
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.application.arn
    }
  }
}

output "application_url" {
  value = aws_apprunner_service.application.service_url
}
