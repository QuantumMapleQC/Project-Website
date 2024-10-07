const express = require('express');
const path = require('path');
const os = require('os');
const si = require('systeminformation');
const app = express();
const port = 3000;

// Serve static files from the "docs" directory
app.use(express.static(path.join(__dirname, 'docs')));

// Route to fetch the status
app.get('/status', async (req, res) => {
    try {
        const battery = await si.battery();
        const networkInterfaces = os.networkInterfaces();
        const wifiInterface = networkInterfaces.wlan0 || networkInterfaces.en0; // Adjust as needed
        const isConnected = wifiInterface && wifiInterface.some(iface => iface.family === 'IPv4' && iface.internal === false);
        
        const status = {
            online: true,
            battery: {
                percent: battery.percent,
                isCharging: battery.ischarging,
            },
            internet: isConnected
        };

        res.json(status);
    } catch (error) {
        console.error('Error fetching system information:', error);
        res.status(500).json({ online: false });
    }
});

// Start the server
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});
