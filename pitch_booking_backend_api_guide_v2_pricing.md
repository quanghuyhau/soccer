# Pitch Booking Backend API Guide — Cập nhật logic giá sân

Tài liệu này dùng để gửi cho team App/Frontend để sửa lại logic đặt sân theo backend mới.

## Điểm thay đổi quan trọng

```text
Customer không được gửi totalPrice khi đặt sân.
Owner cấu hình giá theo từng pitch và từng khung giờ.
Backend tự tính totalPrice dựa trên pitchId + startTime + endTime.
```

Base URL qua Gateway:

```text
http://localhost:8090
```

Header auth cho các API cần đăng nhập:

```http
Authorization: Bearer <ACCESS_TOKEN>
```

Toàn bộ ID hiện tại là UUID string, không còn dạng số `1, 2, 3`.

---

# 1. Flow mới cho Customer đặt sân

```text
Login
→ GET /api/venues
→ Chọn venue
→ GET /api/venues/{venueId}/pitches
→ Chọn pitch
→ GET /api/pitches/{pitchId}/prices để xem bảng giá
→ User chọn ngày/giờ
→ App có thể tự preview giá tạm thời
→ POST /api/bookings không gửi totalPrice
→ Backend tự tính totalPrice
→ App lấy totalPrice chính thức từ response booking
```

Request tạo booking mới **không còn `totalPrice`**.

Request cũ sai:

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

Request mới đúng:

```json
{
  "pitchId": "uuid-pitch-id",
  "customerName": "Khách hàng Demo",
  "customerPhone": "0909999999",
  "startTime": "2026-07-02T18:00:00",
  "endTime": "2026-07-02T19:30:00",
  "note": "Đặt sân buổi tối"
}
```

---

# 2. Pitch Price APIs — API mới

Owner dùng nhóm API này để cấu hình bảng giá cho từng sân con/pitch.

Ví dụ một pitch có bảng giá:

| Khung giờ | Giá/giờ |
|---|---:|
| 06:00 - 17:00 | 150000 |
| 17:00 - 22:00 | 250000 |
| 22:00 - 23:00 | 300000 |

Backend dùng bảng giá này để tự tính tiền khi customer đặt sân.

---

## 2.1. Lấy bảng giá của pitch

```http
GET /api/pitches/{pitchId}/prices
```

Dùng cho:

```text
- App hiển thị bảng giá ở màn pitch detail.
- App preview giá tạm thời trước khi đặt sân.
- Owner xem danh sách khung giá đã cấu hình.
```

Curl:

```bash
curl http://localhost:8090/api/pitches/<PITCH_ID>/prices \
-H "Authorization: Bearer <ACCESS_TOKEN>"
```

Response:

```json
{
  "code": 200,
  "message": "Thành công",
  "result": [
    {
      "id": "uuid-price-id-1",
      "pitchId": "uuid-pitch-id",
      "pitchName": "Sân 5A",
      "startTime": "06:00:00",
      "endTime": "17:00:00",
      "pricePerHour": 150000
    },
    {
      "id": "uuid-price-id-2",
      "pitchId": "uuid-pitch-id",
      "pitchName": "Sân 5A",
      "startTime": "17:00:00",
      "endTime": "22:00:00",
      "pricePerHour": 250000
    }
  ]
}
```

---

## 2.2. Tạo khung giá cho pitch

```http
POST /api/pitches/{pitchId}/prices
```

Role nên dùng: `OWNER`.

Request:

```json
{
  "startTime": "06:00:00",
  "endTime": "17:00:00",
  "pricePerHour": 150000
}
```

Curl:

```bash
curl -X POST http://localhost:8090/api/pitches/<PITCH_ID>/prices \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <OWNER_ACCESS_TOKEN>" \
-d '{
  "startTime": "06:00:00",
  "endTime": "17:00:00",
  "pricePerHour": 150000
}'
```

Response:

