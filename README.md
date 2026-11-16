# 🏫 Campus Room Allocation System

A PHP and MySQL web app for managing student housing on campus. Students request rooms, find compatible roommates and report maintenance issues. Admins manage rooms and students and allocate rooms based on **year level**.

![PHP](https://img.shields.io/badge/PHP_8-777BB4?style=flat-square&logo=php&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square&logo=javascript&logoColor=black)
![Chart.js](https://img.shields.io/badge/Chart.js-FF6384?style=flat-square&logo=chartdotjs&logoColor=white)

## Features

**Students**
- Register and log in (passwords hashed with `password_hash`)
- A dashboard with **room recommendations for your year level**
- Request a room with a preferred building, floor and roommate
- **Roommate finder**: build a lifestyle profile (sleep schedule, study habits, cleanliness, noise level) and send roommate requests
- See your allocated room, log **maintenance requests** with a priority, and get notifications
- Edit your profile

**Admins**
- A dashboard with occupancy statistics and **Chart.js** charts
- Room management: add and edit rooms, types, capacity, status and amenities
- Student management: search, filter by year, activate and deactivate accounts
- Allocations: assign rooms, check students in and out, cancel allocations (wrapped in database transactions)

**Security**
- PDO prepared statements for every query
- Hardened sessions (HTTP-only cookies, 30-minute timeout)
- Role-based access control (`requireAdmin()`, `requireStudent()`)

## Tech stack

| Layer | Tools |
| --- | --- |
| Backend | PHP 8 with PDO |
| Database | MySQL or MariaDB |
| Frontend | HTML, CSS (animations, responsive layout, toasts), vanilla JavaScript, Chart.js, Font Awesome |

## Project structure

```
index.php                 # Landing page
auth/                     # login, register, logout, session helpers
pages/admin/              # dashboard, rooms, students, allocations
pages/student/            # dashboard, request-room, my-room, find-roommate, maintenance, notifications, profile
includes/                 # header, footer, helper functions, SVG image placeholders
config/                   # database.example.php → copy to database.php
database/                 # schema.sql + add_maintenance.sql + add_notifications.sql
assets/                   # CSS and JS
```

## Getting started

**You need:** PHP 8+ with `pdo_mysql`, and MySQL or MariaDB. XAMPP, MAMP or Laragon all work.

1. **Get the code.** Clone it into your web root (for XAMPP, that's `htdocs/`):
   ```bash
   git clone https://github.com/Dwaynemaster007/Campus-Room-Allocator.git
   ```
2. **Create the database:**
   ```bash
   mysql -u root -p -e "CREATE DATABASE campus_room_allocation CHARACTER SET utf8mb4"
   mysql -u root -p campus_room_allocation < database/schema.sql
   mysql -u root -p campus_room_allocation < database/add_maintenance.sql
   mysql -u root -p campus_room_allocation < database/add_notifications.sql
   ```
3. **Configure it:**
   ```bash
   cp config/database.example.php config/database.php   # then set DB_USER and DB_PASS
   ```
4. **Create demo accounts.** These scripts only run from the command line:
   ```bash
   php create_admin.php     # admin@campus.edu / admin123
   php create_student.php   # john.doe@student.edu / student123
   php test_connection.php  # optional connection check
   ```
5. **Run it.** Open `http://localhost/Campus-Room-Allocator/`, or start PHP's built-in server:
   ```bash
   php -S localhost:8000
   ```

> Change the demo passwords before you put this anywhere public.

## Next steps

- [ ] Add the CSRF tokens (helpers already exist in `auth/session.php`) to every form
- [ ] Make **Export Data** download CSV (`pages/admin/export.php` is currently a copy of the dashboard)
- [ ] Email notifications for allocation updates

## Author

**Thubelihle Dlamini**, [GitHub](https://github.com/Dwaynemaster007) · [LinkedIn](https://linkedin.com/in/thubelihledlamini)
