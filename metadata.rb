maintainer       "Enalean"
maintainer_email "crew@enalean.com"
license          "GPLv2+"
description      "Setup Tuleap continuous build server"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends 'yum'
depends 'yum-epel'
depends 'yum-repoforge'
