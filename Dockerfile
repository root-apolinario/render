# Base: Ubuntu 22.04 (Jammy)
FROM ubuntu:22.04

# Variáveis para não travar instalação (apt-get não interativo)
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

# Cria usuário não-root para rodar o code-server
RUN useradd -m coder
USER coder
WORKDIR /home/coder

# Config padrão do code-server
RUN mkdir -p ~/.config/code-server \
    && echo 'bind-addr: 0.0.0.0:8080' > ~/.config/code-server/config.yaml \
    && echo 'auth: password' >> ~/.config/code-server/config.yaml \
    && echo 'password: changeme' >> ~/.config/code-server/config.yaml \
    && echo 'cert: false' >> ~/.config/code-server/config.yaml

# Porta padrão do Render (vai rodar em 8080)
EXPOSE 8080

# Inicializa com dumb-init para evitar problemas de PID/Signals
ENTRYPOINT ["dumb-init", "code-server"]
CMD ["--host", "0.0.0.0", "--port", "8080"]
