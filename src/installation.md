---
---

# Installation

Installation steps:

1. [Install the requirements](#requirements)
2. [Download and Install LL](#download-and-install)
3. [Setup Mongo](#setup-mongodb)
4. [Register your first user](#register-your-first-user)

Additional information:

- [Configuration](#configuration)
- [Installation on AWS](http://cloudboffins.com/advanced-projects/learning-locker-lrs-free-server-part-1/) thanks to [Cloud Boffins](http://cloudboffins.com)
- [Installation on Ubuntu](http://www.jpablo128.com/how_to_install_learning_locker/) thanks to [@jpablo128](https://twitter.com/jpablo128)
- [Installation on CentOS 7.0](https://gist.github.com/davidpesce/7d6e1b81594ecbc72311) thanks to [@davidpesce](https://github.com/davidpesce)
- [Installation on Ubuntu with Vagrant](http://www.jmblog.org/blog/2015/02/03/learning-locker-vagrant) thanks to [Jim Baker](http://www.jmblog.org)

## Requirements
Learning Locker requires the components listed below. Learning Locker is built upon the excellent [Laravel](http://laravel.com) PHP framework, so in addition to the components below, please see the [Laravel requirements](http://laravel.com/docs/4.2#server-requirements).

* [PHP 5.5](http://php.net)
* [Composer](http://getcomposer.org)
* [MongoDB](http://mongodb.org)
* [MongoDB php extension](http://www.php.net/manual/en/mongo.installation.php)
* [Node and NPM](http://nodejs.org)
* [Bower](http://bower.io)

## Download and Install
To download and install Learning Locker, you need to run the commands below.

    git clone git@github.com:LearningLocker/learninglocker.git learninglocker
    cd learninglocker
    composer install

## Setup MongoDB
Make sure you have MongoDB set up with your db credentials added to `app/config/local/database.php` (or `app/config/database.php` depending on your `bootstrap/start.php` file) inside `connections` under `mongodb`. Then run the command below.

    php artisan migrate

If you're upgrading please check the [release notes](https://github.com/LearningLocker/learninglocker/releases) for any further steps.

## Register your first user
Go to `yoursite/register` and create the first user (which will be super admin). When registration is complete, you will be logged in. Next, select 'settings' to visit overall settings and click on 'edit' - here you can give your install a name and description as well as set a few options for the install.

You are now ready to use Learning Locker If you would like to use a previous version of Learning locker just append the tagged name to the path. e.g learninglocker/learninglocker=v1.0rc1

## Configuration
By default the `app/config/local` configuration will be used if you access Learning Locker via your localhost. You can change various settings such as debug mode, default language and timezone in `app/config/app.php`.
