# Pitch Booking Backend API Guide

Tài liệu này tổng hợp các API hiện tại của hệ thống **Pitch Booking Microservices** để frontend/mobile app có thể dựa vào đó thiết kế luồng màn hình, gọi API và hiểu nghiệp vụ.

---

## 1. Tổng quan hệ thống

Hệ thống hiện tại gồm 3 service chính:

| Service | Port direct | Vai trò |
|---|---:|---|
| `gateway-service` | `8090` | Cổng vào chính cho app/client |
| `user-service` | `8083` | Đăng ký, đăng nhập, thông tin user, role |
| `booking-service` | `8084` | Venue, Pitch, Image, Booking |

Service discovery:

| Công cụ | URL |
|---|---|
| Consul UI | `http://localhost:8500` |

Storage:

| Công cụ | URL |
|---|---|
| MinIO API | `http://localhost:9000` |
| MinIO Console | `http://localhost:9001` |

Database:

| DB | Mục đích |
|---|---|
| `pitch_user_db` | users, roles, user_roles |
| `pitch_booking_db` | venues, pitches, images, bookings |

---

## 2. Base URL cho frontend

Frontend/app nên gọi qua Gateway:

```text
http://localhost:8090
```

Không nên gọi trực tiếp:

```text
http://localhost:8083
http://localhost:8084
```

Vì sau này service có thể đổi port, scale nhiều instance, còn Gateway + Consul sẽ route giúp.

---

## 3. Format response chuẩn

Tất cả API nên trả về format:

```json
{
  "code": 200,
  "message": "Thành công",
  "result": {}
}
```

Ví dụ lỗi:

```json
{
  "code": 401,
  "message": "Chưa xác thực",
  "result": null
}
```

---

## 4. Authentication

Sau khi login thành công, backend trả về:

```json
{
  "code": 200,
  "message": "Thành công",
  "result": {
    "accessToken": "jwt-token",
    "refreshToken": "jwt-refresh-token"
  }
}
```

App cần lưu:

| Token | Cách dùng |
|---|---|
| `accessToken` | Gắn vào header để gọi API cần đăng nhập |
| `refreshToken` | Hiện tại mới trả về, chưa có API refresh-token |

Header chuẩn:

```http
Authorization: Bearer <ACCESS_TOKEN>
```

---

## 5. Role hiện tại

| Role | Ý nghĩa |
|---|---|
| `CUSTOMER` | Người dùng đặt sân |
| `OWNER` | Chủ sân, được tạo venue/pitch |
| `ADMIN` | Quản trị viên |

Hiện tại `register` mặc định tạo user role `CUSTOMER`.

Nếu muốn test user `OWNER`, gán role trong DB:

```sql
INSERT IGNORE INTO user_roles (user_id, role_id)
SELECT u.id, r.id
FROM users u
JOIN roles r
WHERE u.username = 'owner'
  AND r.code = 'OWNER';
```

---

# 6. User Service APIs

## 6.1. Register

### API

```http
POST /api/auth/register
```

### Auth

Không cần token.

### Request

```json
{
  "username": "customer",
  "password": "123456",
  "fullName": "Khách hàng Demo",
  "email": "customer@gmail.com",
  "phone": "0909999999",
  "gender": "MALE",
  "dateOfBirth": "2002-05-11",
  "address": "Hà Nội"
}
```

### Curl

```bash
curl -X POST http://localhost:8090/api/auth/register \
-H "Content-Type: application/json" \
-d '{
  "username": "customer",
  "password": "123456",
  "fullName": "Khách hàng Demo",
  "email": "customer@gmail.com",
  "phone": "0909999999",
  "gender": "MALE",
  "dateOfBirth": "2002-05-11",
  "address": "Hà Nội"
}'
```

### Response

```json
{
  "code": 200,
  "message": "Thành công",
  "result": {
    "id": "uuid-user-id",
    "username": "customer",
    "fullName": "Khách hàng Demo",
    "email": "customer@gmail.com",
    "phone": "0909999999",
    "gender": "MALE",
    "dateOfBirth": "2002-05-11",
    "address": "Hà Nội",
    "status": "ACTIVE",
    "roles": ["CUSTOMER"]
  }
}
```

