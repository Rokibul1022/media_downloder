const express = require('express');
const { exec } = require('child_process');
const app = express();
app.use(express.json());

app.post('/info', (req, res) => {
  const url = req.body.url;
  exec(`yt-dlp --dump-json ${url}`, (err, stdout) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(JSON.parse(stdout));
  });
});

app.post('/download', (req, res) => {
  const url = req.body.url;
  const format = req.body.format === 'video' ? 'mp4' : 'mp3';
  const quality = req.body.quality || 'best';
  exec(`yt-dlp -f ${quality} -o - ${url}`, (err, stdout, stderr) => {
    if (err) return res.status(500).json({ error: err.message });
    res.setHeader('Content-Type', format === 'mp4' ? 'video/mp4' : 'audio/mpeg');
    res.send(stdout);
  });
});

app.listen(3000, () => console.log('Server running on port 3000'));