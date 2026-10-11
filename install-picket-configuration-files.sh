#!/usr/bin/env fish

set project_parent_path .
set local_binary_files_to_install_source_parent_path $project_parent_path/build

if test ! -d $HOME/.picket
    mkdir $HOME/.picket
end

if test ! -d $HOME/.config/picket
    mkdir -p $HOME/.config/picket
end

set local_configuration_file_to_install $project_parent_path/site-canonical-source-code-files
cp $local_configuration_file_to_install $HOME/.picket/

set local_configuration_file_to_install $project_parent_path/site-canonical-binary-files
cp $local_configuration_file_to_install $HOME/.picket/

set local_configuration_file_to_install $project_parent_path/app-canonical-source-code-files
cp $local_configuration_file_to_install $HOME/.picket/

set local_configuration_file_to_install $project_parent_path/app-canonical-binary-files
cp $local_configuration_file_to_install $HOME/.picket/

set local_configuration_file_to_install $project_parent_path/config.picket
cp $local_configuration_file_to_install $HOME/.config/picket

set local_template_files_to_install background.png favicon.png index.html logo.png screen.css robots.txt title.png
for local_template_file_to_install in $local_template_files_to_install
    cp $project_parent_path/build/$local_template_file_to_install $HOME/.picket/
end
