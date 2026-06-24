# 🚀 Deploy Lavalink lên Render.com

## Cấu trúc folder cần tách ra (repo riêng)

```
lavalink-render/          ← tên repo GitHub mới
├── Dockerfile
├── application.yml
└── .gitignore
```

> **Không cần** `start.bat`, `Lavalink.jar` (Dockerfile tự tải), hay `logs/`, `plugins/`

---

## Bước 1 — Tạo GitHub repo mới

```bash
# Copy 3 file cần thiết sang thư mục mới
# Sau đó:
git init
git add Dockerfile application.yml .gitignore
git commit -m "feat: Lavalink v4 for Render deployment"
git remote add origin https://github.com/YOUR_USERNAME/lavalink-render.git
git push -u origin main
```

---

## Bước 2 — Tạo Web Service trên Render

1. Vào [render.com](https://render.com) → **New → Web Service**
2. Chọn **Connect GitHub** → chọn repo `lavalink-render`
3. Cấu hình:

| Trường | Giá trị |
|--------|---------|
| **Name** | `lavalink-bot` (tùy đặt) |
| **Region** | Singapore (gần VN nhất) |
| **Branch** | `main` |
| **Runtime** | `Docker` ← quan trọng |
| **Instance Type** | `Free` (hoặc Starter $7/tháng nếu cần ổn định) |

4. **Build Command**: để trống (Dockerfile tự xử lý)
5. **Start Command**: để trống (CMD trong Dockerfile)

---

## Bước 3 — Cài Environment Variables trên Render

Vào tab **Environment** của service, thêm các biến sau:

| Key | Value | Ghi chú |
|-----|-------|---------|
| `SERVER_PORT` | `10000` | Render free dùng port 10000 |
| `LAVALINK_PASSWORD` | `your-strong-password` | Đặt password mạnh |
| `SPOTIFY_CLIENT_ID` | `your_spotify_id` | Nếu muốn Spotify |
| `SPOTIFY_CLIENT_SECRET` | `your_spotify_secret` | Nếu muốn Spotify |

> ⚠️ **Quan trọng**: Render Free inject `PORT=10000`. Dockerfile dùng `SERVER_PORT` nên bạn cần set `SERVER_PORT=10000` thủ công.

---

## Bước 4 — Deploy và lấy domain

1. Click **Deploy Web Service**
2. Chờ khoảng **3–5 phút** (tải Lavalink.jar ~100MB + plugins)
3. Khi thấy `✅ Live` → copy domain dạng:
   ```
   https://lavalink-bot.onrender.com
   ```

---

## Bước 5 — Cập nhật .env của bot

```env
# Lavalink trên Render
LAVALINK_HOST="lavalink-bot.onrender.com"   ← bỏ https://
LAVALINK_PORT="443"
LAVALINK_PASSWORD="your-strong-password"    ← khớp với Render env var
LAVALINK_SECURE="true"                      ← PHẢI là true
```

---

## ⚠️ Lưu ý quan trọng với Render Free

| Vấn đề | Giải pháp |
|--------|-----------|
| **Sleep sau 15 phút không dùng** | Dùng [UptimeRobot](https://uptimerobot.com) ping `/version` mỗi 5 phút |
| **Cold start ~30s** | Bot cần retry logic (shoukaku đã có sẵn) |
| **750 giờ/tháng free** | Đủ cho 1 service chạy liên tục |
| **RAM 512MB** | Dockerfile đã giới hạn `-Xmx400m` |

### UptimeRobot setup (giữ Lavalink không sleep)
- URL monitor: `https://lavalink-bot.onrender.com/version`
- Interval: 5 phút
- Lavalink sẽ trả về JSON version info → UptimeRobot nhận 200 OK

---

## Kiểm tra Lavalink đang chạy

Truy cập browser:
```
https://lavalink-bot.onrender.com/version
```

Kết quả mong đợi:
```json
{
  "semver": "4.0.8",
  "major": 4,
  ...
}
```
