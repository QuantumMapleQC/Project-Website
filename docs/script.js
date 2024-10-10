function displayAnnouncements() {
    if (announcements.length > 0) {
        announcementMessage.innerHTML = announcements.map((ann, index) => {
            let badges = ''; // Add badges based on username

            // Perform a case-insensitive match
            const usernameLower = ann.username.toLowerCase();
            const ownerName = 'quantummapleqc'; // Your name, case insensitive

            // Add badges based on the username
            if (usernameLower === ownerName) {
                badges += `
                    <img src="/home/fdiskzles/docs/Server_Developer.png" alt="Server Developer Badge" class="badge">
                    <img src="/home/fdiskzles/docs/pepeowner.png" alt="Owner Badge" class="badge">
                `;
            } 
            if (usernameLower === 'staff') {
                badges += `
                    <img src="/home/fdiskzles/docs/staff.png" alt="Staff Badge" class="badge">
                `;
            } 
            if (usernameLower === 'new_member') {
                badges += `
                    <img src="/home/fdiskzles/docs/new_member.png" alt="New Member Badge" class="badge">
                `;
            } 
            if (usernameLower === 'active_developer') {
                badges += `
                    <img src="/home/fdiskzles/docs/Active_Developer.png" alt="Active Developer Badge" class="badge">
                `;
            }

            return `
                <div class="announcement-entry">
                    <div class="name-badges">
                        <strong class="username ${usernameLower === ownerName ? 'dev-role' : ''}">
                            ${ann.username}
                        </strong>
                        ${badges}
                    </div>
                    <p>${ann.text}</p>
                    <small>${new Date(ann.date).toLocaleString()}</small>
                </div>
            `;
        }).join('');
    } else {
        announcementMessage.innerHTML = 'No announcements yet. Use the form above to add one!';
    }
}
