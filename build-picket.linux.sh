#!/usr/bin/fish

set source_files ~/code/gitwork/deploy/picket.sh ~/code/gitwork/deploy/picket-deploy-site.sh ~/code/gitwork/deploy/picket-undeploy-site.sh ~/code/gitwork/deploy/picket-delete-site.sh ~/code/gitwork/deploy/upload.sh

set source_dirname $(dirname $source_files[1])

for source_file in $source_files
    set destination_file $(basename $(path change-extension '' $source_file))
    cp $source_file $source_dirname/build/$destination_file
end
