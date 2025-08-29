# VSLA Backend - Django REST API

A comprehensive Django backend for the VSLA (BwinoLink YouthCare) Flutter application, providing youth healthcare services including health screening, peer navigation, rewards system, and health access points.

## Features

- **User Management**: Youth, staff, peer navigator, and vendor roles
- **Health Screening**: Comprehensive health screening results management
- **Peer Navigation**: Support system for youth healthcare guidance
- **Rewards System**: Gamified points and rewards for health engagement
- **Health Access Points**: Market, school, youth center, and clinic locations
- **Notifications**: Real-time notification system
- **Chat System**: Communication between youth and health workers
- **JWT Authentication**: Secure API access with token-based authentication

## Technology Stack

- **Django 4.2.7**: Web framework
- **Django REST Framework**: API development
- **SQLite**: Database (can be configured for PostgreSQL)
- **JWT**: Authentication tokens
- **CORS**: Cross-origin resource sharing support

## Project Structure

```
vsla_backend/
├── manage.py
├── requirements.txt
├── README.md
├── vsla_backend/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   ├── wsgi.py
│   └── asgi.py
├── users/
│   ├── __init__.py
│   ├── apps.py
│   ├── models.py
│   ├── serializers.py
│   ├── views.py
│   ├── urls.py
│   └── admin.py
├── health_screening/
│   ├── __init__.py
│   ├── apps.py
│   ├── models.py
│   ├── serializers.py
│   ├── views.py
│   ├── urls.py
│   └── admin.py
├── rewards/
├── health_access/
├── peer_navigation/
├── notifications/
└── chat/
```

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd vsla_backend
   ```

2. **Create a virtual environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run migrations**
   ```bash
   python manage.py makemigrations
   python manage.py migrate
   ```

5. **Create a superuser**
   ```bash
   python manage.py createsuperuser
   ```

6. **Run the development server**
   ```bash
   python manage.py runserver
   ```

## API Endpoints

### Authentication
- `POST /api/v1/auth/register/` - User registration
- `POST /api/v1/auth/login/` - User login
- `POST /api/v1/auth/logout/` - User logout

### User Management
- `GET /api/v1/profile/` - Get user profile
- `PUT /api/v1/profile/update/` - Update user profile
- `POST /api/v1/profile/change-password/` - Change password
- `GET /api/v1/points/` - Get user points
- `POST /api/v1/points/` - Add points to user

### Health Screening
- `GET /api/v1/screenings/` - List screening results
- `POST /api/v1/screenings/` - Create new screening
- `GET /api/v1/screenings/<id>/` - Get screening details
- `PUT /api/v1/screenings/<id>/` - Update screening
- `GET /api/v1/screenings/abnormal/` - Get abnormal results
- `GET /api/v1/screenings/statistics/` - Get screening statistics

### Health Workers
- `GET /api/v1/health-workers/` - List health workers
- `GET /api/v1/health-workers/profile/` - Get health worker profile
- `PUT /api/v1/health-workers/availability/` - Update availability

## Models

### UserProfile
- Extended Django user model with VSLA-specific fields
- Role-based access control (youth, staff, peer_navigator, vendor)
- Points system for gamification
- Location and interests tracking

### ScreeningResult
- Comprehensive health screening data
- Support for multiple test types
- Follow-up scheduling and instructions
- Location tracking (market, school, youth center, clinic)

### HealthWorkerProfile
- Professional health worker information
- Specialization and availability tracking
- License and experience details

## Security Features

- JWT token authentication
- Role-based permissions
- CORS configuration for Flutter app
- Input validation and sanitization
- Secure password handling

## Development

### Adding New Apps
1. Create app directory: `python manage.py startapp app_name`
2. Add to INSTALLED_APPS in settings.py
3. Include URLs in main urls.py
4. Create models, serializers, views, and URLs

### Database Changes
1. Modify models in models.py
2. Create migrations: `python manage.py makemigrations`
3. Apply migrations: `python manage.py migrate`

### Testing
```bash
python manage.py test
```

## Deployment

### Production Settings
- Set `DEBUG = False`
- Configure production database (PostgreSQL recommended)
- Set secure `SECRET_KEY`
- Configure static and media file serving
- Set up proper CORS origins

### Environment Variables
Create a `.env` file for sensitive configuration:
```
SECRET_KEY=your-secret-key
DEBUG=False
ALLOWED_HOSTS=your-domain.com
DATABASE_URL=postgresql://user:password@localhost/dbname
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support and questions, please contact the development team or create an issue in the repository.