---

## 6.2. Login

### API

```http
POST /api/auth/login
```

### Auth

Không cần token.

### Request

```json
{
  "username": "customer",
  "password": "123456"
}
```

### Curl

```bash
curl -X POST http://localhost:8090/api/auth/login \
-H "Content-Type: application/json" \
-d '{
  "username": "customer",
  "password": "123456"
}'
```

### Response

```json
{
  "code": 200,
  "message": "Thành công",
  "result": {
    "accessToken": "jwt-access-token",
    "refreshToken": "jwt-refresh-token"
  }
}
```

---

## 6.3. Get current user

### API

```http
GET /api/users/me
```

### Auth

Cần token.

### Curl

```bash
curl http://localhost:8090/api/users/me \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

### Response

```json
{
  "code": 200,
  "message": "Thành công",
  "result": {
    "id": "uuid-user-id",
    "username": "customer",
    "fullName": "Khách hàng Demo",
    "email": "customer@gmail.com",
    "phone": "0909999999",
    "gender": "MALE",
    "dateOfBirth": "2002-05-11",
    "address": "Hà Nội",
    "status": "ACTIVE",
    "roles": ["CUSTOMER"]
  }
}
```

---

# 7. Venue APIs

Venue là cụm sân, ví dụ: Sân bóng Mỹ Đình, Sân bóng Cầu Giấy.

## 7.1. Get all venues

### API

```http
GET /api/venues
```

### Auth

Cần token.

### Curl

```bash
curl http://localhost:8090/api/venues \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

### Response

```json
{
  "code": 200,
  "message": "Thành công",
  "result": [
    {
      "id": "uuid-venue-id",
      "ownerId": "uuid-owner-user-id",
      "code": "VENUE001",
      "name": "Sân bóng Mỹ Đình",
      "description": "Cụm sân bóng mini chất lượng cao",
      "phone": "0987654321",
      "address": "Nam Từ Liêm, Hà Nội",
      "openTime": "06:00:00",
      "closeTime": "23:00:00",
      "status": "ACTIVE"
    }
  ]
}
```

---

## 7.2. Get venue detail

```http
GET /api/venues/{venueId}
```

```bash
curl http://localhost:8090/api/venues/<VENUE_ID> \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

---

## 7.3. Get venues by owner

```http
GET /api/venues/owner/{ownerId}
```

```bash
curl http://localhost:8090/api/venues/owner/<OWNER_ID> \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

---

## 7.4. Create venue

### API

```http
POST /api/venues
```

### Auth

Cần token role `OWNER`.

### Lưu ý quan trọng

Với flow mới dùng Feign:

- App **không gửi `ownerId`**.
- Backend tự lấy user hiện tại từ token.
- `booking-service` gọi `user-service` để lấy user.
- Nếu user có role `OWNER`, backend tự set `ownerId = currentUser.id`.

### Request

```json
{
  "code": "VENUE_FEIGN_001",
  "name": "Sân Feign Demo",
  "description": "Test booking-service gọi user-service kiểm tra OWNER",
  "phone": "0987654321",
  "address": "Nam Từ Liêm, Hà Nội",
  "openTime": "06:00:00",
  "closeTime": "23:00:00"
}
```

### Curl

```bash
curl -X POST http://localhost:8090/api/venues \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <OWNER_ACCESS_TOKEN>" \
-d '{
  "code": "VENUE_FEIGN_001",
  "name": "Sân Feign Demo",
  "description": "Test booking-service gọi user-service kiểm tra OWNER",
  "phone": "0987654321",
  "address": "Nam Từ Liêm, Hà Nội",
  "openTime": "06:00:00",
  "closeTime": "23:00:00"
}'
```

### Response

```json
{
  "code": 200,
  "message": "Thành công",
  "result": {
    "id": "uuid-venue-id",
    "ownerId": "uuid-owner-user-id",
    "code": "VENUE_FEIGN_001",
    "name": "Sân Feign Demo",
    "description": "Test booking-service gọi user-service kiểm tra OWNER",
    "phone": "0987654321",
    "address": "Nam Từ Liêm, Hà Nội",
    "openTime": "06:00:00",
    "closeTime": "23:00:00",
    "status": "ACTIVE"
  }
}
```

