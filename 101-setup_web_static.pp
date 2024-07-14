# Puppet manifest to set up web server for deployment of web_static

# Ensure nginx is installed and running
package { 'nginx':
  ensure => installed,
}

service { 'nginx':
  ensure     => running,
  enable     => true,
  subscribe  => Package['nginx'],
}

# Ensure directories are created
file { '/data/web_static/shared/':
  ensure => directory,
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0755',
  recurse => true,
}

file { '/data/web_static/releases/test/':
  ensure => directory,
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0755',
  recurse => true,
}

# Create the test HTML file
file { '/data/web_static/releases/test/index.html':
  ensure  => file,
  content => '<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  mode    => '0644',
}

# Create a symlink
file { '/data/web_static/current':
  ensure => link,
  target => '/data/web_static/releases/test',
  owner  => 'ubuntu',
  group  => 'ubuntu',
}

# Ensure ownership of the /data directory
file { '/data/':
  ensure => directory,
  owner  => 'ubuntu',
  group  => 'ubuntu',
  recurse => true,
}

# Update Nginx configuration to serve content
file_line { 'nginx_hbnb_static':
  path  => '/etc/nginx/sites-available/default',
  line  => 'location /hbnb_static/ { alias /data/web_static/current/; }',
  match => '^\s*location /hbnb_static/',
  notify => Service['nginx'],
}

# Restart Nginx to apply changes
service { 'nginx':
  ensure    => running,
  subscribe => File_line['nginx_hbnb_static'],
}
