#!/usr/bin/env python3
"""
Test script to verify VSLA Django backend setup
"""

import os
import sys
import django

def test_django_setup():
    """Test if Django is properly configured"""
    try:
        # Add the project directory to Python path
        project_dir = os.path.dirname(os.path.abspath(__file__))
        sys.path.insert(0, project_dir)
        
        # Set Django settings
        os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'vsla_backend.settings')
        
        # Setup Django
        django.setup()
        
        print("✅ Django setup successful!")
        
        # Test imports
        from vsla_backend.users.models import UserProfile
        from health_screening.models import ScreeningResult, HealthWorkerProfile
        
        print("✅ Models imported successfully!")
        
        # Test database connection
        from django.db import connection
        cursor = connection.cursor()
        cursor.execute("SELECT 1")
        result = cursor.fetchone()
        
        if result and result[0] == 1:
            print("✅ Database connection successful!")
        else:
            print("❌ Database connection failed!")
            
        return True
        
    except Exception as e:
        print(f"❌ Django setup failed: {str(e)}")
        return False

def test_app_configuration():
    """Test if all apps are properly configured"""
    try:
        from django.apps import apps
        
        required_apps = [
            'users',
            'health_screening',
        ]
        
        for app_name in required_apps:
            if apps.is_installed(app_name):
                print(f"✅ {app_name} app is installed")
            else:
                print(f"❌ {app_name} app is not installed")
                return False
        
        return True
        
    except Exception as e:
        print(f"❌ App configuration test failed: {str(e)}")
        return False

def main():
    """Main test function"""
    print("🚀 Testing VSLA Django Backend Setup...")
    print("=" * 50)
    
    # Test Django setup
    if not test_django_setup():
        print("\n❌ Setup test failed. Please check your configuration.")
        return False
    
    print()
    
    # Test app configuration
    if not test_app_configuration():
        print("\n❌ App configuration test failed.")
        return False
    
    print("\n🎉 All tests passed! Your Django backend is ready.")
    print("\nNext steps:")
    print("1. Run: python manage.py makemigrations")
    print("2. Run: python manage.py migrate")
    print("3. Run: python manage.py createsuperuser")
    print("4. Run: python manage.py runserver")
    
    return True

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
