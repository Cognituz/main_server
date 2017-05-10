#!/bin/bash

# For each file in /tmp/nginx_conf that ends with '.template',
# replace env variables using envsubst, and remove the source template.
# Then merge the contents of /tmp/nginx_conf into /etc/nginx

for f in $(find /tmp/nginx_conf | grep "\.template$"); do
  cat $f \
    | \
      envsubst '\
      \$API_ASSETS_DIR \
      \$API_DOMAIN     \
      \$API_SOCK_PATH  \
      \$UI_DOMAIN      \
      \$UI_ASSETS_DIR  \
    ' \
    > ${f%.template}

  rm $f
done

rsync -ra /tmp/nginx_conf/* /etc/nginx/

ln -sf /dev/stdout $ACCESS_LOG
ln -sf /dev/stdout $ERROR_LOG

nginx -g 'daemon off;'
