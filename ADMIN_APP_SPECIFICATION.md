# CarsNan Admin App - Complete Development Specification

## 📱 Overview
The CarsNan Admin App is a comprehensive management dashboard for car wash service administrators. It provides complete control over services, workers, orders, and system operations with real-time Firebase integration.

## 🎯 Core Functionality

### 1. Admin Authentication & Security
**Secure admin-only access with role-based permissions**

#### Features Required:
- **Admin Login System**: Separate from user app
- **Role Management**: Super Admin, Manager, Operator roles
- **Session Management**: Secure session handling
- **Two-Factor Authentication**: Enhanced security for admin access
- **Access Logs**: Track admin activities

#### Implementation:
```yaml
Authentication Flow:
  1. Admin email/password login
  2. Role verification from Firestore
  3. MFA verification (optional but recommended)
  4. Dashboard access based on role permissions

Firebase Structure:
  admins/
    └── {adminId}/
        ├── email: string
        ├── role: 'super_admin' | 'manager' | 'operator'
        ├── permissions: array
        ├── lastLogin: timestamp
        └── isActive: boolean
```

### 2. Service Management Dashboard
**Complete control over services offered to users**

#### Core Features:
- **Service CRUD Operations**: Create, read, update, delete services
- **Dynamic Pricing**: Set and modify service prices
- **Service Categories**: Organize services by type
- **Service Availability**: Enable/disable services
- **Image Management**: Upload and manage service images
- **Service Analytics**: Track popular services

#### Service Management Interface:
```yaml
Service Configuration:
  Basic Info:
    - Service name and description
    - Category selection
    - Base price setting
    - Duration estimation
    - Service availability status

  Advanced Settings:
    - Car type multipliers (Sedan, SUV, Mini)
    - Location-based pricing
    - Seasonal pricing rules
    - Bundle offers and discounts
    - Required equipment/supplies

  Media Management:
    - Service images (multiple uploads)
    - Video demonstrations
    - Service instruction documents
    - Before/after photo examples
```

#### Firebase Integration:
```yaml
services/
  └── {serviceId}/
      ├── title: string
      ├── description: string
      ├── basePrice: number
      ├── category: string
      ├── duration: number (minutes)
      ├── isActive: boolean
      ├── carTypeMultipliers: object
      ├── images: array
      ├── createdAt: timestamp
      ├── updatedAt: timestamp
      └── createdBy: adminId
```

### 3. Worker Management System
**Comprehensive worker allocation and tracking**

#### Worker Registration & Profiles:
- **Worker Database**: Store all worker information
- **ID Generation**: Automatic job ID creation
- **Profile Management**: Complete worker profiles
- **Document Storage**: ID proofs, certifications
- **Rating System**: Track worker performance

#### Worker Allocation Engine:
```yaml
Allocation Logic:
  Time Slots:
    - 6:00 AM - 7:00 AM (Slot 1)
    - 7:00 AM - 8:00 AM (Slot 2)
    - ... (hourly slots)
    - 5:00 PM - 6:00 PM (Slot 12)

  Allocation Rules:
    - Maximum 5 workers per day
    - 12 working hours (6 AM - 6 PM)
    - 1 hour lunch break (12-1 PM)
    - 11 available slots per worker
    - Total 55 slots available per day

  Auto-Assignment:
    - Assign workers to time slots automatically
    - Balance workload across workers
    - Handle worker availability preferences
    - Manage sick leave and holidays
```

#### Worker Management Interface:
```yaml
Worker Dashboard:
  Registration:
    - Personal information form
    - Contact details
    - Address and location
    - Emergency contact
    - Bank account details
    - Document uploads (ID, photos)

  Job Management:
    - Create unique job IDs
    - Assign service areas
    - Set availability schedules
    - Track performance metrics
    - Manage ratings and reviews

  Allocation System:
    - View daily worker allocation
    - Drag-and-drop slot assignment
    - Bulk allocation for multiple days
    - Worker substitution management
    - Real-time availability updates
```

#### Firebase Structure:
```yaml
workers/
  └── {workerId}/
      ├── jobId: string (unique)
      ├── personalInfo: object
      ├── contactDetails: object
      ├── documents: array
      ├── availability: object
      ├── assignedSlots: array
      ├── performance: object
      ├── isActive: boolean
      ├── createdAt: timestamp
      └── createdBy: adminId

workerAllocations/
  └── {date}/
      ├── availableSlots: number
      ├── assignedWorkers: array
      ├── workload: object
      └── lastUpdated: timestamp
```

### 4. Order History & Analytics Dashboard
**Comprehensive order tracking and business intelligence**

#### Order Management:
- **Real-time Order Tracking**: Live order status
- **Order Details**: Complete booking information
- **Customer Information**: User details and history
- **Service History**: Past service records
- **Payment Tracking**: Transaction details
- **Issue Management**: Handle complaints and issues

