
#Import ssl cert for rabbitmq
cookbook_file '/tmp/ssl_crt.tar.gz' do
  source 'ssl_crt.tar.gz'
  mode '0755'
  notifies :run, "bash[import-ssl]"
end

  bash "import-ssl" do 
   cwd   '/tmp'
   action :nothing
   code <<-EOH
          dir_name="/tmp/ssl_crt/"
          all=`ls  ${dir_name}`
          for i in $all
            do
            nodename=${i%_pro*}
            if ! keytool -list -keystore /opt/hp/propel/security/propel.truststore -storepass "propel2015" | grep -q $nodename}
                      then
                        keytool -importcert -file /tmp/ssl_crt/"$nodename"_propel_host.crt -keystore /opt/hp/propel/security/propel.truststore -alias "$nodename" -storepass "propel2016" -noprompt
            fi
            done
      EOH
  end