### Error nếu user không phải OWNER

```json
{
  "code": 403,
  "message": "Tài khoản không có quyền OWNER",
  "result": null
}
```

---

## 7.5. Update venue

```http
PUT /api/venues/{venueId}
```

```json
{
  "code": "VENUE001",
  "name": "Sân bóng Mỹ Đình Updated",
  "description": "Cụm sân bóng đã cập nhật",
  "phone": "0987654321",
  "address": "Nam Từ Liêm, Hà Nội",
  "openTime": "05:30:00",
  "closeTime": "23:30:00"
}
```

```bash
curl -X PUT http://localhost:8090/api/venues/<VENUE_ID> \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <ACCESS_TOKEN>" \
-d '{
  "code": "VENUE001",
  "name": "Sân bóng Mỹ Đình Updated",
  "description": "Cụm sân bóng đã cập nhật",
  "phone": "0987654321",
  "address": "Nam Từ Liêm, Hà Nội",
  "openTime": "05:30:00",
  "closeTime": "23:30:00"
}'
```

---

## 7.6. Delete venue

```http
DELETE /api/venues/{venueId}
```

```bash
curl -X DELETE http://localhost:8090/api/venues/<VENUE_ID> \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

---

# 8. Pitch APIs

Pitch là sân con thuộc venue, ví dụ: Sân 5A, Sân 7A.

## 8.1. Get all pitches

```http
GET /api/pitches
```

```bash
curl http://localhost:8090/api/pitches \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

---

## 8.2. Get pitch detail

```http
GET /api/pitches/{pitchId}
```

```bash
curl http://localhost:8090/api/pitches/<PITCH_ID> \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

---

## 8.3. Get pitches by venue

```http
GET /api/venues/{venueId}/pitches
```

```bash
curl http://localhost:8090/api/venues/<VENUE_ID>/pitches \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

---

## 8.4. Create pitch

```http
POST /api/venues/{venueId}/pitches
```

```json
{
  "code": "PITCH001",
  "name": "Sân 5A",
  "description": "Sân bóng 5 người",
  "type": "FIVE",
  "size": "20x40m",
  "surface": "Cỏ nhân tạo"
}
```

```bash
curl -X POST http://localhost:8090/api/venues/<VENUE_ID>/pitches \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <ACCESS_TOKEN>" \
-d '{
  "code": "PITCH001",
  "name": "Sân 5A",
  "description": "Sân bóng 5 người",
  "type": "FIVE",
  "size": "20x40m",
  "surface": "Cỏ nhân tạo"
}'
```

### Response

```json
{
  "code": 200,
  "message": "Thành công",
  "result": {
    "id": "uuid-pitch-id",
    "venueId": "uuid-venue-id",
    "venueName": "Sân bóng Mỹ Đình",
    "code": "PITCH001",
    "name": "Sân 5A",
    "description": "Sân bóng 5 người",
    "type": "FIVE",
    "size": "20x40m",
    "surface": "Cỏ nhân tạo",
    "status": "ACTIVE"
  }
}
```

---

## 8.5. Update pitch

```http
PUT /api/pitches/{pitchId}
```

```bash
curl -X PUT http://localhost:8090/api/pitches/<PITCH_ID> \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <ACCESS_TOKEN>" \
-d '{
  "code": "PITCH001",
  "name": "Sân 5A Updated",
  "description": "Sân bóng 5 người đã cập nhật",
  "type": "FIVE",
  "size": "22x42m",
  "surface": "Cỏ nhân tạo cao cấp"
}'
```

---

## 8.6. Delete pitch

```http
DELETE /api/pitches/{pitchId}
```