#### Analytics Features:
```yaml
Business Intelligence:
  Revenue Analytics:
    - Daily/weekly/monthly revenue
    - Service-wise revenue breakdown
    - Customer lifetime value
    - Payment method analytics
    - Refund and cancellation tracking

  Operational Analytics:
    - Worker productivity metrics
    - Service completion rates
    - Average service duration
    - Customer satisfaction scores
    - Peak time analysis

  Customer Analytics:
    - New vs returning customers
    - Customer demographics
    - Service preferences
    - Geographic distribution
    - Customer churn analysis
```

#### Dashboard Components:
```yaml
Order Management Interface:
  Order List View:
    - Searchable and filterable orders
    - Real-time status updates
    - Quick action buttons
    - Bulk operations
    - Export capabilities

  Order Detail View:
    - Customer information
    - Service details
    - Worker assignment
    - Payment information
    - Timeline of events
    - Communication logs

  Analytics Dashboard:
    - Revenue charts and graphs
    - Key performance indicators
    - Real-time metrics
    - Custom date ranges
    - Downloadable reports
```

### 5. Real-time Communication System
**Integration with user and worker apps**

#### Communication Features:
- **Broadcast Notifications**: Send updates to all users
- **Targeted Messaging**: Specific user/worker groups
- **System Announcements**: App-wide announcements
- **Emergency Alerts**: Urgent notifications
- **Promotional Campaigns**: Marketing messages

#### Integration Points:
```yaml
Firebase Cloud Messaging:
  User App Integration:
    - Order status updates
    - Service reminders
    - Promotional offers
    - System maintenance alerts

  Worker App Integration:
    - Job assignments
    - Schedule changes
    - Performance feedback
    - Training announcements

  Admin Notifications:
    - System alerts
    - Performance metrics
    - Critical issues
    - Daily summaries
```

## 🏗️ Technical Architecture

### Technology Stack:
```yaml
Framework: Flutter (Web & Desktop)
Architecture: Clean Architecture + MVVM
State Management: flutter_bloc (Bloc/Cubit)
Database: Firebase Firestore
Authentication: Firebase Auth (Admin)
Storage: Firebase Storage
Analytics: Firebase Analytics
Notifications: Firebase Cloud Messaging
Charts: fl_chart or syncfusion_flutter_charts
Web Deployment: Firebase Hosting
Desktop: Windows/macOS builds
```

### Project Structure:
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── di/
│   ├── errors/
│   ├── router/
│   ├── services/
│   └── utils/
├── shared/
│   ├── widgets/          # Common UI components
│   ├── themes/           # Admin theme
│   └── constants/        # Admin constants
└── features/
    ├── auth/             # Admin authentication
    ├── dashboard/        # Main dashboard
    ├── services/         # Service management
    ├── workers/          # Worker management
    ├── orders/           # Order management
    ├── analytics/        # Analytics dashboard
    ├── notifications/    # Communication system
    └── settings/         # Admin settings
