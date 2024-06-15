FROM node:20

WORKDIR /app

# Install cron and curl
RUN apt-get update && apt-get install -y cron curl

# Clone your repository or copy your application files
RUN git clone https://github.com/nthumodifications/courseweb .

# Check if the package.json file exists
RUN ls -al /app

# Check for network issues
RUN npm config set registry https://registry.npmjs.org/

RUN npm install --legacy-peer-deps

# Copy the fetch_status script and give execution rights
COPY fetch_status.sh /app
RUN chmod +x /app/fetch_status.sh

# Add a cron job
RUN (crontab -l ; echo "*/10 * * * * /app/fetch_status.sh") | crontab

EXPOSE 3000

# Start cron and the application
CMD cron && npm run dev
