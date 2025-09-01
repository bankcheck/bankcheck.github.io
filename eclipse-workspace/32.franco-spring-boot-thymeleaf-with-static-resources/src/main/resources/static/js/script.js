document.addEventListener("DOMContentLoaded", function() {
    const messageElement = document.querySelector('h1');
    if (messageElement) {
        messageElement.textContent += ' - Page Loaded! (by JS)';
    }
});