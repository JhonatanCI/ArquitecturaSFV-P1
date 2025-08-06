Write-Host "Verificando si Docker está instalado..."
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker no está instalado. Por favor instálalo antes de continuar."
    exit 1
}

Write-Host "Construyendo la imagen Docker..."
docker build -t node-app .

Write-Host "Ejecutando el contenedor..."
docker run -d -p 8080:8080 --name node-app-container -e PORT=8080 -e NODE_ENV=production node-app

Start-Sleep -Seconds 5

Write-Host "Probando si el servicio responde..."
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080" -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ El servicio está funcionando correctamente en http://localhost:8080"
        exit 0
    }
} catch {
    Write-Host "❌ Error: El servicio no respondió correctamente"
    exit 1
}
