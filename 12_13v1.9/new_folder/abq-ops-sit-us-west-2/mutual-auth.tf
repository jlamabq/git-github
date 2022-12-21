

########################### Mutual Auth - HAProxy Certs ###########################
# awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}'  client.pem
# awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}'  server.pem

resource "aws_ssm_parameter" "ma_client" {

  name        = "/${var.project}/ma/client"
  key_id      = "alias/aws/ssm"
  description = "The parameter description"
  type        = "SecureString"
  tier        = "Advanced"
  overwrite   = "true"
  value       = "-----BEGIN CERTIFICATE-----\nMIIDNDCCAhygAwIBAgIBATANBgkqhkiG9w0BAQsFADAUMRIwEAYDVQQDEwl0ZXN0\ncm9vdDEwHhcNMjEwNTA0MDAwNDE4WhcNMzEwNTAyMDAwNDE4WjAUMRIwEAYDVQQD\nEwl0ZXN0cm9vdDEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCntpkN\nPuspQILIC5xlNhSQu9vxE+AjeRtCm9/6sYuElam9skL89tG7GlH39BSTQ8FO8knX\nZ1v+QgtG7wSxqHA+0sQAuZPilJA85CshMW/esB7Qj2Uw5Gc//PZF6iQV4bHlhbwc\nrcQes3qQQcEZeO1+lBRY797XydnFmHqSb8RpEQCiqMYHzPonmV0HMeQ2HT7CjlzX\nk+dHyo/s0tAMUep3WS/hd8eiCOhcivdq+wyLuULHlVCqXhXtm9XGJlI7zyrnJa6H\n0OkPZR77odqgnB7A7TWhexHmHMPwXNOsSwnRKCGgJPxLsBARfHINz6jr1VA87WRZ\nagD+Zn3YYAdkLhnfAgMBAAGjgZAwgY0wEgYDVR0TAQH/BAgwBgEB/wIBCjAOBgNV\nHQ8BAf8EBAMCAYYwJwYDVR0fBCAwHjAcoBqgGIYWaHR0cDovL2V4YW1wbGUuY29t\nL2NybDAdBgNVHQ4EFgQUGuHgJUJIganERoO3jqgWeTSrUnAwHwYDVR0jBBgwFoAU\nGuHgJUJIganERoO3jqgWeTSrUnAwDQYJKoZIhvcNAQELBQADggEBAHWGY/Yr5qf4\nWRKbQxW3RWWJTQy25Hi58cEU6fUb2uHzWnO0xsJm5jRz2QTpQAlwC00A4lEokIjH\nIDdVd2x96TmRb34uHOFBTNbs3JVSx4yCVNoDEFEZq88YqhKLN6zPmVjrtIfI4gIf\n0EBz34MnForAUXCvCCrrjsViDsN7nGJrMgCcHoEYr1L14x+Q84lGsfV/W8NMwGoP\noyB6cBSm+VYX/5GawpEMqS/C55nns9lSpFuIwcTlbTUtXqczy2j0w4lozHcI2N5g\nUcGRe5UlhWSKaFhTU/311zySabf6Q5+w3wbaGjlPyvn+gHNKyQxxvBWJDicIf+si\n25KKaGSvt+Q=\n-----END CERTIFICATE-----\n-----BEGIN CERTIFICATE-----\nMIIDDzCCAfegAwIBAgIBZTANBgkqhkiG9w0BAQsFADAUMRIwEAYDVQQDEwl0ZXN0\ncm9vdDEwHhcNMjIwNTEwMTYyMzU3WhcNMjcwNTA5MTYyMzU3WjAaMRgwFgYDVQQD\nEw90ZXN0Y2xpZW50cm9vdDEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB\nAQCRfRU8g3/RY+CCwiOReoA9j4lZyBtvEYxUFQY8o503psL2/1sm+RxQkmXf/qE7\ngZ0aHbhTqEw+um2RZ32PWTfuC2ipVcXqD3tjg2LI+JdGDN7gidvzVwqbeJD2c/jG\nBy1cQtKb4VKG6o702wjQT5pSMfRmqj86BbXfpTYbn59wx8wWxB/cogBoKRTcPeB1\n2xwq/1qiD4E5xm0eco+VxJsDsmzeEdAWBXDSribL0v9VTZEOKEKqdiVN5m1v2uv2\noK7AIIbsmXDgobZ6L3qBY7RLRQkun3ATVK+0W8ToWS7qxmfVe3mnVa8W+BlZWX2+\nIHbuw+9sEcWrRuw60DnTZK05AgMBAAGjZjBkMBIGA1UdEwEB/wQIMAYBAf8CAQEw\nDgYDVR0PAQH/BAQDAgGGMB0GA1UdDgQWBBR6aIeJcYBvifAqdUpuQZFN/FADvjAf\nBgNVHSMEGDAWgBQa4eAlQkiBqcRGg7eOqBZ5NKtScDANBgkqhkiG9w0BAQsFAAOC\nAQEAN65J0vCdN3EVTnRzEsaim6rLKwDZM0Nj09tfkkQ9YtS2AGsBV+QbfpdN5BBl\n7NJ35rvYpb5nPiIqewQXz3qD6MwfmgZwcXjIKYDK8/wb0oBqhmiySL+7BsRyl0jc\n/7Rm4KPUtsPDlc05RdOpJQ1XfpBdE9tBnyMRvtXdv4Bi8H7Eg2KxAzgkhozz5xXd\nTIYh+6NB9lRY4eujqsUyEqZSclKMf77lzZByGNknuFTtFx+EekzJpfkj4MeOruP/\nU2hhvO18fTb9kGKVvqfnWKFnay1r3S1AyEvLZKji3sAi9BGiycJ/NfvuBaXDw9MD\nhrVoZDIBDEVPUkE8HBytzyortg==\n-----END CERTIFICATE-----\n"

  tags = merge(local.module_tags_list,
      {
        "abq:name" = "${var.project}-${var.region}-ma_client",
      })
}

resource "aws_ssm_parameter" "ma_server" {

  name        = "/${var.project}/ma/server"
  key_id      = "alias/aws/ssm"
  description = "The parameter description"
  type        = "SecureString"
  tier        = "Advanced"
  overwrite   = "true"
  value       = "${file( var.self-certificate["chain"] )}\n${file( var.self-certificate["key"] )}"


  tags = merge(local.module_tags_list,
      {
        "abq:name" = "${var.project}-${var.region}-ma_server",
      })
}


#for aqcloud.io
resource "aws_ssm_parameter" "ma_server_aqcloud" {

  name        = "/${var.default-identifier}/ma/server/aqcloud"
  key_id      = "alias/aws/ssm"
  description = "The parameter description"
  type        = "SecureString"
  tier        = "Advanced"
  overwrite   = "true"
  value       = "${file( var.self-certificate-aqcloud["chain"] )}\n${file( var.self-certificate-aqcloud["key"] )}"


  tags = merge(local.module_tags_list,
      {
        "abq:name" = "${var.project}-${var.region}-ma_server_aqcloud",
        "abq:tier" = " ",
      })
}