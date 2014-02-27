# Puppet Stages
stage {
    'users':       before => Stage['folders'];
    'folders':     before => Stage['updates'];
    'updates':     before => Stage['packages'];
    'packages':    before => Stage['configure'];
    'configure':   before => Stage['services'];
    'services':    before => Stage['main'];
}

class users {
    group { "www-data":
        ensure => "present",
     }
}

class folders {
    file { ['/var/www']:
        ensure => 'directory',
        owner => 'www-data',
        group => 'www-data',
        mode => 0755
    }
}

class updates {
    exec { "aptitude-update":
        command => "/usr/bin/aptitude update -y -q",
        timeout => 0
    }
}

class packages {
    package {[
            "git",
            "apache2",
            "mysql-client",
            "php5",
            "php5-mysql",
            "php5-gd",
            "php5-curl",
            "php5-mcrypt",
            "php5-cli"
            ]:
        ensure => "present",
    }
}

class configure {
    exec {
        "clear-apache-conf":
            command => '/usr/bin/sudo rm /etc/apache2/sites-enabled/000-default',
            onlyif => '/bin/ls /etc/apache2/sites-enabled/000-default';

        "link-apache-conf":
            command => '/usr/bin/sudo ln -s /var/www/manifests/vagrant.conf /etc/apache2/sites-enabled/vagrant.conf',
            unless => '/bin/ls /etc/apache2/sites-enabled/vagrant.conf';

        "clear-webroot":
            command => '/bin/rm /var/www/index.html',
            onlyif => '/bin/ls /var/www/index.html';

        "apache-rewrite":
            command => '/usr/bin/sudo a2enmod rewrite';
    }
}

class services {
    exec {
        "apache-restart":
            command => '/usr/bin/sudo service apache2 restart';
    }
}

class {
    users:       stage => "users";
    folders:     stage => "folders";
    updates:     stage => "updates";
    packages:    stage => "packages";
    configure:   stage => "configure";
    services:    stage => "services";
}
