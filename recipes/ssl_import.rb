directory '/tmp/propel' do
  mode '0755'
  action :create
end

search(:node, 'name:*') do |n|
    if n["ssl_cert"]
        host_name = n["fqdn"]
        f = File.open("/tmp/propel/#{host_name}.crt", 'w')
        f.puts n["ssl_cert"]
        f.close
    end
end

bash "import-ssl" do 
 cwd   '/tmp/propel'
 code <<-EOH
  for file in ./*
    file_name=${file%.crt}
    do
      if ! keytool -list -keystore /opt/hp/propel/security/propel.truststore -storepass "propel2014" | grep -q $file_name
      then
        keytool -importcert -file $file -keystore /opt/hp/propel/security/propel.truststore -alias "$file_name" -storepass "propel2014" -noprompt
      fi
    done
  EOH
end