```bash
curl -X DELETE http://localhost:8090/api/pitches/<PITCH_ID> \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

---

# 9. Image APIs

Ảnh được lưu trên MinIO, metadata lưu trong DB.

Entity type hiện tại:

| entityType | Ý nghĩa |
|---|---|
| `VENUE` | Ảnh của cụm sân |
| `PITCH` | Ảnh của sân con |

---

## 9.1. Upload venue image

```http
POST /api/venues/{venueId}/images
```

Content-Type:

```http
multipart/form-data
```

```bash
curl -X POST http://localhost:8090/api/venues/<VENUE_ID>/images \
-H "Authorization: Bearer <ACCESS_TOKEN>" \
-F "file=@/Users/atomi/Desktop/image.jpg"
```

### Response

```json
{
  "code": 200,
  "message": "Thành công",
  "result": {
    "id": "uuid-image-id",
    "entityType": "VENUE",
    "entityId": "uuid-venue-id",
    "originalFileName": "image.jpg",
    "objectName": "venues/uuid-venue-id/uuid.jpg",
    "url": "http://localhost:9000/pitch-booking/venues/uuid-venue-id/uuid.jpg",
    "contentType": "image/jpeg",
    "size": 123456,
    "isPrimary": true
  }
}
```

---

## 9.2. Upload pitch image

```http
POST /api/pitches/{pitchId}/images
```

```bash
curl -X POST http://localhost:8090/api/pitches/<PITCH_ID>/images \
-H "Authorization: Bearer <ACCESS_TOKEN>" \
-F "file=@/Users/atomi/Desktop/image.jpg"
```

---

## 9.3. List images by entity

```http
GET /api/images?entityType={entityType}&entityId={entityId}
```

```bash
curl "http://localhost:8090/api/images?entityType=VENUE&entityId=<VENUE_ID>" \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

```bash
curl "http://localhost:8090/api/images?entityType=PITCH&entityId=<PITCH_ID>" \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

---

# 10. Booking APIs

Booking là lịch đặt sân.

Trạng thái booking:

| Status | Ý nghĩa |
|---|---|
| `PENDING` | Chờ xác nhận |
| `CONFIRMED` | Đã xác nhận |
| `CANCELLED` | Đã huỷ |
| `COMPLETED` | Đã hoàn tất |

Logic chống trùng lịch hiện tại:

- Cùng một pitch.
- Khoảng thời gian mới bị giao với booking cũ.
- Chỉ check conflict với booking status `PENDING` và `CONFIRMED`.
- Booking `CANCELLED` không tính là conflict.

---

## 10.1. Create booking

```http
POST /api/bookings
```

```json
{
  "pitchId": "uuid-pitch-id",
  "customerName": "Khách hàng Demo",
  "customerPhone": "0909999999",
  "startTime": "2026-07-02T18:00:00",
  "endTime": "2026-07-02T19:30:00",
  "totalPrice": 300000,
  "note": "Đặt sân buổi tối"
}
```

```bash
curl -X POST http://localhost:8090/api/bookings \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <ACCESS_TOKEN>" \
-d '{
  "pitchId": "<PITCH_ID>",
  "customerName": "Khách hàng Demo",
  "customerPhone": "0909999999",
  "startTime": "2026-07-02T18:00:00",
  "endTime": "2026-07-02T19:30:00",
  "totalPrice": 300000,
  "note": "Đặt sân buổi tối"
}'
```

### Response

```json
{
  "code": 200,
  "message": "Thành công",
  "result": {
    "id": "uuid-booking-id",
    "customerUsername": "customer",
    "customerName": "Khách hàng Demo",
    "customerPhone": "0909999999",
    "pitchId": "uuid-pitch-id",
    "pitchName": "Sân 5A",
    "venueId": "uuid-venue-id",
    "venueName": "Sân bóng Mỹ Đình",
    "startTime": "2026-07-02T18:00:00",
    "endTime": "2026-07-02T19:30:00",
    "totalPrice": 300000,
    "status": "PENDING",
    "note": "Đặt sân buổi tối"
  }
}
```

---

## 10.2. Test conflict booking

Nếu gọi lại cùng pitch và cùng giờ:

```json
{
  "pitchId": "uuid-pitch-id",
  "startTime": "2026-07-02T18:00:00",
  "endTime": "2026-07-02T19:30:00"
}
```

Response đúng:

```json
{
  "code": 400,
  "message": "Khung giờ này đã có người đặt",
  "result": null
}
```

---

## 10.3. Get all bookings

```http
GET /api/bookings
```

```bash
curl http://localhost:8090/api/bookings \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

