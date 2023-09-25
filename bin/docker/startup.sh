#! /bin/sh

# Prepare DB (Migrate - If not? Create db & Migrate)
bundle exec rake db:migrate
echo "Done!"

bundle exec rails server -p 80 -b '0.0.0.0'