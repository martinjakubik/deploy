#!/usr/bin/env fish

set project_parent_path ~/code/gitwork/deploy
set local_files_to_install_parent_path $project_parent_path/build
set local_files_to_install picket picket-deploy-site picket-undeploy-site picket-delete-site picket-stage-site picket-unstage-site picket-function-prepare picket-function-upload picket-function-delete-stage picket-function-get-site-nickname-from-id picket-function-get-site-project-root-from-id picket-function-is-ipv6

set string_ssh_command "ssh -t martin@192.46.222.142 '"

for local_file_to_install in $local_files_to_install
    if test -f $local_files_to_install_parent_path/$local_file_to_install
        sudo cp $local_files_to_install_parent_path/$local_file_to_install /usr/local/bin/
        sudo chmod +x /usr/local/bin/$local_file_to_install

        #scp $local_file_to_install martin@192.46.222.142:~/

        set --append string_ssh_command "sudo mv ~/"$local_file_to_install" /usr/local/bin/"$local_file_to_install" ; sudo chmod a+x /usr/local/bin/"$local_file_to_install" ; sudo chown root:root /usr/local/bin/"$local_file_to_install" ; "
    end
end

set local_file_to_install $project_parent_path/site-canonical-source-code-files
sudo cp $local_file_to_install /etc/picket/

set local_file_to_install $project_parent_path/site-canonical-binary-files
sudo cp $local_file_to_install /etc/picket/

set --append string_ssh_command "'"

# echo ---
# echo debugging the upload command:
# echo $string_ssh_command
# echo ---

# eval $string_ssh_command

# ssh martin@192.46.222.142 'ls -la /usr/local/bin'
