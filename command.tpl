#!/bin/bash

yum update
yum -y install httpd

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF> /var/www/html/index.html
<html>
<h2>my web page, ip: ${myip} <h2><br>
i am ${f_name} ${l_name} <br>

%{ for x in names ~ }
hello to ${x} from ${f_name} <br>
%{ endfor ~}
</html>
EOF

service httpd start
chkconfig httpd on
