document.addEventListener('DOMContentLoaded', function() {
    const app = document.getElementById('app');
    
    app.innerHTML = `
        <div class="container">
            <header>
                <h1>TechWave Solutions</h1>
                <p>Innovative Web Application</p>
            </header>
            <div class="content">
                <button onclick="loadData()">Load Data</button>
                <div id="data-container"></div>
                <div id="status"></div>
            </div>
        </div>
    `;
});

async function loadData() {
    const status = document.getElementById('status');
    const container = document.getElementById('data-container');
    
    status.innerHTML = 'Loading...';
    container.innerHTML = '';
    
    try {
        const response = await fetch('/api/data');
        const result = await response.json();
        
        let html = '<h3>Data from API:</h3><ul>';
        result.data.forEach(item => {
            html += `<li>${item.name}: ${item.value}</li>`;
        });
        html += '</ul>';
        
        container.innerHTML = html;
        status.innerHTML = 'Data loaded successfully!';
    } catch (error) {
        status.innerHTML = 'Error loading data: ' + error.message;
    }
}