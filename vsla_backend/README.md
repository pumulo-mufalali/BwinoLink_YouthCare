# VSLA Backend - Django REST API

A comprehensive Django backend for the VSLA (BwinoLink YouthCare) Flutter application, providing youth healthcare services including health screening, peer navigation, rewards system, and health access points.

## 🚀 Features

- **User Management**: Youth, staff, peer navigator, and vendor roles with comprehensive profiles
- **Health Screening**: Complete health screening results management with follow-up tracking
- **Peer Navigation**: Support system for youth healthcare guidance with session tracking
- **Rewards System**: Gamified points and rewards for health engagement
- **Health Access Points**: Market, school, youth center, and clinic locations with scheduling
- **Notifications**: Real-time notification system with templates and preferences
- **Chat System**: Communication between youth and health workers with file attachments
- **JWT Authentication**: Secure API access with token-based authentication
- **Role-based Access Control**: Comprehensive permission system
- **CORS Support**: Cross-origin resource sharing for Flutter app integration

## 🛠️ Technology Stack

- **Django 4.2.7**: Web framework
- **Django REST Framework**: API development
- **SQLite**: Database (can be configured for PostgreSQL)
- **JWT**: Authentication tokens
- **CORS**: Cross-origin resource sharing support
- **Django Filters**: Advanced filtering and search capabilities

## 📁 Project Structure

```
vsla_backend/
├── manage.py 
├── requirements.txt
├── README.md
├── test_setup.py
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
│   ├── __init__.py
│   ├── apps.py
│   ├── models.py
│   ├── serializers.py
│   ├── views.py
│   ├── urls.py
│   └── admin.py
├── health_access/
│   ├── __init__.py
│   ├── apps.py
│   ├── models.py
│   ├── serializers.py
│   ├── views.py
│   ├── urls.py
│   └── admin.py
├── peer_navigation/
│   ├── __init__.py
│   ├── apps.py
│   ├── models.py
│   ├── serializers.py
│   ├── views.py
│   ├── urls.py
│   └── admin.py
├── notifications/
│   ├── __init__.py
│   ├── apps.py
│   ├── models.py
│   ├── serializers.py
│   ├── views.py
│   ├── urls.py
│   └── admin.py
└── chat/
    ├── __init__.py
    ├── apps.py
    ├── models.py
    ├── serializers.py
    ├── views.py
    ├── urls.py
    └── admin.py
```

## 🗄️ Database Models

### Users App
- **UserProfile**: Extended Django user with VSLA-specific fields
- Role-based access control (youth, staff, peer_navigator, vendor)
- Points system for gamification
- Location and interests tracking

### Health Screening App
- **ScreeningResult**: Comprehensive health screening data
- **HealthWorkerProfile**: Professional health worker information
- Support for multiple test types
- Follow-up scheduling and instructions
- Location tracking (market, school, youth center, clinic)

### Rewards App
- **RewardItem**: Points-based reward system
- **Achievement**: Gamification achievements
- **UserReward**: User reward redemptions
- **UserAchievement**: Achievement tracking

### Health Access App
- **HealthAccessPoint**: Health service locations
- **AccessPointService**: Available services
- **AccessPointSchedule**: Operating schedules

### Peer Navigation App
- **PeerNavigatorAssignment**: Youth-peer navigator relationships
- **SupportSession**: Individual support sessions
- Progress tracking and goal setting

### Notifications App
- **NotificationItem**: User notifications
- **NotificationTemplate**: Reusable templates
- **NotificationPreference**: User preferences

### Chat App
- **HealthWorkerMessage**: Chat messages
- **ChatRoom**: Conversation rooms
- **ChatRoomParticipant**: Room participants
- **MessageAttachment**: File attachments

## 🔌 API Endpoints

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

### Rewards
- `GET /api/v1/rewards/` - List available rewards
- `POST /api/v1/rewards/redeem/` - Redeem reward
- `GET /api/v1/achievements/` - List achievements
- `GET /api/v1/user-rewards/` - User reward history

