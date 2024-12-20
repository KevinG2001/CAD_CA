# Ensure the script stops on error
set -e

echo "Stopping any running Rails server"
pkill -f "rails server" || true

echo "Pulling the latest code from the deployment branch"
git pull origin deployment

echo "Running bundle install"
bundle install

echo "Starting Rails server on 0.0.0.0:3000"
rails server -b '0.0.0.0' -p 3000 -e production