```json
{
  "code": 200,
  "message": "Thành công",
  "result": {
    "id": "uuid-price-id",
    "pitchId": "uuid-pitch-id",
    "pitchName": "Sân 5A",
    "startTime": "06:00:00",
    "endTime": "17:00:00",
    "pricePerHour": 150000
  }
}
```

---

## 2.3. Sửa khung giá

```http
PUT /api/pitch-prices/{priceId}
```

Role nên dùng: `OWNER`.

Request:

```json
{
  "startTime": "06:00:00",
  "endTime": "17:00:00",
  "pricePerHour": 180000
}
```

Curl:

```bash
curl -X PUT http://localhost:8090/api/pitch-prices/<PRICE_ID> \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <OWNER_ACCESS_TOKEN>" \
-d '{
  "startTime": "06:00:00",
  "endTime": "17:00:00",
  "pricePerHour": 180000
}'
```

---

## 2.4. Xoá khung giá

```http
DELETE /api/pitch-prices/{priceId}
```

Role nên dùng: `OWNER`.

Curl:

```bash
curl -X DELETE http://localhost:8090/api/pitch-prices/<PRICE_ID> \
-H "Authorization: Bearer <OWNER_ACCESS_TOKEN>"
```

---

## 2.5. Rule validate bảng giá

Backend đang áp dụng rule:

```text
1. startTime phải nhỏ hơn endTime.
2. pricePerHour phải lớn hơn 0.
3. Các khung giá của cùng một pitch không được overlap.
4. Nếu booking rơi vào khoảng giờ chưa có bảng giá, backend trả lỗi.
```

Ví dụ hợp lệ:

```text
06:00 - 17:00
17:00 - 22:00
22:00 - 23:00
```

Ví dụ không hợp lệ vì overlap:

```text
06:00 - 17:00
16:00 - 22:00
```

Error overlap:

```json
{
  "code": 400,
  "message": "Khung giờ giá đã bị trùng",
  "result": null
}
```

---

# 3. Booking APIs — Logic mới

## 3.1. Tạo booking

```http
POST /api/bookings
```

Auth: cần token customer.

Request mới:

```json
{
  "pitchId": "uuid-pitch-id",
  "customerName": "Khách hàng Demo",
  "customerPhone": "0909999999",
  "startTime": "2026-07-02T18:00:00",
  "endTime": "2026-07-02T19:30:00",
  "note": "Đặt sân buổi tối"
}
```

Curl:

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
  "note": "Đặt sân buổi tối"
}'
```

Response:

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
    "venueName": "Sân App Demo",
    "startTime": "2026-07-02T18:00:00",
    "endTime": "2026-07-02T19:30:00",
    "totalPrice": 375000,
    "status": "PENDING",
    "note": "Đặt sân buổi tối"
  }
}
```

`totalPrice` trong response là giá backend tự tính, app không được tự quyết định giá cuối cùng.

---

## 3.2. Cách backend tính tiền

Ví dụ pitch có bảng giá:

```text
06:00 - 17:00: 150000 / giờ
17:00 - 22:00: 250000 / giờ
22:00 - 23:00: 300000 / giờ
```

Customer đặt:

```text
18:00 - 19:30
```

Backend tính:

```text
1.5 giờ * 250000 = 375000
```

Response trả:

```json
{
  "totalPrice": 375000
}
```

---

## 3.3. Booking cắt qua 2 khung giá

Customer đặt:

```text
16:30 - 18:30
```

Backend tính:

```text
16:30 - 17:00 = 0.5 giờ * 150000 = 75000
17:00 - 18:30 = 1.5 giờ * 250000 = 375000

Total = 450000
```

Response:

```json
{
  "totalPrice": 450000
}
```

---

## 3.4. Nếu pitch chưa có bảng giá

Nếu booking rơi vào khung giờ chưa được cấu hình giá:

```json
{
  "code": 400,
  "message": "Khung giờ đặt sân chưa được cấu hình giá",
  "result": null
}
```

App nên hiển thị:

```text
Sân này chưa có bảng giá cho khung giờ đã chọn.
```

---

## 3.5. Logic chống trùng lịch

