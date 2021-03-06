= Dango Report

== Description

DRep is a simple data collector and report generator. It can collect data through a specific
data provider and generate a report by populating a specified template with the picked up data.

== Features:

* Data source-agnostic report generator
* Predefined examples to help you to get started

== Requirements

* Ruby 1.8.6 or later

=== Extra Dependencies

* nokogiri (version 1.3.2 or later)

Required for the bundled example and most likely for the majority of custom data providers
Use "--ignore- dependencies" Gem flag if you do not want to install this library alongside with the DRep

=== Extra Development Dependencies

* newgem (version 1.5.1 or later)

== Installation

=== Gem Installation

In order to setup DRep you will need to have RubyGems installed.
If you have it, then you can proceed with the following command:

  gem install drep

Note that you must have the correspondent account privileges
on your system in order to use this commands.

For other software bundles (including links for the source code packages)
consider visiting the official page of the project.

* http://85.17.184.9/drep

== Synopsis

For now, DRep can only be used as a standalone command line application.

=== Command Line Usage

The list of command line options can be obtained from the DRep executable with one of the following commands:

  drep -h
  drep --help

== Development

=== Source Repositories

DRep is currently hosted at RubyForge and GitHub.

The RubyForge page is
* http://rubyforge.org/projects/drep

The github web page is
* http://github.com/tda/drep

The public git clone URL is
* http://github.com/tda/drep.git

== Additional Information

Author:: Toksaitov Dmitrii Alexandrovich <toksaitov.d@gmail.com>

Project web site:: http://85.17.184.9/drep
Project forum:: http://groups.google.com/group/drep-system

== License

(The GNU General Public License)

DRep is a simple data collector and report generator.
Copyright (C) 2009 Toksaitov Dmitrii Alexandrovich

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
