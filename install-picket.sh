#!/usr/bin/env fish

set project_parent_path ~/code/gitwork/deploy
set local_binary_files_to_install_source_parent_path $project_parent_path/build
set local_binary_files_to_install picket picket-add-app picket-activate-app picket-create-app picket-create-site picket-deploy-site picket-undeploy-site picket-delete-site picket-list-sites picket-stage-site picket-unstage-site picket-function-check-if-argument-provided-ip picket-function-check-if-argument-provided-siteid picket-function-check-if-argument-provided-userid picket-function-check-if-argument-provided-or-stored-userid picket-function-does-app-exist-in-database picket-function-does-site-exist-in-database picket-function-is-valid-app-id picket-function-prepare picket-function-upload picket-function-delete-stage picket-function-get-app-project-root-from-id picket-function-get-site-nickname-from-id picket-function-get-site-project-root-from-id picket-function-is-ipv6 picket-function-is-valid-site-id picket-function-is-valid-user-id picket-function-list-sites-hosting-app picket-login picket-list-apps  picket-logout picket-delete-app

for local_executable_file_to_install in $local_binary_files_to_install
    if test -f $local_binary_files_to_install_source_parent_path/$local_executable_file_to_install
        cp $local_binary_files_to_install_source_parent_path/$local_executable_file_to_install /usr/local/bin/
        chmod +x /usr/local/bin/$local_executable_file_to_install
    end
end

if test ! -d $HOME/.picket
    mkdir $HOME/.picket
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
cp $local_configuration_file_to_install /etc/picket/
cp $local_configuration_file_to_install $HOME/.picket/

set local_template_files_to_install background.png favicon.png index.html logo.png screen.css robots.txt title.png
for local_template_file_to_install in $local_template_files_to_install
    cp $project_parent_path/build/$local_template_file_to_install /etc/picket/
    cp $project_parent_path/build/$local_template_file_to_install $HOME/.picket/
end