```

## 🎨 UI/UX Design Requirements

### Design System:
```yaml
Theme: Professional Admin Dashboard
Colors:
  Primary: Deep Blue (#1565C0)
  Secondary: Orange (#FF9800)
  Success: Green (#4CAF50)
  Warning: Amber (#FFC107)
  Error: Red (#F44336)
  Background: Light Gray (#FAFAFA)
  Surface: White (#FFFFFF)

Typography:
  Header: Roboto 24px Bold
  Subheader: Roboto 18px Medium
  Body: Roboto 14px Regular
  Caption: Roboto 12px Regular

Components:
  - Data tables with sorting/filtering
  - Interactive charts and graphs
  - Modal dialogs for forms
  - Sidebar navigation
  - Responsive grid layouts
  - Loading states and progress indicators
```

### Layout Structure:
```yaml
Main Layout:
  Sidebar Navigation:
    - Dashboard
    - Services Management
    - Worker Management
    - Order History
    - Analytics
    - Notifications
    - Settings
    - Logout

  Header Bar:
    - App title and logo
    - Real-time notifications bell
    - Admin profile dropdown
    - Search functionality
    - Quick actions

  Main Content Area:
    - Dynamic content based on navigation
    - Breadcrumb navigation
    - Page-specific actions
    - Data visualization components
```

## 📊 Dashboard Components

### 1. Main Dashboard (Home):
```yaml
Overview Cards:
  - Total Orders Today
  - Active Workers
  - Revenue Today
  - Customer Satisfaction

Real-time Charts:
  - Orders Timeline (24 hours)
  - Revenue Trend (7 days)
  - Worker Utilization
  - Service Distribution

Quick Actions:
  - Add New Service
  - Register Worker
  - Send Notification
  - View Critical Issues
```

### 2. Services Management Page:
```yaml
Service List:
  - Grid/List view toggle
  - Search and filter options
  - Bulk actions (activate/deactivate)
  - Quick edit capabilities

Add/Edit Service Form:
  - Service details form
  - Image upload interface
  - Pricing configuration
  - Car type multipliers
  - Availability settings
```

### 3. Worker Management Page:
```yaml
Worker Overview:
  - Worker list with photos
  - Status indicators (active/inactive)
  - Performance ratings
  - Current assignments

Allocation Calendar:
  - Weekly/monthly view
  - Drag-and-drop slot assignment
  - Worker availability matrix
  - Automatic allocation suggestions

Worker Profile:
  - Detailed worker information
  - Performance metrics
  - Job history
  - Document management
```

### 4. Order Management Page:
```yaml
Order Dashboard:
  - Real-time order feed
  - Status distribution chart
  - Filter by status/date/worker
  - Export functionality

Order Details Modal:
  - Complete order information
  - Customer details
  - Service timeline
  - Payment status
  - Communication log
```

## 🔄 Implementation Phases

### Phase 1: Core Foundation (Week 1-2)
```yaml
Setup & Authentication:
  - Flutter project setup
  - Firebase configuration
  - Admin authentication system
  - Basic routing and navigation
  - Theme and UI foundation

Deliverables:
  - Admin login screen
  - Dashboard layout
  - Navigation system
  - Firebase integration
```

### Phase 2: Service Management (Week 3-4)
```yaml
Service CRUD Operations:
  - Service list interface
  - Add/edit service forms
  - Image upload functionality
  - Service activation/deactivation
  - Real-time updates to user app

Deliverables:
  - Complete service management
  - Firebase service collection
  - Image storage system
  - Live sync with user app
```

### Phase 3: Worker Management (Week 5-6)
```yaml
Worker System:
  - Worker registration forms
  - Job ID generation
  - Profile management
  - Allocation system interface
  - Time slot management

Deliverables:
  - Worker management dashboard
  - Allocation calendar
  - Worker profiles
  - Scheduling system
```

### Phase 4: Order & Analytics (Week 7-8)
```yaml
Order Management:
  - Order history interface
  - Real-time order tracking
  - Analytics dashboard
  - Reporting system
  - Data visualization

Deliverables:
  - Complete order management
  - Analytics dashboards
  - Report generation
  - Performance metrics
```

### Phase 5: Integration & Polish (Week 9-10)
```yaml
System Integration:
  - Worker app integration
  - Notification system
  - Real-time updates
  - Testing and bug fixes
  - Performance optimization

Deliverables:
  - Complete admin system
  - Multi-app integration
  - Production deployment
  - Documentation
```

## 🔗 Integration Requirements

### Firebase Collections Structure:
```yaml
Database Structure:
  admins/                 # Admin users
  services/              # Service management
  workers/               # Worker information
  workerAllocations/     # Daily worker assignments
  orders/                # All customer orders
  notifications/         # System notifications
  analytics/             # Analytics data
  settings/              # System settings

Security Rules:
  - Admin-only access to sensitive data
  - Role-based permissions
  - Audit logging for admin actions
  - Data validation rules
```

### API Endpoints (if needed):
```yaml
Admin APIs:
  - POST /api/admin/login
  - GET /api/admin/dashboard
  - GET /api/admin/analytics
  - POST /api/admin/notifications/broadcast

Worker APIs:
  - GET /api/workers/allocations
  - POST /api/workers/assignments
  - PUT /api/workers/status

Order APIs:
  - GET /api/orders/history
  - PUT /api/orders/status
  - GET /api/orders/analytics
```

## 🧪 Testing Strategy

### Testing Requirements:
```yaml
Unit Tests:
  - Business logic testing
  - Data model testing
  - Use case testing

Widget Tests:
  - UI component testing
  - Form validation testing
  - Navigation testing

Integration Tests:
  - Firebase integration
  - End-to-end workflows
  - Cross-app communication

Performance Tests:
  - Large data set handling
  - Real-time updates
  - Concurrent user testing
```

## 🚀 Deployment Strategy

### Deployment Options:
```yaml
Web Deployment:
  - Firebase Hosting
  - Custom domain setup
  - SSL certificate
  - Progressive Web App (PWA)

Desktop Deployment:
  - Windows executable
  - macOS application
  - Auto-update mechanism
  - Installer packages

Mobile Deployment (Optional):
  - Android APK
  - iOS IPA
  - Internal distribution
  - MDM integration
```

## 📋 Development Guidelines

### Code Standards:
- Follow Flutter/Dart best practices
- Implement Clean Architecture
- Use proper state management
- Handle errors gracefully
- Write comprehensive tests
- Document all APIs and functions

### Security Requirements:
- Implement proper authentication
- Use role-based access control
- Validate all user inputs
- Encrypt sensitive data
- Implement audit logging
- Regular security updates

### Performance Requirements:
- Optimize for large data sets
- Implement pagination
- Use efficient data queries
- Cache frequently used data
- Monitor app performance
- Implement lazy loading

---

*This specification provides a complete blueprint for developing the CarsNan Admin App. Follow this guide to build a robust, scalable admin dashboard that integrates seamlessly with the user and worker applications.*