Backend check trùng với booking có status:

```text
PENDING
CONFIRMED
```

Không tính conflict với:

```text
CANCELLED
COMPLETED
```

Công thức overlap:

```text
bookingCũ.startTime < bookingMới.endTime
AND
bookingCũ.endTime > bookingMới.startTime
```

Ví dụ đã có booking:

```text
18:00 - 19:30
```

Bị trùng:

```text
17:30 - 18:30
18:00 - 19:00
19:00 - 20:00
17:00 - 20:00
```

Không trùng:

```text
16:00 - 18:00
19:30 - 21:00
```

Error:

```json
{
  "code": 400,
  "message": "Khung giờ này đã có người đặt",
  "result": null
}
```

---

## 3.6. Các booking API còn lại

### Get all bookings

```http
GET /api/bookings
```

### Get booking detail

```http
GET /api/bookings/{bookingId}
```

### Get my bookings

```http
GET /api/bookings/me
```

### Get bookings by pitch

```http
GET /api/pitches/{pitchId}/bookings
```

### Update booking status

```http
PATCH /api/bookings/{bookingId}/status
```

Request:

```json
{
  "status": "CONFIRMED"
}
```

Status hợp lệ:

```text
PENDING
CONFIRMED
CANCELLED
COMPLETED
```

### Delete booking

```http
DELETE /api/bookings/{bookingId}
```

---

# 4. App cần sửa gì?

## 4.1. Màn tạo booking

Bỏ field `totalPrice` khỏi request tạo booking.

App không được gửi:

```json
{
  "totalPrice": 300000
}
```

App chỉ gửi:

```json
{
  "pitchId": "uuid-pitch-id",
  "customerName": "Khách hàng Demo",
  "customerPhone": "0909999999",
  "startTime": "2026-07-02T18:00:00",
  "endTime": "2026-07-02T19:30:00",
  "note": "Đặt sân buổi tối"
}
```

---

## 4.2. Màn chi tiết pitch

App nên gọi thêm:

```http
GET /api/pitches/{pitchId}/prices
```

để hiển thị bảng giá cho người dùng.

---

## 4.3. Màn owner quản lý sân

Cần thêm màn quản lý giá cho pitch:

```text
Danh sách khung giá
Tạo khung giá
Sửa khung giá
Xoá khung giá
```

API dùng:

```text
GET    /api/pitches/{pitchId}/prices
POST   /api/pitches/{pitchId}/prices
PUT    /api/pitch-prices/{priceId}
DELETE /api/pitch-prices/{priceId}
```

---

## 4.4. Màn xác nhận đặt sân

App có thể preview giá tạm thời dựa trên bảng giá đã lấy từ:

```http
GET /api/pitches/{pitchId}/prices
```

Nhưng giá cuối cùng vẫn phải lấy từ response:

```json
{
  "totalPrice": 375000
}
```

Backend là nguồn đúng cuối cùng.

---

# 5. Test nhanh flow mới

## 5.1. Tạo bảng giá cho pitch

```bash
curl -X POST http://localhost:8090/api/pitches/<PITCH_ID>/prices \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <OWNER_ACCESS_TOKEN>" \
-d '{
  "startTime": "17:00:00",
  "endTime": "22:00:00",
  "pricePerHour": 250000
}'
```

## 5.2. Tạo booking không gửi totalPrice

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
  "note": "Đặt sân buổi tối"
}'
```

Expected nếu giá 17:00-22:00 là `250000/giờ`:

```json
{
  "totalPrice": 375000
}
```

---

# 6. Kết luận cho App

Các điểm bắt buộc App cần sửa:

```text
1. Bỏ totalPrice khỏi request POST /api/bookings.
2. Thêm màn/API quản lý bảng giá pitch cho owner.
3. Khi customer vào pitch detail, gọi GET /api/pitches/{pitchId}/prices để hiển thị bảng giá.
4. Khi tạo booking, backend tự tính totalPrice.
5. totalPrice chính thức lấy từ response POST /api/bookings.
```
