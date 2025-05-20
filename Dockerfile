# Verwende ein Debian-basiertes Image für bessere Kompatibilität
FROM node:20-slim

ARG N8N_VERSION
ARG PUPPETEER_VERSION
# Korrigierte Paketnamen für Debian
ARG PUPPETEER_DEPS="chromium libnss3 libfreetype6 libharfbuzz0b fonts-freefont-ttf ca-certificates yarn libstdc++6 bash tini libx11-6 libxcursor1 libxrandr2 libxinerama1 libxcomposite1 libxdamage1 libxext6 libdrm2 libgl1 libatk-bridge2.0-0 libgtk-3-0 libasound2"

# Installiere Abhängigkeiten
RUN apt-get update && apt-get install -y --no-install-recommends ${PUPPETEER_DEPS} && rm -rf /var/lib/apt/lists/*

# Installiere n8n und Puppeteer
RUN npm install -g --omit=dev n8n@${N8N_VERSION} \
    && npm install -g puppeteer-core@${PUPPETEER_VERSION} cheerio n8n-workflow

# Konfiguriere Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Einrichten des Benutzers und Verzeichnisse
RUN mkdir -p /home/node/.n8n && chown node:node /home/node/.n8n
USER node

# Starte n8n mit Tini
ENTRYPOINT ["/usr/bin/tini", "--", "n8n"]