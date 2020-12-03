#!/usr/bin/env ruby

require 'sinatra'
require 'conjur-api'
require 'cgi'
require 'json'
require 'mysql2'

enable :logging
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

# ==============================================
# Database Username and Password order - 1) Read from Environment variable 2) Fetch from Conjur using Ruby API
# 1) DBUsername and DBPassword = Environment Variable
# 2) DBUserName_CONJUR_VAR and DBPassword_CONJUR_VAR - variable reference in Conjur
# ==============================================

helpers do

  def dbaddress
    ENV['DBAddress'] or raise "Error: no Database Address defined"
  end

  def dbport
    ENV['DBPort'] or "3306"
  end

  def dbname
    ENV['DBName'] or raise "Error: No Database Name defined"
  end

  # ---- Modify code to perform password lookup from Conjur using Conjur Ruby API
  def dbusername
    ENV['DBUsername'] or conjur_api.resource(ENV['CONJUR_ACCOUNT'] + ":variable:" + ENV['DBUsername_CONJUR_VAR']).value or raise "Error: no Username or Conjur variable for Username defined"
  end

  def dbpassword
    ENV['DBPassword'] or conjur_api.resource(ENV['CONJUR_ACCOUNT'] + ":variable:" + ENV['DBPassword_CONJUR_VAR']).value or raise "Error: no Password or Conjur variable for Password defined"
  end

  def conjur_api
    # Ideally this would be done only once.
    # But for testing, it means that if the login fails, the pod is stuck in a bad state
    # and the tests can't be performed.
    Conjur.configuration.apply_cert_config!
    token = JSON.parse(File.read("/run/conjur/access-token"))
    Conjur::API.new_from_token(token)
  end

end

get '/' do
  begin
    mysqlclient = Mysql2::Client.new(host: dbaddress,
                                 port: dbport,
                                 username: dbusername,
                                 password: dbpassword,
                                 database: dbname)
    randomcity = mysqlclient.query('SELECT city.Name as City,country.name as Country,city.District,city.Population FROM city,country WHERE city.CountryCode = country.Code ORDER BY RAND() LIMIT 1').to_a[0]
    mysqlclient.close

 "<!doctype html>
     <html lang=\"en\">
	<head>
		<title>Random World Cities</title>
		<link rel=\"stylesheet\" href=\"https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css\" integrity=\"sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk\" crossorigin=\"anonymous\">
	</head>
    	<body>
	 <div class=\"jumbotron\">
		<h1>#{randomcity['City']}</h1>
		<p class=\"lead\">A city in #{randomcity['District']}, #{randomcity['Country']} with a population of #{randomcity['Population']}</p>
	</div>
        <code>   Connected to database <b>#{dbname}</b> on <b>#{dbaddress}:#{dbport}</b> using username: <b>#{dbusername}</b> and password: <b>#{dbpassword}</b></code>
    </body></html>"

  rescue
    $stderr.puts $!
    $stderr.puts $!.backtrace.join("\n")
    halt 500, "Error: #{$!}"
  end
end