### Health Access Points
- `GET /api/v1/access-points/` - List health access points
- `GET /api/v1/access-points/<id>/` - Get access point details
- `GET /api/v1/access-points/by-type/<type>/` - Filter by type

### Peer Navigation
- `GET /api/v1/peer-navigation/assignments/` - List assignments
- `POST /api/v1/peer-navigation/assignments/` - Create assignment
- `GET /api/v1/peer-navigation/sessions/` - List support sessions

### Notifications
- `GET /api/v1/notifications/` - List user notifications
- `PUT /api/v1/notifications/<id>/read/` - Mark as read
- `GET /api/v1/notifications/preferences/` - Get preferences

### Chat
- `GET /api/v1/chat/rooms/` - List chat rooms
- `GET /api/v1/chat/messages/<room_id>/` - Get room messages
- `POST /api/v1/chat/messages/` - Send message

## 🚀 Installation

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

6. **Test the setup**
   ```bash
   python test_setup.py
   ```

7. **Run the development server**
   ```bash
   python manage.py runserver
   ```

## 🔧 Configuration

### Environment Variables
Create a `.env` file for sensitive configuration:
```
SECRET_KEY=your-secret-key
DEBUG=False
ALLOWED_HOSTS=your-domain.com
DATABASE_URL=postgresql://user:password@localhost/dbname
```

### Database Configuration
The default configuration uses SQLite. For production, configure PostgreSQL:
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'vsla_db',
        'USER': 'vsla_user',
        'PASSWORD': 'your_password',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}
```

## 🧪 Testing

### Run Tests
```bash
python manage.py test
```

### Test Setup
```bash
python test_setup.py
```

## 🔒 Security Features

- JWT token authentication
- Role-based permissions
- CORS configuration for Flutter app
- Input validation and sanitization
- Secure password handling
- Custom user model with extended fields

## 📱 Flutter Integration

The backend is designed to work seamlessly with your Flutter app:

### Authentication Flow
1. User registers/logs in via Flutter app
2. Backend returns JWT tokens
3. Flutter app stores tokens securely
4. All subsequent API calls include JWT in headers

### Data Synchronization
- Replace dummy data with real API calls
- Implement real-time updates using Django signals
- Handle offline/online synchronization

### Push Notifications
- Integrate with Firebase Cloud Messaging
- Use Django signals to trigger notifications
- Support for scheduled notifications

## 🚀 Deployment

### Production Settings
- Set `DEBUG = False`
- Configure production database (PostgreSQL recommended)
- Set secure `SECRET_KEY`
- Configure static and media file serving
- Set up proper CORS origins
- Enable HTTPS

### Deployment Options
- **Heroku**: Easy deployment with PostgreSQL add-on
- **AWS**: EC2 with RDS and S3
- **DigitalOcean**: Droplet with managed database
- **Docker**: Containerized deployment

## 🔄 Development Workflow

### Adding New Features
1. Create models in appropriate app
2. Create serializers for API responses
3. Implement views with proper permissions
4. Add URL patterns
5. Create admin interface
6. Write tests
7. Update documentation

### Database Changes
1. Modify models in models.py
2. Create migrations: `python manage.py makemigrations`
3. Apply migrations: `python manage.py migrate`
4. Update admin if needed

### API Versioning
- Current version: `/api/v1/`
- Future versions: `/api/v2/`, etc.
- Maintain backward compatibility

## 📊 Monitoring & Analytics

### Health Checks
- Database connectivity
- API response times
- Error rates
- User activity metrics

### Logging
- Request/response logging
- Error tracking
- Performance monitoring
- User action auditing

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Update documentation
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation
- Review the API endpoints

## 🎯 Next Steps

1. **Complete API Implementation**: Add remaining serializers, views, and URLs
2. **Admin Interface**: Complete admin configurations for all apps
3. **Testing**: Write comprehensive tests for all models and views
4. **Documentation**: Add API documentation using drf-spectacular
5. **Performance**: Add caching and database optimization
6. **Security**: Implement rate limiting and additional security measures
7. **Monitoring**: Add logging and monitoring tools

---

**VSLA Backend** - Empowering Youth Healthcare Through Technology 🏥✨
