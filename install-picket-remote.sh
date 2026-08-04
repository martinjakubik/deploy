#!/usr/local/bin/fish

set local_files_to_install ~/code/gitwork/deploy/build/picket ~/code/gitwork/deploy/build/picket-deploy-site ~/code/gitwork/deploy/build/picket-undeploy-site ~/code/gitwork/deploy/build/picket-delete-site

set files_to_install_local_dirname $(dirname $local_files_to_install[1])

set string_ssh_command "echo ssh -t martin@192.46.222.142 '"

for local_file_to_install in $local_files_to_install
    if test -f $local_file_to_install
        set file_to_install_basename $(basename $local_file_to_install)
        scp $local_file_to_install martin@192.46.222.142:~/

        set --append string_ssh_command "sudo mv ~/"$file_to_install_basename" /usr/local/bin/"$file_to_install_basename" ; sudo chmod a+x /usr/local/bin/"$file_to_install_basename" ; sudo chown root:root /usr/local/bin/"$file_to_install_basename" ; "

        ssh -t martin@192.46.222.142 'sudo mv ~/'$file_to_install_basename' /usr/local/bin/'$file_to_install_basename' ; sudo chmod a+x /usr/local/bin/'$file_to_install_basename' ; sudo chown root:root /usr/local/bin/'$file_to_install_basename
    end
end

set --append string_ssh_command "'"

echo ---
echo debugging the upload command:
echo $string_ssh_command
echo ---

# eval $string_ssh_command

ssh martin@192.46.222.142 'ls -la /usr/local/bin'
