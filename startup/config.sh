#!/bin/bash

# updates startup file in the correct directory instead of using a symbolic link

cp ./start_aux.sh /usr/local/bin/startup_script.sh

# gives run permission
chmod +x /usr/local/bin/startup_script.sh

