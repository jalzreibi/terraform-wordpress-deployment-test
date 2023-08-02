import {
  to = aws_subnet.db-euw-1b
  id = "subnet-0f665a55865a834c4"
}
import {
  to = aws_subnet.webserver-euw-1b
  id = "subnet-00671329efb6f664c"
}
import {
  to = aws_vpc.Webapp-VPC
  id = "vpc-0c0a804de6d335b7a"
}
import {
  to = aws_security_group.db_sg
  id = "sg-0767bf9195b6ac0e0"
}
import {
  to = aws_security_group.webserver_sg
  id = "sg-09bab196cfa4a08a9"
}
