<p align="center">
    <img src="https://raw.githubusercontent.com/homematehq/homemate/master/logo.png" alt="HomeMate" height="200px" width="200px">
</p>
<p align="center">
    <a href="https://codeclimate.com/github/homematehq/homemate/maintainability">
        <img src="https://img.shields.io/codeclimate/maintainability/homematehq/homemate.svg?style=flat-square" />
    </a>&nbsp;
    <img src="https://img.shields.io/github/license/homematehq/homemate.svg?style=flat-square" />
</p> 

# HomeMate

HomeMate is a tenancy management system designed to reduce the burden of the landlord. It is built with the [Ruby on 
Rails](http://rubyonrails.org/) framework.

## Getting started

HomeMate requires Ruby version 2.4.2 and a compatible database server such as [PostgreSQL](https://www.postgresql.org/),
 [SQLite](https://www.sqlite.org/) or [MySQL](https://www.mysql.com/).

Edit the configuration files at `config/settings.yml` and `config/database.yml`. You will need your database credentials
 to hand. 

Generate application secret:

    bundle exec rake secret

Install dependencies and load database schema:

    bundle install
    bundle exec rake db:setup
    bundle exec rake db:migrate
    
Import start-up data entries, which also set up the first user so you will be able to login:

    bundle exec rake db:seed
    
Run the development local web server:

    bundle exec rails server
    
The system is now available at [http://localhost:3000](http://localhost:3000)! You can login with the username `admin`
 and the password `homemate`.

## License

Copyright &copy; Andrew Ying 2017.

HomeMate is a free software: you can redistribute it and/or modify it under the terms of the [GNU General Public 
License](LICENSE.md) as published by the Free Software Foundation. This program is distributed in the hope that it will 
be useful, but **WITHOUT ANY WARRANTY**; without even the implied warranty of **MERCHANTABILITY** or **FITNESS FOR A
 PARTICULAR PURPOSE**.