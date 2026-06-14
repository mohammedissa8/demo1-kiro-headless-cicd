FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl unzip ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://cli.kiro.dev/install | bash

# API key MUST be injected at runtime via -e KIRO_API_KEY=...
# Never hardcode credentials in the image.
ENV KIRO_API_KEY=""

ENTRYPOINT ["kiro-cli", "chat", "--no-interactive"]
CMD ["--prompt", "Analyze the project and report findings"]
