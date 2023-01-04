go mod init gopath/src/github.com/hashicorp/terraform-plugin-sdk

go get github.com/hashicorp/terraform-plugin-sdk/helper/schema

go get github.com/hashicorp/terraform-plugin-sdk/plugin

go get github.com/hashicorp/terraform-plugin-sdk/terraform

go build -o terraform-provider-example

mkdir -p ~/.terraform.d/plugins/example.com/qwiklabs/example/1.0.2/linux_amd64

cp terraform-provider-example ~/.terraform.d/plugins/example.com/qwiklabs/example/1.0.2/linux_amd64
