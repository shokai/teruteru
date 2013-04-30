teruteru
========


Install Dependencies
--------------------

    % gem install bundler
    % bundle install


Run
---

    % ruby teruteru.rb --help
    % ruby teruteru.rb -city 東京 -interval 600 -rain 30


Install
-------

    % sudo foreman export upstart /etc/init --app teruteru -d `pwd` -u `whoami`
