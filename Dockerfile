# Base: Ubuntu 22.04
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Atualiza pacotes e instala dependências
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    ca-certificates \
    dumb-init \
    git \
    nano \
    unzip \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Instala o code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Config padrão do code-server
RUN mkdir -p /root/.config/code-server \
    && echo 'bind-addr: 0.0.0.0:8080' > /root/.config/code-server/config.yaml \
    && echo 'auth: password' >> /root/.config/code-server/config.yaml \
    && echo 'password: changeme' >> /root/.config/code-server/config.yaml \
    && echo 'cert: false' >> /root/.config/code-server/config.yaml

# Porta padrão (Render expõe automaticamente)
EXPOSE 8080

# Inicializa com dumb-init
ENTRYPOINT ["dumb-init", "code-server"]
CMD ["--host", "0.0.0.0", "--port", "8080"]
