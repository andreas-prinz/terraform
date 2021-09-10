# export AWS_DEFAULT_REGION=
# export AWS_ACCESS_KEY_ID=
# export AWS_SECRET_ACCESS_KEY=

provider "aws" {
#    access_key = ""
#    secret_key = ""
#    region = ""
}

resource "aws_instance" "myWeb1" {
    count = 3
    ami = "ami-"
    instance_type = "t3.micro"
    vpc_security_group_ids = ["aws_security_group.myWeb1.id"] # dependency
#    vpc_security_group_ids = ["sg-"]

    tag {
        name = "Web Server"
        owner = "Andr P"
        project = "Terra"
    }

    user_data = templetefile("command.tpl", {
        f_namr = "Andreas",
        l_name = "Prinz",
        names = ["Sasha", "Lena", "Kolya", "Gans", "Olga", "Peter"]
    })
#    = file("command.tpl")
}

resource "aws_instance" "myAmazon1" {
    ami = "ami-"
    instance_type = "t3.small"

    tag {
        name = "Amaz Server"
        owner = "Andr P"
        project = "Terra"
    }
}

resource "aws_security_group" "myWeb1" {
    name = "web sec group"
    description = "my sec for web1"

    dynamic "ingress" {
        for_each = ["80", "443"]
        ingress {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cdir_blocks = ["0.0.0.0/0"]
        }
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cdir_blocks = ["1.2.3.4/32"]
    }

    engress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cdir_blocks = ["0.0.0.0/0"]
    }

    tag {
        name = "Sec Group"
        owner = "Andr P"
        project = "Terra"
    }
}
