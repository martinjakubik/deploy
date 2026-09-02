#!/usr/bin/env fish

set project_parent_path ~/code/gitwork/deploy
set source_files picket.sh picket-create-site.sh picket-deploy-site.sh picket-undeploy-site.sh picket-delete-site.sh picket-list-sites.sh picket-stage-site.sh picket-unstage-site.sh picket-function-prepare.sh picket-function-upload.sh picket-function-delete-stage.sh picket-function-get-site-nickname-from-id.sh picket-function-get-site-project-root-from-id.sh picket-function-is-ipv6.sh

if test ! -d $project_parent_path/build
    mkdir $project_parent_path/build
end

for source_file in $source_files
    set destination_file $(path change-extension '' $source_file)
    cp $project_parent_path/$source_file $project_parent_path/build/$destination_file
    chmod u+x $project_parent_path/build/$destination_file
end

cp "$project_parent_path"/site-canonical-source-code-files "$project_parent_path"/build/
cp "$project_parent_path"/site-canonical-binary-files "$project_parent_path"/build/