---

## 10.4. Get booking detail

```http
GET /api/bookings/{bookingId}
```

```bash
curl http://localhost:8090/api/bookings/<BOOKING_ID> \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

---

## 10.5. Get my bookings

```http
GET /api/bookings/me
```

```bash
curl http://localhost:8090/api/bookings/me \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

---

## 10.6. Get bookings by pitch

```http
GET /api/pitches/{pitchId}/bookings
```

```bash
curl http://localhost:8090/api/pitches/<PITCH_ID>/bookings \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

---

## 10.7. Update booking status

```http
PATCH /api/bookings/{bookingId}/status
```

```json
{
  "status": "CONFIRMED"
}
```

```bash
curl -X PATCH http://localhost:8090/api/bookings/<BOOKING_ID>/status \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <ACCESS_TOKEN>" \
-d '{
  "status": "CONFIRMED"
}'
```

Các status hợp lệ:

```text
PENDING
CONFIRMED
CANCELLED
COMPLETED
```

---

## 10.8. Delete booking

```http
DELETE /api/bookings/{bookingId}
```

```bash
curl -X DELETE http://localhost:8090/api/bookings/<BOOKING_ID> \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

---

# 11. Flow gợi ý cho app/mobile

## 11.1. Flow đăng nhập

```text
Màn Login
→ POST /api/auth/login
→ Lưu accessToken
→ GET /api/users/me
→ Lưu user profile + roles
```

---

## 11.2. Flow customer đặt sân

```text
Home
→ GET /api/venues
→ Chọn venue
→ GET /api/venues/{venueId}/pitches
→ Chọn pitch
→ GET /api/pitches/{pitchId}/bookings để xem lịch
→ POST /api/bookings
→ Nếu thành công hiển thị booking detail
```

---

## 11.3. Flow owner quản lý sân

```text
Login bằng user role OWNER
→ GET /api/users/me
→ Nếu roles chứa OWNER thì hiển thị tab Owner
→ POST /api/venues
→ POST /api/venues/{venueId}/pitches
→ POST /api/venues/{venueId}/images
→ POST /api/pitches/{pitchId}/images
→ GET /api/bookings
→ PATCH /api/bookings/{bookingId}/status
```

---

## 11.4. Flow ảnh

```text
Venue detail
→ GET /api/images?entityType=VENUE&entityId={venueId}

Pitch detail
→ GET /api/images?entityType=PITCH&entityId={pitchId}
```

URL ảnh trả về có thể dùng trực tiếp trong app:

```text
http://localhost:9000/pitch-booking/...
```

Nếu chạy trên điện thoại thật, cần đổi `localhost` thành IP máy tính hoặc domain server.

---

# 12. Màn hình app gợi ý

## Customer app

| Màn | API chính |
|---|---|
| Login | `POST /api/auth/login` |
| Register | `POST /api/auth/register` |
| Profile | `GET /api/users/me` |
| Home venue list | `GET /api/venues` |
| Venue detail | `GET /api/venues/{venueId}`, `GET /api/images?...` |
| Pitch list | `GET /api/venues/{venueId}/pitches` |
| Pitch detail | `GET /api/pitches/{pitchId}`, `GET /api/images?...` |
| Booking create | `POST /api/bookings` |
| My bookings | `GET /api/bookings/me` |
| Booking detail | `GET /api/bookings/{bookingId}` |

## Owner app/admin area

| Màn | API chính |
|---|---|
| Owner dashboard | `GET /api/venues/owner/{ownerId}` |
| Create venue | `POST /api/venues` |
| Edit venue | `PUT /api/venues/{venueId}` |
| Upload venue image | `POST /api/venues/{venueId}/images` |
| Create pitch | `POST /api/venues/{venueId}/pitches` |
| Edit pitch | `PUT /api/pitches/{pitchId}` |
| Upload pitch image | `POST /api/pitches/{pitchId}/images` |
| Manage bookings | `GET /api/bookings` |
| Confirm/cancel booking | `PATCH /api/bookings/{bookingId}/status` |

---

# 13. Lưu ý khi frontend gọi API

