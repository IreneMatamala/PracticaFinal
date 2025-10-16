fetch('/api/')
  .then(r => r.json())
  .then(d => document.getElementById('app').innerText = JSON.stringify(d));
