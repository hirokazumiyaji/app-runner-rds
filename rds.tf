resource "aws_db_subnet_group" "database" {
  name       = "database"
  subnet_ids = [aws_subnet.database_1.id, aws_subnet.database_2.id]
}

resource "aws_db_instance" "database" {
  identifier             = "database"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = local.database_instance_type
  db_name                = local.database_name
  username               = local.database_username
  password               = local.database_password
  vpc_security_group_ids = [aws_security_group.database.id]
  db_subnet_group_name   = aws_db_subnet_group.database.name
  skip_final_snapshot    = true
}