## 13.1. Token

Mọi API trừ `register` và `login` đều cần:

```http
Authorization: Bearer <ACCESS_TOKEN>
```

## 13.2. UUID string

ID hiện tại là chuỗi UUID, không còn số `1,2,3`.

Ví dụ:

```text
f93b07c4-3852-4d06-b699-3a9c0ab99542
```

Frontend phải khai báo id kiểu `String`.

## 13.3. Date time

Booking dùng ISO LocalDateTime:

```text
2026-07-02T18:00:00
```

Không gửi dạng:

```text
02/07/2026 18:00
```

## 13.4. Multipart upload ảnh

Upload ảnh dùng `multipart/form-data`, field name là:

```text
file
```

## 13.5. App chạy trên điện thoại thật

Nếu app mobile chạy trên emulator/device thật, không dùng được `localhost` theo cách bình thường.

Ví dụ backend chạy trên máy Mac IP:

```text
192.168.1.10
```

Base URL app nên là:

```text
http://192.168.1.10:8090
```

MinIO image URL cũng cần đổi nếu app không mở được ảnh từ `localhost`.

---

# 14. Test nhanh toàn bộ flow

## 14.1. Login

```bash
curl -X POST http://localhost:8090/api/auth/login \
-H "Content-Type: application/json" \
-d '{
  "username": "owner",
  "password": "123456"
}'
```

## 14.2. Create venue

```bash
curl -X POST http://localhost:8090/api/venues \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <OWNER_ACCESS_TOKEN>" \
-d '{
  "code": "VENUE_APP_001",
  "name": "Sân App Demo",
  "description": "Venue để test app",
  "phone": "0987654321",
  "address": "Hà Nội",
  "openTime": "06:00:00",
  "closeTime": "23:00:00"
}'
```

## 14.3. Create pitch

```bash
curl -X POST http://localhost:8090/api/venues/<VENUE_ID>/pitches \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <OWNER_ACCESS_TOKEN>" \
-d '{
  "code": "PITCH_APP_001",
  "name": "Sân 5A",
  "description": "Sân bóng 5 người",
  "type": "FIVE",
  "size": "20x40m",
  "surface": "Cỏ nhân tạo"
}'
```

## 14.4. Create booking

```bash
curl -X POST http://localhost:8090/api/bookings \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <CUSTOMER_ACCESS_TOKEN>" \
-d '{
  "pitchId": "<PITCH_ID>",
  "customerName": "Khách hàng Demo",
  "customerPhone": "0909999999",
  "startTime": "2026-07-02T18:00:00",
  "endTime": "2026-07-02T19:30:00",
  "totalPrice": 300000,
  "note": "Đặt sân buổi tối"
}'
```

---

# 15. Các API nên làm tiếp sau này

Hiện tại backend đã đủ nền để làm app cơ bản. Sau này nên bổ sung:

| API | Lý do |
|---|---|
| `GET /api/venues/search` | Tìm sân theo tên/địa chỉ |
| `GET /api/pitches/available` | Check sân trống theo ngày/giờ |
| `POST /api/payments` | Thanh toán |
| `GET /api/owners/me/venues` | Owner xem sân của mình tiện hơn |
| `GET /api/owners/me/bookings` | Owner xem booking thuộc sân của mình |
| `PATCH /api/bookings/{id}/cancel` | Huỷ booking theo hành động rõ ràng |
| `POST /api/auth/refresh-token` | Làm mới access token |
| `POST /api/auth/logout` | Đăng xuất/invalidate token |
| `GET /api/venues/{id}/detail` | Trả venue + pitches + images trong một API |

---

## 16. Kết luận cho app

Frontend/mobile app nên bắt đầu từ các flow:

```text
Login/Register
→ Home danh sách cụm sân
→ Chi tiết cụm sân
→ Danh sách sân con
→ Tạo booking
→ Lịch sử booking của tôi
```

Owner flow:

```text
Login owner
→ Tạo venue
→ Tạo pitch
→ Upload ảnh
→ Xác nhận booking
```

Base URL:

```text
http://localhost:8090
```

Auth header:

```text
Authorization: Bearer <ACCESS_TOKEN>
```
