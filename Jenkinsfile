pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git(
                    url: 'https://github.com/nowdelivery/Backend.git',
                    branch: 'develop',
                    credentialsId: 'github-pat'
                )
            }
        }

        stage('Prepare Environment') {
            steps {
                sh '''
                    if [ -f ".env.example" ]; then
                        cp .env.example .env
                        
                        
                        sed -i 's/^# \\(DB_HOST=\\|DB_PORT=\\|DB_DATABASE=\\|DB_USERNAME=\\|DB_PASSWORD=\\)/\\1/' .env
                        sed -i 's/^DB_CONNECTION=.*/DB_CONNECTION=mysql/' .env
                        sed -i 's/^DB_HOST=.*/DB_HOST=127.0.0.1/' .env
                        sed -i 's/^DB_DATABASE=.*/DB_DATABASE=laravel/' .env
                        sed -i 's/^DB_USERNAME=.*/DB_USERNAME=root/' .env
                        sed -i 's/^DB_PASSWORD=.*/DB_PASSWORD=/' .env
                        sed -i 's/^DASHBOARD_ADMIN_NAME=.*/DASHBOARD_ADMIN_NAME="Dashboard Admin"/' .env
                    else
                        "file not found"
                    fi
                    nl .env
                '''
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh '''
                    composer install \
                        --no-interaction \
                        --prefer-dist \
                        --optimize-autoloader 
                '''
            }
        }
        stage('Prepare Laravel') {
            steps {
                sh '''
                    php artisan package:discover
                    php artisan key:generate --force
           
                    php artisan config:clear
                    php artisan migrate --force
                    php artisan cache:clear
                    php artisan route:clear
                    php artisan view:clear
                '''
            }       
        }
        stage('Run Tests') {
            steps {
                sh '''
                    export DB_CONNECTION=sqlite
                    export DB_DATABASE=":memory:"

                    php artisan config:clear
                    
                    php artisan migrate --env=testing --force
                '''
            }
        }
    }
}
