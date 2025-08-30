# Social Media Downloader Backend

Node.js backend API for downloading videos and audio from social media platforms.

## Setup

1. Install dependencies:
```bash
cd backend
npm install
```

2. Install yt-dlp:
```bash
# Windows
winget install yt-dlp
# or download from https://github.com/yt-dlp/yt-dlp/releases

# macOS
brew install yt-dlp

# Linux
sudo apt install yt-dlp
```

3. Start server:
```bash
npm run dev
```

## API Endpoints

### POST /api/download
Download video/audio from URL
```json
{
  "url": "https://youtube.com/watch?v=...",
  "format": "video", // or "audio"
  "platform": "YouTube"
}
```

### POST /api/info
Get video information
```json
{
  "url": "https://youtube.com/watch?v=..."
}
```

### GET /api/health
Health check endpoint

## Supported Platforms
- YouTube
- Facebook
- Instagram
- Twitter/X
- TikTok
- And many more supported by yt-dlp